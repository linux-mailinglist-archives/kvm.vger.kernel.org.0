Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D113186BB
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 10:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhBKJPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 04:15:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27318 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230080AbhBKJL2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Feb 2021 04:11:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613034594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dRw1x5CIje+EbHm23iQaa6l4WW6GIWAovluAFh62J0o=;
        b=Oa4NMcuOWaOICMf/C9csoBZ4y3o6WMx6D01EvKZLPYuzx8zxDGkvN8yB7areQoaOJvBrii
        v9mpScl1VKXwVFJzh6JkASGDwduw83xUCjKoIG1kHKMTj9NUiyYcn2RsE3fhrb1sER/U/N
        RzsQqxJwTRxR8J4pDESv1Ca0PR6PFYA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-572-xpFcwURrNVem02sbpXfynA-1; Thu, 11 Feb 2021 04:09:50 -0500
X-MC-Unique: xpFcwURrNVem02sbpXfynA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C30D1005D49;
        Thu, 11 Feb 2021 09:09:49 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-46.ams2.redhat.com [10.36.112.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D8FD362A33;
        Thu, 11 Feb 2021 09:09:43 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v1 2/4] s390x: lib: fix and improve
 pgtable.h
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com,
        frankja@linux.ibm.com, cohuck@redhat.com, pmorel@linux.ibm.com
References: <20210209143835.1031617-1-imbrenda@linux.ibm.com>
 <20210209143835.1031617-3-imbrenda@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <80589037-53d1-e187-d1b0-3739ff3597f2@redhat.com>
Date:   Thu, 11 Feb 2021 10:09:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210209143835.1031617-3-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/02/2021 15.38, Claudio Imbrenda wrote:
> Fix and improve pgtable.h:
> 
> * SEGMENT_ENTRY_SFAA had one extra bit set
> * pmd entries don't have a length
> * ipte does not need to clear the lower bits
> * add macros to check whether a pmd or a pud are large / huge
> * add idte functions for pmd, pud, p4d and pgd
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   lib/s390x/asm/pgtable.h | 38 ++++++++++++++++++++++++++++++++++----
>   1 file changed, 34 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/s390x/asm/pgtable.h b/lib/s390x/asm/pgtable.h
> index 277f3480..4269ab62 100644
> --- a/lib/s390x/asm/pgtable.h
> +++ b/lib/s390x/asm/pgtable.h
> @@ -60,7 +60,7 @@
>   #define SEGMENT_SHIFT			20
>   
>   #define SEGMENT_ENTRY_ORIGIN		0xfffffffffffff800UL
> -#define SEGMENT_ENTRY_SFAA		0xfffffffffff80000UL
> +#define SEGMENT_ENTRY_SFAA		0xfffffffffff00000UL
>   #define SEGMENT_ENTRY_AV		0x0000000000010000UL
>   #define SEGMENT_ENTRY_ACC		0x000000000000f000UL
>   #define SEGMENT_ENTRY_F			0x0000000000000800UL
> @@ -100,6 +100,9 @@
>   #define pmd_none(entry) (pmd_val(entry) & SEGMENT_ENTRY_I)
>   #define pte_none(entry) (pte_val(entry) & PAGE_ENTRY_I)
>   
> +#define pud_huge(entry)  (pud_val(entry) & REGION3_ENTRY_FC)
> +#define pmd_large(entry) (pmd_val(entry) & SEGMENT_ENTRY_FC)
> +
>   #define pgd_addr(entry) __va(pgd_val(entry) & REGION_ENTRY_ORIGIN)
>   #define p4d_addr(entry) __va(p4d_val(entry) & REGION_ENTRY_ORIGIN)
>   #define pud_addr(entry) __va(pud_val(entry) & REGION_ENTRY_ORIGIN)
> @@ -202,21 +205,48 @@ static inline pte_t *pte_alloc(pmd_t *pmd, unsigned long addr)
>   {
>   	if (pmd_none(*pmd)) {
>   		pte_t *pte = pte_alloc_one();
> -		pmd_val(*pmd) = __pa(pte) | SEGMENT_ENTRY_TT_SEGMENT |
> -				SEGMENT_TABLE_LENGTH;
> +		pmd_val(*pmd) = __pa(pte) | SEGMENT_ENTRY_TT_SEGMENT;

I think you could even remove the #define SEGMENT_TABLE_LENGTH now, since 
this define does not make much sense, does it?

>   	}
>   	return pte_offset(pmd, addr);
>   }
>   
>   static inline void ipte(unsigned long vaddr, pteval_t *p_pte)
>   {
> -	unsigned long table_origin = (unsigned long)p_pte & PAGE_MASK;
> +	unsigned long table_origin = (unsigned long)p_pte;
>   
>   	asm volatile(
>   		"	ipte %0,%1\n"
>   		: : "a" (table_origin), "a" (vaddr) : "memory");
>   }
>   
> +static inline void idte(unsigned long table_origin, unsigned long vaddr)
> +{
> +	vaddr &= SEGMENT_ENTRY_SFAA;
> +	asm volatile(
> +		"	idte %0,0,%1\n"
> +		: : "a" (table_origin), "a" (vaddr) : "memory");
> +}
> +
> +static inline void idte_pmdp(unsigned long vaddr, pmdval_t *pmdp)
> +{
> +	idte((unsigned long)(pmdp - pmd_index(vaddr)) | ASCE_DT_SEGMENT, vaddr);
> +}
> +
> +static inline void idte_pudp(unsigned long vaddr, pudval_t *pudp)
> +{
> +	idte((unsigned long)(pudp - pud_index(vaddr)) | ASCE_DT_REGION3, vaddr);
> +}
> +
> +static inline void idte_p4dp(unsigned long vaddr, p4dval_t *p4dp)
> +{
> +	idte((unsigned long)(p4dp - p4d_index(vaddr)) | ASCE_DT_REGION2, vaddr);
> +}
> +
> +static inline void idte_pgdp(unsigned long vaddr, pgdval_t *pgdp)
> +{
> +	idte((unsigned long)(pgdp - pgd_index(vaddr)) | ASCE_DT_REGION1, vaddr);
> +}

I think it would be cleaner to separate the fixes from the new functions, 
i.e. put the new functions into a separate patch.

  Thomas

