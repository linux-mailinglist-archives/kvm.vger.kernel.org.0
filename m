Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD6D3DBB8D
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 17:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239549AbhG3PGU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 11:06:20 -0400
Received: from mga05.intel.com ([192.55.52.43]:52635 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239445AbhG3PGO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 11:06:14 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10061"; a="298699120"
X-IronPort-AV: E=Sophos;i="5.84,282,1620716400"; 
   d="scan'208";a="298699120"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2021 08:06:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,282,1620716400"; 
   d="scan'208";a="508154925"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by FMSMGA003.fm.intel.com with ESMTP; 30 Jul 2021 08:06:05 -0700
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     bp@suse.de, luto@kernel.org, tglx@linutronix.de, mingo@kernel.org,
        x86@kernel.org
Cc:     len.brown@intel.com, dave.hansen@intel.com,
        thiago.macieira@intel.com, jing2.liu@intel.com,
        ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, kvm@vger.kernel.org
Subject: [PATCH v9 09/26] x86/fpu/xstate: Update the XSTATE save function to support dynamic states
Date:   Fri, 30 Jul 2021 07:59:40 -0700
Message-Id: <20210730145957.7927-10-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210730145957.7927-1-chang.seok.bae@intel.com>
References: <20210730145957.7927-1-chang.seok.bae@intel.com>
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
index 16abc0357e2e..541628bfc8c0 100644
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
index 2f35aada2007..f70f84d53442 100644
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
index 18a337f99459..97b68c6cacd2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9890,11 +9890,16 @@ static void kvm_save_current_fpu(struct fpu *fpu)
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
 		save_fpregs_to_fpstate(fpu);
+	}
 }
 
 /* Swap (qemu) user FPU context for the guest FPU context. */
-- 
2.17.1

