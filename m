Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB7161B1CED
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 05:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbgDUDey (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 23:34:54 -0400
Received: from mga04.intel.com ([192.55.52.120]:29353 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726793AbgDUDex (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Apr 2020 23:34:53 -0400
IronPort-SDR: oZ/zheVjPYfLMJtYzZSl0qbfppY65QX5gkJx0AnQ8ICE4T6coOx050d6h0KbhWBafxOGkQamCK
 WazYzrRJkFHQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 20:34:53 -0700
IronPort-SDR: /QUx7vGWhN0FyE594Jo7yF6w8Dhwu7BOs4MqQtdudlT2yf9cG8m4MHrZZx3eGaZizlr/4wO6Ne
 6vK7BNsnarjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,408,1580803200"; 
   d="scan'208";a="300469608"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Apr 2020 20:34:53 -0700
Date:   Mon, 20 Apr 2020 20:34:53 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] vfio/type1: Fix VA->PA translation for PFNMAP VMAs in
 vaddr_get_pfn()
Message-ID: <20200421033453.GC11134@linux.intel.com>
References: <20200416225057.8449-1-sean.j.christopherson@intel.com>
 <20200420134005.456151fe@w520.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420134005.456151fe@w520.home>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 20, 2020 at 01:40:05PM -0600, Alex Williamson wrote:
> > I'm mostly confident this is correct from the standpoint that it generates
> > the correct VA->PA.  I'm far less confident the end result is what VFIO
> > wants, there appears to be a fair bit of magic going on that I don't fully
> > understand, e.g. I'm a bit mystified as to how this ever worked in any
> > capacity.
> 
> Yeah, that magic was copied from KVM's hva_to_pfn(), which split this
> part out into hva_to_pfn_remapped() in 92176a8ede57 and then in

Wowsers.  I don't suppose anyone knows how/if KVM prevented that BUG_ON()
in hva_to_pfn() from being triggered by a malicious/miconfigured userspace?

> add6a0cd1c5b adopted a follow_pfn() approach, but also added forcing a
> user fault and retry mechanism, iiuc.  Cc'ing Paolo and Andrea to see
> if we should consider something similar.  We'd be forcing the fault on
> user mapping, not first access though, so I'm not sure if it's still
> useful.

Hmm, because the fault would trigger on map, userspace could provide the
same effective result by touching the page before calling into VFIO, i.e.
doesn't seem like adding fixup_user_fault() would add much other than
complexity.

> > Mapping PFNMAP VMAs into the IOMMU without using a mmu_notifier also
> > seems dangerous, e.g. if the subsystem associated with the VMA
> > unmaps/remaps the VMA then the IOMMU will end up with stale
> > translations.
> 
> The original use case was to support mapping MMIO ranges between
> devices to support p2p within a VM instance, so remapping the VMA was
> not a concern.  But yes, as this might be used beyond that limited
> case for something like rdma, it should be expanded.  Patches?

Heh, I don't have a use case for any of this.  Quite the opposite actually,
this was encountered because the VFIO memory listener in Qemu was trying to
map SGX EPC memory for DMA.  I segued into this patch only because the WARN
on PA!=0 caught my eye.

> > Last thought, using PA==0 for the error seems unnecessarily risky,
> > e.g. why not use something similar to KVM_PFN_ERR_* or an explicit
> > return code?
> 
> We're just consuming what the IOMMU driver provide.  Both Intel and AMD
> return zero for a page not found.  In retrospect, yeah, we probably
> should have balked at that.
> 
> >  drivers/vfio/vfio_iommu_type1.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/vfio/vfio_iommu_type1.c
> > b/drivers/vfio/vfio_iommu_type1.c index 85b32c325282..c2ada190c5cb
> > 100644 --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -342,8 +342,8 @@ static int vaddr_get_pfn(struct mm_struct *mm,
> > unsigned long vaddr, vma = find_vma_intersection(mm, vaddr, vaddr +
> > 1); 
> >  	if (vma && vma->vm_flags & VM_PFNMAP) {
> > -		*pfn = ((vaddr - vma->vm_start) >> PAGE_SHIFT) +
> > vma->vm_pgoff;
> > -		if (is_invalid_reserved_pfn(*pfn))
> > +		if (!follow_pfn(vma, vaddr, pfn) &&
> > +		    is_invalid_reserved_pfn(*pfn))
> >  			ret = 0;
> >  	}
> >  done:
> 
> Should we consume that error code?
> 
> 	ret = follow_pfn(vma, vaddr, pfn);
> 	if (!ret && !is_invalid_reserved_pfn(*pfn))
> 		ret = -EINVAL;

Not sure it matters?  gup() returns -EINVAL on PFNMAP, follow_pfn() returns
-EINVAL for all error cases, and the delta would also return -EINVAL.
Generally speaking, letting the first error "win" usually seems like the
way to go, e.g. to avoid squashing a meaningful error code.  But AFAICT
it's a moot point.
