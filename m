Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 298C718DAD1
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 23:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727446AbgCTWFc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 18:05:32 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:37491 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727400AbgCTWEP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 18:04:15 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jFPk8-0004b5-39; Fri, 20 Mar 2020 23:03:52 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 59EDD1040C5;
        Fri, 20 Mar 2020 23:03:48 +0100 (CET)
Message-Id: <20200320180033.897314494@linutronix.de>
User-Agent: quilt/0.65
Date:   Fri, 20 Mar 2020 19:00:11 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Paul McKenney <paulmck@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Brian Gerst <brgerst@gmail.com>,
        Juergen Gross <jgross@suse.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [RESEND][patch V3 15/23] x86/entry/64: Check IF in
 __preempt_enable_notrace() thunk
References: <20200320175956.033706968@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The preempt_enable_notrace() ASM thunk is called from tracing, entry code
RCU and other places which are already in or going to be in the noinstr
section which protects sensitve code from being instrumented.

Calls out of these sections happen with interrupts disabled, which is
handled in C code, but the push regs, call, pop regs sequence can be
completely avoided in this case.

This is also a preparatory step for annotating the call from the thunk to
preempt_enable_notrace() safe from a noinstr section.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
New patch
---
 arch/x86/entry/thunk_64.S       |   27 +++++++++++++++++++++++----
 arch/x86/include/asm/irqflags.h |    3 +--
 arch/x86/include/asm/paravirt.h |    3 +--
 3 files changed, 25 insertions(+), 8 deletions(-)

--- a/arch/x86/entry/thunk_64.S
+++ b/arch/x86/entry/thunk_64.S
@@ -9,10 +9,28 @@
 #include "calling.h"
 #include <asm/asm.h>
 #include <asm/export.h>
+#include <asm/irqflags.h>
+
+.code64
 
 	/* rdi:	arg1 ... normal C conventions. rax is saved/restored. */
-	.macro THUNK name, func, put_ret_addr_in_rdi=0
+	.macro THUNK name, func, put_ret_addr_in_rdi=0, check_if=0
 SYM_FUNC_START_NOALIGN(\name)
+
+	.if \check_if
+	/*
+	 * Check for interrupts disabled right here. No point in
+	 * going all the way down
+	 */
+	pushq	%rax
+	SAVE_FLAGS(CLBR_RAX)
+	testl	$X86_EFLAGS_IF, %eax
+	popq	%rax
+	jnz	1f
+	ret
+1:
+	.endif
+
 	pushq %rbp
 	movq %rsp, %rbp
 
@@ -38,8 +56,8 @@ SYM_FUNC_END(\name)
 	.endm
 
 #ifdef CONFIG_TRACE_IRQFLAGS
-	THUNK trace_hardirqs_on_thunk,trace_hardirqs_on_caller,1
-	THUNK trace_hardirqs_off_thunk,trace_hardirqs_off_caller,1
+	THUNK trace_hardirqs_on_thunk,trace_hardirqs_on_caller, put_ret_addr_in_rdi=1
+	THUNK trace_hardirqs_off_thunk,trace_hardirqs_off_caller, put_ret_addr_in_rdi=1
 #endif
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
@@ -48,8 +66,9 @@ SYM_FUNC_END(\name)
 
 #ifdef CONFIG_PREEMPTION
 	THUNK ___preempt_schedule, preempt_schedule
-	THUNK ___preempt_schedule_notrace, preempt_schedule_notrace
 	EXPORT_SYMBOL(___preempt_schedule)
+
+	THUNK ___preempt_schedule_notrace, preempt_schedule_notrace, check_if=1
 	EXPORT_SYMBOL(___preempt_schedule_notrace)
 #endif
 
--- a/arch/x86/include/asm/irqflags.h
+++ b/arch/x86/include/asm/irqflags.h
@@ -127,9 +127,8 @@ static inline notrace unsigned long arch
 #define DISABLE_INTERRUPTS(x)	cli
 
 #ifdef CONFIG_X86_64
-#ifdef CONFIG_DEBUG_ENTRY
+
 #define SAVE_FLAGS(x)		pushfq; popq %rax
-#endif
 
 #define SWAPGS	swapgs
 /*
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -900,14 +900,13 @@ extern void default_banner(void);
 		  ANNOTATE_RETPOLINE_SAFE;				\
 		  jmp PARA_INDIRECT(pv_ops+PV_CPU_usergs_sysret64);)
 
-#ifdef CONFIG_DEBUG_ENTRY
 #define SAVE_FLAGS(clobbers)                                        \
 	PARA_SITE(PARA_PATCH(PV_IRQ_save_fl),			    \
 		  PV_SAVE_REGS(clobbers | CLBR_CALLEE_SAVE);        \
 		  ANNOTATE_RETPOLINE_SAFE;			    \
 		  call PARA_INDIRECT(pv_ops+PV_IRQ_save_fl);	    \
 		  PV_RESTORE_REGS(clobbers | CLBR_CALLEE_SAVE);)
-#endif
+
 #endif /* CONFIG_PARAVIRT_XXL */
 #endif	/* CONFIG_X86_64 */
 

