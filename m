Return-Path: <kvm+bounces-28775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8138799D0CA
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 17:07:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4618B2832C1
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 15:07:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A7EA1AAE02;
	Mon, 14 Oct 2024 15:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U44RtaNT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16D03A1B6;
	Mon, 14 Oct 2024 15:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918433; cv=none; b=sgi971ZGHMAiBqTiaJIHJRLxYKIa+n8X8ZvM7hEc/kdSzCh7lpp65bibNW6V5JRFrqpJ7g4HJfjN3MNhnEMn7sHaFH6cAlfl7zj9cZaOkvlOJv7vkDm3e7W6ItWOH7tVKX1BD43rOiPZWz+LxbgnYjSeOn03N8/tGxCSckzbvIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918433; c=relaxed/simple;
	bh=EvSSFxRgPZuWgvBuv++rbbv2H2ZAidHTI94XEz0Es9Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FD5EOLrmivNOR5f6RrO1oeshejg/U3WgXXnHvx/WZDxj5Kw000rR8wR1Bhw6vcW+SEDFwG37u3WFzHN+RWaV63zNXPUC2HUjEtmaaG1O1My/3NyYnS9gzviM0Z+CqM7nTIvGOKKsPSkvaEOL8EjlH4kD46cLaYbud+CK83YrGCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U44RtaNT; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728918432; x=1760454432;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EvSSFxRgPZuWgvBuv++rbbv2H2ZAidHTI94XEz0Es9Q=;
  b=U44RtaNTo/1DZrokZxx1aEnLKlRHDCO3gR3yPgsNX8mANiIxrCWeCnbR
   YjmP9CMgFJhalgZUFFd+EKOTSqjup9vP665ojqIU9ZaCJfcUcbJbgOnXg
   key95rOloThSyfhoYQC6z0iB0zRJv3dkinC7txl0QK2ZHpPsz9XyP5SMo
   RS6YPI2mcQ0zJJya+DA9RtieTamnOlcgq/ux8yy538HHvMbowLUrxqYiZ
   DaAOWywbPu8DNpZckKto+NTnQPbVmjpljk9l0P/uvco62ZazRmD0EVrtB
   DaAzjUbTLHqUsRuHv4sgh/3Q/P6j0qyVyDmO/ZVkmA5augWEDeqhSYO54
   w==;
X-CSE-ConnectionGUID: Uvw+ui75TcSAo2sYMK8xmA==
X-CSE-MsgGUID: 7FyvE2zmSY6NmKz2qcOQbg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="31966381"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="31966381"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 08:06:05 -0700
X-CSE-ConnectionGUID: B+YGha7iSHaBF+VPCaOi5Q==
X-CSE-MsgGUID: 1687BWLQRrO/l45+jE/E7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,203,1725346800"; 
   d="scan'208";a="77781414"
Received: from linux.intel.com ([10.54.29.200])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 08:06:06 -0700
Received: from [10.212.61.73] (kliang2-mobl1.ccr.corp.intel.com [10.212.61.73])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by linux.intel.com (Postfix) with ESMTPS id C987220B5782;
	Mon, 14 Oct 2024 08:06:02 -0700 (PDT)
Message-ID: <4d63b685-6161-4dbe-990d-54c6dd352972@linux.intel.com>
Date: Mon, 14 Oct 2024 11:06:01 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 09/58] perf: Add a EVENT_GUEST flag
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
 Like Xu <like.xu.linux@gmail.com>,
 Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
 linux-perf-users@vger.kernel.org
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-10-mizhang@google.com>
 <20241014111416.GC16066@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: "Liang, Kan" <kan.liang@linux.intel.com>
In-Reply-To: <20241014111416.GC16066@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2024-10-14 7:14 a.m., Peter Zijlstra wrote:
> On Thu, Aug 01, 2024 at 04:58:18AM +0000, Mingwei Zhang wrote:
> 
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
> 
> I thought the premise was that if we have !exclude_guest events, we'll
> fail the creation of vPMU, and if we have vPMU we'll fail the creation
> of !exclude_guest events.
> 
> As such, they're mutually exclusive, and the above comment doesn't make
> sense, if we have a vPMU, there are no !exclude_guest events, IOW
> schedule out the entire context.

It's a typo. Right, it should schedule out all exclude_guest events of
the passthrough PMUs.

> 
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
> 
>> @@ -3864,13 +3953,22 @@ static int merge_sched_in(struct perf_event *event, void *data)
>>  	if (!event_filter_match(event))
>>  		return 0;
>>  
>> -	if (group_can_go_on(event, *can_add_hw)) {
>> +	/*
>> +	 * Don't schedule in any exclude_guest events of PMU with
>> +	 * PERF_PMU_CAP_PASSTHROUGH_VPMU, while a guest is running.
>> +	 */
> 
> More confusion; if we have vPMU there should not be !exclude_guest
> events, right? So the above then becomes 'Don't schedule in any events'.

Right. I will correct the three comments.

Thanks,
Kan

> 
>> +	if (__this_cpu_read(perf_in_guest) && event->attr.exclude_guest &&
>> +	    event->pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU &&
>> +	    !(msd->event_type & EVENT_GUEST))
>> +		return 0;
>> +
>> +	if (group_can_go_on(event, msd->can_add_hw)) {
>>  		if (!group_sched_in(event, ctx))
>>  			list_add_tail(&event->active_list, get_event_list(event));
> 
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
> 
> Idem.
> 
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
> 


