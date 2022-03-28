Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52D8F4E9EDE
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 20:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244988AbiC1SWm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 14:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240614AbiC1SWl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 14:22:41 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C329C237D5
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 11:20:59 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id w7so26244563lfd.6
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 11:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1vLAv1KOlCRxpDZItVyZbMpKfcQXoowxC7+HEkoBdy4=;
        b=o30vEfNBFnnK30LBoZ01uwe+RsC8PrLrIPZyVcX3SB0+mOjLfVPG5xbF3NovYExpPI
         EEg5269QO2Y16wVVrAPmiihiVOftHZvuYQ8m6P7rJ3uLLZRtzJ4VnZ4PDBFedIRGFMzE
         JYR+5M/tKvQReQ5kuzCbYE6w7QMRxTiaAl1woRfEMmTSdr4gmrZ/tCzVVFVzOfRzubTO
         AFCyc+PK4iIIFptdO6tJfYBTLctLWuFXh39583b+1IqywifxH8O6t7eE4oqaoQpfptCt
         WygHvoIgohWd2+CEbmoJu+zg584vgqan6f+4GDVe5lYSPmVyNWyToXgUmwS/5Ve9t621
         fAsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1vLAv1KOlCRxpDZItVyZbMpKfcQXoowxC7+HEkoBdy4=;
        b=0jbFLarp8MJ9jd1pT6rwASbn+nFc13pO91L4lTWj3a1+MMqr7fxfAu1ONDHgQltPAp
         VSS2OGiiMJizJqoqdeQiXR6ACBoFNrFgNl0jtGZhwzSAzZFQhzykizsesvZowsSZeptt
         6y5H7bqj70QulibT0QsObPgdL3Aipk3IU2vx3oJqFKLlQ54jnF2F/y3r2n16cfIiBpad
         eHb6F/LDn02Xk8bHNjm4zwpgrTnDuCx6zQVNI1aAIAMPogiO0B6sknX4qDQqQngs6GUF
         ySIU1ZyrbZaGBjGXokIQDY1MqH0iE49vXx22qSIg2v92H9ab1nOtOS1VbHqyjOY0EGI8
         4FKg==
X-Gm-Message-State: AOAM5305ToBurH1Nsz9eeHkSIci+AdTSZrW5+4yMwTERG8+AIx5Hix/l
        czDdKWdmnLtI9lZ0pGFpyYnBosAlV4o7V+02y4dDTA==
X-Google-Smtp-Source: ABdhPJyOCaYlsyW7m833jqFR0CsDT6nnCGkhGM8Le9SAY4UeZpOrpm0wz9G7b+yyFXFGXhfGClkkTwzaO3vErZoZ4J4=
X-Received: by 2002:a05:6512:3341:b0:433:b033:bd22 with SMTP id
 y1-20020a056512334100b00433b033bd22mr21026170lfd.190.1648491656532; Mon, 28
 Mar 2022 11:20:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220321224358.1305530-1-bgardon@google.com> <20220321224358.1305530-10-bgardon@google.com>
 <YkH0O2Qh7lRizGtC@google.com> <CANgfPd8V_34TBb3m-JpmczZnY3t5aaFwHNZq1W0eknumbrXCRw@mail.gmail.com>
In-Reply-To: <CANgfPd8V_34TBb3m-JpmczZnY3t5aaFwHNZq1W0eknumbrXCRw@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 28 Mar 2022 11:20:30 -0700
Message-ID: <CALzav=e7Aj3=pU8HaQWH57b9pLu=n3E9o4tKk8d2n==9s-e2WQ@mail.gmail.com>
Subject: Re: [PATCH v2 9/9] KVM: x86/mmu: Promote pages in-place when
 disabling dirty logging
To:     Ben Gardon <bgardon@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
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

On Mon, Mar 28, 2022 at 11:07 AM Ben Gardon <bgardon@google.com> wrote:
>
> On Mon, Mar 28, 2022 at 10:45 AM David Matlack <dmatlack@google.com> wrote:
> >
> > On Mon, Mar 21, 2022 at 03:43:58PM -0700, Ben Gardon wrote:
> > > When disabling dirty logging, the TDP MMU currently zaps each leaf entry
> > > mapping memory in the relevant memslot. This is very slow. Doing the zaps
> > > under the mmu read lock requires a TLB flush for every zap and the
> > > zapping causes a storm of ETP/NPT violations.
> > >
> > > Instead of zapping, replace the split large pages with large page
> > > mappings directly. While this sort of operation has historically only
> > > been done in the vCPU page fault handler context, refactorings earlier
> > > in this series and the relative simplicity of the TDP MMU make it
> > > possible here as well.
> > >
> > > Running the dirty_log_perf_test on an Intel Skylake with 96 vCPUs and 1G
> > > of memory per vCPU, this reduces the time required to disable dirty
> > > logging from over 45 seconds to just over 1 second. It also avoids
> > > provoking page faults, improving vCPU performance while disabling
> > > dirty logging.
> > >
> > > Signed-off-by: Ben Gardon <bgardon@google.com>
> > > ---
> > >  arch/x86/kvm/mmu/mmu.c          |  4 +-
> > >  arch/x86/kvm/mmu/mmu_internal.h |  6 +++
> > >  arch/x86/kvm/mmu/tdp_mmu.c      | 73 ++++++++++++++++++++++++++++++++-
> > >  3 files changed, 79 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 6f98111f8f8b..a99c23ef90b6 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -100,7 +100,7 @@ module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
> > >   */
> > >  bool tdp_enabled = false;
> > >
> > > -static int max_huge_page_level __read_mostly;
> > > +int max_huge_page_level;
> > >  static int tdp_root_level __read_mostly;
> > >  static int max_tdp_level __read_mostly;
> > >
> > > @@ -4486,7 +4486,7 @@ static inline bool boot_cpu_is_amd(void)
> > >   * the direct page table on host, use as much mmu features as
> > >   * possible, however, kvm currently does not do execution-protection.
> > >   */
> > > -static void
> > > +void
> > >  build_tdp_shadow_zero_bits_mask(struct rsvd_bits_validate *shadow_zero_check,
> > >                               int shadow_root_level)
> > >  {
> > > diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> > > index 1bff453f7cbe..6c08a5731fcb 100644
> > > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > > @@ -171,4 +171,10 @@ void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
> > >  void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
> > >  void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
> > >
> > > +void
> > > +build_tdp_shadow_zero_bits_mask(struct rsvd_bits_validate *shadow_zero_check,
> > > +                             int shadow_root_level);
> > > +
> > > +extern int max_huge_page_level __read_mostly;
> > > +
> > >  #endif /* __KVM_X86_MMU_INTERNAL_H */
> > > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > > index af60922906ef..eb8929e394ec 100644
> > > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > > @@ -1709,6 +1709,66 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
> > >               clear_dirty_pt_masked(kvm, root, gfn, mask, wrprot);
> > >  }
> > >
> > > +static bool try_promote_lpage(struct kvm *kvm,
> > > +                           const struct kvm_memory_slot *slot,
> > > +                           struct tdp_iter *iter)
> >
> > Use "huge_page" instead of "lpage" to be consistent with eager page
> > splitting and the rest of the Linux kernel. Some of the old KVM methods
> > still use "lpage" and "large page", but we're slowly moving away from
> > that.
>
> Ah good catch. Paolo, if you want me to send a v2 to address all these
> comments, I can. Otherwise I'll just reply to the questions below.
>
> >
> > > +{
> > > +     struct kvm_mmu_page *sp = sptep_to_sp(iter->sptep);
> > > +     struct rsvd_bits_validate shadow_zero_check;
> > > +     bool map_writable;
> > > +     kvm_pfn_t pfn;
> > > +     u64 new_spte;
> > > +     u64 mt_mask;
> > > +
> > > +     /*
> > > +      * If addresses are being invalidated, don't do in-place promotion to
> > > +      * avoid accidentally mapping an invalidated address.
> > > +      */
> > > +     if (unlikely(kvm->mmu_notifier_count))
> > > +             return false;
> >
> > Why is this necessary? Seeing this makes me wonder if we need a similar
> > check for eager page splitting.
>
> This is needed here, but not in the page splitting case, because we
> are potentially mapping new memory.
> If a page is split for dirt logging, but then the backing transparent
> huge page is split for some reason, we could race with the THP split.
> Since we're mapping the entire huge page, this could wind up mapping
> more memory than it should. Checking the MMU notifier count prevents
> that. It's not needed in the splitting case because the memory in
> question is already mapped. We're essentially trying to do what the
> page fault handler does, since we know that's safe and it's what
> replaces the zapped page with a huge page. The page fault handler
> checks for MMU notifiers, so we need to as well.
> >
> > > +
> > > +     if (iter->level > max_huge_page_level || iter->gfn < slot->base_gfn ||
> > > +         iter->gfn >= slot->base_gfn + slot->npages)
> > > +             return false;
> > > +
> > > +     pfn = __gfn_to_pfn_memslot(slot, iter->gfn, true, NULL, true,
> > > +                                &map_writable, NULL);
> > > +     if (is_error_noslot_pfn(pfn))
> > > +             return false;
> > > +
> > > +     /*
> > > +      * Can't reconstitute an lpage if the consituent pages can't be
> > > +      * mapped higher.
> > > +      */
> > > +     if (iter->level > kvm_mmu_max_mapping_level(kvm, slot, iter->gfn,
> > > +                                                 pfn, PG_LEVEL_NUM))
> > > +             return false;
> > > +
> > > +     build_tdp_shadow_zero_bits_mask(&shadow_zero_check, iter->root_level);
> > > +
> > > +     /*
> > > +      * In some cases, a vCPU pointer is required to get the MT mask,
> > > +      * however in most cases it can be generated without one. If a
> > > +      * vCPU pointer is needed kvm_x86_try_get_mt_mask will fail.
> > > +      * In that case, bail on in-place promotion.
> > > +      */
> > > +     if (unlikely(!static_call(kvm_x86_try_get_mt_mask)(kvm, iter->gfn,
> > > +                                                        kvm_is_mmio_pfn(pfn),
> > > +                                                        &mt_mask)))
> > > +             return false;
> > > +
> > > +     __make_spte(kvm, sp, slot, ACC_ALL, iter->gfn, pfn, 0, false, true,
> > > +               map_writable, mt_mask, &shadow_zero_check, &new_spte);
> > > +
> > > +     if (tdp_mmu_set_spte_atomic(kvm, iter, new_spte))
> > > +             return true;
> > > +
> > > +     /* Re-read the SPTE as it must have been changed by another thread. */
> > > +     iter->old_spte = READ_ONCE(*rcu_dereference(iter->sptep));
> >
> > Huge page promotion could be retried in this case.
>
> That's true, but retries always get complicated since we need to
> guarantee forward progress and then you get into counting retries and
> it adds complexity.

There's plenty of unbounding retrying in tdp_mmu.c (search for "goto
retry"). I think that' fine though. I can't imagine a scenario where a
thread is blocked retrying more than a few times.

> Given how rare this race should be, I'm inclined
> to just let it fall back to zapping the spte.

I think that's fine too. Although it'd be pretty easy to plumb by
checking for -EBUSY from tdp_mmu_set_spte_atomic().

Maybe just leave a comment explaining why we don't care about going
through the effort of retrying.

>
> >
> > > +
> > > +     return false;
> > > +}
> > > +
> > >  /*
> > >   * Clear leaf entries which could be replaced by large mappings, for
> > >   * GFNs within the slot.
> > > @@ -1729,8 +1789,17 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
> > >               if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
> > >                       continue;
> > >
> > > -             if (!is_shadow_present_pte(iter.old_spte) ||
> > > -                 !is_last_spte(iter.old_spte, iter.level))
> > > +             if (iter.level > max_huge_page_level ||
> > > +                 iter.gfn < slot->base_gfn ||
> > > +                 iter.gfn >= slot->base_gfn + slot->npages)
> >
> > I feel like I've been seeing this "does slot contain gfn" calculation a
> > lot in recent commits. It's probably time to create a helper function.
> > No need to do this clean up as part of your series though, unless you
> > want to :).
> >
> > > +                     continue;
> > > +
> > > +             if (!is_shadow_present_pte(iter.old_spte))
> > > +                     continue;
> > > +
> > > +             /* Try to promote the constitutent pages to an lpage. */
> > > +             if (!is_last_spte(iter.old_spte, iter.level) &&
> > > +                 try_promote_lpage(kvm, slot, &iter))
> > >                       continue;
> >
> > If iter.old_spte is not a leaf, the only loop would always continue to
> > the next SPTE. Now we try to promote it and if that fails we run through
> > the rest of the loop. This seems broken. For example, in the next line
> > we end up grabbing the pfn of the non-leaf SPTE (which would be the PFN
> > of the TDP MMU page table?) and treat that as the PFN backing this GFN,
> > which is wrong.
> >
> > In the worst case we end up zapping an SPTE that we didn't need to, but
> > we should still fix up this code.
> >
> > >
> > >               pfn = spte_to_pfn(iter.old_spte);
> > > --
> > > 2.35.1.894.gb6a874cedc-goog
> > >
