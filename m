Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A699DCB6B6
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 10:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387484AbfJDIz6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 04:55:58 -0400
Received: from foss.arm.com ([217.140.110.172]:39126 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729334AbfJDIz6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 04:55:58 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7F5621597;
        Fri,  4 Oct 2019 01:55:57 -0700 (PDT)
Received: from localhost (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 046B13F739;
        Fri,  4 Oct 2019 01:55:56 -0700 (PDT)
Date:   Fri, 4 Oct 2019 09:55:55 +0100
From:   Andrew Murray <andrew.murray@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH] KVM: arm64: pmu: Fix cycle counter truncation on counter
 stop
Message-ID: <20191004085554.GQ42880@e119886-lin.cambridge.arm.com>
References: <20191003172400.21157-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003172400.21157-1-maz@kernel.org>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 03, 2019 at 06:24:00PM +0100, Marc Zyngier wrote:
> When a counter is disabled, its value is sampled before the event
> is being disabled, and the value written back in the shadow register.
> 
> In that process, the value gets truncated to 32bit, which is adequate

Doh, that shouldn't have happened.

> for any counter but the cycle counter, which can be configured to
> hold a 64bit value. This obviously results in a corrupted counter,
> and things like "perf record -e cycles" not working at all when
> run in a guest...
> 
> Make the truncation conditional on the counter not being 64bit.
> 
> Fixes: 80f393a23be6 ("KVM: arm/arm64: Support chained PMU counters")
> Cc: Andrew Murray <andrew.murray@arm.com>
> Reported-by: Julien Thierry Julien Thierry <julien.thierry.kdev@gmail.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  virt/kvm/arm/pmu.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index 362a01886bab..d716aef2bae9 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -206,9 +206,11 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
>  		__vcpu_sys_reg(vcpu, reg) = lower_32_bits(counter);
>  		__vcpu_sys_reg(vcpu, reg + 1) = upper_32_bits(counter);
>  	} else {
> +		if (!kvm_pmu_idx_is_64bit(vcpu, pmc->idx))
> +			counter = lower_32_bits(counter);
>  		reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
>  		       ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
> -		__vcpu_sys_reg(vcpu, reg) = lower_32_bits(counter);
> +		__vcpu_sys_reg(vcpu, reg) = counter;

The other uses of lower_32_bits look OK to me.

Reviewed-by: Andrew Murray <andrew.murray@arm.com>

As a side note, I'm not convinced that the implementation (or perhaps the
use of) kvm_pmu_idx_is_64bit is correct:

static bool kvm_pmu_idx_is_64bit(struct kvm_vcpu *vcpu, u64 select_idx)
{
        return (select_idx == ARMV8_PMU_CYCLE_IDX &&
                __vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_LC);
}

We shouldn't truncate the value of a cycle counter to 32 bits just because
_PMCR_LC is unset. We should only be interested in _PMCR_LC when setting
the sample_period.

If you agree this is wrong, I'll spin a change.

Though unsetting _PMCR_LC is deprecated so I can't imagine this causes any
issue.

Thanks,

Andrew Murray

>  	}
>  
>  	kvm_pmu_release_perf_event(pmc);
> -- 
> 2.20.1
> 
