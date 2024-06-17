Return-Path: <kvm+bounces-19789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C73FD90B451
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 17:29:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E7051F27A6B
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2024 15:29:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1146137925;
	Mon, 17 Jun 2024 15:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MD4o4Y5B"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD8755888;
	Mon, 17 Jun 2024 15:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718636461; cv=none; b=iFCiMzN82Zig9d1ASSb8immBR/lyCj9BlBVkz5U7e1lHpLtcNGe2Y9WNna4vFDNr7B5fwnFeV4bETPKXvb2K29Br+Ltu4JRcfmiTSAqVnAxcwbut6x7DimQnzY8V8APgo50mNUH7eS5P5rp4y2jJHg/gLHUulVAXSNq70pZo8TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718636461; c=relaxed/simple;
	bh=kNhCpF9yy4ozI+EhT1JRqFNTV1nZBZe9zUnBYVOWTKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ppM6sFJIvdmATaSMV4lQxE3LD+e10iRXCAyhCDClp2QzfeOM47mOUyZZBmcnokpvbpO5NZuJTEvryfqwmMkKmVXbThmwMaGlSCs6qX7RyqsTx9Jr+pePj/DlE57iaJaEHSRIC/jUPBgAFa6oRmeXMkZDpIg0TS+F4u6XJtSv4nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MD4o4Y5B; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ob7EjVWS74YHIzO0+xs/iszj8jCcXUxw7ZhVkRSF93I=; b=MD4o4Y5BSNU0Xp6t440QmxGt2Q
	NdXHS2ibYHTvzEAkzK9x1hm6Cuh/5jGqpvKe2w2yO+LWvImKXyRLWkgVQSoS997pacOJ9qttRpU67
	l2mGnE/dVsAILaOmeuRkcmcvVyEeVTAyDvL3DunWbTVjHcvlg1oNOoQxu1UsCD5VCGoyqwvZXn6Ry
	dslJrdK6UbXNF9bza8KYgduB7zrdjQgsgPrI7AsfjM+axd1KKSYcCTUxYxGpYJvstVBpa5hnMSkj1
	LtLcDjqrPiaooftmnqSBWAob627cLkFTl49GRp9RJGNEXto0Y3B+FzVpy0xeEpTF0vY0kKZLtrY1h
	tJYHqYjw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJDqe-00000002Dyl-04tO;
	Mon, 17 Jun 2024 15:00:44 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E97AE30024D; Mon, 17 Jun 2024 17:00:38 +0200 (CEST)
Date: Mon, 17 Jun 2024 17:00:38 +0200
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
Message-ID: <20240617150038.GW8774@noisy.programming.kicks-ass.net>
References: <902c40cc-6e0b-4b2f-826c-457f533a0a76@linux.intel.com>
 <20240611120641.GF8774@noisy.programming.kicks-ass.net>
 <0a403a6c-8d55-42cb-a90c-c13e1458b45e@linux.intel.com>
 <20240612111732.GW40213@noisy.programming.kicks-ass.net>
 <e72c847f-a069-43e4-9e49-37c0bf9f0a8b@linux.intel.com>
 <20240613091507.GA17707@noisy.programming.kicks-ass.net>
 <3755c323-6244-4e75-9e79-679bd05b13a4@linux.intel.com>
 <f4da2fb2-fa09-4d2b-a78d-1b459ada6d09@linux.intel.com>
 <20240617075123.GX40213@noisy.programming.kicks-ass.net>
 <5fcf4471-bcf9-43af-93a0-dcc4fae27449@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5fcf4471-bcf9-43af-93a0-dcc4fae27449@linux.intel.com>

On Mon, Jun 17, 2024 at 09:34:15AM -0400, Liang, Kan wrote:
> 
> 
> On 2024-06-17 3:51 a.m., Peter Zijlstra wrote:
> > On Thu, Jun 13, 2024 at 02:04:36PM -0400, Liang, Kan wrote:
> >>>>  static enum event_type_t get_event_type(struct perf_event *event)
> >>>> @@ -3340,9 +3388,14 @@ ctx_sched_out(struct perf_event_context
> >>>>  	 * would only update time for the pinned events.
> >>>>  	 */
> >>>>  	if (is_active & EVENT_TIME) {
> >>>> +		bool stop;
> >>>> +
> >>>> +		stop = !((ctx->is_active & event_type) & EVENT_ALL) &&
> >>>> +		       ctx == &cpuctx->ctx;
> >>>> +			
> >>>>  		/* update (and stop) ctx time */
> >>>>  		update_context_time(ctx);
> >>>> -		update_cgrp_time_from_cpuctx(cpuctx, ctx == &cpuctx->ctx);
> >>>> +		update_cgrp_time_from_cpuctx(cpuctx, stop);
> >>
> >> For the event_type == EVENT_GUEST, the "stop" should always be the same
> >> as "ctx == &cpuctx->ctx". Because the ctx->is_active never set the
> >> EVENT_GUEST bit.
> >> Why the stop is introduced?
> > 
> > Because the ctx_sched_out() for vPMU should not stop time, 
> 
> But the implementation seems stop the time.
> 
> The ctx->is_active should be (EVENT_ALL | EVENT_TIME) for most of cases.
> 
> When a vPMU is scheduling in (invoke ctx_sched_out()), the event_type
> should only be EVENT_GUEST.
> 
> !((ctx->is_active & event_type) & EVENT_ALL) should be TRUE.

Hmm.. yeah, I think I might've gotten that wrong.

> > only the
> > 'normal' sched-out should stop time.
> 
> If the guest is the only case which we want to keep the time for, I
> think we may use a straightforward check as below.
> 
> 	stop = !(event_type & EVENT_GUEST) && ctx == &cpuctx->ctx;

So I think I was trying to get stop true when there weren't in fact
events on, that is when we got in without EVENT_ALL bits, but perhaps
that case isn't relevant.


