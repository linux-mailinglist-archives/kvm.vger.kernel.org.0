Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32D23D7D2B
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 20:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhG0SLv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 14:11:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229453AbhG0SLv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 14:11:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC23860238;
        Tue, 27 Jul 2021 18:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627409510;
        bh=q1CHfyk12vw4U1T20eDp/l4diZTpTmt1XveN+HsNvZc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SCpJSpyuVKJ48axoUhFScqf5GQrNcRTW7Gtnaj1EJYMEX8Gb0MkvbRJtuQez0w5vG
         btoxnHcjX+fWlo643xBBvL7U5CIQUVUOk3c1XUal0tjMpLnr+xe0XyjEqy5/9sqfyL
         Pt9y9IdexKHL0V2Li9zb+qr6LGHm+8NnVQGy9n6uq4/jIbCKsJONjWpww/Qknz3jnp
         2hZbxFoRzkPp18BGYNFxz+JqpUYzF0BYhpL/AfOZnh+Hit/ODIYCDjp2ROAQVw2onu
         1ZHnF6cvqaf0ZkK1Kdl/sNHT1DBIQ8PrryiofhODctOwl9BWzfqnWUxI5AyTe79ooM
         HqVQ0KjFrDUxw==
Date:   Tue, 27 Jul 2021 19:11:46 +0100
From:   Will Deacon <will@kernel.org>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        qperret@google.com, dbrazdil@google.com,
        Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 07/16] KVM: arm64: Wire MMIO guard hypercalls
Message-ID: <20210727181145.GF19173@willie-the-truck>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-8-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210715163159.1480168-8-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 15, 2021 at 05:31:50PM +0100, Marc Zyngier wrote:
> Plumb in the hypercall interface to allow a guest to discover,
> enroll, map and unmap MMIO regions.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hypercalls.c | 20 ++++++++++++++++++++
>  include/linux/arm-smccc.h   | 28 ++++++++++++++++++++++++++++
>  2 files changed, 48 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index 30da78f72b3b..a3deeb907fdd 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -5,6 +5,7 @@
>  #include <linux/kvm_host.h>
>  
>  #include <asm/kvm_emulate.h>
> +#include <asm/kvm_mmu.h>
>  
>  #include <kvm/arm_hypercalls.h>
>  #include <kvm/arm_psci.h>
> @@ -129,10 +130,29 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
>  		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
>  		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_PTP);
> +		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MMIO_GUARD_INFO);
> +		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MMIO_GUARD_ENROLL);
> +		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MMIO_GUARD_MAP);
> +		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_MMIO_GUARD_UNMAP);
>  		break;
>  	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
>  		kvm_ptp_get_time(vcpu, val);
>  		break;
> +	case ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_INFO_FUNC_ID:
> +		val[0] = PAGE_SIZE;
> +		break;

I get the nagging feeling that querying the stage-2 page-size outside of
MMIO guard is going to be useful once we start looking at memory sharing,
so perhaps rename this to something more generic?

> +	case ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_ENROLL_FUNC_ID:
> +		set_bit(KVM_ARCH_FLAG_MMIO_GUARD, &vcpu->kvm->arch.flags);
> +		val[0] = SMCCC_RET_SUCCESS;
> +		break;
> +	case ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_MAP_FUNC_ID:
> +		if (kvm_install_ioguard_page(vcpu, vcpu_get_reg(vcpu, 1)))
> +			val[0] = SMCCC_RET_SUCCESS;
> +		break;
> +	case ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_UNMAP_FUNC_ID:
> +		if (kvm_remove_ioguard_page(vcpu, vcpu_get_reg(vcpu, 1)))
> +			val[0] = SMCCC_RET_SUCCESS;
> +		break;

I think there's a slight discrepancy between MAP and UNMAP here in that
calling UNMAP on something that hasn't been mapped will fail, whereas
calling MAP on something that's already been mapped will succeed. I think
that might mean you can't reason about the final state of the page if two
vCPUs race to call these functions in some cases (and both succeed).

Will
