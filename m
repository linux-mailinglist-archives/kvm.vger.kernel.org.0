Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 674B358E7B3
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 09:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbiHJHQ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 03:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbiHJHQ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 03:16:26 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FFDE83F0A
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 00:16:23 -0700 (PDT)
Date:   Wed, 10 Aug 2022 02:16:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660115781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JWa6e+rnrdWvVoghcAxH/PdSCwzl60DGMbaxifj9l3w=;
        b=vPDXS2JEszGswRAoCeR8RTho3pkWnzCr8LueW/NbdjZwkLKHGCxND7PeLifwpHOr8qBvan
        WEkoI35UGv/1Jhf2HNYn+Nam2SD/dE6SRzLE7t3fr75ei95KKwLD9sU8OEf7hA3lXhabWM
        /nVc5FDL7adT3TWbCSS3nlkBaTUgDcc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Ricardo Koller <ricarkol@google.com>, kernel-team@android.com
Subject: Re: [PATCH 8/9] KVM: arm64: PMU: Implement PMUv3p5 long counter
 support
Message-ID: <YvNbPm7WAhUCRkx/@google.com>
References: <20220805135813.2102034-1-maz@kernel.org>
 <20220805135813.2102034-9-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805135813.2102034-9-maz@kernel.org>
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

On Fri, Aug 05, 2022 at 02:58:12PM +0100, Marc Zyngier wrote:
> PMUv3p5 (which is mandatory with ARMv8.5) comes with some extra
> features:
> 
> - All counters are 64bit
> 
> - The overflow point is controlled by the PMCR_EL0.LP bit
> 
> Add the required checks in the helpers that control counter
> width and overflow, as well as the sysreg handling for the LP
> bit. A new kvm_pmu_is_3p5() helper makes it easy to spot the
> PMUv3p5 specific handling.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/pmu-emul.c | 8 +++++---
>  arch/arm64/kvm/sys_regs.c | 4 ++++
>  include/kvm/arm_pmu.h     | 8 ++++++++
>  3 files changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index 33a88ca7b7fd..b33a2953cbf6 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -50,13 +50,15 @@ static u32 kvm_pmu_event_mask(struct kvm *kvm)
>   */
>  static bool kvm_pmu_idx_is_64bit(struct kvm_vcpu *vcpu, u64 select_idx)
>  {
> -	return (select_idx == ARMV8_PMU_CYCLE_IDX);
> +	return (select_idx == ARMV8_PMU_CYCLE_IDX || kvm_pmu_is_3p5(vcpu));
>  }
>  
>  static bool kvm_pmu_idx_has_64bit_overflow(struct kvm_vcpu *vcpu, u64 select_idx)
>  {
> -	return (select_idx == ARMV8_PMU_CYCLE_IDX &&
> -		__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_LC);
> +	u64 val = __vcpu_sys_reg(vcpu, PMCR_EL0);
> +
> +	return (select_idx < ARMV8_PMU_CYCLE_IDX && (val & ARMV8_PMU_PMCR_LP)) ||
> +	       (select_idx == ARMV8_PMU_CYCLE_IDX && (val & ARMV8_PMU_PMCR_LC));
>  }
>  
>  static bool kvm_pmu_counter_can_chain(struct kvm_vcpu *vcpu, u64 idx)
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index c0595f31dab8..2b5e0ec5c100 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -654,6 +654,8 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  	       | (ARMV8_PMU_PMCR_MASK & 0xdecafbad)) & (~ARMV8_PMU_PMCR_E);
>  	if (!system_supports_32bit_el0())
>  		val |= ARMV8_PMU_PMCR_LC;
> +	if (!kvm_pmu_is_3p5(vcpu))
> +		val &= ~ARMV8_PMU_PMCR_LP;
>  	__vcpu_sys_reg(vcpu, r->reg) = val;
>  }
>  
> @@ -703,6 +705,8 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  		val |= p->regval & ARMV8_PMU_PMCR_MASK;
>  		if (!system_supports_32bit_el0())
>  			val |= ARMV8_PMU_PMCR_LC;
> +		if (!kvm_pmu_is_3p5(vcpu))
> +			val &= ~ARMV8_PMU_PMCR_LP;
>  		__vcpu_sys_reg(vcpu, PMCR_EL0) = val;
>  		kvm_pmu_handle_pmcr(vcpu, val);
>  		kvm_vcpu_pmu_restore_guest(vcpu);
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 6bda9b071084..846502251923 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -89,6 +89,13 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
>  			vcpu->arch.pmu.events = *kvm_get_pmu_events();	\
>  	} while (0)
>  
> +/*
> + * Evaluates as true when emulating PMUv3p5, and false otherwise.
> + */
> +#define kvm_pmu_is_3p5(vcpu)						\
> +	(vcpu->kvm->arch.dfr0_pmuver >= ID_AA64DFR0_PMUVER_8_5 &&	\
> +	 vcpu->kvm->arch.dfr0_pmuver != ID_AA64DFR0_PMUVER_IMP_DEF)

I don't believe the IMP_DEF condition will ever evaluate to false as
dfr0_pmuver is sanitized at initialization and writes from userspace.

>  u8 kvm_arm_pmu_get_host_pmuver(void);
>  
>  #else
> @@ -153,6 +160,7 @@ static inline u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
>  }
>  
>  #define kvm_vcpu_has_pmu(vcpu)		({ false; })
> +#define kvm_pmu_is_3p5(vcpu)		({ false; })
>  static inline void kvm_pmu_update_vcpu_events(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu) {}
> -- 
> 2.34.1
> 
