Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C04767CFAA
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 16:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbjAZPPu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 10:15:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbjAZPPl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 10:15:41 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4B94740B;
        Thu, 26 Jan 2023 07:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=YEKkyvTZ05I2hq93YUH2assl5KDOT02g9Cn+Y86W8Rg=; b=SoV17rTENpYVgcWXTPv/sGdBPn
        vpjNtXuSCV1HZytAHinNzdEN/g3C3V78+6SMrD/vm8nXGBaoeAmIVgP6Pj7ybkWY9vV1yKWVovkAX
        iTdrgHaQNSxC1QuKg95EHjdBqytYpTJFT/a7qLSJ5n3SmRCowSDrqbUVlhYGc5P55D0jQD5bX3Be8
        YObkOaVvxiFpZMDQt+1SMt/BTQOecqoozb+o+GTt7KgxZSGtjfrqhjXcGwLinOKpaM7ikv+JQFNR/
        HgKTCoJ2LrfhVv4OSDwp/q74WHMlHON14XfDY1l7U40J3SNuagsx5HTJ1KQHQWrQ+8W7aUI2rbiuR
        EO4FdU8g==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pL3xI-002U1m-1w;
        Thu, 26 Jan 2023 15:14:24 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 880523021F5;
        Thu, 26 Jan 2023 16:14:54 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 2E2812084C4AD; Thu, 26 Jan 2023 16:14:53 +0100 (CET)
Message-ID: <20230126151323.760767043@infradead.org>
User-Agent: quilt/0.66
Date:   Thu, 26 Jan 2023 16:08:37 +0100
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
Subject: [PATCH v2 8/9] sched/clock: Make local_clock() noinstr
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

With sched_clock() noinstr, provide a noinstr implementation of
local_clock().

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/sched/clock.h |    8 +++-----
 kernel/sched/clock.c        |   27 +++++++++++++++++++++------
 2 files changed, 24 insertions(+), 11 deletions(-)

--- a/include/linux/sched/clock.h
+++ b/include/linux/sched/clock.h
@@ -45,7 +45,7 @@ static inline u64 cpu_clock(int cpu)
 	return sched_clock();
 }
 
-static inline u64 local_clock(void)
+static __always_inline u64 local_clock(void)
 {
 	return sched_clock();
 }
@@ -79,10 +79,8 @@ static inline u64 cpu_clock(int cpu)
 	return sched_clock_cpu(cpu);
 }
 
-static inline u64 local_clock(void)
-{
-	return sched_clock_cpu(raw_smp_processor_id());
-}
+extern u64 local_clock(void);
+
 #endif
 
 #ifdef CONFIG_IRQ_TIME_ACCOUNTING
--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -93,7 +93,7 @@ struct sched_clock_data {
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct sched_clock_data, sched_clock_data);
 
-notrace static inline struct sched_clock_data *this_scd(void)
+static __always_inline struct sched_clock_data *this_scd(void)
 {
 	return this_cpu_ptr(&sched_clock_data);
 }
@@ -244,12 +244,12 @@ late_initcall(sched_clock_init_late);
  * min, max except they take wrapping into account
  */
 
-notrace static inline u64 wrap_min(u64 x, u64 y)
+static __always_inline u64 wrap_min(u64 x, u64 y)
 {
 	return (s64)(x - y) < 0 ? x : y;
 }
 
-notrace static inline u64 wrap_max(u64 x, u64 y)
+static __always_inline u64 wrap_max(u64 x, u64 y)
 {
 	return (s64)(x - y) > 0 ? x : y;
 }
@@ -260,7 +260,7 @@ notrace static inline u64 wrap_max(u64 x
  *  - filter out backward motion
  *  - use the GTOD tick value to create a window to filter crazy TSC values
  */
-notrace static u64 sched_clock_local(struct sched_clock_data *scd)
+static __always_inline u64 sched_clock_local(struct sched_clock_data *scd)
 {
 	u64 now, clock, old_clock, min_clock, max_clock, gtod;
 	s64 delta;
@@ -287,13 +287,28 @@ notrace static u64 sched_clock_local(str
 	clock = wrap_max(clock, min_clock);
 	clock = wrap_min(clock, max_clock);
 
-	if (!try_cmpxchg64(&scd->clock, &old_clock, clock))
+	if (!arch_try_cmpxchg64(&scd->clock, &old_clock, clock))
 		goto again;
 
 	return clock;
 }
 
-notrace static u64 sched_clock_remote(struct sched_clock_data *scd)
+noinstr u64 local_clock(void)
+{
+	u64 clock;
+
+	if (static_branch_likely(&__sched_clock_stable))
+		return sched_clock() + __sched_clock_offset;
+
+	preempt_disable_notrace();
+	clock = sched_clock_local(this_scd());
+	preempt_enable_notrace();
+
+	return clock;
+}
+EXPORT_SYMBOL_GPL(local_clock);
+
+static notrace u64 sched_clock_remote(struct sched_clock_data *scd)
 {
 	struct sched_clock_data *my_scd = this_scd();
 	u64 this_clock, remote_clock;


