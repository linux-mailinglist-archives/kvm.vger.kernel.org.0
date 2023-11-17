Return-Path: <kvm+bounces-1945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DB377EF2C7
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 13:38:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68F231C20A9A
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 12:38:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1781730357;
	Fri, 17 Nov 2023 12:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Dtpn1gWv"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA486B3;
	Fri, 17 Nov 2023 04:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ihaKmDQEUKTpLi3X62NAOuhZsDyQ5ySoKRLINzqRVm0=; b=Dtpn1gWv0I+0QPid4NYzcsR/6j
	Fnqh+ZOcrbzX0ek/ekvlgdLxQeJBvQLc2Or69WIqPsQPUpCBKWGngILq8Yg51uDD0QKU4GNBD9bxZ
	t052LdAsWc7KsuoXoRRzkXBNrP+h5GZm0KyV1KsAOV4omImFqr+9dQCANq5qGRVt2zXc0ak1IRnMd
	PA3FAx1dyrt7LRiP/oabBenTnKJjMg/9OsJr1izBHUTooI5dPTYhfahZ6/nP4kdN39zBV8MxpOiOh
	TgxveYHS+0rv+vyKboYXWwJX0Y5LUqnPOH2GZSTwPWuOkRpIML5crC0+xKaV/LT3zKWOXphB8zPU/
	jp6pFuNQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1r3y6h-007HlG-1D;
	Fri, 17 Nov 2023 12:37:59 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 10E793002BE; Fri, 17 Nov 2023 13:37:59 +0100 (CET)
Date: Fri, 17 Nov 2023 13:37:59 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tobias Huschle <huschle@linux.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	mst@redhat.com, jasowang@redhat.com, wuyun.abel@bytedance.com
Subject: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6 sched/fair: Add
 lag based placement)
Message-ID: <20231117123759.GP8262@noisy.programming.kicks-ass.net>
References: <c7b38bc27cc2c480f0c5383366416455@linux.ibm.com>
 <20231117092318.GJ8262@noisy.programming.kicks-ass.net>
 <ZVdbdSXg4qefTNtg@DESKTOP-2CCOB1S.>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZVdbdSXg4qefTNtg@DESKTOP-2CCOB1S.>

On Fri, Nov 17, 2023 at 01:24:21PM +0100, Tobias Huschle wrote:
> On Fri, Nov 17, 2023 at 10:23:18AM +0100, Peter Zijlstra wrote:

> > kworkers are typically not in cgroups and are part of the root cgroup,
> > but what's a vhost and where does it live?
> 
> The qemu instances of the two KVM guests are placed into cgroups.
> The vhosts run within the context of these qemu instances (4 threads per guest).
> So they are also put into those cgroups.
> 
> I'll answer the other questions you brought up as well, but I guess that one 
> is most critical: 
> 
> > 
> > After confirming both tasks are indeed in the same cgroup ofcourse,
> > because if they're not, vruntime will be meaningless to compare and we
> > should look elsewhere.
> 
> In that case we probably have to go with elsewhere ... which is good to know.

Ah, so if this is a cgroup issue, it might be worth trying this patch
that we have in tip/sched/urgent.

I'll try and read the rest of the email a little later, gotta run
errands first.

---

commit eab03c23c2a162085b13200d7942fc5a00b5ccc8
Author: Abel Wu <wuyun.abel@bytedance.com>
Date:   Tue Nov 7 17:05:07 2023 +0800

    sched/eevdf: Fix vruntime adjustment on reweight
    
    vruntime of the (on_rq && !0-lag) entity needs to be adjusted when
    it gets re-weighted, and the calculations can be simplified based
    on the fact that re-weight won't change the w-average of all the
    entities. Please check the proofs in comments.
    
    But adjusting vruntime can also cause position change in RB-tree
    hence require re-queue to fix up which might be costly. This might
    be avoided by deferring adjustment to the time the entity actually
    leaves tree (dequeue/pick), but that will negatively affect task
    selection and probably not good enough either.
    
    Fixes: 147f3efaa241 ("sched/fair: Implement an EEVDF-like scheduling policy")
    Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
    Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
    Link: https://lkml.kernel.org/r/20231107090510.71322-2-wuyun.abel@bytedance.com

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2048138ce54b..025d90925bf6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3666,41 +3666,140 @@ static inline void
 dequeue_load_avg(struct cfs_rq *cfs_rq, struct sched_entity *se) { }
 #endif
 
+static void reweight_eevdf(struct cfs_rq *cfs_rq, struct sched_entity *se,
+			   unsigned long weight)
+{
+	unsigned long old_weight = se->load.weight;
+	u64 avruntime = avg_vruntime(cfs_rq);
+	s64 vlag, vslice;
+
+	/*
+	 * VRUNTIME
+	 * ========
+	 *
+	 * COROLLARY #1: The virtual runtime of the entity needs to be
+	 * adjusted if re-weight at !0-lag point.
+	 *
+	 * Proof: For contradiction assume this is not true, so we can
+	 * re-weight without changing vruntime at !0-lag point.
+	 *
+	 *             Weight	VRuntime   Avg-VRuntime
+	 *     before    w          v            V
+	 *      after    w'         v'           V'
+	 *
+	 * Since lag needs to be preserved through re-weight:
+	 *
+	 *	lag = (V - v)*w = (V'- v')*w', where v = v'
+	 *	==>	V' = (V - v)*w/w' + v		(1)
+	 *
+	 * Let W be the total weight of the entities before reweight,
+	 * since V' is the new weighted average of entities:
+	 *
+	 *	V' = (WV + w'v - wv) / (W + w' - w)	(2)
+	 *
+	 * by using (1) & (2) we obtain:
+	 *
+	 *	(WV + w'v - wv) / (W + w' - w) = (V - v)*w/w' + v
+	 *	==> (WV-Wv+Wv+w'v-wv)/(W+w'-w) = (V - v)*w/w' + v
+	 *	==> (WV - Wv)/(W + w' - w) + v = (V - v)*w/w' + v
+	 *	==>	(V - v)*W/(W + w' - w) = (V - v)*w/w' (3)
+	 *
+	 * Since we are doing at !0-lag point which means V != v, we
+	 * can simplify (3):
+	 *
+	 *	==>	W / (W + w' - w) = w / w'
+	 *	==>	Ww' = Ww + ww' - ww
+	 *	==>	W * (w' - w) = w * (w' - w)
+	 *	==>	W = w	(re-weight indicates w' != w)
+	 *
+	 * So the cfs_rq contains only one entity, hence vruntime of
+	 * the entity @v should always equal to the cfs_rq's weighted
+	 * average vruntime @V, which means we will always re-weight
+	 * at 0-lag point, thus breach assumption. Proof completed.
+	 *
+	 *
+	 * COROLLARY #2: Re-weight does NOT affect weighted average
+	 * vruntime of all the entities.
+	 *
+	 * Proof: According to corollary #1, Eq. (1) should be:
+	 *
+	 *	(V - v)*w = (V' - v')*w'
+	 *	==>    v' = V' - (V - v)*w/w'		(4)
+	 *
+	 * According to the weighted average formula, we have:
+	 *
+	 *	V' = (WV - wv + w'v') / (W - w + w')
+	 *	   = (WV - wv + w'(V' - (V - v)w/w')) / (W - w + w')
+	 *	   = (WV - wv + w'V' - Vw + wv) / (W - w + w')
+	 *	   = (WV + w'V' - Vw) / (W - w + w')
+	 *
+	 *	==>  V'*(W - w + w') = WV + w'V' - Vw
+	 *	==>	V' * (W - w) = (W - w) * V	(5)
+	 *
+	 * If the entity is the only one in the cfs_rq, then reweight
+	 * always occurs at 0-lag point, so V won't change. Or else
+	 * there are other entities, hence W != w, then Eq. (5) turns
+	 * into V' = V. So V won't change in either case, proof done.
+	 *
+	 *
+	 * So according to corollary #1 & #2, the effect of re-weight
+	 * on vruntime should be:
+	 *
+	 *	v' = V' - (V - v) * w / w'		(4)
+	 *	   = V  - (V - v) * w / w'
+	 *	   = V  - vl * w / w'
+	 *	   = V  - vl'
+	 */
+	if (avruntime != se->vruntime) {
+		vlag = (s64)(avruntime - se->vruntime);
+		vlag = div_s64(vlag * old_weight, weight);
+		se->vruntime = avruntime - vlag;
+	}
+
+	/*
+	 * DEADLINE
+	 * ========
+	 *
+	 * When the weight changes, the virtual time slope changes and
+	 * we should adjust the relative virtual deadline accordingly.
+	 *
+	 *	d' = v' + (d - v)*w/w'
+	 *	   = V' - (V - v)*w/w' + (d - v)*w/w'
+	 *	   = V  - (V - v)*w/w' + (d - v)*w/w'
+	 *	   = V  + (d - V)*w/w'
+	 */
+	vslice = (s64)(se->deadline - avruntime);
+	vslice = div_s64(vslice * old_weight, weight);
+	se->deadline = avruntime + vslice;
+}
+
 static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
 			    unsigned long weight)
 {
-	unsigned long old_weight = se->load.weight;
+	bool curr = cfs_rq->curr == se;
 
 	if (se->on_rq) {
 		/* commit outstanding execution time */
-		if (cfs_rq->curr == se)
+		if (curr)
 			update_curr(cfs_rq);
 		else
-			avg_vruntime_sub(cfs_rq, se);
+			__dequeue_entity(cfs_rq, se);
 		update_load_sub(&cfs_rq->load, se->load.weight);
 	}
 	dequeue_load_avg(cfs_rq, se);
 
-	update_load_set(&se->load, weight);
-
 	if (!se->on_rq) {
 		/*
 		 * Because we keep se->vlag = V - v_i, while: lag_i = w_i*(V - v_i),
 		 * we need to scale se->vlag when w_i changes.
 		 */
-		se->vlag = div_s64(se->vlag * old_weight, weight);
+		se->vlag = div_s64(se->vlag * se->load.weight, weight);
 	} else {
-		s64 deadline = se->deadline - se->vruntime;
-		/*
-		 * When the weight changes, the virtual time slope changes and
-		 * we should adjust the relative virtual deadline accordingly.
-		 */
-		deadline = div_s64(deadline * old_weight, weight);
-		se->deadline = se->vruntime + deadline;
-		if (se != cfs_rq->curr)
-			min_deadline_cb_propagate(&se->run_node, NULL);
+		reweight_eevdf(cfs_rq, se, weight);
 	}
 
+	update_load_set(&se->load, weight);
+
 #ifdef CONFIG_SMP
 	do {
 		u32 divider = get_pelt_divider(&se->avg);
@@ -3712,8 +3811,17 @@ static void reweight_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
 	enqueue_load_avg(cfs_rq, se);
 	if (se->on_rq) {
 		update_load_add(&cfs_rq->load, se->load.weight);
-		if (cfs_rq->curr != se)
-			avg_vruntime_add(cfs_rq, se);
+		if (!curr) {
+			/*
+			 * The entity's vruntime has been adjusted, so let's check
+			 * whether the rq-wide min_vruntime needs updated too. Since
+			 * the calculations above require stable min_vruntime rather
+			 * than up-to-date one, we do the update at the end of the
+			 * reweight process.
+			 */
+			__enqueue_entity(cfs_rq, se);
+			update_min_vruntime(cfs_rq);
+		}
 	}
 }
 
@@ -3857,14 +3965,11 @@ static void update_cfs_group(struct sched_entity *se)
 
 #ifndef CONFIG_SMP
 	shares = READ_ONCE(gcfs_rq->tg->shares);
-
-	if (likely(se->load.weight == shares))
-		return;
 #else
-	shares   = calc_group_shares(gcfs_rq);
+	shares = calc_group_shares(gcfs_rq);
 #endif
-
-	reweight_entity(cfs_rq_of(se), se, shares);
+	if (unlikely(se->load.weight != shares))
+		reweight_entity(cfs_rq_of(se), se, shares);
 }
 
 #else /* CONFIG_FAIR_GROUP_SCHED */

