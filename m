Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D0A373927
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 13:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232902AbhEELTh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 07:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbhEELTg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 07:19:36 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73057C061574;
        Wed,  5 May 2021 04:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=RHDX0FLVG6dTYnJm4oxsEkYWJqHDZhBGOgcQMNzy7lw=; b=iOGlkqlEkOOD76NRGpiIY+xVOs
        X4qiOzazGIqQhZgwgrckQTOqVkrIjbNQpuMgMBME88MzsqwC5UBuGGi8vRRIbHMuDIc2V3z6PAFbu
        p78rPpiOwCgYaVH/vFFDqK1fVKirQ6104M7odj3vsPgUWYwEFVsY1D78SEhB5hDGu1L+UHb2O1FTV
        PPKyAQIXk1frfPNN3kAtga0LsZp91RWbC7OTSDTX+ONAzbLrSZzjdWemmeHJBlvex48LxOLhCuSm/
        SPovU5UVV7T9daAdrCCMk5u4uQosvmcAjWWjFer+vUKWLGYYjcm8YyMXO3WYYhecquKXQAswfKjP3
        H1hr0Aag==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1leFXl-0014WE-I2; Wed, 05 May 2021 11:18:19 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2902330022C;
        Wed,  5 May 2021 13:18:15 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id E766F299E9865; Wed,  5 May 2021 13:18:14 +0200 (CEST)
Message-ID: <20210505111525.121458839@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 05 May 2021 12:59:43 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     tglx@linutronix.de, mingo@kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, bsingharora@gmail.com, pbonzini@redhat.com,
        maz@kernel.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        peterz@infradead.org, riel@surriel.com, hannes@cmpxchg.org
Subject: [PATCH 3/6] sched: Simplify sched_info_on()
References: <20210505105940.190490250@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The situation around sched_info is somewhat complicated, it is used by
sched_stats and delayacct and, indirectly, kvm.

If SCHEDSTATS=Y (but disabled by default) sched_info_on() is
unconditionally true -- this is the case for all distro kernel configs
I checked.

If for some reason SCHEDSTATS=N, but TASK_DELAY_ACCT=Y, then
sched_info_on() can return false when delayacct is disabled,
presumably because there would be no other users left; except kvm is.

Instead of complicating matters further by accurately accounting
sched_stat and kvm state, simply unconditionally enable when
SCHED_INFO=Y, matching the common distro case.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/sched/stat.h |   10 ++--------
 kernel/delayacct.c         |    1 -
 kernel/sched/stats.h       |   37 ++++++++++---------------------------
 3 files changed, 12 insertions(+), 36 deletions(-)

--- a/include/linux/sched/stat.h
+++ b/include/linux/sched/stat.h
@@ -3,6 +3,7 @@
 #define _LINUX_SCHED_STAT_H
 
 #include <linux/percpu.h>
+#include <linux/kconfig.h>
 
 /*
  * Various counters maintained by the scheduler and fork(),
@@ -23,14 +24,7 @@ extern unsigned long nr_iowait_cpu(int c
 
 static inline int sched_info_on(void)
 {
-#ifdef CONFIG_SCHEDSTATS
-	return 1;
-#elif defined(CONFIG_TASK_DELAY_ACCT)
-	extern int delayacct_on;
-	return delayacct_on;
-#else
-	return 0;
-#endif
+	return IS_ENABLED(CONFIG_SCHED_INFO);
 }
 
 #ifdef CONFIG_SCHEDSTATS
--- a/kernel/delayacct.c
+++ b/kernel/delayacct.c
@@ -15,7 +15,6 @@
 #include <linux/module.h>
 
 int delayacct_on __read_mostly = 1;	/* Delay accounting turned on/off */
-EXPORT_SYMBOL_GPL(delayacct_on);
 struct kmem_cache *delayacct_cache;
 
 static int __init delayacct_setup_disable(char *str)
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -150,11 +150,6 @@ static inline void psi_sched_switch(stru
 #endif /* CONFIG_PSI */
 
 #ifdef CONFIG_SCHED_INFO
-static inline void sched_info_reset_dequeued(struct task_struct *t)
-{
-	t->sched_info.last_queued = 0;
-}
-
 /*
  * We are interested in knowing how long it was from the *first* time a
  * task was queued to the time that it finally hit a CPU, we call this routine
@@ -163,13 +158,12 @@ static inline void sched_info_reset_dequ
  */
 static inline void sched_info_dequeue(struct rq *rq, struct task_struct *t)
 {
-	unsigned long long now = rq_clock(rq), delta = 0;
+	unsigned long long delta = 0;
 
-	if (sched_info_on()) {
-		if (t->sched_info.last_queued)
-			delta = now - t->sched_info.last_queued;
+	if (t->sched_info.last_queued) {
+		delta = rq_clock(rq) - t->sched_info.last_queued;
+		t->sched_info.last_queued = 0;
 	}
-	sched_info_reset_dequeued(t);
 	t->sched_info.run_delay += delta;
 
 	rq_sched_info_dequeue(rq, delta);
@@ -184,9 +178,10 @@ static void sched_info_arrive(struct rq
 {
 	unsigned long long now = rq_clock(rq), delta = 0;
 
-	if (t->sched_info.last_queued)
+	if (t->sched_info.last_queued) {
 		delta = now - t->sched_info.last_queued;
-	sched_info_reset_dequeued(t);
+		t->sched_info.last_queued = 0;
+	}
 	t->sched_info.run_delay += delta;
 	t->sched_info.last_arrival = now;
 	t->sched_info.pcount++;
@@ -201,10 +196,8 @@ static void sched_info_arrive(struct rq
  */
 static inline void sched_info_enqueue(struct rq *rq, struct task_struct *t)
 {
-	if (sched_info_on()) {
-		if (!t->sched_info.last_queued)
-			t->sched_info.last_queued = rq_clock(rq);
-	}
+	if (!t->sched_info.last_queued)
+		t->sched_info.last_queued = rq_clock(rq);
 }
 
 /*
@@ -231,7 +224,7 @@ static inline void sched_info_depart(str
  * the idle task.)  We are only called when prev != next.
  */
 static inline void
-__sched_info_switch(struct rq *rq, struct task_struct *prev, struct task_struct *next)
+sched_info_switch(struct rq *rq, struct task_struct *prev, struct task_struct *next)
 {
 	/*
 	 * prev now departs the CPU.  It's not interesting to record
@@ -245,18 +238,8 @@ __sched_info_switch(struct rq *rq, struc
 		sched_info_arrive(rq, next);
 }
 
-static inline void
-sched_info_switch(struct rq *rq, struct task_struct *prev, struct task_struct *next)
-{
-	if (sched_info_on())
-		__sched_info_switch(rq, prev, next);
-}
-
 #else /* !CONFIG_SCHED_INFO: */
 # define sched_info_enqueue(rq, t)	do { } while (0)
-# define sched_info_reset_dequeued(t)	do { } while (0)
 # define sched_info_dequeue(rq, t)	do { } while (0)
-# define sched_info_depart(rq, t)	do { } while (0)
-# define sched_info_arrive(rq, next)	do { } while (0)
 # define sched_info_switch(rq, t, next)	do { } while (0)
 #endif /* CONFIG_SCHED_INFO */


