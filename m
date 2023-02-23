Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690896A029E
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 06:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233267AbjBWF7h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 00:59:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233221AbjBWF7f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 00:59:35 -0500
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600B312BD3
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 21:59:33 -0800 (PST)
Received: by mail-vs1-xe35.google.com with SMTP id v27so5371847vsa.7
        for <kvm@vger.kernel.org>; Wed, 22 Feb 2023 21:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=voGsAay0JFyPNio8rcBV6wtwoqCyfm2R0MRGDG4+I/0=;
        b=Sqaq5lh2eaXDCN8btRTVSZgyL0HObVfsyAHIbkAC5IPrJvBu4OePPr88QW2SoSa6ep
         +tV8JGytOa9EN6vAFMfVVakotTH8kruySr8d6LyQ8aZtJw8MVvFq6UGr2ihfJ+Sby12E
         yEFq9ofnl/HzbGa+f/vvzGLPlVYlKR107c7BHjlb0/2AqFdXnlqia73cVnsPaJpneaVf
         cyJwZr8Y/LPWFkwkR90uY+zyu0yC9uDSP6cqPUQJM0gtK7m7L3t0TTfaDvT9XjR0Jp96
         z1+FsrLGy1fwgJo3UL8ogH6ZltcuoqAKUqeCwDDafL4G1L0fWx8W/MqKIuAnhoTcyQrf
         7kxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=voGsAay0JFyPNio8rcBV6wtwoqCyfm2R0MRGDG4+I/0=;
        b=CYPKlgZyXHrqb2Ung88HwhBqkfrofqPr3nTIfpFmjwLzYmguaz1xG1h9Hptl7j2I9z
         Vbg2HyvEwYxKbe+/dCvsW2BOtoMKJVQDdXZ56gcP1ebRRv9CnzltOs55y+rJ1H+7a3qt
         TUxoCJUuYC0eylig9XgjPm2jJk23+f20GYoncoQJOUITtsOGRNxkHCWqmHGGJddMKoLo
         eHBvQPkCHbglg4xEhAPKPIGGObjTsqgzIg8vmNz+VyaKLnULwK/H7XQcB8Ni82XTpCLn
         IaotC+7BadcX8N/115LvPgPCOkQ2UAhihILcPMVlqFTuiNTISg8KvjN8VMWiBMnI4K4v
         ipDA==
X-Gm-Message-State: AO0yUKVI4WBSStZ3WO8gdblxBJLVmypMnwElQl+tPJbwV0wnuhVXqd88
        oP/QsJBO8BR3HSAXkbT+mjfPKwukLxl1tojc9I2j1w==
X-Google-Smtp-Source: AK7set8VuRuV4VxywpIU3KkVLV5dhdtwJXtEFnsgQIUvofFMrP6yngToGpMhoAq4t4jKNWH2TZiaOGQVBfK1rFiYhoY=
X-Received: by 2002:a05:6102:108f:b0:41e:d8b5:ee40 with SMTP id
 s15-20020a056102108f00b0041ed8b5ee40mr558056vsr.26.1677131972255; Wed, 22 Feb
 2023 21:59:32 -0800 (PST)
MIME-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com> <20230217041230.2417228-3-yuzhao@google.com>
 <Y++q/lglE6FJBdjt@google.com>
In-Reply-To: <Y++q/lglE6FJBdjt@google.com>
From:   Yu Zhao <yuzhao@google.com>
Date:   Wed, 22 Feb 2023 22:58:56 -0700
Message-ID: <CAOUHufaK-BHdajDZJKjn_LU-gMkUTKa_9foMB8g-u9DyrVhPwg@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v1 2/5] kvm/x86: add kvm_arch_test_clear_young()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Larabel <michael@michaellarabel.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
        linux-mm@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 17, 2023 at 9:27 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Feb 16, 2023, Yu Zhao wrote:
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 6aaae18f1854..d2995c9e8f07 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1367,6 +1367,12 @@ struct kvm_arch {
> >        *      the MMU lock in read mode + the tdp_mmu_pages_lock or
> >        *      the MMU lock in write mode
> >        *
> > +      * kvm_arch_test_clear_young() is a special case. It relies on two
>
> No, it's not.  The TDP MMU already employs on RCU and CMPXCHG.

It is -- you read it out of context :)

         * For reads, this list is protected by:
         *      the MMU lock in read mode + RCU or
         *      the MMU lock in write mode
         *
         * For writes, this list is protected by:
         *      the MMU lock in read mode + the tdp_mmu_pages_lock or
         *      the MMU lock in write mode
         *
         * kvm_arch_test_clear_young() is a special case.
         ...

        struct list_head tdp_mmu_roots;

> Just drop the
> entire comment.

Let me move it into kvm_arch_test_clear_young().

Also I want to be clear:
1. We can't just focus on here and now; we need to consider the distant future.
2. From my POV, "see the comments on ..." is like the index of a book.

> > +      * techniques, RCU and cmpxchg, to safely test and clear the accessed
> > +      * bit without taking the MMU lock. The former protects KVM page tables
> > +      * from being freed while the latter clears the accessed bit atomically
> > +      * against both the hardware and other software page table walkers.
> > +      *
> >        * Roots will remain in the list until their tdp_mmu_root_count
> >        * drops to zero, at which point the thread that decremented the
> >        * count to zero should removed the root from the list and clean
> > @@ -2171,4 +2177,25 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
> >        KVM_X86_QUIRK_FIX_HYPERCALL_INSN |     \
> >        KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS)
> >
> > +extern u64 __read_mostly shadow_accessed_mask;
> > +
> > +/*
> > + * Returns true if A/D bits are supported in hardware and are enabled by KVM.
> > + * When enabled, KVM uses A/D bits for all non-nested MMUs.  Because L1 can
> > + * disable A/D bits in EPTP12, SP and SPTE variants are needed to handle the
> > + * scenario where KVM is using A/D bits for L1, but not L2.
> > + */
> > +static inline bool kvm_ad_enabled(void)
> > +{
> > +     return shadow_accessed_mask;
> > +}
>
> Absolutely not.  This information is not getting directly exposed outside of KVM.

Will do.

> > +
> > +/* see the comments on the generic kvm_arch_has_test_clear_young() */
> > +#define kvm_arch_has_test_clear_young kvm_arch_has_test_clear_young
> > +static inline bool kvm_arch_has_test_clear_young(void)
> > +{
> > +     return IS_ENABLED(CONFIG_KVM) && IS_ENABLED(CONFIG_X86_64) &&
> > +            (!IS_REACHABLE(CONFIG_KVM) || (kvm_ad_enabled() && tdp_enabled));
> > +}
>
> Pending the justification for why this is KVM-only

Nothing else has *_young()... IOW, KVM is the only user of *_young().

> I would strongly prefer we
> find a way to have the mmu_notifier framework track whether or not any listeners
> have a test_clear_young().  E.g. have KVM nullify its hook during module load.

It's already done that way. This function is just for the caller to
avoid unnecessary trips into the MMU notifier on archs that don't
support this capability. (The caller would find it unsupported.)

> > +
> >  #endif /* _ASM_X86_KVM_HOST_H */
> > diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> > index 6f54dc9409c9..0dc7fed1f3fd 100644
> > --- a/arch/x86/kvm/mmu/spte.h
> > +++ b/arch/x86/kvm/mmu/spte.h
> > @@ -153,7 +153,6 @@ extern u64 __read_mostly shadow_mmu_writable_mask;
> >  extern u64 __read_mostly shadow_nx_mask;
> >  extern u64 __read_mostly shadow_x_mask; /* mutual exclusive with nx_mask */
> >  extern u64 __read_mostly shadow_user_mask;
> > -extern u64 __read_mostly shadow_accessed_mask;
> >  extern u64 __read_mostly shadow_dirty_mask;
> >  extern u64 __read_mostly shadow_mmio_value;
> >  extern u64 __read_mostly shadow_mmio_mask;
> > @@ -247,17 +246,6 @@ static inline bool is_shadow_present_pte(u64 pte)
> >       return !!(pte & SPTE_MMU_PRESENT_MASK);
> >  }
> >
> > -/*
> > - * Returns true if A/D bits are supported in hardware and are enabled by KVM.
> > - * When enabled, KVM uses A/D bits for all non-nested MMUs.  Because L1 can
> > - * disable A/D bits in EPTP12, SP and SPTE variants are needed to handle the
> > - * scenario where KVM is using A/D bits for L1, but not L2.
> > - */
> > -static inline bool kvm_ad_enabled(void)
> > -{
> > -     return !!shadow_accessed_mask;
> > -}
>
> As Oliver said in the ARM patch, _if_ this is justified, please do code movement
> in a separate patch.

I'll just drop this.

> >  static inline bool sp_ad_disabled(struct kvm_mmu_page *sp)
> >  {
> >       return sp->role.ad_disabled;
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index d6df38d371a0..9028e09f1aab 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -1309,6 +1309,47 @@ bool kvm_tdp_mmu_age_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
> >       return kvm_tdp_mmu_handle_gfn(kvm, range, age_gfn_range);
> >  }
> >
> > +bool kvm_arch_test_clear_young(struct kvm *kvm, struct kvm_gfn_range *range,
> > +                            gfn_t lsb_gfn, unsigned long *bitmap)
> > +{
> > +     struct kvm_mmu_page *root;
> > +
> > +     if (WARN_ON_ONCE(!kvm_arch_has_test_clear_young()))
> > +             return false;
> > +
> > +     if (kvm_memslots_have_rmaps(kvm))
>
> This completely disables the API on VMs that have _ever_ run a nested VM.

Ok, we definitely don't want this.

> I doubt
> that's the intended behavior.

Good catch, thanks.

> > +             return false;
> > +
> > +     /* see the comments on kvm_arch->tdp_mmu_roots */
> > +     rcu_read_lock();
> > +
> > +     list_for_each_entry_rcu(root, &kvm->arch.tdp_mmu_roots, link) {
> > +             struct tdp_iter iter;
> > +
> > +             if (kvm_mmu_page_as_id(root) != range->slot->as_id)
> > +                     continue;
>
> for_each_tdp_mmu_root() does this for you.
>
> > +
> > +             tdp_root_for_each_leaf_pte(iter, root, range->start, range->end) {
> > +                     u64 *sptep = rcu_dereference(iter.sptep);
>
> kvm_tdp_mmu_read_spte(), thought it's not clear to me why this doesn't test+clear
> the SPTE's accessed bit and then toggle the bitmap.
>
> > +                     u64 new_spte = iter.old_spte & ~shadow_accessed_mask;
> > +
> > +                     VM_WARN_ON_ONCE(!page_count(virt_to_page(sptep)));
>
> This doesn't do what I assume it's intended to do.

This asserts the page table page is not freed, i.e., the memory we are
modifying still belongs to someone.

 If we forget to do RCU free, i.e., we free immediately, this can
catch it, assuming no reuse.

> The sptep points at a KVM,
> a.k.a. kernel, allocated page, not at guest memory.  Assuming the intent is to
> assert that the memory being aged has an elevated refcount, this would need to
> extract the pfn out of the SPTE and get the struct page for that.  But that's
> completely unsafe because KVM supports mapping VM_PFNMAP and VM_IO memory into
> the guest.  Maybe the proposed caller only operates on struct page memory, but
> I am not willing to make that assumption in KVM.
>
> TL;DR: drop this.
>
> > +                     VM_WARN_ON_ONCE(iter.gfn < range->start || iter.gfn >= range->end);
>
> This adds no value KVM is completely hosed if tdp_root_for_each_leaf_pte() botches
> the ranges.

Ok.

> > +
> > +                     if (new_spte == iter.old_spte)
> > +                             continue;
> > +
> > +                     /* see the comments on the generic kvm_arch_has_test_clear_young() */
>
> No, "see xyz" for unintuitive logic is not acceptable.  Add a helper and document
> the logic there, don't splatter "see XYZ" comments everywhere.
>
> > +                     if (__test_and_change_bit(lsb_gfn - iter.gfn, bitmap))
> > +                             cmpxchg64(sptep, iter.old_spte, new_spte);
>
> Clearing a single bit doesn't need a CMPXCHG.  Please weigh in on a relevant series
> that is modifying the aging flows[*], I want to have exactly one helper for aging
> TDP MMU SPTEs.
>
> [*] https://lore.kernel.org/all/20230211014626.3659152-5-vipinsh@google.com

I'll take a look at that series. clear_bit() probably won't cause any
practical damage but is technically wrong because, for example, it can
end up clearing the A-bit in a non-leaf PMD. (cmpxchg will just fail
in this case, obviously.)
