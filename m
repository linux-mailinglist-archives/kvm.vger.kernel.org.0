Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53ACC123A3B
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 23:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfLQWvU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 17:51:20 -0500
Received: from mga14.intel.com ([192.55.52.115]:3230 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbfLQWvU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 17:51:20 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2019 14:51:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,327,1571727600"; 
   d="scan'208";a="247654290"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 17 Dec 2019 14:51:18 -0800
Date:   Tue, 17 Dec 2019 14:51:18 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>,
        kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v4 07/19] KVM: Explicitly free allocated-but-unused dirty
 bitmap
Message-ID: <20191217225118.GF11771@linux.intel.com>
References: <20191217204041.10815-1-sean.j.christopherson@intel.com>
 <20191217204041.10815-8-sean.j.christopherson@intel.com>
 <20191217222446.GK7258@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217222446.GK7258@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 17, 2019 at 05:24:46PM -0500, Peter Xu wrote:
> On Tue, Dec 17, 2019 at 12:40:29PM -0800, Sean Christopherson wrote:
> > Explicitly free an allocated-but-unused dirty bitmap instead of relying
> > on kvm_free_memslot() if an error occurs in __kvm_set_memory_region().
> > There is no longer a need to abuse kvm_free_memslot() to free arch
> > specific resources as arch specific code is now called only after the
> > common flow is guaranteed to succeed.  Arch code can still fail, but
> > it's responsible for its own cleanup in that case.
> > 
> > Eliminating the error path's abuse of kvm_free_memslot() paves the way
> > for simplifying kvm_free_memslot(), i.e. dropping its @dont param.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  virt/kvm/kvm_main.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index d403e93e3028..6b2261a9e139 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -1096,7 +1096,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
> >  
> >  	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
> >  	if (!slots)
> > -		goto out_free;
> > +		goto out_bitmap;
> >  	memcpy(slots, __kvm_memslots(kvm, as_id), sizeof(struct kvm_memslots));
> >  
> >  	if ((change == KVM_MR_DELETE) || (change == KVM_MR_MOVE)) {
> > @@ -1144,8 +1144,9 @@ int __kvm_set_memory_region(struct kvm *kvm,
> >  	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
> >  		slots = install_new_memslots(kvm, as_id, slots);
> >  	kvfree(slots);
> > -out_free:
> > -	kvm_free_memslot(kvm, &new, &old);
> > +out_bitmap:
> > +	if (new.dirty_bitmap && !old.dirty_bitmap)
> > +		kvm_destroy_dirty_bitmap(&new);
> 
> What if both the old and new have KVM_MEM_LOG_DIRTY_PAGES set?
> kvm_free_memslot() did cover that but I see that you explicitly
> dropped it.  Could I ask why?  Thanks,

In that case, old.dirty_bitmap == new.dirty_bitmap, i.e. shouldn't be freed
by this error path since doing so would result in a use-after-free via the
old memslot.

The kvm_free_memslot() logic is the same, albeit in a very twisted way.

In __kvm_set_memory_region(), @old and @new start with the same dirty_bitmap.

	new = old = *slot;

And @new is modified based on KVM_MEM_LOG_DIRTY_PAGES.  If LOG_DIRTY_PAGES
is set in both @new and @old, then both the "if" and "else if" evaluate
false, i.e. new.dirty_bitmap == old.dirty_bitmap.

	/* Allocate/free page dirty bitmap as needed */
	if (!(new.flags & KVM_MEM_LOG_DIRTY_PAGES))
		new.dirty_bitmap = NULL;
	else if (!new.dirty_bitmap) {
		r = kvm_create_dirty_bitmap(&new);
		if (r)
			return r;
	}

Subbing "@free <= @new" and "@dont <= @old" in kvm_free_memslot()

  static void kvm_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free,
			       struct kvm_memory_slot *dont)
  {
	if (!dont || free->dirty_bitmap != dont->dirty_bitmap)
		kvm_destroy_dirty_bitmap(free);


yeids this, since @old is obviously non-NULL

	if (new.dirty_bitmap != old.dirty_bitmap)
		kvm_destroy_dirty_bitmap(&new);

The dirty_bitmap allocation logic guarantees that new.dirty_bitmap is
  a) NULL (the "if" case")
  b) != old.dirty_bitmap iff old.dirty_bitmap == NULL (the "else if" case)
  c) == old.dirty_bitmap (the implicit "else" case).

kvm_free_memslot() frees @new.dirty_bitmap iff its != @old.dirty_bitmap,
thus the explicit destroy only needs to check for (b).
