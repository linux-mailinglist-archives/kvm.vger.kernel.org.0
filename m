Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8D742C42C
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238353AbhJMO6B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 10:58:01 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35462 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238148AbhJMO5t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 10:57:49 -0400
Message-ID: <20211013145322.869001791@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634136945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=ncWQ0hRZ3EV+ZEbd4taFLJFeMkbBwnFwXxOb4l2vRbA=;
        b=iSHgbznvtoGUjqStKLgntGUyWYmGv/UdxPlzJGKv4AsICK2pe8fV73AaFjuOJtKkU/zgsh
        JRDO+ESDzkN3WjPDj+3iz3nJ60YtgZxI75DWOKHAYRMwmWcDVxskpc851O69U6iXLSgs6E
        k6I9GlH99JISDHTjIcwzZM+XJ1SFJx8KomjTnmHoxseBFtUUfNiWdEo19fmlZjn5Z8zMRY
        uyIYK8hlXT4GgsAWFuQj5gqexhCIj7ggwYWsI2zGxy114/YOjNsVMg5W+bbsISHTCp14eY
        rseAYZ4mcVGteQo9ZTQlAGd3et1O7mSqAqy0roNk9mauolNMX5MYte0bAzU/yw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634136945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=ncWQ0hRZ3EV+ZEbd4taFLJFeMkbBwnFwXxOb4l2vRbA=;
        b=PJvfuCS5AxjUg3NYQFVeyGh+CCUgxJxX4BVztWnc9HIx04piaEQk96oAsrHrVFfp1V+V1U
        l8W8kz0vmB8xvTDg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 13/21] x86/process: Move arch_thread_struct_whitelist() out of line
References: <20211013142847.120153383@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 13 Oct 2021 16:55:45 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In preparation for dynamic enabled FPU features move the function out of
line as the goal is to expose less and not more information.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/processor.h |    9 +++------
 arch/x86/kernel/fpu/core.c       |   10 ++++++++++
 arch/x86/kernel/fpu/internal.h   |    2 ++
 3 files changed, 15 insertions(+), 6 deletions(-)

--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -461,9 +461,6 @@ DECLARE_PER_CPU(struct irq_stack *, hard
 DECLARE_PER_CPU(struct irq_stack *, softirq_stack_ptr);
 #endif	/* !X86_64 */
 
-extern unsigned int fpu_kernel_xstate_size;
-extern unsigned int fpu_user_xstate_size;
-
 struct perf_event;
 
 struct thread_struct {
@@ -537,12 +534,12 @@ struct thread_struct {
 	 */
 };
 
-/* Whitelist the FPU register state from the task_struct for hardened usercopy. */
+extern void fpu_thread_struct_whitelist(unsigned long *offset, unsigned long *size);
+
 static inline void arch_thread_struct_whitelist(unsigned long *offset,
 						unsigned long *size)
 {
-	*offset = offsetof(struct thread_struct, fpu.__fpstate.regs);
-	*size = fpu_kernel_xstate_size;
+	fpu_thread_struct_whitelist(offset, size);
 }
 
 static inline void
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -405,6 +405,16 @@ int fpu_clone(struct task_struct *dst)
 }
 
 /*
+ * Whitelist the FPU register state embedded into task_struct for hardened
+ * usercopy.
+ */
+void fpu_thread_struct_whitelist(unsigned long *offset, unsigned long *size)
+{
+	*offset = offsetof(struct thread_struct, fpu.__fpstate.regs);
+	*size = fpu_kernel_xstate_size;
+}
+
+/*
  * Drops current FPU state: deactivates the fpregs and
  * the fpstate. NOTE: it still leaves previous contents
  * in the fpregs in the eager-FPU case.
--- a/arch/x86/kernel/fpu/internal.h
+++ b/arch/x86/kernel/fpu/internal.h
@@ -2,6 +2,8 @@
 #ifndef __X86_KERNEL_FPU_INTERNAL_H
 #define __X86_KERNEL_FPU_INTERNAL_H
 
+extern unsigned int fpu_kernel_xstate_size;
+extern unsigned int fpu_user_xstate_size;
 extern struct fpstate init_fpstate;
 
 /* CPU feature check wrappers */

