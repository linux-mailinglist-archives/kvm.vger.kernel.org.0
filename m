Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2AB036E073
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 22:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242013AbhD1UlK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 16:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240387AbhD1UlK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 16:41:10 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB1DC06138B
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 13:40:24 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id 35-20020a9d05260000b029029c82502d7bso28142500otw.2
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 13:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=boJVxwbv68E6kptb+hUE8SCZnY8IWI5+k6h0gATVG5s=;
        b=orJkPDsfa5lZi/6zpkbPvXlfg/BVXbKDIOI7OTHXRq5Gw/E/R0N641zTdghwPhjV8f
         LrWDyoIy4cVfOasbxP7IWq/D5I0XZtgtaXO6pezzbJtoNjLJFPpL8na/c/wdtkrjSdnE
         4llSC8oMV0IkeSrNbqIa/hmdfS9kvTQz+batkn1Sc7pa8cny0atjTyz5EeXNjcu/qjhw
         osssih9cGo5h1gOYEItD/sxjO9VAdG7UaxEbLQPesnoh3pakuxA9A3fujt+F0F62AYUh
         CNCdfK8Rnov9YlR4IV3GjuaNy40OxD+A0owphEN/tlgODsaAGOQdggqUDzgNWKP1kBX5
         M3AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=boJVxwbv68E6kptb+hUE8SCZnY8IWI5+k6h0gATVG5s=;
        b=XENn/QU4ngKXhCKsIh8LcY0cWiLH/Y6l3izpd2Ji+enp2iLLG9ejqY731yEbPyF3Y6
         BAEMunsJo6bPdcHP5QRbQrnzbuYblPo2KMiTfR8VjGQ2vWcC8rYJf61nqBeHcMaA2FPt
         tgwYqn+9vcJySzWPi321Gv6dojLkl5J0X4j6XRwZh03GIE/MIWixmD037DOTKCquDF3i
         VOqPkY4caXBHO2HiRp2CllUQ87wlDFLdKozviuF8DKRxCw4V2tCmLfLSgx/uoQK+VV+f
         hngSxo2oAW7hOa+oBLuqftydUz0XCqjVx8noPRJ/tWvbjJk1hr8BtF4QX2BJJH65Fzqw
         dexQ==
X-Gm-Message-State: AOAM531B5wiAU8QzSmGGocxro7HXxRy/ebpz8lniPi1/FQKu5ycmgAFP
        kc0Cdo/0WCM/z69Cm+U5lsyLCB5lMwOtGOecXH0fLA==
X-Google-Smtp-Source: ABdhPJyoDNDBlFi1TSJkZIkZiY7c+FPvb3Qs8POW6cfJgX78Nf6/KSvgrbMPGWt6KQOa+5YxwuZwQHEQzBul3kyfaEc=
X-Received: by 2002:a9d:7857:: with SMTP id c23mr15776680otm.208.1619642423910;
 Wed, 28 Apr 2021 13:40:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210427223635.2711774-1-bgardon@google.com> <20210427223635.2711774-6-bgardon@google.com>
 <997f9fe3-847b-8216-c629-1ad5fdd2ffae@redhat.com> <CANgfPd8RZXQ-BamwQPS66Q5hLRZaDFhi0WaA=ZvCP4BbofiUhg@mail.gmail.com>
 <d936b13b-bb00-fc93-de3b-adc59fa32a7b@redhat.com>
In-Reply-To: <d936b13b-bb00-fc93-de3b-adc59fa32a7b@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 28 Apr 2021 13:40:12 -0700
Message-ID: <CANgfPd9kVJOAR_uq+oh9kE2gr00EUAGSPiJ9jMR9BdG2CAC+BA@mail.gmail.com>
Subject: Re: [PATCH 5/6] KVM: x86/mmu: Protect kvm->memslots with a mutex
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 28, 2021 at 10:46 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 28/04/21 18:40, Ben Gardon wrote:
> > On Tue, Apr 27, 2021 at 11:25 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>
> >> On 28/04/21 00:36, Ben Gardon wrote:
> >>> +void kvm_arch_assign_memslots(struct kvm *kvm, int as_id,
> >>> +                          struct kvm_memslots *slots)
> >>> +{
> >>> +     mutex_lock(&kvm->arch.memslot_assignment_lock);
> >>> +     rcu_assign_pointer(kvm->memslots[as_id], slots);
> >>> +     mutex_unlock(&kvm->arch.memslot_assignment_lock);
> >>> +}
> >>
> >> Does the assignment also needs the lock, or only the rmap allocation?  I
> >> would prefer the hook to be something like kvm_arch_setup_new_memslots.
> >
> > The assignment does need to be under the lock to prevent the following race:
> > 1. Thread 1 (installing a new memslot): Acquires memslot assignment
> > lock (or perhaps in this case rmap_allocation_lock would be more apt.)
> > 2. Thread 1: Check alloc_memslot_rmaps (it is false)
> > 3. Thread 1: doesn't allocate memslot rmaps for new slot
> > 4. Thread 1: Releases memslot assignment lock
> > 5. Thread 2 (allocating a shadow root): Acquires memslot assignment lock
> > 6. Thread 2: Sets alloc_memslot_rmaps = true
> > 7. Thread 2: Allocates rmaps for all existing slots
> > 8. Thread 2: Releases memslot assignment lock
> > 9. Thread 2: Sets shadow_mmu_active = true
> > 10. Thread 1: Installs the new memslots
> > 11. Thread 3: Null pointer dereference when trying to access rmaps on
> > the new slot.
>
> ... because thread 3 would be under mmu_lock and therefore cannot
> allocate the rmap itself (you have to do it in mmu_alloc_shadow_roots,
> as in patch 6).
>
> Related to this, your solution does not have to protect kvm_dup_memslots
> with the new lock, because the first update of the memslots will not go
> through kvm_arch_prepare_memory_region but it _will_ go through
> install_new_memslots and therefore through the new hook.  But overall I
> think I'd prefer to have a kvm->slots_arch_lock mutex in generic code,
> and place the call to kvm_dup_memslots and
> kvm_arch_prepare_memory_region inside that mutex.

That makes sense, and I think it also avoids a bug in this series.
Currently, if the rmaps are allocated between kvm_dup_memslots and and
install_new_memslots, we run into a problem where the copied slots
will have new rmaps allocated for them before installation.
Potentially creating all sorts of problems. I had fixed that issue in
the past by allocating the array of per-level rmaps at memslot
creation, seperate from the memslot. That meant that the copy would
get the newly allocated rmaps as well, but I thought that was obsolete
after some memslot refactors went in.

I hoped we could get away without that change, but I was probably
wrong. However, with this enlarged critical section, that should not
be an issue for creating memslots since kvm_dup_memslots will either
copy memslots with the rmaps already allocated, or the whole thing
will happen before the rmaps are allocated.

... However with the locking you propose below, we might still run
into issues on a move or delete, which would mean we'd still need the
separate memory allocation for the rmaps array. Or we do some
shenanigans where we try to copy the rmap pointers from the other set
of memslots.

I can put together a v2 with the seperate rmap memory and more generic
locking and see how that looks.

>
> That makes the new lock decently intuitive, and easily documented as
> "Architecture code can use slots_arch_lock if the contents of struct
> kvm_arch_memory_slot needs to be written outside
> kvm_arch_prepare_memory_region.  Unlike slots_lock, slots_arch_lock can
> be taken inside a ``kvm->srcu`` read-side critical section".
>
> I admit I haven't thought about it very thoroughly, but if something
> like this is enough, it is relatively pretty:
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 9b8e30dd5b9b..6e5106365597 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1333,6 +1333,7 @@ static struct kvm_memslots
> *install_new_memslots(struct kvm *kvm,
>
>         rcu_assign_pointer(kvm->memslots[as_id], slots);
>
> +       mutex_unlock(&kvm->slots_arch_lock);
>         synchronize_srcu_expedited(&kvm->srcu);
>
>         /*
> @@ -1399,6 +1398,7 @@ static int kvm_set_memslot(struct kvm *kvm,
>         struct kvm_memslots *slots;
>         int r;
>
> +       mutex_lock(&kvm->slots_arch_lock);
>         slots = kvm_dup_memslots(__kvm_memslots(kvm, as_id), change);
>         if (!slots)
>                 return -ENOMEM;
> @@ -1427,6 +1427,7 @@ static int kvm_set_memslot(struct kvm *kvm,
>                  *      - kvm_is_visible_gfn (mmu_check_root)
>                  */
>                 kvm_arch_flush_shadow_memslot(kvm, slot);
> +               mutex_lock(&kvm->slots_arch_lock);
>         }
>
>         r = kvm_arch_prepare_memory_region(kvm, new, mem, change);
>
> It does make the critical section a bit larger, so that the
> initialization of the shadow page (which is in KVM_RUN context) contends
> with slightly more code than necessary.  However it's all but a
> performance critical situation, as it will only happen just once per VM.

I agree performance is not a huge concern here. Excluding
kvm_arch_flush_shadow_memslot from the critical section also helps a
lot because that's where most of the work could be if we're deleting /
moving a slot.
My only worry is the latency this could add to a nested VM launch, but
it seems pretty unlikely that that would be frequently coinciding with
a memslot change in practice.

>
> WDYT?
>
> Paolo
>
> > Putting the assignment under the lock prevents 5-8 from happening
> > between 2 and 10.
> >
> > I'm open to other ideas as far as how to prevent this race though. I
> > admit this solution is not the most elegant looking.
>
>
