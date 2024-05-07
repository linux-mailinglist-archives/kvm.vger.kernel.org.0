Return-Path: <kvm+bounces-16807-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED0748BDD4D
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 10:41:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29D1E1C219B4
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 08:41:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3380814D422;
	Tue,  7 May 2024 08:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Dp6yNe2o"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB7E14D439;
	Tue,  7 May 2024 08:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715071289; cv=none; b=r9GN7vEb0SWMyMW89maQuN7UyCm7KC7s9qGT/ijzOk+oLG4+NvW0uYfUk8CrPa4yafwJx7w/pXVY6/8ABf/ObwaOmCljuNHz2NRFzLH+sNxOSGXBnOTNVtKGezXNuLqUFKK9Y17hzzFplGSde/OSBuvs+JXbrbKSj0XSGYABOx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715071289; c=relaxed/simple;
	bh=W+ERTdFlb2QQk3jvo+qLV+U1ZR77x3BqWQqGpbV5+Ko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WP0zZvJEX+Bk/Xn0mJxxkLaqWZ6JX3f9GMVtBsoXA341QaCWYjGZstD1GFo5uvtwMD7dB60lJ9VTSRj7Mv1IJpgbQm5hwxjRcsX+yxKdze/3barA64k6hWcB5hKe2pi8p0HGyBqvOjSO8N1kdMvBrTUmMFcrTRVSr3r+lh4zbok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Dp6yNe2o; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FfH85KTq5+JtRGbRwa+cpvV/wehHNxx/cu/nCBaV/NA=; b=Dp6yNe2ohpGDodqhki0N3FL4Jh
	tgxFwO9OUH0M6MvTdiY8J4+UDTcu0ksShsKTEEsJ6Hc6Z0OrE/DWJwsI2aXOO6iTQiJCigCj2R2mU
	Sz+hD4HkgEIeI2J3Q2xOfhhlGTMzQmCRojf5sySjxqWqw2Xp/u6PQ1guCqYLWjvDjZsLKxhXL7blI
	DLJW3zO1DvwTLdRw3UjeGYFgrW8lLXf657t7s5Mxkfr/tSEoIVgjLscBP+2/d6fzN9ss7rH7G0Xei
	kOsCquzgIWcsHYxaJ7XVzSrgo4BWAZOZQdwWU9egFbbmaNhTRlY81env+xok3s4H/4m7kn5vGTxKr
	42xzybwQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s4GNu-0000000CqND-0gYr;
	Tue, 07 May 2024 08:41:14 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id B4E06300362; Tue,  7 May 2024 10:41:13 +0200 (CEST)
Date: Tue, 7 May 2024 10:41:13 +0200
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
	maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
	kvm@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v2 06/54] perf: Support get/put passthrough PMU interfaces
Message-ID: <20240507084113.GR40213@noisy.programming.kicks-ass.net>
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-7-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240506053020.3911940-7-mizhang@google.com>

On Mon, May 06, 2024 at 05:29:31AM +0000, Mingwei Zhang wrote:

> +int perf_get_mediated_pmu(void)
> +{
> +	int ret = 0;
> +
> +	mutex_lock(&perf_mediated_pmu_mutex);
> +	if (refcount_inc_not_zero(&nr_mediated_pmu_vms))
> +		goto end;
> +
> +	if (atomic_read(&nr_include_guest_events)) {
> +		ret = -EBUSY;
> +		goto end;
> +	}
> +	refcount_set(&nr_mediated_pmu_vms, 1);
> +end:
> +	mutex_unlock(&perf_mediated_pmu_mutex);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(perf_get_mediated_pmu);
> +
> +void perf_put_mediated_pmu(void)
> +{
> +	if (!refcount_dec_not_one(&nr_mediated_pmu_vms))
> +		refcount_set(&nr_mediated_pmu_vms, 0);

I'm sorry, but this made the WTF'o'meter go 'ding'.

Isn't that simply refcount_dec() ?

> +}
> +EXPORT_SYMBOL_GPL(perf_put_mediated_pmu);
> +
>  /*
>   * Holding the top-level event's child_mutex means that any
>   * descendant process that has inherited this event will block
> @@ -12086,11 +12140,24 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
>  	if (err)
>  		goto err_callchain_buffer;
>  
> +	if (is_include_guest_event(event)) {
> +		mutex_lock(&perf_mediated_pmu_mutex);
> +		if (refcount_read(&nr_mediated_pmu_vms)) {
> +			mutex_unlock(&perf_mediated_pmu_mutex);
> +			err = -EACCES;
> +			goto err_security_alloc;
> +		}
> +		atomic_inc(&nr_include_guest_events);
> +		mutex_unlock(&perf_mediated_pmu_mutex);
> +	}

Wouldn't all that be nicer with a helper function?

	if (is_include_guest_event() && !perf_get_guest_event())
		goto err_security_alloc;

> +
>  	/* symmetric to unaccount_event() in _free_event() */
>  	account_event(event);
>  
>  	return event;
>  
> +err_security_alloc:
> +	security_perf_event_free(event);
>  err_callchain_buffer:
>  	if (!event->parent) {
>  		if (event->attr.sample_type & PERF_SAMPLE_CALLCHAIN)
> -- 
> 2.45.0.rc1.225.g2a3ae87e7f-goog
> 

