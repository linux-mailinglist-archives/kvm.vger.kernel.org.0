Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F2742E49F
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 01:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234442AbhJNXL5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 19:11:57 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:45662 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234357AbhJNXLn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 19:11:43 -0400
Message-ID: <20211014230739.352041752@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634252976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=Iupuk7aJ0zvBpAgWac2JQmQ4S38b/G2vWCFaT6UOkWs=;
        b=GBIHX5QLT5q4ZSBDrNFhv3L3jUaEJrLuzG393ymJB0U6MDuFNDhY+/m8gmwmDrlsJ/imYO
        qD+XVmuB6CtAMlSq/aJnuEmwMo/mIAfRwL7vucmOroVa5jelxDLPk3t3f1vvr2tMSihcMA
        ecqgki+RTJHsjXdLqNjBAZDaCmPNXgp1iBpyPOMoIeykloEZD1Kjmgp4t8/odIgUa5k87R
        3ODAmZ+5NN1yqCzHtfTeidB8JhboFnnopOEhpkPoWCQXlK6YpdVda68cdGCcvJaW6n2lH8
        6RSzdvLQmIydlLZlJFLe583rXvNh+vclV37ObMcEkCKDRBF0MQGIkXHmsLVEwA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634252976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=Iupuk7aJ0zvBpAgWac2JQmQ4S38b/G2vWCFaT6UOkWs=;
        b=yZBUB9qaf5yFhJoePqd3E0ETPk36pclNuuQ95b7XTrCDkLoitu9XcPAiJwYFX6jNHBK69A
        Ye2G3TN+CUUPkIDg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 5/8] x86/fpu: Move xstate feature masks to fpu_*_cfg
References: <20211014225711.615197738@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 01:09:35 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the feature mask storage to the kernel and user config
structs. Default and maximum feature set are the same for now.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/fpu/xstate.h |   10 ++----
 arch/x86/kernel/fpu/core.c        |    4 +-
 arch/x86/kernel/fpu/init.c        |    2 -
 arch/x86/kernel/fpu/signal.c      |    3 +-
 arch/x86/kernel/fpu/xstate.c      |   57 +++++++++++++++++++-------------------
 5 files changed, 38 insertions(+), 38 deletions(-)

--- a/arch/x86/include/asm/fpu/xstate.h
+++ b/arch/x86/include/asm/fpu/xstate.h
@@ -78,11 +78,9 @@
 				      XFEATURE_MASK_INDEPENDENT | \
 				      XFEATURE_MASK_SUPERVISOR_UNSUPPORTED)
 
-extern u64 xfeatures_mask_all;
-
 static inline u64 xfeatures_mask_supervisor(void)
 {
-	return xfeatures_mask_all & XFEATURE_MASK_SUPERVISOR_SUPPORTED;
+	return fpu_kernel_cfg.max_features & XFEATURE_MASK_SUPERVISOR_SUPPORTED;
 }
 
 /*
@@ -91,7 +89,7 @@ static inline u64 xfeatures_mask_supervi
  */
 static inline u64 xfeatures_mask_uabi(void)
 {
-	return xfeatures_mask_all & XFEATURE_MASK_USER_SUPPORTED;
+	return fpu_kernel_cfg.max_features & XFEATURE_MASK_USER_SUPPORTED;
 }
 
 /*
@@ -102,7 +100,7 @@ static inline u64 xfeatures_mask_uabi(vo
  */
 static inline u64 xfeatures_mask_restore_user(void)
 {
-	return xfeatures_mask_all & XFEATURE_MASK_USER_RESTORE;
+	return fpu_kernel_cfg.max_features & XFEATURE_MASK_USER_RESTORE;
 }
 
 /*
@@ -111,7 +109,7 @@ static inline u64 xfeatures_mask_restore
  */
 static inline u64 xfeatures_mask_fpstate(void)
 {
-	return xfeatures_mask_all & \
+	return fpu_kernel_cfg.max_features & \
 		(XFEATURE_MASK_USER_RESTORE | XFEATURE_MASK_SUPERVISOR_SUPPORTED);
 }
 
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -337,8 +337,8 @@ void fpstate_reset(struct fpu *fpu)
 	/* Initialize sizes and feature masks */
 	fpu->fpstate->size		= fpu_kernel_cfg.default_size;
 	fpu->fpstate->user_size		= fpu_user_cfg.default_size;
-	fpu->fpstate->xfeatures		= xfeatures_mask_all;
-	fpu->fpstate->user_xfeatures	= xfeatures_mask_uabi();
+	fpu->fpstate->xfeatures		= fpu_kernel_cfg.default_features;
+	fpu->fpstate->user_xfeatures	= fpu_user_cfg.default_features;
 }
 
 #if IS_ENABLED(CONFIG_KVM)
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -211,7 +211,7 @@ static void __init fpu__init_init_fpstat
 {
 	/* Bring init_fpstate size and features up to date */
 	init_fpstate.size		= fpu_kernel_cfg.max_size;
-	init_fpstate.xfeatures		= xfeatures_mask_all;
+	init_fpstate.xfeatures		= fpu_kernel_cfg.max_features;
 }
 
 /*
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -409,7 +409,8 @@ static bool __fpu_restore_sig(void __use
 		u64 mask = user_xfeatures | xfeatures_mask_supervisor();
 
 		fpregs->xsave.header.xfeatures &= mask;
-		success = !os_xrstor_safe(&fpregs->xsave, xfeatures_mask_all);
+		success = !os_xrstor_safe(&fpregs->xsave,
+					  fpu_kernel_cfg.max_features);
 	} else {
 		success = !fxrstor_safe(&fpregs->fxsave);
 	}
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -62,12 +62,6 @@ static short xsave_cpuid_features[] __in
 	X86_FEATURE_ENQCMD,
 };
 
-/*
- * This represents the full set of bits that should ever be set in a kernel
- * XSAVE buffer, both supervisor and user xstates.
- */
-u64 xfeatures_mask_all __ro_after_init;
-
 static unsigned int xstate_offsets[XFEATURE_MAX] __ro_after_init =
 	{ [ 0 ... XFEATURE_MAX - 1] = -1};
 static unsigned int xstate_sizes[XFEATURE_MAX] __ro_after_init =
@@ -84,7 +78,7 @@ static unsigned int xstate_supervisor_on
  */
 int cpu_has_xfeatures(u64 xfeatures_needed, const char **feature_name)
 {
-	u64 xfeatures_missing = xfeatures_needed & ~xfeatures_mask_all;
+	u64 xfeatures_missing = xfeatures_needed & ~fpu_kernel_cfg.max_features;
 
 	if (unlikely(feature_name)) {
 		long xfeature_idx, max_idx;
@@ -134,7 +128,7 @@ static bool xfeature_is_supervisor(int x
  */
 void fpu__init_cpu_xstate(void)
 {
-	if (!boot_cpu_has(X86_FEATURE_XSAVE) || !xfeatures_mask_all)
+	if (!boot_cpu_has(X86_FEATURE_XSAVE) || !fpu_kernel_cfg.max_features)
 		return;
 
 	cr4_set_bits(X86_CR4_OSXSAVE);
@@ -144,7 +138,7 @@ void fpu__init_cpu_xstate(void)
 	 * managed by XSAVE{C, OPT, S} and XRSTOR{S}.  Only XSAVE user
 	 * states can be set here.
 	 */
-	xsetbv(XCR_XFEATURE_ENABLED_MASK, xfeatures_mask_uabi());
+	xsetbv(XCR_XFEATURE_ENABLED_MASK, fpu_user_cfg.max_features);
 
 	/*
 	 * MSR_IA32_XSS sets supervisor states managed by XSAVES.
@@ -157,7 +151,7 @@ void fpu__init_cpu_xstate(void)
 
 static bool xfeature_enabled(enum xfeature xfeature)
 {
-	return xfeatures_mask_all & BIT_ULL(xfeature);
+	return fpu_kernel_cfg.max_features & BIT_ULL(xfeature);
 }
 
 /*
@@ -183,7 +177,7 @@ static void __init setup_xstate_features
 	xstate_sizes[XFEATURE_SSE]	= sizeof_field(struct fxregs_state,
 						       xmm_space);
 
-	for_each_extended_xfeature(i, xfeatures_mask_all) {
+	for_each_extended_xfeature(i, fpu_kernel_cfg.max_features) {
 		cpuid_count(XSTATE_CPUID, i, &eax, &ebx, &ecx, &edx);
 
 		xstate_sizes[i] = eax;
@@ -288,14 +282,14 @@ static void __init setup_xstate_comp_off
 						     xmm_space);
 
 	if (!cpu_feature_enabled(X86_FEATURE_XSAVES)) {
-		for_each_extended_xfeature(i, xfeatures_mask_all)
+		for_each_extended_xfeature(i, fpu_kernel_cfg.max_features)
 			xstate_comp_offsets[i] = xstate_offsets[i];
 		return;
 	}
 
 	next_offset = FXSAVE_SIZE + XSAVE_HDR_SIZE;
 
-	for_each_extended_xfeature(i, xfeatures_mask_all) {
+	for_each_extended_xfeature(i, fpu_kernel_cfg.max_features) {
 		if (xfeature_is_aligned(i))
 			next_offset = ALIGN(next_offset, 64);
 
@@ -319,7 +313,7 @@ static void __init setup_supervisor_only
 
 	next_offset = FXSAVE_SIZE + XSAVE_HDR_SIZE;
 
-	for_each_extended_xfeature(i, xfeatures_mask_all) {
+	for_each_extended_xfeature(i, fpu_kernel_cfg.max_features) {
 		if (!xfeature_is_supervisor(i))
 			continue;
 
@@ -338,7 +332,7 @@ static void __init print_xstate_offset_s
 {
 	int i;
 
-	for_each_extended_xfeature(i, xfeatures_mask_all) {
+	for_each_extended_xfeature(i, fpu_kernel_cfg.max_features) {
 		pr_info("x86/fpu: xstate_offset[%d]: %4d, xstate_sizes[%d]: %4d\n",
 			 i, xstate_comp_offsets[i], i, xstate_sizes[i]);
 	}
@@ -401,7 +395,7 @@ static void __init setup_init_fpu_buf(vo
 	setup_xstate_features();
 	print_xstate_features();
 
-	xstate_init_xcomp_bv(&init_fpstate.regs.xsave, xfeatures_mask_all);
+	xstate_init_xcomp_bv(&init_fpstate.regs.xsave, fpu_kernel_cfg.max_features);
 
 	/*
 	 * Init all the features state with header.xfeatures being 0x0
@@ -570,7 +564,7 @@ static bool __init paranoid_xstate_size_
 	unsigned int size = FXSAVE_SIZE + XSAVE_HDR_SIZE;
 	int i;
 
-	for_each_extended_xfeature(i, xfeatures_mask_all) {
+	for_each_extended_xfeature(i, fpu_kernel_cfg.max_features) {
 		if (!check_xstate_against_struct(i))
 			return false;
 		/*
@@ -724,7 +718,7 @@ static int __init init_xstate_size(void)
  */
 static void __init fpu__init_disable_system_xstate(unsigned int legacy_size)
 {
-	xfeatures_mask_all = 0;
+	fpu_kernel_cfg.max_features = 0;
 	cr4_clear_bits(X86_CR4_OSXSAVE);
 	setup_clear_cpu_cap(X86_FEATURE_XSAVE);
 
@@ -768,13 +762,13 @@ void __init fpu__init_system_xstate(unsi
 	 * Find user xstates supported by the processor.
 	 */
 	cpuid_count(XSTATE_CPUID, 0, &eax, &ebx, &ecx, &edx);
-	xfeatures_mask_all = eax + ((u64)edx << 32);
+	fpu_kernel_cfg.max_features = eax + ((u64)edx << 32);
 
 	/*
 	 * Find supervisor xstates supported by the processor.
 	 */
 	cpuid_count(XSTATE_CPUID, 1, &eax, &ebx, &ecx, &edx);
-	xfeatures_mask_all |= ecx + ((u64)edx << 32);
+	fpu_kernel_cfg.max_features |= ecx + ((u64)edx << 32);
 
 	if ((xfeatures_mask_uabi() & XFEATURE_MASK_FPSSE) != XFEATURE_MASK_FPSSE) {
 		/*
@@ -783,7 +777,7 @@ void __init fpu__init_system_xstate(unsi
 		 * booting without it.  This is too early to BUG().
 		 */
 		pr_err("x86/fpu: FP/SSE not present amongst the CPU's xstate features: 0x%llx.\n",
-		       xfeatures_mask_all);
+		       fpu_kernel_cfg.max_features);
 		goto out_disable;
 	}
 
@@ -792,14 +786,21 @@ void __init fpu__init_system_xstate(unsi
 	 */
 	for (i = 0; i < ARRAY_SIZE(xsave_cpuid_features); i++) {
 		if (!boot_cpu_has(xsave_cpuid_features[i]))
-			xfeatures_mask_all &= ~BIT_ULL(i);
+			fpu_kernel_cfg.max_features &= ~BIT_ULL(i);
 	}
 
-	xfeatures_mask_all &= XFEATURE_MASK_USER_SUPPORTED |
+	fpu_kernel_cfg.max_features &= XFEATURE_MASK_USER_SUPPORTED |
 			      XFEATURE_MASK_SUPERVISOR_SUPPORTED;
 
+	fpu_user_cfg.max_features = fpu_kernel_cfg.max_features;
+	fpu_user_cfg.max_features &= XFEATURE_MASK_USER_SUPPORTED;
+
+	/* Identical for now */
+	fpu_kernel_cfg.default_features = fpu_kernel_cfg.max_features;
+	fpu_user_cfg.default_features = fpu_user_cfg.max_features;
+
 	/* Store it for paranoia check at the end */
-	xfeatures = xfeatures_mask_all;
+	xfeatures = fpu_kernel_cfg.max_features;
 
 	/* Enable xstate instructions to be able to continue with initialization: */
 	fpu__init_cpu_xstate();
@@ -825,15 +826,15 @@ void __init fpu__init_system_xstate(unsi
 	 * Paranoia check whether something in the setup modified the
 	 * xfeatures mask.
 	 */
-	if (xfeatures != xfeatures_mask_all) {
+	if (xfeatures != fpu_kernel_cfg.max_features) {
 		pr_err("x86/fpu: xfeatures modified from 0x%016llx to 0x%016llx during init, disabling XSAVE\n",
-		       xfeatures, xfeatures_mask_all);
+		       xfeatures, fpu_kernel_cfg.max_features);
 		goto out_disable;
 	}
 
 	print_xstate_offset_size();
 	pr_info("x86/fpu: Enabled xstate features 0x%llx, context size is %d bytes, using '%s' format.\n",
-		xfeatures_mask_all,
+		fpu_kernel_cfg.max_features,
 		fpu_kernel_cfg.max_size,
 		boot_cpu_has(X86_FEATURE_XSAVES) ? "compacted" : "standard");
 	return;
@@ -908,7 +909,7 @@ void *get_xsave_addr(struct xregs_state
 	 * We should not ever be requesting features that we
 	 * have not enabled.
 	 */
-	WARN_ONCE(!(xfeatures_mask_all & BIT_ULL(xfeature_nr)),
+	WARN_ONCE(!(fpu_kernel_cfg.max_features & BIT_ULL(xfeature_nr)),
 		  "get of unsupported state");
 	/*
 	 * This assumes the last 'xsave*' instruction to

