Return-Path: <kvm+bounces-28759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DF7499C9A3
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 14:04:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 37B561F22D0F
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 12:04:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2114619F420;
	Mon, 14 Oct 2024 12:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CqOdBEmj"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC75213D291;
	Mon, 14 Oct 2024 12:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728907444; cv=none; b=OQvrJTZMhPAw0htT0stFIGJwlhgLYHzYaRc34Iaqx8a1xxQWce+/4x17lmKaEPchpqfQ5HGonh0I74gCVyb2DCGHLmrlpK0C1ozTUgKaiVVJ/1goNhymR6h6NkqjgUwF5Gcv7/5qk5FuWM/uINSJBtqr6PQ50zU3wyOrXvO1CsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728907444; c=relaxed/simple;
	bh=BucjGK7oOEpDZYZTP6xNMRvvAQrIVwfxLXGkiBtGLKk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U+mmIt8z7eZfEjtjHqOibxsAyonhpX82L/OGJ1WrYBMZRn4Ri+c0+lfDXhpJlQcNUXIXOuPyIPdyvqTbEXLPyoIuQrpWNTCAN+p2vjlmoZjGwvCAU4E1rvpi+QVgaywQj/gGE4RQ21Hfoh/5nxJpPOLcdXDNHt4cfwJV1RbxijU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CqOdBEmj; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=H/FvNT+b/oyNoZDsGFKQR9pfKzER8p8KcUzpunAgWC0=; b=CqOdBEmjhozM0Y7svPN9LLifAJ
	Jv/wJik0o4VOG5Vni6R/ExQ8cyfjlFqz6qDGj00CeJ7bciK3jCVvK5WP5ERI4i69JdYpg0TI6IDRf
	d6gqvz09MEYUPsJsV22kLZO3yVn9GB1DolaYpVLRpclfKcGtDXXI+rpECl4J/WtJzvIHC8T2PEFI+
	VDGZrmj9HkoCF3jtl4FmeD++6PH5z3/JFR8xAHZ3kV3LUV3x8qZfxiQCQ88b4dUJefNJaAO2mUFJT
	eytWujOPDDw9bQ1oRIKuJFlTcu0D+BlJsEb28xOpoWjh6cSkVtBhjQAc0RJACSMBNve5jUZgK4o6D
	Bta1pMIw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t0Jnn-00000006KtD-1YVn;
	Mon, 14 Oct 2024 12:03:55 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 09E97300777; Mon, 14 Oct 2024 14:03:55 +0200 (CEST)
Date: Mon, 14 Oct 2024 14:03:54 +0200
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
Message-ID: <20241014120354.GG16066@noisy.programming.kicks-ass.net>
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
> From: Kan Liang <kan.liang@linux.intel.com>
> 
> There will be a dedicated interrupt vector for guests on some platforms,
> e.g., Intel. Add an interface to switch the interrupt vector while
> entering/exiting a guest.
> 
> When PMI switch into a new guest vector, guest_lvtpc value need to be
> reflected onto HW, e,g., guest clear PMI mask bit, the HW PMI mask
> bit should be cleared also, then PMI can be generated continuously
> for guest. So guest_lvtpc parameter is added into perf_guest_enter()
> and switch_interrupt().
> 
> At switch_interrupt(), the target pmu with PASSTHROUGH cap should
> be found. Since only one passthrough pmu is supported, we keep the
> implementation simply by tracking the pmu as a global variable.
> 
> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
> 
> [Simplify the commit with removal of srcu lock/unlock since only one pmu is
> supported.]
> 
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> ---
>  include/linux/perf_event.h |  9 +++++++--
>  kernel/events/core.c       | 36 ++++++++++++++++++++++++++++++++++--
>  2 files changed, 41 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 75773f9890cc..aeb08f78f539 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -541,6 +541,11 @@ struct pmu {
>  	 * Check period value for PERF_EVENT_IOC_PERIOD ioctl.
>  	 */
>  	int (*check_period)		(struct perf_event *event, u64 value); /* optional */
> +
> +	/*
> +	 * Switch the interrupt vectors, e.g., guest enter/exit.
> +	 */
> +	void (*switch_interrupt)	(bool enter, u32 guest_lvtpc); /* optional */
>  };

I'm thinking the guets_lvtpc argument shouldn't be part of the
interface. That should be PMU implementation data and accessed by the
method implementation.

