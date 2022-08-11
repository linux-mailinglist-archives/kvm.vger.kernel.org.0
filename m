Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 384545905A2
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 19:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236337AbiHKRRW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 13:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236414AbiHKRQr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 13:16:47 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 721FA9BB70
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 10:08:59 -0700 (PDT)
Date:   Thu, 11 Aug 2022 17:08:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660237737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pSXXX5nUGBzBxyOtlQFRi2au12HwbHuAwUkay+JOhFk=;
        b=i8ID265G5LbPTSjgsik7VQaFZdYZbVXju5Oj0XcCUmwZMahpvigNTk/+KzCJ+DowsgN8s9
        BOOU7sh2sc93Qvd1xHPdTU2rRUViOh/XxNwsn4lzy9ELSha6148xQNR5NrKms4cCmKs5fC
        YtHtXzAcd7QXRFnE7g/u6ik5kElABlw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com,
        suzuki.poulose@arm.com, will@kernel.org
Subject: Re: [PATCH 1/2] KVM: arm64: Treat PMCR_EL1.LC as RES1 on asymmetric
 systems
Message-ID: <YvU3putdfYdshcB5@google.com>
References: <20220811170221.3771048-1-oliver.upton@linux.dev>
 <20220811170221.3771048-2-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220811170221.3771048-2-oliver.upton@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 11, 2022 at 05:02:20PM +0000, Oliver Upton wrote:
> KVM does not support AArch32 on asymmetric systems. To that end, enforce
> AArch64-only behavior on PMCR_EL1.LC when on an asymmetric system.
> 
> Fixes: 2122a833316f ("arm64: Allow mismatched 32-bit EL0 support")
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/include/asm/kvm_host.h | 4 ++++
>  arch/arm64/kvm/arm.c              | 3 +--
>  arch/arm64/kvm/sys_regs.c         | 4 ++--
>  3 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index f38ef299f13b..e9c9388ccc02 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -929,6 +929,10 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
>  	(system_supports_mte() &&				\
>  	 test_bit(KVM_ARCH_FLAG_MTE_ENABLED, &(kvm)->arch.flags))
>  
> +#define kvm_supports_32bit_el0()				\
> +	(system_supports_32bit_el0() &&				\
> +	 !static_branch_unlikely(&arm64_mismatched_32bit_el0))
> +
>  int kvm_trng_call(struct kvm_vcpu *vcpu);
>  #ifdef CONFIG_KVM
>  extern phys_addr_t hyp_mem_base;
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 986cee6fbc7f..bef3849c564f 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -757,8 +757,7 @@ static bool vcpu_mode_is_bad_32bit(struct kvm_vcpu *vcpu)
>  	if (likely(!vcpu_mode_is_32bit(vcpu)))
>  		return false;
>  
> -	return !system_supports_32bit_el0() ||
> -		static_branch_unlikely(&arm64_mismatched_32bit_el0);
> +	return kvm_supports_32bit_el0();

Lol, promised this was lightly tested :) Read the patch once more, this
will need to be:

	return !kvm_supports_32bit_el0();

I'll fix it in v2 but will wait a bit for folks to review.

--
Thanks,
Oliver

>  }
>  
>  /**
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index c059b259aea6..3234f50b8c4b 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -652,7 +652,7 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  	 */
>  	val = ((pmcr & ~ARMV8_PMU_PMCR_MASK)
>  	       | (ARMV8_PMU_PMCR_MASK & 0xdecafbad)) & (~ARMV8_PMU_PMCR_E);
> -	if (!system_supports_32bit_el0())
> +	if (!kvm_supports_32bit_el0())
>  		val |= ARMV8_PMU_PMCR_LC;
>  	__vcpu_sys_reg(vcpu, r->reg) = val;
>  }
> @@ -701,7 +701,7 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  		val = __vcpu_sys_reg(vcpu, PMCR_EL0);
>  		val &= ~ARMV8_PMU_PMCR_MASK;
>  		val |= p->regval & ARMV8_PMU_PMCR_MASK;
> -		if (!system_supports_32bit_el0())
> +		if (!kvm_supports_32bit_el0())
>  			val |= ARMV8_PMU_PMCR_LC;
>  		__vcpu_sys_reg(vcpu, PMCR_EL0) = val;
>  		kvm_pmu_handle_pmcr(vcpu, val);
> -- 
> 2.37.1.559.g78731f0fdb-goog
> 
