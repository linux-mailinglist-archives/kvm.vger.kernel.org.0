Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203EA46447E
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 02:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233553AbhLABdB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 20:33:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbhLABdA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 20:33:00 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC9CC061574
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 17:29:40 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id k37so58590313lfv.3
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 17:29:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I7QkS/3LaNMozeuLEGU+HVMk+GdSSdWWWQ+92EhjyI8=;
        b=iacrYMXKGfrjS3oBHOvTG0bqUadxV0p9tNOrTYgt4cIzOvxorFa1IE8G4TAJP5yLUu
         AGu2N8LiMinxnjessPh/axosV/pgu8EQbQql0FGIxzMJYE5drWQBc2Y3+iKAMnMKJL0/
         JqL01nQtvsdv2Jnf/utoZJOJZGL8FuEFe0bYK75XTb2PsznvuQc1pOX2m6yC09M+rTeG
         +3IoqCdI5PnDjlLXOiIKlKh9ETtKcUyuNu8wtsfcmUHirr9iJ54RidUrj4hE5ppRjSlZ
         Y32FiZwwl0SYO+rY34GkGXQ5/RnYFx7thHxhYg9OYrfqb5Z24ulKCMsSDcCpZDA5EWkp
         QCjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I7QkS/3LaNMozeuLEGU+HVMk+GdSSdWWWQ+92EhjyI8=;
        b=Z/pIoOw+f9COSBEdDStpSErHrB6ZNYaPakf0RgDmb447iwqXE3vckG48JDEyuW3FMd
         m1KUFVghqKt4BeuEyCiDNYrBspo5ml0LmwRyeYzR2LCJjgKBDztIvgfjd0Li2LrKnEQi
         mZVLkohb37wHqPtJCJnpDA87AEloijuOVbVEPrr7kPO3KQqW/ANKr9qJSzVWuSmVbt0h
         JWIaXlhewQUbNAX53k5AK4T6tXsws2sKJPOBCNQMzhz9RKb23dybnI4dn8bR5dwa5nuR
         g73kikVDdS6FuFg+mnNHjO4BfI2zc0J5vFwTJbqeUqdN/tT/xwrcCA58W88fqrhO0Utf
         wG/w==
X-Gm-Message-State: AOAM533vulk/8hqITBcEqwgLT+o1xkH7rq4HyDgdM8Xu+0d7rszG99d2
        PrU5wrtmCV7QBkj+Vy6bWKUUxaVoTNgVZopSBfoxHw==
X-Google-Smtp-Source: ABdhPJz3l2xFLj/ItGNLJ4Oumy5TDOgJRnvZzVks4yyZ0jHEQSTDatWqVbAfo5UCfWS5BLH1NKgCFvYEVU+1xGdKkjo=
X-Received: by 2002:ac2:558d:: with SMTP id v13mr2842625lfg.190.1638322177271;
 Tue, 30 Nov 2021 17:29:37 -0800 (PST)
MIME-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com> <20211119235759.1304274-13-dmatlack@google.com>
 <YaDMg3/xUSwL5+Ei@xz-m1.local> <CALzav=cXgCSP3RLh+gss65==B6eYXC82V3zNjv2KCNehUMQewA@mail.gmail.com>
 <YabJSdRklj3T6FWJ@google.com>
In-Reply-To: <YabJSdRklj3T6FWJ@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Tue, 30 Nov 2021 17:29:10 -0800
Message-ID: <CALzav=cJpWPF1RzsEZcoN+ZX8kM3OquKQR-8rdTksZ6cs1R+EQ@mail.gmail.com>
Subject: Re: [RFC PATCH 12/15] KVM: x86/mmu: Split large pages when dirty
 logging is enabled
To:     Sean Christopherson <seanjc@google.com>
Cc:     Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 30, 2021 at 5:01 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Nov 30, 2021, David Matlack wrote:
> > On Fri, Nov 26, 2021 at 4:01 AM Peter Xu <peterx@redhat.com> wrote:
> > >
> > > Hi, David,
> > >
> > > On Fri, Nov 19, 2021 at 11:57:56PM +0000, David Matlack wrote:
> > > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > > index 2a7564703ea6..432a4df817ec 100644
> > > > --- a/arch/x86/include/asm/kvm_host.h
> > > > +++ b/arch/x86/include/asm/kvm_host.h
> > > > @@ -1232,6 +1232,9 @@ struct kvm_arch {
> > > >       hpa_t   hv_root_tdp;
> > > >       spinlock_t hv_root_tdp_lock;
> > > >  #endif
> > > > +
> > > > +     /* MMU caches used when splitting large pages during VM-ioctls. */
> > > > +     struct kvm_mmu_memory_caches split_caches;
> > >
> > > Are mmu_gfn_array_cache and mmu_pte_list_desc_cache wasted here?  I saw that
> > > "struct kvm_mmu_memory_cache" still takes up quite a few hundreds of bytes,
> > > just want to make sure we won't waste them in vain.
> >
> > Yes they are wasted right now. But there's a couple of things to keep in mind:
> >
> > 1. They are also wasted in every vCPU (in the per-vCPU caches) that
> > does not use the shadow MMU.
> > 2. They will (I think) be used eventually when I add Eager Page
> > Splitting support to the shadow MMU.
> > 3. split_caches is per-VM so it's only a few hundred bytes per VM.
> >
> > If we really want to save the memory the right way forward might be to
> > make each kvm_mmu_memory_cache a pointer instead of an embedded
> > struct. Then we can allocate each dynamically only as needed. I can
> > add that to my TODO list but I don't think it'd be worth blocking this
> > on it given the points above.
> >
> > >
> > > [...]
> > >
> > > > +int mmu_topup_split_caches(struct kvm *kvm)
> > > > +{
> > > > +     struct kvm_mmu_memory_caches *split_caches = &kvm->arch.split_caches;
> > > > +     int r;
> > > > +
> > > > +     assert_split_caches_invariants(kvm);
> > > > +
> > > > +     r = kvm_mmu_topup_memory_cache(&split_caches->page_header_cache, 1);
> > > > +     if (r)
> > > > +             goto out;
> > > > +
> > > > +     r = kvm_mmu_topup_memory_cache(&split_caches->shadow_page_cache, 1);
> > > > +     if (r)
> > > > +             goto out;
> > >
> > > Is it intended to only top-up with one cache object?  IIUC this means we'll try
> > > to proactively yield the cpu for each of the huge page split right after the
> > > object is consumed.
> > >
> > > Wondering whether it be more efficient to make it a slightly larger number, so
> > > we don't overload the memory but also make the loop a bit more efficient.
> >
> > IIUC, 1 here is just the min needed for kvm_mmu_topup_memory_cache to
> > return success. I chose 1 for each because it's the minimum necessary
> > to make forward progress (split one large page).
>
> The @min parameter is minimum number of pages that _must_ be available in the
> cache, i.e. it's the maximum number of pages that can theoretically be used by
> whatever upcoming operation is going to be consuming pages from the cache.
>
> So '1' is technically correct, but I think it's the wrong choice given the behavior
> of this code.  E.g. if there's 1 object in the cache, the initial top-up will do
> nothing,

This scenario will not happen though, since we free the caches after
splitting. So, the next time userspace enables dirty logging on a
memslot and we go to do the initial top-up the caches will have 0
objects.

> and then tdp_mmu_split_large_pages_root() will almost immediately drop
> mmu_lock to topup the cache.  Since the in-loop usage explicitly checks for an
> empty cache, i.e. any non-zero @min will have identical behavior, I think it makes
> sense to use KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE _and_ add a comment explaining why.

If we set the min to KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE,
kvm_mmu_topup_memory_cache will return ENOMEM if it can't allocate at
least KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE objects, even though we really
only need 1 to make forward progress.

It's a total edge case but there could be a scenario where userspace
sets the cgroup memory limits so tight that we can't allocate
KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE objects when splitting the last few
pages and in the end we only needed 1 or 2 objects to finish
splitting. In this case we'd end up with a spurious pr_warn and may
not split the last few pages depending on which cache failed to get
topped up.


>
> > No matter what you pass for min kvm_mmu_topup_memory_cache() will
> > still always try to allocate KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
> > objects.
>
> No, it will try to allocate KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE if and only if there
> are fewer than @min objects in the cache.
