Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94206D0035
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 19:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbfJHRzf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Oct 2019 13:55:35 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:47313 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726320AbfJHRzf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Oct 2019 13:55:35 -0400
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:AES256-GCM-SHA384:256)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iHthr-0003Vi-1f; Tue, 08 Oct 2019 19:55:31 +0200
Date:   Tue, 8 Oct 2019 18:55:29 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH v2 4/5] arm64: perf: Add reload-on-overflow capability
Message-ID: <20191008185529.75477da0@why>
In-Reply-To: <20191008160128.8872-5-maz@kernel.org>
References: <20191008160128.8872-1-maz@kernel.org>
        <20191008160128.8872-5-maz@kernel.org>
Organization: Approximate
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, mark.rutland@arm.com, suzuki.poulose@arm.com, james.morse@arm.com, andrew.murray@arm.com, will@kernel.org, julien.thierry.kdev@gmail.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  8 Oct 2019 17:01:27 +0100
Marc Zyngier <maz@kernel.org> wrote:

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
>  }
>  
>  static struct attribute *armv8_pmuv3_format_attrs[] = {
> @@ -736,8 +736,14 @@ static irqreturn_t armv8pmu_handle_irq(struct arm_pmu *cpu_pmu)
>  		if (!armpmu_event_set_period(event))
>  			continue;
>  
> +		if (event->attr.config1 & PERF_ATTR_CFG1_RELOAD_EVENT)
> +			cpu_pmu->pmu.stop(event, PERF_EF_RELOAD);
> +

Actually, I just realized that there is probably no need for this patch
as a standalone change. I can perfectly fold the stop() and start()
calls into the last patch, as part of the overflow handler.

The question is still whether that's a good idea or not.

Thanks,

	M.


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



-- 
Jazz is not dead. It just smells funny...
