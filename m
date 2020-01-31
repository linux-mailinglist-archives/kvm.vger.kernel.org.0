Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C990114F33C
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 21:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgAaUgX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 15:36:23 -0500
Received: from mga07.intel.com ([134.134.136.100]:10439 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbgAaUgX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jan 2020 15:36:23 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jan 2020 12:36:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,387,1574150400"; 
   d="scan'208";a="247838310"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 31 Jan 2020 12:36:22 -0800
Date:   Fri, 31 Jan 2020 12:36:22 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH v3 09/21] KVM: X86: Don't track dirty for
 KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
Message-ID: <20200131203622.GF18946@linux.intel.com>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109145729.32898-10-peterx@redhat.com>
 <20200121155657.GA7923@linux.intel.com>
 <20200128055005.GB662081@xz-x1>
 <20200128182402.GA18652@linux.intel.com>
 <20200131150832.GA740148@xz-x1>
 <20200131193301.GC18946@linux.intel.com>
 <20200131202824.GA7063@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200131202824.GA7063@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 31, 2020 at 03:28:24PM -0500, Peter Xu wrote:
> On Fri, Jan 31, 2020 at 11:33:01AM -0800, Sean Christopherson wrote:
> > For the same reason we don't take mmap_sem, it gains us nothing, i.e. KVM
> > still has to use copy_{to,from}_user().
> > 
> > In the proposed __x86_set_memory_region() refactor, vmx_set_tss_addr()
> > would be provided the hva of the memory region.  Since slots_lock and SRCU
> > only protect gfn->hva, why would KVM take slots_lock since it already has
> > the hva?
> 
> OK so you're suggesting to unlock the lock earlier to not cover
> init_rmode_tss() rather than dropping the whole lock...  Yes it looks
> good to me.  I think that's the major confusion I got.

Ya.  And I missed where the -EEXIST was coming from.  I think we're on the
same page.

> > Returning -EEXIST is an ABI change, e.g. userspace can currently call
> > KVM_SET_TSS_ADDR any number of times, it just needs to ensure proper
> > serialization between calls.
> > 
> > If you want to change the ABI, then submit a patch to do exactly that.
> > But don't bury an ABI change under the pretense that it's a bug fix.
> 
> Could you explain what do you mean by "ABI change"?
> 
> I was talking about the original code, not after applying the
> patchset.  To be explicit, I mean [a] below:
> 
> int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size,
> 			    unsigned long *uaddr)
> {
> 	int i, r;
> 	unsigned long hva;
> 	struct kvm_memslots *slots = kvm_memslots(kvm);
> 	struct kvm_memory_slot *slot, old;
> 
> 	/* Called with kvm->slots_lock held.  */
> 	if (WARN_ON(id >= KVM_MEM_SLOTS_NUM))
> 		return -EINVAL;
> 
> 	slot = id_to_memslot(slots, id);
> 	if (size) {
> 		if (slot->npages)
> 			return -EEXIST;  <------------------------ [a]
>         }
>         ...
> }

Doh, I completely forgot that the second __x86_set_memory_region() would
fail.  Sorry :-(

> > > Yes, but as I mentioned, I don't think it's an issue to be considered
> > > by KVM, otherwise we should have the same issue all over the places
> > > when we fetch the cached userspace_addr from any user slots.
> > 
> > Huh?  Of course it's an issue that needs to be considered by KVM, e.g.
> > kvm_{read,write}_guest_cached() aren't using __copy_{to,}from_user() for
> > giggles.
> 
> The cache is for the GPA->HVA translation (struct gfn_to_hva_cache),
> we still use __copy_{to,}from_user() upon the HVAs, no?

I'm still lost on this one.  I'm pretty sure I'm incorrectly interpreting:
  
  I don't think it's an issue to be considered by KVM, otherwise we should
  have the same issue all over the places when we fetch the cached
  userspace_addr from any user slots.

What is the issue to which you are referring?
