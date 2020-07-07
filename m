Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FCCD216647
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 08:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgGGGRe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 02:17:34 -0400
Received: from mga05.intel.com ([192.55.52.43]:1426 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725974AbgGGGRd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 02:17:33 -0400
IronPort-SDR: u3dzJVe6oCRt/JWaMZ3pQv9EAN7l/6jYheOuj/SaYbL0C0ASJTl+RKMPYzDlRYIaxjmdtzykCD
 l7VpVKZs1DrQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9674"; a="232405481"
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="232405481"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 23:17:32 -0700
IronPort-SDR: N34W45B6rEEFTRZ/LgN7qlqRSKG4prvchZenPMGgmsPkxFy9npsOpMiUq7PlQMuhJ4fs58ed5R
 tNn+oUBx9vQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,321,1589266800"; 
   d="scan'208";a="357684608"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga001.jf.intel.com with ESMTP; 06 Jul 2020 23:17:32 -0700
Date:   Mon, 6 Jul 2020 23:17:32 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH v10 02/14] KVM: Cache as_id in kvm_memory_slot
Message-ID: <20200707061732.GI5208@linux.intel.com>
References: <20200601115957.1581250-1-peterx@redhat.com>
 <20200601115957.1581250-3-peterx@redhat.com>
 <20200702230849.GL3575@linux.intel.com>
 <20200703184122.GF6677@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200703184122.GF6677@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 03, 2020 at 02:41:22PM -0400, Peter Xu wrote:
> On Thu, Jul 02, 2020 at 04:08:49PM -0700, Sean Christopherson wrote:
> > On Mon, Jun 01, 2020 at 07:59:45AM -0400, Peter Xu wrote:
> > > Cache the address space ID just like the slot ID.  It will be used in
> > > order to fill in the dirty ring entries.
> > > 
> > > Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> > > Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > > Signed-off-by: Peter Xu <peterx@redhat.com>
> > > ---
> > >  include/linux/kvm_host.h | 1 +
> > >  virt/kvm/kvm_main.c      | 1 +
> > >  2 files changed, 2 insertions(+)
> > > 
> > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > index 01276e3d01b9..5e7bbaf7a36b 100644
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -346,6 +346,7 @@ struct kvm_memory_slot {
> > >  	unsigned long userspace_addr;
> > >  	u32 flags;
> > >  	short id;
> > > +	u16 as_id;
> > >  };
> > >  
> > >  static inline unsigned long kvm_dirty_bitmap_bytes(struct kvm_memory_slot *memslot)
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index 74bdb7bf3295..ebdd98a30e82 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -1243,6 +1243,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
> > >  	if (!mem->memory_size)
> > >  		return kvm_delete_memslot(kvm, mem, &old, as_id);
> > 
> > This technically needs to set as_id in the deleted memslot.  I highly doubt
> > it will ever matter from a functionality perspective, but it'd be confusing
> > to encounter a memslot whose as_id did not match that of its owner.
> 
> Yeah it shouldn't matter because as_id is directly passed in to look up the
> pointer of kvm_memslots in kvm_delete_memslot, and memslot->as_id shouldn't be
> further referenced.
> 
> I can add a comment above if this can clarify things a bit:
> 
> +	u16 as_id; /* cache of as_id; only valid if npages != 0 */

Why not just set it?  It's a single line of code, and there's more than one
"shouldn't" in the above.
