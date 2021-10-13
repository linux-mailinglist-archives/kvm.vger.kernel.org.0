Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C050C42C421
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237959AbhJMO5x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 10:57:53 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35424 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237968AbhJMO5o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 10:57:44 -0400
Message-ID: <20211013145322.659456185@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634136939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=L9MFNnb+5EhYZzjza1LcCn5Mphd5on/qHXQ35Nu1kvk=;
        b=3IzfUKYoBz4rYXUH46Z9IQ2+tQTkKyoYiwMyW49qZA2HIte/Y+wQLX8tMs8gfgxYF9C0cZ
        XdK9ShnELaTboYH5Vx6awL0EvRsoxjeTOYQDCgzSm4exuucnz+yP2rpvwSkjqeQL9+qF8s
        jpWizd6yvGTfoFDJSnZNTDZzp/f2Z/iR8aqj4dqEad95Vp1lQB2hGZYWwnv+hwNpKYQ1Hx
        bJ3N6x/LfLRPk7L8qQ8NLZodVnIDbkrfe02yEzJVI0N9H5O3ealLs2BaVFRI73tFRSq+fb
        KnZABMqVLgLhufDKkiYf3qWFx2NybJj0EbO+/U0cyPFTzkGkCKwFvUpOcKorgA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634136939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=L9MFNnb+5EhYZzjza1LcCn5Mphd5on/qHXQ35Nu1kvk=;
        b=Qz0qJbPCGPu3w0B6xeDZXfCCTbouhgK8fwlOc6khCDAccYp+jyHV9aNv+h2/nyfVexb6Gd
        VSPHWM8dmxH0fbAw==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 09/21] x86/fpu/core: Convert to fpstate
References: <20211013142847.120153383@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 13 Oct 2021 16:55:39 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert the rest of the core code to the new register storage mechanism in
preparation for dynamically sized buffers.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/fpu/api.h |    4 +--
 arch/x86/kernel/fpu/core.c     |   44 +++++++++++++++++++++--------------------
 arch/x86/kernel/fpu/init.c     |    2 -
 arch/x86/kernel/fpu/xstate.c   |    2 -
 4 files changed, 27 insertions(+), 25 deletions(-)

--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -50,9 +50,9 @@ static inline void kernel_fpu_begin(void
 }
 
 /*
- * Use fpregs_lock() while editing CPU's FPU registers or fpu->state.
+ * Use fpregs_lock() while editing CPU's FPU registers or fpu->fpstate.
  * A context switch will (and softirq might) save CPU's FPU registers to
- * fpu->state and set TIF_NEED_FPU_LOAD leaving CPU's FPU registers in
+ * fpu->fpstate.regs and set TIF_NEED_FPU_LOAD leaving CPU's FPU registers in
  * a random state.
  *
  * local_bh_disable() protects against both preemption and soft interrupts
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -89,7 +89,7 @@ bool irq_fpu_usable(void)
 EXPORT_SYMBOL(irq_fpu_usable);
 
 /*
- * Save the FPU register state in fpu->state. The register state is
+ * Save the FPU register state in fpu->fpstate->regs. The register state is
  * preserved.
  *
  * Must be called with fpregs_lock() held.
@@ -105,19 +105,19 @@ EXPORT_SYMBOL(irq_fpu_usable);
 void save_fpregs_to_fpstate(struct fpu *fpu)
 {
 	if (likely(use_xsave())) {
-		os_xsave(&fpu->state.xsave);
+		os_xsave(&fpu->fpstate->regs.xsave);
 
 		/*
 		 * AVX512 state is tracked here because its use is
 		 * known to slow the max clock speed of the core.
 		 */
-		if (fpu->state.xsave.header.xfeatures & XFEATURE_MASK_AVX512)
+		if (fpu->fpstate->regs.xsave.header.xfeatures & XFEATURE_MASK_AVX512)
 			fpu->avx512_timestamp = jiffies;
 		return;
 	}
 
 	if (likely(use_fxsr())) {
-		fxsave(&fpu->state.fxsave);
+		fxsave(&fpu->fpstate->regs.fxsave);
 		return;
 	}
 
@@ -125,8 +125,8 @@ void save_fpregs_to_fpstate(struct fpu *
 	 * Legacy FPU register saving, FNSAVE always clears FPU registers,
 	 * so we have to reload them from the memory state.
 	 */
-	asm volatile("fnsave %[fp]; fwait" : [fp] "=m" (fpu->state.fsave));
-	frstor(&fpu->state.fsave);
+	asm volatile("fnsave %[fp]; fwait" : [fp] "=m" (fpu->fpstate->regs.fsave));
+	frstor(&fpu->fpstate->regs.fsave);
 }
 
 void restore_fpregs_from_fpstate(struct fpstate *fpstate, u64 mask)
@@ -167,7 +167,8 @@ void fpu_swap_kvm_fpu(struct fpu *save,
 
 	if (save) {
 		if (test_thread_flag(TIF_NEED_FPU_LOAD)) {
-			memcpy(&save->state, &current->thread.fpu.state,
+			memcpy(&save->fpstate->regs,
+			       &current->thread.fpu.fpstate->regs,
 			       fpu_kernel_xstate_size);
 		} else {
 			save_fpregs_to_fpstate(save);
@@ -187,7 +188,7 @@ EXPORT_SYMBOL_GPL(fpu_swap_kvm_fpu);
 void fpu_copy_fpstate_to_kvm_uabi(struct fpu *fpu, void *buf,
 			       unsigned int size, u32 pkru)
 {
-	union fpregs_state *kstate = &fpu->state;
+	union fpregs_state *kstate = &fpu->fpstate->regs;
 	union fpregs_state *ustate = buf;
 	struct membuf mb = { .p = buf, .left = size };
 
@@ -205,7 +206,7 @@ EXPORT_SYMBOL_GPL(fpu_copy_fpstate_to_kv
 int fpu_copy_kvm_uabi_to_fpstate(struct fpu *fpu, const void *buf, u64 xcr0,
 				 u32 *vpkru)
 {
-	union fpregs_state *kstate = &fpu->state;
+	union fpregs_state *kstate = &fpu->fpstate->regs;
 	const union fpregs_state *ustate = buf;
 	struct pkru_state *xpkru;
 	int ret;
@@ -378,7 +379,7 @@ int fpu_clone(struct task_struct *dst)
 	 */
 	if (dst->flags & (PF_KTHREAD | PF_IO_WORKER)) {
 		/* Clear out the minimal state */
-		memcpy(&dst_fpu->state, &init_fpstate.regs,
+		memcpy(&dst_fpu->fpstate->regs, &init_fpstate.regs,
 		       init_fpstate_copy_size());
 		return 0;
 	}
@@ -389,11 +390,12 @@ int fpu_clone(struct task_struct *dst)
 	 * child's FPU context, without any memory-to-memory copying.
 	 */
 	fpregs_lock();
-	if (test_thread_flag(TIF_NEED_FPU_LOAD))
-		memcpy(&dst_fpu->state, &src_fpu->state, fpu_kernel_xstate_size);
-
-	else
+	if (test_thread_flag(TIF_NEED_FPU_LOAD)) {
+		memcpy(&dst_fpu->fpstate->regs, &src_fpu->fpstate->regs,
+		       fpu_kernel_xstate_size);
+	} else {
 		save_fpregs_to_fpstate(dst_fpu);
+	}
 	fpregs_unlock();
 
 	trace_x86_fpu_copy_src(src_fpu);
@@ -466,7 +468,7 @@ static void fpu_reset_fpstate(void)
 	 * user space as PKRU is eagerly written in switch_to() and
 	 * flush_thread().
 	 */
-	memcpy(&fpu->state, &init_fpstate.regs, init_fpstate_copy_size());
+	memcpy(&fpu->fpstate->regs, &init_fpstate.regs, init_fpstate_copy_size());
 	set_thread_flag(TIF_NEED_FPU_LOAD);
 	fpregs_unlock();
 }
@@ -493,7 +495,7 @@ void fpu__clear_user_states(struct fpu *
 	 */
 	if (xfeatures_mask_supervisor() &&
 	    !fpregs_state_valid(fpu, smp_processor_id())) {
-		os_xrstor(&fpu->state.xsave, xfeatures_mask_supervisor());
+		os_xrstor(&fpu->fpstate->regs.xsave, xfeatures_mask_supervisor());
 	}
 
 	/* Reset user states in registers. */
@@ -574,11 +576,11 @@ int fpu__exception_code(struct fpu *fpu,
 		 * fully reproduce the context of the exception.
 		 */
 		if (boot_cpu_has(X86_FEATURE_FXSR)) {
-			cwd = fpu->state.fxsave.cwd;
-			swd = fpu->state.fxsave.swd;
+			cwd = fpu->fpstate->regs.fxsave.cwd;
+			swd = fpu->fpstate->regs.fxsave.swd;
 		} else {
-			cwd = (unsigned short)fpu->state.fsave.cwd;
-			swd = (unsigned short)fpu->state.fsave.swd;
+			cwd = (unsigned short)fpu->fpstate->regs.fsave.cwd;
+			swd = (unsigned short)fpu->fpstate->regs.fsave.swd;
 		}
 
 		err = swd & ~cwd;
@@ -592,7 +594,7 @@ int fpu__exception_code(struct fpu *fpu,
 		unsigned short mxcsr = MXCSR_DEFAULT;
 
 		if (boot_cpu_has(X86_FEATURE_XMM))
-			mxcsr = fpu->state.fxsave.mxcsr;
+			mxcsr = fpu->fpstate->regs.fxsave.mxcsr;
 
 		err = ~(mxcsr >> 7) & mxcsr;
 	}
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -38,7 +38,7 @@ static void fpu__init_cpu_generic(void)
 	/* Flush out any pending x87 state: */
 #ifdef CONFIG_MATH_EMULATION
 	if (!boot_cpu_has(X86_FEATURE_FPU))
-		fpstate_init_soft(&current->thread.fpu.state.soft);
+		fpstate_init_soft(&current->thread.fpu.fpstate->regs.soft);
 	else
 #endif
 		asm volatile ("fninit");
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1094,7 +1094,7 @@ void __copy_xstate_to_uabi_buf(struct me
 void copy_xstate_to_uabi_buf(struct membuf to, struct task_struct *tsk,
 			     enum xstate_copy_mode copy_mode)
 {
-	__copy_xstate_to_uabi_buf(to, &tsk->thread.fpu.state.xsave,
+	__copy_xstate_to_uabi_buf(to, &tsk->thread.fpu.fpstate->regs.xsave,
 				  tsk->thread.pkru, copy_mode);
 }
 

