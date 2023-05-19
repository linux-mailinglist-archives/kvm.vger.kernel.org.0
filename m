Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D46AA709501
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 12:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbjESKej (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 06:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231964AbjESKeV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 06:34:21 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 641B0E66;
        Fri, 19 May 2023 03:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=H7LxrFsb985fkK1T+mF0ZsG8uLGdOc8qkU4ev4xL54A=; b=YgwIUdvHAG2hMd/puvkzqCdCOH
        FzRZBTNLiFtvQFxmAPYeCKCJSUYa+6tqxQPmap+o05Z6izIEnA2ONs1Ju2uf5T/K7m7IkdE4R2BoQ
        n9deQpuO4y1zKChLIrvNguhLbgiOAm+qTiHasDEA1AYRLDEHCDK5ZgQ6vD8Pglvlzqe5OR15fzgVc
        1poftjuN51rTjciFXymVYqaFY94uIwoix7zZ0+cnU8hDmC3Nc+7Y1cyJ+4BQ3UkARJfUgkOlvGHv8
        Sohua1FBapLJMC4QCoCtkLftpNOmg4OYkgFiEy7NZqNgUXichb64xlwj3lbdKTg0DLH28RNH/mqm2
        Wn9WraGg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pzxPv-006UqR-ME; Fri, 19 May 2023 10:33:00 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 508CD306154;
        Fri, 19 May 2023 12:32:56 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id F35F9235EF0B5; Fri, 19 May 2023 12:32:55 +0200 (CEST)
Message-ID: <20230519102715.978624636@infradead.org>
User-Agent: quilt/0.66
Date:   Fri, 19 May 2023 12:21:10 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     bigeasy@linutronix.de
Cc:     mark.rutland@arm.com, maz@kernel.org, catalin.marinas@arm.com,
        will@kernel.org, chenhuacai@kernel.org, kernel@xen0n.name,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com,
        pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        jgross@suse.com, boris.ostrovsky@oracle.com,
        daniel.lezcano@linaro.org, kys@microsoft.com,
        haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        rafael@kernel.org, peterz@infradead.org, longman@redhat.com,
        boqun.feng@gmail.com, pmladek@suse.com, senozhatsky@chromium.org,
        rostedt@goodmis.org, john.ogness@linutronix.de,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        dietmar.eggemann@arm.com, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, vschneid@redhat.com, jstultz@google.com,
        sboyd@kernel.org, linux-kernel@vger.kernel.org,
        loongarch@lists.linux.dev, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH v2 12/13] sched/clock: Provide local_clock_noinstr()
References: <20230519102058.581557770@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that all ARCH_WANTS_NO_INSTR architectures (arm64, loongarch,
s390, x86) provide sched_clock_noinstr(), use this to provide
local_clock_noinstr().

This local_clock_noinstr() will be safe to use from noinstr code with
the assumption that any such noinstr code is non-preemptible (it had
better be, entry code will have IRQs disabled while __cpuidle must
have preemption disabled).

Specifically, preempt_enable_notrace(), a common part of many a
sched_clock() implementation calls out to schedule() -- even though,
per the above, it will never trigger -- which frustrates noinstr
validation.

  vmlinux.o: warning: objtool: local_clock+0xb5: call to preempt_schedule_notrace_thunk() leaves .noinstr.text section

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/sched/clock.h |   17 ++++++++++++++++-
 kernel/sched/clock.c        |   19 +++++++++++++------
 2 files changed, 29 insertions(+), 7 deletions(-)

--- a/include/linux/sched/clock.h
+++ b/include/linux/sched/clock.h
@@ -12,7 +12,16 @@
  *
  * Please use one of the three interfaces below.
  */
-extern unsigned long long notrace sched_clock(void);
+extern u64 sched_clock(void);
+
+#if defined(CONFIG_ARCH_WANTS_NO_INSTR) || defined(CONFIG_GENERIC_SCHED_CLOCK)
+extern u64 sched_clock_noinstr(void);
+#else
+static __always_inline u64 sched_clock_noinstr(void)
+{
+	return sched_clock();
+}
+#endif
 
 /*
  * See the comment in kernel/sched/clock.c
@@ -45,6 +54,11 @@ static inline u64 cpu_clock(int cpu)
 	return sched_clock();
 }
 
+static __always_inline u64 local_clock_noinstr(void)
+{
+	return sched_clock_noinstr();
+}
+
 static __always_inline u64 local_clock(void)
 {
 	return sched_clock();
@@ -79,6 +93,7 @@ static inline u64 cpu_clock(int cpu)
 	return sched_clock_cpu(cpu);
 }
 
+extern u64 local_clock_noinstr(void);
 extern u64 local_clock(void);
 
 #endif
--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -266,7 +266,7 @@ static __always_inline u64 sched_clock_l
 	s64 delta;
 
 again:
-	now = sched_clock();
+	now = sched_clock_noinstr();
 	delta = now - scd->tick_raw;
 	if (unlikely(delta < 0))
 		delta = 0;
@@ -293,22 +293,29 @@ static __always_inline u64 sched_clock_l
 	return clock;
 }
 
-noinstr u64 local_clock(void)
+noinstr u64 local_clock_noinstr(void)
 {
 	u64 clock;
 
 	if (static_branch_likely(&__sched_clock_stable))
-		return sched_clock() + __sched_clock_offset;
+		return sched_clock_noinstr() + __sched_clock_offset;
 
 	if (!static_branch_likely(&sched_clock_running))
-		return sched_clock();
+		return sched_clock_noinstr();
 
-	preempt_disable_notrace();
 	clock = sched_clock_local(this_scd());
-	preempt_enable_notrace();
 
 	return clock;
 }
+
+u64 local_clock(void)
+{
+	u64 now;
+	preempt_disable_notrace();
+	now = local_clock_noinstr();
+	preempt_enable_notrace();
+	return now;
+}
 EXPORT_SYMBOL_GPL(local_clock);
 
 static notrace u64 sched_clock_remote(struct sched_clock_data *scd)


