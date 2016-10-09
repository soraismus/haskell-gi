module Data.GI.Base.GParamSpec
    ( noGParamSpec

    , wrapGParamSpecPtr
    , newGParamSpecFromPtr
    , unrefGParamSpec
    , disownGParamSpec
    ) where

import Foreign.Ptr
import Control.Monad (void)

import Data.GI.Base.ManagedPtr (newManagedPtr', withManagedPtr, disownManagedPtr)
import Data.GI.Base.BasicTypes (GParamSpec(..))

#include <glib-object.h>

noGParamSpec :: Maybe GParamSpec
noGParamSpec = Nothing

foreign import ccall "g_param_spec_ref_sink" g_param_spec_ref_sink ::
    Ptr GParamSpec -> IO (Ptr GParamSpec)
foreign import ccall "g_param_spec_ref" g_param_spec_ref ::
    Ptr GParamSpec -> IO (Ptr GParamSpec)
foreign import ccall "g_param_spec_unref" g_param_spec_unref ::
    Ptr GParamSpec -> IO ()
foreign import ccall "&g_param_spec_unref" ptr_to_g_param_spec_unref ::
    FunPtr (Ptr GParamSpec -> IO ())

-- | Take ownership of a ParamSpec passed in 'Ptr'.
wrapGParamSpecPtr :: Ptr GParamSpec -> IO GParamSpec
wrapGParamSpecPtr ptr = do
  void $ g_param_spec_ref_sink ptr
  fPtr <- newManagedPtr' ptr_to_g_param_spec_unref ptr
  return $! GParamSpec fPtr

-- | Construct a Haskell wrapper for the given 'GParamSpec', without
-- assuming ownership.
newGParamSpecFromPtr :: Ptr GParamSpec -> IO GParamSpec
newGParamSpecFromPtr ptr = do
  fPtr <- g_param_spec_ref ptr >>= newManagedPtr' ptr_to_g_param_spec_unref
  return $! GParamSpec fPtr

-- | Remove a reference to the given 'GParamSpec'.
unrefGParamSpec :: GParamSpec -> IO ()
unrefGParamSpec ps = withManagedPtr ps g_param_spec_unref

-- | Disown a `GParamSpec`, i.e. do not longer unref the associated
-- foreign `GParamSpec` when the Haskell `GParamSpec` gets garbage
-- collected.
disownGParamSpec :: GParamSpec -> IO (Ptr GParamSpec)
disownGParamSpec = disownManagedPtr
