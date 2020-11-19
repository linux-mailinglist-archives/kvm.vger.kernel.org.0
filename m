Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B65C82B9E8C
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 00:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727342AbgKSXhv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Nov 2020 18:37:51 -0500
Received: from mga07.intel.com ([134.134.136.100]:49073 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727032AbgKSXhD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Nov 2020 18:37:03 -0500
IronPort-SDR: Zq/Pe0p5l91hzzx48DOjm3ebbChK80LW8s+OwnICX1nGafsr13H2JNTzNYk/SXmj3kEoZO8atX
 D/aR+DdAIJ6w==
X-IronPort-AV: E=McAfee;i="6000,8403,9810"; a="235531197"
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="235531197"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2020 15:37:02 -0800
IronPort-SDR: VMCuB3rwBwInEHUHrFef2gQiRrhm7CgBMKml9/imwPF3Ks4pIjGh4SuRBPJusd72Ma53jJSb86
 TplYUTVs9q2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="431392221"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by fmsmga001.fm.intel.com with ESMTP; 19 Nov 2020 15:37:02 -0800
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     tglx@linutronix.de, mingo@kernel.org, bp@suse.de, luto@kernel.org,
        x86@kernel.org
Cc:     len.brown@intel.com, dave.hansen@intel.com, jing2.liu@intel.com,
        ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, kvm@vger.kernel.org
Subject: [PATCH v2 10/22] x86/fpu/xstate: Update xstate save function for supporting dynamic user xstate
Date:   Thu, 19 Nov 2020 15:32:45 -0800
Message-Id: <20201119233257.2939-11-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201119233257.2939-1-chang.seok.bae@intel.com>
References: <20201119233257.2939-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

copy_xregs_to_kernel() used to save all user states in an invariably
sufficient buffer. When the dynamic user state is enabled, it becomes
conditional which state to be saved.

fpu->state_mask can indicate which state components are reserved to be
saved in XSAVE buffer. Use it as XSAVE's instruction mask to select states.

KVM saves xstate in guest_fpu and user_fpu. With the change, the KVM code
needs to ensure a valid fpu->state_mask before XSAVE.

No functional change until the kernel supports dynamic user states.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Reviewed-by: Len Brown <len.brown@intel.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
---
 arch/x86/include/asm/fpu/internal.h |  3 +--
 arch/x86/kernel/fpu/core.c          |  2 +-
 arch/x86/kvm/x86.c                  | 11 ++++++++---
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index 3201468ff4aa..75196d10aa71 100644
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
index dca4961fcc36..ece6428ba85b 100644
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
index abd5ff338155..023db770b55f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9212,15 +9212,20 @@ static int complete_emulated_mmio(struct kvm_vcpu *vcpu)
 
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
 		       fpu_kernel_xstate_default_size);
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

