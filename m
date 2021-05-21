Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F85E38C05B
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 09:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234572AbhEUHIx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 03:08:53 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:47080 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235286AbhEUHIu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 03:08:50 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1ljzEW-000575-4Q; Fri, 21 May 2021 09:06:08 +0200
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
References: <cover.1621191549.git.maciej.szmigiero@oracle.com>
 <cf1695b3e1ba495a4d23cbdc66e0fa9b7b535cc3.1621191551.git.maciej.szmigiero@oracle.com>
 <YKWaFwgMNSaQQuQP@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH v3 4/8] KVM: Introduce memslots hva tree
Message-ID: <a9a2f5c0-45f4-bde1-8336-3e90d97bc2c9@maciej.szmigiero.name>
Date:   Fri, 21 May 2021 09:06:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YKWaFwgMNSaQQuQP@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20.05.2021 01:07, Sean Christopherson wrote:
> Nit: something like "KVM: Use interval tree to do fast hva lookup in memslots"
> would be more helpful when perusing the shortlogs.  Stating that a tree is being
> added doesn't provide any hint as to why, or even the what is somewhat unclear.

Will do.

> On Sun, May 16, 2021, Maciej S. Szmigiero wrote:
>> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
>>
>> The current memslots implementation only allows quick binary search by gfn,
>> quick lookup by hva is not possible - the implementation has to do a linear
>> scan of the whole memslots array, even though the operation being performed
>> might apply just to a single memslot.
>>
>> This significantly hurts performance of per-hva operations with higher
>> memslot counts.
>>
>> Since hva ranges can overlap between memslots an interval tree is needed
>> for tracking them.
>>
>> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>> ---
> 
> ...
> 
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index d3a35646dfd8..f59847b6e9b3 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -27,6 +27,7 @@
>>   #include <linux/rcuwait.h>
>>   #include <linux/refcount.h>
>>   #include <linux/nospec.h>
>> +#include <linux/interval_tree.h>
>>   #include <linux/hashtable.h>
>>   #include <asm/signal.h>
>>   
>> @@ -358,6 +359,7 @@ static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
>>   
>>   struct kvm_memory_slot {
>>   	struct hlist_node id_node;
>> +	struct interval_tree_node hva_node;
>>   	gfn_t base_gfn;
>>   	unsigned long npages;
>>   	unsigned long *dirty_bitmap;
>> @@ -459,6 +461,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
>>    */
>>   struct kvm_memslots {
>>   	u64 generation;
>> +	struct rb_root_cached hva_tree;
>>   	/* The mapping table from slot id to the index in memslots[]. */
>>   	DECLARE_HASHTABLE(id_hash, 7);
>>   	atomic_t lru_slot;
>> @@ -679,6 +682,11 @@ static inline struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu)
>>   	return __kvm_memslots(vcpu->kvm, as_id);
>>   }
>>   
>> +#define kvm_for_each_hva_range_memslot(node, slots, start, last)	     \
> 
> kvm_for_each_memslot_in_range()?  Or kvm_for_each_memslot_in_hva_range()?

Will change the name to kvm_for_each_memslot_in_hva_range(), so it is
obvious it's the *hva* range this iterates over.

> Please add a comment about whether start is inclusive or exclusive.

Will do.

> I'd also be in favor of hiding this in kvm_main.c, just above the MMU notifier
> usage.  It'd be nice to discourage arch code from adding lookups that more than
> likely belong in generic code.

Will do.

>> +	for (node = interval_tree_iter_first(&slots->hva_tree, start, last); \
>> +	     node;							     \
>> +	     node = interval_tree_iter_next(node, start, last))	     \
>> +
>>   static inline
>>   struct kvm_memory_slot *id_to_memslot(struct kvm_memslots *slots, int id)
>>   {
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 50f9bc9bb1e0..a55309432c9a 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -488,6 +488,9 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
>>   	struct kvm_memslots *slots;
>>   	int i, idx;
>>   
>> +	if (range->end == range->start || WARN_ON(range->end < range->start))
> 
> I'm pretty sure both of these are WARNable offenses, i.e. they can be combined.
> It'd also be a good idea to use WARN_ON_ONCE(); if a caller does manage to
> trigger this, odds are good it will get spammed.

Will do.

> Also, does interval_tree_iter_first() explode if given bad inputs?  If not, I'd
> probably say just omit this entirely.  

Looking at the interval tree code it seems it does not account for this
possibility.
But even if after a deeper analysis it turns out to be safe (as of now)
there is always a possibility that in the future somebody will optimize
how this data structure performs its operations.
After all, garbage in, garbage out.

> If it does explode, it might be a good idea
> to work the sanity check into the macro, even if the macro is hidden here.

Can be done, although this will make the macro a bit uglier.

>> +		return 0;
>> +
>>   	/* A null handler is allowed if and only if on_lock() is provided. */
>>   	if (WARN_ON_ONCE(IS_KVM_NULL_FN(range->on_lock) &&
>>   			 IS_KVM_NULL_FN(range->handler)))
>> @@ -507,15 +510,18 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
>>   	}
>>   
>>   	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
>> +		struct interval_tree_node *node;
>> +
>>   		slots = __kvm_memslots(kvm, i);
>> -		kvm_for_each_memslot(slot, slots) {
>> +		kvm_for_each_hva_range_memslot(node, slots,
>> +					       range->start, range->end - 1) {
>>   			unsigned long hva_start, hva_end;
>>   
>> +			slot = container_of(node, struct kvm_memory_slot,
>> +					    hva_node);
> 
> Eh, let that poke out.  The 80 limit is more of a guideline.

Okay.

>>   			hva_start = max(range->start, slot->userspace_addr);
>>   			hva_end = min(range->end, slot->userspace_addr +
>>   						  (slot->npages << PAGE_SHIFT));
>> -			if (hva_start >= hva_end)
>> -				continue;
>>   
>>   			/*
>>   			 * To optimize for the likely case where the address
>> @@ -787,6 +793,7 @@ static struct kvm_memslots *kvm_alloc_memslots(void)
>>   	if (!slots)
>>   		return NULL;
>>   
>> +	slots->hva_tree = RB_ROOT_CACHED;
>>   	hash_init(slots->id_hash);
>>   
>>   	return slots;
>> @@ -1113,10 +1120,14 @@ static inline void kvm_memslot_delete(struct kvm_memslots *slots,
>>   		atomic_set(&slots->lru_slot, 0);
>>   
>>   	for (i = dmemslot - mslots; i < slots->used_slots; i++) {
>> +		interval_tree_remove(&mslots[i].hva_node, &slots->hva_tree);
>>   		hash_del(&mslots[i].id_node);
> 
> I think it would make sense to add helpers for these?  Not sure I like the names,
> but it would certainly dedup the code a bit.
> 
> static void kvm_memslot_remove(struct kvm_memslots *slots,
> 			       struct kvm_memslot *memslot)
> {
> 	interval_tree_remove(&memslot->hva_node, &slots->hva_tree);
> 	hash_del(&memslot->id_node);
> }
> 
> static void kvm_memslot_insert(struct kvm_memslots *slots,
> 			       struct kvm_memslot *memslot)
> {
> 	interval_tree_insert(&memslot->hva_node, &slots->hva_tree);
> 	hash_add(slots->id_hash, &memslot->id_node, memslot->id);> }

This is possible, however patch 6 replaces the whole code anyway
(and it has kvm_memslot_gfn_insert() and kvm_replace_memslot() helpers).

>> +
>>   		mslots[i] = mslots[i + 1];
>> +		interval_tree_insert(&mslots[i].hva_node, &slots->hva_tree);
>>   		hash_add(slots->id_hash, &mslots[i].id_node, mslots[i].id);
>>   	}
>> +	interval_tree_remove(&mslots[i].hva_node, &slots->hva_tree);
>>   	hash_del(&mslots[i].id_node);
>>   	mslots[i] = *memslot;
>>   }

Thanks,
Maciej
