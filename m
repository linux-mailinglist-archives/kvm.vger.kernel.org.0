Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3AB37BB74
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 13:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhELLLx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 07:11:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:51046 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230035AbhELLLw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 07:11:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D58ABB028;
        Wed, 12 May 2021 11:10:43 +0000 (UTC)
Date:   Wed, 12 May 2021 12:10:40 +0100
From:   Mel Gorman <mgorman@suse.de>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     tglx@linutronix.de, mingo@kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, bristot@redhat.com,
        bsingharora@gmail.com, pbonzini@redhat.com, maz@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        riel@surriel.com, hannes@cmpxchg.org
Subject: Re: [PATCH 3/6] sched: Simplify sched_info_on()
Message-ID: <20210512111040.GC3672@suse.de>
References: <20210505105940.190490250@infradead.org>
 <20210505111525.121458839@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210505111525.121458839@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 05, 2021 at 12:59:43PM +0200, Peter Zijlstra wrote:
> The situation around sched_info is somewhat complicated, it is used by
> sched_stats and delayacct and, indirectly, kvm.
> 
> If SCHEDSTATS=Y (but disabled by default) sched_info_on() is
> unconditionally true -- this is the case for all distro kernel configs
> I checked.
> 
> If for some reason SCHEDSTATS=N, but TASK_DELAY_ACCT=Y, then
> sched_info_on() can return false when delayacct is disabled,
> presumably because there would be no other users left; except kvm is.
> 
> Instead of complicating matters further by accurately accounting
> sched_stat and kvm state, simply unconditionally enable when
> SCHED_INFO=Y, matching the common distro case.
> 
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> @@ -163,13 +158,12 @@ static inline void sched_info_reset_dequ
>   */
>  static inline void sched_info_dequeue(struct rq *rq, struct task_struct *t)
>  {
> -	unsigned long long now = rq_clock(rq), delta = 0;
> +	unsigned long long delta = 0;
>  
> -	if (sched_info_on()) {
> -		if (t->sched_info.last_queued)
> -			delta = now - t->sched_info.last_queued;
> +	if (t->sched_info.last_queued) {
> +		delta = rq_clock(rq) - t->sched_info.last_queued;
> +		t->sched_info.last_queued = 0;
>  	}
> -	sched_info_reset_dequeued(t);
>  	t->sched_info.run_delay += delta;
>  
>  	rq_sched_info_dequeue(rq, delta);

As delta is !0 iff t->sched_info.last_queued, why not this?

diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
index 33ffd41935ba..37e33c0eeb7c 100644
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -158,15 +158,14 @@ static inline void psi_sched_switch(struct task_struct *prev,
  */
 static inline void sched_info_dequeue(struct rq *rq, struct task_struct *t)
 {
-	unsigned long long delta = 0;
-
 	if (t->sched_info.last_queued) {
+		unsigned long long delta;
+
 		delta = rq_clock(rq) - t->sched_info.last_queued;
 		t->sched_info.last_queued = 0;
+		t->sched_info.run_delay += delta;
+		rq_sched_info_dequeue(rq, delta);
 	}
-	t->sched_info.run_delay += delta;
-
-	rq_sched_info_dequeue(rq, delta);
 }
 
 /*

> @@ -184,9 +178,10 @@ static void sched_info_arrive(struct rq
>  {
>  	unsigned long long now = rq_clock(rq), delta = 0;
>  
> -	if (t->sched_info.last_queued)
> +	if (t->sched_info.last_queued) {
>  		delta = now - t->sched_info.last_queued;
> -	sched_info_reset_dequeued(t);
> +		t->sched_info.last_queued = 0;
> +	}
>  	t->sched_info.run_delay += delta;
>  	t->sched_info.last_arrival = now;
>  	t->sched_info.pcount++;

Similarly

@@ -176,17 +175,18 @@ static inline void sched_info_dequeue(struct rq *rq, struct task_struct *t)
  */
 static void sched_info_arrive(struct rq *rq, struct task_struct *t)
 {
-	unsigned long long now = rq_clock(rq), delta = 0;
+	unsigned long long now = rq_clock(rq);
 
 	if (t->sched_info.last_queued) {
+		unsigned long long delta;
+
 		delta = now - t->sched_info.last_queued;
 		t->sched_info.last_queued = 0;
+		t->sched_info.run_delay += delta;
+		rq_sched_info_arrive(rq, delta);
 	}
-	t->sched_info.run_delay += delta;
 	t->sched_info.last_arrival = now;
 	t->sched_info.pcount++;
-
-	rq_sched_info_arrive(rq, delta);
 }
 
 /*

-- 
Mel Gorman
SUSE Labs
