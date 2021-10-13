Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E70F42B39B
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 05:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237723AbhJMDbw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 23:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237704AbhJMDbu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 23:31:50 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DCB9C061570
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 20:29:48 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id n65so3022289ybb.7
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 20:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K1V9NDATmu17pUoF4QdYlG/zF1QvhHmXa48+FoG1Ebg=;
        b=V4hO+e2bD1JKo+Av7J5TFNJ1Ayzjepp5lrSlnAALB4jkPnPZEm3JE2msYawjx0E+JD
         tymz1KVCEPIHc7Lb1cN8BmImJcbDMIBN1FhakghcvYzmLRFwru1SX8emTJ2jfivukZrU
         17T4/dOBCe4YOLTSInLOyPaslkb0C1DApR82U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K1V9NDATmu17pUoF4QdYlG/zF1QvhHmXa48+FoG1Ebg=;
        b=XKBT4E0syhwmiAnGHZLreXIoNfcrTbRnXIIkyFFmg5XBSBFb5/+VgDDS6x1sFHUj4u
         Uxrsmm/hwFHijwX/4LubfiMFsP8k6zfwTegRqObXkwZENTJ++DYMn/ybg6TtVy/djvzH
         V7CWRgjFE7WDal8n82MI7H4qgMHtTGqChHuVCOM/wvuEXYFU4uE2md4E9nZWSQ7I6OWP
         5dh1ZrFNSYJlz8/YQ8kEc9qRQN9nRntyzzQV0t0eQzOHck82suH23i3trQbRGQpqXz+W
         desPxtrY3jFFJ4/Y0MP27izOGlVvxow8FFe83WJpi19R5NQI0yN2pkVT5ENmqG3gHBGW
         v6dQ==
X-Gm-Message-State: AOAM531Jws08PU+wZB4YBzrLIfiLERIEKStWuqAaWaB17sIEuGE+tyOv
        4eR8puH3e7GPu96bA/DtuvApDl7RMh2eq9TZe2Bmqg==
X-Google-Smtp-Source: ABdhPJxq87bgca01rLjYkuSh5HTdIgTMzvRne9NDRirxkvsd38A826PPWMoXsd9Iv9DztgPg8Lkfu/gUc5455msojX4=
X-Received: by 2002:a25:22d7:: with SMTP id i206mr34357892ybi.355.1634095787342;
 Tue, 12 Oct 2021 20:29:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210929042908.1313874-1-stevensd@google.com> <20210929042908.1313874-5-stevensd@google.com>
 <YWYiJy1Z7VZ0SxAd@google.com>
In-Reply-To: <YWYiJy1Z7VZ0SxAd@google.com>
From:   David Stevens <stevensd@chromium.org>
Date:   Wed, 13 Oct 2021 12:29:36 +0900
Message-ID: <CAD=HUj5HCdBBU2z=yJCCiAhTj0ARj-8XpLqdVbam7Kt9af+SSA@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] KVM: mmu: remove over-aggressive warnings
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
        open list <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 13, 2021 at 9:02 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Wed, Sep 29, 2021, David Stevens wrote:
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
> > index 5a1adcc9cfbc..3b469df63bcf 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -617,13 +617,6 @@ static int mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
> >
> >       pfn = spte_to_pfn(old_spte);
> >
> > -     /*
> > -      * KVM does not hold the refcount of the page used by
> > -      * kvm mmu, before reclaiming the page, we should
> > -      * unmap it from mmu first.
> > -      */
> > -     WARN_ON(!kvm_is_reserved_pfn(pfn) && !page_count(pfn_to_page(pfn)));
>
> Have you actually observed false positives with this WARN?  I would expect anything
> without a struct page to get filtered out by !kvm_is_reserved_pfn(pfn).

Those are the type of pfns that were responsible for CVE-2021-22543
[1]. One specific example is that amdgpu uses ttm_pool, which makes
higher order, non-compound allocation. Without the head/tail metadata,
only the first base page in such an allocation has non-zero
page_count.

[1] https://github.com/google/security-research/security/advisories/GHSA-7wq5-phmq-m584

> If you have observed false positives, I would strongly prefer we find a way to
> keep the page_count() sanity check, it has proven very helpful in the past in
> finding/debugging bugs during MMU development.

When we see a refcount of zero, I think we can look up spte->(gfn,
slot)->hva->vma and determine whether or not the zero refcount is
okay, based on vm_flags. That's kind of heavy for a debug check,
although at least we'd only pay the cost for unusual mappings. But it
still might make sense to switch to a MMU_WARN_ON, in that case. Or we
could just ignore the cost, since at least from a superficial reading
and some basic tests, tdp_mmu doesn't seem to execute this code path.

Thoughts? I'd lean towards MMU_WARN_ON, but I'd like to know what the
maintainers' preferences are before sending an updated patch series.

-David

>
> > -
> >       if (is_accessed_spte(old_spte))
> >               kvm_set_pfn_accessed(pfn);
> >
