Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17F14352DA
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 20:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhJTSor (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 14:44:47 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:40950 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231271AbhJTSoq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 14:44:46 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1mdGXl-0002gu-8u; Wed, 20 Oct 2021 20:42:29 +0200
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
 <555f58fdaec120aa7a6f6fbad06cca796a8c9168.1632171479.git.maciej.szmigiero@oracle.com>
 <YW9mKTRBEABjGPp7@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH v5 08/13] KVM: Resolve memslot ID via a hash table instead
 of via a static array
Message-ID: <1729cda2-83f0-ed03-c6b4-4418de80f933@maciej.szmigiero.name>
Date:   Wed, 20 Oct 2021 20:42:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YW9mKTRBEABjGPp7@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20.10.2021 02:43, Sean Christopherson wrote:
> On Mon, Sep 20, 2021, Maciej S. Szmigiero wrote:
>> ---
>>   include/linux/kvm_host.h | 16 +++++------
>>   virt/kvm/kvm_main.c      | 61 +++++++++++++++++++++++++++++++---------
>>   2 files changed, 55 insertions(+), 22 deletions(-)
>>
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index 8fd9644f40b2..d2acc00a6472 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -29,6 +29,7 @@
>>   #include <linux/refcount.h>
>>   #include <linux/nospec.h>
>>   #include <linux/notifier.h>
>> +#include <linux/hashtable.h>
>>   #include <asm/signal.h>
>>   
>>   #include <linux/kvm.h>
>> @@ -426,6 +427,7 @@ static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
>>   #define KVM_MEM_MAX_NR_PAGES ((1UL << 31) - 1)
>>   
>>   struct kvm_memory_slot {
>> +	struct hlist_node id_node;
>>   	gfn_t base_gfn;
>>   	unsigned long npages;
>>   	unsigned long *dirty_bitmap;
>> @@ -528,7 +530,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
>>   struct kvm_memslots {
>>   	u64 generation;
>>   	/* The mapping table from slot id to the index in memslots[]. */
>> -	short id_to_index[KVM_MEM_SLOTS_NUM];
>> +	DECLARE_HASHTABLE(id_hash, 7);
> 
> Can you add a comment explaining the rationale for size "7"?  Not necessarily the
> justification in choosing "7", more so the tradeoffs between performance, memory,
> etc... so that all your work/investigation isn't lost and doesn't have to be repeated
> if someone wants to tweak this in the future.

Will add such comment.

>>   	atomic_t last_used_slot;
>>   	int used_slots;
>>   	struct kvm_memory_slot memslots[];
>> @@ -795,16 +797,14 @@ static inline struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu)
>>   static inline
>>   struct kvm_memory_slot *id_to_memslot(struct kvm_memslots *slots, int id)
>>   {
>> -	int index = slots->id_to_index[id];
>>   	struct kvm_memory_slot *slot;
>>   
>> -	if (index < 0)
>> -		return NULL;
>> -
>> -	slot = &slots->memslots[index];
>> +	hash_for_each_possible(slots->id_hash, slot, id_node, id) {
>> +		if (slot->id == id)
>> +			return slot;
> 
> Hmm, related to the hash, it might be worth adding a stat here to count collisions.
> Might be more pain than it's worth though since we don't have @kvm.

It's a good idea if it turns out that it's worth optimizing the code
further (by, for example, introducing a self-resizing hash table, which
would bring a significant increase in complexity for rather uncertain
gains).

>> @@ -1274,30 +1275,46 @@ static inline int kvm_memslot_insert_back(struct kvm_memslots *slots)
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
> 
> My comment from v3 about the danger of "mmemslot" still stands.  FWIW, I dislike
> "mslots" as well, but that predates me, and all of this will go away in the end :-)
>
> On Wed, May 19, 2021 at 3:31 PM Sean Christopherson <seanjc@google.com> wrote:
>> On Sun, May 16, 2021, Maciej S. Szmigiero wrote:
>>>        struct kvm_memory_slot *mslots = slots->memslots;
>>> +     struct kvm_memory_slot *dmemslot = id_to_memslot(slots, memslot->id);
>>
>> I vote to call these local vars "old", or something along those lines.  dmemslot
>> isn't too bad, but mmemslot in the helpers below is far too similar to memslot,
>> and using the wrong will cause nasty explosions.
> 

Will rename "mmemslot" to "oldslot" in kvm_memslot_move_backward(), too.
  
>>   	int i;
>>   
>> -	if (slots->id_to_index[memslot->id] == -1 || !slots->used_slots)
>> +	if (!mmemslot || !slots->used_slots)
>>   		return -1;
>>   
>> +	/*
>> +	 * The loop below will (possibly) overwrite the target memslot with
>> +	 * data of the next memslot, or a similar loop in
>> +	 * kvm_memslot_move_forward() will overwrite it with data of the
>> +	 * previous memslot.
>> +	 * Then update_memslots() will unconditionally overwrite and re-add
>> +	 * it to the hash table.
>> +	 * That's why the memslot has to be first removed from the hash table
>> +	 * here.
>> +	 */
> 
> Is this reword accurate?
> 
> 	/*
> 	 * Delete the slot from the hash table before sorting the remaining
> 	 * slots, the slot's data may be overwritten when copying slots as part
> 	 * of the sorting proccess.  update_memslots() will unconditionally
> 	 * rewrite the entire slot and re-add it to the hash table.
> 	 */

It's accurate, will replace the comment with the proposed one.

>> @@ -1369,6 +1391,9 @@ static inline int kvm_memslot_move_forward(struct kvm_memslots *slots,
>>    * most likely to be referenced, sorting it to the front of the array was
>>    * advantageous.  The current binary search starts from the middle of the array
>>    * and uses an LRU pointer to improve performance for all memslots and GFNs.
>> + *
>> + * @memslot is a detached struct, not a part of the current or new memslot
>> + * array.
>>    */
>>   static void update_memslots(struct kvm_memslots *slots,
>>   			    struct kvm_memory_slot *memslot,
>> @@ -1393,7 +1418,8 @@ static void update_memslots(struct kvm_memslots *slots,
>>   		 * its index accordingly.
>>   		 */
>>   		slots->memslots[i] = *memslot;
>> -		slots->id_to_index[memslot->id] = i;
>> +		hash_add(slots->id_hash, &slots->memslots[i].id_node,
>> +			 memslot->id);
> 
> Let this poke out past 80 chars, i.e. drop the newline.

Will do.

Thanks,
Maciej
