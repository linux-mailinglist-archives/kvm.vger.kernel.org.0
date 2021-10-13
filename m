Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDD842C41D
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238047AbhJMO5q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 10:57:46 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35376 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237747AbhJMO5k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 10:57:40 -0400
Message-ID: <20211013145322.555239736@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634136936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=U7gsEuDGMDabYjhedbdmAJ9kXhUMBT4TdImZ4fF59Fc=;
        b=ioP2IlvLF+vc8tAJ1yzAgL0CzDKyUqeBGGjivGhTqqWBEJoI8ciyYEovL2DpfYqpRSAUun
        OtJrJBWojwrKsL8m9nq7QLxb6TFryMtkNKXRXkzetDRM/mOeoJ1VMzQktxu9yeqcnu170d
        yqPGVi6GjLof3KjpF+lAglnsr0BajbB4wIG9kwMJvgxmVTXeGx+scLePlBkW6G2rC0JSuk
        oQu0f5bj2frcGRrxyN8u8RRr0CZIguDX/qEonPuqfYzlVMDcgTDbzHsniVgEzF3lSHJYHb
        +sj4X71udvNzf+WYTxYHLSBsryiSPU7c/p/vIx1uU+aZVBm+qHwtBsygvcGKWQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634136936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=U7gsEuDGMDabYjhedbdmAJ9kXhUMBT4TdImZ4fF59Fc=;
        b=BA5vjqvJ2KLTPaPESzwNb1eA6AYlqvXFrn7emFxk5Lr7cQkzUmltCqgsgbnwnP1aujqzEH
        XzS0ohsBc0zPUkBQ==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 07/21] x86/fpu/regset: Convert to fpstate
References: <20211013142847.120153383@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 13 Oct 2021 16:55:36 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert regset related code to the new register storage mechanism in
preparation for dynamically sized buffers.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/fpu/regset.c |   27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

--- a/arch/x86/kernel/fpu/regset.c
+++ b/arch/x86/kernel/fpu/regset.c
@@ -78,8 +78,8 @@ int xfpregs_get(struct task_struct *targ
 	sync_fpstate(fpu);
 
 	if (!use_xsave()) {
-		return membuf_write(&to, &fpu->state.fxsave,
-				    sizeof(fpu->state.fxsave));
+		return membuf_write(&to, &fpu->fpstate->regs.fxsave,
+				    sizeof(fpu->fpstate->regs.fxsave));
 	}
 
 	copy_xstate_to_uabi_buf(to, target, XSTATE_COPY_FX);
@@ -114,15 +114,15 @@ int xfpregs_set(struct task_struct *targ
 	fpu_force_restore(fpu);
 
 	/* Copy the state  */
-	memcpy(&fpu->state.fxsave, &newstate, sizeof(newstate));
+	memcpy(&fpu->fpstate->regs.fxsave, &newstate, sizeof(newstate));
 
 	/* Clear xmm8..15 */
-	BUILD_BUG_ON(sizeof(fpu->state.fxsave.xmm_space) != 16 * 16);
-	memset(&fpu->state.fxsave.xmm_space[8], 0, 8 * 16);
+	BUILD_BUG_ON(sizeof(fpu->__fpstate.regs.fxsave.xmm_space) != 16 * 16);
+	memset(&fpu->fpstate->regs.fxsave.xmm_space[8], 0, 8 * 16);
 
 	/* Mark FP and SSE as in use when XSAVE is enabled */
 	if (use_xsave())
-		fpu->state.xsave.header.xfeatures |= XFEATURE_MASK_FPSSE;
+		fpu->fpstate->regs.xsave.header.xfeatures |= XFEATURE_MASK_FPSSE;
 
 	return 0;
 }
@@ -168,7 +168,8 @@ int xstateregs_set(struct task_struct *t
 	}
 
 	fpu_force_restore(fpu);
-	ret = copy_uabi_from_kernel_to_xstate(&fpu->state.xsave, kbuf ?: tmpbuf);
+	ret = copy_uabi_from_kernel_to_xstate(&fpu->fpstate->regs.xsave,
+					      kbuf ?: tmpbuf);
 
 out:
 	vfree(tmpbuf);
@@ -287,7 +288,7 @@ static void __convert_from_fxsr(struct u
 void
 convert_from_fxsr(struct user_i387_ia32_struct *env, struct task_struct *tsk)
 {
-	__convert_from_fxsr(env, tsk, &tsk->thread.fpu.state.fxsave);
+	__convert_from_fxsr(env, tsk, &tsk->thread.fpu.fpstate->regs.fxsave);
 }
 
 void convert_to_fxsr(struct fxregs_state *fxsave,
@@ -330,7 +331,7 @@ int fpregs_get(struct task_struct *targe
 		return fpregs_soft_get(target, regset, to);
 
 	if (!cpu_feature_enabled(X86_FEATURE_FXSR)) {
-		return membuf_write(&to, &fpu->state.fsave,
+		return membuf_write(&to, &fpu->fpstate->regs.fsave,
 				    sizeof(struct fregs_state));
 	}
 
@@ -341,7 +342,7 @@ int fpregs_get(struct task_struct *targe
 		copy_xstate_to_uabi_buf(mb, target, XSTATE_COPY_FP);
 		fx = &fxsave;
 	} else {
-		fx = &fpu->state.fxsave;
+		fx = &fpu->fpstate->regs.fxsave;
 	}
 
 	__convert_from_fxsr(&env, target, fx);
@@ -370,16 +371,16 @@ int fpregs_set(struct task_struct *targe
 	fpu_force_restore(fpu);
 
 	if (cpu_feature_enabled(X86_FEATURE_FXSR))
-		convert_to_fxsr(&fpu->state.fxsave, &env);
+		convert_to_fxsr(&fpu->fpstate->regs.fxsave, &env);
 	else
-		memcpy(&fpu->state.fsave, &env, sizeof(env));
+		memcpy(&fpu->fpstate->regs.fsave, &env, sizeof(env));
 
 	/*
 	 * Update the header bit in the xsave header, indicating the
 	 * presence of FP.
 	 */
 	if (cpu_feature_enabled(X86_FEATURE_XSAVE))
-		fpu->state.xsave.header.xfeatures |= XFEATURE_MASK_FP;
+		fpu->fpstate->regs.xsave.header.xfeatures |= XFEATURE_MASK_FP;
 
 	return 0;
 }

