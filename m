Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4E4D14F498
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 23:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbgAaWUz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 17:20:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:55797 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726180AbgAaWUz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jan 2020 17:20:55 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jan 2020 14:20:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,387,1574150400"; 
   d="scan'208";a="223281824"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga008.jf.intel.com with ESMTP; 31 Jan 2020 14:20:53 -0800
Date:   Fri, 31 Jan 2020 14:20:53 -0800
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
Message-ID: <20200131222053.GI18946@linux.intel.com>
References: <20200121155657.GA7923@linux.intel.com>
 <20200128055005.GB662081@xz-x1>
 <20200128182402.GA18652@linux.intel.com>
 <20200131150832.GA740148@xz-x1>
 <20200131193301.GC18946@linux.intel.com>
 <20200131202824.GA7063@xz-x1>
 <20200131203622.GF18946@linux.intel.com>
 <20200131205550.GB7063@xz-x1>
 <20200131212928.GH18946@linux.intel.com>
 <20200131221637.GC7063@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200131221637.GC7063@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 31, 2020 at 05:16:37PM -0500, Peter Xu wrote:
> On Fri, Jan 31, 2020 at 01:29:28PM -0800, Sean Christopherson wrote:
> > On Fri, Jan 31, 2020 at 03:55:50PM -0500, Peter Xu wrote:
> > > On Fri, Jan 31, 2020 at 12:36:22PM -0800, Sean Christopherson wrote:
> > > > On Fri, Jan 31, 2020 at 03:28:24PM -0500, Peter Xu wrote:
> > > > > On Fri, Jan 31, 2020 at 11:33:01AM -0800, Sean Christopherson wrote:
> > > > > > For the same reason we don't take mmap_sem, it gains us nothing, i.e. KVM
> > > > > > still has to use copy_{to,from}_user().
> > > > > > 
> > > > > > In the proposed __x86_set_memory_region() refactor, vmx_set_tss_addr()
> > > > > > would be provided the hva of the memory region.  Since slots_lock and SRCU
> > > > > > only protect gfn->hva, why would KVM take slots_lock since it already has
> > > > > > the hva?
> > > > > 
> > > > > OK so you're suggesting to unlock the lock earlier to not cover
> > > > > init_rmode_tss() rather than dropping the whole lock...  Yes it looks
> > > > > good to me.  I think that's the major confusion I got.
> > > > 
> > > > Ya.  And I missed where the -EEXIST was coming from.  I think we're on the
> > > > same page.
> > > 
> > > Good to know.  Btw, for me I would still prefer to keep the lock be
> > > after the __copy_to_user()s because "HVA is valid without lock" is
> > > only true for these private memslots.
> > 
> > No.  From KVM's perspective, the HVA is *never* valid.  Even if you rewrote
> > this statement to say "the gfn->hva translation is valid without lock" it
> > would still be incorrect. 
> > 
> > KVM is *always* using HVAs without holding lock, e.g. every time it enters
> > the guest it is deferencing a memslot because the translations stored in
> > the TLB are effectively gfn->hva->hpa.  Obviously KVM ensures that it won't
> > dereference a memslot that has been deleted/moved, but it's a lot more
> > subtle than simply holding a lock.
> > 
> > > After all this is super slow path so I wouldn't mind to take the lock
> > > for some time longer.
> > 
> > Holding the lock doesn't affect this super slow vmx_set_tss_addr(), it
> > affects everything else that wants slots_lock.  Now, admittedly it's
> > extremely unlikely userspace is going to do KVM_SET_USER_MEMORY_REGION in
> > parallel, but that's not the point and it's not why I'm objecting to
> > holding the lock.
> > 
> > Holding the lock implies protection that is *not* provided.  You and I know
> > it's not needed for copy_{to,from}_user(), but look how long it's taken us
> > to get on the same page.  A future KVM developer comes along, sees this
> > code, and thinks "oh, I need to hold slots_lock to dereference a gfn", and
> > propagates the unnecessary locking to some other code.
> 
> At least for a user memory slot, we "need to hold slots_lock to
> dereference a gfn" (or srcu), right?

Gah, that was supposed to be "dereference a hva".  Yes, a gfn->hva lookup
requires slots_lock or SRCU read lock.

> You know I'm suffering from a jetlag today, I thought I was still
> fine, now I start to doubt it. :-)

Unintentional gaslighting.  Or was it?  :-D
