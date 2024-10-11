Return-Path: <kvm+bounces-28610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBA1399A294
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 13:19:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 39207B21092
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 11:19:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAF8921502F;
	Fri, 11 Oct 2024 11:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vok1ydJj"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D663E804;
	Fri, 11 Oct 2024 11:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728645541; cv=none; b=IW0utCpgIHgOhhj2yZyzQhN5aHnC8PNv7FO7iFSx9/8MLu0ZZHAik/tbDIQLgveZLzCQAoE6P2fjRdvPwf6gKnxLKpf40uLGujyFiF/Wtycze48UdAK0LQOnnzwNVFGo1SbqCA6wyv9No9qe74D59WQisYvD1FpFoO6aw6r/Gb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728645541; c=relaxed/simple;
	bh=l/ebEG8kD/gjaGhc9sDTvLQS00rUq5c+N3DFQlZBEzM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KCg8eCCOt1AsUgUq+Av/HR3hfOYOmOKYFTwYMTGfMyHEVu4IEnvwLLdXxFcGii2BFMsFajv1kx6zQrvMm6y84Gl57HBPeIqC7ZPXE0nBFNZrQKR0PsjdB3C/5rXN5h0TYWmsybWstQlY3ASYGgGY1/Je/vCe7eVowXfTkuEnqeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vok1ydJj; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JmzYZueYdB1IqVFlxSAinoEZfpgluWHovncGAWktWlU=; b=vok1ydJjbOKAUOWv5qDBpnZuN/
	n+fSJPCvif/g62RipbMzFvKVO1Sm1BtHEwYwExJqsHpzXzUlAjhzDlCL6iHuAoap1UVrefrlzSm4u
	GPa3to4Qrwb8iUApEGN3suRquVGlHz5+SQzevP2oB08acHpw+N9EX+lpibwLJVK474W6KLvNwOLYA
	8sb6Zvfs8SKs5RnLb5+g5Z/n3MGr7Ze3JMZC4GnmNfHre/xr6J2M3G0h1XKjwidhXQetXPsC2aTFi
	8LfVeCYqZdXRxFvjh4tGy3mbjWKSRWkPYEwWQkgaZlsoXZgPgOHgvhv2LVKpnIKPwTTueMBureBRy
	Lb9foEyg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1szDfV-0000000AbXI-2lYb;
	Fri, 11 Oct 2024 11:18:51 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id C8330300642; Fri, 11 Oct 2024 13:18:49 +0200 (CEST)
Date: Fri, 11 Oct 2024 13:18:49 +0200
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
Subject: Re: [RFC PATCH v3 07/58] perf: Skip pmu_ctx based on event_type
Message-ID: <20241011111849.GM14587@noisy.programming.kicks-ass.net>
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-8-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240801045907.4010984-8-mizhang@google.com>

On Thu, Aug 01, 2024 at 04:58:16AM +0000, Mingwei Zhang wrote:
> @@ -3299,9 +3309,6 @@ ctx_sched_out(struct perf_event_context *ctx, enum event_type_t event_type)
>  	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
>  	struct perf_event_pmu_context *pmu_ctx;
>  	int is_active = ctx->is_active;
> -	bool cgroup = event_type & EVENT_CGROUP;
> -
> -	event_type &= ~EVENT_CGROUP;
>  
>  	lockdep_assert_held(&ctx->lock);
>  
> @@ -3336,7 +3343,7 @@ ctx_sched_out(struct perf_event_context *ctx, enum event_type_t event_type)
>  		barrier();
>  	}
>  
> -	ctx->is_active &= ~event_type;
> +	ctx->is_active &= ~(event_type & ~EVENT_FLAGS);
>  	if (!(ctx->is_active & EVENT_ALL))
>  		ctx->is_active = 0;
>  

> @@ -3912,9 +3919,6 @@ ctx_sched_in(struct perf_event_context *ctx, enum event_type_t event_type)
>  {
>  	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
>  	int is_active = ctx->is_active;
> -	bool cgroup = event_type & EVENT_CGROUP;
> -
> -	event_type &= ~EVENT_CGROUP;
>  
>  	lockdep_assert_held(&ctx->lock);
>  
> @@ -3932,7 +3936,7 @@ ctx_sched_in(struct perf_event_context *ctx, enum event_type_t event_type)
>  		barrier();
>  	}
>  
> -	ctx->is_active |= (event_type | EVENT_TIME);
> +	ctx->is_active |= ((event_type & ~EVENT_FLAGS) | EVENT_TIME);
>  	if (ctx->task) {
>  		if (!is_active)
>  			cpuctx->task_ctx = ctx;

Would it make sense to do something like:

	enum event_type_t active_type = event_type & ~EVENT_FLAGS;

	ctx->is_active &= ~active_type;
and
	ctx->is_active |= (active_type | EVENT_TIME);

Or something along those lines; those expressions become a little
unwieldy otherwise.

