Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB818709514
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 12:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbjESKe5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 06:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbjESKeT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 06:34:19 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D2B10DC;
        Fri, 19 May 2023 03:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=vb5RHA5WAD/i+pcNIxyZaXw8sGymL5Wslp2oL9HHf5o=; b=EiPZwCG1U/KNRhYpgNKpzRQuLb
        7xFTEZkWp7Gmon4O45hOp9YVGPqFVdoAzxEPJCs3eYe9DgCZVQiKr5YCcGJtGMP6GOTajZGKfVPvj
        8FTv/2HjVMv8u4vaKGnC6QGsdqtqJNZkskhydvRzuSu7JbvBQES81l4E8TppOCmAtYImFCH8TnnFw
        x1EycU83oVTk52DdnAKhfUez6y7RsoYGk8HLKW1FNPoA1wly3HbHfI3gWKazRnVrliBkafyoPPQcb
        tyQQUWYv0N8EVcOQKgokb9+WCX4Ays6FmnKvNOQt3Pp86pE1oVXWwCr44x2Ud0UZYAqMHU3tkW4X+
        d9I2vVZQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pzxPv-006UqJ-1G; Fri, 19 May 2023 10:32:59 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 66122306158;
        Fri, 19 May 2023 12:32:56 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 02484235EF0B4; Fri, 19 May 2023 12:32:56 +0200 (CEST)
Message-ID: <20230519102716.045980863@infradead.org>
User-Agent: quilt/0.66
Date:   Fri, 19 May 2023 12:21:11 +0200
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
Subject: [PATCH v2 13/13] cpuidle: Use local_clock_noinstr()
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

With the introduction of local_clock_noinstr(), local_clock() itself
is no longer marked noinstr, use the correct function.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 drivers/cpuidle/cpuidle.c    |    8 ++++----
 drivers/cpuidle/poll_state.c |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -145,7 +145,7 @@ static noinstr void enter_s2idle_proper(
 
 	instrumentation_begin();
 
-	time_start = ns_to_ktime(local_clock());
+	time_start = ns_to_ktime(local_clock_noinstr());
 
 	tick_freeze();
 	/*
@@ -169,7 +169,7 @@ static noinstr void enter_s2idle_proper(
 	tick_unfreeze();
 	start_critical_timings();
 
-	time_end = ns_to_ktime(local_clock());
+	time_end = ns_to_ktime(local_clock_noinstr());
 
 	dev->states_usage[index].s2idle_time += ktime_us_delta(time_end, time_start);
 	dev->states_usage[index].s2idle_usage++;
@@ -243,7 +243,7 @@ noinstr int cpuidle_enter_state(struct c
 	sched_idle_set_state(target_state);
 
 	trace_cpu_idle(index, dev->cpu);
-	time_start = ns_to_ktime(local_clock());
+	time_start = ns_to_ktime(local_clock_noinstr());
 
 	stop_critical_timings();
 	if (!(target_state->flags & CPUIDLE_FLAG_RCU_IDLE)) {
@@ -276,7 +276,7 @@ noinstr int cpuidle_enter_state(struct c
 	start_critical_timings();
 
 	sched_clock_idle_wakeup_event();
-	time_end = ns_to_ktime(local_clock());
+	time_end = ns_to_ktime(local_clock_noinstr());
 	trace_cpu_idle(PWR_EVENT_EXIT, dev->cpu);
 
 	/* The cpu is no longer idle or about to enter idle. */
--- a/drivers/cpuidle/poll_state.c
+++ b/drivers/cpuidle/poll_state.c
@@ -15,7 +15,7 @@ static int __cpuidle poll_idle(struct cp
 {
 	u64 time_start;
 
-	time_start = local_clock();
+	time_start = local_clock_noinstr();
 
 	dev->poll_time_limit = false;
 
@@ -32,7 +32,7 @@ static int __cpuidle poll_idle(struct cp
 				continue;
 
 			loop_count = 0;
-			if (local_clock() - time_start > limit) {
+			if (local_clock_noinstr() - time_start > limit) {
 				dev->poll_time_limit = true;
 				break;
 			}


