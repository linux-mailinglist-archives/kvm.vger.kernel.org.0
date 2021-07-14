Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8253C8865
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 18:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbhGNQNx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jul 2021 12:13:53 -0400
Received: from foss.arm.com ([217.140.110.172]:36594 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231480AbhGNQNw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jul 2021 12:13:52 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9B666D6E;
        Wed, 14 Jul 2021 09:11:00 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 206BC3F7D8;
        Wed, 14 Jul 2021 09:10:57 -0700 (PDT)
Subject: Re: [PATCH 2/3] KVM: arm64: Drop unnecessary masking of PMU registers
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Robin Murphy <robin.murphy@arm.com>, kernel-team@android.com
References: <20210713135900.1473057-1-maz@kernel.org>
 <20210713135900.1473057-3-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <e67684f9-e5df-072c-b6ac-f5adecfeb260@arm.com>
Date:   Wed, 14 Jul 2021 17:12:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210713135900.1473057-3-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 7/13/21 2:58 PM, Marc Zyngier wrote:
> We always sanitise our PMU sysreg on the write side, so there
> is no need to do it on the read side as well.
>
> Drop the unnecessary masking.

Checked for all the remaining uses of kvm_pmu_valid_counter_mask in sys_regs.c and
in pmu-emul.c, and nothing stands out:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/pmu-emul.c | 3 +--
>  arch/arm64/kvm/sys_regs.c | 6 +++---
>  2 files changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index f33825c995cb..fae4e95b586c 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -373,7 +373,6 @@ static u64 kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
>  		reg = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
>  		reg &= __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
>  		reg &= __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
> -		reg &= kvm_pmu_valid_counter_mask(vcpu);
>  	}
>  
>  	return reg;
> @@ -569,7 +568,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
>  
>  	if (val & ARMV8_PMU_PMCR_E) {
>  		kvm_pmu_enable_counter_mask(vcpu,
> -		       __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask);
> +		       __vcpu_sys_reg(vcpu, PMCNTENSET_EL0));
>  	} else {
>  		kvm_pmu_disable_counter_mask(vcpu, mask);
>  	}
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 95ccb8f45409..7ead93a8d67f 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -883,7 +883,7 @@ static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  			kvm_pmu_disable_counter_mask(vcpu, val);
>  		}
>  	} else {
> -		p->regval = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask;
> +		p->regval = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
>  	}
>  
>  	return true;
> @@ -907,7 +907,7 @@ static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  			/* accessing PMINTENCLR_EL1 */
>  			__vcpu_sys_reg(vcpu, PMINTENSET_EL1) &= ~val;
>  	} else {
> -		p->regval = __vcpu_sys_reg(vcpu, PMINTENSET_EL1) & mask;
> +		p->regval = __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
>  	}
>  
>  	return true;
> @@ -929,7 +929,7 @@ static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  			/* accessing PMOVSCLR_EL0 */
>  			__vcpu_sys_reg(vcpu, PMOVSSET_EL0) &= ~(p->regval & mask);
>  	} else {
> -		p->regval = __vcpu_sys_reg(vcpu, PMOVSSET_EL0) & mask;
> +		p->regval = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
>  	}
>  
>  	return true;
