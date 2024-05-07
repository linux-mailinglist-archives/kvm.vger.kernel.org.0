Return-Path: <kvm+bounces-16817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DDC448BDE65
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 11:34:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D39B1F259EF
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 09:34:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08E2E14EC43;
	Tue,  7 May 2024 09:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mY9Q/xKH"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD3C5B1E0;
	Tue,  7 May 2024 09:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715074401; cv=none; b=UosEGPLLhImCquP+HKY53G4hjzgHxrpIWyJPpYw5pRmqrWKEwJE7SKjrGMfpeLfvJ/qG4ArmHso7OYEfjmgG06LEM2qGRmq8eSJknwEXmRMhtcio5zVZKTo2/7v3AzAWHdmEOQq86zyUgztQBITCBTvHB8LUMAid72dz9lLk5sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715074401; c=relaxed/simple;
	bh=aXpQ2bPUxaRp5kpcwVxAWsV3qiCDpywLcsx+/kWv8Hk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=riVSDySLrWmLJH1C28ywbAxtaoIGf2BgtcLnbJITdmHOacThargeAuDYomd4T9KEqyuwnx9zeYodfWjFKVobqyxc0XHdzS4GjMMVpSu1CX3OFzq27Mw7T/YDQOxHT83hfum6W9w5+jFn9k2dSdvVOXIxG3NNJz9WqgYcHRvbu7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mY9Q/xKH; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RXAx0qDXAcVhK3dkzMm+wB4SoWgodQXI42L2PaUkdEo=; b=mY9Q/xKHtUFfUMefbQq1ZahtZ8
	l7KiyKip2Dl6WQL15CMW6VwFp40EGRB2kRgkPH6W061k3cyD8bMvm0i45jFJsZOTYUkt/jzxd5o2j
	XzxnjPGVKVYdtq16+cuqZUBgGHBLxhjb738FWoKTWWU2AUgNYABuXkeA8DrJReEMkROlJphtQtaQb
	GxjqtUUYgYV6Ac+UKDcg6Nm1lHS9Tto7kg0Qu1RCP534kMs85wXtd2t+nHmYzgAdDtv0/BBtr52cD
	VQePdDL0Uu9x+FhSafNsp3TSXkn9DiHhRBuBV1J5ORkfmtBsC3ZXOfmKnAjPcltqG8ZirFkONl6me
	mWLR4cJQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s4HCB-0000000Cw8X-3R48;
	Tue, 07 May 2024 09:33:11 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 77308300362; Tue,  7 May 2024 11:33:11 +0200 (CEST)
Date: Tue, 7 May 2024 11:33:11 +0200
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
Subject: Re: [PATCH v2 13/54] perf: core/x86: Forbid PMI handler when guest
 own PMU
Message-ID: <20240507093311.GW40213@noisy.programming.kicks-ass.net>
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-14-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240506053020.3911940-14-mizhang@google.com>

On Mon, May 06, 2024 at 05:29:38AM +0000, Mingwei Zhang wrote:

> @@ -1749,6 +1749,23 @@ perf_event_nmi_handler(unsigned int cmd, struct pt_regs *regs)
>  	u64 finish_clock;
>  	int ret;
>  
> +	/*
> +	 * When guest pmu context is loaded this handler should be forbidden from
> +	 * running, the reasons are:
> +	 * 1. After x86_perf_guest_enter() is called, and before cpu enter into
> +	 *    non-root mode, NMI could happen, but x86_pmu_handle_irq() restore PMU
> +	 *    to use NMI vector, which destroy KVM PMI vector setting.
> +	 * 2. When VM is running, host NMI other than PMI causes VM exit, KVM will
> +	 *    call host NMI handler (vmx_vcpu_enter_exit()) first before KVM save
> +	 *    guest PMU context (kvm_pmu_save_pmu_context()), as x86_pmu_handle_irq()
> +	 *    clear global_status MSR which has guest status now, then this destroy
> +	 *    guest PMU status.
> +	 * 3. After VM exit, but before KVM save guest PMU context, host NMI other
> +	 *    than PMI could happen, x86_pmu_handle_irq() clear global_status MSR
> +	 *    which has guest status now, then this destroy guest PMU status.
> +	 */
> +	if (perf_is_guest_context_loaded())
> +		return 0;

A function call makes sense because? Also, isn't this naming at least a
very little misleading? Specifically this is about passthrough, not
guest context per se.

>  	/*
>  	 * All PMUs/events that share this PMI handler should make sure to
>  	 * increment active_events for their events.
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index acf16676401a..5da7de42954e 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -1736,6 +1736,7 @@ extern int perf_get_mediated_pmu(void);
>  extern void perf_put_mediated_pmu(void);
>  void perf_guest_enter(void);
>  void perf_guest_exit(void);
> +bool perf_is_guest_context_loaded(void);
>  #else /* !CONFIG_PERF_EVENTS: */
>  static inline void *
>  perf_aux_output_begin(struct perf_output_handle *handle,
> @@ -1830,6 +1831,10 @@ static inline int perf_get_mediated_pmu(void)
>  static inline void perf_put_mediated_pmu(void)			{ }
>  static inline void perf_guest_enter(void)			{ }
>  static inline void perf_guest_exit(void)			{ }
> +static inline bool perf_is_guest_context_loaded(void)
> +{
> +	return false;
> +}
>  #endif
>  
>  #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 4c6daf5cc923..184d06c23391 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -5895,6 +5895,11 @@ void perf_guest_exit(void)
>  	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
>  }
>  
> +bool perf_is_guest_context_loaded(void)
> +{
> +	return __this_cpu_read(perf_in_guest);
> +}
> +
>  /*
>   * Holding the top-level event's child_mutex means that any
>   * descendant process that has inherited this event will block
> -- 
> 2.45.0.rc1.225.g2a3ae87e7f-goog
> 

