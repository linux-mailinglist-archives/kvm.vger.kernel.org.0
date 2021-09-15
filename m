Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A750D40C71E
	for <lists+kvm@lfdr.de>; Wed, 15 Sep 2021 16:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237740AbhIOONN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Sep 2021 10:13:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:20300 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234504AbhIOONK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Sep 2021 10:13:10 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10107"; a="209559802"
X-IronPort-AV: E=Sophos;i="5.85,295,1624345200"; 
   d="scan'208";a="209559802"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2021 07:11:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,295,1624345200"; 
   d="scan'208";a="651213477"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga005.jf.intel.com with ESMTP; 15 Sep 2021 07:11:43 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 726895A5; Wed, 15 Sep 2021 17:11:47 +0300 (EEST)
Date:   Wed, 15 Sep 2021 17:11:47 +0300
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To:     Chao Peng <chao.p.peng@linux.intel.com>
Cc:     "Kirill A. Shutemov" <kirill@shutemov.name>,
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
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
Subject: Re: [RFC] KVM: mm: fd-based approach for supporting KVM guest
 private memory
Message-ID: <20210915141147.s4mgtcfv3ber5fnt@black.fi.intel.com>
References: <20210824005248.200037-1-seanjc@google.com>
 <20210902184711.7v65p5lwhpr2pvk7@box.shutemov.name>
 <YTE1GzPimvUB1FOF@google.com>
 <20210903191414.g7tfzsbzc7tpkx37@box.shutemov.name>
 <02806f62-8820-d5f9-779c-15c0e9cd0e85@kernel.org>
 <20210910171811.xl3lms6xoj3kx223@box.shutemov.name>
 <20210915195857.GA52522@chaop.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210915195857.GA52522@chaop.bj.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 15, 2021 at 07:58:57PM +0000, Chao Peng wrote:
> On Fri, Sep 10, 2021 at 08:18:11PM +0300, Kirill A. Shutemov wrote:
> > On Fri, Sep 03, 2021 at 12:15:51PM -0700, Andy Lutomirski wrote:
> > > On 9/3/21 12:14 PM, Kirill A. Shutemov wrote:
> > > > On Thu, Sep 02, 2021 at 08:33:31PM +0000, Sean Christopherson wrote:
> > > >> Would requiring the size to be '0' at F_SEAL_GUEST time solve that problem?
> > > > 
> > > > I guess. Maybe we would need a WRITE_ONCE() on set. I donno. I will look
> > > > closer into locking next.
> > > 
> > > We can decisively eliminate this sort of failure by making the switch
> > > happen at open time instead of after.  For a memfd-like API, this would
> > > be straightforward.  For a filesystem, it would take a bit more thought.
> > 
> > I think it should work fine as long as we check seals after i_size in the
> > read path. See the comment in shmem_file_read_iter().
> > 
> > Below is updated version. I think it should be good enough to start
> > integrate with KVM.
> > 
> > I also attach a test-case that consists of kernel patch and userspace
> > program. It demonstrates how it can be integrated into KVM code.
> > 
> > One caveat I noticed is that guest_ops::invalidate_page_range() can be
> > called after the owner (struct kvm) has being freed. It happens because
> > memfd can outlive KVM. So the callback has to check if such owner exists,
> > than check that there's a memslot with such inode.
> 
> Would introducing memfd_unregister_guest() fix this?

I considered this, but it get complex quickly.

At what point it gets called? On KVM memslot destroy?

What if multiple KVM slot share the same memfd? Add refcount into memfd on
how many times the owner registered the memfd?

It would leave us in strange state: memfd refcount owners (struct KVM) and
KVM memslot pins the struct file. Weird refcount exchnage program.

I hate it.

> > I guess it should be okay: we have vm_list we can check owner against.
> > We may consider replace vm_list with something more scalable if number of
> > VMs will get too high.
> > 
> > Any comments?
> > 
> > diff --git a/include/linux/memfd.h b/include/linux/memfd.h
> > index 4f1600413f91..3005e233140a 100644
> > --- a/include/linux/memfd.h
> > +++ b/include/linux/memfd.h
> > @@ -4,13 +4,34 @@
> >  
> >  #include <linux/file.h>
> >  
> > +struct guest_ops {
> > +	void (*invalidate_page_range)(struct inode *inode, void *owner,
> > +				      pgoff_t start, pgoff_t end);
> > +};
> 
> I can see there are two scenarios to invalidate page(s), when punching a
> hole or ftruncating to 0, in either cases KVM should already been called
> with necessary information from usersapce with memory slot punch hole
> syscall or memory slot delete syscall, so wondering this callback is
> really needed.

So what you propose? Forbid truncate/punch from userspace and make KVM
handle punch hole/truncate from within kernel? I think it's layering
violation.

> > +
> > +struct guest_mem_ops {
> > +	unsigned long (*get_lock_pfn)(struct inode *inode, pgoff_t offset);
> > +	void (*put_unlock_pfn)(unsigned long pfn);
> 
> Same as above, I’m not clear on which time put_unlock_pfn() would be
> called, I’m thinking the page can be put_and_unlock when userspace
> punching a hole or ftruncating to 0 on the fd.

No. put_unlock_pfn() has to be called after the pfn is in SEPT. This way
we close race between SEPT population and truncate/punch. get_lock_pfn()
would stop truncate untile put_unlock_pfn() called.

> We did miss pfn_mapping_level() callback which is needed for KVM to query
> the page size level (e.g. 4K or 2M) that the backing store can support.

Okay, makes sense. We can return the information as part of get_lock_pfn()
call.

> Are we stick our design to memfd interface (e.g other memory backing
> stores like tmpfs and hugetlbfs will all rely on this memfd interface to
> interact with KVM), or this is just the initial implementation for PoC?
> 
> If we really want to expose multiple memory backing stores directly to
> KVM (as opposed to expose backing stores to memfd and then memfd expose
> single interface to KVM), I feel we need a third layer between KVM and
> backing stores to eliminate the direct call like this. Backing stores
> can register ‘memory fd providers’ and KVM should be able to connect to
> the right backing store provider with the fd provided by usersapce under
> the help of this third layer.

memfd can provide shmem and hugetlbfs. That's should be enough for now.

-- 
 Kirill A. Shutemov
