Return-Path: <kvm+bounces-28743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 14D6799C888
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 13:18:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 379B11C23098
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 11:18:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6C7A1A3A8D;
	Mon, 14 Oct 2024 11:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KUL80hsD"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CB219E80F;
	Mon, 14 Oct 2024 11:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728904469; cv=none; b=EuBdUibqINVmJOCT8+n9KZxrIQUUFLf5XbYB10Z0UsbHHw1lgeswXsXz4NF9gHhSWJOMHqRD1ominKvQBEFnNUOj6xlKLpHv+Da09huGUXwk7d/K4dwJSm/DNWyYwbl2PBhs3B4J6lS7pqhcwWzTKbgFpjjWuZC+dbtHnvg1tH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728904469; c=relaxed/simple;
	bh=dIavG+4Pxv2Jc8Mrm2Z/DI/IfOUhpTvf7o6Hp5PykM8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hNwEwjErdKkJrrTggrY0w/GVy+zNRMWy3LkLsKWdf+6NSiJqbuY9A9wEV92MgSoRVYOG3GUrpqsmF/X2NTJDC/Cr4Y8eMsmUI7Ev5TzAVqGQPElBVwfswJyY/tsokWKV2Hsz0tAIpmIeF5C9gB6UK1ngEb1Cke5z3j6iWdLRhsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KUL80hsD; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fE8nj1xF3U26vFxVB9FjXH6EC5VEQmlmeZGSI1Y+p3E=; b=KUL80hsDg6WwajHeV5kkx47Zct
	VJYWQhyCizYthQ3p8mot1xaTfFNlmWY9DkMzKI8CkJokKt5AWF62KUWLKvYw3lKCeXVFxqH+hQgP5
	FJIxB0GNWLbPhCBDazho3XaC37s3tqQESBWYu597SamrizVXAVaBN3H5vIAqpUeHUpWhZfWY8dHd+
	6BYiA3kFGb0LHaJafJcemQUCsKYHV6U1AGk1HK6ffu12jAaM8IHtlzORrUlRdK6tNl0cywaWjWlYc
	mrF/gpxNq59APuFXZcNl1ep9DmBY8+iwXjVDfVkiyJXMw5ExmaCX+T9BZ3cKBQ6OyK2/+lTj0+PGf
	Fk1vOaRQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t0J1l-00000006JtA-0A7P;
	Mon, 14 Oct 2024 11:14:18 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id A7E7C300777; Mon, 14 Oct 2024 13:14:16 +0200 (CEST)
Date: Mon, 14 Oct 2024 13:14:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mingwei Zhang <mizhang@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
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
	Like Xu <like.xu.linux@gmail.com>,
	Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [RFC PATCH v3 09/58] perf: Add a EVENT_GUEST flag
Message-ID: <20241014111416.GC16066@noisy.programming.kicks-ass.net>
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-10-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240801045907.4010984-10-mizhang@google.com>

On Thu, Aug 01, 2024 at 04:58:18AM +0000, Mingwei Zhang wrote:

> @@ -3334,9 +3401,15 @@ ctx_sched_out(struct perf_event_context *ctx, enum event_type_t event_type)
>  	 * would only update time for the pinned events.
>  	 */
>  	if (is_active & EVENT_TIME) {
> +		bool stop;
> +
> +		/* vPMU should not stop time */
> +		stop = !(event_type & EVENT_GUEST) &&
> +		       ctx == &cpuctx->ctx;
> +
>  		/* update (and stop) ctx time */
>  		update_context_time(ctx);
> -		update_cgrp_time_from_cpuctx(cpuctx, ctx == &cpuctx->ctx);
> +		update_cgrp_time_from_cpuctx(cpuctx, stop);
>  		/*
>  		 * CPU-release for the below ->is_active store,
>  		 * see __load_acquire() in perf_event_time_now()
> @@ -3354,7 +3427,18 @@ ctx_sched_out(struct perf_event_context *ctx, enum event_type_t event_type)
>  			cpuctx->task_ctx = NULL;
>  	}
>  
> -	is_active ^= ctx->is_active; /* changed bits */
> +	if (event_type & EVENT_GUEST) {
> +		/*
> +		 * Schedule out all !exclude_guest events of PMU
> +		 * with PERF_PMU_CAP_PASSTHROUGH_VPMU.
> +		 */

I thought the premise was that if we have !exclude_guest events, we'll
fail the creation of vPMU, and if we have vPMU we'll fail the creation
of !exclude_guest events.

As such, they're mutually exclusive, and the above comment doesn't make
sense, if we have a vPMU, there are no !exclude_guest events, IOW
schedule out the entire context.

> +		is_active = EVENT_ALL;
> +		__update_context_guest_time(ctx, false);
> +		perf_cgroup_set_timestamp(cpuctx, true);
> +		barrier();
> +	} else {
> +		is_active ^= ctx->is_active; /* changed bits */
> +	}
>  
>  	list_for_each_entry(pmu_ctx, &ctx->pmu_ctx_list, pmu_ctx_entry) {
>  		if (perf_skip_pmu_ctx(pmu_ctx, event_type))

> @@ -3864,13 +3953,22 @@ static int merge_sched_in(struct perf_event *event, void *data)
>  	if (!event_filter_match(event))
>  		return 0;
>  
> -	if (group_can_go_on(event, *can_add_hw)) {
> +	/*
> +	 * Don't schedule in any exclude_guest events of PMU with
> +	 * PERF_PMU_CAP_PASSTHROUGH_VPMU, while a guest is running.
> +	 */

More confusion; if we have vPMU there should not be !exclude_guest
events, right? So the above then becomes 'Don't schedule in any events'.

> +	if (__this_cpu_read(perf_in_guest) && event->attr.exclude_guest &&
> +	    event->pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU &&
> +	    !(msd->event_type & EVENT_GUEST))
> +		return 0;
> +
> +	if (group_can_go_on(event, msd->can_add_hw)) {
>  		if (!group_sched_in(event, ctx))
>  			list_add_tail(&event->active_list, get_event_list(event));

> @@ -3945,7 +4049,23 @@ ctx_sched_in(struct perf_event_context *ctx, enum event_type_t event_type)
>  			WARN_ON_ONCE(cpuctx->task_ctx != ctx);
>  	}
>  
> -	is_active ^= ctx->is_active; /* changed bits */
> +	if (event_type & EVENT_GUEST) {
> +		/*
> +		 * Schedule in all !exclude_guest events of PMU
> +		 * with PERF_PMU_CAP_PASSTHROUGH_VPMU.
> +		 */

Idem.

> +		is_active = EVENT_ALL;
> +
> +		/*
> +		 * Update ctx time to set the new start time for
> +		 * the exclude_guest events.
> +		 */
> +		update_context_time(ctx);
> +		update_cgrp_time_from_cpuctx(cpuctx, false);
> +		barrier();
> +	} else {
> +		is_active ^= ctx->is_active; /* changed bits */
> +	}

