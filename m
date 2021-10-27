Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F67B43CB1C
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 15:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237526AbhJ0Nu4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 09:50:56 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:41838 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231458AbhJ0Nuz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Oct 2021 09:50:55 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1mfjHu-0001RD-DR; Wed, 27 Oct 2021 15:48:18 +0200
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
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH v5 13/13] KVM: Optimize overlapping memslots check
Message-ID: <4222ead3-f80f-0992-569f-9e1a7adbabcc@maciej.szmigiero.name>
Date:   Wed, 27 Oct 2021 15:48:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YXhQEeNxi2+fAQPM@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26.10.2021 20:59, Sean Christopherson wrote:
> On Mon, Sep 20, 2021, Maciej S. Szmigiero wrote:
>> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
>>
>> Do a quick lookup for possibly overlapping gfns when creating or moving
>> a memslot instead of performing a linear scan of the whole memslot set.
>>
>> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>> ---
>>   virt/kvm/kvm_main.c | 36 +++++++++++++++++++++++++++---------
>>   1 file changed, 27 insertions(+), 9 deletions(-)
>>
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 5fea467d6fec..78dad8c6376f 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -1667,6 +1667,30 @@ static int kvm_delete_memslot(struct kvm *kvm,
>>   	return kvm_set_memslot(kvm, mem, old, &new, as_id, KVM_MR_DELETE);
>>   }
>>   
>> +static bool kvm_check_memslot_overlap(struct kvm_memslots *slots,
>> +				      struct kvm_memory_slot *nslot)
>> +{
>> +	int idx = slots->node_idx;
>> +	gfn_t nend = nslot->base_gfn + nslot->npages;
>> +	struct rb_node *node;
>> +
>> +	kvm_for_each_memslot_in_gfn_range(node, slots, nslot->base_gfn, nend) {
>> +		struct kvm_memory_slot *cslot;
>> +		gfn_t cend;
>> +
>> +		cslot = container_of(node, struct kvm_memory_slot, gfn_node[idx]);
>> +		cend = cslot->base_gfn + cslot->npages;
>> +		if (cslot->id == nslot->id)
>> +			continue;
>> +
>> +		/* kvm_for_each_in_gfn_no_more() guarantees that cslot->base_gfn < nend */
>> +		if (cend > nslot->base_gfn)
> 
> Hmm, IMO the need for this check means that kvm_for_each_memslot_in_gfn_range()
> is flawed.  The user of kvm_for_each...() should not be responsible for skipping
> memslots that do not actually overlap the requested range.  I.e. this function
> should be no more than:
> 
> static bool kvm_check_memslot_overlap(struct kvm_memslots *slots,
> 				      struct kvm_memory_slot *slot)
> {
> 	gfn_t start = slot->base_gfn;
> 	gfn_t end = start + slot->npages;
> 
> 	kvm_for_each_memslot_in_gfn_range(&iter, slots, start, end) {
> 		if (iter.slot->id != slot->id)
> 			return true;
> 	}
> 
> 	return false;
> }
> 
> 
> and I suspect kvm_zap_gfn_range() could be further simplified as well.
> 
> Looking back at the introduction of the helper, its comment's highlighting of
> "possibily" now makes sense.
> 
>    /* Iterate over each memslot *possibly* intersecting [start, end) range */
>    #define kvm_for_each_memslot_in_gfn_range(node, slots, start, end)	\
> 
> That's an unnecessarily bad API.  It's a very solvable problem for the iterator
> helpers to advance until there's actually overlap, not doing so violates the
> principle of least surprise, and unless I'm missing something, there's no use
> case for an "approximate" iteration.

In principle this can be done, however this will complicate the gfn
iterator logic - especially the kvm_memslot_iter_start() part, which
will already get messier from open-coding kvm_memslots_gfn_upper_bound()
there.

At the same kvm_zap_gfn_range() will still need to do the memslot range
<-> request range merging by itself as it does not want to process the
whole returned memslot, but rather just the part that's actually
overlapping its requested range.

In the worst case, the current code can return one memslot too much, so
I don't think it's worth bringing additional complexity just to detect
and skip it - it's not that uncommon to design an API that needs extra
checking from its caller to cover some corner cases.

For example, see pthread_cond_wait() or kernel waitqueues with their
spurious wakeups or atomic_compare_exchange_weak() from C11.
And these are higher level APIs than a very limited internal KVM one
with just two callers.
In case of kvm_zap_gfn_range() the necessary checking is already
there and has to be kept due to the above range merging.

Also, a code that is simpler is easier to understand, maintain and
so less prone to subtle bugs.

>> +			return true;
>> +	}
>> +
>> +	return false;
>> +}
>> +
>>   /*
>>    * Allocate some memory and give it an address in the guest physical address
>>    * space.
>> @@ -1752,16 +1776,10 @@ int __kvm_set_memory_region(struct kvm *kvm,
>>   	}
>>   
>>   	if ((change == KVM_MR_CREATE) || (change == KVM_MR_MOVE)) {
>> -		int bkt;
>> -
>>   		/* Check for overlaps */
> 
> This comment can be dropped, the new function is fairly self-documenting.

Will drop it.

>> -		kvm_for_each_memslot(tmp, bkt, __kvm_memslots(kvm, as_id)) {
>> -			if (tmp->id == id)
>> -				continue;
>> -			if (!((new.base_gfn + new.npages <= tmp->base_gfn) ||
>> -			      (new.base_gfn >= tmp->base_gfn + tmp->npages)))
>> -				return -EEXIST;
>> -		}
>> +		if (kvm_check_memslot_overlap(__kvm_memslots(kvm, as_id),
>> +					      &new))
> 
> And then with the comment dropped, the wrap can be avoided by folding the check
> into the outer if statement, e.g.
> 
> 	if (((change == KVM_MR_CREATE) || (change == KVM_MR_MOVE)) &&
> 	    kvm_check_memslot_overlap(__kvm_memslots(kvm, as_id), &new))
> 		return -EEXIST;
> 

Will fold it.

Thanks,
Maciej
