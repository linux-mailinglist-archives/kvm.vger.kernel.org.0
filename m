Return-Path: <kvm+bounces-18374-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C758B8D46E5
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 10:19:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F31C2841D0
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 08:19:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BF7914C580;
	Thu, 30 May 2024 08:19:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4EEE176AC8;
	Thu, 30 May 2024 08:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717057168; cv=none; b=umQwF2GsZTlfhJZ6v9DmNxAWBcrhLS6RNS2h8rXvsTJQkrdrn8CqzW5fJQlDQldDb/NdyIeYs0hcFX8DQ0lrkTyXN9xcFK0pafWCjRutmoo/0q6HqPSzvvbCSoaR9iWy2LAoM4Yo/obWf3KCOkv6fePReKUlDLAIXwcpXgopc0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717057168; c=relaxed/simple;
	bh=AtyBrt1ShrZf6Sya3/wfDmIitZOKqIwvkNP14l1vYzo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rFezi7FhR4SxR4oa+TCCShgcE660v2F/GRlvay2b9JMRU55B3xSvq61TNVJHWpal7Yv4A+VP3sQUsOzQFxoIl5t58IP65XKIPdxY3icIbWlcBwEoBUmpypm7KBK2IRBRhat6Ip2w6RR3XNvwSBriZW2BerRclLyoxxxy5tKcSfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 054A320008;
	Thu, 30 May 2024 08:19:12 +0000 (UTC)
Message-ID: <ec110587-d557-439b-ae50-f3472535ef3a@ghiti.fr>
Date: Thu, 30 May 2024 10:19:12 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 1/5] RISC-V: Detect and Enable Svadu Extension
 Support
Content-Language: en-US
To: Andrew Jones <ajones@ventanamicro.com>,
 Yong-Xuan Wang <yongxuan.wang@sifive.com>
Cc: linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org,
 kvm@vger.kernel.org, greentime.hu@sifive.com, vincent.chen@sifive.com,
 cleger@rivosinc.com, Jinyu Tang <tjytimi@163.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Anup Patel <anup@brainfault.org>, Conor Dooley <conor.dooley@microchip.com>,
 Mayuresh Chitale <mchitale@ventanamicro.com>,
 Samuel Holland <samuel.holland@sifive.com>, Samuel Ortiz
 <sameo@rivosinc.com>, Evan Green <evan@rivosinc.com>,
 Xiao Wang <xiao.w.wang@intel.com>, Alexandre Ghiti <alexghiti@rivosinc.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Jisheng Zhang <jszhang@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Charlie Jenkins <charlie@rivosinc.com>, Leonardo Bras <leobras@redhat.com>,
 linux-kernel@vger.kernel.org
References: <20240524103307.2684-1-yongxuan.wang@sifive.com>
 <20240524103307.2684-2-yongxuan.wang@sifive.com>
 <20240527-41b376a2bfedb3b9cf7e9c7b@orel>
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20240527-41b376a2bfedb3b9cf7e9c7b@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-Sasl: alex@ghiti.fr

Hi Yong-Xuan,

On 27/05/2024 18:25, Andrew Jones wrote:
> On Fri, May 24, 2024 at 06:33:01PM GMT, Yong-Xuan Wang wrote:
>> Svadu is a RISC-V extension for hardware updating of PTE A/D bits.
>>
>> In this patch we detect Svadu extension support from DTB and enable it
>> with SBI FWFT extension. Also we add arch_has_hw_pte_young() to enable
>> optimization in MGLRU and __wp_page_copy_user() if Svadu extension is
>> available.


So we talked about this yesterday during the linux-riscv patchwork 
meeting. We came to the conclusion that we should not wait for the SBI 
FWFT extension to enable Svadu but instead, it should be enabled by 
default by openSBI if the extension is present in the device tree. This 
is because we did not find any backward compatibility issues, meaning 
that enabling Svadu should not break any S-mode software. This is what 
you did in your previous versions of this patchset so the changes should 
be easy. This behaviour must be added to the dtbinding description of 
the Svadu extension.

Another thing that we discussed yesterday. There exist 2 schemes to 
manage the A/D bits updates, Svade and Svadu. If a platform supports 
both extensions and both are present in the device tree, it is M-mode 
firmware's responsibility to provide a "sane" device tree to the S-mode 
software, meaning the device tree can not contain both extensions. And 
because on such platforms, Svadu is more performant than Svade, Svadu 
should be enabled by the M-mode firmware and only Svadu should be 
present in the device tree.

I hope that clearly explains what we discussed yesterday, let me know if 
you (or anyone else) need more explanations. If no one is opposed to 
this solution, do you think you can implement this behaviour? If not, I 
can deal with it, just let me know.

Thanks


>>
>> Co-developed-by: Jinyu Tang <tjytimi@163.com>
>> Signed-off-by: Jinyu Tang <tjytimi@163.com>
>> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
>> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
>> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> I think this patch changed too much to keep r-b's. We didn't have the
> FWFT part before.
>
>> ---
>>   arch/riscv/Kconfig               |  1 +
>>   arch/riscv/include/asm/csr.h     |  1 +
>>   arch/riscv/include/asm/hwcap.h   |  1 +
>>   arch/riscv/include/asm/pgtable.h |  8 +++++++-
>>   arch/riscv/kernel/cpufeature.c   | 11 +++++++++++
>>   5 files changed, 21 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
>> index be09c8836d56..30fa558ee284 100644
>> --- a/arch/riscv/Kconfig
>> +++ b/arch/riscv/Kconfig
>> @@ -34,6 +34,7 @@ config RISCV
>>   	select ARCH_HAS_PMEM_API
>>   	select ARCH_HAS_PREPARE_SYNC_CORE_CMD
>>   	select ARCH_HAS_PTE_SPECIAL
>> +	select ARCH_HAS_HW_PTE_YOUNG
>>   	select ARCH_HAS_SET_DIRECT_MAP if MMU
>>   	select ARCH_HAS_SET_MEMORY if MMU
>>   	select ARCH_HAS_STRICT_KERNEL_RWX if MMU && !XIP_KERNEL
>> diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
>> index 2468c55933cd..2ac270ad4acd 100644
>> --- a/arch/riscv/include/asm/csr.h
>> +++ b/arch/riscv/include/asm/csr.h
>> @@ -194,6 +194,7 @@
>>   /* xENVCFG flags */
>>   #define ENVCFG_STCE			(_AC(1, ULL) << 63)
>>   #define ENVCFG_PBMTE			(_AC(1, ULL) << 62)
>> +#define ENVCFG_ADUE			(_AC(1, ULL) << 61)
>>   #define ENVCFG_CBZE			(_AC(1, UL) << 7)
>>   #define ENVCFG_CBCFE			(_AC(1, UL) << 6)
>>   #define ENVCFG_CBIE_SHIFT		4
>> diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
>> index e17d0078a651..8d539e3f4e11 100644
>> --- a/arch/riscv/include/asm/hwcap.h
>> +++ b/arch/riscv/include/asm/hwcap.h
>> @@ -81,6 +81,7 @@
>>   #define RISCV_ISA_EXT_ZTSO		72
>>   #define RISCV_ISA_EXT_ZACAS		73
>>   #define RISCV_ISA_EXT_XANDESPMU		74
>> +#define RISCV_ISA_EXT_SVADU		75
>>   
>>   #define RISCV_ISA_EXT_XLINUXENVCFG	127
>>   
>> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
>> index 9f8ea0e33eb1..1f1b326ccf63 100644
>> --- a/arch/riscv/include/asm/pgtable.h
>> +++ b/arch/riscv/include/asm/pgtable.h
>> @@ -117,6 +117,7 @@
>>   #include <asm/tlbflush.h>
>>   #include <linux/mm_types.h>
>>   #include <asm/compat.h>
>> +#include <asm/cpufeature.h>
>>   
>>   #define __page_val_to_pfn(_val)  (((_val) & _PAGE_PFN_MASK) >> _PAGE_PFN_SHIFT)
>>   
>> @@ -285,7 +286,6 @@ static inline pte_t pud_pte(pud_t pud)
>>   }
>>   
>>   #ifdef CONFIG_RISCV_ISA_SVNAPOT
>> -#include <asm/cpufeature.h>
>>   
>>   static __always_inline bool has_svnapot(void)
>>   {
>> @@ -621,6 +621,12 @@ static inline pgprot_t pgprot_writecombine(pgprot_t _prot)
>>   	return __pgprot(prot);
>>   }
>>   
>> +#define arch_has_hw_pte_young arch_has_hw_pte_young
>> +static inline bool arch_has_hw_pte_young(void)
>> +{
>> +	return riscv_has_extension_unlikely(RISCV_ISA_EXT_SVADU);
>> +}
>> +
>>   /*
>>    * THP functions
>>    */
>> diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
>> index 3ed2359eae35..b023908c5932 100644
>> --- a/arch/riscv/kernel/cpufeature.c
>> +++ b/arch/riscv/kernel/cpufeature.c
>> @@ -93,6 +93,16 @@ static bool riscv_isa_extension_check(int id)
>>   			return false;
>>   		}
>>   		return true;
>> +	case RISCV_ISA_EXT_SVADU:
>> +		if (sbi_probe_extension(SBI_EXT_FWFT) > 0) {
> I think we've decided the appropriate way to prove for SBI extensions is
> to first ensure the SBI version and then do the probe, like we do for STA
> in has_pv_steal_clock()
>
>> +			struct sbiret ret;
>> +
>> +			ret = sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_SET, SBI_FWFT_PTE_AD_HW_UPDATING,
>> +					1, 0, 0, 0, 0);
>> +
>> +			return ret.error == SBI_SUCCESS;
>> +		}
>> +		return false;
>>   	case RISCV_ISA_EXT_INVALID:
>>   		return false;
>>   	}
>> @@ -301,6 +311,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
>>   	__RISCV_ISA_EXT_DATA(ssaia, RISCV_ISA_EXT_SSAIA),
>>   	__RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
>>   	__RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
>> +	__RISCV_ISA_EXT_SUPERSET(svadu, RISCV_ISA_EXT_SVADU, riscv_xlinuxenvcfg_exts),
> We do we need XLINUXENVCFG?
>
> Thanks,
> drew
>
>>   	__RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
>>   	__RISCV_ISA_EXT_DATA(svnapot, RISCV_ISA_EXT_SVNAPOT),
>>   	__RISCV_ISA_EXT_DATA(svpbmt, RISCV_ISA_EXT_SVPBMT),
>> -- 
>> 2.17.1
>>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

