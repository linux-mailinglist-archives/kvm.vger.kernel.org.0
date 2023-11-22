Return-Path: <kvm+bounces-2265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 378407F431B
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 11:04:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 36B211C20A61
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 10:04:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F93C5644C;
	Wed, 22 Nov 2023 10:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SjXtM+ft"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48AE8D4A;
	Wed, 22 Nov 2023 02:00:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GD4bNNM15E1cJYaRe//tJkfYx4k2Jflbn5Zo9mdLKTw=; b=SjXtM+ft3WnregXt8o1Cq89gbu
	N7byio5iMWHjPDRlP+StbGqPIPqD744/DwhZq8+VWKFIpEpVvCnttIr2LswYHplkpT6MfFYLQJeU0
	KZ3KY1nEwg/rgqSWx8v4e3yY+jahpvKGCCVyVrocI6uKy3WCeBUdLR8AodWPZYlZxRSNPrR3gXRNa
	OBLEwR0xEd9h98y3eCUMQ9hsy5o5TNoGsIY2OZ5A6zU/FbLStzctFcW10Sh6FO2zBQRIyhY1nIzd0
	LKn3ayOVoMdfuJFVDc9hmhzsgn+nWBUyXq0O5IMdVQvk2ar1g186heq+I5x0ybktRuM3zX5TS8Ank
	0IObH15g==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1r5k1q-00CH1O-04;
	Wed, 22 Nov 2023 10:00:18 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id A2CF83005AA; Wed, 22 Nov 2023 11:00:16 +0100 (CET)
Date: Wed, 22 Nov 2023 11:00:16 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tobias Huschle <huschle@linux.ibm.com>
Cc: Abel Wu <wuyun.abel@bytedance.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	mst@redhat.com, jasowang@redhat.com
Subject: Re: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6 sched/fair:
 Add lag based placement)
Message-ID: <20231122100016.GO8262@noisy.programming.kicks-ass.net>
References: <c7b38bc27cc2c480f0c5383366416455@linux.ibm.com>
 <20231117092318.GJ8262@noisy.programming.kicks-ass.net>
 <ZVdbdSXg4qefTNtg@DESKTOP-2CCOB1S.>
 <20231117123759.GP8262@noisy.programming.kicks-ass.net>
 <46a997c2-5a38-4b60-b589-6073b1fac677@bytedance.com>
 <ZVyt4UU9+XxunIP7@DESKTOP-2CCOB1S.>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZVyt4UU9+XxunIP7@DESKTOP-2CCOB1S.>

On Tue, Nov 21, 2023 at 02:17:21PM +0100, Tobias Huschle wrote:

> We applied both suggested patch options and ran the test again, so 
> 
> sched/eevdf: Fix vruntime adjustment on reweight
> sched/fair: Update min_vruntime for reweight_entity() correctly
> 
> and
> 
> sched/eevdf: Delay dequeue
> 
> Unfortunately, both variants do NOT fix the problem.
> The regression remains unchanged.

Thanks for testing.

> I will continue getting myself familiar with how cgroups are scheduled to dig 
> deeper here. If there are any other ideas, I'd be happy to use them as a 
> starting point for further analysis.
> 
> Would additional traces still be of interest? If so, I would be glad to
> provide them.

So, since it got bisected to the placement logic, but is a cgroup
related issue, I was thinking that 'Delay dequeue' might not cut it,
that only works for tasks, not the internal entities.

The below should also work for internal entities, but last time I poked
around with it I had some regressions elsewhere -- you know, fix one,
wreck another type of situations on hand.

But still, could you please give it a go -- it applies cleanly to linus'
master and -rc2.

---
Subject: sched/eevdf: Revenge of the Sith^WSleepers

For tasks that have received excess service (negative lag) allow them to
gain parity (zero lag) by sleeping.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 kernel/sched/fair.c     | 36 ++++++++++++++++++++++++++++++++++++
 kernel/sched/features.h |  6 ++++++
 2 files changed, 42 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d7a3c63a2171..b975e4b07a68 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5110,6 +5110,33 @@ static inline void update_misfit_status(struct task_struct *p, struct rq *rq) {}
 
 #endif /* CONFIG_SMP */
 
+static inline u64
+entity_vlag_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
+{
+	u64 now, vdelta;
+	s64 delta;
+
+	if (!(flags & ENQUEUE_WAKEUP))
+		return se->vlag;
+
+	if (flags & ENQUEUE_MIGRATED)
+		return 0;
+
+	now = rq_clock_task(rq_of(cfs_rq));
+	delta = now - se->exec_start;
+	if (delta < 0)
+		return se->vlag;
+
+	if (sched_feat(GENTLE_SLEEPER))
+		delta /= 2;
+
+	vdelta = __calc_delta(delta, NICE_0_LOAD, &cfs_rq->load);
+	if (vdelta < -se->vlag)
+		return se->vlag + vdelta;
+
+	return 0;
+}
+
 static void
 place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 {
@@ -5133,6 +5160,15 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 
 		lag = se->vlag;
 
+		/*
+		 * Allow tasks that have received too much service (negative
+		 * lag) to (re)gain parity (zero lag) by sleeping for the
+		 * equivalent duration. This ensures they will be readily
+		 * eligible.
+		 */
+		if (sched_feat(PLACE_SLEEPER) && lag < 0)
+			lag = entity_vlag_sleeper(cfs_rq, se, flags);
+
 		/*
 		 * If we want to place a task and preserve lag, we have to
 		 * consider the effect of the new entity on the weighted
diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index a3ddf84de430..722282d3ed07 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -7,6 +7,12 @@
 SCHED_FEAT(PLACE_LAG, true)
 SCHED_FEAT(PLACE_DEADLINE_INITIAL, true)
 SCHED_FEAT(RUN_TO_PARITY, true)
+/*
+ * Let sleepers earn back lag, but not more than 0-lag. GENTLE_SLEEPERS earn at
+ * half the speed.
+ */
+SCHED_FEAT(PLACE_SLEEPER, true)
+SCHED_FEAT(GENTLE_SLEEPER, true)
 
 /*
  * Prefer to schedule the task we woke last (assuming it failed

