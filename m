Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 671C9155ADA
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 16:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbgBGPib (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 10:38:31 -0500
Received: from mga17.intel.com ([192.55.52.151]:52915 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726982AbgBGPib (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 10:38:31 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Feb 2020 07:38:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,413,1574150400"; 
   d="scan'208";a="255445625"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 07 Feb 2020 07:38:29 -0800
Date:   Fri, 7 Feb 2020 07:38:29 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>
Subject: Re: [PATCH v5 18/19] KVM: Dynamically size memslot array based on
 number of used slots
Message-ID: <20200207153829.GA2401@linux.intel.com>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-19-sean.j.christopherson@intel.com>
 <20200206221208.GI700495@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200206221208.GI700495@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 06, 2020 at 05:12:08PM -0500, Peter Xu wrote:
> On Tue, Jan 21, 2020 at 02:31:56PM -0800, Sean Christopherson wrote:
> > Now that the memslot logic doesn't assume memslots are always non-NULL,
> > dynamically size the array of memslots instead of unconditionally
> > allocating memory for the maximum number of memslots.
> > 
> > Note, because a to-be-deleted memslot must first be invalidated, the
> > array size cannot be immediately reduced when deleting a memslot.
> > However, consecutive deletions will realize the memory savings, i.e.
> > a second deletion will trim the entry.
> > 
> > Tested-by: Christoffer Dall <christoffer.dall@arm.com>
> > Tested-by: Marc Zyngier <maz@kernel.org>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  include/linux/kvm_host.h |  2 +-
> >  virt/kvm/kvm_main.c      | 31 ++++++++++++++++++++++++++++---
> >  2 files changed, 29 insertions(+), 4 deletions(-)
> > 
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 60ddfdb69378..8bb6fb127387 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -431,11 +431,11 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
> >   */
> >  struct kvm_memslots {
> >  	u64 generation;
> > -	struct kvm_memory_slot memslots[KVM_MEM_SLOTS_NUM];
> >  	/* The mapping table from slot id to the index in memslots[]. */
> >  	short id_to_index[KVM_MEM_SLOTS_NUM];
> >  	atomic_t lru_slot;
> >  	int used_slots;
> > +	struct kvm_memory_slot memslots[];
> 
> This patch is tested so I believe this works, however normally I need
> to do similar thing with [0] otherwise gcc might complaint.  Is there
> any trick behind to make this work?  Or is that because of different
> gcc versions?

array[] and array[0] have the same net affect, but array[] is given special
treatment by gcc to provide extra sanity checks, e.g. requires the field to
be the end of the struct.  Last I checked, gcc also doesn't allow array[]
in unions.  There are probably other restrictions.

But, it's precisely because of those restrictions that using array[] is
preferred, as it provides extra protections, e.g. if someone moved memslots
to the top of the struct it would fail to compile.
 
> >  };
> >  
> >  struct kvm {
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 9b614cf2ca20..ed392ce64e59 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -565,7 +565,7 @@ static struct kvm_memslots *kvm_alloc_memslots(void)
> >  		return NULL;
> >  
> >  	for (i = 0; i < KVM_MEM_SLOTS_NUM; i++)
> > -		slots->id_to_index[i] = slots->memslots[i].id = -1;
> > +		slots->id_to_index[i] = -1;
> >  
> >  	return slots;
> >  }
> > @@ -1077,6 +1077,32 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
> >  	return old_memslots;
> >  }
> >  
> > +/*
> > + * Note, at a minimum, the current number of used slots must be allocated, even
> > + * when deleting a memslot, as we need a complete duplicate of the memslots for
> > + * use when invalidating a memslot prior to deleting/moving the memslot.
> > + */
> > +static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
> > +					     enum kvm_mr_change change)
> > +{
> > +	struct kvm_memslots *slots;
> > +	size_t old_size, new_size;
> > +
> > +	old_size = sizeof(struct kvm_memslots) +
> > +		   (sizeof(struct kvm_memory_slot) * old->used_slots);
> > +
> > +	if (change == KVM_MR_CREATE)
> > +		new_size = old_size + sizeof(struct kvm_memory_slot);
> > +	else
> > +		new_size = old_size;
> > +
> > +	slots = kvzalloc(new_size, GFP_KERNEL_ACCOUNT);
> > +	if (likely(slots))
> > +		memcpy(slots, old, old_size);
> 
> (Maybe directly copy into it?)

I don't follow, are you saying do "*slots = *old"?

@new_size and @old_size are not guaranteed to be the same.  More
specifically, slots->memslots and old->slots are now flexible arrays with
potentially different sizes.  Doing "*slots = *old" would only copy the
standard members, a memcpy() would still be needed for @memlots.

A more effecient implementation would be:

	slots = kvalloc(new_size, GFP_KERNEL_ACCOUNT);
	if (likely(slots)) {
		memcpy(slots, old, old_size);
		if (change == KVM_MR_CREATE)
			memset((void *)slots + old_size, 0, new_size - old_size);
	}

to avoid unnecessarily zeroing out the entire thing.  I opted for the
simpler implementation as this is not performance critical code, for most
cases @slots won't be all that large, and I wanted to be absolutely sure
any mixup would hit zeroed memory and not uninitialized memory.

> 
> > +
> > +	return slots;
> > +}
> > +
> >  static int kvm_set_memslot(struct kvm *kvm,
> >  			   const struct kvm_userspace_memory_region *mem,
> >  			   struct kvm_memory_slot *old,
> > @@ -1087,10 +1113,9 @@ static int kvm_set_memslot(struct kvm *kvm,
> >  	struct kvm_memslots *slots;
> >  	int r;
> >  
> > -	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
> > +	slots = kvm_dup_memslots(__kvm_memslots(kvm, as_id), change);
> >  	if (!slots)
> >  		return -ENOMEM;
> > -	memcpy(slots, __kvm_memslots(kvm, as_id), sizeof(struct kvm_memslots));
> >  
> >  	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
> >  		/*
> > -- 
> > 2.24.1
> > 
> 
> -- 
> Peter Xu
> 
