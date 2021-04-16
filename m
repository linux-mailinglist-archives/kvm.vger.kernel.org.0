Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68CA6362595
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 18:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235385AbhDPQWI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 12:22:08 -0400
Received: from mga04.intel.com ([192.55.52.120]:14422 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235243AbhDPQV7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Apr 2021 12:21:59 -0400
IronPort-SDR: zVEFsmsZ4GgsdbekcNYZLPywQ/MqMAroYE5FFQBgWG2ag06I9n+YuAQ1t5MP4O/g8XGXwZh3oJ
 24zEcsaIxF/A==
X-IronPort-AV: E=McAfee;i="6200,9189,9956"; a="192937960"
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="192937960"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 09:21:35 -0700
IronPort-SDR: Fcy8rkeucZUzDEOy5KtWgRSLaA8b/0KVcVYLuQAwktP3nu+DcFkovbQDcBTf07g8nlx/hk9wlG
 V2d5SU3L8wbA==
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="scan'208";a="453389865"
Received: from mhsedler-mobl1.amr.corp.intel.com (HELO [10.212.149.97]) ([10.212.149.97])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 09:21:34 -0700
Subject: Re: [RFCv2 04/13] x86/kvm: Use bounce buffers for KVM memory
 protection
To:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Peter Gonda <pgonda@google.com>,
        David Hildenbrand <david@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
 <20210416154106.23721-5-kirill.shutemov@linux.intel.com>
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
 z5cecg==
Message-ID: <2ea287f6-9e2f-1607-c9d6-8c985438f989@intel.com>
Date:   Fri, 16 Apr 2021 09:21:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210416154106.23721-5-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/16/21 8:40 AM, Kirill A. Shutemov wrote:
> Mirror SEV, use SWIOTLB always if KVM memory protection is enabled.
...
>  arch/x86/mm/mem_encrypt.c          | 44 ---------------------------
>  arch/x86/mm/mem_encrypt_common.c   | 48 ++++++++++++++++++++++++++++++

The changelog need to at least mention what's going on here.  It doesn't
prepare me at all for having code move around.

> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index d197b3beb904..c51d14db5620 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -812,6 +812,7 @@ config KVM_GUEST
>  	select ARCH_CPUIDLE_HALTPOLL
>  	select X86_HV_CALLBACK_VECTOR
>  	select X86_MEM_ENCRYPT_COMMON
> +	select SWIOTLB
>  	default y
>  	help
>  	  This option enables various optimizations for running under the KVM

So, this feature is always compiled in with KVM.  Could you say a couple
of things about that?  Why did you decide not have a Kconfig option for it?

> diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
> index 31c4df123aa0..a748b30c2f23 100644
> --- a/arch/x86/include/asm/mem_encrypt.h
> +++ b/arch/x86/include/asm/mem_encrypt.h
> @@ -47,10 +47,8 @@ int __init early_set_memory_encrypted(unsigned long vaddr, unsigned long size);
>  
>  void __init mem_encrypt_free_decrypted_mem(void);
>  
> -/* Architecture __weak replacement functions */
> -void __init mem_encrypt_init(void);
> -
>  void __init sev_es_init_vc_handling(void);
> +
>  bool sme_active(void);
>  bool sev_active(void);
>  bool sev_es_active(void);
> @@ -91,6 +89,9 @@ static inline void mem_encrypt_free_decrypted_mem(void) { }
>  
>  #endif	/* CONFIG_AMD_MEM_ENCRYPT */
>  
> +/* Architecture __weak replacement functions */
> +void __init mem_encrypt_init(void);

FWIW, I'd rather have the code movement in separate patches from the
functional changes.

>  /*
>   * The __sme_pa() and __sme_pa_nodebug() macros are meant for use when
>   * writing to or comparing values from the cr3 register.  Having the
> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> index aed6034fcac1..ba179f5ca198 100644
> --- a/arch/x86/kernel/kvm.c
> +++ b/arch/x86/kernel/kvm.c
> @@ -26,6 +26,7 @@
>  #include <linux/kprobes.h>
>  #include <linux/nmi.h>
>  #include <linux/swait.h>
> +#include <linux/swiotlb.h>
>  #include <asm/timer.h>
>  #include <asm/cpu.h>
>  #include <asm/traps.h>
> @@ -765,6 +766,7 @@ static void __init kvm_init_platform(void)
>  		pr_info("KVM memory protection enabled\n");
>  		mem_protected = true;
>  		setup_force_cpu_cap(X86_FEATURE_KVM_MEM_PROTECTED);
> +		swiotlb_force = SWIOTLB_FORCE;
>  	}
>  }
>  
> diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
> index c2cfa5e7c152..814060a6ceb0 100644
> --- a/arch/x86/kernel/pci-swiotlb.c
> +++ b/arch/x86/kernel/pci-swiotlb.c
> @@ -13,6 +13,7 @@
>  #include <asm/dma.h>
>  #include <asm/xen/swiotlb-xen.h>
>  #include <asm/iommu_table.h>
> +#include <asm/kvm_para.h>
>  
>  int swiotlb __read_mostly;
>  
> @@ -49,7 +50,7 @@ int __init pci_swiotlb_detect_4gb(void)
>  	 * buffers are allocated and used for devices that do not support
>  	 * the addressing range required for the encryption mask.
>  	 */
> -	if (sme_active())
> +	if (sme_active() || kvm_mem_protected())
>  		swiotlb = 1;
>  
>  	return swiotlb;

While I don't doubt you got it right, it would be nice to also explain
in the changelog why you manipulate both 'swiotlb_force' and 'swiotlb'.

> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> index 9ca477b9b8ba..3478f20fb46f 100644
> --- a/arch/x86/mm/mem_encrypt.c
> +++ b/arch/x86/mm/mem_encrypt.c
> @@ -409,47 +409,3 @@ void __init mem_encrypt_free_decrypted_mem(void)
>  
>  	free_init_pages("unused decrypted", vaddr, vaddr_end);
>  }
> -
> -static void print_mem_encrypt_feature_info(void)
> -{
> -	pr_info("AMD Memory Encryption Features active:");
> -
> -	/* Secure Memory Encryption */
> -	if (sme_active()) {
> -		/*
> -		 * SME is mutually exclusive with any of the SEV
> -		 * features below.
> -		 */
> -		pr_cont(" SME\n");
> -		return;
> -	}
> -
> -	/* Secure Encrypted Virtualization */
> -	if (sev_active())
> -		pr_cont(" SEV");
> -
> -	/* Encrypted Register State */
> -	if (sev_es_active())
> -		pr_cont(" SEV-ES");
> -
> -	pr_cont("\n");
> -}
> -
> -/* Architecture __weak replacement functions */
> -void __init mem_encrypt_init(void)
> -{
> -	if (!sme_me_mask)
> -		return;
> -
> -	/* Call into SWIOTLB to update the SWIOTLB DMA buffers */
> -	swiotlb_update_mem_attributes();
> -
> -	/*
> -	 * With SEV, we need to unroll the rep string I/O instructions.
> -	 */
> -	if (sev_active())
> -		static_branch_enable(&sev_enable_key);
> -
> -	print_mem_encrypt_feature_info();
> -}
> -
> diff --git a/arch/x86/mm/mem_encrypt_common.c b/arch/x86/mm/mem_encrypt_common.c
> index 6bf0718bb72a..351b77361a5d 100644
> --- a/arch/x86/mm/mem_encrypt_common.c
> +++ b/arch/x86/mm/mem_encrypt_common.c
> @@ -11,6 +11,7 @@
>  #include <linux/mem_encrypt.h>
>  #include <linux/dma-direct.h>
>  #include <asm/kvm_para.h>
> +#include <asm/mem_encrypt.h>
>  
>  /* Override for DMA direct allocation check - ARCH_HAS_FORCE_DMA_UNENCRYPTED */
>  bool force_dma_unencrypted(struct device *dev)
> @@ -37,3 +38,50 @@ bool force_dma_unencrypted(struct device *dev)
>  
>  	return false;
>  }
> +
> +static void print_mem_encrypt_feature_info(void)
> +{
> +	if (kvm_mem_protected()) {
> +		pr_info("KVM memory protection enabled\n");
> +		return;
> +	}

I understand that they're touching similar areas of code, but I'm a bit
unnerved with memory protection being in all these "encryption"
functions and files.

I think some thoughtful renaming is in order.

> +	pr_info("AMD Memory Encryption Features active:");
> +
> +	/* Secure Memory Encryption */
> +	if (sme_active()) {
> +		/*
> +		 * SME is mutually exclusive with any of the SEV
> +		 * features below.
> +		 */
> +		pr_cont(" SME\n");
> +		return;
> +	}
> +
> +	/* Secure Encrypted Virtualization */
> +	if (sev_active())
> +		pr_cont(" SEV");
> +
> +	/* Encrypted Register State */
> +	if (sev_es_active())
> +		pr_cont(" SEV-ES");
> +
> +	pr_cont("\n");
> +}

This, for instance really shouldn't be in common code.  It should be in
an AMD-specific area.

> +void __init mem_encrypt_init(void)
> +{
> +	if (!sme_me_mask && !kvm_mem_protected())
> +		return;
> +
> +	/* Call into SWIOTLB to update the SWIOTLB DMA buffers */
> +	swiotlb_update_mem_attributes();
> +
> +	/*
> +	 * With SEV, we need to unroll the rep string I/O instructions.
> +	 */
> +	if (sev_active())
> +		static_branch_enable(&sev_enable_key);
> +
> +	print_mem_encrypt_feature_info();
> +}

This function is called like this:

>         /*
>          * This needs to be called before any devices perform DMA
>          * operations that might use the SWIOTLB bounce buffers. It will
>          * mark the bounce buffers as decrypted so that their usage will
>          * not cause "plain-text" data to be decrypted when accessed.
>          */
>         mem_encrypt_init();

So, maybe this should be x86_swiotlb_init() or something.  Then, move
the print_mem_encrypt_feature_info() elsewhere, probably back out to
mem_init().  Maybe even just call it print_arch_mem_features() or something.
