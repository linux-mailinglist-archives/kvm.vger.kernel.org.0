Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC21429A1F
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 02:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235949AbhJLAIv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 20:08:51 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:51536 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233200AbhJLAI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 20:08:29 -0400
Message-ID: <20211011223611.189084655@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633997183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=Ij7f9mOfp0QLjWmvwZM0nmVubL30A1buOGY1JPWbLHc=;
        b=HdmBHMq+Qld3lFMMgIHxAJf1YjxeVa4uuQdZBF2XMyj5DEqPoJAluQKDLe5b6i8dhqgF8k
        mVgiAOwNB84VyDiiugsoeD7dXNG2RVo/5eKTq0rDmxX1aAmhCCG4uD3ovfKbPZ6dUSHcvs
        doRzj6+x9fAATMWwMkeV6yXhL3Q89yhfD1mInMb6iGW9ik0mM/l/BoYh+njdeS9CzuWG0S
        eqGkq+QG2m0YZahEXQGqC1waRGm5U6LqYU3HkTRTpRL9NzRGBa5uQIP1OXu0/aaYuABotA
        ljVnJ2sJ8tvn26+8I8759rZqTSvD7DDHy0MNECYfp0v7Um6GMCBVa5qa+1TVUg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633997183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=Ij7f9mOfp0QLjWmvwZM0nmVubL30A1buOGY1JPWbLHc=;
        b=z7o+25g0twDCPNgb/TE0ysFVK9/S06gvKLTOUgK+08Ho+WZ0RJjIHYNXmVEm1dHY4ulSDI
        BHd0iT9WifulFGDw==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 15/31] x86/fpu: Rework copy_xstate_to_uabi_buf()
References: <20211011215813.558681373@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 12 Oct 2021 02:00:20 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Prepare for replacing the KVM copy xstate to user function by extending
copy_xstate_to_uabi_buf() with a pkru argument which allows the caller to
hand in the pkru value, which is required for KVM because the guest PKRU is
not accessible via current. Fixup all callsites accordingly.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/fpu/xstate.c |   34 ++++++++++++++++++++++++++--------
 arch/x86/kernel/fpu/xstate.h |    3 +++
 2 files changed, 29 insertions(+), 8 deletions(-)

--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -940,9 +940,10 @@ static void copy_feature(bool from_xstat
 }
 
 /**
- * copy_xstate_to_uabi_buf - Copy kernel saved xstate to a UABI buffer
+ * __copy_xstate_to_uabi_buf - Copy kernel saved xstate to a UABI buffer
  * @to:		membuf descriptor
- * @tsk:	The task from which to copy the saved xstate
+ * @xsave:	The xsave from which to copy
+ * @pkru_val:	The PKRU value to store in the PKRU component
  * @copy_mode:	The requested copy mode
  *
  * Converts from kernel XSAVE or XSAVES compacted format to UABI conforming
@@ -951,11 +952,10 @@ static void copy_feature(bool from_xstat
  *
  * It supports partial copy but @to.pos always starts from zero.
  */
-void copy_xstate_to_uabi_buf(struct membuf to, struct task_struct *tsk,
-			     enum xstate_copy_mode copy_mode)
+void __copy_xstate_to_uabi_buf(struct membuf to, struct xregs_state *xsave,
+			       u32 pkru_val, enum xstate_copy_mode copy_mode)
 {
 	const unsigned int off_mxcsr = offsetof(struct fxregs_state, mxcsr);
-	struct xregs_state *xsave = &tsk->thread.fpu.state.xsave;
 	struct xregs_state *xinit = &init_fpstate.xsave;
 	struct xstate_header header;
 	unsigned int zerofrom;
@@ -1033,10 +1033,9 @@ void copy_xstate_to_uabi_buf(struct memb
 			struct pkru_state pkru = {0};
 			/*
 			 * PKRU is not necessarily up to date in the
-			 * thread's XSAVE buffer.  Fill this part from the
-			 * per-thread storage.
+			 * XSAVE buffer. Use the provided value.
 			 */
-			pkru.pkru = tsk->thread.pkru;
+			pkru.pkru = pkru_val;
 			membuf_write(&to, &pkru, sizeof(pkru));
 		} else {
 			copy_feature(header.xfeatures & BIT_ULL(i), &to,
@@ -1056,6 +1055,25 @@ void copy_xstate_to_uabi_buf(struct memb
 		membuf_zero(&to, to.left);
 }
 
+/**
+ * copy_xstate_to_uabi_buf - Copy kernel saved xstate to a UABI buffer
+ * @to:		membuf descriptor
+ * @tsk:	The task from which to copy the saved xstate
+ * @copy_mode:	The requested copy mode
+ *
+ * Converts from kernel XSAVE or XSAVES compacted format to UABI conforming
+ * format, i.e. from the kernel internal hardware dependent storage format
+ * to the requested @mode. UABI XSTATE is always uncompacted!
+ *
+ * It supports partial copy but @to.pos always starts from zero.
+ */
+void copy_xstate_to_uabi_buf(struct membuf to, struct task_struct *tsk,
+			     enum xstate_copy_mode copy_mode)
+{
+	__copy_xstate_to_uabi_buf(to, &tsk->thread.fpu.state.xsave,
+				  tsk->thread.pkru, copy_mode);
+}
+
 static int copy_from_buffer(void *dst, unsigned int offset, unsigned int size,
 			    const void *kbuf, const void __user *ubuf)
 {
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -15,4 +15,7 @@ static inline void xstate_init_xcomp_bv(
 		xsave->header.xcomp_bv = mask | XCOMP_BV_COMPACTED_FORMAT;
 }
 
+extern void __copy_xstate_to_uabi_buf(struct membuf to, struct xregs_state *xsave,
+				      u32 pkru_val, enum xstate_copy_mode copy_mode);
+
 #endif

