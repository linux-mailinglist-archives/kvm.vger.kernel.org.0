Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA32E280897
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 22:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727713AbgJAUmy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 16:42:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:58716 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbgJAUmw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Oct 2020 16:42:52 -0400
IronPort-SDR: WUjfmZ/pJ32mhbyS183zl6hnDH+X7/TLhPa0PPQWGfE9nUEVjeoxmpahyRGnl3Sm9uwlh4nsnb
 g3F7rVHVtjYg==
X-IronPort-AV: E=McAfee;i="6000,8403,9761"; a="160170709"
X-IronPort-AV: E=Sophos;i="5.77,325,1596524400"; 
   d="scan'208";a="160170709"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2020 13:42:51 -0700
IronPort-SDR: gYo6blMVVytvDhYheP8ApAZAlpOmQ2A89VQg/UPDpHm+Kx/6i9XmpVsZdmaRY+5tVIlSt2d90y
 8kVc6oIR+F7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,325,1596524400"; 
   d="scan'208";a="351297037"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Oct 2020 13:42:51 -0700
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     tglx@linutronix.de, mingo@kernel.org, bp@suse.de, luto@kernel.org,
        x86@kernel.org
Cc:     len.brown@intel.com, dave.hansen@intel.com, jing2.liu@intel.com,
        ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, kvm@vger.kernel.org
Subject: [RFC PATCH 04/22] x86/fpu/xstate: Modify save and restore helper prototypes to access all the possible areas
Date:   Thu,  1 Oct 2020 13:38:55 -0700
Message-Id: <20201001203913.9125-5-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201001203913.9125-1-chang.seok.bae@intel.com>
References: <20201001203913.9125-1-chang.seok.bae@intel.com>
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
index baca80e877a6..6eec5209750f 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -396,8 +396,9 @@ static inline int copy_user_to_xregs(struct xregs_state __user *buf, u64 mask)
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
@@ -424,8 +425,10 @@ static inline void __copy_kernel_to_fpregs(union fpregs_state *fpstate, u64 mask
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
@@ -510,7 +513,7 @@ static inline void __fpregs_load_activate(void)
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
index adbf63114bc2..6f3bcc7dab80 100644
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
index c4b8d3705625..192d52ff5b8c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8877,7 +8877,7 @@ static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 
 	kvm_save_current_fpu(vcpu->arch.guest_fpu);
 
-	copy_kernel_to_fpregs(&vcpu->arch.user_fpu->state);
+	copy_kernel_to_fpregs(vcpu->arch.user_fpu);
 
 	fpregs_mark_activate();
 	fpregs_unlock();
-- 
2.17.1

