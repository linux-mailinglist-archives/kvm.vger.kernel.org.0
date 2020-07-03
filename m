Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E4F213A17
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 14:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgGCMaV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 08:30:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59243 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726022AbgGCMaV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jul 2020 08:30:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593779419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fx2bXJNjfkfmj97FzNQkImWp6IRTeqS+rbWch0aaHsM=;
        b=MbK1DzcjGpaiEmho+oWPXvBzYD0MIF42NXFl4a/6G723cZalWfM9gz+mRwV8qe55l+URdy
        ffLFB2v6ELBYLKZO9m9Jkf2LEG3j1dKc4MUNe84rW39iYRubAIeLEdCICwIUM2GPayFB/6
        EPgsg5ISpJaCiTjyoJnrvg+TEi8tqBY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-fY9H51X5OoihE2kS2Eer6g-1; Fri, 03 Jul 2020 08:30:15 -0400
X-MC-Unique: fY9H51X5OoihE2kS2Eer6g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 91BC2193F560;
        Fri,  3 Jul 2020 12:30:14 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.150])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 24B7A5FC36;
        Fri,  3 Jul 2020 12:30:03 +0000 (UTC)
Date:   Fri, 3 Jul 2020 14:30:01 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, frankja@linux.ibm.com,
        thuth@redhat.com, david@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 4/4] lib/vmalloc: allow vm_memalign
 with alignment > PAGE_SIZE
Message-ID: <20200703123001.o7kbtfaeq3rml6zo@kamzik.brq.redhat.com>
References: <20200703115109.39139-1-imbrenda@linux.ibm.com>
 <20200703115109.39139-5-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200703115109.39139-5-imbrenda@linux.ibm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 03, 2020 at 01:51:09PM +0200, Claudio Imbrenda wrote:
> Allow allocating aligned virtual memory with alignment larger than only
> one page.
> 
> Add a check that the backing pages were actually allocated.
> 
> Export the alloc_vpages_aligned function to allow users to allocate
> non-backed aligned virtual addresses.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/vmalloc.h |  3 +++
>  lib/vmalloc.c | 40 ++++++++++++++++++++++++++++++++--------
>  2 files changed, 35 insertions(+), 8 deletions(-)
> 
> diff --git a/lib/vmalloc.h b/lib/vmalloc.h
> index 2b563f4..fa3fa22 100644
> --- a/lib/vmalloc.h
> +++ b/lib/vmalloc.h
> @@ -5,6 +5,9 @@
>  
>  /* Allocate consecutive virtual pages (without backing) */
>  extern void *alloc_vpages(ulong nr);
> +/* Allocate consecutive and aligned virtual pages (without backing) */
> +extern void *alloc_vpages_aligned(ulong nr, unsigned int alignment_pages);
> +
>  /* Allocate one virtual page (without backing) */
>  extern void *alloc_vpage(void);
>  /* Set the top of the virtual address space */
> diff --git a/lib/vmalloc.c b/lib/vmalloc.c
> index 9237a0f..2c482aa 100644
> --- a/lib/vmalloc.c
> +++ b/lib/vmalloc.c
> @@ -12,19 +12,28 @@
>  #include "alloc.h"
>  #include "alloc_phys.h"
>  #include "alloc_page.h"
> +#include <bitops.h>
>  #include "vmalloc.h"
>  
>  static struct spinlock lock;
>  static void *vfree_top = 0;
>  static void *page_root;
>  
> -void *alloc_vpages(ulong nr)
> +/*
> + * Allocate a certain number of pages from the virtual address space (without
> + * physical backing).
> + *
> + * nr is the number of pages to allocate
> + * alignment_pages is the alignment of the allocation *in pages*
> + */
> +static void *alloc_vpages_intern(ulong nr, unsigned int alignment_pages)

This helper function isn't necessary. Just introduce
alloc_vpages_aligned() and then call alloc_vpages_aligned(nr, 1) from
alloc_vpages().

>  {
>  	uintptr_t ptr;
>  
>  	spin_lock(&lock);
>  	ptr = (uintptr_t)vfree_top;
>  	ptr -= PAGE_SIZE * nr;
> +	ptr &= GENMASK_ULL(63, PAGE_SHIFT + get_order(alignment_pages));
>  	vfree_top = (void *)ptr;
>  	spin_unlock(&lock);
>  
> @@ -32,6 +41,16 @@ void *alloc_vpages(ulong nr)
>  	return (void *)ptr;
>  }
>  
> +void *alloc_vpages(ulong nr)
> +{
> +	return alloc_vpages_intern(nr, 1);
> +}
> +
> +void *alloc_vpages_aligned(ulong nr, unsigned int alignment_pages)
> +{
> +	return alloc_vpages_intern(nr, alignment_pages);
> +}
> +
>  void *alloc_vpage(void)
>  {
>  	return alloc_vpages(1);
> @@ -55,17 +74,22 @@ void *vmap(phys_addr_t phys, size_t size)
>  	return mem;
>  }
>  
> +/*
> + * Allocate virtual memory, with the specified minimum alignment.
> + */
>  static void *vm_memalign(size_t alignment, size_t size)
>  {
> +	phys_addr_t pa;
>  	void *mem, *p;
> -	size_t pages;
>  
> -	assert(alignment <= PAGE_SIZE);
> -	size = PAGE_ALIGN(size);
> -	pages = size / PAGE_SIZE;
> -	mem = p = alloc_vpages(pages);
> -	while (pages--) {
> -		phys_addr_t pa = virt_to_phys(alloc_page());
> +	assert(is_power_of_2(alignment));
> +
> +	size = PAGE_ALIGN(size) / PAGE_SIZE;
> +	alignment = PAGE_ALIGN(alignment) / PAGE_SIZE;
> +	mem = p = alloc_vpages_intern(size, alignment);
> +	while (size--) {
> +		pa = virt_to_phys(alloc_page());
> +		assert(pa);
>  		install_page(page_root, pa, p);
>  		p += PAGE_SIZE;
>  	}
> -- 
> 2.26.2
>

Otherwise

Reviewed-by: Andrew Jones <drjones@redhat.com>

Thanks,
drew 

