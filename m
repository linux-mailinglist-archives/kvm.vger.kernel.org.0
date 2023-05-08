Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF4C66FB9E6
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 23:36:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234085AbjEHVgC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 17:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233588AbjEHVfy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 17:35:54 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 738AD9ED1;
        Mon,  8 May 2023 14:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=vb5RHA5WAD/i+pcNIxyZaXw8sGymL5Wslp2oL9HHf5o=; b=tCSw7wyzM5jCUBmoiGImrzrVMf
        H/ZkDYGbPCkHyTxMrtpf+U6dHzUyVsPW7AEfG0XssOJSV4kg3e8pz7ZJKIt2zgel1Tg3scu0q87KX
        XOGfQLNrVl701X/bZl65glhBPOZfF/4zUxmiv7nVkkSPkyGMxinwX/GHPApF9GoBvs9bYw6r7ewxn
        X4tTNuQUxRZNTcX8fh50RBEUA8q/DMH4OvtBRsskPQPXuLsLNENKNssUXCF141sZwuMRTOp+ricCh
        X8jdVIBKJsrzV1GFPWKS5U8xiSZcmMDh8vZXIac4hlaS2z4/Hlb/evVbvzVzGW+FVjdzYIKs0Vb/s
        ffwGxzrA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pw8UZ-00EW3n-C8; Mon, 08 May 2023 21:33:59 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id CA95230614B;
        Mon,  8 May 2023 23:33:48 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 52A012482942D; Mon,  8 May 2023 23:33:48 +0200 (CEST)
Message-ID: <20230508213147.990013706@infradead.org>
User-Agent: quilt/0.66
Date:   Mon, 08 May 2023 23:20:00 +0200
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
Subject: [RFC][PATCH 9/9] cpuidle: Use local_clock_noinstr()
References: <20230508211951.901961964@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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


