Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC25A37AF41
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 21:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232180AbhEKTW2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 15:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbhEKTW0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 15:22:26 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47703C061574
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 12:21:19 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id bo23-20020a17090b0917b029015cb1f2fd59so354608pjb.2
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 12:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dwK1U82Cni7ccV8S1qKjUSfRYwWW4lzwAOYn1poHEnE=;
        b=sk3YhdkvbA1SaAdIaY8XtPgZhzp5if6gZsVktrwmAlk4vLeKRaEFZ2/W4c0un4F7UB
         tXU+wh+T3Y26bvGyaf7YPFO1K7fVKMii3WeUSzGmNGzackuEcPZ9HceQtkH7s0pkEcqI
         Rw2mociqQnqqQUnxyhk/6Huo+4PFEwz8eoHxhEBvdGuFKzeEU/ex/J8y9t6R3GHCEpsN
         H4lNRUzfNr4i0FKldtxKaQfG9Ln0aCwNlYvh7Jdeyy9G8ErsTyOUaonJ9dVHY8Im3ajf
         p3AjV79Q6qS/cHBj4GdQ/UqRIRHiid+4w7MFYk3b7kAXhcpz5QG7BnVc/IbF9PaVPJoH
         /hyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dwK1U82Cni7ccV8S1qKjUSfRYwWW4lzwAOYn1poHEnE=;
        b=Hbch9BFq/3iBckhoNAak4fXXqJr9o76+rMd+aYP3Rla3PEkun+Gh20e2a7Z4VvehPn
         QBQjitsvIcn8jaHoczYFUGydNnsCqzezpwRFAqhh4R2uoWBSZQHX8nWzRoiljjuiEKzi
         DY1w7+ZVXoqJKRyhKx4opaIj9o1P28mXK3Ik8mAXIbiVnGv3OwaqJGkSOf9dYzWLKCa5
         NpjdJjlZdRKJH/IXAr30GBaxZQpJshEqy4phyPj4U66fLantIR4bFZOkjQWOLepYe0aK
         xFF0ZV9jp0uhnge9b9c6RU0IplDJvnfGXWflFEMBrlFzvvwcVVqCv6FK6FHyEFAOIFmD
         ENWg==
X-Gm-Message-State: AOAM533eb6AoR/j/ro8odchA6KJT5l3DHnMeWSqPe8BbrXlNTg6XK18D
        FjlFWPcvHIbdw/+XYrbJPlv59w==
X-Google-Smtp-Source: ABdhPJyCjbzdu6FoOm6qq9I9+ePVjPU+YpEnduGAknmNzx6r90OcHhE5yoFSVfwkkq/7z1nix8WXMg==
X-Received: by 2002:a17:90b:508:: with SMTP id r8mr17514714pjz.152.1620760878491;
        Tue, 11 May 2021 12:21:18 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id h4sm3008782pjc.12.2021.05.11.12.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 12:21:17 -0700 (PDT)
Date:   Tue, 11 May 2021 19:21:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v4 4/7] KVM: mmu: Add slots_arch_lock for memslot arch
 fields
Message-ID: <YJrZKkW9Cb9t+fU5@google.com>
References: <20210511171610.170160-1-bgardon@google.com>
 <20210511171610.170160-5-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511171610.170160-5-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021, Ben Gardon wrote:
> Add a new lock to protect the arch-specific fields of memslots if they
> need to be modified in a kvm->srcu read critical section. A future
> commit will use this lock to lazily allocate memslot rmaps for x86.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>  include/linux/kvm_host.h |  9 +++++++++
>  virt/kvm/kvm_main.c      | 31 ++++++++++++++++++++++++++-----
>  2 files changed, 35 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 8895b95b6a22..2d5e797fbb08 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -472,6 +472,15 @@ struct kvm {
>  #endif /* KVM_HAVE_MMU_RWLOCK */
>  
>  	struct mutex slots_lock;
> +
> +	/*
> +	 * Protects the arch-specific fields of struct kvm_memory_slots in
> +	 * use by the VM. To be used under the slots_lock (above) or in a
> +	 * kvm->srcu read cirtical section where acquiring the slots_lock
> +	 * would lead to deadlock with the synchronize_srcu in
> +	 * install_new_memslots.
> +	 */
> +	struct mutex slots_arch_lock;
>  	struct mm_struct *mm; /* userspace tied to this vm */
>  	struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
>  	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 9e106742b388..5c40d83754b1 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -908,6 +908,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
>  	mutex_init(&kvm->lock);
>  	mutex_init(&kvm->irq_lock);
>  	mutex_init(&kvm->slots_lock);
> +	mutex_init(&kvm->slots_arch_lock);
>  	INIT_LIST_HEAD(&kvm->devices);
>  
>  	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
> @@ -1280,6 +1281,10 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
>  	slots->generation = gen | KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS;
>  
>  	rcu_assign_pointer(kvm->memslots[as_id], slots);
> +
> +	/* Acquired in kvm_set_memslot. */
> +	mutex_unlock(&kvm->slots_arch_lock);
> +
>  	synchronize_srcu_expedited(&kvm->srcu);
>  
>  	/*
> @@ -1351,6 +1356,9 @@ static int kvm_set_memslot(struct kvm *kvm,
>  	struct kvm_memslots *slots;
>  	int r;
>  
> +	/* Released in install_new_memslots. */

This needs a much more comprehensive comment, either here or above the declaration
of slots_arch_lock.  I can't find anything that explicitly states the the lock
must be held from the time the previous memslots are duplicated/copied until the
new memslots are set.  Without that information, the rules/expecations are not
clear.

> +	mutex_lock(&kvm->slots_arch_lock);
> +
>  	slots = kvm_dup_memslots(__kvm_memslots(kvm, as_id), change);
>  	if (!slots)
>  		return -ENOMEM;

Fails to drop slots_arch_lock.

> @@ -1364,10 +1372,9 @@ static int kvm_set_memslot(struct kvm *kvm,
>  		slot->flags |= KVM_MEMSLOT_INVALID;
>  
>  		/*
> -		 * We can re-use the old memslots, the only difference from the
> -		 * newly installed memslots is the invalid flag, which will get
> -		 * dropped by update_memslots anyway.  We'll also revert to the
> -		 * old memslots if preparing the new memory region fails.
> +		 * We can re-use the memory from the old memslots.
> +		 * It will be overwritten with a copy of the new memslots
> +		 * after reacquiring the slots_arch_lock below.
>  		 */
>  		slots = install_new_memslots(kvm, as_id, slots);
>  
> @@ -1379,6 +1386,17 @@ static int kvm_set_memslot(struct kvm *kvm,
>  		 *	- kvm_is_visible_gfn (mmu_check_root)
>  		 */
>  		kvm_arch_flush_shadow_memslot(kvm, slot);
> +
> +		/* Released in install_new_memslots. */
> +		mutex_lock(&kvm->slots_arch_lock);
> +
> +		/*
> +		 * The arch-specific fields of the memslots could have changed
> +		 * between releasing the slots_arch_lock in
> +		 * install_new_memslots and here, so get a fresh copy of the
> +		 * slots.
> +		 */
> +		kvm_copy_memslots(__kvm_memslots(kvm, as_id), slots);

Ow.  This is feedback for a previous patch, but kvm_copy_memslots() absolutely
needs to swap the order of params to match memcpy(), i.e. @to is first, @from is
second.

>  	}
>  
>  	r = kvm_arch_prepare_memory_region(kvm, new, mem, change);
> @@ -1394,8 +1412,11 @@ static int kvm_set_memslot(struct kvm *kvm,
>  	return 0;
>  
>  out_slots:
> -	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE)
> +	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
> +		slot = id_to_memslot(slots, old->id);
> +		slot->flags &= ~KVM_MEMSLOT_INVALID;
>  		slots = install_new_memslots(kvm, as_id, slots);
> +	}

Fails to drop slots_arch_lock if kvm_arch_prepare_memory_region() fails for
anything other than DELETE and MOVE.

I really, really don't like dropping the lock in install_new_memslots().  Unlocking
bugs aside, IMO it makes it quite difficult to understand exactly what
slots_arch_lock protects.  Unfortunately I'm just whining at this point since I
don't have a better idea :-(

>  	kvfree(slots);
>  	return r;
>  }
> -- 
> 2.31.1.607.g51e8a6a459-goog
> 
