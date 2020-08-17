Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7401E246CE7
	for <lists+kvm@lfdr.de>; Mon, 17 Aug 2020 18:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388719AbgHQQcg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 12:32:36 -0400
Received: from mga03.intel.com ([134.134.136.65]:10701 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731243AbgHQQcJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 12:32:09 -0400
IronPort-SDR: OgIy0tFYSB8VRyYiBcpQMHC9GDDfYcELHRgBZhGW0HcidjHM+hJ0MZQGuk208kf2oX4zN908ie
 ou2w8V/yiuNg==
X-IronPort-AV: E=McAfee;i="6000,8403,9716"; a="154720042"
X-IronPort-AV: E=Sophos;i="5.76,324,1592895600"; 
   d="scan'208";a="154720042"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2020 09:32:08 -0700
IronPort-SDR: gNGa53ARN2B7I6Gdco4Cf5OlcSb1BwI/csVdhVxHYKUn7DGgGs7yaKNfcMPwlAdWh87KZIXCG+
 eiiPc4lUjVHA==
X-IronPort-AV: E=Sophos;i="5.76,324,1592895600"; 
   d="scan'208";a="440920616"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2020 09:32:08 -0700
Date:   Mon, 17 Aug 2020 09:32:07 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] KVM: x86: introduce KVM_MEM_PCI_HOLE memory
Message-ID: <20200817163207.GC22407@linux.intel.com>
References: <20200807141232.402895-1-vkuznets@redhat.com>
 <20200807141232.402895-3-vkuznets@redhat.com>
 <20200814023139.GB4845@linux.intel.com>
 <20200814102850-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200814102850-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 14, 2020 at 10:30:14AM -0400, Michael S. Tsirkin wrote:
> On Thu, Aug 13, 2020 at 07:31:39PM -0700, Sean Christopherson wrote:
> > > @@ -2318,6 +2338,11 @@ static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
> > >  	int r;
> > >  	unsigned long addr;
> > >  
> > > +	if (unlikely(slot && (slot->flags & KVM_MEM_PCI_HOLE))) {
> > > +		memset(data, 0xff, len);
> > > +		return 0;
> > > +	}
> > 
> > This feels wrong, shouldn't we be treating PCI_HOLE as MMIO?  Given that
> > this is performance oriented, I would think we'd want to leverage the
> > GPA from the VMCS instead of doing a full translation.
> > 
> > That brings up a potential alternative to adding a memslot flag.  What if
> > we instead add a KVM_MMIO_BUS device similar to coalesced MMIO?  I think
> > it'd be about the same amount of KVM code, and it would provide userspace
> > with more flexibility, e.g. I assume it would allow handling even writes
> > wholly within the kernel for certain ranges and/or use cases, and it'd
> > allow stuffing a value other than 0xff (though I have no idea if there is
> > a use case for this).
> 
> I still think down the road the way to go is to map
> valid RO page full of 0xff to avoid exit on read.
> I don't think a KVM_MMIO_BUS device will allow this, will it?

No, it would not, but adding KVM_MEM_PCI_HOLE doesn't get us any closer to
solving that problem either.

What if we add a flag to allow routing all GFNs in a memslot to a single
HVA?  At a glance, it doesn't seem to heinous.  It would have several of the
same touchpoints as this series, e.g. __kvm_set_memory_region() and
kvm_alloc_memslot_metadata().

The functional changes (for x86) would be a few lines in
__gfn_to_hva_memslot() and some new logic in kvm_handle_hva_range().  The
biggest concern is probably the fragility of such an implementation, as KVM
has a habit of open coding operations on memslots.

The new flags could then be paired with KVM_MEM_READONLY to yield the desired
behavior of reading out 0xff for an arbitrary range without requiring copious
memslots and/or host pages.

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 852fc8274bdd..875243a0ab36 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1103,6 +1103,9 @@ __gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
 static inline unsigned long
 __gfn_to_hva_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
 {
+       if (unlikely(slot->flags & KVM_MEM_SINGLE_HVA))
+               return slot->userspace_addr;
+
        return slot->userspace_addr + (gfn - slot->base_gfn) * PAGE_SIZE;
 }

