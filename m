Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D27C938995A
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 00:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbhESWdG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 18:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbhESWdF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 18:33:05 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3EAC061574
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 15:31:44 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id b15-20020a17090a550fb029015dad75163dso4216119pji.0
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 15:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3Vx7mu6+ZNKXXoJYS7AVN4Z/38zh285y5Q+544/T8iY=;
        b=XxRkDCdm53sGRGyY2ZYwH7T0AQIXefX6uNKZpOorQU6EQHDGclhTmzcnRR6oEpDkR9
         hwPcnNL8Se68VX1SNb6obITM1ng2MKcYq5VQR2zlZY9YhMGuM2rCq6YcajdUhwbxUO7Y
         bK/rEBsN13eh0y/NjU4uawPATIAhV0LA5d+niD5nZhN+5FE9+OuHWhtyWPV/hbb0PmPG
         +B84rQsB0fU8U+7/wut17hQ+LErazbfphlbqrM3DPC74TDrcpOxxe304ZjkYT7sRhcRV
         SHb/lli5vqmguWhu5YcbIk0NxcpbotFtdUkZ2s03CqKo5KaDfVGHmW9JxskcnQCqC2Tl
         S9cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3Vx7mu6+ZNKXXoJYS7AVN4Z/38zh285y5Q+544/T8iY=;
        b=ZWMEP/g6+mki0zo3/+pEHE1ymIrMvRs07Q6INfFyMtiwGs1iciKwkzTXfOW18BiXZM
         o6Ek6RfbMDNOI6//mayjg7PVGFAlkUuB1gZLkgNA6Jq2uWxZPMWPlpzoxK15Uvs1XvRV
         SdwHEAaAnyyNtSYXaIdius7jcN1HV7xyC068321U2kJL+QJY7W4QZ91osjliUudHjbnv
         GGXpaE9Xj2OSEMdyLl5IZYqPidvvd/lafZ8j7hk+z1eIw3xv3Gf7mdsbbHrdhTJD65sW
         HK5RkGzqnZPUhXQ/riGsbuu2Cfw7GhOalPfWWFURKPBXIvx0sUnhA0KYnQQH0zvDst6j
         J7SQ==
X-Gm-Message-State: AOAM530c0ZPuIbVquved3LAnrU7pVHJxfyuUOb2ezxXD3t0xZCXo6fA+
        BIrHG6HplUnZTkVZTMhbDLcXWQ==
X-Google-Smtp-Source: ABdhPJyVa57WZ7TUt99IukPmtNkvrFPQqB+ptTfQty0q1rI/EXjLODYRKiJfCeImcIvIJxb0mHjLaQ==
X-Received: by 2002:a17:902:d507:b029:f2:c88c:5b45 with SMTP id b7-20020a170902d507b02900f2c88c5b45mr2080651plg.66.1621463503306;
        Wed, 19 May 2021 15:31:43 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id ge5sm971996pjb.45.2021.05.19.15.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 15:31:42 -0700 (PDT)
Date:   Wed, 19 May 2021 22:31:38 +0000
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
Subject: Re: [PATCH v3 3/8] KVM: Resolve memslot ID via a hash table instead
 of via a static array
Message-ID: <YKWRyvyyO5UAHv4U@google.com>
References: <cover.1621191549.git.maciej.szmigiero@oracle.com>
 <4a4867419344338e1419436af1e1b0b8f2405517.1621191551.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a4867419344338e1419436af1e1b0b8f2405517.1621191551.git.maciej.szmigiero@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, May 16, 2021, Maciej S. Szmigiero wrote:
> @@ -356,6 +357,7 @@ static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
>  #define KVM_MEM_MAX_NR_PAGES ((1UL << 31) - 1)
>  
>  struct kvm_memory_slot {
> +	struct hlist_node id_node;
>  	gfn_t base_gfn;
>  	unsigned long npages;
>  	unsigned long *dirty_bitmap;
> @@ -458,7 +460,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
>  struct kvm_memslots {
>  	u64 generation;
>  	/* The mapping table from slot id to the index in memslots[]. */
> -	short id_to_index[KVM_MEM_SLOTS_NUM];
> +	DECLARE_HASHTABLE(id_hash, 7);

Is there any specific motivation for using 7 bits?

>  	atomic_t lru_slot;
>  	int used_slots;
>  	struct kvm_memory_slot memslots[];

...

> @@ -1097,14 +1095,16 @@ static int kvm_alloc_dirty_bitmap(struct kvm_memory_slot *memslot)
>  /*
>   * Delete a memslot by decrementing the number of used slots and shifting all
>   * other entries in the array forward one spot.
> + * @memslot is a detached dummy struct with just .id and .as_id filled.
>   */
>  static inline void kvm_memslot_delete(struct kvm_memslots *slots,
>  				      struct kvm_memory_slot *memslot)
>  {
>  	struct kvm_memory_slot *mslots = slots->memslots;
> +	struct kvm_memory_slot *dmemslot = id_to_memslot(slots, memslot->id);

I vote to call these local vars "old", or something along those lines.  dmemslot
isn't too bad, but mmemslot in the helpers below is far too similar to memslot,
and using the wrong will cause nasty explosions.

>  	int i;
>  
> -	if (WARN_ON(slots->id_to_index[memslot->id] == -1))
> +	if (WARN_ON(!dmemslot))
>  		return;
>  
>  	slots->used_slots--;
> @@ -1112,12 +1112,13 @@ static inline void kvm_memslot_delete(struct kvm_memslots *slots,
>  	if (atomic_read(&slots->lru_slot) >= slots->used_slots)
>  		atomic_set(&slots->lru_slot, 0);
>  
> -	for (i = slots->id_to_index[memslot->id]; i < slots->used_slots; i++) {
> +	for (i = dmemslot - mslots; i < slots->used_slots; i++) {
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
> @@ -1135,31 +1136,41 @@ static inline int kvm_memslot_insert_back(struct kvm_memslots *slots)
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
>  	int i;
>  
> -	if (WARN_ON_ONCE(slots->id_to_index[memslot->id] == -1) ||
> +	if (WARN_ON_ONCE(!mmemslot) ||
>  	    WARN_ON_ONCE(!slots->used_slots))
>  		return -1;
>  
> +	/*
> +	 * update_memslots() will unconditionally overwrite and re-add the
> +	 * target memslot so it has to be removed here firs
> +	 */

It would be helpful to explain "why" this is necessary.  Something like:

	/*
	 * The memslot is being moved, delete its previous hash entry; its new
	 * entry will be added by updated_memslots().  The old entry cannot be
	 * kept even though its id is unchanged, because the old entry points at
	 * the memslot in the old instance of memslots.
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
> @@ -1170,6 +1181,10 @@ static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
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
> @@ -1185,8 +1200,9 @@ static inline int kvm_memslot_move_forward(struct kvm_memslots *slots,
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
> @@ -1231,6 +1247,9 @@ static inline int kvm_memslot_move_forward(struct kvm_memslots *slots,
>   * most likely to be referenced, sorting it to the front of the array was
>   * advantageous.  The current binary search starts from the middle of the array
>   * and uses an LRU pointer to improve performance for all memslots and GFNs.
> + *
> + * @memslot is a detached struct, not a part of the current or new memslot
> + * array.
>   */
>  static void update_memslots(struct kvm_memslots *slots,
>  			    struct kvm_memory_slot *memslot,
> @@ -1247,12 +1266,16 @@ static void update_memslots(struct kvm_memslots *slots,
>  			i = kvm_memslot_move_backward(slots, memslot);
>  		i = kvm_memslot_move_forward(slots, memslot, i);
>  
> +		if (i < 0)
> +			return;

Hmm, this is essentially a "fix" to existing code, it should be in a separate
patch.  And since kvm_memslot_move_forward() can theoretically hit this even if
kvm_memslot_move_backward() doesn't return -1, i.e. doesn't WARN, what about
doing WARN_ON_ONCE() here and dropping the WARNs in kvm_memslot_move_backward()?
It'll be slightly less developer friendly, but anyone that has the unfortunate
pleasure of breaking and debugging this code is already in for a world of pain.

> +
>  		/*
>  		 * Copy the memslot to its new position in memslots and update
>  		 * its index accordingly.
>  		 */
>  		slots->memslots[i] = *memslot;
> -		slots->id_to_index[memslot->id] = i;
> +		hash_add(slots->id_hash, &slots->memslots[i].id_node,
> +			 memslot->id);
>  	}
>  }
>  
> @@ -1316,6 +1339,7 @@ static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
>  {
>  	struct kvm_memslots *slots;
>  	size_t old_size, new_size;
> +	struct kvm_memory_slot *memslot;
>  
>  	old_size = sizeof(struct kvm_memslots) +
>  		   (sizeof(struct kvm_memory_slot) * old->used_slots);
> @@ -1326,8 +1350,14 @@ static struct kvm_memslots *kvm_dup_memslots(struct kvm_memslots *old,
>  		new_size = old_size;
>  
>  	slots = kvzalloc(new_size, GFP_KERNEL_ACCOUNT);
> -	if (likely(slots))
> -		memcpy(slots, old, old_size);
> +	if (unlikely(!slots))
> +		return NULL;
> +
> +	memcpy(slots, old, old_size);
> +
> +	hash_init(slots->id_hash);
> +	kvm_for_each_memslot(memslot, slots)
> +		hash_add(slots->id_hash, &memslot->id_node, memslot->id);

What's the perf penalty if the number of memslots gets large?  I ask because the
lazy rmap allocation is adding multiple calls to kvm_dup_memslots().

>  	return slots;
>  }
