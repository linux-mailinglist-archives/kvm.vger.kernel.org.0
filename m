Return-Path: <kvm+bounces-19758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 33BCD90A7B3
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 09:51:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD8FE1F24920
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 07:51:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14B0A18FDA6;
	Mon, 17 Jun 2024 07:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vQ85Xupg"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 733BD38396;
	Mon, 17 Jun 2024 07:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718610701; cv=none; b=e7HlzFe/Mef0mbyFcRPc7OIifp5zuq/QNujbQnCcaB2eD6VmaYFRossxlWDYKeUey5sXr6DdyuLK3Lzl7uzylC6G2f4OaPbmZQK1T9RxG+cW/DKu3eLH0WWKeEI3h4G1bY4Qx5Qwmc8CXHnk8aXCvVPqm3ntawnWBX+UBhyUHHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718610701; c=relaxed/simple;
	bh=NG8gvLsGeGERZcnN9LKe5/vwkRczxp/GUoWZxf+l7ME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rAZJ6JELNk8GN51oOq8oB6q80zl6cQPL6dnsiUiykM7mHvXF85ijWQu3m5KP8CuFSx/xjHGFhjj8cEX0nfv9avtTOYEDqRd8+fO0tLOD0c9HFte8mpfupxVcEiXkFdtGklLzJg2eA2CA/L9I0Ks4uDuyUouGpJoGOEvJDucqwIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vQ85Xupg; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IAmKegLYI+0e826keswLRf8FGni5PR5ZQKaV8HRzyrU=; b=vQ85Xupglat8LtsLeL3JFW9akS
	FbnIJABe9IR7/BZY3pzSg0IESab/IIpQvTUyjwOsi1nWVgMiBHw6aNkbEt/vDNWV5KzQ61PQPUiBz
	CJxQ9zujfWM2bEPI3ubIS+lFg2ypvCdr5KfcuaBEEqarM5huIcxWVPm5JWNoa6wvBGXqeOpgwnBvk
	b4Z+jJMzAvU78zgIxbG5jVonU3bo/lAL9OmfRm6bbU2SwrIy6be6a2+1j//ZO1N88I0ThlNrdvx1p
	ZM+B3fWx0sSlmuHpCv4Upz6kM4ohLlbZMSpYuPYp24ZdUis+SJwczJYp9logGtSxUpmQpWKiW7D+5
	g8T42pkg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJ799-00000001v2O-3R7x;
	Mon, 17 Jun 2024 07:51:25 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 332EB30088D; Mon, 17 Jun 2024 09:51:23 +0200 (CEST)
Date: Mon, 17 Jun 2024 09:51:23 +0200
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
Message-ID: <20240617075123.GX40213@noisy.programming.kicks-ass.net>
References: <20240506053020.3911940-8-mizhang@google.com>
 <20240507085807.GS40213@noisy.programming.kicks-ass.net>
 <902c40cc-6e0b-4b2f-826c-457f533a0a76@linux.intel.com>
 <20240611120641.GF8774@noisy.programming.kicks-ass.net>
 <0a403a6c-8d55-42cb-a90c-c13e1458b45e@linux.intel.com>
 <20240612111732.GW40213@noisy.programming.kicks-ass.net>
 <e72c847f-a069-43e4-9e49-37c0bf9f0a8b@linux.intel.com>
 <20240613091507.GA17707@noisy.programming.kicks-ass.net>
 <3755c323-6244-4e75-9e79-679bd05b13a4@linux.intel.com>
 <f4da2fb2-fa09-4d2b-a78d-1b459ada6d09@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4da2fb2-fa09-4d2b-a78d-1b459ada6d09@linux.intel.com>

On Thu, Jun 13, 2024 at 02:04:36PM -0400, Liang, Kan wrote:
> >>  static enum event_type_t get_event_type(struct perf_event *event)
> >> @@ -3340,9 +3388,14 @@ ctx_sched_out(struct perf_event_context
> >>  	 * would only update time for the pinned events.
> >>  	 */
> >>  	if (is_active & EVENT_TIME) {
> >> +		bool stop;
> >> +
> >> +		stop = !((ctx->is_active & event_type) & EVENT_ALL) &&
> >> +		       ctx == &cpuctx->ctx;
> >> +			
> >>  		/* update (and stop) ctx time */
> >>  		update_context_time(ctx);
> >> -		update_cgrp_time_from_cpuctx(cpuctx, ctx == &cpuctx->ctx);
> >> +		update_cgrp_time_from_cpuctx(cpuctx, stop);
> 
> For the event_type == EVENT_GUEST, the "stop" should always be the same
> as "ctx == &cpuctx->ctx". Because the ctx->is_active never set the
> EVENT_GUEST bit.
> Why the stop is introduced?

Because the ctx_sched_out() for vPMU should not stop time, only the
'normal' sched-out should stop time.


> >> @@ -3949,6 +4015,8 @@ ctx_sched_in(struct perf_event_context *
> >>  		return;
> >>  
> >>  	if (!(is_active & EVENT_TIME)) {
> >> +		/* EVENT_TIME should be active while the guest runs */
> >> +		WARN_ON_ONCE(event_type & EVENT_GUEST);
> >>  		/* start ctx time */
> >>  		__update_context_time(ctx, false);
> >>  		perf_cgroup_set_timestamp(cpuctx);
> >> @@ -3979,8 +4047,11 @@ ctx_sched_in(struct perf_event_context *
> >>  		 * the exclude_guest events.
> >>  		 */
> >>  		update_context_time(ctx);
> >> -	} else
> >> +		update_cgrp_time_from_cpuctx(cpuctx, false);
> 
> 
> In the above ctx_sched_out(), the cgrp_time is stopped and the cgrp has
> been set to inactive.
> I think we need a perf_cgroup_set_timestamp(cpuctx) here to restart the
> cgrp_time, Right?

So the idea was to not stop time when we schedule out for the vPMU, as
per the above.

> Also, I think the cgrp_time is different from the normal ctx->time. When
> a guest is running, there must be no cgroup. It's OK to disable the
> cgrp_time. If so, I don't think we need to track the guest_time for the
> cgrp.

Uh, the vCPU thread is/can-be part of a cgroup, and different guests
part of different cgroups. The CPU wide 'guest' time is all time spend
in guets, but the cgroup view of things might differ, depending on how
the guets are arranged in cgroups, no?

As such, we need per cgroup guest tracking.


