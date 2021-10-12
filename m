Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEF4429A15
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 02:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235562AbhJLAIi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 20:08:38 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:51366 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbhJLAIY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 20:08:24 -0400
Message-ID: <20211011223610.828296394@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633997181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=5e/GctY8E+M9FTg87q7clLA+JaNKqsqcOKPkkw/zsqY=;
        b=fWKxcOASGZ283xBkCCj1NcRQ4K05BWRXR2p6CrF/lel3M+NzVbvtyyrqvF/htWqJ25HcJV
        fGsCwv8YQvSNwQeEuakL+EpxoMDsOtUM/AfWcMY3gdEvSGW1zP2jLpzko+UwMCXEFoi1Yf
        jdK47/szQVY8vbFZ89S7hGLMfUCBuO/pmEi6Lch7VkTod3QeHPNrGFkQVG+C7aXFyd7pEj
        L5VDar88FVg7y8TYSznegYwTivW3d646AxK2vd+bTewbbqZ8Mcj04DzvEtqbAqX+DgPlwU
        E5737oLf0m/OKyK05J0c0d0pZTvS5q7WXm05TReMN/zl/FAIdmbOpjoPtyC4NA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633997181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=5e/GctY8E+M9FTg87q7clLA+JaNKqsqcOKPkkw/zsqY=;
        b=W7dM5vmo/lQxT2lbTj5ScIbfcpcLEwctrVW4uwIwHIb+GfYSSWVk4KdDd3y3mKl2F9/Y6P
        iws95qs0CzewB8Dg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 09/31] x86/fpu: Do not inherit FPU context for CLONE_THREAD
References: <20211011215813.558681373@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 12 Oct 2021 02:00:11 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CLONE_THREAD does not have the guarantee of a true fork to inherit all
state. Especially the FPU state is meaningless for CLONE_THREAD.

Just wipe out the minimal required state so restore on return to user space
let's the thread start with a clean FPU.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/fpu/internal.h |    2 +-
 arch/x86/kernel/fpu/core.c          |    8 +++++---
 arch/x86/kernel/process.c           |    2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)

--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -34,7 +34,7 @@ extern int  fpu__exception_code(struct f
 extern void fpu_sync_fpstate(struct fpu *fpu);
 
 /* Clone and exit operations */
-extern int  fpu_clone(struct task_struct *dst);
+extern int  fpu_clone(struct task_struct *dst, unsigned long clone_flags);
 extern void fpu_flush_thread(void);
 
 /*
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -257,7 +257,7 @@ void fpstate_init(union fpregs_state *st
 EXPORT_SYMBOL_GPL(fpstate_init);
 
 /* Clone current's FPU state on fork */
-int fpu_clone(struct task_struct *dst)
+int fpu_clone(struct task_struct *dst, unsigned long clone_flags)
 {
 	struct fpu *src_fpu = &current->thread.fpu;
 	struct fpu *dst_fpu = &dst->thread.fpu;
@@ -276,9 +276,11 @@ int fpu_clone(struct task_struct *dst)
 
 	/*
 	 * No FPU state inheritance for kernel threads and IO
-	 * worker threads.
+	 * worker threads. Neither CLONE_THREAD needs a copy
+	 * of the FPU state.
 	 */
-	if (dst->flags & (PF_KTHREAD | PF_IO_WORKER)) {
+	if (clone_flags & CLONE_THREAD ||
+	    dst->flags & (PF_KTHREAD | PF_IO_WORKER)) {
 		/* Clear out the minimal state */
 		memcpy(&dst_fpu->state, &init_fpstate,
 		       init_fpstate_copy_size());
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -154,7 +154,7 @@ int copy_thread(unsigned long clone_flag
 	frame->flags = X86_EFLAGS_FIXED;
 #endif
 
-	fpu_clone(p);
+	fpu_clone(p, clone_flags);
 
 	/* Kernel thread ? */
 	if (unlikely(p->flags & PF_KTHREAD)) {

