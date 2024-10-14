Return-Path: <kvm+bounces-28796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E44D99D5D7
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 19:51:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6056D1C23049
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 17:51:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BDF21C75F9;
	Mon, 14 Oct 2024 17:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OLSJd7lo"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367F11B85C0;
	Mon, 14 Oct 2024 17:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728928279; cv=none; b=JalKIx5sM9pMEj+Pp7YpwB+3/8zO82Ht+bsKROpgbg020B90T+A+pZKUT+6c1dzo/gJ1s99rzHJyIREQx0TLqM0Q06GcM79Mhm8u0NihXlykbuETdEUOQb7fMMBXsUajRLGUkylqMYNotmQ3zek71GKZkGz72+nhbKu/MiYc5Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728928279; c=relaxed/simple;
	bh=R0KQ0Ll3kqDPc1WDZpPba2V71+JJYw6UBE4LyIDLqqY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i9ba61br6UJjw42yZfwgCsy3QzPF/fzmjAM1IOg34XAZYFbDjN3e9jrXpoQV5+WaN6rawCLXFQ17eBRhrQ1z55lt4aoKtVJD/mRsVZ+nXg/bpbpy3/OcXmG91rKHsazfJaJJqMt7DoZN5tmldFNzIohtRshXXPa+Hc1xGCrUTEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OLSJd7lo; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qEuhsEPyoNPD4STMxrNg6EcgQIJDgYWvsm8zFMyMqog=; b=OLSJd7loA+8oK4oI9gVIwf6T1K
	geqlc8OlolDytI/X+ncD0EGIYDaav09STDhpoSdFN4HRvdSyzw791TPwFdGaCTuGBqe1QcG2Juj3x
	5/x9EAYkZ1zAguZinfRVdU62WptU0zrAnZRdn6Dyp+Fp7IKa3kVkODlWyN997SFevsG+xu+Z2mfrf
	mDeWrm38vB/8LcFEZuV7WZGZw8FNzH1hgzzpzoERD/Q2gi+6CXqdaCXICxePPzpM3RiiEp2WPJUXy
	RVIF+ScCMPNhzpvlnIebtTbELKD3+HALzoVNOzQZ8/YgbOQs5aqWHbxQ1571F9hn1l8o/wgZksEfr
	IG/tLxvA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t0PDr-00000006OYI-3E05;
	Mon, 14 Oct 2024 17:51:11 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 655F53004AF; Mon, 14 Oct 2024 19:51:11 +0200 (CEST)
Date: Mon, 14 Oct 2024 19:51:11 +0200
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
Message-ID: <20241014175111.GM16066@noisy.programming.kicks-ass.net>
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
> 
> 
> On 2024-10-14 7:56 a.m., Peter Zijlstra wrote:
> > On Thu, Aug 01, 2024 at 04:58:23AM +0000, Mingwei Zhang wrote:
> > 
> >> @@ -5941,8 +5942,21 @@ void perf_put_mediated_pmu(void)
> >>  }
> >>  EXPORT_SYMBOL_GPL(perf_put_mediated_pmu);
> >>  
> >> +static void perf_switch_interrupt(bool enter, u32 guest_lvtpc)
> >> +{
> >> +	/* Mediated passthrough PMU should have PASSTHROUGH_VPMU cap. */
> >> +	if (!passthru_pmu)
> >> +		return;
> >> +
> >> +	if (passthru_pmu->switch_interrupt &&
> >> +	    try_module_get(passthru_pmu->module)) {
> >> +		passthru_pmu->switch_interrupt(enter, guest_lvtpc);
> >> +		module_put(passthru_pmu->module);
> >> +	}
> >> +}
> > 
> > Should we move the whole module reference to perf_pmu_(,un}register() ?
> 
> A PMU module can be load/unload anytime. How should we know if the PMU
> module is available when the reference check is moved to
> perf_pmu_(,un}register()?

Feh, dunno. I never really use modules. I just think the above is naf --
doubly so because you're saying the SRCU smp_mb() are expensive; but
this module reference crap is more expensive than that.

(IOW, the SRCU smp_mb() cannot have been the problem)

