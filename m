Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4813E283CE1
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 18:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbgJEQyK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 12:54:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20334 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725939AbgJEQyK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 5 Oct 2020 12:54:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601916848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EulLPDnePNYf0txrxind0sxCky60bmOxP9pb6aVk+Co=;
        b=a/39Gy+UI6yZadl+LkCfLP/w1ljp5ADbCfsxBb2nnE2a9c8eTrnRUwbMh8V6Ti3aV20FJ8
        /u5+iQvdAulMn5tHrZWql/fhpWyU84f/UPaNKVVRGvgweWlay7fqs/+Tk1rCRld6fAas3/
        HgosDOXXHCLEjG1kPoZCerOhatkVyHA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-stKb3_uTP3CLozs-_B-SWw-1; Mon, 05 Oct 2020 12:54:05 -0400
X-MC-Unique: stKb3_uTP3CLozs-_B-SWw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A87F100F952;
        Mon,  5 Oct 2020 16:53:48 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.195.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C61656E70D;
        Mon,  5 Oct 2020 16:53:13 +0000 (UTC)
Date:   Mon, 5 Oct 2020 18:53:11 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        lvivier@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 4/7] lib/alloc_page: complete rewrite
 of the page allocator
Message-ID: <20201005165311.w37u3b2fpuqvf2ob@kamzik.brq.redhat.com>
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
 <20201002154420.292134-5-imbrenda@linux.ibm.com>
 <20201005124039.sf6mbytv5da3hxed@kamzik.brq.redhat.com>
 <20201005175613.1215b61e@ibm-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005175613.1215b61e@ibm-vm>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 05, 2020 at 05:56:13PM +0200, Claudio Imbrenda wrote:
> On Mon, 5 Oct 2020 14:40:39 +0200
> Andrew Jones <drjones@redhat.com> wrote:
> 
> > On Fri, Oct 02, 2020 at 05:44:17PM +0200, Claudio Imbrenda wrote:
> > >  {
> > > -	void *old_freelist;
> > > -	void *end;
> > > +	return (pfn >= PFN(a->page_states)) && (pfn < a->top);  
> > 
> > Why are we comparing an input pfn with the page_states virtual
> > pfn? I guess you want 'pfn >= base' ?
> 
> no, I want to see if the address overlaps the start of the metadata,
> which is placed immediately before the usable range. it is used in one
> place below, unfortunately below the point at which you gave up reading

But we're mixing and matching virtual and physical addresses. I assume
pfn is the physical frame number, thus physical. a->top should also
be physical, but PFN(a->page_states) is virtual. Now that I understand
what this function does, I think you want something like

  meta_start = PFN(virt_to_phys(a->page_states));
  meta_end = PFN(virt_to_phys(&a->page_states[block_size]));

  (pfn >= meta_start && pfn < meta_end) || (pfn >= a->base && pfn < a->top)

There's also another metadata page to consider though, right? The one
where the page_states pointer is stored.

> > > + *
> > > + * The function depends on the following assumptions:
> > > + * - The allocator must have been initialized
> > > + * - the block must be within the memory area
> > > + * - all pages in the block must be free and not special
> > > + * - the pointer must point to the start of the block
> > > + * - all pages in the block must have the same block size.  
> > 
> > pages should all have the same page size, no? How does a
> > page have a block size?
> 
> no, a page belongs to a power-of-two aligned block of pages, in the
> worst case it's an order 0 block (so one page), but in most cases it
> will belong to a larger block.

So the comment should be "all blocks in the memory area must have
the same block size" ?

> 
> this is basically where we store the size of an allocation so we don't
> have to provide it back again when freeing
> 
> > > + * - the block size must be greater than 0
> > > + * - the block size must be smaller than the maximum allowed
> > > + * - the block must be in a free list
> > > + * - the function is called with the lock held
> > > + */
> > > +static void split(struct mem_area *a, void *addr)
> > > +{
> > > +	uintptr_t pfn = PFN(addr);  
> > 
> > addr appears to be virtual, since it's a 'void *', not a phys_addr_t.
> 
> it's a pointer, doesn't mean it's virtual. In fact it will be physical,
> since the page allocator only works with physical addresses.

That won't work for 32-bit processors that support physical addresses
that are larger than 32-bits - if the target has more than 4G and the
unit test wants to access that high memory. Using phys_addr_t everywhere
you want a physical address avoids that problem.

> 
> if the MMU has been activated and all of memory is virtual but identity
> mapped, it does not make any difference.

True for 64-bit targets, not possible for targets than can't address all
memory. Also, I don't think we should write general code that assumes we
have an identity map, or that the current virtual mapping we're using is
the identity mapping. It's best to be explicit with 

 phys_addr_t paddr = virt_to_phys(vaddr);

and then use paddr wherever a physical address is expected, not a pointer.

> 
> the addresses do not belong to the vmalloc range
> 
> > PFN() only does a shift, so that's the virtual PFN. However we're
> 
> again, it's just a PFN
> 
> > comparing that with memory area pfn's, which are supposed to be
> > physical frame numbers, at least according to the comments in the
> 
> correct. we are comparing physical PFNs with other physical PFNs

Maybe. But that's not obvious from the code.

> 
> > struct.
> > 
> > > +	struct linked_list *p;
> > > +	uintptr_t i, idx;
> > > +	u8 order;
> > >  
> > > -	assert_msg(size == 0 || (uintptr_t)mem == -size ||
> > > -		   (uintptr_t)mem + size > (uintptr_t)mem,
> > > -		   "mem + size overflow: %p + %#zx", mem, size);
> > > +	assert(a && area_contains(a, pfn));
> > > +	idx = pfn - a->base;
> > > +	order = a->page_states[idx];  
> > 
> > pfn - a->base could potentially be huge, so we can't be using that
> > as an array index.
> 
> this is exactly what we are doing. we need the index of the page in the
> per-page metadata array.

Ah right, one byte per page. That's indeed going to be a large array.

> 
> from the array we get the order of the block the page belongs to.
>  
> > I think what you want is something like
> > 
> >  pfn = PFN(virt_to_phys(addr));
> >  order = ffs(pfn) - 1;
> >  if (pfn != order)
> >    order <<= 1;
> > 
> > Then you have order and can use it as a index into an array if
> > necessary.
> 
> now this does not make any sense

I was thinking we wanted the order of the address, not of some block
the address is somehow associated with and mapped to by this byte.

> 
> > > +	assert(!(order & ~ORDER_MASK) && order && (order <
> > > NLISTS));  
> > 
> > What's wrong with order==0? What is ORDER_MASK good for?
> 
> as written in the comment in the struct, the metadata contains the
> order and a bit to mark when a page is allocated. ORDER_MASK is used to
> extract the order part.
> 
> a block with order 0 is a single page. you cannot split a page. that's
> why order 0 is bad.
> 
> split takes a pointer to a free block and splits the block in two blocks
> of half the size each. this is needed when there are no free blocks of
> the suitable size, but there are bigger free blocks
> 
> > > +	assert(IS_ALIGNED_ORDER(pfn, order));  
> > 
> > I'm getting the feeling that split() shouldn't operate on an addr, but
> > rather some internal index of a block list or something. There are
> > just too many requirements as to what addr is supposed to be.
> 
> split is an internal function, it's static for a reason. basically
> there is exactly one spot where it should be used, and that is the one
> where it is used.
>  
> > > +	assert(area_contains(a, pfn + BIT(order) - 1));
> > >  
> > > -	if (size == 0) {
> > > -		freelist = NULL;
> > > -		return;
> > > -	}
> > > +	/* Remove the block from its free list */
> > > +	p = list_remove(addr);  
> > 
> > So addr is a pointer to a linked_list object? I'm getting really
> > confused.
> 
> it's literally a free list; the beginning of each free block of memory
> contains the pointers so that it can be handled using list operations

Using a list member for list operations and container_of() to get back to
the object would help readability.

> 
> > My editor says I'm only 30% of my way through this patch, so I don't
> > think I'm going to have time to look at the rest. I think this patch
> > is trying to do too much at once. IMO, we need to implement a single
> 
> this patch is implementing the page allocator; it is a single new
> feature.
> 
> > new feature at a time. Possibly starting with some cleanup patches
> > for the current code first.
> 
> there is no way to split this any further, I need to break some
> interfaces, so I need to do it all at once.

You can always build up a new implementation with a series of patches
that don't wire up to anything. A final patch can simply wire up the
new and delete the old.

Thanks,
drew

