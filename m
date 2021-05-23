Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D837A38DC9D
	for <lists+kvm@lfdr.de>; Sun, 23 May 2021 21:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbhEWTj5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 May 2021 15:39:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:31998 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231967AbhEWTj4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 May 2021 15:39:56 -0400
IronPort-SDR: P90B+WqNbH42NA0G0PbdcM5R0eU9XH+dGPcOjDPufQo6gFI/IUQxmhGb+zV+bDg3ndOnxhC9E3
 iDQwKwtG8NNQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9993"; a="198740676"
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="198740676"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2021 12:38:28 -0700
IronPort-SDR: 2jr+pu/3oLl32YbNsPXiZ3PO24/Gh7icBbiRYnzLURXa5e8PjH8re1gppUtFntsYHer6nVAo1a
 if1gFeb624tA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="407467070"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by fmsmga007.fm.intel.com with ESMTP; 23 May 2021 12:38:27 -0700
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     bp@suse.de, luto@kernel.org, tglx@linutronix.de, mingo@kernel.org,
        x86@kernel.org
Cc:     len.brown@intel.com, dave.hansen@intel.com, jing2.liu@intel.com,
        ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, kvm@vger.kernel.org
Subject: [PATCH v5 04/28] x86/fpu/xstate: Modify the context restore helper to handle both static and dynamic buffers
Date:   Sun, 23 May 2021 12:32:35 -0700
Message-Id: <20210523193259.26200-5-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210523193259.26200-1-chang.seok.bae@intel.com>
References: <20210523193259.26200-1-chang.seok.bae@intel.com>
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
* Reverted the change of the copy_kernel_to_xregs_err() function as not
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
index 52f886477b07..830b1bc75ed4 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -173,7 +173,7 @@ void fpu__save(struct fpu *fpu)
 
 	if (!test_thread_flag(TIF_NEED_FPU_LOAD)) {
 		if (!copy_fpregs_to_fpstate(fpu)) {
-			copy_kernel_to_fpregs(&fpu->state);
+			copy_kernel_to_fpregs(fpu);
 		}
 	}
 
@@ -258,7 +258,7 @@ int fpu__copy(struct task_struct *dst, struct task_struct *src)
 		memcpy(&dst_fpu->state, &src_fpu->state, fpu_kernel_xstate_size);
 
 	else if (!copy_fpregs_to_fpstate(dst_fpu))
-		copy_kernel_to_fpregs(&dst_fpu->state);
+		copy_kernel_to_fpregs(dst_fpu);
 
 	fpregs_unlock();
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 01c8642cb56c..b428ff496bca 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9649,7 +9649,7 @@ static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.guest_fpu)
 		kvm_save_current_fpu(vcpu->arch.guest_fpu);
 
-	copy_kernel_to_fpregs(&vcpu->arch.user_fpu->state);
+	copy_kernel_to_fpregs(vcpu->arch.user_fpu);
 
 	fpregs_mark_activate();
 	fpregs_unlock();
-- 
2.17.1

