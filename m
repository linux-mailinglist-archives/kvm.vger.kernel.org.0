Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD49818DAB4
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 23:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbgCTWET (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 18:04:19 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:37496 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727141AbgCTWER (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 18:04:17 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jFPk2-0004Tb-L5; Fri, 20 Mar 2020 23:03:46 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 2324A1039FD;
        Fri, 20 Mar 2020 23:03:46 +0100 (CET)
Message-Id: <20200320180032.994128577@linutronix.de>
User-Agent: quilt/0.65
Date:   Fri, 20 Mar 2020 19:00:02 +0100
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
Subject: [RESEND][patch V3 06/23] bug: Annotate WARN/BUG/stackfail as noinstr safe
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

Warnings, bugs and stack protection fails from noinstr sections, e.g. low
level and early entry code, are likely to be fatal.

Mark them as "safe" to be invoked from noinstr protected code to avoid
annotating all usage sites. Getting the information out is important.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/bug.h |    3 +++
 include/asm-generic/bug.h  |    9 +++++++--
 kernel/panic.c             |    4 +++-
 3 files changed, 13 insertions(+), 3 deletions(-)

--- a/arch/x86/include/asm/bug.h
+++ b/arch/x86/include/asm/bug.h
@@ -70,13 +70,16 @@ do {									\
 #define HAVE_ARCH_BUG
 #define BUG()							\
 do {								\
+	instr_begin();						\
 	_BUG_FLAGS(ASM_UD2, 0);					\
 	unreachable();						\
 } while (0)
 
 #define __WARN_FLAGS(flags)					\
 do {								\
+	instr_begin();						\
 	_BUG_FLAGS(ASM_UD2, BUGFLAG_WARNING|(flags));		\
+	instr_end();						\
 	annotate_reachable();					\
 } while (0)
 
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -83,14 +83,19 @@ extern __printf(4, 5)
 void warn_slowpath_fmt(const char *file, const int line, unsigned taint,
 		       const char *fmt, ...);
 #define __WARN()		__WARN_printf(TAINT_WARN, NULL)
-#define __WARN_printf(taint, arg...)					\
-	warn_slowpath_fmt(__FILE__, __LINE__, taint, arg)
+#define __WARN_printf(taint, arg...) do {				\
+	instr_begin();							\
+	warn_slowpath_fmt(__FILE__, __LINE__, taint, arg);		\
+	instr_end();							\
+	while (0)
 #else
 extern __printf(1, 2) void __warn_printk(const char *fmt, ...);
 #define __WARN()		__WARN_FLAGS(BUGFLAG_TAINT(TAINT_WARN))
 #define __WARN_printf(taint, arg...) do {				\
+		instr_begin();						\
 		__warn_printk(arg);					\
 		__WARN_FLAGS(BUGFLAG_NO_CUT_HERE | BUGFLAG_TAINT(taint));\
+		instr_end();						\
 	} while (0)
 #define WARN_ON_ONCE(condition) ({				\
 	int __ret_warn_on = !!(condition);			\
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -662,10 +662,12 @@ device_initcall(register_warn_debugfs);
  * Called when gcc's -fstack-protector feature is used, and
  * gcc detects corruption of the on-stack canary value
  */
-__visible void __stack_chk_fail(void)
+__visible noinstr void __stack_chk_fail(void)
 {
+	instr_begin();
 	panic("stack-protector: Kernel stack is corrupted in: %pB",
 		__builtin_return_address(0));
+	instr_end();
 }
 EXPORT_SYMBOL(__stack_chk_fail);
 

