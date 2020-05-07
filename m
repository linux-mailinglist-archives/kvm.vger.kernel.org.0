Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE9661C888A
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 13:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725969AbgEGLln (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 07:41:43 -0400
Received: from foss.arm.com ([217.140.110.172]:57378 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbgEGLln (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 07:41:43 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 67A991FB;
        Thu,  7 May 2020 04:41:42 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6DA9D3F68F;
        Thu,  7 May 2020 04:41:40 -0700 (PDT)
Subject: Re: [PATCH 01/26] KVM: arm64: Check advertised Stage-2 page size
 capability
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-2-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <f2de215f-2ad4-da04-36ab-8932d35abba6@arm.com>
Date:   Thu, 7 May 2020 12:42:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200422120050.3693593-2-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 4/22/20 1:00 PM, Marc Zyngier wrote:
> With ARMv8.5-GTG, the hardware (or more likely a hypervisor) can
> advertise the supported Stage-2 page sizes.
>
> Let's check this at boot time.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_host.h |  2 +-
>  arch/arm64/include/asm/sysreg.h   |  3 +++
>  arch/arm64/kernel/cpufeature.c    |  8 +++++++
>  arch/arm64/kvm/reset.c            | 40 ++++++++++++++++++++++++++++---
>  virt/kvm/arm/arm.c                |  4 +---
>  5 files changed, 50 insertions(+), 7 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 32c8a675e5a4a..7dd8fefa6aecd 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -670,7 +670,7 @@ static inline int kvm_arm_have_ssbd(void)
>  void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu);
>  void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu);
>  
> -void kvm_set_ipa_limit(void);
> +int kvm_set_ipa_limit(void);
>  
>  #define __KVM_HAVE_ARCH_VM_ALLOC
>  struct kvm *kvm_arch_alloc_vm(void);
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index ebc6224328318..5d10c9148e844 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -686,6 +686,9 @@
>  #define ID_AA64ZFR0_SVEVER_SVE2		0x1
>  
>  /* id_aa64mmfr0 */
> +#define ID_AA64MMFR0_TGRAN4_2_SHIFT	40
> +#define ID_AA64MMFR0_TGRAN64_2_SHIFT	36
> +#define ID_AA64MMFR0_TGRAN16_2_SHIFT	32
>  #define ID_AA64MMFR0_TGRAN4_SHIFT	28
>  #define ID_AA64MMFR0_TGRAN64_SHIFT	24
>  #define ID_AA64MMFR0_TGRAN16_SHIFT	20
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 9fac745aa7bb2..9892a845d06c9 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -208,6 +208,14 @@ static const struct arm64_ftr_bits ftr_id_aa64zfr0[] = {
>  };
>  
>  static const struct arm64_ftr_bits ftr_id_aa64mmfr0[] = {
> +	/*
> +	 * Page size not being supported at Stage-2 are not fatal. You

s/are not fatal/is not fatal

> +	 * just give up KVM if PAGE_SIZE isn't supported there. Go fix
> +	 * your favourite nesting hypervisor.
> +	 */
> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_EXACT, ID_AA64MMFR0_TGRAN4_2_SHIFT, 4, 1),
> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_EXACT, ID_AA64MMFR0_TGRAN64_2_SHIFT, 4, 1),
> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_EXACT, ID_AA64MMFR0_TGRAN16_2_SHIFT, 4, 1),
>  	/*
>  	 * We already refuse to boot CPUs that don't support our configured
>  	 * page size, so we can only detect mismatches for a page size other
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 30b7ea680f66c..241db35a7ef4f 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -9,6 +9,7 @@
>   */
>  
>  #include <linux/errno.h>
> +#include <linux/bitfield.h>
>  #include <linux/kernel.h>
>  #include <linux/kvm_host.h>
>  #include <linux/kvm.h>
> @@ -340,11 +341,42 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  	return ret;
>  }
>  
> -void kvm_set_ipa_limit(void)
> +int kvm_set_ipa_limit(void)
>  {
> -	unsigned int ipa_max, pa_max, va_max, parange;
> +	unsigned int ipa_max, pa_max, va_max, parange, tgran_2;
> +	u64 mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
>  
> -	parange = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1) & 0x7;
> +	/*
> +	 * Check with ARMv8.5-GTG that our PAGE_SIZE is supported at
> +	 * Stage-2. If not, things will stop very quickly.
> +	 */
> +	switch (PAGE_SIZE) {
> +	default:
> +	case SZ_4K:
> +		tgran_2 = ID_AA64MMFR0_TGRAN4_2_SHIFT;
> +		break;
> +	case SZ_16K:
> +		tgran_2 = ID_AA64MMFR0_TGRAN16_2_SHIFT;
> +		break;
> +	case SZ_64K:
> +		tgran_2 = ID_AA64MMFR0_TGRAN64_2_SHIFT;
> +		break;
> +	}
> +
> +	switch (FIELD_GET(0xFUL << tgran_2, mmfr0)) {
> +	default:
> +	case 1:
> +		kvm_err("PAGE_SIZE not supported at Stage-2, giving up\n");
> +		return -EINVAL;
> +	case 0:
> +		kvm_debug("PAGE_SIZE supported at Stage-2 (default)\n");
> +		break;
> +	case 2:
> +		kvm_debug("PAGE_SIZE supported at Stage-2 (advertised)\n");
> +		break;
> +	}
> +
> +	parange = mmfr0 & 0x7;
>  	pa_max = id_aa64mmfr0_parange_to_phys_shift(parange);
>  
>  	/* Clamp the IPA limit to the PA size supported by the kernel */
> @@ -378,6 +410,8 @@ void kvm_set_ipa_limit(void)
>  	     "KVM IPA limit (%d bit) is smaller than default size\n", ipa_max);
>  	kvm_ipa_limit = ipa_max;
>  	kvm_info("IPA Size Limit: %dbits\n", kvm_ipa_limit);
> +
> +	return 0;
>  }
>  
>  /*
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 48d0ec44ad77e..53b3ba9173ba7 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -1387,9 +1387,7 @@ static inline void hyp_cpu_pm_exit(void)
>  
>  static int init_common_resources(void)
>  {
> -	kvm_set_ipa_limit();
> -
> -	return 0;
> +	return kvm_set_ipa_limit();
>  }
>  
>  static int init_subsystems(void)

For what is worth, I've taken a look at the ARMv8.5-GTG spec and your patch looks
fine to me:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex
