Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B06EC58F17F
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 19:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233522AbiHJRV2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 13:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233580AbiHJRVQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 13:21:16 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4D67C776
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 10:21:14 -0700 (PDT)
Date:   Wed, 10 Aug 2022 12:21:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660152072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EacwsSkLTdFW0eIrqN/hNoQtEwVR/UyGViuuOhwHm/o=;
        b=nxoIpEKxTye5R0e840XBtTW3gLH4VSRHBhBDOs5inYKQA2aep99B/WlVNDeCNHTipDWxyt
        IBM8vhD7AvKs2aR8RpHqu3RigPuV20jmYkf+wqg8h0ryYx5iuox6Q00Qfag4zgKf+sq0ae
        +SQYQDcH7ycGpckWjkFL6flOwH/is64=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Ricardo Koller <ricarkol@google.com>, kernel-team@android.com
Subject: Re: [PATCH 1/9] KVM: arm64: PMU: Align chained counter
 implementation with architecture pseudocode
Message-ID: <YvPpAsNjslW46Ter@google.com>
References: <20220805135813.2102034-1-maz@kernel.org>
 <20220805135813.2102034-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805135813.2102034-2-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Fri, Aug 05, 2022 at 02:58:05PM +0100, Marc Zyngier wrote:
> Ricardo recently pointed out that the PMU chained counter emulation
> in KVM wasn't quite behaving like the one on actual hardware, in
> the sense that a chained counter would expose an overflow on
> both halves of a chained counter, while KVM would only expose the
> overflow on the top half.
> 
> The difference is subtle, but significant. What does the architecture
> say (DDI0087 H.a):
> 
> - Before PMUv3p4, all counters but the cycle counter are 32bit
> - A 32bit counter that overflows generates a CHAIN event on the
>   adjacent counter after exposing its own overflow status
> - The CHAIN event is accounted if the counter is correctly
>   configured (CHAIN event selected and counter enabled)
> 
> This all means that our current implementation (which uses 64bit
> perf events) prevents us from emulating this overflow on the lower half.
> 
> How to fix this? By implementing the above, to the letter.
> 
> This largly results in code deletion, removing the notions of
> "counter pair", "chained counters", and "canonical counter".
> The code is further restructured to make the CHAIN handling similar
> to SWINC, as the two are now extremely similar in behaviour.
> 
> Reported-by: Ricardo Koller <ricarkol@google.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/pmu-emul.c | 324 +++++++++++---------------------------
>  include/kvm/arm_pmu.h     |   2 -
>  2 files changed, 91 insertions(+), 235 deletions(-)
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 11c43bed5f97..4986e8b3ea6c 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -21,10 +21,6 @@ static LIST_HEAD(arm_pmus);
>  static DEFINE_MUTEX(arm_pmus_lock);
>  
>  static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx);
> -static void kvm_pmu_update_pmc_chained(struct kvm_vcpu *vcpu, u64 select_idx);
> -static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc);
> -
> -#define PERF_ATTR_CFG1_KVM_PMU_CHAINED 0x1

nit: The name isn't a good fit for the config bit, but it might be nice to
keep something around.

>  static u32 kvm_pmu_event_mask(struct kvm *kvm)
>  {
> @@ -57,6 +53,11 @@ static bool kvm_pmu_idx_is_64bit(struct kvm_vcpu *vcpu, u64 select_idx)
>  		__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_LC);
>  }
>  
> +static bool kvm_pmu_counter_can_chain(struct kvm_vcpu *vcpu, u64 idx)
> +{
> +	return (!(idx & 1) && (idx + 1) < ARMV8_PMU_CYCLE_IDX);
> +}
> +
>  static struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
>  {
>  	struct kvm_pmu *pmu;
> @@ -69,91 +70,22 @@ static struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
>  }
>  
>  /**
> - * kvm_pmu_pmc_is_chained - determine if the pmc is chained
> - * @pmc: The PMU counter pointer
> - */
> -static bool kvm_pmu_pmc_is_chained(struct kvm_pmc *pmc)
> -{
> -	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
> -
> -	return test_bit(pmc->idx >> 1, vcpu->arch.pmu.chained);
> -}
> -
> -/**
> - * kvm_pmu_idx_is_high_counter - determine if select_idx is a high/low counter
> - * @select_idx: The counter index
> - */
> -static bool kvm_pmu_idx_is_high_counter(u64 select_idx)
> -{
> -	return select_idx & 0x1;
> -}
> -
> -/**
> - * kvm_pmu_get_canonical_pmc - obtain the canonical pmc
> - * @pmc: The PMU counter pointer
> - *
> - * When a pair of PMCs are chained together we use the low counter (canonical)
> - * to hold the underlying perf event.
> - */
> -static struct kvm_pmc *kvm_pmu_get_canonical_pmc(struct kvm_pmc *pmc)
> -{
> -	if (kvm_pmu_pmc_is_chained(pmc) &&
> -	    kvm_pmu_idx_is_high_counter(pmc->idx))
> -		return pmc - 1;
> -
> -	return pmc;
> -}
> -static struct kvm_pmc *kvm_pmu_get_alternate_pmc(struct kvm_pmc *pmc)
> -{
> -	if (kvm_pmu_idx_is_high_counter(pmc->idx))
> -		return pmc - 1;
> -	else
> -		return pmc + 1;
> -}
> -
> -/**
> - * kvm_pmu_idx_has_chain_evtype - determine if the event type is chain
> + * kvm_pmu_get_counter_value - get PMU counter value
>   * @vcpu: The vcpu pointer
>   * @select_idx: The counter index
>   */
> -static bool kvm_pmu_idx_has_chain_evtype(struct kvm_vcpu *vcpu, u64 select_idx)
> -{
> -	u64 eventsel, reg;
> -
> -	select_idx |= 0x1;
> -
> -	if (select_idx == ARMV8_PMU_CYCLE_IDX)
> -		return false;
> -
> -	reg = PMEVTYPER0_EL0 + select_idx;
> -	eventsel = __vcpu_sys_reg(vcpu, reg) & kvm_pmu_event_mask(vcpu->kvm);
> -
> -	return eventsel == ARMV8_PMUV3_PERFCTR_CHAIN;
> -}
> -
> -/**
> - * kvm_pmu_get_pair_counter_value - get PMU counter value
> - * @vcpu: The vcpu pointer
> - * @pmc: The PMU counter pointer
> - */
> -static u64 kvm_pmu_get_pair_counter_value(struct kvm_vcpu *vcpu,
> -					  struct kvm_pmc *pmc)
> +u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
>  {
> -	u64 counter, counter_high, reg, enabled, running;
> -
> -	if (kvm_pmu_pmc_is_chained(pmc)) {
> -		pmc = kvm_pmu_get_canonical_pmc(pmc);
> -		reg = PMEVCNTR0_EL0 + pmc->idx;
> +	u64 counter, reg, enabled, running;
> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> +	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
>  
> -		counter = __vcpu_sys_reg(vcpu, reg);
> -		counter_high = __vcpu_sys_reg(vcpu, reg + 1);
> +	if (!kvm_vcpu_has_pmu(vcpu))
> +		return 0;
>  
> -		counter = lower_32_bits(counter) | (counter_high << 32);
> -	} else {
> -		reg = (pmc->idx == ARMV8_PMU_CYCLE_IDX)
> -		      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
> -		counter = __vcpu_sys_reg(vcpu, reg);
> -	}
> +	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
> +		? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
> +	counter = __vcpu_sys_reg(vcpu, reg);
>  
>  	/*
>  	 * The real counter value is equal to the value of counter register plus
> @@ -163,29 +95,7 @@ static u64 kvm_pmu_get_pair_counter_value(struct kvm_vcpu *vcpu,
>  		counter += perf_event_read_value(pmc->perf_event, &enabled,
>  						 &running);
>  
> -	return counter;
> -}
> -
> -/**
> - * kvm_pmu_get_counter_value - get PMU counter value
> - * @vcpu: The vcpu pointer
> - * @select_idx: The counter index
> - */
> -u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
> -{
> -	u64 counter;
> -	struct kvm_pmu *pmu = &vcpu->arch.pmu;
> -	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
> -
> -	if (!kvm_vcpu_has_pmu(vcpu))
> -		return 0;
> -
> -	counter = kvm_pmu_get_pair_counter_value(vcpu, pmc);
> -
> -	if (kvm_pmu_pmc_is_chained(pmc) &&
> -	    kvm_pmu_idx_is_high_counter(select_idx))
> -		counter = upper_32_bits(counter);
> -	else if (select_idx != ARMV8_PMU_CYCLE_IDX)
> +	if (select_idx != ARMV8_PMU_CYCLE_IDX)
>  		counter = lower_32_bits(counter);
>  
>  	return counter;
> @@ -218,7 +128,6 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
>   */
>  static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc)
>  {
> -	pmc = kvm_pmu_get_canonical_pmc(pmc);
>  	if (pmc->perf_event) {
>  		perf_event_disable(pmc->perf_event);
>  		perf_event_release_kernel(pmc->perf_event);
> @@ -236,11 +145,10 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
>  {
>  	u64 counter, reg, val;
>  
> -	pmc = kvm_pmu_get_canonical_pmc(pmc);
>  	if (!pmc->perf_event)
>  		return;
>  
> -	counter = kvm_pmu_get_pair_counter_value(vcpu, pmc);
> +	counter = kvm_pmu_get_counter_value(vcpu, pmc->idx);
>  
>  	if (pmc->idx == ARMV8_PMU_CYCLE_IDX) {
>  		reg = PMCCNTR_EL0;
> @@ -252,9 +160,6 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
>  
>  	__vcpu_sys_reg(vcpu, reg) = val;
>  
> -	if (kvm_pmu_pmc_is_chained(pmc))
> -		__vcpu_sys_reg(vcpu, reg + 1) = upper_32_bits(counter);
> -
>  	kvm_pmu_release_perf_event(pmc);
>  }
>  
> @@ -285,8 +190,6 @@ void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu)
>  
>  	for_each_set_bit(i, &mask, 32)
>  		kvm_pmu_stop_counter(vcpu, &pmu->pmc[i]);
> -
> -	bitmap_zero(vcpu->arch.pmu.chained, ARMV8_PMU_MAX_COUNTER_PAIRS);
>  }
>  
>  /**
> @@ -340,11 +243,8 @@ void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
>  
>  		pmc = &pmu->pmc[i];
>  
> -		/* A change in the enable state may affect the chain state */
> -		kvm_pmu_update_pmc_chained(vcpu, i);
>  		kvm_pmu_create_perf_event(vcpu, i);
>  
> -		/* At this point, pmc must be the canonical */
>  		if (pmc->perf_event) {
>  			perf_event_enable(pmc->perf_event);
>  			if (pmc->perf_event->state != PERF_EVENT_STATE_ACTIVE)
> @@ -375,11 +275,8 @@ void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
>  
>  		pmc = &pmu->pmc[i];
>  
> -		/* A change in the enable state may affect the chain state */
> -		kvm_pmu_update_pmc_chained(vcpu, i);
>  		kvm_pmu_create_perf_event(vcpu, i);
>  
> -		/* At this point, pmc must be the canonical */
>  		if (pmc->perf_event)
>  			perf_event_disable(pmc->perf_event);
>  	}
> @@ -484,6 +381,51 @@ static void kvm_pmu_perf_overflow_notify_vcpu(struct irq_work *work)
>  	kvm_vcpu_kick(vcpu);
>  }
>  
> +/*
> + * Perform an increment on any of the counters described in @mask,
> + * generating the overflow if required, and propagate it as a chained
> + * event if possible.
> + */
> +static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
> +				      unsigned long mask, u32 event)
> +{
> +	int i;
> +
> +	if (!kvm_vcpu_has_pmu(vcpu))
> +		return;
> +
> +	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E))
> +		return;
> +
> +	/* Weed out disabled counters */
> +	mask &= __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
> +
> +	for_each_set_bit(i, &mask, ARMV8_PMU_CYCLE_IDX) {
> +		u64 type, reg;

nit: replace 'reg' with 'counter' or 'val'. I think it might read better
as it avoids a collision with counter_index_to_reg()

It feels like this patch could be broken down a bit as I found myself
skipping around a bit. The s/pmc->idx/select_idx/ doesn't seem strictly
necessary to bake in with this patch, either. Nonetheless, the end
result looks good.

--
Thanks,
Oliver
