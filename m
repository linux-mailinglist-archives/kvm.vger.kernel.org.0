Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDAEE2A0A28
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 16:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgJ3PqZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 11:46:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57177 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726239AbgJ3PqY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Oct 2020 11:46:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604072782;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5P4wz46Z0JowkRkOqesEA8WSq8m52UlnRC0dYmwGlm0=;
        b=AoPfCnBViJdaBy32iKW4/LZAdHOYl+cgWmMLGaMQZXpBIsrl2SlN8LJVCb3CP0t1q6aQWi
        qaWK/7pLDcBra4enwuK10MG1LAkb35H3gG86JBnG1HYpQ8Xyb0VgHumVrBXXTbUGIoHr6L
        GL8FBIhDH2T1ot+8R6K/r8AFr04tI+o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-yybn_CkfN7ia_MqzSVbMMA-1; Fri, 30 Oct 2020 11:46:20 -0400
X-MC-Unique: yybn_CkfN7ia_MqzSVbMMA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C9AE107467A;
        Fri, 30 Oct 2020 15:46:19 +0000 (UTC)
Received: from [10.36.114.125] (ovpn-114-125.ams2.redhat.com [10.36.114.125])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D56D6198D;
        Fri, 30 Oct 2020 15:46:16 +0000 (UTC)
Subject: Re: [kvm-unit-tests RFC PATCH v2 4/5] lib: arm/arm64: Add function to
 unmap a page
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, Andrew Jones <drjones@redhat.com>
References: <20201027171944.13933-1-alexandru.elisei@arm.com>
 <20201027171944.13933-5-alexandru.elisei@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <a4ea8427-2894-12b3-7b63-e551eec57a96@redhat.com>
Date:   Fri, 30 Oct 2020 16:46:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201027171944.13933-5-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexandru,

On 10/27/20 6:19 PM, Alexandru Elisei wrote:
> Being able to cause a stage 1 data abort might be useful for future tests.
> Add a function that unmaps a page from the translation tables.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  lib/arm/asm/mmu-api.h |  1 +
>  lib/arm/mmu.c         | 32 ++++++++++++++++++++++++++++++++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/lib/arm/asm/mmu-api.h b/lib/arm/asm/mmu-api.h
> index 2bbe1faea900..305f77c6501f 100644
> --- a/lib/arm/asm/mmu-api.h
> +++ b/lib/arm/asm/mmu-api.h
> @@ -23,4 +23,5 @@ extern void mmu_set_range_ptes(pgd_t *pgtable, uintptr_t virt_offset,
>  			       phys_addr_t phys_start, phys_addr_t phys_end,
>  			       pgprot_t prot);
>  extern void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr);
> +extern void mmu_unmap_page(pgd_t *pgtable, unsigned long vaddr);
>  #endif
> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> index 540a1e842d5b..72ac0be8d146 100644
> --- a/lib/arm/mmu.c
> +++ b/lib/arm/mmu.c
> @@ -232,3 +232,35 @@ void mmu_clear_user(pgd_t *pgtable, unsigned long vaddr)
>  out_flush_tlb:
>  	flush_tlb_page(vaddr);
>  }
> +
> +void mmu_unmap_page(pgd_t *pgtable, unsigned long vaddr)
> +{
> +	pgd_t *pgd;
> +	pmd_t *pmd;
> +	pte_t *pte;
> +
> +	if (!mmu_enabled())
> +		return;
> +
> +	pgd = pgd_offset(pgtable, vaddr);
> +	if (!pgd_valid(*pgd))
> +		return;
> +
> +	pmd = pmd_offset(pgd, vaddr);
> +	if (!pmd_valid(*pmd))
> +		return;
> +
> +	if (pmd_huge(*pmd)) {
> +		WRITE_ONCE(*pmd, 0);
> +		goto out_flush_tlb;
> +	} else {
is the else needed?
> +		pte = pte_offset(pmd, vaddr);
> +		if (!pte_valid(*pte))
> +			return;
> +		WRITE_ONCE(*pte, 0);
> +		goto out_flush_tlb;
> +	}
> +
> +out_flush_tlb:
> +	flush_tlb_page(vaddr);
> +}
> 
This code is very similar to mmu_clear_user() besides the bit to invalidate
Just wondering if we couldn't use the same code and pass a bit offset.
It seems the offsets in PMD and PTE are same for USER bit and valid bit.

But maybe this is far-fetched and not worth the sharing.
I see Drew is not in CC, + Drew

Besides
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

