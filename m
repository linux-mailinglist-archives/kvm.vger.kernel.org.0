Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05997429A2D
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 02:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236242AbhJLAJV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 20:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235003AbhJLAIa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 20:08:30 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D342C06174E;
        Mon, 11 Oct 2021 17:06:29 -0700 (PDT)
Message-ID: <20211011223610.584398929@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633997186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=wsqOL8FLiWK/ug1HoIyemEsvOTae9xkh1fWRP383y9k=;
        b=iUvazFzUe3cO23KDcHZEJ6UNxjGgZi1iJ1s57nBnLVwn5W6i9EcHPSwWHgUPeDv/pilnf2
        CyEOYYXjnZNgrzYelC+/Say7I5/EUJ853lpLn+IisKPq+TlpJr/TeWJlIixwoaEHspDkZG
        lnlyXtFqyUcnFgqq4cyswzWzFXErOwGyLhlvOYsOmKzxIMAnlzNRGZZFh20fIaicjsraNF
        rLRZsah/FkzJ1aNZ5uTUb8DNPcdVax+bbY3xKO+hOZHE1BFEOMSmp4MhnjahE+3qD5t2mH
        FWTHN3We3NMofTJSWS7Hox9wTkqyDk/+RpknV7d8idye4VpXmZfOTTwcd01YnQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633997186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=wsqOL8FLiWK/ug1HoIyemEsvOTae9xkh1fWRP383y9k=;
        b=ngF7uGFQgMACUCNdufzUDlV6mBfkkZdovwnhoDCB+UHYsWJnYk9GWOdHWy6v7MmnxlHdm0
        hZ9qalp7hajZz7Cg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 05/31] x86/fpu: Cleanup the on_boot_cpu clutter
References: <20211011215813.558681373@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 12 Oct 2021 02:00:05 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Defensive programming is useful, but this on_boot_cpu debug is really
silly.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/fpu/init.c   |   16 ----------------
 arch/x86/kernel/fpu/xstate.c |    9 ---------
 2 files changed, 25 deletions(-)

--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -192,11 +192,6 @@ static void __init fpu__init_task_struct
  */
 static void __init fpu__init_system_xstate_size_legacy(void)
 {
-	static int on_boot_cpu __initdata = 1;
-
-	WARN_ON_FPU(!on_boot_cpu);
-	on_boot_cpu = 0;
-
 	/*
 	 * Note that xstate sizes might be overwritten later during
 	 * fpu__init_system_xstate().
@@ -216,15 +211,6 @@ static void __init fpu__init_system_xsta
 	fpu_user_xstate_size = fpu_kernel_xstate_size;
 }
 
-/* Legacy code to initialize eager fpu mode. */
-static void __init fpu__init_system_ctx_switch(void)
-{
-	static bool on_boot_cpu __initdata = 1;
-
-	WARN_ON_FPU(!on_boot_cpu);
-	on_boot_cpu = 0;
-}
-
 /*
  * Called on the boot CPU once per system bootup, to set up the initial
  * FPU state that is later cloned into all processes:
@@ -243,6 +229,4 @@ void __init fpu__init_system(struct cpui
 	fpu__init_system_xstate_size_legacy();
 	fpu__init_system_xstate();
 	fpu__init_task_struct_size();
-
-	fpu__init_system_ctx_switch();
 }
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -379,15 +379,10 @@ static void __init print_xstate_offset_s
  */
 static void __init setup_init_fpu_buf(void)
 {
-	static int on_boot_cpu __initdata = 1;
-
 	BUILD_BUG_ON((XFEATURE_MASK_USER_SUPPORTED |
 		      XFEATURE_MASK_SUPERVISOR_SUPPORTED) !=
 		     XFEATURES_INIT_FPSTATE_HANDLED);
 
-	WARN_ON_FPU(!on_boot_cpu);
-	on_boot_cpu = 0;
-
 	if (!boot_cpu_has(X86_FEATURE_XSAVE))
 		return;
 
@@ -721,14 +716,10 @@ static void fpu__init_disable_system_xst
 void __init fpu__init_system_xstate(void)
 {
 	unsigned int eax, ebx, ecx, edx;
-	static int on_boot_cpu __initdata = 1;
 	u64 xfeatures;
 	int err;
 	int i;
 
-	WARN_ON_FPU(!on_boot_cpu);
-	on_boot_cpu = 0;
-
 	if (!boot_cpu_has(X86_FEATURE_FPU)) {
 		pr_info("x86/fpu: No FPU detected\n");
 		return;

