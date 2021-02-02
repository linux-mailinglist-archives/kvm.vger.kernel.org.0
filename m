Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF4730CFF3
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 00:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhBBXog (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 18:44:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229466AbhBBXof (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 18:44:35 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5680CC061788
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 15:43:55 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id s24so3290088pjp.5
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 15:43:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TFhKnEbS5tnzAjSTgUGK0hVK7sWaCRvcwy0WR3lAdSc=;
        b=PGpVhmBczpBs7N99PQ0DWAWN8ErN6uMHF50ryZxnMpmjcUn2INHIhLy49vDTZaXUs+
         BVF5QIcKTc7U8q6upR7sctXZ9+nkzAJmMtyxcpva0WWjNN4S6OIGOOVovjwvnm6R8cik
         qLehUSWZ+xIE41hqEk1mhaTd6KDmel8E1sMojBGJiiiaI7izuXOK1SK8HINyzAuYlGcG
         sI48ncibeXXUBnzZ6yJpXJiIL3nhDRQdPoJlU4WlF/NqBBcH3TZkFS8AuDyvPA4Ui9Dm
         qV/yakUNubyWcVpXdOJz7BIkzgMEfhfVNUOWFxFE0i1hm81HRPUVAiHP0zOz84KwEqET
         LuPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TFhKnEbS5tnzAjSTgUGK0hVK7sWaCRvcwy0WR3lAdSc=;
        b=soRQIGaL9pbSpIbwmHzkWdjJCrdrMK3hn9IXHnYcK+w19OKvpfXm6O8ePmAtzL8a5G
         S2tgtidHEnWUPC3bfK3X0dcEBhPsIbBaP6QaEmlODJyTVgJKBJAnYM5PGSLTJtS5G5iI
         1VblVLTKm8r9z3xdPsBatEC4fxPOD14AeeLKYFQKL+AeLRjP2GKuqJxLG9ywqfMabNj7
         rx+dT+/L/vcely4a5nmxbB+H1sdsacY5HWPm42peQFJwCzy/EkKjwGzhTPPcbmB8UomH
         Bi5/pSio9TGsWRjh/DIV6E6btnsgnlIrYkUcPgXe6KfokB7K0UQFYBCC1D0pFQhYAh6S
         RXXA==
X-Gm-Message-State: AOAM532uAAFWnHShHlcVolo2M3FnpGd56l/bHcuoZo+apYXp0XZyXeie
        7hxq4GuD8SFUX47XlAZDevRGOA==
X-Google-Smtp-Source: ABdhPJztFp0LrHHbcKIdK45Shn5hc38ZlRy9WyZgEJ4RZXFiO4b9XBhfA8uAk6Cauc2vCvXB/w0zrg==
X-Received: by 2002:a17:902:f686:b029:de:18c7:41f8 with SMTP id l6-20020a170902f686b02900de18c741f8mr564398plg.65.1612309434519;
        Tue, 02 Feb 2021 15:43:54 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e1bc:da69:2e4b:ce97])
        by smtp.gmail.com with ESMTPSA id r7sm100931pfc.26.2021.02.02.15.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 15:43:53 -0800 (PST)
Date:   Tue, 2 Feb 2021 15:43:46 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: Scalable memslots implementation
Message-ID: <YBnjso2OeX1/r3Ls@google.com>
References: <ceb96527b6f7bb662eec813f05b897a551ebd0b2.1612140117.git.maciej.szmigiero@oracle.com>
 <4d748e0fd50bac68ece6952129aed319502b6853.1612140117.git.maciej.szmigiero@oracle.com>
 <YBisBkSYPoaOM42F@google.com>
 <9e6ca093-35c3-7cca-443b-9f635df4891d@maciej.szmigiero.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e6ca093-35c3-7cca-443b-9f635df4891d@maciej.szmigiero.name>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 02, 2021, Maciej S. Szmigiero wrote:
> On 02.02.2021 02:33, Sean Christopherson wrote:
> > > Making lookup and memslot management operations O(log(n)) brings
> > > some performance benefits (tested on a Xeon 8167M machine):
> > > 509 slots in use:
> > > Test          Before         After		Improvement
> > > Map           0,0246s     0,0240s		 2%
> > > Unmap         0,0833s     0,0318s		62%
> > > Unmap 2M      0,00177s	0,000917s	48%
> > > Move active   0,0000959s	0,0000816s	15%
> > > Move inactive 0,0000960s	0,0000799s	17%
> > 
> > I assume "move" refers to the gfn?  If so, I believe this can be ignored for the
> > most part as it's not a common operation, and already has a lot of leading zeros :-)
> 
> Even if it is not a common operation (today) making it better is
> still a good thing.
> 
> The move test result has a lot of leading zeros since it is moving just
> a single memslot and that does not take a lot of time in the absolute
> sense.

Yes, that's my point.  The absolute time is barely measurable, this is an
extremely rare operation, and the optimal approach isn't orders of magnitude
faster, i.e. we can comfortably ignore the "move" performance when weighing
options.

> > > Slot setup	0,0107s		0,00825s	23%
> > 
> > What does "slot setup" measure?  I assume it's one-time pain?  If so, then we
> > can probably ignore this as use cases that care about millisecond improvements
> > in boot time are unlikely to have 50 memslots, let alone 500+ memslots.
> 
> This value shows how long it took the test to add all these memslots.
> 
> Strictly speaking, it also includes the time spent allocating
> the backing memory and time spent in the (userspace) selftest framework
> vm_userspace_mem_region_add() function, but since these operations are
> exactly the same for both in-kernel memslots implementations the
> difference in results is all due to the new kernel code (that is, this
> patch).
> 
> The result also shows how the performance of the create memslot operation
> scales with various count of memslots in use (the measurement is always
> done with the same guest memory size).
> 
> Hyper-V SynIC may require up to two additional slots per vCPU.
> A large guest with with 128 vCPUs will then use 256 memslots for this
> alone.
> Also, performance improvements add up.

I generally agree, but if this is literally a one time savings of a millisecond
or so, for VM with a boot time measured in seconds or even tends of seconds...

> At (guest) runtime live migration uses the memslot set flags operation
> to turn on and off dirty pages logging.

Do you have numbers for the overhead of enabling dirty logging?  I assume the
per-memslot overhead will be similr to the "move" microbenchmark?

> Hot{un,}plug of memory and some other devices (like GPUs) create and
> delete memslots, too.
> 
> > I'm not nitpicking the benchmarks to discredit your measurements, rather to
> > point out that I suspect the only thing that's "broken" and that anyone truly
> > cares about is unmapping, i.e. hva->memslot lookups.  If that is indeed the
> > case, would it be sufficient to focus on speeding up _just_ the hva lookups?>
> > Specifically, I think we can avoid copying the "active vs. inactive" scheme that
> > is used for the main gfn-based array by having the hva tree resolve to an _id_,
> > not to the memslot itself. I.e. bounce through id_to_index, which is coupled
> > with the main array, so that lookups are always done on the "active" memslots,
> > without also having to implement an "inactive" hva tree.
> 
> I guess you mean to still turn id_to_index into a hash table, since
> otherwise a VMM which uses just two memslots but numbered 0 and 508
> will have a 509-entry id_to_index array allocated.

That should be irrelevant for the purposes of optimizing hva lookups, and mostly
irrelevant for optimizing memslot updates.  Using a hash table is almost a pure
a memory optimization, it really only matters when the max number of memslots
skyrockets, which is a separate discussion from optimizing hva lookups.

> > For deletion, seeing the defunct/invalid memslot is not a functional problem;
> > it's technically a performance "problem", but one that we already have.  For
> > creation, id_to_index will be -1, and so the memslot lookup will return NULL
> > until the new memslot is visible.
> 
> This sounds like you would keep the id_to_index array / hash table
> separate from the main array as it is in the old code (I read "coupled
> with the main array" above as a suggestion to move it to the part that
> gets resized when memslots are created or deleted in the current code,
> that is struct kvm_memslots).

What I meant by "coupled" is that, in the current code, the id_to_index and
main memslots array are updated in tandem, it's impossible for readers to see
unsynchronized arrays.

> Then if you create or delete a memslot the memslots located further in
> the memslot array (with lower gfn that the processed slot) will have
> their indices shifted - you can't atomically update all of them.
> 
> But overall, this solution (and the one with id_to_index moved into the
> main array, too) is still O(n) per memslot operation as you still need to
> copy the array to either make space for the new memslot or to remove the
> hole from the removed memslot.

Yes, but that problem that can be solved separately from the performance issue
with hva lookups.

> Due to that scaling issue it's rather hard to use 32k memslots with the
> old code, the improvement was like 20+ times there on an early version
> of this code.
>
> And if we start adding special cases for things like flags change or
> gfn moves to workaround their scaling issues the code will quickly grow
> even more complicated.
> 
> > 
> > All hva lookups would obviously need to be changed, but the touchpoint for the
> > write would be quite small, e.g.
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 8367d88ce39b..c03beb4833b2 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -1220,6 +1220,20 @@ static int kvm_set_memslot(struct kvm *kvm,
> >          if (r)
> >                  goto out_slots;
> > 
> > +       /*
> > +        * Update the hva=>id tree if a memslot is being deleted or created.
> > +        * No update is required for moving a memslot or changing its flags,
> > +        * as those don't affect its _id_.  For deletion, the memslot has been
> > +        * zapped and flushed, fast hva lookups are guaranteed to be nops.  For
> > +        * creation, the new memslot isn't visible until the final installation
> > +        * is complete.  Fast hva lookups may prematurely see the entry, but
> > +        * id_to_memslot() will return NULL upon seeing id_to_index[id] == -1.
> > +        */
> > +       if (change == KVM_MR_DELETE)
> > +               kvm_hva_tree_remove(...);
> > +       else if (change == KVM_MR_CREATE)
> > +               kvm_hva_tree_insert(...);
> > +
> >          update_memslots(slots, new, change);
> >          slots = install_new_memslots(kvm, as_id, slots);
> > 
> > 
> > I'm not opposed to using more sophisticated storage for the gfn lookups, but
> > only if there's a good reason for doing so.  IMO, the rbtree isn't simpler, just
> > different.  Memslot modifications are unlikely to be a hot path (and if it is,
> > x86's "zap everything" implementation is a far bigger problem), and it's hard to
> > beat the memory footprint of a raw array.  That doesn't leave much motivation
> > for such a big change to some of KVM's scariest (for me) code.
> > 
> 
> Improvements can be done step-by-step,
> kvm_mmu_invalidate_zap_pages_in_memslot() can be rewritten, too in the
> future, if necessary.
> After all, complains are that this change alone is too big.

It's not simply that it's too big, it's that it solves several problems in
a single patch that can, and should, be done in separate patches.

Dumping everything into a single patch makes bisecting nearly worthless, e.g. if
fast hva lookups breaks a non-x86 architecture, we should able to bisect to
exactly that, not a massive patch that completely rewrites all of the memslot
code in one fell swoop.

Mega patches with multiple logical changes are also extremely difficult to
review.

See 'Patch preparation' in Documentation/process/5.Posting.rst for more info on
splitting up patches.

> I think that if you look not at the patch itself but at the resulting
> code the new implementation looks rather straightforward,

Sorry to be blunt, but that's just not how Linux kernel development works.
Again, I am not opposed to any particular idea/approach in this patch, but the
individual enhancements absolutely need to be split into separate patches.

I focused on the hva tree because I think that has, by far, the best bang for
the buck.  The performance benefits are clear, the changes can be done with
minimal impact to existing code, and each architcture can opt-in one at a time.
What I'm suggesting is that we first get the fast hva lookups merged, and then
worry about getting KVM to play nice with tens of thousands of memslots.

> there are comments at every step in kvm_set_memslot() to explain exactly what
> is being done.  Not only it already scales well, but it is also flexible to
> accommodate further improvements or even new operations.
> 
> The new implementation also uses standard kernel {rb,interval}-tree and hash
> table implementation as its basic data structures, so it automatically
> benefits from any generic improvements to these.
> 
> All for the low price of just 174 net lines of code added.
> 
> Maciej
