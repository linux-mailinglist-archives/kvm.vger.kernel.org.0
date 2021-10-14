Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7F6D42E4A2
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 01:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234340AbhJNXMB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 19:12:01 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:45684 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234379AbhJNXLq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 19:11:46 -0400
Message-ID: <20211014230739.461348278@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634252979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=Rzw02zaGEt/Tb3o44nL3X5P6XPRDUNaCla4lCE+NSiE=;
        b=Qvuwjt6GZtJ6FQq5xgvEY3vmyt/PZlSGUadBl8HDVVDyDTxBFh2tVv0I0021oDT7B8QHEb
        JCT/CPMeo5ZloRBvdO0OjeSiSZ/v1kxlAt4u7TDHMXcgvV/jQJq4e3KUUAHJ7LL5AZQwMG
        egDknicIK2HklK/qM1Whykm0koFY4Qd0a4Pok7YQLOFKdJ61DnbnFBw9aPafIMT2zFz905
        TmY7vKQRJtONvW4YTiEN5ILRBKco8Xpt7Lx6r68AWidqESqHK1vhpmlEoK239rX+vM1ThN
        edN4uBoAoinVDuMiU3t3IDecFX6k6edCsxyKfidnSo+eLcj7F+SEMRxV2YXMOA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634252979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=Rzw02zaGEt/Tb3o44nL3X5P6XPRDUNaCla4lCE+NSiE=;
        b=uuRjY1d8PUEOIOUW664gniOsULptlv5Pgh7bv5sWzttc51kokkUEakPb8XkjhwhJE8SQUw
        bvtNB56dLmflIRAA==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 7/8] x86/fpu: Rework restore_regs_from_fpstate()
References: <20211014225711.615197738@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 01:09:38 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

xfeatures_mask_fpstate() is not longer valid when dynamically enabled
features come into play.

Rework restore_regs_from_fpstate() so it takes a constant mask which will
then be applied against the maximum feature set so that the restore
operation brings all features which are not in the xsave buffer xfeature
bitmap into init state.

This ensures that if the previous task used a dynamically enabled feature
that the task which restores has all unused components properly initialized.

Cleanup the last user of xfeatures_mask_fpstate() as well and remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/fpu/xstate.h |   27 +++++++--------------------
 arch/x86/kernel/fpu/context.h     |    6 +-----
 arch/x86/kernel/fpu/core.c        |   17 ++++++++++++++---
 arch/x86/kernel/fpu/xstate.c      |    2 +-
 4 files changed, 23 insertions(+), 29 deletions(-)

--- a/arch/x86/include/asm/fpu/xstate.h
+++ b/arch/x86/include/asm/fpu/xstate.h
@@ -78,30 +78,17 @@
 				      XFEATURE_MASK_INDEPENDENT | \
 				      XFEATURE_MASK_SUPERVISOR_UNSUPPORTED)
 
-static inline u64 xfeatures_mask_supervisor(void)
-{
-	return fpu_kernel_cfg.max_features & XFEATURE_MASK_SUPERVISOR_SUPPORTED;
-}
-
 /*
- * The xfeatures which are restored by the kernel when returning to user
- * mode. This is not necessarily the same as xfeatures_mask_uabi() as the
- * kernel does not manage all XCR0 enabled features via xsave/xrstor as
- * some of them have to be switched eagerly on context switch and exec().
+ * The feature mask required to restore FPU state:
+ * - All user states which are not eagerly switched in switch_to()/exec()
+ * - The suporvisor states
  */
-static inline u64 xfeatures_mask_restore_user(void)
-{
-	return fpu_kernel_cfg.max_features & XFEATURE_MASK_USER_RESTORE;
-}
+#define XFEATURE_MASK_FPSTATE	(XFEATURE_MASK_USER_RESTORE | \
+				 XFEATURE_MASK_SUPERVISOR_SUPPORTED)
 
-/*
- * Like xfeatures_mask_restore_user() but additionally restors the
- * supported supervisor states.
- */
-static inline u64 xfeatures_mask_fpstate(void)
+static inline u64 xfeatures_mask_supervisor(void)
 {
-	return fpu_kernel_cfg.max_features & \
-		(XFEATURE_MASK_USER_RESTORE | XFEATURE_MASK_SUPERVISOR_SUPPORTED);
+	return fpu_kernel_cfg.max_features & XFEATURE_MASK_SUPERVISOR_SUPPORTED;
 }
 
 static inline u64 xfeatures_mask_independent(void)
--- a/arch/x86/kernel/fpu/context.h
+++ b/arch/x86/kernel/fpu/context.h
@@ -61,8 +61,6 @@ static inline void fpregs_restore_userre
 		return;
 
 	if (!fpregs_state_valid(fpu, cpu)) {
-		u64 mask;
-
 		/*
 		 * This restores _all_ xstate which has not been
 		 * established yet.
@@ -72,9 +70,7 @@ static inline void fpregs_restore_userre
 		 * flush_thread(). So it is excluded because it might be
 		 * not up to date in current->thread.fpu.xsave state.
 		 */
-		mask = xfeatures_mask_restore_user() |
-			xfeatures_mask_supervisor();
-		restore_fpregs_from_fpstate(fpu->fpstate, mask);
+		restore_fpregs_from_fpstate(fpu->fpstate, XFEATURE_MASK_FPSTATE);
 
 		fpregs_activate(fpu);
 		fpu->last_cpu = cpu;
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -150,6 +150,17 @@ void restore_fpregs_from_fpstate(struct
 	}
 
 	if (use_xsave()) {
+		/*
+		 * Restoring state always needs to modify all features
+		 * which are in @mask even if the current task cannot use
+		 * extended features.
+		 *
+		 * So fpstate->xfeatures cannot be used here, because then
+		 * a feature for which the task has no permission but was
+		 * used by the previous task would not go into init state.
+		 */
+		mask = fpu_kernel_cfg.max_features & mask;
+
 		os_xrstor(&fpstate->regs.xsave, mask);
 	} else {
 		if (use_fxsr())
@@ -161,7 +172,7 @@ void restore_fpregs_from_fpstate(struct
 
 void fpu_reset_from_exception_fixup(void)
 {
-	restore_fpregs_from_fpstate(&init_fpstate, xfeatures_mask_fpstate());
+	restore_fpregs_from_fpstate(&init_fpstate, XFEATURE_MASK_FPSTATE);
 }
 
 #if IS_ENABLED(CONFIG_KVM)
@@ -179,7 +190,7 @@ void fpu_swap_kvm_fpu(struct fpu *save,
 	}
 
 	if (rstor) {
-		restore_mask &= xfeatures_mask_fpstate();
+		restore_mask &= XFEATURE_MASK_FPSTATE;
 		restore_fpregs_from_fpstate(rstor->fpstate, restore_mask);
 	}
 
@@ -499,7 +510,7 @@ void fpu__clear_user_states(struct fpu *
 	}
 
 	/* Reset user states in registers. */
-	restore_fpregs_from_init_fpstate(xfeatures_mask_restore_user());
+	restore_fpregs_from_init_fpstate(XFEATURE_MASK_USER_RESTORE);
 
 	/*
 	 * Now all FPU registers have their desired values.  Inform the FPU
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -344,7 +344,7 @@ static void __init print_xstate_offset_s
  */
 static __init void os_xrstor_booting(struct xregs_state *xstate)
 {
-	u64 mask = xfeatures_mask_fpstate();
+	u64 mask = fpu_kernel_cfg.max_features & XFEATURE_MASK_FPSTATE;
 	u32 lmask = mask;
 	u32 hmask = mask >> 32;
 	int err;

