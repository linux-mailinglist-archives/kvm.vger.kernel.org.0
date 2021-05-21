Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8365338C058
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 09:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233874AbhEUHIx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 03:08:53 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:47046 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235282AbhEUHIt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 03:08:49 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1ljzDq-000569-AA; Fri, 21 May 2021 09:05:26 +0200
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
 <4a4867419344338e1419436af1e1b0b8f2405517.1621191551.git.maciej.szmigiero@oracle.com>
 <YKWRyvyyO5UAHv4U@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH v3 3/8] KVM: Resolve memslot ID via a hash table instead
 of via a static array
Message-ID: <c7ba42ee-dc70-a86c-aeb2-d410c136a5ec@maciej.szmigiero.name>
Date:   Fri, 21 May 2021 09:05:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YKWRyvyyO5UAHv4U@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20.05.2021 00:31, Sean Christopherson wrote:
> On Sun, May 16, 2021, Maciej S. Szmigiero wrote:
>> @@ -356,6 +357,7 @@ static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
>>   #define KVM_MEM_MAX_NR_PAGES ((1UL << 31) - 1)
>>   
>>   struct kvm_memory_slot {
>> +	struct hlist_node id_node;
>>   	gfn_t base_gfn;
>>   	unsigned long npages;
>>   	unsigned long *dirty_bitmap;
>> @@ -458,7 +460,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
>>   struct kvm_memslots {
>>   	u64 generation;
>>   	/* The mapping table from slot id to the index in memslots[]. */
>> -	short id_to_index[KVM_MEM_SLOTS_NUM];
>> +	DECLARE_HASHTABLE(id_hash, 7);
> 
> Is there any specific motivation for using 7 bits?

At the time this code was written "id_to_index" was 512 entries * 2 bytes =
1024 bytes in size and I didn't want to unnecessarily make
struct kvm_memslots bigger so I have tried using a hashtable array of the
same size (128 bucket-heads * 8 bytes).

I have done a few performance measurements then and I remember there was
only a small performance difference in comparison to using a larger
hashtable (for 509 memslots), so it seemed like a good compromise.

The KVM selftest framework patch actually uses a 9-bit hashtable so the
509 original memslots have chance to be stored without hash collisions.

Another option would be to use a dynamically-resizable hashtable but this
would make the code significantly more complex and possibly introduce new
performance corner cases (like a workload that forces the hashtable grow
and shrink repeatably).

>>   	atomic_t lru_slot;
>>   	int used_slots;
>>   	struct kvm_memory_slot memslots[];
> 
> ...
> 
>> @@ -1097,14 +1095,16 @@ static int kvm_alloc_dirty_bitmap(struct kvm_memory_slot *memslot)
>>   /*
>>    * Delete a memslot by decrementing the number of used slots and shifting all
>>    * other entries in the array forward one spot.
>> + * @memslot is a detached dummy struct with just .id and .as_id filled.
>>    */
>>   static inline void kvm_memslot_delete(struct kvm_memslots *slots,
>>   				      struct kvm_memory_slot *memslot)
>>   {
>>   	struct kvm_memory_slot *mslots = slots->memslots;
>> +	struct kvm_memory_slot *dmemslot = id_to_memslot(slots, memslot->id);
> 
> I vote to call these local vars "old", or something along those lines.  dmemslot
> isn't too bad, but mmemslot in the helpers below is far too similar to memslot,
> and using the wrong will cause nasty explosions.

Will rename to "oldslot" then.

(..)
>> @@ -1135,31 +1136,41 @@ static inline int kvm_memslot_insert_back(struct kvm_memslots *slots)
>>    * itself is not preserved in the array, i.e. not swapped at this time, only
>>    * its new index into the array is tracked.  Returns the changed memslot's
>>    * current index into the memslots array.
>> + * The memslot at the returned index will not be in @slots->id_hash by then.
>> + * @memslot is a detached struct with desired final data of the changed slot.
>>    */
>>   static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
>>   					    struct kvm_memory_slot *memslot)
>>   {
>>   	struct kvm_memory_slot *mslots = slots->memslots;
>> +	struct kvm_memory_slot *mmemslot = id_to_memslot(slots, memslot->id);
>>   	int i;
>>   
>> -	if (WARN_ON_ONCE(slots->id_to_index[memslot->id] == -1) ||
>> +	if (WARN_ON_ONCE(!mmemslot) ||
>>   	    WARN_ON_ONCE(!slots->used_slots))
>>   		return -1;
>>   
>> +	/*
>> +	 * update_memslots() will unconditionally overwrite and re-add the
>> +	 * target memslot so it has to be removed here firs
>> +	 */
> 
> It would be helpful to explain "why" this is necessary.  Something like:
> 
> 	/*
> 	 * The memslot is being moved, delete its previous hash entry; its new
> 	 * entry will be added by updated_memslots().  The old entry cannot be
> 	 * kept even though its id is unchanged, because the old entry points at
> 	 * the memslot in the old instance of memslots.
> 	 */

Well, this isn't technically true, since kvm_dup_memslots() reinits
the hashtable of the copied memslots array and re-adds all the existing
memslots there.

The reasons this memslot is getting removed from the hashtable are that:
a) The loop below will (possibly) overwrite it with data of the next
memslot, or a similar loop in kvm_memslot_move_forward() will overwrite
it with data of the previous memslot,

b) update_memslots() will overwrite it with data of the target memslot.

The comment above only refers to the case b), so I will update it to
also cover the case a).

(..)
>> @@ -1247,12 +1266,16 @@ static void update_memslots(struct kvm_memslots *slots,
>>   			i = kvm_memslot_move_backward(slots, memslot);
>>   		i = kvm_memslot_move_forward(slots, memslot, i);
>>   
>> +		if (i < 0)
>> +			return;
> 
> Hmm, this is essentially a "fix" to existing code, it should be in a separate
> patch.  And since kvm_memslot_move_forward() can theoretically hit this even if
> kvm_memslot_move_backward() doesn't return -1, i.e. doesn't WARN, what about
> doing WARN_ON_ONCE() here and dropping the WARNs in kvm_memslot_move_backward()?
> It'll be slightly less developer friendly, but anyone that has the unfortunate
> pleasure of breaking and debugging this code is already in for a world of pain.

Will do.

>> +
>>   		/*
>>   		 * Copy the memslot to its new position in memslots and update
>>   		 * its index accordingly.
>>   		 */
>>   		slots->memslots[i] = *memslot;
>> -		slots->id_to_index[memslot->id] = i;
>> +		hash_add(slots->id_hash, &slots->memslots[i].id_node,
>> +			 memslot->id);
>>   	}
>>   }
>>   
>> @@ -1316,6 +1339,7 @@ static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
>>   {
>>   	struct kvm_memslots *slots;
>>   	size_t old_size, new_size;
>> +	struct kvm_memory_slot *memslot;
>>   
>>   	old_size = sizeof(struct kvm_memslots) +
>>   		   (sizeof(struct kvm_memory_slot) * old->used_slots);
>> @@ -1326,8 +1350,14 @@ static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
>>   		new_size = old_size;
>>   
>>   	slots = kvzalloc(new_size, GFP_KERNEL_ACCOUNT);
>> -	if (likely(slots))
>> -		memcpy(slots, old, old_size);
>> +	if (unlikely(!slots))
>> +		return NULL;
>> +
>> +	memcpy(slots, old, old_size);
>> +
>> +	hash_init(slots->id_hash);
>> +	kvm_for_each_memslot(memslot, slots)
>> +		hash_add(slots->id_hash, &memslot->id_node, memslot->id);
> 
> What's the perf penalty if the number of memslots gets large?  I ask because the
> lazy rmap allocation is adding multiple calls to kvm_dup_memslots().

I would expect the "move inactive" benchmark to be closest to measuring
the performance of just a memslot array copy operation but the results
suggest that the performance stays within ~10% window from 10 to 509
memslots on the old code (it then climbs 13x for 32k case).

That suggests that something else is dominating this benchmark for these
memslot counts (probably zapping of shadow pages).

At the same time, the tree-based memslots implementation is clearly
faster in this benchmark, even for smaller memslot counts, so apparently
copying of the memslot array has some performance impact, too.

Measuring just kvm_dup_memslots() performance would probably be done
best by benchmarking KVM_MR_FLAGS_ONLY operation - will try to add this
operation to my set of benchmarks and see how it performs with different
memslot counts.

Thanks,
Maciej
