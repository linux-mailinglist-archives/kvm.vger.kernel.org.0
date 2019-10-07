Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84FE2CDE5B
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2019 11:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727355AbfJGJnb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 05:43:31 -0400
Received: from foss.arm.com ([217.140.110.172]:58612 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727103AbfJGJna (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Oct 2019 05:43:30 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE99015BE;
        Mon,  7 Oct 2019 02:43:29 -0700 (PDT)
Received: from localhost (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 51FC03F68E;
        Mon,  7 Oct 2019 02:43:29 -0700 (PDT)
Date:   Mon, 7 Oct 2019 10:43:27 +0100
From:   Andrew Murray <andrew.murray@arm.com>
To:     maz@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 3/3] KVM: arm64: pmu: Reset sample period on overflow
 handling
Message-ID: <20191007094325.GX42880@e119886-lin.cambridge.arm.com>
References: <20191006104636.11194-1-maz@kernel.org>
 <20191006104636.11194-4-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191006104636.11194-4-maz@kernel.org>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 06, 2019 at 11:46:36AM +0100, maz@kernel.org wrote:
> From: Marc Zyngier <maz@kernel.org>
> 
> The PMU emulation code uses the perf event sample period to trigger
> the overflow detection. This works fine  for the *first* overflow
> handling

Although, even though the first overflow is timed correctly, the value
the guest reads may be wrong...

Assuming a Linux guest with the arm_pmu.c driver, if I recall correctly
this writes the -remainingperiod to the counter upon stopping/starting.
In the case of a perf_event that is pinned to a task, this will happen
upon every context switch of that task. If the counter was getting close
to overflow before the context switch, then the value written to the
guest counter will be very high and thus the sample_period written in KVM
will be very low...

The best scenario is when the host handles the overflow, the guest
handles its overflow and rewrites the guest counter (resulting in a new
host perf_event) - all before the first host perf_event fires again. This
is clearly the assumption the code makes.

Or - the host handles its overflow and kicks the guest, but the guest
doesn't respond in time, so we end up endlessly and pointlessly kicking it
for each host overflow - thus resulting in the large difference between number
of interrupts between host and guest. This isn't ideal, because when the
guest does read its counter, the value isn't correct (because it overflowed
a zillion times at a value less than the arrchitected max).

Worse still is when the sample_period is so small, the host doesn't
even keep up.

> , but results in a huge number of interrupts on the host,
> unrelated to the number of interrupts handled in the guest (a x20
> factor is pretty common for the cycle counter). On a slow system
> (such as a SW model), this can result in the guest only making
> forward progress at a glacial pace.
> 
> It turns out that the clue is in the name. The sample period is
> exactly that: a period. And once the an overflow has occured,
> the following period should be the full width of the associated
> counter, instead of whatever the guest had initially programed.
> 
> Reset the sample period to the architected value in the overflow
> handler, which now results in a number of host interrupts that is
> much closer to the number of interrupts in the guest.

This seems a reasonable pragmatic approach - though of course you will end
up counting slightly slower due to the host interrupt latency. But that's
better than the status quo.

It may be possible with perf to have a single-fire counter (this mitigates
against my third scenario but you still end up with a loss of precision) -
See PERF_EVENT_IOC_REFRESH.

Ideally the PERF_EVENT_IOC_REFRESH type of functionality could be updated
to reload to a different value after the first hit.

This problem also exists on arch/x86/kvm/pmu.c (though I'm not sure what
their PMU drivers do with respect to the value they write).

> 
> Fixes: b02386eb7dac ("arm64: KVM: Add PMU overflow interrupt routing")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  virt/kvm/arm/pmu.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index c30c3a74fc7f..3ca4761fc0f5 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -444,6 +444,18 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
>  	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
>  	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
>  	int idx = pmc->idx;
> +	u64 val, period;
> +
> +	/* Start by resetting the sample period to the architectural limit */
> +	val = kvm_pmu_get_pair_counter_value(vcpu, pmc);
> +
> +	if (kvm_pmu_idx_is_64bit(vcpu, pmc->idx))

This is correct, because in this case we *do* care about _PMCR_LC.

> +		period = (-val) & GENMASK(63, 0);
> +	else
> +		period = (-val) & GENMASK(31, 0);
> +
> +	pmc->perf_event->attr.sample_period = period;
> +	pmc->perf_event->hw.sample_period = period;

I'm not sure about the above line - does direct manipulation of sample_period
work on a running perf event? As far as I can tell this is already done in the
kernel with __perf_event_period - however this also does other stuff (such as
disable and re-enable the event).

>  

Thanks,

Andrew Murray

>  	__vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(idx);
>  
> -- 
> 2.20.1
> 
