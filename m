Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6DF31BAC0B
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 20:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgD0SKz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 14:10:55 -0400
Received: from mga03.intel.com ([134.134.136.65]:33437 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725995AbgD0SKz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 14:10:55 -0400
IronPort-SDR: Cr2qcAYLXeFLjmMsMH/gKkHw90+P/5bdOo299Km3loBxnj68/BxL0nah3wW4K+BgYev6Yl2SON
 r2RCdz9XMuNg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 11:10:55 -0700
IronPort-SDR: gV6505nVR9Uf00DxSwVzlwBzUTwspCl7aZaDPS1ZznM26yKSLJnV+rAvnIZvi5+atxE0vHrfcb
 Otm0GQkrNr+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,325,1583222400"; 
   d="scan'208";a="292583458"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 27 Apr 2020 11:10:54 -0700
Date:   Mon, 27 Apr 2020 11:10:54 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Kevin Tian <kevin.tian@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH v8 03/14] KVM: X86: Don't track dirty for
 KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
Message-ID: <20200427181054.GL14870@linux.intel.com>
References: <20200331190000.659614-1-peterx@redhat.com>
 <20200331190000.659614-4-peterx@redhat.com>
 <20200423203944.GS17824@linux.intel.com>
 <20200424152151.GB41816@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424152151.GB41816@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 24, 2020 at 11:21:51AM -0400, Peter Xu wrote:
> On Thu, Apr 23, 2020 at 01:39:44PM -0700, Sean Christopherson wrote:
> > On Tue, Mar 31, 2020 at 02:59:49PM -0400, Peter Xu wrote:
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 1b6d9ac9533c..faa702c4d37b 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -9791,7 +9791,32 @@ void kvm_arch_sync_events(struct kvm *kvm)
> > >  	kvm_free_pit(kvm);
> > >  }
> > >  
> > > -int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
> > > +#define  ERR_PTR_USR(e)  ((void __user *)ERR_PTR(e))
> > 
> > Heh, my first thought when reading the below code was "cool, I didn't know
> > there was ERR_PTR_USR!".  This probably should be in include/linux/err.h,
> > or maybe a new arch specific implementation if it's not universally safe.
> 
> Yeah, I just wanted to avoid introducing things in common headers before I'm
> sure it'll be used in the rest of the world..  We can always replace them with
> a global definition when it comes.

Gotcha.

> > An alternative, which looks enticing given that proper user variants will
> > be a bit of an explosion, would be to do:
> > 
> >   static void *____x86_set_memory_region(...)
> >   {
> > 	<actual function>
> >   }
> > 
> >   void __user *__x86_set_memory_region(...)
> >   {
> > 	return (void __user *)____x86_set_memory_region(...);
> >   }
> > 
> > A second alternative would be to return an "unsigned long", i.e. force the
> > one function that actually accesses the hva to do the cast.  I think I like
> > this option the best as it would minimize the churn in
> > __x86_set_memory_region().  Callers can use IS_ERR_VALUE() to detect failure.
> 
> If you won't mind, I would prefer a 2nd opinion (maybe Paolo?) so we can
> consolidate the idea before I change them... (I would for sure still prefer the
> current approach for simplicity since after all I don't have strong opionion..)

Definitely makes sense for Paolo to weigh in.

> > > +/**
> > > + * __x86_set_memory_region: Setup KVM internal memory slot
> > > + *
> > > + * @kvm: the kvm pointer to the VM.
> > > + * @id: the slot ID to setup.
> > > + * @gpa: the GPA to install the slot (unused when @size == 0).
> > > + * @size: the size of the slot. Set to zero to uninstall a slot.
> > > + *
> > > + * This function helps to setup a KVM internal memory slot.  Specify
> > > + * @size > 0 to install a new slot, while @size == 0 to uninstall a
> > > + * slot.  The return code can be one of the following:
> > > + *
> > > + *   HVA:           on success (uninstall will return a bogus HVA)
> > 
> > I think it's important to call out that it returns '0' on uninstall, e.g.
> > otherwise it's not clear how a caller can detect failure.
> 
> It will "return (0xdeadull << 48)" as you proposed in abbed4fa94f6? :-)
> 
> Frankly speaking I always preferred zero but that's just not true any more
> after above change.  This also reminded me that maybe we should also return the
> same thing at [1] below.

Ah, I was looking at this code:

	if (!slot || !slot->npages)
		return 0;

That means deletion returns different success values for "deletion was a
nop" and "deletion was successful".  The nop path should probably return
(or fill in) "(unsigned long)(0xdeadull << 48)" as well.

> > > + *   -errno:        on error
> > > + *
> > > + * The caller should always use IS_ERR() to check the return value
> > > + * before use.  Note, the KVM internal memory slots are guaranteed to
> > > + * remain valid and unchanged until the VM is destroyed, i.e., the
> > > + * GPA->HVA translation will not change.  However, the HVA is a user
> > > + * address, i.e. its accessibility is not guaranteed, and must be
> > > + * accessed via __copy_{to,from}_user().
> > > + */
> > > +void __user * __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
> > > +				      u32 size)
> > >  {
> > >  	int i, r;
> > >  	unsigned long hva, uninitialized_var(old_npages);
> > > @@ -9800,12 +9825,12 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
> > >  
> > >  	/* Called with kvm->slots_lock held.  */
> > >  	if (WARN_ON(id >= KVM_MEM_SLOTS_NUM))
> > > -		return -EINVAL;
> > > +		return ERR_PTR_USR(-EINVAL);
> > >  
> > >  	slot = id_to_memslot(slots, id);
> > >  	if (size) {
> > >  		if (slot && slot->npages)
> > > -			return -EEXIST;
> > > +			return ERR_PTR_USR(-EEXIST);
> > >  
> > >  		/*
> > >  		 * MAP_SHARED to prevent internal slot pages from being moved
> > > @@ -9814,10 +9839,10 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
> > >  		hva = vm_mmap(NULL, 0, size, PROT_READ | PROT_WRITE,
> > >  			      MAP_SHARED | MAP_ANONYMOUS, 0);
> > >  		if (IS_ERR((void *)hva))
> > 
> > IS_ERR_VALUE() can be used to avoid the double cast.
> 
> Agreed.  But it's a context cleanup, so I normally will keep it as is (or use a
> standalone patch).
> 
> > 
> > > -			return PTR_ERR((void *)hva);
> > > +			return (void __user *)hva;
> > 
> > If we still want to go down the route of ERR_PTR_USR, then an ERR_CAST_USR
> > seems in order.
> 
> Sure.  But I'll still keep it kvm-only if you won't mind...
> 
> > 
> > >  	} else {
> > >  		if (!slot || !slot->npages)
> > > -			return 0;
> > > +			return ERR_PTR_USR(0);
> 
> [1]
> 
> > 
> > "return ERR_PTR_USR(NULL)" or "return NULL" would be more intuitive.  Moot
> > point if the return is changed to "unsigned long".
> 
> ERR_PTR_USR() takes a "long".  I can use ERR_CAST_USR(NULL) if you prefer me to
> explicitly use NULL.
> 
> Thanks,
> 
> -- 
> Peter Xu
> 
