Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EED750E7CF
	for <lists+kvm@lfdr.de>; Mon, 25 Apr 2022 20:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244231AbiDYSM4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Apr 2022 14:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233522AbiDYSMy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Apr 2022 14:12:54 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 985EF10772E
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 11:09:49 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id v59so15636694ybi.12
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 11:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WRagUqgnu2gqfsSAzpstirBXqrGhb5L7ntYnE2F3DSk=;
        b=QuBa8iSMQOkRUAVzJ3Ab4dD33gjR+lDzFSyrbJKZU+//n7cs+hIAqMkuAzEnZD9aDA
         Y5664bLmc3BZahwmRMp1PoE1dpm/0dGu00UZllehq4Lsno/bi1IOibXxkppaH2ur0Zc/
         yBxRkABByL+Au9vUoWR8Wsft+yNGGFhK2x3av0ZAdWWojRmdJWPC9F/6H61zwjHUAabw
         T9fVTUCiVWmtLm2+PeyA81c0BZXh5KGZA6Gz0eda/9+KZuZ1W6wfkuDqdz/8OOLH15x7
         mBHp+7GqknOgHbAq0cI4TrIKgkOe2Qxlx941dO5R7cNwcFEDsvLh3cWbdzTCjYjvgnHz
         mkFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WRagUqgnu2gqfsSAzpstirBXqrGhb5L7ntYnE2F3DSk=;
        b=d0PLX6Wo1SQeUjK96SdBQfWBYsAsp2IxRSsC3qDeVCAjA+i4z6UTNsXSAEvbquYQyY
         QpEHu2mRYbHfkXTOIXkebuRWne8Ev/Od7UIcnDaz/sTxU5nyKL7qXMHp64R74PjmRaci
         r68KYhNRFa12MQYFH2ApN7bzBxy2soZ5HBTvpoMVncUbHOJQaIiS5HSpdvRmg0wDcSZS
         DvgzbJRXaCL3bawRZ7IkNjUz76dkTJM8U05/dfTRVIrjDlpmJJkMH0+pO3av3RjSVLll
         1nkZqR4Qohqc6VN43qkFotecnOV/BaLXoQ8FdycHNX/CFZH3UL8q3rsqQfH3wWtzfEsw
         G84Q==
X-Gm-Message-State: AOAM531bohyJ1T9ZMp6HSW424bVZ5ag54be3sxMB8mRVauxO1bY9nwhl
        Dfo0g+yHRAeUR5BaLz8IJnL2WOXF9n3aW4NXp9P4gA==
X-Google-Smtp-Source: ABdhPJy3iUOb/6VCyCYzrq9KvSQ6wbAHKZGBfT5I4pRcKji+0lRG1H+gtWT5t/vUvxdc3y/4/EDppG7ZuY/qUCS9teE=
X-Received: by 2002:a25:8546:0:b0:61e:1d34:ec71 with SMTP id
 f6-20020a258546000000b0061e1d34ec71mr16122201ybn.259.1650910188589; Mon, 25
 Apr 2022 11:09:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220321224358.1305530-1-bgardon@google.com> <20220321224358.1305530-10-bgardon@google.com>
 <YlWsImxP0C01BUtM@google.com>
In-Reply-To: <YlWsImxP0C01BUtM@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Mon, 25 Apr 2022 11:09:37 -0700
Message-ID: <CANgfPd-xxxzV3fp55Gx3Y_5ugfkcXMiipvgBMvYHVvAEdhrAMQ@mail.gmail.com>
Subject: Re: [PATCH v2 9/9] KVM: x86/mmu: Promote pages in-place when
 disabling dirty logging
To:     Sean Christopherson <seanjc@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 12, 2022 at 9:43 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Mar 21, 2022, Ben Gardon wrote:
> > diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> > index 1bff453f7cbe..6c08a5731fcb 100644
> > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > @@ -171,4 +171,10 @@ void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
> >  void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
> >  void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
> >
> > +void
> > +build_tdp_shadow_zero_bits_mask(struct rsvd_bits_validate *shadow_zero_check,
> > +                             int shadow_root_level);
>
> Same comments from the earlier patch.
>
> > +extern int max_huge_page_level __read_mostly;
>
> Can you put this at the top of the heaader?  x86.h somehow ended up with extern
> variables being declared in the middle of the file and I find it very jarring,
> e.g. global definitions are pretty much never buried in the middle of a .c file.

Will do. I'm working on a v3 of this series now.

>
>
> >  #endif /* __KVM_X86_MMU_INTERNAL_H */
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index af60922906ef..eb8929e394ec 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -1709,6 +1709,66 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
> >               clear_dirty_pt_masked(kvm, root, gfn, mask, wrprot);
> >  }
> >
> > +static bool try_promote_lpage(struct kvm *kvm,
>
> I believe we've settled on huge_page instead of lpage.
>
> And again, I strongly prefer a 0/-errno return instead of a boolean as seeing
> -EBUSY or whatever makes it super obviously that the early returns are failure
> paths.

Will do. To your and David's comments about retries, this makes the
retry scheme really nice and clean.

>
> > +                           const struct kvm_memory_slot *slot,
> > +                           struct tdp_iter *iter)
> > +{
> > +     struct kvm_mmu_page *sp = sptep_to_sp(iter->sptep);
> > +     struct rsvd_bits_validate shadow_zero_check;
> > +     bool map_writable;
> > +     kvm_pfn_t pfn;
> > +     u64 new_spte;
> > +     u64 mt_mask;
> > +
> > +     /*
> > +      * If addresses are being invalidated, don't do in-place promotion to
> > +      * avoid accidentally mapping an invalidated address.
> > +      */
> > +     if (unlikely(kvm->mmu_notifier_count))
> > +             return false;
> > +
> > +     if (iter->level > max_huge_page_level || iter->gfn < slot->base_gfn ||
> > +         iter->gfn >= slot->base_gfn + slot->npages)
> > +             return false;
> > +
> > +     pfn = __gfn_to_pfn_memslot(slot, iter->gfn, true, NULL, true,
> > +                                &map_writable, NULL);
> > +     if (is_error_noslot_pfn(pfn))
> > +             return false;
> > +
> > +     /*
> > +      * Can't reconstitute an lpage if the consituent pages can't be
>
> "huge page", though honestly I'd just drop the comment, IMO this is more intuitive
> then say the checks against the slot stuff above.
>
> > +      * mapped higher.
> > +      */
> > +     if (iter->level > kvm_mmu_max_mapping_level(kvm, slot, iter->gfn,
> > +                                                 pfn, PG_LEVEL_NUM))
> > +             return false;
> > +
> > +     build_tdp_shadow_zero_bits_mask(&shadow_zero_check, iter->root_level);
> > +
> > +     /*
> > +      * In some cases, a vCPU pointer is required to get the MT mask,
> > +      * however in most cases it can be generated without one. If a
> > +      * vCPU pointer is needed kvm_x86_try_get_mt_mask will fail.
> > +      * In that case, bail on in-place promotion.
> > +      */
> > +     if (unlikely(!static_call(kvm_x86_try_get_mt_mask)(kvm, iter->gfn,
>
> I wouldn't bother with the "unlikely".  It's wrong for a VM with non-coherent DMA,
> and it's very unlikely (heh) to actually be a meaningful optimization in any case.
>
> > +                                                        kvm_is_mmio_pfn(pfn),
> > +                                                        &mt_mask)))
> > +             return false;
> > +
> > +     __make_spte(kvm, sp, slot, ACC_ALL, iter->gfn, pfn, 0, false, true,
>
> A comment stating the return type is intentionally ignore would be helpful.  Not
> strictly necessary because it's mostly obvious after looking at the details, but
> it'd save someone from having to dig into said details.
>
> > +               map_writable, mt_mask, &shadow_zero_check, &new_spte);
>
> Bad indentation.
>
> > +
> > +     if (tdp_mmu_set_spte_atomic(kvm, iter, new_spte))
> > +             return true;
>
> And by returning an int, and because the failure path rereads the SPTE for you,
> this becomes:
>
>         return tdp_mmu_set_spte_atomic(kvm, iter, new_spte);
>
> > +
> > +     /* Re-read the SPTE as it must have been changed by another thread. */
> > +     iter->old_spte = READ_ONCE(*rcu_dereference(iter->sptep));
> > +
> > +     return false;
> > +}
> > +
> >  /*
> >   * Clear leaf entries which could be replaced by large mappings, for
> >   * GFNs within the slot.
>
> This comment needs to be updated to include the huge page promotion behavior. And
> maybe renamed the function too?  E.g.
>
> static void zap_or_promote_collapsible_sptes(struct kvm *kvm,
>                                              struct kvm_mmu_page *root,
>                                              const struct kvm_memory_slot *slot)
>
> > @@ -1729,8 +1789,17 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
> >               if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
> >                       continue;
> >
> > -             if (!is_shadow_present_pte(iter.old_spte) ||
> > -                 !is_last_spte(iter.old_spte, iter.level))
> > +             if (iter.level > max_huge_page_level ||
> > +                 iter.gfn < slot->base_gfn ||
> > +                 iter.gfn >= slot->base_gfn + slot->npages)
>
> Isn't this exact check in try_promote_lpage()?  Ditto for the kvm_mmu_max_mapping_level()
> check that's just out of sight.  That one in particular can be somewhat expsensive,
> especially when KVM is fixed to use a helper that disable IRQs so the host page tables
> aren't freed while they're being walked.  Oh, and the huge page promotion path
> doesn't incorporate the reserved pfn check.
>
> In other words, shouldn't this be:
>
>
>                 if (!is_shadow_present_pte(iter.old_spte))
>                         continue;
>
>                 if (iter.level > max_huge_page_level ||
>                     iter.gfn < slot->base_gfn ||
>                     iter.gfn >= slot->base_gfn + slot->npages)
>                         continue;
>
>                 pfn = spte_to_pfn(iter.old_spte);
>                 if (kvm_is_reserved_pfn(pfn) ||
>                     iter.level >= kvm_mmu_max_mapping_level(kvm, slot, iter.gfn,
>                                                             pfn, PG_LEVEL_NUM))
>                         continue;
>
> Followed by the promotion stuff.  And then unless I'm overlooking something, "pfn"
> can be passed into try_promote_huge_page(), it just needs to be masked appropriately.
> I.e. the promotion path can avoid the __gfn_to_pfn_memslot() lookup and also drop
> its is_error_noslot_pfn() check since the pfn is pulled from the SPTE and KVM should
> never install garbage into the SPTE (emulated/noslot MMIO pfns fail the shadow
> present check).

I'll work on deduplicating the checks. The big distinction is that in
the promotion function, the iterator is still at the non-leaf SPTE, so
if we get the PFN from the SPTE, it'll be the PFN of a page table, not
a PFN backing guest memory. I could use the same GFN to PFN memslot
conversion in both cases, but it seems more expensive than extracting
the PFN from the SPTE.

__gfn_to_pfn_memslot should never return a reserved PFN right?

>
> > +                     continue;
> > +
> > +             if (!is_shadow_present_pte(iter.old_spte))
> > +                     continue;
>
> I strongly prefer to keep the !is_shadow_present_pte() check first, it really
> should be the first thing any of these flows check.
>
> > +
> > +             /* Try to promote the constitutent pages to an lpage. */
> > +             if (!is_last_spte(iter.old_spte, iter.level) &&
> > +                 try_promote_lpage(kvm, slot, &iter))
>
> There is an undocumented function change here, and I can't tell if it's intentional.
> If the promotion fails, KVM continues on an zaps the non-leaf shadow page.  If that
> is intentional behavior, it should be done in a follow-up patch, e.g. so that it can
> be easily reverted if it turns out that zappping e.g. a PUD is bad for performance.
>
> I.e. shouldn't this be:
>
>                 if (!is_last_spte(iter.old_spte, iter.level)) {
>                         try_promote_huge_page(...);
>                         continue;
>                 }
>
> and then converted to the current variant in a follow-up?

Ah, good point.

>
> >                       continue;
> >
> >               pfn = spte_to_pfn(iter.old_spte);
> > --
> > 2.35.1.894.gb6a874cedc-goog
> >
