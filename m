Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E12694C7E65
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 00:29:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiB1Xad (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Feb 2022 18:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiB1Xad (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Feb 2022 18:30:33 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D83113F1C
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 15:29:52 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id v22so19590377ljh.7
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 15:29:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yPpMXidYeHF1dqJftGCaz/AfgN/H1D78ppB5nb3Wex8=;
        b=slgbMMyPAZC6PIsUocUM+g01AkMWPnISgf9kp4QhmYSZnwHKpcY9XhoM8YVvxqPjNV
         EMxdI2cosa9ZuDdzelchVvPXVzc255cj5Y3IxhVsueB7EZI9VCmwyMKNnJrN+0ZDSkw8
         BhgUiCWalDDAnsyPMVa3aFp4P04gyTjwz/4UNugrIRk6gfrFPdrUPqmSND47dqyvf5Dz
         u30CNhqQG5rvi/RjS/t7ddoY2hShdudSC1phRVaTtPxfZyFmFg9Jcx5vDHCdoziu09yk
         79lweb+JD537bvwGD/dCOf0bnf9HDKVTV8nWK2hFeqUaVioFRDm8HfGBzaIcThyPDR9J
         yuJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yPpMXidYeHF1dqJftGCaz/AfgN/H1D78ppB5nb3Wex8=;
        b=hTy26NPVzfUb2CASp5Z3jO+Fi/SrGEyqgL3tA7+Tz07afZs0pesY4+yMLmJhVQ8lqO
         kJJtDEdLlL5gYaGWv/vO1SWUI6GEgpF94Zot9QHn4rGPxgVAY6HuXskKtaf3prN8TMgy
         kLSeiq+QyangswOOMSKpoQOjbS9hnMcR5c+6a8vxfs0PiekPZ7XfFlVLKEUauLMbyP02
         y4X1Y5AYjWOHfwnYRNJlwxvH7P2/CmkR1kd77Kl0nMrKZ23JeQCfJgiLHpqjqo6Ass09
         gW8aJcXfMFehxvDzCfgDVb/tctwqeRmr8N587xKC9R8ENKtum2VSE0hALjRSbVAkqefW
         XV4Q==
X-Gm-Message-State: AOAM530lzByZ+RVt4hxCDRYQCH8sio9xv2/8e2s7T7np9eMVHoqaZkZX
        SbQEW8OF5AGHzu4l0npkRchLDAjJ/A2pi7oH7hMtZ0ac74DLdw==
X-Google-Smtp-Source: ABdhPJxYEm6Rfuw11F0KjwkpGJTaR2x/GG+uIgTHn1k9lAuA1WbqF4BJwJYOvo+ajGLprlXCvLgVwrIldW8Jf4hFQbw=
X-Received: by 2002:a2e:925a:0:b0:246:4233:3835 with SMTP id
 v26-20020a2e925a000000b0024642333835mr15008205ljg.361.1646090990410; Mon, 28
 Feb 2022 15:29:50 -0800 (PST)
MIME-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com> <20220203010051.2813563-19-dmatlack@google.com>
 <CANgfPd_o6G2TrUgn+YCO84yvqbpjjSN_U==OxLO9X9D_yAGJ0g@mail.gmail.com>
In-Reply-To: <CANgfPd_o6G2TrUgn+YCO84yvqbpjjSN_U==OxLO9X9D_yAGJ0g@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 28 Feb 2022 15:29:23 -0800
Message-ID: <CALzav=d9yq0Yh8Y+Yn5MhH_ufp+3SB2z4D0mhc15u=meSM7myw@mail.gmail.com>
Subject: Re: [PATCH 18/23] KVM: x86/mmu: Extend Eager Page Splitting to the
 shadow MMU
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
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 28, 2022 at 1:09 PM Ben Gardon <bgardon@google.com> wrote:
>
>  a
>
> On Wed, Feb 2, 2022 at 5:03 PM David Matlack <dmatlack@google.com> wrote:
> >
> > Extend KVM's eager page splitting to also split huge pages that are
> > mapped by the shadow MMU. Specifically, walk through the rmap splitting
> > all 1GiB pages to 2MiB pages, and splitting all 2MiB pages to 4KiB
> > pages.
> >
> > Splitting huge pages mapped by the shadow MMU requries dealing with some
> > extra complexity beyond that of the TDP MMU:
> >
> > (1) The shadow MMU has a limit on the number of shadow pages that are
> >     allowed to be allocated. So, as a policy, Eager Page Splitting
> >     refuses to split if there are KVM_MIN_FREE_MMU_PAGES or fewer
> >     pages available.
> >
> > (2) Huge pages may be mapped by indirect shadow pages which have the
> >     possibility of being unsync. As a policy we opt not to split such
> >     pages as their translation may no longer be valid.
> >
> > (3) Splitting a huge page may end up re-using an existing lower level
> >     shadow page tables. This is unlike the TDP MMU which always allocates
> >     new shadow page tables when splitting.  This commit does *not*
> >     handle such aliasing and opts not to split such huge pages.
> >
> > (4) When installing the lower level SPTEs, they must be added to the
> >     rmap which may require allocating additional pte_list_desc structs.
> >     This commit does *not* handle such cases and instead opts to leave
> >     such lower-level SPTEs non-present. In this situation TLBs must be
> >     flushed before dropping the MMU lock as a portion of the huge page
> >     region is being unmapped.
> >
> > Suggested-by: Peter Feiner <pfeiner@google.com>
> > [ This commit is based off of the original implementation of Eager Page
> >   Splitting from Peter in Google's kernel from 2016. ]
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  .../admin-guide/kernel-parameters.txt         |   3 -
> >  arch/x86/kvm/mmu/mmu.c                        | 349 ++++++++++++++++++
> >  2 files changed, 349 insertions(+), 3 deletions(-)
> >
> > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> > index 1b54e410e206..09d236cb15d6 100644
> > --- a/Documentation/admin-guide/kernel-parameters.txt
> > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > @@ -2351,9 +2351,6 @@
> >                         the KVM_CLEAR_DIRTY ioctl, and only for the pages being
> >                         cleared.
> >
> > -                       Eager page splitting currently only supports splitting
> > -                       huge pages mapped by the TDP MMU.
> > -
> >                         Default is Y (on).
> >
> >         kvm.enable_vmware_backdoor=[KVM] Support VMware backdoor PV interface.
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 2d47a54e62a5..825cfdec589b 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -738,6 +738,11 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
> >
> >  static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_mmu_memory_cache *cache)
> >  {
> > +       static const gfp_t gfp_nocache = GFP_ATOMIC | __GFP_ACCOUNT | __GFP_ZERO;
> > +
> > +       if (WARN_ON_ONCE(!cache))
> > +               return kmem_cache_alloc(pte_list_desc_cache, gfp_nocache);
> > +
> >         return kvm_mmu_memory_cache_alloc(cache);
> >  }
>
> Is this change needed in this commit? In the description it says we're
> just skipping the split if a pte_list_desc needs to be allocated.

I made this change out of an abundance of caution since this commit
passes NULL to __rmap_add() and __link_shadow_page(). But yes, you are
right, this code should never be hit in practice (hence the WARN_ON).

>
> >
> > @@ -754,6 +759,28 @@ static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
> >         return sp->gfn + (index << ((sp->role.level - 1) * PT64_LEVEL_BITS));
> >  }
> >
> > +static gfn_t sptep_to_gfn(u64 *sptep)
> > +{
> > +       struct kvm_mmu_page *sp = sptep_to_sp(sptep);
> > +
> > +       return kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
> > +}
> > +
> > +static unsigned int kvm_mmu_page_get_access(struct kvm_mmu_page *sp, int index)
> > +{
> > +       if (!sp->role.direct)
> > +               return sp->shadowed_translation[index].access;
> > +
> > +       return sp->role.access;
> > +}
> > +
> > +static unsigned int sptep_to_access(u64 *sptep)
> > +{
> > +       struct kvm_mmu_page *sp = sptep_to_sp(sptep);
> > +
> > +       return kvm_mmu_page_get_access(sp, sptep - sp->spt);
> > +}
> > +
> >  static void kvm_mmu_page_set_gfn_access(struct kvm_mmu_page *sp, int index,
> >                                         gfn_t gfn, u32 access)
> >  {
> > @@ -923,6 +950,41 @@ static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
> >         return count;
> >  }
> >
> > +static struct kvm_rmap_head *gfn_to_rmap(gfn_t gfn, int level,
> > +                                        const struct kvm_memory_slot *slot);
> > +
> > +static bool pte_list_need_new_desc(struct kvm_rmap_head *rmap_head)
> > +{
> > +       struct pte_list_desc *desc;
> > +
> > +       if (!rmap_head->val)
> > +               return false;
> > +
> > +       if (!(rmap_head->val & 1))
> > +               return true;
> > +
> > +       desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
> > +       while (desc->spte_count == PTE_LIST_EXT) {
> > +               if (!desc->more)
> > +                       return true;
> > +               desc = desc->more;
> > +       }
> > +
> > +       return false;
> > +}
> > +
> > +/*
> > + * Return true if the rmap for the given gfn and level needs a new
> > + * pte_list_desc struct allocated to add a new spte.
> > + */
> > +static bool rmap_need_new_pte_list_desc(const struct kvm_memory_slot *slot,
> > +                                       gfn_t gfn, int level)
> > +{
> > +       struct kvm_rmap_head *rmap_head = gfn_to_rmap(gfn, level, slot);
> > +
> > +       return pte_list_need_new_desc(rmap_head);
> > +}
> > +
> >  static void
> >  pte_list_desc_remove_entry(struct kvm_rmap_head *rmap_head,
> >                            struct pte_list_desc *desc, int i,
> > @@ -2129,6 +2191,24 @@ static struct kvm_mmu_page *kvm_mmu_get_existing_sp_maybe_unsync(struct kvm *kvm
> >         return sp;
> >  }
> >
> > +static struct kvm_mmu_page *kvm_mmu_get_existing_direct_sp(struct kvm *kvm,
> > +                                                          gfn_t gfn,
> > +                                                          union kvm_mmu_page_role role)
> > +{
> > +       struct kvm_mmu_page *sp;
> > +       LIST_HEAD(invalid_list);
> > +
> > +       BUG_ON(!role.direct);
> > +
> > +       sp = kvm_mmu_get_existing_sp_maybe_unsync(kvm, gfn, role, &invalid_list);
> > +
> > +       /* Direct SPs are never unsync. */
> > +       WARN_ON_ONCE(sp && sp->unsync);
> > +
> > +       kvm_mmu_commit_zap_page(kvm, &invalid_list);
>
> This should be unnecessary since the page can't be unsync right?
> I'd be inclined to also add an assertion that invalid_list is empty
> and then BUG or terminate the VM if it's not.

You might be right in practice but the code in kvm_mmu_get_page() (aka
kvm_mmu_get_existing_sp() in this series) does not read that way.
Specifically, KVM zaps unsync SPs that match the same GFN, even if the
target SP is not unsync.

>
> > +       return sp;
> > +}
> > +
> >  /*
> >   * Looks up an existing SP for the given gfn and role if one exists. The
> >   * return SP is guaranteed to be synced.
> > @@ -5955,12 +6035,275 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
> >                 kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
> >  }
> >
> > +
> > +static int alloc_memory_for_split(struct kvm *kvm, struct kvm_mmu_page **spp, gfp_t gfp)
> > +{
> > +       if (*spp)
> > +               return 0;
> > +
> > +       *spp = kvm_mmu_alloc_direct_sp_for_split(gfp);
> > +
> > +       return *spp ? 0 : -ENOMEM;
> > +}
>
> I assume this is preparation for a more complicated allocation scheme
> in a future commit. I'd be inclined to wait on that until it's needed
> as this looks unnecessarily complicated.

Ack.

>
> > +
> > +static int prepare_to_split_huge_page(struct kvm *kvm,
> > +                                     const struct kvm_memory_slot *slot,
> > +                                     u64 *huge_sptep,
> > +                                     struct kvm_mmu_page **spp,
> > +                                     bool *flush,
> > +                                     bool *dropped_lock)
> > +{
> > +       int r = 0;
> > +
> > +       *dropped_lock = false;
> > +
> > +       if (kvm_mmu_available_pages(kvm) <= KVM_MIN_FREE_MMU_PAGES)
> > +               return -ENOSPC;
> > +
> > +       if (need_resched() || rwlock_needbreak(&kvm->mmu_lock))
> > +               goto drop_lock;
> > +
> > +       r = alloc_memory_for_split(kvm, spp, GFP_NOWAIT | __GFP_ACCOUNT);
> > +       if (r)
> > +               goto drop_lock;
> > +
> > +       return 0;
> > +
> > +drop_lock:
> > +       if (*flush)
> > +               kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
> > +
> > +       *flush = false;
> > +       *dropped_lock = true;
> > +
> > +       write_unlock(&kvm->mmu_lock);
> > +       cond_resched();
> > +       r = alloc_memory_for_split(kvm, spp, GFP_KERNEL_ACCOUNT);
>
> You're using different sets of flags in these allocations. Is that
> intentional? I understand the NOWAIT, but there's also a difference
> between GFP_KERNEL_ACCOUNT and __GFP_ACCOUNT which I'm not sure about.

Yes this is intentional. GFP_KERNEL_ACCOUNT is just a convenience
macro for GFP_KERNEL | __GFP_ACCOUNT.

We want allocations to be charged the same way, hence we always use
__GFP_ACCOUNT. But when allocating under the lock we don't want to
block on filesystem callbacks and reclaim, hence GFP_NOWAIT in place
of GFP_KERNEL.

>
> > +       write_lock(&kvm->mmu_lock);
> > +
> > +       return r;
> > +}
> > +
> > +static struct kvm_mmu_page *kvm_mmu_get_sp_for_split(struct kvm *kvm,
> > +                                                    const struct kvm_memory_slot *slot,
> > +                                                    u64 *huge_sptep,
> > +                                                    struct kvm_mmu_page **spp)
> > +{
> > +       struct kvm_mmu_page *huge_sp = sptep_to_sp(huge_sptep);
> > +       struct kvm_mmu_page *split_sp;
> > +       union kvm_mmu_page_role role;
> > +       unsigned int access;
> > +       gfn_t gfn;
> > +
> > +       gfn = sptep_to_gfn(huge_sptep);
> > +       access = sptep_to_access(huge_sptep);
> > +
> > +       /*
> > +        * Huge page splitting always uses direct shadow pages since we are
> > +        * directly mapping the huge page GFN region with smaller pages.
> > +        */
> > +       role = kvm_mmu_child_role(huge_sp, true, access);
> > +       split_sp = kvm_mmu_get_existing_direct_sp(kvm, gfn, role);
> > +
> > +       /*
> > +        * Opt not to split if the lower-level SP already exists. This requires
> > +        * more complex handling as the SP may be already partially filled in
> > +        * and may need extra pte_list_desc structs to update parent_ptes.
> > +        */
> > +       if (split_sp)
> > +               return NULL;
> > +
> > +       swap(split_sp, *spp);
> > +       kvm_mmu_init_sp(kvm, split_sp, slot, gfn, role);
> > +       trace_kvm_mmu_get_page(split_sp, true);
> > +
> > +       return split_sp;
> > +}
> > +
> > +static int kvm_mmu_split_huge_page(struct kvm *kvm,
> > +                                  const struct kvm_memory_slot *slot,
> > +                                  u64 *huge_sptep, struct kvm_mmu_page **spp,
> > +                                  bool *flush)
> > +
> > +{
> > +       struct kvm_mmu_page *split_sp;
> > +       u64 huge_spte, split_spte;
> > +       int split_level, index;
> > +       unsigned int access;
> > +       u64 *split_sptep;
> > +       gfn_t split_gfn;
> > +
> > +       split_sp = kvm_mmu_get_sp_for_split(kvm, slot, huge_sptep, spp);
> > +       if (!split_sp)
> > +               return -EOPNOTSUPP;
> > +
> > +       /*
> > +        * Since we did not allocate pte_list_desc_structs for the split, we
> > +        * cannot add a new parent SPTE to parent_ptes. This should never happen
> > +        * in practice though since this is a fresh SP.
> > +        *
> > +        * Note, this makes it safe to pass NULL to __link_shadow_page() below.
> > +        */
> > +       if (WARN_ON_ONCE(pte_list_need_new_desc(&split_sp->parent_ptes)))
> > +               return -EINVAL;
> > +
> > +       huge_spte = READ_ONCE(*huge_sptep);
> > +
> > +       split_level = split_sp->role.level;
> > +       access = split_sp->role.access;
> > +
> > +       for (index = 0; index < PT64_ENT_PER_PAGE; index++) {
> > +               split_sptep = &split_sp->spt[index];
> > +               split_gfn = kvm_mmu_page_get_gfn(split_sp, index);
> > +
> > +               BUG_ON(is_shadow_present_pte(*split_sptep));
> > +
> > +               /*
> > +                * Since we did not allocate pte_list_desc structs for the
> > +                * split, we can't add a new SPTE that maps this GFN.
> > +                * Skipping this SPTE means we're only partially mapping the
> > +                * huge page, which means we'll need to flush TLBs before
> > +                * dropping the MMU lock.
> > +                *
> > +                * Note, this make it safe to pass NULL to __rmap_add() below.
> > +                */
> > +               if (rmap_need_new_pte_list_desc(slot, split_gfn, split_level)) {
> > +                       *flush = true;
> > +                       continue;
> > +               }
> > +
> > +               split_spte = make_huge_page_split_spte(
> > +                               huge_spte, split_level + 1, index, access);
> > +
> > +               mmu_spte_set(split_sptep, split_spte);
> > +               __rmap_add(kvm, NULL, slot, split_sptep, split_gfn, access);
> > +       }
> > +
> > +       /*
> > +        * Replace the huge spte with a pointer to the populated lower level
> > +        * page table. Since we are making this change without a TLB flush vCPUs
> > +        * will see a mix of the split mappings and the original huge mapping,
> > +        * depending on what's currently in their TLB. This is fine from a
> > +        * correctness standpoint since the translation will be the same either
> > +        * way.
> > +        */
> > +       drop_large_spte(kvm, huge_sptep, false);
> > +       __link_shadow_page(NULL, huge_sptep, split_sp);
> > +
> > +       return 0;
> > +}
> > +
> > +static bool should_split_huge_page(u64 *huge_sptep)
> > +{
> > +       struct kvm_mmu_page *huge_sp = sptep_to_sp(huge_sptep);
> > +
> > +       if (WARN_ON_ONCE(!is_large_pte(*huge_sptep)))
> > +               return false;
> > +
> > +       if (huge_sp->role.invalid)
> > +               return false;
> > +
> > +       /*
> > +        * As a policy, do not split huge pages if SP on which they reside
> > +        * is unsync. Unsync means the guest is modifying the page table being
> > +        * shadowed by huge_sp, so splitting may be a waste of cycles and
> > +        * memory.
> > +        */
> > +       if (huge_sp->unsync)
> > +               return false;
> > +
> > +       return true;
> > +}
> > +
> > +static bool rmap_try_split_huge_pages(struct kvm *kvm,
> > +                                     struct kvm_rmap_head *rmap_head,
> > +                                     const struct kvm_memory_slot *slot)
> > +{
> > +       struct kvm_mmu_page *sp = NULL;
> > +       struct rmap_iterator iter;
> > +       u64 *huge_sptep, spte;
> > +       bool flush = false;
> > +       bool dropped_lock;
> > +       int level;
> > +       gfn_t gfn;
> > +       int r;
> > +
> > +restart:
> > +       for_each_rmap_spte(rmap_head, &iter, huge_sptep) {
> > +               if (!should_split_huge_page(huge_sptep))
> > +                       continue;
> > +
> > +               spte = *huge_sptep;
> > +               level = sptep_to_sp(huge_sptep)->role.level;
> > +               gfn = sptep_to_gfn(huge_sptep);
> > +
> > +               r = prepare_to_split_huge_page(kvm, slot, huge_sptep, &sp, &flush, &dropped_lock);
> > +               if (r) {
> > +                       trace_kvm_mmu_split_huge_page(gfn, spte, level, r);
> > +                       break;
> > +               }
> > +
> > +               if (dropped_lock)
> > +                       goto restart;
> > +
> > +               r = kvm_mmu_split_huge_page(kvm, slot, huge_sptep, &sp, &flush);
> > +
> > +               trace_kvm_mmu_split_huge_page(gfn, spte, level, r);
> > +
> > +               /*
> > +                * If splitting is successful we must restart the iterator
> > +                * because huge_sptep has just been removed from it.
> > +                */
> > +               if (!r)
> > +                       goto restart;
> > +       }
> > +
> > +       if (sp)
> > +               kvm_mmu_free_sp(sp);
> > +
> > +       return flush;
> > +}
> > +
> > +static void kvm_rmap_try_split_huge_pages(struct kvm *kvm,
> > +                                         const struct kvm_memory_slot *slot,
> > +                                         gfn_t start, gfn_t end,
> > +                                         int target_level)
> > +{
> > +       bool flush;
> > +       int level;
> > +
> > +       /*
> > +        * Split huge pages starting with KVM_MAX_HUGEPAGE_LEVEL and working
> > +        * down to the target level. This ensures pages are recursively split
> > +        * all the way to the target level. There's no need to split pages
> > +        * already at the target level.
> > +        *
> > +        * Note that TLB flushes must be done before dropping the MMU lock since
> > +        * rmap_try_split_huge_pages() may partially split any given huge page,
> > +        * i.e. it may effectively unmap (make non-present) a portion of the
> > +        * huge page.
> > +        */
> > +       for (level = KVM_MAX_HUGEPAGE_LEVEL; level > target_level; level--) {
> > +               flush = slot_handle_level_range(kvm, slot,
> > +                                               rmap_try_split_huge_pages,
> > +                                               level, level, start, end - 1,
> > +                                               true, flush);
> > +       }
> > +
> > +       if (flush)
> > +               kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
> > +}
> > +
> >  /* Must be called with the mmu_lock held in write-mode. */
> >  void kvm_mmu_try_split_huge_pages(struct kvm *kvm,
> >                                    const struct kvm_memory_slot *memslot,
> >                                    u64 start, u64 end,
> >                                    int target_level)
> >  {
> > +       if (kvm_memslots_have_rmaps(kvm))
> > +               kvm_rmap_try_split_huge_pages(kvm, memslot, start, end,
> > +                                             target_level);
> > +
> >         if (is_tdp_mmu_enabled(kvm))
> >                 kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end,
> >                                                  target_level, false);
> > @@ -5978,6 +6321,12 @@ void kvm_mmu_slot_try_split_huge_pages(struct kvm *kvm,
> >         u64 start = memslot->base_gfn;
> >         u64 end = start + memslot->npages;
> >
> > +       if (kvm_memslots_have_rmaps(kvm)) {
> > +               write_lock(&kvm->mmu_lock);
> > +               kvm_rmap_try_split_huge_pages(kvm, memslot, start, end, target_level);
> > +               write_unlock(&kvm->mmu_lock);
> > +       }
> > +
> >         if (is_tdp_mmu_enabled(kvm)) {
> >                 read_lock(&kvm->mmu_lock);
> >                 kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end, target_level, true);
> > --
> > 2.35.0.rc2.247.g8bbb082509-goog
> >
