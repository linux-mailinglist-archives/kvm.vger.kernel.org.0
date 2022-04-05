Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1438C4F49C1
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443573AbiDEWUd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573284AbiDESpH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 14:45:07 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B914665D
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 11:43:08 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id c15-20020a17090a8d0f00b001c9c81d9648so338496pjo.2
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 11:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gJzgf6Iv7oB5UObDvwzbFk36ZZGoaQK9bnZLN2Tfs0I=;
        b=dgrOzknUexQlIuSO+UjRiz9jxgdigSYnBe18OMPFHJmoInfbp0RTx3iP3nX0re5w2D
         2yATSMDka5uUkazSNorU5+RzCuIFrkoaqTG4niTIIRA0kbedlJP1YPpA/gSFs01VA0XT
         RCLP+rvo51n+lo0L1mQaoiYAguNg0KmlaQuIdsiofu2HxNAzVZVNhhboGOCu4yvHbDzN
         HifJvc9wpolcl55L9k5Gk6uwI/6hrARP1V447PbCCeVRGWH0nmHjTWqL1hIWfywk+8mJ
         XKAOo1X4bVDpvmjDtTuQT+VyLq5qGRLkGuBPqsx9AS3xJEElddp20H7lPdkP8TqpTm2k
         Tgag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gJzgf6Iv7oB5UObDvwzbFk36ZZGoaQK9bnZLN2Tfs0I=;
        b=fc1J0WQ+TuO812+7lIgthHXfnJLnQPlTC+X+Mn1Tm2XyX+Oy1kUpsGa095HFSwaap7
         dDf6Q3eoHwri0GZtNOqmEUBK6hMb5pNvQ/xd0FhW339nv9ys2LrGasuO3eJXoXU+bmyP
         aCB4YrHfDc6MIWCly33HI4ty6ULH566465tEfZxwVHl3RhMBi+s+HkVVs8WCMSLvZaP1
         yQoVTc7Zw6RRY6eUltU02YHXU7DU+L3mU/KkFRLnSuI2Yl9PmXID6blOCeKxeE0gBbai
         OowJDNbhHMbolx0PPB/0uKzCJp3TkJo9cHB/013EFPhDVfaZ2Iu8BeGu3b4p7Fs2yRlc
         X6bw==
X-Gm-Message-State: AOAM532hFeP+meoKmS1bTwdVBmKcGI+sIMOyJ7obFxiAQP/7rvyBNThQ
        Nrym2RWvjOFvwadk9G1J5pUNQXWRbCcNY+cUqkF+zQ==
X-Google-Smtp-Source: ABdhPJztmY9sKoIZGd2pBBxy+j0lCdDyauuyXo3K3iNX+i0+Jo9L6G0cSIGxeW7Lc3sUwy/E7R2SlI1z13djM4MonNg=
X-Received: by 2002:a17:90b:4c0a:b0:1c6:90be:1e03 with SMTP id
 na10-20020a17090b4c0a00b001c690be1e03mr5799953pjb.7.1649184187870; Tue, 05
 Apr 2022 11:43:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220311001252.195690-1-yosryahmed@google.com> <YkOo6iM9YUACsNGF@google.com>
In-Reply-To: <YkOo6iM9YUACsNGF@google.com>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Tue, 5 Apr 2022 11:42:32 -0700
Message-ID: <CAJD7tkYMJGC9uJkhqegfCW1XLJCLfauC3_M_bgy+81LaW0jURg@mail.gmail.com>
Subject: Re: [PATCH] KVM: memcg: count KVM page table pages used by KVM in
 memcg pagetable stats
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Junaid Shahid <junaids@google.com>,
        David Matlack <dmatlack@google.com>, kvm@vger.kernel.org
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

On Tue, Mar 29, 2022 at 5:48 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Mar 11, 2022, Yosry Ahmed wrote:
> > Count the pages used by KVM for page tables in pagetable memcg stats in
> > memory.stat.
>
> Why?  Is it problematic to count these as kernel memory as opposed to page tables?
> What is gained/lost by tracking these as page table allocations?  E.g. won't this
> pollute the information about the host page tables for the userpace process?
>
> When you asked about stats, I thought you meant KVM stats :-)

Thanks for taking the time to look into this. I followed up with a v2
patch series with the rationale behind this change in the cover
letter.

Basically we maintain different kernel memory stats on different
levels (global, per-node, per-memcg, ..), this includes the total kmem
usage, in addition to the significant components (page tables,
vmalloc, stack, ...). This gives users insights to what the kmem usage
is made up of.

As for polluting the information about the host page tables, the pages
used by KVM for page tables are still page tables, and the user should
be aware of the workload they are running. If I am running a VM I
should be expecting more page tables usage for the guest as well.

>
> > Most pages used for KVM page tables come from the mmu_shadow_page_cache,
> > in addition to a few allocations in __kvm_mmu_create() and
> > mmu_alloc_special_roots().
> >
> > For allocations from the mmu_shadow_page_cache, the pages are counted as
> > pagetables when they are actually used by KVM (when
> > mmu_memory_cache_alloc_obj() is called), rather than when they are
> > allocated in the cache itself. In other words, pages sitting in the
> > cache are not counted as pagetables (they are still accounted as kernel
> > memory).
> >
> > The reason for this is to avoid the complexity and confusion of
> > incrementing the stats in the cache layer, while decerementing them
> > by the cache users when they are being freed (pages are freed directly
> > and not returned to the cache).
> > For the sake of simplicity, the stats are incremented and decremented by
> > the users of the cache when they get the page and when they free it.
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  7 +++++++
> >  arch/x86/kvm/mmu/mmu.c          | 19 +++++++++++++++++++
> >  arch/x86/kvm/mmu/tdp_mmu.c      |  4 ++++
> >  virt/kvm/kvm_main.c             | 17 +++++++++++++++++
> >  4 files changed, 47 insertions(+)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index f72e80178ffc..4a1dda2f56e1 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -458,6 +458,13 @@ struct kvm_mmu {
> >       */
> >       u32 pkru_mask;
> >
> > +     /*
> > +      * After a page is allocated for any of these roots,
> > +      * increment per-memcg pagetable stats by calling:
> > +      * inc_lruvec_page_state(page, NR_PAGETABLE)
> > +      * Before the page is freed, decrement the stats by calling:
> > +      * dec_lruvec_page_state(page, NR_PAGETABLE).
> > +      */
> >       u64 *pae_root;
> >       u64 *pml4_root;
> >       u64 *pml5_root;
>
> Eh, I would much prefer we don't bother counting these.  They're barely page
> tables, more like necessary evils.  And hopefully they'll be gone soon[*].

These were ignored in v2.

>
> [*] https://lore.kernel.org/all/20220329153604.507475-1-jiangshanlai@gmail.com
>
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 3b8da8b0745e..5f87e1b0da91 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1673,7 +1673,10 @@ static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
> >       MMU_WARN_ON(!is_empty_shadow_page(sp->spt));
> >       hlist_del(&sp->hash_link);
> >       list_del(&sp->link);
> > +
> > +     dec_lruvec_page_state(virt_to_page(sp->spt), NR_PAGETABLE);
>
> I would strongly prefer to add new helpers to combine this accounting with KVM's
> existing accounting.  E.g. for the legacy (not tdp_mmu.c) MMU code

Thanks a lot for the suggestion. I followed this in both legacy and
tdp mmu code for x86 and the diff is much cleaner.

>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 1361eb4599b4..c2cb642157cc 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1668,6 +1668,18 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
>         percpu_counter_add(&kvm_total_used_mmu_pages, nr);
>  }
>
> +static void kvm_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> +{
> +       kvm_mod_used_mmu_pages(kvm, 1);
> +       inc_lruvec_page_state(..., NR_PAGETABLE);
> +}
> +
> +static void kvm_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> +{
> +       kvm_mod_used_mmu_pages(kvm, -1);
> +       dec_lruvec_page_state(..., NR_PAGETABLE);
> +}
> +
>  static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
>  {
>         MMU_WARN_ON(!is_empty_shadow_page(sp->spt));
> @@ -1723,7 +1735,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct
>          */
>         sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
>         list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
> -       kvm_mod_used_mmu_pages(vcpu->kvm, +1);
> +       kvm_account_mmu_page(vcpu->kvm, sp);
>         return sp;
>  }
>
> @@ -2339,7 +2351,7 @@ static bool __kvm_mmu_prepare_zap_page(struct kvm *kvm,
>                         list_add(&sp->link, invalid_list);
>                 else
>                         list_move(&sp->link, invalid_list);
> -               kvm_mod_used_mmu_pages(kvm, -1);
> +               kvm_unaccount_mmu_page(kvm, sp);
>         } else {
>                 /*
>                  * Remove the active root from the active page list, the root
>
>
> >       free_page((unsigned long)sp->spt);
> > +
>
> There's a lot of spurious whitespace change in this patch.

Took care of this in v2. I was trying to separate the stats update
from kvm logic visually.

>
> >       if (!sp->role.direct)
> >               free_page((unsigned long)sp->gfns);
> >       kmem_cache_free(mmu_page_header_cache, sp);
> > @@ -1711,7 +1714,10 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct
> >       struct kvm_mmu_page *sp;
> >
> >       sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> > +
>
> More whitespace, though it should just naturally go away.
>
> >       sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> > +     inc_lruvec_page_state(virt_to_page(sp->spt), NR_PAGETABLE);
> > +
> >       if (!direct)
> >               sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
> >       set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> > @@ -3602,6 +3608,10 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
> >       mmu->pml4_root = pml4_root;
> >       mmu->pml5_root = pml5_root;
> >
> > +     /* Update per-memcg pagetable stats */
> > +     inc_lruvec_page_state(virt_to_page(pae_root), NR_PAGETABLE);
> > +     inc_lruvec_page_state(virt_to_page(pml4_root), NR_PAGETABLE);
> > +     inc_lruvec_page_state(virt_to_page(pml5_root), NR_PAGETABLE);
> >       return 0;
> >
> >  #ifdef CONFIG_X86_64
> > @@ -5554,6 +5564,12 @@ static void free_mmu_pages(struct kvm_mmu *mmu)
> >  {
> >       if (!tdp_enabled && mmu->pae_root)
> >               set_memory_encrypted((unsigned long)mmu->pae_root, 1);
> > +
> > +     /* Update per-memcg pagetable stats */
> > +     dec_lruvec_page_state(virt_to_page(mmu->pae_root), NR_PAGETABLE);
> > +     dec_lruvec_page_state(virt_to_page(mmu->pml4_root), NR_PAGETABLE);
> > +     dec_lruvec_page_state(virt_to_page(mmu->pml5_root), NR_PAGETABLE);
> > +
> >       free_page((unsigned long)mmu->pae_root);
> >       free_page((unsigned long)mmu->pml4_root);
> >       free_page((unsigned long)mmu->pml5_root);
> > @@ -5591,6 +5607,9 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
> >       if (!page)
> >               return -ENOMEM;
> >
> > +     /* Update per-memcg pagetable stats */
> > +     inc_lruvec_page_state(page, NR_PAGETABLE);
> > +
> >       mmu->pae_root = page_address(page);
> >
> >       /*
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index af60922906ef..ce8930fd0835 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -64,6 +64,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
> >
> >  static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
> >  {
> > +     dec_lruvec_page_state(virt_to_page(sp->spt), NR_PAGETABLE);
>
> I'd prefer to do this in tdp_mmu_{,un}link_sp(), it saves having to add calls in
> all paths that allocate TDP MMU pages.

Followed this in v2.

Thanks for your review, the version of this patch in v2 is indeed much
cleaner and more readable!
