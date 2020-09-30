Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5D927F5C9
	for <lists+kvm@lfdr.de>; Thu,  1 Oct 2020 01:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732145AbgI3XPh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Sep 2020 19:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730528AbgI3XP3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Sep 2020 19:15:29 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845D5C0613D0
        for <kvm@vger.kernel.org>; Wed, 30 Sep 2020 16:15:29 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id f15so4165560ilj.2
        for <kvm@vger.kernel.org>; Wed, 30 Sep 2020 16:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ziKIfU8vAVPMot5eNP2rJCYqSKd8W1jYnncCawSVC4k=;
        b=sNIUgBiX8VjUnFjvQu6mWmODrgvc3PS6B3WbHDRu/bvwK6yZkGJB/JE6tTBwBbDdp+
         7PiR/NVNqXNOIy2exNIBm4w0b+jK1AUYkILUiYH7EhuFCbZdAarKCz9Il4cF5pDffG+J
         iTbd+JhF/vdPZ6JIV9RRcKssPQ+tVYS2Nz0n+ePWkJ1A5z4qr5FSd5RdwPogbJfbhFHa
         Xqc7G/25yo4GvDiif0dlJtBBPbYPAgpVH5pUh1MIQ3FhvQI4I89Ij2x0W5vKELB6KdOt
         qdsyxt9d3I525xkjH3r0Vdm9aFjLQf9DkpreLVcaPfHcdpZNYWC45caUCLRPib9fLNbb
         l0Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ziKIfU8vAVPMot5eNP2rJCYqSKd8W1jYnncCawSVC4k=;
        b=Z/FZOv1vdtFcDAgIsO/g0n68LQKaScr4ygblt+xw0Wva2azBhNMDdR0VPFNfLUHKp1
         TSvyYVZBnn766dfupwGv/lGfd+NdFxeTkyFGzEYy2yQJEv0JDKEP+JG2YBQtdysYEpBi
         I+xpHGkw2G9e0AKhd+p6Nie5zk2GcCGreAPipyqnVti2brB9uo5CHtj7Y8Rya1wjb5CU
         cghDItUFMG/UFOPoHcRoup+Ev1BIFgt9aTPgrsIMv/Gn06jMWZhyZfq7D87f3RRWK/be
         UO9YrZKc3Mdif1g5BIZsFY1fNZP7+wyTxoXqeypXL+n3y3U9feh6b6yY6xFz9Yf6qhCc
         Sd/w==
X-Gm-Message-State: AOAM532iLBCzrP2qHIJAWscLMO17oTPGr7uycKm6qxVLfow9NDlb0iAJ
        //mMzts5H2vuUj5b0+6bjWnFff1eWpbdsx4Nj2Ankw==
X-Google-Smtp-Source: ABdhPJwRmseqt72krYvVnpFdh2oLD6cRu0btU4XTLtqHd04bjRbM2vZgcV+RxuwraUqav9cqZtSYiOOPfRelA1kqXA0=
X-Received: by 2002:a92:1e07:: with SMTP id e7mr194208ile.154.1601507728477;
 Wed, 30 Sep 2020 16:15:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200925212302.3979661-1-bgardon@google.com> <20200925212302.3979661-14-bgardon@google.com>
 <20200930170354.GF32672@linux.intel.com>
In-Reply-To: <20200930170354.GF32672@linux.intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 30 Sep 2020 16:15:17 -0700
Message-ID: <CANgfPd8mH7XpNzCbObD-XO_Pzc0TK6oNQpTw9rgSdqBV-4trFw@mail.gmail.com>
Subject: Re: [PATCH 13/22] kvm: mmu: Support invalidate range MMU notifier for
 TDP MMU
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

On Wed, Sep 30, 2020 at 10:04 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Fri, Sep 25, 2020 at 02:22:53PM -0700, Ben Gardon wrote:
> > In order to interoperate correctly with the rest of KVM and other Linux
> > subsystems, the TDP MMU must correctly handle various MMU notifiers. Add
> > hooks to handle the invalidate range family of MMU notifiers.
> >
> > Tested by running kvm-unit-tests and KVM selftests on an Intel Haswell
> > machine. This series introduced no new failures.
> >
> > This series can be viewed in Gerrit at:
> >       https://linux-review.googlesource.com/c/virt/kvm/kvm/+/2538
> >
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c     |  9 ++++-
> >  arch/x86/kvm/mmu/tdp_mmu.c | 80 +++++++++++++++++++++++++++++++++++---
> >  arch/x86/kvm/mmu/tdp_mmu.h |  3 ++
> >  3 files changed, 86 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 52d661a758585..0ddfdab942554 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -1884,7 +1884,14 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
> >  int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
> >                       unsigned flags)
> >  {
> > -     return kvm_handle_hva_range(kvm, start, end, 0, kvm_unmap_rmapp);
> > +     int r;
> > +
> > +     r = kvm_handle_hva_range(kvm, start, end, 0, kvm_unmap_rmapp);
> > +
> > +     if (kvm->arch.tdp_mmu_enabled)
> > +             r |= kvm_tdp_mmu_zap_hva_range(kvm, start, end);
>
> Similar to an earlier question, is this intentionally additive, or can this
> instead by:
>
>         if (kvm->arch.tdp_mmu_enabled)
>                 r = kvm_tdp_mmu_zap_hva_range(kvm, start, end);
>         else
>                 r = kvm_handle_hva_range(kvm, start, end, 0, kvm_unmap_rmapp);
>

It is intentionally additive so the legacy/shadow MMU can handle nested.

> > +
> > +     return r;
> >  }
> >
> >  int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 557e780bdf9f9..1cea58db78a13 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -60,7 +60,7 @@ bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
> >  }
> >
> >  static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> > -                       gfn_t start, gfn_t end);
> > +                       gfn_t start, gfn_t end, bool can_yield);
> >
> >  static void free_tdp_mmu_root(struct kvm *kvm, struct kvm_mmu_page *root)
> >  {
> > @@ -73,7 +73,7 @@ static void free_tdp_mmu_root(struct kvm *kvm, struct kvm_mmu_page *root)
> >
> >       list_del(&root->link);
> >
> > -     zap_gfn_range(kvm, root, 0, max_gfn);
> > +     zap_gfn_range(kvm, root, 0, max_gfn, false);
> >
> >       free_page((unsigned long)root->spt);
> >       kmem_cache_free(mmu_page_header_cache, root);
> > @@ -361,9 +361,14 @@ static bool tdp_mmu_iter_cond_resched(struct kvm *kvm, struct tdp_iter *iter)
> >   * non-root pages mapping GFNs strictly within that range. Returns true if
> >   * SPTEs have been cleared and a TLB flush is needed before releasing the
> >   * MMU lock.
> > + * If can_yield is true, will release the MMU lock and reschedule if the
> > + * scheduler needs the CPU or there is contention on the MMU lock. If this
> > + * function cannot yield, it will not release the MMU lock or reschedule and
> > + * the caller must ensure it does not supply too large a GFN range, or the
> > + * operation can cause a soft lockup.
> >   */
> >  static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> > -                       gfn_t start, gfn_t end)
> > +                       gfn_t start, gfn_t end, bool can_yield)
> >  {
> >       struct tdp_iter iter;
> >       bool flush_needed = false;
> > @@ -387,7 +392,10 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
> >               handle_changed_spte(kvm, as_id, iter.gfn, iter.old_spte, 0,
> >                                   iter.level);
> >
> > -             flush_needed = !tdp_mmu_iter_cond_resched(kvm, &iter);
> > +             if (can_yield)
> > +                     flush_needed = !tdp_mmu_iter_cond_resched(kvm, &iter);
>
>                 flush_needed = !can_yield || !tdp_mmu_iter_cond_resched(kvm, &iter);
>
> > +             else
> > +                     flush_needed = true;
> >       }
> >       return flush_needed;
> >  }
> > @@ -410,7 +418,7 @@ bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end)
> >                */
> >               get_tdp_mmu_root(kvm, root);
> >
> > -             flush = zap_gfn_range(kvm, root, start, end) || flush;
> > +             flush = zap_gfn_range(kvm, root, start, end, true) || flush;
> >
> >               put_tdp_mmu_root(kvm, root);
> >       }
> > @@ -551,3 +559,65 @@ int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu, int write, int map_writable,
> >
> >       return ret;
> >  }
> > +
> > +static int kvm_tdp_mmu_handle_hva_range(struct kvm *kvm, unsigned long start,
> > +             unsigned long end, unsigned long data,
> > +             int (*handler)(struct kvm *kvm, struct kvm_memory_slot *slot,
> > +                            struct kvm_mmu_page *root, gfn_t start,
> > +                            gfn_t end, unsigned long data))
> > +{
> > +     struct kvm_memslots *slots;
> > +     struct kvm_memory_slot *memslot;
> > +     struct kvm_mmu_page *root;
> > +     int ret = 0;
> > +     int as_id;
> > +
> > +     for_each_tdp_mmu_root(kvm, root) {
> > +             /*
> > +              * Take a reference on the root so that it cannot be freed if
> > +              * this thread releases the MMU lock and yields in this loop.
> > +              */
> > +             get_tdp_mmu_root(kvm, root);
> > +
> > +             as_id = kvm_mmu_page_as_id(root);
> > +             slots = __kvm_memslots(kvm, as_id);
> > +             kvm_for_each_memslot(memslot, slots) {
> > +                     unsigned long hva_start, hva_end;
> > +                     gfn_t gfn_start, gfn_end;
> > +
> > +                     hva_start = max(start, memslot->userspace_addr);
> > +                     hva_end = min(end, memslot->userspace_addr +
> > +                                   (memslot->npages << PAGE_SHIFT));
> > +                     if (hva_start >= hva_end)
> > +                             continue;
> > +                     /*
> > +                      * {gfn(page) | page intersects with [hva_start, hva_end)} =
> > +                      * {gfn_start, gfn_start+1, ..., gfn_end-1}.
> > +                      */
> > +                     gfn_start = hva_to_gfn_memslot(hva_start, memslot);
> > +                     gfn_end = hva_to_gfn_memslot(hva_end + PAGE_SIZE - 1, memslot);
> > +
> > +                     ret |= handler(kvm, memslot, root, gfn_start,
> > +                                    gfn_end, data);
>
> Eh, I'd say let this one poke out, the above hva_to_gfn_memslot() already
> overruns 80 chars.  IMO it's more readable without the wraps.

Will do.

>
> > +             }
> > +
> > +             put_tdp_mmu_root(kvm, root);
> > +     }
> > +
> > +     return ret;
> > +}
> > +
> > +static int zap_gfn_range_hva_wrapper(struct kvm *kvm,
> > +                                  struct kvm_memory_slot *slot,
> > +                                  struct kvm_mmu_page *root, gfn_t start,
> > +                                  gfn_t end, unsigned long unused)
> > +{
> > +     return zap_gfn_range(kvm, root, start, end, false);
> > +}
> > +
> > +int kvm_tdp_mmu_zap_hva_range(struct kvm *kvm, unsigned long start,
> > +                           unsigned long end)
> > +{
> > +     return kvm_tdp_mmu_handle_hva_range(kvm, start, end, 0,
> > +                                         zap_gfn_range_hva_wrapper);
> > +}
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> > index abf23dc0ab7ad..ce804a97bfa1d 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.h
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> > @@ -18,4 +18,7 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm);
> >  int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu, int write, int map_writable,
> >                          int level, gpa_t gpa, kvm_pfn_t pfn, bool prefault,
> >                          bool lpage_disallowed);
> > +
> > +int kvm_tdp_mmu_zap_hva_range(struct kvm *kvm, unsigned long start,
> > +                           unsigned long end);
> >  #endif /* __KVM_X86_MMU_TDP_MMU_H */
> > --
> > 2.28.0.709.gb0816b6eb0-goog
> >
