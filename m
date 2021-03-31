Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4D9350796
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 21:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235926AbhCaTrx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 15:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235416AbhCaTrb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Mar 2021 15:47:31 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5DCC06174A
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 12:47:30 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id y32so32431pga.11
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 12:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rXm/nrr7cYYIlQJb0K7kNX2znqQaRXVsKWhpXjS7Y2I=;
        b=CDypuGGrGw60J4khFNkq4AEV9gEEkbaVaUqFpR2D7gf8tSeMlwyf6nUvLGw5rNTBh2
         90XQzii0SYEovLXzoVaQjvGeQeHndrQULcF0QWkSZbcoJwB5ql9Ob5Gl0OkYvOMObYXM
         PwQIir8z4T4I0j/bFveoAqjDn6togPwkzvrmQkFjCtgGWwq8oscdeBxw+lhkNUgr0hWm
         HXKb2gq5qA41y4lLmIaRntCJ35FzXcivETY+ele6LdBo5hR9Rdw5GU8WKZABZWs5l5fj
         8JlgLggRkFrPzsokWbabc+GXcvYWIYDIVvThpt0UqySXiDlCUpLG+W2dOsggjxgt560h
         NTmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rXm/nrr7cYYIlQJb0K7kNX2znqQaRXVsKWhpXjS7Y2I=;
        b=IlQJOphW1tLsJalNjPiXFwlqsTfd4wY8rVhUoH2J+3AADG2UTp1z9P35UWVqOq8hO+
         GHWhaQ6Z3BBzmIW5Dvk4dyKMeg/ynqlP9No+sAib/3aQSpOtakAz/ZYhJwQtDll/1uSX
         uGTcNkrjd/WhjvIHQp2FaJr9PpbC31eL0J0mwsxLU5sqJW4+c1KeNsMZrGJVyY8B/6+k
         bzJU72V9RFJ688zkZYjIfZQJGyEOZC5qf8hYo49NEgH/VvGLzmiYWx58QhxxOm97pW7W
         AziyEsHROnNIl3PVkmorzHQgA4tYOIN4qS17SHnwuIpNud+nPkUhqooGeAQiuT4bs1PB
         Okvg==
X-Gm-Message-State: AOAM533XUROXqAwz9npvDkk8+l1Qqw5h3dPZDEfJ3OnVM0BwX/ZNmIAH
        WFnslVjyXKxxoB58/Cs9WQ7uQw==
X-Google-Smtp-Source: ABdhPJxre3DS307rwPCOHwWEZe4TtjFTW40vfmhoKbdPXBUPZaU3Ljhlizc9oUjhXKKagxfqerxWhA==
X-Received: by 2002:aa7:8814:0:b029:21d:d2ce:7be with SMTP id c20-20020aa788140000b029021dd2ce07bemr4305854pfo.80.1617220049616;
        Wed, 31 Mar 2021 12:47:29 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id r2sm3226686pgv.50.2021.03.31.12.47.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 12:47:28 -0700 (PDT)
Date:   Wed, 31 Mar 2021 19:47:25 +0000
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
Message-ID: <YGTRzf/4i9Y8XR2c@google.com>
References: <20210326021957.1424875-1-seanjc@google.com>
 <20210326021957.1424875-17-seanjc@google.com>
 <6e7dc7d0-f5dc-85d9-1c50-d23b761b5ff3@redhat.com>
 <YGSmMeSOPcjxRwf6@google.com>
 <56ea69fe-87b0-154b-e286-efce9233864e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56ea69fe-87b0-154b-e286-efce9233864e@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 31, 2021, Paolo Bonzini wrote:
> On 31/03/21 18:41, Sean Christopherson wrote:
> > > That said, the easiest way to avoid this would be to always update
> > > mmu_notifier_count.
> > Updating mmu_notifier_count requires taking mmu_lock, which would defeat the
> > purpose of these shenanigans.
> 
> Okay; I wasn't sure if the problem was contention with page faults in
> general, or just the long critical sections from the MMU notifier callbacks.
> Still updating mmu_notifier_count unconditionally is a good way to break up
> the patch in two and keep one commit just for the rwsem nastiness.

Rereading things, a small chunk of the rwsem nastiness can go away.  I don't see
any reason to use rw_semaphore instead of rwlock_t.  install_new_memslots() only
holds the lock for a handful of instructions.  Readers could get queued up
behind a writer, but since install_new_memslots() is serialized by slots_lock
(the existing mutex), there is no chance of multiple writers, i.e. the worst
case wait duration is bounded at the length of an in-flight notification.  And
that's _already_ the worst case since notifications are currently serialized by
mmu_lock.  In practice, the existing worst case is probably far worse since
there can be far more writers trying to acquire mmu_lock.

In other words, there's no strong argument for sleeping instead of busy waiting
in the notifiers.

By switching to rwlock_t, taking mmu_notifier_slots_lock doesn't have to depend
on mmu_notifier_range_blockable(), and the must_lock path also goes away.

> > > > +#if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
> > > > +	down_write(&kvm->mmu_notifier_slots_lock);
> > > > +#endif
> > > >   	rcu_assign_pointer(kvm->memslots[as_id], slots);
> > > > +#if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
> > > > +	up_write(&kvm->mmu_notifier_slots_lock);
> > > > +#endif
> > > Please do this unconditionally, the cost is minimal if the rwsem is not
> > > contended (as is the case if the architecture doesn't use MMU notifiers at
> > > all).
> > It's not the cost, it's that mmu_notifier_slots_lock doesn't exist.  That's an
> > easily solved problem, but then the lock wouldn't be initialized since
> > kvm_init_mmu_notifier() is a nop.  That's again easy to solve, but IMO would
> > look rather weird.  I guess the counter argument is that __kvm_memslots()
> > wouldn't need #ifdeffery.
> 
> Yep.  Less #ifdefs usually wins. :)
> 
> > These are the to ideas I've come up with:
> > 
> > Option 1:
> > 	static int kvm_init_mmu_notifier(struct kvm *kvm)
> > 	{
> > 		init_rwsem(&kvm->mmu_notifier_slots_lock);
> > 
> > 	#if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
> > 		kvm->mmu_notifier.ops = &kvm_mmu_notifier_ops;
> > 		return mmu_notifier_register(&kvm->mmu_notifier, current->mm);
> > 	#else
> > 		return 0;
> > 	#endif
> > 	}
> 
> Option 2 is also okay I guess, but the simplest is option 1 + just init it
> in kvm_create_vm.

Arr.  I'll play around with it to try and purge the #ifdefs.
