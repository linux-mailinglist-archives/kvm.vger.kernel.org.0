Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C5540C770
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 16:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237847AbhIOOav (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 10:30:51 -0400
Received: from mga06.intel.com ([134.134.136.31]:14415 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233745AbhIOOau (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Sep 2021 10:30:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10107"; a="283333977"
X-IronPort-AV: E=Sophos;i="5.85,295,1624345200"; 
   d="scan'208";a="283333977"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2021 07:29:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,295,1624345200"; 
   d="scan'208";a="472417997"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga007.jf.intel.com with ESMTP; 15 Sep 2021 07:29:17 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id D78845A5; Wed, 15 Sep 2021 17:29:21 +0300 (EEST)
Date:   Wed, 15 Sep 2021 17:29:21 +0300
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Chao Peng <chao.p.peng@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>,
        Andi Kleen <ak@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Dario Faggioli <dfaggioli@suse.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-coco@lists.linux.dev,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
Subject: Re: [RFC] KVM: mm: fd-based approach for supporting KVM guest
 private memory
Message-ID: <20210915142921.bxxsap6xktkt4bek@black.fi.intel.com>
References: <20210824005248.200037-1-seanjc@google.com>
 <20210902184711.7v65p5lwhpr2pvk7@box.shutemov.name>
 <YTE1GzPimvUB1FOF@google.com>
 <20210903191414.g7tfzsbzc7tpkx37@box.shutemov.name>
 <02806f62-8820-d5f9-779c-15c0e9cd0e85@kernel.org>
 <20210910171811.xl3lms6xoj3kx223@box.shutemov.name>
 <20210915195857.GA52522@chaop.bj.intel.com>
 <51a6f74f-6c05-74b9-3fd7-b7cd900fb8cc@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51a6f74f-6c05-74b9-3fd7-b7cd900fb8cc@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 15, 2021 at 03:51:25PM +0200, David Hildenbrand wrote:
> > > diff --git a/mm/memfd.c b/mm/memfd.c
> > > index 081dd33e6a61..ae43454789f4 100644
> > > --- a/mm/memfd.c
> > > +++ b/mm/memfd.c
> > > @@ -130,11 +130,24 @@ static unsigned int *memfd_file_seals_ptr(struct file *file)
> > >   	return NULL;
> > >   }
> > > +int memfd_register_guest(struct inode *inode, void *owner,
> > > +			 const struct guest_ops *guest_ops,
> > > +			 const struct guest_mem_ops **guest_mem_ops)
> > > +{
> > > +	if (shmem_mapping(inode->i_mapping)) {
> > > +		return shmem_register_guest(inode, owner,
> > > +					    guest_ops, guest_mem_ops);
> > > +	}
> > > +
> > > +	return -EINVAL;
> > > +}
> > 
> > Are we stick our design to memfd interface (e.g other memory backing
> > stores like tmpfs and hugetlbfs will all rely on this memfd interface to
> > interact with KVM), or this is just the initial implementation for PoC?
> 
> I don't think we are, it still feels like we are in the early prototype
> phase (even way before a PoC). I'd be happy to see something "cleaner" so to
> say -- it still feels kind of hacky to me, especially there seem to be many
> pieces of the big puzzle missing so far. Unfortunately, this series hasn't
> caught the attention of many -MM people so far, maybe because other people
> miss the big picture as well and are waiting for a complete design proposal.
> 
> For example, what's unclear to me: we'll be allocating pages with
> GFP_HIGHUSER_MOVABLE, making them land on MIGRATE_CMA or ZONE_MOVABLE; then
> we silently turn them unmovable, which breaks these concepts. Who'd migrate
> these pages away just like when doing long-term pinning, or how is that
> supposed to work?

That's fair point. We can fix it by changing mapping->gfp_mask.

> Also unclear to me is how refcount and mapcount will be handled to prevent
> swapping,

refcount and mapcount are unchanged. Pages not pinned per se. Swapping
prevented with the change in shmem_writepage().

> who will actually do some kind of gfn-epfn etc. mapping, how we'll
> forbid access to this memory e.g., via /proc/kcore or when dumping memory

It's not aimed to prevent root to shoot into his leg. Root do root.

> ... and how it would ever work with migration/swapping/rmap (it's clearly
> future work, but it's been raised that this would be the way to make it
> work, I don't quite see how it would all come together).

Given that hardware supports it migration and swapping can be implemented
by providing new callbacks in guest_ops. Like ->migrate_page would
transfer encrypted data between pages and ->swapout would provide
encrypted blob that can be put on disk or handled back to ->swapin to
bring back to memory.

-- 
 Kirill A. Shutemov
