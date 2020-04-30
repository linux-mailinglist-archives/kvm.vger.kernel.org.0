Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0958E1BF47B
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 11:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgD3Jti (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 05:49:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:41270 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726404AbgD3Jti (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 05:49:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id C02DBADB3;
        Thu, 30 Apr 2020 09:49:33 +0000 (UTC)
Subject: Re: [PATCH v7 11/18] mm: x86: Invoke hypercall when page encryption
 status is changed
To:     Ashish Kalra <Ashish.Kalra@amd.com>, pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com
References: <cover.1588234824.git.ashish.kalra@amd.com>
 <c167e7191cb8f9c7635f5d8cfecb1157cc96cf6b.1588234824.git.ashish.kalra@amd.com>
From:   =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Message-ID: <486fe740-0c2d-9d2b-d490-bdb3215a120c@suse.com>
Date:   Thu, 30 Apr 2020 11:49:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <c167e7191cb8f9c7635f5d8cfecb1157cc96cf6b.1588234824.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30.04.20 10:45, Ashish Kalra wrote:
> From: Brijesh Singh <Brijesh.Singh@amd.com>
> 
> Invoke a hypercall when a memory region is changed from encrypted ->
> decrypted and vice versa. Hypervisor needs to know the page encryption
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
> Reviewed-by: Venu Busireddy <venu.busireddy@oracle.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>   arch/x86/include/asm/paravirt.h       | 10 +++++
>   arch/x86/include/asm/paravirt_types.h |  2 +
>   arch/x86/kernel/paravirt.c            |  1 +
>   arch/x86/mm/mem_encrypt.c             | 58 ++++++++++++++++++++++++++-
>   arch/x86/mm/pat/set_memory.c          |  7 ++++
>   5 files changed, 77 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
> index 694d8daf4983..8127b9c141bf 100644
> --- a/arch/x86/include/asm/paravirt.h
> +++ b/arch/x86/include/asm/paravirt.h
> @@ -78,6 +78,12 @@ static inline void paravirt_arch_exit_mmap(struct mm_struct *mm)
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
> @@ -946,6 +952,10 @@ static inline void paravirt_arch_dup_mmap(struct mm_struct *oldmm,
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
> index 732f62e04ddb..03bfd515c59c 100644
> --- a/arch/x86/include/asm/paravirt_types.h
> +++ b/arch/x86/include/asm/paravirt_types.h
> @@ -215,6 +215,8 @@ struct pv_mmu_ops {
>   
>   	/* Hook for intercepting the destruction of an mm_struct. */
>   	void (*exit_mmap)(struct mm_struct *mm);
> +	void (*page_encryption_changed)(unsigned long vaddr, int npages,
> +					bool enc);
>   
>   #ifdef CONFIG_PARAVIRT_XXL
>   	struct paravirt_callee_save read_cr2;
> diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
> index c131ba4e70ef..840c02b23aeb 100644
> --- a/arch/x86/kernel/paravirt.c
> +++ b/arch/x86/kernel/paravirt.c
> @@ -367,6 +367,7 @@ struct paravirt_patch_template pv_ops = {
>   			(void (*)(struct mmu_gather *, void *))tlb_remove_page,
>   
>   	.mmu.exit_mmap		= paravirt_nop,
> +	.mmu.page_encryption_changed	= paravirt_nop,
>   
>   #ifdef CONFIG_PARAVIRT_XXL
>   	.mmu.read_cr2		= __PV_IS_CALLEE_SAVE(native_read_cr2),
> diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
> index f4bd4b431ba1..603f5abf8a78 100644
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
> @@ -196,6 +198,48 @@ void __init sme_early_init(void)
>   		swiotlb_force = SWIOTLB_FORCE;
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
> +		if (x86_platform.hyper.sev_migration_hcall)
> +			x86_platform.hyper.sev_migration_hcall(pfn << PAGE_SHIFT,
> +							       psize >> PAGE_SHIFT,
> +							       enc);

Why do you need two indirections? One via pv.mmu_ops and then another
via x86_platform.hyper? Isn't one enough?

And if x86_platform.hyper.sev_migration_hcall isn't set the whole loop
is basically a nop.

> +		vaddr_next = (vaddr & pmask) + psize;
> +	}
> +}
> +
>   static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
>   {
>   	pgprot_t old_prot, new_prot;
> @@ -253,12 +297,13 @@ static void __init __set_clr_pte_enc(pte_t *kpte, int level, bool enc)
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
> @@ -313,6 +358,8 @@ static int __init early_set_memory_enc_dec(unsigned long vaddr,
>   
>   	ret = 0;
>   
> +	set_memory_enc_dec_hypercall(start, PAGE_ALIGN(size) >> PAGE_SHIFT,
> +					enc);
>   out:
>   	__flush_tlb_all();
>   	return ret;
> @@ -451,6 +498,15 @@ void __init mem_encrypt_init(void)
>   	if (sev_active())
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
>   	pr_info("AMD %s active\n",
>   		sev_active() ? "Secure Encrypted Virtualization (SEV)"
>   			     : "Secure Memory Encryption (SME)");
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index 59eca6a94ce7..9aaf1b6f5a1b 100644
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
> @@ -2003,6 +2004,12 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
>   	 */
>   	cpa_flush(&cpa, 0);
>   
> +	/* Notify hypervisor that a given memory range is mapped encrypted
> +	 * or decrypted. The hypervisor will use this information during the
> +	 * VM migration.
> +	 */
> +	page_encryption_changed(addr, numpages, enc);

Is this operation really so performance critical that a pv-op is
needed? Wouldn't a static key be sufficient here?

> +
>   	return ret;
>   }
>   
> 


Juergen
