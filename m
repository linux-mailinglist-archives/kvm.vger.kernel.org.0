Return-Path: <kvm+bounces-28744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CFA299C910
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 13:36:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6DD5BB2D512
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 11:22:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A852197A8A;
	Mon, 14 Oct 2024 11:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cGeGEIYc"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE3C1607AC;
	Mon, 14 Oct 2024 11:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728904852; cv=none; b=n6/RNATCSMgOx3AONF8tvxNhm+ZqEd05xAkn4rrMA6JTDN1dctDPffLgjaZjxnTqEAtOXIX14xVCqPJt+fvkrUXgHKHuF282uOqQRRZI3D8Z2/4kaKJ3s1hXG4Z01Dh9+Ei/IuhJSDDGNi81PoTvfxm3TChnZSFL3BPZITQtY2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728904852; c=relaxed/simple;
	bh=8j9yAqvValdDGueRPSaoEYlMs4p98lEYiz/SHCqYy94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cAcai+Ay7gcj3yoY2mqPjqzEglKyu2Pg1x32t+zCHjfxWP7z5IYpRME/2o1CF+iJ/ufxYaR3f0r1PlKacQk23r/CZSVI//zKyVcXvdMJ7ZnTpc800fqpO61RfCcHtHCXOqzGtuTRIOaTndIoHE+AhFLYWZ+EDfza2rHqF5f/D4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cGeGEIYc; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RXw3F76G2FKcop8fFxeWoHhU95yY/p8R5y+b8KjWbLg=; b=cGeGEIYcui7BNGX7nr8MMs46kU
	AGpA95yFou/pxyzhG3EM7yVhA8P25DregFp8fdb+99ToBfYJW+/fR/9tKuft8Q/8+V4IC8ieMhR7T
	vysV3zRZ/zp7NqsXUAmSFGKtdloMyXld1CuZ12eZjXfOaFFRdOFunRyGO0sv2NGCZUja2euuWcUNf
	9veuJaYzC+nWAzKXllPcEt9cy9mMNoHWhVcVxop9fNiGNbHU6IULD2irM9hoyu5U2UrXIRe6wUJts
	EXbUveORGj2MdOZp1pFw0+ZhmEQHZlklVAP3WcWvi4O0hJaVDlnWLJqVP9oEcDW9wRs0jKnFtVQpc
	/jE7NRAg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t0J7z-00000001TTs-0CPS;
	Mon, 14 Oct 2024 11:20:44 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 2F86A300ABE; Mon, 14 Oct 2024 13:20:43 +0200 (CEST)
Date: Mon, 14 Oct 2024 13:20:43 +0200
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
Subject: Re: [RFC PATCH v3 10/58] perf: Add generic exclude_guest support
Message-ID: <20241014112043.GD16066@noisy.programming.kicks-ass.net>
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-11-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240801045907.4010984-11-mizhang@google.com>

On Thu, Aug 01, 2024 at 04:58:19AM +0000, Mingwei Zhang wrote:
> +void perf_guest_exit(void)
> +{
> +	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
> +
> +	lockdep_assert_irqs_disabled();
> +
> +	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
> +
> +	if (WARN_ON_ONCE(!__this_cpu_read(perf_in_guest)))
> +		goto unlock;
> +
> +	perf_ctx_disable(&cpuctx->ctx, EVENT_GUEST);
> +	ctx_sched_in(&cpuctx->ctx, EVENT_GUEST);
> +	perf_ctx_enable(&cpuctx->ctx, EVENT_GUEST);
> +	if (cpuctx->task_ctx) {
> +		perf_ctx_disable(cpuctx->task_ctx, EVENT_GUEST);
> +		ctx_sched_in(cpuctx->task_ctx, EVENT_GUEST);
> +		perf_ctx_enable(cpuctx->task_ctx, EVENT_GUEST);
> +	}

Does this not violate the scheduling order of events? AFAICT this will
do:

  cpu pinned
  cpu flexible
  task pinned
  task flexible

as opposed to:

  cpu pinned
  task pinned
  cpu flexible
  task flexible

We have the perf_event_sched_in() helper for this.

> +
> +	__this_cpu_write(perf_in_guest, false);
> +unlock:
> +	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
> +}
> +EXPORT_SYMBOL_GPL(perf_guest_exit);

