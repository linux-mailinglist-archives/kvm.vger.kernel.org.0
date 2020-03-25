Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2C5E1925DB
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 11:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbgCYKiu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 06:38:50 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:49060 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727458AbgCYKiu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Mar 2020 06:38:50 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7787C72ABDB49AE56E7A;
        Wed, 25 Mar 2020 18:38:47 +0800 (CST)
Received: from [127.0.0.1] (10.173.220.25) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Wed, 25 Mar 2020
 18:38:42 +0800
Subject: Re: [PATCH v2 67/94] arm64: Add level-hinted TLB invalidation helper
To:     Marc Zyngier <maz@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
CC:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        "Dave Martin" <Dave.Martin@arm.com>,
        James Morse <james.morse@arm.com>,
        "Alexandru Elisei" <alexandru.elisei@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20200211174938.27809-1-maz@kernel.org>
 <20200211174938.27809-68-maz@kernel.org>
From:   Zhenyu Ye <yezhenyu2@huawei.com>
Message-ID: <b4120382-d175-0c2f-249e-cc77a09709db@huawei.com>
Date:   Wed, 25 Mar 2020 18:38:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200211174938.27809-68-maz@kernel.org>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.220.25]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2020/2/12 1:49, Marc Zyngier wrote:
> Add a level-hinted TLB invalidation helper that only gets used if
> ARMv8.4-TTL gets detected.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/tlbflush.h | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
> index bc3949064725..a3f70778a325 100644
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
> @@ -59,6 +60,35 @@
>  		__ta;						\
>  	})
>  
> +#define TLBI_TTL_MASK	GENMASK_ULL(47, 44)
> +
> +#define __tlbi_level(op, addr, level)					\
> +	do {								\
> +		u64 arg = addr;						\
> +									\
> +		if (cpus_have_const_cap(ARM64_HAS_ARMv8_4_TTL) &&	\
> +		    level) {						\
> +			u64 ttl = level;				\
> +									\
> +			switch (PAGE_SIZE) {				\
> +			case SZ_4K:					\
> +				ttl |= 1 << 2;				\
> +				break;					\
> +			case SZ_16K:					\
> +				ttl |= 2 << 2;				\
> +				break;					\
> +			case SZ_64K:					\
> +				ttl |= 3 << 2;				\
> +				break;					\
> +			}						\

Can we define a macro here to replace the switch? It will be more
clearly and efficient. Such as:

#define __TG ((PAGE_SHIFT - 12) / 2 + 1)
ttl |= __TG << 2;

> +									\
> +			arg &= ~TLBI_TTL_MASK;				\
> +			arg |= FIELD_PREP(TLBI_TTL_MASK, ttl);		\
> +		}							\
> +									\
> +		__tlbi(op,  arg);					\
> +	} while(0)
> +
>  /*
>   *	TLB Invalidation
>   *	================
> 

Thanks,
Zhenyu

