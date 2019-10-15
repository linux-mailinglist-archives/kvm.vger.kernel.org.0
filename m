Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2E1AD72AB
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 12:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbfJOKAE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Oct 2019 06:00:04 -0400
Received: from foss.arm.com ([217.140.110.172]:34170 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727018AbfJOKAE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Oct 2019 06:00:04 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7936D28;
        Tue, 15 Oct 2019 03:00:03 -0700 (PDT)
Received: from localhost (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E89133F68E;
        Tue, 15 Oct 2019 03:00:02 -0700 (PDT)
Date:   Tue, 15 Oct 2019 11:00:01 +0100
From:   Andrew Murray <andrew.murray@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v3 4/4] KVM: arm64: pmu: Reset sample period on overflow
 handling
Message-ID: <20191015100000.GT42880@e119886-lin.cambridge.arm.com>
References: <20191011123954.31378-1-maz@kernel.org>
 <20191011123954.31378-5-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011123954.31378-5-maz@kernel.org>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 11, 2019 at 01:39:54PM +0100, Marc Zyngier wrote:
> The PMU emulation code uses the perf event sample period to trigger
> the overflow detection. This works fine  for the *first* overflow
> handling, but results in a huge number of interrupts on the host,
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
> 
> Fixes: b02386eb7dac ("arm64: KVM: Add PMU overflow interrupt routing")
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---

Reviewed-by: Andrew Murray <andrew.murray@arm.com>

>  virt/kvm/arm/pmu.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index f291d4ac3519..8731dfeced8b 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -8,6 +8,7 @@
>  #include <linux/kvm.h>
>  #include <linux/kvm_host.h>
>  #include <linux/perf_event.h>
> +#include <linux/perf/arm_pmu.h>
>  #include <linux/uaccess.h>
>  #include <asm/kvm_emulate.h>
>  #include <kvm/arm_pmu.h>
> @@ -442,8 +443,25 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
>  				  struct pt_regs *regs)
>  {
>  	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
> +	struct arm_pmu *cpu_pmu = to_arm_pmu(perf_event->pmu);
>  	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
>  	int idx = pmc->idx;
> +	u64 period;
> +
> +	cpu_pmu->pmu.stop(perf_event, PERF_EF_UPDATE);
> +
> +	/*
> +	 * Reset the sample period to the architectural limit,
> +	 * i.e. the point where the counter overflows.
> +	 */
> +	period = -(local64_read(&perf_event->count));
> +
> +	if (!kvm_pmu_idx_is_64bit(vcpu, pmc->idx))
> +		period &= GENMASK(31, 0);
> +
> +	local64_set(&perf_event->hw.period_left, 0);
> +	perf_event->attr.sample_period = period;
> +	perf_event->hw.sample_period = period;
>  
>  	__vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(idx);
>  
> @@ -451,6 +469,8 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
>  		kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
>  		kvm_vcpu_kick(vcpu);
>  	}
> +
> +	cpu_pmu->pmu.start(perf_event, PERF_EF_RELOAD);
>  }
>  
>  /**
> -- 
> 2.20.1
> 
