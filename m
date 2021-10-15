Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E1342E5CC
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 03:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232242AbhJOBSD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 21:18:03 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46300 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbhJOBSC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 21:18:02 -0400
Message-ID: <20211015011538.433135710@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634260555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=ZZTNJd7cxz4mCtW2ftlTrqZfGzeoazdJ+Z32mroPb/E=;
        b=Kk8CHxQwHxh789V1y3SUoXQ15ByBEdE7Z0cW9BxJ9eLy0FyPftpiHlySKJbeglrmg6VWPc
        f3YT3LK9iFU0fwidUUbbfQPkpXhMTNmdVos+AB6faTftNgkid2GakZM3MZ0q1xF/8KPaEZ
        h6D3ljd+U/Cy3rRcgUbTRJHtDlFyut7wCGD1RJC4yGdFLe0tZrBLxQUyfu77t3aGuhu9zv
        dJKEBABv6w+5hGHJ3bSOE6QX2Mfft2UzmhAlncltKuEWknY4yXc7OKfUSgiM3sX1wSMyCn
        kQ0GDjQiN6+iIF6bcgJufHmGdsjOjHdBkGFe3RU5zDJqJlqa5tZp9XFwFMaGww==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634260555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=ZZTNJd7cxz4mCtW2ftlTrqZfGzeoazdJ+Z32mroPb/E=;
        b=7lnjxBbFH3aV2E6qvzwtaUe0/xrJD/KFOJtLKV8ET+AYxa7245bDFiQ8URtx7k+LF5OXGR
        ynmlZ4swuVqWd3Cw==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [patch V2 01/30] x86/fpu: Remove pointless argument from switch_fpu_finish()
References: <20211015011411.304289784@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 03:15:54 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unused since the FPU switching rework.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/include/asm/fpu/internal.h | 2 +-
 arch/x86/kernel/process_32.c        | 3 +--
 arch/x86/kernel/process_64.c        | 3 +--
 3 files changed, 3 insertions(+), 5 deletions(-)
---
diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index 89960e479f87..1503750534f7 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -521,7 +521,7 @@ static inline void switch_fpu_prepare(struct fpu *old_fpu, int cpu)
  * Delay loading of the complete FPU state until the return to userland.
  * PKRU is handled separately.
  */
-static inline void switch_fpu_finish(struct fpu *new_fpu)
+static inline void switch_fpu_finish(void)
 {
 	if (cpu_feature_enabled(X86_FEATURE_FPU))
 		set_thread_flag(TIF_NEED_FPU_LOAD);
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 4f2f54e1281c..d008e222a302 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -160,7 +160,6 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	struct thread_struct *prev = &prev_p->thread,
 			     *next = &next_p->thread;
 	struct fpu *prev_fpu = &prev->fpu;
-	struct fpu *next_fpu = &next->fpu;
 	int cpu = smp_processor_id();
 
 	/* never put a printk in __switch_to... printk() calls wake_up*() indirectly */
@@ -213,7 +212,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 
 	this_cpu_write(current_task, next_p);
 
-	switch_fpu_finish(next_fpu);
+	switch_fpu_finish();
 
 	/* Load the Intel cache allocation PQR MSR. */
 	resctrl_sched_in();
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index ec0d836a13b1..39f12ef1c85c 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -559,7 +559,6 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	struct thread_struct *prev = &prev_p->thread;
 	struct thread_struct *next = &next_p->thread;
 	struct fpu *prev_fpu = &prev->fpu;
-	struct fpu *next_fpu = &next->fpu;
 	int cpu = smp_processor_id();
 
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_DEBUG_ENTRY) &&
@@ -620,7 +619,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	this_cpu_write(current_task, next_p);
 	this_cpu_write(cpu_current_top_of_stack, task_top_of_stack(next_p));
 
-	switch_fpu_finish(next_fpu);
+	switch_fpu_finish();
 
 	/* Reload sp0. */
 	update_task_stack(next_p);

