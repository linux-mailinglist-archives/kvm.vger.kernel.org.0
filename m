Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 700AF484E9C
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 08:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237968AbiAEHOv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 02:14:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237957AbiAEHOv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 02:14:51 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E57C061784
        for <kvm@vger.kernel.org>; Tue,  4 Jan 2022 23:14:50 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id k69so99535782ybf.1
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 23:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ar70wR0uLqi2vs94HMsJBd4iJvsCR4GfURTETOA2peg=;
        b=SD0W30ayy7Ht5hRyPFvOr5WbZyHVyQN18ZhFUk+IIBAnlLcM1tBlRnBEzDcFl6OSJL
         uI7M6gwsXpNSFE3e04UHM/uN3Sp6TUP45ODbxnjduSZfhXWqiG6B5VZe4Bf5mg2/Lc+1
         u7+6ipOmw9UMoFdyTVfAAZwN2luyZVwUzc9NQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ar70wR0uLqi2vs94HMsJBd4iJvsCR4GfURTETOA2peg=;
        b=w0I5/fkFL2YepM08kzmglQSYs9LzHEI7QZFza8e1IEeuAgcbnnJkw3nibIpIP7wTtx
         giBZaMXG9iYXHY3t2N9F3QQUw2emvOdJyOW4UviY4yPaI95jPl/c2T0x0cx9IU+NZE+t
         hdvmmZNl7KNuc37lsqiTn4T2TYn+iO3dAodQ5wywuKCzbCk3JNCygsOAvPiOgBYeIJ6w
         mhvbW3SbRvVkGUcp6bjiy59iH1SgwnYwQYcUhM9OE4xxvefew5iTrYcnZoJqSlP/2eBK
         pmaTh2uBPoPYUI8u5GwnoeoGaT5rsU31fGxTWPm3q743fJVx2ERDtusQWSipxloTH5Cq
         sfiQ==
X-Gm-Message-State: AOAM53211hktUsv7Vgj87Fav9BJt9aao/DAj6txHPHzVLdwn1nheAd7B
        0iwwTKIcqiykL8W9dRkw7+gzWtGh2jJQdP6AH4J3pQ==
X-Google-Smtp-Source: ABdhPJzMM9JD+YzU8GTpgvjQLU5j4pITzxMThzVJzImk/yziKs0vvTKMKEFlvsFvSU4M8Z5KLi8KkuIpUIk9t+9Hk2k=
X-Received: by 2002:a5b:350:: with SMTP id q16mr545180ybp.639.1641366890092;
 Tue, 04 Jan 2022 23:14:50 -0800 (PST)
MIME-Version: 1.0
References: <20211129034317.2964790-1-stevensd@google.com> <20211129034317.2964790-5-stevensd@google.com>
 <Yc4G23rrSxS59br5@google.com>
In-Reply-To: <Yc4G23rrSxS59br5@google.com>
From:   David Stevens <stevensd@chromium.org>
Date:   Wed, 5 Jan 2022 16:14:39 +0900
Message-ID: <CAD=HUj5Q6rW8UyxAXUa3o93T0LBqGQb7ScPj07kvuM3txHMMrQ@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] KVM: mmu: remove over-aggressive warnings
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 31, 2021 at 4:22 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Nov 29, 2021, David Stevens wrote:
> > From: David Stevens <stevensd@chromium.org>
> >
> > Remove two warnings that require ref counts for pages to be non-zero, as
> > mapped pfns from follow_pfn may not have an initialized ref count.
> >
> > Signed-off-by: David Stevens <stevensd@chromium.org>
> > ---
> >  arch/x86/kvm/mmu/mmu.c | 7 -------
> >  virt/kvm/kvm_main.c    | 2 +-
> >  2 files changed, 1 insertion(+), 8 deletions(-)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index 0626395ff1d9..7c4c7fededf0 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -621,13 +621,6 @@ static int mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
> >
> >       pfn = spte_to_pfn(old_spte);
> >
> > -     /*
> > -      * KVM does not hold the refcount of the page used by
> > -      * kvm mmu, before reclaiming the page, we should
> > -      * unmap it from mmu first.
> > -      */
> > -     WARN_ON(!kvm_is_reserved_pfn(pfn) && !page_count(pfn_to_page(pfn)));
> > -
> >       if (is_accessed_spte(old_spte))
> >               kvm_set_pfn_accessed(pfn);
> >
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 16a8a71f20bf..d81edcb3e107 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -170,7 +170,7 @@ bool kvm_is_zone_device_pfn(kvm_pfn_t pfn)
> >        * the device has been pinned, e.g. by get_user_pages().  WARN if the
> >        * page_count() is zero to help detect bad usage of this helper.
>
> Stale comment.
>
> >        */
> > -     if (!pfn_valid(pfn) || WARN_ON_ONCE(!page_count(pfn_to_page(pfn))))
> > +     if (!pfn_valid(pfn) || !page_count(pfn_to_page(pfn)))
>
> Hrm, I know the whole point of this series is to support pages without an elevated
> refcount, but this WARN was extremely helpful in catching several use-after-free
> bugs in the TDP MMU.  We talked about burying a slow check behind MMU_WARN_ON, but
> that isn't very helpful because no one runs with MMU_WARN_ON, and this is also a
> type of check that's most useful if it runs in production.
>
> IIUC, this series explicitly disallows using pfns that have a struct page without
> refcounting, and the issue with the WARN here is that kvm_is_zone_device_pfn() is
> called by kvm_is_reserved_pfn() before ensure_pfn_ref() rejects problematic pages,
> i.e. triggers false positive.
>
> So, can't we preserve the use-after-free benefits of the check by moving it to
> where KVM releases the PFN?  I.e.
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index fbca2e232e94..675b835525fa 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2904,15 +2904,19 @@ EXPORT_SYMBOL_GPL(kvm_release_pfn_dirty);
>
>  void kvm_set_pfn_dirty(kvm_pfn_t pfn)
>  {
> -       if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn))
> +       if (!kvm_is_reserved_pfn(pfn) && !kvm_is_zone_device_pfn(pfn)) {
> +               WARN_ON_ONCE(!page_count(pfn_to_page(pfn)));
>                 SetPageDirty(pfn_to_page(pfn));
> +       }
>  }
>  EXPORT_SYMBOL_GPL(kvm_set_pfn_dirty);

I'm still seeing this warning show up via __handle_changed_spte
calling kvm_set_pfn_dirty:

[  113.350473]  kvm_set_pfn_dirty+0x26/0x3e
[  113.354861]  __handle_changed_spte+0x452/0x4f6
[  113.359841]  __handle_changed_spte+0x452/0x4f6
[  113.364819]  __handle_changed_spte+0x452/0x4f6
[  113.369790]  zap_gfn_range+0x1de/0x27a
[  113.373992]  kvm_tdp_mmu_zap_invalidated_roots+0x64/0xb8
[  113.379945]  kvm_mmu_zap_all_fast+0x18c/0x1c1
[  113.384827]  kvm_page_track_flush_slot+0x55/0x87
[  113.390000]  kvm_set_memslot+0x137/0x455
[  113.394394]  kvm_delete_memslot+0x5c/0x91
[  113.398888]  __kvm_set_memory_region+0x3c0/0x5e6
[  113.404061]  kvm_set_memory_region+0x45/0x74
[  113.408844]  kvm_vm_ioctl+0x563/0x60c

I wasn't seeing it for my particular test case, but the gfn aging code
might trigger the warning as well.

I don't know if setting the dirty/accessed bits in non-refcounted
struct pages is problematic. The only way I can see to avoid it would
be to try to map from the spte to the vma and then check its flags. If
setting the flags is benign, then we'd need to do that lookup to
differentiate the safe case from the use-after-free case. Do you have
any advice on how to handle this?

-David
