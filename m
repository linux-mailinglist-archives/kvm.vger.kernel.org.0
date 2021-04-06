Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BECC355912
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 18:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346339AbhDFQWw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 12:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233438AbhDFQWu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 12:22:50 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79CCDC06174A;
        Tue,  6 Apr 2021 09:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HAWHkSHLpgp7SKC3po0RuoKKiMjohQD3zmd/MHygCVY=; b=Xpg483JZKG5jyymhkSRLWD/wej
        v25qJkOyU47/DeEPYqZRC4RrP+mk/yqbrUvJQoukNpWxwZBeIyciFIowwxBzNIt9YW6ad3WyKorKt
        owYUYl5ehm6ApZZJJSW8lWcbwd/Ho4mXFjWHRNtScATjFfTVHoyAAq3GhV+jyhDe7ddLTDIYo1ybI
        ufCidcYY+hiLrLQSVN0WtU4QEm0pCY1nTJwhp6EnRAZ2GGSVYak69nwxhiWFhLC5GjdpRpDiNq9w0
        llLL9tRRnwYvcxJGMT7zPMfw93yw25wf5017Ovxe1z8JskXJxcC2BkXOH9jxh9mEVFotVU6uitlSg
        h8GJyeUg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lToSy-002zuy-6Q; Tue, 06 Apr 2021 16:22:12 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A467E304B54;
        Tue,  6 Apr 2021 18:22:10 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 4B247244029D0; Tue,  6 Apr 2021 18:22:10 +0200 (CEST)
Date:   Tue, 6 Apr 2021 18:22:10 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, eranian@google.com,
        andi@firstfloor.org, kan.liang@linux.intel.com,
        wei.w.wang@intel.com, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v4 02/16] perf/x86/intel: Handle guest PEBS overflow PMI
 for KVM guest
Message-ID: <YGyKsna7CcncX0g6@hirez.programming.kicks-ass.net>
References: <20210329054137.120994-1-like.xu@linux.intel.com>
 <20210329054137.120994-3-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329054137.120994-3-like.xu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 29, 2021 at 01:41:23PM +0800, Like Xu wrote:
> With PEBS virtualization, the guest PEBS records get delivered to the
> guest DS, and the host pmi handler uses perf_guest_cbs->is_in_guest()
> to distinguish whether the PMI comes from the guest code like Intel PT.
> 
> No matter how many guest PEBS counters are overflowed, only triggering
> one fake event is enough. The fake event causes the KVM PMI callback to
> be called, thereby injecting the PEBS overflow PMI into the guest.
> 
> KVM will inject the PMI with BUFFER_OVF set, even if the guest DS is
> empty. That should really be harmless. Thus the guest PEBS handler would
> retrieve the correct information from its own PEBS records buffer.
> 
> Originally-by: Andi Kleen <ak@linux.intel.com>
> Co-developed-by: Kan Liang <kan.liang@linux.intel.com>
> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> ---
>  arch/x86/events/intel/core.c | 45 +++++++++++++++++++++++++++++++++++-
>  1 file changed, 44 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> index 591d60cc8436..af9ac48fe840 100644
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -2747,6 +2747,46 @@ static void intel_pmu_reset(void)
>  	local_irq_restore(flags);
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
> + * The contents and other behavior of the guest event do not matter.
> + */
> +static int x86_pmu_handle_guest_pebs(struct pt_regs *regs,
> +					struct perf_sample_data *data)
> +{
> +	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
> +	u64 guest_pebs_idxs = cpuc->pebs_enabled & ~cpuc->intel_ctrl_host_mask;
> +	struct perf_event *event = NULL;
> +	int bit;
> +
> +	if (!x86_pmu.pebs_active || !guest_pebs_idxs)
> +		return 0;
> +
> +	for_each_set_bit(bit, (unsigned long *)&guest_pebs_idxs,
> +			INTEL_PMC_IDX_FIXED + x86_pmu.num_counters_fixed) {
> +
> +		event = cpuc->events[bit];
> +		if (!event->attr.precise_ip)
> +			continue;
> +
> +		perf_sample_data_init(data, 0, event->hw.last_period);
> +		if (perf_event_overflow(event, data, regs))
> +			x86_pmu_stop(event, 0);
> +
> +		/* Inject one fake event is enough. */
> +		return 1;
> +	}
> +
> +	return 0;
> +}

Why the return value, it is ignored.

> +
>  static int handle_pmi_common(struct pt_regs *regs, u64 status)
>  {
>  	struct perf_sample_data data;
> @@ -2797,7 +2837,10 @@ static int handle_pmi_common(struct pt_regs *regs, u64 status)
>  		u64 pebs_enabled = cpuc->pebs_enabled;
>  
>  		handled++;
> -		x86_pmu.drain_pebs(regs, &data);
> +		if (x86_pmu.pebs_vmx && perf_guest_cbs && perf_guest_cbs->is_in_guest())
> +			x86_pmu_handle_guest_pebs(regs, &data);
> +		else
> +			x86_pmu.drain_pebs(regs, &data);

Why is that else? Since we can't tell if the PMI was for the guest or
for our own DS, we should check both, no?
