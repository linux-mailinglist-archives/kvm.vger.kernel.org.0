Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A211341F790
	for <lists+kvm@lfdr.de>; Sat,  2 Oct 2021 00:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356062AbhJAWqV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 18:46:21 -0400
Received: from mga17.intel.com ([192.55.52.151]:38076 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230357AbhJAWqL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 18:46:11 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10124"; a="205756636"
X-IronPort-AV: E=Sophos;i="5.85,340,1624345200"; 
   d="scan'208";a="205756636"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2021 15:44:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,340,1624345200"; 
   d="scan'208";a="565343988"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by fmsmga002.fm.intel.com with ESMTP; 01 Oct 2021 15:44:15 -0700
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     bp@suse.de, luto@kernel.org, tglx@linutronix.de, mingo@kernel.org,
        x86@kernel.org
Cc:     len.brown@intel.com, lenb@kernel.org, dave.hansen@intel.com,
        thiago.macieira@intel.com, jing2.liu@intel.com,
        ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, kvm@vger.kernel.org
Subject: [PATCH v11 10/29] x86/fpu/xstate: Update the XSTATE save function to support dynamic states
Date:   Fri,  1 Oct 2021 15:37:09 -0700
Message-Id: <20211001223728.9309-11-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211001223728.9309-1-chang.seok.bae@intel.com>
References: <20211001223728.9309-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extend os_xsave() to receive a mask argument of which states to save, in
preparation for dynamic user state handling.

Update KVM to set a valid fpu->state_mask, so it can continue to share with
the core code.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Reviewed-by: Len Brown <len.brown@intel.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
---
Changes from v5:
* Adjusted the changelog and code for the new base code.

Changes from v3:
* Updated the changelog. (Borislav Petkov)
* Made the code change more reviewable.

Changes from v2:
* Updated the changelog to clarify the KVM code changes.
---
 arch/x86/include/asm/fpu/internal.h | 3 +--
 arch/x86/kernel/fpu/core.c          | 2 +-
 arch/x86/kernel/fpu/signal.c        | 2 +-
 arch/x86/kvm/x86.c                  | 9 +++++++--
 4 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index d2fc19c0e457..263e349ff85a 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -298,9 +298,8 @@ static inline void os_xrstor_booting(struct xregs_state *xstate)
  * Uses either XSAVE or XSAVEOPT or XSAVES depending on the CPU features
  * and command line options. The choice is permanent until the next reboot.
  */
-static inline void os_xsave(struct xregs_state *xstate)
+static inline void os_xsave(struct xregs_state *xstate, u64 mask)
 {
-	u64 mask = xfeatures_mask_all;
 	u32 lmask = mask;
 	u32 hmask = mask >> 32;
 	int err;
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 2941d03912db..164e75c37dbb 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -99,7 +99,7 @@ EXPORT_SYMBOL(irq_fpu_usable);
 void save_fpregs_to_fpstate(struct fpu *fpu)
 {
 	if (likely(use_xsave())) {
-		os_xsave(&fpu->state->xsave);
+		os_xsave(&fpu->state->xsave, fpu->state_mask);
 
 		/*
 		 * AVX512 state is tracked here because its use is
diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 8b333b1a4d07..fe2732db6d6b 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -365,7 +365,7 @@ static int __fpu_restore_sig(void __user *buf, void __user *buf_fx,
 		 * the right place in memory. It's ia32 mode. Shrug.
 		 */
 		if (xfeatures_mask_supervisor())
-			os_xsave(&fpu->state->xsave);
+			os_xsave(&fpu->state->xsave, fpu->state_mask);
 		set_thread_flag(TIF_NEED_FPU_LOAD);
 	}
 	__fpu_invalidate_fpregs_state(fpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7c6dcc21e962..b0de53f4e5e9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9908,11 +9908,16 @@ static void kvm_save_current_fpu(struct fpu *fpu)
 	 * KVM does not support dynamic user states yet. Assume the buffer
 	 * always has the minimum size.
 	 */
-	if (test_thread_flag(TIF_NEED_FPU_LOAD))
+	if (test_thread_flag(TIF_NEED_FPU_LOAD)) {
 		memcpy(fpu->state, current->thread.fpu.state,
 		       fpu_buf_cfg.min_size);
-	else
+	} else {
+		struct fpu *src_fpu = &current->thread.fpu;
+
+		if (fpu->state_mask != src_fpu->state_mask)
+			fpu->state_mask = src_fpu->state_mask;
 		save_fpregs_to_fpstate(fpu);
+	}
 }
 
 /* Swap (qemu) user FPU context for the guest FPU context. */
-- 
2.17.1

