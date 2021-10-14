Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BACF42E4A4
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 01:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234427AbhJNXMD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 19:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234351AbhJNXLm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 19:11:42 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC86C061753;
        Thu, 14 Oct 2021 16:09:36 -0700 (PDT)
Message-ID: <20211014230739.296830097@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634252974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=3R+u38TW/8EzeINdAnoi+SOFILANDSR/nFwamEbZoiw=;
        b=q1aT23Hp/4MnDLRU1zpKhugWb3GQkiTBwXRNT5BIgZHb58fCOjE78KxWvJjZPrPdzhDCG0
        n/HtRwAWN/6TTszB/MuNFyQJEuZZ32YkSABhl39yY2wd2JXRNHZiMfmlMuj4ExsdZ9j5xA
        DWBUTNRgjPP2yf0deMNoPXdK8VIqzeMqSwn79B/0zsUQlVVvlAX4zDZP6261JaI+wCj3J8
        QufAtcGKRL+h2k8EkGZ2D4PxMrDXAoQIFKJkUYGCEQ8tC/G+iRJP1OyAci2Tk0QfGBAJw9
        VFW1bGLOiBhJ0286L7DqgP4pHCyY6KcG4Vx8oGOly8eRM5eC/Ga2eQsM8NotkQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634252974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=3R+u38TW/8EzeINdAnoi+SOFILANDSR/nFwamEbZoiw=;
        b=BlPY2MTGoM4lGxl0NEvxSYbTZKJ/B8I4Z+ptt4AiU/leIUAyD2buYfVrElnaYTWGi5hlvL
        4uFw1sAuC2CaudDg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 4/8] x86/fpu: Move xstate size to fpu_*_cfg
References: <20211014225711.615197738@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 01:09:34 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the new kernel and user space config storage to store and retrieve the
XSTATE buffer sizes. The default and the maximum size are the same for now,
but will change when support for dynamically enabled features is added.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/fpu/core.c     |    8 ++++----
 arch/x86/kernel/fpu/init.c     |   31 ++++++++++++++-----------------
 arch/x86/kernel/fpu/internal.h |    2 --
 arch/x86/kernel/fpu/regset.c   |    2 +-
 arch/x86/kernel/fpu/signal.c   |    6 +++---
 arch/x86/kernel/fpu/xstate.c   |   32 ++++++++++++++++++--------------
 arch/x86/kernel/fpu/xstate.h   |    2 +-
 7 files changed, 41 insertions(+), 42 deletions(-)

--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -298,7 +298,7 @@ void fpu_sync_fpstate(struct fpu *fpu)
 static inline unsigned int init_fpstate_copy_size(void)
 {
 	if (!use_xsave())
-		return fpu_kernel_xstate_size;
+		return fpu_kernel_cfg.default_size;
 
 	/* XSAVE(S) just needs the legacy and the xstate header part */
 	return sizeof(init_fpstate.regs.xsave);
@@ -347,8 +347,8 @@ void fpstate_reset(struct fpu *fpu)
 	fpu->fpstate = &fpu->__fpstate;
 
 	/* Initialize sizes and feature masks */
-	fpu->fpstate->size		= fpu_kernel_xstate_size;
-	fpu->fpstate->user_size		= fpu_user_xstate_size;
+	fpu->fpstate->size		= fpu_kernel_cfg.default_size;
+	fpu->fpstate->user_size		= fpu_user_cfg.default_size;
 	fpu->fpstate->xfeatures		= xfeatures_mask_all;
 	fpu->fpstate->user_xfeatures	= xfeatures_mask_uabi();
 }
@@ -420,7 +420,7 @@ int fpu_clone(struct task_struct *dst)
 void fpu_thread_struct_whitelist(unsigned long *offset, unsigned long *size)
 {
 	*offset = offsetof(struct thread_struct, fpu.__fpstate.regs);
-	*size = fpu_kernel_xstate_size;
+	*size = fpu_kernel_cfg.default_size;
 }
 
 /*
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -133,14 +133,6 @@ static void __init fpu__init_system_gene
 	fpu__init_system_mxcsr();
 }
 
-/*
- * Size of the FPU context state. All tasks in the system use the
- * same context size, regardless of what portion they use.
- * This is inherent to the XSAVE architecture which puts all state
- * components into a single, continuous memory block:
- */
-unsigned int fpu_kernel_xstate_size __ro_after_init;
-
 /* Get alignment of the TYPE. */
 #define TYPE_ALIGN(TYPE) offsetof(struct { char x; TYPE test; }, test)
 
@@ -171,7 +163,7 @@ static void __init fpu__init_task_struct
 	 * Add back the dynamically-calculated register state
 	 * size.
 	 */
-	task_size += fpu_kernel_xstate_size;
+	task_size += fpu_kernel_cfg.default_size;
 
 	/*
 	 * We dynamically size 'struct fpu', so we require that
@@ -195,25 +187,30 @@ static void __init fpu__init_task_struct
  */
 static void __init fpu__init_system_xstate_size_legacy(void)
 {
+	unsigned int size;
+
 	/*
-	 * Note that xstate sizes might be overwritten later during
-	 * fpu__init_system_xstate().
+	 * Note that the size configuration might be overwritten later
+	 * during fpu__init_system_xstate().
 	 */
 	if (!cpu_feature_enabled(X86_FEATURE_FPU))
-		fpu_kernel_xstate_size = sizeof(struct swregs_state);
+		size = sizeof(struct swregs_state);
 	else if (cpu_feature_enabled(X86_FEATURE_FXSR))
-		fpu_kernel_xstate_size = sizeof(struct fxregs_state);
+		size = sizeof(struct fxregs_state);
 	else
-		fpu_kernel_xstate_size = sizeof(struct fregs_state);
+		size = sizeof(struct fregs_state);
 
-	fpu_user_xstate_size = fpu_kernel_xstate_size;
+	fpu_kernel_cfg.max_size = size;
+	fpu_kernel_cfg.default_size = size;
+	fpu_user_cfg.max_size = size;
+	fpu_user_cfg.default_size = size;
 	fpstate_reset(&current->thread.fpu);
 }
 
 static void __init fpu__init_init_fpstate(void)
 {
 	/* Bring init_fpstate size and features up to date */
-	init_fpstate.size		= fpu_kernel_xstate_size;
+	init_fpstate.size		= fpu_kernel_cfg.max_size;
 	init_fpstate.xfeatures		= xfeatures_mask_all;
 }
 
@@ -234,7 +231,7 @@ void __init fpu__init_system(struct cpui
 
 	fpu__init_system_generic();
 	fpu__init_system_xstate_size_legacy();
-	fpu__init_system_xstate();
+	fpu__init_system_xstate(fpu_kernel_cfg.max_size);
 	fpu__init_task_struct_size();
 	fpu__init_init_fpstate();
 }
--- a/arch/x86/kernel/fpu/internal.h
+++ b/arch/x86/kernel/fpu/internal.h
@@ -2,8 +2,6 @@
 #ifndef __X86_KERNEL_FPU_INTERNAL_H
 #define __X86_KERNEL_FPU_INTERNAL_H
 
-extern unsigned int fpu_kernel_xstate_size;
-extern unsigned int fpu_user_xstate_size;
 extern struct fpstate init_fpstate;
 
 /* CPU feature check wrappers */
--- a/arch/x86/kernel/fpu/regset.c
+++ b/arch/x86/kernel/fpu/regset.c
@@ -153,7 +153,7 @@ int xstateregs_set(struct task_struct *t
 	/*
 	 * A whole standard-format XSAVE buffer is needed:
 	 */
-	if (pos != 0 || count != fpu_user_xstate_size)
+	if (pos != 0 || count != fpu_user_cfg.max_size)
 		return -EFAULT;
 
 	if (!kbuf) {
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -503,7 +503,7 @@ fpu__alloc_mathframe(unsigned long sp, i
 
 unsigned long __init fpu__get_fpstate_size(void)
 {
-	unsigned long ret = fpu_user_xstate_size;
+	unsigned long ret = fpu_user_cfg.max_size;
 
 	if (use_xsave())
 		ret += FP_XSTATE_MAGIC2_SIZE;
@@ -531,12 +531,12 @@ unsigned long __init fpu__get_fpstate_si
  */
 void __init fpu__init_prepare_fx_sw_frame(void)
 {
-	int size = fpu_user_xstate_size + FP_XSTATE_MAGIC2_SIZE;
+	int size = fpu_user_cfg.default_size + FP_XSTATE_MAGIC2_SIZE;
 
 	fx_sw_reserved.magic1 = FP_XSTATE_MAGIC1;
 	fx_sw_reserved.extended_size = size;
 	fx_sw_reserved.xfeatures = xfeatures_mask_uabi();
-	fx_sw_reserved.xstate_size = fpu_user_xstate_size;
+	fx_sw_reserved.xstate_size = fpu_user_cfg.default_size;
 
 	if (IS_ENABLED(CONFIG_IA32_EMULATION) ||
 	    IS_ENABLED(CONFIG_X86_32)) {
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -78,13 +78,6 @@ static unsigned int xstate_supervisor_on
 	{ [ 0 ... XFEATURE_MAX - 1] = -1};
 
 /*
- * The XSAVE area of kernel can be in standard or compacted format;
- * it is always in standard format for user mode. This is the user
- * mode standard format size used for signal and ptrace frames.
- */
-unsigned int fpu_user_xstate_size __ro_after_init;
-
-/*
  * Return whether the system supports a given xfeature.
  *
  * Also return the name of the (most advanced) feature that the caller requested:
@@ -716,8 +709,11 @@ static int __init init_xstate_size(void)
 	if (!paranoid_xstate_size_valid(kernel_size))
 		return -EINVAL;
 
-	fpu_kernel_xstate_size = kernel_size;
-	fpu_user_xstate_size = user_size;
+	/* Keep it the same for now */
+	fpu_kernel_cfg.max_size = kernel_size;
+	fpu_kernel_cfg.default_size = kernel_size;
+	fpu_user_cfg.max_size = user_size;
+	fpu_user_cfg.default_size = user_size;
 
 	return 0;
 }
@@ -726,11 +722,18 @@ static int __init init_xstate_size(void)
  * We enabled the XSAVE hardware, but something went wrong and
  * we can not use it.  Disable it.
  */
-static void __init fpu__init_disable_system_xstate(void)
+static void __init fpu__init_disable_system_xstate(unsigned int legacy_size)
 {
 	xfeatures_mask_all = 0;
 	cr4_clear_bits(X86_CR4_OSXSAVE);
 	setup_clear_cpu_cap(X86_FEATURE_XSAVE);
+
+	/* Restore the legacy size.*/
+	fpu_kernel_cfg.max_size = legacy_size;
+	fpu_kernel_cfg.default_size = legacy_size;
+	fpu_user_cfg.max_size = legacy_size;
+	fpu_user_cfg.default_size = legacy_size;
+
 	fpstate_reset(&current->thread.fpu);
 }
 
@@ -738,7 +741,7 @@ static void __init fpu__init_disable_sys
  * Enable and initialize the xsave feature.
  * Called once per system bootup.
  */
-void __init fpu__init_system_xstate(void)
+void __init fpu__init_system_xstate(unsigned int legacy_size)
 {
 	unsigned int eax, ebx, ecx, edx;
 	u64 xfeatures;
@@ -810,7 +813,8 @@ void __init fpu__init_system_xstate(void
 	 * Update info used for ptrace frames; use standard-format size and no
 	 * supervisor xstates:
 	 */
-	update_regset_xstate_info(fpu_user_xstate_size, xfeatures_mask_uabi());
+	update_regset_xstate_info(fpu_user_cfg.max_size,
+				  xfeatures_mask_uabi());
 
 	fpu__init_prepare_fx_sw_frame();
 	setup_init_fpu_buf();
@@ -830,13 +834,13 @@ void __init fpu__init_system_xstate(void
 	print_xstate_offset_size();
 	pr_info("x86/fpu: Enabled xstate features 0x%llx, context size is %d bytes, using '%s' format.\n",
 		xfeatures_mask_all,
-		fpu_kernel_xstate_size,
+		fpu_kernel_cfg.max_size,
 		boot_cpu_has(X86_FEATURE_XSAVES) ? "compacted" : "standard");
 	return;
 
 out_disable:
 	/* something went wrong, try to boot without any XSAVE support */
-	fpu__init_disable_system_xstate();
+	fpu__init_disable_system_xstate(legacy_size);
 }
 
 /*
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -31,7 +31,7 @@ extern int copy_sigframe_from_user_to_xs
 
 
 extern void fpu__init_cpu_xstate(void);
-extern void fpu__init_system_xstate(void);
+extern void fpu__init_system_xstate(unsigned int legacy_size);
 
 extern void *get_xsave_addr(struct xregs_state *xsave, int xfeature_nr);
 

