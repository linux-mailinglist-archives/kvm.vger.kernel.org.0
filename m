Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7888A437CD2
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 20:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbhJVS6R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 14:58:17 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:41120 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233059AbhJVS6O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Oct 2021 14:58:14 -0400
Message-ID: <20211022185313.074853631@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634928955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=Q1D0MwonvmkUGVRF+jJM2/P6KTp+ZP3J0eVWNnnOvTE=;
        b=sFVZohZ+IzEXGu7FKNMMroFZxxCeMo1VlgLowt3F/E69JG2tX9onR7iR/CQqXohUMQCgOJ
        5i6lcnXoD5oxOuJ7jk62gjR/tv1HGS3xqv3H/+MRmAGmzUbQ7hfWtvyRb2YTGo00eIPoyZ
        WLBNnZp+xqA/zQa8aDb+rno4IeJJ/uNSeGwJtvsd9bF8r2JQXSWKL+7zlhQ6HhDKEFNtDR
        gZWBM5ppe/KBuyfhmtQBdVgef2e5InK0ou1lx2aS3IrEEP8hPiDBVXxZQo4HXrY9WLZSCz
        ku7okfcTDxaROL7Jfff3+vpoXOfAKoa0fJkge5zjQ0W0T+E55oJ7Q6hTQNiPng==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634928955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=Q1D0MwonvmkUGVRF+jJM2/P6KTp+ZP3J0eVWNnnOvTE=;
        b=akyz2fS2yiySaDU80qxvDBnNyHsozzXhbwJn9q+5St2cTjAkcMVL0Mcw2S4xKY8u2C79ub
        mW2azR0eapbtjQDA==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Liu, Jing2" <jing2.liu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, "Nakajima, Jun" <jun.nakajima@intel.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [patch V2 4/4] x86/fpu: Remove old KVM FPU interface
References: <20211022184540.581350173@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 22 Oct 2021 20:55:54 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No more users.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/include/asm/fpu/api.h |    2 --
 arch/x86/kernel/fpu/core.c     |   32 --------------------------------
 2 files changed, 34 deletions(-)
---
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -131,14 +131,12 @@ static inline void fpstate_init_soft(str
 DECLARE_PER_CPU(struct fpu *, fpu_fpregs_owner_ctx);
 
 /* fpstate-related functions which are exported to KVM */
-extern void fpu_init_fpstate_user(struct fpu *fpu);
 extern void fpstate_clear_xstate_component(struct fpstate *fps, unsigned int xfeature);
 
 /* KVM specific functions */
 extern bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu);
 extern void fpu_free_guest_fpstate(struct fpu_guest *gfpu);
 extern int fpu_swap_kvm_fpstate(struct fpu_guest *gfpu, bool enter_guest);
-extern void fpu_swap_kvm_fpu(struct fpu *save, struct fpu *rstor, u64 restore_mask);
 
 extern void fpu_copy_guest_fpstate_to_uabi(struct fpu_guest *gfpu, void *buf, unsigned int size, u32 pkru);
 extern int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf, u64 xcr0, u32 *vpkru);
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -245,29 +245,6 @@ int fpu_swap_kvm_fpstate(struct fpu_gues
 }
 EXPORT_SYMBOL_GPL(fpu_swap_kvm_fpstate);
 
-void fpu_swap_kvm_fpu(struct fpu *save, struct fpu *rstor, u64 restore_mask)
-{
-	fpregs_lock();
-
-	if (save) {
-		struct fpstate *fpcur = current->thread.fpu.fpstate;
-
-		if (test_thread_flag(TIF_NEED_FPU_LOAD))
-			memcpy(&save->fpstate->regs, &fpcur->regs, fpcur->size);
-		else
-			save_fpregs_to_fpstate(save);
-	}
-
-	if (rstor) {
-		restore_mask &= XFEATURE_MASK_FPSTATE;
-		restore_fpregs_from_fpstate(rstor->fpstate, restore_mask);
-	}
-
-	fpregs_mark_activate();
-	fpregs_unlock();
-}
-EXPORT_SYMBOL_GPL(fpu_swap_kvm_fpu);
-
 void fpu_copy_guest_fpstate_to_uabi(struct fpu_guest *gfpu, void *buf,
 				    unsigned int size, u32 pkru)
 {
@@ -437,15 +414,6 @@ void fpstate_reset(struct fpu *fpu)
 	__fpstate_reset(fpu->fpstate);
 }
 
-#if IS_ENABLED(CONFIG_KVM)
-void fpu_init_fpstate_user(struct fpu *fpu)
-{
-	fpstate_reset(fpu);
-	fpstate_init_user(fpu->fpstate);
-}
-EXPORT_SYMBOL_GPL(fpu_init_fpstate_user);
-#endif
-
 /* Clone current's FPU state on fork */
 int fpu_clone(struct task_struct *dst)
 {

