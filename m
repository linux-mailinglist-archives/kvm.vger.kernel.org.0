Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96DEC30E2E8
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 19:54:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbhBCSw6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 13:52:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233113AbhBCSwl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 13:52:41 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A7AC061573
        for <kvm@vger.kernel.org>; Wed,  3 Feb 2021 10:52:01 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id y15so197742ilj.11
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 10:52:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AZDi8lCrS2NywtnR2RVH/bdowc1KYG9B2acasSvhjxE=;
        b=dQFpo9GZlg1fMUH3LykZanV1gNjABOvh3vUqtT8oW3vxRdaEud5xnSyj/Eox8b7GsX
         +PAyVXzPolxEUBdKywO1JZiidlyF2wP4x0my8zRd9XsbtCcSQ/vZ68Jep/4josx+9c+I
         Mu+sfQx44BYavUOjxBW8V2QdHRKUiL61Jaagln8F8J3cSbhO8q1fveslVwZAM1oFeW2N
         osTSk2BnMAvVE5M8ZAHlkDNAXS+y/6f743Y9xY5qGR0/0jCgPmeEOweWx1P2jeP2B0Ll
         D9qmJ2Qf6xcBKiQbny1xYmSn8fjoBQKWE7Ufpxg0OIOF0VBEIj+A5hLoS24JuZN30Izx
         oRiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AZDi8lCrS2NywtnR2RVH/bdowc1KYG9B2acasSvhjxE=;
        b=cYy6W1us5RtqPAlw8ATu/1SSIVVmdLa83i9VKlUivCDYiz0z3c+R6II+goTgZDHkiU
         NDDp44cU/hg8IzIKDV3ke9/K2GSQhWFPMF8G2QkfbEtE89IRS6Y8lCty3CpNXvNrTCfJ
         Q/nNWObgo52ktt1UYmEQ18DOyHYFYvSpNvw9cITPM5/j1+EqpUj0I/CHpDcPIendOM+e
         hYfxtYKSOzW3MSSuXvLTgYIZ+Iy92A4XR8t8q8FiE1DkpAtn3D2Q6OWzTfsl1v2Ta/gH
         oTphLHmplV0x9jYSRjpAa2xouC186uJs8ISLhxo3hnZWgLtiWbvAByxbP/B/LUwT54tW
         Tc5g==
X-Gm-Message-State: AOAM533mV9azlCC8eQNqOMXySPU4ZzHs8regcQoEynw2GiihVED8NtlI
        +y9G/Aijkz9KHeaz+VyV8wVIZegxu/xqCj6o06O+HQ==
X-Google-Smtp-Source: ABdhPJyTrJ10xy5k4wVkQ9ELmn8mTS2TmuEiBPHiJfDnOazCC3FfQGKP3J1+OGRYf2mtmMKemLim9I8+H1OZhiq2UhY=
X-Received: by 2002:a05:6e02:1888:: with SMTP id o8mr3241146ilu.154.1612378320595;
 Wed, 03 Feb 2021 10:52:00 -0800 (PST)
MIME-Version: 1.0
References: <20210202185734.1680553-1-bgardon@google.com> <20210202185734.1680553-26-bgardon@google.com>
 <e87d4a5d-f6ac-677a-87aa-0c30977c92f1@redhat.com>
In-Reply-To: <e87d4a5d-f6ac-677a-87aa-0c30977c92f1@redhat.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 3 Feb 2021 10:51:49 -0800
Message-ID: <CANgfPd_t1umcmiFzaUwsUwAAvOePbdxn5nY5y9NcoROYv5HEWg@mail.gmail.com>
Subject: Re: [PATCH v2 25/28] KVM: x86/mmu: Allow zapping collapsible SPTEs to
 use MMU read lock
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
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

On Wed, Feb 3, 2021 at 3:34 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 02/02/21 19:57, Ben Gardon wrote:
> > @@ -1485,7 +1489,9 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
> >       struct kvm_mmu_page *root;
> >       int root_as_id;
> >
> > -     for_each_tdp_mmu_root_yield_safe(kvm, root, false) {
> > +     read_lock(&kvm->mmu_lock);
> > +
> > +     for_each_tdp_mmu_root_yield_safe(kvm, root, true) {
> >               root_as_id = kvm_mmu_page_as_id(root);
> >               if (root_as_id != slot->as_id)
> >                       continue;
> > @@ -1493,6 +1499,8 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
> >               zap_collapsible_spte_range(kvm, root, slot->base_gfn,
> >                                          slot->base_gfn + slot->npages);
> >       }
> > +
> > +     read_unlock(&kvm->mmu_lock);
> >  }
>
>
> I'd prefer the functions to be consistent about who takes the lock,
> either mmu.c or tdp_mmu.c.  Since everywhere else you're doing it in
> mmu.c, that would be:
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 0554d9c5c5d4..386ee4b703d9 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5567,10 +5567,13 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
>         write_lock(&kvm->mmu_lock);
>         slot_handle_leaf(kvm, (struct kvm_memory_slot *)memslot,
>                          kvm_mmu_zap_collapsible_spte, true);
> +       write_unlock(&kvm->mmu_lock);
>
> -       if (kvm->arch.tdp_mmu_enabled)
> +       if (kvm->arch.tdp_mmu_enabled) {
> +               read_lock(&kvm->mmu_lock);
>                 kvm_tdp_mmu_zap_collapsible_sptes(kvm, memslot);
> -       write_unlock(&kvm->mmu_lock);
> +               read_unlock(&kvm->mmu_lock);
> +       }
>   }
>
>   void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
>
> and just lockdep_assert_held_read here.

That makes sense to me, I agree keeping it consistent is probably a good idea.

>
> > -             tdp_mmu_set_spte(kvm, &iter, 0);
> > -
> > -             spte_set = true;
>
> Is it correct to remove this assignment?

No, it was not correct to remove it. Thank you for catching that.

>
> Paolo
>
