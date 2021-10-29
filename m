Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5E2044003D
	for <lists+kvm@lfdr.de>; Fri, 29 Oct 2021 18:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbhJ2Q0g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Oct 2021 12:26:36 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:36796 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229607AbhJ2Q0e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Oct 2021 12:26:34 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1mgUfa-000874-Sb; Fri, 29 Oct 2021 18:23:54 +0200
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
References: <cover.1632171478.git.maciej.szmigiero@oracle.com>
 <4f8718fc8da57ab799e95ef7c2060f8be0f2391f.1632171479.git.maciej.szmigiero@oracle.com>
 <YXhQEeNxi2+fAQPM@google.com>
 <4222ead3-f80f-0992-569f-9e1a7adbabcc@maciej.szmigiero.name>
 <YXrjnSKBhzG7JVLF@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH v5 13/13] KVM: Optimize overlapping memslots check
Message-ID: <4156d889-5320-ff78-9898-e065d8554c7d@maciej.szmigiero.name>
Date:   Fri, 29 Oct 2021 18:23:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YXrjnSKBhzG7JVLF@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28.10.2021 19:53, Sean Christopherson wrote:
> On Wed, Oct 27, 2021, Maciej S. Szmigiero wrote:
>> On 26.10.2021 20:59, Sean Christopherson wrote:
>>>> +		/* kvm_for_each_in_gfn_no_more() guarantees that cslot->base_gfn < nend */
>>>> +		if (cend > nslot->base_gfn)
>>>
>>> Hmm, IMO the need for this check means that kvm_for_each_memslot_in_gfn_range()
>>> is flawed.  The user of kvm_for_each...() should not be responsible for skipping
>>> memslots that do not actually overlap the requested range.  I.e. this function
>>> should be no more than:
>>>
>>> static bool kvm_check_memslot_overlap(struct kvm_memslots *slots,
>>> 				      struct kvm_memory_slot *slot)
>>> {
>>> 	gfn_t start = slot->base_gfn;
>>> 	gfn_t end = start + slot->npages;
>>>
>>> 	kvm_for_each_memslot_in_gfn_range(&iter, slots, start, end) {
>>> 		if (iter.slot->id != slot->id)
>>> 			return true;
>>> 	}
>>>
>>> 	return false;
>>> }
>>>
>>>
>>> and I suspect kvm_zap_gfn_range() could be further simplified as well.
>>>
>>> Looking back at the introduction of the helper, its comment's highlighting of
>>> "possibily" now makes sense.
>>>
>>>     /* Iterate over each memslot *possibly* intersecting [start, end) range */
>>>     #define kvm_for_each_memslot_in_gfn_range(node, slots, start, end)	\
>>>
>>> That's an unnecessarily bad API.  It's a very solvable problem for the iterator
>>> helpers to advance until there's actually overlap, not doing so violates the
>>> principle of least surprise, and unless I'm missing something, there's no use
>>> case for an "approximate" iteration.
>>
>> In principle this can be done, however this will complicate the gfn
>> iterator logic - especially the kvm_memslot_iter_start() part, which
>> will already get messier from open-coding kvm_memslots_gfn_upper_bound()
>> there.
> 
> Hmm, no, this is trivial to handle, though admittedly a bit unpleasant.
> 
> /*
>   * Note, kvm_memslot_iter_start() finds the first memslot that _may_ overlap
>   * the range, it does not verify that there is actual overlap.  The check in
>   * the loop body filters out the case where the highest memslot with a base_gfn
>   * below start doesn't actually overlap.
>   */
> #define kvm_for_each_memslot_in_gfn_range(iter, node, slots, start, end) \
>          for (kvm_memslot_iter_start(iter, node, slots, start, end);      \
>               kvm_memslot_iter_is_valid(iter);                            \
>               kvm_memslot_iter_next(node))                                \
> 		if (iter->slot->base_gfn + iter->slot->npages < start) { \
> 		} else

As you say, that's rather unpleasant, since we know that the first
returned memslot is the only one that's possibly *not* overlapping
(and then it only happens sometimes).
Yet with the above change we'll pay the price of this check for every
loop iteration (for every returned memslot).
That's definitely not optimizing for the most common case.

Also, the above code has a bug - using a [start, end) notation compatible
with what kvm_for_each_memslot_in_gfn_range() expects,  where [1, 4)
means a range consisting of { 1, 2, 3 }, consider a tree consisting of the
following two memslots: [1, 2), [3, 5)

When kvm_for_each_memslot_in_gfn_range() is then called to "return"
memslots overlapping range [2, 4) it will "return" the [1, 2) memslot, too -
even though it does *not*  actually overlap the requested range.

While this bug is easy to fix (just use "<=" instead of "<") it serves to
underline that one has to be very careful with working with this type of
code as it is very easy to introduce subtle mistakes here.

Here, how many lines of code a function or macro has is not a good proxy
metric for how hard is to build a strictly accurate mental model of it.

>> At the same kvm_zap_gfn_range() will still need to do the memslot range
>> <-> request range merging by itself as it does not want to process the
>> whole returned memslot, but rather just the part that's actually
>> overlapping its requested range.
> 
> That's purely coincidental though.  IMO, kvm_zap_gfn_range() would be well within
> its rights to sanity the memslot, e.g.
> 
> 	if (WARN_ON(memslot->base_gfn + memslot->npages < gfn_start))
> 		continue;
>   
>> In the worst case, the current code can return one memslot too much, so
>> I don't think it's worth bringing additional complexity just to detect
>> and skip it
> 
> I strongly disagree.  This is very much a case of one chunk of code that knows
> the internal details of what it's doing taking on all the pain and complexity
> so that users of the helper
> 
>> it's not that uncommon to design an API that needs extra checking from its
>> caller to cover some corner cases.
> 
> That doesn't mean it's desirable.
> 
>> For example, see pthread_cond_wait() or kernel waitqueues with their
>> spurious wakeups or atomic_compare_exchange_weak() from C11.
>> And these are higher level APIs than a very limited internal KVM one
>> with just two callers.
> 
> Two _existing_ callers.  Odds are very, very high that future usage of
> kvm_for_each_memslot_in_gfn_range() will overlook the detail about the helper
> not actually doing what it says it does.  That could be addressed to some extent
> by renaming it kvm_for_each_memslot_in_gfn_range_approx() or whatever, but as
> above this isn't difficult to handle, just gross.

What kind of future users of this API do you envision?

I've pointed out above that adding this extra check means essentially
optimizing for an uncommon case.

One of the callers of this function already has the necessary code to
reject non-overlapping memslots and have to keep it to calculate the
effective overlapping range for each memslot.
For the second caller (which, by the way, is called much less often than
kvm_zap_gfn_range()) it's a matter of one extra condition.

>> In case of kvm_zap_gfn_range() the necessary checking is already
>> there and has to be kept due to the above range merging.
>>
>> Also, a code that is simpler is easier to understand, maintain and
>> so less prone to subtle bugs.
> 
> Heh, and IMO that's an argument for putting all the complexity into a single
> location.  :-)
> 

If you absolutely insist then obviously I can change the code to return
only memslots strictly overlapping the requested range in the next
patchset version.

However, I do want to know that this will be the final logic here,
since I am concerned that yet another bug might slip in, this time
under my radar, too.

Thanks,
Maciej
