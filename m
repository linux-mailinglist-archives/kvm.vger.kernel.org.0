Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B12428089A
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 22:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733050AbgJAUnR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Oct 2020 16:43:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:58716 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733062AbgJAUnR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Oct 2020 16:43:17 -0400
IronPort-SDR: hljPix7sDZsE5TIcZIfzIQROxurmP2vO8X3hkZFYzynvzazLOc++YncwmAyuEY7kpZEpc9CJgL
 kCmuCj1Wasjw==
X-IronPort-AV: E=McAfee;i="6000,8403,9761"; a="160170722"
X-IronPort-AV: E=Sophos;i="5.77,325,1596524400"; 
   d="scan'208";a="160170722"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2020 13:42:52 -0700
IronPort-SDR: s99G8RnmpQ7YAa58hSoFTv4NZhVrvX0Mpopu3DBKEKM/fu03wUi90frHoMGh4pjyuAKbw7fXwB
 tgBZbSjbV2aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,325,1596524400"; 
   d="scan'208";a="351297056"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Oct 2020 13:42:52 -0700
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     tglx@linutronix.de, mingo@kernel.org, bp@suse.de, luto@kernel.org,
        x86@kernel.org
Cc:     len.brown@intel.com, dave.hansen@intel.com, jing2.liu@intel.com,
        ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, kvm@vger.kernel.org
Subject: [RFC PATCH 10/22] x86/fpu/xstate: Update xstate save function for supporting dynamic user xstate
Date:   Thu,  1 Oct 2020 13:39:01 -0700
Message-Id: <20201001203913.9125-11-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201001203913.9125-1-chang.seok.bae@intel.com>
References: <20201001203913.9125-1-chang.seok.bae@intel.com>
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
index 2dfb3b6f58fc..3b03ead87a46 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -331,9 +331,8 @@ static inline void copy_kernel_to_xregs_booting(struct xregs_state *xstate)
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
index ecec6418ccca..a8b5f507083c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8842,15 +8842,20 @@ static int complete_emulated_mmio(struct kvm_vcpu *vcpu)
 
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

