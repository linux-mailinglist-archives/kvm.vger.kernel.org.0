Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08FF2E93BC
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2019 00:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbfJ2XeB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Oct 2019 19:34:01 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39890 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbfJ2XeA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Oct 2019 19:34:00 -0400
Received: by mail-pg1-f196.google.com with SMTP id p12so166135pgn.6
        for <kvm@vger.kernel.org>; Tue, 29 Oct 2019 16:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0Xmk7HO2vRgpXszB/kIq0Xg4B3AGRv0Wn0fnDa+7N5s=;
        b=euwz1pCrcc8ErtHrU0pXszhEnqpeNYrORk6EY7IjIFmPvvTgGGbVPy+IlPaHtp+Gsz
         o5Q8B023YtqvEWtsSjUzv5QZ7XuyDB1QGPqWjJ2xrcLyyHBJpCsk//MZufKmg2YtorrK
         dBw6aiYnFC7ZvLbksH+HGJqyZrH61K8RUvRYo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0Xmk7HO2vRgpXszB/kIq0Xg4B3AGRv0Wn0fnDa+7N5s=;
        b=q+EP1KPGo63+kV8TDIJOmp2Ewf8oxGGGi2r6fPIBM7gAqp7CN4Ymf74rwD8K2blgrL
         1RjeJHsu/F/8NjOrNsCYusRjVnXxWOge4Q1BrKMPY5Qy6wBN0PZPOydePvhukd3GEdIh
         hm+zt/9htgq6gBK8601OSRtexudL07g2KesmtMPoFb7Yn8a+fCO+w1wBNnKIS7xVtcQG
         8q6JvEKBoqGYqAKsrb5OldgocCRdJfmRee2fuv4uaCL+JhgvHFi/bWNt1EgTLSVh40tz
         L3Yxkqo20sfH6EfNrRmUPeieWWKT2wTNTdRhJztVPp0io4oL5VJS1fZaG5fnDQIcklfq
         BPvw==
X-Gm-Message-State: APjAAAXrKy1js2bUQ6aKjCkyXNUD3b+6wvbBYry/8aj6d1mbK4PX8nvK
        Bs69MBZptxQr9osdXCPmxweVDg==
X-Google-Smtp-Source: APXvYqwsYeStphgrEURm1KorU9dh4rsSJVLid2s6BZ9qvZAvHt/QktS8Eyt7ttDx/PajmgFOD0lLEw==
X-Received: by 2002:aa7:96ef:: with SMTP id i15mr12043621pfq.242.1572392039376;
        Tue, 29 Oct 2019 16:33:59 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q3sm306607pgj.54.2019.10.29.16.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 16:33:58 -0700 (PDT)
Date:   Tue, 29 Oct 2019 16:33:57 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@kvack.org, luto@kernel.org, peterz@infradead.org,
        dave.hansen@intel.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, kristen@linux.intel.com,
        deneen.t.dock@intel.com
Subject: Re: [RFC PATCH 09/13] x86/cpufeature: Add detection of KVM XO
Message-ID: <201910291633.927254B10@keescook>
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
 <20191003212400.31130-10-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003212400.31130-10-rick.p.edgecombe@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 03, 2019 at 02:23:56PM -0700, Rick Edgecombe wrote:
> Add a new CPUID leaf to hold the contents of CPUID 0x40000030 EAX to
> detect KVM defined generic VMM features.
> 
> The leaf was proposed to allow KVM to communicate features that are
> defined by KVM, but available for any VMM to implement.
> 
> Add cpu_feature_enabled() support for features in this leaf (KVM XO), and
> a pgtable_kvmxo_enabled() helper similar to pgtable_l5_enabled() so that
> pgtable_kvmxo_enabled() can be used in early code that includes
> arch/x86/include/asm/sparsemem.h.
> 
> Lastly, in head64.c detect and this feature and perform necessary
> adjustments to physical_mask.

Can this be exposed to /proc/cpuinfo so a guest userspace can determine
if this feature is enabled?

-Kees

> 
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
>  arch/x86/include/asm/cpufeature.h             |  6 ++-
>  arch/x86/include/asm/cpufeatures.h            |  2 +-
>  arch/x86/include/asm/disabled-features.h      |  3 +-
>  arch/x86/include/asm/pgtable_32_types.h       |  1 +
>  arch/x86/include/asm/pgtable_64_types.h       | 26 ++++++++++++-
>  arch/x86/include/asm/required-features.h      |  3 +-
>  arch/x86/include/asm/sparsemem.h              |  4 +-
>  arch/x86/kernel/cpu/common.c                  |  5 +++
>  arch/x86/kernel/head64.c                      | 38 ++++++++++++++++++-
>  .../arch/x86/include/asm/disabled-features.h  |  3 +-
>  10 files changed, 80 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> index 17127ffbc2a2..7d04ea4f1623 100644
> --- a/arch/x86/include/asm/cpufeature.h
> +++ b/arch/x86/include/asm/cpufeature.h
> @@ -82,8 +82,9 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
>  	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 16, feature_bit) ||	\
>  	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 17, feature_bit) ||	\
>  	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 18, feature_bit) ||	\
> +	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 19, feature_bit) ||	\
>  	   REQUIRED_MASK_CHECK					  ||	\
> -	   BUILD_BUG_ON_ZERO(NCAPINTS != 19))
> +	   BUILD_BUG_ON_ZERO(NCAPINTS != 20))
>  
>  #define DISABLED_MASK_BIT_SET(feature_bit)				\
>  	 ( CHECK_BIT_IN_MASK_WORD(DISABLED_MASK,  0, feature_bit) ||	\
> @@ -105,8 +106,9 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
>  	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 16, feature_bit) ||	\
>  	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 17, feature_bit) ||	\
>  	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 18, feature_bit) ||	\
> +	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 19, feature_bit) ||	\
>  	   DISABLED_MASK_CHECK					  ||	\
> -	   BUILD_BUG_ON_ZERO(NCAPINTS != 19))
> +	   BUILD_BUG_ON_ZERO(NCAPINTS != 20))
>  
>  #define cpu_has(c, bit)							\
>  	(__builtin_constant_p(bit) && REQUIRED_MASK_BIT_SET(bit) ? 1 :	\
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 7ba217e894ea..9c1b07674401 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -13,7 +13,7 @@
>  /*
>   * Defines x86 CPU feature bits
>   */
> -#define NCAPINTS			19	   /* N 32-bit words worth of info */
> +#define NCAPINTS			20	   /* N 32-bit words worth of info */
>  #define NBUGINTS			1	   /* N 32-bit bug flags */
>  
>  /*
> diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
> index a5ea841cc6d2..f0f935f8d917 100644
> --- a/arch/x86/include/asm/disabled-features.h
> +++ b/arch/x86/include/asm/disabled-features.h
> @@ -84,6 +84,7 @@
>  #define DISABLED_MASK16	(DISABLE_PKU|DISABLE_OSPKE|DISABLE_LA57|DISABLE_UMIP)
>  #define DISABLED_MASK17	0
>  #define DISABLED_MASK18	0
> -#define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 19)
> +#define DISABLED_MASK19	0
> +#define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 20)
>  
>  #endif /* _ASM_X86_DISABLED_FEATURES_H */
> diff --git a/arch/x86/include/asm/pgtable_32_types.h b/arch/x86/include/asm/pgtable_32_types.h
> index b0bc0fff5f1f..57a11692715e 100644
> --- a/arch/x86/include/asm/pgtable_32_types.h
> +++ b/arch/x86/include/asm/pgtable_32_types.h
> @@ -16,6 +16,7 @@
>  #endif
>  
>  #define pgtable_l5_enabled() 0
> +#define pgtable_kvmxo_enabled() 0
>  
>  #define PGDIR_SIZE	(1UL << PGDIR_SHIFT)
>  #define PGDIR_MASK	(~(PGDIR_SIZE - 1))
> diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
> index 6b55b837ead4..7c7c9d1a199a 100644
> --- a/arch/x86/include/asm/pgtable_64_types.h
> +++ b/arch/x86/include/asm/pgtable_64_types.h
> @@ -43,10 +43,34 @@ static inline bool pgtable_l5_enabled(void)
>  extern unsigned int pgdir_shift;
>  extern unsigned int ptrs_per_p4d;
>  
> +#ifdef CONFIG_KVM_XO
> +extern unsigned int __pgtable_kvmxo_enabled;
> +
> +#ifdef USE_EARLY_PGTABLE
> +/*
> + * cpu_feature_enabled() is not available in early boot code.
> + * Use variable instead.
> + */
> +static inline bool pgtable_kvmxo_enabled(void)
> +{
> +	return __pgtable_kvmxo_enabled;
> +}
> +#else
> +#define pgtable_kvmxo_enabled() cpu_feature_enabled(X86_FEATURE_KVM_XO)
> +#endif /* USE_EARLY_PGTABLE */
> +
> +#else
> +#define pgtable_kvmxo_enabled() 0
> +#endif /* CONFIG_KVM_XO */
> +
>  #endif	/* !__ASSEMBLY__ */
>  
>  #define SHARED_KERNEL_PMD	0
>  
> +#if defined(CONFIG_X86_5LEVEL) || defined(CONFIG_KVM_XO)
> +#define MAX_POSSIBLE_PHYSMEM_BITS	52
> +#endif
> +
>  #ifdef CONFIG_X86_5LEVEL
>  
>  /*
> @@ -64,8 +88,6 @@ extern unsigned int ptrs_per_p4d;
>  #define P4D_SIZE		(_AC(1, UL) << P4D_SHIFT)
>  #define P4D_MASK		(~(P4D_SIZE - 1))
>  
> -#define MAX_POSSIBLE_PHYSMEM_BITS	52
> -
>  #else /* CONFIG_X86_5LEVEL */
>  
>  /*
> diff --git a/arch/x86/include/asm/required-features.h b/arch/x86/include/asm/required-features.h
> index 6847d85400a8..fa5700097f64 100644
> --- a/arch/x86/include/asm/required-features.h
> +++ b/arch/x86/include/asm/required-features.h
> @@ -101,6 +101,7 @@
>  #define REQUIRED_MASK16	0
>  #define REQUIRED_MASK17	0
>  #define REQUIRED_MASK18	0
> -#define REQUIRED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 19)
> +#define REQUIRED_MASK19	0
> +#define REQUIRED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 20)
>  
>  #endif /* _ASM_X86_REQUIRED_FEATURES_H */
> diff --git a/arch/x86/include/asm/sparsemem.h b/arch/x86/include/asm/sparsemem.h
> index 199218719a86..24b305195369 100644
> --- a/arch/x86/include/asm/sparsemem.h
> +++ b/arch/x86/include/asm/sparsemem.h
> @@ -27,8 +27,8 @@
>  # endif
>  #else /* CONFIG_X86_32 */
>  # define SECTION_SIZE_BITS	27 /* matt - 128 is convenient right now */
> -# define MAX_PHYSADDR_BITS	(pgtable_l5_enabled() ? 52 : 44)
> -# define MAX_PHYSMEM_BITS	(pgtable_l5_enabled() ? 52 : 46)
> +# define MAX_PHYSADDR_BITS	((pgtable_l5_enabled() ? 52 : 44) - !!pgtable_kvmxo_enabled())
> +# define MAX_PHYSMEM_BITS	((pgtable_l5_enabled() ? 52 : 46) - !!pgtable_kvmxo_enabled())
>  #endif
>  
>  #endif /* CONFIG_SPARSEMEM */
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 4f08e164c0b1..ee204aefbcfd 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -933,6 +933,11 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
>  		c->x86_capability[CPUID_D_1_EAX] = eax;
>  	}
>  
> +	eax = cpuid_eax(0x40000000);
> +	c->extended_cpuid_level = eax;
> +	if (c->extended_cpuid_level >= 0x40000030)
> +		c->x86_capability[CPUID_4000_0030_EAX] = cpuid_eax(0x40000030);
> +
>  	/* AMD-defined flags: level 0x80000001 */
>  	eax = cpuid_eax(0x80000000);
>  	c->extended_cpuid_level = eax;
> diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
> index 55f5294c3cdf..7091702a7bec 100644
> --- a/arch/x86/kernel/head64.c
> +++ b/arch/x86/kernel/head64.c
> @@ -52,6 +52,11 @@ unsigned int ptrs_per_p4d __ro_after_init = 1;
>  EXPORT_SYMBOL(ptrs_per_p4d);
>  #endif
>  
> +#ifdef CONFIG_KVM_XO
> +unsigned int __pgtable_kvmxo_enabled __ro_after_init;
> +unsigned int __pgtable_kvmxo_bit __ro_after_init;
> +#endif /* CONFIG_KVM_XO */
> +
>  #ifdef CONFIG_DYNAMIC_MEMORY_LAYOUT
>  unsigned long page_offset_base __ro_after_init = __PAGE_OFFSET_BASE_L4;
>  EXPORT_SYMBOL(page_offset_base);
> @@ -73,12 +78,14 @@ static unsigned long __head *fixup_long(void *ptr, unsigned long physaddr)
>  	return fixup_pointer(ptr, physaddr);
>  }
>  
> -#ifdef CONFIG_X86_5LEVEL
> +#if defined(CONFIG_X86_5LEVEL) || defined(CONFIG_KVM_XO)
>  static unsigned int __head *fixup_int(void *ptr, unsigned long physaddr)
>  {
>  	return fixup_pointer(ptr, physaddr);
>  }
> +#endif
>  
> +#ifdef CONFIG_X86_5LEVEL
>  static bool __head check_la57_support(unsigned long physaddr)
>  {
>  	/*
> @@ -104,6 +111,33 @@ static bool __head check_la57_support(unsigned long physaddr)
>  }
>  #endif
>  
> +#ifdef CONFIG_KVM_XO
> +static void __head check_kvmxo_support(unsigned long physaddr)
> +{
> +	unsigned long physbits;
> +
> +	if ((native_cpuid_eax(0x40000000) < 0x40000030) ||
> +	    !(native_cpuid_eax(0x40000030) & (1 << (X86_FEATURE_KVM_XO & 31))))
> +		return;
> +
> +	if (native_cpuid_eax(0x80000000) < 0x80000008)
> +		return;
> +
> +	physbits = native_cpuid_eax(0x80000008) & 0xff;
> +
> +	/*
> +	 * If KVM XO is active, the top physical address bit is the permisison
> +	 * bit, so zero it in the mask.
> +	 */
> +	physical_mask &= ~(1UL << physbits);
> +
> +	*fixup_int(&__pgtable_kvmxo_enabled, physaddr) = 1;
> +	*fixup_int(&__pgtable_kvmxo_bit, physaddr) = physbits;
> +}
> +#else /* CONFIG_KVM_XO */
> +static void __head check_kvmxo_support(unsigned long physaddr) { }
> +#endif /* CONFIG_KVM_XO */
> +
>  /* Code in __startup_64() can be relocated during execution, but the compiler
>   * doesn't have to generate PC-relative relocations when accessing globals from
>   * that function. Clang actually does not generate them, which leads to
> @@ -127,6 +161,8 @@ unsigned long __head __startup_64(unsigned long physaddr,
>  
>  	la57 = check_la57_support(physaddr);
>  
> +	check_kvmxo_support(physaddr);
> +
>  	/* Is the address too large? */
>  	if (physaddr >> MAX_PHYSMEM_BITS)
>  		for (;;);
> diff --git a/tools/arch/x86/include/asm/disabled-features.h b/tools/arch/x86/include/asm/disabled-features.h
> index a5ea841cc6d2..f0f935f8d917 100644
> --- a/tools/arch/x86/include/asm/disabled-features.h
> +++ b/tools/arch/x86/include/asm/disabled-features.h
> @@ -84,6 +84,7 @@
>  #define DISABLED_MASK16	(DISABLE_PKU|DISABLE_OSPKE|DISABLE_LA57|DISABLE_UMIP)
>  #define DISABLED_MASK17	0
>  #define DISABLED_MASK18	0
> -#define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 19)
> +#define DISABLED_MASK19	0
> +#define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 20)
>  
>  #endif /* _ASM_X86_DISABLED_FEATURES_H */
> -- 
> 2.17.1
> 

-- 
Kees Cook
