Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9D8D017E
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 21:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730442AbfJHTww (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 15:52:52 -0400
Received: from foss.arm.com ([217.140.110.172]:44660 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729436AbfJHTww (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Oct 2019 15:52:52 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C8D1515BE;
        Tue,  8 Oct 2019 12:52:51 -0700 (PDT)
Received: from localhost (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4C7243F68E;
        Tue,  8 Oct 2019 12:52:51 -0700 (PDT)
Date:   Tue, 8 Oct 2019 20:52:49 +0100
From:   Andrew Murray <andrew.murray@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v2 4/5] arm64: perf: Add reload-on-overflow capability
Message-ID: <20191008195248.GJ42880@e119886-lin.cambridge.arm.com>
References: <20191008160128.8872-1-maz@kernel.org>
 <20191008160128.8872-5-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191008160128.8872-5-maz@kernel.org>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 08, 2019 at 05:01:27PM +0100, Marc Zyngier wrote:
> As KVM uses perf as a way to emulate an ARMv8 PMU, it needs to
> be able to change the sample period as part of the overflow
> handling (once an overflow has taken place, the following
> overflow point is the overflow of the virtual counter).
> 
> Deleting and recreating the in-kernel event is difficult, as
> we're in interrupt context. Instead, we can teach the PMU driver
> a new trick, which is to stop the event before the overflow handling,
> and reprogram it once it has been handled. This would give KVM
> the opportunity to adjust the next sample period. This feature
> is gated on a new flag that can get set by KVM in a subsequent
> patch.
> 
> Whilst we're at it, move the CHAINED flag from the KVM emulation
> to the perf_event.h file and adjust the PMU code accordingly.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/perf_event.h | 4 ++++
>  arch/arm64/kernel/perf_event.c      | 8 +++++++-
>  virt/kvm/arm/pmu.c                  | 4 +---
>  3 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/perf_event.h b/arch/arm64/include/asm/perf_event.h
> index 2bdbc79bbd01..8b6b38f2db8e 100644
> --- a/arch/arm64/include/asm/perf_event.h
> +++ b/arch/arm64/include/asm/perf_event.h
> @@ -223,4 +223,8 @@ extern unsigned long perf_misc_flags(struct pt_regs *regs);
>  	(regs)->pstate = PSR_MODE_EL1h;	\
>  }
>  
> +/* Flags used by KVM, among others */
> +#define PERF_ATTR_CFG1_CHAINED_EVENT	(1U << 0)
> +#define PERF_ATTR_CFG1_RELOAD_EVENT	(1U << 1)
> +
>  #endif
> diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
> index a0b4f1bca491..98907c9e5508 100644
> --- a/arch/arm64/kernel/perf_event.c
> +++ b/arch/arm64/kernel/perf_event.c
> @@ -322,7 +322,7 @@ PMU_FORMAT_ATTR(long, "config1:0");
>  
>  static inline bool armv8pmu_event_is_64bit(struct perf_event *event)
>  {
> -	return event->attr.config1 & 0x1;
> +	return event->attr.config1 & PERF_ATTR_CFG1_CHAINED_EVENT;

I'm pleased to see this be replaced with a define, it helps readers see the
link between this and the KVM driver.

>  }
>  
>  static struct attribute *armv8_pmuv3_format_attrs[] = {
> @@ -736,8 +736,14 @@ static irqreturn_t armv8pmu_handle_irq(struct arm_pmu *cpu_pmu)
>  		if (!armpmu_event_set_period(event))
>  			continue;
>  
> +		if (event->attr.config1 & PERF_ATTR_CFG1_RELOAD_EVENT)
> +			cpu_pmu->pmu.stop(event, PERF_EF_RELOAD);

I believe PERF_EF_RELOAD is only intended to be used in the stop calls. I'd
suggest that you replace it with PERF_EF_UPDATE instead, this tells the PMU
to update the counter with the latest value from the hardware. (Though the
ARM PMU driver always does this regardless to the flag anyway).

Thanks,

Andrew Murray

> +
>  		if (perf_event_overflow(event, &data, regs))
>  			cpu_pmu->disable(event);
> +
> +		if (event->attr.config1 & PERF_ATTR_CFG1_RELOAD_EVENT)
> +			cpu_pmu->pmu.start(event, PERF_EF_RELOAD);
>  	}
>  	armv8pmu_start(cpu_pmu);
>  
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index f291d4ac3519..25a483a04beb 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -15,8 +15,6 @@
>  
>  static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx);
>  
> -#define PERF_ATTR_CFG1_KVM_PMU_CHAINED 0x1
> -
>  /**
>   * kvm_pmu_idx_is_64bit - determine if select_idx is a 64bit counter
>   * @vcpu: The vcpu pointer
> @@ -570,7 +568,7 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>  		 */
>  		attr.sample_period = (-counter) & GENMASK(63, 0);
>  		if (kvm_pmu_counter_is_enabled(vcpu, pmc->idx + 1))
> -			attr.config1 |= PERF_ATTR_CFG1_KVM_PMU_CHAINED;
> +			attr.config1 |= PERF_ATTR_CFG1_CHAINED_EVENT;
>  
>  		event = perf_event_create_kernel_counter(&attr, -1, current,
>  							 kvm_pmu_perf_overflow,
> -- 
> 2.20.1
> 
