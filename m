Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 259CE18DAD5
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 23:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgCTWFh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 18:05:37 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:37490 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727372AbgCTWEP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 18:04:15 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jFPk8-0004bo-Q3; Fri, 20 Mar 2020 23:03:52 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 965401040C6;
        Fri, 20 Mar 2020 23:03:48 +0100 (CET)
Message-Id: <20200320180034.003248957@linutronix.de>
User-Agent: quilt/0.65
Date:   Fri, 20 Mar 2020 19:00:12 +0100
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
Subject: [RESEND][patch V3 16/23] x86/entry/64: Mark
 ___preempt_schedule_notrace() thunk noinstr
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

Code calling this from noinstr sections, e.g. entry code, has interrupts
disabled, so the actual call into the scheduler code does not happen.

The objtool section check complains nevertheless, so mark the call "safe".

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/entry/thunk_64.S |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/arch/x86/entry/thunk_64.S
+++ b/arch/x86/entry/thunk_64.S
@@ -49,7 +49,22 @@ SYM_FUNC_START_NOALIGN(\name)
 	movq 8(%rbp), %rdi
 	.endif
 
+	.if \check_if
+1:
+	.pushsection .discard.instr_begin
+	.long 1b - .
+	.popsection
+
+	call \func
+2:
+	.pushsection .discard.instr_end
+	.long 2b - .
+	.popsection
+
+	.else
 	call \func
+	.endif
+
 	jmp  .L_restore
 SYM_FUNC_END(\name)
 	_ASM_NOKPROBE(\name)
@@ -68,13 +83,16 @@ SYM_FUNC_END(\name)
 	THUNK ___preempt_schedule, preempt_schedule
 	EXPORT_SYMBOL(___preempt_schedule)
 
+.pushsection .noinstr.text, "ax"
 	THUNK ___preempt_schedule_notrace, preempt_schedule_notrace, check_if=1
+.popsection
 	EXPORT_SYMBOL(___preempt_schedule_notrace)
 #endif
 
 #if defined(CONFIG_TRACE_IRQFLAGS) \
  || defined(CONFIG_DEBUG_LOCK_ALLOC) \
  || defined(CONFIG_PREEMPTION)
+.section .noinstr.text, "ax"
 SYM_CODE_START_LOCAL_NOALIGN(.L_restore)
 	popq %r11
 	popq %r10

