Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4326E364FC2
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 03:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbhDTBRy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 21:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbhDTBRx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 21:17:53 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 191B0C061763
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 18:17:22 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id d10so25477571pgf.12
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 18:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SggzfZxjHcNUSsdMFr1Eduw2GR0AfAVorLsjUVQHMLQ=;
        b=JVfyIcteQwVIc1C5qvn6rWBSOtArwIhzfn29v6P/P6+Z1Xb1JJ6a39MbzFduBZLJc3
         1fgTNVlkMIU2POWkC9ev3WkVNVG37ZmveLO5aXrMB/8K/v+IORdMiv2lRKblY3EtAEaQ
         2r11UPVBWlDCpDpaZzO/44GNWaUglO18qs8rKcqGCFlLPDWUCm7TN5LLaSqAD8xLu8kj
         NLjUK/Vr3IIWw4mE204cVelc3EkKfqBVKrv8yteyg99jaasela8bpcPsKazph+nAyTCb
         AMyw9m0gRL9ANm6hEbBo5t0479K7qtJJu4MKItAXHVKxQMz23JIW713xtMA1pvlIO2QL
         Gi4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SggzfZxjHcNUSsdMFr1Eduw2GR0AfAVorLsjUVQHMLQ=;
        b=aThAfYXFtqT1/PFsh5NX4GPYdZdp9WcbuMRHax8M5/OUyM9u9mfhNtc1jrMed9mCso
         86xuW/yAIeJNx8vsE2BfGWZ6MOzjGWg4uvdjYkkjr3JRchp2b6Ttnq4/RUTOQlDVEFzO
         I9qctI0ExCux5+KsqTwGaE7KIKCqksKHwJ4pna7o9lgtZ7AD7QeHpbamSpb//VooOYL3
         mpTw38TNNKrOrACwMFtFtvtm0jz5BJK6D6Zgf1q8s1Fb4AONNJ8MoZg8rXgi1XucJ5MA
         0LqBb+xKONHjDCANpRRFR1vP0JR14AO/UJYNZbZ1P83KJyJmb70mceX2v1dp+/1aiKug
         acbA==
X-Gm-Message-State: AOAM533Az5Gq7wNxQmMB9aNeG3ca17J3QeAv+bGQOae9iNrwIu88fOpD
        Pi4nSt2bMKYuF9Dtd4c96RchHA==
X-Google-Smtp-Source: ABdhPJxzHAdY3UsE4krXE94EyP90jXg3NBfuyK29elRMTZ4LaGvrT5vHnagdENvSbFKj4BjOdcxApw==
X-Received: by 2002:a62:1b97:0:b029:24e:44e9:a8c1 with SMTP id b145-20020a621b970000b029024e44e9a8c1mr22972281pfb.19.1618881439280;
        Mon, 19 Apr 2021 18:17:19 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id e23sm2931094pgg.76.2021.04.19.18.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 18:17:18 -0700 (PDT)
Date:   Tue, 20 Apr 2021 01:17:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <bonzini@gnu.org>
Cc:     Wanpeng Li <kernellwp@gmail.com>, Marc Zyngier <maz@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 09/10] KVM: Don't take mmu_lock for range invalidation
 unless necessary
Message-ID: <YH4rm4W57R85tMKE@google.com>
References: <20210402005658.3024832-1-seanjc@google.com>
 <20210402005658.3024832-10-seanjc@google.com>
 <CANRm+Cwt9Xs=13r9E4YWOhcE6oEJXmVrkKrv_wQ5jMUkY8+Stw@mail.gmail.com>
 <2a7670e4-94c0-9f35-74de-a7d5b1504ced@redhat.com>
 <YH2dDRBXJcbUcbLi@google.com>
 <051f78aa-7bf8-0832-aee6-b4157a1853a0@gnu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <051f78aa-7bf8-0832-aee6-b4157a1853a0@gnu.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 20, 2021, Paolo Bonzini wrote:
> On 19/04/21 17:09, Sean Christopherson wrote:
> > > - this loses the rwsem fairness.  On the other hand, mm/mmu_notifier.c's
> > > own interval-tree-based filter is also using a similar mechanism that is
> > > likewise not fair, so it should be okay.
> > 
> > The one concern I had with an unfair mechanism of this nature is that, in theory,
> > the memslot update could be blocked indefinitely.
> 
> Yep, that's why I mentioned it.
> 
> > > @@ -1333,9 +1351,22 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
> > >   	WARN_ON(gen & KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS);
> > >   	slots->generation = gen | KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS;
> > > -	down_write(&kvm->mmu_notifier_slots_lock);
> > > +	/*
> > > +	 * This cannot be an rwsem because the MMU notifier must not run
> > > +	 * inside the critical section.  A sleeping rwsem cannot exclude
> > > +	 * that.
> > 
> > How on earth did you decipher that from the splat?  I stared at it for a good
> > five minutes and was completely befuddled.
> 
> Just scratch that, it makes no sense.  It's much simpler, but you have
> to look at include/linux/mmu_notifier.h to figure it out:

LOL, glad you could figure it out, I wasn't getting anywhere, mmu_notifier.h or
not.

>     invalidate_range_start
>       take pseudo lock
>       down_read()           (*)
>       release pseudo lock
>     invalidate_range_end
>       take pseudo lock      (**)
>       up_read()
>       release pseudo lock
> 
> At point (*) we take the mmu_notifiers_slots_lock inside the pseudo lock;
> at point (**) we take the pseudo lock inside the mmu_notifiers_slots_lock.
> 
> This could cause a deadlock (ignoring for a second that the pseudo lock
> is not a lock):
> 
> - invalidate_range_start waits on down_read(), because the rwsem is
> held by install_new_memslots
> 
> - install_new_memslots waits on down_write(), because the rwsem is
> held till (another) invalidate_range_end finishes
> 
> - invalidate_range_end sits waits on the pseudo lock, held by
> invalidate_range_start.
> 
> Removing the fairness of the rwsem breaks the cycle (in lockdep terms,
> it would change the *shared* rwsem readers into *shared recursive*
> readers).  This also means that there's no need for a raw spinlock.

Ahh, thanks, this finally made things click.

> Given this simple explanation, I think it's okay to include this

LOL, "simple".

> patch in the merge window pull request, with the fix after my
> signature squashed in.  The fix actually undoes a lot of the
> changes to __kvm_handle_hva_range that this patch made, so the
> result is relatively simple.  You can already find the result
> in kvm/queue.

...

>  static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
>  						  const struct kvm_hva_range *range)
>  {
> @@ -515,10 +495,6 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
>  	idx = srcu_read_lock(&kvm->srcu);
> -	if (range->must_lock &&
> -	    kvm_mmu_lock_and_check_handler(kvm, range, &locked))
> -		goto out_unlock;
> -
>  	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
>  		slots = __kvm_memslots(kvm, i);
>  		kvm_for_each_memslot(slot, slots) {
> @@ -547,8 +523,14 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
>  			gfn_range.end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, slot);
>  			gfn_range.slot = slot;
> -			if (kvm_mmu_lock_and_check_handler(kvm, range, &locked))
> -				goto out_unlock;
> +			if (!locked) {
> +				locked = true;
> +				KVM_MMU_LOCK(kvm);
> +				if (!IS_KVM_NULL_FN(range->on_lock))
> +					range->on_lock(kvm, range->start, range->end);
> +				if (IS_KVM_NULL_FN(range->handler))
> +					break;

This can/should be "goto out_unlock", "break" only takes us out of the memslots
walk, we want to get out of the address space loop.  Not a functional problem,
but we might walk all SMM memslots unnecessarily.

> +			}
>  			ret |= range->handler(kvm, &gfn_range);
>  		}
> @@ -557,7 +539,6 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
>  	if (range->flush_on_ret && (ret || kvm->tlbs_dirty))
>  		kvm_flush_remote_tlbs(kvm);
> -out_unlock:
>  	if (locked)
>  		KVM_MMU_UNLOCK(kvm);
> @@ -580,7 +561,6 @@ static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
>  		.pte		= pte,
>  		.handler	= handler,
>  		.on_lock	= (void *)kvm_null_fn,
> -		.must_lock	= false,
>  		.flush_on_ret	= true,
>  		.may_block	= false,
>  	};
> @@ -600,7 +580,6 @@ static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn
>  		.pte		= __pte(0),
>  		.handler	= handler,
>  		.on_lock	= (void *)kvm_null_fn,
> -		.must_lock	= false,
>  		.flush_on_ret	= false,
>  		.may_block	= false,
>  	};
> @@ -620,13 +599,11 @@ static void kvm_mmu_notifier_change_pte(struct mmu_notifier *mn,
>  	 * .change_pte() must be surrounded by .invalidate_range_{start,end}(),

While you're squashing, want to change the above comma to a period?

>  	 * If mmu_notifier_count is zero, then start() didn't find a relevant
>  	 * memslot and wasn't forced down the slow path; rechecking here is
> -	 * unnecessary.  This can only occur if memslot updates are blocked;
> -	 * otherwise, mmu_notifier_count is incremented unconditionally.
> +	 * unnecessary.
>  	 */
> -	if (!kvm->mmu_notifier_count) {
> -		lockdep_assert_held(&kvm->mmu_notifier_slots_lock);
> +	WARN_ON_ONCE(!READ_ONCE(kvm->mn_active_invalidate_count));
> +	if (!kvm->mmu_notifier_count)
>  		return;
> -	}
>  	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_set_spte_gfn);
>  }

...

> @@ -1333,9 +1315,22 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
>  	WARN_ON(gen & KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS);
>  	slots->generation = gen | KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS;
> -	down_write(&kvm->mmu_notifier_slots_lock);
> +	/*
> +	 * This cannot be an rwsem because the MMU notifier must not run
> +	 * inside the critical section, which cannot be excluded with a
> +	 * sleeping rwsem.

Any objection to replcaing this comment with a rephrased version of your
statement about "shared" vs. "shared recursive" and breaking the fairness cycle?
IIUC, it's not "running inside the critical section" that's problematic, it's
that sleeping in down_write() can cause deadlock due to blocking future readers.

Thanks much!

> +	 */
> +	spin_lock(&kvm->mn_invalidate_lock);
> +	prepare_to_rcuwait(&kvm->mn_memslots_update_rcuwait);
> +	while (kvm->mn_active_invalidate_count) {
> +		set_current_state(TASK_UNINTERRUPTIBLE);
> +		spin_unlock(&kvm->mn_invalidate_lock);
> +		schedule();
> +		spin_lock(&kvm->mn_invalidate_lock);
> +	}
> +	finish_rcuwait(&kvm->mn_memslots_update_rcuwait);
>  	rcu_assign_pointer(kvm->memslots[as_id], slots);
> -	up_write(&kvm->mmu_notifier_slots_lock);
> +	spin_unlock(&kvm->mn_invalidate_lock);
>  	synchronize_srcu_expedited(&kvm->srcu);
> -- 
> 2.26.2
> 
