Return-Path: <kvm+bounces-19312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F6B0903B88
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 14:08:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 103C81C23A8B
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 12:08:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D757F17BB32;
	Tue, 11 Jun 2024 12:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IgtOfu/E"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CB617BB05;
	Tue, 11 Jun 2024 12:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718107619; cv=none; b=Db1UBJDBX9+0rtpMPSPhf2BbJ3YGPy1R/vPr8LFJjgdQkQTG+Quubbw8aCECYUDt18R4mUwOL8GftbyhFaxt+yCuC9SBOKfzuG5jRzVUIIY9gUJfkCytFlx8Ry3k6ZAC2rj+71unNYhxThIFrQNr8wE28C2FLH9IjLOQumAk6Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718107619; c=relaxed/simple;
	bh=6LrN94wE5Ch4GZUFkDyGncBGli2yNQVHQBCmjAvHQRg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kXOI5lntuJFy6KENfPuUATT4wBsJdwiX5f5kuUbiAAka8Lu7KeTDzK4egBC3F1CSpxI5oLkZXyvOe/grjuyShiGjG0JH3cIu85aDKJ8Qop4E21F/xuuCTac6YPctPph1pTxeJMuxvxSHKSRItVvkYmbxlXifD8KztXfnKtwyDLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IgtOfu/E; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=H8K+4mfc6GBwXfg5dFM2GwN6ZgaMKddi6NCsobqz0F4=; b=IgtOfu/E74ezmKs66TEY8gvwNN
	KATQxqW2g7gIQNZxZGF/7zGnYTtQKrSYtpjix9LHJGgkWXp83P4W1oJuhLdV91sNdyKcl29X59cTZ
	uxG9ZOpGQVmKifSvYaT0jFqBqpfEkLIwIKYEvpyyVgsXB1zYZ2nED2KduT3cC2vf2XbDEEOp3b7iN
	8dDhiH7C1uq1U7GGqqEZXpKwRyV9B8P68MIcklOLc416hSAW0SXrpm8FpVd2yaws4eBH+oLRR3npd
	z0cbq7ykmgJ1/v/2VXsAu/KzNjHlXIwez8kFva5lL0KluusMeZO0eWzpSav5/0FIIY2k/Ww2Xkvxj
	XRRFAWlg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sH0Gs-000000028ym-2gHJ;
	Tue, 11 Jun 2024 12:06:42 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 3F655302792; Tue, 11 Jun 2024 14:06:41 +0200 (CEST)
Date: Tue, 11 Jun 2024 14:06:41 +0200
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
Message-ID: <20240611120641.GF8774@noisy.programming.kicks-ass.net>
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-8-mizhang@google.com>
 <20240507085807.GS40213@noisy.programming.kicks-ass.net>
 <902c40cc-6e0b-4b2f-826c-457f533a0a76@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <902c40cc-6e0b-4b2f-826c-457f533a0a76@linux.intel.com>

On Mon, Jun 10, 2024 at 01:23:04PM -0400, Liang, Kan wrote:
> On 2024-05-07 4:58 a.m., Peter Zijlstra wrote:

> > Bah, this is a ton of copy-paste from the normal scheduling code with
> > random changes. Why ?
> > 
> > Why can't this use ctx_sched_{in,out}() ? Surely the whole
> > CAP_PASSTHROUGHT thing is but a flag away.
> >
> 
> Not just a flag. The time has to be updated as well, since the ctx->time
> is shared among PMUs. Perf shouldn't stop it while other PMUs is still
> running.

Obviously the original changelog didn't mention any of that.... :/

> A timeguest will be introduced to track the start time of a guest.
> The event->tstamp of an exclude_guest event should always keep
> ctx->timeguest while a guest is running.
> When a guest is leaving, update the event->tstamp to now, so the guest
> time can be deducted.
> 
> The below patch demonstrate how the timeguest works.
> (It's an incomplete patch. Just to show the idea.)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 22d3e56682c9..2134e6886e22 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -953,6 +953,7 @@ struct perf_event_context {
>  	u64				time;
>  	u64				timestamp;
>  	u64				timeoffset;
> +	u64				timeguest;
> 
>  	/*
>  	 * These fields let us detect when two contexts have both
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 14fd881e3e1d..2aed56671a24 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -690,12 +690,31 @@ __perf_update_times(struct perf_event *event, u64
> now, u64 *enabled, u64 *runnin
>  		*running += delta;
>  }
> 
> +static void perf_event_update_time_guest(struct perf_event *event)
> +{
> +	/*
> +	 * If a guest is running, use the timestamp while entering the guest.
> +	 * If the guest is leaving, reset the event timestamp.
> +	 */
> +	if (!__this_cpu_read(perf_in_guest))
> +		event->tstamp = event->ctx->time;
> +	else
> +		event->tstamp = event->ctx->timeguest;
> +}

This conditional seems inverted, without a good reason. Also, in another
thread you talk about some PMUs stopping time in a guest, while other
PMUs would keep ticking. I don't think the above captures that.

>  static void perf_event_update_time(struct perf_event *event)
>  {
> -	u64 now = perf_event_time(event);
> +	u64 now;
> +
> +	/* Never count the time of an active guest into an exclude_guest event. */
> +	if (event->ctx->timeguest &&
> +	    event->pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU)
> +		return perf_event_update_time_guest(event);

Urgh, weird split. The PMU check is here. Please just inline the above
here, this seems to be the sole caller anyway.

> 
> +	now = perf_event_time(event);
>  	__perf_update_times(event, now, &event->total_time_enabled,
>  					&event->total_time_running);
> +
>  	event->tstamp = now;
>  }
> 
> @@ -3398,7 +3417,14 @@ ctx_sched_out(struct perf_event_context *ctx,
> enum event_type_t event_type)
>  			cpuctx->task_ctx = NULL;
>  	}
> 
> -	is_active ^= ctx->is_active; /* changed bits */
> +	if (event_type & EVENT_GUEST) {

Patch doesn't introduce EVENT_GUEST, lost a hunk somewhere?

> +		/*
> +		 * Schedule out all !exclude_guest events of PMU
> +		 * with PERF_PMU_CAP_PASSTHROUGH_VPMU.
> +		 */
> +		is_active = EVENT_ALL;
> +	} else
> +		is_active ^= ctx->is_active; /* changed bits */
> 
>  	list_for_each_entry(pmu_ctx, &ctx->pmu_ctx_list, pmu_ctx_entry) {
>  		if (perf_skip_pmu_ctx(pmu_ctx, event_type))

> @@ -5894,14 +5933,18 @@ void perf_guest_enter(u32 guest_lvtpc)
>  	}
> 
>  	perf_ctx_disable(&cpuctx->ctx, EVENT_GUEST);
> -	ctx_sched_out(&cpuctx->ctx, EVENT_ALL | EVENT_GUEST);
> +	ctx_sched_out(&cpuctx->ctx, EVENT_GUEST);
> +	/* Set the guest start time */
> +	cpuctx->ctx.timeguest = cpuctx->ctx.time;
>  	perf_ctx_enable(&cpuctx->ctx, EVENT_GUEST);
>  	if (cpuctx->task_ctx) {
>  		perf_ctx_disable(cpuctx->task_ctx, EVENT_GUEST);
> -		task_ctx_sched_out(cpuctx->task_ctx, EVENT_ALL | EVENT_GUEST);
> +		task_ctx_sched_out(cpuctx->task_ctx, EVENT_GUEST);
> +		cpuctx->task_ctx->timeguest = cpuctx->task_ctx->time;
>  		perf_ctx_enable(cpuctx->task_ctx, EVENT_GUEST);
>  	}
> 
>  	__this_cpu_write(perf_in_guest, true);
> @@ -5925,14 +5968,17 @@ void perf_guest_exit(void)
> 
>  	__this_cpu_write(perf_in_guest, false);
> 
>  	perf_ctx_disable(&cpuctx->ctx, EVENT_GUEST);
> -	ctx_sched_in(&cpuctx->ctx, EVENT_ALL | EVENT_GUEST);
> +	ctx_sched_in(&cpuctx->ctx, EVENT_GUEST);
> +	cpuctx->ctx.timeguest = 0;
>  	perf_ctx_enable(&cpuctx->ctx, EVENT_GUEST);
>  	if (cpuctx->task_ctx) {
>  		perf_ctx_disable(cpuctx->task_ctx, EVENT_GUEST);
> -		ctx_sched_in(cpuctx->task_ctx, EVENT_ALL | EVENT_GUEST);
> +		ctx_sched_in(cpuctx->task_ctx, EVENT_GUEST);
> +		cpuctx->task_ctx->timeguest = 0;
>  		perf_ctx_enable(cpuctx->task_ctx, EVENT_GUEST);
>  	}

I'm thinking EVENT_GUEST should cause the ->timeguest updates, no point
in having them explicitly duplicated here, hmm?

