Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD3C42E5FD
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 03:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235163AbhJOBTl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 21:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234818AbhJOBSw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 21:18:52 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119C2C0613DF;
        Thu, 14 Oct 2021 18:16:25 -0700 (PDT)
Message-ID: <20211015011539.455836597@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634260583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=wJvwI4BBDt6Cu2A9JXCnL4YOdGbXc9WWklcRk7yFEcs=;
        b=djEf3dzpPDWlJIyINEdUxOtyf9wyx7r2m6ijWqcdjlIx3JY5ooQ2HVj3o6wlMZgETA1Mwo
        oLo9tFCPtuGu/7e8gKrmdITlVbjOAqGBMXYv/4tAX6Ipl9tj1vUEoDN708NCALua8BgU3O
        dFTpl0XRibNHOHEiPhi1c/rTgGwzRoP2hw1IdTZ5Y/io+uT+DnuGhUgPBoWFW5rDS1bNYc
        UX7AMn2lWV6NyZy/kyMZllpsIONC784jwcAFiS9I83Vimi3OzXb8riJrEfOFHaSCxmFdmE
        n0ybNoBEnujOahDHHdXjlxZUZGBRHp7RViKp1eDrHvydVGHNsHBQifRuESqmTA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634260583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=wJvwI4BBDt6Cu2A9JXCnL4YOdGbXc9WWklcRk7yFEcs=;
        b=yLESv1KV5SSVoWAQKMcbQMC/QU0QKqrczYcoCh+XX4XntrEPRBVM/LBKV89ayyv3/JMuwF
        3O6SQ+SXNYlWCdDg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [patch V2 19/30] x86/fpu: Make os_xrstor_booting() private
References: <20211015011411.304289784@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 03:16:23 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's only required in the xstate init code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/include/asm/fpu/internal.h | 25 -------------------------
 arch/x86/kernel/fpu/xstate.c        | 23 +++++++++++++++++++++++
 2 files changed, 23 insertions(+), 25 deletions(-)
---
diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index 5da7528b3b2f..3ad2ae73efa5 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -226,31 +226,6 @@ static inline void fxsave(struct fxregs_state *fx)
 		     : "memory")
 
 /*
- * This function is called only during boot time when x86 caps are not set
- * up and alternative can not be used yet.
- */
-static inline void os_xrstor_booting(struct xregs_state *xstate)
-{
-	u64 mask = xfeatures_mask_fpstate();
-	u32 lmask = mask;
-	u32 hmask = mask >> 32;
-	int err;
-
-	WARN_ON(system_state != SYSTEM_BOOTING);
-
-	if (boot_cpu_has(X86_FEATURE_XSAVES))
-		XSTATE_OP(XRSTORS, xstate, lmask, hmask, err);
-	else
-		XSTATE_OP(XRSTOR, xstate, lmask, hmask, err);
-
-	/*
-	 * We should never fault when copying from a kernel buffer, and the FPU
-	 * state we set at boot time should be valid.
-	 */
-	WARN_ON_FPU(err);
-}
-
-/*
  * Save processor xstate to xsave area.
  *
  * Uses either XSAVE or XSAVEOPT or XSAVES depending on the CPU features
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 1f5a66a38671..b712c06cbbfb 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -351,6 +351,29 @@ static void __init print_xstate_offset_size(void)
 }
 
 /*
+ * This function is called only during boot time when x86 caps are not set
+ * up and alternative can not be used yet.
+ */
+static __init void os_xrstor_booting(struct xregs_state *xstate)
+{
+	u64 mask = xfeatures_mask_fpstate();
+	u32 lmask = mask;
+	u32 hmask = mask >> 32;
+	int err;
+
+	if (cpu_feature_enabled(X86_FEATURE_XSAVES))
+		XSTATE_OP(XRSTORS, xstate, lmask, hmask, err);
+	else
+		XSTATE_OP(XRSTOR, xstate, lmask, hmask, err);
+
+	/*
+	 * We should never fault when copying from a kernel buffer, and the FPU
+	 * state we set at boot time should be valid.
+	 */
+	WARN_ON_FPU(err);
+}
+
+/*
  * All supported features have either init state all zeros or are
  * handled in setup_init_fpu() individually. This is an explicit
  * feature list and does not use XFEATURE_MASK*SUPPORTED to catch

