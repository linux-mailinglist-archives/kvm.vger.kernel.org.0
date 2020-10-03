Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959AF2822A0
	for <lists+kvm@lfdr.de>; Sat,  3 Oct 2020 10:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725772AbgJCIq7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Oct 2020 04:46:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30370 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725648AbgJCIq7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 3 Oct 2020 04:46:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601714816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2jQtJcALDeYTL3NsNlDsYx0cNd3ug04HK+dB9V6M4eo=;
        b=JOoR943Byj1l/It8m8xnYHoWts6B3AccJTKUz4eKT/x21d7XEAVAoR5A/l6t7vqfA2+CgH
        xfCQTtUO6ffwkVku8LzBw8bBBn7Wp3GDTX+WOMst8DiDnrmcZPH+MT08jk380X/09eb7Rr
        FlaXgAGmgflOwchfXHdKvfvtotRPKrI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-Nu-HbliLNv-TBmleXrV-QA-1; Sat, 03 Oct 2020 04:46:52 -0400
X-MC-Unique: Nu-HbliLNv-TBmleXrV-QA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37C4D801ABD;
        Sat,  3 Oct 2020 08:46:51 +0000 (UTC)
Received: from kamzik.brq.redhat.com (ovpn-112-40.ams2.redhat.com [10.36.112.40])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AAC785C1DA;
        Sat,  3 Oct 2020 08:46:42 +0000 (UTC)
Date:   Sat, 3 Oct 2020 10:46:39 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        lvivier@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 2/7] lib/vmalloc: vmalloc support for
 handling allocation metadata
Message-ID: <20201003084639.s36ngidcfqtehygh@kamzik.brq.redhat.com>
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
 <20201002154420.292134-3-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002154420.292134-3-imbrenda@linux.ibm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 02, 2020 at 05:44:15PM +0200, Claudio Imbrenda wrote:
> Add allocation metadata handling to vmalloc.
> 
> In upcoming patches, allocation metadata will have to be handled
> directly bt the lower level allocators, and will not be handled by the
> common wrapper.
> 
> In this patch, the number of allocated pages plus a magic value are
> written immediately before the returned pointer. This means that multi
> page allocations will allocate one extra page (which is not worse than
> what the current allocator does).
> 
> For small allocations there is an optimization: the returned address is
> intentionally not page-aligned. This signals that the allocation
> spanned one page only. In this case the metadata is only the magic
> value, and it is also saved immediately before the returned pointer.
> Since the pointer does not point to the begininng of the page, there is
> always space in the same page for the magic value.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  lib/vmalloc.c | 105 +++++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 95 insertions(+), 10 deletions(-)
> 
> diff --git a/lib/vmalloc.c b/lib/vmalloc.c
> index e0c7b6b..2f25734 100644
> --- a/lib/vmalloc.c
> +++ b/lib/vmalloc.c
> @@ -15,6 +15,16 @@
>  #include <bitops.h>
>  #include "vmalloc.h"
>  
> +#define VM_MAGIC 0x7E57C0DE
> +
> +#define GET_METADATA(x) (((struct metadata *)(x)) - 1)
> +#define GET_MAGIC(x) (*((unsigned long *)(x) - 1))
> +
> +struct metadata {
> +	unsigned long npages;
> +	unsigned long magic;
> +};
> +
>  static struct spinlock lock;
>  static void *vfree_top = 0;
>  static void *page_root;
> @@ -25,8 +35,14 @@ static void *page_root;
>   *
>   * nr is the number of pages to allocate
>   * alignment_pages is the alignment of the allocation *in pages*
> + * metadata indicates whether an extra (unaligned) page needs to be allocated
> + * right before the main (aligned) allocation.
> + *
> + * The return value points to the first allocated virtual page, which will
> + * be the (potentially unaligned) metadata page if the metadata flag is
> + * specified.
>   */
> -void *alloc_vpages_aligned(ulong nr, unsigned int align_order)
> +static void *do_alloc_vpages(ulong nr, unsigned int align_order, bool metadata)
>  {
>  	uintptr_t ptr;
>  
> @@ -34,6 +50,8 @@ void *alloc_vpages_aligned(ulong nr, unsigned int align_order)
>  	ptr = (uintptr_t)vfree_top;
>  	ptr -= PAGE_SIZE * nr;
>  	ptr &= GENMASK_ULL(63, PAGE_SHIFT + align_order);
> +	if (metadata)
> +		ptr -= PAGE_SIZE;
>  	vfree_top = (void *)ptr;
>  	spin_unlock(&lock);
>  
> @@ -41,6 +59,11 @@ void *alloc_vpages_aligned(ulong nr, unsigned int align_order)
>  	return (void *)ptr;
>  }
>  
> +void *alloc_vpages_aligned(ulong nr, unsigned int align_order)
> +{
> +	return do_alloc_vpages(nr, align_order, false);
> +}
> +
>  void *alloc_vpages(ulong nr)
>  {
>  	return alloc_vpages_aligned(nr, 0);
> @@ -69,35 +92,97 @@ void *vmap(phys_addr_t phys, size_t size)
>  	return mem;
>  }
>  
> +/*
> + * Allocate one page, for an object with specified alignment.
> + * The resulting pointer will be aligned to the required alignment, but
> + * intentionally not page-aligned.
> + * The metadata for single pages allocation is just the magic value,
> + * which is placed right before the pointer, like for bigger allocations.
> + */
> +static void *vm_alloc_one_page(size_t alignment)
> +{
> +	void *p;
> +
> +	/* this guarantees that there will be space for the magic value */
> +	assert(alignment >= sizeof(uintptr_t));
> +	assert(alignment < PAGE_SIZE);
> +	p = alloc_vpage();
> +	install_page(page_root, virt_to_phys(alloc_page()), p);
> +	p = (void *)((uintptr_t)p + alignment);
> +	/* write the magic value right before the returned address */
> +	GET_MAGIC(p) = VM_MAGIC;
> +	return p;
> +}
> +
>  /*
>   * Allocate virtual memory, with the specified minimum alignment.
> + * If the allocation fits in one page, only one page is allocated. Otherwise
> + * enough pages are allocated for the object, plus one to keep metadata
> + * information about the allocation.
>   */
>  static void *vm_memalign(size_t alignment, size_t size)
>  {
> +	struct metadata *m;
>  	phys_addr_t pa;
> -	void *mem, *p;
> +	uintptr_t p;
> +	void *mem;
> +	size_t i;
>  
> +	if (!size)
> +		return NULL;
>  	assert(is_power_of_2(alignment));
>  
> +	if (alignment < sizeof(uintptr_t))
> +		alignment = sizeof(uintptr_t);
> +	/* it fits in one page, allocate only one page */
> +	if (alignment + size <= PAGE_SIZE)
> +		return vm_alloc_one_page(alignment);
>  	size = PAGE_ALIGN(size) / PAGE_SIZE;
>  	alignment = get_order(PAGE_ALIGN(alignment) / PAGE_SIZE);
> -	mem = p = alloc_vpages_aligned(size, alignment);
> -	while (size--) {
> +	mem = do_alloc_vpages(size, alignment, true);
> +	p = (uintptr_t)mem;
> +	/* skip the metadata page */
> +	mem = (void *)(p + PAGE_SIZE);
> +	/*
> +	 * time to actually allocate the physical pages to back our virtual
> +	 * allocation; note that we need to allocate one extra page (for the
> +	 * metadata), hence the <=
> +	 */
> +	for (i = 0; i <= size; i++, p += PAGE_SIZE) {
>  		pa = virt_to_phys(alloc_page());
>  		assert(pa);
> -		install_page(page_root, pa, p);
> -		p += PAGE_SIZE;
> +		install_page(page_root, pa, (void *)p);
>  	}
> +	m = GET_METADATA(mem);
> +	m->npages = size;
> +	m->magic = VM_MAGIC;
>  	return mem;
>  }
>  
>  static void vm_free(void *mem, size_t size)
>  {
> -	while (size) {
> -		free_page(phys_to_virt(virt_to_pte_phys(page_root, mem)));
> -		mem += PAGE_SIZE;
> -		size -= PAGE_SIZE;
> +	struct metadata *m;
> +	uintptr_t ptr, end;
> +
> +	/* the pointer is not page-aligned, it was a single-page allocation */
> +	if (!IS_ALIGNED((uintptr_t)mem, PAGE_SIZE)) {
> +		assert(GET_MAGIC(mem) == VM_MAGIC);
> +		ptr = virt_to_pte_phys(page_root, mem) & PAGE_MASK;
> +		free_page(phys_to_virt(ptr));
> +		return;
>  	}
> +
> +	/* the pointer is page-aligned, it was a multi-page allocation */
> +	m = GET_METADATA(mem);
> +	assert(m->magic == VM_MAGIC);
> +	assert(m->npages > 0);
> +	/* free all the pages including the metadata page */
> +	ptr = (uintptr_t)mem - PAGE_SIZE;
> +	end = ptr + m->npages * PAGE_SIZE;
> +	for ( ; ptr < end; ptr += PAGE_SIZE)
> +		free_page(phys_to_virt(virt_to_pte_phys(page_root, (void *)ptr)));
> +	/* free the last one separately to avoid overflow issues */
> +	free_page(phys_to_virt(virt_to_pte_phys(page_root, (void *)ptr)));

I don't get this. How is

 for (p = start; p < end; p += step)
   process(p);
 process(p)

different from

 for (p = start; p <= end; p += step)
   process(p);

To avoid overflow issues we should simple ensure start and end are
computed correctly. Also, I'd prefer 'end' point to the actual end,
not the last included page, e.g. start=0x1000, end=0x1fff. Then we
have

 start = get_start();
 assert(PAGE_ALIGN(start) == start);
 end = start + nr_pages * PAGE_SIZE - 1;
 assert(start < end);
 for (p = start; start < end; p += PAGE_SIZE)
   process(p);

Thanks,
drew


>  }
>  
>  static struct alloc_ops vmalloc_ops = {
> -- 
> 2.26.2
> 

