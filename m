Return-Path: <kvm+bounces-18180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 20CB98D0878
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 18:28:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 455F11C2306B
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 16:28:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30C5E15A860;
	Mon, 27 May 2024 16:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="H4hcpxAY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B39815A840
	for <kvm@vger.kernel.org>; Mon, 27 May 2024 16:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716827155; cv=none; b=nS7c2nnb0Eh5yd0Q15e0TZP99EH4KEPO4+ZZlKMv+dxR514JCFKcLyF33AW4zcrrHxOsLni+HCtHAM20qoe53flfhHovhLc8K3tV+NyTlHVOwThkJloBepwh1jSiUkXfJxJUaRw6v0suGbZlHeYXP8Lu1YWlSJznu9hE88W2OAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716827155; c=relaxed/simple;
	bh=BWHpsqf+a3APel0aPkI161DJdxHGlPWG1TM+Qe431l0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VdjSCoffDqzrOvMxEN6jmRo37OmhAQ6vP4bQhtiSH/6VAqmRP9fiNZvBGLwCIE2SgPeKbhX90BR4CiR7qufakoFmfoqfDrSDfpiVV7pBg9VkXrc8RHqqoJGp2avw1XRKiyLXs7WcxMh5bm1HiHy1Z/LvSK89mClpKDZ4DVn+hu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=H4hcpxAY; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5296232e00bso3644175e87.3
        for <kvm@vger.kernel.org>; Mon, 27 May 2024 09:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1716827150; x=1717431950; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=47CM+OohXZ/uj91laGtyNIW1WOIMEW/2BamLnhPhjLg=;
        b=H4hcpxAYs5UAhSYxgijMwPV11OuRAyn13m7zKZt0hY4vTMcSNeItK+Y4aiJmxXU0I3
         ysfs8Tan9cLKsVp3e5yypdVj7nrU9Ja/o6x1ApjN86yUo/EfvI57OevpNxYp/iCZDYsj
         ANOXJ7rIZBbvxOhMsmgF9hbzo1OQMsJZlfHfwx4isCTTygj/dc4ML4TBnC4V+ninTdlE
         6IpHEzMZ/SDa+Qc2CAYBDicMnB2hYOoWKh+4TxJ5dXBGA/KIyPJRSFDPmDbV3B+b/UCn
         oZRpgBa1e+D2zxH58lrVwIOcTTkZ/kP35jYotUvNcZP3NKnp2wVg+jTDBY+GrBMEcxGm
         UiyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716827150; x=1717431950;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=47CM+OohXZ/uj91laGtyNIW1WOIMEW/2BamLnhPhjLg=;
        b=NtrLLX9MgvDcQZTI/u1pbewalDhLaoNs3dEiVxKYfPZOzGbmdbMsWSeEU3G6hnYz+U
         gtCYh6UBYghx2hLAmR+AeQ/wAVyt+1PNnjYnAdO5u50Q45Xewo7Z1hPYM0FWlExVlInH
         Vq7IxNuaCNUnWga9WR41yd1maWlQZoH9qj+nhhVXKAG3HZIJ41ri4ZP9/YtDlG7ZEApo
         t/pFJKAn1vmDsDHYPx2ACwFeYNx7bNGQaA/UVWT8mnxAx5bHhlu4731h0Ii7brs+Y9LV
         SMmZeSbDsG87tJvgoFxzUAamDjNhnhXBk0Tlkp+xI5EPDJXOewFf6q2ZfNMXp0jeIh3z
         1HEQ==
X-Forwarded-Encrypted: i=1; AJvYcCVklX77W+9WZi81QhL2iEG/p8bjzvuYf+02jWFC1vQpk37I5eX/Mgsg6+MDwWL9lNA0piArozy83DrtIojvkB4VfzW6
X-Gm-Message-State: AOJu0YyH6lXfaapmTg7SZmwK+HG0VHE1BIK5B7kLXO2J5ZpJQwrr5s8H
	Q30mB2S8bhk1yzxmSBCTbuYiKGjCq8f8GMb2DlEMbfxAbXdeMNmS7q/qXzpsGQ8=
X-Google-Smtp-Source: AGHT+IERUBuY75t+21Dh0Te3entq997PSVNxYrQiMf+uzfZwadVoSO9JlMdhr5Poe9kWJuTWdn1vkQ==
X-Received: by 2002:ac2:5ec6:0:b0:51e:147d:bd2d with SMTP id 2adb3069b0e04-52964eac421mr5508085e87.39.1716827150373;
        Mon, 27 May 2024 09:25:50 -0700 (PDT)
Received: from localhost ([176.74.158.132])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-578524bb79esm5935351a12.92.2024.05.27.09.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 May 2024 09:25:49 -0700 (PDT)
Date: Mon, 27 May 2024 18:25:49 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Cc: linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, greentime.hu@sifive.com, vincent.chen@sifive.com, 
	cleger@rivosinc.com, alex@ghiti.fr, Jinyu Tang <tjytimi@163.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Anup Patel <anup@brainfault.org>, 
	Conor Dooley <conor.dooley@microchip.com>, Mayuresh Chitale <mchitale@ventanamicro.com>, 
	Samuel Holland <samuel.holland@sifive.com>, Samuel Ortiz <sameo@rivosinc.com>, 
	Evan Green <evan@rivosinc.com>, Xiao Wang <xiao.w.wang@intel.com>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, "Mike Rapoport (IBM)" <rppt@kernel.org>, 
	Jisheng Zhang <jszhang@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Charlie Jenkins <charlie@rivosinc.com>, Leonardo Bras <leobras@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 1/5] RISC-V: Detect and Enable Svadu Extension
 Support
Message-ID: <20240527-41b376a2bfedb3b9cf7e9c7b@orel>
References: <20240524103307.2684-1-yongxuan.wang@sifive.com>
 <20240524103307.2684-2-yongxuan.wang@sifive.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240524103307.2684-2-yongxuan.wang@sifive.com>

On Fri, May 24, 2024 at 06:33:01PM GMT, Yong-Xuan Wang wrote:
> Svadu is a RISC-V extension for hardware updating of PTE A/D bits.
> 
> In this patch we detect Svadu extension support from DTB and enable it
> with SBI FWFT extension. Also we add arch_has_hw_pte_young() to enable
> optimization in MGLRU and __wp_page_copy_user() if Svadu extension is
> available.
> 
> Co-developed-by: Jinyu Tang <tjytimi@163.com>
> Signed-off-by: Jinyu Tang <tjytimi@163.com>
> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

I think this patch changed too much to keep r-b's. We didn't have the
FWFT part before.

> ---
>  arch/riscv/Kconfig               |  1 +
>  arch/riscv/include/asm/csr.h     |  1 +
>  arch/riscv/include/asm/hwcap.h   |  1 +
>  arch/riscv/include/asm/pgtable.h |  8 +++++++-
>  arch/riscv/kernel/cpufeature.c   | 11 +++++++++++
>  5 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index be09c8836d56..30fa558ee284 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -34,6 +34,7 @@ config RISCV
>  	select ARCH_HAS_PMEM_API
>  	select ARCH_HAS_PREPARE_SYNC_CORE_CMD
>  	select ARCH_HAS_PTE_SPECIAL
> +	select ARCH_HAS_HW_PTE_YOUNG
>  	select ARCH_HAS_SET_DIRECT_MAP if MMU
>  	select ARCH_HAS_SET_MEMORY if MMU
>  	select ARCH_HAS_STRICT_KERNEL_RWX if MMU && !XIP_KERNEL
> diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
> index 2468c55933cd..2ac270ad4acd 100644
> --- a/arch/riscv/include/asm/csr.h
> +++ b/arch/riscv/include/asm/csr.h
> @@ -194,6 +194,7 @@
>  /* xENVCFG flags */
>  #define ENVCFG_STCE			(_AC(1, ULL) << 63)
>  #define ENVCFG_PBMTE			(_AC(1, ULL) << 62)
> +#define ENVCFG_ADUE			(_AC(1, ULL) << 61)
>  #define ENVCFG_CBZE			(_AC(1, UL) << 7)
>  #define ENVCFG_CBCFE			(_AC(1, UL) << 6)
>  #define ENVCFG_CBIE_SHIFT		4
> diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
> index e17d0078a651..8d539e3f4e11 100644
> --- a/arch/riscv/include/asm/hwcap.h
> +++ b/arch/riscv/include/asm/hwcap.h
> @@ -81,6 +81,7 @@
>  #define RISCV_ISA_EXT_ZTSO		72
>  #define RISCV_ISA_EXT_ZACAS		73
>  #define RISCV_ISA_EXT_XANDESPMU		74
> +#define RISCV_ISA_EXT_SVADU		75
>  
>  #define RISCV_ISA_EXT_XLINUXENVCFG	127
>  
> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
> index 9f8ea0e33eb1..1f1b326ccf63 100644
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -117,6 +117,7 @@
>  #include <asm/tlbflush.h>
>  #include <linux/mm_types.h>
>  #include <asm/compat.h>
> +#include <asm/cpufeature.h>
>  
>  #define __page_val_to_pfn(_val)  (((_val) & _PAGE_PFN_MASK) >> _PAGE_PFN_SHIFT)
>  
> @@ -285,7 +286,6 @@ static inline pte_t pud_pte(pud_t pud)
>  }
>  
>  #ifdef CONFIG_RISCV_ISA_SVNAPOT
> -#include <asm/cpufeature.h>
>  
>  static __always_inline bool has_svnapot(void)
>  {
> @@ -621,6 +621,12 @@ static inline pgprot_t pgprot_writecombine(pgprot_t _prot)
>  	return __pgprot(prot);
>  }
>  
> +#define arch_has_hw_pte_young arch_has_hw_pte_young
> +static inline bool arch_has_hw_pte_young(void)
> +{
> +	return riscv_has_extension_unlikely(RISCV_ISA_EXT_SVADU);
> +}
> +
>  /*
>   * THP functions
>   */
> diff --git a/arch/riscv/kernel/cpufeature.c b/arch/riscv/kernel/cpufeature.c
> index 3ed2359eae35..b023908c5932 100644
> --- a/arch/riscv/kernel/cpufeature.c
> +++ b/arch/riscv/kernel/cpufeature.c
> @@ -93,6 +93,16 @@ static bool riscv_isa_extension_check(int id)
>  			return false;
>  		}
>  		return true;
> +	case RISCV_ISA_EXT_SVADU:
> +		if (sbi_probe_extension(SBI_EXT_FWFT) > 0) {

I think we've decided the appropriate way to prove for SBI extensions is
to first ensure the SBI version and then do the probe, like we do for STA
in has_pv_steal_clock()

> +			struct sbiret ret;
> +
> +			ret = sbi_ecall(SBI_EXT_FWFT, SBI_EXT_FWFT_SET, SBI_FWFT_PTE_AD_HW_UPDATING,
> +					1, 0, 0, 0, 0);
> +
> +			return ret.error == SBI_SUCCESS;
> +		}
> +		return false;
>  	case RISCV_ISA_EXT_INVALID:
>  		return false;
>  	}
> @@ -301,6 +311,7 @@ const struct riscv_isa_ext_data riscv_isa_ext[] = {
>  	__RISCV_ISA_EXT_DATA(ssaia, RISCV_ISA_EXT_SSAIA),
>  	__RISCV_ISA_EXT_DATA(sscofpmf, RISCV_ISA_EXT_SSCOFPMF),
>  	__RISCV_ISA_EXT_DATA(sstc, RISCV_ISA_EXT_SSTC),
> +	__RISCV_ISA_EXT_SUPERSET(svadu, RISCV_ISA_EXT_SVADU, riscv_xlinuxenvcfg_exts),

We do we need XLINUXENVCFG?

Thanks,
drew

>  	__RISCV_ISA_EXT_DATA(svinval, RISCV_ISA_EXT_SVINVAL),
>  	__RISCV_ISA_EXT_DATA(svnapot, RISCV_ISA_EXT_SVNAPOT),
>  	__RISCV_ISA_EXT_DATA(svpbmt, RISCV_ISA_EXT_SVPBMT),
> -- 
> 2.17.1
> 

