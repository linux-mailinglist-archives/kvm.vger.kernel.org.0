Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1421B468A
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 15:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbgDVNqT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 09:46:19 -0400
Received: from foss.arm.com ([217.140.110.172]:50236 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgDVNqT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 09:46:19 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE6E531B;
        Wed, 22 Apr 2020 06:46:18 -0700 (PDT)
Received: from [10.37.12.172] (unknown [10.37.12.172])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6BEC03F68F;
        Wed, 22 Apr 2020 06:46:15 -0700 (PDT)
Subject: Re: [PATCH 02/26] KVM: arm64: Move __load_guest_stage2 to kvm_mmu.h
To:     maz@kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc:     andre.przywara@arm.com, christoffer.dall@arm.com,
        dave.martin@arm.com, jintack@cs.columbia.edu,
        alexandru.elisei@arm.com, gcherian@marvell.com,
        prime.zeng@hisilicon.com, will@kernel.org, catalin.marinas@arm.com,
        mark.rutland@arm.com, james.morse@arm.com,
        julien.thierry.kdev@gmail.com
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-3-maz@kernel.org>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <7bfefbb0-a467-3e43-6e22-466ae7184a1f@arm.com>
Date:   Wed, 22 Apr 2020 14:51:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20200422120050.3693593-3-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,


On 04/22/2020 01:00 PM, Marc Zyngier wrote:
> Having __load_guest_stage2 in kvm_hyp.h is quickly going to trigger
> a circular include problem. In order to avoid this, let's move
> it to kvm_mmu.h, where it will be a better fit anyway.
> 
> In the process, drop the __hyp_text annotation, which doesn't help
> as the function is marked as __always_inline.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

> ---
>   arch/arm64/include/asm/kvm_hyp.h | 18 ------------------
>   arch/arm64/include/asm/kvm_mmu.h | 17 +++++++++++++++++
>   2 files changed, 17 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> index fe57f60f06a89..dcb63bf941057 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -10,7 +10,6 @@
>   #include <linux/compiler.h>
>   #include <linux/kvm_host.h>
>   #include <asm/alternative.h>
> -#include <asm/kvm_mmu.h>
>   #include <asm/sysreg.h>
>   
>   #define __hyp_text __section(.hyp.text) notrace
> @@ -88,22 +87,5 @@ void deactivate_traps_vhe_put(void);
>   u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
>   void __noreturn __hyp_do_panic(unsigned long, ...);
>   
> -/*
> - * Must be called from hyp code running at EL2 with an updated VTTBR
> - * and interrupts disabled.
> - */
> -static __always_inline void __hyp_text __load_guest_stage2(struct kvm *kvm)
> -{
> -	write_sysreg(kvm->arch.vtcr, vtcr_el2);
> -	write_sysreg(kvm_get_vttbr(kvm), vttbr_el2);
> -
> -	/*
> -	 * ARM errata 1165522 and 1530923 require the actual execution of the
> -	 * above before we can switch to the EL1/EL0 translation regime used by
> -	 * the guest.
> -	 */
> -	asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT_VHE));
> -}
> -
>   #endif /* __ARM64_KVM_HYP_H__ */
>   
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 30b0e8d6b8953..5ba1310639ec6 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -604,5 +604,22 @@ static __always_inline u64 kvm_get_vttbr(struct kvm *kvm)
>   	return kvm_phys_to_vttbr(baddr) | vmid_field | cnp;
>   }
>   
> +/*
> + * Must be called from hyp code running at EL2 with an updated VTTBR
> + * and interrupts disabled.
> + */
> +static __always_inline void __load_guest_stage2(struct kvm *kvm)
> +{
> +	write_sysreg(kvm->arch.vtcr, vtcr_el2);
> +	write_sysreg(kvm_get_vttbr(kvm), vttbr_el2);
> +
> +	/*
> +	 * ARM erratum 1165522 requires the actual execution of the above

Is it intentional to drop the reference to errata 1530923 ?

Otherwise :

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>

