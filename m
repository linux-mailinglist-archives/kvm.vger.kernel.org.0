Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E4E42E50B
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 02:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234578AbhJOAMd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 20:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233426AbhJOAMc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 20:12:32 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8EFC061570
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 17:10:27 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id g5so5284919plg.1
        for <kvm@vger.kernel.org>; Thu, 14 Oct 2021 17:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KKAviLRUKqVjp43nqMLg6bveGxLDROIz4blReEr8Bmo=;
        b=ZBD68KtEuRuJ2LXGX2e4Bq5AGfrbJB7Ct4q5cPqaOIdkz8JGahpzAsLGlpbmGa0qj2
         HgTKgCzwXvVzOP6SUz7KzzNlWNh+tnwRWS20rjnszlEGubea5dq2zvlTU/CQg4R9ZITI
         vTcpu8c93VKGxm1TuBo1hNUo+LC6eRQtOQjqY691/6F3GL1EYIyoux9G8Bq37r68yUiq
         1ZSH61AKIqVtSF6z4dNYil5nXb3BlP+PgpmV3xO0JqjLA7b/44qUnrZ2OQbfX+CaMyoL
         4iGPd7aT4gg3DBpMvmh7xmVj5NW7ai9ibGHXGw1bGDe29In+oJwcG/GHgWpgXr73ZraR
         hP+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KKAviLRUKqVjp43nqMLg6bveGxLDROIz4blReEr8Bmo=;
        b=O0H2RXnBaDIipmiVzKXH4mWzDa+1IuDvIEUtFtYXGB28LQXyZhUNmEidiNVY/7cJvK
         h3HykNS6ra91C08wZ3qr+jp8nA8Vuljhs4qCupHNPrXq96C+AJ4y/bNrNl98+wcqdIg5
         OO+F5VfdKr3FDWB9yc1e8NHpMhID6y/Nmqe6DFE2Yk7Pr05fLHVLsFfxFhu1H9EOKkrZ
         7OtPddW8E4Sgk6+wJ3AziPBbgxWiMSMt0/5aLC2YRU4iSeEs+sVfXZMZ5tkc7R5FsolL
         qicmBTAOVXi65wFZneXNkArjo9bJRHQoSrBReHzp89PV/MZbn2wVExpfweGsxaR3DaBj
         NPHA==
X-Gm-Message-State: AOAM533UFSipUw9qoIJd4JCXelwUKzHMYO2T0fFqN5X03qzDN/etHmrS
        tJz419vbwPe0uTlbH6BlwGXu7g==
X-Google-Smtp-Source: ABdhPJwTVpqE5aEbYXFT63sU9y1zGxi+9b4o6MVy6i9quejmJK/oyroXtRQRCRyj99is3chHPVoCTQ==
X-Received: by 2002:a17:902:d2c6:b0:13f:1ecb:aefd with SMTP id n6-20020a170902d2c600b0013f1ecbaefdmr7991685plc.50.1634256626178;
        Thu, 14 Oct 2021 17:10:26 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x13sm3197813pge.37.2021.10.14.17.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 17:10:25 -0700 (PDT)
Date:   Fri, 15 Oct 2021 00:10:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Stevens <stevensd@chromium.org>
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
Subject: Re: [PATCH v4 4/4] KVM: mmu: remove over-aggressive warnings
Message-ID: <YWjG7XJ9rx5qLzm7@google.com>
References: <20210929042908.1313874-1-stevensd@google.com>
 <20210929042908.1313874-5-stevensd@google.com>
 <YWYiJy1Z7VZ0SxAd@google.com>
 <CAD=HUj5HCdBBU2z=yJCCiAhTj0ARj-8XpLqdVbam7Kt9af+SSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAD=HUj5HCdBBU2z=yJCCiAhTj0ARj-8XpLqdVbam7Kt9af+SSA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 13, 2021, David Stevens wrote:
> On Wed, Oct 13, 2021 at 9:02 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Wed, Sep 29, 2021, David Stevens wrote:
> > > From: David Stevens <stevensd@chromium.org>
> > >
> > > Remove two warnings that require ref counts for pages to be non-zero, as
> > > mapped pfns from follow_pfn may not have an initialized ref count.
> > >
> > > Signed-off-by: David Stevens <stevensd@chromium.org>
> > > ---
> > >  arch/x86/kvm/mmu/mmu.c | 7 -------
> > >  virt/kvm/kvm_main.c    | 2 +-
> > >  2 files changed, 1 insertion(+), 8 deletions(-)
> > >
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 5a1adcc9cfbc..3b469df63bcf 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -617,13 +617,6 @@ static int mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
> > >
> > >       pfn = spte_to_pfn(old_spte);
> > >
> > > -     /*
> > > -      * KVM does not hold the refcount of the page used by
> > > -      * kvm mmu, before reclaiming the page, we should
> > > -      * unmap it from mmu first.
> > > -      */
> > > -     WARN_ON(!kvm_is_reserved_pfn(pfn) && !page_count(pfn_to_page(pfn)));
> >
> > Have you actually observed false positives with this WARN?  I would expect anything
> > without a struct page to get filtered out by !kvm_is_reserved_pfn(pfn).
> 
> Those are the type of pfns that were responsible for CVE-2021-22543
> [1]. One specific example is that amdgpu uses ttm_pool, which makes
> higher order, non-compound allocation. Without the head/tail metadata,
> only the first base page in such an allocation has non-zero
> page_count.

Huh.  I hadn't actually read the CVE, or obviously thought critically about the
problem. :-)

> [1] https://github.com/google/security-research/security/advisories/GHSA-7wq5-phmq-m584
> 
> > If you have observed false positives, I would strongly prefer we find a way to
> > keep the page_count() sanity check, it has proven very helpful in the past in
> > finding/debugging bugs during MMU development.
> 
> When we see a refcount of zero, I think we can look up spte->(gfn,
> slot)->hva->vma and determine whether or not the zero refcount is
> okay, based on vm_flags. That's kind of heavy for a debug check,
> although at least we'd only pay the cost for unusual mappings. But it
> still might make sense to switch to a MMU_WARN_ON, in that case. Or we
> could just ignore the cost, since at least from a superficial reading
> and some basic tests, tdp_mmu doesn't seem to execute this code path.
> 
> Thoughts? I'd lean towards MMU_WARN_ON, but I'd like to know what the
> maintainers' preferences are before sending an updated patch series.

MMU_WARN_ON is a poor choice, but only because no one turns it on.  I think we've
discussed turning it into a proper Kconfig (and killing off mmu_audit.c) multiple
times, but no one has actually followed through.

The TDP MMU indeed doesn't hit this path.  So I'd say just keep this patch as is
and punt the whole MMU_WARN_ON / audit cleanup to the future.  I bet if we spend
any time at all, we can think of a big pile of MMU sanity checks we could add to
KVM, i.e. this can be but one of many checks that applies to all flavors of MMUs.
