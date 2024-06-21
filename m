Return-Path: <kvm+bounces-20237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A9EB9122AE
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:42:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8B86A1C23C89
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 10:42:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F8D017276E;
	Fri, 21 Jun 2024 10:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="GmFEkXoZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49506171E4F
	for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 10:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718966558; cv=none; b=TJJe9eM8uxSkADpgxBHyAZL9HXYvHlj7CtF9KbnX74NjkrmsKfNfQckq7GcPOn6ht0tB1Ulda6p7GjbyVU1ScW8VkNkp5kbaQRsOW/hYG0AHdsGrz0FYcPmHK8IiuFqsaR4QNcZEi3SpZDiICF0iO95h11w5+IqDm6dtrFNgGLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718966558; c=relaxed/simple;
	bh=ky0SEPLZl0H9ulbLnRryxYTIwBF3DV2m8IRcePyJpcA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S/9D4crF8M5YRuFnGNbuJkRAHAhpSOI+H1oI2ebWIbkNzmZiHQSwEMEN5zbj0yWrftbSzU5ML//j2K1KL5HOYLmaSAd8JeF7y+M5DWdbyNAi6E1h6GC3+jHSyTJHDHSf9O7QLNnu4ulO5PVlTI/vA4cm1WPSdf0TGXH8mCneagY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=GmFEkXoZ; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a6f176c5c10so222683366b.2
        for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 03:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1718966554; x=1719571354; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dgz9ZmJ4s9216HaGH0t9U4xCU2tIUMWcQRC8Q7eK2T4=;
        b=GmFEkXoZ4La/YG7VwjQTKLEj1FTEi6ALkqhKCaENPUyLSkIvQA/9NQyN5XE1AQPhas
         lY0+xUSPGPxqqdEaXEDRkxZSUUlDH+HfmFtMlHwdt/b0GIH7MGX9ALAWCQdpgRORXfjF
         FfmNMbBHoBFAOqMthoJoQQbSQFPUDghJR7Vz/gS1BexByD+x5fzv3EiDfDVF6WLMY7VN
         xn5AQDvwGwqtY4j8Y/Tm7YUiMrK3prjdvmFfmzJLZhoMey6UvJC2yNLI8cRZzxpxEEi+
         79oklQV2MDRfmPvIVc1eDalJ2K9zU8Pnq4EyWGLI1efKwhDzoAYdc2GA4l2gm9Z9yiYB
         JbQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718966554; x=1719571354;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dgz9ZmJ4s9216HaGH0t9U4xCU2tIUMWcQRC8Q7eK2T4=;
        b=gt5C1GjB7ZkovxxTQAOf4eePNiQud+1PuyluouLXt+But3yC7XWi07kbzJwEqReW3N
         seZMD0S9qHTwId9JDL+DVFSZpXiGYQw8VM2a96Wh9z+RuEQo2a0GCs3A/deaIy78tijK
         5QEzcitd+yfMts6RSQa5VbeOoaRjWM49wkhq2kRGOyZzuCnT79iZk+PZetSrOGJQE1Im
         qtHafhAFwl50ARpZnYtSbZ1j53PTWCtCHhy1vh2L9Rqm767aWr+bH44klwgeh8rUYkRp
         d5XQqwExj/QhnvyCEEwbmYF4elAc5ps8E7KOUaPI0TBmhRCKo2qHHLcP6u7y5DMgeI2n
         /OEg==
X-Forwarded-Encrypted: i=1; AJvYcCWxExpn6HqAaEPTpQhjwbnK7IeJ9Vyyx7GYXDFoc0z/+N0rvX+l9Dlfxv7VFNNLDLyxZhuUdMXtAL22iuVomI9aJc2d
X-Gm-Message-State: AOJu0YzUp2/eiqVV/TNWYK9MVo+1b4alLkmmQCZXWmCYIR9CepgqnxUj
	ZnW1SRhtyZkHCR5+//fYAJH0iho3MfeJNZztHiu2coiAgHOJCrjEyEsx5apOpaE=
X-Google-Smtp-Source: AGHT+IHxrHNNvxNY4qy5ocEyq6ukqomCarzZCMchwFqZYAIJwUYhqG6K9/TqPLhbvu6lrozE/uS1Hw==
X-Received: by 2002:a17:906:a28a:b0:a6f:1ad7:6875 with SMTP id a640c23a62f3a-a6fab7d0479mr422358166b.69.1718966553875;
        Fri, 21 Jun 2024 03:42:33 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6fcf428c67sm70251066b.2.2024.06.21.03.42.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jun 2024 03:42:33 -0700 (PDT)
Date: Fri, 21 Jun 2024 12:42:32 +0200
From: Andrew Jones <ajones@ventanamicro.com>
To: Conor Dooley <conor.dooley@microchip.com>
Cc: Yong-Xuan Wang <yongxuan.wang@sifive.com>, 
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, apatel@ventanamicro.com, alex@ghiti.fr, greentime.hu@sifive.com, 
	vincent.chen@sifive.com, Jinyu Tang <tjytimi@163.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Anup Patel <anup@brainfault.org>, 
	Mayuresh Chitale <mchitale@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>, wchen <waylingii@gmail.com>, 
	Samuel Ortiz <sameo@rivosinc.com>, =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>, 
	Evan Green <evan@rivosinc.com>, Xiao Wang <xiao.w.wang@intel.com>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Mike Rapoport (IBM)" <rppt@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Samuel Holland <samuel.holland@sifive.com>, Jisheng Zhang <jszhang@kernel.org>, 
	Charlie Jenkins <charlie@rivosinc.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Leonardo Bras <leobras@redhat.com>
Subject: Re: [PATCH v5 1/4] RISC-V: Add Svade and Svadu Extensions Support
Message-ID: <20240621-b22a7c677a8d61c26feaa75b@orel>
References: <20240605121512.32083-1-yongxuan.wang@sifive.com>
 <20240605121512.32083-2-yongxuan.wang@sifive.com>
 <20240621-d1b77d43adacaa34337238c2@orel>
 <20240621-nutty-penknife-ca541ee5108d@wendy>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240621-nutty-penknife-ca541ee5108d@wendy>

On Fri, Jun 21, 2024 at 11:24:19AM GMT, Conor Dooley wrote:
> On Fri, Jun 21, 2024 at 10:43:58AM +0200, Andrew Jones wrote:
> > On Wed, Jun 05, 2024 at 08:15:07PM GMT, Yong-Xuan Wang wrote:
> > > Svade and Svadu extensions represent two schemes for managing the PTE A/D
> > > bits. When the PTE A/D bits need to be set, Svade extension intdicates
> > > that a related page fault will be raised. In contrast, the Svadu extension
> > > supports hardware updating of PTE A/D bits. Since the Svade extension is
> > > mandatory and the Svadu extension is optional in RVA23 profile, by default
> > > the M-mode firmware will enable the Svadu extension in the menvcfg CSR
> > > when only Svadu is present in DT.
> > > 
> > > This patch detects Svade and Svadu extensions from DT and adds
> > > arch_has_hw_pte_young() to enable optimization in MGLRU and
> > > __wp_page_copy_user() when we have the PTE A/D bits hardware updating
> > > support.
> > > 
> > > Co-developed-by: Jinyu Tang <tjytimi@163.com>
> > > Signed-off-by: Jinyu Tang <tjytimi@163.com>
> > > Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
> > > ---
> > >  arch/riscv/Kconfig               |  1 +
> > >  arch/riscv/include/asm/csr.h     |  1 +
> > >  arch/riscv/include/asm/hwcap.h   |  2 ++
> > >  arch/riscv/include/asm/pgtable.h | 14 +++++++++++++-
> > >  arch/riscv/kernel/cpufeature.c   |  2 ++
> > >  5 files changed, 19 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> > > index b94176e25be1..dbfe2be99bf9 100644
> > > --- a/arch/riscv/Kconfig
> > > +++ b/arch/riscv/Kconfig
> > > @@ -36,6 +36,7 @@ config RISCV
> > >  	select ARCH_HAS_PMEM_API
> > >  	select ARCH_HAS_PREPARE_SYNC_CORE_CMD
> > >  	select ARCH_HAS_PTE_SPECIAL
> > > +	select ARCH_HAS_HW_PTE_YOUNG
> > >  	select ARCH_HAS_SET_DIRECT_MAP if MMU
> > >  	select ARCH_HAS_SET_MEMORY if MMU
> > >  	select ARCH_HAS_STRICT_KERNEL_RWX if MMU && !XIP_KERNEL
> > > diff --git a/arch/riscv/include/asm/csr.h b/arch/riscv/include/asm/csr.h
> > > index 25966995da04..524cd4131c71 100644
> > > --- a/arch/riscv/include/asm/csr.h
> > > +++ b/arch/riscv/include/asm/csr.h
> > > @@ -195,6 +195,7 @@
> > >  /* xENVCFG flags */
> > >  #define ENVCFG_STCE			(_AC(1, ULL) << 63)
> > >  #define ENVCFG_PBMTE			(_AC(1, ULL) << 62)
> > > +#define ENVCFG_ADUE			(_AC(1, ULL) << 61)
> > >  #define ENVCFG_CBZE			(_AC(1, UL) << 7)
> > >  #define ENVCFG_CBCFE			(_AC(1, UL) << 6)
> > >  #define ENVCFG_CBIE_SHIFT		4
> > > diff --git a/arch/riscv/include/asm/hwcap.h b/arch/riscv/include/asm/hwcap.h
> > > index e17d0078a651..35d7aa49785d 100644
> > > --- a/arch/riscv/include/asm/hwcap.h
> > > +++ b/arch/riscv/include/asm/hwcap.h
> > > @@ -81,6 +81,8 @@
> > >  #define RISCV_ISA_EXT_ZTSO		72
> > >  #define RISCV_ISA_EXT_ZACAS		73
> > >  #define RISCV_ISA_EXT_XANDESPMU		74
> > > +#define RISCV_ISA_EXT_SVADE             75
> > > +#define RISCV_ISA_EXT_SVADU		76
> > >  
> > >  #define RISCV_ISA_EXT_XLINUXENVCFG	127
> > >  
> > > diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
> > > index aad8b8ca51f1..7287ea4a6160 100644
> > > --- a/arch/riscv/include/asm/pgtable.h
> > > +++ b/arch/riscv/include/asm/pgtable.h
> > > @@ -120,6 +120,7 @@
> > >  #include <asm/tlbflush.h>
> > >  #include <linux/mm_types.h>
> > >  #include <asm/compat.h>
> > > +#include <asm/cpufeature.h>
> > >  
> > >  #define __page_val_to_pfn(_val)  (((_val) & _PAGE_PFN_MASK) >> _PAGE_PFN_SHIFT)
> > >  
> > > @@ -288,7 +289,6 @@ static inline pte_t pud_pte(pud_t pud)
> > >  }
> > >  
> > >  #ifdef CONFIG_RISCV_ISA_SVNAPOT
> > > -#include <asm/cpufeature.h>
> > >  
> > >  static __always_inline bool has_svnapot(void)
> > >  {
> > > @@ -624,6 +624,18 @@ static inline pgprot_t pgprot_writecombine(pgprot_t _prot)
> > >  	return __pgprot(prot);
> > >  }
> > >  
> > > +/*
> > > + * Both Svade and Svadu control the hardware behavior when the PTE A/D bits need to be set. By
> > > + * default the M-mode firmware enables the hardware updating scheme when only Svadu is present in
> > > + * DT.
> > > + */
> > > +#define arch_has_hw_pte_young arch_has_hw_pte_young
> > > +static inline bool arch_has_hw_pte_young(void)
> > > +{
> > > +	return riscv_has_extension_unlikely(RISCV_ISA_EXT_SVADU) &&
> > > +	       !riscv_has_extension_likely(RISCV_ISA_EXT_SVADE);
> > 
> > It's hard to guess what is, or will be, more likely to be the correct
> > choice of call between the _unlikely and _likely variants. But, while we
> > assume svade is most prevalent right now, it's actually quite unlikely
> > that 'svade' will be in the DT, since DTs haven't been putting it there
> > yet. Anyway, it doesn't really matter much and maybe the _unlikely vs.
> > _likely variants are better for documenting expectations than for
> > performance.
> 
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
>

Yes, I think that's reasonable, assuming we do it in the final "pass",
where we're sure svadu isn't present. Doing this is a good idea since
we'll be able to simplify conditions, as we can just use 'if (svade)'
since !svade would imply svadu. With FWFT and both, we'll want to remove
svade from the isa bitmap when enabling svadu.

Thanks,
drew

