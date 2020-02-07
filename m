Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC8EC155FB2
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 21:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbgBGUjS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 15:39:18 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:46650 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727028AbgBGUjS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 15:39:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581107956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HDJ/VjQrWMNdHQtja+MCN3Q9tHemN4hRWun5DjgIKoY=;
        b=Y/OTtP+unlroR2cMuBnhxhsNPgJ6D4G4Jqre+q5UTY6DBbYlNFhRZKbShuguwMgmEsON41
        3tHmSBjACXTzDeLaiM/OfXPPs2CNT+Qf1hiLemyWCPgU24FrIOpBMOu0MPtXuqjFRDf2+V
        VjT22jnG60uet9bB+zmOzPu+ljZ2gqE=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-bk_Vb33BN2aXEvE5gJzZXg-1; Fri, 07 Feb 2020 15:39:14 -0500
X-MC-Unique: bk_Vb33BN2aXEvE5gJzZXg-1
Received: by mail-qk1-f199.google.com with SMTP id t195so254538qke.23
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2020 12:39:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HDJ/VjQrWMNdHQtja+MCN3Q9tHemN4hRWun5DjgIKoY=;
        b=lYbtbgkJkDNwRHlEFRUAesJpwZVZqCg6K9QD1okQsHAFPqvyqrSv7wJBG2hdocwNCM
         R9iAPWh3QXEMutntzDvoZtPmSb3LyctsUsvveGTtIvisRL2ynLrCVuWMwOujeFyfsEFO
         /jnFF/mDgOuUVV+vq7ZoPoWU9gu59adMlJGqQXJeiUuI7YA6aOjwtN/oUxIKJKLLwttG
         ciHJZYBOBqbhKZmMXR/cUGKYUEeYc7eYInE4dW91E64rG/y7p79eMO3kjA4wew9N49Tg
         mJqUYe6D8Mpb+dEDcYxK7yhusyKJDl7sL/w4r+noEnsjua5Wsyrfg9fRHUV4cYF33bJA
         Ku8Q==
X-Gm-Message-State: APjAAAVixhx3r2PyF56VkH2EhW5dCenLf6wmHAOCO0Kn1qJk2IJlbpTp
        AEygg1AmUI7XEZLbBmLA8TfgUnMN6M8Y8rEn+OXQ0DmrT6pwzt+9ribTCKs0Glr7djq4TTSy4pd
        FHJTxOzHVk6N+
X-Received: by 2002:a05:620a:201d:: with SMTP id c29mr707082qka.91.1581107953744;
        Fri, 07 Feb 2020 12:39:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqxQuu5qnyNVPYa+YqHICHyvrdUbVM/BEFf5AJFqCnQhpIOoL4uGjjInlTUcv67ProkOUC4n0Q==
X-Received: by 2002:a05:620a:201d:: with SMTP id c29mr707063qka.91.1581107953398;
        Fri, 07 Feb 2020 12:39:13 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id h34sm2025258qtc.62.2020.02.07.12.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 12:39:12 -0800 (PST)
Date:   Fri, 7 Feb 2020 15:39:09 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
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
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: Re: [PATCH v5 17/19] KVM: Terminate memslot walks via used_slots
Message-ID: <20200207203909.GE720553@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-18-sean.j.christopherson@intel.com>
 <20200206210944.GD700495@xz-x1>
 <20200207183325.GI2401@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200207183325.GI2401@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 07, 2020 at 10:33:25AM -0800, Sean Christopherson wrote:
> On Thu, Feb 06, 2020 at 04:09:44PM -0500, Peter Xu wrote:
> > On Tue, Jan 21, 2020 at 02:31:55PM -0800, Sean Christopherson wrote:
> > > @@ -9652,13 +9652,13 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
> > >  		if (IS_ERR((void *)hva))
> > >  			return PTR_ERR((void *)hva);
> > >  	} else {
> > > -		if (!slot->npages)
> > > +		if (!slot || !slot->npages)
> > >  			return 0;
> > >  
> > > -		hva = 0;
> > > +		hva = slot->userspace_addr;
> > 
> > Is this intended?
> 
> Yes.  It's possible to allow VA=0 for userspace mappings.  It's extremely
> uncommon, but possible.  Therefore "hva == 0" shouldn't be used to
> indicate an invalid slot.

Note that this is the deletion path in __x86_set_memory_region() not
allocation.  IIUC userspace_addr won't even be used in follow up code
path so it shouldn't really matter.  Or am I misunderstood somewhere?

> 
> > > +		old_npages = slot->npages;
> > >  	}
> > >  
> > > -	old = *slot;
> > >  	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> > >  		struct kvm_userspace_memory_region m;
> > >  
> 
> ...
> 
> > > @@ -869,63 +869,162 @@ static int kvm_create_dirty_bitmap(struct kvm_memory_slot *memslot)
> > >  }
> > >  
> > >  /*
> > > - * Insert memslot and re-sort memslots based on their GFN,
> > > - * so binary search could be used to lookup GFN.
> > > - * Sorting algorithm takes advantage of having initially
> > > - * sorted array and known changed memslot position.
> > > + * Delete a memslot by decrementing the number of used slots and shifting all
> > > + * other entries in the array forward one spot.
> > > + */
> > > +static inline void kvm_memslot_delete(struct kvm_memslots *slots,
> > > +				      struct kvm_memory_slot *memslot)
> > > +{
> > > +	struct kvm_memory_slot *mslots = slots->memslots;
> > > +	int i;
> > > +
> > > +	if (WARN_ON(slots->id_to_index[memslot->id] == -1))
> > > +		return;
> > > +
> > > +	slots->used_slots--;
> > > +
> > > +	for (i = slots->id_to_index[memslot->id]; i < slots->used_slots; i++) {
> > > +		mslots[i] = mslots[i + 1];
> > > +		slots->id_to_index[mslots[i].id] = i;
> > > +	}
> > > +	mslots[i] = *memslot;
> > > +	slots->id_to_index[memslot->id] = -1;
> > > +}
> > > +
> > > +/*
> > > + * "Insert" a new memslot by incrementing the number of used slots.  Returns
> > > + * the new slot's initial index into the memslots array.
> > > + */
> > > +static inline int kvm_memslot_insert_back(struct kvm_memslots *slots)
> > 
> > The naming here didn't help me to understand but a bit more
> > confused...
> > 
> > How about "kvm_memslot_insert_end"?  Or even unwrap it.
> 
> It's not guaranteed to be the end, as there could be multiple unused
> entries at the back of the array.  I agree the naming isn't perfect, but
> IMO it's the least crappy option and will be familiar to anyone with C++
> STL (and other languages?) experience.  Arguably it would be better to
> follow kernel naming for lists, e.g. head/tail, but there are no
> convenient adverbs for the move helpers, e.g. kvm_memslot_move_backward()
> would be kvm_memslot_move_towards_tail().
> 
> I'm very strongly opposed to unwrapping it.
> 
> The code would look like this.  Without a beefy comment, the high level
> semantics of the KVM_MR_CREATE case are not at all clear.  Adding a
> comment gets messy because putting it above the entire if-else makes it
> difficult to understand that its *only* for the CREATE case, and I hate
> having multi-line comments in if-else statements without brackets.
> 
>                 if (change == KVM_MR_CREATE)
>                         i = slots->used_slots++
>                 else
>                         i = kvm_memslot_move_backward(slots, memslot);

This is made too complicated, imho... A one-liner comment would be
clear enough to me.  :)

Please feel free to keep the original code as you wish.

> 
> > > +{
> > > +	return slots->used_slots++;
> > > +}
> > > +
> > > +/*
> > > + * Move a changed memslot backwards in the array by shifting existing slots
> > > + * with a higher GFN toward the front of the array.  Note, the changed memslot
> > > + * itself is not preserved in the array, i.e. not swapped at this time, only
> > > + * its new index into the array is tracked.  Returns the changed memslot's
> > > + * current index into the memslots array.
> > > + */
> > > +static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
> > > +					    struct kvm_memory_slot *memslot)
> > 
> > "backward" makes me feel like it's moving towards smaller index,
> > instead it's moving to bigger index.  Same applies to "forward" below.
> > I'm not sure whether I'm the only one, though...
> 
> Move forward towards the front, and backward towards the back.  In the
> languages I am familiar with, e.g. C++ STL, JavaScript, Python, and Golang,
> front==container[0] and back==container[len() - 1].

OK.

> 
> > > +{
> > > +	struct kvm_memory_slot *mslots = slots->memslots;
> > > +	int i;
> > > +
> > > +	if (WARN_ON_ONCE(slots->id_to_index[memslot->id] == -1) ||
> > > +	    WARN_ON_ONCE(!slots->used_slots))
> > > +		return -1;
> > > +
> > > +	/*
> > > +	 * Move the target memslot backward in the array by shifting existing
> > > +	 * memslots with a higher GFN (than the target memslot) towards the
> > > +	 * front of the array.
> > > +	 */
> > > +	for (i = slots->id_to_index[memslot->id]; i < slots->used_slots - 1; i++) {
> > > +		if (memslot->base_gfn > mslots[i + 1].base_gfn)
> > > +			break;
> > > +
> > > +		WARN_ON_ONCE(memslot->base_gfn == mslots[i + 1].base_gfn);
> > 
> > Will this trigger?  Note that in __kvm_set_memory_region() we have
> > already checked overlap of memslots.
> 
> If you screw up the code it will :-)  In a perfect world, no WARN() will
> *ever* trigger.  All of the added WARN_ON_ONCE() are to help the next poor
> soul that wants to modify this code.

I normally won't keep WARN_ON if it is 100% not triggering (100% here
I mean when e.g. it is checked twice so the 1st one will definitely
trigger first).  My question is more like a pure question in case I
overlooked something.  Please also feel free to keep it if you want.

>  
> > > +
> > > +		/* Shift the next memslot forward one and update its index. */
> > > +		mslots[i] = mslots[i + 1];
> > > +		slots->id_to_index[mslots[i].id] = i;
> > > +	}
> > > +	return i;
> > > +}
> > > @@ -1104,8 +1203,13 @@ int __kvm_set_memory_region(struct kvm *kvm,
> 
> ...
> 
> > >  	 * when the memslots are re-sorted by update_memslots().
> > >  	 */
> > >  	tmp = id_to_memslot(__kvm_memslots(kvm, as_id), id);
> > > -	old = *tmp;
> > > -	tmp = NULL;
> > 
> > I was confused in that patch, then...
> > 
> > > +	if (tmp) {
> > > +		old = *tmp;
> > > +		tmp = NULL;
> > 
> > ... now I still don't know why it needs to set to NULL?
> 
> To make it abundantly clear that though shall not use @tmp, i.e. to force
> using the copy and not the pointer.  Note, @tmp is also reused as an
> iterator below.

OK it still feels a bit strange, say, we can comment on that if you
wants to warn the others.  The difference is probably no useless
instruction executed.  But this is also trivial, I'll leave to the
others to judge.

Thanks,

-- 
Peter Xu

