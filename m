Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60365349C87
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 23:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbhCYWqe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 18:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbhCYWqH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 18:46:07 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F8B4C06174A
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 15:46:07 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id v26so3526502iox.11
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 15:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vr8jx5HqmowOc9mzzRH8nyvNiCy6SLGQQdzTOO7BYQc=;
        b=J47+cqdvpvEehRJITiM/Qtsv3h7cnBc6W92nj4YaE7DygkqoWd81DOYTqN9bT1sG0a
         AmdfzNY/pE1IsK0q3MiC0UGwtYUcXloTq0fPoflXHTn0Vp2GX6Y6uRiymYU7hPNaS9OU
         WcMOe4R/BKiIax1n36Vjtl39sYWAz4ozk90GJCkhU4UrX367AQw4kwKuXN1ZspLyPkCG
         tqE8W8h8pJChZSovYuFVC9hSbOVekGQ2uKi7mYLlMXK5GJYNQQbRhyf/06UJnxKL9VzT
         6RXd4BPjKYhSvnDyAd+DpAFfJkkbP9TWF9eMgz/K6a7zkOdltYOvCWS8hzY8ab/8SwuA
         tl2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vr8jx5HqmowOc9mzzRH8nyvNiCy6SLGQQdzTOO7BYQc=;
        b=JSA3fmmaqGYTIxADr25RancwCvwJk6QvBzSEXD5qje9muNZFW9EtJUdJ4be3OURgVd
         NKhQUGnfZV2SCfrLJcrsB8pf0On4E13HyZCpMMKQbXJ2m2SXtinrrSeO96fPbvEZXlk2
         Ep3VyIzCj3+eGbqZGFKUhkxNRzUuTh8ouACDt55zgN/gF3Vktlypl8shfd3HkGnyESV5
         xbVl2Dybx/ZG+0kR4vhWN7oNFaM0yrdimCvz5c+GuRscP1KICUOUkinEZPiE3ap02zO2
         D1Y3kltvKYqWuLUHZPaKG985YTUmFU6DFBbu66jslYvJFWabWzIabJee3Fm69ecKWvVZ
         kvNA==
X-Gm-Message-State: AOAM532PIEU/iz50/ffUm5cjSv2h3LKr+pjUfSUNBK5A9MP/HbNEsoyB
        Fc6TaDPHWZZXd0udhS7QSHQuCUI3vxIaWOUacW/ZHQ==
X-Google-Smtp-Source: ABdhPJxJVBy3q940UtG8JRVlEvPnmQI5YHDSUhNDkkxec39bCTxnOvwhIW1qXTfrVjtC6MCUD8kx1f0JO6Ww72HdUJQ=
X-Received: by 2002:a6b:ee0b:: with SMTP id i11mr8493762ioh.157.1616712366324;
 Thu, 25 Mar 2021 15:46:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210325200119.1359384-1-seanjc@google.com> <20210325200119.1359384-4-seanjc@google.com>
 <CANgfPd8N1+oxPWyO+Ob=hSs4nkdedusde6RQ5TXTX8hi48mvOw@mail.gmail.com> <YF0N5/qsmsNHQeVy@google.com>
In-Reply-To: <YF0N5/qsmsNHQeVy@google.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Thu, 25 Mar 2021 15:45:56 -0700
Message-ID: <CANgfPd98XttnW0VTN3nSyd=ZWO8sQR53C2oygC6OH+DecMnioA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] KVM: x86/mmu: Don't allow TDP MMU to yield when
 recovering NX pages
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 25, 2021 at 3:25 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Mar 25, 2021, Ben Gardon wrote:
> > On Thu, Mar 25, 2021 at 1:01 PM Sean Christopherson <seanjc@google.com> wrote:
> > > +static inline bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start,
> > > +                                            gfn_t end)
> > > +{
> > > +       return __kvm_tdp_mmu_zap_gfn_range(kvm, start, end, true);
> > > +}
> > > +static inline bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
> >
> > I'm a little leary of adding an interface which takes a non-root
> > struct kvm_mmu_page as an argument to the TDP MMU.
> > In the TDP MMU, the struct kvm_mmu_pages are protected rather subtly.
> > I agree this is safe because we hold the MMU lock in write mode here,
> > but if we ever wanted to convert to holding it in read mode things
> > could get complicated fast.
> > Maybe this is more of a concern if the function started to be used
> > elsewhere since NX recovery is already so dependent on the write lock.
>
> Agreed.  Even writing the comment below felt a bit awkward when thinking about
> additional users holding mmu_lock for read.  Actually, I should remove that
> specific blurb since zapping currently requires holding mmu_lock for write.
>
> > Ideally though, NX reclaim could use MMU read lock +
> > tdp_mmu_pages_lock to protect the list and do reclaim in parallel with
> > everything else.
>
> Yar, processing all legacy MMU pages, and then all TDP MMU pages to avoid some
> of these dependencies crossed my mind.  But, it's hard to justify effectively
> walking the list twice.  And maintaining two lists might lead to balancing
> issues, e.g. the legacy MMU and thus nested VMs get zapped more often than the
> TDP MMU, or vice versa.

I think in an earlier version of the TDP that I sent out, NX reclaim
was a seperate thread for the two MMUs, sidestepping the balance
issue.
I think the TDP MMU also had a seperate NX reclaim list.
That would also make it easier to do something under the read lock.

>
> > The nice thing about drawing the TDP MMU interface in terms of GFNs
> > and address space IDs instead of SPs is that it doesn't put
> > constraints on the implementation of the TDP MMU because those GFNs
> > are always going to be valid / don't require any shared memory.
> > This is kind of innocuous because it's immediately converted into that
> > gfn interface, so I don't know how much it really matters.
> >
> > In any case this change looks correct and I don't want to hold up
> > progress with bikeshedding.
> > WDYT?
>
> I think we're kind of hosed either way.  Either we add a helper in the TDP MMU
> that takes a SP, or we bleed a lot of information about the details of TDP MMU
> into the common MMU.  E.g. the function could be open-coded verbatim, but the
> whole comment below, and the motivation for not feeding in flush is very
> dependent on the internal details of TDP MMU.
>
> I don't have a super strong preference.  One thought would be to assert that
> mmu_lock is held for write, and then it largely come future person's problem :-)

Yeah, I agree and I'm happy to kick this proverbial can down the road
until we actually add an NX reclaim implementation that uses the MMU
read lock.

>
> > > +{
> > > +       gfn_t end = sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level);
> > > +
> > > +       /*
> > > +        * Don't allow yielding, as the caller may have a flush pending.  Note,
> > > +        * if mmu_lock is held for write, zapping will never yield in this case,
> > > +        * but explicitly disallow it for safety.  The TDP MMU does not yield
> > > +        * until it has made forward progress (steps sideways), and when zapping
> > > +        * a single shadow page that it's guaranteed to see (thus the mmu_lock
> > > +        * requirement), its "step sideways" will always step beyond the bounds
> > > +        * of the shadow page's gfn range and stop iterating before yielding.
> > > +        */
> > > +       return __kvm_tdp_mmu_zap_gfn_range(kvm, sp->gfn, end, false);
> > > +}
> > >  void kvm_tdp_mmu_zap_all(struct kvm *kvm);
> > >
> > >  int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
> > > --
> > > 2.31.0.291.g576ba9dcdaf-goog
> > >
