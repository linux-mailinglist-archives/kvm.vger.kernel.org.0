Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3B667CF9C
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 16:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbjAZPPm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 10:15:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbjAZPPj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 10:15:39 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5D361851;
        Thu, 26 Jan 2023 07:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=l0DzCOJq4iPL3KosVlP6zvOaIMnRWOgU4qXiR+sg9ls=; b=vx0yzVEBCZzmRcRsPn/H2gna9O
        LvAeJI8uoFar8HqBemiwvXrejXgtgwV4z+UmZfzTVhtlr//iJe71lbkexUn9i+umTWkjRgTBnopyT
        sWoxB93i1+RklzZSidY8m2MJTviacK+tjSxFCtLEpJILXssOV1ar+ITNIZBEWz6hBd0aYZG/EGoL9
        TNRwr3yG9DZ0NyE42Mc3tfn5PtoF3lCVGGz1FQG4W4pHeVUHX7i8AdAU1iTioeLECvcDSq7QHfkYY
        LDeDK8zB8jpiDfJ1Z5nm+x/z/G6UEbwuD9QAVzusi4Hq0nq9Z640wanoqrhYjUP3ouydeJfVEPQik
        NLl/l6zw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pL3xn-006qUD-F6; Thu, 26 Jan 2023 15:14:56 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2EAEA300ECD;
        Thu, 26 Jan 2023 16:14:53 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 0DDD020138B1D; Thu, 26 Jan 2023 16:14:53 +0100 (CET)
Message-ID: <20230126151323.408156109@infradead.org>
User-Agent: quilt/0.66
Date:   Thu, 26 Jan 2023 16:08:31 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     mingo@kernel.org
Cc:     will@kernel.org, peterz@infradead.org, boqun.feng@gmail.com,
        mark.rutland@arm.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com,
        jgross@suse.com, srivatsa@csail.mit.edu, amakhalov@vmware.com,
        pv-drivers@vmware.com, wanpengli@tencent.com, vkuznets@redhat.com,
        boris.ostrovsky@oracle.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, lpieralisi@kernel.org,
        frederic@kernel.org, paulmck@kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, longman@redhat.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        bsegall@google.com, mgorman@suse.de, bristot@redhat.com,
        vschneid@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-pm@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: [PATCH v2 2/9] bug: Disable rcu_is_watching() during WARN/BUG
References: <20230126150829.087606759@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to avoid WARN/BUG from generating nested or even recursive
warnings, force rcu_is_watching() true during
WARN/lockdep_rcu_suspicious().

Notably things like unwinding the stack can trigger rcu_dereference()
warnings, which then triggers more unwinding which then triggers more
warnings etc..

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/context_tracking.h |   27 +++++++++++++++++++++++++++
 kernel/locking/lockdep.c         |    3 +++
 kernel/panic.c                   |    5 +++++
 lib/bug.c                        |   15 ++++++++++++++-
 4 files changed, 49 insertions(+), 1 deletion(-)

--- a/include/linux/context_tracking.h
+++ b/include/linux/context_tracking.h
@@ -130,9 +130,36 @@ static __always_inline unsigned long ct_
 	return arch_atomic_add_return(incby, this_cpu_ptr(&context_tracking.state));
 }
 
+static __always_inline bool warn_rcu_enter(void)
+{
+	bool ret = false;
+
+	/*
+	 * Horrible hack to shut up recursive RCU isn't watching fail since
+	 * lots of the actual reporting also relies on RCU.
+	 */
+	preempt_disable_notrace();
+	if (rcu_dynticks_curr_cpu_in_eqs()) {
+		ret = true;
+		ct_state_inc(RCU_DYNTICKS_IDX);
+	}
+
+	return ret;
+}
+
+static __always_inline void warn_rcu_exit(bool rcu)
+{
+	if (rcu)
+		ct_state_inc(RCU_DYNTICKS_IDX);
+	preempt_enable_notrace();
+}
+
 #else
 static inline void ct_idle_enter(void) { }
 static inline void ct_idle_exit(void) { }
+
+static __always_inline bool warn_rcu_enter(void) { return false; }
+static __always_inline void warn_rcu_exit(bool rcu) { }
 #endif /* !CONFIG_CONTEXT_TRACKING_IDLE */
 
 #endif
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -55,6 +55,7 @@
 #include <linux/rcupdate.h>
 #include <linux/kprobes.h>
 #include <linux/lockdep.h>
+#include <linux/context_tracking.h>
 
 #include <asm/sections.h>
 
@@ -6555,6 +6556,7 @@ void lockdep_rcu_suspicious(const char *
 {
 	struct task_struct *curr = current;
 	int dl = READ_ONCE(debug_locks);
+	bool rcu = warn_rcu_enter();
 
 	/* Note: the following can be executed concurrently, so be careful. */
 	pr_warn("\n");
@@ -6595,5 +6597,6 @@ void lockdep_rcu_suspicious(const char *
 	lockdep_print_held_locks(curr);
 	pr_warn("\nstack backtrace:\n");
 	dump_stack();
+	warn_rcu_exit(rcu);
 }
 EXPORT_SYMBOL_GPL(lockdep_rcu_suspicious);
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -34,6 +34,7 @@
 #include <linux/ratelimit.h>
 #include <linux/debugfs.h>
 #include <linux/sysfs.h>
+#include <linux/context_tracking.h>
 #include <trace/events/error_report.h>
 #include <asm/sections.h>
 
@@ -679,6 +680,7 @@ void __warn(const char *file, int line,
 void warn_slowpath_fmt(const char *file, int line, unsigned taint,
 		       const char *fmt, ...)
 {
+	bool rcu = warn_rcu_enter();
 	struct warn_args args;
 
 	pr_warn(CUT_HERE);
@@ -693,11 +695,13 @@ void warn_slowpath_fmt(const char *file,
 	va_start(args.args, fmt);
 	__warn(file, line, __builtin_return_address(0), taint, NULL, &args);
 	va_end(args.args);
+	warn_rcu_exit(rcu);
 }
 EXPORT_SYMBOL(warn_slowpath_fmt);
 #else
 void __warn_printk(const char *fmt, ...)
 {
+	bool rcu = warn_rcu_enter();
 	va_list args;
 
 	pr_warn(CUT_HERE);
@@ -705,6 +709,7 @@ void __warn_printk(const char *fmt, ...)
 	va_start(args, fmt);
 	vprintk(fmt, args);
 	va_end(args);
+	warn_rcu_exit(rcu);
 }
 EXPORT_SYMBOL(__warn_printk);
 #endif
--- a/lib/bug.c
+++ b/lib/bug.c
@@ -47,6 +47,7 @@
 #include <linux/sched.h>
 #include <linux/rculist.h>
 #include <linux/ftrace.h>
+#include <linux/context_tracking.h>
 
 extern struct bug_entry __start___bug_table[], __stop___bug_table[];
 
@@ -153,7 +154,7 @@ struct bug_entry *find_bug(unsigned long
 	return module_find_bug(bugaddr);
 }
 
-enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
+static enum bug_trap_type __report_bug(unsigned long bugaddr, struct pt_regs *regs)
 {
 	struct bug_entry *bug;
 	const char *file;
@@ -209,6 +210,18 @@ enum bug_trap_type report_bug(unsigned l
 	return BUG_TRAP_TYPE_BUG;
 }
 
+enum bug_trap_type report_bug(unsigned long bugaddr, struct pt_regs *regs)
+{
+	enum bug_trap_type ret;
+	bool rcu = false;
+
+	rcu = warn_rcu_enter();
+	ret = __report_bug(bugaddr, regs);
+	warn_rcu_exit(rcu);
+
+	return ret;
+}
+
 static void clear_once_table(struct bug_entry *start, struct bug_entry *end)
 {
 	struct bug_entry *bug;


