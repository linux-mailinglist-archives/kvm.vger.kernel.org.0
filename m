Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D66474EA4
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 00:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238278AbhLNXfE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 18:35:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235236AbhLNXfE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 18:35:04 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA36AC06173E
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 15:35:03 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id k64so19101012pfd.11
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 15:35:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gDXHyE+5f179Ixy1hF6TPncRkHGmUBczNontEgHGLBw=;
        b=dDaN4zSTIHp0O3AZVMYfOMB4N/6+RLi6EzucFkfHQYqjfaOAGlX6FUNKqpWB5LtzVi
         bJh4DQuX8zDd5XApnN65AT+uN2HQJ0Jh+ei/VEcDgco9n1FfIz5GsWOrpks4DAyEPOm/
         awYs69O7VsXg8zrS7gcNIAn8i/BYkPFZXyREroDfmrTb5Vu9To2mg5ci/pNxReeQYUvt
         nRdJ6EcGTNopZTvqW1ppodF9meXBpOF2z3mlJxrg3Fi91zHqlXTSvqEcxXnSdLrp6iWk
         3iGCHHv5HgRdbzv/qmYXN4eO57xaDy0QCNlbzx2kn5BxFW/CnIfPOo+56aL+obvOstax
         B0ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gDXHyE+5f179Ixy1hF6TPncRkHGmUBczNontEgHGLBw=;
        b=Yom+WFqYjHQz7RCim3TqgqEUgphS2a07FIiPhiJjD5/c1PLxJjmoqACeTJ6aulwkk8
         PRHcuoLKS3pSZwQiYwLRhN5xznu5861J/mY7KWtRhyOzaDhldhArCSViPCBkooNXfSFa
         brS9Yyo2ry+pTKMHtt6JxCrOLYxES2sgWEm8vOZj4LEgeRk+A3RqNkGRBW6THvucp59z
         cCARdvNtMpoz6TE7oTVUFFTkzGHgwZQDs1F/QZh3L21zew0MyOUp2XwTbMQEwr4++iqR
         hXjYOmbqJ1b/V/ojb4H6NqpF+gr04qDomRfw7ed+zYuymt6+Ub/rOAihz6+LbpsLqgwE
         vYXA==
X-Gm-Message-State: AOAM531/hpihSB9NQmLG+OhwE/QsYRpA+jqQwdYkLBUPnOOfN5YmniSo
        IkE4YKYYQinXYTaQw8Mnupep+A==
X-Google-Smtp-Source: ABdhPJxmH9w+SFOO7sAAlh9QF2Iy0zuPOZtoPKFJhVTBJsR0/xtUUru5N6j85UkjG2tsYRQ9BAHBjQ==
X-Received: by 2002:a63:8349:: with SMTP id h70mr5684564pge.53.1639524903171;
        Tue, 14 Dec 2021 15:35:03 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id rm10sm86035pjb.29.2021.12.14.15.35.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 15:35:02 -0800 (PST)
Date:   Tue, 14 Dec 2021 23:34:59 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>
Subject: Re: [PATCH 15/28] KVM: x86/mmu: Take TDP MMU roots off list when
 invalidating all roots
Message-ID: <YbkqIxJjVQkoFo5o@google.com>
References: <20211120045046.3940942-1-seanjc@google.com>
 <20211120045046.3940942-16-seanjc@google.com>
 <CANgfPd8Kz41FpvooznGW2VLp8GZFei28FCjonr2+YEZoturi0A@mail.gmail.com>
 <YZwi+TzVLQi5YlIX@google.com>
 <CANgfPd8s=8SY2R_Cg+gytU6VU2PhOqkOwtq9fAdXCgp+GRpmQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd8s=8SY2R_Cg+gytU6VU2PhOqkOwtq9fAdXCgp+GRpmQg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 22, 2021, Ben Gardon wrote:
> On Mon, Nov 22, 2021 at 3:08 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Mon, Nov 22, 2021, Ben Gardon wrote:
> > > On Fri, Nov 19, 2021 at 8:51 PM Sean Christopherson <seanjc@google.com> wrote:
> > > >
> > > > Take TDP MMU roots off the list of roots when they're invalidated instead
> > > > of walking later on to find the roots that were just invalidated.  In
> > > > addition to making the flow more straightforward, this allows warning
> > > > if something attempts to elevate the refcount of an invalid root, which
> > > > should be unreachable (no longer on the list so can't be reached by MMU
> > > > notifier, and vCPUs must reload a new root before installing new SPTE).
> > > >
> > > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > >
> > > There are a bunch of awesome little cleanups and unrelated fixes
> > > included in this commit that could be factored out.
> > >
> > > I'm skeptical of immediately moving the invalidated roots into another
> > > list as that seems like it has a lot of potential for introducing
> > > weird races.
> >
> > I disagree, the entire premise of fast invalidate is that there can't be races,
> > i.e. mmu_lock must be held for write.  IMO, it's actually the opposite, as the only
> > reason leaving roots on the per-VM list doesn't have weird races is because slots_lock
> > is held.  If slots_lock weren't required to do a fast zap, which is feasible for the
> > TDP MMU since it doesn't rely on the memslots generation, then it would be possible
> > for multiple calls to kvm_tdp_mmu_zap_invalidated_roots() to run in parallel.  And in
> > that case, leaving roots on the per-VM list would lead to a single instance of a
> > "fast zap" zapping roots it didn't invalidate.  That's wouldn't be problematic per se,
> > but I don't like not having a clear "owner" of the invalidated root.
> 
> That's a good point, the potential interleaving of zap_alls would be gross.
> 
> My mental model for the invariant here was "roots that are still in
> use are on the roots list," but I can see how "the roots list contains
> all valid, in-use roots" could be a more useful invariant.

Sadly, my idea of taking invalid roots off the list ain't gonna happen.

The immediate issue is that the TDP MMU doesn't zap invalid roots in mmu_notifier
callbacks.  This leads to use-after-free and other issues if the mmu_notifier runs
to completion while an invalid root zapper yields as KVM fails to honor the
requirement that there must be _no_ references to the page after the mmu_notifier
returns.

This is most noticeable with set_nx_huge_pages() + kvm_mmu_notifier_release(),
but the bug exists between kvm_mmu_notifier_invalidate_range_start() and memslot
updates as well.  The pages aren't accessible by the guest, and KVM won't read or
write the data itself, but KVM will trigger e.g. kvm_set_pfn_dirty() when zapping
SPTEs, _after_ the mmu_notifier returns.
