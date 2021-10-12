Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69CC6429A22
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 02:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235991AbhJLAIy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 20:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234869AbhJLAI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 20:08:29 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06ABFC061745;
        Mon, 11 Oct 2021 17:06:28 -0700 (PDT)
Message-ID: <20211011223611.488735966@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633997185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=RM4WwqDVFzMFQNaYplJ49a0++6qEuhrKPfh9LJhm0gY=;
        b=qfbNJ3nzl/9uZyg7e5mJlDMz7ka6lqSRKQPQtvnR5Z2bij+P/GJEOMW5RuUPCNjkla/xtt
        cFXWLXr+fioKa2TOzIupl4wGSLDguiNrDzXJSOyFzRy4CoWpA5z5bSNjruTzn0OC3LVR1v
        JepmA/INy/YuKP9FsjFAfq4gvQg2Hsq4hs4NZLEs04yUCRTTQEVZv0FQvO0Ws94ikKVAI8
        ldadKtQVHf9CAiNNHrJlI1dGCcXQmy3m0sykVYCoc1a6xDSxGgMr5OEN27zNNFuPlz+PcK
        gTJZnbRhB57KgTta4IHNZ6S7omtARUUnpxV1H8JncpNtKOcBPUwtwDM+hsr78Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633997185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=RM4WwqDVFzMFQNaYplJ49a0++6qEuhrKPfh9LJhm0gY=;
        b=ret41enOBEKuHMRhOFxn80vdf5Ai1A5t7Bo/p+q6JsBdmBGivrkeFFIdHKaID5Q/6LAg7c
        GY/4pXn3eqNve1AQ==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 20/31] x86/fpu: Make os_xrstor_booting() private
References: <20211011215813.558681373@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 12 Oct 2021 02:00:28 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's only required in the xstate init code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/fpu/internal.h |   25 -------------------------
 arch/x86/kernel/fpu/xstate.c        |   23 +++++++++++++++++++++++
 2 files changed, 23 insertions(+), 25 deletions(-)

--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -226,31 +226,6 @@ static inline void fxsave(struct fxregs_
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
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -351,6 +351,29 @@ static void __init print_xstate_offset_s
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

