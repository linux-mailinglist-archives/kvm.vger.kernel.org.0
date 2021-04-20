Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE63536559A
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 11:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbhDTJkX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 05:40:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59542 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229937AbhDTJkW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Apr 2021 05:40:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618911591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7sWRozUdZOTDSWH44pqId+a7eHo5mZxw3UWB7bjXCJI=;
        b=SSs6jfwACui1woSgqBvneOW8Drdv9Q0b9GP76GLE9Cnx2I3spERkXhH177XzW3b844VTQa
        8hnuI6eX4SCKdGAZPWfYvyZQML3Zig/1QPOPxY4Zpwq88YXZiA+fLaB3Vy2rQynae1kUot
        JvRZyjxAa+cmMrH1nQd4sfk4Jl+5ujg=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-811kUGCHOsG2ZSxpV5shsw-1; Tue, 20 Apr 2021 05:39:19 -0400
X-MC-Unique: 811kUGCHOsG2ZSxpV5shsw-1
Received: by mail-ed1-f70.google.com with SMTP id p16-20020a0564021550b029038522733b66so4730009edx.11
        for <kvm@vger.kernel.org>; Tue, 20 Apr 2021 02:39:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7sWRozUdZOTDSWH44pqId+a7eHo5mZxw3UWB7bjXCJI=;
        b=e00XO0lRgH8kEpV6F9X4xLidmPrsISMyDIAqdGqoYSXf7cpiHUgWmB9K/tCp/WBLbZ
         pqm0yiO94HB2g43Gh28YhKh+/6iEEjomrdZinOeyDQifQ1cgu3M/4zL2fikhy4G7pFof
         7RF6IC3LmlIGwNJEo13uGiy2Vv5ifGKC0IP5NVMFxACg4PZ0c/T+z1fmXjezRqPKtpQS
         yYohIezReQCiYd3MvTJbKiwbIFrodFVyb6/BiWNSHqiuThNr1cYKsQZ2hnRbrRhYAt3F
         eTR48gamtRWLMgbJVcUIZlF9VLPVR5og5ffYMatvXezrT7bYj8juxmgnUbhU7JcaiDMW
         QLQQ==
X-Gm-Message-State: AOAM530xHbcKEiMZkVNhDLz5Qvy4lUmQCXzvEv43NUtpcn9GbY12hkRa
        uH6Dj0cYV9Zdo0JiMqPRru+GdnMmDtQ6dee11+PBtGuiYasL+i23PluzLnV2ERv+J15U+oaISxU
        A1PXHGLGPkwIS
X-Received: by 2002:aa7:d85a:: with SMTP id f26mr19697542eds.305.1618911558272;
        Tue, 20 Apr 2021 02:39:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwEmxJ2tCRr0SWSOMB8OVKhoPXgyNNIywNQY/un8EStcgKNNZOrvJF2rM2tTEb/g9xrL+QMog==
X-Received: by 2002:aa7:d85a:: with SMTP id f26mr19697511eds.305.1618911558108;
        Tue, 20 Apr 2021 02:39:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t17sm3662738edv.3.2021.04.20.02.39.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Apr 2021 02:39:17 -0700 (PDT)
Subject: Re: [PATCH v13 09/12] mm: x86: Invoke hypercall when page encryption
 status is changed
To:     Ashish Kalra <Ashish.Kalra@amd.com>, bp@suse.de
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, thomas.lendacky@amd.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, seanjc@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
References: <cover.1618498113.git.ashish.kalra@amd.com>
 <f2340642c5b8d597a099285194fca8d05c9843bd.1618498113.git.ashish.kalra@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <faf98f6d-3f7a-978b-5705-614e4e692bfb@redhat.com>
Date:   Tue, 20 Apr 2021 11:39:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <f2340642c5b8d597a099285194fca8d05c9843bd.1618498113.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/04/21 17:57, Ashish Kalra wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> Invoke a hypercall when a memory region is changed from encrypted ->
> decrypted and vice versa. Hypervisor needs to know the page encryption
> status during the guest migration.

Boris, can you ack this patch?

Paolo

> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Reviewed-by: Steve Rutherford <srutherford@google.com>
> Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>   arch/x86/include/asm/paravirt.h       | 10 +++++
>   arch/x86/include/asm/paravirt_types.h |  2 +
>   arch/x86/kernel/paravirt.c            |  1 +
>   arch/x86/mm/mem_encrypt.c             | 57 ++++++++++++++++++++++++++-
>   arch/x86/mm/pat/set_memory.c          |  7 ++++
>   5 files changed, 76 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
> index 4abf110e2243..efaa3e628967 100644
> --- a/arch/x86/include/asm/paravirt.h
> +++ b/arch/x86/include/asm/paravirt.h
> @@ -84,6 +84,12 @@ static inline void paravirt_arch_exit_mmap(struct mm_struct *mm)
>   	PVOP_VCALL1(mmu.exit_mmap, mm);
>   }
>   
> +static inline void page_encryption_changed(unsigned long vaddr, int npages,
> +						bool enc)
> +{
> +	PVOP_VCALL3(mmu.page_encryption_changed, vaddr, npages, enc);
> +}
> +
>   #ifdef CONFIG_PARAVIRT_XXL
>   static inline void load_sp0(unsigned long sp0)
>   {
> @@ -799,6 +805,10 @@ static inline void paravirt_arch_dup_mmap(struct mm_struct *oldmm,
>   static inline void paravirt_arch_exit_mmap(struct mm_struct *mm)
>   {
>   }
> +
> +static inline void page_encryption_changed(unsigned long vaddr, int npages, bool enc)
> +{
> +}
>   #endif
>   #endif /* __ASSEMBLY__ */
>   #endif /* _ASM_X86_PARAVIRT_H */
> diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
> index de87087d3bde..69ef9c207b38 100644
> --- a/arch/x86/include/asm/paravirt_types.h
> +++ b/arch/x86/include/asm/paravirt_types.h
> @@ -195,6 +195,8 @@ struct pv_mmu_ops {
>   
>   	/* Hook for intercepting the destruction of an mm_struct. */
>   	void (*exit_mmap)(struct mm_struct *mm);
> +	void (*page_encryption_changed)(unsigned long vaddr, int npages,
> +					bool enc);
>   
>   #ifdef CONFIG_PARAVIRT_XXL
>   	struct paravirt_callee_save read_cr2;
> diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
> index c60222ab8ab9..9f206e192f6b 100644
> --- a/arch/x86/kernel/paravirt.c
> +++ b/arch/x86/kernel/paravirt.c
> @@ -335,6 +335,7 @@ struct paravirt_patch_template pv_ops = {
>   			(void (*)(struct mmu_gather *, void *))tlb_remove_page,
>   
>   	.mmu.exit_mmap		= paravirt_nop,
> +	.mmu.page_encryption_changed	= paravirt_nop,
>   
>   #ifdef CONFIG_PARAVIRT_XXL
>   	.mmu.read_cr2		= __PV_IS_CALLEE_SAVE(native_read_cr2),
> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> index ae78cef79980..fae9ccbd0da7 100644
> --- a/arch/x86/mm/mem_encrypt.c
> +++ b/arch/x86/mm/mem_encrypt.c
> @@ -19,6 +19,7 @@
>   #include <linux/kernel.h>
>   #include <linux/bitops.h>
>   #include <linux/dma-mapping.h>
> +#include <linux/kvm_para.h>
>   
>   #include <asm/tlbflush.h>
>   #include <asm/fixmap.h>
> @@ -29,6 +30,7 @@
>   #include <asm/processor-flags.h>
>   #include <asm/msr.h>
>   #include <asm/cmdline.h>
> +#include <asm/kvm_para.h>
>   
>   #include "mm_internal.h"
>   
> @@ -229,6 +231,47 @@ void __init sev_setup_arch(void)
>   	swiotlb_adjust_size(size);
>   }
>   
> +static void set_memory_enc_dec_hypercall(unsigned long vaddr, int npages,
> +					bool enc)
> +{
> +	unsigned long sz = npages << PAGE_SHIFT;
> +	unsigned long vaddr_end, vaddr_next;
> +
> +	vaddr_end = vaddr + sz;
> +
> +	for (; vaddr < vaddr_end; vaddr = vaddr_next) {
> +		int psize, pmask, level;
> +		unsigned long pfn;
> +		pte_t *kpte;
> +
> +		kpte = lookup_address(vaddr, &level);
> +		if (!kpte || pte_none(*kpte))
> +			return;
> +
> +		switch (level) {
> +		case PG_LEVEL_4K:
> +			pfn = pte_pfn(*kpte);
> +			break;
> +		case PG_LEVEL_2M:
> +			pfn = pmd_pfn(*(pmd_t *)kpte);
> +			break;
> +		case PG_LEVEL_1G:
> +			pfn = pud_pfn(*(pud_t *)kpte);
> +			break;
> +		default:
> +			return;
> +		}
> +
> +		psize = page_level_size(level);
> +		pmask = page_level_mask(level);
> +
> +		kvm_sev_hypercall3(KVM_HC_PAGE_ENC_STATUS,
> +				   pfn << PAGE_SHIFT, psize >> PAGE_SHIFT, enc);
> +
> +		vaddr_next = (vaddr & pmask) + psize;
> +	}
> +}
> +
>   static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
>   {
>   	pgprot_t old_prot, new_prot;
> @@ -286,12 +329,13 @@ static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
>   static int __init early_set_memory_enc_dec(unsigned long vaddr,
>   					   unsigned long size, bool enc)
>   {
> -	unsigned long vaddr_end, vaddr_next;
> +	unsigned long vaddr_end, vaddr_next, start;
>   	unsigned long psize, pmask;
>   	int split_page_size_mask;
>   	int level, ret;
>   	pte_t *kpte;
>   
> +	start = vaddr;
>   	vaddr_next = vaddr;
>   	vaddr_end = vaddr + size;
>   
> @@ -346,6 +390,8 @@ static int __init early_set_memory_enc_dec(unsigned long vaddr,
>   
>   	ret = 0;
>   
> +	set_memory_enc_dec_hypercall(start, PAGE_ALIGN(size) >> PAGE_SHIFT,
> +					enc);
>   out:
>   	__flush_tlb_all();
>   	return ret;
> @@ -481,6 +527,15 @@ void __init mem_encrypt_init(void)
>   	if (sev_active() && !sev_es_active())
>   		static_branch_enable(&sev_enable_key);
>   
> +#ifdef CONFIG_PARAVIRT
> +	/*
> +	 * With SEV, we need to make a hypercall when page encryption state is
> +	 * changed.
> +	 */
> +	if (sev_active())
> +		pv_ops.mmu.page_encryption_changed = set_memory_enc_dec_hypercall;
> +#endif
> +
>   	print_mem_encrypt_feature_info();
>   }
>   
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index 16f878c26667..3576b583ac65 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -27,6 +27,7 @@
>   #include <asm/proto.h>
>   #include <asm/memtype.h>
>   #include <asm/set_memory.h>
> +#include <asm/paravirt.h>
>   
>   #include "../mm_internal.h"
>   
> @@ -2012,6 +2013,12 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
>   	 */
>   	cpa_flush(&cpa, 0);
>   
> +	/* Notify hypervisor that a given memory range is mapped encrypted
> +	 * or decrypted. The hypervisor will use this information during the
> +	 * VM migration.
> +	 */
> +	page_encryption_changed(addr, numpages, enc);
> +
>   	return ret;
>   }
>   
> 

