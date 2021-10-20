Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06293434C7B
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 15:45:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbhJTNra (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 09:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbhJTNrD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 09:47:03 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33FE1C061765;
        Wed, 20 Oct 2021 06:44:41 -0700 (PDT)
Date:   Wed, 20 Oct 2021 13:44:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634737479;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sKO8CcQ9o3Et7hymHg88ZaYb4W64/N1vazeBA9QYeKM=;
        b=d11k0cS9TuSizhQ+OEyv2FnwtpNneji5kVZFh7M15ApMGEbZesqpRi6/BFBobXc/7vZdPy
        +XCePvpC3CAADCPZpjarW0b5ZKBQ2B7YplqRCaksdQFYzbCImwBAHKUmNB5npZ1hHLaeeZ
        OkBEvHRmdtjorjPi2eDUGV67tLxBiwEoYys4D94TUbX18U9pWiMeys3WKphPM3I7GlS6/N
        X22EBG4qz7d4kNswDHVmQXMWSMQHJkMqH+92hdusbqt3uRAVOOH4n1wPsKZTEJUNEG+whF
        oP8+krXa6zIe/v2CoMEDgfOHfUJcEYnAG2D0cVnNZiiW4jOBFpFjLj3+DhSOzQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634737479;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sKO8CcQ9o3Et7hymHg88ZaYb4W64/N1vazeBA9QYeKM=;
        b=adLLyvGCETGSCNjKnh3OT75opLeXqMnoXYiymrF5UUVKICTOcfhMe+Sy1GT3Nn0A3qHdgk
        V8mOcg/DZ3d1XdDQ==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/fpu] x86/fpu: Move KVMs FPU swapping to FPU core
Cc:     Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20211015011539.076072399@linutronix.de>
References: <20211015011539.076072399@linutronix.de>
MIME-Version: 1.0
Message-ID: <163473747895.25758.7734497884560014813.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following commit has been merged into the x86/fpu branch of tip:

Commit-ID:     a0ff0611c2fbde94f6c9db8351939b08f2cb6797
Gitweb:        https://git.kernel.org/tip/a0ff0611c2fbde94f6c9db8351939b08f2cb6797
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Fri, 15 Oct 2021 03:16:12 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 20 Oct 2021 15:27:27 +02:00

x86/fpu: Move KVMs FPU swapping to FPU core

Swapping the host/guest FPU is directly fiddling with FPU internals which
requires 5 exports. The upcoming support of dynamically enabled states
would even need more.

Implement a swap function in the FPU core code and export that instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Link: https://lkml.kernel.org/r/20211015011539.076072399@linutronix.de
---
 arch/x86/include/asm/fpu/api.h      |  8 ++++-
 arch/x86/include/asm/fpu/internal.h | 15 +-------
 arch/x86/kernel/fpu/core.c          | 30 +++++++++++++---
 arch/x86/kernel/fpu/init.c          |  1 +-
 arch/x86/kernel/fpu/xstate.c        |  1 +-
 arch/x86/kvm/x86.c                  | 51 ++++++----------------------
 arch/x86/mm/extable.c               |  2 +-
 7 files changed, 48 insertions(+), 60 deletions(-)

diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index 23bef08..d2b8603 100644
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
index df57f1a..3ac55ba 100644
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
index 0789f0c..023bfe8 100644
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
index 37f8726..545c91c 100644
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
index b35ecfa..6835560 100644
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
index 74712e5..66eea4e 100644
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
@@ -9913,58 +9915,27 @@ static int complete_emulated_mmio(struct kvm_vcpu *vcpu)
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
index f37e290..043ec38 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -47,7 +47,7 @@ static bool ex_handler_fprestore(const struct exception_table_entry *fixup,
 	WARN_ONCE(1, "Bad FPU state detected at %pB, reinitializing FPU registers.",
 		  (void *)instruction_pointer(regs));
 
-	__restore_fpregs_from_fpstate(&init_fpstate, xfeatures_mask_fpstate());
+	restore_fpregs_from_fpstate(&init_fpstate, xfeatures_mask_fpstate());
 	return true;
 }
 
