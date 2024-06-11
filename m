Return-Path: <kvm+bounces-19326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9182F903D4E
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 15:29:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E58221F23FEF
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 13:29:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D0D217D378;
	Tue, 11 Jun 2024 13:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AG915C4e"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C258B17C7DA;
	Tue, 11 Jun 2024 13:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718112474; cv=none; b=pKCmPsrraVOTnzELDGWggbGdyMLJAQWSdoNAo9J1GPmX561qvL3vEpSRrQ4JHAFSACmOXLMpcasC9dBAsXwbYSKCxU/tuhDYVFJh5fQq+obAUnr3LGHhwd6TntsZNiETY2gSvQhrr0/jd7pYPLxL9eTRp7+tf7HaS6eBFS+uPMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718112474; c=relaxed/simple;
	bh=fjgEDqR45MSMTMNGKpBI2WAy1U0O3ya4ljsGk4mt3y4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RwkTljyJspgiQmoJuc38Fp/Es0QZEiXqDA+66UEY9sgguRkj17kEr075OasBRzmm4jesXvkMDXajnu3DVZcInDblwg5CP6cmRM+hO7D/Px5hSHOdJ2CPPjYedVOopgMiPvQKLFwFbumzbh998Ds0VYlctrccPpw4DtUljyLNPWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AG915C4e; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718112472; x=1749648472;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fjgEDqR45MSMTMNGKpBI2WAy1U0O3ya4ljsGk4mt3y4=;
  b=AG915C4e5WNZytkvtODplUWC0MwlIheFUE8l5xMS8D/h+8Nveh+QCMKJ
   c+L3WXrti96tNY4SseoA2eTsQzJuBxNhbW21qlbg9yIg9hsGB4iuvOgIb
   fFL8ZcSXrpGeLnmaFJwyOn9XHOYb6o5r/ZFjzFHkz4G+YBuJW4WdKjRGw
   IJUK/AP70ovPUFi0oJFm+SR3peMlgkBMaoK5eREZjyo6rz8QLnM52gxDi
   LVuRnMCp9YWH7awlF+rlWjImRrtRAqAOIHE3woQwsUc6Xww4EAvqscbfd
   HDVZu69H6qcKKinMFhvP+nUgxKrq9HT3byrgDbzl/jfPNu2BMmfv5uXEc
   w==;
X-CSE-ConnectionGUID: 7wJzA/kGTV+gZM1RIy1SuQ==
X-CSE-MsgGUID: eAoDKXT/R1SjPoSo8NZ71g==
X-IronPort-AV: E=McAfee;i="6600,9927,11099"; a="18680787"
X-IronPort-AV: E=Sophos;i="6.08,230,1712646000"; 
   d="scan'208";a="18680787"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 06:27:51 -0700
X-CSE-ConnectionGUID: HW2viWxdSDeNE41xrnpv7Q==
X-CSE-MsgGUID: IcKtAS1VSPeEQ/oYhbDAZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,230,1712646000"; 
   d="scan'208";a="39549205"
Received: from linux.intel.com ([10.54.29.200])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 06:27:50 -0700
Received: from [10.209.186.83] (kliang2-mobl1.ccr.corp.intel.com [10.209.186.83])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id AE0B820B5703;
	Tue, 11 Jun 2024 06:27:47 -0700 (PDT)
Message-ID: <0a403a6c-8d55-42cb-a90c-c13e1458b45e@linux.intel.com>
Date: Tue, 11 Jun 2024 09:27:46 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/54] perf: Add generic exclude_guest support
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mingwei Zhang <mizhang@google.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>, Kan Liang <kan.liang@intel.com>,
 Zhenyu Wang <zhenyuw@linux.intel.com>, Manali Shukla
 <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>,
 Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
 kvm@vger.kernel.org, linux-perf-users@vger.kernel.org
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-8-mizhang@google.com>
 <20240507085807.GS40213@noisy.programming.kicks-ass.net>
 <902c40cc-6e0b-4b2f-826c-457f533a0a76@linux.intel.com>
 <20240611120641.GF8774@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <20240611120641.GF8774@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024-06-11 8:06 a.m., Peter Zijlstra wrote:
> On Mon, Jun 10, 2024 at 01:23:04PM -0400, Liang, Kan wrote:
>> On 2024-05-07 4:58 a.m., Peter Zijlstra wrote:
> 
>>> Bah, this is a ton of copy-paste from the normal scheduling code with
>>> random changes. Why ?
>>>
>>> Why can't this use ctx_sched_{in,out}() ? Surely the whole
>>> CAP_PASSTHROUGHT thing is but a flag away.
>>>
>>
>> Not just a flag. The time has to be updated as well, since the ctx->time
>> is shared among PMUs. Perf shouldn't stop it while other PMUs is still
>> running.
> 
> Obviously the original changelog didn't mention any of that.... :/

Yes, the time issue was a newly found bug when we test the uncore PMUs.

> 
>> A timeguest will be introduced to track the start time of a guest.
>> The event->tstamp of an exclude_guest event should always keep
>> ctx->timeguest while a guest is running.
>> When a guest is leaving, update the event->tstamp to now, so the guest
>> time can be deducted.
>>
>> The below patch demonstrate how the timeguest works.
>> (It's an incomplete patch. Just to show the idea.)
>>
>> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
>> index 22d3e56682c9..2134e6886e22 100644
>> --- a/include/linux/perf_event.h
>> +++ b/include/linux/perf_event.h
>> @@ -953,6 +953,7 @@ struct perf_event_context {
>>  	u64				time;
>>  	u64				timestamp;
>>  	u64				timeoffset;
>> +	u64				timeguest;
>>
>>  	/*
>>  	 * These fields let us detect when two contexts have both
>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>> index 14fd881e3e1d..2aed56671a24 100644
>> --- a/kernel/events/core.c
>> +++ b/kernel/events/core.c
>> @@ -690,12 +690,31 @@ __perf_update_times(struct perf_event *event, u64
>> now, u64 *enabled, u64 *runnin
>>  		*running += delta;
>>  }
>>
>> +static void perf_event_update_time_guest(struct perf_event *event)
>> +{
>> +	/*
>> +	 * If a guest is running, use the timestamp while entering the guest.
>> +	 * If the guest is leaving, reset the event timestamp.
>> +	 */
>> +	if (!__this_cpu_read(perf_in_guest))
>> +		event->tstamp = event->ctx->time;
>> +	else
>> +		event->tstamp = event->ctx->timeguest;
>> +}
> 
> This conditional seems inverted, without a good reason. Also, in another
> thread you talk about some PMUs stopping time in a guest, while other
> PMUs would keep ticking. I don't think the above captures that.
> 
>>  static void perf_event_update_time(struct perf_event *event)
>>  {
>> -	u64 now = perf_event_time(event);
>> +	u64 now;
>> +
>> +	/* Never count the time of an active guest into an exclude_guest event. */
>> +	if (event->ctx->timeguest &&
>> +	    event->pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU)
>> +		return perf_event_update_time_guest(event);
> 
> Urgh, weird split. The PMU check is here. Please just inline the above
> here, this seems to be the sole caller anyway.
>

Sure

>>
>> +	now = perf_event_time(event);
>>  	__perf_update_times(event, now, &event->total_time_enabled,
>>  					&event->total_time_running);
>> +
>>  	event->tstamp = now;
>>  }
>>
>> @@ -3398,7 +3417,14 @@ ctx_sched_out(struct perf_event_context *ctx,
>> enum event_type_t event_type)
>>  			cpuctx->task_ctx = NULL;
>>  	}
>>
>> -	is_active ^= ctx->is_active; /* changed bits */
>> +	if (event_type & EVENT_GUEST) {
> 
> Patch doesn't introduce EVENT_GUEST, lost a hunk somewhere?

Sorry, there is a prerequisite patch to factor out the EVENT_CGROUP.
I thought it will be complex and confusion to paste both. Some details
are lost.
I will post both two patches at the end.

> 
>> +		/*
>> +		 * Schedule out all !exclude_guest events of PMU
>> +		 * with PERF_PMU_CAP_PASSTHROUGH_VPMU.
>> +		 */
>> +		is_active = EVENT_ALL;
>> +	} else
>> +		is_active ^= ctx->is_active; /* changed bits */
>>
>>  	list_for_each_entry(pmu_ctx, &ctx->pmu_ctx_list, pmu_ctx_entry) {
>>  		if (perf_skip_pmu_ctx(pmu_ctx, event_type))
> 
>> @@ -5894,14 +5933,18 @@ void perf_guest_enter(u32 guest_lvtpc)
>>  	}
>>
>>  	perf_ctx_disable(&cpuctx->ctx, EVENT_GUEST);
>> -	ctx_sched_out(&cpuctx->ctx, EVENT_ALL | EVENT_GUEST);
>> +	ctx_sched_out(&cpuctx->ctx, EVENT_GUEST);
>> +	/* Set the guest start time */
>> +	cpuctx->ctx.timeguest = cpuctx->ctx.time;
>>  	perf_ctx_enable(&cpuctx->ctx, EVENT_GUEST);
>>  	if (cpuctx->task_ctx) {
>>  		perf_ctx_disable(cpuctx->task_ctx, EVENT_GUEST);
>> -		task_ctx_sched_out(cpuctx->task_ctx, EVENT_ALL | EVENT_GUEST);
>> +		task_ctx_sched_out(cpuctx->task_ctx, EVENT_GUEST);
>> +		cpuctx->task_ctx->timeguest = cpuctx->task_ctx->time;
>>  		perf_ctx_enable(cpuctx->task_ctx, EVENT_GUEST);
>>  	}
>>
>>  	__this_cpu_write(perf_in_guest, true);
>> @@ -5925,14 +5968,17 @@ void perf_guest_exit(void)
>>
>>  	__this_cpu_write(perf_in_guest, false);
>>
>>  	perf_ctx_disable(&cpuctx->ctx, EVENT_GUEST);
>> -	ctx_sched_in(&cpuctx->ctx, EVENT_ALL | EVENT_GUEST);
>> +	ctx_sched_in(&cpuctx->ctx, EVENT_GUEST);
>> +	cpuctx->ctx.timeguest = 0;
>>  	perf_ctx_enable(&cpuctx->ctx, EVENT_GUEST);
>>  	if (cpuctx->task_ctx) {
>>  		perf_ctx_disable(cpuctx->task_ctx, EVENT_GUEST);
>> -		ctx_sched_in(cpuctx->task_ctx, EVENT_ALL | EVENT_GUEST);
>> +		ctx_sched_in(cpuctx->task_ctx, EVENT_GUEST);
>> +		cpuctx->task_ctx->timeguest = 0;
>>  		perf_ctx_enable(cpuctx->task_ctx, EVENT_GUEST);
>>  	}
> 
> I'm thinking EVENT_GUEST should cause the ->timeguest updates, no point
> in having them explicitly duplicated here, hmm?

We have to add a EVENT_GUEST check and update the ->timeguest at the end
of the ctx_sched_out/in functions after the pmu_ctx_sched_out/in().
Because the ->timeguest also be used to check if it's leaving the guest
in the perf_event_update_time().

Since the EVENT_GUEST only be used by perf_guest_enter/exit(), I thought
maybe it's better to move it to where it is used rather than the generic
ctx_sched_out/in(). It will minimize the impact on the
non-virtualization user.

Here are the two complete patches.

The first one is to factor out the EVENT_CGROUP.


From c508f2b0e11a2eea71fe3ff16d1d848359ede535 Mon Sep 17 00:00:00 2001
From: Kan Liang <kan.liang@linux.intel.com>
Date: Mon, 27 May 2024 06:58:29 -0700
Subject: [PATCH 1/2] perf: Skip pmu_ctx based on event_type

To optimize the cgroup context switch, the perf_event_pmu_context
iteration skips the PMUs without cgroup events. A bool cgroup was
introduced to indicate the case. It can work, but this way is hard to
extend for other cases, e.g. skipping non-passthrough PMUs. It doesn't
make sense to keep adding bool variables.

Pass the event_type instead of the specific bool variable. Check both
the event_type and related pmu_ctx variables to decide whether skipping
a PMU.

Event flags, e.g., EVENT_CGROUP, should be cleard in the ctx->is_active.
Add EVENT_FLAGS to indicate such event flags.

No functional change.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
---
 kernel/events/core.c | 70 +++++++++++++++++++++++---------------------
 1 file changed, 37 insertions(+), 33 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index abd4027e3859..95d1d5a5addc 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -376,6 +376,7 @@ enum event_type_t {
 	/* see ctx_resched() for details */
 	EVENT_CPU = 0x8,
 	EVENT_CGROUP = 0x10,
+	EVENT_FLAGS = EVENT_CGROUP,
 	EVENT_ALL = EVENT_FLEXIBLE | EVENT_PINNED,
 };

@@ -699,23 +700,32 @@ do {									\
 	___p;								\
 })

-static void perf_ctx_disable(struct perf_event_context *ctx, bool cgroup)
+static bool perf_skip_pmu_ctx(struct perf_event_pmu_context *pmu_ctx,
+			      enum event_type_t event_type)
+{
+	if ((event_type & EVENT_CGROUP) && !pmu_ctx->nr_cgroups)
+		return true;
+
+	return false;
+}
+
+static void perf_ctx_disable(struct perf_event_context *ctx, enum
event_type_t event_type)
 {
 	struct perf_event_pmu_context *pmu_ctx;

 	list_for_each_entry(pmu_ctx, &ctx->pmu_ctx_list, pmu_ctx_entry) {
-		if (cgroup && !pmu_ctx->nr_cgroups)
+		if (perf_skip_pmu_ctx(pmu_ctx, event_type))
 			continue;
 		perf_pmu_disable(pmu_ctx->pmu);
 	}
 }

-static void perf_ctx_enable(struct perf_event_context *ctx, bool cgroup)
+static void perf_ctx_enable(struct perf_event_context *ctx, enum
event_type_t event_type)
 {
 	struct perf_event_pmu_context *pmu_ctx;

 	list_for_each_entry(pmu_ctx, &ctx->pmu_ctx_list, pmu_ctx_entry) {
-		if (cgroup && !pmu_ctx->nr_cgroups)
+		if (perf_skip_pmu_ctx(pmu_ctx, event_type))
 			continue;
 		perf_pmu_enable(pmu_ctx->pmu);
 	}
@@ -877,7 +887,7 @@ static void perf_cgroup_switch(struct task_struct *task)
 		return;

 	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
-	perf_ctx_disable(&cpuctx->ctx, true);
+	perf_ctx_disable(&cpuctx->ctx, EVENT_CGROUP);

 	ctx_sched_out(&cpuctx->ctx, EVENT_ALL|EVENT_CGROUP);
 	/*
@@ -893,7 +903,7 @@ static void perf_cgroup_switch(struct task_struct *task)
 	 */
 	ctx_sched_in(&cpuctx->ctx, EVENT_ALL|EVENT_CGROUP);

-	perf_ctx_enable(&cpuctx->ctx, true);
+	perf_ctx_enable(&cpuctx->ctx, EVENT_CGROUP);
 	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
 }

@@ -2729,9 +2739,9 @@ static void ctx_resched(struct perf_cpu_context
*cpuctx,

 	event_type &= EVENT_ALL;

-	perf_ctx_disable(&cpuctx->ctx, false);
+	perf_ctx_disable(&cpuctx->ctx, 0);
 	if (task_ctx) {
-		perf_ctx_disable(task_ctx, false);
+		perf_ctx_disable(task_ctx, 0);
 		task_ctx_sched_out(task_ctx, event_type);
 	}

@@ -2749,9 +2759,9 @@ static void ctx_resched(struct perf_cpu_context
*cpuctx,

 	perf_event_sched_in(cpuctx, task_ctx);

-	perf_ctx_enable(&cpuctx->ctx, false);
+	perf_ctx_enable(&cpuctx->ctx, 0);
 	if (task_ctx)
-		perf_ctx_enable(task_ctx, false);
+		perf_ctx_enable(task_ctx, 0);
 }

 void perf_pmu_resched(struct pmu *pmu)
@@ -3296,9 +3306,6 @@ ctx_sched_out(struct perf_event_context *ctx, enum
event_type_t event_type)
 	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
 	struct perf_event_pmu_context *pmu_ctx;
 	int is_active = ctx->is_active;
-	bool cgroup = event_type & EVENT_CGROUP;
-
-	event_type &= ~EVENT_CGROUP;

 	lockdep_assert_held(&ctx->lock);

@@ -3333,7 +3340,7 @@ ctx_sched_out(struct perf_event_context *ctx, enum
event_type_t event_type)
 		barrier();
 	}

-	ctx->is_active &= ~event_type;
+	ctx->is_active &= ~(event_type & ~EVENT_FLAGS);
 	if (!(ctx->is_active & EVENT_ALL))
 		ctx->is_active = 0;

@@ -3346,7 +3353,7 @@ ctx_sched_out(struct perf_event_context *ctx, enum
event_type_t event_type)
 	is_active ^= ctx->is_active; /* changed bits */

 	list_for_each_entry(pmu_ctx, &ctx->pmu_ctx_list, pmu_ctx_entry) {
-		if (cgroup && !pmu_ctx->nr_cgroups)
+		if (perf_skip_pmu_ctx(pmu_ctx, event_type))
 			continue;
 		__pmu_ctx_sched_out(pmu_ctx, is_active);
 	}
@@ -3540,7 +3547,7 @@ perf_event_context_sched_out(struct task_struct
*task, struct task_struct *next)
 		raw_spin_lock_nested(&next_ctx->lock, SINGLE_DEPTH_NESTING);
 		if (context_equiv(ctx, next_ctx)) {

-			perf_ctx_disable(ctx, false);
+			perf_ctx_disable(ctx, 0);

 			/* PMIs are disabled; ctx->nr_pending is stable. */
 			if (local_read(&ctx->nr_pending) ||
@@ -3560,7 +3567,7 @@ perf_event_context_sched_out(struct task_struct
*task, struct task_struct *next)
 			perf_ctx_sched_task_cb(ctx, false);
 			perf_event_swap_task_ctx_data(ctx, next_ctx);

-			perf_ctx_enable(ctx, false);
+			perf_ctx_enable(ctx, 0);

 			/*
 			 * RCU_INIT_POINTER here is safe because we've not
@@ -3584,13 +3591,13 @@ perf_event_context_sched_out(struct task_struct
*task, struct task_struct *next)

 	if (do_switch) {
 		raw_spin_lock(&ctx->lock);
-		perf_ctx_disable(ctx, false);
+		perf_ctx_disable(ctx, 0);

 inside_switch:
 		perf_ctx_sched_task_cb(ctx, false);
 		task_ctx_sched_out(ctx, EVENT_ALL);

-		perf_ctx_enable(ctx, false);
+		perf_ctx_enable(ctx, 0);
 		raw_spin_unlock(&ctx->lock);
 	}
 }
@@ -3887,12 +3894,12 @@ static void pmu_groups_sched_in(struct
perf_event_context *ctx,

 static void ctx_groups_sched_in(struct perf_event_context *ctx,
 				struct perf_event_groups *groups,
-				bool cgroup)
+				enum event_type_t event_type)
 {
 	struct perf_event_pmu_context *pmu_ctx;

 	list_for_each_entry(pmu_ctx, &ctx->pmu_ctx_list, pmu_ctx_entry) {
-		if (cgroup && !pmu_ctx->nr_cgroups)
+		if (perf_skip_pmu_ctx(pmu_ctx, event_type))
 			continue;
 		pmu_groups_sched_in(ctx, groups, pmu_ctx->pmu);
 	}
@@ -3909,9 +3916,6 @@ ctx_sched_in(struct perf_event_context *ctx, enum
event_type_t event_type)
 {
 	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
 	int is_active = ctx->is_active;
-	bool cgroup = event_type & EVENT_CGROUP;
-
-	event_type &= ~EVENT_CGROUP;

 	lockdep_assert_held(&ctx->lock);

@@ -3929,7 +3933,7 @@ ctx_sched_in(struct perf_event_context *ctx, enum
event_type_t event_type)
 		barrier();
 	}

-	ctx->is_active |= (event_type | EVENT_TIME);
+	ctx->is_active |= ((event_type & ~EVENT_FLAGS) | EVENT_TIME);
 	if (ctx->task) {
 		if (!is_active)
 			cpuctx->task_ctx = ctx;
@@ -3944,11 +3948,11 @@ ctx_sched_in(struct perf_event_context *ctx,
enum event_type_t event_type)
 	 * in order to give them the best chance of going on.
 	 */
 	if (is_active & EVENT_PINNED)
-		ctx_groups_sched_in(ctx, &ctx->pinned_groups, cgroup);
+		ctx_groups_sched_in(ctx, &ctx->pinned_groups, event_type);

 	/* Then walk through the lower prio flexible groups */
 	if (is_active & EVENT_FLEXIBLE)
-		ctx_groups_sched_in(ctx, &ctx->flexible_groups, cgroup);
+		ctx_groups_sched_in(ctx, &ctx->flexible_groups, event_type);
 }

 static void perf_event_context_sched_in(struct task_struct *task)
@@ -3963,11 +3967,11 @@ static void perf_event_context_sched_in(struct
task_struct *task)

 	if (cpuctx->task_ctx == ctx) {
 		perf_ctx_lock(cpuctx, ctx);
-		perf_ctx_disable(ctx, false);
+		perf_ctx_disable(ctx, 0);

 		perf_ctx_sched_task_cb(ctx, true);

-		perf_ctx_enable(ctx, false);
+		perf_ctx_enable(ctx, 0);
 		perf_ctx_unlock(cpuctx, ctx);
 		goto rcu_unlock;
 	}
@@ -3980,7 +3984,7 @@ static void perf_event_context_sched_in(struct
task_struct *task)
 	if (!ctx->nr_events)
 		goto unlock;

-	perf_ctx_disable(ctx, false);
+	perf_ctx_disable(ctx, 0);
 	/*
 	 * We want to keep the following priority order:
 	 * cpu pinned (that don't need to move), task pinned,
@@ -3990,7 +3994,7 @@ static void perf_event_context_sched_in(struct
task_struct *task)
 	 * events, no need to flip the cpuctx's events around.
 	 */
 	if (!RB_EMPTY_ROOT(&ctx->pinned_groups.tree)) {
-		perf_ctx_disable(&cpuctx->ctx, false);
+		perf_ctx_disable(&cpuctx->ctx, 0);
 		ctx_sched_out(&cpuctx->ctx, EVENT_FLEXIBLE);
 	}

@@ -3999,9 +4003,9 @@ static void perf_event_context_sched_in(struct
task_struct *task)
 	perf_ctx_sched_task_cb(cpuctx->task_ctx, true);

 	if (!RB_EMPTY_ROOT(&ctx->pinned_groups.tree))
-		perf_ctx_enable(&cpuctx->ctx, false);
+		perf_ctx_enable(&cpuctx->ctx, 0);

-	perf_ctx_enable(ctx, false);
+	perf_ctx_enable(ctx, 0);

 unlock:
 	perf_ctx_unlock(cpuctx, ctx);


Here are the second patch to introduce EVENT_GUEST and
perf_guest_exit/enter().


From c052e673dc3e0e7ebacdce23f2b0d50ec98401b3 Mon Sep 17 00:00:00 2001
From: Kan Liang <kan.liang@linux.intel.com>
Date: Tue, 11 Jun 2024 06:04:20 -0700
Subject: [PATCH 2/2] perf: Add generic exclude_guest support

Current perf doesn't explicitly schedule out all exclude_guest events
while the guest is running. There is no problem with the current
emulated vPMU. Because perf owns all the PMU counters. It can mask the
counter which is assigned to an exclude_guest event when a guest is
running (Intel way), or set the corresponding HOSTONLY bit in evsentsel
(AMD way). The counter doesn't count when a guest is running.

However, either way doesn't work with the introduced passthrough vPMU.
A guest owns all the PMU counters when it's running. The host should not
mask any counters. The counter may be used by the guest. The evsentsel
may be overwritten.

Perf should explicitly schedule out all exclude_guest events to release
the PMU resources when entering a guest, and resume the counting when
exiting the guest.

Expose two interfaces to KVM. The KVM should notify the perf when
entering/exiting a guest.

Introduce a new event type EVENT_CGUEST to indicate that perf should
check and skip the PMUs which doesn't support the passthrough mode.

It's possible that an exclude_guest event is created when a guest is
running. The new event should not be scheduled in as well.

The ctx->time is used to calculated the running/enabling time of an
event, which is shared among PMUs. The ctx_sched_in/out() with
EVENT_CGUEST doesn't stop the ctx->time. A timeguest is introduced to
track the start time of a guest. For an exclude_guest event, the time in
the guest mode is deducted.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
---
 include/linux/perf_event.h |   5 ++
 kernel/events/core.c       | 119 +++++++++++++++++++++++++++++++++++--
 2 files changed, 120 insertions(+), 4 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index dd4920bf3d1b..68c8b93c4e5c 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -945,6 +945,7 @@ struct perf_event_context {
 	u64				time;
 	u64				timestamp;
 	u64				timeoffset;
+	u64				timeguest;

 	/*
 	 * These fields let us detect when two contexts have both
@@ -1734,6 +1735,8 @@ extern int perf_event_period(struct perf_event
*event, u64 value);
 extern u64 perf_event_pause(struct perf_event *event, bool reset);
 extern int perf_get_mediated_pmu(void);
 extern void perf_put_mediated_pmu(void);
+void perf_guest_enter(void);
+void perf_guest_exit(void);
 #else /* !CONFIG_PERF_EVENTS: */
 static inline void *
 perf_aux_output_begin(struct perf_output_handle *handle,
@@ -1826,6 +1829,8 @@ static inline int perf_get_mediated_pmu(void)
 }

 static inline void perf_put_mediated_pmu(void)			{ }
+static inline void perf_guest_enter(void)			{ }
+static inline void perf_guest_exit(void)			{ }
 #endif

 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 95d1d5a5addc..cd3a89672b14 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -376,7 +376,8 @@ enum event_type_t {
 	/* see ctx_resched() for details */
 	EVENT_CPU = 0x8,
 	EVENT_CGROUP = 0x10,
-	EVENT_FLAGS = EVENT_CGROUP,
+	EVENT_GUEST = 0x20,
+	EVENT_FLAGS = EVENT_CGROUP | EVENT_GUEST,
 	EVENT_ALL = EVENT_FLEXIBLE | EVENT_PINNED,
 };

@@ -407,6 +408,7 @@ static atomic_t nr_include_guest_events __read_mostly;

 static atomic_t nr_mediated_pmu_vms;
 static DEFINE_MUTEX(perf_mediated_pmu_mutex);
+static DEFINE_PER_CPU(bool, perf_in_guest);

 /* !exclude_guest event of PMU with PERF_PMU_CAP_PASSTHROUGH_VPMU */
 static inline bool is_include_guest_event(struct perf_event *event)
@@ -651,10 +653,26 @@ __perf_update_times(struct perf_event *event, u64
now, u64 *enabled, u64 *runnin

 static void perf_event_update_time(struct perf_event *event)
 {
-	u64 now = perf_event_time(event);
+	u64 now;
+
+	/* Never count the time of an active guest into an exclude_guest event. */
+	if (event->ctx->timeguest &&
+	    event->pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU) {
+		/*
+		 * If a guest is running, use the timestamp while entering the guest.
+		 * If the guest is leaving, reset the event timestamp.
+		 */
+		if (__this_cpu_read(perf_in_guest))
+			event->tstamp = event->ctx->timeguest;
+		else
+			event->tstamp = event->ctx->time;
+		return;
+	}

+	now = perf_event_time(event);
 	__perf_update_times(event, now, &event->total_time_enabled,
 					&event->total_time_running);
+
 	event->tstamp = now;
 }

@@ -706,6 +724,10 @@ static bool perf_skip_pmu_ctx(struct
perf_event_pmu_context *pmu_ctx,
 	if ((event_type & EVENT_CGROUP) && !pmu_ctx->nr_cgroups)
 		return true;

+	if ((event_type & EVENT_GUEST) &&
+	    !(pmu_ctx->pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU))
+		return true;
+
 	return false;
 }

@@ -3350,7 +3372,14 @@ ctx_sched_out(struct perf_event_context *ctx,
enum event_type_t event_type)
 			cpuctx->task_ctx = NULL;
 	}

-	is_active ^= ctx->is_active; /* changed bits */
+	if (event_type & EVENT_GUEST) {
+		/*
+		 * Schedule out all !exclude_guest events of PMU
+		 * with PERF_PMU_CAP_PASSTHROUGH_VPMU.
+		 */
+		is_active = EVENT_ALL;
+	} else
+		is_active ^= ctx->is_active; /* changed bits */

 	list_for_each_entry(pmu_ctx, &ctx->pmu_ctx_list, pmu_ctx_entry) {
 		if (perf_skip_pmu_ctx(pmu_ctx, event_type))
@@ -3860,6 +3889,15 @@ static int merge_sched_in(struct perf_event
*event, void *data)
 	if (!event_filter_match(event))
 		return 0;

+	/*
+	 * Don't schedule in any exclude_guest events of PMU with
+	 * PERF_PMU_CAP_PASSTHROUGH_VPMU, while a guest is running.
+	 */
+	if (__this_cpu_read(perf_in_guest) &&
+	    event->pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU &&
+	    event->attr.exclude_guest)
+		return 0;
+
 	if (group_can_go_on(event, *can_add_hw)) {
 		if (!group_sched_in(event, ctx))
 			list_add_tail(&event->active_list, get_event_list(event));
@@ -3941,7 +3979,20 @@ ctx_sched_in(struct perf_event_context *ctx, enum
event_type_t event_type)
 			WARN_ON_ONCE(cpuctx->task_ctx != ctx);
 	}

-	is_active ^= ctx->is_active; /* changed bits */
+	if (event_type & EVENT_GUEST) {
+		/*
+		 * Schedule in all !exclude_guest events of PMU
+		 * with PERF_PMU_CAP_PASSTHROUGH_VPMU.
+		 */
+		is_active = EVENT_ALL;
+
+		/*
+		 * Update ctx time to set the new start time for
+		 * the exclude_guest events.
+		 */
+		update_context_time(ctx);
+	} else
+		is_active ^= ctx->is_active; /* changed bits */

 	/*
 	 * First go through the list and put on any pinned groups
@@ -5788,6 +5839,66 @@ void perf_put_mediated_pmu(void)
 }
 EXPORT_SYMBOL_GPL(perf_put_mediated_pmu);

+/* When entering a guest, schedule out all exclude_guest events. */
+void perf_guest_enter(void)
+{
+	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
+
+	lockdep_assert_irqs_disabled();
+
+	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
+
+	if (WARN_ON_ONCE(__this_cpu_read(perf_in_guest))) {
+		perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
+		return;
+	}
+
+	perf_ctx_disable(&cpuctx->ctx, EVENT_GUEST);
+	ctx_sched_out(&cpuctx->ctx, EVENT_GUEST);
+	/* Set the guest start time */
+	cpuctx->ctx.timeguest = cpuctx->ctx.time;
+	perf_ctx_enable(&cpuctx->ctx, EVENT_GUEST);
+	if (cpuctx->task_ctx) {
+		perf_ctx_disable(cpuctx->task_ctx, EVENT_GUEST);
+		task_ctx_sched_out(cpuctx->task_ctx, EVENT_GUEST);
+		cpuctx->task_ctx->timeguest = cpuctx->task_ctx->time;
+		perf_ctx_enable(cpuctx->task_ctx, EVENT_GUEST);
+	}
+
+	__this_cpu_write(perf_in_guest, true);
+
+	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
+}
+
+void perf_guest_exit(void)
+{
+	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
+
+	lockdep_assert_irqs_disabled();
+
+	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
+
+	if (WARN_ON_ONCE(!__this_cpu_read(perf_in_guest))) {
+		perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
+		return;
+	}
+
+	__this_cpu_write(perf_in_guest, false);
+
+	perf_ctx_disable(&cpuctx->ctx, EVENT_GUEST);
+	ctx_sched_in(&cpuctx->ctx, EVENT_GUEST);
+	cpuctx->ctx.timeguest = 0;
+	perf_ctx_enable(&cpuctx->ctx, EVENT_GUEST);
+	if (cpuctx->task_ctx) {
+		perf_ctx_disable(cpuctx->task_ctx, EVENT_GUEST);
+		ctx_sched_in(cpuctx->task_ctx, EVENT_GUEST);
+		cpuctx->task_ctx->timeguest = 0;
+		perf_ctx_enable(cpuctx->task_ctx, EVENT_GUEST);
+	}
+
+	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
+}
+
 /*
  * Holding the top-level event's child_mutex means that any
  * descendant process that has inherited this event will block


Thanks,
Kan


