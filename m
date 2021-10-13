Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43E6242C416
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237585AbhJMO5h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 10:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237413AbhJMO5f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 10:57:35 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B991C061570;
        Wed, 13 Oct 2021 07:55:32 -0700 (PDT)
Message-ID: <20211013145322.347395546@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634136930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=y1Z2Az1JrjMwCXWxSlcQxz5vFesFHkG9dYnK/Nla8H4=;
        b=1TVrOm4ND0K7U/+lDt19sQarLBJHcDy/mZFgGUBnrJBtls3EODXwv0z2afRhWFoBR6E3Vb
        KZhsFm1H0105y2B96XvbMvYY+yy3JOMhWizRyly46D7GNrYc3P0ve4DrkZ2u081SvlZG45
        AGkNTuHZm+lITw6IEqMflveUWz1pDKASttMPrukw8gNA2tvA4lyqheBSd8gcnRVk0M9A26
        +wYWAYDAhgAAcM/Ov6A5Z5oBpLQgkrR+GMIphA59ijU7pV5+EcscBEonZ38fNFBcxCTVLT
        BYfPnQtZz/h/JfeoyOSRRYSKTFzoKo03YOQAFF1F0Tv8rbRGEbJGeKnZecQ6Kw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634136930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=y1Z2Az1JrjMwCXWxSlcQxz5vFesFHkG9dYnK/Nla8H4=;
        b=VBE3q/DrDfolSfCGAzdH2KlW0t2RifoE5IFQg47D37Emqnf5IJoZ8Cx++oTOsLyTe9szg+
        c38W21XG/s+G7bCQ==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 03/21] x86/fpu: Convert restore_fpregs_from_fpstate() to
 struct fpstate
References: <20211013142847.120153383@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 13 Oct 2021 16:55:30 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert restore_fpregs_from_fpstate and related code to the new register
storage mechanism in preparation for dynamically sized buffers.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/fpu/signal.h |    2 +-
 arch/x86/kernel/fpu/context.h     |    2 +-
 arch/x86/kernel/fpu/core.c        |   12 ++++++------
 3 files changed, 8 insertions(+), 8 deletions(-)

--- a/arch/x86/include/asm/fpu/signal.h
+++ b/arch/x86/include/asm/fpu/signal.h
@@ -40,7 +40,7 @@ extern bool copy_fpstate_to_sigframe(voi
 extern void fpu__clear_user_states(struct fpu *fpu);
 extern bool fpu__restore_sig(void __user *buf, int ia32_frame);
 
-extern void restore_fpregs_from_fpstate(union fpregs_state *fpstate, u64 mask);
+extern void restore_fpregs_from_fpstate(struct fpstate *fpstate, u64 mask);
 
 extern bool copy_fpstate_to_sigframe(void __user *buf, void __user *fp, int size);
 
--- a/arch/x86/kernel/fpu/context.h
+++ b/arch/x86/kernel/fpu/context.h
@@ -74,7 +74,7 @@ static inline void fpregs_restore_userre
 		 */
 		mask = xfeatures_mask_restore_user() |
 			xfeatures_mask_supervisor();
-		restore_fpregs_from_fpstate(&fpu->state, mask);
+		restore_fpregs_from_fpstate(fpu->fpstate, mask);
 
 		fpregs_activate(fpu);
 		fpu->last_cpu = cpu;
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -129,7 +129,7 @@ void save_fpregs_to_fpstate(struct fpu *
 	frstor(&fpu->state.fsave);
 }
 
-void restore_fpregs_from_fpstate(union fpregs_state *fpstate, u64 mask)
+void restore_fpregs_from_fpstate(struct fpstate *fpstate, u64 mask)
 {
 	/*
 	 * AMD K7/K8 and later CPUs up to Zen don't save/restore
@@ -146,18 +146,18 @@ void restore_fpregs_from_fpstate(union f
 	}
 
 	if (use_xsave()) {
-		os_xrstor(&fpstate->xsave, mask);
+		os_xrstor(&fpstate->regs.xsave, mask);
 	} else {
 		if (use_fxsr())
-			fxrstor(&fpstate->fxsave);
+			fxrstor(&fpstate->regs.fxsave);
 		else
-			frstor(&fpstate->fsave);
+			frstor(&fpstate->regs.fsave);
 	}
 }
 
 void fpu_reset_from_exception_fixup(void)
 {
-	restore_fpregs_from_fpstate(&init_fpstate.regs, xfeatures_mask_fpstate());
+	restore_fpregs_from_fpstate(&init_fpstate, xfeatures_mask_fpstate());
 }
 
 #if IS_ENABLED(CONFIG_KVM)
@@ -176,7 +176,7 @@ void fpu_swap_kvm_fpu(struct fpu *save,
 
 	if (rstor) {
 		restore_mask &= xfeatures_mask_fpstate();
-		restore_fpregs_from_fpstate(&rstor->state, restore_mask);
+		restore_fpregs_from_fpstate(rstor->fpstate, restore_mask);
 	}
 
 	fpregs_mark_activate();

