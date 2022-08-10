Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E3758E7B9
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 09:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbiHJHSB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 03:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiHJHSA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 03:18:00 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9590F7B786
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 00:17:59 -0700 (PDT)
Date:   Wed, 10 Aug 2022 02:17:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660115878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4H6aplbdkM4J5SGx/3gsDNjblU9QVtypMaeGnaAIAsc=;
        b=Kg0/4Sk1YnCkQ/m1F3VPGNCCGYkUYC+3E74SiJobSJy96DnV3wqQc27acsaWcCNHYXI6l8
        niUBIRVXi0zUfFRrJQ2PmaglNZqAnasR8nTowkmZpU6q5VZLwu3YBjyI0SrwWIpXApjeAc
        xvnPg6HGSLtzeSVIx3UjtAS5QaJrb1k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Ricardo Koller <ricarkol@google.com>, kernel-team@android.com
Subject: Re: [PATCH 4/9] KVM: arm64: PMU: Add counter_index_to_*reg() helpers
Message-ID: <YvNboA7nla0NcKwa@google.com>
References: <20220805135813.2102034-1-maz@kernel.org>
 <20220805135813.2102034-5-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805135813.2102034-5-maz@kernel.org>
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

On Fri, Aug 05, 2022 at 02:58:08PM +0100, Marc Zyngier wrote:
> In order to reduce the boilerplate code, add two helpers returning
> the counter register index (resp. the event register) in the vcpu
> register file from the counter index.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

> ---
>  arch/arm64/kvm/pmu-emul.c | 27 +++++++++++++++------------
>  1 file changed, 15 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 0ab6f59f433c..9be485d23416 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -75,6 +75,16 @@ static struct kvm_vcpu *kvm_pmc_to_vcpu(struct kvm_pmc *pmc)
>  	return container_of(vcpu_arch, struct kvm_vcpu, arch);
>  }
>  
> +static u32 counter_index_to_reg(u64 idx)
> +{
> +	return (idx == ARMV8_PMU_CYCLE_IDX) ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + idx;
> +}
> +
> +static u32 counter_index_to_evtreg(u64 idx)
> +{
> +	return (idx == ARMV8_PMU_CYCLE_IDX) ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + idx;
> +}
> +
>  /**
>   * kvm_pmu_get_counter_value - get PMU counter value
>   * @vcpu: The vcpu pointer
> @@ -89,8 +99,7 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
>  	if (!kvm_vcpu_has_pmu(vcpu))
>  		return 0;
>  
> -	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
> -		? PMCCNTR_EL0 : PMEVCNTR0_EL0 + pmc->idx;
> +	reg = counter_index_to_reg(select_idx);
>  	counter = __vcpu_sys_reg(vcpu, reg);
>  
>  	/*
> @@ -120,8 +129,7 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
>  	if (!kvm_vcpu_has_pmu(vcpu))
>  		return;
>  
> -	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
> -	      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
> +	reg = counter_index_to_reg(select_idx);
>  	__vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
>  
>  	/* Recreate the perf event to reflect the updated sample_period */
> @@ -156,10 +164,7 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
>  
>  	counter = kvm_pmu_get_counter_value(vcpu, pmc->idx);
>  
> -	if (pmc->idx == ARMV8_PMU_CYCLE_IDX)
> -		reg = PMCCNTR_EL0;
> -	else
> -		reg = PMEVCNTR0_EL0 + pmc->idx;
> +	reg = counter_index_to_reg(pmc->idx);
>  
>  	if (!kvm_pmu_idx_is_64bit(vcpu, pmc->idx))
>  		counter = lower_32_bits(counter);
> @@ -540,8 +545,7 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
>  	struct perf_event_attr attr;
>  	u64 eventsel, counter, reg, data;
>  
> -	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
> -	      ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + pmc->idx;
> +	reg = counter_index_to_evtreg(select_idx);
>  	data = __vcpu_sys_reg(vcpu, reg);
>  
>  	kvm_pmu_stop_counter(vcpu, pmc);
> @@ -627,8 +631,7 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>  	mask &= ~ARMV8_PMU_EVTYPE_EVENT;
>  	mask |= kvm_pmu_event_mask(vcpu->kvm);
>  
> -	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
> -	      ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + select_idx;
> +	reg = counter_index_to_evtreg(select_idx);
>  
>  	__vcpu_sys_reg(vcpu, reg) = data & mask;
>  
> -- 
> 2.34.1
> 
