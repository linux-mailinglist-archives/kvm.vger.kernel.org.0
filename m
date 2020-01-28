Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE4F14BF94
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 19:24:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgA1SYE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 13:24:04 -0500
Received: from mga18.intel.com ([134.134.136.126]:15937 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727080AbgA1SYE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jan 2020 13:24:04 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Jan 2020 10:24:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,374,1574150400"; 
   d="scan'208";a="252352625"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 28 Jan 2020 10:24:02 -0800
Date:   Tue, 28 Jan 2020 10:24:03 -0800
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
Message-ID: <20200128182402.GA18652@linux.intel.com>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109145729.32898-10-peterx@redhat.com>
 <20200121155657.GA7923@linux.intel.com>
 <20200128055005.GB662081@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200128055005.GB662081@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 28, 2020 at 01:50:05PM +0800, Peter Xu wrote:
> On Tue, Jan 21, 2020 at 07:56:57AM -0800, Sean Christopherson wrote:
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index c4d3972dcd14..ff97782b3919 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -9584,7 +9584,15 @@ void kvm_arch_sync_events(struct kvm *kvm)
> > >  	kvm_free_pit(kvm);
> > >  }
> > >  
> > > -int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
> > > +/*
> > > + * If `uaddr' is specified, `*uaddr' will be returned with the
> > > + * userspace address that was just allocated.  `uaddr' is only
> > > + * meaningful if the function returns zero, and `uaddr' will only be
> > > + * valid when with either the slots_lock or with the SRCU read lock
> > > + * held.  After we release the lock, the returned `uaddr' will be invalid.
> > 
> > This is all incorrect.  Neither of those locks has any bearing on the
> > validity of the hva.  slots_lock does as the name suggests and prevents
> > concurrent writes to the memslots.  The SRCU lock ensures the implicit
> > memslots lookup in kvm_clear_guest_page() won't result in a use-after-free
> > due to derefencing old memslots.
> > 
> > Neither of those has anything to do with the userspace address, they're
> > both fully tied to KVM's gfn->hva lookup.  As Paolo pointed out, KVM's
> > mapping is instead tied to the lifecycle of the VM.  Note, even *that* has
> > no bearing on the validity of the mapping or address as KVM only increments
> > mm_count, not mm_users, i.e. guarantees the mm struct itself won't be freed
> > but doesn't ensure the vmas or associated pages tables are valid.
> > 
> > Which is the entire point of using __copy_{to,from}_user(), as they
> > gracefully handle the scenario where the process has not valid mapping
> > and/or translation for the address.
> 
> Sorry I don't understand.
> 
> I do think either the slots_lock or SRCU would protect at least the
> existing kvm.memslots, and if so at least the previous vm_mmap()
> return value should still be valid.

Nope.  kvm->slots_lock only protects gfn->hva lookups, e.g. userspace can
munmap() the range at any time.

> I agree that __copy_to_user() will protect us from many cases from process
> mm pov (which allows page faults inside), but again if the kvm.memslots is
> changed underneath us then it's another story, IMHO, and that's why we need
> either the lock or SRCU.

No, again, slots_lock and SRCU only protect gfn->hva lookups.

> Or are you assuming that (1) __x86_set_memory_region() is only for the
> 3 private kvm memslots, 

It's not an assumption, the entire purpose of __x86_set_memory_region()
is to provide support for private KVM memslots.

> and (2) currently the kvm private memory slots will never change after VM
> is created and before VM is destroyed?

No, I'm not assuming the private memslots are constant, e.g. the flow in
question, vmx_set_tss_addr() is directly tied to an unprotected ioctl().

KVM's sole responsible for vmx_set_tss_addr() is to not crash the kernel.
Userspace is responsible for ensuring it doesn't break its guests, e.g.
that multiple calls to KVM_SET_TSS_ADDR are properly serialized.

In the existing code, KVM ensures it doesn't crash by holding the SRCU lock
for the duration of init_rmode_tss() so that the gfn->hva lookups in
kvm_clear_guest_page() don't dereference a stale memslots array.  In no way
does that ensure the validity of the resulting hva, e.g. multiple calls to
KVM_SET_TSS_ADDR would race to set vmx->tss_addr and so init_rmode_tss()
could be operating on a stale gpa.

Putting the onus on KVM to ensure atomicity is pointless because concurrent
calls to KVM_SET_TSS_ADDR would still race, i.e. the end value of
vmx->tss_addr would be non-deterministic.  The intregrity of the underlying
TSS would be guaranteed, but that guarantee isn't part of KVM's ABI.

> If so, I agree with you.  However I don't see why we need to restrict
> __x86_set_memory_region() with that assumption, after all taking a
> lock is not expensive in this slow path.

In what way would not holding slots_lock in vmx_set_tss_addr() restrict
__x86_set_memory_region()?  Literally every other usage of
__x86_set_memory_region() holds slots_lock for the duration of creating
the private memslot, because in those flows, KVM *is* responsible for
ensuring correct ordering.

> Even if so, we'd better comment above __x86_set_memory_region() about this,
> so we know that we should not use __x86_set_memory_region() for future kvm
> internal memslots that are prone to change during VM's lifecycle (while
> currently it seems to be a very general interface).

There is no such restriction.  Obviously such a flow would need to ensure
correctness, but hopefully that goes without saying.
