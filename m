Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09466464343
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 00:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345340AbhK3XdH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 18:33:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345779AbhK3Xc2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 18:32:28 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164F6C06174A
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 15:28:53 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id n12so58005862lfe.1
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 15:28:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CsdlASmUA3no22vSvUBJVVs3lWEUHzxw+AHaIqB42Tw=;
        b=XNYoYaFkabO1Nueih9SMncACkcrj5iZgMW0TAN8l2q/zVvIVyIauaOgi8CRznK8vd5
         yQj2h7xkoL9EgvGLsWgVhq4WBojX0viRrrsIZqJXlNK96+ph1oq/FPAEQnSVynydolZH
         c4n4gWThRBom0V8sShuCSRh8G6jy2Uxcnu5ixiKYmLzGiEBw1ju2uokIaaMLPHnaPODC
         hCkOIwPQ0uGPZq0ww0wtMdGiooHRRO32ln0jUxwEUVEEtv2v4y6eXbnp0HC9XFp1OvGa
         5TekVA1dBxEG+3D9ZV5ka6bpjQe0Aj/F4ez01dg/NeY8t2AgmRA7UzZp/XOYrntWFJ+Z
         q2fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CsdlASmUA3no22vSvUBJVVs3lWEUHzxw+AHaIqB42Tw=;
        b=THvm7wLpi098KKrqpbqC2mkKNWDPvxpZeb5WmbTe2n4xhbiS7Stg9K1Thy025odGH9
         Ix0ATWqa4ksKuzJKaspAQDfMk7y+/eELHXghnwIuEsEZE2uaLuZqsa9fngVYgh8w3hys
         5nYJmktAdD7NB8oVO/MjIwrms1q6ENVjc/hlvZalTO9roTdAJaD+0AMuzJSjlDhi46NM
         FHj4lvSwXfTsb6puxmJfv80utC5QDy44mEbLAxVaCBui6qvAULAjdNX26N4ZKTsIvnCT
         Dr0IjuLTOyVBBIAL5GBkl8j0be/bPAabWnx+9cqsCI1nvxMd2cxitPLw0+8NgmwL6RUy
         Bl8A==
X-Gm-Message-State: AOAM532dr+xHB9KeJBjSrZJM+xVD48qZq7Iy+aTDBAYNJJwIXRYaGvGf
        VxIUwsNTR8v5/RqBwEQbvW0hdXxu7tn2PoSxNGManA==
X-Google-Smtp-Source: ABdhPJyUGG2a0NWxWCGBL5JgrzGht3liPcUFH0bXFVS/gzwyB5nfdQB2+lY3qf43a6/cN3DgU2baZVKWpiVEvces7ms=
X-Received: by 2002:ac2:558d:: with SMTP id v13mr2295902lfg.190.1638314931116;
 Tue, 30 Nov 2021 15:28:51 -0800 (PST)
MIME-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com> <20211119235759.1304274-6-dmatlack@google.com>
 <CANgfPd-L0iA9Yxf4PtSY4q2c0QZ168s5X3DjLhzTBGjw3YGVHA@mail.gmail.com>
In-Reply-To: <CANgfPd-L0iA9Yxf4PtSY4q2c0QZ168s5X3DjLhzTBGjw3YGVHA@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 30 Nov 2021 15:28:24 -0800
Message-ID: <CALzav=fBr+-FMJO4w0u0kTycZ=N66NzRhaeDNKw0kmOuQU+ofQ@mail.gmail.com>
Subject: Re: [RFC PATCH 05/15] KVM: x86/mmu: Abstract mmu caches out to a
 separate struct
To:     Ben Gardon <bgardon@google.com>
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
>
> I don't think this patch creates any functional change. If that's the
> intent, it'd be worth noting.

Will do!

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
