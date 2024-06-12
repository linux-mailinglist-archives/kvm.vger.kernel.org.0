Return-Path: <kvm+bounces-19440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E93E3905138
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 13:18:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 82E40B21DC8
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 11:18:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D027146017;
	Wed, 12 Jun 2024 11:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YhY9+kli"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6026155A52;
	Wed, 12 Jun 2024 11:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718191073; cv=none; b=OcBPTP8Z8y3Ms95TFyd6Q4+hvI1KK+AtmiYmPMFR28jWZ0uvijSW7frBSU4xd5bvVKjB02z2PjxW1pKBKoQ1wX8xY6dRBM/qIzpg8XKoa4TEHJDXBcQ+D5/6I2BnqDsJwdfYKiniIWM+Au/RLnhV95inFcvKT2/6bhKx8okxfxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718191073; c=relaxed/simple;
	bh=atWMfvcTWLZ5DtT0n7itvM6WQJ3OO9YxzL1XB1BRvu0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eGDNloj5hcts3EWVPz7xNhMNDETsZBkdNXAaChgH6od90TGd3vxoHJEgj/T53MTLAqfZbPZGqkR8H5LDyhIbcUBvYyY89ehugLiDexVQwP1HSPa08X+RyCS/Njz0lI1j8c1MdZh6PKTqOzUtjRe9gnDnf4onWFWKuUO9OCjIh5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YhY9+kli; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UXqLhIdJHPKijVnOw4uOjchsFVWzb1RJKvU3WypYVrw=; b=YhY9+kliR4OXUwB13S795nh+p6
	FwyDgD5vebvwGqOeFF8zjuaEiK1xuL3nd90iCg45OGyid4Zm3R8+dG5RbFeqjyH3QVRyFww3ffaeY
	NtqeNsNd05lLB6gu4qQ5fQWOWgnqPmGsz0hNbBoWgG+0ESNCcoK8KKAPASe/X1gGEW2UEjVnu4Y8T
	OCym8b+SwJqF1g32O0dcSBHzk9jI/A9ZcFNZH6pTAULKYO/nEEmd7dBuUlpKdK8/o0Qd7zXP9ex1Y
	IlLeDG8tJJdAzLqpuHsCOMNqy7GuP8FfHipDQeOxWrjb0YwzZUTbGuTLno9Cq824S+aJddfqUtlPo
	pXgjp8Tg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sHLys-00000002q6s-0gGw;
	Wed, 12 Jun 2024 11:17:34 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id BA257300592; Wed, 12 Jun 2024 13:17:32 +0200 (CEST)
Date: Wed, 12 Jun 2024 13:17:32 +0200
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
Message-ID: <20240612111732.GW40213@noisy.programming.kicks-ass.net>
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-8-mizhang@google.com>
 <20240507085807.GS40213@noisy.programming.kicks-ass.net>
 <902c40cc-6e0b-4b2f-826c-457f533a0a76@linux.intel.com>
 <20240611120641.GF8774@noisy.programming.kicks-ass.net>
 <0a403a6c-8d55-42cb-a90c-c13e1458b45e@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a403a6c-8d55-42cb-a90c-c13e1458b45e@linux.intel.com>

On Tue, Jun 11, 2024 at 09:27:46AM -0400, Liang, Kan wrote:
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index dd4920bf3d1b..68c8b93c4e5c 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -945,6 +945,7 @@ struct perf_event_context {
>  	u64				time;
>  	u64				timestamp;
>  	u64				timeoffset;
> +	u64				timeguest;
> 
>  	/*
>  	 * These fields let us detect when two contexts have both

> @@ -651,10 +653,26 @@ __perf_update_times(struct perf_event *event, u64
> now, u64 *enabled, u64 *runnin
> 
>  static void perf_event_update_time(struct perf_event *event)
>  {
> -	u64 now = perf_event_time(event);
> +	u64 now;
> +
> +	/* Never count the time of an active guest into an exclude_guest event. */
> +	if (event->ctx->timeguest &&
> +	    event->pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU) {
> +		/*
> +		 * If a guest is running, use the timestamp while entering the guest.
> +		 * If the guest is leaving, reset the event timestamp.
> +		 */
> +		if (__this_cpu_read(perf_in_guest))
> +			event->tstamp = event->ctx->timeguest;
> +		else
> +			event->tstamp = event->ctx->time;
> +		return;
> +	}
> 
> +	now = perf_event_time(event);
>  	__perf_update_times(event, now, &event->total_time_enabled,
>  					&event->total_time_running);
> +
>  	event->tstamp = now;
>  }

So I really don't like this much, and AFAICT this is broken. At the very
least this doesn't work right for cgroup events, because they have their
own timeline.

Let me have a poke...

