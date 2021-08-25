Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B47843F7990
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 18:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241255AbhHYQBY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 12:01:24 -0400
Received: from mga14.intel.com ([192.55.52.115]:15524 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241181AbhHYQBX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 12:01:23 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10087"; a="217271037"
X-IronPort-AV: E=Sophos;i="5.84,351,1620716400"; 
   d="scan'208";a="217271037"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2021 09:00:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,351,1620716400"; 
   d="scan'208";a="494317164"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by fmsmga008.fm.intel.com with ESMTP; 25 Aug 2021 09:00:36 -0700
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     bp@suse.de, luto@kernel.org, tglx@linutronix.de, mingo@kernel.org,
        x86@kernel.org
Cc:     len.brown@intel.com, lenb@kernel.org, dave.hansen@intel.com,
        thiago.macieira@intel.com, jing2.liu@intel.com,
        ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, kvm@vger.kernel.org
Subject: [PATCH v10 02/28] x86/fpu/xstate: Modify the initialization helper to handle both static and dynamic buffers
Date:   Wed, 25 Aug 2021 08:53:47 -0700
Message-Id: <20210825155413.19673-3-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210825155413.19673-1-chang.seok.bae@intel.com>
References: <20210825155413.19673-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Have the function initializing the XSTATE buffer take a struct fpu *
pointer in preparation for dynamic state buffer support.

init_fpstate is a special case, which is indicated by a null pointer
parameter to fpstate_init().

Also, fpstate_init_xstate() now accepts the state component bitmap to
customize the compacted format.

No functional change.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Reviewed-by: Len Brown <len.brown@intel.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
---
Changes from v5:
* Moved fpstate_init_xstate() back to the header (again).
* Massaged the changelog.

Changes from v4:
* Added a proper function description. (Borislav Petkov)
* Added the likely() statement as a null pointer is a special case.

Changes from v3:
* Updated the changelog. (Borislav Petkov)
* Updated the function comment to use kernel-doc style. (Borislav Petkov)

Changes from v2:
* Updated the changelog with task->fpu removed. (Borislav Petkov)
---
 arch/x86/include/asm/fpu/internal.h | 11 ++++++++++-
 arch/x86/kernel/fpu/core.c          | 28 +++++++++++++++++-----------
 arch/x86/kernel/fpu/init.c          |  2 +-
 arch/x86/kernel/fpu/xstate.c        |  3 +--
 arch/x86/kvm/x86.c                  |  2 +-
 5 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index 5a18694a89b2..c7a64e2806a9 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -80,7 +80,7 @@ static __always_inline __pure bool use_fxsr(void)
 
 extern union fpregs_state init_fpstate;
 
-extern void fpstate_init(union fpregs_state *state);
+extern void fpstate_init(struct fpu *fpu);
 #ifdef CONFIG_MATH_EMULATION
 extern void fpstate_init_soft(struct swregs_state *soft);
 #else
@@ -88,6 +88,15 @@ static inline void fpstate_init_soft(struct swregs_state *soft) {}
 #endif
 extern void save_fpregs_to_fpstate(struct fpu *fpu);
 
+static inline void fpstate_init_xstate(struct xregs_state *xsave, u64 mask)
+{
+	/*
+	 * XRSTORS requires these bits set in xcomp_bv, or it will
+	 * trigger #GP:
+	 */
+	xsave->header.xcomp_bv = XCOMP_BV_COMPACTED_FORMAT | mask;
+}
+
 /* Returns 0 or the negated trap number, which results in -EFAULT for #PF */
 #define user_insn(insn, output, input...)				\
 ({									\
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 7ada7bd03a32..c0098f8422de 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -203,15 +203,6 @@ void fpu_sync_fpstate(struct fpu *fpu)
 	fpregs_unlock();
 }
 
-static inline void fpstate_init_xstate(struct xregs_state *xsave)
-{
-	/*
-	 * XRSTORS requires these bits set in xcomp_bv, or it will
-	 * trigger #GP:
-	 */
-	xsave->header.xcomp_bv = XCOMP_BV_COMPACTED_FORMAT | xfeatures_mask_all;
-}
-
 static inline void fpstate_init_fxstate(struct fxregs_state *fx)
 {
 	fx->cwd = 0x37f;
@@ -229,8 +220,23 @@ static inline void fpstate_init_fstate(struct fregs_state *fp)
 	fp->fos = 0xffff0000u;
 }
 
-void fpstate_init(union fpregs_state *state)
+/**
+ *
+ * fpstate_init - initialize the xstate buffer
+ *
+ * If @fpu is NULL, initialize init_fpstate.
+ *
+ * @fpu:	A struct fpu * pointer
+ */
+void fpstate_init(struct fpu *fpu)
 {
+	union fpregs_state *state;
+
+	if (likely(fpu))
+		state = &fpu->state;
+	else
+		state = &init_fpstate;
+
 	if (!static_cpu_has(X86_FEATURE_FPU)) {
 		fpstate_init_soft(&state->soft);
 		return;
@@ -239,7 +245,7 @@ void fpstate_init(union fpregs_state *state)
 	memset(state, 0, fpu_kernel_xstate_size);
 
 	if (static_cpu_has(X86_FEATURE_XSAVES))
-		fpstate_init_xstate(&state->xsave);
+		fpstate_init_xstate(&state->xsave, xfeatures_mask_all);
 	if (static_cpu_has(X86_FEATURE_FXSR))
 		fpstate_init_fxstate(&state->fxsave);
 	else
diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index 64e29927cc32..e14c72bc8706 100644
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -124,7 +124,7 @@ static void __init fpu__init_system_generic(void)
 	 * Set up the legacy init FPU context. (xstate init might overwrite this
 	 * with a more modern format, if the CPU supports it.)
 	 */
-	fpstate_init(&init_fpstate);
+	fpstate_init(NULL);
 
 	fpu__init_system_mxcsr();
 }
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index fc1d529547e6..0fed7fbcf2e8 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -395,8 +395,7 @@ static void __init setup_init_fpu_buf(void)
 	print_xstate_features();
 
 	if (boot_cpu_has(X86_FEATURE_XSAVES))
-		init_fpstate.xsave.header.xcomp_bv = XCOMP_BV_COMPACTED_FORMAT |
-						     xfeatures_mask_all;
+		fpstate_init_xstate(&init_fpstate.xsave, xfeatures_mask_all);
 
 	/*
 	 * Init all the features state with header.xfeatures being 0x0
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e5d5c5ed7dd4..ce529ab233d7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10608,7 +10608,7 @@ static void fx_init(struct kvm_vcpu *vcpu)
 	if (!vcpu->arch.guest_fpu)
 		return;
 
-	fpstate_init(&vcpu->arch.guest_fpu->state);
+	fpstate_init(vcpu->arch.guest_fpu);
 	if (boot_cpu_has(X86_FEATURE_XSAVES))
 		vcpu->arch.guest_fpu->state.xsave.header.xcomp_bv =
 			host_xcr0 | XSTATE_COMPACTION_ENABLED;
-- 
2.17.1

