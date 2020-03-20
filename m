Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 597EB18DABC
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 23:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbgCTWEU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 18:04:20 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:37508 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727431AbgCTWET (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 18:04:19 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jFPk9-0004Tr-J8; Fri, 20 Mar 2020 23:03:53 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 9A804104084;
        Fri, 20 Mar 2020 23:03:47 +0100 (CET)
Message-Id: <20200320180033.589172314@linutronix.de>
User-Agent: quilt/0.65
Date:   Fri, 20 Mar 2020 19:00:08 +0100
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
Subject: [RESEND][patch V3 12/23] context_tracking: Ensure that the critical
 path cannot be instrumented
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

context tracking lacks a few protection mechanisms against instrumentation:

 - While the core functions are marked NOKPROBE they lack protection
   against function tracing which is required as the function entry/exit
   points can be utilized by BPF.

 - static functions invoked from the protected functions need to be marked
   as well as they can be instrumented otherwise.

 - using plain inline allows the compiler to emit traceable and probable
   functions.

Fix this by marking the functions noinstr and converting the plain inlines
to __always_inline.

The NOKPROBE_SYMBOL() annotations are removed as the .noinstr.text section
is already excluded from being probed.

Cures the following objtool warnings:

 vmlinux.o: warning: objtool: enter_from_user_mode()+0x34: call to __context_tracking_exit() leaves .noinstr.text section
 vmlinux.o: warning: objtool: prepare_exit_to_usermode()+0x29: call to __context_tracking_enter() leaves .noinstr.text section
 vmlinux.o: warning: objtool: syscall_return_slowpath()+0x29: call to __context_tracking_enter() leaves .noinstr.text section
 vmlinux.o: warning: objtool: do_syscall_64()+0x7f: call to __context_tracking_enter() leaves .noinstr.text section
 vmlinux.o: warning: objtool: do_int80_syscall_32()+0x3d: call to __context_tracking_enter() leaves .noinstr.text section
 vmlinux.o: warning: objtool: do_fast_syscall_32()+0x9c: call to __context_tracking_enter() leaves .noinstr.text section

and generates new ones...

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/context_tracking.h       |    6 +++---
 include/linux/context_tracking_state.h |    6 +++---
 kernel/context_tracking.c              |   14 ++++++++------
 3 files changed, 14 insertions(+), 12 deletions(-)

--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -33,13 +33,13 @@ static inline void user_exit(void)
 }
 
 /* Called with interrupts disabled.  */
-static inline void user_enter_irqoff(void)
+static __always_inline void user_enter_irqoff(void)
 {
 	if (context_tracking_enabled())
 		__context_tracking_enter(CONTEXT_USER);
 
 }
-static inline void user_exit_irqoff(void)
+static __always_inline void user_exit_irqoff(void)
 {
 	if (context_tracking_enabled())
 		__context_tracking_exit(CONTEXT_USER);
@@ -75,7 +75,7 @@ static inline void exception_exit(enum c
  * is enabled.  If context tracking is disabled, returns
  * CONTEXT_DISABLED.  This should be used primarily for debugging.
  */
-static inline enum ctx_state ct_state(void)
+static __always_inline enum ctx_state ct_state(void)
 {
 	return context_tracking_enabled() ?
 		this_cpu_read(context_tracking.state) : CONTEXT_DISABLED;
--- a/include/linux/context_tracking_state.h
+++ b/include/linux/context_tracking_state.h
@@ -26,12 +26,12 @@ struct context_tracking {
 extern struct static_key_false context_tracking_key;
 DECLARE_PER_CPU(struct context_tracking, context_tracking);
 
-static inline bool context_tracking_enabled(void)
+static __always_inline bool context_tracking_enabled(void)
 {
 	return static_branch_unlikely(&context_tracking_key);
 }
 
-static inline bool context_tracking_enabled_cpu(int cpu)
+static __always_inline bool context_tracking_enabled_cpu(int cpu)
 {
 	return context_tracking_enabled() && per_cpu(context_tracking.active, cpu);
 }
@@ -41,7 +41,7 @@ static inline bool context_tracking_enab
 	return context_tracking_enabled() && __this_cpu_read(context_tracking.active);
 }
 
-static inline bool context_tracking_in_user(void)
+static __always_inline bool context_tracking_in_user(void)
 {
 	return __this_cpu_read(context_tracking.state) == CONTEXT_USER;
 }
--- a/kernel/context_tracking.c
+++ b/kernel/context_tracking.c
@@ -31,7 +31,7 @@ EXPORT_SYMBOL_GPL(context_tracking_key);
 DEFINE_PER_CPU(struct context_tracking, context_tracking);
 EXPORT_SYMBOL_GPL(context_tracking);
 
-static bool context_tracking_recursion_enter(void)
+static noinstr bool context_tracking_recursion_enter(void)
 {
 	int recursion;
 
@@ -45,7 +45,7 @@ static bool context_tracking_recursion_e
 	return false;
 }
 
-static void context_tracking_recursion_exit(void)
+static __always_inline void context_tracking_recursion_exit(void)
 {
 	__this_cpu_dec(context_tracking.recursion);
 }
@@ -59,7 +59,7 @@ static void context_tracking_recursion_e
  * instructions to execute won't use any RCU read side critical section
  * because this function sets RCU in extended quiescent state.
  */
-void __context_tracking_enter(enum ctx_state state)
+void noinstr __context_tracking_enter(enum ctx_state state)
 {
 	/* Kernel threads aren't supposed to go to userspace */
 	WARN_ON_ONCE(!current->mm);
@@ -77,8 +77,10 @@ void __context_tracking_enter(enum ctx_s
 			 * on the tick.
 			 */
 			if (state == CONTEXT_USER) {
+				instr_begin();
 				trace_user_enter(0);
 				vtime_user_enter(current);
+				instr_end();
 			}
 			rcu_user_enter();
 		}
@@ -99,7 +101,6 @@ void __context_tracking_enter(enum ctx_s
 	}
 	context_tracking_recursion_exit();
 }
-NOKPROBE_SYMBOL(__context_tracking_enter);
 EXPORT_SYMBOL_GPL(__context_tracking_enter);
 
 void context_tracking_enter(enum ctx_state state)
@@ -142,7 +143,7 @@ NOKPROBE_SYMBOL(context_tracking_user_en
  * This call supports re-entrancy. This way it can be called from any exception
  * handler without needing to know if we came from userspace or not.
  */
-void __context_tracking_exit(enum ctx_state state)
+void noinstr __context_tracking_exit(enum ctx_state state)
 {
 	if (!context_tracking_recursion_enter())
 		return;
@@ -155,15 +156,16 @@ void __context_tracking_exit(enum ctx_st
 			 */
 			rcu_user_exit();
 			if (state == CONTEXT_USER) {
+				instr_begin();
 				vtime_user_exit(current);
 				trace_user_exit(0);
+				instr_end();
 			}
 		}
 		__this_cpu_write(context_tracking.state, CONTEXT_KERNEL);
 	}
 	context_tracking_recursion_exit();
 }
-NOKPROBE_SYMBOL(__context_tracking_exit);
 EXPORT_SYMBOL_GPL(__context_tracking_exit);
 
 void context_tracking_exit(enum ctx_state state)

