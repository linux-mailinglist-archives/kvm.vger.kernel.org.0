Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731592E1F17
	for <lists+kvm@lfdr.de>; Wed, 23 Dec 2020 17:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728414AbgLWQCW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Dec 2020 11:02:22 -0500
Received: from mga01.intel.com ([192.55.52.88]:1574 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728058AbgLWQCW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Dec 2020 11:02:22 -0500
IronPort-SDR: aVOR/DHJpbLUIEtwuIf5WhC22ddTqymsyD8mlp2+5FqlztWNJO9SoKbNg94GhFYv/kNEgskK5J
 n1KsDxSGwFxw==
X-IronPort-AV: E=McAfee;i="6000,8403,9844"; a="194483184"
X-IronPort-AV: E=Sophos;i="5.78,441,1599548400"; 
   d="scan'208";a="194483184"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2020 08:01:40 -0800
IronPort-SDR: 1XSvzBXp0Fq7V9+HAcYCNMBzL0Bomh+nP20y493IPL/Hp1o9VRVnrfhje+ZdA2/3L7Yl1qJfeL
 nwj956lp2v8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,441,1599548400"; 
   d="scan'208";a="458027979"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by fmsmga001.fm.intel.com with ESMTP; 23 Dec 2020 08:01:40 -0800
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     bp@suse.de, luto@kernel.org, tglx@linutronix.de, mingo@kernel.org,
        x86@kernel.org
Cc:     len.brown@intel.com, dave.hansen@intel.com, jing2.liu@intel.com,
        ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, kvm@vger.kernel.org
Subject: [PATCH v3 10/21] x86/fpu/xstate: Update xstate save function to support dynamic xstate
Date:   Wed, 23 Dec 2020 07:57:06 -0800
Message-Id: <20201223155717.19556-11-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201223155717.19556-1-chang.seok.bae@intel.com>
References: <20201223155717.19556-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

copy_xregs_to_kernel() used to save all user states in a kernel buffer.
When the dynamic user state is enabled, it becomes conditional which state
to be saved.

fpu->state_mask can indicate which state components are reserved to be
saved in XSAVE buffer. Use it as XSAVE's instruction mask to select states.

KVM used to save all xstate via copy_xregs_to_kernel(). Update KVM to set a
valid fpu->state_mask, which will be necessary to correctly handle dynamic
state buffers.

No functional change until the kernel supports dynamic user states.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Reviewed-by: Len Brown <len.brown@intel.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
---
Changes from v2:
* Updated the changelog to clarify the KVM code changes.
---
 arch/x86/include/asm/fpu/internal.h |  3 +--
 arch/x86/kernel/fpu/core.c          |  2 +-
 arch/x86/kvm/x86.c                  | 11 ++++++++---
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index 67ffd1d7c95e..d409a6ae0c38 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -332,9 +332,8 @@ static inline void copy_kernel_to_xregs_booting(struct xregs_state *xstate)
 /*
  * Save processor xstate to xsave area.
  */
-static inline void copy_xregs_to_kernel(struct xregs_state *xstate)
+static inline void copy_xregs_to_kernel(struct xregs_state *xstate, u64 mask)
 {
-	u64 mask = xfeatures_mask_all;
 	u32 lmask = mask;
 	u32 hmask = mask >> 32;
 	int err;
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 8b9d3ec9ac46..5a12e4b22db2 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -99,7 +99,7 @@ int copy_fpregs_to_fpstate(struct fpu *fpu)
 	if (likely(use_xsave())) {
 		struct xregs_state *xsave = &xstate->xsave;
 
-		copy_xregs_to_kernel(xsave);
+		copy_xregs_to_kernel(xsave, fpu->state_mask);
 
 		/*
 		 * AVX512 state is tracked here because its use is
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4aecfba04bd3..93b5bacad67a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9214,15 +9214,20 @@ static int complete_emulated_mmio(struct kvm_vcpu *vcpu)
 
 static void kvm_save_current_fpu(struct fpu *fpu)
 {
+	struct fpu *src_fpu = &current->thread.fpu;
+
 	/*
 	 * If the target FPU state is not resident in the CPU registers, just
 	 * memcpy() from current, else save CPU state directly to the target.
 	 */
-	if (test_thread_flag(TIF_NEED_FPU_LOAD))
-		memcpy(&fpu->state, &current->thread.fpu.state,
+	if (test_thread_flag(TIF_NEED_FPU_LOAD)) {
+		memcpy(&fpu->state, &src_fpu->state,
 		       fpu_kernel_xstate_min_size);
-	else
+	} else {
+		if (fpu->state_mask != src_fpu->state_mask)
+			fpu->state_mask = src_fpu->state_mask;
 		copy_fpregs_to_fpstate(fpu);
+	}
 }
 
 /* Swap (qemu) user FPU context for the guest FPU context. */
-- 
2.17.1

