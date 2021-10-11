Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1AB429A4B
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 02:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234174AbhJLANR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 20:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbhJLANN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 20:13:13 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE22C0613E8;
        Mon, 11 Oct 2021 17:10:26 -0700 (PDT)
Message-ID: <20211011223610.344149306@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633996799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=K/J8DliA1KrydT+K75626ybfPJK1Kiie29CUG4R7hzc=;
        b=H7T3VpdSC2CYXckP5JLTRtsCTBQ+N7V8euUhZmAllSwWDrrRkLbNN0cvHV+859gA0ck4NL
        6Lw0RjX/K2bz/AOiD6zn/RdBXvx6LVxR8D2noBrbXbMrKxG0E9Q4iFh9lYBI0uBq1Fsv8I
        ROVXlj8JTmXYCfkyDRogq+V1k49hXXXRXHAIjZOIkUzuOTLFo7FNiS6qLgLYxUfGO+RMW9
        dyqbG9//XnIg37YyHdV4Jai0t2P8ceE/G6Pa8EQd7kfwARveFdRyd15QuMpzePwps5fMEf
        wioe2KcT5auY2b2w0239bADYfvvQKmeRaheSaeefh9YQJcPGmpY+jX8Ae7Rweg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633996799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=K/J8DliA1KrydT+K75626ybfPJK1Kiie29CUG4R7hzc=;
        b=f/6HQnddEEvZcHUnLpzgM8ZOd01FN8/UVG9Ii1lkr5sMEGVALPsVVzyjvm/v6RY3pj8Iml
        CIe4FvnVZNfwQUCQ==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 01/31] x86/fpu: Remove pointless argument from switch_fpu_finish()
References: <20211011215813.558681373@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 12 Oct 2021 01:59:59 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unused since the FPU switching rework.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/fpu/internal.h |    2 +-
 arch/x86/kernel/process_32.c        |    3 +--
 arch/x86/kernel/process_64.c        |    3 +--
 3 files changed, 3 insertions(+), 5 deletions(-)

--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -521,7 +521,7 @@ static inline void switch_fpu_prepare(st
  * Delay loading of the complete FPU state until the return to userland.
  * PKRU is handled separately.
  */
-static inline void switch_fpu_finish(struct fpu *new_fpu)
+static inline void switch_fpu_finish(void)
 {
 	if (cpu_feature_enabled(X86_FEATURE_FPU))
 		set_thread_flag(TIF_NEED_FPU_LOAD);
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -160,7 +160,6 @@ EXPORT_SYMBOL_GPL(start_thread);
 	struct thread_struct *prev = &prev_p->thread,
 			     *next = &next_p->thread;
 	struct fpu *prev_fpu = &prev->fpu;
-	struct fpu *next_fpu = &next->fpu;
 	int cpu = smp_processor_id();
 
 	/* never put a printk in __switch_to... printk() calls wake_up*() indirectly */
@@ -213,7 +212,7 @@ EXPORT_SYMBOL_GPL(start_thread);
 
 	this_cpu_write(current_task, next_p);
 
-	switch_fpu_finish(next_fpu);
+	switch_fpu_finish();
 
 	/* Load the Intel cache allocation PQR MSR. */
 	resctrl_sched_in();
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -559,7 +559,6 @@ void compat_start_thread(struct pt_regs
 	struct thread_struct *prev = &prev_p->thread;
 	struct thread_struct *next = &next_p->thread;
 	struct fpu *prev_fpu = &prev->fpu;
-	struct fpu *next_fpu = &next->fpu;
 	int cpu = smp_processor_id();
 
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_DEBUG_ENTRY) &&
@@ -620,7 +619,7 @@ void compat_start_thread(struct pt_regs
 	this_cpu_write(current_task, next_p);
 	this_cpu_write(cpu_current_top_of_stack, task_top_of_stack(next_p));
 
-	switch_fpu_finish(next_fpu);
+	switch_fpu_finish();
 
 	/* Reload sp0. */
 	update_task_stack(next_p);

