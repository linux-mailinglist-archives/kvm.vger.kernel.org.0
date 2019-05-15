Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEC4C1EAE5
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 11:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbfEOJ1V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 05:27:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39804 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbfEOJ1V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 05:27:21 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E6587C057EC6;
        Wed, 15 May 2019 09:27:20 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B49335D9DC;
        Wed, 15 May 2019 09:27:19 +0000 (UTC)
Date:   Wed, 15 May 2019 11:27:17 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [kvm-unit-tests PATCH v3 4/4] arm: Remove redundant page zeroing
Message-ID: <20190515092717.r3tjqo4qrp4xpd6x@kamzik.brq.redhat.com>
References: <20190509200558.12347-1-nadav.amit@gmail.com>
 <20190509200558.12347-5-nadav.amit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509200558.12347-5-nadav.amit@gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Wed, 15 May 2019 09:27:21 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 09, 2019 at 01:05:58PM -0700, Nadav Amit wrote:
> Now that alloc_page() zeros the page, remove the redundant page zeroing.
> 
> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
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
> -- 
> 2.17.1
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
