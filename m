Return-Path: <kvm+bounces-20210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C34E1911D56
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 09:52:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43EF31F2312E
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 07:52:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 222ED16D308;
	Fri, 21 Jun 2024 07:52:14 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881A6168C3A;
	Fri, 21 Jun 2024 07:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718956333; cv=none; b=kmU9mhWOvDwVMygvH6h+hM7fZJAlcFOWlHrHwtrccbmJOXaMiPQnhztBPrnZ1ibK4SrFyXWXN3EHT7w6z1gc1FelPpMuEPBHR23c6m63KQmgxGkoiBZdsenKqZqaXn/ETGcbwThJosPxRp+CAXC6uc1PALHyKGmLrw+sO7Ai0QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718956333; c=relaxed/simple;
	bh=tmXZGLu2iMLP9zYiH2Rk+CIRJmyrIpftNTby0ufqyf0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tMekbzBz7Z8ZbqYoeOY0ZXQKtU71LtktF4rhExgkhrOlkdWTeSpXb4vzdqdbMSSHJ9OL2XvmCKw6OScs48WZHVfj1ergS5MULo8zhVrHm7sqbmBLEOPUwptGthzszL89uSgnRIaGmXAbuiCjnl4q47x+ZKi4prJ1SJp+tO0Mn6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr; spf=pass smtp.mailfrom=ghiti.fr; arc=none smtp.client-ip=217.70.183.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ghiti.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id D035E20003;
	Fri, 21 Jun 2024 07:52:02 +0000 (UTC)
Message-ID: <09f427cd-74ad-4aa5-81b1-995af2b6e1d1@ghiti.fr>
Date: Fri, 21 Jun 2024 09:52:01 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/4] RISC-V: Add Svade and Svadu Extensions Support
Content-Language: en-US
To: Yong-Xuan Wang <yongxuan.wang@sifive.com>, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org,
 kvm@vger.kernel.org
Cc: apatel@ventanamicro.com, ajones@ventanamicro.com,
 greentime.hu@sifive.com, vincent.chen@sifive.com,
 Jinyu Tang <tjytimi@163.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Anup Patel <anup@brainfault.org>, Conor Dooley <conor.dooley@microchip.com>,
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
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20240605121512.32083-2-yongxuan.wang@sifive.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-Sasl: alex@ghiti.fr

Hi Yong-Xuan,

On 05/06/2024 14:15, Yong-Xuan Wang wrote:
> Svade and Svadu extensions represent two schemes for managing the PTE A/D
> bits. When the PTE A/D bits need to be set, Svade extension intdicates
> that a related page fault will be raised. In contrast, the Svadu extension
> supports hardware updating of PTE A/D bits. Since the Svade extension is
> mandatory and the Svadu extension is optional in RVA23 profile, by default
> the M-mode firmware will enable the Svadu extension in the menvcfg CSR
> when only Svadu is present in DT.
>
> This patch detects Svade and Svadu extensions from DT and adds
> arch_has_hw_pte_young() to enable optimization in MGLRU and
> __wp_page_copy_user() when we have the PTE A/D bits hardware updating
> support.
>
> Co-developed-by: Jinyu Tang <tjytimi@163.com>
> Signed-off-by: Jinyu Tang <tjytimi@163.com>
> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> ---
>   arch/riscv/Kconfig               |  1 +
>   arch/riscv/include/asm/csr.h     |  1 +
>   arch/riscv/include/asm/hwcap.h   |  2 ++
>   arch/riscv/include/asm/pgtable.h | 14 +++++++++++++-
>   arch/riscv/kernel/cpufeature.c   |  2 ++
>   5 files changed, 19 insertions(+), 1 deletion(-)
>
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index b94176e25be1..dbfe2be99bf9 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -36,6 +36,7 @@ config RISCV
>   	select ARCH_HAS_PMEM_API
>   	select ARCH_HAS_PREPARE_SYNC_CORE_CMD
>   	select ARCH_HAS_PTE_SPECIAL
> +	select ARCH_HAS_HW_PTE_YOUNG
>   	select ARCH_HAS_SET_DIRECT_MAP if MMU
>   	select ARCH_HAS_SET_MEMORY if MMU
>   	select ARCH_HAS_STRICT_KERNEL_RWX if MMU && !XIP_KERNEL
> diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
> index 25966995da04..524cd4131c71 100644
> --- a/arch/riscv/include/asm/csr.h
> +++ b/arch/riscv/include/asm/csr.h
> @@ -195,6 +195,7 @@
>   /* xENVCFG flags */
>   #define ENVCFG_STCE			(_AC(1, ULL) << 63)
>   #define ENVCFG_PBMTE			(_AC(1, ULL) << 62)
> +#define ENVCFG_ADUE			(_AC(1, ULL) << 61)
>   #define ENVCFG_CBZE			(_AC(1, UL) << 7)
>   #define ENVCFG_CBCFE			(_AC(1, UL) << 6)
>   #define ENVCFG_CBIE_SHIFT		4
> diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
> index e17d0078a651..35d7aa49785d 100644
> --- a/arch/riscv/include/asm/hwcap.h
> +++ b/arch/riscv/include/asm/hwcap.h
> @@ -81,6 +81,8 @@
>   #define RISCV_ISA_EXT_ZTSO		72
>   #define RISCV_ISA_EXT_ZACAS		73
>   #define RISCV_ISA_EXT_XANDESPMU		74
> +#define RISCV_ISA_EXT_SVADE             75
> +#define RISCV_ISA_EXT_SVADU		76
>   
>   #define RISCV_ISA_EXT_XLINUXENVCFG	127
>   
> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
> index aad8b8ca51f1..7287ea4a6160 100644
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -120,6 +120,7 @@
>   #include <asm/tlbflush.h>
>   #include <linux/mm_types.h>
>   #include <asm/compat.h>
> +#include <asm/cpufeature.h>
>   
>   #define __page_val_to_pfn(_val)  (((_val) & _PAGE_PFN_MASK) >> _PAGE_PFN_SHIFT)
>   
> @@ -288,7 +289,6 @@ static inline pte_t pud_pte(pud_t pud)
>   }
>   
>   #ifdef CONFIG_RISCV_ISA_SVNAPOT
> -#include <asm/cpufeature.h>
>   
>   static __always_inline bool has_svnapot(void)
>   {
> @@ -624,6 +624,18 @@ static inline pgprot_t pgprot_writecombine(pgprot_t _prot)
>   	return __pgprot(prot);
>   }
>   
> +/*
> + * Both Svade and Svadu control the hardware behavior when the PTE A/D bits need to be set. By
> + * default the M-mode firmware enables the hardware updating scheme when only Svadu is present in
> + * DT.
> + */
> +#define arch_has_hw_pte_young arch_has_hw_pte_young
> +static inline bool arch_has_hw_pte_young(void)
> +{
> +	return riscv_has_extension_unlikely(RISCV_ISA_EXT_SVADU) &&
> +	       !riscv_has_extension_likely(RISCV_ISA_EXT_SVADE);
> +}


AFAIK, the riscv_has_extension_*() macros will use the content of the 
riscv,isa string. So this works fine for now with the description you 
provided in the cover letter, as long as we don't have the FWFT SBI 
extension. I'm wondering if we should not make sure it works when FWFT 
lands because I'm pretty sure we will forget about this.

So I think we should check the availability of SBI FWFT and use some 
global variable that tells if svadu is enabled or not instead of this check.


> +
>   /*
>    * THP functions
>    */
> diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
> index 5ef48cb20ee1..58565798cea0 100644
> --- a/arch/riscv/kernel/cpufeature.c
> +++ b/arch/riscv/kernel/cpufeature.c
> @@ -301,6 +301,8 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
>   	__RISCV_ISA_EXT_DATA(ssaia, RISCV_ISA_EXT_SSAIA),
>   	__RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
>   	__RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
> +	__RISCV_ISA_EXT_DATA(svade, RISCV_ISA_EXT_SVADE),
> +	__RISCV_ISA_EXT_DATA(svadu, RISCV_ISA_EXT_SVADU),
>   	__RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
>   	__RISCV_ISA_EXT_DATA(svnapot, RISCV_ISA_EXT_SVNAPOT),
>   	__RISCV_ISA_EXT_DATA(svpbmt, RISCV_ISA_EXT_SVPBMT),

