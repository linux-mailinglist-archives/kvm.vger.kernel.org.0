Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 263F84E9DC0
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 19:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244644AbiC1RnS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 13:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244335AbiC1RnR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 13:43:17 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF795DA04
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 10:41:35 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id j21so13063004qta.0
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 10:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OE+8cdgGfoCGXGwp8r/5HOUNTsvZQT1x4g0OFfZy04I=;
        b=VpuXPRNVm7f1LqJrjVj7chLW0tPoQ3BE1b1rqOCodPiOJkbCRaxy3RaqkZ3zgcws1Z
         BmY7ItjiL2MzN3PNeAVPB1vGcUUdvw4SSDVbsHNp2sWBUJ3YOArvlSgd5sFosUnNhRDp
         9S0fobS/YsOxR55WP+tFLPD7FLla6aVPjYa+cBXmoJ4Pc1N9D9BWP0mQDiKICcx2FWp4
         HgEz9JMtHIXUPFvUrKeDItYmkoOuG0dwZoIyGT/GR5JQGYeEuebbO0GYSlcS6zHv69x2
         vqR/jEWpLjrjNl8YCBT64S+sk3pyg6/YfqZwYnm57mtx8p5kSu4BNADmKoOKfVcg6W6R
         SBJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OE+8cdgGfoCGXGwp8r/5HOUNTsvZQT1x4g0OFfZy04I=;
        b=VQLuicJ/SL91PNtmLN/Y6nsYsjslkRUCJXk3Dmm6TZcWBmYFsTLJHzBQr2ngSIzyVD
         kVEOq7ORggU4TxxGOA0qaQtpv3Kf8IPg3QrT4rxVMRGNWG0XXrsAJh7qOlfl3/K09cI4
         5O21NS32BRpErXxkJvSJCVlspRO4iKXiIcuP4Fokiw8Kv4V7vFpXTPhqvFG0pPL9bsDx
         DPLcDcwBo5Ni40JBvbbxVNGSPkk9OH52sfcnjyp3gN5t/m4mhuAcB0HMkc+ENC/RH/qJ
         BPnFWGlOB6PS8m+ZrJ2ja/8mZtNjogKBppGYcKmvjcxVlYBWE8sQUa/BfeI0CpHzukGO
         Yrog==
X-Gm-Message-State: AOAM530/9AUgxkhRNt5uh02bBDLmYTGqy98KGVsfNjN8avVpR4eWH2dP
        4mGW4XvdSEQRmIFdoPr4HJ6voRxJirqh5JCjTnf5dw==
X-Google-Smtp-Source: ABdhPJzG6IU5B+2M3qXnnxgjxuQwtFazpbuUwBiH9W1XKT5vWh+FJkrC4Mnus1LpesRkUaMWoMwBYnzujoxfG1MZOn4=
X-Received: by 2002:ac8:7d0e:0:b0:2e0:6675:adf6 with SMTP id
 g14-20020ac87d0e000000b002e06675adf6mr23080372qtb.227.1648489294729; Mon, 28
 Mar 2022 10:41:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220327205803.739336-1-mizhang@google.com> <YkHRYY6x1Ewez/g4@google.com>
In-Reply-To: <YkHRYY6x1Ewez/g4@google.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Mon, 28 Mar 2022 10:41:23 -0700
Message-ID: <CAL715WL7ejOBjzXy9vbS_M2LmvXcC-CxmNr+oQtCZW0kciozHA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: add lockdep check before lookup_address_in_mm()
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>
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

Hi Sean,


On Mon, Mar 28, 2022 at 8:16 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Sun, Mar 27, 2022, Mingwei Zhang wrote:
> > Add a lockdep check before invoking lookup_address_in_mm().
> > lookup_address_in_mm() walks all levels of host page table without
> > accquiring any lock. This is usually unsafe unless we are walking the
> > kernel addresses (check other usage cases of lookup_address_in_mm and
> > lookup_address_in_pgd).
> >
> > Walking host page table (especially guest addresses) usually requires
> > holding two types of locks: 1) mmu_lock in mm or the lock that protects
> > the reverse maps of host memory in range; 2) lock for the leaf paging
> > structures.
> >
> > One exception case is when we take the mmu_lock of the secondary mmu.
> > Holding mmu_lock of KVM MMU in either read mode or write mode prevents host
> > level entities from modifying the host page table concurrently. This is
> > because all of them will have to invoke KVM mmu_notifier first before doing
> > the actual work. Since KVM mmu_notifier invalidation operations always take
> > the mmu write lock, we are safe if we hold the mmu lock here.
> >
> > Note: this means that KVM cannot allow concurrent multiple mmu_notifier
> > invalidation callbacks by using KVM mmu read lock. Since, otherwise, any
> > host level entity can cause race conditions with this one. Walking host
> > page table here may get us stale information or may trigger NULL ptr
> > dereference that is hard to reproduce.
> >
> > Having a lockdep check here will prevent or at least warn future
> > development that directly walks host page table simply in a KVM ioctl
> > function. In addition, it provides a record for any future development on
> > KVM mmu_notifier.
> >
> > Cc: Sean Christopherson <seanjc@google.com>
> > Cc: Ben Gardon <bgardon@google.com>
> > Cc: David Matlack <dmatlack@google.com>
> >
> > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 18 ++++++++++++++++++
> >  1 file changed, 18 insertions(+)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 1361eb4599b4..066bb5435156 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -2820,6 +2820,24 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
> >        */
> >       hva = __gfn_to_hva_memslot(slot, gfn);
> >
> > +     /*
> > +      * lookup_address_in_mm() walks all levels of host page table without
> > +      * accquiring any lock. This is not safe when KVM does not take the
> > +      * mmu_lock. Holding mmu_lock in either read mode or write mode prevents
> > +      * host level entities from modifying the host page table. This is
> > +      * because all of them will have to invoke KVM mmu_notifier first before
> > +      * doing the actual work. Since KVM mmu_notifier invalidation operations
> > +      * always take the mmu write lock, we are safe if we hold the mmu lock
> > +      * here.
> > +      *
> > +      * Note: this means that KVM cannot allow concurrent multiple
> > +      * mmu_notifier invalidation callbacks by using KVM mmu read lock.
> > +      * Otherwise, any host level entity can cause race conditions with this
> > +      * one. Walking host page table here may get us stale information or may
> > +      * trigger NULL ptr dereference that is hard to reproduce.
> > +      */
> > +     lockdep_assert_held(&kvm->mmu_lock);
>
> Holding mmu_lock isn't strictly required.  It would also be safe to use this helper
> if mmu_notifier_retry_hva() were checked after grabbing the mapping level, before
> consuming it.  E.g. we could theoretically move this to kvm_faultin_pfn().
>
> And simply holding the lock isn't sufficient, i.e. the lockdep gives a false sense
> of security.  E.g. calling this while holding mmu_lock but without first checking
> mmu_notifier_count would let it run concurrently with host PTE modifications.

Right, even holding the kvm->mmu_lock is not safe, since we may have
several concurrent invalidations ongoing and they are done zapping
entries in EPT (so that they could just release the kvm->mmu_lock) and
start working on the host page table. If we want to make it safe, we
also have to check mmu_notifier_count (and potentially mmu_seq as
well).

With that, I start to feel this is a bug. The issue is just so rare
that it has never triggered a problem.

lookup_address_in_mm() walks the host page table as if it is a
sequence of _static_ memory chunks. This is clearly dangerous. If we
look at hva_to_pfn(), which is the right way to walk host page table:

hva_to_pfn() =>
  hva_to_pfn_fast() =>
    get_user_page_fast_only() =>
      internal_get_user_pages_fast() =>
        lockless_pages_from_mm() =>
          local_irq_save(flags); /* Disable interrupts here. */
          gup_pgd_range(start, end, gup_flags, pages, &nr_pinned);
  ... ...
  hva_to_pfn_slow() =>
    get_user_pages_unlocked() =>
      mmap_read_lock(mm); /* taking the mm lock here. */

The above code has two branches to walk the host page table: 1) the
fast one and 2) slow one; The slower one takes the mm lock, while the
faster one simply disables the interrupts.

I think we might have to mimic the same thing in
lockless_pages_from_mm(), i.e. wrapping
local_irq_{save,restore}(flags) around the lookup_address_in_mm().

Alternatively, we have to specify that the function
lookup_address_in_mm() as well as its callers:
host_pfn_mapping_level() and kvm_mmu_max_mapping_level() CANNOT be
called in generic places in KVM, but only in the fault path and AFTER
the check of "is_page_fault_stale()".

But right now,  kvm_mmu_max_mapping_level() are used in other places
as well: kvm_mmu_zap_collapsible_spte(), which does not satisfy the
strict requirement of walking the host page table.

>
> I'm definitely in favor of adding a comment to document the mmu_notifier
> interactions, but I don't like adding a lockdep.
