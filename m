Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 813194B9354
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 22:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235297AbiBPVnf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 16:43:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234794AbiBPVnd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 16:43:33 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F8919FAEB
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 13:43:19 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id e17so5406380ljk.5
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 13:43:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IdQcNFGHAt/u8ph9ZnTkYnGd8BzRqpf6Uz+c8hphHXE=;
        b=M8PRg2Gqyfhc8d2ZMa8CPfYVZENH6gawdlmed6vsP2XqGAyQpqb93HEfM68A6zLAnA
         Dekr8hlV+9/5riN4mqnJUOg1D0BjIc71B264CL20jNqqO8o7jzX25/m4DPCXqdNuK5mf
         VnPCZJ55KoS/93GwiSvakoPPYICNjGdIBBKGrifVVBIbj+v7EPmMu43VEZk5xUj5q93O
         RBizWgOCC6BPR9iZ/r8xYo5jsK01RkVcGemyow17U+xS7K9Zby39N+9SC+et7BcNbJ0E
         lJlnsSn1xbkId8WlCCH9TNwM7n9VrOHlrIi9g1vAG0v8EENQn54OgY05tFJ37adCA4Yn
         sRHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IdQcNFGHAt/u8ph9ZnTkYnGd8BzRqpf6Uz+c8hphHXE=;
        b=p1sR2b/8AVKY/GmDQGSHyYMsNjzvbCUpzS//19kVN7im/1vbzTsYa/x8323j42RGF2
         OWNhfJklslymR8e6ab2q1nZSR3B6TH48kKIdAIOOx+7ZEjmjfU54iCIikiOxffb/QEUl
         tsohpV+GjMUGW/xBIomlZipam9V1teQBLsbf3NhiUUTFbaKEVtuo6djsy2TMIwbx3d4d
         hR3MBBR+zhnO+hUXC1ERTCiMrgSI9lz92KpiLKq+W9NtP3yIgFGnCtOb+LvVIontVLYe
         MJaJvHG+3EEoOqwv0AB3epe9YOEPVNkDgRt9RPeKUyReZSmsZ6D6/NoosGHsGGcdoCGW
         Qn7g==
X-Gm-Message-State: AOAM530lESdTZpVNu2m/6mtcJgLs3F1esfEyfEsAOBXhaDgko4BYl1K1
        0HTy4ck81oY+L/rNd0DVdFcqyq8q27N3973HxbVbZg==
X-Google-Smtp-Source: ABdhPJxZV7dmum8jgwM0k9G/FmhX6Sxkb/Uut05c5+q8xocRapgCc3/NPKO9BCyhBFtzz2tHeK1AGlHnqPpBmrcDLiQ=
X-Received: by 2002:a2e:6804:0:b0:245:f269:618 with SMTP id
 c4-20020a2e6804000000b00245f2690618mr13680lja.198.1645047797533; Wed, 16 Feb
 2022 13:43:17 -0800 (PST)
MIME-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com> <20220203010051.2813563-7-dmatlack@google.com>
 <CANgfPd-5HM7+etr=TCEACMSSgrZo3vV8LmA5JbJw4x8Q5VnLmw@mail.gmail.com>
In-Reply-To: <CANgfPd-5HM7+etr=TCEACMSSgrZo3vV8LmA5JbJw4x8Q5VnLmw@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 16 Feb 2022 13:42:50 -0800
Message-ID: <CALzav=fypkyoP07_+RcpvTwCamco1xcbd4+HSBM0wTqwRsAvMg@mail.gmail.com>
Subject: Re: [PATCH 06/23] KVM: x86/mmu: Separate shadow MMU sp allocation
 from initialization
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 16, 2022 at 11:37 AM Ben Gardon <bgardon@google.com> wrote:
>
> On Wed, Feb 2, 2022 at 5:02 PM David Matlack <dmatlack@google.com> wrote:
> >
> > Separate the code that allocates a new shadow page from the vCPU caches
> > from the code that initializes it. This is in preparation for creating
> > new shadow pages from VM ioctls for eager page splitting, where we do
> > not have access to the vCPU caches.
> >
> > No functional change intended.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 44 +++++++++++++++++++++---------------------
> >  1 file changed, 22 insertions(+), 22 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 49f82addf4b5..d4f90a10b652 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1718,7 +1718,7 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
> >         mmu_spte_clear_no_track(parent_pte);
> >  }
> >
> > -static struct kvm_mmu_page *kvm_mmu_alloc_sp(struct kvm_vcpu *vcpu, int direct)
> > +static struct kvm_mmu_page *kvm_mmu_alloc_sp(struct kvm_vcpu *vcpu, bool direct)
> >  {
> >         struct kvm_mmu_page *sp;
> >
> > @@ -1726,16 +1726,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_sp(struct kvm_vcpu *vcpu, int direct)
> >         sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> >         if (!direct)
> >                 sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
> > -       set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
>
> I'd be inclined to leave this in the allocation function instead of
> moving it to the init function. It might not be any less code, but if
> you're doing the sp -> page link here, you might as well do the page
> -> sp link too.

Good suggestion. I'll include that change in the next version.
>
> >
> >
> > -       /*
> > -        * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
> > -        * depends on valid pages being added to the head of the list.  See
> > -        * comments in kvm_zap_obsolete_pages().
> > -        */
> > -       sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
> > -       list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
> > -       kvm_mod_used_mmu_pages(vcpu->kvm, +1);
> >         return sp;
> >  }
> >
> > @@ -2144,27 +2135,34 @@ static struct kvm_mmu_page *kvm_mmu_get_existing_sp(struct kvm_vcpu *vcpu,
> >         return sp;
> >  }
> >
> > -static struct kvm_mmu_page *kvm_mmu_create_sp(struct kvm_vcpu *vcpu,
> > -                                             struct kvm_memory_slot *slot,
> > -                                             gfn_t gfn,
> > -                                             union kvm_mmu_page_role role)
> > +
> > +static void kvm_mmu_init_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
> > +                           struct kvm_memory_slot *slot, gfn_t gfn,
> > +                           union kvm_mmu_page_role role)
> >  {
> > -       struct kvm_mmu_page *sp;
> >         struct hlist_head *sp_list;
> >
> > -       ++vcpu->kvm->stat.mmu_cache_miss;
> > +       ++kvm->stat.mmu_cache_miss;
> > +
> > +       set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> >
> > -       sp = kvm_mmu_alloc_sp(vcpu, role.direct);
> >         sp->gfn = gfn;
> >         sp->role = role;
> > +       sp->mmu_valid_gen = kvm->arch.mmu_valid_gen;
> >
> > -       sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
> > +       /*
> > +        * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
> > +        * depends on valid pages being added to the head of the list.  See
> > +        * comments in kvm_zap_obsolete_pages().
> > +        */
> > +       list_add(&sp->link, &kvm->arch.active_mmu_pages);
> > +       kvm_mod_used_mmu_pages(kvm, 1);
> > +
> > +       sp_list = &kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
> >         hlist_add_head(&sp->hash_link, sp_list);
> >
> >         if (!role.direct)
> > -               account_shadowed(vcpu->kvm, slot, sp);
> > -
> > -       return sp;
> > +               account_shadowed(kvm, slot, sp);
> >  }
> >
> >  static struct kvm_mmu_page *kvm_mmu_get_sp(struct kvm_vcpu *vcpu, gfn_t gfn,
> > @@ -2179,8 +2177,10 @@ static struct kvm_mmu_page *kvm_mmu_get_sp(struct kvm_vcpu *vcpu, gfn_t gfn,
> >                 goto out;
> >
> >         created = true;
> > +       sp = kvm_mmu_alloc_sp(vcpu, role.direct);
> > +
> >         slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
> > -       sp = kvm_mmu_create_sp(vcpu, slot, gfn, role);
> > +       kvm_mmu_init_sp(vcpu->kvm, sp, slot, gfn, role);
> >
> >  out:
> >         trace_kvm_mmu_get_page(sp, created);
> > --
> > 2.35.0.rc2.247.g8bbb082509-goog
> >
