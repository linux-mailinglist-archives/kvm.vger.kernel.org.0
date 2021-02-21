Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89EE7320CEE
	for <lists+kvm@lfdr.de>; Sun, 21 Feb 2021 20:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbhBUTCg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Feb 2021 14:02:36 -0500
Received: from mga05.intel.com ([192.55.52.43]:37166 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230367AbhBUTCZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Feb 2021 14:02:25 -0500
IronPort-SDR: 59xFBacYzbb9wdU7IS87r6C8h6Cj3NQLkr6UMX0QPcDiP0DywybOrsT+DtFGsHZ1x8ilvyPe1y
 TzHWhr9LmkmA==
X-IronPort-AV: E=McAfee;i="6000,8403,9902"; a="269192147"
X-IronPort-AV: E=Sophos;i="5.81,195,1610438400"; 
   d="scan'208";a="269192147"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2021 11:01:28 -0800
IronPort-SDR: riq+h46S09FTbJHO5p9lO8+QrLt8W77mBhOmjYEuMC7CknxpTiKXsngWDVR6DIPq4DutOMlcc5
 glep/+dFJAXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,195,1610438400"; 
   d="scan'208";a="429792111"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Feb 2021 11:01:27 -0800
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     bp@suse.de, luto@kernel.org, tglx@linutronix.de, mingo@kernel.org,
        x86@kernel.org
Cc:     len.brown@intel.com, dave.hansen@intel.com, jing2.liu@intel.com,
        ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, kvm@vger.kernel.org
Subject: [PATCH v4 11/22] x86/fpu/xstate: Update the xstate save function to support dynamic states
Date:   Sun, 21 Feb 2021 10:56:26 -0800
Message-Id: <20210221185637.19281-12-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210221185637.19281-1-chang.seok.bae@intel.com>
References: <20210221185637.19281-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extend copy_xregs_to_kernel() to receive a mask argument of which states to
save, in preparation for dynamic user state handling.

Update KVM to set a valid fpu->state_mask, so it can continue to share with
the core code.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Reviewed-by: Len Brown <len.brown@intel.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
---
Changes from v3:
* Updated the changelog. (Borislav Petkov)
* Made the code change more reviewable.

Changes from v2:
* Updated the changelog to clarify the KVM code changes.
---
 arch/x86/include/asm/fpu/internal.h | 3 +--
 arch/x86/kernel/fpu/core.c          | 2 +-
 arch/x86/kvm/x86.c                  | 9 +++++++--
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index e4afc1831e29..f964f3efc92e 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -317,9 +317,8 @@ static inline void copy_kernel_to_xregs_booting(struct xregs_state *xstate)
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
index dc20eabb072d..ad1ac80f98ef 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -98,7 +98,7 @@ EXPORT_SYMBOL(irq_fpu_usable);
 int copy_fpregs_to_fpstate(struct fpu *fpu)
 {
 	if (likely(use_xsave())) {
-		copy_xregs_to_kernel(&fpu->state->xsave);
+		copy_xregs_to_kernel(&fpu->state->xsave, fpu->state_mask);
 
 		/*
 		 * AVX512 state is tracked here because its use is
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c10122547ecd..ca2c0574acf2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9275,11 +9275,16 @@ static void kvm_save_current_fpu(struct fpu *fpu)
 	 * KVM does not support dynamic user states yet. Assume the buffer
 	 * always has the minimum size.
 	 */
-	if (test_thread_flag(TIF_NEED_FPU_LOAD))
+	if (test_thread_flag(TIF_NEED_FPU_LOAD)) {
 		memcpy(fpu->state, current->thread.fpu.state,
 		       get_xstate_config(XSTATE_MIN_SIZE));
-	else
+	} else {
+		struct fpu *src_fpu = &current->thread.fpu;
+
+		if (fpu->state_mask != src_fpu->state_mask)
+			fpu->state_mask = src_fpu->state_mask;
 		copy_fpregs_to_fpstate(fpu);
+	}
 }
 
 /* Swap (qemu) user FPU context for the guest FPU context. */
-- 
2.17.1

