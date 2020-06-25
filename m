Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2544620A2CA
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 18:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406078AbgFYQYG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 12:24:06 -0400
Received: from foss.arm.com ([217.140.110.172]:33216 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406074AbgFYQYG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 12:24:06 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 248191FB;
        Thu, 25 Jun 2020 09:24:05 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E75FA3F6CF;
        Thu, 25 Jun 2020 09:24:02 -0700 (PDT)
Subject: Re: [PATCH v2 04/17] arm64: Add level-hinted TLB invalidation helper
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Andrew Scull <ascull@google.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
References: <20200615132719.1932408-1-maz@kernel.org>
 <20200615132719.1932408-5-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <89d18c52-f3ee-8286-9353-1cd28226984a@arm.com>
Date:   Thu, 25 Jun 2020 17:24:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200615132719.1932408-5-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 6/15/20 2:27 PM, Marc Zyngier wrote:
> Add a level-hinted TLB invalidation helper that only gets used if
> ARMv8.4-TTL gets detected.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/stage2_pgtable.h |  9 +++++
>  arch/arm64/include/asm/tlbflush.h       | 45 +++++++++++++++++++++++++
>  2 files changed, 54 insertions(+)
>
> diff --git a/arch/arm64/include/asm/stage2_pgtable.h b/arch/arm64/include/asm/stage2_pgtable.h
> index b767904f28b1..996bf98f0cab 100644
> --- a/arch/arm64/include/asm/stage2_pgtable.h
> +++ b/arch/arm64/include/asm/stage2_pgtable.h
> @@ -256,4 +256,13 @@ stage2_pgd_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
>  	return (boundary - 1 < end - 1) ? boundary : end;
>  }
>  
> +/*
> + * Level values for the ARMv8.4-TTL extension, mapping PUD/PMD/PTE and
> + * the architectural page-table level.
> + */
> +#define S2_NO_LEVEL_HINT	0
> +#define S2_PUD_LEVEL		1
> +#define S2_PMD_LEVEL		2
> +#define S2_PTE_LEVEL		3
> +
>  #endif	/* __ARM64_S2_PGTABLE_H_ */
> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
> index bc3949064725..e05c31fd0bbc 100644
> --- a/arch/arm64/include/asm/tlbflush.h
> +++ b/arch/arm64/include/asm/tlbflush.h
> @@ -10,6 +10,7 @@
>  
>  #ifndef __ASSEMBLY__
>  
> +#include <linux/bitfield.h>
>  #include <linux/mm_types.h>
>  #include <linux/sched.h>
>  #include <asm/cputype.h>
> @@ -59,6 +60,50 @@
>  		__ta;						\
>  	})
>  
> +/*
> + * Level-based TLBI operations.
> + *
> + * When ARMv8.4-TTL exists, TLBI operations take an additional hint for
> + * the level at which the invalidation must take place. If the level is
> + * wrong, no invalidation may take place. In the case where the level
> + * cannot be easily determined, a 0 value for the level parameter will
> + * perform a non-hinted invalidation.
> + *
> + * For Stage-2 invalidation, use the level values provided to that effect
> + * in asm/stage2_pgtable.h.
> + */
> +#define TLBI_TTL_MASK		GENMASK_ULL(47, 44)
> +#define TLBI_TTL_PS_4K		1
> +#define TLBI_TTL_PS_16K		2
> +#define TLBI_TTL_PS_64K		3

The Arm ARM likes to call those translation granules, so maybe we can use TG
instead of PS to be aligned with the field names in TCR/VTCR? Just a suggestion in
case you think it works better than PS, otherwise feel free to ignore it.

> +
> +#define __tlbi_level(op, addr, level)					\
> +	do {								\
> +		u64 arg = addr;						\
> +									\
> +		if (cpus_have_const_cap(ARM64_HAS_ARMv8_4_TTL) &&	\
> +		    level) {						\
> +			u64 ttl = level & 3;				\
> +									\
> +			switch (PAGE_SIZE) {				\
> +			case SZ_4K:					\
> +				ttl |= TLBI_TTL_PS_4K << 2;		\
> +				break;					\
> +			case SZ_16K:					\
> +				ttl |= TLBI_TTL_PS_16K << 2;		\
> +				break;					\
> +			case SZ_64K:					\
> +				ttl |= TLBI_TTL_PS_64K << 2;		\
> +				break;					\
> +			}						\
> +									\
> +			arg &= ~TLBI_TTL_MASK;				\
> +			arg |= FIELD_PREP(TLBI_TTL_MASK, ttl);		\
> +		}							\
> +									\
> +		__tlbi(op, arg);					\
> +	} while(0)
> +
>  /*
>   *	TLB Invalidation
>   *	================

I like the fact that defines are now used. I checked against Arm ARM, pages
D5-2673 and D5-2674, and the granule size and the table level fields match, so:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex
