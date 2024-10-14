Return-Path: <kvm+bounces-28763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD0CD99CBEA
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 15:53:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 163601C22E36
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 13:53:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E1841537AA;
	Mon, 14 Oct 2024 13:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Q6xwkgIV"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24D8E1AAE06;
	Mon, 14 Oct 2024 13:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728913973; cv=none; b=NiJfD9+cP4ToMH30g7e+yCPT2tcIRQnUrRlk5KngztsNkHAWC8hvhWfNNFW5Pw3hPJ0lNQF6rcJkSR7cHBzv0rJoBJM2p8asfx4ZntNhcAR4sGdDrGWjRIe0iYDvlLvHfwtWg+02ky2w6Z6VsXk9VMagRZalrDoHyMnUIl6vuf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728913973; c=relaxed/simple;
	bh=9pNZe4GPyWpnnPhc3Jjci3jDdC8/dvIgnWG7jPHDobc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k3bZ+Br2VprYuxzvC+/xNrsP568aYVwoQDj7+hjollIvDRsyuBP6U5b6tgljWsRzgSHZ03Bd6Snf5bPx5mp0Knu9OO96KJrgcDL6MZzbFsOkaGRUW0w0FeUlBiI8nYVrbUg0FVuBTnalE3pvKvWsf1pun5lvbT3qF19qiG0Z3yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Q6xwkgIV; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6Iwq8S1+u8FhnXBzbOyAszOo/tgTDYlXeMeiNKIKv9w=; b=Q6xwkgIVsZ3joboFPqym6ptyk0
	VaDoPpHug/sbpTfrtxY/01tIEBNhVusZdhWRi8cweWOZO1nHWnKIWzTV7Sfkq73dP0E4737MVg6aM
	hM/wE/tdvjFcP/2hslYdBiagoLEef5qPmZIdF3/MdzWm7va80mDDJVV1g4r58V3wASBQ6d2g56/dA
	17Cm3WpV8X8BG37rGnBRh2CX99ZruXFKUMIHpOG546E9S/niq21DnvHYvKfnVjqONZuDkRzutlKtl
	1/s6G6GIAzrBTH1RFTtPg/i1SXP84Iwj0/PtwZiJJb8Kei+iWPiL/pR3NE2jYZ6Tv+xxLDvlcw8uj
	uy63J7QQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t0LV5-00000006MB6-3jCO;
	Mon, 14 Oct 2024 13:52:44 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 158AA3004AF; Mon, 14 Oct 2024 15:52:43 +0200 (CEST)
Date: Mon, 14 Oct 2024 15:52:42 +0200
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
Message-ID: <20241014135242.GH16066@noisy.programming.kicks-ass.net>
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
> @@ -5962,6 +5976,8 @@ void perf_guest_enter(void)
>  		perf_ctx_enable(cpuctx->task_ctx, EVENT_GUEST);
>  	}
>  
> +	perf_switch_interrupt(true, guest_lvtpc);
> +
>  	__this_cpu_write(perf_in_guest, true);
>  
>  unlock:
> @@ -5980,6 +5996,8 @@ void perf_guest_exit(void)
>  	if (WARN_ON_ONCE(!__this_cpu_read(perf_in_guest)))
>  		goto unlock;
>  
> +	perf_switch_interrupt(false, 0);
> +
>  	perf_ctx_disable(&cpuctx->ctx, EVENT_GUEST);
>  	ctx_sched_in(&cpuctx->ctx, EVENT_GUEST);
>  	perf_ctx_enable(&cpuctx->ctx, EVENT_GUEST);

This seems to suggest the method is named wrong, it should probably be
guest_enter() or somsuch.

