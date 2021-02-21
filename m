Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B857320CE5
	for <lists+kvm@lfdr.de>; Sun, 21 Feb 2021 20:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhBUTCL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Feb 2021 14:02:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:2043 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230211AbhBUTCH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Feb 2021 14:02:07 -0500
IronPort-SDR: QGSWx0DRrz3Lfv5P3X+rMwbzXIfxk6SLPgJo4zAvBGVsXdLu2XTx/TLgfDi94Bfc5WopKuhaMb
 RncTBvvmSnNA==
X-IronPort-AV: E=McAfee;i="6000,8403,9902"; a="184382822"
X-IronPort-AV: E=Sophos;i="5.81,195,1610438400"; 
   d="scan'208";a="184382822"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2021 11:01:27 -0800
IronPort-SDR: Ysf2RZIskvNXoH8suu3ScNj3GRZjUQEmezzxdcQt9tI7P014yLuA6EC214DzBs/xjpMvlHsuQU
 RFmXEtBoxWaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,195,1610438400"; 
   d="scan'208";a="429792089"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Feb 2021 11:01:26 -0800
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     bp@suse.de, luto@kernel.org, tglx@linutronix.de, mingo@kernel.org,
        x86@kernel.org
Cc:     len.brown@intel.com, dave.hansen@intel.com, jing2.liu@intel.com,
        ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, kvm@vger.kernel.org
Subject: [PATCH v4 04/22] x86/fpu/xstate: Modify the context restore helper to handle both static and dynamic buffers
Date:   Sun, 21 Feb 2021 10:56:19 -0800
Message-Id: <20210221185637.19281-5-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210221185637.19281-1-chang.seok.bae@intel.com>
References: <20210221185637.19281-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Have the function restoring xstate take a struct fpu * pointer in
preparation for dynamic state buffer support.

No functional change.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Reviewed-by: Len Brown <len.brown@intel.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
---
Changes from v3:
* Updated the changelog. (Borislav Petkov)
* Reverted the change on the copy_kernel_to_xregs_err() function as not
  needed.

Changes from v2:
* Updated the changelog with task->fpu removed. (Borislav Petkov)
---
 arch/x86/include/asm/fpu/internal.h | 6 ++++--
 arch/x86/kernel/fpu/core.c          | 4 ++--
 arch/x86/kvm/x86.c                  | 2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index 0153c4d4ca77..b34d0d29e4b8 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -425,8 +425,10 @@ static inline void __copy_kernel_to_fpregs(union fpregs_state *fpstate, u64 mask
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
@@ -511,7 +513,7 @@ static inline void __fpregs_load_activate(void)
 		return;
 
 	if (!fpregs_state_valid(fpu, cpu)) {
-		copy_kernel_to_fpregs(&fpu->state);
+		copy_kernel_to_fpregs(fpu);
 		fpregs_activate(fpu);
 		fpu->last_cpu = cpu;
 	}
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index d43661d309ab..5775e64b0172 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -173,7 +173,7 @@ void fpu__save(struct fpu *fpu)
 
 	if (!test_thread_flag(TIF_NEED_FPU_LOAD)) {
 		if (!copy_fpregs_to_fpstate(fpu)) {
-			copy_kernel_to_fpregs(&fpu->state);
+			copy_kernel_to_fpregs(fpu);
 		}
 	}
 
@@ -251,7 +251,7 @@ int fpu__copy(struct task_struct *dst, struct task_struct *src)
 		memcpy(&dst_fpu->state, &src_fpu->state, fpu_kernel_xstate_size);
 
 	else if (!copy_fpregs_to_fpstate(dst_fpu))
-		copy_kernel_to_fpregs(&dst_fpu->state);
+		copy_kernel_to_fpregs(dst_fpu);
 
 	fpregs_unlock();
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cc3b604ddcd2..dd9565d12d81 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9313,7 +9313,7 @@ static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.guest_fpu)
 		kvm_save_current_fpu(vcpu->arch.guest_fpu);
 
-	copy_kernel_to_fpregs(&vcpu->arch.user_fpu->state);
+	copy_kernel_to_fpregs(vcpu->arch.user_fpu);
 
 	fpregs_mark_activate();
 	fpregs_unlock();
-- 
2.17.1

