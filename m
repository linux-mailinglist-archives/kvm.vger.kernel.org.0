Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3C4390CED
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 01:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbhEYXXa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 19:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbhEYXX1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 May 2021 19:23:27 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F988C061756
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 16:21:57 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id v13-20020a17090abb8db029015f9f7d7290so2636715pjr.0
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 16:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=x1vMXwpW5skr/9OKzZ2sftcZPsyTPnQHhwyzkk4rGjM=;
        b=oPo4Phq/mBJQ1V3RXpyE7n8FVeN7cj7kFsGS9hkAVnBot6JD2IcA6pv/LMNWz7vq0b
         aiIUdKGKbTNNWizY3Q4IT0MICesm13tmgbMv6uM67yc900Hvu3fMyNWUGVt5GmGkQydN
         2dl1TBPOUG29oDVzdmRbyBxxVOVhefN8W9YL3IgBxHohmu7Rt8ujQQisgewBH+DJV6Zy
         68hXkmdL/vs+fNjXJ7aOrxmEk7jb4w+7nj9BUcigvAmZCESOpUQzXDE/iOLDGIsP+VTa
         qfRUdtBinlQfX0IxGmKqBvXTsLZOCkaCVHdVhsARxnjlukKuAzYt7VvIqQMJEqZFmWJs
         vHZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=x1vMXwpW5skr/9OKzZ2sftcZPsyTPnQHhwyzkk4rGjM=;
        b=d1mSpdHxCeFufVHKIDD02zsumThIOI+e6qRhHSc1vrDlBBBi+pF13iJUkr5lbVGsQt
         2VjkeodmFRo0TlwZ6a6eBZ5WZniSWyEaq5gyuuUtO55yZ2VwyeqrlwRlece6rNBZpr4Z
         SPatVGphsyUwyZFlp/Uk/RfxclqTBJJVIKOghCJvI7Gg1S6zAuQz5PBv/MCjPLgKZ+uN
         8ymMa3QfeZISgrdXQdZX4+APhv0Z3NQaeEi1x9wqQTj8Yd8ehHiVXIgKW2Nspn9yNE52
         0Pn4/EC0kCgDd1q88Phre7imkzB3/kl18vcJ3dsmkLU8HDpY5Jbye8BMHuS3aqYKEfAY
         advA==
X-Gm-Message-State: AOAM5312AkCiVXQjjXXaEH6lnnAvmf9SE37nGLR+d/hegu/vDX2YAsQL
        A54XeImcqBTFMCJ6/T0oJ/0KHg==
X-Google-Smtp-Source: ABdhPJzmO3txEypcGsBglGttaG0jJN0Ypw+9/zgiGLU+OpQvVZQCYZPMyh+9ZfHzIzh3OxdyHBwPyA==
X-Received: by 2002:a17:902:8341:b029:fa:2aef:7e3c with SMTP id z1-20020a1709028341b02900fa2aef7e3cmr12758658pln.9.1621984915812;
        Tue, 25 May 2021 16:21:55 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id 6sm14562882pfx.117.2021.05.25.16.21.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 16:21:55 -0700 (PDT)
Date:   Tue, 25 May 2021 23:21:51 +0000
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
Subject: Re: [PATCH v3 6/8] KVM: Keep memslots in tree-based structures
 instead of array-based ones
Message-ID: <YK2GjzkWvjBcCFxn@google.com>
References: <cover.1621191549.git.maciej.szmigiero@oracle.com>
 <20035aa6e276615b026ea00ee3ec711a3159a70a.1621191552.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3zAiiMgFZmQFHLbv"
Content-Disposition: inline
In-Reply-To: <20035aa6e276615b026ea00ee3ec711a3159a70a.1621191552.git.maciej.szmigiero@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--3zAiiMgFZmQFHLbv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Overall, I like it!  Didn't see any functional issues, though that comes with a
disclaimer that functionality was a secondary focus for this pass.

I have lots of comments, but they're (almost?) all mechanical.

The most impactful feedback is to store the actual node index in the memslots
instead of storing whether or not an instance is node0.  This has a cascading
effect that allows for substantial cleanup, specifically that it obviates the
motivation for caching the active vs. inactive indices in local variables.  That
in turn reduces naming collisions, which allows using more generic (but easily
parsed/read) names.

I also tweaked/added quite a few comments, mostly as documentation of my own
(mis)understanding of the code.  Patch attached (hopefully), with another
disclaimer that it's compile tested only, and only on x86.

On Sun, May 16, 2021, Maciej S. Szmigiero wrote:
>  arch/arm64/kvm/mmu.c                |   8 +-
>  arch/powerpc/kvm/book3s_64_mmu_hv.c |   4 +-
>  arch/powerpc/kvm/book3s_hv.c        |   3 +-
>  arch/powerpc/kvm/book3s_hv_nested.c |   4 +-
>  arch/powerpc/kvm/book3s_hv_uvmem.c  |  14 +-
>  arch/s390/kvm/kvm-s390.c            |  27 +-
>  arch/s390/kvm/kvm-s390.h            |   7 +-
>  arch/x86/kvm/mmu/mmu.c              |   4 +-
>  include/linux/kvm_host.h            | 100 ++---
>  virt/kvm/kvm_main.c                 | 580 ++++++++++++++--------------
>  10 files changed, 379 insertions(+), 372 deletions(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index c5d1f3c87dbd..2b4ced4f1e55 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -199,13 +199,13 @@ static void stage2_flush_vm(struct kvm *kvm)
>  {
>  	struct kvm_memslots *slots;
>  	struct kvm_memory_slot *memslot;
> -	int idx;
> +	int idx, ctr;

Let's use 'bkt' instead of 'ctr', purely that's what the interval tree uses.  KVM
itself shouldn't care since it shoudn't be poking into those details anyways.

>  
>  	idx = srcu_read_lock(&kvm->srcu);
>  	spin_lock(&kvm->mmu_lock);
>  
>  	slots = kvm_memslots(kvm);
> -	kvm_for_each_memslot(memslot, slots)
> +	kvm_for_each_memslot(memslot, ctr, slots)
>  		stage2_flush_memslot(kvm, memslot);
>  
>  	spin_unlock(&kvm->mmu_lock);

...

> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index f59847b6e9b3..a9c5b0df2311 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -29,6 +29,7 @@
>  #include <linux/nospec.h>
>  #include <linux/interval_tree.h>
>  #include <linux/hashtable.h>
> +#include <linux/rbtree.h>
>  #include <asm/signal.h>
>  
>  #include <linux/kvm.h>
> @@ -358,8 +359,9 @@ static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
>  #define KVM_MEM_MAX_NR_PAGES ((1UL << 31) - 1)
>  
>  struct kvm_memory_slot {
> -	struct hlist_node id_node;
> -	struct interval_tree_node hva_node;
> +	struct hlist_node id_node[2];
> +	struct interval_tree_node hva_node[2];
> +	struct rb_node gfn_node[2];

This block needs a comment explaining the dual (duelling?) tree system.

>  	gfn_t base_gfn;
>  	unsigned long npages;
>  	unsigned long *dirty_bitmap;
> @@ -454,19 +456,14 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
>  }
>  #endif
>  
> -/*
> - * Note:
> - * memslots are not sorted by id anymore, please use id_to_memslot()
> - * to get the memslot by its id.
> - */
>  struct kvm_memslots {
>  	u64 generation;
> +	atomic_long_t lru_slot;
>  	struct rb_root_cached hva_tree;
> -	/* The mapping table from slot id to the index in memslots[]. */
> +	struct rb_root gfn_tree;
> +	/* The mapping table from slot id to memslot. */
>  	DECLARE_HASHTABLE(id_hash, 7);
> -	atomic_t lru_slot;
> -	int used_slots;
> -	struct kvm_memory_slot memslots[];
> +	bool is_idx_0;

This is where storing an int helps.  I was thinking 'int node_idx'.

>  };
>  
>  struct kvm {
> @@ -478,6 +475,7 @@ struct kvm {
>  
>  	struct mutex slots_lock;
>  	struct mm_struct *mm; /* userspace tied to this vm */
> +	struct kvm_memslots memslots_all[KVM_ADDRESS_SPACE_NUM][2];

I think it makes sense to call this '__memslots', to try to convey that it is
backing for a front end.  'memslots_all' could be misinterpreted as "memslots
for all address spaces".  A comment is probably warranted, too.

>  	struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
>  	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
>  
> @@ -617,12 +615,6 @@ static inline int kvm_vcpu_get_idx(struct kvm_vcpu *vcpu)
>  	return vcpu->vcpu_idx;
>  }
>  
> -#define kvm_for_each_memslot(memslot, slots)				\
> -	for (memslot = &slots->memslots[0];				\
> -	     memslot < slots->memslots + slots->used_slots; memslot++)	\
> -		if (WARN_ON_ONCE(!memslot->npages)) {			\
> -		} else
> -
>  void kvm_vcpu_destroy(struct kvm_vcpu *vcpu);
>  
>  void vcpu_load(struct kvm_vcpu *vcpu);
> @@ -682,6 +674,22 @@ static inline struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu)
>  	return __kvm_memslots(vcpu->kvm, as_id);
>  }
>  
> +static inline bool kvm_memslots_empty(struct kvm_memslots *slots)
> +{
> +	return RB_EMPTY_ROOT(&slots->gfn_tree);
> +}
> +
> +static inline int kvm_memslots_idx(struct kvm_memslots *slots)
> +{
> +	return slots->is_idx_0 ? 0 : 1;
> +}

This helper can go away.

> +
> +#define kvm_for_each_memslot(memslot, ctr, slots)	\

Use 'bkt' again.

> +	hash_for_each(slots->id_hash, ctr, memslot,	\
> +		      id_node[kvm_memslots_idx(slots)]) \

With 'node_idx, this can squeak into a single line:

	hash_for_each(slots->id_hash, bkt, memslot, id_node[slots->node_idx]) \

> +		if (WARN_ON_ONCE(!memslot->npages)) {	\
> +		} else
> +
>  #define kvm_for_each_hva_range_memslot(node, slots, start, last)	     \
>  	for (node = interval_tree_iter_first(&slots->hva_tree, start, last); \
>  	     node;							     \
> @@ -690,9 +698,10 @@ static inline struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu)
>  static inline
>  struct kvm_memory_slot *id_to_memslot(struct kvm_memslots *slots, int id)
>  {
> +	int idxactive = kvm_memslots_idx(slots);

Use 'idx'.  Partly for readability, partly because this function doesn't (and
shouldn't) care whether or not @slots is the active set.

>  	struct kvm_memory_slot *slot;
>  
> -	hash_for_each_possible(slots->id_hash, slot, id_node, id) {
> +	hash_for_each_possible(slots->id_hash, slot, id_node[idxactive], id) {
>  		if (slot->id == id)
>  			return slot;
>  	}
> @@ -1102,42 +1111,39 @@ bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args);
>   * With "approx" set returns the memslot also when the address falls
>   * in a hole. In that case one of the memslots bordering the hole is
>   * returned.
> - *
> - * IMPORTANT: Slots are sorted from highest GFN to lowest GFN!
>   */
>  static inline struct kvm_memory_slot *
>  search_memslots(struct kvm_memslots *slots, gfn_t gfn, bool approx)
>  {
> -	int start = 0, end = slots->used_slots;
> -	int slot = atomic_read(&slots->lru_slot);
> -	struct kvm_memory_slot *memslots = slots->memslots;
> -
> -	if (unlikely(!slots->used_slots))
> -		return NULL;
> -
> -	if (gfn >= memslots[slot].base_gfn &&
> -	    gfn < memslots[slot].base_gfn + memslots[slot].npages)
> -		return &memslots[slot];
> -
> -	while (start < end) {
> -		slot = start + (end - start) / 2;
> -
> -		if (gfn >= memslots[slot].base_gfn)
> -			end = slot;
> -		else
> -			start = slot + 1;
> +	int idxactive = kvm_memslots_idx(slots);

Same as above, s/idxactive/idx.

> +	struct kvm_memory_slot *slot;
> +	struct rb_node *prevnode, *node;
> +
> +	slot = (struct kvm_memory_slot *)atomic_long_read(&slots->lru_slot);
> +	if (slot &&
> +	    gfn >= slot->base_gfn && gfn < slot->base_gfn + slot->npages)
> +		return slot;
> +
> +	for (prevnode = NULL, node = slots->gfn_tree.rb_node; node; ) {
> +		prevnode = node;
> +		slot = container_of(node, struct kvm_memory_slot,
> +				    gfn_node[idxactive]);

With 'idx', this can go on a single line.  It runs over by two chars, but the 80
char limit is a soft limit, and IMO avoiding line breaks for things like this
improves readability.

> +		if (gfn >= slot->base_gfn) {
> +			if (gfn < slot->base_gfn + slot->npages) {
> +				atomic_long_set(&slots->lru_slot,
> +						(unsigned long)slot);
> +				return slot;
> +			}
> +			node = node->rb_right;
> +		} else
> +			node = node->rb_left;
>  	}
>  
> -	if (approx && start >= slots->used_slots)
> -		return &memslots[slots->used_slots - 1];
> +	if (approx && prevnode)
> +		return container_of(prevnode, struct kvm_memory_slot,
> +				    gfn_node[idxactive]);

And arguably the same here, though the overrun is a wee bit worse.

>  
> -	if (start < slots->used_slots && gfn >= memslots[start].base_gfn &&
> -	    gfn < memslots[start].base_gfn + memslots[start].npages) {
> -		atomic_set(&slots->lru_slot, start);
> -		return &memslots[start];
> -	}
> -
> -	return approx ? &memslots[start] : NULL;
> +	return NULL;
>  }
>  
>  static inline struct kvm_memory_slot *
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index a55309432c9a..189504b27ca6 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -510,15 +510,17 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
>  	}
>  
>  	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> +		int idxactive;

This variable can be avoided entirely be using slots->node_idx directly (my
favored 'idx' is stolen for SRCU).

>  		struct interval_tree_node *node;
>  
>  		slots = __kvm_memslots(kvm, i);
> +		idxactive = kvm_memslots_idx(slots);
>  		kvm_for_each_hva_range_memslot(node, slots,
>  					       range->start, range->end - 1) {
>  			unsigned long hva_start, hva_end;
>  
>  			slot = container_of(node, struct kvm_memory_slot,
> -					    hva_node);
> +					    hva_node[idxactive]);
>  			hva_start = max(range->start, slot->userspace_addr);
>  			hva_end = min(range->end, slot->userspace_addr +
>  						  (slot->npages << PAGE_SHIFT));
> @@ -785,18 +787,12 @@ static int kvm_init_mmu_notifier(struct kvm *kvm)
>  
>  #endif /* CONFIG_MMU_NOTIFIER && KVM_ARCH_WANT_MMU_NOTIFIER */
>  
> -static struct kvm_memslots *kvm_alloc_memslots(void)
> +static void kvm_init_memslots(struct kvm_memslots *slots)
>  {
> -	struct kvm_memslots *slots;
> -
> -	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
> -	if (!slots)
> -		return NULL;
> -
> +	atomic_long_set(&slots->lru_slot, (unsigned long)NULL);
>  	slots->hva_tree = RB_ROOT_CACHED;
> +	slots->gfn_tree = RB_ROOT;
>  	hash_init(slots->id_hash);
> -
> -	return slots;

With 'node_idx' in the slots, it's easier to open code this in the loop and
drop kvm_init_memslots().

>  }
>  
>  static void kvm_destroy_dirty_bitmap(struct kvm_memory_slot *memslot)
> @@ -808,27 +804,31 @@ static void kvm_destroy_dirty_bitmap(struct kvm_memory_slot *memslot)
>  	memslot->dirty_bitmap = NULL;
>  }
>  
> +/* This does not remove the slot from struct kvm_memslots data structures */
>  static void kvm_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
>  {
>  	kvm_destroy_dirty_bitmap(slot);
>  
>  	kvm_arch_free_memslot(kvm, slot);
>  
> -	slot->flags = 0;
> -	slot->npages = 0;
> +	kfree(slot);
>  }
>  
>  static void kvm_free_memslots(struct kvm *kvm, struct kvm_memslots *slots)
>  {
> +	int ctr;
> +	struct hlist_node *idnode;
>  	struct kvm_memory_slot *memslot;
>  
> -	if (!slots)
> +	/*
> +	 * Both active and inactive struct kvm_memslots should point to
> +	 * the same set of memslots, so it's enough to free them once
> +	 */

Thumbs up for comments!  It would be very helpful to state that which index is
used is completely arbitrary.

> +	if (slots->is_idx_0)
>  		return;
>  
> -	kvm_for_each_memslot(memslot, slots)
> +	hash_for_each_safe(slots->id_hash, ctr, idnode, memslot, id_node[1])
>  		kvm_free_memslot(kvm, memslot);
> -
> -	kvfree(slots);
>  }
>  
>  static void kvm_destroy_vm_debugfs(struct kvm *kvm)
> @@ -924,13 +924,14 @@ static struct kvm *kvm_create_vm(unsigned long type)
>  
>  	refcount_set(&kvm->users_count, 1);
>  	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> -		struct kvm_memslots *slots = kvm_alloc_memslots();
> +		kvm_init_memslots(&kvm->memslots_all[i][0]);
> +		kvm_init_memslots(&kvm->memslots_all[i][1]);
> +		kvm->memslots_all[i][0].is_idx_0 = true;
> +		kvm->memslots_all[i][1].is_idx_0 = false;
>  
> -		if (!slots)
> -			goto out_err_no_arch_destroy_vm;
>  		/* Generations must be different for each address space. */
> -		slots->generation = i;
> -		rcu_assign_pointer(kvm->memslots[i], slots);
> +		kvm->memslots_all[i][0].generation = i;
> +		rcu_assign_pointer(kvm->memslots[i], &kvm->memslots_all[i][0]);

Open coding this with node_idx looks like so:

		for (j = 0; j < 2; j++) {
			slots = &kvm->__memslots[i][j];

			atomic_long_set(&slots->lru_slot, (unsigned long)NULL);
			slots->hva_tree = RB_ROOT_CACHED;
			slots->gfn_tree = RB_ROOT;
			hash_init(slots->id_hash);
			slots->node_idx = j;

			/* Generations must be different for each address space. */
			slots->generation = i;
		}

		rcu_assign_pointer(kvm->memslots[i], &kvm->__memslots[i][0]);

>  	}
>  
>  	for (i = 0; i < KVM_NR_BUSES; i++) {
> @@ -983,8 +984,6 @@ static struct kvm *kvm_create_vm(unsigned long type)
>  	WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));
>  	for (i = 0; i < KVM_NR_BUSES; i++)
>  		kfree(kvm_get_bus(kvm, i));
> -	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
> -		kvm_free_memslots(kvm, __kvm_memslots(kvm, i));
>  	cleanup_srcu_struct(&kvm->irq_srcu);
>  out_err_no_irq_srcu:
>  	cleanup_srcu_struct(&kvm->srcu);
> @@ -1038,8 +1037,10 @@ static void kvm_destroy_vm(struct kvm *kvm)
>  #endif
>  	kvm_arch_destroy_vm(kvm);
>  	kvm_destroy_devices(kvm);
> -	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
> -		kvm_free_memslots(kvm, __kvm_memslots(kvm, i));
> +	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> +		kvm_free_memslots(kvm, &kvm->memslots_all[i][0]);
> +		kvm_free_memslots(kvm, &kvm->memslots_all[i][1]);
> +	}
>  	cleanup_srcu_struct(&kvm->irq_srcu);
>  	cleanup_srcu_struct(&kvm->srcu);
>  	kvm_arch_free_vm(kvm);
> @@ -1099,212 +1100,6 @@ static int kvm_alloc_dirty_bitmap(struct kvm_memory_slot *memslot)
>  	return 0;
>  }
>  

...

> @@ -1319,10 +1114,12 @@ static int check_memory_region_flags(const struct kvm_userspace_memory_region *m
>  	return 0;
>  }
>  
> -static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
> -		int as_id, struct kvm_memslots *slots)
> +static void swap_memslots(struct kvm *kvm, int as_id)
>  {
>  	struct kvm_memslots *old_memslots = __kvm_memslots(kvm, as_id);
> +	int idxactive = kvm_memslots_idx(old_memslots);
> +	int idxina = idxactive == 0 ? 1 : 0;
> +	struct kvm_memslots *slots = &kvm->memslots_all[as_id][idxina];
>  	u64 gen = old_memslots->generation;
>  
>  	WARN_ON(gen & KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS);
> @@ -1351,44 +1148,129 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
>  	kvm_arch_memslots_updated(kvm, gen);
>  
>  	slots->generation = gen;
> +}
> +
> +static void kvm_memslot_gfn_insert(struct rb_root *gfn_tree,
> +				  struct kvm_memory_slot *slot,
> +				  int which)

Pass slots instead of the tree, that way the index doesn't need to passed
separately.  And similar to previous feedback, s/which/idx.

> +{
> +	struct rb_node **cur, *parent;
> +
> +	for (cur = &gfn_tree->rb_node, parent = NULL; *cur; ) {

I think it makes sense to initialize 'parent' outside of loop, both to make the
loop control flow easier to read, and to make it more obvious that parent _must_
be initialized in the empty case.

> +		struct kvm_memory_slot *cslot;

I'd prefer s/cur/node and s/cslot/tmp.  'cslot' in particular is hard to parse.

> +		cslot = container_of(*cur, typeof(*cslot), gfn_node[which]);
> +		parent = *cur;
> +		if (slot->base_gfn < cslot->base_gfn)
> +			cur = &(*cur)->rb_left;
> +		else if (slot->base_gfn > cslot->base_gfn)
> +			cur = &(*cur)->rb_right;
> +		else
> +			BUG();
> +	}
>  
> -	return old_memslots;
> +	rb_link_node(&slot->gfn_node[which], parent, cur);
> +	rb_insert_color(&slot->gfn_node[which], gfn_tree);
>  }
>  
>  /*
> - * Note, at a minimum, the current number of used slots must be allocated, even
> - * when deleting a memslot, as we need a complete duplicate of the memslots for
> - * use when invalidating a memslot prior to deleting/moving the memslot.
> + * Just copies the memslot data.
> + * Does not copy or touch the embedded nodes, including the ranges at hva_nodes.
>   */
> -static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
> -					     enum kvm_mr_change change)
> +static void kvm_copy_memslot(struct kvm_memory_slot *dest,
> +			     struct kvm_memory_slot *src)
>  {
> -	struct kvm_memslots *slots;
> -	size_t old_size, new_size;
> -	struct kvm_memory_slot *memslot;
> +	dest->base_gfn = src->base_gfn;
> +	dest->npages = src->npages;
> +	dest->dirty_bitmap = src->dirty_bitmap;
> +	dest->arch = src->arch;
> +	dest->userspace_addr = src->userspace_addr;
> +	dest->flags = src->flags;
> +	dest->id = src->id;
> +	dest->as_id = src->as_id;
> +}
>  
> -	old_size = sizeof(struct kvm_memslots) +
> -		   (sizeof(struct kvm_memory_slot) * old->used_slots);
> +/*
> + * Initializes the ranges at both hva_nodes from the memslot userspace_addr
> + * and npages fields.
> + */
> +static void kvm_init_memslot_hva_ranges(struct kvm_memory_slot *slot)
> +{
> +	slot->hva_node[0].start = slot->hva_node[1].start =
> +		slot->userspace_addr;
> +	slot->hva_node[0].last = slot->hva_node[1].last =
> +		slot->userspace_addr + (slot->npages << PAGE_SHIFT) - 1;

Fold this into kvm_copy_memslot().  It's always called immediately after, and
technically the node range does come from the src, e.g. calling this without
first calling kvm_copy_memslot() doesn't make sense.

> +}
>  
> -	if (change == KVM_MR_CREATE)
> -		new_size = old_size + sizeof(struct kvm_memory_slot);
> -	else
> -		new_size = old_size;
> +/*
> + * Replaces the @oldslot with @nslot in the memslot set indicated by
> + * @slots_idx.
> + *
> + * With NULL @oldslot this simply adds the @nslot to the set.
> + * With NULL @nslot this simply removes the @oldslot from the set.
> + *
> + * If @nslot is non-NULL its hva_node[slots_idx] range has to be set
> + * appropriately.
> + */
> +static void kvm_replace_memslot(struct kvm *kvm,
> +				int as_id, int slots_idx,

Pass slots itself, then all three of these go away.

> +				struct kvm_memory_slot *oldslot,
> +				struct kvm_memory_slot *nslot)

s/oldslot/old and s/nslot/new, again to make it easier to identify which is what,
and for consistency.

> +{
> +	struct kvm_memslots *slots = &kvm->memslots_all[as_id][slots_idx];

s/slots_idx/idx for consistency.

>  
> -	slots = kvzalloc(new_size, GFP_KERNEL_ACCOUNT);
> -	if (unlikely(!slots))
> -		return NULL;
> +	if (WARN_ON(!oldslot && !nslot))

This should be moved to kvm_set_memslot() in the form of:

	if (change != KVM_MR_CREATE) {
		slot = id_to_memslot(active, old->id);
		if (WARN_ON_ONCE(!slot))
			return -EIO;
	}

Adding a WARN that the caller doesn't pass "NULL, NULL" is unnecessary, and
putting the WARN in this helper obfuscates the one case that warrants a guard.

> +		return;
> +
> +	if (oldslot) {
> +		hash_del(&oldslot->id_node[slots_idx]);
> +		interval_tree_remove(&oldslot->hva_node[slots_idx],
> +				     &slots->hva_tree);

Unnecessary newline.

> +		atomic_long_cmpxchg(&slots->lru_slot,
> +				    (unsigned long)oldslot,
> +				    (unsigned long)nslot);

Can be:

		atomic_long_cmpxchg(&slots->lru_slot,
				    (unsigned long)old, (unsigned long)new);


> +		if (!nslot) {
> +			rb_erase(&oldslot->gfn_node[slots_idx],
> +				 &slots->gfn_tree);

Unnecessary newline.

> +			return;
> +		}
> +	}
>  
> -	memcpy(slots, old, old_size);
> +	hash_add(slots->id_hash, &nslot->id_node[slots_idx],
> +		 nslot->id);
> +	WARN_ON(PAGE_SHIFT > 0 &&

Are there actually KVM architectures for which PAGE_SHIFT==0?

> +		nslot->hva_node[slots_idx].start >=
> +		nslot->hva_node[slots_idx].last);
> +	interval_tree_insert(&nslot->hva_node[slots_idx],
> +			     &slots->hva_tree);
>  
> -	slots->hva_tree = RB_ROOT_CACHED;
> -	hash_init(slots->id_hash);
> -	kvm_for_each_memslot(memslot, slots) {
> -		interval_tree_insert(&memslot->hva_node, &slots->hva_tree);
> -		hash_add(slots->id_hash, &memslot->id_node, memslot->id);
> +	/* Shame there is no O(1) interval_tree_replace()... */
> +	if (oldslot && oldslot->base_gfn == nslot->base_gfn)
> +		rb_replace_node(&oldslot->gfn_node[slots_idx],
> +				&nslot->gfn_node[slots_idx],
> +				&slots->gfn_tree);

Add wrappers for all the rb-tree mutators.  Partly for consistency, mostly for
readability.  Having the node index in the memslots helps in this case.  E.g.

	/* Shame there is no O(1) interval_tree_replace()... */
	if (old && old->base_gfn == new->base_gfn) {
		kvm_memslot_gfn_replace(slots, old, new);
	} else {
		if (old)
			kvm_memslot_gfn_erase(slots, old);
		kvm_memslot_gfn_insert(slots, new);
	}

> +	else {
> +		if (oldslot)
> +			rb_erase(&oldslot->gfn_node[slots_idx],
> +				 &slots->gfn_tree);
> +		kvm_memslot_gfn_insert(&slots->gfn_tree,
> +				       nslot, slots_idx);

Unnecessary newlines.

>  	}
> +}
> +
> +/*
> + * Copies the @oldslot data into @nslot and uses this slot to replace
> + * @oldslot in the memslot set indicated by @slots_idx.
> + */
> +static void kvm_copy_replace_memslot(struct kvm *kvm,

I fiddled with this one, and I think it's best to drop this helper in favor of
open coding the calls to kvm_copy_memslot() and kvm_replace_memslot().  More on
this below.

> +				     int as_id, int slots_idx,
> +				     struct kvm_memory_slot *oldslot,
> +				     struct kvm_memory_slot *nslot)
> +{
> +	kvm_copy_memslot(nslot, oldslot);
> +	kvm_init_memslot_hva_ranges(nslot);
>  
> -	return slots;
> +	kvm_replace_memslot(kvm, as_id, slots_idx, oldslot, nslot);
>  }
>  
>  static int kvm_set_memslot(struct kvm *kvm,
> @@ -1397,56 +1279,178 @@ static int kvm_set_memslot(struct kvm *kvm,
>  			   struct kvm_memory_slot *new, int as_id,
>  			   enum kvm_mr_change change)
>  {
> -	struct kvm_memory_slot *slot;
> -	struct kvm_memslots *slots;
> +	struct kvm_memslots *slotsact = __kvm_memslots(kvm, as_id);
> +	int idxact = kvm_memslots_idx(slotsact);
> +	int idxina = idxact == 0 ? 1 : 0;

I strongly prefer using "active" and "inactive" for the memslots, dropping the
local incidices completely, and using "slot" and "tmp" for the slot.

"slot" and "tmp" aren't great, but slotsact vs. slotact is really, really hard
to read.  And more importantly, slotact vs. slotina is misleading because they
don't always point slots in the active set and inactive set respectively.  That
detail took me a while to fully grep.

> +	struct kvm_memslots *slotsina = &kvm->memslots_all[as_id][idxina];

To avoid local index variables, this can be the somewhat clever/gross:

	struct kvm_memslots *inactive = &kvm->__memslots[as_id][active->node_idx ^ 1];

> +	struct kvm_memory_slot *slotina, *slotact;
>  	int r;
>  
> -	slots = kvm_dup_memslots(__kvm_memslots(kvm, as_id), change);
> -	if (!slots)
> +	slotina = kzalloc(sizeof(*slotina), GFP_KERNEL_ACCOUNT);
> +	if (!slotina)
>  		return -ENOMEM;
>  
> +	if (change != KVM_MR_CREATE)
> +		slotact = id_to_memslot(slotsact, old->id);

And the WARN, as mentioned above.
> +
>  	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
>  		/*
> -		 * Note, the INVALID flag needs to be in the appropriate entry
> -		 * in the freshly allocated memslots, not in @old or @new.
> +		 * Replace the slot to be deleted or moved in the inactive
> +		 * memslot set by its copy with KVM_MEMSLOT_INVALID flag set.

This is where the inactive slot vs. inactive memslot terminology gets really
confusing.  "inactive memslots" refers precisely which set is not kvm->memslots,
whereas "inactive slot" might refer to a slot that is in the inactive set, but
it might also refer to a slot that is currently not in any tree at all.  E.g.

		/*
		 * Mark the current slot INVALID.  This must be done on the tmp
		 * slot to avoid modifying the current slot in the active tree.
		 */

>  		 */
> -		slot = id_to_memslot(slots, old->id);
> -		slot->flags |= KVM_MEMSLOT_INVALID;
> +		kvm_copy_replace_memslot(kvm, as_id, idxina, slotact, slotina);
> +		slotina->flags |= KVM_MEMSLOT_INVALID;

This is where I'd prefer to open code the copy and replace.  Functionally it works,
but setting the INVALID flag _after_ replacing the slot is not intuitive.  E.g.
this sequencing helps the reader understand that it makes a copy

		kvm_copy_memslot(tmp, slot);
		tmp->flags |= KVM_MEMSLOT_INVALID;
		kvm_replace_memslot(inactive, slot, tmp);


>  		/*
> -		 * We can re-use the old memslots, the only difference from the
> -		 * newly installed memslots is the invalid flag, which will get
> -		 * dropped by update_memslots anyway.  We'll also revert to the
> -		 * old memslots if preparing the new memory region fails.
> +		 * Swap the active <-> inactive memslot set.
> +		 * Now the active memslot set still contains the memslot to be
> +		 * deleted or moved, but with the KVM_MEMSLOT_INVALID flag set.
>  		 */
> -		slots = install_new_memslots(kvm, as_id, slots);
> +		swap_memslots(kvm, as_id);

kvm_swap_active_memslots() would be preferable, without context it's not clear
what's being swapped.

To dedup code, and hopefully improve readability, I think it makes sense to do
the swap() of the memslots in kvm_swap_active_memslots().  With the indices gone,
the number of swap() calls goes down dramatically, e.g.


		/*
		 * Activate the slot that is now marked INVALID, but don't
		 * propagate the slot to the now inactive slots.  The slot is
		 * either going to be deleted or recreated as a new slot.
		*/
		kvm_swap_active_memslots(kvm, as_id, &active, &inactive);

		/* The temporary and current slot have swapped roles. */
		swap(tmp, slot);

> +		swap(idxact, idxina);
> +		swap(slotsina, slotsact);
> +		swap(slotact, slotina);
>  
> -		/* From this point no new shadow pages pointing to a deleted,
> +		/*
> +		 * From this point no new shadow pages pointing to a deleted,
>  		 * or moved, memslot will be created.
>  		 *
>  		 * validation of sp->gfn happens in:
>  		 *	- gfn_to_hva (kvm_read_guest, gfn_to_pfn)
>  		 *	- kvm_is_visible_gfn (mmu_check_root)
>  		 */
> -		kvm_arch_flush_shadow_memslot(kvm, slot);
> +		kvm_arch_flush_shadow_memslot(kvm, slotact);
>  	}
>  
>  	r = kvm_arch_prepare_memory_region(kvm, new, mem, change);
>  	if (r)
>  		goto out_slots;

Normally I like avoiding code churn, but in this case I think it makes sense to
avoid the goto.  Even after the below if-else-elif block is trimmed down, the
error handling that is specific to the above DELETE|MOVE ends up landing too far
away from the code that it is reverting.  E.g.

	r = kvm_arch_prepare_memory_region(kvm, new, mem, change);
	if (r) {
		if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
			/*
			 * Revert the above INVALID change.  No modifications
			 * required since the original slot was preserved in
			 * the inactive slots.
			 */
			kvm_swap_active_memslots(kvm, as_id, &active, &inactive);
			swap(tmp, slot);
		}
		kfree(tmp);
		return r;
	}
  
> -	update_memslots(slots, new, change);
> -	slots = install_new_memslots(kvm, as_id, slots);
> +	if (change == KVM_MR_MOVE) {
> +		/*
> +		 * Since we are going to be changing the memslot gfn we need to

Try to use imperative mode and avoid I/we/us/etc....  It requires creative
wording in some cases, but overall it does help avoid ambiguity (though "we" is
fairly obvious in this case).

> +		 * remove it from the gfn tree so it can be re-added there with
> +		 * the updated gfn.
> +		 */
> +		rb_erase(&slotina->gfn_node[idxina],
> +			 &slotsina->gfn_tree);

Unnecessary newline.

> +
> +		slotina->base_gfn = new->base_gfn;
> +		slotina->flags = new->flags;
> +		slotina->dirty_bitmap = new->dirty_bitmap;
> +		/* kvm_arch_prepare_memory_region() might have modified arch */
> +		slotina->arch = new->arch;
> +
> +		/* Re-add to the gfn tree with the updated gfn */
> +		kvm_memslot_gfn_insert(&slotsina->gfn_tree,
> +				       slotina, idxina);

Again, newline.  
> +
> +		/*
> +		 * Swap the active <-> inactive memslot set.
> +		 * Now the active memslot set contains the new, final memslot.
> +		 */
> +		swap_memslots(kvm, as_id);
> +		swap(idxact, idxina);
> +		swap(slotsina, slotsact);
> +		swap(slotact, slotina);
> +
> +		/*
> +		 * Replace the temporary KVM_MEMSLOT_INVALID slot with the
> +		 * new, final memslot in the inactive memslot set and
> +		 * free the temporary memslot.
> +		 */
> +		kvm_replace_memslot(kvm, as_id, idxina, slotina, slotact);
> +		kfree(slotina);

Adding a wrapper for the trifecta of swap + replace + kfree() cuts down on the
boilerplate tremendously, and sidesteps having to swap() "slot" and "tmp" for
these flows.   E.g. this can become:

		/*
		 * The memslot's gfn is changing, remove it from the inactive
		 * tree, it will be re-added with its updated gfn.  Because its
		 * range is changing, an in-place replace is not possible.
		 */
		kvm_memslot_gfn_erase(inactive, tmp);

		tmp->base_gfn = new->base_gfn;
		tmp->flags = new->flags;
		tmp->dirty_bitmap = new->dirty_bitmap;
		/* kvm_arch_prepare_memory_region() might have modified arch */
		tmp->arch = new->arch;

		/* Re-add to the gfn tree with the updated gfn */
		kvm_memslot_gfn_insert(inactive, tmp);

		/* Replace the current INVALID slot with the updated memslot. */
		kvm_activate_memslot(kvm, as_id, &active, &inactive, slot, tmp);

by adding:

static void kvm_activate_memslot(struct kvm *kvm, int as_id,
				 struct kvm_memslots **active,
				 struct kvm_memslots **inactive,
				 struct kvm_memory_slot *old,
				 struct kvm_memory_slot *new)
{
	/*
	 * Swap the active <-> inactive memslots.  Note, this also swaps
	 * the active and inactive pointers themselves.
	 */
	kvm_swap_active_memslots(kvm, as_id, active, inactive);

	/* Propagate the new memslot to the now inactive memslots. */
	kvm_replace_memslot(*inactive, old, new);

	/* And free the old slot. */
	if (old)
		kfree(old);
}

> +	} else if (change == KVM_MR_FLAGS_ONLY) {
> +		/*
> +		 * Almost like the move case above, but we don't use a temporary
> +		 * KVM_MEMSLOT_INVALID slot.

Let's use INVALID, it should be obvious to readers that make it his far :-)

> +		 * Instead, we simply replace the old memslot with a new, updated
> +		 * copy in both memslot sets.
> +		 *
> +		 * Since we aren't going to be changing the memslot gfn we can
> +		 * simply use kvm_copy_replace_memslot(), which will use
> +		 * rb_replace_node() to switch the memslot node in the gfn tree
> +		 * instead of removing the old one and inserting the new one
> +		 * as two separate operations.
> +		 * It's a performance win since node replacement is a single
> +		 * O(1) operation as opposed to two O(log(n)) operations for
> +		 * slot removal and then re-insertion.
> +		 */
> +		kvm_copy_replace_memslot(kvm, as_id, idxina, slotact, slotina);
> +		slotina->flags = new->flags;
> +		slotina->dirty_bitmap = new->dirty_bitmap;
> +		/* kvm_arch_prepare_memory_region() might have modified arch */
> +		slotina->arch = new->arch;
> +
> +		/* Swap the active <-> inactive memslot set. */
> +		swap_memslots(kvm, as_id);
> +		swap(idxact, idxina);
> +		swap(slotsina, slotsact);
> +		swap(slotact, slotina);
> +
> +		/*
> +		 * Replace the old memslot in the other memslot set and
> +		 * then finally free it.
> +		 */
> +		kvm_replace_memslot(kvm, as_id, idxina, slotina, slotact);
> +		kfree(slotina);
> +	} else if (change == KVM_MR_CREATE) {
> +		/*
> +		 * Add the new memslot to the current inactive set as a copy
> +		 * of the provided new memslot data.
> +		 */
> +		kvm_copy_memslot(slotina, new);
> +		kvm_init_memslot_hva_ranges(slotina);
> +
> +		kvm_replace_memslot(kvm, as_id, idxina, NULL, slotina);
> +
> +		/* Swap the active <-> inactive memslot set. */
> +		swap_memslots(kvm, as_id);
> +		swap(idxact, idxina);
> +		swap(slotsina, slotsact);
> +
> +		/* Now add it also to the other memslot set */
> +		kvm_replace_memslot(kvm, as_id, idxina, NULL, slotina);
> +	} else if (change == KVM_MR_DELETE) {
> +		/*
> +		 * Remove the old memslot from the current inactive set
> +		 * (the other, active set contains the temporary
> +		 * KVM_MEMSLOT_INVALID slot)
> +		 */
> +		kvm_replace_memslot(kvm, as_id, idxina, slotina, NULL);
> +
> +		/* Swap the active <-> inactive memslot set. */
> +		swap_memslots(kvm, as_id);
> +		swap(idxact, idxina);
> +		swap(slotsina, slotsact);
> +		swap(slotact, slotina);
> +
> +		/* Remove the temporary KVM_MEMSLOT_INVALID slot and free it. */
> +		kvm_replace_memslot(kvm, as_id, idxina, slotina, NULL);
> +		kfree(slotina);
> +		/* slotact will be freed by kvm_free_memslot() */

I think this comment can go away in favor of documenting the kvm_free_memslot()
call down below.  With all of the aforementioned changes:

		/*
		 * Remove the old memslot (in the inactive memslots) and activate
		 * the NULL slot.
		*/
		kvm_replace_memslot(inactive, tmp, NULL);
		kvm_activate_memslot(kvm, as_id, &active, &inactive, slot, NULL);

> +	} else
> +		BUG();
>  
>  	kvm_arch_commit_memory_region(kvm, mem, old, new, change);
>  
> -	kvfree(slots);
> +	if (change == KVM_MR_DELETE)
> +		kvm_free_memslot(kvm, slotact);
> +
>  	return 0;

--3zAiiMgFZmQFHLbv
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-tmp.patch"

From 9909e51d83ba3e5abe5573946891b20e5fd50a22 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 25 May 2021 15:14:05 -0700
Subject: [PATCH] tmp

---
 include/linux/kvm_host.h |  31 ++-
 virt/kvm/kvm_main.c      | 427 ++++++++++++++++++---------------------
 2 files changed, 204 insertions(+), 254 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 84fd72d8bb23..85ee81318362 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -508,7 +508,7 @@ struct kvm_memslots {
 	struct rb_root gfn_tree;
 	/* The mapping table from slot id to memslot. */
 	DECLARE_HASHTABLE(id_hash, 7);
-	bool is_idx_0;
+	int node_idx;
 };
 
 struct kvm {
@@ -520,7 +520,7 @@ struct kvm {
 
 	struct mutex slots_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
-	struct kvm_memslots memslots_all[KVM_ADDRESS_SPACE_NUM][2];
+	struct kvm_memslots __memslots[KVM_ADDRESS_SPACE_NUM][2];
 	struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 
@@ -724,15 +724,9 @@ static inline bool kvm_memslots_empty(struct kvm_memslots *slots)
 	return RB_EMPTY_ROOT(&slots->gfn_tree);
 }
 
-static inline int kvm_memslots_idx(struct kvm_memslots *slots)
-{
-	return slots->is_idx_0 ? 0 : 1;
-}
-
-#define kvm_for_each_memslot(memslot, ctr, slots)	\
-	hash_for_each(slots->id_hash, ctr, memslot,	\
-		      id_node[kvm_memslots_idx(slots)]) \
-		if (WARN_ON_ONCE(!memslot->npages)) {	\
+#define kvm_for_each_memslot(memslot, bkt, slots)			      \
+	hash_for_each(slots->id_hash, bkt, memslot, id_node[slots->node_idx]) \
+		if (WARN_ON_ONCE(!memslot->npages)) {			      \
 		} else
 
 #define kvm_for_each_hva_range_memslot(node, slots, start, last)	     \
@@ -743,10 +737,10 @@ static inline int kvm_memslots_idx(struct kvm_memslots *slots)
 static inline
 struct kvm_memory_slot *id_to_memslot(struct kvm_memslots *slots, int id)
 {
-	int idxactive = kvm_memslots_idx(slots);
 	struct kvm_memory_slot *slot;
+	int idx = slots->node_idx;
 
-	hash_for_each_possible(slots->id_hash, slot, id_node[idxactive], id) {
+	hash_for_each_possible(slots->id_hash, slot, id_node[idx], id) {
 		if (slot->id == id)
 			return slot;
 	}
@@ -1160,19 +1154,19 @@ bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args);
 static inline struct kvm_memory_slot *
 search_memslots(struct kvm_memslots *slots, gfn_t gfn, bool approx)
 {
-	int idxactive = kvm_memslots_idx(slots);
 	struct kvm_memory_slot *slot;
 	struct rb_node *prevnode, *node;
+	int idx = slots->node_idx;
 
 	slot = (struct kvm_memory_slot *)atomic_long_read(&slots->lru_slot);
 	if (slot &&
 	    gfn >= slot->base_gfn && gfn < slot->base_gfn + slot->npages)
 		return slot;
 
-	for (prevnode = NULL, node = slots->gfn_tree.rb_node; node; ) {
+	prevnode = NULL;
+	for (node = slots->gfn_tree.rb_node; node; ) {
 		prevnode = node;
-		slot = container_of(node, struct kvm_memory_slot,
-				    gfn_node[idxactive]);
+		slot = container_of(node, struct kvm_memory_slot, gfn_node[idx]);
 		if (gfn >= slot->base_gfn) {
 			if (gfn < slot->base_gfn + slot->npages) {
 				atomic_long_set(&slots->lru_slot,
@@ -1185,8 +1179,7 @@ search_memslots(struct kvm_memslots *slots, gfn_t gfn, bool approx)
 	}
 
 	if (approx && prevnode)
-		return container_of(prevnode, struct kvm_memory_slot,
-				    gfn_node[idxactive]);
+		return container_of(prevnode, struct kvm_memory_slot, gfn_node[idx]);
 
 	return NULL;
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 189504b27ca6..0744b081b16b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -510,17 +510,15 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 	}
 
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
-		int idxactive;
 		struct interval_tree_node *node;
 
 		slots = __kvm_memslots(kvm, i);
-		idxactive = kvm_memslots_idx(slots);
 		kvm_for_each_hva_range_memslot(node, slots,
 					       range->start, range->end - 1) {
 			unsigned long hva_start, hva_end;
 
 			slot = container_of(node, struct kvm_memory_slot,
-					    hva_node[idxactive]);
+					    hva_node[slots->node_idx]);
 			hva_start = max(range->start, slot->userspace_addr);
 			hva_end = min(range->end, slot->userspace_addr +
 						  (slot->npages << PAGE_SHIFT));
@@ -787,14 +785,6 @@ static int kvm_init_mmu_notifier(struct kvm *kvm)
 
 #endif /* CONFIG_MMU_NOTIFIER && KVM_ARCH_WANT_MMU_NOTIFIER */
 
-static void kvm_init_memslots(struct kvm_memslots *slots)
-{
-	atomic_long_set(&slots->lru_slot, (unsigned long)NULL);
-	slots->hva_tree = RB_ROOT_CACHED;
-	slots->gfn_tree = RB_ROOT;
-	hash_init(slots->id_hash);
-}
-
 static void kvm_destroy_dirty_bitmap(struct kvm_memory_slot *memslot)
 {
 	if (!memslot->dirty_bitmap)
@@ -816,18 +806,18 @@ static void kvm_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 
 static void kvm_free_memslots(struct kvm *kvm, struct kvm_memslots *slots)
 {
-	int ctr;
 	struct hlist_node *idnode;
 	struct kvm_memory_slot *memslot;
+	int bkt;
 
 	/*
-	 * Both active and inactive struct kvm_memslots should point to
-	 * the same set of memslots, so it's enough to free them once
+	 * The same memslot objects live in both active and inactive sets,
+	 * arbitrarily free using index '0'.
 	 */
-	if (slots->is_idx_0)
+	if (slots->node_idx)
 		return;
 
-	hash_for_each_safe(slots->id_hash, ctr, idnode, memslot, id_node[1])
+	hash_for_each_safe(slots->id_hash, bkt, idnode, memslot, id_node[0])
 		kvm_free_memslot(kvm, memslot);
 }
 
@@ -900,8 +890,9 @@ void __weak kvm_arch_pre_destroy_vm(struct kvm *kvm)
 static struct kvm *kvm_create_vm(unsigned long type)
 {
 	struct kvm *kvm = kvm_arch_alloc_vm();
+	struct kvm_memslots *slots;
 	int r = -ENOMEM;
-	int i;
+	int i, j;
 
 	if (!kvm)
 		return ERR_PTR(-ENOMEM);
@@ -924,14 +915,20 @@ static struct kvm *kvm_create_vm(unsigned long type)
 
 	refcount_set(&kvm->users_count, 1);
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
-		kvm_init_memslots(&kvm->memslots_all[i][0]);
-		kvm_init_memslots(&kvm->memslots_all[i][1]);
-		kvm->memslots_all[i][0].is_idx_0 = true;
-		kvm->memslots_all[i][1].is_idx_0 = false;
+		for (j = 0; j < 2; j++) {
+			slots = &kvm->__memslots[i][j];
 
-		/* Generations must be different for each address space. */
-		kvm->memslots_all[i][0].generation = i;
-		rcu_assign_pointer(kvm->memslots[i], &kvm->memslots_all[i][0]);
+			atomic_long_set(&slots->lru_slot, (unsigned long)NULL);
+			slots->hva_tree = RB_ROOT_CACHED;
+			slots->gfn_tree = RB_ROOT;
+			hash_init(slots->id_hash);
+			slots->node_idx = j;
+
+			/* Generations must be different for each address space. */
+			slots->generation = i;
+		}
+
+		rcu_assign_pointer(kvm->memslots[i], &kvm->__memslots[i][0]);
 	}
 
 	for (i = 0; i < KVM_NR_BUSES; i++) {
@@ -1038,8 +1035,8 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	kvm_arch_destroy_vm(kvm);
 	kvm_destroy_devices(kvm);
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
-		kvm_free_memslots(kvm, &kvm->memslots_all[i][0]);
-		kvm_free_memslots(kvm, &kvm->memslots_all[i][1]);
+		kvm_free_memslots(kvm, &kvm->__memslots[i][0]);
+		kvm_free_memslots(kvm, &kvm->__memslots[i][1]);
 	}
 	cleanup_srcu_struct(&kvm->irq_srcu);
 	cleanup_srcu_struct(&kvm->srcu);
@@ -1114,13 +1111,12 @@ static int check_memory_region_flags(const struct kvm_userspace_memory_region *m
 	return 0;
 }
 
-static void swap_memslots(struct kvm *kvm, int as_id)
+static void kvm_swap_active_memslots(struct kvm *kvm, int as_id,
+				     struct kvm_memslots **active,
+				     struct kvm_memslots **inactive)
 {
-	struct kvm_memslots *old_memslots = __kvm_memslots(kvm, as_id);
-	int idxactive = kvm_memslots_idx(old_memslots);
-	int idxina = idxactive == 0 ? 1 : 0;
-	struct kvm_memslots *slots = &kvm->memslots_all[as_id][idxina];
-	u64 gen = old_memslots->generation;
+	struct kvm_memslots *slots = *inactive;
+	u64 gen = (*active)->generation;
 
 	WARN_ON(gen & KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS);
 	slots->generation = gen | KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS;
@@ -1148,37 +1144,55 @@ static void swap_memslots(struct kvm *kvm, int as_id)
 	kvm_arch_memslots_updated(kvm, gen);
 
 	slots->generation = gen;
+
+	swap(*active, *inactive);
 }
 
-static void kvm_memslot_gfn_insert(struct rb_root *gfn_tree,
-				  struct kvm_memory_slot *slot,
-				  int which)
+static void kvm_memslot_gfn_insert(struct kvm_memslots *slots,
+				   struct kvm_memory_slot *slot)
 {
-	struct rb_node **cur, *parent;
+	struct rb_root *gfn_tree = &slots->gfn_tree;
+	struct rb_node **node, *parent;
+	int idx = slots->node_idx;
 
-	for (cur = &gfn_tree->rb_node, parent = NULL; *cur; ) {
-		struct kvm_memory_slot *cslot;
+	parent = NULL;
+	for (node = &gfn_tree->rb_node; *node; ) {
+		struct kvm_memory_slot *tmp;
 
-		cslot = container_of(*cur, typeof(*cslot), gfn_node[which]);
-		parent = *cur;
-		if (slot->base_gfn < cslot->base_gfn)
-			cur = &(*cur)->rb_left;
-		else if (slot->base_gfn > cslot->base_gfn)
-			cur = &(*cur)->rb_right;
+		tmp = container_of(*node, struct kvm_memory_slot, gfn_node[idx]);
+		parent = *node;
+		if (slot->base_gfn < tmp->base_gfn)
+			node = &(*node)->rb_left;
+		else if (slot->base_gfn > tmp->base_gfn)
+			node = &(*node)->rb_right;
 		else
 			BUG();
 	}
 
-	rb_link_node(&slot->gfn_node[which], parent, cur);
-	rb_insert_color(&slot->gfn_node[which], gfn_tree);
+	rb_link_node(&slot->gfn_node[idx], parent, node);
+	rb_insert_color(&slot->gfn_node[idx], gfn_tree);
+}
+
+static void kvm_memslot_gfn_erase(struct kvm_memslots *slots,
+				  struct kvm_memory_slot *slot)
+{
+	rb_erase(&slot->gfn_node[slots->node_idx], &slots->gfn_tree);
+}
+
+static void kvm_memslot_gfn_replace(struct kvm_memslots *slots,
+				    struct kvm_memory_slot *old,
+				    struct kvm_memory_slot *new)
+{
+	int idx = slots->node_idx;
+
+	WARN_ON_ONCE(old->base_gfn != new->base_gfn);
+
+	rb_replace_node(&old->gfn_node[idx], &new->gfn_node[idx],
+			&slots->gfn_tree);
 }
 
-/*
- * Just copies the memslot data.
- * Does not copy or touch the embedded nodes, including the ranges at hva_nodes.
- */
 static void kvm_copy_memslot(struct kvm_memory_slot *dest,
-			     struct kvm_memory_slot *src)
+			     const struct kvm_memory_slot *src)
 {
 	dest->base_gfn = src->base_gfn;
 	dest->npages = src->npages;
@@ -1188,89 +1202,72 @@ static void kvm_copy_memslot(struct kvm_memory_slot *dest,
 	dest->flags = src->flags;
 	dest->id = src->id;
 	dest->as_id = src->as_id;
-}
 
-/*
- * Initializes the ranges at both hva_nodes from the memslot userspace_addr
- * and npages fields.
- */
-static void kvm_init_memslot_hva_ranges(struct kvm_memory_slot *slot)
-{
-	slot->hva_node[0].start = slot->hva_node[1].start =
-		slot->userspace_addr;
-	slot->hva_node[0].last = slot->hva_node[1].last =
-		slot->userspace_addr + (slot->npages << PAGE_SHIFT) - 1;
+	dest->hva_node[0].start = dest->hva_node[1].start =
+		dest->userspace_addr;
+	dest->hva_node[0].last = dest->hva_node[1].last =
+		dest->userspace_addr + (dest->npages << PAGE_SHIFT) - 1;
 }
 
 /*
- * Replaces the @oldslot with @nslot in the memslot set indicated by
- * @slots_idx.
+ * Replace @old with @new in @slots.
  *
- * With NULL @oldslot this simply adds the @nslot to the set.
- * With NULL @nslot this simply removes the @oldslot from the set.
+ * With NULL @old this simply adds the @new to @slots.
+ * With NULL @new this simply removes the @old from @slots.
  *
- * If @nslot is non-NULL its hva_node[slots_idx] range has to be set
+ * If @new is non-NULL its hva_node[slots_idx] range has to be set
  * appropriately.
  */
-static void kvm_replace_memslot(struct kvm *kvm,
-				int as_id, int slots_idx,
-				struct kvm_memory_slot *oldslot,
-				struct kvm_memory_slot *nslot)
+static void kvm_replace_memslot(struct kvm_memslots *slots,
+				struct kvm_memory_slot *old,
+				struct kvm_memory_slot *new)
 {
-	struct kvm_memslots *slots = &kvm->memslots_all[as_id][slots_idx];
+	int idx = slots->node_idx;
 
-	if (WARN_ON(!oldslot && !nslot))
-		return;
-
-	if (oldslot) {
-		hash_del(&oldslot->id_node[slots_idx]);
-		interval_tree_remove(&oldslot->hva_node[slots_idx],
-				     &slots->hva_tree);
+	if (old) {
+		hash_del(&old->id_node[idx]);
+		interval_tree_remove(&old->hva_node[idx], &slots->hva_tree);
 		atomic_long_cmpxchg(&slots->lru_slot,
-				    (unsigned long)oldslot,
-				    (unsigned long)nslot);
-		if (!nslot) {
-			rb_erase(&oldslot->gfn_node[slots_idx],
-				 &slots->gfn_tree);
+				    (unsigned long)old, (unsigned long)new);
+		if (!new) {
+			kvm_memslot_gfn_erase(slots, old);
 			return;
 		}
 	}
 
-	hash_add(slots->id_hash, &nslot->id_node[slots_idx],
-		 nslot->id);
 	WARN_ON(PAGE_SHIFT > 0 &&
-		nslot->hva_node[slots_idx].start >=
-		nslot->hva_node[slots_idx].last);
-	interval_tree_insert(&nslot->hva_node[slots_idx],
-			     &slots->hva_tree);
+		new->hva_node[idx].start >= new->hva_node[idx].last);
+	hash_add(slots->id_hash, &new->id_node[idx], new->id);
+	interval_tree_insert(&new->hva_node[idx], &slots->hva_tree);
 
 	/* Shame there is no O(1) interval_tree_replace()... */
-	if (oldslot && oldslot->base_gfn == nslot->base_gfn)
-		rb_replace_node(&oldslot->gfn_node[slots_idx],
-				&nslot->gfn_node[slots_idx],
-				&slots->gfn_tree);
-	else {
-		if (oldslot)
-			rb_erase(&oldslot->gfn_node[slots_idx],
-				 &slots->gfn_tree);
-		kvm_memslot_gfn_insert(&slots->gfn_tree,
-				       nslot, slots_idx);
+	if (old && old->base_gfn == new->base_gfn) {
+		kvm_memslot_gfn_replace(slots, old, new);
+	} else {
+		if (old)
+			kvm_memslot_gfn_erase(slots, old);
+		kvm_memslot_gfn_insert(slots, new);
 	}
 }
 
-/*
- * Copies the @oldslot data into @nslot and uses this slot to replace
- * @oldslot in the memslot set indicated by @slots_idx.
- */
-static void kvm_copy_replace_memslot(struct kvm *kvm,
-				     int as_id, int slots_idx,
-				     struct kvm_memory_slot *oldslot,
-				     struct kvm_memory_slot *nslot)
+static void kvm_activate_memslot(struct kvm *kvm, int as_id,
+				 struct kvm_memslots **active,
+				 struct kvm_memslots **inactive,
+				 struct kvm_memory_slot *old,
+				 struct kvm_memory_slot *new)
 {
-	kvm_copy_memslot(nslot, oldslot);
-	kvm_init_memslot_hva_ranges(nslot);
+	/*
+	 * Swap the active <-> inactive memslots.  Note, this also swaps
+	 * the active and inactive pointers themselves.
+	 */
+	kvm_swap_active_memslots(kvm, as_id, active, inactive);
 
-	kvm_replace_memslot(kvm, as_id, slots_idx, oldslot, nslot);
+	/* Propagate the new memslot to the now inactive memslots. */
+	kvm_replace_memslot(*inactive, old, new);
+
+	/* And free the old slot. */
+	if (old)
+		kfree(old);
 }
 
 static int kvm_set_memslot(struct kvm *kvm,
@@ -1279,37 +1276,43 @@ static int kvm_set_memslot(struct kvm *kvm,
 			   struct kvm_memory_slot *new, int as_id,
 			   enum kvm_mr_change change)
 {
-	struct kvm_memslots *slotsact = __kvm_memslots(kvm, as_id);
-	int idxact = kvm_memslots_idx(slotsact);
-	int idxina = idxact == 0 ? 1 : 0;
-	struct kvm_memslots *slotsina = &kvm->memslots_all[as_id][idxina];
-	struct kvm_memory_slot *slotina, *slotact;
+	struct kvm_memslots *active = __kvm_memslots(kvm, as_id);
+	struct kvm_memslots *inactive = &kvm->__memslots[as_id][active->node_idx ^ 1];
+	struct kvm_memory_slot *slot, *tmp;
 	int r;
 
-	slotina = kzalloc(sizeof(*slotina), GFP_KERNEL_ACCOUNT);
-	if (!slotina)
+	if (change != KVM_MR_CREATE) {
+		slot = id_to_memslot(active, old->id);
+		if (WARN_ON_ONCE(!slot))
+			return -EIO;
+	}
+
+	/*
+	 * Modifications are done on a tmp, unreachable slot.  The changes are
+	 * then (eventually) propagated to both the active and inactive slots.
+	 */
+	tmp = kzalloc(sizeof(*tmp), GFP_KERNEL_ACCOUNT);
+	if (!tmp)
 		return -ENOMEM;
 
-	if (change != KVM_MR_CREATE)
-		slotact = id_to_memslot(slotsact, old->id);
-
 	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
 		/*
-		 * Replace the slot to be deleted or moved in the inactive
-		 * memslot set by its copy with KVM_MEMSLOT_INVALID flag set.
+		 * Mark the current slot INVALID.  This must be done on the tmp
+		 * slot to avoid modifying the current slot in the active tree.
 		 */
-		kvm_copy_replace_memslot(kvm, as_id, idxina, slotact, slotina);
-		slotina->flags |= KVM_MEMSLOT_INVALID;
+		kvm_copy_memslot(tmp, slot);
+		tmp->flags |= KVM_MEMSLOT_INVALID;
+		kvm_replace_memslot(inactive, slot, tmp);
 
 		/*
-		 * Swap the active <-> inactive memslot set.
-		 * Now the active memslot set still contains the memslot to be
-		 * deleted or moved, but with the KVM_MEMSLOT_INVALID flag set.
-		 */
-		swap_memslots(kvm, as_id);
-		swap(idxact, idxina);
-		swap(slotsina, slotsact);
-		swap(slotact, slotina);
+		 * Activate the slot that is now marked INVALID, but don't
+		 * propagate the slot to the now inactive slots.  The slot is
+		 * either going to be deleted or recreated as a new slot.
+		*/
+		kvm_swap_active_memslots(kvm, as_id, &active, &inactive);
+
+		/* The temporary and current slot have swapped roles. */
+		swap(tmp, slot);
 
 		/*
 		 * From this point no new shadow pages pointing to a deleted,
@@ -1319,139 +1322,93 @@ static int kvm_set_memslot(struct kvm *kvm,
 		 *	- gfn_to_hva (kvm_read_guest, gfn_to_pfn)
 		 *	- kvm_is_visible_gfn (mmu_check_root)
 		 */
-		kvm_arch_flush_shadow_memslot(kvm, slotact);
+		kvm_arch_flush_shadow_memslot(kvm, slot);
 	}
 
 	r = kvm_arch_prepare_memory_region(kvm, new, mem, change);
-	if (r)
-		goto out_slots;
+	if (r) {
+		if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
+			/*
+			 * Revert the above INVALID change.  No modifications
+			 * required since the original slot was preserved in
+			 * the inactive slots.
+			 */
+			kvm_swap_active_memslots(kvm, as_id, &active, &inactive);
+			swap(tmp, slot);
+		}
+		kfree(tmp);
+		return r;
+	}
 
 	if (change == KVM_MR_MOVE) {
 		/*
-		 * Since we are going to be changing the memslot gfn we need to
-		 * remove it from the gfn tree so it can be re-added there with
-		 * the updated gfn.
+		 * The memslot's gfn is changing, remove it from the inactive
+		 * tree, it will be re-added with its updated gfn.  Because its
+		 * range is changing, an in-place replace is not possible.
 		 */
-		rb_erase(&slotina->gfn_node[idxina],
-			 &slotsina->gfn_tree);
+		kvm_memslot_gfn_erase(inactive, tmp);
 
-		slotina->base_gfn = new->base_gfn;
-		slotina->flags = new->flags;
-		slotina->dirty_bitmap = new->dirty_bitmap;
+		tmp->base_gfn = new->base_gfn;
+		tmp->flags = new->flags;
+		tmp->dirty_bitmap = new->dirty_bitmap;
 		/* kvm_arch_prepare_memory_region() might have modified arch */
-		slotina->arch = new->arch;
+		tmp->arch = new->arch;
 
 		/* Re-add to the gfn tree with the updated gfn */
-		kvm_memslot_gfn_insert(&slotsina->gfn_tree,
-				       slotina, idxina);
+		kvm_memslot_gfn_insert(inactive, tmp);
 
-		/*
-		 * Swap the active <-> inactive memslot set.
-		 * Now the active memslot set contains the new, final memslot.
-		 */
-		swap_memslots(kvm, as_id);
-		swap(idxact, idxina);
-		swap(slotsina, slotsact);
-		swap(slotact, slotina);
-
-		/*
-		 * Replace the temporary KVM_MEMSLOT_INVALID slot with the
-		 * new, final memslot in the inactive memslot set and
-		 * free the temporary memslot.
-		 */
-		kvm_replace_memslot(kvm, as_id, idxina, slotina, slotact);
-		kfree(slotina);
+		/* Replace the current INVALID slot with the updated memslot. */
+		kvm_activate_memslot(kvm, as_id, &active, &inactive, slot, tmp);
 	} else if (change == KVM_MR_FLAGS_ONLY) {
 		/*
-		 * Almost like the move case above, but we don't use a temporary
-		 * KVM_MEMSLOT_INVALID slot.
-		 * Instead, we simply replace the old memslot with a new, updated
-		 * copy in both memslot sets.
+		 * Similar to the MOVE case, but the slot doesn't need to be
+		 * zapped as an intermediate step.  Instead, the old memslot is
+		 * simply replaced with a new, updated copy in both memslot sets.
 		 *
-		 * Since we aren't going to be changing the memslot gfn we can
-		 * simply use kvm_copy_replace_memslot(), which will use
-		 * rb_replace_node() to switch the memslot node in the gfn tree
-		 * instead of removing the old one and inserting the new one
-		 * as two separate operations.
-		 * It's a performance win since node replacement is a single
-		 * O(1) operation as opposed to two O(log(n)) operations for
-		 * slot removal and then re-insertion.
+		 * Since the memslot gfn is unchanged, kvm_copy_replace_memslot()
+		 * and kvm_memslot_gfn_replace() can be used to switch the node
+		 * in the gfn tree instead of removing the old and inserting the
+		 * new as two separate operations.  Replacement is a single O(1)
+		 * operation versus two O(log(n)) operations for remove+insert.
 		 */
-		kvm_copy_replace_memslot(kvm, as_id, idxina, slotact, slotina);
-		slotina->flags = new->flags;
-		slotina->dirty_bitmap = new->dirty_bitmap;
+		kvm_copy_memslot(tmp, slot);
+		tmp->flags = new->flags;
+		tmp->dirty_bitmap = new->dirty_bitmap;
 		/* kvm_arch_prepare_memory_region() might have modified arch */
-		slotina->arch = new->arch;
+		tmp->arch = new->arch;
+		kvm_replace_memslot(inactive, slot, tmp);
 
-		/* Swap the active <-> inactive memslot set. */
-		swap_memslots(kvm, as_id);
-		swap(idxact, idxina);
-		swap(slotsina, slotsact);
-		swap(slotact, slotina);
-
-		/*
-		 * Replace the old memslot in the other memslot set and
-		 * then finally free it.
-		 */
-		kvm_replace_memslot(kvm, as_id, idxina, slotina, slotact);
-		kfree(slotina);
+		kvm_activate_memslot(kvm, as_id, &active, &inactive, slot, tmp);
 	} else if (change == KVM_MR_CREATE) {
 		/*
-		 * Add the new memslot to the current inactive set as a copy
-		 * of the provided new memslot data.
+		 * Add the new memslot to the inactive set as a copy of the
+		 * new memslot data provided by userspace.
 		 */
-		kvm_copy_memslot(slotina, new);
-		kvm_init_memslot_hva_ranges(slotina);
+		kvm_copy_memslot(tmp, new);
+		kvm_replace_memslot(inactive, NULL, tmp);
 
-		kvm_replace_memslot(kvm, as_id, idxina, NULL, slotina);
-
-		/* Swap the active <-> inactive memslot set. */
-		swap_memslots(kvm, as_id);
-		swap(idxact, idxina);
-		swap(slotsina, slotsact);
-
-		/* Now add it also to the other memslot set */
-		kvm_replace_memslot(kvm, as_id, idxina, NULL, slotina);
+		kvm_activate_memslot(kvm, as_id, &active, &inactive, NULL, tmp);
 	} else if (change == KVM_MR_DELETE) {
 		/*
-		 * Remove the old memslot from the current inactive set
-		 * (the other, active set contains the temporary
-		 * KVM_MEMSLOT_INVALID slot)
-		 */
-		kvm_replace_memslot(kvm, as_id, idxina, slotina, NULL);
-
-		/* Swap the active <-> inactive memslot set. */
-		swap_memslots(kvm, as_id);
-		swap(idxact, idxina);
-		swap(slotsina, slotsact);
-		swap(slotact, slotina);
-
-		/* Remove the temporary KVM_MEMSLOT_INVALID slot and free it. */
-		kvm_replace_memslot(kvm, as_id, idxina, slotina, NULL);
-		kfree(slotina);
-		/* slotact will be freed by kvm_free_memslot() */
-	} else
+		 * Remove the old memslot (in the inactive memslots) and activate
+		 * the NULL slot.
+		*/
+		kvm_replace_memslot(inactive, tmp, NULL);
+		kvm_activate_memslot(kvm, as_id, &active, &inactive, slot, NULL);
+	} else {
 		BUG();
+	}
 
 	kvm_arch_commit_memory_region(kvm, mem, old, new, change);
 
+	/*
+	 * Free the memslot and its metadata.  Note, slot and tmp hold the same
+	 * metadata, but slot is freed as part of activation.  It's tmp's turn.
+	 */
 	if (change == KVM_MR_DELETE)
-		kvm_free_memslot(kvm, slotact);
+		kvm_free_memslot(kvm, tmp);
 
 	return 0;
-
-out_slots:
-	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
-		swap_memslots(kvm, as_id);
-		swap(idxact, idxina);
-		swap(slotsina, slotsact);
-		swap(slotact, slotina);
-
-		kvm_replace_memslot(kvm, as_id, idxina, slotina, slotact);
-	}
-	kfree(slotina);
-
-	return r;
 }
 
 static int kvm_delete_memslot(struct kvm *kvm,
-- 
2.32.0.rc0.204.g9fa02ecfa5-goog


--3zAiiMgFZmQFHLbv--
