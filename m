Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1C8C2E1F36
	for <lists+kvm@lfdr.de>; Wed, 23 Dec 2020 17:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728874AbgLWQCx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Dec 2020 11:02:53 -0500
Received: from mga12.intel.com ([192.55.52.136]:48944 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbgLWQCw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Dec 2020 11:02:52 -0500
IronPort-SDR: qOOV+kzqDrH+1d0GcWvC5NvalgqoespURdECxBMuDPPKxAi1/N0Q+TYRKUqdz13CTSk4T9nkFO
 fpzLQibXDrEA==
X-IronPort-AV: E=McAfee;i="6000,8403,9844"; a="155241872"
X-IronPort-AV: E=Sophos;i="5.78,441,1599548400"; 
   d="scan'208";a="155241872"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2020 08:01:39 -0800
IronPort-SDR: ZBYrTbCtYls7+ETwRIsuW6w5GY9AExALmGEFQ8gerAYXCD95DOL+nilnnjfbUQEeCdOgwcJV+P
 V1lURmNT+peQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,441,1599548400"; 
   d="scan'208";a="458027936"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by fmsmga001.fm.intel.com with ESMTP; 23 Dec 2020 08:01:37 -0800
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     bp@suse.de, luto@kernel.org, tglx@linutronix.de, mingo@kernel.org,
        x86@kernel.org
Cc:     len.brown@intel.com, dave.hansen@intel.com, jing2.liu@intel.com,
        ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, kvm@vger.kernel.org
Subject: [PATCH v3 04/21] x86/fpu/xstate: Modify context switch helpers to handle both static and dynamic buffers
Date:   Wed, 23 Dec 2020 07:57:00 -0800
Message-Id: <20201223155717.19556-5-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201223155717.19556-1-chang.seok.bae@intel.com>
References: <20201223155717.19556-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation for dynamic xstate buffer expansion, update the xstate
restore function parameters to equally handle static in-line xstate buffer,
as well as dynamically allocated xstate buffer.

No functional change.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Reviewed-by: Len Brown <len.brown@intel.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
---
Changes from v2:
* Updated the changelog with task->fpu removed. (Boris Petkov)
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
index f23e5ffbb307..20925cae2a84 100644
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
index 0d6deb75c507..414a13427934 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -426,8 +426,7 @@ static int __fpu__restore_sig(void __user *buf, void __user *buf_fx, int size)
 		 * Restore previously saved supervisor xstates along with
 		 * copied-in user xstates.
 		 */
-		ret = copy_kernel_to_xregs_err(&fpu->state.xsave,
-					       user_xfeatures | xfeatures_mask_supervisor());
+		ret = copy_kernel_to_xregs_err(fpu, user_xfeatures | xfeatures_mask_supervisor());
 
 	} else if (use_fxsr()) {
 		ret = __copy_from_user(&fpu->state.fxsave, buf_fx, state_size);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 09368201d9cc..a087bbf252b6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9249,7 +9249,7 @@ static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 
 	kvm_save_current_fpu(vcpu->arch.guest_fpu);
 
-	copy_kernel_to_fpregs(&vcpu->arch.user_fpu->state);
+	copy_kernel_to_fpregs(vcpu->arch.user_fpu);
 
 	fpregs_mark_activate();
 	fpregs_unlock();
-- 
2.17.1

