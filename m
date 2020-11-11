Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753732AEE9F
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 11:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbgKKKQ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 05:16:57 -0500
Received: from foss.arm.com ([217.140.110.172]:46384 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727109AbgKKKQ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Nov 2020 05:16:56 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 069AB101E;
        Wed, 11 Nov 2020 02:16:56 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 147A33F6CF;
        Wed, 11 Nov 2020 02:16:54 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v3 1/2] arm: Add mmu_get_pte() to the MMU
 API
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>, kvm@vger.kernel.org
Cc:     mark.rutland@arm.com, jade.alglave@arm.com, luc.maranget@inria.fr,
        andre.przywara@arm.com, drjones@redhat.com
References: <20201110180924.95106-1-nikos.nikoleris@arm.com>
 <20201110180924.95106-2-nikos.nikoleris@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <3641d1f0-7d82-e001-dcde-6d00261923d6@arm.com>
Date:   Wed, 11 Nov 2020 10:18:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201110180924.95106-2-nikos.nikoleris@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Nikos,

I tried to apply it on top of master just to make sure everything is correct and I
got a conflict in mmu.c. The line numbers were different, and mmu_clear_user() had
a pud_t *pud local variable, which isn't present in master, but is added by your
series to enable configurable translation granule. Applying on top of that series
worked without any conflicts. Just a heads-up to Drew when it picks them up.

Just to be on the safe side, I ran the tests on a Cortex-A53 and Cortex-A72, with
4k and 64k pages, nothing unexpected. The patch looks good to me.

Thanks,

Alex

On 11/10/20 6:09 PM, Nikos Nikoleris wrote:
> From: Luc Maranget <Luc.Maranget@inria.fr>
>
> Add the mmu_get_pte() function that allows a test to get a pointer to
> the PTE for a valid virtual address. Return NULL if the MMU is off.
>
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Signed-off-by: Luc Maranget <Luc.Maranget@inria.fr>
> Co-Developed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/arm/asm/mmu-api.h |  1 +
>  lib/arm/mmu.c         | 32 +++++++++++++++++++++-----------
>  2 files changed, 22 insertions(+), 11 deletions(-)
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
> index d937f20..a1862a5 100644
> --- a/lib/arm/mmu.c
> +++ b/lib/arm/mmu.c
> @@ -212,7 +212,13 @@ unsigned long __phys_to_virt(phys_addr_t addr)
>  	return addr;
>  }
>  
> -void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
> +/*
> + * NOTE: The Arm architecture might require the use of a
> + * break-before-make sequence before making changes to a PTE and
> + * certain conditions are met (see Arm ARM D5-2669 for AArch64 and
> + * B3-1378 for AArch32 for more details).
> + */
> +pteval_t *mmu_get_pte(pgd_t *pgtable, uintptr_t vaddr)
>  {
>  	pgd_t *pgd;
>  	pud_t *pud;
> @@ -220,7 +226,7 @@ void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
>  	pte_t *pte;
>  
>  	if (!mmu_enabled())
> -		return;
> +		return NULL;
>  
>  	pgd = pgd_offset(pgtable, vaddr);
>  	assert(pgd_valid(*pgd));
> @@ -229,17 +235,21 @@ void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
>  	pmd = pmd_offset(pud, vaddr);
>  	assert(pmd_valid(*pmd));
>  
> -	if (pmd_huge(*pmd)) {
> -		pmd_t entry = __pmd(pmd_val(*pmd) & ~PMD_SECT_USER);
> -		WRITE_ONCE(*pmd, entry);
> -		goto out_flush_tlb;
> -	}
> +	if (pmd_huge(*pmd))
> +		return &pmd_val(*pmd);
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
