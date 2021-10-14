Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D42142E49D
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 01:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbhJNXLv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 19:11:51 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:45678 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234364AbhJNXLo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 19:11:44 -0400
Message-ID: <20211014230739.408879849@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634252978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=bAQJJerKDNICmvVOHamcMxaejexvNO2x+7HSc41vSD8=;
        b=Aycrphoa7Oc2AP93wNyT62FD1jbbwnzzR/dQehyzuO/HUs97ohLxqdtxVeohGbtm0Pq1Hx
        3K+k3EpKkTlqGGEAtQE4hl4tfy3vq98TWTPdvXfeWT4XHEngnW9jJgQ0WXdNefFO01A+fd
        T6tVY04Qqx9ffJYyhhOqRj109ZIEFzELtboBdgLRkJ1OJzTlAfdRTXbP3tKcF3h/Zrm/9s
        xJMvLjAUB2ZzNq3ay5ilWxmroAUxfehHddiZSatyg9pLuDCHyf9nBNDtQ52/rPK1FYUPtB
        J9YYDHP/OVVav4u4jr9DQhUalbeq9dnwpM2qSTLafB03nMi+WoZCRmiu1wgiiQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634252978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=bAQJJerKDNICmvVOHamcMxaejexvNO2x+7HSc41vSD8=;
        b=mGy95CLvebg78ULpga21g2NFrGZoxCTMpMaLvFVhwRcxmmFj89R/8+yqIhIrfXnt91+4Rd
        rLPWzV8LPgzscjAw==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 6/8] x86/fpu: Mop up xfeatures_mask_uabi()
References: <20211014225711.615197738@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 01:09:37 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the new fpu_user_cfg to retrieve the information instead of
xfeatures_mask_uabi() which will be not longer correct when dynamically
enabled features become available.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/fpu/xstate.h |    9 ---------
 arch/x86/kernel/fpu/core.c        |    4 ++--
 arch/x86/kernel/fpu/signal.c      |    2 +-
 arch/x86/kernel/fpu/xstate.c      |    6 +++---
 4 files changed, 6 insertions(+), 15 deletions(-)

--- a/arch/x86/include/asm/fpu/xstate.h
+++ b/arch/x86/include/asm/fpu/xstate.h
@@ -84,15 +84,6 @@ static inline u64 xfeatures_mask_supervi
 }
 
 /*
- * The xfeatures which are enabled in XCR0 and expected to be in ptrace
- * buffers and signal frames.
- */
-static inline u64 xfeatures_mask_uabi(void)
-{
-	return fpu_kernel_cfg.max_features & XFEATURE_MASK_USER_SUPPORTED;
-}
-
-/*
  * The xfeatures which are restored by the kernel when returning to user
  * mode. This is not necessarily the same as xfeatures_mask_uabi() as the
  * kernel does not manage all XCR0 enabled features via xsave/xrstor as
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -237,7 +237,7 @@ int fpu_copy_kvm_uabi_to_fpstate(struct
 	}
 
 	/* Ensure that XCOMP_BV is set up for XSAVES */
-	xstate_init_xcomp_bv(&kstate->regs.xsave, xfeatures_mask_uabi());
+	xstate_init_xcomp_bv(&kstate->regs.xsave, fpu_user_cfg.max_features);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(fpu_copy_kvm_uabi_to_fpstate);
@@ -333,7 +333,7 @@ void fpstate_init_user(struct fpstate *f
 		return;
 	}
 
-	xstate_init_xcomp_bv(&fpstate->regs.xsave, xfeatures_mask_uabi());
+	xstate_init_xcomp_bv(&fpstate->regs.xsave, fpu_user_cfg.max_features);
 
 	if (cpu_feature_enabled(X86_FEATURE_FXSR))
 		fpstate_init_fxstate(fpstate);
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -530,7 +530,7 @@ void __init fpu__init_prepare_fx_sw_fram
 
 	fx_sw_reserved.magic1 = FP_XSTATE_MAGIC1;
 	fx_sw_reserved.extended_size = size;
-	fx_sw_reserved.xfeatures = xfeatures_mask_uabi();
+	fx_sw_reserved.xfeatures = fpu_user_cfg.default_features;
 	fx_sw_reserved.xstate_size = fpu_user_cfg.default_size;
 
 	if (IS_ENABLED(CONFIG_IA32_EMULATION) ||
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -770,7 +770,7 @@ void __init fpu__init_system_xstate(unsi
 	cpuid_count(XSTATE_CPUID, 1, &eax, &ebx, &ecx, &edx);
 	fpu_kernel_cfg.max_features |= ecx + ((u64)edx << 32);
 
-	if ((xfeatures_mask_uabi() & XFEATURE_MASK_FPSSE) != XFEATURE_MASK_FPSSE) {
+	if ((fpu_kernel_cfg.max_features & XFEATURE_MASK_FPSSE) != XFEATURE_MASK_FPSSE) {
 		/*
 		 * This indicates that something really unexpected happened
 		 * with the enumeration.  Disable XSAVE and try to continue
@@ -815,7 +815,7 @@ void __init fpu__init_system_xstate(unsi
 	 * supervisor xstates:
 	 */
 	update_regset_xstate_info(fpu_user_cfg.max_size,
-				  xfeatures_mask_uabi());
+				  fpu_user_cfg.max_features);
 
 	fpu__init_prepare_fx_sw_frame();
 	setup_init_fpu_buf();
@@ -853,7 +853,7 @@ void fpu__resume_cpu(void)
 	 * Restore XCR0 on xsave capable CPUs:
 	 */
 	if (cpu_feature_enabled(X86_FEATURE_XSAVE))
-		xsetbv(XCR_XFEATURE_ENABLED_MASK, xfeatures_mask_uabi());
+		xsetbv(XCR_XFEATURE_ENABLED_MASK, fpu_user_cfg.max_features);
 
 	/*
 	 * Restore IA32_XSS. The same CPUID bit enumerates support

