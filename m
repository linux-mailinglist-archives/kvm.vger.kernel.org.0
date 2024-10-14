Return-Path: <kvm+bounces-28793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CC4F199D5CA
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 19:48:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 77AE81F23AEE
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 17:48:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D0DE1C728E;
	Mon, 14 Oct 2024 17:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oyVsJNdY"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1DF231C8A;
	Mon, 14 Oct 2024 17:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728928078; cv=none; b=IEh+XD+U8T2vIC/ZuAF2wgLJsa+QYqhK0Ctd7tAz/5fmKzlP0hPCsvoMUQjKZG6+Q6+9SAlr51AITcS4oPssBXi0xdPONTIld4ZGKvxqKPLcAMjvGvU57q1Qkdbg0iDPDvbH2nY8EO+7GHC6ioD/xV/ZvzskajZTocTHgJmumFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728928078; c=relaxed/simple;
	bh=1u52/m2la5/UTMg7PJdjLLz55atjhzgesQNOek4zY5E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PjnValI7sXUvCwr5X+PCe6J2GkzDnCnVh2qN8b6BwbfJpDlUBN1syZlr3Ix67ZD0xHhZkPJ2gdejD+/y8922FAlJ3G1115hEqwDoUvFri5HQdb58QsVByNt91BXh9owz18Tc03efPaxaC8NJJzQJF2pSKNQgVtDmoQ0dXoWA6Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oyVsJNdY; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rXWOwXW6KbbomHZgeT+isf5Wm6cIEI4y6NkJ6mtUALk=; b=oyVsJNdYAx7nISkp2eHo/xbggl
	yHy+9UUheUxhUYmXOUiARXPYMEE5eGZKsGtyxbnwYQmLa2elGEZOOtP2s91vvR3xpHFtjlkwT9y7j
	q2B+SendmM3nKJ2SkgUGpjryukfTjchs9KwXC2mp5hsHqXQBv+Dk/tAg2i8Y1uQZ8cVjSbwNqgdry
	5qqq4qEkH+E6UGwuAaosq7gAezuigOYxAJq+JaK/Eehz8JqLrL+XDP/pM4nMjZB0Re94qZAvEwr6l
	omphjm45mx28VcLFpWAHZvhZs0bDXnGICYYfSrllL3wPilOmR43VJAH1wkV+47GvCDOukPVoolOdC
	tdRs9zTw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t0PAd-00000006OWj-1CSG;
	Mon, 14 Oct 2024 17:47:51 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E56FF3004AF; Mon, 14 Oct 2024 19:47:50 +0200 (CEST)
Date: Mon, 14 Oct 2024 19:47:50 +0200
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
Message-ID: <20241014174750.GK16066@noisy.programming.kicks-ass.net>
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-15-mizhang@google.com>
 <20241014115641.GE16066@noisy.programming.kicks-ass.net>
 <3da8094d-0763-4b66-9ac1-71cd333b7747@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3da8094d-0763-4b66-9ac1-71cd333b7747@linux.intel.com>

On Mon, Oct 14, 2024 at 11:40:21AM -0400, Liang, Kan wrote:

> >> @@ -11842,7 +11860,21 @@ int perf_pmu_register(struct pmu *pmu, const char *name, int type)
> >>  	if (!pmu->event_idx)
> >>  		pmu->event_idx = perf_event_idx_default;
> >>  
> >> -	list_add_rcu(&pmu->entry, &pmus);
> >> +	/*
> >> +	 * Initialize passthru_pmu with the core pmu that has
> >> +	 * PERF_PMU_CAP_PASSTHROUGH_VPMU capability.
> >> +	 */
> >> +	if (pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU) {
> >> +		if (!passthru_pmu)
> >> +			passthru_pmu = pmu;
> >> +
> >> +		if (WARN_ONCE(passthru_pmu != pmu, "Only one passthrough PMU is supported\n")) {
> >> +			ret = -EINVAL;
> >> +			goto free_dev;
> > 
> > Why impose this limit? Changelog also fails to explain this.
> 
> Because the passthru_pmu is global variable. If there are two or more
> PMUs with the PERF_PMU_CAP_PASSTHROUGH_VPMU, the former one will be
> implicitly overwritten if without the check.

That is not the question; but is has been answered elsewhere. For some
reason you thought the srcu+list thing was expensive.


