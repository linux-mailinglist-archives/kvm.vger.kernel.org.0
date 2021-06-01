Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAEE6397B31
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 22:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234835AbhFAU0y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 16:26:54 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:35302 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234513AbhFAU0x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 16:26:53 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1loAwf-0008SL-HM; Tue, 01 Jun 2021 22:25:01 +0200
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
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
 <20035aa6e276615b026ea00ee3ec711a3159a70a.1621191552.git.maciej.szmigiero@oracle.com>
 <YK2GjzkWvjBcCFxn@google.com>
Subject: Re: [PATCH v3 6/8] KVM: Keep memslots in tree-based structures
 instead of array-based ones
Message-ID: <6414a791-fa6f-ef19-d321-bc1a45808624@maciej.szmigiero.name>
Date:   Tue, 1 Jun 2021 22:24:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <YK2GjzkWvjBcCFxn@google.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26.05.2021 01:21, Sean Christopherson wrote:
> Overall, I like it!  Didn't see any functional issues, though that comes with a
> disclaimer that functionality was a secondary focus for this pass.
> 
> I have lots of comments, but they're (almost?) all mechanical.
> 
> The most impactful feedback is to store the actual node index in the memslots
> instead of storing whether or not an instance is node0.  This has a cascading
> effect that allows for substantial cleanup, specifically that it obviates the
> motivation for caching the active vs. inactive indices in local variables.  That
> in turn reduces naming collisions, which allows using more generic (but easily
> parsed/read) names.
> 
> I also tweaked/added quite a few comments, mostly as documentation of my own
> (mis)understanding of the code.  Patch attached (hopefully), with another
> disclaimer that it's compile tested only, and only on x86.

Thanks for the review Sean!

I agree that storing the actual node index in the memslot set makes the
code more readable.

Thanks for the suggested patch (which mostly can be integrated as-is into
this commit), however I think that its changes are deep enough for you to
at least be tagged "Co-developed-by:" here.

My remaining comments are below, inline.

Maciej

> On Sun, May 16, 2021, Maciej S. Szmigiero wrote:
>>   arch/arm64/kvm/mmu.c                |   8 +-
>>   arch/powerpc/kvm/book3s_64_mmu_hv.c |   4 +-
>>   arch/powerpc/kvm/book3s_hv.c        |   3 +-
>>   arch/powerpc/kvm/book3s_hv_nested.c |   4 +-
>>   arch/powerpc/kvm/book3s_hv_uvmem.c  |  14 +-
>>   arch/s390/kvm/kvm-s390.c            |  27 +-
>>   arch/s390/kvm/kvm-s390.h            |   7 +-
>>   arch/x86/kvm/mmu/mmu.c              |   4 +-
>>   include/linux/kvm_host.h            | 100 ++---
>>   virt/kvm/kvm_main.c                 | 580 ++++++++++++++--------------
>>   10 files changed, 379 insertions(+), 372 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index c5d1f3c87dbd..2b4ced4f1e55 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -199,13 +199,13 @@ static void stage2_flush_vm(struct kvm *kvm)
>>   {
>>   	struct kvm_memslots *slots;
>>   	struct kvm_memory_slot *memslot;
>> -	int idx;
>> +	int idx, ctr;
> 
> Let's use 'bkt' instead of 'ctr', purely that's what the interval tree uses.  KVM
> itself shouldn't care since it shoudn't be poking into those details anyways.

Will do (BTW I guess you meant 'hash table' not 'interval tree' here).

>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index f59847b6e9b3..a9c5b0df2311 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -29,6 +29,7 @@
>>   #include <linux/nospec.h>
>>   #include <linux/interval_tree.h>
>>   #include <linux/hashtable.h>
>> +#include <linux/rbtree.h>
>>   #include <asm/signal.h>
>>   
>>   #include <linux/kvm.h>
>> @@ -358,8 +359,9 @@ static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
>>   #define KVM_MEM_MAX_NR_PAGES ((1UL << 31) - 1)
>>   
>>   struct kvm_memory_slot {
>> -	struct hlist_node id_node;
>> -	struct interval_tree_node hva_node;
>> +	struct hlist_node id_node[2];
>> +	struct interval_tree_node hva_node[2];
>> +	struct rb_node gfn_node[2];
> 
> This block needs a comment explaining the dual (duelling?) tree system.

Will do.

>>   	gfn_t base_gfn;
>>   	unsigned long npages;
>>   	unsigned long *dirty_bitmap;
>> @@ -454,19 +456,14 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
>>   }
>>   #endif
>>   
>> -/*
>> - * Note:
>> - * memslots are not sorted by id anymore, please use id_to_memslot()
>> - * to get the memslot by its id.
>> - */
>>   struct kvm_memslots {
>>   	u64 generation;
>> +	atomic_long_t lru_slot;
>>   	struct rb_root_cached hva_tree;
>> -	/* The mapping table from slot id to the index in memslots[]. */
>> +	struct rb_root gfn_tree;
>> +	/* The mapping table from slot id to memslot. */
>>   	DECLARE_HASHTABLE(id_hash, 7);
>> -	atomic_t lru_slot;
>> -	int used_slots;
>> -	struct kvm_memory_slot memslots[];
>> +	bool is_idx_0;
> 
> This is where storing an int helps.  I was thinking 'int node_idx'.

Looks sensible.

>>   };
>>   
>>   struct kvm {
>> @@ -478,6 +475,7 @@ struct kvm {
>>   
>>   	struct mutex slots_lock;
>>   	struct mm_struct *mm; /* userspace tied to this vm */
>> +	struct kvm_memslots memslots_all[KVM_ADDRESS_SPACE_NUM][2];
> 
> I think it makes sense to call this '__memslots', to try to convey that it is
> backing for a front end.  'memslots_all' could be misinterpreted as "memslots
> for all address spaces".  A comment is probably warranted, too.

Will add comment here, your patch already renames the variable.

>>   	struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
>>   	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
>>   
>> @@ -617,12 +615,6 @@ static inline int kvm_vcpu_get_idx(struct kvm_vcpu *vcpu)
>>   	return vcpu->vcpu_idx;
>>   }
>>   
>> -#define kvm_for_each_memslot(memslot, slots)				\
>> -	for (memslot = &slots->memslots[0];				\
>> -	     memslot < slots->memslots + slots->used_slots; memslot++)	\
>> -		if (WARN_ON_ONCE(!memslot->npages)) {			\
>> -		} else
>> -
>>   void kvm_vcpu_destroy(struct kvm_vcpu *vcpu);
>>   
>>   void vcpu_load(struct kvm_vcpu *vcpu);
>> @@ -682,6 +674,22 @@ static inline struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu)
>>   	return __kvm_memslots(vcpu->kvm, as_id);
>>   }
>>   
>> +static inline bool kvm_memslots_empty(struct kvm_memslots *slots)
>> +{
>> +	return RB_EMPTY_ROOT(&slots->gfn_tree);
>> +}
>> +
>> +static inline int kvm_memslots_idx(struct kvm_memslots *slots)
>> +{
>> +	return slots->is_idx_0 ? 0 : 1;
>> +}
> 
> This helper can go away.

Your patch already does that.

>> +
>> +#define kvm_for_each_memslot(memslot, ctr, slots)	\
> 
> Use 'bkt' again.

Will do.

>> +	hash_for_each(slots->id_hash, ctr, memslot,	\
>> +		      id_node[kvm_memslots_idx(slots)]) \
> 
> With 'node_idx, this can squeak into a single line:
> 
> 	hash_for_each(slots->id_hash, bkt, memslot, id_node[slots->node_idx]) \

Your patch already does that.

>> +		if (WARN_ON_ONCE(!memslot->npages)) {	\
>> +		} else
>> +
>>   #define kvm_for_each_hva_range_memslot(node, slots, start, last)	     \
>>   	for (node = interval_tree_iter_first(&slots->hva_tree, start, last); \
>>   	     node;							     \
>> @@ -690,9 +698,10 @@ static inline struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu)
>>   static inline
>>   struct kvm_memory_slot *id_to_memslot(struct kvm_memslots *slots, int id)
>>   {
>> +	int idxactive = kvm_memslots_idx(slots);
> 
> Use 'idx'.  Partly for readability, partly because this function doesn't (and
> shouldn't) care whether or not @slots is the active set.

Your patch already does that.

>>   	struct kvm_memory_slot *slot;
>>   
>> -	hash_for_each_possible(slots->id_hash, slot, id_node, id) {
>> +	hash_for_each_possible(slots->id_hash, slot, id_node[idxactive], id) {
>>   		if (slot->id == id)
>>   			return slot;
>>   	}
>> @@ -1102,42 +1111,39 @@ bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args);
>>    * With "approx" set returns the memslot also when the address falls
>>    * in a hole. In that case one of the memslots bordering the hole is
>>    * returned.
>> - *
>> - * IMPORTANT: Slots are sorted from highest GFN to lowest GFN!
>>    */
>>   static inline struct kvm_memory_slot *
>>   search_memslots(struct kvm_memslots *slots, gfn_t gfn, bool approx)
>>   {
>> -	int start = 0, end = slots->used_slots;
>> -	int slot = atomic_read(&slots->lru_slot);
>> -	struct kvm_memory_slot *memslots = slots->memslots;
>> -
>> -	if (unlikely(!slots->used_slots))
>> -		return NULL;
>> -
>> -	if (gfn >= memslots[slot].base_gfn &&
>> -	    gfn < memslots[slot].base_gfn + memslots[slot].npages)
>> -		return &memslots[slot];
>> -
>> -	while (start < end) {
>> -		slot = start + (end - start) / 2;
>> -
>> -		if (gfn >= memslots[slot].base_gfn)
>> -			end = slot;
>> -		else
>> -			start = slot + 1;
>> +	int idxactive = kvm_memslots_idx(slots);
> 
> Same as above, s/idxactive/idx.

Your patch already does that.

>> +	struct kvm_memory_slot *slot;
>> +	struct rb_node *prevnode, *node;
>> +
>> +	slot = (struct kvm_memory_slot *)atomic_long_read(&slots->lru_slot);
>> +	if (slot &&
>> +	    gfn >= slot->base_gfn && gfn < slot->base_gfn + slot->npages)
>> +		return slot;
>> +
>> +	for (prevnode = NULL, node = slots->gfn_tree.rb_node; node; ) {
>> +		prevnode = node;
>> +		slot = container_of(node, struct kvm_memory_slot,
>> +				    gfn_node[idxactive]);
> 
> With 'idx', this can go on a single line.  It runs over by two chars, but the 80
> char limit is a soft limit, and IMO avoiding line breaks for things like this
> improves readability.

Your patch already does that.
    
>> +		if (gfn >= slot->base_gfn) {
>> +			if (gfn < slot->base_gfn + slot->npages) {
>> +				atomic_long_set(&slots->lru_slot,
>> +						(unsigned long)slot);
>> +				return slot;
>> +			}
>> +			node = node->rb_right;
>> +		} else
>> +			node = node->rb_left;
>>   	}
>>   
>> -	if (approx && start >= slots->used_slots)
>> -		return &memslots[slots->used_slots - 1];
>> +	if (approx && prevnode)
>> +		return container_of(prevnode, struct kvm_memory_slot,
>> +				    gfn_node[idxactive]);
> 
> And arguably the same here, though the overrun is a wee bit worse.

Your patch already does that.
    
>>   
>> -	if (start < slots->used_slots && gfn >= memslots[start].base_gfn &&
>> -	    gfn < memslots[start].base_gfn + memslots[start].npages) {
>> -		atomic_set(&slots->lru_slot, start);
>> -		return &memslots[start];
>> -	}
>> -
>> -	return approx ? &memslots[start] : NULL;
>> +	return NULL;
>>   }
>>   
>>   static inline struct kvm_memory_slot *
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index a55309432c9a..189504b27ca6 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -510,15 +510,17 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
>>   	}
>>   
>>   	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
>> +		int idxactive;
> 
> This variable can be avoided entirely be using slots->node_idx directly (my
> favored 'idx' is stolen for SRCU).

Your patch already does that.
    
>>   		struct interval_tree_node *node;
>>   
>>   		slots = __kvm_memslots(kvm, i);
>> +		idxactive = kvm_memslots_idx(slots);
>>   		kvm_for_each_hva_range_memslot(node, slots,
>>   					       range->start, range->end - 1) {
>>   			unsigned long hva_start, hva_end;
>>   
>>   			slot = container_of(node, struct kvm_memory_slot,
>> -					    hva_node);
>> +					    hva_node[idxactive]);
>>   			hva_start = max(range->start, slot->userspace_addr);
>>   			hva_end = min(range->end, slot->userspace_addr +
>>   						  (slot->npages << PAGE_SHIFT));
>> @@ -785,18 +787,12 @@ static int kvm_init_mmu_notifier(struct kvm *kvm)
>>   
>>   #endif /* CONFIG_MMU_NOTIFIER && KVM_ARCH_WANT_MMU_NOTIFIER */
>>   
>> -static struct kvm_memslots *kvm_alloc_memslots(void)
>> +static void kvm_init_memslots(struct kvm_memslots *slots)
>>   {
>> -	struct kvm_memslots *slots;
>> -
>> -	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
>> -	if (!slots)
>> -		return NULL;
>> -
>> +	atomic_long_set(&slots->lru_slot, (unsigned long)NULL);
>>   	slots->hva_tree = RB_ROOT_CACHED;
>> +	slots->gfn_tree = RB_ROOT;
>>   	hash_init(slots->id_hash);
>> -
>> -	return slots;
> 
> With 'node_idx' in the slots, it's easier to open code this in the loop and
> drop kvm_init_memslots().

Your patch already does that.
    
>>   }
>>   
>>   static void kvm_destroy_dirty_bitmap(struct kvm_memory_slot *memslot)
>> @@ -808,27 +804,31 @@ static void kvm_destroy_dirty_bitmap(struct kvm_memory_slot *memslot)
>>   	memslot->dirty_bitmap = NULL;
>>   }
>>   
>> +/* This does not remove the slot from struct kvm_memslots data structures */
>>   static void kvm_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
>>   {
>>   	kvm_destroy_dirty_bitmap(slot);
>>   
>>   	kvm_arch_free_memslot(kvm, slot);
>>   
>> -	slot->flags = 0;
>> -	slot->npages = 0;
>> +	kfree(slot);
>>   }
>>   
>>   static void kvm_free_memslots(struct kvm *kvm, struct kvm_memslots *slots)
>>   {
>> +	int ctr;
>> +	struct hlist_node *idnode;
>>   	struct kvm_memory_slot *memslot;
>>   
>> -	if (!slots)
>> +	/*
>> +	 * Both active and inactive struct kvm_memslots should point to
>> +	 * the same set of memslots, so it's enough to free them once
>> +	 */
> 
> Thumbs up for comments!

Thanks :)

> It would be very helpful to state that which index is> used is completely arbitrary.

Your patch already states that, however it switches the actual freeing
from idx 1 to idx 0.

Even though technically it does not matter I think it just looks better
when the first kvm_free_memslots() call does nothing and the second
invocation actually frees the slot data rather than the first call
freeing the data and the second invocation operating over a structure
with dangling pointers (even if the function isn't actually touching
them).

>> +	if (slots->is_idx_0)
>>   		return;
>>   
>> -	kvm_for_each_memslot(memslot, slots)
>> +	hash_for_each_safe(slots->id_hash, ctr, idnode, memslot, id_node[1])
>>   		kvm_free_memslot(kvm, memslot);
>> -
>> -	kvfree(slots);
>>   }
>>   
>>   static void kvm_destroy_vm_debugfs(struct kvm *kvm)
>> @@ -924,13 +924,14 @@ static struct kvm *kvm_create_vm(unsigned long type)
>>   
>>   	refcount_set(&kvm->users_count, 1);
>>   	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
>> -		struct kvm_memslots *slots = kvm_alloc_memslots();
>> +		kvm_init_memslots(&kvm->memslots_all[i][0]);
>> +		kvm_init_memslots(&kvm->memslots_all[i][1]);
>> +		kvm->memslots_all[i][0].is_idx_0 = true;
>> +		kvm->memslots_all[i][1].is_idx_0 = false;
>>   
>> -		if (!slots)
>> -			goto out_err_no_arch_destroy_vm;
>>   		/* Generations must be different for each address space. */
>> -		slots->generation = i;
>> -		rcu_assign_pointer(kvm->memslots[i], slots);
>> +		kvm->memslots_all[i][0].generation = i;
>> +		rcu_assign_pointer(kvm->memslots[i], &kvm->memslots_all[i][0]);
> 
> Open coding this with node_idx looks like so:
> 
> 		for (j = 0; j < 2; j++) {
> 			slots = &kvm->__memslots[i][j];
> 
> 			atomic_long_set(&slots->lru_slot, (unsigned long)NULL);
> 			slots->hva_tree = RB_ROOT_CACHED;
> 			slots->gfn_tree = RB_ROOT;
> 			hash_init(slots->id_hash);
> 			slots->node_idx = j;
> 
> 			/* Generations must be different for each address space. */
> 			slots->generation = i;
> 		}
> 
> 		rcu_assign_pointer(kvm->memslots[i], &kvm->__memslots[i][0]);

Your patch already does that.

(..)
>> @@ -1351,44 +1148,129 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
>>   	kvm_arch_memslots_updated(kvm, gen);
>>   
>>   	slots->generation = gen;
>> +}
>> +
>> +static void kvm_memslot_gfn_insert(struct rb_root *gfn_tree,
>> +				  struct kvm_memory_slot *slot,
>> +				  int which)
> 
> Pass slots instead of the tree, that way the index doesn't need to passed
> separately.  And similar to previous feedback, s/which/idx.

Your patch already does that.

>> +{
>> +	struct rb_node **cur, *parent;
>> +
>> +	for (cur = &gfn_tree->rb_node, parent = NULL; *cur; ) {
> 
> I think it makes sense to initialize 'parent' outside of loop, both to make the
> loop control flow easier to read, and to make it more obvious that parent _must_
> be initialized in the empty case.

Your patch already does that.

>> +		struct kvm_memory_slot *cslot;
> 
> I'd prefer s/cur/node and s/cslot/tmp.  'cslot' in particular is hard to parse.

Your patch already does that.

>> +		cslot = container_of(*cur, typeof(*cslot), gfn_node[which]);
>> +		parent = *cur;
>> +		if (slot->base_gfn < cslot->base_gfn)
>> +			cur = &(*cur)->rb_left;
>> +		else if (slot->base_gfn > cslot->base_gfn)
>> +			cur = &(*cur)->rb_right;
>> +		else
>> +			BUG();
>> +	}
>>   
>> -	return old_memslots;
>> +	rb_link_node(&slot->gfn_node[which], parent, cur);
>> +	rb_insert_color(&slot->gfn_node[which], gfn_tree);
>>   }
>>   
>>   /*
>> - * Note, at a minimum, the current number of used slots must be allocated, even
>> - * when deleting a memslot, as we need a complete duplicate of the memslots for
>> - * use when invalidating a memslot prior to deleting/moving the memslot.
>> + * Just copies the memslot data.
>> + * Does not copy or touch the embedded nodes, including the ranges at hva_nodes.
>>    */
>> -static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
>> -					     enum kvm_mr_change change)
>> +static void kvm_copy_memslot(struct kvm_memory_slot *dest,
>> +			     struct kvm_memory_slot *src)
>>   {
>> -	struct kvm_memslots *slots;
>> -	size_t old_size, new_size;
>> -	struct kvm_memory_slot *memslot;
>> +	dest->base_gfn = src->base_gfn;
>> +	dest->npages = src->npages;
>> +	dest->dirty_bitmap = src->dirty_bitmap;
>> +	dest->arch = src->arch;
>> +	dest->userspace_addr = src->userspace_addr;
>> +	dest->flags = src->flags;
>> +	dest->id = src->id;
>> +	dest->as_id = src->as_id;
>> +}
>>   
>> -	old_size = sizeof(struct kvm_memslots) +
>> -		   (sizeof(struct kvm_memory_slot) * old->used_slots);
>> +/*
>> + * Initializes the ranges at both hva_nodes from the memslot userspace_addr
>> + * and npages fields.
>> + */
>> +static void kvm_init_memslot_hva_ranges(struct kvm_memory_slot *slot)
>> +{
>> +	slot->hva_node[0].start = slot->hva_node[1].start =
>> +		slot->userspace_addr;
>> +	slot->hva_node[0].last = slot->hva_node[1].last =
>> +		slot->userspace_addr + (slot->npages << PAGE_SHIFT) - 1;
> 
> Fold this into kvm_copy_memslot().  It's always called immediately after, and
> technically the node range does come from the src, e.g. calling this without
> first calling kvm_copy_memslot() doesn't make sense.

Your patch already does that.

>> +}
>>   
>> -	if (change == KVM_MR_CREATE)
>> -		new_size = old_size + sizeof(struct kvm_memory_slot);
>> -	else
>> -		new_size = old_size;
>> +/*
>> + * Replaces the @oldslot with @nslot in the memslot set indicated by
>> + * @slots_idx.
>> + *
>> + * With NULL @oldslot this simply adds the @nslot to the set.
>> + * With NULL @nslot this simply removes the @oldslot from the set.
>> + *
>> + * If @nslot is non-NULL its hva_node[slots_idx] range has to be set
>> + * appropriately.
>> + */
>> +static void kvm_replace_memslot(struct kvm *kvm,
>> +				int as_id, int slots_idx,
> 
> Pass slots itself, then all three of these go away.

Your patch already does that.

>> +				struct kvm_memory_slot *oldslot,
>> +				struct kvm_memory_slot *nslot)
> 
> s/oldslot/old and s/nslot/new, again to make it easier to identify which is what,
> and for consistency.

Your patch already does that.

>> +{
>> +	struct kvm_memslots *slots = &kvm->memslots_all[as_id][slots_idx];
> 
> s/slots_idx/idx for consistency.

Your patch already does that.

>>   
>> -	slots = kvzalloc(new_size, GFP_KERNEL_ACCOUNT);
>> -	if (unlikely(!slots))
>> -		return NULL;
>> +	if (WARN_ON(!oldslot && !nslot))
> 
> This should be moved to kvm_set_memslot() in the form of:
> 
> 	if (change != KVM_MR_CREATE) {
> 		slot = id_to_memslot(active, old->id);
> 		if (WARN_ON_ONCE(!slot))
> 			return -EIO;
> 	}
>
> Adding a WARN that the caller doesn't pass "NULL, NULL" is unnecessary, and
> putting the WARN in this helper obfuscates the one case that warrants a guard.

Your patch already does both of these changes.

>> +		return;
>> +
>> +	if (oldslot) {
>> +		hash_del(&oldslot->id_node[slots_idx]);
>> +		interval_tree_remove(&oldslot->hva_node[slots_idx],
>> +				     &slots->hva_tree);
> 
> Unnecessary newline.

Your patch already removes it.

> 
>> +		atomic_long_cmpxchg(&slots->lru_slot,
>> +				    (unsigned long)oldslot,
>> +				    (unsigned long)nslot);
> 
> Can be:
> 
> 		atomic_long_cmpxchg(&slots->lru_slot,
> 				    (unsigned long)old, (unsigned long)new);

Your patch already does it.

> 
>> +		if (!nslot) {
>> +			rb_erase(&oldslot->gfn_node[slots_idx],
>> +				 &slots->gfn_tree);
> 
> Unnecessary newline.

Your patch already changes this into a single-line
kvm_memslot_gfn_erase() call.

> 
>> +			return;
>> +		}
>> +	}
>>   
>> -	memcpy(slots, old, old_size);
>> +	hash_add(slots->id_hash, &nslot->id_node[slots_idx],
>> +		 nslot->id);
>> +	WARN_ON(PAGE_SHIFT > 0 &&
> 
> Are there actually KVM architectures for which PAGE_SHIFT==0?

Don't think so, it's just future-proofing of the code.

>> +		nslot->hva_node[slots_idx].start >=
>> +		nslot->hva_node[slots_idx].last);
>> +	interval_tree_insert(&nslot->hva_node[slots_idx],
>> +			     &slots->hva_tree);
>>   
>> -	slots->hva_tree = RB_ROOT_CACHED;
>> -	hash_init(slots->id_hash);
>> -	kvm_for_each_memslot(memslot, slots) {
>> -		interval_tree_insert(&memslot->hva_node, &slots->hva_tree);
>> -		hash_add(slots->id_hash, &memslot->id_node, memslot->id);
>> +	/* Shame there is no O(1) interval_tree_replace()... */
>> +	if (oldslot && oldslot->base_gfn == nslot->base_gfn)
>> +		rb_replace_node(&oldslot->gfn_node[slots_idx],
>> +				&nslot->gfn_node[slots_idx],
>> +				&slots->gfn_tree);
> 
> Add wrappers for all the rb-tree mutators.  Partly for consistency, mostly for
> readability.  Having the node index in the memslots helps in this case.  E.g.
> 
> 	/* Shame there is no O(1) interval_tree_replace()... */
> 	if (old && old->base_gfn == new->base_gfn) {
> 		kvm_memslot_gfn_replace(slots, old, new);
> 	} else {
> 		if (old)
> 			kvm_memslot_gfn_erase(slots, old);
> 		kvm_memslot_gfn_insert(slots, new);
> 	}

Your patch already does it.

>> +	else {
>> +		if (oldslot)
>> +			rb_erase(&oldslot->gfn_node[slots_idx],
>> +				 &slots->gfn_tree);
>> +		kvm_memslot_gfn_insert(&slots->gfn_tree,
>> +				       nslot, slots_idx);
> 
> Unnecessary newlines.

Your patch already removes them.

>>   	}
>> +}
>> +
>> +/*
>> + * Copies the @oldslot data into @nslot and uses this slot to replace
>> + * @oldslot in the memslot set indicated by @slots_idx.
>> + */
>> +static void kvm_copy_replace_memslot(struct kvm *kvm,
> 
> I fiddled with this one, and I think it's best to drop this helper in favor of
> open coding the calls to kvm_copy_memslot() and kvm_replace_memslot().  More on
> this below.
> 
>> +				     int as_id, int slots_idx,
>> +				     struct kvm_memory_slot *oldslot,
>> +				     struct kvm_memory_slot *nslot)
>> +{
>> +	kvm_copy_memslot(nslot, oldslot);
>> +	kvm_init_memslot_hva_ranges(nslot);
>>   
>> -	return slots;
>> +	kvm_replace_memslot(kvm, as_id, slots_idx, oldslot, nslot);
>>   }
>>   
>>   static int kvm_set_memslot(struct kvm *kvm,
>> @@ -1397,56 +1279,178 @@ static int kvm_set_memslot(struct kvm *kvm,
>>   			   struct kvm_memory_slot *new, int as_id,
>>   			   enum kvm_mr_change change)
>>   {
>> -	struct kvm_memory_slot *slot;
>> -	struct kvm_memslots *slots;
>> +	struct kvm_memslots *slotsact = __kvm_memslots(kvm, as_id);
>> +	int idxact = kvm_memslots_idx(slotsact);
>> +	int idxina = idxact == 0 ? 1 : 0;
> 
> I strongly prefer using "active" and "inactive" for the memslots, dropping the
> local incidices completely, and using "slot" and "tmp" for the slot.
> 
> "slot" and "tmp" aren't great, but slotsact vs. slotact is really, really hard
> to read.  And more importantly, slotact vs. slotina is misleading because they
> don't always point slots in the active set and inactive set respectively.  That
> detail took me a while to fully grep.

Your patch already does these changes.
My comment on the "active" vs "inactive" slot terminology thing is below.

>> +	struct kvm_memslots *slotsina = &kvm->memslots_all[as_id][idxina];
> 
> To avoid local index variables, this can be the somewhat clever/gross:
> 
> 	struct kvm_memslots *inactive = &kvm->__memslots[as_id][active->node_idx ^ 1];

Or "active->node_idx == 0 ? 1 : 0" to make it more explicit.

>> +	struct kvm_memory_slot *slotina, *slotact;
>>   	int r;
>>   
>> -	slots = kvm_dup_memslots(__kvm_memslots(kvm, as_id), change);
>> -	if (!slots)
>> +	slotina = kzalloc(sizeof(*slotina), GFP_KERNEL_ACCOUNT);
>> +	if (!slotina)
>>   		return -ENOMEM;
>>   
>> +	if (change != KVM_MR_CREATE)
>> +		slotact = id_to_memslot(slotsact, old->id);
> 
> And the WARN, as mentioned above.

Your patch already does this.

>> +
>>   	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
>>   		/*
>> -		 * Note, the INVALID flag needs to be in the appropriate entry
>> -		 * in the freshly allocated memslots, not in @old or @new.
>> +		 * Replace the slot to be deleted or moved in the inactive
>> +		 * memslot set by its copy with KVM_MEMSLOT_INVALID flag set.
> 
> This is where the inactive slot vs. inactive memslot terminology gets really
> confusing.  "inactive memslots" refers precisely which set is not kvm->memslots,
> whereas "inactive slot" might refer to a slot that is in the inactive set, but
> it might also refer to a slot that is currently not in any tree at all.  E.g.

"Inactive slot" is a slot that is never in the active memslot set.
There is one exception to that in the second part of the KVM_MR_CREATE
branch, but that's easily fixable by adding a "swap(slotact, slotina)"
there, just as other branches use (it's a consistency win, too).

The swap could be actually inside kvm_swap_active_memslots() and be
shared between all the branches - more about this later.

Also, KVM_MR_CREATE uses just one slot anyway, so technically it should
be called just a "slot" without any qualifier.

Conversely, an "active slot" is a slot that is in the active memslot set,
with an exception of the second part of the KVM_MR_DELETE branch where the
slot should be called something like a "dead slot".

I have a bit of a mixed felling here: these "slot" and, "tmp" variable
names are even less descriptive ("tmp" in particular sounds totally
generic).

Additionally, the introduction of kvm_activate_memslot() removed "slot"
and "tmp" swapping at memslot sets swap time from the KVM_MR_MOVE,
KVM_MR_FLAGS_ONLY and KVM_MR_DELETE branches while keeping it in the
code block that adds a temporary KVM_MEMSLOT_INVALID slot and in the
error cleanup code.

In terms of "slotact" and "slotina" the KVM_MR_CREATE case can be
trivially fixed, the KVM_MR_DELETE branch can make use either of a
dedicated "slotdead" variable, or a comment explaining what "slotina"
points to there.

At the same time a comment can be added near these variables describing
their semantics so they are clear to future people analyzing the code.

> 
> 		/*
> 		 * Mark the current slot INVALID.  This must be done on the tmp
> 		 * slot to avoid modifying the current slot in the active tree.
> 		 */

Your patch already does this comment change.

>>   		 */
>> -		slot = id_to_memslot(slots, old->id);
>> -		slot->flags |= KVM_MEMSLOT_INVALID;
>> +		kvm_copy_replace_memslot(kvm, as_id, idxina, slotact, slotina);
>> +		slotina->flags |= KVM_MEMSLOT_INVALID;
> 
> This is where I'd prefer to open code the copy and replace.  Functionally it works,
> but setting the INVALID flag _after_ replacing the slot is not intuitive.  E.g.
> this sequencing helps the reader understand that it makes a copy
> 
> 		kvm_copy_memslot(tmp, slot);
> 		tmp->flags |= KVM_MEMSLOT_INVALID;
> 		kvm_replace_memslot(inactive, slot, tmp);
> 

Your patch already does this change.

>>   		/*
>> -		 * We can re-use the old memslots, the only difference from the
>> -		 * newly installed memslots is the invalid flag, which will get
>> -		 * dropped by update_memslots anyway.  We'll also revert to the
>> -		 * old memslots if preparing the new memory region fails.
>> +		 * Swap the active <-> inactive memslot set.
>> +		 * Now the active memslot set still contains the memslot to be
>> +		 * deleted or moved, but with the KVM_MEMSLOT_INVALID flag set.
>>   		 */
>> -		slots = install_new_memslots(kvm, as_id, slots);
>> +		swap_memslots(kvm, as_id);
> 
> kvm_swap_active_memslots() would be preferable, without context it's not clear
> what's being swapped.
> 
> To dedup code, and hopefully improve readability, I think it makes sense to do
> the swap() of the memslots in kvm_swap_active_memslots().  With the indices gone,
> the number of swap() calls goes down dramatically, e.g.
> 
> 
> 		/*
> 		 * Activate the slot that is now marked INVALID, but don't
> 		 * propagate the slot to the now inactive slots.  The slot is
> 		 * either going to be deleted or recreated as a new slot.
> 		*/
> 		kvm_swap_active_memslots(kvm, as_id, &active, &inactive);
> 
> 		/* The temporary and current slot have swapped roles. */
> 		swap(tmp, slot);

Your patch already does this change.

>> +		swap(idxact, idxina);
>> +		swap(slotsina, slotsact);
>> +		swap(slotact, slotina);
>>   
>> -		/* From this point no new shadow pages pointing to a deleted,
>> +		/*
>> +		 * From this point no new shadow pages pointing to a deleted,
>>   		 * or moved, memslot will be created.
>>   		 *
>>   		 * validation of sp->gfn happens in:
>>   		 *	- gfn_to_hva (kvm_read_guest, gfn_to_pfn)
>>   		 *	- kvm_is_visible_gfn (mmu_check_root)
>>   		 */
>> -		kvm_arch_flush_shadow_memslot(kvm, slot);
>> +		kvm_arch_flush_shadow_memslot(kvm, slotact);
>>   	}
>>   
>>   	r = kvm_arch_prepare_memory_region(kvm, new, mem, change);
>>   	if (r)
>>   		goto out_slots;
> 
> Normally I like avoiding code churn, but in this case I think it makes sense to
> avoid the goto.  Even after the below if-else-elif block is trimmed down, the
> error handling that is specific to the above DELETE|MOVE ends up landing too far
> away from the code that it is reverting.  E.g.
> 
> 	r = kvm_arch_prepare_memory_region(kvm, new, mem, change);
> 	if (r) {
> 		if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
> 			/*
> 			 * Revert the above INVALID change.  No modifications
> 			 * required since the original slot was preserved in
> 			 * the inactive slots.
> 			 */
> 			kvm_swap_active_memslots(kvm, as_id, &active, &inactive);
> 			swap(tmp, slot);
> 		}
> 		kfree(tmp);
> 		return r;
> 	}
>

No problem, however the error handler code above needs to also re-add
the original memslot to the second memslot set, as the original error
handler previously located at the function end did:
> swap_memslots(kvm, as_id);
> swap(idxact, idxina);
> swap(slotsina, slotsact);
> swap(slotact, slotina);
> 
> kvm_replace_memslot(kvm, as_id, idxina, slotina, slotact);


>> -	update_memslots(slots, new, change);
>> -	slots = install_new_memslots(kvm, as_id, slots);
>> +	if (change == KVM_MR_MOVE) {
>> +		/*
>> +		 * Since we are going to be changing the memslot gfn we need to
> 
> Try to use imperative mode and avoid I/we/us/etc....  It requires creative
> wording in some cases, but overall it does help avoid ambiguity (though "we" is
> fairly obvious in this case).

Your patch already rewrites this comment (will have this on mind for the
future comments).

> 
>> +		 * remove it from the gfn tree so it can be re-added there with
>> +		 * the updated gfn.
>> +		 */
>> +		rb_erase(&slotina->gfn_node[idxina],
>> +			 &slotsina->gfn_tree);
> 
> Unnecessary newline.

Your patch already removes it.

>> +
>> +		slotina->base_gfn = new->base_gfn;
>> +		slotina->flags = new->flags;
>> +		slotina->dirty_bitmap = new->dirty_bitmap;
>> +		/* kvm_arch_prepare_memory_region() might have modified arch */
>> +		slotina->arch = new->arch;
>> +
>> +		/* Re-add to the gfn tree with the updated gfn */
>> +		kvm_memslot_gfn_insert(&slotsina->gfn_tree,
>> +				       slotina, idxina);
> 
> Again, newline.

Your patch already removes it.

>> +
>> +		/*
>> +		 * Swap the active <-> inactive memslot set.
>> +		 * Now the active memslot set contains the new, final memslot.
>> +		 */
>> +		swap_memslots(kvm, as_id);
>> +		swap(idxact, idxina);
>> +		swap(slotsina, slotsact);
>> +		swap(slotact, slotina);
>> +
>> +		/*
>> +		 * Replace the temporary KVM_MEMSLOT_INVALID slot with the
>> +		 * new, final memslot in the inactive memslot set and
>> +		 * free the temporary memslot.
>> +		 */
>> +		kvm_replace_memslot(kvm, as_id, idxina, slotina, slotact);
>> +		kfree(slotina);
> 
> Adding a wrapper for the trifecta of swap + replace + kfree() cuts down on the
> boilerplate tremendously, and sidesteps having to swap() "slot" and "tmp" for
> these flows.   E.g. this can become:
> 
> 		/*
> 		 * The memslot's gfn is changing, remove it from the inactive
> 		 * tree, it will be re-added with its updated gfn.  Because its
> 		 * range is changing, an in-place replace is not possible.
> 		 */
> 		kvm_memslot_gfn_erase(inactive, tmp);
> 
> 		tmp->base_gfn = new->base_gfn;
> 		tmp->flags = new->flags;
> 		tmp->dirty_bitmap = new->dirty_bitmap;
> 		/* kvm_arch_prepare_memory_region() might have modified arch */
> 		tmp->arch = new->arch;
> 
> 		/* Re-add to the gfn tree with the updated gfn */
> 		kvm_memslot_gfn_insert(inactive, tmp);
> 
> 		/* Replace the current INVALID slot with the updated memslot. */
> 		kvm_activate_memslot(kvm, as_id, &active, &inactive, slot, tmp);
> 
> by adding:
> 
> static void kvm_activate_memslot(struct kvm *kvm, int as_id,
> 				 struct kvm_memslots **active,
> 				 struct kvm_memslots **inactive,
> 				 struct kvm_memory_slot *old,
> 				 struct kvm_memory_slot *new)
> {
> 	/*
> 	 * Swap the active <-> inactive memslots.  Note, this also swaps
> 	 * the active and inactive pointers themselves.
> 	 */
> 	kvm_swap_active_memslots(kvm, as_id, active, inactive);
> 
> 	/* Propagate the new memslot to the now inactive memslots. */
> 	kvm_replace_memslot(*inactive, old, new);
> 
> 	/* And free the old slot. */
> 	if (old)
> 		kfree(old);
> }

Generally, I agree, but as I have written above, I think it would be
good to assign some semantics to slot variables (however they are called).
Your refactoring actually helps with that, since then there will be only
a single place where both memslot sets and memslot pointers are swapped:
in kvm_swap_active_memslots().

I also think kvm_activate_memslot() would benefit from a good comment
describing what it actually does.

BTW, (k)free() can be safely called with a NULL pointer.

>> +	} else if (change == KVM_MR_FLAGS_ONLY) {
>> +		/*
>> +		 * Almost like the move case above, but we don't use a temporary
>> +		 * KVM_MEMSLOT_INVALID slot.
> 
> Let's use INVALID, it should be obvious to readers that make it his far :-)

All right :)
Your patch already does a similar change, so I guess it has the final
proposed wording.

>> +		 * Instead, we simply replace the old memslot with a new, updated
>> +		 * copy in both memslot sets.
>> +		 *
>> +		 * Since we aren't going to be changing the memslot gfn we can
>> +		 * simply use kvm_copy_replace_memslot(), which will use
>> +		 * rb_replace_node() to switch the memslot node in the gfn tree
>> +		 * instead of removing the old one and inserting the new one
>> +		 * as two separate operations.
>> +		 * It's a performance win since node replacement is a single
>> +		 * O(1) operation as opposed to two O(log(n)) operations for
>> +		 * slot removal and then re-insertion.
>> +		 */
>> +		kvm_copy_replace_memslot(kvm, as_id, idxina, slotact, slotina);
>> +		slotina->flags = new->flags;
>> +		slotina->dirty_bitmap = new->dirty_bitmap;
>> +		/* kvm_arch_prepare_memory_region() might have modified arch */
>> +		slotina->arch = new->arch;
>> +
>> +		/* Swap the active <-> inactive memslot set. */
>> +		swap_memslots(kvm, as_id);
>> +		swap(idxact, idxina);
>> +		swap(slotsina, slotsact);
>> +		swap(slotact, slotina);
>> +
>> +		/*
>> +		 * Replace the old memslot in the other memslot set and
>> +		 * then finally free it.
>> +		 */
>> +		kvm_replace_memslot(kvm, as_id, idxina, slotina, slotact);
>> +		kfree(slotina);
>> +	} else if (change == KVM_MR_CREATE) {
>> +		/*
>> +		 * Add the new memslot to the current inactive set as a copy
>> +		 * of the provided new memslot data.
>> +		 */
>> +		kvm_copy_memslot(slotina, new);
>> +		kvm_init_memslot_hva_ranges(slotina);
>> +
>> +		kvm_replace_memslot(kvm, as_id, idxina, NULL, slotina);
>> +
>> +		/* Swap the active <-> inactive memslot set. */
>> +		swap_memslots(kvm, as_id);
>> +		swap(idxact, idxina);
>> +		swap(slotsina, slotsact);
>> +
>> +		/* Now add it also to the other memslot set */
>> +		kvm_replace_memslot(kvm, as_id, idxina, NULL, slotina);
>> +	} else if (change == KVM_MR_DELETE) {
>> +		/*
>> +		 * Remove the old memslot from the current inactive set
>> +		 * (the other, active set contains the temporary
>> +		 * KVM_MEMSLOT_INVALID slot)
>> +		 */
>> +		kvm_replace_memslot(kvm, as_id, idxina, slotina, NULL);
>> +
>> +		/* Swap the active <-> inactive memslot set. */
>> +		swap_memslots(kvm, as_id);
>> +		swap(idxact, idxina);
>> +		swap(slotsina, slotsact);
>> +		swap(slotact, slotina);
>> +
>> +		/* Remove the temporary KVM_MEMSLOT_INVALID slot and free it. */
>> +		kvm_replace_memslot(kvm, as_id, idxina, slotina, NULL);
>> +		kfree(slotina);
>> +		/* slotact will be freed by kvm_free_memslot() */
> 
> I think this comment can go away in favor of documenting the kvm_free_memslot()
> call down below.  With all of the aforementioned changes:
> 
> 		/*
> 		 * Remove the old memslot (in the inactive memslots) and activate
> 		 * the NULL slot.
> 		*/
> 		kvm_replace_memslot(inactive, tmp, NULL);
> 		kvm_activate_memslot(kvm, as_id, &active, &inactive, slot, NULL);

Your patch already does this change, however I will slightly change the
comment to say something like:
> Remove the old memslot (in the inactive memslots) by passing NULL as the new slot
since there isn't really anything like a NULL memslot.

>> +	} else
>> +		BUG();
>>   
>>   	kvm_arch_commit_memory_region(kvm, mem, old, new, change);
>>   
>> -	kvfree(slots);
>> +	if (change == KVM_MR_DELETE)
>> +		kvm_free_memslot(kvm, slotact);
>> +
>>   	return 0;
