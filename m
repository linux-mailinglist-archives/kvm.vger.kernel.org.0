Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2966542E5E2
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 03:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234782AbhJOBSr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 21:18:47 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46438 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234103AbhJOBST (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 21:18:19 -0400
Message-ID: <20211015011539.076072399@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634260572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=z0ay49acq2DOw6ZhSUwwocc5xvCRCyVdfe0cuef4++4=;
        b=ijpWP5+VjJ7p+Nata20L00uTLKtB+ei1A8k+bao0Vq/m9rnB7yOZJDDNK9SGQJDGePn5RB
        JMGTPnMoa5NXLrq6cp0tCFkejIpjIuqLDCm9+tA8xho7FNoTfa0VTxduMMoiCJG+b3VfR0
        xFto74TOm/nieN5e/mhchiUqSkwjQcIsOKoZ0zOkcdZG0cc9cMm9i9TuC8NiumXXf0bRgP
        N3HcbPuL9piVQ5OJmeVZF84ay9R90Ut34PDyIwp4Eqeoof8pCRyrPhkNKMd/ih4NAkJm8Y
        /GdvOcXVMtzjS2xYw8/zkOT21A0JOwPexAfRmpf0pBci+15ZSjAqu9YCqHOB8g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634260572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=z0ay49acq2DOw6ZhSUwwocc5xvCRCyVdfe0cuef4++4=;
        b=tYroHFdbMnAsS/edjBdktbrl47kcNbEEgylG4Eo6SRpX0TrX9lf1DoHNxCpe5pcx/yG5qq
        ncsROVD4xkxSnwBA==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [patch V2 12/30] x86/fpu: Move KVMs FPU swapping to FPU core
References: <20211015011411.304289784@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 03:16:12 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Swapping the host/guest FPU is directly fiddling with FPU internals which
requires 5 exports. The upcoming support of dynamically enabled states
would even need more.

Implement a swap function in the FPU core code and export that instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
---
V2: Fix changelog and comments - Boris
---
 arch/x86/include/asm/fpu/api.h      |  8 ++++++-
 arch/x86/include/asm/fpu/internal.h | 15 +----------
 arch/x86/kernel/fpu/core.c          | 30 +++++++++++++++++++---
 arch/x86/kernel/fpu/init.c          |  1 +-
 arch/x86/kernel/fpu/xstate.c        |  1 +-
 arch/x86/kvm/x86.c                  | 51 ++++++++------------------------------
 arch/x86/mm/extable.c               |  2 +-
 7 files changed, 48 insertions(+), 60 deletions(-)
---
diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index 23bef08a8388..d2b8603a9c7e 100644
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
@@ -108,4 +110,10 @@ extern int cpu_has_xfeatures(u64 xfeatures_mask, const char **feature_name);
 
 static inline void update_pasid(void) { }
 
+/* fpstate-related functions which are exported to KVM */
+extern void fpu_init_fpstate_user(struct fpu *fpu);
+
+/* KVM specific functions */
+extern void fpu_swap_kvm_fpu(struct fpu *save, struct fpu *rstor, u64 restore_mask);
+
 #endif /* _ASM_X86_FPU_API_H */
diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index df57f1af3a4c..3ac55ba55782 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -74,14 +74,8 @@ static __always_inline __pure bool use_fxsr(void)
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
@@ -381,12 +375,7 @@ static inline int os_xrstor_safe(struct xregs_state *xstate, u64 mask)
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
 
@@ -467,7 +456,7 @@ static inline void fpregs_restore_userregs(void)
 		 */
 		mask = xfeatures_mask_restore_user() |
 			xfeatures_mask_supervisor();
-		__restore_fpregs_from_fpstate(&fpu->state, mask);
+		restore_fpregs_from_fpstate(&fpu->state, mask);
 
 		fpregs_activate(fpu);
 		fpu->last_cpu = cpu;
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 0789f0c3dca9..023bfe857907 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -124,9 +124,8 @@ void save_fpregs_to_fpstate(struct fpu *fpu)
 	asm volatile("fnsave %[fp]; fwait" : [fp] "=m" (fpu->state.fsave));
 	frstor(&fpu->state.fsave);
 }
-EXPORT_SYMBOL(save_fpregs_to_fpstate);
 
-void __restore_fpregs_from_fpstate(union fpregs_state *fpstate, u64 mask)
+void restore_fpregs_from_fpstate(union fpregs_state *fpstate, u64 mask)
 {
 	/*
 	 * AMD K7/K8 and later CPUs up to Zen don't save/restore
@@ -151,7 +150,31 @@ void __restore_fpregs_from_fpstate(union fpregs_state *fpstate, u64 mask)
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
@@ -457,7 +480,6 @@ void fpregs_mark_activate(void)
 	fpu->last_cpu = smp_processor_id();
 	clear_thread_flag(TIF_NEED_FPU_LOAD);
 }
-EXPORT_SYMBOL_GPL(fpregs_mark_activate);
 
 /*
  * x87 math exception handling:
diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index 37f872630a0e..545c91c723b8 100644
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -136,7 +136,6 @@ static void __init fpu__init_system_generic(void)
  * components into a single, continuous memory block:
  */
 unsigned int fpu_kernel_xstate_size __ro_after_init;
-EXPORT_SYMBOL_GPL(fpu_kernel_xstate_size);
 
 /* Get alignment of the TYPE. */
 #define TYPE_ALIGN(TYPE) offsetof(struct { char x; TYPE test; }, test)
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index b35ecfa8d450..68355605ca75 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -65,7 +65,6 @@ static short xsave_cpuid_features[] __initdata = {
  * XSAVE buffer, both supervisor and user xstates.
  */
 u64 xfeatures_mask_all __ro_after_init;
-EXPORT_SYMBOL_GPL(xfeatures_mask_all);
 
 static unsigned int xstate_offsets[XFEATURE_MAX] __ro_after_init =
 	{ [ 0 ... XFEATURE_MAX - 1] = -1};
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 743f522ed293..b9fda03162bd 100644
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
@@ -9899,58 +9901,27 @@ static int complete_emulated_mmio(struct kvm_vcpu *vcpu)
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
+	 * Guests with protected state have guest_fpu == NULL which makes
+	 * the swap only save the host state. Exclude PKRU from restore as
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
+	 * Guests with protected state have guest_fpu == NULL which makes
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
diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index f37e290e6d0a..043ec385af45 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -47,7 +47,7 @@ static bool ex_handler_fprestore(const struct exception_table_entry *fixup,
 	WARN_ONCE(1, "Bad FPU state detected at %pB, reinitializing FPU registers.",
 		  (void *)instruction_pointer(regs));
 
-	__restore_fpregs_from_fpstate(&init_fpstate, xfeatures_mask_fpstate());
+	restore_fpregs_from_fpstate(&init_fpstate, xfeatures_mask_fpstate());
 	return true;
 }
 

