Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D9B373931
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 13:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbhEELWS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 07:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232967AbhEELV7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 07:21:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE6CAC061763;
        Wed,  5 May 2021 04:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=knZbfT8+eIFIsMjLBY2UuSxf8ltNwAg+fgyQDo4qiWI=; b=Tit4GMyOzVVskqtUu9EAtmQXbl
        /D1ARDmeAKmr7l2NIk8XIHGRZ4wdLNAfefNyVscP6k482JFkRe712BpfWwcfqnBrjmcynugBq471O
        70D/wOWUfijEm7B9jggyY0mcZol0pL118qtQkLA0C1PuuM8fRujPVyUllMjnXIgqMH085YoSau4Oa
        JPbGGn0zLxFylMTndtS65jzu9h0ge9RiGqZzmBnplk8XbASOCWRkC8VVE2LbyUm8YFnMDjbuSTFgc
        tXCqvC9BOVSWxg0D5UtKe9BgI/93Irhei1TcIU6aKT35xIt2Z1faUlBNWDqLFX/rwybeud07FSM0O
        3ucWZRUA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1leFXm-000FR8-02; Wed, 05 May 2021 11:18:44 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2F9DA3002A8;
        Wed,  5 May 2021 13:18:15 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id E016D299E985D; Wed,  5 May 2021 13:18:14 +0200 (CEST)
Message-ID: <20210505111525.001031466@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 05 May 2021 12:59:41 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     tglx@linutronix.de, mingo@kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, bsingharora@gmail.com, pbonzini@redhat.com,
        maz@kernel.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        peterz@infradead.org, riel@surriel.com, hannes@cmpxchg.org
Subject: [PATCH 1/6] delayacct: Use sched_clock()
References: <20210505105940.190490250@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Like all scheduler statistics, use sched_clock() based time.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 kernel/delayacct.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/kernel/delayacct.c
+++ b/kernel/delayacct.c
@@ -7,9 +7,9 @@
 #include <linux/sched.h>
 #include <linux/sched/task.h>
 #include <linux/sched/cputime.h>
+#include <linux/sched/clock.h>
 #include <linux/slab.h>
 #include <linux/taskstats.h>
-#include <linux/time.h>
 #include <linux/sysctl.h>
 #include <linux/delayacct.h>
 #include <linux/module.h>
@@ -42,10 +42,9 @@ void __delayacct_tsk_init(struct task_st
  * Finish delay accounting for a statistic using its timestamps (@start),
  * accumalator (@total) and @count
  */
-static void delayacct_end(raw_spinlock_t *lock, u64 *start, u64 *total,
-			  u32 *count)
+static void delayacct_end(raw_spinlock_t *lock, u64 *start, u64 *total, u32 *count)
 {
-	s64 ns = ktime_get_ns() - *start;
+	s64 ns = local_clock() - *start;
 	unsigned long flags;
 
 	if (ns > 0) {
@@ -58,7 +57,7 @@ static void delayacct_end(raw_spinlock_t
 
 void __delayacct_blkio_start(void)
 {
-	current->delays->blkio_start = ktime_get_ns();
+	current->delays->blkio_start = local_clock();
 }
 
 /*
@@ -151,21 +150,20 @@ __u64 __delayacct_blkio_ticks(struct tas
 
 void __delayacct_freepages_start(void)
 {
-	current->delays->freepages_start = ktime_get_ns();
+	current->delays->freepages_start = local_clock();
 }
 
 void __delayacct_freepages_end(void)
 {
-	delayacct_end(
-		&current->delays->lock,
-		&current->delays->freepages_start,
-		&current->delays->freepages_delay,
-		&current->delays->freepages_count);
+	delayacct_end(&current->delays->lock,
+		      &current->delays->freepages_start,
+		      &current->delays->freepages_delay,
+		      &current->delays->freepages_count);
 }
 
 void __delayacct_thrashing_start(void)
 {
-	current->delays->thrashing_start = ktime_get_ns();
+	current->delays->thrashing_start = local_clock();
 }
 
 void __delayacct_thrashing_end(void)


