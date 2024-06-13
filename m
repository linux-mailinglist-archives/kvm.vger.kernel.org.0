Return-Path: <kvm+bounces-19569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D2EB906848
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 11:15:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 537AA1C21818
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 09:15:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A847E13DDDB;
	Thu, 13 Jun 2024 09:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ICU05R/5"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DC713698F;
	Thu, 13 Jun 2024 09:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718270125; cv=none; b=jJsr3qpGVB9m1O2DtecnMfCEvZY3tQVxBda+B+0fG/W8iSLbG4fKJUVIdtY+naQBUcm63zbI8Dib44QStbxAcGFqL0xOpzrQO/9xYJLTiBhLeUTAAVJa4Hy53IhgX5YjDk3xOkZma/SYXE+T1w0UXOZt6HSbnZU1e80lCQR432U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718270125; c=relaxed/simple;
	bh=TVE8INeugaQe72v3GhOFkLFtRsSvv4AWQfrUOWovAYM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JXHooiW3q1UxIKTBcNiIFiquek4Ng7uKAvmZRdpJI3g7avcAFDy0fkVAfJ/q7tF1ApuKibU0hWyA01JzvPrDf50dGtBs2g/vKiVPa9PWxHaDIuIbYv6jA3fsEdyZWuCoGjT/jJJX5wQLsX1XH1zmh3EHb5V1qCG5WeSy717rk3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ICU05R/5; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=F5hhLnuI3k9OXvi6P+MH5atvnRPndfpnU1ipGTMdJhw=; b=ICU05R/55IqCsxUNFUwxUId3xS
	6UaeGfUC7GQ5e0o0Psnwz11jknKTR8vIboAYxVXMrdq5LELIDdk03pTbsHn6JxRVjcxkpPZaMcRtx
	RLKPBOD0MdygpTCQCKw7Ie745PsDsE8QwoiA6zxn5o+9Ppuq7aE0ivZipnsUT1iHJX5vhUcFszEr3
	1l3n3QQ8YuT2Q8L7pPKs4rzFkpu8sDl2tBcb52MojTDh0Meu20BVsimGLiJpmHoACiVx2QlPCiohK
	BDOjX1AgN9oSyfdOguuo3Kax5U38k65RdshqluFe4JTFKoEuAQOwVHYLZmUoN6Fr35hEgvJN+4Yog
	kN9xbTVg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sHgY0-0000000FbKp-0f5L;
	Thu, 13 Jun 2024 09:15:08 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 82E1C300B40; Thu, 13 Jun 2024 11:15:07 +0200 (CEST)
Date: Thu, 13 Jun 2024 11:15:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Liang, Kan" <kan.liang@linux.intel.com>
Cc: Mingwei Zhang <mizhang@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Kan Liang <kan.liang@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Manali Shukla <manali.shukla@amd.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Jim Mattson <jmattson@google.com>,
	Stephane Eranian <eranian@google.com>,
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
	gce-passthrou-pmu-dev@google.com,
	Samantha Alt <samantha.alt@intel.com>,
	Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
	maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
	kvm@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v2 07/54] perf: Add generic exclude_guest support
Message-ID: <20240613091507.GA17707@noisy.programming.kicks-ass.net>
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-8-mizhang@google.com>
 <20240507085807.GS40213@noisy.programming.kicks-ass.net>
 <902c40cc-6e0b-4b2f-826c-457f533a0a76@linux.intel.com>
 <20240611120641.GF8774@noisy.programming.kicks-ass.net>
 <0a403a6c-8d55-42cb-a90c-c13e1458b45e@linux.intel.com>
 <20240612111732.GW40213@noisy.programming.kicks-ass.net>
 <e72c847f-a069-43e4-9e49-37c0bf9f0a8b@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e72c847f-a069-43e4-9e49-37c0bf9f0a8b@linux.intel.com>

On Wed, Jun 12, 2024 at 09:38:06AM -0400, Liang, Kan wrote:
> On 2024-06-12 7:17 a.m., Peter Zijlstra wrote:
> > On Tue, Jun 11, 2024 at 09:27:46AM -0400, Liang, Kan wrote:
> >> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> >> index dd4920bf3d1b..68c8b93c4e5c 100644
> >> --- a/include/linux/perf_event.h
> >> +++ b/include/linux/perf_event.h
> >> @@ -945,6 +945,7 @@ struct perf_event_context {
> >>  	u64				time;
> >>  	u64				timestamp;
> >>  	u64				timeoffset;
> >> +	u64				timeguest;
> >>
> >>  	/*
> >>  	 * These fields let us detect when two contexts have both
> > 
> >> @@ -651,10 +653,26 @@ __perf_update_times(struct perf_event *event, u64
> >> now, u64 *enabled, u64 *runnin
> >>
> >>  static void perf_event_update_time(struct perf_event *event)
> >>  {
> >> -	u64 now = perf_event_time(event);
> >> +	u64 now;
> >> +
> >> +	/* Never count the time of an active guest into an exclude_guest event. */
> >> +	if (event->ctx->timeguest &&
> >> +	    event->pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU) {
> >> +		/*
> >> +		 * If a guest is running, use the timestamp while entering the guest.
> >> +		 * If the guest is leaving, reset the event timestamp.
> >> +		 */
> >> +		if (__this_cpu_read(perf_in_guest))
> >> +			event->tstamp = event->ctx->timeguest;
> >> +		else
> >> +			event->tstamp = event->ctx->time;
> >> +		return;
> >> +	}
> >>
> >> +	now = perf_event_time(event);
> >>  	__perf_update_times(event, now, &event->total_time_enabled,
> >>  					&event->total_time_running);
> >> +
> >>  	event->tstamp = now;
> >>  }
> > 
> > So I really don't like this much, 
> 
> An alternative way I can imagine may maintain a dedicated timeline for
> the PASSTHROUGH PMUs. For that, we probably need two new timelines for
> the normal events and the cgroup events. That sounds too complex.

I'm afraid we might have to. Specifically, the below:

> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 019c237dd456..6c46699c6752 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -665,7 +665,7 @@ static void perf_event_update_time(struct perf_event
> *event)
>  		if (__this_cpu_read(perf_in_guest))
>  			event->tstamp = event->ctx->timeguest;
>  		else
> -			event->tstamp = event->ctx->time;
> +			event->tstamp = perf_event_time(event);
>  		return;
>  	}

is still broken in that it (ab)uses event state to track time, and this
goes sideways in case of event overcommit, because then
ctx_sched_{out,in}() will not visit all events.

We've ran into that before. Time-keeping really should be per context or
we'll get a ton of pain.

I've ended up with the (uncompiled) below. Yes, it is unfortunate, but
aside from a few cleanups (we could introduce a struct time_ctx { u64
time, stamp, offset }; and fold a bunch of code, this is more or less
the best we can do I'm afraid.

---

--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -947,7 +947,9 @@ struct perf_event_context {
 	u64				time;
 	u64				timestamp;
 	u64				timeoffset;
-	u64				timeguest;
+	u64				guest_time;
+	u64				guest_timestamp;
+	u64				guest_timeoffset;
 
 	/*
 	 * These fields let us detect when two contexts have both
@@ -1043,6 +1045,9 @@ struct perf_cgroup_info {
 	u64				time;
 	u64				timestamp;
 	u64				timeoffset;
+	u64				guest_time;
+	u64				guest_timestamp;
+	u64				guest_timeoffset;
 	int				active;
 };
 
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -638,26 +638,9 @@ __perf_update_times(struct perf_event *e
 
 static void perf_event_update_time(struct perf_event *event)
 {
-	u64 now;
-
-	/* Never count the time of an active guest into an exclude_guest event. */
-	if (event->ctx->timeguest &&
-	    event->pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU) {
-		/*
-		 * If a guest is running, use the timestamp while entering the guest.
-		 * If the guest is leaving, reset the event timestamp.
-		 */
-		if (__this_cpu_read(perf_in_guest))
-			event->tstamp = event->ctx->timeguest;
-		else
-			event->tstamp = event->ctx->time;
-		return;
-	}
-
-	now = perf_event_time(event);
+	u64 now = perf_event_time(event);
 	__perf_update_times(event, now, &event->total_time_enabled,
 					&event->total_time_running);
-
 	event->tstamp = now;
 }
 
@@ -780,19 +763,33 @@ static inline int is_cgroup_event(struct
 static inline u64 perf_cgroup_event_time(struct perf_event *event)
 {
 	struct perf_cgroup_info *t;
+	u64 time;
 
 	t = per_cpu_ptr(event->cgrp->info, event->cpu);
-	return t->time;
+	time = t->time;
+	if (event->attr.exclude_guest)
+		time -= t->guest_time;
+	return time;
 }
 
 static inline u64 perf_cgroup_event_time_now(struct perf_event *event, u64 now)
 {
 	struct perf_cgroup_info *t;
+	u64 time, guest_time;
 
 	t = per_cpu_ptr(event->cgrp->info, event->cpu);
-	if (!__load_acquire(&t->active))
-		return t->time;
-	now += READ_ONCE(t->timeoffset);
+	if (!__load_acquire(&t->active)) {
+		time = t->time;
+		if (event->attr.exclude_guest)
+			time -= t->guest_time;
+		return time;
+	}
+
+	time = now + READ_ONCE(t->timeoffset);
+	if (event->attr.exclude_guest && __this_cpu_read(perf_in_guest)) {
+		guest_time = now + READ_ONCE(t->guest_offset);
+		time -= guest_time;
+	}
 	return now;
 }
 
@@ -807,6 +804,17 @@ static inline void __update_cgrp_time(st
 	WRITE_ONCE(info->timeoffset, info->time - info->timestamp);
 }
 
+static inline void __update_cgrp_guest_time(struct perf_cgroup_info *info, u64 now, bool adv)
+{
+	if (adv)
+		info->guest_time += now - info->guest_timestamp;
+	info->guest_timestamp = now;
+	/*
+	 * see update_context_time()
+	 */
+	WRITE_ONCE(info->guest_timeoffset, info->guest_time - info->guest_timestamp);
+}
+
 static inline void update_cgrp_time_from_cpuctx(struct perf_cpu_context *cpuctx, bool final)
 {
 	struct perf_cgroup *cgrp = cpuctx->cgrp;
@@ -821,6 +829,8 @@ static inline void update_cgrp_time_from
 			info = this_cpu_ptr(cgrp->info);
 
 			__update_cgrp_time(info, now, true);
+			if (__this_cpu_read(perf_in_guest))
+				__update_cgrp_guest_time(info, now, true);
 			if (final)
 				__store_release(&info->active, 0);
 		}
@@ -1501,14 +1511,39 @@ static void __update_context_time(struct
 	WRITE_ONCE(ctx->timeoffset, ctx->time - ctx->timestamp);
 }
 
+static void __update_context_guest_time(struct perf_event_context *ctx, bool adv)
+{
+	u64 now = ctx->timestamp; /* must be called after __update_context_time(); */
+
+	lockdep_assert_held(&ctx->lock);
+
+	if (adv)
+		ctx->guest_time += now - ctx->guest_timestamp;
+	ctx->guest_timestamp = now;
+
+	/*
+	 * The above: time' = time + (now - timestamp), can be re-arranged
+	 * into: time` = now + (time - timestamp), which gives a single value
+	 * offset to compute future time without locks on.
+	 *
+	 * See perf_event_time_now(), which can be used from NMI context where
+	 * it's (obviously) not possible to acquire ctx->lock in order to read
+	 * both the above values in a consistent manner.
+	 */
+	WRITE_ONCE(ctx->guest_timeoffset, ctx->guest_time - ctx->guest_timestamp);
+}
+
 static void update_context_time(struct perf_event_context *ctx)
 {
 	__update_context_time(ctx, true);
+	if (__this_cpu_read(perf_in_guest))
+		__update_context_guest_time(ctx, true);
 }
 
 static u64 perf_event_time(struct perf_event *event)
 {
 	struct perf_event_context *ctx = event->ctx;
+	u64 time;
 
 	if (unlikely(!ctx))
 		return 0;
@@ -1516,12 +1551,17 @@ static u64 perf_event_time(struct perf_e
 	if (is_cgroup_event(event))
 		return perf_cgroup_event_time(event);
 
-	return ctx->time;
+	time = ctx->time;
+	if (event->attr.exclude_guest)
+		time -= ctx->guest_time;
+
+	return time;
 }
 
 static u64 perf_event_time_now(struct perf_event *event, u64 now)
 {
 	struct perf_event_context *ctx = event->ctx;
+	u64 time, guest_time;
 
 	if (unlikely(!ctx))
 		return 0;
@@ -1529,11 +1569,19 @@ static u64 perf_event_time_now(struct pe
 	if (is_cgroup_event(event))
 		return perf_cgroup_event_time_now(event, now);
 
-	if (!(__load_acquire(&ctx->is_active) & EVENT_TIME))
-		return ctx->time;
+	if (!(__load_acquire(&ctx->is_active) & EVENT_TIME)) {
+		time = ctx->time;
+		if (event->attr.exclude_guest)
+			time -= ctx->guest_time;
+		return time;
+	}
 
-	now += READ_ONCE(ctx->timeoffset);
-	return now;
+	time = now + READ_ONCE(ctx->timeoffset);
+	if (event->attr.exclude_guest && __this_cpu_read(perf_in_guest)) {
+		guest_time = now + READ_ONCE(ctx->guest_timeoffset);
+		time -= guest_time;
+	}
+	return time;
 }
 
 static enum event_type_t get_event_type(struct perf_event *event)
@@ -3340,9 +3388,14 @@ ctx_sched_out(struct perf_event_context
 	 * would only update time for the pinned events.
 	 */
 	if (is_active & EVENT_TIME) {
+		bool stop;
+
+		stop = !((ctx->is_active & event_type) & EVENT_ALL) &&
+		       ctx == &cpuctx->ctx;
+			
 		/* update (and stop) ctx time */
 		update_context_time(ctx);
-		update_cgrp_time_from_cpuctx(cpuctx, ctx == &cpuctx->ctx);
+		update_cgrp_time_from_cpuctx(cpuctx, stop);
 		/*
 		 * CPU-release for the below ->is_active store,
 		 * see __load_acquire() in perf_event_time_now()
@@ -3366,8 +3419,12 @@ ctx_sched_out(struct perf_event_context
 		 * with PERF_PMU_CAP_PASSTHROUGH_VPMU.
 		 */
 		is_active = EVENT_ALL;
-	} else
+		__update_context_guest_time(ctx, false);
+		perf_cgroup_set_guest_timestamp(cpuctx);
+		barrier();
+	} else {
 		is_active ^= ctx->is_active; /* changed bits */
+	}
 
 	list_for_each_entry(pmu_ctx, &ctx->pmu_ctx_list, pmu_ctx_entry) {
 		if (perf_skip_pmu_ctx(pmu_ctx, event_type))
@@ -3866,10 +3923,15 @@ static inline void group_update_userpage
 		event_update_userpage(event);
 }
 
+struct merge_sched_data {
+	int can_add_hw;
+	enum event_type_t event_type;
+};
+
 static int merge_sched_in(struct perf_event *event, void *data)
 {
 	struct perf_event_context *ctx = event->ctx;
-	int *can_add_hw = data;
+	struct merge_sched_data *msd = data;
 
 	if (event->state <= PERF_EVENT_STATE_OFF)
 		return 0;
@@ -3881,18 +3943,18 @@ static int merge_sched_in(struct perf_ev
 	 * Don't schedule in any exclude_guest events of PMU with
 	 * PERF_PMU_CAP_PASSTHROUGH_VPMU, while a guest is running.
 	 */
-	if (__this_cpu_read(perf_in_guest) &&
-	    event->pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU &&
-	    event->attr.exclude_guest)
+	if (event->attr.exclude_guest && __this_cpu_read(perf_in_guest) &&
+	    (event->pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU) &&
+	    !(msd->event_type & EVENT_GUEST))
 		return 0;
 
-	if (group_can_go_on(event, *can_add_hw)) {
+	if (group_can_go_on(event, msd->can_add_hw)) {
 		if (!group_sched_in(event, ctx))
 			list_add_tail(&event->active_list, get_event_list(event));
 	}
 
 	if (event->state == PERF_EVENT_STATE_INACTIVE) {
-		*can_add_hw = 0;
+		msd->can_add_hw = 0;
 		if (event->attr.pinned) {
 			perf_cgroup_event_disable(event, ctx);
 			perf_event_set_state(event, PERF_EVENT_STATE_ERROR);
@@ -3911,11 +3973,15 @@ static int merge_sched_in(struct perf_ev
 
 static void pmu_groups_sched_in(struct perf_event_context *ctx,
 				struct perf_event_groups *groups,
-				struct pmu *pmu)
+				struct pmu *pmu,
+				enum even_type_t event_type)
 {
-	int can_add_hw = 1;
+	struct merge_sched_data msd = {
+		.can_add_hw = 1,
+		.event_type = event_type,
+	};
 	visit_groups_merge(ctx, groups, smp_processor_id(), pmu,
-			   merge_sched_in, &can_add_hw);
+			   merge_sched_in, &msd);
 }
 
 static void ctx_groups_sched_in(struct perf_event_context *ctx,
@@ -3927,14 +3993,14 @@ static void ctx_groups_sched_in(struct p
 	list_for_each_entry(pmu_ctx, &ctx->pmu_ctx_list, pmu_ctx_entry) {
 		if (perf_skip_pmu_ctx(pmu_ctx, event_type))
 			continue;
-		pmu_groups_sched_in(ctx, groups, pmu_ctx->pmu);
+		pmu_groups_sched_in(ctx, groups, pmu_ctx->pmu, event_type);
 	}
 }
 
 static void __pmu_ctx_sched_in(struct perf_event_context *ctx,
 			       struct pmu *pmu)
 {
-	pmu_groups_sched_in(ctx, &ctx->flexible_groups, pmu);
+	pmu_groups_sched_in(ctx, &ctx->flexible_groups, pmu, 0);
 }
 
 static void
@@ -3949,6 +4015,8 @@ ctx_sched_in(struct perf_event_context *
 		return;
 
 	if (!(is_active & EVENT_TIME)) {
+		/* EVENT_TIME should be active while the guest runs */
+		WARN_ON_ONCE(event_type & EVENT_GUEST);
 		/* start ctx time */
 		__update_context_time(ctx, false);
 		perf_cgroup_set_timestamp(cpuctx);
@@ -3979,8 +4047,11 @@ ctx_sched_in(struct perf_event_context *
 		 * the exclude_guest events.
 		 */
 		update_context_time(ctx);
-	} else
+		update_cgrp_time_from_cpuctx(cpuctx, false);
+		barrier();
+	} else {
 		is_active ^= ctx->is_active; /* changed bits */
+	}
 
 	/*
 	 * First go through the list and put on any pinned groups
@@ -5832,25 +5903,20 @@ void perf_guest_enter(void)
 
 	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
 
-	if (WARN_ON_ONCE(__this_cpu_read(perf_in_guest))) {
-		perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
-		return;
-	}
+	if (WARN_ON_ONCE(__this_cpu_read(perf_in_guest)))
+		goto unlock;
 
 	perf_ctx_disable(&cpuctx->ctx, EVENT_GUEST);
 	ctx_sched_out(&cpuctx->ctx, EVENT_GUEST);
-	/* Set the guest start time */
-	cpuctx->ctx.timeguest = cpuctx->ctx.time;
 	perf_ctx_enable(&cpuctx->ctx, EVENT_GUEST);
 	if (cpuctx->task_ctx) {
 		perf_ctx_disable(cpuctx->task_ctx, EVENT_GUEST);
 		task_ctx_sched_out(cpuctx->task_ctx, EVENT_GUEST);
-		cpuctx->task_ctx->timeguest = cpuctx->task_ctx->time;
 		perf_ctx_enable(cpuctx->task_ctx, EVENT_GUEST);
 	}
 
 	__this_cpu_write(perf_in_guest, true);
-
+unlock:
 	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
 }
 
@@ -5862,24 +5928,21 @@ void perf_guest_exit(void)
 
 	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
 
-	if (WARN_ON_ONCE(!__this_cpu_read(perf_in_guest))) {
-		perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
-		return;
-	}
-
-	__this_cpu_write(perf_in_guest, false);
+	if (WARN_ON_ONCE(!__this_cpu_read(perf_in_guest)))
+		goto unlock;
 
 	perf_ctx_disable(&cpuctx->ctx, EVENT_GUEST);
 	ctx_sched_in(&cpuctx->ctx, EVENT_GUEST);
-	cpuctx->ctx.timeguest = 0;
 	perf_ctx_enable(&cpuctx->ctx, EVENT_GUEST);
 	if (cpuctx->task_ctx) {
 		perf_ctx_disable(cpuctx->task_ctx, EVENT_GUEST);
 		ctx_sched_in(cpuctx->task_ctx, EVENT_GUEST);
-		cpuctx->task_ctx->timeguest = 0;
 		perf_ctx_enable(cpuctx->task_ctx, EVENT_GUEST);
 	}
 
+	__this_cpu_write(perf_in_guest, false);
+
+unlock:
 	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
 }
 

