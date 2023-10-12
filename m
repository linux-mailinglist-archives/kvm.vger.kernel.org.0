Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 200DF7C7190
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 17:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379202AbjJLPdX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 11:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbjJLPdW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 11:33:22 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B7BE4B8
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 08:33:19 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6598D13D5;
        Thu, 12 Oct 2023 08:33:59 -0700 (PDT)
Received: from [10.57.3.94] (unknown [10.57.3.94])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4B3933F7A6;
        Thu, 12 Oct 2023 08:33:17 -0700 (PDT)
Message-ID: <c0c89e79-3fed-7207-8ae1-f84cb461d98e@arm.com>
Date:   Thu, 12 Oct 2023 16:33:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH 2/2] KVM: arm64: Treat PMEVTYPER<n>_EL0.NSH as RES0
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        James Clark <james.clark@arm.com>
References: <20231011081649.3226792-1-oliver.upton@linux.dev>
 <20231011081649.3226792-3-oliver.upton@linux.dev>
 <24d7dda6-888c-141e-3aa0-9319987360d7@arm.com> <ZSbKiXY-LAsfRdlD@linux.dev>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <ZSbKiXY-LAsfRdlD@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/10/2023 17:17, Oliver Upton wrote:
> On Wed, Oct 11, 2023 at 01:33:16PM +0100, Suzuki K Poulose wrote:
> 
> [...]
> 
>> However, I think we are missing the support for a guest using the
>> combination of PMEVTYPER.NS{K/U} instead of the PMEVTYPER.{P/U} for
>> filtering the events. As per Arm ARM, it is permitted to use the
>> PMEVTYPER.NSK/U (leaving PMEVTYPER.{P,U} == 0) for filtering in Non-Secure
>> EL1.
> 
> Ah, good eye. The pseudocode is easy enough to rip off, something like
> the below diff would get things going. There's an extra step of making
> these bits RES0 if EL3 isn't present in the guest's ID register values,
> but not a huge deal.

True, the change below looks good to me. Thanks for addressing this.

Suzuki

> 
>> Anyways, for this patch:
>>
>> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com?
> 
> Thanks!
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 087764435390..b6df9ba39940 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -585,6 +585,7 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
>   	struct perf_event *event;
>   	struct perf_event_attr attr;
>   	u64 eventsel, reg, data;
> +	bool p, u, nsk, nsu;
>   
>   	reg = counter_index_to_evtreg(pmc->idx);
>   	data = __vcpu_sys_reg(vcpu, reg);
> @@ -611,13 +612,18 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
>   	    !test_bit(eventsel, vcpu->kvm->arch.pmu_filter))
>   		return;
>   
> +	p = data & ARMV8_PMU_EXCLUDE_EL1;
> +	u = data & ARMV8_PMU_EXCLUDE_EL0;
> +	nsk = data & ARMV8_PMU_EXCLUDE_NS_EL1;
> +	nsu = data & ARMV8_PMU_EXCLUDE_NS_EL0;
> +
>   	memset(&attr, 0, sizeof(struct perf_event_attr));
>   	attr.type = arm_pmu->pmu.type;
>   	attr.size = sizeof(attr);
>   	attr.pinned = 1;
>   	attr.disabled = !kvm_pmu_counter_is_enabled(pmc);
> -	attr.exclude_user = data & ARMV8_PMU_EXCLUDE_EL0 ? 1 : 0;
> -	attr.exclude_kernel = data & ARMV8_PMU_EXCLUDE_EL1 ? 1 : 0;
> +	attr.exclude_user = (u != nsu);
> +	attr.exclude_kernel = (p != nsk);
>   	attr.exclude_hv = 1; /* Don't count EL2 events */
>   	attr.exclude_host = 1; /* Don't count host events */
>   	attr.config = eventsel;
> @@ -663,7 +669,8 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>   	if (!kvm_vcpu_has_pmu(vcpu))
>   		return;
>   
> -	mask = ARMV8_PMU_EXCLUDE_EL1 | ARMV8_PMU_EXCLUDE_EL0;
> +	mask = ARMV8_PMU_EXCLUDE_EL1 | ARMV8_PMU_EXCLUDE_EL0 |
> +	       ARMV8_PMU_EXCLUDE_NS_EL1 | ARMV8_PMU_EXCLUDE_NS_EL0;
>   	mask |= kvm_pmu_event_mask(vcpu->kvm);
>   
>   	reg = counter_index_to_evtreg(pmc->idx);
> diff --git a/include/linux/perf/arm_pmuv3.h b/include/linux/perf/arm_pmuv3.h
> index 753f8dbd9d10..872119cc2bac 100644
> --- a/include/linux/perf/arm_pmuv3.h
> +++ b/include/linux/perf/arm_pmuv3.h
> @@ -235,9 +235,11 @@
>   /*
>    * Event filters for PMUv3
>    */
> -#define ARMV8_PMU_EXCLUDE_EL1	(1U << 31)
> -#define ARMV8_PMU_EXCLUDE_EL0	(1U << 30)
> -#define ARMV8_PMU_INCLUDE_EL2	(1U << 27)
> +#define ARMV8_PMU_EXCLUDE_EL1		(1U << 31)
> +#define ARMV8_PMU_EXCLUDE_EL0		(1U << 30)
> +#define ARMV8_PMU_EXCLUDE_NS_EL1	(1U << 29)
> +#define ARMV8_PMU_EXCLUDE_NS_EL0	(1U << 28)
> +#define ARMV8_PMU_INCLUDE_EL2		(1U << 27)
>   
>   /*
>    * PMUSERENR: user enable reg

