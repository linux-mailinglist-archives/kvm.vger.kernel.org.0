Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD1D37392A
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 13:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbhEELTk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 07:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232845AbhEELTg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 07:19:36 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1623C06174A;
        Wed,  5 May 2021 04:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=9mUN0n80qb4w4JfDlaVmbQ/bXpPVIekXWUK41bom3iw=; b=EmHBR7U/t43jAptJKMhecDD5Jt
        Fio//DnSuJ7fXh2YZSHvYlHuGVe9wVAX7zfsx6R/G3aCNRLr+0xwnd5ftp/Epq1SEFK5/OdAwzdVO
        knaSYxGp/2scBUVtD+1PWIN7RhF8SENnUuj/lTlHQLloc7k70FQuVbuKJkrhpK64o7ThNqoBTrwSU
        r9Rt1xaT5pPZm+Qm0XZR5NgW9/BERwwZcdKNUchLziK1c+dfgzkg2qDcaTYZumU1KYFCI1S2BYYkk
        qOvmCli/alFXUZR1p1pG34LSDnuXEBSF/ATKa7XrgTq/wHTQTeaQk7N4cMGUG66nerdks4CUB/7wo
        6c+PdGpQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1leFXl-0014WG-IK; Wed, 05 May 2021 11:18:19 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2D609300252;
        Wed,  5 May 2021 13:18:15 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id E2E6B299E9864; Wed,  5 May 2021 13:18:14 +0200 (CEST)
Message-ID: <20210505111525.061402904@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 05 May 2021 12:59:42 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     tglx@linutronix.de, mingo@kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, bsingharora@gmail.com, pbonzini@redhat.com,
        maz@kernel.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        peterz@infradead.org, riel@surriel.com, hannes@cmpxchg.org
Subject: [PATCH 2/6] sched: Rename sched_info_{queued,dequeued}
References: <20210505105940.190490250@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For consistency, rename {queued,dequeued} to {enqueue,dequeue}.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 kernel/sched/core.c  |    4 ++--
 kernel/sched/stats.h |   20 ++++++++++----------
 2 files changed, 12 insertions(+), 12 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1935,7 +1935,7 @@ static inline void enqueue_task(struct r
 		update_rq_clock(rq);
 
 	if (!(flags & ENQUEUE_RESTORE)) {
-		sched_info_queued(rq, p);
+		sched_info_enqueue(rq, p);
 		psi_enqueue(p, flags & ENQUEUE_WAKEUP);
 	}
 
@@ -1955,7 +1955,7 @@ static inline void dequeue_task(struct r
 		update_rq_clock(rq);
 
 	if (!(flags & DEQUEUE_SAVE)) {
-		sched_info_dequeued(rq, p);
+		sched_info_dequeue(rq, p);
 		psi_dequeue(p, flags & DEQUEUE_SLEEP);
 	}
 
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -25,7 +25,7 @@ rq_sched_info_depart(struct rq *rq, unsi
 }
 
 static inline void
-rq_sched_info_dequeued(struct rq *rq, unsigned long long delta)
+rq_sched_info_dequeue(struct rq *rq, unsigned long long delta)
 {
 	if (rq)
 		rq->rq_sched_info.run_delay += delta;
@@ -42,7 +42,7 @@ rq_sched_info_dequeued(struct rq *rq, un
 
 #else /* !CONFIG_SCHEDSTATS: */
 static inline void rq_sched_info_arrive  (struct rq *rq, unsigned long long delta) { }
-static inline void rq_sched_info_dequeued(struct rq *rq, unsigned long long delta) { }
+static inline void rq_sched_info_dequeue(struct rq *rq, unsigned long long delta) { }
 static inline void rq_sched_info_depart  (struct rq *rq, unsigned long long delta) { }
 # define   schedstat_enabled()		0
 # define __schedstat_inc(var)		do { } while (0)
@@ -161,7 +161,7 @@ static inline void sched_info_reset_dequ
  * from dequeue_task() to account for possible rq->clock skew across CPUs. The
  * delta taken on each CPU would annul the skew.
  */
-static inline void sched_info_dequeued(struct rq *rq, struct task_struct *t)
+static inline void sched_info_dequeue(struct rq *rq, struct task_struct *t)
 {
 	unsigned long long now = rq_clock(rq), delta = 0;
 
@@ -172,7 +172,7 @@ static inline void sched_info_dequeued(s
 	sched_info_reset_dequeued(t);
 	t->sched_info.run_delay += delta;
 
-	rq_sched_info_dequeued(rq, delta);
+	rq_sched_info_dequeue(rq, delta);
 }
 
 /*
@@ -197,9 +197,9 @@ static void sched_info_arrive(struct rq
 /*
  * This function is only called from enqueue_task(), but also only updates
  * the timestamp if it is already not set.  It's assumed that
- * sched_info_dequeued() will clear that stamp when appropriate.
+ * sched_info_dequeue() will clear that stamp when appropriate.
  */
-static inline void sched_info_queued(struct rq *rq, struct task_struct *t)
+static inline void sched_info_enqueue(struct rq *rq, struct task_struct *t)
 {
 	if (sched_info_on()) {
 		if (!t->sched_info.last_queued)
@@ -212,7 +212,7 @@ static inline void sched_info_queued(str
  * due, typically, to expiring its time slice (this may also be called when
  * switching to the idle task).  Now we can calculate how long we ran.
  * Also, if the process is still in the TASK_RUNNING state, call
- * sched_info_queued() to mark that it has now again started waiting on
+ * sched_info_enqueue() to mark that it has now again started waiting on
  * the runqueue.
  */
 static inline void sched_info_depart(struct rq *rq, struct task_struct *t)
@@ -222,7 +222,7 @@ static inline void sched_info_depart(str
 	rq_sched_info_depart(rq, delta);
 
 	if (t->state == TASK_RUNNING)
-		sched_info_queued(rq, t);
+		sched_info_enqueue(rq, t);
 }
 
 /*
@@ -253,9 +253,9 @@ sched_info_switch(struct rq *rq, struct
 }
 
 #else /* !CONFIG_SCHED_INFO: */
-# define sched_info_queued(rq, t)	do { } while (0)
+# define sched_info_enqueue(rq, t)	do { } while (0)
 # define sched_info_reset_dequeued(t)	do { } while (0)
-# define sched_info_dequeued(rq, t)	do { } while (0)
+# define sched_info_dequeue(rq, t)	do { } while (0)
 # define sched_info_depart(rq, t)	do { } while (0)
 # define sched_info_arrive(rq, next)	do { } while (0)
 # define sched_info_switch(rq, t, next)	do { } while (0)


