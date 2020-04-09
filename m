Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D53C1A3820
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 18:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgDIQhw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 12:37:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44498 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726837AbgDIQhw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 12:37:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nIqPOKs1fmMReW8y7QRk2R1z1/+KdCJCN9yG/rxFSdc=; b=W+1B2tWu3U/QfDtIdj88tby3F0
        Y64bX77mUH+JQjFT4Z8tj4G3tLrrhejyBrDeuFHrXmyEEq68qUGQS+sPCg295L6TF2eZahjfNc1hn
        kqRlJqmIPqwJwMwPG4n9kCA0tCoX4+ECZex2oC7poy+sE3gJpUVDfGYXVfRmvkBQB6uc7omSerqFi
        zZCVb1uHmtWGUajxlXZf1iJ961My5q053OfI7F11x4YuHO5kxwTH3G72FoDdHmVSrZaxv/Z/0LpdP
        vJXppFgKWef59KdlTyuBdoHlqa8fOgveWRQlJvd3nOhv6UqLPgDpKWdB6SQwtouxiEZ3CrFlPRki/
        FJSuIIbg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jMaB7-00043p-QD; Thu, 09 Apr 2020 16:37:22 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 98DBA3012D8;
        Thu,  9 Apr 2020 18:37:17 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 847222BA1D826; Thu,  9 Apr 2020 18:37:17 +0200 (CEST)
Date:   Thu, 9 Apr 2020 18:37:17 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Liran Alon <liran.alon@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Liang Kan <kan.liang@linux.intel.com>,
        Wei Wang <wei.w.wang@intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v9 03/10] perf/x86: Add constraint to create guest LBR
 event without hw counter
Message-ID: <20200409163717.GD20713@hirez.programming.kicks-ass.net>
References: <20200313021616.112322-1-like.xu@linux.intel.com>
 <20200313021616.112322-4-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313021616.112322-4-like.xu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index 3bb738f5a472..e919187a0751 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -74,7 +74,8 @@ u64 x86_perf_event_update(struct perf_event *event)
>  	int idx = hwc->idx;
>  	u64 delta;
>  
> -	if (idx == INTEL_PMC_IDX_FIXED_BTS)
> +	if ((idx == INTEL_PMC_IDX_FIXED_BTS) ||
> +		(idx == INTEL_PMC_IDX_FIXED_VLBR))
>  		return 0;
>  
>  	/*
> @@ -1102,7 +1103,8 @@ static inline void x86_assign_hw_event(struct perf_event *event,
>  	hwc->last_cpu = smp_processor_id();
>  	hwc->last_tag = ++cpuc->tags[i];
>  
> -	if (hwc->idx == INTEL_PMC_IDX_FIXED_BTS) {
> +	if ((hwc->idx == INTEL_PMC_IDX_FIXED_BTS) ||
> +		(hwc->idx == INTEL_PMC_IDX_FIXED_VLBR)) {
>  		hwc->config_base = 0;
>  		hwc->event_base	= 0;
>  	} else if (hwc->idx >= INTEL_PMC_IDX_FIXED) {
> @@ -1233,7 +1235,8 @@ int x86_perf_event_set_period(struct perf_event *event)
>  	s64 period = hwc->sample_period;
>  	int ret = 0, idx = hwc->idx;
>  
> -	if (idx == INTEL_PMC_IDX_FIXED_BTS)
> +	if ((idx == INTEL_PMC_IDX_FIXED_BTS) ||
> +		(idx == INTEL_PMC_IDX_FIXED_VLBR))
>  		return 0;
>  
>  	/*

That seems unfortunate; can that be >= INTEL_PMC_IDX_FIXED_BTS ? If so,
that probably wants a comment with the definitions.

Or otherwise check for !hwc->event_base. That should be 0 for both these
things.

> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> index 3be51aa06e67..901c82032f4a 100644
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -2157,6 +2157,9 @@ static void intel_pmu_disable_event(struct perf_event *event)
>  		return;
>  	}
>  
> +	if (unlikely(hwc->idx == INTEL_PMC_IDX_FIXED_VLBR))
> +		return;
> +

Please check code-gen to see if you can cut down on brancher here;
there's 4 cases:

 - vlbr
 - bts
 - fixed
 - gp

perhaps you can write it like so:

(also see https://lkml.kernel.org/r/20190828090217.GN2386@hirez.programming.kicks-ass.net )

static void intel_pmu_enable_event(struct perf_event *event)
{
	...
	int idx = hwx->idx;

	if (idx < INTEL_PMC_IDX_FIXED) {
		intel_set_masks(event, idx);
		__x86_pmu_enable_event(hwc, ARCH_PERFMON_EVENTSEL_ENABLE);
	} else if (idx < INTEL_PMC_IDX_FIXED_BTS) {
		intel_set_masks(event, idx);
		intel_pmu_enable_fixed(event);
	} else if (idx == INTEL_PMC_IDX_FIXED_BTS) {
		intel_pmu_enable_bts(hwc->config);
	}

	/* nothing for INTEL_PMC_IDX_FIXED_VLBR */
}

That should sort the branches in order of: gp,fixed,bts,vlbr

>  	cpuc->intel_ctrl_guest_mask &= ~(1ull << hwc->idx);
>  	cpuc->intel_ctrl_host_mask &= ~(1ull << hwc->idx);
>  	cpuc->intel_cp_status &= ~(1ull << hwc->idx);
> @@ -2241,6 +2244,9 @@ static void intel_pmu_enable_event(struct perf_event *event)
>  		return;
>  	}
>  
> +	if (unlikely(hwc->idx == INTEL_PMC_IDX_FIXED_VLBR))
> +		return;
> +
>  	if (event->attr.exclude_host)
>  		cpuc->intel_ctrl_guest_mask |= (1ull << hwc->idx);
>  	if (event->attr.exclude_guest)

idem.

> @@ -2595,6 +2601,15 @@ intel_bts_constraints(struct perf_event *event)
>  	return NULL;
>  }
>  
> +static struct event_constraint *
> +intel_guest_event_constraints(struct perf_event *event)
> +{
> +	if (unlikely(is_guest_lbr_event(event)))
> +		return &guest_lbr_constraint;
> +
> +	return NULL;
> +}

This is a mis-nomer, it isn't just any guest_event

> +
>  static int intel_alt_er(int idx, u64 config)
>  {
>  	int alt_idx = idx;
> @@ -2785,6 +2800,10 @@ __intel_get_event_constraints(struct cpu_hw_events *cpuc, int idx,
>  {
>  	struct event_constraint *c;
>  
> +	c = intel_guest_event_constraints(event);
> +	if (c)
> +		return c;
> +
>  	c = intel_bts_constraints(event);
>  	if (c)
>  		return c;

> diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
> index 1025bc6eb04f..9a62264a3068 100644
> --- a/arch/x86/events/perf_event.h
> +++ b/arch/x86/events/perf_event.h
> @@ -969,6 +969,20 @@ static inline bool intel_pmu_has_bts(struct perf_event *event)
>  	return intel_pmu_has_bts_period(event, hwc->sample_period);
>  }
>  
> +static inline bool is_guest_event(struct perf_event *event)
> +{
> +	if (event->attr.exclude_host && is_kernel_event(event))
> +		return true;
> +	return false;
> +}

I don't like this one, what if another in-kernel users generates an
event with exclude_host set ?

> @@ -989,6 +1003,7 @@ void release_ds_buffers(void);
>  void reserve_ds_buffers(void);
>  
>  extern struct event_constraint bts_constraint;
> +extern struct event_constraint guest_lbr_constraint;
>  
>  void intel_pmu_enable_bts(u64 config);
>  
> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
> index e018a1cf604c..674130aca75a 100644
> --- a/arch/x86/include/asm/perf_event.h
> +++ b/arch/x86/include/asm/perf_event.h
> @@ -181,9 +181,19 @@ struct x86_pmu_capability {
>  #define GLOBAL_STATUS_UNC_OVF				BIT_ULL(61)
>  #define GLOBAL_STATUS_ASIF				BIT_ULL(60)
>  #define GLOBAL_STATUS_COUNTERS_FROZEN			BIT_ULL(59)
> -#define GLOBAL_STATUS_LBRS_FROZEN			BIT_ULL(58)
> +#define GLOBAL_STATUS_LBRS_FROZEN_BIT			58
> +#define GLOBAL_STATUS_LBRS_FROZEN			BIT_ULL(GLOBAL_STATUS_LBRS_FROZEN_BIT)
>  #define GLOBAL_STATUS_TRACE_TOPAPMI			BIT_ULL(55)
>  
> +/*
> + * We model guest LBR event tracing as another fixed-mode PMC like BTS.
> + *
> + * We choose bit 58 (LBRS_FROZEN_BIT) which is used to indicate that the LBR
> + * stack is frozen on a hardware PMI request in the PERF_GLOBAL_STATUS msr,
> + * and the 59th PMC counter (if any) is not supposed to use it as well.

Is this saying that STATUS.58 should never be set? I don't really
understand the language.

> + */
> +#define INTEL_PMC_IDX_FIXED_VLBR	GLOBAL_STATUS_LBRS_FROZEN_BIT
> +
>  /*
>   * Adaptive PEBS v4
>   */
