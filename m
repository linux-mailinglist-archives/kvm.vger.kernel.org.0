Return-Path: <kvm+bounces-28794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E416699D5D0
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 19:49:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8222AB22331
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 17:49:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 977F11C728F;
	Mon, 14 Oct 2024 17:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aHNcDFZ1"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0215F231C8A;
	Mon, 14 Oct 2024 17:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728928181; cv=none; b=mpMxpA3PaFmOlgkENSkBvd2CTDUCrk8rNycd5ZwQmn9+Ecf3TGLPo9OnCzc0i6JY6zbCkD3wPoDcSrsudn3gTYgJ2rsRYU/ZV0cqc4QMLQxA1/S1hnh0CIOeGbGyhKqiTO9i5wvBEg0XcTpiwnJF1Pusu9/8i5RofnYkvNwuPEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728928181; c=relaxed/simple;
	bh=tIWb28lPNpgVE6+quF3B+zMcV1b3JJiOigP0L5kg0Sc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rd9SQvus4IxTGItrAgGWEnzpv+wBhE1rxoJ1uUKeCFaQpqB8L3s9Pt8cwlVVxQFoN6eJxP5SXxZ5bhi3YoVIjmDQ+ASI/fs3quRZ4rH7saTstfPvyRyWcw/Qe2oQOpVdMclDR/pX8MCqmrGwJqRaRVzWtwOiNS4GOu1shQlKHD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aHNcDFZ1; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vMS8ywr8a0TU/9isRX8aw6baNcb0N+HzLlHTLMTIWuI=; b=aHNcDFZ1rT/3vM8HWPJ9BcqNFL
	Uk7pYbMlWlw4Rv0QxSddUrXYevVaXRyorJlqS51okS510PvCzyS5/GNq0FFv7fl6wN6cK2erxtniZ
	Uq88p9CZs8L7Rul/lJOCRt+yaI+efq43B+fIQDmMA7yVN0IYunvP3uJ9aFFIiX+vsUll2HlE/ZHUu
	3RkXkVa/NYbv0mMAbeyM+oA5d7oiFGTXyhiJQHVk7g23W5hJ2ef2X9KPtgTqzNBHdzfG0TleaArkO
	jXDHtzGCfYo64RqWWnq+S+O9VJ2t7OrvXA5IlXkMrNlg7eHmMXvTROrx17El1fIppnfa9zOjuPCJs
	a+74z9gA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t0PCD-00000002MFz-35du;
	Mon, 14 Oct 2024 17:49:30 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 89DD53004AF; Mon, 14 Oct 2024 19:49:29 +0200 (CEST)
Date: Mon, 14 Oct 2024 19:49:29 +0200
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
	Like Xu <like.xu.linux@gmail.com>,
	Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [RFC PATCH v3 14/58] perf: Add switch_interrupt() interface
Message-ID: <20241014174929.GL16066@noisy.programming.kicks-ass.net>
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-15-mizhang@google.com>
 <20241014120354.GG16066@noisy.programming.kicks-ass.net>
 <3cc05609-4fbd-4fb8-87bf-34ea1092ab2b@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3cc05609-4fbd-4fb8-87bf-34ea1092ab2b@linux.intel.com>

On Mon, Oct 14, 2024 at 11:51:06AM -0400, Liang, Kan wrote:
> On 2024-10-14 8:03 a.m., Peter Zijlstra wrote:
> > On Thu, Aug 01, 2024 at 04:58:23AM +0000, Mingwei Zhang wrote:
> >> From: Kan Liang <kan.liang@linux.intel.com>
> >>
> >> There will be a dedicated interrupt vector for guests on some platforms,
> >> e.g., Intel. Add an interface to switch the interrupt vector while
> >> entering/exiting a guest.
> >>
> >> When PMI switch into a new guest vector, guest_lvtpc value need to be
> >> reflected onto HW, e,g., guest clear PMI mask bit, the HW PMI mask
> >> bit should be cleared also, then PMI can be generated continuously
> >> for guest. So guest_lvtpc parameter is added into perf_guest_enter()
> >> and switch_interrupt().
> >>
> >> At switch_interrupt(), the target pmu with PASSTHROUGH cap should
> >> be found. Since only one passthrough pmu is supported, we keep the
> >> implementation simply by tracking the pmu as a global variable.
> >>
> >> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
> >>
> >> [Simplify the commit with removal of srcu lock/unlock since only one pmu is
> >> supported.]
> >>
> >> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> >> ---
> >>  include/linux/perf_event.h |  9 +++++++--
> >>  kernel/events/core.c       | 36 ++++++++++++++++++++++++++++++++++--
> >>  2 files changed, 41 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> >> index 75773f9890cc..aeb08f78f539 100644
> >> --- a/include/linux/perf_event.h
> >> +++ b/include/linux/perf_event.h
> >> @@ -541,6 +541,11 @@ struct pmu {
> >>  	 * Check period value for PERF_EVENT_IOC_PERIOD ioctl.
> >>  	 */
> >>  	int (*check_period)		(struct perf_event *event, u64 value); /* optional */
> >> +
> >> +	/*
> >> +	 * Switch the interrupt vectors, e.g., guest enter/exit.
> >> +	 */
> >> +	void (*switch_interrupt)	(bool enter, u32 guest_lvtpc); /* optional */
> >>  };
> > 
> > I'm thinking the guets_lvtpc argument shouldn't be part of the
> > interface. That should be PMU implementation data and accessed by the
> > method implementation.
> 
> I think the name of the perf_switch_interrupt() is too specific.
> Here should be to switch the guest context. The interrupt should be just
> part of the context. Maybe a interface as below
> 
> void (*switch_guest_ctx)	(bool enter, void *data); /* optional */

I don't think you even need the data thing. For example, the x86/intel
implementation can just look at a x86_pmu data field to find the magic
value.

