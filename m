Return-Path: <kvm+bounces-19249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0251A9027AB
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 19:23:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91B3D284A07
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 17:23:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B56191474A9;
	Mon, 10 Jun 2024 17:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TA6M5pRt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BE4145B09;
	Mon, 10 Jun 2024 17:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718040192; cv=none; b=rmKDmvCv3dHUGVPs7zBT+2HoUdv+pg/I7QqbVzsoWRU+g18DGSlWAf+uCFYlEr+gwgj4cmkoeKxMmJbrzyreGSfbhB8cspO6LA8Qwd00pbtcNFJRozK7ef0OULTQTl9St8mGpFymogN7l08llPJLNsmtblwDcdsuaP+4axZ6MFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718040192; c=relaxed/simple;
	bh=xICCe+ukBvtwKOZY0xKMoj4LsItlafubP1FcEzkhyaY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=At98AjnIka8P6IZARxVSU4EdimAhhYpfnNmGlll/h1P5EG0cdBtua3SyWk3w7w4xrxAGtCn8UoZH4O/CtBhyV0q9wQwbeLBdOz01HEwwbDpO3StHYX8oN5LJTEggho8Z8fSO041GRmCaztvOb6BaP5J2oLBlcMXYtDldwIFpGdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TA6M5pRt; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718040191; x=1749576191;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xICCe+ukBvtwKOZY0xKMoj4LsItlafubP1FcEzkhyaY=;
  b=TA6M5pRthFEbKpKq7Sa87L5fehr8eWMFtST9pmhUSrN5zUeYSHUK2x/4
   uVuSMpeSBoHlFj0MjcsTBT87WmqmKJR+z8rULkdG9G9kpGI1u1vmK1Ji0
   FnIZ/ZAnkojG+WmVWUuE6Ix6QSPGypGgTA+ksyEuFWdyYgeW1UKMWnnBQ
   LtGeMTnGb9/p2wpwKY3y+665O/GVvA6hSkMHgjcmeCYpVgtvmBHS9wH1P
   C+EGzVf22wsmnnn+4XVBEjOi0Myleax4bjtJ7bsdO3C+GwzwgcxOkN4SU
   pfFOGNR3fuDJD3+rmxKOQJWHb2fvGMgzBPDojDbbdE4DtzCF7Jq0IfOuS
   g==;
X-CSE-ConnectionGUID: uAQDDSVIRG+MK56EVNQJaQ==
X-CSE-MsgGUID: CM7t3zZ+SHy7L7ETw/TgGQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11099"; a="18567857"
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="18567857"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 10:23:09 -0700
X-CSE-ConnectionGUID: MrVk/wGkSzCuHkFpXeInxQ==
X-CSE-MsgGUID: SAy+V+F9Q22ekCMiaRBONQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="39129703"
Received: from linux.intel.com ([10.54.29.200])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 10:23:08 -0700
Received: from [10.213.169.239] (kliang2-mobl1.ccr.corp.intel.com [10.213.169.239])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id D6DF320B5703;
	Mon, 10 Jun 2024 10:23:05 -0700 (PDT)
Message-ID: <902c40cc-6e0b-4b2f-826c-457f533a0a76@linux.intel.com>
Date: Mon, 10 Jun 2024 13:23:04 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/54] perf: Add generic exclude_guest support
To: Peter Zijlstra <peterz@infradead.org>, Mingwei Zhang <mizhang@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
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
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <20240507085807.GS40213@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024-05-07 4:58 a.m., Peter Zijlstra wrote:
> On Mon, May 06, 2024 at 05:29:32AM +0000, Mingwei Zhang wrote:
> 
>> @@ -5791,6 +5801,100 @@ void perf_put_mediated_pmu(void)
>>  }
>>  EXPORT_SYMBOL_GPL(perf_put_mediated_pmu);
>>  
>> +static void perf_sched_out_exclude_guest(struct perf_event_context *ctx)
>> +{
>> +	struct perf_event_pmu_context *pmu_ctx;
>> +
>> +	update_context_time(ctx);
>> +	list_for_each_entry(pmu_ctx, &ctx->pmu_ctx_list, pmu_ctx_entry) {
>> +		struct perf_event *event, *tmp;
>> +		struct pmu *pmu = pmu_ctx->pmu;
>> +
>> +		if (!(pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU))
>> +			continue;
>> +
>> +		perf_pmu_disable(pmu);
>> +
>> +		/*
>> +		 * All active events must be exclude_guest events.
>> +		 * See perf_get_mediated_pmu().
>> +		 * Unconditionally remove all active events.
>> +		 */
>> +		list_for_each_entry_safe(event, tmp, &pmu_ctx->pinned_active, active_list)
>> +			group_sched_out(event, pmu_ctx->ctx);
>> +
>> +		list_for_each_entry_safe(event, tmp, &pmu_ctx->flexible_active, active_list)
>> +			group_sched_out(event, pmu_ctx->ctx);
>> +
>> +		pmu_ctx->rotate_necessary = 0;
>> +
>> +		perf_pmu_enable(pmu);
>> +	}
>> +}
>> +
>> +/* When entering a guest, schedule out all exclude_guest events. */
>> +void perf_guest_enter(void)
>> +{
>> +	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
>> +
>> +	lockdep_assert_irqs_disabled();
>> +
>> +	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
>> +
>> +	if (WARN_ON_ONCE(__this_cpu_read(perf_in_guest))) {
>> +		perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
>> +		return;
>> +	}
>> +
>> +	perf_sched_out_exclude_guest(&cpuctx->ctx);
>> +	if (cpuctx->task_ctx)
>> +		perf_sched_out_exclude_guest(cpuctx->task_ctx);
>> +
>> +	__this_cpu_write(perf_in_guest, true);
>> +
>> +	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
>> +}
>> +
>> +static void perf_sched_in_exclude_guest(struct perf_event_context *ctx)
>> +{
>> +	struct perf_event_pmu_context *pmu_ctx;
>> +
>> +	update_context_time(ctx);
>> +	list_for_each_entry(pmu_ctx, &ctx->pmu_ctx_list, pmu_ctx_entry) {
>> +		struct pmu *pmu = pmu_ctx->pmu;
>> +
>> +		if (!(pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU))
>> +			continue;
>> +
>> +		perf_pmu_disable(pmu);
>> +		pmu_groups_sched_in(ctx, &ctx->pinned_groups, pmu);
>> +		pmu_groups_sched_in(ctx, &ctx->flexible_groups, pmu);
>> +		perf_pmu_enable(pmu);
>> +	}
>> +}
>> +
>> +void perf_guest_exit(void)
>> +{
>> +	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
>> +
>> +	lockdep_assert_irqs_disabled();
>> +
>> +	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
>> +
>> +	if (WARN_ON_ONCE(!__this_cpu_read(perf_in_guest))) {
>> +		perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
>> +		return;
>> +	}
>> +
>> +	__this_cpu_write(perf_in_guest, false);
>> +
>> +	perf_sched_in_exclude_guest(&cpuctx->ctx);
>> +	if (cpuctx->task_ctx)
>> +		perf_sched_in_exclude_guest(cpuctx->task_ctx);
>> +
>> +	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
>> +}
> 
> Bah, this is a ton of copy-paste from the normal scheduling code with
> random changes. Why ?
> 
> Why can't this use ctx_sched_{in,out}() ? Surely the whole
> CAP_PASSTHROUGHT thing is but a flag away.
>

Not just a flag. The time has to be updated as well, since the ctx->time
is shared among PMUs. Perf shouldn't stop it while other PMUs is still
running.

A timeguest will be introduced to track the start time of a guest.
The event->tstamp of an exclude_guest event should always keep
ctx->timeguest while a guest is running.
When a guest is leaving, update the event->tstamp to now, so the guest
time can be deducted.

The below patch demonstrate how the timeguest works.
(It's an incomplete patch. Just to show the idea.)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 22d3e56682c9..2134e6886e22 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -953,6 +953,7 @@ struct perf_event_context {
 	u64				time;
 	u64				timestamp;
 	u64				timeoffset;
+	u64				timeguest;

 	/*
 	 * These fields let us detect when two contexts have both
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 14fd881e3e1d..2aed56671a24 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -690,12 +690,31 @@ __perf_update_times(struct perf_event *event, u64
now, u64 *enabled, u64 *runnin
 		*running += delta;
 }

+static void perf_event_update_time_guest(struct perf_event *event)
+{
+	/*
+	 * If a guest is running, use the timestamp while entering the guest.
+	 * If the guest is leaving, reset the event timestamp.
+	 */
+	if (!__this_cpu_read(perf_in_guest))
+		event->tstamp = event->ctx->time;
+	else
+		event->tstamp = event->ctx->timeguest;
+}
+
 static void perf_event_update_time(struct perf_event *event)
 {
-	u64 now = perf_event_time(event);
+	u64 now;
+
+	/* Never count the time of an active guest into an exclude_guest event. */
+	if (event->ctx->timeguest &&
+	    event->pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU)
+		return perf_event_update_time_guest(event);

+	now = perf_event_time(event);
 	__perf_update_times(event, now, &event->total_time_enabled,
 					&event->total_time_running);
+
 	event->tstamp = now;
 }

@@ -3398,7 +3417,14 @@ ctx_sched_out(struct perf_event_context *ctx,
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
@@ -3998,7 +4024,20 @@ ctx_sched_in(struct perf_event_context *ctx, enum
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

@@ -5894,14 +5933,18 @@ void perf_guest_enter(u32 guest_lvtpc)
 	}

 	perf_ctx_disable(&cpuctx->ctx, EVENT_GUEST);
-	ctx_sched_out(&cpuctx->ctx, EVENT_ALL | EVENT_GUEST);
+	ctx_sched_out(&cpuctx->ctx, EVENT_GUEST);
+	/* Set the guest start time */
+	cpuctx->ctx.timeguest = cpuctx->ctx.time;
 	perf_ctx_enable(&cpuctx->ctx, EVENT_GUEST);
 	if (cpuctx->task_ctx) {
 		perf_ctx_disable(cpuctx->task_ctx, EVENT_GUEST);
-		task_ctx_sched_out(cpuctx->task_ctx, EVENT_ALL | EVENT_GUEST);
+		task_ctx_sched_out(cpuctx->task_ctx, EVENT_GUEST);
+		cpuctx->task_ctx->timeguest = cpuctx->task_ctx->time;
 		perf_ctx_enable(cpuctx->task_ctx, EVENT_GUEST);
 	}

 	__this_cpu_write(perf_in_guest, true);
@@ -5925,14 +5968,17 @@ void perf_guest_exit(void)

 	__this_cpu_write(perf_in_guest, false);

 	perf_ctx_disable(&cpuctx->ctx, EVENT_GUEST);
-	ctx_sched_in(&cpuctx->ctx, EVENT_ALL | EVENT_GUEST);
+	ctx_sched_in(&cpuctx->ctx, EVENT_GUEST);
+	cpuctx->ctx.timeguest = 0;
 	perf_ctx_enable(&cpuctx->ctx, EVENT_GUEST);
 	if (cpuctx->task_ctx) {
 		perf_ctx_disable(cpuctx->task_ctx, EVENT_GUEST);
-		ctx_sched_in(cpuctx->task_ctx, EVENT_ALL | EVENT_GUEST);
+		ctx_sched_in(cpuctx->task_ctx, EVENT_GUEST);
+		cpuctx->task_ctx->timeguest = 0;
 		perf_ctx_enable(cpuctx->task_ctx, EVENT_GUEST);
 	}

Thanks
Kan

