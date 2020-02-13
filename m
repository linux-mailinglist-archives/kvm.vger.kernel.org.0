Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E78115CB75
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 20:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbgBMT4E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 14:56:04 -0500
Received: from mga03.intel.com ([134.134.136.65]:51558 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728295AbgBMT4E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 14:56:04 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Feb 2020 11:56:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,437,1574150400"; 
   d="scan'208";a="234218810"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 13 Feb 2020 11:56:02 -0800
Date:   Thu, 13 Feb 2020 11:56:02 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marc Zyngier <maz@kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-mm@kvack.org,
        kvm-ppc@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 01/35] mm:gup/writeback: add callbacks for inaccessible
 pages
Message-ID: <20200213195602.GD18610@linux.intel.com>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
 <20200207113958.7320-2-borntraeger@de.ibm.com>
 <28792269-e053-ac70-a344-45612ee5c729@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28792269-e053-ac70-a344-45612ee5c729@de.ibm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 10, 2020 at 06:27:04PM +0100, Christian Borntraeger wrote:
> CC Marc Zyngier for KVM on ARM.  Marc, see below. Will there be any
> use for this on KVM/ARM in the future?
> 
> CC Sean Christopherson/Tom Lendacky. Any obvious use case for Intel/AMD
> to have a callback before a page is used for I/O?

Yes?

> Andrew (or other mm people) any chance to get an ACK for this change?
> I could then carry that via s390 or KVM tree. Or if you want to carry
> that yourself I can send an updated version (we need to kind of 
> synchronize that Linus will pull the KVM changes after the mm changes).
> 
> Andrea asked if others would benefit from this, so here are some more
> information about this (and I can also put this into the patch
> description).  So we have talked to the POWER folks. They do not use
> the standard normal memory management, instead they have a hard split
> between secure and normal memory. The secure memory  is the handled by
> the hypervisor as device memory and the ultravisor and the hypervisor
> move this forth and back when needed.
> 
> On s390 there is no *separate* pool of physical pages that are secure.
> Instead, *any* physical page can be marked as secure or not, by
> setting a bit in a per-page data structure that hardware uses to stop
> unauthorized access.  (That bit is under control of the ultravisor.)
> 
> Note that one side effect of this strategy is that the decision
> *which* secure pages to encrypt and then swap out is actually done by
> the hypervisor, not the ultravisor.  In our case, the hypervisor is
> Linux/KVM, so we're using the regular Linux memory management scheme
> (active/inactive LRU lists etc.) to make this decision.  The advantage
> is that the Ultravisor code does not need to itself implement any
> memory management code, making it a lot simpler.

Disclaimer: I'm not familiar with s390 guest page faults or UV.  I tried
to give myself a crash course, apologies if I'm way out in left field...

AIUI, pages will first be added to a secure guest by converting a normal,
non-secure page to secure and stuffing it into the guest page tables.  To
swap a page from a secure guest, arch_make_page_accessible() will be called
to encrypt the page in place so that it can be accessed by the untrusted
kernel/VMM and written out to disk.  And to fault the page back in, on s390
a secure guest access to a non-secure page will generate a page fault with
a dedicated type.  That fault routes directly to
do_non_secure_storage_access(), which converts the page to secure and thus
makes it re-accessible to the guest.

That all sounds sane and usable for Intel.

My big question is the follow/get flows, more on that below.

> However, in the end this is why we need the hook into Linux memory
> management: once Linux has decided to swap a page out, we need to get
> a chance to tell the Ultravisor to "export" the page (i.e., encrypt
> its contents and mark it no longer secure).
> 
> As outlined below this should be a no-op for anybody not opting in.
> 
> Christian                                   
> 
> On 07.02.20 12:39, Christian Borntraeger wrote:
> > From: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > 
> > With the introduction of protected KVM guests on s390 there is now a
> > concept of inaccessible pages. These pages need to be made accessible
> > before the host can access them.
> > 
> > While cpu accesses will trigger a fault that can be resolved, I/O
> > accesses will just fail.  We need to add a callback into architecture
> > code for places that will do I/O, namely when writeback is started or
> > when a page reference is taken.
> > 
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> > ---
> >  include/linux/gfp.h | 6 ++++++
> >  mm/gup.c            | 2 ++
> >  mm/page-writeback.c | 1 +
> >  3 files changed, 9 insertions(+)
> > 
> > diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> > index e5b817cb86e7..be2754841369 100644
> > --- a/include/linux/gfp.h
> > +++ b/include/linux/gfp.h
> > @@ -485,6 +485,12 @@ static inline void arch_free_page(struct page *page, int order) { }
> >  #ifndef HAVE_ARCH_ALLOC_PAGE
> >  static inline void arch_alloc_page(struct page *page, int order) { }
> >  #endif
> > +#ifndef HAVE_ARCH_MAKE_PAGE_ACCESSIBLE
> > +static inline int arch_make_page_accessible(struct page *page)
> > +{
> > +	return 0;
> > +}
> > +#endif
> >  
> >  struct page *
> >  __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int preferred_nid,
> > diff --git a/mm/gup.c b/mm/gup.c
> > index 7646bf993b25..a01262cd2821 100644
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -257,6 +257,7 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
> >  			page = ERR_PTR(-ENOMEM);
> >  			goto out;
> >  		}
> > +		arch_make_page_accessible(page);

As Will pointed out, the return value definitely needs to be checked, there
will undoubtedly be scenarios where the page cannot be made accessible.

What is the use case for calling arch_make_page_accessible() in the follow()
and gup() paths?  Live migration is the only thing that comes to mind, and
for live migration I would expect you would want to keep the secure guest
running when copying pages to the target, i.e. use pre-copy.  That would
conflict with converting the page in place.  Rather, migration would use a
separate dedicated path to copy the encrypted contents of the secure page to
a completely different page, and send *that* across the wire so that the
guest can continue accessing the original page.

Am I missing a need to do this for the swap/reclaim case?  Or is there a
completely different use case I'm overlooking?

Tangentially related, hooks here could be quite useful for sanity checking
the kernel/KVM and/or debugging kernel/KVM bugs.  Would it make sense to
pass a param to arch_make_page_accessible() to provide some information as
to why the page needs to be made accessible?

> >  	}
> >  	if (flags & FOLL_TOUCH) {
> >  		if ((flags & FOLL_WRITE) &&
> > @@ -1870,6 +1871,7 @@ static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
> >  
> >  		VM_BUG_ON_PAGE(compound_head(page) != head, page);
> >  
> > +		arch_make_page_accessible(page);
> >  		SetPageReferenced(page);
> >  		pages[*nr] = page;
> >  		(*nr)++;
> > diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> > index 2caf780a42e7..0f0bd14571b1 100644
> > --- a/mm/page-writeback.c
> > +++ b/mm/page-writeback.c
> > @@ -2806,6 +2806,7 @@ int __test_set_page_writeback(struct page *page, bool keep_write)
> >  		inc_lruvec_page_state(page, NR_WRITEBACK);
> >  		inc_zone_page_state(page, NR_ZONE_WRITE_PENDING);
> >  	}
> > +	arch_make_page_accessible(page);
> >  	unlock_page_memcg(page);
> 
> As outlined by Ulrich, we can move the callback after the unlock.
> 
> >  	return ret;
> >  
> > 
> 
