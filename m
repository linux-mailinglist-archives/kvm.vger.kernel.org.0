Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25D3242E5D1
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 03:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbhJOBSI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 21:18:08 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46334 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232412AbhJOBSG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 21:18:06 -0400
Message-ID: <20211015011538.608492174@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634260559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=NxL389GvCjYUIYxtWyYLkVLuEIfE/oYZ1co+1NzD5AQ=;
        b=SIdlpy7xGtg2Q2b5SjYmIzJmYx7vxcpHbYR6g6uTIYcsPEcPH2dTfX++2KoXYujqrK1oSw
        JxLCZe+Q6BPLg9dtJBY1cx+rG+PGab5nCYDhTcfGRSlvCebXf9bbPHI3N35ItQYv9EUU4j
        5HtUdL9HUaRx+CYEh/fu4UDvlyTZlmAvCkwAhPVa/38cNXKIFsNldcPXi8BrDsKuzSyeTS
        Kc8+H3/G5wxP5NZ6pGam/4tmEB5BrO9cOuBGy9mKKeRGRb4Fz7/N5P7HUW8Dmxdf0npsOO
        9vHbHY7fX3THVx4zf1xoAqm3tYI3qoh7aHSr4qjFh2gNyBGr++s+1rL3DDkDBQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634260559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=NxL389GvCjYUIYxtWyYLkVLuEIfE/oYZ1co+1NzD5AQ=;
        b=UYnpa4gWI8zoffFomg/WiH12Ss6FrpLvBf2eSZ0OtMkanP0lNkt8MMtPv4+uhjM9zaqBZ5
        76FP248mvBUYlUAg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [patch V2 04/30] x86/fpu: Restrict xsaves()/xrstors() to independent states
References: <20211015011411.304289784@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 03:15:59 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These interfaces are really only valid for features which are independently
managed and not part of the task context state for various reasons.

Tighten the checks and adjust the misleading comments.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
V2: Rename functions and address the comment related review - Boris
---
 arch/x86/kernel/fpu/xstate.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)
---
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index c8def1b7f8fb..5a76df965337 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1175,20 +1175,14 @@ int copy_sigframe_from_user_to_xstate(struct xregs_state *xsave,
 	return copy_uabi_to_xstate(xsave, NULL, ubuf);
 }
 
-static bool validate_xsaves_xrstors(u64 mask)
+static bool validate_independent_components(u64 mask)
 {
 	u64 xchk;
 
 	if (WARN_ON_FPU(!cpu_feature_enabled(X86_FEATURE_XSAVES)))
 		return false;
-	/*
-	 * Validate that this is either a task->fpstate related component
-	 * subset or an independent one.
-	 */
-	if (mask & xfeatures_mask_independent())
-		xchk = ~xfeatures_mask_independent();
-	else
-		xchk = ~xfeatures_mask_all;
+
+	xchk = ~xfeatures_mask_independent();
 
 	if (WARN_ON_ONCE(!mask || mask & xchk))
 		return false;
@@ -1206,14 +1200,13 @@ static bool validate_xsaves_xrstors(u64 mask)
  * buffer should be zeroed otherwise a consecutive XRSTORS from that buffer
  * can #GP.
  *
- * The feature mask must either be a subset of the independent features or
- * a subset of the task->fpstate related features.
+ * The feature mask must be a subset of the independent features.
  */
 void xsaves(struct xregs_state *xstate, u64 mask)
 {
 	int err;
 
-	if (!validate_xsaves_xrstors(mask))
+	if (!validate_independent_components(mask))
 		return;
 
 	XSTATE_OP(XSAVES, xstate, (u32)mask, (u32)(mask >> 32), err);
@@ -1231,14 +1224,13 @@ void xsaves(struct xregs_state *xstate, u64 mask)
  * Proper usage is to restore the state which was saved with
  * xsaves() into @xstate.
  *
- * The feature mask must either be a subset of the independent features or
- * a subset of the task->fpstate related features.
+ * The feature mask must be a subset of the independent features.
  */
 void xrstors(struct xregs_state *xstate, u64 mask)
 {
 	int err;
 
-	if (!validate_xsaves_xrstors(mask))
+	if (!validate_independent_components(mask))
 		return;
 
 	XSTATE_OP(XRSTORS, xstate, (u32)mask, (u32)(mask >> 32), err);

