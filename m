Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3595E30CF3A
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 23:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235565AbhBBWnT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 17:43:19 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:59894 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235113AbhBBWnB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 17:43:01 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps (TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.93.0.4)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1l74N7-00031Q-Ud; Tue, 02 Feb 2021 23:42:09 +0100
To:     Sean Christopherson <seanjc@google.com>
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
References: <ceb96527b6f7bb662eec813f05b897a551ebd0b2.1612140117.git.maciej.szmigiero@oracle.com>
 <4d748e0fd50bac68ece6952129aed319502b6853.1612140117.git.maciej.szmigiero@oracle.com>
 <YBisBkSYPoaOM42F@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 2/2] KVM: Scalable memslots implementation
Message-ID: <9e6ca093-35c3-7cca-443b-9f635df4891d@maciej.szmigiero.name>
Date:   Tue, 2 Feb 2021 23:42:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YBisBkSYPoaOM42F@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

Thanks for your quick look at the series.

On 02.02.2021 02:33, Sean Christopherson wrote:
> The patch numbering and/or threading is messed up.  This should either be a
> standalone patch, or fully incorporated into the same series as the selftests
> changes.  But, that's somewhat of a moot point...

While the new benchmark was used to measure the performance of these
changes, it is otherwise independent of them, that's why it was submitted
as a separate series.

> On Mon, Feb 01, 2021, Maciej S. Szmigiero wrote:
>> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
>>
>> The current memslot code uses a (reverse) gfn-ordered memslot array for
>> keeping track of them.
>> This only allows quick binary search by gfn, quick lookup by hva is not
>> possible (the implementation has to do a linear scan of the whole memslot
>> array).
>>
>> Because the memslot array that is currently in use cannot be modified
>> every memslot management operation (create, delete, move, change flags)
>> has to make a copy of the whole array so it has a scratch copy to work
>> on.
>>
>> Strictly speaking, however, it is only necessary to make copy of the
>> memslot that is being modified, copying all the memslots currently
>> present is just a limitation of the array-based memslot implementation.
>>
>> Two memslot sets, however, are still needed so the VM continues to
>> run on the currently active set while the requested operation is being
>> performed on the second, currently inactive one.
>>
>> In order to have two memslot sets, but only one copy of the actual
>> memslots it is necessary to split out the memslot data from the
>> memslot sets.
>>
>> The memslots themselves should be also kept independent of each other
>> so they can be individually added or deleted.
>>
>> These two memslot sets should normally point to the same set of
>> memslots. They can, however, be desynchronized when performing a
>> memslot management operation by replacing the memslot to be modified
>> by its copy.
>> After the operation is complete, both memslot sets once again
>> point to the same, common set of memslot data.
>>
>> This commit implements the aforementioned idea.
> 
> This needs split into at least 5+ patches, and probably more like 10+ to have
> a realistic chance of getting it thoroughly reviewed.
> 
> E.g. changes that can easily be split out:
> 
>    - Move s390's "approximate" logic into search_memslots.

Will do.

>    - Introduce n_memslots_pages

Will do.

>    - Using a hash for id_to_index

Will do.

>    - Changing KVM_USER_MEM_SLOTS to SHRT_MAX

Will do.

>    - kvm_zap_gfn_range() changes/optimizations

I guess you mean using a gfn rbtree instead of an ordered array here,
since that's the reason for the change here - will do.

> 
> AFAICT, tracking both the active and inactive memslot in memslots_all could also
> be done in a separate patch, though I can't tell if that would actually gain
> anything.

Two sets of memslots are always needed since we need a second, inactive
set to perform operation on while the VM continues to run on the first
one.

It is only that the current code makes a copy of the whole array,
including all the memslot data, for this second set, but the new code
only copies the data of the actually modified memslot.

For this reason, the patch that changes the array implementation to the
"memslots_all" implementation has to also change the whole algorithm in
kvm_set_memslot().


>> The new implementation uses two trees to perform quick lookups:
>> For tracking of gfn an ordinary rbtree is used since memslots cannot
>> overlap in the guest address space and so this data structure is
>> sufficient for ensuring that lookups are done quickly.
> 
> Switching to a rbtree for the gfn lookups also appears to be a separate change,

All right.

> though that's little more than a guess based on a quick read of the changes.
> 
>> For tracking of hva, however, an interval tree is needed since they
>> can overlap between memslots.
> 
> ...
> 
>> Making lookup and memslot management operations O(log(n)) brings
>> some performance benefits (tested on a Xeon 8167M machine):
>> 509 slots in use:
>> Test          Before         After		Improvement
>> Map           0,0246s     0,0240s		 2%
>> Unmap         0,0833s     0,0318s		62%
>> Unmap 2M      0,00177s	0,000917s	48%
>> Move active   0,0000959s	0,0000816s	15%
>> Move inactive 0,0000960s	0,0000799s	17%
> 
> I assume "move" refers to the gfn?  If so, I believe this can be ignored for the
> most part as it's not a common operation, and already has a lot of leading zeros :-)

Even if it is not a common operation (today) making it better is
still a good thing.

The move test result has a lot of leading zeros since it is moving just
a single memslot and that does not take a lot of time in the absolute
sense.

>> Slot setup	0,0107s		0,00825s	23%
> 
> What does "slot setup" measure?  I assume it's one-time pain?  If so, then we
> can probably ignore this as use cases that care about millisecond improvements
> in boot time are unlikely to have 50 memslots, let alone 500+ memslots.

This value shows how long it took the test to add all these memslots.

Strictly speaking, it also includes the time spent allocating
the backing memory and time spent in the (userspace) selftest framework
vm_userspace_mem_region_add() function, but since these operations are
exactly the same for both in-kernel memslots implementations the
difference in results is all due to the new kernel code (that is, this
patch).

The result also shows how the performance of the create memslot operation
scales with various count of memslots in use (the measurement is always
done with the same guest memory size).

Hyper-V SynIC may require up to two additional slots per vCPU.
A large guest with with 128 vCPUs will then use 256 memslots for this
alone.
Also, performance improvements add up.

At (guest) runtime live migration uses the memslot set flags operation
to turn on and off dirty pages logging.
Hot{un,}plug of memory and some other devices (like GPUs) create and
delete memslots, too.

> I'm not nitpicking the benchmarks to discredit your measurements, rather to
> point out that I suspect the only thing that's "broken" and that anyone truly
> cares about is unmapping, i.e. hva->memslot lookups.  If that is indeed the
> case, would it be sufficient to focus on speeding up _just_ the hva lookups?>
> Specifically, I think we can avoid copying the "active vs. inactive" scheme that
> is used for the main gfn-based array by having the hva tree resolve to an _id_,
> not to the memslot itself. I.e. bounce through id_to_index, which is coupled> with the main array, so that lookups are always done on the "active" memslots,
> without also having to implement an "inactive" hva tree.

I guess you mean to still turn id_to_index into a hash table, since
otherwise a VMM which uses just two memslots but numbered 0 and 508
will have a 509-entry id_to_index array allocated.

> For deletion, seeing the defunct/invalid memslot is not a functional problem;
> it's technically a performance "problem", but one that we already have.  For
> creation, id_to_index will be -1, and so the memslot lookup will return NULL
> until the new memslot is visible.

This sounds like you would keep the id_to_index array / hash table
separate from the main array as it is in the old code (I read "coupled
with the main array" above as a suggestion to move it to the part that
gets resized when memslots are created or deleted in the current code,
that is struct kvm_memslots).

Then if you create or delete a memslot the memslots located further in
the memslot array (with lower gfn that the processed slot) will have
their indices shifted - you can't atomically update all of them.

But overall, this solution (and the one with id_to_index moved into the
main array, too) is still O(n) per memslot operation as you still need to
copy the array to either make space for the new memslot or to remove the
hole from the removed memslot.

Due to that scaling issue it's rather hard to use 32k memslots with the
old code, the improvement was like 20+ times there on an early version
of this code.

And if we start adding special cases for things like flags change or
gfn moves to workaround their scaling issues the code will quickly grow
even more complicated.

> 
> All hva lookups would obviously need to be changed, but the touchpoint for the
> write would be quite small, e.g.
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 8367d88ce39b..c03beb4833b2 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1220,6 +1220,20 @@ static int kvm_set_memslot(struct kvm *kvm,
>          if (r)
>                  goto out_slots;
> 
> +       /*
> +        * Update the hva=>id tree if a memslot is being deleted or created.
> +        * No update is required for moving a memslot or changing its flags,
> +        * as those don't affect its _id_.  For deletion, the memslot has been
> +        * zapped and flushed, fast hva lookups are guaranteed to be nops.  For
> +        * creation, the new memslot isn't visible until the final installation
> +        * is complete.  Fast hva lookups may prematurely see the entry, but
> +        * id_to_memslot() will return NULL upon seeing id_to_index[id] == -1.
> +        */
> +       if (change == KVM_MR_DELETE)
> +               kvm_hva_tree_remove(...);
> +       else if (change == KVM_MR_CREATE)
> +               kvm_hva_tree_insert(...);
> +
>          update_memslots(slots, new, change);
>          slots = install_new_memslots(kvm, as_id, slots);
> 
>
> I'm not opposed to using more sophisticated storage for the gfn lookups, but
> only if there's a good reason for doing so.  IMO, the rbtree isn't simpler, just
> different.  Memslot modifications are unlikely to be a hot path (and if it is,
> x86's "zap everything" implementation is a far bigger problem), and it's hard to
> beat the memory footprint of a raw array.  That doesn't leave much motivation
> for such a big change to some of KVM's scariest (for me) code.
> 

Improvements can be done step-by-step,
kvm_mmu_invalidate_zap_pages_in_memslot() can be rewritten, too in the
future, if necessary.
After all, complains are that this change alone is too big.

I think that if you look not at the patch itself but at the resulting
code the new implementation looks rather straightforward, there are
comments at every step in kvm_set_memslot() to explain exactly what is
being done.
Not only it already scales well, but it is also flexible to accommodate
further improvements or even new operations.

The new implementation also uses standard kernel {rb,interval}-tree and
hash table implementation as its basic data structures, so it
automatically benefits from any generic improvements to these.

All for the low price of just 174 net lines of code added.

Maciej
