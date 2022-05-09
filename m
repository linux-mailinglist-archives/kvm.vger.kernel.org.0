Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 370245206DA
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 23:45:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiEIVsp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 17:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbiEIVsn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 17:48:43 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AABA7245C58
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 14:44:48 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id d15so17598736lfk.5
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 14:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9xP9hLvPwnUH8e9dgAvhQrikoxQHFodB+z+wqUWV91k=;
        b=rS5oGooY0KklvJmBrLth8CCp/JghorHPD5I3RfSvIosSZ6sp55/tniDhAAT0E+7aVj
         g4vHRlFWlxdE48xcOdm1UGRx5vvHrjQA4yj4rNzUcJN05d+wRPZMxyPB9wbS/fksVtyL
         4pHst3TQ1NhkStcR0pxLZJnLRmxdxvumOQqRxZfZxkz7vHK4FxDkwSx2F+OcEUbhq2TK
         gOoFwoafn+Lw2NzKm4LnEkvwpLsU+8VRDHco1PUj98ET1R9k948SMnjxiMHhbTofnSyd
         AYNwtBJ321iTNxiCRZXhLnNDXQIJvuJjargWNdsqhm5B5B5ANl/Qpr9bpTDWLIIuUCD8
         1yrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9xP9hLvPwnUH8e9dgAvhQrikoxQHFodB+z+wqUWV91k=;
        b=pp3mVVR5YSol+7Pz8RUd45o1eiUhDVxMlGqPYZjtfICVsxPtjOgQy+i7jUosoK07wP
         ZPBBOEkDxW8n6HGWsplzL3cNQVml6a99VvA2fE7o2gXp0EWY4MkfxwFdeX/KlS0Hfa5U
         qb/KyOSY9TJP+rObVnQGYZNOW2IBxbzF4y6Lw0P7Vhgo7pjW6+w7O6eYr1I30lPMgrPR
         P1RZmJYVZ1hggF/jUFXS3asJFntK5lJnaEaU24cCps7aMXkYKEynd0ev9t6HbsTrvlYN
         jfaFxjtZ0mNoMkIK+KEOTWsZXyKHUt3F5Y/PlwdR2H3sRO+o7p8GkY5dVgmFGtD4mZ48
         q7+Q==
X-Gm-Message-State: AOAM5314z+KvlcoCoT1e53TB9c63utgEEFfXR6gIw4xTVXf6ImXn3cj+
        BDP8PqoNe8dqnCNKn6LY5iXdgM7rqToZF1hyJmqZzQ==
X-Google-Smtp-Source: ABdhPJx3BtgeAqKYip4mEOFwVPQ8MYIyXpXFHYcWEc3DABXKaw2hfpEtfVb5UyzuC5+W/qADzrNyQ8ZO+QHAsNRqGl8=
X-Received: by 2002:ac2:4c54:0:b0:473:a414:1768 with SMTP id
 o20-20020ac24c54000000b00473a4141768mr14007574lfk.537.1652132686814; Mon, 09
 May 2022 14:44:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com> <20220422210546.458943-21-dmatlack@google.com>
 <YnlFzMpJZNfFuFic@google.com>
In-Reply-To: <YnlFzMpJZNfFuFic@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 9 May 2022 14:44:20 -0700
Message-ID: <CALzav=fTTf8=u1i0pePxAHtuHr4Q_+N1-d8x09MtRk+6y250rw@mail.gmail.com>
Subject: Re: [PATCH v4 20/20] KVM: x86/mmu: Extend Eager Page Splitting to
 nested MMUs
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
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

On Mon, May 9, 2022 at 9:48 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Fri, Apr 22, 2022, David Matlack wrote:
> > +static bool need_topup_split_caches_or_resched(struct kvm *kvm)
> > +{
> > +     if (need_resched() || rwlock_needbreak(&kvm->mmu_lock))
> > +             return true;
> > +
> > +     /*
> > +      * In the worst case, SPLIT_DESC_CACHE_CAPACITY descriptors are needed
> > +      * to split a single huge page. Calculating how many are actually needed
> > +      * is possible but not worth the complexity.
> > +      */
> > +     return need_topup(&kvm->arch.split_desc_cache, SPLIT_DESC_CACHE_CAPACITY) ||
> > +             need_topup(&kvm->arch.split_page_header_cache, 1) ||
> > +             need_topup(&kvm->arch.split_shadow_page_cache, 1);
>
> Uber nit that Paolo will make fun of me for... please align indentiation
>
>         return need_topup(&kvm->arch.split_desc_cache, SPLIT_DESC_CACHE_CAPACITY) ||
>                need_topup(&kvm->arch.split_page_header_cache, 1) ||
>                need_topup(&kvm->arch.split_shadow_page_cache, 1);

Will do.

>
> > +static void nested_mmu_split_huge_page(struct kvm *kvm,
> > +                                    const struct kvm_memory_slot *slot,
> > +                                    u64 *huge_sptep)
> > +
> > +{
> > +     struct kvm_mmu_memory_cache *cache = &kvm->arch.split_desc_cache;
> > +     u64 huge_spte = READ_ONCE(*huge_sptep);
> > +     struct kvm_mmu_page *sp;
> > +     bool flush = false;
> > +     u64 *sptep, spte;
> > +     gfn_t gfn;
> > +     int index;
> > +
> > +     sp = nested_mmu_get_sp_for_split(kvm, huge_sptep);
> > +
> > +     for (index = 0; index < PT64_ENT_PER_PAGE; index++) {
> > +             sptep = &sp->spt[index];
> > +             gfn = kvm_mmu_page_get_gfn(sp, index);
> > +
> > +             /*
> > +              * The SP may already have populated SPTEs, e.g. if this huge
> > +              * page is aliased by multiple sptes with the same access
> > +              * permissions. These entries are guaranteed to map the same
> > +              * gfn-to-pfn translation since the SP is direct, so no need to
> > +              * modify them.
> > +              *
> > +              * However, if a given SPTE points to a lower level page table,
> > +              * that lower level page table may only be partially populated.
> > +              * Installing such SPTEs would effectively unmap a potion of the
> > +              * huge page, which requires a TLB flush.
>
> Maybe explain why a TLB flush is required?  E.g. "which requires a TLB flush as
> a subsequent mmu_notifier event on the unmapped region would fail to detect the
> need to flush".

Will do.

>
> > +static bool nested_mmu_skip_split_huge_page(u64 *huge_sptep)
>
> "skip" is kinda odd terminology.  It reads like a command, but it's actually
> querying state _and_ it's returning a boolean, which I've learned to hate :-)
>
> I don't see any reason for a helper, there's one caller and it can just do
> "continue" directly.

Will do.

>
> > +static void kvm_nested_mmu_try_split_huge_pages(struct kvm *kvm,
> > +                                             const struct kvm_memory_slot *slot,
> > +                                             gfn_t start, gfn_t end,
> > +                                             int target_level)
> > +{
> > +     int level;
> > +
> > +     /*
> > +      * Split huge pages starting with KVM_MAX_HUGEPAGE_LEVEL and working
> > +      * down to the target level. This ensures pages are recursively split
> > +      * all the way to the target level. There's no need to split pages
> > +      * already at the target level.
> > +      */
> > +     for (level = KVM_MAX_HUGEPAGE_LEVEL; level > target_level; level--) {
>
> Unnecessary braces.

The brace is unnecessary, but when the inner statement is split across
multiple lines I tend to prefer using braces. (That's why I did the
same in the other patch and you had the same feedback.) I couldn't
find any guidance about this in CodingStyle so I'm fine with getting
rid of the braces if that's what you prefer.

> > +             slot_handle_level_range(kvm, slot,
> > +                                     nested_mmu_try_split_huge_pages,
> > +                                     level, level, start, end - 1,
> > +                                     true, false);
>
> IMO it's worth running over by 4 chars to drop 2 lines:

Will do.

>
>         for (level = KVM_MAX_HUGEPAGE_LEVEL; level > target_level; level--)
>                 slot_handle_level_range(kvm, slot, nested_mmu_try_split_huge_pages,
>                                         level, level, start, end - 1, true, false);
> > +     }
> > +}
> > +
> >  /* Must be called with the mmu_lock held in write-mode. */
>
> Add a lockdep assertion, not a comment.

Agreed but this is an existing comment, so better left to a separate patch.

>
> >  void kvm_mmu_try_split_huge_pages(struct kvm *kvm,
> >                                  const struct kvm_memory_slot *memslot,
> >                                  u64 start, u64 end,
> >                                  int target_level)
> >  {
> > -     if (is_tdp_mmu_enabled(kvm))
> > -             kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end,
> > -                                              target_level, false);
> > +     if (!is_tdp_mmu_enabled(kvm))
> > +             return;
> > +
> > +     kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end, target_level,
> > +                                      false);
> > +
> > +     if (kvm_memslots_have_rmaps(kvm))
> > +             kvm_nested_mmu_try_split_huge_pages(kvm, memslot, start, end,
> > +                                                 target_level);
> >
> >       /*
> >        * A TLB flush is unnecessary at this point for the same resons as in
> > @@ -6051,10 +6304,19 @@ void kvm_mmu_slot_try_split_huge_pages(struct kvm *kvm,
> >       u64 start = memslot->base_gfn;
> >       u64 end = start + memslot->npages;
> >
> > -     if (is_tdp_mmu_enabled(kvm)) {
> > -             read_lock(&kvm->mmu_lock);
> > -             kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end, target_level, true);
> > -             read_unlock(&kvm->mmu_lock);
> > +     if (!is_tdp_mmu_enabled(kvm))
> > +             return;
> > +
> > +     read_lock(&kvm->mmu_lock);
> > +     kvm_tdp_mmu_try_split_huge_pages(kvm, memslot, start, end, target_level,
> > +                                      true);
>
> Eh, let this poke out.

Will do :)

>
> > +     read_unlock(&kvm->mmu_lock);
> > +
> > +     if (kvm_memslots_have_rmaps(kvm)) {
> > +             write_lock(&kvm->mmu_lock);
> > +             kvm_nested_mmu_try_split_huge_pages(kvm, memslot, start, end,
> > +                                                 target_level);
> > +             write_unlock(&kvm->mmu_lock);
>
> Super duper nit: all other flows do rmaps first, than TDP MMU.  Might as well keep
> that ordering here, otherwise it suggests there's a reason to be different.

Will do.
>
> >       }
> >
> >       /*
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index ab336f7c82e4..e123e24a130f 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -12161,6 +12161,12 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
> >                * page faults will create the large-page sptes.
> >                */
> >               kvm_mmu_zap_collapsible_sptes(kvm, new);
> > +
> > +             /*
> > +              * Free any memory left behind by eager page splitting. Ignore
> > +              * the module parameter since userspace might have changed it.
> > +              */
> > +             free_split_caches(kvm);
> >       } else {
> >               /*
> >                * Initially-all-set does not require write protecting any page,
> > --
> > 2.36.0.rc2.479.g8af0fa9b8e-goog
> >
