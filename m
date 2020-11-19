Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1020A2B9E80
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 00:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbgKSXhE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Nov 2020 18:37:04 -0500
Received: from mga17.intel.com ([192.55.52.151]:28799 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727021AbgKSXhD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Nov 2020 18:37:03 -0500
IronPort-SDR: q3bxTDEo+XptXhbEeP1G4StkijlCmuWwAdGEyad4Z7qOsEliqZVjKMCUpo8DZMnhaLl0YgC+th
 1zDkojJHE3lg==
X-IronPort-AV: E=McAfee;i="6000,8403,9810"; a="151232248"
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="151232248"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2020 15:37:02 -0800
IronPort-SDR: sH0I7/GOip18F5jtDCo/21hM0WekzUGC4Zs7ihRgaQWWcuwlgzOjEtfFh5VUJpJsEE81P2w317
 eImkFPKvrH6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="431392193"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by fmsmga001.fm.intel.com with ESMTP; 19 Nov 2020 15:36:59 -0800
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     tglx@linutronix.de, mingo@kernel.org, bp@suse.de, luto@kernel.org,
        x86@kernel.org
Cc:     len.brown@intel.com, dave.hansen@intel.com, jing2.liu@intel.com,
        ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, kvm@vger.kernel.org
Subject: [PATCH v2 04/22] x86/fpu/xstate: Modify save and restore helper prototypes to access all the possible areas
Date:   Thu, 19 Nov 2020 15:32:39 -0800
Message-Id: <20201119233257.2939-5-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201119233257.2939-1-chang.seok.bae@intel.com>
References: <20201119233257.2939-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The xstate infrastructure is not flexible to support dynamic areas in
task->fpu. Make the xstate save and restore helpers to access task->fpu
directly.

No functional change.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Reviewed-by: Len Brown <len.brown@intel.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
---
 arch/x86/include/asm/fpu/internal.h | 9 ++++++---
 arch/x86/kernel/fpu/core.c          | 4 ++--
 arch/x86/kernel/fpu/signal.c        | 3 +--
 arch/x86/kvm/x86.c                  | 2 +-
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index 0153c4d4ca77..37ea5e37f21c 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -397,8 +397,9 @@ static inline int copy_user_to_xregs(struct xregs_state __user *buf, u64 mask)
  * Restore xstate from kernel space xsave area, return an error code instead of
  * an exception.
  */
-static inline int copy_kernel_to_xregs_err(struct xregs_state *xstate, u64 mask)
+static inline int copy_kernel_to_xregs_err(struct fpu *fpu, u64 mask)
 {
+	struct xregs_state *xstate = &fpu->state.xsave;
 	u32 lmask = mask;
 	u32 hmask = mask >> 32;
 	int err;
@@ -425,8 +426,10 @@ static inline void __copy_kernel_to_fpregs(union fpregs_state *fpstate, u64 mask
 	}
 }
 
-static inline void copy_kernel_to_fpregs(union fpregs_state *fpstate)
+static inline void copy_kernel_to_fpregs(struct fpu *fpu)
 {
+	union fpregs_state *fpstate = &fpu->state;
+
 	/*
 	 * AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception is
 	 * pending. Clear the x87 state here by setting it to fixed values.
@@ -511,7 +514,7 @@ static inline void __fpregs_load_activate(void)
 		return;
 
 	if (!fpregs_state_valid(fpu, cpu)) {
-		copy_kernel_to_fpregs(&fpu->state);
+		copy_kernel_to_fpregs(fpu);
 		fpregs_activate(fpu);
 		fpu->last_cpu = cpu;
 	}
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 41d926c76615..39ddb22c143b 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -172,7 +172,7 @@ void fpu__save(struct fpu *fpu)
 
 	if (!test_thread_flag(TIF_NEED_FPU_LOAD)) {
 		if (!copy_fpregs_to_fpstate(fpu)) {
-			copy_kernel_to_fpregs(&fpu->state);
+			copy_kernel_to_fpregs(fpu);
 		}
 	}
 
@@ -248,7 +248,7 @@ int fpu__copy(struct task_struct *dst, struct task_struct *src)
 		memcpy(&dst_fpu->state, &src_fpu->state, fpu_kernel_xstate_size);
 
 	else if (!copy_fpregs_to_fpstate(dst_fpu))
-		copy_kernel_to_fpregs(&dst_fpu->state);
+		copy_kernel_to_fpregs(dst_fpu);
 
 	fpregs_unlock();
 
diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 60676eef41a8..83c4bdbe5a23 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -427,8 +427,7 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 		 * Restore previously saved supervisor xstates along with
 		 * copied-in user xstates.
 		 */
-		ret = copy_kernel_to_xregs_err(&fpu->state.xsave,
-					       user_xfeatures | xfeatures_mask_supervisor());
+		ret = copy_kernel_to_xregs_err(fpu, user_xfeatures | xfeatures_mask_supervisor());
 
 	} else if (use_fxsr()) {
 		ret = __copy_from_user(&fpu->state.fxsave, buf_fx, state_size);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 71d9076d2b77..c65b7ab34e86 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9247,7 +9247,7 @@ static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 
 	kvm_save_current_fpu(vcpu->arch.guest_fpu);
 
-	copy_kernel_to_fpregs(&vcpu->arch.user_fpu->state);
+	copy_kernel_to_fpregs(vcpu->arch.user_fpu);
 
 	fpregs_mark_activate();
 	fpregs_unlock();
-- 
2.17.1

