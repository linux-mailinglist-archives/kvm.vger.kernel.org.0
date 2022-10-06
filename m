Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 352205F65C6
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 14:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbiJFMIu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 08:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbiJFMId (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 08:08:33 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8A40E165AA
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 05:08:17 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E73A1169C;
        Thu,  6 Oct 2022 05:08:08 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4B5883F792;
        Thu,  6 Oct 2022 05:08:01 -0700 (PDT)
Date:   Thu, 6 Oct 2022 13:09:08 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Laurent Vivier <lvivier@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 1/3] lib/vmalloc: Treat virt_to_pte_phys()
 as returning a physical address
Message-ID: <Yz7FZPWAsFV9Cwpv@monolith.localdoman>
References: <20221006111241.15083-1-alexandru.elisei@arm.com>
 <20221006111241.15083-2-alexandru.elisei@arm.com>
 <20221006133552.091bb41b@p-imbrenda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221006133552.091bb41b@p-imbrenda>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Thu, Oct 06, 2022 at 01:35:52PM +0200, Claudio Imbrenda wrote:
> On Thu,  6 Oct 2022 12:12:39 +0100
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> 
> > All architectures that implements virt_to_pte_phys() (s390x, x86, arm and
> > arm64) return a physical address from the function. Teach vmalloc to treat
> > it as such, instead of confusing the return value with a page table entry.
> 
> I'm not sure I understand what you mean

I thought that vmalloc uses PAGE_MASK because it expects virt_to_pte_phys()
to return a pteval (because of the "pte' part in the virt_to_pte_phys()
function name), which might have the [PAGE_SHIFT-1:0] bits used to store
page metadata by an architecture (like permissions), but like you've
explained below it uses PAGE_MASK to align the page address (which is
identically mapped) before passing it to the page allocator to be freed.

> 
> > Changing things the other way around (having the function return a page
> > table entry instead) is not feasible, because it is possible for an
> > architecture to use the upper bits of the table entry to store metadata
> > about the page.
> > 
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Thomas Huth <thuth@redhat.com>
> > Cc: Andrew Jones <andrew.jones@linux.dev>
> > Cc: Laurent Vivier <lvivier@redhat.com>
> > Cc: Janosch Frank <frankja@linux.ibm.com>
> > Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >  lib/vmalloc.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/lib/vmalloc.c b/lib/vmalloc.c
> > index 572682576cc3..0696b5da8190 100644
> > --- a/lib/vmalloc.c
> > +++ b/lib/vmalloc.c
> > @@ -169,7 +169,7 @@ static void vm_free(void *mem)
> >  	/* the pointer is not page-aligned, it was a single-page allocation */
> >  	if (!IS_ALIGNED((uintptr_t)mem, PAGE_SIZE)) {
> >  		assert(GET_MAGIC(mem) == VM_MAGIC);
> > -		page = virt_to_pte_phys(page_root, mem) & PAGE_MASK;
> > +		page = virt_to_pte_phys(page_root, mem);
> 
> this will break things for small allocations, though. if the pointer is
> not aligned, then the result of virt_to_pte_phys will also not be
> aligned....

I agree, I missed that part. Would be nice if it were written using
PAGE_ALIGN to avoid mistakes like mine in the future, but that's
unimportant.

> 
> >  		assert(page);
> >  		free_page(phys_to_virt(page));
> 
> ...and phys_to_virt will also return an unaligned address, and
> free_page will complain about it.
> 
> >  		return;
> > @@ -183,7 +183,7 @@ static void vm_free(void *mem)
> >  	/* free all the pages including the metadata page */
> >  	ptr = (uintptr_t)m & PAGE_MASK;
> 
> ptr gets page aligned here
> 
> >  	for (i = 0 ; i < m->npages + 1; i++, ptr += PAGE_SIZE) {
> > -		page = virt_to_pte_phys(page_root, (void *)ptr) & PAGE_MASK;
> > +		page = virt_to_pte_phys(page_root, (void *)ptr);
> 
> so virt_to_pte_phys will also return an aligned address;
> I agree that & PAGE_MASK is redundant here

You are correct, if we've ended up here it means that the pointer is
already page aligned, and it will be incremented by PAGE_SIZE each
iteration, hence the virt_to_pte_phys() will also be paged aligned.

I don't see much point in writing a patch just to remove the unnecessary
alignment here, so I'll drop this patch entirely.

Thank you for the prompt explanation!

Alex

> 
> >  		assert(page);
> >  		free_page(phys_to_virt(page));
> >  	}
> 
