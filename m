Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 040FFCDD9F
	for <lists+kvm@lfdr.de>; Mon,  7 Oct 2019 10:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbfJGIsD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 04:48:03 -0400
Received: from foss.arm.com ([217.140.110.172]:57780 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727103AbfJGIsD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Oct 2019 04:48:03 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A681A1570;
        Mon,  7 Oct 2019 01:48:02 -0700 (PDT)
Received: from localhost (unknown [10.37.6.20])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 29A753F68E;
        Mon,  7 Oct 2019 01:48:02 -0700 (PDT)
Date:   Mon, 7 Oct 2019 09:48:00 +0100
From:   Andrew Murray <andrew.murray@arm.com>
To:     maz@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 1/3] KVM: arm64: pmu: Fix cycle counter truncation
Message-ID: <20191007084800.GW42880@e119886-lin.cambridge.arm.com>
References: <20191006104636.11194-1-maz@kernel.org>
 <20191006104636.11194-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191006104636.11194-2-maz@kernel.org>
User-Agent: Mutt/1.10.1+81 (426a6c1) (2018-08-26)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 06, 2019 at 11:46:34AM +0100, maz@kernel.org wrote:
> From: Marc Zyngier <maz@kernel.org>
> 
> When a counter is disabled, its value is sampled before the event
> is being disabled, and the value written back in the shadow register.
> 
> In that process, the value gets truncated to 32bit, which is adequate
> for any counter but the cycle counter (defined as a 64bit counter).
> 
> This obviously results in a corrupted counter, and things like
> "perf record -e cycles" not working at all when run in a guest...
> A similar, but less critical bug exists in kvm_pmu_get_counter_value.
> 
> Make the truncation conditional on the counter not being the cycle
> counter, which results in a minor code reorganisation.
> 
> Fixes: 80f393a23be6 ("KVM: arm/arm64: Support chained PMU counters")
> Cc: Andrew Murray <andrew.murray@arm.com>
> Reported-by: Julien Thierry <julien.thierry.kdev@gmail.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---

Reviewed-by: Andrew Murray <andrew.murray@arm.com>

>  virt/kvm/arm/pmu.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> index 362a01886bab..c30c3a74fc7f 100644
> --- a/virt/kvm/arm/pmu.c
> +++ b/virt/kvm/arm/pmu.c
> @@ -146,8 +146,7 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
>  	if (kvm_pmu_pmc_is_chained(pmc) &&
>  	    kvm_pmu_idx_is_high_counter(select_idx))
>  		counter = upper_32_bits(counter);
> -
> -	else if (!kvm_pmu_idx_is_64bit(vcpu, select_idx))
> +	else if (select_idx != ARMV8_PMU_CYCLE_IDX)
>  		counter = lower_32_bits(counter);
>  
>  	return counter;
> @@ -193,7 +192,7 @@ static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
>   */
>  static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
>  {
> -	u64 counter, reg;
> +	u64 counter, reg, val;
>  
>  	pmc = kvm_pmu_get_canonical_pmc(pmc);
>  	if (!pmc->perf_event)
> @@ -201,16 +200,19 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
>  
>  	counter = kvm_pmu_get_pair_counter_value(vcpu, pmc);
>  
> -	if (kvm_pmu_pmc_is_chained(pmc)) {
> -		reg = PMEVCNTR0_EL0 + pmc->idx;
> -		__vcpu_sys_reg(vcpu, reg) = lower_32_bits(counter);
> -		__vcpu_sys_reg(vcpu, reg + 1) = upper_32_bits(counter);
> +	if (pmc->idx == ARMV8_PMU_CYCLE_IDX) {
> +		reg = PMCCNTR_EL0;
> +		val = counter;
>  	} else {
> -		reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
> -		       ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
> -		__vcpu_sys_reg(vcpu, reg) = lower_32_bits(counter);
> +		reg = PMEVCNTR0_EL0 + pmc->idx;
> +		val = lower_32_bits(counter);
>  	}
>  
> +	__vcpu_sys_reg(vcpu, reg) = val;
> +
> +	if (kvm_pmu_pmc_is_chained(pmc))
> +		__vcpu_sys_reg(vcpu, reg + 1) = upper_32_bits(counter);
> +
>  	kvm_pmu_release_perf_event(pmc);
>  }
>  
> -- 
> 2.20.1
> 
