Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4FD31BA927
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 17:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727905AbgD0PuN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 11:50:13 -0400
Received: from foss.arm.com ([217.140.110.172]:37330 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727006AbgD0PuN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 11:50:13 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 927BC31B;
        Mon, 27 Apr 2020 08:50:12 -0700 (PDT)
Received: from [10.37.12.144] (unknown [10.37.12.144])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A5DB53F68F;
        Mon, 27 Apr 2020 08:50:08 -0700 (PDT)
Subject: Re: [PATCH 04/26] arm64: Detect the ARMv8.4 TTL feature
To:     maz@kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc:     andre.przywara@arm.com, christoffer.dall@arm.com,
        dave.martin@arm.com, jintack@cs.columbia.edu,
        alexandru.elisei@arm.com, gcherian@marvell.com,
        prime.zeng@hisilicon.com, will@kernel.org, catalin.marinas@arm.com,
        mark.rutland@arm.com, james.morse@arm.com,
        julien.thierry.kdev@gmail.com
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-5-maz@kernel.org>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <d6032191-ba0e-82a4-4dde-11beef369a11@arm.com>
Date:   Mon, 27 Apr 2020 16:55:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <20200422120050.3693593-5-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/22/2020 01:00 PM, Marc Zyngier wrote:
> In order to reduce the cost of TLB invalidation, the ARMv8.4 TTL
> feature allows TLBs to be issued with a level allowing for quicker
> invalidation.
> 
> Let's detect the feature for now. Further patches will implement
> its actual usage.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---


>   arch/arm64/include/asm/cpucaps.h |  3 ++-
>   arch/arm64/include/asm/sysreg.h  |  1 +
>   arch/arm64/kernel/cpufeature.c   | 11 +++++++++++
>   3 files changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
> index 8eb5a088ae658..cabb0c49a1d11 100644
> --- a/arch/arm64/include/asm/cpucaps.h
> +++ b/arch/arm64/include/asm/cpucaps.h
> @@ -61,7 +61,8 @@
>   #define ARM64_HAS_AMU_EXTN			51
>   #define ARM64_HAS_ADDRESS_AUTH			52
>   #define ARM64_HAS_GENERIC_AUTH			53
> +#define ARM64_HAS_ARMv8_4_TTL			54
>   
> -#define ARM64_NCAPS				54
> +#define ARM64_NCAPS				55
>   
>   #endif /* __ASM_CPUCAPS_H */
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 5d10c9148e844..79cf186b7e471 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -726,6 +726,7 @@
>   
>   /* id_aa64mmfr2 */
>   #define ID_AA64MMFR2_E0PD_SHIFT		60
> +#define ID_AA64MMFR2_TTL_SHIFT		48
>   #define ID_AA64MMFR2_FWB_SHIFT		40
>   #define ID_AA64MMFR2_AT_SHIFT		32
>   #define ID_AA64MMFR2_LVA_SHIFT		16
> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
> index 9892a845d06c9..d8ab4f1e93bee 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c
> @@ -252,6 +252,7 @@ static const struct arm64_ftr_bits ftr_id_aa64mmfr1[] = {
>   
>   static const struct arm64_ftr_bits ftr_id_aa64mmfr2[] = {
>   	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64MMFR2_E0PD_SHIFT, 4, 0),
> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR2_TTL_SHIFT, 4, 0),
>   	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR2_FWB_SHIFT, 4, 0),
>   	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR2_AT_SHIFT, 4, 0),
>   	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR2_LVA_SHIFT, 4, 0),
> @@ -1630,6 +1631,16 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>   		.matches = has_cpuid_feature,
>   		.cpu_enable = cpu_has_fwb,
>   	},
> +	{
> +		.desc = "ARMv8.4 Translation Table Level",
> +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
> +		.capability = ARM64_HAS_ARMv8_4_TTL,
> +		.sys_reg = SYS_ID_AA64MMFR2_EL1,
> +		.sign = FTR_UNSIGNED,
> +		.field_pos = ID_AA64MMFR2_TTL_SHIFT,
> +		.min_field_value = 1,
> +		.matches = has_cpuid_feature,
> +	},

Reviewed-by : Suzuki K Polose <suzuki.poulose@arm.com>
