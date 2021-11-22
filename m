Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE49145952A
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 19:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbhKVS7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 13:59:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231714AbhKVS7K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 13:59:10 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E88C061574
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 10:56:03 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id z26so24692772iod.10
        for <kvm@vger.kernel.org>; Mon, 22 Nov 2021 10:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+ImoNY0EE1j0At33I/oNABZslbV9IhAEhUNkS9wIM+8=;
        b=m0PXBpGF9RPhfk51jF+LTCkvNRVSlRBpcE0tuq13gny7Ap2HQ0Xg8gdWXwyvgdJ3yz
         3go4R3tCkxOQ3eTb6HV/Q2Ku1Y6WV/lPZ+8CMV3jHlZjbRWCnFCpk6tUYIUWB9jZTkG9
         hmC+dRvyV1NEhl97SBOkUy8+1Mo7FAeHtnHS+/+mlvN/WpAfWOwQcl3TkEmRvvX9kWqp
         UARmlFQt2wi8vN4proA+xVWVZ3hTwVE2jTSG0bHf8MM6l/uab1Z9ku7T76UvIZP/If8T
         51R6TtugKExcydb9U9VGv7SnIzPDy6qwKtMq+ME9+KQss7RmdbzXmedFzPRD9xI7bTYR
         HGEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+ImoNY0EE1j0At33I/oNABZslbV9IhAEhUNkS9wIM+8=;
        b=iUxjdA5s9vPweX+1dCSIvZiCjeatAAhtOuAU6URGaGbWfnjUm0mlSXfmYdj9xxt5Bn
         o/2snENW88lmCqeNYKBOS8V7VsmVAJS/hbvKtKpPBLZ7G81HoWDtEYORsGDsptFr0sp0
         R6u0fgjZQOw0ILauOjMISv3qbLYuXMp5pJREUmDpbPMAx2tXv3F/YsEBsO4U542MMaJy
         nSe0j0NHAfPpUmvxT5KsKGVz356T/O11CbY27YfYsi/DROP7NmIGw52EmBZmXNqvA4XV
         BwV9IdbuLyzOqGD0dxGRyS2V9YYUtz+1ibJ9lQ06m1N5uQ4e6kwtG8LNdzxjC+qm0Ref
         CHpg==
X-Gm-Message-State: AOAM532TuRJ8rvSZ3B2cNnZXTSGm7ldYxcMAhgo9moD16fLKcIUSvL6R
        yVIxfOBtZdZlnS+2F7Iodf7GDub+tRJdiQqokA64Sg==
X-Google-Smtp-Source: ABdhPJy77HTayF09PFUNcICsPeTkCOhu4N740FI0aXYKibNRW8+pW/LyPi05K3YfDRh2mU45tPbueFYZwrHkzpxQsFQ=
X-Received: by 2002:a6b:5c05:: with SMTP id z5mr23804155ioh.181.1637607362708;
 Mon, 22 Nov 2021 10:56:02 -0800 (PST)
MIME-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com> <20211119235759.1304274-6-dmatlack@google.com>
 <CANgfPd-L0iA9Yxf4PtSY4q2c0QZ168s5X3DjLhzTBGjw3YGVHA@mail.gmail.com>
In-Reply-To: <CANgfPd-L0iA9Yxf4PtSY4q2c0QZ168s5X3DjLhzTBGjw3YGVHA@mail.gmail.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 22 Nov 2021 10:55:51 -0800
Message-ID: <CANgfPd8L80wXdDUOUJr8F3vcmtH0RodfF5ndqFpfEDMGBA7GAg@mail.gmail.com>
Subject: Re: [RFC PATCH 05/15] KVM: x86/mmu: Abstract mmu caches out to a
 separate struct
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 22, 2021 at 10:55 AM Ben Gardon <bgardon@google.com> wrote:
>
> On Fri, Nov 19, 2021 at 3:58 PM David Matlack <dmatlack@google.com> wrote:
> >
> > Move the kvm_mmu_memory_cache structs into a separate wrapper struct.
> > This is in preparation for eagerly splitting all large pages during
> > VM-ioctls (i.e. not in the vCPU fault path) which will require adding
> > kvm_mmu_memory_cache structs to struct kvm_arch.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
>
> Reviewed-by: Ben Gardon

Woops
Reviewed-by: Ben Gardon <bgardon@google.com>

>
> I don't think this patch creates any functional change. If that's the
> intent, it'd be worth noting.
>
>
> > ---
> >  arch/x86/include/asm/kvm_host.h | 12 ++++---
> >  arch/x86/kvm/mmu/mmu.c          | 59 ++++++++++++++++++++++-----------
> >  arch/x86/kvm/mmu/tdp_mmu.c      |  7 ++--
> >  3 files changed, 52 insertions(+), 26 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 1fcb345bc107..2a7564703ea6 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -612,6 +612,13 @@ struct kvm_vcpu_xen {
> >         u64 runstate_times[4];
> >  };
> >
> > +struct kvm_mmu_memory_caches {
> > +       struct kvm_mmu_memory_cache pte_list_desc_cache;
> > +       struct kvm_mmu_memory_cache shadow_page_cache;
> > +       struct kvm_mmu_memory_cache gfn_array_cache;
> > +       struct kvm_mmu_memory_cache page_header_cache;
> > +};
> > +
> >  struct kvm_vcpu_arch {
> >         /*
> >          * rip and regs accesses must go through
> > @@ -681,10 +688,7 @@ struct kvm_vcpu_arch {
> >          */
> >         struct kvm_mmu *walk_mmu;
> >
> > -       struct kvm_mmu_memory_cache mmu_pte_list_desc_cache;
> > -       struct kvm_mmu_memory_cache mmu_shadow_page_cache;
> > -       struct kvm_mmu_memory_cache mmu_gfn_array_cache;
> > -       struct kvm_mmu_memory_cache mmu_page_header_cache;
> > +       struct kvm_mmu_memory_caches mmu_caches;
> >
> >         /*
> >          * QEMU userspace and the guest each have their own FPU state.
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 1146f87044a6..537952574211 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -732,38 +732,60 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
> >
> >  static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
> >  {
> > +       struct kvm_mmu_memory_caches *mmu_caches;
> >         int r;
> >
> > +       mmu_caches = &vcpu->arch.mmu_caches;
> > +
> >         /* 1 rmap, 1 parent PTE per level, and the prefetched rmaps. */
> > -       r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
> > +       r = kvm_mmu_topup_memory_cache(&mmu_caches->pte_list_desc_cache,
> >                                        1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
> >         if (r)
> >                 return r;
> > -       r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
> > +       r = kvm_mmu_topup_memory_cache(&mmu_caches->shadow_page_cache,
> >                                        PT64_ROOT_MAX_LEVEL);
> >         if (r)
> >                 return r;
> >         if (maybe_indirect) {
> > -               r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_gfn_array_cache,
> > +               r = kvm_mmu_topup_memory_cache(&mmu_caches->gfn_array_cache,
> >                                                PT64_ROOT_MAX_LEVEL);
> >                 if (r)
> >                         return r;
> >         }
> > -       return kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache,
> > +       return kvm_mmu_topup_memory_cache(&mmu_caches->page_header_cache,
> >                                           PT64_ROOT_MAX_LEVEL);
> >  }
> >
> >  static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
> >  {
> > -       kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
> > -       kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
> > -       kvm_mmu_free_memory_cache(&vcpu->arch.mmu_gfn_array_cache);
> > -       kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
> > +       struct kvm_mmu_memory_caches *mmu_caches;
> > +
> > +       mmu_caches = &vcpu->arch.mmu_caches;
> > +
> > +       kvm_mmu_free_memory_cache(&mmu_caches->pte_list_desc_cache);
> > +       kvm_mmu_free_memory_cache(&mmu_caches->shadow_page_cache);
> > +       kvm_mmu_free_memory_cache(&mmu_caches->gfn_array_cache);
> > +       kvm_mmu_free_memory_cache(&mmu_caches->page_header_cache);
> > +}
> > +
> > +static void mmu_init_memory_caches(struct kvm_mmu_memory_caches *caches)
> > +{
> > +       caches->pte_list_desc_cache.kmem_cache = pte_list_desc_cache;
> > +       caches->pte_list_desc_cache.gfp_zero = __GFP_ZERO;
> > +
> > +       caches->page_header_cache.kmem_cache = mmu_page_header_cache;
> > +       caches->page_header_cache.gfp_zero = __GFP_ZERO;
> > +
> > +       caches->shadow_page_cache.gfp_zero = __GFP_ZERO;
> >  }
> >
> >  static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_vcpu *vcpu)
> >  {
> > -       return kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_pte_list_desc_cache);
> > +       struct kvm_mmu_memory_caches *mmu_caches;
> > +
> > +       mmu_caches = &vcpu->arch.mmu_caches;
> > +
> > +       return kvm_mmu_memory_cache_alloc(&mmu_caches->pte_list_desc_cache);
> >  }
> >
> >  static void mmu_free_pte_list_desc(struct pte_list_desc *pte_list_desc)
> > @@ -1071,7 +1093,7 @@ static bool rmap_can_add(struct kvm_vcpu *vcpu)
> >  {
> >         struct kvm_mmu_memory_cache *mc;
> >
> > -       mc = &vcpu->arch.mmu_pte_list_desc_cache;
> > +       mc = &vcpu->arch.mmu_caches.pte_list_desc_cache;
> >         return kvm_mmu_memory_cache_nr_free_objects(mc);
> >  }
> >
> > @@ -1742,12 +1764,15 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
> >
> >  static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct)
> >  {
> > +       struct kvm_mmu_memory_caches *mmu_caches;
> >         struct kvm_mmu_page *sp;
> >
> > -       sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> > -       sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> > +       mmu_caches = &vcpu->arch.mmu_caches;
> > +
> > +       sp = kvm_mmu_memory_cache_alloc(&mmu_caches->page_header_cache);
> > +       sp->spt = kvm_mmu_memory_cache_alloc(&mmu_caches->shadow_page_cache);
> >         if (!direct)
> > -               sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
> > +               sp->gfns = kvm_mmu_memory_cache_alloc(&mmu_caches->gfn_array_cache);
> >         set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> >
> >         /*
> > @@ -5544,13 +5569,7 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
> >  {
> >         int ret;
> >
> > -       vcpu->arch.mmu_pte_list_desc_cache.kmem_cache = pte_list_desc_cache;
> > -       vcpu->arch.mmu_pte_list_desc_cache.gfp_zero = __GFP_ZERO;
> > -
> > -       vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
> > -       vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
> > -
> > -       vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
> > +       mmu_init_memory_caches(&vcpu->arch.mmu_caches);
> >
> >         vcpu->arch.mmu = &vcpu->arch.root_mmu;
> >         vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 9ee3f4f7fdf5..b70707a7fe87 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -175,10 +175,13 @@ static union kvm_mmu_page_role page_role_for_level(struct kvm_vcpu *vcpu,
> >  static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
> >                                                int level)
> >  {
> > +       struct kvm_mmu_memory_caches *mmu_caches;
> >         struct kvm_mmu_page *sp;
> >
> > -       sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> > -       sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> > +       mmu_caches = &vcpu->arch.mmu_caches;
> > +
> > +       sp = kvm_mmu_memory_cache_alloc(&mmu_caches->page_header_cache);
> > +       sp->spt = kvm_mmu_memory_cache_alloc(&mmu_caches->shadow_page_cache);
> >         set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> >
> >         sp->role.word = page_role_for_level(vcpu, level).word;
> > --
> > 2.34.0.rc2.393.gf8c9666880-goog
> >
