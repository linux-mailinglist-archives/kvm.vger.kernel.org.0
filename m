Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7512C42E5D2
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 03:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbhJOBSJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 21:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232904AbhJOBSI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 21:18:08 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F01C061755;
        Thu, 14 Oct 2021 18:16:03 -0700 (PDT)
Message-ID: <20211015011538.665080855@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634260561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=1+fzVJkFpn2tADRe4ODW/jh023vO5Spky2/2mWXGWdU=;
        b=tN2J9E9/vTbOYn5GnVZzeQOevlmw/wTDV0aUUGqu1IhPy/fHahLxzD7nG4FRc5VwI6G2jm
        fXyPZN+tNKHqZhbeyWxON5MgkyZnu8kpoTRlVHj6qmpFI/0HrTvkLhnGhmWkYDm2jPKOME
        +bAPuOU0Xs9sf93IdOOJtVNj9qGjPBCpBf3MXj35RxqeL7LwOnQGsLhcjCSXX+Zf66JmMQ
        AmbEPEpIbgkBfvz0iZlyVOLzS7VAWBhLIgJwp6NCpOXW41F8C5vtNiNk+/U3O2MRegi8XM
        cq4rXJ4qjsWJhucyd/ICmKMDpokSigEUnipQ7k4VmSXlY4b4BuTjp1/6vFmGEQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634260561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=1+fzVJkFpn2tADRe4ODW/jh023vO5Spky2/2mWXGWdU=;
        b=7H0l4GAJaGv+L+6trXIqifMpzwwjs5VCMMEFRCMs3/vJXwzIz++LT9D7SABEtBziwXQHjo
        lxHhcpR1iKff+iCQ==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [patch V2 05/30] x86/fpu: Cleanup the on_boot_cpu clutter
References: <20211015011411.304289784@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 03:16:01 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Defensive programming is useful, but this on_boot_cpu debug is really
silly.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/kernel/fpu/init.c   | 16 ----------------
 arch/x86/kernel/fpu/xstate.c |  9 ---------
 2 files changed, 25 deletions(-)
---
diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index 64e29927cc32..86bc9759fc8b 100644
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -192,11 +192,6 @@ static void __init fpu__init_task_struct_size(void)
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
@@ -216,15 +211,6 @@ static void __init fpu__init_system_xstate_size_legacy(void)
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
@@ -243,6 +229,4 @@ void __init fpu__init_system(struct cpuinfo_x86 *c)
 	fpu__init_system_xstate_size_legacy();
 	fpu__init_system_xstate();
 	fpu__init_task_struct_size();
-
-	fpu__init_system_ctx_switch();
 }
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 5a76df965337..d6b5f2266143 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -379,15 +379,10 @@ static void __init print_xstate_offset_size(void)
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
 
@@ -721,14 +716,10 @@ static void fpu__init_disable_system_xstate(void)
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

