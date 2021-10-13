Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E541442C43B
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238517AbhJMO6n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 10:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238504AbhJMO6J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 10:58:09 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2124C061775;
        Wed, 13 Oct 2021 07:55:51 -0700 (PDT)
Message-ID: <20211013145323.025695590@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634136950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=tyZ4fB8M8KQ+ZVy4Tj94RxQ5EI71d2jFs+ZcceYHE5g=;
        b=YuNi/CmrBXr+jRuCRtfQMJqh7ai5mxHcQCdxSPTnRUwhIk2wVsL/a+dPwMLZ05M/c6Ko/H
        xDNV12j317mQJQd7jkcqPSI8IiKNnKBlahIma4D4qsWiz8DADCRL1Pe2q1M2y4Llecs1DZ
        owpdRWhUSzTPf61fXA9m8sYHn1WIVofjkzi3ar8INOwAeZt/n2pzxSbBb4T+9yWvDL2FRq
        yxbcigL3zJa3EvnUMq85dz+btnuVbDeVl/5iGLMrQzIclQK44Ug9Qu8JDXVAPdILdcPgk3
        8W8M3oFYq00Qbmi4wTmKGhexCmSZpBxQsvxx3gj07ThGImElJa4JIhGyjwZWVw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634136950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=tyZ4fB8M8KQ+ZVy4Tj94RxQ5EI71d2jFs+ZcceYHE5g=;
        b=UOtFelc+PDgYGglRygwpw6eXBGhD4tID5NP1Jt2NuzcH1uc2x/3jWthxZyAzFGlTFoHY4j
        G7Q8VWxW5Ch+hBBw==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 16/21] x86/fpu/xstate: Use fpstate for os_xsave()
References: <20211013142847.120153383@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 13 Oct 2021 16:55:49 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With variable feature sets XSAVE[S} requires to know the feature set for
which the buffer is valid. Retrieve it from fpstate.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/fpu/core.c   |    2 +-
 arch/x86/kernel/fpu/signal.c |    4 ++--
 arch/x86/kernel/fpu/xstate.h |    6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -105,7 +105,7 @@ EXPORT_SYMBOL(irq_fpu_usable);
 void save_fpregs_to_fpstate(struct fpu *fpu)
 {
 	if (likely(use_xsave())) {
-		os_xsave(&fpu->fpstate->regs.xsave);
+		os_xsave(fpu->fpstate);
 
 		/*
 		 * AVX512 state is tracked here because its use is
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -349,7 +349,6 @@ static bool __fpu_restore_sig(void __use
 	if (__copy_from_user(&env, buf, sizeof(env)))
 		return false;
 
-	fpregs = &fpu->fpstate->regs;
 	/*
 	 * By setting TIF_NEED_FPU_LOAD it is ensured that our xstate is
 	 * not modified on context switch and that the xstate is considered
@@ -367,13 +366,14 @@ static bool __fpu_restore_sig(void __use
 		 * the right place in memory. It's ia32 mode. Shrug.
 		 */
 		if (xfeatures_mask_supervisor())
-			os_xsave(&fpregs->xsave);
+			os_xsave(fpu->fpstate);
 		set_thread_flag(TIF_NEED_FPU_LOAD);
 	}
 	__fpu_invalidate_fpregs_state(fpu);
 	__cpu_invalidate_fpregs_state();
 	fpregs_unlock();
 
+	fpregs = &fpu->fpstate->regs;
 	if (use_xsave() && !fx_only) {
 		if (copy_sigframe_from_user_to_xstate(&fpregs->xsave, buf_fx))
 			return false;
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -101,16 +101,16 @@ extern void *get_xsave_addr(struct xregs
  * Uses either XSAVE or XSAVEOPT or XSAVES depending on the CPU features
  * and command line options. The choice is permanent until the next reboot.
  */
-static inline void os_xsave(struct xregs_state *xstate)
+static inline void os_xsave(struct fpstate *fpstate)
 {
-	u64 mask = xfeatures_mask_all;
+	u64 mask = fpstate->xfeatures;
 	u32 lmask = mask;
 	u32 hmask = mask >> 32;
 	int err;
 
 	WARN_ON_FPU(!alternatives_patched);
 
-	XSTATE_XSAVE(xstate, lmask, hmask, err);
+	XSTATE_XSAVE(&fpstate->regs.xsave, lmask, hmask, err);
 
 	/* We should never fault when copying to a kernel buffer: */
 	WARN_ON_FPU(err);

