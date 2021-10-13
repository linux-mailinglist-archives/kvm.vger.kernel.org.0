Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC9242C441
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238404AbhJMO7R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 10:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238458AbhJMO6m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 10:58:42 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D48C0613E8;
        Wed, 13 Oct 2021 07:55:57 -0700 (PDT)
Message-ID: <20211013145323.233529986@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634136956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=bap8nj49keOI3aiwIuu3xjhv/aUqjhea7KisuXttHHM=;
        b=0I9cvBbAP8BNprxTk3wGm58XaELSaF/JRYaU8WLe5feV3VvJrAPWQ7P6DFtFBFamxo16gH
        hEWoxs0IpiAE9AWe+HrmXRyGc8JBSdF5l1bbb6kZ5w9md9QrPyJMVwxtgI1OxB+YDuOGet
        aZAkywvudUYho0iNOMiZvWQsfzZ1APAioR5w525cVbcFOPko8k6gzz7Oc07GlNe1uPZfCl
        lT+zZ1GcidyHnJmM534lcsl290169OyWssMj/Y9mTrlc6bkFi7HgrRNUGLoCU/BQHqSzxD
        husC/BsaqGZD9jLPBeQ9Sqs/G1Le80my/xhuxu1Iwcb9zN5RurslpIv0jPH/CA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634136956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=bap8nj49keOI3aiwIuu3xjhv/aUqjhea7KisuXttHHM=;
        b=jEu4GaPZj/0PKdNl0zxjsHKnHqeckHCwkZDo4KW/IubuOfAPAAU+ySUYtlhrT/Wb1Mfwsw
        IoP95di0bwilKOBQ==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 20/21] x86/fpu/xstate: Use fpstate for copy_uabi_to_xstate()
References: <20211013142847.120153383@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 13 Oct 2021 16:55:55 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Prepare for dynamically enabled states per task. The function needs to
retrieve the features and sizes which are valid in a fpstate
context. Retrieve them from fpstate.

Move the function declarations to the core header as they are not
required anywhere else.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/fpu/xstate.h |   12 ------------
 arch/x86/kernel/fpu/core.c        |    2 +-
 arch/x86/kernel/fpu/regset.c      |    5 ++---
 arch/x86/kernel/fpu/signal.c      |    2 +-
 arch/x86/kernel/fpu/xstate.c      |   18 ++++++++++--------
 arch/x86/kernel/fpu/xstate.h      |   12 ++++++++++++
 6 files changed, 26 insertions(+), 25 deletions(-)

--- a/arch/x86/include/asm/fpu/xstate.h
+++ b/arch/x86/include/asm/fpu/xstate.h
@@ -129,20 +129,8 @@ extern void __init update_regset_xstate_
 					     u64 xstate_mask);
 
 int xfeature_size(int xfeature_nr);
-int copy_uabi_from_kernel_to_xstate(struct xregs_state *xsave, const void *kbuf);
-int copy_sigframe_from_user_to_xstate(struct xregs_state *xsave, const void __user *ubuf);
 
 void xsaves(struct xregs_state *xsave, u64 mask);
 void xrstors(struct xregs_state *xsave, u64 mask);
 
-enum xstate_copy_mode {
-	XSTATE_COPY_FP,
-	XSTATE_COPY_FX,
-	XSTATE_COPY_XSAVE,
-};
-
-struct membuf;
-void copy_xstate_to_uabi_buf(struct membuf to, struct task_struct *tsk,
-			     enum xstate_copy_mode mode);
-
 #endif
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -222,7 +222,7 @@ int fpu_copy_kvm_uabi_to_fpstate(struct
 	if (ustate->xsave.header.xfeatures & ~xcr0)
 		return -EINVAL;
 
-	ret = copy_uabi_from_kernel_to_xstate(&kstate->regs.xsave, ustate);
+	ret = copy_uabi_from_kernel_to_xstate(kstate, ustate);
 	if (ret)
 		return ret;
 
--- a/arch/x86/kernel/fpu/regset.c
+++ b/arch/x86/kernel/fpu/regset.c
@@ -8,11 +8,11 @@
 #include <asm/fpu/api.h>
 #include <asm/fpu/signal.h>
 #include <asm/fpu/regset.h>
-#include <asm/fpu/xstate.h>
 
 #include "context.h"
 #include "internal.h"
 #include "legacy.h"
+#include "xstate.h"
 
 /*
  * The xstateregs_active() routine is the same as the regset_fpregs_active() routine,
@@ -168,8 +168,7 @@ int xstateregs_set(struct task_struct *t
 	}
 
 	fpu_force_restore(fpu);
-	ret = copy_uabi_from_kernel_to_xstate(&fpu->fpstate->regs.xsave,
-					      kbuf ?: tmpbuf);
+	ret = copy_uabi_from_kernel_to_xstate(fpu->fpstate, kbuf ?: tmpbuf);
 
 out:
 	vfree(tmpbuf);
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -375,7 +375,7 @@ static bool __fpu_restore_sig(void __use
 
 	fpregs = &fpu->fpstate->regs;
 	if (use_xsave() && !fx_only) {
-		if (copy_sigframe_from_user_to_xstate(&fpregs->xsave, buf_fx))
+		if (copy_sigframe_from_user_to_xstate(fpu->fpstate, buf_fx))
 			return false;
 	} else {
 		if (__copy_from_user(&fpregs->fxsave, buf_fx,
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -463,10 +463,11 @@ int xfeature_size(int xfeature_nr)
 }
 
 /* Validate an xstate header supplied by userspace (ptrace or sigreturn) */
-static int validate_user_xstate_header(const struct xstate_header *hdr)
+static int validate_user_xstate_header(const struct xstate_header *hdr,
+				       struct fpstate *fpstate)
 {
 	/* No unknown or supervisor features may be set */
-	if (hdr->xfeatures & ~xfeatures_mask_uabi())
+	if (hdr->xfeatures & ~fpstate->user_xfeatures)
 		return -EINVAL;
 
 	/* Userspace must use the uncompacted format */
@@ -1115,9 +1116,10 @@ static int copy_from_buffer(void *dst, u
 }
 
 
-static int copy_uabi_to_xstate(struct xregs_state *xsave, const void *kbuf,
+static int copy_uabi_to_xstate(struct fpstate *fpstate, const void *kbuf,
 			       const void __user *ubuf)
 {
+	struct xregs_state *xsave = &fpstate->regs.xsave;
 	unsigned int offset, size;
 	struct xstate_header hdr;
 	u64 mask;
@@ -1127,7 +1129,7 @@ static int copy_uabi_to_xstate(struct xr
 	if (copy_from_buffer(&hdr, offset, sizeof(hdr), kbuf, ubuf))
 		return -EFAULT;
 
-	if (validate_user_xstate_header(&hdr))
+	if (validate_user_xstate_header(&hdr, fpstate))
 		return -EINVAL;
 
 	/* Validate MXCSR when any of the related features is in use */
@@ -1182,9 +1184,9 @@ static int copy_uabi_to_xstate(struct xr
  * Convert from a ptrace standard-format kernel buffer to kernel XSAVE[S]
  * format and copy to the target thread. Used by ptrace and KVM.
  */
-int copy_uabi_from_kernel_to_xstate(struct xregs_state *xsave, const void *kbuf)
+int copy_uabi_from_kernel_to_xstate(struct fpstate *fpstate, const void *kbuf)
 {
-	return copy_uabi_to_xstate(xsave, kbuf, NULL);
+	return copy_uabi_to_xstate(fpstate, kbuf, NULL);
 }
 
 /*
@@ -1192,10 +1194,10 @@ int copy_uabi_from_kernel_to_xstate(stru
  * XSAVE[S] format and copy to the target thread. This is called from the
  * sigreturn() and rt_sigreturn() system calls.
  */
-int copy_sigframe_from_user_to_xstate(struct xregs_state *xsave,
+int copy_sigframe_from_user_to_xstate(struct fpstate *fpstate,
 				      const void __user *ubuf)
 {
-	return copy_uabi_to_xstate(xsave, NULL, ubuf);
+	return copy_uabi_to_xstate(fpstate, NULL, ubuf);
 }
 
 static bool validate_independent_components(u64 mask)
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -15,8 +15,20 @@ static inline void xstate_init_xcomp_bv(
 		xsave->header.xcomp_bv = mask | XCOMP_BV_COMPACTED_FORMAT;
 }
 
+enum xstate_copy_mode {
+	XSTATE_COPY_FP,
+	XSTATE_COPY_FX,
+	XSTATE_COPY_XSAVE,
+};
+
+struct membuf;
 extern void __copy_xstate_to_uabi_buf(struct membuf to, struct fpstate *fpstate,
 				      u32 pkru_val, enum xstate_copy_mode copy_mode);
+extern void copy_xstate_to_uabi_buf(struct membuf to, struct task_struct *tsk,
+				    enum xstate_copy_mode mode);
+extern int copy_uabi_from_kernel_to_xstate(struct fpstate *fpstate, const void *kbuf);
+extern int copy_sigframe_from_user_to_xstate(struct fpstate *fpstate, const void __user *ubuf);
+
 
 extern void fpu__init_cpu_xstate(void);
 extern void fpu__init_system_xstate(void);

