Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4FB1873D
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 10:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfEII7l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 04:59:41 -0400
Received: from foss.arm.com ([217.140.101.70]:34836 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726798AbfEII71 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 04:59:27 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1BAFF374;
        Thu,  9 May 2019 01:59:27 -0700 (PDT)
Received: from [10.1.215.53] (e121566-lin.cambridge.arm.com [10.1.215.53])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4D0233F575;
        Thu,  9 May 2019 01:59:26 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 4/4] arm: Remove redeundant page zeroing
To:     nadav.amit@gmail.com, Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>
References: <20190503103207.9021-1-nadav.amit@gmail.com>
 <20190503103207.9021-5-nadav.amit@gmail.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <bef927bd-6326-4f4c-6426-403179102e95@arm.com>
Date:   Thu, 9 May 2019 09:59:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190503103207.9021-5-nadav.amit@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/3/19 11:32 AM, nadav.amit@gmail.com wrote:
> From: Nadav Amit <nadav.amit@gmail.com>

Documentation/process/submitting-patches.rst says that the "From" tag is only
needed if you're submitting the patches on behalf of someone else (line 632).

>
> Now that alloc_page() zeros the page, remove the redundant page zeroing.
>
> Suggested-by: Andrew Jones <drjones@redhat.com>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
> ---
>  lib/arm/asm/pgtable.h   | 2 --
>  lib/arm/mmu.c           | 1 -
>  lib/arm64/asm/pgtable.h | 1 -
>  3 files changed, 4 deletions(-)
>
> diff --git a/lib/arm/asm/pgtable.h b/lib/arm/asm/pgtable.h
> index b614bce..241dff6 100644
> --- a/lib/arm/asm/pgtable.h
> +++ b/lib/arm/asm/pgtable.h
> @@ -53,7 +53,6 @@ static inline pmd_t *pmd_alloc_one(void)
>  {
>  	assert(PTRS_PER_PMD * sizeof(pmd_t) == PAGE_SIZE);
>  	pmd_t *pmd = alloc_page();
> -	memset(pmd, 0, PTRS_PER_PMD * sizeof(pmd_t));
>  	return pmd;
>  }
>  static inline pmd_t *pmd_alloc(pgd_t *pgd, unsigned long addr)
> @@ -80,7 +79,6 @@ static inline pte_t *pte_alloc_one(void)
>  {
>  	assert(PTRS_PER_PTE * sizeof(pte_t) == PAGE_SIZE);
>  	pte_t *pte = alloc_page();
> -	memset(pte, 0, PTRS_PER_PTE * sizeof(pte_t));
>  	return pte;
>  }
>  static inline pte_t *pte_alloc(pmd_t *pmd, unsigned long addr)
> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> index 03f6622..3d38c83 100644
> --- a/lib/arm/mmu.c
> +++ b/lib/arm/mmu.c
> @@ -166,7 +166,6 @@ void *setup_mmu(phys_addr_t phys_end)
>  #endif
>  
>  	mmu_idmap = alloc_page();
> -	memset(mmu_idmap, 0, PAGE_SIZE);
>  
>  	/*
>  	 * mach-virt I/O regions:
> diff --git a/lib/arm64/asm/pgtable.h b/lib/arm64/asm/pgtable.h
> index 5860abe..ee0a2c8 100644
> --- a/lib/arm64/asm/pgtable.h
> +++ b/lib/arm64/asm/pgtable.h
> @@ -61,7 +61,6 @@ static inline pte_t *pte_alloc_one(void)
>  {
>  	assert(PTRS_PER_PTE * sizeof(pte_t) == PAGE_SIZE);
>  	pte_t *pte = alloc_page();
> -	memset(pte, 0, PTRS_PER_PTE * sizeof(pte_t));
>  	return pte;
>  }
>  static inline pte_t *pte_alloc(pmd_t *pmd, unsigned long addr)
In the subject line: s/redeundant/redundant (this also applies to patches 2 and 3).

The patch looks reasonable, it removes the calls to memset only when we're
certain that the address came from alloc_page. So with the above minor changes:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

