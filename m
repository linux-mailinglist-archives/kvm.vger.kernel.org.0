Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A682E1F16
	for <lists+kvm@lfdr.de>; Wed, 23 Dec 2020 17:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgLWQCV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Dec 2020 11:02:21 -0500
Received: from mga12.intel.com ([192.55.52.136]:48944 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbgLWQCV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Dec 2020 11:02:21 -0500
IronPort-SDR: xwPoBGWUZg2XWyLc25EGuOL4XI1mAGujOo/cUeIlvQhhEUaGplyCUM9cgSC6Y5LFmvZ4ei1XhT
 6peyrNV/QeCw==
X-IronPort-AV: E=McAfee;i="6000,8403,9844"; a="155241856"
X-IronPort-AV: E=Sophos;i="5.78,441,1599548400"; 
   d="scan'208";a="155241856"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2020 08:01:37 -0800
IronPort-SDR: Mouh5E+8HOjAMqrxrMRKi6kf4ZFpIpLUSQU+JXkzXANvLmiTHpGqkgH9f076/94FMfNFRDwRBC
 1D0GMurdWzkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,441,1599548400"; 
   d="scan'208";a="458027907"
Received: from chang-linux-3.sc.intel.com ([172.25.66.175])
  by fmsmga001.fm.intel.com with ESMTP; 23 Dec 2020 08:01:36 -0800
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
To:     bp@suse.de, luto@kernel.org, tglx@linutronix.de, mingo@kernel.org,
        x86@kernel.org
Cc:     len.brown@intel.com, dave.hansen@intel.com, jing2.liu@intel.com,
        ravi.v.shankar@intel.com, linux-kernel@vger.kernel.org,
        chang.seok.bae@intel.com, kvm@vger.kernel.org
Subject: [PATCH v3 01/21] x86/fpu/xstate: Modify initialization helper to handle both static and dynamic buffers
Date:   Wed, 23 Dec 2020 07:56:57 -0800
Message-Id: <20201223155717.19556-2-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201223155717.19556-1-chang.seok.bae@intel.com>
References: <20201223155717.19556-1-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation for dynamic xstate buffer expansion, update the buffer
initialization function parameters to equally handle static in-line xstate
buffer, as well as dynamically allocated xstate buffer.

init_fpstate is a special case, which is indicated by a null pointer
parameter to fpstate_init().

Also, fpstate_init_xstate() now accepts the state component bitmap to
configure XCOMP_BV for the compacted format.

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
 arch/x86/include/asm/fpu/internal.h |  6 +++---
 arch/x86/kernel/fpu/core.c          | 14 +++++++++++---
 arch/x86/kernel/fpu/init.c          |  2 +-
 arch/x86/kernel/fpu/regset.c        |  2 +-
 arch/x86/kernel/fpu/xstate.c        |  3 +--
 arch/x86/kvm/x86.c                  |  2 +-
 6 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index 8d33ad80704f..d81d8c407dc0 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -80,20 +80,20 @@ static __always_inline __pure bool use_fxsr(void)
 
 extern union fpregs_state init_fpstate;
 
-extern void fpstate_init(union fpregs_state *state);
+extern void fpstate_init(struct fpu *fpu);
 #ifdef CONFIG_MATH_EMULATION
 extern void fpstate_init_soft(struct swregs_state *soft);
 #else
 static inline void fpstate_init_soft(struct swregs_state *soft) {}
 #endif
 
-static inline void fpstate_init_xstate(struct xregs_state *xsave)
+static inline void fpstate_init_xstate(struct xregs_state *xsave, u64 xcomp_mask)
 {
 	/*
 	 * XRSTORS requires these bits set in xcomp_bv, or it will
 	 * trigger #GP:
 	 */
-	xsave->header.xcomp_bv = XCOMP_BV_COMPACTED_FORMAT | xfeatures_mask_all;
+	xsave->header.xcomp_bv = XCOMP_BV_COMPACTED_FORMAT | xcomp_mask;
 }
 
 static inline void fpstate_init_fxstate(struct fxregs_state *fx)
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index eb86a2b831b1..f23e5ffbb307 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -191,8 +191,16 @@ static inline void fpstate_init_fstate(struct fregs_state *fp)
 	fp->fos = 0xffff0000u;
 }
 
-void fpstate_init(union fpregs_state *state)
+/* A null pointer parameter indicates init_fpstate. */
+void fpstate_init(struct fpu *fpu)
 {
+	union fpregs_state *state;
+
+	if (fpu)
+		state = &fpu->state;
+	else
+		state = &init_fpstate;
+
 	if (!static_cpu_has(X86_FEATURE_FPU)) {
 		fpstate_init_soft(&state->soft);
 		return;
@@ -201,7 +209,7 @@ void fpstate_init(union fpregs_state *state)
 	memset(state, 0, fpu_kernel_xstate_size);
 
 	if (static_cpu_has(X86_FEATURE_XSAVES))
-		fpstate_init_xstate(&state->xsave);
+		fpstate_init_xstate(&state->xsave, xfeatures_mask_all);
 	if (static_cpu_has(X86_FEATURE_FXSR))
 		fpstate_init_fxstate(&state->fxsave);
 	else
@@ -261,7 +269,7 @@ static void fpu__initialize(struct fpu *fpu)
 	WARN_ON_FPU(fpu != &current->thread.fpu);
 
 	set_thread_flag(TIF_NEED_FPU_LOAD);
-	fpstate_init(&fpu->state);
+	fpstate_init(fpu);
 	trace_x86_fpu_init_state(fpu);
 }
 
diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index 701f196d7c68..74e03e3bc20f 100644
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
diff --git a/arch/x86/kernel/fpu/regset.c b/arch/x86/kernel/fpu/regset.c
index c413756ba89f..4c4d9059ff36 100644
--- a/arch/x86/kernel/fpu/regset.c
+++ b/arch/x86/kernel/fpu/regset.c
@@ -144,7 +144,7 @@ int xstateregs_set(struct task_struct *target, const struct user_regset *regset,
 	 * In case of failure, mark all states as init:
 	 */
 	if (ret)
-		fpstate_init(&fpu->state);
+		fpstate_init(fpu);
 
 	return ret;
 }
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 5d8047441a0a..1a3e5effe0fa 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -457,8 +457,7 @@ static void __init setup_init_fpu_buf(void)
 	print_xstate_features();
 
 	if (boot_cpu_has(X86_FEATURE_XSAVES))
-		init_fpstate.xsave.header.xcomp_bv = XCOMP_BV_COMPACTED_FORMAT |
-						     xfeatures_mask_all;
+		fpstate_init_xstate(&init_fpstate.xsave, xfeatures_mask_all);
 
 	/*
 	 * Init all the features state with header.xfeatures being 0x0
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e545a8a613b1..45704f106815 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9820,7 +9820,7 @@ static int sync_regs(struct kvm_vcpu *vcpu)
 
 static void fx_init(struct kvm_vcpu *vcpu)
 {
-	fpstate_init(&vcpu->arch.guest_fpu->state);
+	fpstate_init(vcpu->arch.guest_fpu);
 	if (boot_cpu_has(X86_FEATURE_XSAVES))
 		vcpu->arch.guest_fpu->state.xsave.header.xcomp_bv =
 			host_xcr0 | XSTATE_COMPACTION_ENABLED;
-- 
2.17.1

