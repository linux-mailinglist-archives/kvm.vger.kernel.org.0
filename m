Return-Path: <kvm+bounces-28757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B37399C98E
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 13:57:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 267411F25512
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 11:57:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B88619F104;
	Mon, 14 Oct 2024 11:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UjtsQgHl"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC4D13CABC;
	Mon, 14 Oct 2024 11:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728907015; cv=none; b=H4R9CuuHkZO0lnbLOBV7CrQLvnmhXo4n+JrRRu+h001XIYRcERXWpKsSvK3+2+OV6R3Q9Cfi1Xom+QXpvIdIJthFfedfrAusspEYVW62fZvU7zvxdHldRKilJ+1dAdmm/P43Xy0XcpoYeh7KZPAodvgso/FGz0RUI2AcyUA4a0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728907015; c=relaxed/simple;
	bh=9Ksq7LUElDhRQjdwOCzpVRlPmoUVDEW11ZrZdaTIR0w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ONWV5Bh6SW5m4AoUERTBb+WgC9JEz7F2OclO6Q9ZT9kylPCglQwDiXaYUrCXkppVyKejiYdLseX4oVrB7Dh7cOYUSkrQNo1MU60rbdu4MuIyUtCcylauFGuSLC1B8bDro1g50tC0PvsrFr541Yn3VlaSpcRaqu3U+ox7jKSwubY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UjtsQgHl; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8o7W3qAJQ3PM1lIoyoylBRhUiYt3aSWDMgPD4wZKpSs=; b=UjtsQgHlk9US9/iSGnbAi95dhe
	IfQTTD53WitKn4wK2i57PLWjGu2u+uQ7ICX7g9YAvEwoJPo4PFfDp3KbXn9f0frItsjaPQVBb9IB8
	SaNhTp3MKFBGjTEhiC840VubgrVXlQ7nsr6svB9R9QFJGPXsaG7WmahA/3Z8h83bIPET+lOg3CQm1
	SAshMoWPO4azhJXiRRgqMqTIsnspV5aJRZn/5taGAux96UKyHbbIqnK+KKXnSBiToQo6OFr6khONS
	6VZ8tg9ZQ8CHfZh5BdCLjQTsMgMag2u/Enq3Yn4R8a47A92T2wQ/2dyFOpbp5QEfOpDi1xs6xEsos
	icNkmZhA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t0Jgo-00000001ZHZ-2NTT;
	Mon, 14 Oct 2024 11:56:43 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 87B2C300777; Mon, 14 Oct 2024 13:56:41 +0200 (CEST)
Date: Mon, 14 Oct 2024 13:56:41 +0200
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
Subject: Re: [RFC PATCH v3 14/58] perf: Add switch_interrupt() interface
Message-ID: <20241014115641.GE16066@noisy.programming.kicks-ass.net>
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-15-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240801045907.4010984-15-mizhang@google.com>

On Thu, Aug 01, 2024 at 04:58:23AM +0000, Mingwei Zhang wrote:

> @@ -5941,8 +5942,21 @@ void perf_put_mediated_pmu(void)
>  }
>  EXPORT_SYMBOL_GPL(perf_put_mediated_pmu);
>  
> +static void perf_switch_interrupt(bool enter, u32 guest_lvtpc)
> +{
> +	/* Mediated passthrough PMU should have PASSTHROUGH_VPMU cap. */
> +	if (!passthru_pmu)
> +		return;
> +
> +	if (passthru_pmu->switch_interrupt &&
> +	    try_module_get(passthru_pmu->module)) {
> +		passthru_pmu->switch_interrupt(enter, guest_lvtpc);
> +		module_put(passthru_pmu->module);
> +	}
> +}

Should we move the whole module reference to perf_pmu_(,un}register() ?

> @@ -11842,7 +11860,21 @@ int perf_pmu_register(struct pmu *pmu, const char *name, int type)
>  	if (!pmu->event_idx)
>  		pmu->event_idx = perf_event_idx_default;
>  
> -	list_add_rcu(&pmu->entry, &pmus);
> +	/*
> +	 * Initialize passthru_pmu with the core pmu that has
> +	 * PERF_PMU_CAP_PASSTHROUGH_VPMU capability.
> +	 */
> +	if (pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU) {
> +		if (!passthru_pmu)
> +			passthru_pmu = pmu;
> +
> +		if (WARN_ONCE(passthru_pmu != pmu, "Only one passthrough PMU is supported\n")) {
> +			ret = -EINVAL;
> +			goto free_dev;

Why impose this limit? Changelog also fails to explain this.

> +		}
> +	}
> +
> +	list_add_tail_rcu(&pmu->entry, &pmus);
>  	atomic_set(&pmu->exclusive_cnt, 0);
>  	ret = 0;
>  unlock:
> -- 
> 2.46.0.rc1.232.g9752f9e123-goog
> 

