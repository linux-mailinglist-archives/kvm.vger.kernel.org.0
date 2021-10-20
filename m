Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B02E43429F
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 02:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbhJTApk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 20:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbhJTApj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Oct 2021 20:45:39 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68CE0C061746
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 17:43:26 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id np13so1212618pjb.4
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 17:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1/40PQFDb+y3m4beIXTq/hWGhTdDDwvqdm6zZvMimjw=;
        b=fAfL88L+0aIv71jt1MrDY0DVrQvY2KLcJACmBgaQDVV9+0ql7dSnrjJkSWj1gdb/xq
         5njS3yKjPEc/Th481cwI7JIhpUtM4w7BJUbXm9T7tfoerzrpqu48PJVjNbx7nvADN/8z
         08xteRK+JnmCVQc9fhPQ2J9u6xIwGSl9ltep5ks/VXmvuj2C1Axdpx0qNIxkT9tW7D//
         S2yH0N+/JM931T2F0SnBcUzNn5kjJy3oMuvlAz3dz/hwozzImizORf/5TB8T+mTXWx7N
         A2x+pqgNs8Blo2e5YD4tZmz9ritYlxAxZkhQAZ237WHu6D+sEj5hNw2dY5v+3iefZHxQ
         e5bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1/40PQFDb+y3m4beIXTq/hWGhTdDDwvqdm6zZvMimjw=;
        b=zczjVlSZ8W3l1eqATk2wzGGybBfXA2Ur/TfM1NZ69nvjevq5WAygPTux928DaxqFOt
         hEACvDJXUnBbez+/lT9SOEgQ76SW2VLJTAXp4+VSEIxNpi99exQz4JvAoBDiN0nYGCXY
         VERDNTq3Kba1DD9DVII4GKt7K95u47TEF8oGoCbtb/LvV/1+y9mepa1+IOd7+HE/1Ji7
         QCfPMAm9Ih9QffVtlpcWxGZoaiIrjEQ1uNdqHnIxLjS4gHZiNHlYoXMW9djnJcsAxaXh
         CMAmJeA8GcZf1DJ4i0So23ISt7VaHK/Y//fwI0DNuF/4AD6vziqsEktSDsjzTHjbolTO
         8MQw==
X-Gm-Message-State: AOAM530uERBfQ6/DvvaNqOYQxqHwbrbiayKO9m8A02VpEuxsqqL9J3xu
        0m3pC0PNGoiKM91b7NLx9vOQ4Q==
X-Google-Smtp-Source: ABdhPJyXjD5MCXD+7NNFQhqbnscjDnG2Uxfh29VZOOF5Hdx50r+7f3voUnCTcD8w+6J5p0jiOx+IPw==
X-Received: by 2002:a17:902:c409:b0:13f:1a43:c5c with SMTP id k9-20020a170902c40900b0013f1a430c5cmr35892723plk.40.1634690605624;
        Tue, 19 Oct 2021 17:43:25 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h19sm391637pfv.81.2021.10.19.17.43.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 17:43:25 -0700 (PDT)
Date:   Wed, 20 Oct 2021 00:43:21 +0000
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
Subject: Re: [PATCH v5 08/13] KVM: Resolve memslot ID via a hash table
 instead of via a static array
Message-ID: <YW9mKTRBEABjGPp7@google.com>
References: <cover.1632171478.git.maciej.szmigiero@oracle.com>
 <555f58fdaec120aa7a6f6fbad06cca796a8c9168.1632171479.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <555f58fdaec120aa7a6f6fbad06cca796a8c9168.1632171479.git.maciej.szmigiero@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 20, 2021, Maciej S. Szmigiero wrote:
> ---
>  include/linux/kvm_host.h | 16 +++++------
>  virt/kvm/kvm_main.c      | 61 +++++++++++++++++++++++++++++++---------
>  2 files changed, 55 insertions(+), 22 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 8fd9644f40b2..d2acc00a6472 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -29,6 +29,7 @@
>  #include <linux/refcount.h>
>  #include <linux/nospec.h>
>  #include <linux/notifier.h>
> +#include <linux/hashtable.h>
>  #include <asm/signal.h>
>  
>  #include <linux/kvm.h>
> @@ -426,6 +427,7 @@ static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
>  #define KVM_MEM_MAX_NR_PAGES ((1UL << 31) - 1)
>  
>  struct kvm_memory_slot {
> +	struct hlist_node id_node;
>  	gfn_t base_gfn;
>  	unsigned long npages;
>  	unsigned long *dirty_bitmap;
> @@ -528,7 +530,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
>  struct kvm_memslots {
>  	u64 generation;
>  	/* The mapping table from slot id to the index in memslots[]. */
> -	short id_to_index[KVM_MEM_SLOTS_NUM];
> +	DECLARE_HASHTABLE(id_hash, 7);

Can you add a comment explaining the rationale for size "7"?  Not necessarily the
justification in choosing "7", more so the tradeoffs between performance, memory,
etc... so that all your work/investigation isn't lost and doesn't have to be repeated
if someone wants to tweak this in the future.

>  	atomic_t last_used_slot;
>  	int used_slots;
>  	struct kvm_memory_slot memslots[];
> @@ -795,16 +797,14 @@ static inline struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu)
>  static inline
>  struct kvm_memory_slot *id_to_memslot(struct kvm_memslots *slots, int id)
>  {
> -	int index = slots->id_to_index[id];
>  	struct kvm_memory_slot *slot;
>  
> -	if (index < 0)
> -		return NULL;
> -
> -	slot = &slots->memslots[index];
> +	hash_for_each_possible(slots->id_hash, slot, id_node, id) {
> +		if (slot->id == id)
> +			return slot;

Hmm, related to the hash, it might be worth adding a stat here to count collisions.
Might be more pain than it's worth though since we don't have @kvm.

> +	}
>  
> -	WARN_ON(slot->id != id);
> -	return slot;
> +	return NULL;
>  }
>  
>  /*
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 48d182840060..50597608d085 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -827,15 +827,13 @@ static void kvm_destroy_pm_notifier(struct kvm *kvm)
>  
>  static struct kvm_memslots *kvm_alloc_memslots(void)
>  {
> -	int i;
>  	struct kvm_memslots *slots;
>  
>  	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
>  	if (!slots)
>  		return NULL;
>  
> -	for (i = 0; i < KVM_MEM_SLOTS_NUM; i++)
> -		slots->id_to_index[i] = -1;
> +	hash_init(slots->id_hash);
>  
>  	return slots;
>  }
> @@ -1236,14 +1234,16 @@ static int kvm_alloc_dirty_bitmap(struct kvm_memory_slot *memslot)
>  /*
>   * Delete a memslot by decrementing the number of used slots and shifting all
>   * other entries in the array forward one spot.
> + * @memslot is a detached dummy struct with just .id and .as_id filled.
>   */
>  static inline void kvm_memslot_delete(struct kvm_memslots *slots,
>  				      struct kvm_memory_slot *memslot)
>  {
>  	struct kvm_memory_slot *mslots = slots->memslots;
> +	struct kvm_memory_slot *oldslot = id_to_memslot(slots, memslot->id);
>  	int i;
>  
> -	if (WARN_ON(slots->id_to_index[memslot->id] == -1))
> +	if (WARN_ON(!oldslot))
>  		return;
>  
>  	slots->used_slots--;
> @@ -1251,12 +1251,13 @@ static inline void kvm_memslot_delete(struct kvm_memslots *slots,
>  	if (atomic_read(&slots->last_used_slot) >= slots->used_slots)
>  		atomic_set(&slots->last_used_slot, 0);
>  
> -	for (i = slots->id_to_index[memslot->id]; i < slots->used_slots; i++) {
> +	for (i = oldslot - mslots; i < slots->used_slots; i++) {
> +		hash_del(&mslots[i].id_node);
>  		mslots[i] = mslots[i + 1];
> -		slots->id_to_index[mslots[i].id] = i;
> +		hash_add(slots->id_hash, &mslots[i].id_node, mslots[i].id);
>  	}
> +	hash_del(&mslots[i].id_node);
>  	mslots[i] = *memslot;
> -	slots->id_to_index[memslot->id] = -1;
>  }
>  
>  /*
> @@ -1274,30 +1275,46 @@ static inline int kvm_memslot_insert_back(struct kvm_memslots *slots)
>   * itself is not preserved in the array, i.e. not swapped at this time, only
>   * its new index into the array is tracked.  Returns the changed memslot's
>   * current index into the memslots array.
> + * The memslot at the returned index will not be in @slots->id_hash by then.
> + * @memslot is a detached struct with desired final data of the changed slot.
>   */
>  static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
>  					    struct kvm_memory_slot *memslot)
>  {
>  	struct kvm_memory_slot *mslots = slots->memslots;
> +	struct kvm_memory_slot *mmemslot = id_to_memslot(slots, memslot->id);

My comment from v3 about the danger of "mmemslot" still stands.  FWIW, I dislike
"mslots" as well, but that predates me, and all of this will go away in the end :-)

On Wed, May 19, 2021 at 3:31 PM Sean Christopherson <seanjc@google.com> wrote:
> On Sun, May 16, 2021, Maciej S. Szmigiero wrote:
> >       struct kvm_memory_slot *mslots = slots->memslots;
> > +     struct kvm_memory_slot *dmemslot = id_to_memslot(slots, memslot->id);
>
> I vote to call these local vars "old", or something along those lines.  dmemslot
> isn't too bad, but mmemslot in the helpers below is far too similar to memslot,
> and using the wrong will cause nasty explosions.


>  	int i;
>  
> -	if (slots->id_to_index[memslot->id] == -1 || !slots->used_slots)
> +	if (!mmemslot || !slots->used_slots)
>  		return -1;
>  
> +	/*
> +	 * The loop below will (possibly) overwrite the target memslot with
> +	 * data of the next memslot, or a similar loop in
> +	 * kvm_memslot_move_forward() will overwrite it with data of the
> +	 * previous memslot.
> +	 * Then update_memslots() will unconditionally overwrite and re-add
> +	 * it to the hash table.
> +	 * That's why the memslot has to be first removed from the hash table
> +	 * here.
> +	 */

Is this reword accurate?

	/*
	 * Delete the slot from the hash table before sorting the remaining
	 * slots, the slot's data may be overwritten when copying slots as part
	 * of the sorting proccess.  update_memslots() will unconditionally
	 * rewrite the entire slot and re-add it to the hash table.
	 */

> +	hash_del(&mmemslot->id_node);
> +
>  	/*
>  	 * Move the target memslot backward in the array by shifting existing
>  	 * memslots with a higher GFN (than the target memslot) towards the
>  	 * front of the array.
>  	 */
> -	for (i = slots->id_to_index[memslot->id]; i < slots->used_slots - 1; i++) {
> +	for (i = mmemslot - mslots; i < slots->used_slots - 1; i++) {
>  		if (memslot->base_gfn > mslots[i + 1].base_gfn)
>  			break;
>  
>  		WARN_ON_ONCE(memslot->base_gfn == mslots[i + 1].base_gfn);
>  
>  		/* Shift the next memslot forward one and update its index. */
> +		hash_del(&mslots[i + 1].id_node);
>  		mslots[i] = mslots[i + 1];
> -		slots->id_to_index[mslots[i].id] = i;
> +		hash_add(slots->id_hash, &mslots[i].id_node, mslots[i].id);
>  	}
>  	return i;
>  }
> @@ -1308,6 +1325,10 @@ static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
>   * is not preserved in the array, i.e. not swapped at this time, only its new
>   * index into the array is tracked.  Returns the changed memslot's final index
>   * into the memslots array.
> + * The memslot at the returned index will not be in @slots->id_hash by then.
> + * @memslot is a detached struct with desired final data of the new or
> + * changed slot.
> + * Assumes that the memslot at @start index is not in @slots->id_hash.
>   */
>  static inline int kvm_memslot_move_forward(struct kvm_memslots *slots,
>  					   struct kvm_memory_slot *memslot,
> @@ -1323,8 +1344,9 @@ static inline int kvm_memslot_move_forward(struct kvm_memslots *slots,
>  		WARN_ON_ONCE(memslot->base_gfn == mslots[i - 1].base_gfn);
>  
>  		/* Shift the next memslot back one and update its index. */
> +		hash_del(&mslots[i - 1].id_node);
>  		mslots[i] = mslots[i - 1];
> -		slots->id_to_index[mslots[i].id] = i;
> +		hash_add(slots->id_hash, &mslots[i].id_node, mslots[i].id);
>  	}
>  	return i;
>  }
> @@ -1369,6 +1391,9 @@ static inline int kvm_memslot_move_forward(struct kvm_memslots *slots,
>   * most likely to be referenced, sorting it to the front of the array was
>   * advantageous.  The current binary search starts from the middle of the array
>   * and uses an LRU pointer to improve performance for all memslots and GFNs.
> + *
> + * @memslot is a detached struct, not a part of the current or new memslot
> + * array.
>   */
>  static void update_memslots(struct kvm_memslots *slots,
>  			    struct kvm_memory_slot *memslot,
> @@ -1393,7 +1418,8 @@ static void update_memslots(struct kvm_memslots *slots,
>  		 * its index accordingly.
>  		 */
>  		slots->memslots[i] = *memslot;
> -		slots->id_to_index[memslot->id] = i;
> +		hash_add(slots->id_hash, &slots->memslots[i].id_node,
> +			 memslot->id);

Let this poke out past 80 chars, i.e. drop the newline.

>  	}
>  }
>  
> @@ -1501,6 +1527,7 @@ static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
>  {
>  	struct kvm_memslots *slots;
>  	size_t new_size;
> +	struct kvm_memory_slot *memslot;
>  
>  	if (change == KVM_MR_CREATE)
>  		new_size = kvm_memslots_size(old->used_slots + 1);
> @@ -1508,8 +1535,14 @@ static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
>  		new_size = kvm_memslots_size(old->used_slots);
>  
>  	slots = kvzalloc(new_size, GFP_KERNEL_ACCOUNT);
> -	if (likely(slots))
> -		kvm_copy_memslots(slots, old);
> +	if (unlikely(!slots))
> +		return NULL;
> +
> +	kvm_copy_memslots(slots, old);
> +
> +	hash_init(slots->id_hash);
> +	kvm_for_each_memslot(memslot, slots)
> +		hash_add(slots->id_hash, &memslot->id_node, memslot->id);
>  
>  	return slots;
>  }
