Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27EC02F51E2
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 19:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbhAMSXR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 13:23:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727560AbhAMSXR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jan 2021 13:23:17 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBDDBC061575;
        Wed, 13 Jan 2021 10:22:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=NM1NHS03oZT+cgkZEfeOOqKXZsTG8FXo5mlNcVCKTd4=; b=ZhKASQAK9OkXRMJZqdyVUgezni
        +rXa4zptbIMA2QW+wfRaR01JGtYh2ltreq+2ZwHui9hMcFdwWWGDXOgygWRQnNcdZRNPJF/UUGPad
        bZQSCE03y6GrwkaUjbFlltdVjZYR3w7H/r7wZJAORR0bSUL/CgReOu1n0Rc6qB07tGIysooADS5xc
        ilfA8XFV4TNvQQ33ISynxQRqZn31M6p7gnNBJ4jFieFPpvKFPES26l5tEfH1nJM/ZarNpiWVVFBQC
        pjQI2xMvtHdDUgUob8CUrwSX6YF6HyBNUM2N1YtlUfvGZbF7XDcLD5FotBLV8yzR3P+eQKB59nbpB
        c63k2t5A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kzkmb-0000oP-Ux; Wed, 13 Jan 2021 18:22:14 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 797313010C8;
        Wed, 13 Jan 2021 19:22:09 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 6050B211618D2; Wed, 13 Jan 2021 19:22:09 +0100 (CET)
Date:   Wed, 13 Jan 2021 19:22:09 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andi Kleen <andi@firstfloor.org>,
        Kan Liang <kan.liang@linux.intel.com>, wei.w.wang@intel.com,
        luwei.kang@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 04/17] perf: x86/ds: Handle guest PEBS overflow PMI
 and inject it to guest
Message-ID: <X/86UWuV/9yt14hQ@hirez.programming.kicks-ass.net>
References: <20210104131542.495413-1-like.xu@linux.intel.com>
 <20210104131542.495413-5-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104131542.495413-5-like.xu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 04, 2021 at 09:15:29PM +0800, Like Xu wrote:

> diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
> index b47cc4226934..c499bdb58373 100644
> --- a/arch/x86/events/intel/ds.c
> +++ b/arch/x86/events/intel/ds.c
> @@ -1721,6 +1721,65 @@ intel_pmu_save_and_restart_reload(struct perf_event *event, int count)
>  	return 0;
>  }
>  
> +/*
> + * We may be running with guest PEBS events created by KVM, and the
> + * PEBS records are logged into the guest's DS and invisible to host.
> + *
> + * In the case of guest PEBS overflow, we only trigger a fake event
> + * to emulate the PEBS overflow PMI for guest PBES counters in KVM.
> + * The guest will then vm-entry and check the guest DS area to read
> + * the guest PEBS records.
> + *
> + * The guest PEBS overflow PMI may be dropped when both the guest and
> + * the host use PEBS. Therefore, KVM will not enable guest PEBS once
> + * the host PEBS is enabled since it may bring a confused unknown NMI.
> + *
> + * The contents and other behavior of the guest event do not matter.
> + */
> +static int intel_pmu_handle_guest_pebs(struct cpu_hw_events *cpuc,
> +				       struct pt_regs *iregs,
> +				       struct debug_store *ds)
> +{
> +	struct perf_sample_data data;
> +	struct perf_event *event = NULL;
> +	u64 guest_pebs_idxs = cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask;
> +	int bit;
> +
> +	/*
> +	 * Ideally, we should check guest DS to understand if it's
> +	 * a guest PEBS overflow PMI from guest PEBS counters.
> +	 * However, it brings high overhead to retrieve guest DS in host.
> +	 * So we check host DS instead for performance.

Again; for the virt illiterate people here (me); why is it expensive to
check guest DS?

Why do we need to? Can't we simply always forward the PMI if the guest
has bits set in MSR_IA32_PEBS_ENABLE ? Surely we can access the guest
MSRs at a reasonable rate..

Sure, it'll send too many PMIs, but is that really a problem?

> +	 *
> +	 * If PEBS interrupt threshold on host is not exceeded in a NMI, there
> +	 * must be a PEBS overflow PMI generated from the guest PEBS counters.
> +	 * There is no ambiguity since the reported event in the PMI is guest
> +	 * only. It gets handled correctly on a case by case base for each event.
> +	 *
> +	 * Note: KVM disables the co-existence of guest PEBS and host PEBS.

Where; I need a code reference here.

> +	 */
> +	if (!guest_pebs_idxs || !in_nmi() ||

All the other code uses !iregs instead of !in_nmi(), also your
indentation is broken.

> +		ds->pebs_index >= ds->pebs_interrupt_threshold)
> +		return 0;
> +
> +	for_each_set_bit(bit, (unsigned long *)&guest_pebs_idxs,
> +			INTEL_PMC_IDX_FIXED + x86_pmu.num_counters_fixed) {
> +
> +		event = cpuc->events[bit];
> +		if (!event->attr.precise_ip)
> +			continue;
> +
> +		perf_sample_data_init(&data, 0, event->hw.last_period);
> +		if (perf_event_overflow(event, &data, iregs))
> +			x86_pmu_stop(event, 0);
> +
> +		/* Inject one fake event is enough. */
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
>  static __always_inline void
>  __intel_pmu_pebs_event(struct perf_event *event,
>  		       struct pt_regs *iregs,
> @@ -1965,6 +2024,9 @@ static void intel_pmu_drain_pebs_icl(struct pt_regs *iregs, struct perf_sample_d
>  	if (!x86_pmu.pebs_active)
>  		return;
>  
> +	if (intel_pmu_handle_guest_pebs(cpuc, iregs, ds))
> +		return;
> +
>  	base = (struct pebs_basic *)(unsigned long)ds->pebs_buffer_base;
>  	top = (struct pebs_basic *)(unsigned long)ds->pebs_index;
>  
> -- 
> 2.29.2
> 
