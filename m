Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2B142E46F
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 00:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbhJNWyA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 18:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhJNWyA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 18:54:00 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C5A9C061570;
        Thu, 14 Oct 2021 15:51:54 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634251911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FLoVNNtNPo6mitkB/AzeAHhgIos4G1PL9ZbWqs9uwB4=;
        b=M2Qb+coA4tC6FDgliQJrP+id0TrTKs+XwCG38q94p9mGBfglKhGxLap28KS70GNdgUBLKc
        39K9StYGC/2aAiw6dp2tPwIH7mFgPfjC1Qui0z/LY03MRxm1SeA3kD0svdPjrcTtuY8sl3
        CK2OUKd6pna60Wu8oxCissnfBM01Epc1wIOrL3L7L2NKwMydGfbMqA3F9VMBnrl5yZEAVF
        wRPDJRNBn8lj/MK5RiVIzfQeBflNZEzsnTwmCQlmiVDBFKU9KFGcpC7A2gg05u0iOKtDRe
        Mk8Xda2y8HLDlLV0piTm/JXfFSrTL9HHLFEeeAt34MI32q0dXpPuB0FZQAVuJw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634251911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FLoVNNtNPo6mitkB/AzeAHhgIos4G1PL9ZbWqs9uwB4=;
        b=8O8sCvM5P2b942gVQkyqux5BTAhLHulOLRPnLQjT/Veg+nhYgMLVRdezjKI8uWNuSeJ36K
        Kc3y3lsvnbXKwtCg==
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch V2 21/21] x86/fpu/signal: Use fpstate for size and features
In-Reply-To: <20211013145323.285696382@linutronix.de>
References: <20211013142847.120153383@linutronix.de>
 <20211013145323.285696382@linutronix.de>
Date:   Fri, 15 Oct 2021 00:51:51 +0200
Message-ID: <87ilxz5iew.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For dynamically enabled features it's required to get the features which
are enabled for that context when restoring from sigframe.

The same applies for all signal frame size calculations.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
V2: Added a missing conversion and folded back a conversion which
    was hidden in part 3
---
 arch/x86/kernel/fpu/signal.c |   44 ++++++++++++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 17 deletions(-)

--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -41,7 +41,7 @@ static inline bool check_xstate_in_sigfr
 	/* Check for the first magic field and other error scenarios. */
 	if (fx_sw->magic1 != FP_XSTATE_MAGIC1 ||
 	    fx_sw->xstate_size < min_xstate_size ||
-	    fx_sw->xstate_size > fpu_user_xstate_size ||
+	    fx_sw->xstate_size > current->thread.fpu.fpstate->user_size ||
 	    fx_sw->xstate_size > fx_sw->extended_size)
 		goto setfx;
 
@@ -98,7 +98,8 @@ static inline bool save_fsave_header(str
 	return true;
 }
 
-static inline bool save_xstate_epilog(void __user *buf, int ia32_frame)
+static inline bool save_xstate_epilog(void __user *buf, int ia32_frame,
+				      unsigned int usize)
 {
 	struct xregs_state __user *x = buf;
 	struct _fpx_sw_bytes *sw_bytes;
@@ -113,7 +114,7 @@ static inline bool save_xstate_epilog(vo
 		return !err;
 
 	err |= __put_user(FP_XSTATE_MAGIC2,
-			  (__u32 __user *)(buf + fpu_user_xstate_size));
+			  (__u32 __user *)(buf + usize));
 
 	/*
 	 * Read the xfeatures which we copied (directly from the cpu or
@@ -171,6 +172,7 @@ static inline int copy_fpregs_to_sigfram
 bool copy_fpstate_to_sigframe(void __user *buf, void __user *buf_fx, int size)
 {
 	struct task_struct *tsk = current;
+	struct fpstate *fpstate = tsk->thread.fpu.fpstate;
 	int ia32_fxstate = (buf != buf_fx);
 	int ret;
 
@@ -215,7 +217,7 @@ bool copy_fpstate_to_sigframe(void __use
 	fpregs_unlock();
 
 	if (ret) {
-		if (!__clear_user(buf_fx, fpu_user_xstate_size))
+		if (!__clear_user(buf_fx, fpstate->user_size))
 			goto retry;
 		return false;
 	}
@@ -224,17 +226,18 @@ bool copy_fpstate_to_sigframe(void __use
 	if ((ia32_fxstate || !use_fxsr()) && !save_fsave_header(tsk, buf))
 		return false;
 
-	if (use_fxsr() && !save_xstate_epilog(buf_fx, ia32_fxstate))
+	if (use_fxsr() &&
+	    !save_xstate_epilog(buf_fx, ia32_fxstate, fpstate->user_size))
 		return false;
 
 	return true;
 }
 
-static int __restore_fpregs_from_user(void __user *buf, u64 xrestore,
-				      bool fx_only)
+static int __restore_fpregs_from_user(void __user *buf, u64 ufeatures,
+				      u64 xrestore, bool fx_only)
 {
 	if (use_xsave()) {
-		u64 init_bv = xfeatures_mask_uabi() & ~xrestore;
+		u64 init_bv = ufeatures & ~xrestore;
 		int ret;
 
 		if (likely(!fx_only))
@@ -265,7 +268,8 @@ static bool restore_fpregs_from_user(voi
 retry:
 	fpregs_lock();
 	pagefault_disable();
-	ret = __restore_fpregs_from_user(buf, xrestore, fx_only);
+	ret = __restore_fpregs_from_user(buf, fpu->fpstate->user_xfeatures,
+					 xrestore, fx_only);
 	pagefault_enable();
 
 	if (unlikely(ret)) {
@@ -332,7 +336,7 @@ static bool __fpu_restore_sig(void __use
 		user_xfeatures = fx_sw_user.xfeatures;
 	} else {
 		user_xfeatures = XFEATURE_MASK_FPSSE;
-		state_size = fpu->fpstate->size;
+		state_size = fpu->fpstate->user_size;
 	}
 
 	if (likely(!ia32_fxstate)) {
@@ -425,10 +429,11 @@ static bool __fpu_restore_sig(void __use
 	return success;
 }
 
-static inline int xstate_sigframe_size(void)
+static inline unsigned int xstate_sigframe_size(struct fpstate *fpstate)
 {
-	return use_xsave() ? fpu_user_xstate_size + FP_XSTATE_MAGIC2_SIZE :
-			fpu_user_xstate_size;
+	unsigned int size = fpstate->user_size;
+
+	return use_xsave() ? size + FP_XSTATE_MAGIC2_SIZE : size;
 }
 
 /*
@@ -436,17 +441,19 @@ static inline int xstate_sigframe_size(v
  */
 bool fpu__restore_sig(void __user *buf, int ia32_frame)
 {
-	unsigned int size = xstate_sigframe_size();
 	struct fpu *fpu = &current->thread.fpu;
 	void __user *buf_fx = buf;
 	bool ia32_fxstate = false;
 	bool success = false;
+	unsigned int size;
 
 	if (unlikely(!buf)) {
 		fpu__clear_user_states(fpu);
 		return true;
 	}
 
+	size = xstate_sigframe_size(fpu->fpstate);
+
 	ia32_frame &= (IS_ENABLED(CONFIG_X86_32) ||
 		       IS_ENABLED(CONFIG_IA32_EMULATION));
 
@@ -481,7 +488,7 @@ unsigned long
 fpu__alloc_mathframe(unsigned long sp, int ia32_frame,
 		     unsigned long *buf_fx, unsigned long *size)
 {
-	unsigned long frame_size = xstate_sigframe_size();
+	unsigned long frame_size = xstate_sigframe_size(current->thread.fpu.fpstate);
 
 	*buf_fx = sp = round_down(sp - frame_size, 64);
 	if (ia32_frame && use_fxsr()) {
@@ -494,9 +501,12 @@ fpu__alloc_mathframe(unsigned long sp, i
 	return sp;
 }
 
-unsigned long fpu__get_fpstate_size(void)
+unsigned long __init fpu__get_fpstate_size(void)
 {
-	unsigned long ret = xstate_sigframe_size();
+	unsigned long ret = fpu_user_xstate_size;
+
+	if (use_xsave())
+		ret += FP_XSTATE_MAGIC2_SIZE;
 
 	/*
 	 * This space is needed on (most) 32-bit kernels, or when a 32-bit
