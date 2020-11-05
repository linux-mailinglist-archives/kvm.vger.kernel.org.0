Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 792412A80D4
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 15:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730669AbgKEO0s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 09:26:48 -0500
Received: from foss.arm.com ([217.140.110.172]:34032 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726874AbgKEO0r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Nov 2020 09:26:47 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0125614BF;
        Thu,  5 Nov 2020 06:26:47 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2B9923F719;
        Thu,  5 Nov 2020 06:26:46 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 1/2] arm: Add mmu_get_pte() to the MMU API
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org
Cc:     mark.rutland@arm.com, jade.alglave@arm.com, luc.maranget@inria.fr,
        andre.przywara@arm.com
References: <20201102115311.103750-1-nikos.nikoleris@arm.com>
 <20201102115311.103750-2-nikos.nikoleris@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <f347911e-bca6-3124-7f4a-4a61ec0cb7ab@arm.com>
Date:   Thu, 5 Nov 2020 14:27:50 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201102115311.103750-2-nikos.nikoleris@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Nikos,

Very good idea! Minor comments below.

On 11/2/20 11:53 AM, Nikos Nikoleris wrote:
> From: Luc Maranget <Luc.Maranget@inria.fr>
>
> Add the mmu_get_pte() function that allows a test to get a pointer to
> the PTE for a valid virtual address. Return NULL if the MMU is off.
>
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

Missing Signed-off-by from Luc Maranget.

> ---
>  lib/arm/asm/mmu-api.h |  1 +
>  lib/arm/mmu.c         | 23 ++++++++++++++---------
>  2 files changed, 15 insertions(+), 9 deletions(-)
>
> diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
> index 2bbe1fa..3d04d03 100644
> --- a/lib/arm/asm/mmu-api.h
> +++ b/lib/arm/asm/mmu-api.h
> @@ -22,5 +22,6 @@ extern void mmu_set_range_sect(pgd_t *pgtable, uintptr_t virt_offset,
>  extern void mmu_set_range_ptes(pgd_t *pgtable, uintptr_t virt_offset,
>  			       phys_addr_t phys_start, phys_addr_t phys_end,
>  			       pgprot_t prot);
> +extern pteval_t *mmu_get_pte(pgd_t *pgtable, uintptr_t vaddr);
>  extern void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr);
>  #endif
> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> index 51fa745..2113604 100644
> --- a/lib/arm/mmu.c
> +++ b/lib/arm/mmu.c
> @@ -210,7 +210,7 @@ unsigned long __phys_to_virt(phys_addr_t addr)
>  	return addr;
>  }
>  
> -void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
> +pteval_t *mmu_get_pte(pgd_t *pgtable, uintptr_t vaddr)

I was thinking it might be nice to have a comment here reminding callers to use
break-before-make when necessary, with a reference to the pages in the Arm ARM
where the exact conditions can be found (D5-2669 for armv8, B3-1378 for armv7). It
might save someone a lot of time debugging a once in 100 runs bug because they
forgot to do break-before-make. And having the exact page number will make it much
easier to find the relevant section.

>  {
>  	pgd_t *pgd;
>  	pud_t *pud;
> @@ -218,7 +218,7 @@ void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
>  	pte_t *pte;
>  
>  	if (!mmu_enabled())
> -		return;
> +		return NULL;
>  
>  	pgd = pgd_offset(pgtable, vaddr);
>  	assert(pgd_valid(*pgd));
> @@ -228,16 +228,21 @@ void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
>  	assert(pmd_valid(*pmd));
>  
>  	if (pmd_huge(*pmd)) {
> -		pmd_t entry = __pmd(pmd_val(*pmd) & ~PMD_SECT_USER);
> -		WRITE_ONCE(*pmd, entry);
> -		goto out_flush_tlb;
> +		return &pmd_val(*pmd);
>  	}

The braces are unnecessary now.

With the comments above fixed:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex
>  
>  	pte = pte_offset(pmd, vaddr);
>  	assert(pte_valid(*pte));
> -	pte_t entry = __pte(pte_val(*pte) & ~PTE_USER);
> -	WRITE_ONCE(*pte, entry);
>  
> -out_flush_tlb:
> -	flush_tlb_page(vaddr);
> +        return &pte_val(*pte);
> +}
> +
> +void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
> +{
> +	pteval_t *p_pte = mmu_get_pte(pgtable, vaddr);
> +	if (p_pte) {
> +		pteval_t entry = *p_pte & ~PTE_USER;
> +		WRITE_ONCE(*p_pte, entry);
> +		flush_tlb_page(vaddr);
> +	}
>  }
