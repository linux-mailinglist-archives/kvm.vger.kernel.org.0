Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2106C18DADC
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 23:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbgCTWGB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 18:06:01 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:37480 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbgCTWEN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 18:04:13 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jFPk1-0004TS-TX; Fri, 20 Mar 2020 23:03:46 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 62AEC1039FF;
        Fri, 20 Mar 2020 23:03:45 +0100 (CET)
Message-Id: <20200320180032.708673769@linutronix.de>
User-Agent: quilt/0.65
Date:   Fri, 20 Mar 2020 18:59:59 +0100
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
Subject: [RESEND][patch V3 03/23] vmlinux.lds.h: Create section for protection
 against instrumentation
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

Some code pathes, especially the low level entry code, must be protected
against instrumentation for various reasons:

 - Low level entry code can be a fragile beast, especially on x86.

 - With NO_HZ_FULL RCU state needs to be established before using it.

Having a dedicated section for such code allows to validate with tooling
that no unsafe functions are invoked.

Add the .noinstr.text section and the noinstr attribute to mark
functions. noinstr implies notrace. Kprobes will gain a section check
later.

Provide also two sets of markers:

 - instr_begin()/end()

   This is used to mark code inside in a noinstr function which calls
   into regular instrumentable text section as safe.

 - noinstr_call_begin()/end()

   Same as above but used to mark indirect calls which cannot be tracked by
   tooling and need to be audited manually.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/asm-generic/sections.h    |    3 +++
 include/asm-generic/vmlinux.lds.h |    4 ++++
 include/linux/compiler.h          |   24 ++++++++++++++++++++++++
 include/linux/compiler_types.h    |    4 ++++
 scripts/mod/modpost.c             |    2 +-
 5 files changed, 36 insertions(+), 1 deletion(-)

--- a/include/asm-generic/sections.h
+++ b/include/asm-generic/sections.h
@@ -53,6 +53,9 @@ extern char __ctors_start[], __ctors_end
 /* Start and end of .opd section - used for function descriptors. */
 extern char __start_opd[], __end_opd[];
 
+/* Start and end of instrumentation protected text section */
+extern char __noinstr_text_start[], __noinstr_text_end[];
+
 extern __visible const void __nosave_begin, __nosave_end;
 
 /* Function descriptor handling (if any).  Override in asm/sections.h */
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -550,6 +550,10 @@
 #define TEXT_TEXT							\
 		ALIGN_FUNCTION();					\
 		*(.text.hot TEXT_MAIN .text.fixup .text.unlikely)	\
+		ALIGN_FUNCTION();					\
+		__noinstr_text_start = .;				\
+		*(.noinstr.text)					\
+		__noinstr_text_end = .;					\
 		*(.text..refcount)					\
 		*(.ref.text)						\
 	MEM_KEEP(init.text*)						\
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -120,12 +120,36 @@ void ftrace_likely_update(struct ftrace_
 /* Annotate a C jump table to allow objtool to follow the code flow */
 #define __annotate_jump_table __section(.rodata..c_jump_table)
 
+/* Begin/end of an instrumentation safe region */
+#define instr_begin() ({						\
+	asm volatile("%c0:\n\t"						\
+		     ".pushsection .discard.instr_begin\n\t"		\
+		     ".long %c0b - .\n\t"				\
+		     ".popsection\n\t" : : "i" (__COUNTER__));		\
+})
+
+#define instr_end() ({							\
+	asm volatile("%c0:\n\t"						\
+		     ".pushsection .discard.instr_end\n\t"		\
+		     ".long %c0b - .\n\t"				\
+		     ".popsection\n\t" : : "i" (__COUNTER__));		\
+})
+
 #else
 #define annotate_reachable()
 #define annotate_unreachable()
 #define __annotate_jump_table
+#define instr_begin()		do { } while(0)
+#define instr_end()		do { } while(0)
 #endif
 
+/*
+ * Annotation for audited indirect calls. Distinct from instr_begin() on
+ * purpose because the called function has to be noinstr as well.
+ */
+#define noinstr_call_begin()		instr_begin()
+#define noinstr_call_end()		instr_end()
+
 #ifndef ASM_UNREACHABLE
 # define ASM_UNREACHABLE
 #endif
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -118,6 +118,10 @@ struct ftrace_likely_data {
 #define notrace			__attribute__((__no_instrument_function__))
 #endif
 
+/* Section for code which can't be instrumented at all */
+#define noinstr								\
+	noinline notrace __attribute((__section__(".noinstr.text")))
+
 /*
  * it doesn't make sense on ARM (currently the only user of __naked)
  * to trace naked functions because then mcount is called without
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -953,7 +953,7 @@ static void check_section(const char *mo
 
 #define DATA_SECTIONS ".data", ".data.rel"
 #define TEXT_SECTIONS ".text", ".text.unlikely", ".sched.text", \
-		".kprobes.text", ".cpuidle.text"
+		".kprobes.text", ".cpuidle.text", ".noinstr.text"
 #define OTHER_TEXT_SECTIONS ".ref.text", ".head.text", ".spinlock.text", \
 		".fixup", ".entry.text", ".exception.text", ".text.*", \
 		".coldtext"

