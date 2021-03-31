Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 632D33504D7
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 18:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233977AbhCaQmC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 12:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234003AbhCaQl1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Mar 2021 12:41:27 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C808C061761
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 09:41:26 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id j25so14973786pfe.2
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 09:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iR0wTKyQqrCYG4Q831SOK/hJxQXD0DTeg7JGIplTxaE=;
        b=pDOL/AXp1YZDHSJM55VWmMHEXRZyEKHoWUfLiwu43sQHWLgrvb2clWRDjjyCUh0dsJ
         bNDMyWcbeueU/GKG4kOjx3b7egix4+sMYZfIS9I0MmjVVx1rcp5WszmjK7+6YeQKCfOM
         2FXvSyhaSnZkWSZYBa+Zf13p0L3I/egR0XklyggIPr+PefBGDyB7ynzXrNWFqXB2lvPg
         VgGQ2uiEQdyQFwKIAdbJTxKQSwskTj3uIlVQzOZzPoiS3tMYr2MmjzSdDZfHyKUb7IXo
         nUd7C6HDGQOQomM2rO6UOTojM3AlSltwg6FTYiW5B9h7N+cvmdJr9MHgjJMW5v34nPiS
         VoEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iR0wTKyQqrCYG4Q831SOK/hJxQXD0DTeg7JGIplTxaE=;
        b=lwm7m5A+iegD2DVU1kC5FUcohBVXR18oJD6rfqgGh1RIuAl3UWpjAyjT2hUlEWHZZf
         OwyKi96Hejrqk0hksvZY/M9rP8Cn+B3vjKfmId/EPqVWYtvGBi3bx+Jj0qbQAnzhw54m
         //bK6ZW98XBLlGGF7eOTZM/bCntXe3Ig06HS6SjeVN3rXa4kteQO1AADMOd+26ehsmzX
         4zXR8HQ8IMhEHmF0H9Yi9mTVDhHTeZPgu3Z40LXNcOijb5LtWgKW88fCG4pAfGwMQyId
         r2zFpaVaPyzu/tE2k7DhGJObF8/UR9+k2xRhd6hh10rfDt3K8gev+NiE1GxpVlvCdxfj
         jRjA==
X-Gm-Message-State: AOAM532PjCIbEgASgVVaG/EmhV/fTaq8GbN3+LSjJb97NrxtxNfRVWz7
        q3YfbwPLbl1+lhVdhyn+c2fxYg==
X-Google-Smtp-Source: ABdhPJwZrE+nqFXUOYwl468wAhlBPq8DZI8v9hc2mHxYO0VlQq5depEehdtkJEVYztZyBSLt0lNXHA==
X-Received: by 2002:aa7:86c1:0:b029:203:900:2813 with SMTP id h1-20020aa786c10000b029020309002813mr3647646pfo.35.1617208885458;
        Wed, 31 Mar 2021 09:41:25 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id a13sm2933328pgm.43.2021.03.31.09.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 09:41:24 -0700 (PDT)
Date:   Wed, 31 Mar 2021 16:41:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 16/18] KVM: Don't take mmu_lock for range invalidation
 unless necessary
Message-ID: <YGSmMeSOPcjxRwf6@google.com>
References: <20210326021957.1424875-1-seanjc@google.com>
 <20210326021957.1424875-17-seanjc@google.com>
 <6e7dc7d0-f5dc-85d9-1c50-d23b761b5ff3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e7dc7d0-f5dc-85d9-1c50-d23b761b5ff3@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 31, 2021, Paolo Bonzini wrote:
> On 26/03/21 03:19, Sean Christopherson wrote:
> > +	/*
> > +	 * Reset the lock used to prevent memslot updates between MMU notifier
> > +	 * range_start and range_end.  At this point no more MMU notifiers will
> > +	 * run, but the lock could still be held if KVM's notifier was removed
> > +	 * between range_start and range_end.  No threads can be waiting on the
> > +	 * lock as the last reference on KVM has been dropped.  If the lock is
> > +	 * still held, freeing memslots will deadlock.
> > +	 */
> > +	init_rwsem(&kvm->mmu_notifier_slots_lock);
> 
> I was going to say that this is nasty,

Heh, I still think it's nasty.

> then I noticed that
> mmu_notifier_unregister uses SRCU to ensure completion of concurrent calls
> to the MMU notifier.  So I guess it's fine, but it's better to point it out:
> 
> 	/*
> 	 * At this point no more MMU notifiers will run and pending
> 	 * calls to range_start have completed, but the lock would
> 	 * still be held and never released if the MMU notifier was
> 	 * removed between range_start and range_end.  Since the last
> 	 * reference to the struct kvm has been dropped, no threads can
> 	 * be waiting on the lock, but we might still end up taking it
> 	 * when freeing memslots in kvm_arch_destroy_vm.  Reset the lock
> 	 * to avoid deadlocks.
> 	 */
> 
> That said, the easiest way to avoid this would be to always update
> mmu_notifier_count.

Updating mmu_notifier_count requires taking mmu_lock, which would defeat the
purpose of these shenanigans.  I think it could be made atomic, since mmu_lock
would be taken before the elevated count _must_ be visible, but that would
break the mmu_notifier_range_{start,end} optimization that was recently added.

Or did I completely misunderstand what you're suggesting?

> I don't mind the rwsem, but at least I suggest that you
> split the patch in two---the first one keeping the mmu_notifier_count update
> unconditional, and the second one introducing the rwsem and the on_lock
> function kvm_inc_notifier_count.  Please document the new lock in
> Documentation/virt/kvm/locking.rst too.

Note, will update docs.

> Also, related to the first part of the series, perhaps you could structure
> the series in a slightly different way:
> 
> 1) introduce the HVA walking API in common code, complete with on_lock and
> patch 15, so that you can use on_lock to increase mmu_notifier_seq
> 
> 2) then migrate all architectures including x86 to the new API
> 
> IOW, first half of patch 10 and all of patch 15; then the second half of
> patch 10; then patches 11-14.
> 
> > +#if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
> > +	down_write(&kvm->mmu_notifier_slots_lock);
> > +#endif
> >  	rcu_assign_pointer(kvm->memslots[as_id], slots);
> > +#if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
> > +	up_write(&kvm->mmu_notifier_slots_lock);
> > +#endif
> 
> Please do this unconditionally, the cost is minimal if the rwsem is not
> contended (as is the case if the architecture doesn't use MMU notifiers at
> all).

It's not the cost, it's that mmu_notifier_slots_lock doesn't exist.  That's an
easily solved problem, but then the lock wouldn't be initialized since
kvm_init_mmu_notifier() is a nop.  That's again easy to solve, but IMO would
look rather weird.  I guess the counter argument is that __kvm_memslots()
wouldn't need #ifdeffery.

These are the to ideas I've come up with:

Option 1:
	static int kvm_init_mmu_notifier(struct kvm *kvm)
	{
		init_rwsem(&kvm->mmu_notifier_slots_lock);

	#if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
		kvm->mmu_notifier.ops = &kvm_mmu_notifier_ops;
		return mmu_notifier_register(&kvm->mmu_notifier, current->mm);
	#else
		return 0;
	#endif
	}


Option 2:
	kvm_mmu_notifier_lock(kvm);
	rcu_assign_pointer(kvm->memslots[as_id], slots);
	kvm_mmu_notifier_unlock(kvm);




