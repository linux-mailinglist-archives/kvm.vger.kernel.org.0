Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 493C242E4A0
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 01:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234392AbhJNXL7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 19:11:59 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:45642 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234384AbhJNXLr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 19:11:47 -0400
Message-ID: <20211014230739.514095101@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634252981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=zoeOGaSz/EfV2jZB8yk8D3VJZjEJF1rVrAGB3lz2cKU=;
        b=c63bRbuv/KiP8xcNrCe99L+qMtrMKmd+Ts7jDnfPUC/6Arc3UVnOPz7PwEXDIDyP6fwbPi
        0bwf4Ky26/xjzSQPXCdaFuxP87L4DMMfRNf2y35v93mODP9x6BABRDwjAn/zT2dVVH9oqY
        hXGPDpId2sD6KWEe8XCieTAlvGrfxYiLH+ntQ0OKtoRSCvORVHPj7DU8r/GjxrtX2wM7HR
        lNeGwd0oUGgYPrKERPxzL+v1sz1JVJKu2aInSDECSDwzWylQHm8a++bQd4112Apk6Peqnc
        oWioqjLd8SUX5kiWn8XSL7nl34vd1fuHOVAnKfjKjrR2vHIfCtLSjPw49WaeGg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634252981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=zoeOGaSz/EfV2jZB8yk8D3VJZjEJF1rVrAGB3lz2cKU=;
        b=DLwQULNnOlJuTnDHSnYzUbR6bWaB5T5NndOSL3ea6yP7pfRQtGscz/EmwvDIyLm2yycAkd
        iC2CrzayVjVAgsDA==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 8/8] x86/fpu/xstate: Move remaining xfeature helpers to core
References: <20211014225711.615197738@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 01:09:40 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that everything is mopped up, move all the helpers and prototypes into
the core header. They are not required by the outside.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/fpu/xstate.h |   13 -------------
 arch/x86/kernel/fpu/xstate.h      |   13 +++++++++++++
 2 files changed, 13 insertions(+), 13 deletions(-)

--- a/arch/x86/include/asm/fpu/xstate.h
+++ b/arch/x86/include/asm/fpu/xstate.h
@@ -86,19 +86,6 @@
 #define XFEATURE_MASK_FPSTATE	(XFEATURE_MASK_USER_RESTORE | \
 				 XFEATURE_MASK_SUPERVISOR_SUPPORTED)
 
-static inline u64 xfeatures_mask_supervisor(void)
-{
-	return fpu_kernel_cfg.max_features & XFEATURE_MASK_SUPERVISOR_SUPPORTED;
-}
-
-static inline u64 xfeatures_mask_independent(void)
-{
-	if (!boot_cpu_has(X86_FEATURE_ARCH_LBR))
-		return XFEATURE_MASK_INDEPENDENT & ~XFEATURE_MASK_LBR;
-
-	return XFEATURE_MASK_INDEPENDENT;
-}
-
 extern u64 xstate_fx_sw_bytes[USER_XSTATE_FX_SW_WORDS];
 
 extern void __init update_regset_xstate_info(unsigned int size,
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -35,6 +35,19 @@ extern void fpu__init_system_xstate(unsi
 
 extern void *get_xsave_addr(struct xregs_state *xsave, int xfeature_nr);
 
+static inline u64 xfeatures_mask_supervisor(void)
+{
+	return fpu_kernel_cfg.max_features & XFEATURE_MASK_SUPERVISOR_SUPPORTED;
+}
+
+static inline u64 xfeatures_mask_independent(void)
+{
+	if (!cpu_feature_enabled(X86_FEATURE_ARCH_LBR))
+		return XFEATURE_MASK_INDEPENDENT & ~XFEATURE_MASK_LBR;
+
+	return XFEATURE_MASK_INDEPENDENT;
+}
+
 /* XSAVE/XRSTOR wrapper functions */
 
 #ifdef CONFIG_X86_64

