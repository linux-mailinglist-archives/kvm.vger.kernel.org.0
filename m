Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67A83156085
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 22:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgBGVKR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 16:10:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:27540 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727048AbgBGVKR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 16:10:17 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Feb 2020 13:10:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,414,1574150400"; 
   d="scan'208";a="220912856"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 07 Feb 2020 13:10:16 -0800
Date:   Fri, 7 Feb 2020 13:10:16 -0800
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
Subject: Re: [PATCH v5 17/19] KVM: Terminate memslot walks via used_slots
Message-ID: <20200207211016.GN2401@linux.intel.com>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-18-sean.j.christopherson@intel.com>
 <20200206210944.GD700495@xz-x1>
 <20200207183325.GI2401@linux.intel.com>
 <20200207203909.GE720553@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200207203909.GE720553@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 07, 2020 at 03:39:09PM -0500, Peter Xu wrote:
> On Fri, Feb 07, 2020 at 10:33:25AM -0800, Sean Christopherson wrote:
> > On Thu, Feb 06, 2020 at 04:09:44PM -0500, Peter Xu wrote:
> > > On Tue, Jan 21, 2020 at 02:31:55PM -0800, Sean Christopherson wrote:
> > > > @@ -9652,13 +9652,13 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
> > > >  		if (IS_ERR((void *)hva))
> > > >  			return PTR_ERR((void *)hva);
> > > >  	} else {
> > > > -		if (!slot->npages)
> > > > +		if (!slot || !slot->npages)
> > > >  			return 0;
> > > >  
> > > > -		hva = 0;
> > > > +		hva = slot->userspace_addr;
> > > 
> > > Is this intended?
> > 
> > Yes.  It's possible to allow VA=0 for userspace mappings.  It's extremely
> > uncommon, but possible.  Therefore "hva == 0" shouldn't be used to
> > indicate an invalid slot.
> 
> Note that this is the deletion path in __x86_set_memory_region() not
> allocation.  IIUC userspace_addr won't even be used in follow up code
> path so it shouldn't really matter.  Or am I misunderstood somewhere?

No, but that's precisely why I don't want to zero out @hva, as doing so
implies that '0' indicates an invalid hva, which is wrong.

What if I change this to 

			hva = 0xdeadull << 48;

and add a blurb in the changelog about stuff hva with a non-canonical value
to indicate it's being destroyed.

> > > > +		old_npages = slot->npages;
> > > >  	}
> > > >  
> > > > -	old = *slot;
> > > >  	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> > > >  		struct kvm_userspace_memory_region m;
> > > >  

...

> > > > +{
> > > > +	struct kvm_memory_slot *mslots = slots->memslots;
> > > > +	int i;
> > > > +
> > > > +	if (WARN_ON_ONCE(slots->id_to_index[memslot->id] == -1) ||
> > > > +	    WARN_ON_ONCE(!slots->used_slots))
> > > > +		return -1;
> > > > +
> > > > +	/*
> > > > +	 * Move the target memslot backward in the array by shifting existing
> > > > +	 * memslots with a higher GFN (than the target memslot) towards the
> > > > +	 * front of the array.
> > > > +	 */
> > > > +	for (i = slots->id_to_index[memslot->id]; i < slots->used_slots - 1; i++) {
> > > > +		if (memslot->base_gfn > mslots[i + 1].base_gfn)
> > > > +			break;
> > > > +
> > > > +		WARN_ON_ONCE(memslot->base_gfn == mslots[i + 1].base_gfn);
> > > 
> > > Will this trigger?  Note that in __kvm_set_memory_region() we have
> > > already checked overlap of memslots.
> > 
> > If you screw up the code it will :-)  In a perfect world, no WARN() will
> > *ever* trigger.  All of the added WARN_ON_ONCE() are to help the next poor
> > soul that wants to modify this code.
> 
> I normally won't keep WARN_ON if it is 100% not triggering (100% here
> I mean when e.g. it is checked twice so the 1st one will definitely
> trigger first).  My question is more like a pure question in case I
> overlooked something.  Please also feel free to keep it if you want.

Ah.  The WARNs here as much to concisely document the assumptions and
conditions of the code as they are there to enforce those conditions.

> > > > +
> > > > +		/* Shift the next memslot forward one and update its index. */
> > > > +		mslots[i] = mslots[i + 1];
s> > > > +		slots->id_to_index[mslots[i].id] = i;
> > > > +	}
> > > > +	return i;
> > > > +}
> > > > @@ -1104,8 +1203,13 @@ int __kvm_set_memory_region(struct kvm *kvm,
> > 
> > ...
> > 
> > > >  	 * when the memslots are re-sorted by update_memslots().
> > > >  	 */
> > > >  	tmp = id_to_memslot(__kvm_memslots(kvm, as_id), id);
> > > > -	old = *tmp;
> > > > -	tmp = NULL;
> > > 
> > > I was confused in that patch, then...
> > > 
> > > > +	if (tmp) {
> > > > +		old = *tmp;
> > > > +		tmp = NULL;
> > > 
> > > ... now I still don't know why it needs to set to NULL?
> > 
> > To make it abundantly clear that though shall not use @tmp, i.e. to force
> > using the copy and not the pointer.  Note, @tmp is also reused as an
> > iterator below.
> 
> OK it still feels a bit strange, say, we can comment on that if you
> wants to warn the others.  The difference is probably no useless
> instruction executed.  But this is also trivial, I'll leave to the
> others to judge.

After having suffered through deciphering this code and blundering into
nasty gotchas more than once, I'd really like to keep the nullification.
I'll add a comment to explain that the sole purpose is to kill @tmp so it
can't be used incorrectly and thus cause silent failure.

This is also another reason I'd like to keep the WARN_ONs.  When this code
goes awry, the result is usually silent corruption and delayed explosions,
i.e. failures that absolutely suck to debug.
