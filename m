Return-Path: <kvm+bounces-24726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 509F2959E76
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 15:17:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD05D1F2236A
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 13:17:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C662199955;
	Wed, 21 Aug 2024 13:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gE1p7GOT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2A9161306;
	Wed, 21 Aug 2024 13:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724246219; cv=none; b=BB2oBicdYC+F84o5RcHZbZ4CpSx+kiNbOpBKaLchXTEkQvYSKEwzy2Wy2tmvp2LI+ZmI+oRI72e+krKqhGiDRI6NXf+vhaEOv+gkoBQ9M2wkqjzTUn4mP2oMKze8dHB0srpWB2a+AT89hFCre6/17Lui9x2QPvpxkTr+mF1F4i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724246219; c=relaxed/simple;
	bh=XhyM8mbiPft2vOhNdB5VzN4mrjvB/3Nwb5MuMnOdjyw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rTYlZbCHSwgMfzlBqC541jmsadiFhPDiv6O90nwBnvD6aD8aQ3txM6kYCZzcVgPN576e10juDE/+HPwHnz6IhHSk5t8V6DkpVHFJ0XBaO00pMQ4XxruV6opjDHoeqpHW+0K+q0j+1ENXxUXqLWxX4HtBaeq3kOQC4k7CEyju89M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gE1p7GOT; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724246217; x=1755782217;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XhyM8mbiPft2vOhNdB5VzN4mrjvB/3Nwb5MuMnOdjyw=;
  b=gE1p7GOTAK6dPKJwpwd3CM++otKGkE43w4FRnFj5KU1HqBqa3l9t+NNw
   BzEH++GM0O39RdFok2WUI3f4Suy6DHKpgoefUO40h8nIVxid1LvgPrgOy
   c1GXA/FhAhx+XqlSqmILPOOmLIkUbwnH0NDgU7vzXu5B8iXPy8JB5/4uW
   J+tZyKeLbxKoRBxnKTjgON0kmANdXq/k5Ai9UT/o8eEzAvZlKnZz7GVt7
   mcMP+hfraINOx7hh2qsXxamRkProxvdMY8ktpJCz6pT8xwdlzImnDQyeI
   Lz4vTAOaUVntAX6Mo6nabohE4n6jjAndzpb8Jrxb/9tM62oUbCh84yhG7
   w==;
X-CSE-ConnectionGUID: eErw+z7oTL2r2RtBtvy6Ug==
X-CSE-MsgGUID: ZXkgjLXcSVqphJVdgGAGhQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11171"; a="26357735"
X-IronPort-AV: E=Sophos;i="6.10,164,1719903600"; 
   d="scan'208";a="26357735"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2024 06:16:48 -0700
X-CSE-ConnectionGUID: fdcOlDgfTy+2DKmH3j566A==
X-CSE-MsgGUID: TTLb/tlhRxOeriapwfw02g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,164,1719903600"; 
   d="scan'208";a="65298954"
Received: from linux.intel.com ([10.54.29.200])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2024 06:16:47 -0700
Received: from [10.212.50.248] (kliang2-mobl1.ccr.corp.intel.com [10.212.50.248])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id F28A920CFEDF;
	Wed, 21 Aug 2024 06:16:44 -0700 (PDT)
Message-ID: <a42f95cb-9f6a-4518-aac5-0d1b56f08b94@linux.intel.com>
Date: Wed, 21 Aug 2024 09:16:43 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 09/58] perf: Add a EVENT_GUEST flag
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>,
 Mingwei Zhang <mizhang@google.com>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Xiong Zhang <xiong.y.zhang@intel.com>,
 Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>,
 Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>,
 Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
 gce-passthrou-pmu-dev@google.com, Samantha Alt <samantha.alt@intel.com>,
 Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
 Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-10-mizhang@google.com>
 <095522b1-faad-4544-9282-4dda8be03695@linux.intel.com>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <095522b1-faad-4544-9282-4dda8be03695@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 2024-08-21 1:27 a.m., Mi, Dapeng wrote:
> 
> On 8/1/2024 12:58 PM, Mingwei Zhang wrote:
>> From: Kan Liang <kan.liang@linux.intel.com>
>>
>> Current perf doesn't explicitly schedule out all exclude_guest events
>> while the guest is running. There is no problem with the current
>> emulated vPMU. Because perf owns all the PMU counters. It can mask the
>> counter which is assigned to an exclude_guest event when a guest is
>> running (Intel way), or set the corresponding HOSTONLY bit in evsentsel
>> (AMD way). The counter doesn't count when a guest is running.
>>
>> However, either way doesn't work with the introduced passthrough vPMU.
>> A guest owns all the PMU counters when it's running. The host should not
>> mask any counters. The counter may be used by the guest. The evsentsel
>> may be overwritten.
>>
>> Perf should explicitly schedule out all exclude_guest events to release
>> the PMU resources when entering a guest, and resume the counting when
>> exiting the guest.
>>
>> It's possible that an exclude_guest event is created when a guest is
>> running. The new event should not be scheduled in as well.
>>
>> The ctx time is shared among different PMUs. The time cannot be stopped
>> when a guest is running. It is required to calculate the time for events
>> from other PMUs, e.g., uncore events. Add timeguest to track the guest
>> run time. For an exclude_guest event, the elapsed time equals
>> the ctx time - guest time.
>> Cgroup has dedicated times. Use the same method to deduct the guest time
>> from the cgroup time as well.
>>
>> Co-developed-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
>> Signed-off-by: Mingwei Zhang <mizhang@google.com>
>> ---
>>  include/linux/perf_event.h |   6 ++
>>  kernel/events/core.c       | 178 +++++++++++++++++++++++++++++++------
>>  2 files changed, 155 insertions(+), 29 deletions(-)
>>
>> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
>> index e22cdb6486e6..81a5f8399cb8 100644
>> --- a/include/linux/perf_event.h
>> +++ b/include/linux/perf_event.h
>> @@ -952,6 +952,11 @@ struct perf_event_context {
>>  	 */
>>  	struct perf_time_ctx		time;
>>  
>> +	/*
>> +	 * Context clock, runs when in the guest mode.
>> +	 */
>> +	struct perf_time_ctx		timeguest;
>> +
>>  	/*
>>  	 * These fields let us detect when two contexts have both
>>  	 * been cloned (inherited) from a common ancestor.
>> @@ -1044,6 +1049,7 @@ struct bpf_perf_event_data_kern {
>>   */
>>  struct perf_cgroup_info {
>>  	struct perf_time_ctx		time;
>> +	struct perf_time_ctx		timeguest;
>>  	int				active;
>>  };
>>  
>> diff --git a/kernel/events/core.c b/kernel/events/core.c
>> index c25e2bf27001..57648736e43e 100644
>> --- a/kernel/events/core.c
>> +++ b/kernel/events/core.c
>> @@ -376,7 +376,8 @@ enum event_type_t {
>>  	/* see ctx_resched() for details */
>>  	EVENT_CPU = 0x8,
>>  	EVENT_CGROUP = 0x10,
>> -	EVENT_FLAGS = EVENT_CGROUP,
>> +	EVENT_GUEST = 0x20,
>> +	EVENT_FLAGS = EVENT_CGROUP | EVENT_GUEST,
>>  	EVENT_ALL = EVENT_FLEXIBLE | EVENT_PINNED,
>>  };
>>  
>> @@ -407,6 +408,7 @@ static atomic_t nr_include_guest_events __read_mostly;
>>  
>>  static atomic_t nr_mediated_pmu_vms;
>>  static DEFINE_MUTEX(perf_mediated_pmu_mutex);
>> +static DEFINE_PER_CPU(bool, perf_in_guest);
>>  
>>  /* !exclude_guest event of PMU with PERF_PMU_CAP_PASSTHROUGH_VPMU */
>>  static inline bool is_include_guest_event(struct perf_event *event)
>> @@ -706,6 +708,10 @@ static bool perf_skip_pmu_ctx(struct perf_event_pmu_context *pmu_ctx,
>>  	if ((event_type & EVENT_CGROUP) && !pmu_ctx->nr_cgroups)
>>  		return true;
>>  
>> +	if ((event_type & EVENT_GUEST) &&
>> +	    !(pmu_ctx->pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU))
>> +		return true;
>> +
>>  	return false;
>>  }
>>  
>> @@ -770,12 +776,21 @@ static inline int is_cgroup_event(struct perf_event *event)
>>  	return event->cgrp != NULL;
>>  }
>>  
>> +static inline u64 __perf_event_time_ctx(struct perf_event *event,
>> +					struct perf_time_ctx *time,
>> +					struct perf_time_ctx *timeguest);
>> +
>> +static inline u64 __perf_event_time_ctx_now(struct perf_event *event,
>> +					    struct perf_time_ctx *time,
>> +					    struct perf_time_ctx *timeguest,
>> +					    u64 now);
>> +
>>  static inline u64 perf_cgroup_event_time(struct perf_event *event)
>>  {
>>  	struct perf_cgroup_info *t;
>>  
>>  	t = per_cpu_ptr(event->cgrp->info, event->cpu);
>> -	return t->time.time;
>> +	return __perf_event_time_ctx(event, &t->time, &t->timeguest);
>>  }
>>  
>>  static inline u64 perf_cgroup_event_time_now(struct perf_event *event, u64 now)
>> @@ -784,9 +799,9 @@ static inline u64 perf_cgroup_event_time_now(struct perf_event *event, u64 now)
>>  
>>  	t = per_cpu_ptr(event->cgrp->info, event->cpu);
>>  	if (!__load_acquire(&t->active))
>> -		return t->time.time;
>> -	now += READ_ONCE(t->time.offset);
>> -	return now;
>> +		return __perf_event_time_ctx(event, &t->time, &t->timeguest);
>> +
>> +	return __perf_event_time_ctx_now(event, &t->time, &t->timeguest, now);
>>  }
>>  
>>  static inline void update_perf_time_ctx(struct perf_time_ctx *time, u64 now, bool adv);
>> @@ -796,6 +811,18 @@ static inline void __update_cgrp_time(struct perf_cgroup_info *info, u64 now, bo
>>  	update_perf_time_ctx(&info->time, now, adv);
>>  }
>>  
>> +static inline void __update_cgrp_guest_time(struct perf_cgroup_info *info, u64 now, bool adv)
>> +{
>> +	update_perf_time_ctx(&info->timeguest, now, adv);
>> +}
>> +
>> +static inline void update_cgrp_time(struct perf_cgroup_info *info, u64 now)
>> +{
>> +	__update_cgrp_time(info, now, true);
>> +	if (__this_cpu_read(perf_in_guest))
>> +		__update_cgrp_guest_time(info, now, true);
>> +}
>> +
>>  static inline void update_cgrp_time_from_cpuctx(struct perf_cpu_context *cpuctx, bool final)
>>  {
>>  	struct perf_cgroup *cgrp = cpuctx->cgrp;
>> @@ -809,7 +836,7 @@ static inline void update_cgrp_time_from_cpuctx(struct perf_cpu_context *cpuctx,
>>  			cgrp = container_of(css, struct perf_cgroup, css);
>>  			info = this_cpu_ptr(cgrp->info);
>>  
>> -			__update_cgrp_time(info, now, true);
>> +			update_cgrp_time(info, now);
>>  			if (final)
>>  				__store_release(&info->active, 0);
>>  		}
>> @@ -832,11 +859,11 @@ static inline void update_cgrp_time_from_event(struct perf_event *event)
>>  	 * Do not update time when cgroup is not active
>>  	 */
>>  	if (info->active)
>> -		__update_cgrp_time(info, perf_clock(), true);
>> +		update_cgrp_time(info, perf_clock());
>>  }
>>  
>>  static inline void
>> -perf_cgroup_set_timestamp(struct perf_cpu_context *cpuctx)
>> +perf_cgroup_set_timestamp(struct perf_cpu_context *cpuctx, bool guest)
>>  {
>>  	struct perf_event_context *ctx = &cpuctx->ctx;
>>  	struct perf_cgroup *cgrp = cpuctx->cgrp;
>> @@ -856,8 +883,12 @@ perf_cgroup_set_timestamp(struct perf_cpu_context *cpuctx)
>>  	for (css = &cgrp->css; css; css = css->parent) {
>>  		cgrp = container_of(css, struct perf_cgroup, css);
>>  		info = this_cpu_ptr(cgrp->info);
>> -		__update_cgrp_time(info, ctx->time.stamp, false);
>> -		__store_release(&info->active, 1);
>> +		if (guest) {
>> +			__update_cgrp_guest_time(info, ctx->time.stamp, false);
>> +		} else {
>> +			__update_cgrp_time(info, ctx->time.stamp, false);
>> +			__store_release(&info->active, 1);
>> +		}
>>  	}
>>  }
>>  
>> @@ -1061,7 +1092,7 @@ static inline int perf_cgroup_connect(pid_t pid, struct perf_event *event,
>>  }
>>  
>>  static inline void
>> -perf_cgroup_set_timestamp(struct perf_cpu_context *cpuctx)
>> +perf_cgroup_set_timestamp(struct perf_cpu_context *cpuctx, bool guest)
>>  {
>>  }
>>  
>> @@ -1488,16 +1519,34 @@ static inline void update_perf_time_ctx(struct perf_time_ctx *time, u64 now, boo
>>   */
>>  static void __update_context_time(struct perf_event_context *ctx, bool adv)
>>  {
>> -	u64 now = perf_clock();
>> +	lockdep_assert_held(&ctx->lock);
>> +
>> +	update_perf_time_ctx(&ctx->time, perf_clock(), adv);
>> +}
>>  
>> +static void __update_context_guest_time(struct perf_event_context *ctx, bool adv)
>> +{
>>  	lockdep_assert_held(&ctx->lock);
>>  
>> -	update_perf_time_ctx(&ctx->time, now, adv);
>> +	/* must be called after __update_context_time(); */
>> +	update_perf_time_ctx(&ctx->timeguest, ctx->time.stamp, adv);
>>  }
>>  
>>  static void update_context_time(struct perf_event_context *ctx)
>>  {
>>  	__update_context_time(ctx, true);
>> +	if (__this_cpu_read(perf_in_guest))
>> +		__update_context_guest_time(ctx, true);
>> +}
>> +
>> +static inline u64 __perf_event_time_ctx(struct perf_event *event,
>> +					struct perf_time_ctx *time,
>> +					struct perf_time_ctx *timeguest)
>> +{
>> +	if (event->attr.exclude_guest)
>> +		return time->time - timeguest->time;
>> +	else
>> +		return time->time;
>>  }
>>  
>>  static u64 perf_event_time(struct perf_event *event)
>> @@ -1510,7 +1559,26 @@ static u64 perf_event_time(struct perf_event *event)
>>  	if (is_cgroup_event(event))
>>  		return perf_cgroup_event_time(event);
>>  
>> -	return ctx->time.time;
>> +	return __perf_event_time_ctx(event, &ctx->time, &ctx->timeguest);
>> +}
>> +
>> +static inline u64 __perf_event_time_ctx_now(struct perf_event *event,
>> +					    struct perf_time_ctx *time,
>> +					    struct perf_time_ctx *timeguest,
>> +					    u64 now)
>> +{
>> +	/*
>> +	 * The exclude_guest event time should be calculated from
>> +	 * the ctx time -  the guest time.
>> +	 * The ctx time is now + READ_ONCE(time->offset).
>> +	 * The guest time is now + READ_ONCE(timeguest->offset).
>> +	 * So the exclude_guest time is
>> +	 * READ_ONCE(time->offset) - READ_ONCE(timeguest->offset).
>> +	 */
>> +	if (event->attr.exclude_guest && __this_cpu_read(perf_in_guest))
> 
> Hi Kan,
> 
> we see the following the warning when run perf record command after
> enabling "CONFIG_DEBUG_PREEMPT" config item.
> 
> [  166.779208] BUG: using __this_cpu_read() in preemptible [00000000] code:
> perf/9494
> [  166.779234] caller is __this_cpu_preempt_check+0x13/0x20
> [  166.779241] CPU: 56 UID: 0 PID: 9494 Comm: perf Not tainted
> 6.11.0-rc4-perf-next-mediated-vpmu-v3+ #80
> [  166.779245] Hardware name: Quanta Cloud Technology Inc. QuantaGrid
> D54Q-2U/S6Q-MB-MPS, BIOS 3A11.uh 12/02/2022
> [  166.779248] Call Trace:
> [  166.779250]  <TASK>
> [  166.779252]  dump_stack_lvl+0x76/0xa0
> [  166.779260]  dump_stack+0x10/0x20
> [  166.779267]  check_preemption_disabled+0xd7/0xf0
> [  166.779273]  __this_cpu_preempt_check+0x13/0x20
> [  166.779279]  calc_timer_values+0x193/0x200
> [  166.779287]  perf_event_update_userpage+0x4b/0x170
> [  166.779294]  ? ring_buffer_attach+0x14c/0x200
> [  166.779301]  perf_mmap+0x533/0x5d0
> [  166.779309]  mmap_region+0x243/0xaa0
> [  166.779322]  do_mmap+0x35b/0x640
> [  166.779333]  vm_mmap_pgoff+0xf0/0x1c0
> [  166.779345]  ksys_mmap_pgoff+0x17a/0x250
> [  166.779354]  __x64_sys_mmap+0x33/0x70
> [  166.779362]  x64_sys_call+0x1fa4/0x25f0
> [  166.779369]  do_syscall_64+0x70/0x130
> 
> The season that kernel complains this is __perf_event_time_ctx_now() calls
> __this_cpu_read() in preemption enabled context.
> 
> To eliminate the warning, we may need to use this_cpu_read() to replace
> __this_cpu_read().

Sure.

Besides this, we recently update the time related code in perf.
https://lore.kernel.org/lkml/172311312757.2215.323044538405607858.tip-bot2@tip-bot2/

This patch probably have to be rebased on top of it.

Thanks,
Kan

> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index ccd61fd06e8d..1eb628f8b3a0 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -1581,7 +1581,7 @@ static inline u64 __perf_event_time_ctx_now(struct
> perf_event *event,
>          * So the exclude_guest time is
>          * READ_ONCE(time->offset) - READ_ONCE(timeguest->offset).
>          */
> -       if (event->attr.exclude_guest && __this_cpu_read(perf_in_guest))
> +       if (event->attr.exclude_guest && this_cpu_read(perf_in_guest))
>                 return READ_ONCE(time->offset) - READ_ONCE(timeguest->offset);
>         else
>                 return now + READ_ONCE(time->offset);
> 
>> +		return READ_ONCE(time->offset) - READ_ONCE(timeguest->offset);
>> +	else
>> +		return now + READ_ONCE(time->offset);
>>  }
>>  
>>  static u64 perf_event_time_now(struct perf_event *event, u64 now)
>> @@ -1524,10 +1592,9 @@ static u64 perf_event_time_now(struct perf_event *event, u64 now)
>>  		return perf_cgroup_event_time_now(event, now);
>>  
>>  	if (!(__load_acquire(&ctx->is_active) & EVENT_TIME))
>> -		return ctx->time.time;
>> +		return __perf_event_time_ctx(event, &ctx->time, &ctx->timeguest);
>>  
>> -	now += READ_ONCE(ctx->time.offset);
>> -	return now;
>> +	return __perf_event_time_ctx_now(event, &ctx->time, &ctx->timeguest, now);
>>  }
>>  
>>  static enum event_type_t get_event_type(struct perf_event *event)
>> @@ -3334,9 +3401,15 @@ ctx_sched_out(struct perf_event_context *ctx, enum event_type_t event_type)
>>  	 * would only update time for the pinned events.
>>  	 */
>>  	if (is_active & EVENT_TIME) {
>> +		bool stop;
>> +
>> +		/* vPMU should not stop time */
>> +		stop = !(event_type & EVENT_GUEST) &&
>> +		       ctx == &cpuctx->ctx;
>> +
>>  		/* update (and stop) ctx time */
>>  		update_context_time(ctx);
>> -		update_cgrp_time_from_cpuctx(cpuctx, ctx == &cpuctx->ctx);
>> +		update_cgrp_time_from_cpuctx(cpuctx, stop);
>>  		/*
>>  		 * CPU-release for the below ->is_active store,
>>  		 * see __load_acquire() in perf_event_time_now()
>> @@ -3354,7 +3427,18 @@ ctx_sched_out(struct perf_event_context *ctx, enum event_type_t event_type)
>>  			cpuctx->task_ctx = NULL;
>>  	}
>>  
>> -	is_active ^= ctx->is_active; /* changed bits */
>> +	if (event_type & EVENT_GUEST) {
>> +		/*
>> +		 * Schedule out all !exclude_guest events of PMU
>> +		 * with PERF_PMU_CAP_PASSTHROUGH_VPMU.
>> +		 */
>> +		is_active = EVENT_ALL;
>> +		__update_context_guest_time(ctx, false);
>> +		perf_cgroup_set_timestamp(cpuctx, true);
>> +		barrier();
>> +	} else {
>> +		is_active ^= ctx->is_active; /* changed bits */
>> +	}
>>  
>>  	list_for_each_entry(pmu_ctx, &ctx->pmu_ctx_list, pmu_ctx_entry) {
>>  		if (perf_skip_pmu_ctx(pmu_ctx, event_type))
>> @@ -3853,10 +3937,15 @@ static inline void group_update_userpage(struct perf_event *group_event)
>>  		event_update_userpage(event);
>>  }
>>  
>> +struct merge_sched_data {
>> +	int can_add_hw;
>> +	enum event_type_t event_type;
>> +};
>> +
>>  static int merge_sched_in(struct perf_event *event, void *data)
>>  {
>>  	struct perf_event_context *ctx = event->ctx;
>> -	int *can_add_hw = data;
>> +	struct merge_sched_data *msd = data;
>>  
>>  	if (event->state <= PERF_EVENT_STATE_OFF)
>>  		return 0;
>> @@ -3864,13 +3953,22 @@ static int merge_sched_in(struct perf_event *event, void *data)
>>  	if (!event_filter_match(event))
>>  		return 0;
>>  
>> -	if (group_can_go_on(event, *can_add_hw)) {
>> +	/*
>> +	 * Don't schedule in any exclude_guest events of PMU with
>> +	 * PERF_PMU_CAP_PASSTHROUGH_VPMU, while a guest is running.
>> +	 */
>> +	if (__this_cpu_read(perf_in_guest) && event->attr.exclude_guest &&
>> +	    event->pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU &&
>> +	    !(msd->event_type & EVENT_GUEST))
>> +		return 0;
>> +
>> +	if (group_can_go_on(event, msd->can_add_hw)) {
>>  		if (!group_sched_in(event, ctx))
>>  			list_add_tail(&event->active_list, get_event_list(event));
>>  	}
>>  
>>  	if (event->state == PERF_EVENT_STATE_INACTIVE) {
>> -		*can_add_hw = 0;
>> +		msd->can_add_hw = 0;
>>  		if (event->attr.pinned) {
>>  			perf_cgroup_event_disable(event, ctx);
>>  			perf_event_set_state(event, PERF_EVENT_STATE_ERROR);
>> @@ -3889,11 +3987,15 @@ static int merge_sched_in(struct perf_event *event, void *data)
>>  
>>  static void pmu_groups_sched_in(struct perf_event_context *ctx,
>>  				struct perf_event_groups *groups,
>> -				struct pmu *pmu)
>> +				struct pmu *pmu,
>> +				enum event_type_t event_type)
>>  {
>> -	int can_add_hw = 1;
>> +	struct merge_sched_data msd = {
>> +		.can_add_hw = 1,
>> +		.event_type = event_type,
>> +	};
>>  	visit_groups_merge(ctx, groups, smp_processor_id(), pmu,
>> -			   merge_sched_in, &can_add_hw);
>> +			   merge_sched_in, &msd);
>>  }
>>  
>>  static void ctx_groups_sched_in(struct perf_event_context *ctx,
>> @@ -3905,14 +4007,14 @@ static void ctx_groups_sched_in(struct perf_event_context *ctx,
>>  	list_for_each_entry(pmu_ctx, &ctx->pmu_ctx_list, pmu_ctx_entry) {
>>  		if (perf_skip_pmu_ctx(pmu_ctx, event_type))
>>  			continue;
>> -		pmu_groups_sched_in(ctx, groups, pmu_ctx->pmu);
>> +		pmu_groups_sched_in(ctx, groups, pmu_ctx->pmu, event_type);
>>  	}
>>  }
>>  
>>  static void __pmu_ctx_sched_in(struct perf_event_context *ctx,
>>  			       struct pmu *pmu)
>>  {
>> -	pmu_groups_sched_in(ctx, &ctx->flexible_groups, pmu);
>> +	pmu_groups_sched_in(ctx, &ctx->flexible_groups, pmu, 0);
>>  }
>>  
>>  static void
>> @@ -3927,9 +4029,11 @@ ctx_sched_in(struct perf_event_context *ctx, enum event_type_t event_type)
>>  		return;
>>  
>>  	if (!(is_active & EVENT_TIME)) {
>> +		/* EVENT_TIME should be active while the guest runs */
>> +		WARN_ON_ONCE(event_type & EVENT_GUEST);
>>  		/* start ctx time */
>>  		__update_context_time(ctx, false);
>> -		perf_cgroup_set_timestamp(cpuctx);
>> +		perf_cgroup_set_timestamp(cpuctx, false);
>>  		/*
>>  		 * CPU-release for the below ->is_active store,
>>  		 * see __load_acquire() in perf_event_time_now()
>> @@ -3945,7 +4049,23 @@ ctx_sched_in(struct perf_event_context *ctx, enum event_type_t event_type)
>>  			WARN_ON_ONCE(cpuctx->task_ctx != ctx);
>>  	}
>>  
>> -	is_active ^= ctx->is_active; /* changed bits */
>> +	if (event_type & EVENT_GUEST) {
>> +		/*
>> +		 * Schedule in all !exclude_guest events of PMU
>> +		 * with PERF_PMU_CAP_PASSTHROUGH_VPMU.
>> +		 */
>> +		is_active = EVENT_ALL;
>> +
>> +		/*
>> +		 * Update ctx time to set the new start time for
>> +		 * the exclude_guest events.
>> +		 */
>> +		update_context_time(ctx);
>> +		update_cgrp_time_from_cpuctx(cpuctx, false);
>> +		barrier();
>> +	} else {
>> +		is_active ^= ctx->is_active; /* changed bits */
>> +	}
>>  
>>  	/*
>>  	 * First go through the list and put on any pinned groups
> 

