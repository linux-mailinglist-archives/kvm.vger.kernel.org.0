Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05F41A2174
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 18:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbfH2Qw0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 12:52:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:37824 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727565AbfH2Qw0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 12:52:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4C677AF95;
        Thu, 29 Aug 2019 16:52:24 +0000 (UTC)
Date:   Thu, 29 Aug 2019 18:52:18 +0200
From:   Borislav Petkov <bp@suse.de>
To:     "Singh, Brijesh" <brijesh.singh@amd.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 10/11] mm: x86: Invoke hypercall when page encryption
 status is changed
Message-ID: <20190829165218.GD2132@zn.tnic>
References: <20190710201244.25195-1-brijesh.singh@amd.com>
 <20190710201244.25195-11-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190710201244.25195-11-brijesh.singh@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 10, 2019 at 08:13:11PM +0000, Singh, Brijesh wrote:

> Subject: Re: [PATCH v3 10/11] mm: x86: Invoke hypercall when page encryption status is changed

Subject prefix: "x86/mm: Invoke ..."

git log <filename> would usually show you how the prefixing should look
like.

> Invoke a hypercall when a memory region is changed from encrypted ->
> decrypted and vice versa. Hypervisor need to know the page encryption
> status during the guest migration.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: "Radim Krčmář" <rkrcmar@redhat.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/include/asm/mem_encrypt.h |  3 ++
>  arch/x86/mm/mem_encrypt.c          | 45 +++++++++++++++++++++++++++++-
>  arch/x86/mm/pageattr.c             | 15 ++++++++++
>  3 files changed, 62 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/mem_encrypt.h b/arch/x86/include/asm/mem_encrypt.h
> index 0c196c47d621..6e654ab5a8e4 100644
> --- a/arch/x86/include/asm/mem_encrypt.h
> +++ b/arch/x86/include/asm/mem_encrypt.h
> @@ -94,4 +94,7 @@ extern char __start_bss_decrypted[], __end_bss_decrypted[], __start_bss_decrypte
>  
>  #endif	/* __ASSEMBLY__ */
>  
> +extern void set_memory_enc_dec_hypercall(unsigned long vaddr,
> +					 unsigned long size, bool enc);
> +
>  #endif	/* __X86_MEM_ENCRYPT_H__ */
> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> index e0df96fdfe46..f3fda1de2869 100644
> --- a/arch/x86/mm/mem_encrypt.c
> +++ b/arch/x86/mm/mem_encrypt.c
> @@ -15,6 +15,7 @@
>  #include <linux/dma-direct.h>
>  #include <linux/swiotlb.h>
>  #include <linux/mem_encrypt.h>
> +#include <linux/kvm_para.h>
>  
>  #include <asm/tlbflush.h>
>  #include <asm/fixmap.h>
> @@ -25,6 +26,7 @@
>  #include <asm/processor-flags.h>
>  #include <asm/msr.h>
>  #include <asm/cmdline.h>
> +#include <asm/kvm_para.h>
>  
>  #include "mm_internal.h"
>  
> @@ -192,6 +194,45 @@ void __init sme_early_init(void)
>  		swiotlb_force = SWIOTLB_FORCE;
>  }
>  
> +void set_memory_enc_dec_hypercall(unsigned long vaddr, unsigned long sz, bool enc)
> +{
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
>  static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
>  {
>  	pgprot_t old_prot, new_prot;
> @@ -249,12 +290,13 @@ static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
>  static int __init early_set_memory_enc_dec(unsigned long vaddr,
>  					   unsigned long size, bool enc)
>  {
> -	unsigned long vaddr_end, vaddr_next;
> +	unsigned long vaddr_end, vaddr_next, start;
>  	unsigned long psize, pmask;
>  	int split_page_size_mask;
>  	int level, ret;
>  	pte_t *kpte;
>  
> +	start = vaddr;
>  	vaddr_next = vaddr;
>  	vaddr_end = vaddr + size;
>  
> @@ -309,6 +351,7 @@ static int __init early_set_memory_enc_dec(unsigned long vaddr,
>  
>  	ret = 0;
>  
> +	set_memory_enc_dec_hypercall(start, size, enc);

That function iterates the same way over the virtual addresses as
early_set_memory_enc_dec() does. Please call kvm_sev_hypercall3(),
wrapped of course, directly from early_set_memory_enc_dec(), for
each iteration of the loop instead of iterating over all the virtual
addresses a second time in set_memory_enc_dec_hypercall().

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 247165, AG München
