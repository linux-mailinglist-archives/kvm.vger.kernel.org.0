Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B594918DAB2
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 23:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727445AbgCTWES (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 18:04:18 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:37482 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727196AbgCTWEO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 18:04:14 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jFPkB-0004Zg-53; Fri, 20 Mar 2020 23:03:55 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id D5FFC1040A1;
        Fri, 20 Mar 2020 23:03:47 +0100 (CET)
Message-Id: <20200320180033.681580918@linutronix.de>
User-Agent: quilt/0.65
Date:   Fri, 20 Mar 2020 19:00:09 +0100
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
Subject: [RESEND][patch V3 13/23] lib/smp_processor_id: Move it into noinstr section
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

That code is already not traceable. Move it into the noinstr section so the
objtool section validation does not trigger.

Annotate the warning code as "safe". While it might be not under all
circumstances, getting the information out is important enough.

Should this ever trigger from the sensitive code which is shielded against
instrumentation, e.g. low level entry, then the printk is the least of the
worries.

Addresses the objtool warnings:
 vmlinux.o: warning: objtool: context_tracking_recursion_enter()+0x7: call to __this_cpu_preempt_check() leaves .noinstr.text section
 vmlinux.o: warning: objtool: __context_tracking_exit()+0x17: call to __this_cpu_preempt_check() leaves .noinstr.text section
 vmlinux.o: warning: objtool: __context_tracking_enter()+0x2a: call to __this_cpu_preempt_check() leaves .noinstr.text section

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
V3: New patch
---
 lib/smp_processor_id.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/lib/smp_processor_id.c
+++ b/lib/smp_processor_id.c
@@ -8,7 +8,7 @@
 #include <linux/kprobes.h>
 #include <linux/sched.h>
 
-notrace static nokprobe_inline
+noinstr static
 unsigned int check_preemption_disabled(const char *what1, const char *what2)
 {
 	int this_cpu = raw_smp_processor_id();
@@ -37,6 +37,7 @@ unsigned int check_preemption_disabled(c
 	 */
 	preempt_disable_notrace();
 
+	instr_begin();
 	if (!printk_ratelimit())
 		goto out_enable;
 
@@ -45,6 +46,7 @@ unsigned int check_preemption_disabled(c
 
 	printk("caller is %pS\n", __builtin_return_address(0));
 	dump_stack();
+	instr_end();
 
 out_enable:
 	preempt_enable_no_resched_notrace();
@@ -52,16 +54,14 @@ unsigned int check_preemption_disabled(c
 	return this_cpu;
 }
 
-notrace unsigned int debug_smp_processor_id(void)
+noinstr unsigned int debug_smp_processor_id(void)
 {
 	return check_preemption_disabled("smp_processor_id", "");
 }
 EXPORT_SYMBOL(debug_smp_processor_id);
-NOKPROBE_SYMBOL(debug_smp_processor_id);
 
-notrace void __this_cpu_preempt_check(const char *op)
+noinstr void __this_cpu_preempt_check(const char *op)
 {
 	check_preemption_disabled("__this_cpu_", op);
 }
 EXPORT_SYMBOL(__this_cpu_preempt_check);
-NOKPROBE_SYMBOL(__this_cpu_preempt_check);

