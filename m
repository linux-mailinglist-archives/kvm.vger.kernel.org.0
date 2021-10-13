Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 628FD42C423
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238237AbhJMO5z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 10:57:55 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35396 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237901AbhJMO5m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 10:57:42 -0400
Message-ID: <20211013145322.607370221@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634136938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=sQvge6nvkxgIxHV6g/oETXfh3Z7hm1cWjkiPqF5szUA=;
        b=mpGqsjyUBSR9Q2xfpRVhSGZV3Cc9sYys2DxwD2F3pUM8iqE2GnZ747iQc991zc5OnmsZkA
        +75n2hXA5B9sqKoVJtpopTU7SAgr1mqjoCivJgWGDXJOBuFx2LMubGWq0pAhitrPsu//7y
        17V4mY6uW5fr2nnBrOrFxLhhfROsmciy0Yq4N3vuYRiZW6AWVPB11lPH9xslluvByX8f3Z
        5qC8LyYOwSMNxrNzPcJQfIqmVVz76jigGokNJmFUVrztPMcbT6jj7+LvJxoPTEylUXkXib
        jLL0Bz+He/P8ILPcpRBdkBFQo82VzX7MbVa3F0JJVxhhRxiyQ0mgR64bfdQo4Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634136938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=sQvge6nvkxgIxHV6g/oETXfh3Z7hm1cWjkiPqF5szUA=;
        b=5mrALv29LVjQ7oKwG/HhJOk/ULwnRimjmbsv7GayuG8LGiFkU5B+16iitVnE6yx0PXPY9o
        fe7Sk6enBRSnSIBg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 08/21] x86/fpu/signal: Convert to fpstate
References: <20211013142847.120153383@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 13 Oct 2021 16:55:37 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert signal related code to the new register storage mechanism in
preparation for dynamically sized buffers.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/fpu/signal.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -72,13 +72,13 @@ static inline bool check_xstate_in_sigfr
 static inline bool save_fsave_header(struct task_struct *tsk, void __user *buf)
 {
 	if (use_fxsr()) {
-		struct xregs_state *xsave = &tsk->thread.fpu.state.xsave;
+		struct xregs_state *xsave = &tsk->thread.fpu.fpstate->regs.xsave;
 		struct user_i387_ia32_struct env;
 		struct _fpstate_32 __user *fp = buf;
 
 		fpregs_lock();
 		if (!test_thread_flag(TIF_NEED_FPU_LOAD))
-			fxsave(&tsk->thread.fpu.state.fxsave);
+			fxsave(&tsk->thread.fpu.fpstate->regs.fxsave);
 		fpregs_unlock();
 
 		convert_from_fxsr(&env, tsk);
@@ -303,7 +303,7 @@ static bool restore_fpregs_from_user(voi
 	 * been restored from a user buffer directly.
 	 */
 	if (test_thread_flag(TIF_NEED_FPU_LOAD) && xfeatures_mask_supervisor())
-		os_xrstor(&fpu->state.xsave, xfeatures_mask_supervisor());
+		os_xrstor(&fpu->fpstate->regs.xsave, xfeatures_mask_supervisor());
 
 	fpregs_mark_activate();
 	fpregs_unlock();
@@ -317,6 +317,7 @@ static bool __fpu_restore_sig(void __use
 	struct task_struct *tsk = current;
 	struct fpu *fpu = &tsk->thread.fpu;
 	struct user_i387_ia32_struct env;
+	union fpregs_state *fpregs;
 	u64 user_xfeatures = 0;
 	bool fx_only = false;
 	bool success;
@@ -349,6 +350,7 @@ static bool __fpu_restore_sig(void __use
 	if (__copy_from_user(&env, buf, sizeof(env)))
 		return false;
 
+	fpregs = &fpu->fpstate->regs;
 	/*
 	 * By setting TIF_NEED_FPU_LOAD it is ensured that our xstate is
 	 * not modified on context switch and that the xstate is considered
@@ -366,7 +368,7 @@ static bool __fpu_restore_sig(void __use
 		 * the right place in memory. It's ia32 mode. Shrug.
 		 */
 		if (xfeatures_mask_supervisor())
-			os_xsave(&fpu->state.xsave);
+			os_xsave(&fpregs->xsave);
 		set_thread_flag(TIF_NEED_FPU_LOAD);
 	}
 	__fpu_invalidate_fpregs_state(fpu);
@@ -374,29 +376,29 @@ static bool __fpu_restore_sig(void __use
 	fpregs_unlock();
 
 	if (use_xsave() && !fx_only) {
-		if (copy_sigframe_from_user_to_xstate(&fpu->state.xsave, buf_fx))
+		if (copy_sigframe_from_user_to_xstate(&fpregs->xsave, buf_fx))
 			return false;
 	} else {
-		if (__copy_from_user(&fpu->state.fxsave, buf_fx,
-				     sizeof(fpu->state.fxsave)))
+		if (__copy_from_user(&fpregs->fxsave, buf_fx,
+				     sizeof(fpregs->fxsave)))
 			return false;
 
 		if (IS_ENABLED(CONFIG_X86_64)) {
 			/* Reject invalid MXCSR values. */
-			if (fpu->state.fxsave.mxcsr & ~mxcsr_feature_mask)
+			if (fpregs->fxsave.mxcsr & ~mxcsr_feature_mask)
 				return false;
 		} else {
 			/* Mask invalid bits out for historical reasons (broken hardware). */
-			fpu->state.fxsave.mxcsr &= ~mxcsr_feature_mask;
+			fpregs->fxsave.mxcsr &= ~mxcsr_feature_mask;
 		}
 
 		/* Enforce XFEATURE_MASK_FPSSE when XSAVE is enabled */
 		if (use_xsave())
-			fpu->state.xsave.header.xfeatures |= XFEATURE_MASK_FPSSE;
+			fpregs->xsave.header.xfeatures |= XFEATURE_MASK_FPSSE;
 	}
 
 	/* Fold the legacy FP storage */
-	convert_to_fxsr(&fpu->state.fxsave, &env);
+	convert_to_fxsr(&fpregs->fxsave, &env);
 
 	fpregs_lock();
 	if (use_xsave()) {
@@ -411,10 +413,10 @@ static bool __fpu_restore_sig(void __use
 		 */
 		u64 mask = user_xfeatures | xfeatures_mask_supervisor();
 
-		fpu->state.xsave.header.xfeatures &= mask;
-		success = !os_xrstor_safe(&fpu->state.xsave, xfeatures_mask_all);
+		fpregs->xsave.header.xfeatures &= mask;
+		success = !os_xrstor_safe(&fpregs->xsave, xfeatures_mask_all);
 	} else {
-		success = !fxrstor_safe(&fpu->state.fxsave);
+		success = !fxrstor_safe(&fpregs->fxsave);
 	}
 
 	if (likely(success))

