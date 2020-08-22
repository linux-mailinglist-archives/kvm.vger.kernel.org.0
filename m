Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3585C24E4C8
	for <lists+kvm@lfdr.de>; Sat, 22 Aug 2020 05:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgHVDTr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Aug 2020 23:19:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:34834 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726387AbgHVDTq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Aug 2020 23:19:46 -0400
IronPort-SDR: 6/X+SwjcC5WduVc1s22KoT0eg/GZYgxICdFCkd0Jedvq4x+WfQExjny3VQgcV1Rra4/7wmqtSR
 QcQ7+MAgJ0KQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9720"; a="173712482"
X-IronPort-AV: E=Sophos;i="5.76,339,1592895600"; 
   d="scan'208";a="173712482"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 20:19:46 -0700
IronPort-SDR: hoTSc/bh+DjYbmyVgsOYlBx8a3lPw/XjD3OMG+dOJ3TjFGJEi7ydF/mUdX5nuplykBs9cqCchR
 a9RDPKHsGMeg==
X-IronPort-AV: E=Sophos;i="5.76,339,1592895600"; 
   d="scan'208";a="473265588"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 20:19:45 -0700
Date:   Fri, 21 Aug 2020 20:19:44 -0700
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
Message-ID: <20200822031944.GA4769@sjchrist-ice>
References: <20200807141232.402895-1-vkuznets@redhat.com>
 <20200807141232.402895-3-vkuznets@redhat.com>
 <20200814023139.GB4845@linux.intel.com>
 <20200814102850-mutt-send-email-mst@kernel.org>
 <20200817163207.GC22407@linux.intel.com>
 <20200820214407-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820214407-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 20, 2020 at 09:46:25PM -0400, Michael S. Tsirkin wrote:
> On Mon, Aug 17, 2020 at 09:32:07AM -0700, Sean Christopherson wrote:
> > On Fri, Aug 14, 2020 at 10:30:14AM -0400, Michael S. Tsirkin wrote:
> > > On Thu, Aug 13, 2020 at 07:31:39PM -0700, Sean Christopherson wrote:
> > > > > @@ -2318,6 +2338,11 @@ static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
> > > > >  	int r;
> > > > >  	unsigned long addr;
> > > > >  
> > > > > +	if (unlikely(slot && (slot->flags & KVM_MEM_PCI_HOLE))) {
> > > > > +		memset(data, 0xff, len);
> > > > > +		return 0;
> > > > > +	}
> > > > 
> > > > This feels wrong, shouldn't we be treating PCI_HOLE as MMIO?  Given that
> > > > this is performance oriented, I would think we'd want to leverage the
> > > > GPA from the VMCS instead of doing a full translation.
> > > > 
> > > > That brings up a potential alternative to adding a memslot flag.  What if
> > > > we instead add a KVM_MMIO_BUS device similar to coalesced MMIO?  I think
> > > > it'd be about the same amount of KVM code, and it would provide userspace
> > > > with more flexibility, e.g. I assume it would allow handling even writes
> > > > wholly within the kernel for certain ranges and/or use cases, and it'd
> > > > allow stuffing a value other than 0xff (though I have no idea if there is
> > > > a use case for this).
> > > 
> > > I still think down the road the way to go is to map
> > > valid RO page full of 0xff to avoid exit on read.
> > > I don't think a KVM_MMIO_BUS device will allow this, will it?
> > 
> > No, it would not, but adding KVM_MEM_PCI_HOLE doesn't get us any closer to
> > solving that problem either.
> 
> I'm not sure why. Care to elaborate?

The bulk of the code in this series would get thrown away if KVM_MEM_PCI_HOLE
were reworked to be backed by a physical page.  If we really want a physical
page, then let's use a physical page from the get-go.

I realize I suggested the specialized MMIO idea, but that's when I thought the
primary motivation was memory, not performance.

> > What if we add a flag to allow routing all GFNs in a memslot to a single
> > HVA?
> 
> An issue here would be this breaks attempts to use a hugepage for this.

What are the performance numbers of hugepage vs. aggressively prefetching
SPTEs?  Note, the unbounded prefetching from the original RFC won't fly,
but prefetching 2mb ranges might be reasonable.

Reraising an earlier unanswered question, is enlightening the guest an
option for this use case?
