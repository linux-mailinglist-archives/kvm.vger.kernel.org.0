Return-Path: <kvm+bounces-20219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 16501911F18
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 10:44:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 95F781F25E9B
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 08:44:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B48C816DEDF;
	Fri, 21 Jun 2024 08:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="ACUln0wN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F6716D9B9
	for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 08:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718959443; cv=none; b=NTAZw9VIqX1boSda3QmwTMf0czpOR0xejV3W7lP3UdM1gUQN2EKhcKxTH2fGmoWoT2hIqghBG1p7q4EzOl1O2nIhvM7BRWArqrwZ9PgHWox56g/7Fq1YsWXhDEHsr1+3pPpgxEugXp4+6YJV2cYsF+J/vSu2Rjow855XoAv+nV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718959443; c=relaxed/simple;
	bh=Jbwg4HBbsos0LMHx3qJn3rslKNY3axIyHOu21SZsnAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B3P4V69lnpXNEtmADUNSbQHnkeQE665jLnQAZHLsQNMmkz38iXOgi/6AXSuXWGMp5aIObrcd1s1LUnMZu2U7yTQyDGguP4NBloGnsy98UYo2imr7W0x7Vem9wYer0a88Mz6c0NvjXId9rmwjNypkMon+CxuYH+V7TYLQkZnViXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=ACUln0wN; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a62ef52e837so199026566b.3
        for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 01:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1718959440; x=1719564240; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=y0W/yXjQFyqiu4YF3eksrFfEO800rJtGZTMEqwAB9lw=;
        b=ACUln0wN5MBr2W0zWjXeykApLeYWCRLxefBYwuoLqahTF1ci18I+QPwmvZ0wkHn4AV
         VNwkHNDBLpfaWca8On9V7L1Vn1Pg8fq4i7qjubIIPnp0pFbsO37LaNA4TQNiPHE9dOfl
         W2FH+qwewdL/y1nRv5uzISbbqo8ekF7TlB4MpABRjSCnHIlhMDL9oGW4TCENB3UzmJa7
         AbF8askcY530QM6oIkYRMex5NSOYc0Oji/coxVt76xAsbs2NK+Zg9LRkx4j8wphRDHDi
         Ew1TlqxuHrEDpXpuUKQ08ZjZLnSfN8C+xBmgeCZzY7GvljC5Ud9tfGlrN2e9X2cmG2z4
         r9Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718959440; x=1719564240;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y0W/yXjQFyqiu4YF3eksrFfEO800rJtGZTMEqwAB9lw=;
        b=If5q/djEkmD2/mfgi5PpCI7KVPjPDhotXjvzdwX9Chn8FdCYT47LraDGWwkU9BX9lb
         7qjlYR6UOFR0p2GWLH5/ntGuoaJNLWgYzSuk7Lj0XLV3Fi3b4Vekel1rlveeL/6/ZDeU
         2fT0ATa0vVHyZAE2jmJw6nLvq0wIgnPjSgp8THzN2cNRH3UTFqdTOLL857qsIhyxnpr0
         jo2kMuSOH08KyStl+/VS1jSp089PZwt7QHkwu07dAoL+8C199FqFVkvAs1G55cKP9YJK
         hf9HRhiPdIeczgsQZl5aR3o5Zet7MqTtkw2xvV9KCya2Im1QFTNx6/L5ucv3/jvLrY6q
         Esyw==
X-Forwarded-Encrypted: i=1; AJvYcCV+7zdd58X329JYVjOQeRUSGkZyPis/UhdxzaG5XAb+MgkTvbtq/uHPft68kOXvLBbaunKrZTbgtfv3J3+byKV1K8lI
X-Gm-Message-State: AOJu0YxZGF6aeXdpT5smsCGdzX2veRfkuJ1yZoZrUWGrHumqfiJTLw26
	HARCtVeOEqFdb5PIhDQstWj11S/ApCpNVjT+XqWE3qPwiD3Bnf0xoEHjk3qsScQ=
X-Google-Smtp-Source: AGHT+IGCvv5/dIqWzwFU7HWVxrBDIamtXxsPzF9wPVhiKm9PMGOYERORN5v/XksMktGyjYh/7LB0lA==
X-Received: by 2002:a17:907:b9d2:b0:a6f:50ae:e06 with SMTP id a640c23a62f3a-a6fab778851mr473339566b.53.1718959439838;
        Fri, 21 Jun 2024 01:43:59 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6fcf428bb5sm59484866b.13.2024.06.21.01.43.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jun 2024 01:43:59 -0700 (PDT)
Date: Fri, 21 Jun 2024 10:43:58 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Cc: linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, apatel@ventanamicro.com, alex@ghiti.fr, 
	greentime.hu@sifive.com, vincent.chen@sifive.com, Jinyu Tang <tjytimi@163.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Anup Patel <anup@brainfault.org>, 
	Conor Dooley <conor.dooley@microchip.com>, Mayuresh Chitale <mchitale@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>, wchen <waylingii@gmail.com>, Samuel Ortiz <sameo@rivosinc.com>, 
	=?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>, Evan Green <evan@rivosinc.com>, 
	Xiao Wang <xiao.w.wang@intel.com>, Alexandre Ghiti <alexghiti@rivosinc.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Mike Rapoport (IBM)" <rppt@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Samuel Holland <samuel.holland@sifive.com>, 
	Jisheng Zhang <jszhang@kernel.org>, Charlie Jenkins <charlie@rivosinc.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Leonardo Bras <leobras@redhat.com>
Subject: Re: [PATCH v5 1/4] RISC-V: Add Svade and Svadu Extensions Support
Message-ID: <20240621-d1b77d43adacaa34337238c2@orel>
References: <20240605121512.32083-1-yongxuan.wang@sifive.com>
 <20240605121512.32083-2-yongxuan.wang@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240605121512.32083-2-yongxuan.wang@sifive.com>

On Wed, Jun 05, 2024 at 08:15:07PM GMT, Yong-Xuan Wang wrote:
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
>  arch/riscv/Kconfig               |  1 +
>  arch/riscv/include/asm/csr.h     |  1 +
>  arch/riscv/include/asm/hwcap.h   |  2 ++
>  arch/riscv/include/asm/pgtable.h | 14 +++++++++++++-
>  arch/riscv/kernel/cpufeature.c   |  2 ++
>  5 files changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index b94176e25be1..dbfe2be99bf9 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -36,6 +36,7 @@ config RISCV
>  	select ARCH_HAS_PMEM_API
>  	select ARCH_HAS_PREPARE_SYNC_CORE_CMD
>  	select ARCH_HAS_PTE_SPECIAL
> +	select ARCH_HAS_HW_PTE_YOUNG
>  	select ARCH_HAS_SET_DIRECT_MAP if MMU
>  	select ARCH_HAS_SET_MEMORY if MMU
>  	select ARCH_HAS_STRICT_KERNEL_RWX if MMU && !XIP_KERNEL
> diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
> index 25966995da04..524cd4131c71 100644
> --- a/arch/riscv/include/asm/csr.h
> +++ b/arch/riscv/include/asm/csr.h
> @@ -195,6 +195,7 @@
>  /* xENVCFG flags */
>  #define ENVCFG_STCE			(_AC(1, ULL) << 63)
>  #define ENVCFG_PBMTE			(_AC(1, ULL) << 62)
> +#define ENVCFG_ADUE			(_AC(1, ULL) << 61)
>  #define ENVCFG_CBZE			(_AC(1, UL) << 7)
>  #define ENVCFG_CBCFE			(_AC(1, UL) << 6)
>  #define ENVCFG_CBIE_SHIFT		4
> diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
> index e17d0078a651..35d7aa49785d 100644
> --- a/arch/riscv/include/asm/hwcap.h
> +++ b/arch/riscv/include/asm/hwcap.h
> @@ -81,6 +81,8 @@
>  #define RISCV_ISA_EXT_ZTSO		72
>  #define RISCV_ISA_EXT_ZACAS		73
>  #define RISCV_ISA_EXT_XANDESPMU		74
> +#define RISCV_ISA_EXT_SVADE             75
> +#define RISCV_ISA_EXT_SVADU		76
>  
>  #define RISCV_ISA_EXT_XLINUXENVCFG	127
>  
> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
> index aad8b8ca51f1..7287ea4a6160 100644
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -120,6 +120,7 @@
>  #include <asm/tlbflush.h>
>  #include <linux/mm_types.h>
>  #include <asm/compat.h>
> +#include <asm/cpufeature.h>
>  
>  #define __page_val_to_pfn(_val)  (((_val) & _PAGE_PFN_MASK) >> _PAGE_PFN_SHIFT)
>  
> @@ -288,7 +289,6 @@ static inline pte_t pud_pte(pud_t pud)
>  }
>  
>  #ifdef CONFIG_RISCV_ISA_SVNAPOT
> -#include <asm/cpufeature.h>
>  
>  static __always_inline bool has_svnapot(void)
>  {
> @@ -624,6 +624,18 @@ static inline pgprot_t pgprot_writecombine(pgprot_t _prot)
>  	return __pgprot(prot);
>  }
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

It's hard to guess what is, or will be, more likely to be the correct
choice of call between the _unlikely and _likely variants. But, while we
assume svade is most prevalent right now, it's actually quite unlikely
that 'svade' will be in the DT, since DTs haven't been putting it there
yet. Anyway, it doesn't really matter much and maybe the _unlikely vs.
_likely variants are better for documenting expectations than for
performance.

> +}
> +
>  /*
>   * THP functions
>   */
> diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
> index 5ef48cb20ee1..58565798cea0 100644
> --- a/arch/riscv/kernel/cpufeature.c
> +++ b/arch/riscv/kernel/cpufeature.c
> @@ -301,6 +301,8 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
>  	__RISCV_ISA_EXT_DATA(ssaia, RISCV_ISA_EXT_SSAIA),
>  	__RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
>  	__RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
> +	__RISCV_ISA_EXT_DATA(svade, RISCV_ISA_EXT_SVADE),
> +	__RISCV_ISA_EXT_DATA(svadu, RISCV_ISA_EXT_SVADU),
>  	__RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
>  	__RISCV_ISA_EXT_DATA(svnapot, RISCV_ISA_EXT_SVNAPOT),
>  	__RISCV_ISA_EXT_DATA(svpbmt, RISCV_ISA_EXT_SVPBMT),
> -- 
> 2.17.1
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

Thanks,
drew

