Return-Path: <kvm+bounces-20236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A1E50912278
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:32:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D4281F21FD3
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 10:32:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08F39171E40;
	Fri, 21 Jun 2024 10:32:04 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E5417109B;
	Fri, 21 Jun 2024 10:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718965923; cv=none; b=XP7pEmyCFGSGdCF7uxUe/EyQBuMii9oIClY4CBH27XwM/U6tK9+4Ud/2TcIGD89vgT4Qfe6FB5hf0S9z9uYYw98p17ghKDNv6DJK7/DjNXAM0Oaq2xsOPD25tRNt7V+3prTaibMouejbGb1BXzL/9E0nr3sfEheglvmEyEvMMfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718965923; c=relaxed/simple;
	bh=notFlVZDTS5uhtUDn26Tx/ggY9aKzBhfxPUNGypPFM4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j/6a81UblyF2WQ+/13a1itN9gkHKJFnNImFK5s9KTZLV0SK26knsLg7sZk5vzYTrvbJnjv+KW+/lgURS3dhF88f/YVf4gn11clp8ur0ROGLNeAtZqqYMZDqJEpbfFTchu7WwccF992X8YoDQUs9BQg09FCMJHXqKNDUnxYzWovQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 4FE4A240005;
	Fri, 21 Jun 2024 10:31:50 +0000 (UTC)
Message-ID: <d8055c61-1e01-4fec-99e5-b866d7aed4a1@ghiti.fr>
Date: Fri, 21 Jun 2024 12:31:48 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/4] RISC-V: Add Svade and Svadu Extensions Support
Content-Language: en-US
To: Conor Dooley <conor.dooley@microchip.com>,
 Andrew Jones <ajones@ventanamicro.com>
Cc: Yong-Xuan Wang <yongxuan.wang@sifive.com>, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org,
 kvm@vger.kernel.org, apatel@ventanamicro.com, greentime.hu@sifive.com,
 vincent.chen@sifive.com, Jinyu Tang <tjytimi@163.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Anup Patel <anup@brainfault.org>,
 Mayuresh Chitale <mchitale@ventanamicro.com>,
 Atish Patra <atishp@rivosinc.com>, wchen <waylingii@gmail.com>,
 Samuel Ortiz <sameo@rivosinc.com>, =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?=
 <cleger@rivosinc.com>, Evan Green <evan@rivosinc.com>,
 Xiao Wang <xiao.w.wang@intel.com>, Alexandre Ghiti <alexghiti@rivosinc.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Samuel Holland <samuel.holland@sifive.com>,
 Jisheng Zhang <jszhang@kernel.org>, Charlie Jenkins <charlie@rivosinc.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Leonardo Bras <leobras@redhat.com>
References: <20240605121512.32083-1-yongxuan.wang@sifive.com>
 <20240605121512.32083-2-yongxuan.wang@sifive.com>
 <20240621-d1b77d43adacaa34337238c2@orel>
 <20240621-nutty-penknife-ca541ee5108d@wendy>
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20240621-nutty-penknife-ca541ee5108d@wendy>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-Sasl: alex@ghiti.fr


On 21/06/2024 12:24, Conor Dooley wrote:
> On Fri, Jun 21, 2024 at 10:43:58AM +0200, Andrew Jones wrote:
>> On Wed, Jun 05, 2024 at 08:15:07PM GMT, Yong-Xuan Wang wrote:
>>> Svade and Svadu extensions represent two schemes for managing the PTE A/D
>>> bits. When the PTE A/D bits need to be set, Svade extension intdicates
>>> that a related page fault will be raised. In contrast, the Svadu extension
>>> supports hardware updating of PTE A/D bits. Since the Svade extension is
>>> mandatory and the Svadu extension is optional in RVA23 profile, by default
>>> the M-mode firmware will enable the Svadu extension in the menvcfg CSR
>>> when only Svadu is present in DT.
>>>
>>> This patch detects Svade and Svadu extensions from DT and adds
>>> arch_has_hw_pte_young() to enable optimization in MGLRU and
>>> __wp_page_copy_user() when we have the PTE A/D bits hardware updating
>>> support.
>>>
>>> Co-developed-by: Jinyu Tang <tjytimi@163.com>
>>> Signed-off-by: Jinyu Tang <tjytimi@163.com>
>>> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
>>> ---
>>>   arch/riscv/Kconfig               |  1 +
>>>   arch/riscv/include/asm/csr.h     |  1 +
>>>   arch/riscv/include/asm/hwcap.h   |  2 ++
>>>   arch/riscv/include/asm/pgtable.h | 14 +++++++++++++-
>>>   arch/riscv/kernel/cpufeature.c   |  2 ++
>>>   5 files changed, 19 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
>>> index b94176e25be1..dbfe2be99bf9 100644
>>> --- a/arch/riscv/Kconfig
>>> +++ b/arch/riscv/Kconfig
>>> @@ -36,6 +36,7 @@ config RISCV
>>>   	select ARCH_HAS_PMEM_API
>>>   	select ARCH_HAS_PREPARE_SYNC_CORE_CMD
>>>   	select ARCH_HAS_PTE_SPECIAL
>>> +	select ARCH_HAS_HW_PTE_YOUNG
>>>   	select ARCH_HAS_SET_DIRECT_MAP if MMU
>>>   	select ARCH_HAS_SET_MEMORY if MMU
>>>   	select ARCH_HAS_STRICT_KERNEL_RWX if MMU && !XIP_KERNEL
>>> diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
>>> index 25966995da04..524cd4131c71 100644
>>> --- a/arch/riscv/include/asm/csr.h
>>> +++ b/arch/riscv/include/asm/csr.h
>>> @@ -195,6 +195,7 @@
>>>   /* xENVCFG flags */
>>>   #define ENVCFG_STCE			(_AC(1, ULL) << 63)
>>>   #define ENVCFG_PBMTE			(_AC(1, ULL) << 62)
>>> +#define ENVCFG_ADUE			(_AC(1, ULL) << 61)
>>>   #define ENVCFG_CBZE			(_AC(1, UL) << 7)
>>>   #define ENVCFG_CBCFE			(_AC(1, UL) << 6)
>>>   #define ENVCFG_CBIE_SHIFT		4
>>> diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
>>> index e17d0078a651..35d7aa49785d 100644
>>> --- a/arch/riscv/include/asm/hwcap.h
>>> +++ b/arch/riscv/include/asm/hwcap.h
>>> @@ -81,6 +81,8 @@
>>>   #define RISCV_ISA_EXT_ZTSO		72
>>>   #define RISCV_ISA_EXT_ZACAS		73
>>>   #define RISCV_ISA_EXT_XANDESPMU		74
>>> +#define RISCV_ISA_EXT_SVADE             75
>>> +#define RISCV_ISA_EXT_SVADU		76
>>>   
>>>   #define RISCV_ISA_EXT_XLINUXENVCFG	127
>>>   
>>> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
>>> index aad8b8ca51f1..7287ea4a6160 100644
>>> --- a/arch/riscv/include/asm/pgtable.h
>>> +++ b/arch/riscv/include/asm/pgtable.h
>>> @@ -120,6 +120,7 @@
>>>   #include <asm/tlbflush.h>
>>>   #include <linux/mm_types.h>
>>>   #include <asm/compat.h>
>>> +#include <asm/cpufeature.h>
>>>   
>>>   #define __page_val_to_pfn(_val)  (((_val) & _PAGE_PFN_MASK) >> _PAGE_PFN_SHIFT)
>>>   
>>> @@ -288,7 +289,6 @@ static inline pte_t pud_pte(pud_t pud)
>>>   }
>>>   
>>>   #ifdef CONFIG_RISCV_ISA_SVNAPOT
>>> -#include <asm/cpufeature.h>
>>>   
>>>   static __always_inline bool has_svnapot(void)
>>>   {
>>> @@ -624,6 +624,18 @@ static inline pgprot_t pgprot_writecombine(pgprot_t _prot)
>>>   	return __pgprot(prot);
>>>   }
>>>   
>>> +/*
>>> + * Both Svade and Svadu control the hardware behavior when the PTE A/D bits need to be set. By
>>> + * default the M-mode firmware enables the hardware updating scheme when only Svadu is present in
>>> + * DT.
>>> + */
>>> +#define arch_has_hw_pte_young arch_has_hw_pte_young
>>> +static inline bool arch_has_hw_pte_young(void)
>>> +{
>>> +	return riscv_has_extension_unlikely(RISCV_ISA_EXT_SVADU) &&
>>> +	       !riscv_has_extension_likely(RISCV_ISA_EXT_SVADE);
>> It's hard to guess what is, or will be, more likely to be the correct
>> choice of call between the _unlikely and _likely variants. But, while we
>> assume svade is most prevalent right now, it's actually quite unlikely
>> that 'svade' will be in the DT, since DTs haven't been putting it there
>> yet. Anyway, it doesn't really matter much and maybe the _unlikely vs.
>> _likely variants are better for documenting expectations than for
>> performance.
> binding hat off, and kernel hat on, what do we actually do if there's
> neither Svadu or Svade in the firmware's description of the hardware?
> Do we just arbitrarily turn on Svade, like we already do for some
> extensions:
> 	/*
> 	 * These ones were as they were part of the base ISA when the
> 	 * port & dt-bindings were upstreamed, and so can be set
> 	 * unconditionally where `i` is in riscv,isa on DT systems.
> 	 */
> 	if (acpi_disabled) {
> 		set_bit(RISCV_ISA_EXT_ZICSR, isainfo->isa);
> 		set_bit(RISCV_ISA_EXT_ZIFENCEI, isainfo->isa);
> 		set_bit(RISCV_ISA_EXT_ZICNTR, isainfo->isa);
> 		set_bit(RISCV_ISA_EXT_ZIHPM, isainfo->isa);
> 	}


I'd say yes, svade just put a name on a HW mechanism that is required to 
make an OS work properly (if Svadu is not present). So if a platform 
only supports Svadu and it's not in the device tree, that's a bug on 
their hand.

So if neither Svadu nor Svade are present in the device tree, we can 
legitimately assume that Svade is enabled.


>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

