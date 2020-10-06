Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5781A2854F9
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 01:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgJFXie (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 19:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbgJFXid (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Oct 2020 19:38:33 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87BE0C0613D2
        for <kvm@vger.kernel.org>; Tue,  6 Oct 2020 16:38:33 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id m17so454836ioo.1
        for <kvm@vger.kernel.org>; Tue, 06 Oct 2020 16:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=13791vUhHhb6VTolXcEhezbjPTrOyYuZlnDL2mT/uMQ=;
        b=Z0TILlPqZ0FQ24zoUNu4A+p97EWXxA2vk2dTtYWnOMYhkBG5pdkN56YHET07EOhw01
         zefeHFOxY+Fvf3KUt68ekYAlCZWMD6CMAI/waYWKUcVrKnajcLPaKZxYWivbsU/lXx31
         vKrKnXZDgaKbMBBeoKvbvov7VovPq8wc+bBgYn6Y1hJwruFdw0IoeGYwy1KB5OaDEMox
         FlX/NOau1H6NRbyLoKBAhOYoyzypPoQ0n4tvPBAlrSZRb/sh1h03YbaJCIzZsE/8q3RF
         5RahIry08OKCrrA0FExUDF4YiYAlPriEnWyWZC/SmW76TUEnCxxCHX8jrcK62m5sZbx7
         f9Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=13791vUhHhb6VTolXcEhezbjPTrOyYuZlnDL2mT/uMQ=;
        b=PMfmZhKzXwgQ117N7pdO6OoAARGaORGl9TevT01ZV7pFLVUAXSh9+dk747XScfQq22
         cBpuaLUypXLDjUU1BFpB8qc7HLGLiou8TbEpnT5ZpoQIpy/Rm/J3PwYxVU8RlsV3Sxk5
         L/7YPVKJrBfNCrBWJjosTB+N09TgyU3ys8aejFpe0XIjLCDfeh1Cm6oJEvUlBTgfPtmK
         HgsfRitqkAHU6jwGfcqVOioRvfiPk2AJdRx7iVGC9ucfIhdeSH0YkbAaR5Sy7ZwQhdV7
         MgUsFqFbP/RRSmxbwtg3VNQSeNNKZKSrgtTUAkGZ/WRN3+1wehGUlY0RTcMRfrjqJi89
         xgdA==
X-Gm-Message-State: AOAM5302rD0ZPCFKLtntq19gc8VVJa2kx0U1K9rVidNed/YyFBOu1p0x
        kJNfLb7nlLvdcnfD6+kkcHLaUJWyK0tlSUAk6qOz+Ho6G6n7Ec4P
X-Google-Smtp-Source: ABdhPJy0QFpgEbn5qaxrXcNidTKYH6eoTq2t3Gq67KtBcx1bfyw4/0qrqfnqrvxWwxEP7NECeLhP/F2XG6gveqqzo0Y=
X-Received: by 2002:a05:6602:2d55:: with SMTP id d21mr209338iow.134.1602027512355;
 Tue, 06 Oct 2020 16:38:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com> <20200925212302.3979661-15-bgardon@google.com>
 <20200930174858.GG32672@linux.intel.com>
In-Reply-To: <20200930174858.GG32672@linux.intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 6 Oct 2020 16:38:21 -0700
Message-ID: <CANgfPd8u5-Lzj0Mb58cU8so4ZeHCmTG8DCAvkL2uPWeK6rDBfA@mail.gmail.com>
Subject: Re: [PATCH 14/22] kvm: mmu: Add access tracking for tdp_mmu
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Cannon Matthews <cannonmatthews@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
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

On Wed, Sep 30, 2020 at 10:49 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, Sep 25, 2020 at 02:22:54PM -0700, Ben Gardon wrote:
> > @@ -1945,12 +1944,24 @@ static void rmap_recycle(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
> >
> >  int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
> >  {
> > -     return kvm_handle_hva_range(kvm, start, end, 0, kvm_age_rmapp);
> > +     int young = false;
> > +
> > +     young = kvm_handle_hva_range(kvm, start, end, 0, kvm_age_rmapp);
> > +     if (kvm->arch.tdp_mmu_enabled)
>
> If we end up with a per-VM flag, would it make sense to add a static key
> wrapper similar to the in-kernel lapic?  I assume once this lands the vast
> majority of VMs will use the TDP MMU.
>
> > +             young |= kvm_tdp_mmu_age_hva_range(kvm, start, end);
> > +
> > +     return young;
> >  }
>
> ...
>
> > +
> > +/*
> > + * Mark the SPTEs range of GFNs [start, end) unaccessed and return non-zero
> > + * if any of the GFNs in the range have been accessed.
> > + */
> > +static int age_gfn_range(struct kvm *kvm, struct kvm_memory_slot *slot,
> > +                      struct kvm_mmu_page *root, gfn_t start, gfn_t end,
> > +                      unsigned long unused)
> > +{
> > +     struct tdp_iter iter;
> > +     int young = 0;
> > +     u64 new_spte = 0;
> > +     int as_id = kvm_mmu_page_as_id(root);
> > +
> > +     for_each_tdp_pte_root(iter, root, start, end) {
>
> Ah, I think we should follow the existing shadow iterates by naming this
>
>         for_each_tdp_pte_using_root()
>
> My first reaction was that this was iterating over TDP roots, which was a bit
> confusing.  I suspect others will make the same mistake unless they look at the
> implementation of for_each_tdp_pte_root().
>
> Similar comments on the _vcpu() variant.  For that one I think it'd be
> preferable to take the struct kvm_mmu, i.e. have for_each_tdp_pte_using_mmu(),
> as both kvm_tdp_mmu_page_fault() and kvm_tdp_mmu_get_walk() explicitly
> reference vcpu->arch.mmu in the surrounding code.
>
> E.g. I find this more intuitive
>
>         struct kvm_mmu *mmu = vcpu->arch.mmu;
>         int leaf = mmu->shadow_root_level;
>
>         for_each_tdp_pte_using_mmu(iter, mmu, gfn, gfn + 1) {
>                 leaf = iter.level;
>                 sptes[leaf - 1] = iter.old_spte;
>         }
>
>         return leaf
>
> versus this, which makes me want to look at the implementation of for_each().
>
>
>         int leaf = vcpu->arch.mmu->shadow_root_level;
>
>         for_each_tdp_pte_vcpu(iter, vcpu, gfn, gfn + 1) {
>                 ...
>         }

I will change these macros as you suggested. I agree adding _using_
makes them clearer.

>
> > +             if (!is_shadow_present_pte(iter.old_spte) ||
> > +                 !is_last_spte(iter.old_spte, iter.level))
> > +                     continue;
> > +
> > +             /*
> > +              * If we have a non-accessed entry we don't need to change the
> > +              * pte.
> > +              */
> > +             if (!is_accessed_spte(iter.old_spte))
> > +                     continue;
> > +
> > +             new_spte = iter.old_spte;
> > +
> > +             if (spte_ad_enabled(new_spte)) {
> > +                     clear_bit((ffs(shadow_accessed_mask) - 1),
> > +                               (unsigned long *)&new_spte);
> > +             } else {
> > +                     /*
> > +                      * Capture the dirty status of the page, so that it doesn't get
> > +                      * lost when the SPTE is marked for access tracking.
> > +                      */
> > +                     if (is_writable_pte(new_spte))
> > +                             kvm_set_pfn_dirty(spte_to_pfn(new_spte));
> > +
> > +                     new_spte = mark_spte_for_access_track(new_spte);
> > +             }
> > +
> > +             *iter.sptep = new_spte;
> > +             __handle_changed_spte(kvm, as_id, iter.gfn, iter.old_spte,
> > +                                   new_spte, iter.level);
> > +             young = true;
>
> young is an int, not a bool.  Not really your fault as KVM has a really bad
> habit of using ints instead of bools.

Yeah, I saw that too. In mmu.c young ends up being set to true as
well, just though a function return so it's less obvious. Do you think
it would be preferable to set young to 1 or convert it to a bool?

>
> > +     }
> > +
> > +     return young;
> > +}
> > +
> > +int kvm_tdp_mmu_age_hva_range(struct kvm *kvm, unsigned long start,
> > +                           unsigned long end)
> > +{
> > +     return kvm_tdp_mmu_handle_hva_range(kvm, start, end, 0,
> > +                                         age_gfn_range);
> > +}
> > +
> > +static int test_age_gfn(struct kvm *kvm, struct kvm_memory_slot *slot,
> > +                     struct kvm_mmu_page *root, gfn_t gfn, gfn_t unused,
> > +                     unsigned long unused2)
> > +{
> > +     struct tdp_iter iter;
> > +     int young = 0;
> > +
> > +     for_each_tdp_pte_root(iter, root, gfn, gfn + 1) {
> > +             if (!is_shadow_present_pte(iter.old_spte) ||
> > +                 !is_last_spte(iter.old_spte, iter.level))
> > +                     continue;
> > +
> > +             if (is_accessed_spte(iter.old_spte))
> > +                     young = true;
>
> Same bool vs. int weirdness here.  Also, |= doesn't short circuit for ints
> or bools, so this can be
>
>                 young |= is_accessed_spte(...)
>
> Actually, can't we just return true immediately?

Great point, I'll do that.

>
> > +     }
> > +
> > +     return young;
> > +}
> > +
> > +int kvm_tdp_mmu_test_age_hva(struct kvm *kvm, unsigned long hva)
> > +{
> > +     return kvm_tdp_mmu_handle_hva_range(kvm, hva, hva + 1, 0,
> > +                                         test_age_gfn);
> > +}
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> > index ce804a97bfa1d..f316773b7b5a8 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.h
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> > @@ -21,4 +21,8 @@ int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu, int write, int map_writable,
> >
> >  int kvm_tdp_mmu_zap_hva_range(struct kvm *kvm, unsigned long start,
> >                             unsigned long end);
> > +
> > +int kvm_tdp_mmu_age_hva_range(struct kvm *kvm, unsigned long start,
> > +                           unsigned long end);
> > +int kvm_tdp_mmu_test_age_hva(struct kvm *kvm, unsigned long hva);
> >  #endif /* __KVM_X86_MMU_TDP_MMU_H */
> > --
> > 2.28.0.709.gb0816b6eb0-goog
> >
