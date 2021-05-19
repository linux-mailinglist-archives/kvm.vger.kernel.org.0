Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE375389996
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 01:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbhESXIa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 19:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhESXI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 19:08:29 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23616C06175F
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 16:07:09 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id s20so7909255plr.13
        for <kvm@vger.kernel.org>; Wed, 19 May 2021 16:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RyfmXcmpiPf29zi7Cou4H0ygilUNz1aN0mITS576Vy8=;
        b=p5kMLOk18AUGUrUrS4DlS27GN3nypoHJTs+FtdrccTagn+H1860CPR39MOF6TjlTqU
         SDMnN0WGV3oOSuEt2l1EIvQkhZwCuHWhur6mLeTCa46lcJHHs9HMCPUnEB+P9bj89pmk
         T3F8+5or506sH8OOj63imrYap+w2KjNxgoKFeDDQdT2HjvsRxPggXk1L6+OkqacbZO05
         o1jmT9rJ6a1z0x2IGCR6kKG46wfSxu/bUHRgHR5cubhhsc+NyFIkf7K9ID0nHZ1hliCx
         7DPIwq38FBONTOArY4n2qKTZ/kc+BtO7l2S2ifYuA2N2hRHPtfoO0cY7C4T7lwMt4sCr
         57ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RyfmXcmpiPf29zi7Cou4H0ygilUNz1aN0mITS576Vy8=;
        b=DaxUhAtH1EATR2FRQIfQ2cvc6H8ySsxPp2n4BclQ39wpA+Y1VTP++0nYlt9P7pjGmS
         tfH/BDrEtsOFJVpy7ldKBUZ/ZkHnGafFfjdCl8I5FHTXwyi0CbjStB/8KR+mWxrDLZ1X
         C95UbESS6AGlrXfSiO991EDHb2ngk8trEdyRqTs7/tfwhLeuxBzGnhEAgJfk1VF1rW0E
         uZShXqugaKj8SEo0Ou/tF8/IonA/ohnSKnIIovY0qxwcW/yR5yc0F6d8hj72CXhWOWKb
         UanEfpzevQhyFyL0cZFILdDOYRv8qF7J8bQFxqZ3TlRLX4/RyWMONpQp2hkrlLQrQI8R
         nlfw==
X-Gm-Message-State: AOAM531+v+OeJzYH0UzqxT0nyUG/I1Zp4jB9vqXerJDV9tmh8jpFD0fe
        rUKPX2zSvgib2mqTnWkmrUK2Mg==
X-Google-Smtp-Source: ABdhPJxjoEmuhKpbT9CNsCXuUywm9ANtXixVppamuWzDYfOBD0teEaYiYmjSMSTgmIlvJzEcGHYpfg==
X-Received: by 2002:a17:90a:8816:: with SMTP id s22mr1733707pjn.25.1621465628405;
        Wed, 19 May 2021 16:07:08 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id l67sm340936pgl.18.2021.05.19.16.07.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 16:07:07 -0700 (PDT)
Date:   Wed, 19 May 2021 23:07:03 +0000
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
Subject: Re: [PATCH v3 4/8] KVM: Introduce memslots hva tree
Message-ID: <YKWaFwgMNSaQQuQP@google.com>
References: <cover.1621191549.git.maciej.szmigiero@oracle.com>
 <cf1695b3e1ba495a4d23cbdc66e0fa9b7b535cc3.1621191551.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf1695b3e1ba495a4d23cbdc66e0fa9b7b535cc3.1621191551.git.maciej.szmigiero@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nit: something like "KVM: Use interval tree to do fast hva lookup in memslots"
would be more helpful when perusing the shortlogs.  Stating that a tree is being
added doesn't provide any hint as to why, or even the what is somewhat unclear.

On Sun, May 16, 2021, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> The current memslots implementation only allows quick binary search by gfn,
> quick lookup by hva is not possible - the implementation has to do a linear
> scan of the whole memslots array, even though the operation being performed
> might apply just to a single memslot.
> 
> This significantly hurts performance of per-hva operations with higher
> memslot counts.
> 
> Since hva ranges can overlap between memslots an interval tree is needed
> for tracking them.
> 
> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> ---

...

> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d3a35646dfd8..f59847b6e9b3 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -27,6 +27,7 @@
>  #include <linux/rcuwait.h>
>  #include <linux/refcount.h>
>  #include <linux/nospec.h>
> +#include <linux/interval_tree.h>
>  #include <linux/hashtable.h>
>  #include <asm/signal.h>
>  
> @@ -358,6 +359,7 @@ static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
>  
>  struct kvm_memory_slot {
>  	struct hlist_node id_node;
> +	struct interval_tree_node hva_node;
>  	gfn_t base_gfn;
>  	unsigned long npages;
>  	unsigned long *dirty_bitmap;
> @@ -459,6 +461,7 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
>   */
>  struct kvm_memslots {
>  	u64 generation;
> +	struct rb_root_cached hva_tree;
>  	/* The mapping table from slot id to the index in memslots[]. */
>  	DECLARE_HASHTABLE(id_hash, 7);
>  	atomic_t lru_slot;
> @@ -679,6 +682,11 @@ static inline struct kvm_memslots *kvm_vcpu_memslots(struct kvm_vcpu *vcpu)
>  	return __kvm_memslots(vcpu->kvm, as_id);
>  }
>  
> +#define kvm_for_each_hva_range_memslot(node, slots, start, last)	     \

kvm_for_each_memslot_in_range()?  Or kvm_for_each_memslot_in_hva_range()?

Please add a comment about whether start is inclusive or exclusive.

I'd also be in favor of hiding this in kvm_main.c, just above the MMU notifier
usage.  It'd be nice to discourage arch code from adding lookups that more than
likely belong in generic code.

> +	for (node = interval_tree_iter_first(&slots->hva_tree, start, last); \
> +	     node;							     \
> +	     node = interval_tree_iter_next(node, start, last))	     \
> +
>  static inline
>  struct kvm_memory_slot *id_to_memslot(struct kvm_memslots *slots, int id)
>  {
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 50f9bc9bb1e0..a55309432c9a 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -488,6 +488,9 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
>  	struct kvm_memslots *slots;
>  	int i, idx;
>  
> +	if (range->end == range->start || WARN_ON(range->end < range->staart))

I'm pretty sure both of these are WARNable offenses, i.e. they can be combined.
It'd also be a good idea to use WARN_ON_ONCE(); if a caller does manage to
trigger this, odds are good it will get spammed.

Also, does interval_tree_iter_first() explode if given bad inputs?  If not, I'd
probably say just omit this entirely.  If it does explode, it might be a good idea
to work the sanity check into the macro, even if the macro is hidden here.

> +		return 0;
> +
>  	/* A null handler is allowed if and only if on_lock() is provided. */
>  	if (WARN_ON_ONCE(IS_KVM_NULL_FN(range->on_lock) &&
>  			 IS_KVM_NULL_FN(range->handler)))
> @@ -507,15 +510,18 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
>  	}
>  
>  	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> +		struct interval_tree_node *node;
> +
>  		slots = __kvm_memslots(kvm, i);
> -		kvm_for_each_memslot(slot, slots) {
> +		kvm_for_each_hva_range_memslot(node, slots,
> +					       range->start, range->end - 1) {
>  			unsigned long hva_start, hva_end;
>  
> +			slot = container_of(node, struct kvm_memory_slot,
> +					    hva_node);

Eh, let that poke out.  The 80 limit is more of a guideline.

>  			hva_start = max(range->start, slot->userspace_addr);
>  			hva_end = min(range->end, slot->userspace_addr +
>  						  (slot->npages << PAGE_SHIFT));
> -			if (hva_start >= hva_end)
> -				continue;
>  
>  			/*
>  			 * To optimize for the likely case where the address
> @@ -787,6 +793,7 @@ static struct kvm_memslots *kvm_alloc_memslots(void)
>  	if (!slots)
>  		return NULL;
>  
> +	slots->hva_tree = RB_ROOT_CACHED;
>  	hash_init(slots->id_hash);
>  
>  	return slots;
> @@ -1113,10 +1120,14 @@ static inline void kvm_memslot_delete(struct kvm_memslots *slots,
>  		atomic_set(&slots->lru_slot, 0);
>  
>  	for (i = dmemslot - mslots; i < slots->used_slots; i++) {
> +		interval_tree_remove(&mslots[i].hva_node, &slots->hva_tree);
>  		hash_del(&mslots[i].id_node);

I think it would make sense to add helpers for these?  Not sure I like the names,
but it would certainly dedup the code a bit.

static void kvm_memslot_remove(struct kvm_memslots *slots,
			       struct kvm_memslot *memslot)
{
	interval_tree_remove(&memslot->hva_node, &slots->hva_tree);
	hash_del(&memslot->id_node);
}

static void kvm_memslot_insert(struct kvm_memslots *slots,
			       struct kvm_memslot *memslot)
{
	interval_tree_insert(&memslot->hva_node, &slots->hva_tree);
	hash_add(slots->id_hash, &memslot->id_node, memslot->id);
}

> +
>  		mslots[i] = mslots[i + 1];
> +		interval_tree_insert(&mslots[i].hva_node, &slots->hva_tree);
>  		hash_add(slots->id_hash, &mslots[i].id_node, mslots[i].id);
>  	}
> +	interval_tree_remove(&mslots[i].hva_node, &slots->hva_tree);
>  	hash_del(&mslots[i].id_node);
>  	mslots[i] = *memslot;
>  }
