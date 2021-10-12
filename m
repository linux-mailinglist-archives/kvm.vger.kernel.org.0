Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B428429A12
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 02:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235377AbhJLAIf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 20:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231607AbhJLAIY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 20:08:24 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADDC6C061745;
        Mon, 11 Oct 2021 17:06:23 -0700 (PDT)
Message-ID: <20211011223611.069324121@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633997181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=r/ZkZDk0uCUdUzfqEH4kRtKn/N/k0uKmPiViYgAGdNA=;
        b=X2Jc2yDJqujuUGDr/jHZL20+4lQqjR4hzZMwldbLElbHJ3gmuAb6cCWE6m1O4vvIiqkRSE
        TZi7aG9hjxMccsY4CXrORp5UANoRs0vDURxr+uhUfLrTEt+Q/cmOa0N1+sVspX4qNi74A6
        DpnilvWUPyklrP6BonRgUTcS5ldIqobcOx6kHCjSyPcBNkLWJfLDla67LCyA7p2jKu+5AJ
        OpwCUoGU49E0m09OX9QFRr/fI440raranZF6QUX//PgbqtDH5J439zzWVGhpbVZsZvKY2B
        5PDNadFzT9K+rhPUxkvjJk2MaNEtXqaYU+GuofviaYXZC1Iyj7W87vJA9xCq8w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633997181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=r/ZkZDk0uCUdUzfqEH4kRtKn/N/k0uKmPiViYgAGdNA=;
        b=/Wiu1U+gXREeaEVK2min30l78kB1t5uWMQpl1wtkbZFwU+adceWnv2D1Yp9rRDYPtoOIyH
        //znt1HAktL9BPCQ==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
References: <20211011215813.558681373@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 12 Oct 2021 02:00:17 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Swapping the host/guest FPU is directly fiddling with FPU internals which
requires 5 exports. The upcoming support of dymanically enabled states
would even need more.

Implement a swap function in the FPU core code and export that instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/fpu/api.h      |    8 +++++
 arch/x86/include/asm/fpu/internal.h |   15 +---------
 arch/x86/kernel/fpu/core.c          |   30 ++++++++++++++++++---
 arch/x86/kernel/fpu/init.c          |    1 
 arch/x86/kernel/fpu/xstate.c        |    1 
 arch/x86/kvm/x86.c                  |   51 +++++++-----------------------------
 arch/x86/mm/extable.c               |    2 -
 7 files changed, 48 insertions(+), 60 deletions(-)

--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -12,6 +12,8 @@
 #define _ASM_X86_FPU_API_H
 #include <linux/bottom_half.h>
 
+#include <asm/fpu/types.h>
+
 /*
  * Use kernel_fpu_begin/end() if you intend to use FPU in kernel context. It
  * disables preemption so be careful if you intend to use it for long periods
@@ -108,4 +110,10 @@ extern int cpu_has_xfeatures(u64 xfeatur
 
 static inline void update_pasid(void) { }
 
+/* FPSTATE related functions which are exported to KVM */
+extern void fpu_init_fpstate_user(struct fpu *fpu);
+
+/* KVM specific functions */
+extern void fpu_swap_kvm_fpu(struct fpu *save, struct fpu *rstor, u64 restore_mask);
+
 #endif /* _ASM_X86_FPU_API_H */
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -74,14 +74,8 @@ static __always_inline __pure bool use_f
 	return static_cpu_has(X86_FEATURE_FXSR);
 }
 
-/*
- * fpstate handling functions:
- */
-
 extern union fpregs_state init_fpstate;
-
 extern void fpstate_init_user(union fpregs_state *state);
-extern void fpu_init_fpstate_user(struct fpu *fpu);
 
 #ifdef CONFIG_MATH_EMULATION
 extern void fpstate_init_soft(struct swregs_state *soft);
@@ -381,12 +375,7 @@ static inline int os_xrstor_safe(struct
 	return err;
 }
 
-extern void __restore_fpregs_from_fpstate(union fpregs_state *fpstate, u64 mask);
-
-static inline void restore_fpregs_from_fpstate(union fpregs_state *fpstate)
-{
-	__restore_fpregs_from_fpstate(fpstate, xfeatures_mask_fpstate());
-}
+extern void restore_fpregs_from_fpstate(union fpregs_state *fpstate, u64 mask);
 
 extern bool copy_fpstate_to_sigframe(void __user *buf, void __user *fp, int size);
 
@@ -467,7 +456,7 @@ static inline void fpregs_restore_userre
 		 */
 		mask = xfeatures_mask_restore_user() |
 			xfeatures_mask_supervisor();
-		__restore_fpregs_from_fpstate(&fpu->state, mask);
+		restore_fpregs_from_fpstate(&fpu->state, mask);
 
 		fpregs_activate(fpu);
 		fpu->last_cpu = cpu;
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -124,9 +124,8 @@ void save_fpregs_to_fpstate(struct fpu *
 	asm volatile("fnsave %[fp]; fwait" : [fp] "=m" (fpu->state.fsave));
 	frstor(&fpu->state.fsave);
 }
-EXPORT_SYMBOL(save_fpregs_to_fpstate);
 
-void __restore_fpregs_from_fpstate(union fpregs_state *fpstate, u64 mask)
+void restore_fpregs_from_fpstate(union fpregs_state *fpstate, u64 mask)
 {
 	/*
 	 * AMD K7/K8 and later CPUs up to Zen don't save/restore
@@ -151,7 +150,31 @@ void __restore_fpregs_from_fpstate(union
 			frstor(&fpstate->fsave);
 	}
 }
-EXPORT_SYMBOL_GPL(__restore_fpregs_from_fpstate);
+
+#if IS_ENABLED(CONFIG_KVM)
+void fpu_swap_kvm_fpu(struct fpu *save, struct fpu *rstor, u64 restore_mask)
+{
+	fpregs_lock();
+
+	if (save) {
+		if (test_thread_flag(TIF_NEED_FPU_LOAD)) {
+			memcpy(&save->state, &current->thread.fpu.state,
+			       fpu_kernel_xstate_size);
+		} else {
+			save_fpregs_to_fpstate(save);
+		}
+	}
+
+	if (rstor) {
+		restore_mask &= xfeatures_mask_fpstate();
+		restore_fpregs_from_fpstate(&rstor->state, restore_mask);
+	}
+
+	fpregs_mark_activate();
+	fpregs_unlock();
+}
+EXPORT_SYMBOL_GPL(fpu_swap_kvm_fpu);
+#endif
 
 void kernel_fpu_begin_mask(unsigned int kfpu_mask)
 {
@@ -459,7 +482,6 @@ void fpregs_mark_activate(void)
 	fpu->last_cpu = smp_processor_id();
 	clear_thread_flag(TIF_NEED_FPU_LOAD);
 }
-EXPORT_SYMBOL_GPL(fpregs_mark_activate);
 
 /*
  * x87 math exception handling:
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -136,7 +136,6 @@ static void __init fpu__init_system_gene
  * components into a single, continuous memory block:
  */
 unsigned int fpu_kernel_xstate_size __ro_after_init;
-EXPORT_SYMBOL_GPL(fpu_kernel_xstate_size);
 
 /* Get alignment of the TYPE. */
 #define TYPE_ALIGN(TYPE) offsetof(struct { char x; TYPE test; }, test)
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -65,7 +65,6 @@ static short xsave_cpuid_features[] __in
  * XSAVE buffer, both supervisor and user xstates.
  */
 u64 xfeatures_mask_all __ro_after_init;
-EXPORT_SYMBOL_GPL(xfeatures_mask_all);
 
 static unsigned int xstate_offsets[XFEATURE_MAX] __ro_after_init =
 	{ [ 0 ... XFEATURE_MAX - 1] = -1};
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -68,7 +68,9 @@
 #include <asm/mce.h>
 #include <asm/pkru.h>
 #include <linux/kernel_stat.h>
-#include <asm/fpu/internal.h> /* Ugh! */
+#include <asm/fpu/api.h>
+#include <asm/fpu/xcr.h>
+#include <asm/fpu/xstate.h>
 #include <asm/pvclock.h>
 #include <asm/div64.h>
 #include <asm/irq_remapping.h>
@@ -9899,58 +9901,27 @@ static int complete_emulated_mmio(struct
 	return 0;
 }
 
-static void kvm_save_current_fpu(struct fpu *fpu)
-{
-	/*
-	 * If the target FPU state is not resident in the CPU registers, just
-	 * memcpy() from current, else save CPU state directly to the target.
-	 */
-	if (test_thread_flag(TIF_NEED_FPU_LOAD))
-		memcpy(&fpu->state, &current->thread.fpu.state,
-		       fpu_kernel_xstate_size);
-	else
-		save_fpregs_to_fpstate(fpu);
-}
-
 /* Swap (qemu) user FPU context for the guest FPU context. */
 static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 {
-	fpregs_lock();
-
-	kvm_save_current_fpu(vcpu->arch.user_fpu);
-
 	/*
-	 * Guests with protected state can't have it set by the hypervisor,
-	 * so skip trying to set it.
+	 * Guest with protected state have guest_fpu == NULL which makes
+	 * the swap only safe the host state. Exclude PKRU from restore as
+	 * it is restored separately in kvm_x86_ops.run().
 	 */
-	if (vcpu->arch.guest_fpu)
-		/* PKRU is separately restored in kvm_x86_ops.run. */
-		__restore_fpregs_from_fpstate(&vcpu->arch.guest_fpu->state,
-					~XFEATURE_MASK_PKRU);
-
-	fpregs_mark_activate();
-	fpregs_unlock();
-
+	fpu_swap_kvm_fpu(vcpu->arch.user_fpu, vcpu->arch.guest_fpu,
+			 ~XFEATURE_MASK_PKRU);
 	trace_kvm_fpu(1);
 }
 
 /* When vcpu_run ends, restore user space FPU context. */
 static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 {
-	fpregs_lock();
-
 	/*
-	 * Guests with protected state can't have it read by the hypervisor,
-	 * so skip trying to save it.
+	 * Guest with protected state have guest_fpu == NULL which makes
+	 * swap only restore the host state.
 	 */
-	if (vcpu->arch.guest_fpu)
-		kvm_save_current_fpu(vcpu->arch.guest_fpu);
-
-	restore_fpregs_from_fpstate(&vcpu->arch.user_fpu->state);
-
-	fpregs_mark_activate();
-	fpregs_unlock();
-
+	fpu_swap_kvm_fpu(vcpu->arch.guest_fpu, vcpu->arch.user_fpu, ~0ULL);
 	++vcpu->stat.fpu_reload;
 	trace_kvm_fpu(0);
 }
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -47,7 +47,7 @@ static bool ex_handler_fprestore(const s
 	WARN_ONCE(1, "Bad FPU state detected at %pB, reinitializing FPU registers.",
 		  (void *)instruction_pointer(regs));
 
-	__restore_fpregs_from_fpstate(&init_fpstate, xfeatures_mask_fpstate());
+	restore_fpregs_from_fpstate(&init_fpstate, xfeatures_mask_fpstate());
 	return true;
 }
 

