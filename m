Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9ED42C42E
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237966AbhJMO6J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 10:58:09 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35396 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238168AbhJMO5v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 10:57:51 -0400
Message-ID: <20211013145322.921388806@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634136947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=wypfrIc22n4P4BWKy9qrRd+6CEMC66XrchNc4B3EwM0=;
        b=Nzf2emAetc3c+xVxxJ2N3JfaDbZ1FBxkTHjpZAQLmG5VmF3p2+wM7IE8Sd07KRek4qGGK9
        XjeHIyqjPJs0d4pXPLJmhnS1b0b0ACpx6t/ZrX4cMaS4Dxp3F2PZ1G64fuJdsgOsVRicTI
        SwIWkUOFZ9P/7Iz7EocGjF78Dv+GMOQ2MRGcpdhW9ik93HGTG2WUjd7JZyJY1VAxohSHSc
        VggVuJDuJpk/uQv3kq0HFFNfgy7UUowI80ZOeCr4ba2w9OaSIyMjBbnRBCw/Uvr25f8O2a
        rt4ewTKa/jEk6CIBwFRFnNpaPobOE8hdA7Qysv4F+K/h1osevx4vJvybmB7g/Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634136947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=wypfrIc22n4P4BWKy9qrRd+6CEMC66XrchNc4B3EwM0=;
        b=wL2JS7qWGZgsgDWRvqXqnUHVnFJdDmMnp7/QzGOTk+G0KIjSW/YW9SaiC35pgoElbbhGcZ
        IENnL4Y9cAG8wABA==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 14/21] x86/fpu: Add size and mask information to fpstate
References: <20211013142847.120153383@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 13 Oct 2021 16:55:46 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add state size and feature mask information to the fpstate container. This
will be used for runtime checks with the upcoming support for dynamically
enabled features and dynamically sized buffers. That avoids conditionals
all over the place as the required information is accessible for both
default and extended buffers.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/fpu/types.h |   12 ++++++++++++
 arch/x86/kernel/fpu/core.c       |    6 ++++++
 arch/x86/kernel/fpu/init.c       |    9 +++++++++
 arch/x86/kernel/fpu/xstate.c     |    3 +++
 4 files changed, 30 insertions(+)

--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -310,6 +310,18 @@ union fpregs_state {
 };
 
 struct fpstate {
+	/* @kernel_size: The size of the kernel register image */
+	unsigned int		size;
+
+	/* @user_size: The size in non-compacted UABI format */
+	unsigned int		user_size;
+
+	/* @xfeatures:		xfeatures for which the storage is sized */
+	u64			xfeatures;
+
+	/* @user_xfeatures:	xfeatures valid in UABI buffers */
+	u64			user_xfeatures;
+
 	/* @regs: The register state union for all supported formats */
 	union fpregs_state		regs;
 
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -342,6 +342,12 @@ void fpstate_reset(struct fpu *fpu)
 {
 	/* Set the fpstate pointer to the default fpstate */
 	fpu->fpstate = &fpu->__fpstate;
+
+	/* Initialize sizes and feature masks */
+	fpu->fpstate->size		= fpu_kernel_xstate_size;
+	fpu->fpstate->user_size		= fpu_user_xstate_size;
+	fpu->fpstate->xfeatures		= xfeatures_mask_all;
+	fpu->fpstate->user_xfeatures	= xfeatures_mask_uabi();
 }
 
 #if IS_ENABLED(CONFIG_KVM)
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -212,6 +212,14 @@ static void __init fpu__init_system_xsta
 	}
 
 	fpu_user_xstate_size = fpu_kernel_xstate_size;
+	fpstate_reset(&current->thread.fpu);
+}
+
+static void __init fpu__init_init_fpstate(void)
+{
+	/* Bring init_fpstate size and features up to date */
+	init_fpstate.size		= fpu_kernel_xstate_size;
+	init_fpstate.xfeatures		= xfeatures_mask_all;
 }
 
 /*
@@ -233,4 +241,5 @@ void __init fpu__init_system(struct cpui
 	fpu__init_system_xstate_size_legacy();
 	fpu__init_system_xstate();
 	fpu__init_task_struct_size();
+	fpu__init_init_fpstate();
 }
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -720,6 +720,7 @@ static void __init fpu__init_disable_sys
 	xfeatures_mask_all = 0;
 	cr4_clear_bits(X86_CR4_OSXSAVE);
 	setup_clear_cpu_cap(X86_FEATURE_XSAVE);
+	fpstate_reset(&current->thread.fpu);
 }
 
 /*
@@ -792,6 +793,8 @@ void __init fpu__init_system_xstate(void
 	if (err)
 		goto out_disable;
 
+	fpstate_reset(&current->thread.fpu);
+
 	/*
 	 * Update info used for ptrace frames; use standard-format size and no
 	 * supervisor xstates:

