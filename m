Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD90C42C413
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237211AbhJMO5e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 10:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236719AbhJMO5d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 10:57:33 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14ABAC061570;
        Wed, 13 Oct 2021 07:55:30 -0700 (PDT)
Message-ID: <20211013145322.234458659@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634136927;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=VaXA+17IxKy09pY/oKmNjgRQD0JipWNjNvrXA33QlGI=;
        b=xGHJfwuIWyFBVx5LK2sCy6+YNG614Nb3lTO2AWVYoyecTaiIVce/SJt3aIYy4dqO4905uy
        jnMVhmOTgeNMKnlsZ7IJVK61y46YW3h2IOiIVl3cKnwRvzUjtFmvrixlIUuynt3Wwcvx/U
        5JCU9VmrNRqU+O54rdXeqOCdP/ncS49twn2BX8NmzpVnL/woRGGCb9kq0GflAT78xZgn7e
        oEOn2xJHEsqW5suQ1I1e9t5LlyJzl8B8EItULYGBrW80tMAxMmkkbuwgmrsFY2k+pWrKyX
        cuLV43biymT6OIxbwwM1yooVWwx6B2eGH+nMwnoPcGSo0jNQLug9FgrP/TQQQQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634136927;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=VaXA+17IxKy09pY/oKmNjgRQD0JipWNjNvrXA33QlGI=;
        b=SXOdu6uXGuFAM7De0MNwOyUNmf0RWYr3f1ThvTpkpDUF1MjiQoPfpH4kypGBW211MQBy6D
        5HMOdGjVSDiTrbDA==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 01/21] x86/fpu: Provide struct fpstate
References: <20211013142847.120153383@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 13 Oct 2021 16:55:27 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

New xfeatures will not longer be automatically stored in the regular XSAVE
buffer in thread_struct::fpu.

The kernel will provide the default sized buffer for storing the regular
features up to AVX512 in thread_struct::fpu and if a task requests to use
one of the new features then the register storage has to be extendend.

The state will be accessed via a pointer in thread_struct::fpu which
defaults to the builtin storage and can be switched when extended storage
is required.

To avoid conditionals all over the code, create a new container for the
register storage which will gain other information, e.g. size, feature
masks etc., later. For now it just contains the register storage, which
gives it exactly the same layout as the exiting fpu::state.

Stick fpu::state and the new fpu::__fpstate into an anonymous union and
initialize the pointer. Add build time checks to validate that both are
at the same place and have the same size.

This allows step by step conversion of all users.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/fpu/types.h |   20 +++++++++++++++++++-
 arch/x86/include/asm/processor.h |    4 ++--
 arch/x86/kernel/fpu/core.c       |   11 ++++++++++-
 arch/x86/kernel/fpu/init.c       |    9 +++++++--
 arch/x86/kernel/fpu/internal.h   |    1 +
 5 files changed, 39 insertions(+), 6 deletions(-)

--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -309,6 +309,13 @@ union fpregs_state {
 	u8 __padding[PAGE_SIZE];
 };
 
+struct fpstate {
+	/* @regs: The register state union for all supported formats */
+	union fpregs_state		regs;
+
+	/* @regs is dynamically sized! Don't add anything after @regs! */
+} __attribute__ ((aligned (64)));
+
 /*
  * Highest level per task FPU state data structure that
  * contains the FPU register state plus various FPU
@@ -337,6 +344,14 @@ struct fpu {
 	unsigned long			avx512_timestamp;
 
 	/*
+	 * @fpstate:
+	 *
+	 * Pointer to the active struct fpstate. Initialized to
+	 * point at @__fpstate below.
+	 */
+	struct fpstate			*fpstate;
+
+	/*
 	 * @state:
 	 *
 	 * In-memory copy of all FPU registers that we save/restore
@@ -345,7 +360,10 @@ struct fpu {
 	 * copy. If the task context-switches away then they get
 	 * saved here and represent the FPU state.
 	 */
-	union fpregs_state		state;
+	union {
+		struct fpstate			__fpstate;
+		union fpregs_state		state;
+	};
 	/*
 	 * WARNING: 'state' is dynamically-sized.  Do not put
 	 * anything after it here.
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -537,11 +537,11 @@ struct thread_struct {
 	 */
 };
 
-/* Whitelist the FPU state from the task_struct for hardened usercopy. */
+/* Whitelist the FPU register state from the task_struct for hardened usercopy. */
 static inline void arch_thread_struct_whitelist(unsigned long *offset,
 						unsigned long *size)
 {
-	*offset = offsetof(struct thread_struct, fpu.state);
+	*offset = offsetof(struct thread_struct, fpu.__fpstate.regs);
 	*size = fpu_kernel_xstate_size;
 }
 
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -337,10 +337,17 @@ void fpstate_init_user(union fpregs_stat
 		fpstate_init_fstate(&state->fsave);
 }
 
+void fpstate_reset(struct fpu *fpu)
+{
+	/* Set the fpstate pointer to the default fpstate */
+	fpu->fpstate = &fpu->__fpstate;
+}
+
 #if IS_ENABLED(CONFIG_KVM)
 void fpu_init_fpstate_user(struct fpu *fpu)
 {
-	fpstate_init_user(&fpu->state);
+	fpstate_reset(fpu);
+	fpstate_init_user(&fpu->fpstate->regs);
 }
 EXPORT_SYMBOL_GPL(fpu_init_fpstate_user);
 #endif
@@ -354,6 +361,8 @@ int fpu_clone(struct task_struct *dst)
 	/* The new task's FPU state cannot be valid in the hardware. */
 	dst_fpu->last_cpu = -1;
 
+	fpstate_reset(dst_fpu);
+
 	if (!cpu_feature_enabled(X86_FEATURE_FPU))
 		return 0;
 
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -165,7 +165,7 @@ static void __init fpu__init_task_struct
 	 * Subtract off the static size of the register state.
 	 * It potentially has a bunch of padding.
 	 */
-	task_size -= sizeof(((struct task_struct *)0)->thread.fpu.state);
+	task_size -= sizeof(current->thread.fpu.__fpstate.regs);
 
 	/*
 	 * Add back the dynamically-calculated register state
@@ -180,10 +180,14 @@ static void __init fpu__init_task_struct
 	 * you hit a compile error here, check the structure to
 	 * see if something got added to the end.
 	 */
-	CHECK_MEMBER_AT_END_OF(struct fpu, state);
+	CHECK_MEMBER_AT_END_OF(struct fpu, __fpstate);
 	CHECK_MEMBER_AT_END_OF(struct thread_struct, fpu);
 	CHECK_MEMBER_AT_END_OF(struct task_struct, thread);
 
+	BUILD_BUG_ON(sizeof(struct fpstate) != sizeof(union fpregs_state));
+	BUILD_BUG_ON(offsetof(struct thread_struct, fpu.state) !=
+		     offsetof(struct thread_struct, fpu.__fpstate));
+
 	arch_task_struct_size = task_size;
 }
 
@@ -220,6 +224,7 @@ static void __init fpu__init_system_xsta
  */
 void __init fpu__init_system(struct cpuinfo_x86 *c)
 {
+	fpstate_reset(&current->thread.fpu);
 	fpu__init_system_early_generic(c);
 
 	/*
--- a/arch/x86/kernel/fpu/internal.h
+++ b/arch/x86/kernel/fpu/internal.h
@@ -26,5 +26,6 @@ extern void fpu__init_prepare_fx_sw_fram
 
 /* Used in init.c */
 extern void fpstate_init_user(union fpregs_state *state);
+extern void fpstate_reset(struct fpu *fpu);
 
 #endif

