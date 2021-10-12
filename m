Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9B4429A1E
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 02:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235880AbhJLAIp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 20:08:45 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:51366 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233508AbhJLAI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 20:08:29 -0400
Message-ID: <20211011223610.766147508@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633997186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=UFVFYkEktW/yEvtcjFFR89PEJUGZgSbkDZyTQ+sOUPg=;
        b=dKwibIjsWQVo+snnmtdR33D7DOsRg8NODKLWBU0RJkHspJkuyBkCufL1cmaRHZXKMOJQ9P
        S15YutiqfkJm+C6T4r1yceWfZJhxMTZsh+9UsDj3RG9gw/GFhyCKP+0n9lVqnKd7duehxq
        sTLJzFEQ5GmYXUnG54h6IaRyYp/4Ff4P9XIR743ZUrDioLPacfw4Bi6NWP34pKUwdX/cmn
        GMmBGawdjF6fDhGAIyi9AZYsTaF/ozC3DrYO4Kpi+yZsFAymOZSop/yiOPNhbE549r6Bhp
        pFfiwlFECpQp7N8wc1nRfZnznOCEFltZJWjK1/wu/xwVvSXHJMTIHs0zkXRInQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633997186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=UFVFYkEktW/yEvtcjFFR89PEJUGZgSbkDZyTQ+sOUPg=;
        b=lTekYzvIJbxZ76A+KXIg0s44C8GdaMRqweQ2LkamFpigKmQjIScDnXAGXgISd8W0KXzhU+
        znEfmIispec5AUDA==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 08/31] x86/fpu: Do not inherit FPU context for kernel and IO
 worker threads
References: <20211011215813.558681373@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 12 Oct 2021 02:00:10 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is no reason why kernel and IO worker threads need a full clone of
the parent's FPU state. Both are kernel threads which are not supposed to
use FPU. So copying a large state or doing XSAVE() is pointless. Just clean
out the minimaly required state for those tasks.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/fpu/core.c |   37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -212,6 +212,15 @@ static inline void fpstate_init_xstate(s
 	xsave->header.xcomp_bv = XCOMP_BV_COMPACTED_FORMAT | xfeatures_mask_all;
 }
 
+static inline unsigned int init_fpstate_copy_size(void)
+{
+	if (!use_xsave())
+		return fpu_kernel_xstate_size;
+
+	/* XSAVE(S) just needs the legacy and the xstate header part */
+	return sizeof(init_fpstate.xsave);
+}
+
 static inline void fpstate_init_fxstate(struct fxregs_state *fx)
 {
 	fx->cwd = 0x37f;
@@ -260,6 +269,23 @@ int fpu_clone(struct task_struct *dst)
 		return 0;
 
 	/*
+	 * Enforce reload for user space tasks and prevent kernel threads
+	 * from trying to save the FPU registers on context switch.
+	 */
+	set_tsk_thread_flag(dst, TIF_NEED_FPU_LOAD);
+
+	/*
+	 * No FPU state inheritance for kernel threads and IO
+	 * worker threads.
+	 */
+	if (dst->flags & (PF_KTHREAD | PF_IO_WORKER)) {
+		/* Clear out the minimal state */
+		memcpy(&dst_fpu->state, &init_fpstate,
+		       init_fpstate_copy_size());
+		return 0;
+	}
+
+	/*
 	 * If the FPU registers are not owned by current just memcpy() the
 	 * state.  Otherwise save the FPU registers directly into the
 	 * child's FPU context, without any memory-to-memory copying.
@@ -272,8 +298,6 @@ int fpu_clone(struct task_struct *dst)
 		save_fpregs_to_fpstate(dst_fpu);
 	fpregs_unlock();
 
-	set_tsk_thread_flag(dst, TIF_NEED_FPU_LOAD);
-
 	trace_x86_fpu_copy_src(src_fpu);
 	trace_x86_fpu_copy_dst(dst_fpu);
 
@@ -322,15 +346,6 @@ static inline void restore_fpregs_from_i
 	pkru_write_default();
 }
 
-static inline unsigned int init_fpstate_copy_size(void)
-{
-	if (!use_xsave())
-		return fpu_kernel_xstate_size;
-
-	/* XSAVE(S) just needs the legacy and the xstate header part */
-	return sizeof(init_fpstate.xsave);
-}
-
 /*
  * Reset current->fpu memory state to the init values.
  */

