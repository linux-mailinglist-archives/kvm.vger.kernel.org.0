Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC5B342C437
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238751AbhJMO60 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 10:58:26 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35446 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238056AbhJMO56 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 10:57:58 -0400
Message-ID: <20211013145323.181495492@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634136954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=M7epPoXlEVXhVT9MtSrIKMVfCK09b8UlgJegNqqby9Q=;
        b=f8R7Li9Va/Lz0wBHGvt/fnQMHEwxx60m0HlDrNsl4Veb/s4CEMQuIymZkwCbxnjAMi4ROQ
        WiWLcyXlnYbNjZCpN1cadlwkR88Ft0Bufz9te9ASz1A4T6B8zMZkZfHQnEc+htZND6hSYC
        vbX20fc2lPzykt7cYgGDbvMmS+7p9+wP4UJF6mWg5kFyLCtoYM+AkeE7HmTqNxOZhoFcwG
        H2/xnpT9ZHlq7wlvPpGAqa2CwhrQBtAdaeln2G2X+tGGnTlEeCRgPQdH572xn9jOtySND+
        wNlgG39rak30RyglitRNgeE6i3QMNYj9q83dqmyUSz5v7huXgs/CEcmmA3z/tw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634136954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=M7epPoXlEVXhVT9MtSrIKMVfCK09b8UlgJegNqqby9Q=;
        b=t2LwL0LMTefT1X3sEa94ZEmghYI7FTpaztlH8lvqoFnzb/7Tp2kO0tDNj782qP+A8cb5JZ
        DDEsBgAa5IgpbJDg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 19/21] x86/fpu: Use fpstate in __copy_xstate_to_uabi_buf()
References: <20211013142847.120153383@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 13 Oct 2021 16:55:54 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With dynamically enabled features the copy function must know the features
and the size which is valid for the task. Retrieve them from fpstate.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/fpu/core.c   |    8 ++++----
 arch/x86/kernel/fpu/xstate.c |   11 ++++++-----
 arch/x86/kernel/fpu/xstate.h |    2 +-
 3 files changed, 11 insertions(+), 10 deletions(-)

--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -187,15 +187,15 @@ EXPORT_SYMBOL_GPL(fpu_swap_kvm_fpu);
 void fpu_copy_fpstate_to_kvm_uabi(struct fpu *fpu, void *buf,
 			       unsigned int size, u32 pkru)
 {
-	union fpregs_state *kstate = &fpu->fpstate->regs;
+	struct fpstate *kstate = fpu->fpstate;
 	union fpregs_state *ustate = buf;
 	struct membuf mb = { .p = buf, .left = size };
 
 	if (cpu_feature_enabled(X86_FEATURE_XSAVE)) {
-		__copy_xstate_to_uabi_buf(mb, &kstate->xsave, pkru,
-					  XSTATE_COPY_XSAVE);
+		__copy_xstate_to_uabi_buf(mb, kstate, pkru, XSTATE_COPY_XSAVE);
 	} else {
-		memcpy(&ustate->fxsave, &kstate->fxsave, sizeof(ustate->fxsave));
+		memcpy(&ustate->fxsave, &kstate->regs.fxsave,
+		       sizeof(ustate->fxsave));
 		/* Make it restorable on a XSAVE enabled host */
 		ustate->xsave.header.xfeatures = XFEATURE_MASK_FPSSE;
 	}
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -969,7 +969,7 @@ static void copy_feature(bool from_xstat
 /**
  * __copy_xstate_to_uabi_buf - Copy kernel saved xstate to a UABI buffer
  * @to:		membuf descriptor
- * @xsave:	The xsave from which to copy
+ * @fpstate:	The fpstate buffer from which to copy
  * @pkru_val:	The PKRU value to store in the PKRU component
  * @copy_mode:	The requested copy mode
  *
@@ -979,11 +979,12 @@ static void copy_feature(bool from_xstat
  *
  * It supports partial copy but @to.pos always starts from zero.
  */
-void __copy_xstate_to_uabi_buf(struct membuf to, struct xregs_state *xsave,
+void __copy_xstate_to_uabi_buf(struct membuf to, struct fpstate *fpstate,
 			       u32 pkru_val, enum xstate_copy_mode copy_mode)
 {
 	const unsigned int off_mxcsr = offsetof(struct fxregs_state, mxcsr);
 	struct xregs_state *xinit = &init_fpstate.regs.xsave;
+	struct xregs_state *xsave = &fpstate->regs.xsave;
 	struct xstate_header header;
 	unsigned int zerofrom;
 	u64 mask;
@@ -1003,7 +1004,7 @@ void __copy_xstate_to_uabi_buf(struct me
 		break;
 
 	case XSTATE_COPY_XSAVE:
-		header.xfeatures &= xfeatures_mask_uabi();
+		header.xfeatures &= fpstate->user_xfeatures;
 		break;
 	}
 
@@ -1046,7 +1047,7 @@ void __copy_xstate_to_uabi_buf(struct me
 	 * but there is no state to copy from in the compacted
 	 * init_fpstate. The gap tracking will zero these states.
 	 */
-	mask = xfeatures_mask_uabi();
+	mask = fpstate->user_xfeatures;
 
 	for_each_extended_xfeature(i, mask) {
 		/*
@@ -1097,7 +1098,7 @@ void __copy_xstate_to_uabi_buf(struct me
 void copy_xstate_to_uabi_buf(struct membuf to, struct task_struct *tsk,
 			     enum xstate_copy_mode copy_mode)
 {
-	__copy_xstate_to_uabi_buf(to, &tsk->thread.fpu.fpstate->regs.xsave,
+	__copy_xstate_to_uabi_buf(to, tsk->thread.fpu.fpstate,
 				  tsk->thread.pkru, copy_mode);
 }
 
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -15,7 +15,7 @@ static inline void xstate_init_xcomp_bv(
 		xsave->header.xcomp_bv = mask | XCOMP_BV_COMPACTED_FORMAT;
 }
 
-extern void __copy_xstate_to_uabi_buf(struct membuf to, struct xregs_state *xsave,
+extern void __copy_xstate_to_uabi_buf(struct membuf to, struct fpstate *fpstate,
 				      u32 pkru_val, enum xstate_copy_mode copy_mode);
 
 extern void fpu__init_cpu_xstate(void);

