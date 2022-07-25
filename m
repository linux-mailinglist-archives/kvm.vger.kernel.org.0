Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF0158085F
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 01:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbiGYXpt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 19:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbiGYXps (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 19:45:48 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5676323153
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 16:45:47 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id u20so7046624ljk.0
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 16:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gZvIFke54EXtAZYQklJLeEG4nGrqObiFFpAoFCoKObw=;
        b=WiY66L+OyVEJ95/odHvT8JXXvMFgAh+a/zGWmxWGZxqdCcmpQYvczOUO46+TFq3/se
         HdUnTtFmLUIfBg7qNwvLmpF14rGRSsmXuWjvYPi7wK3gtt/Ub0Y8OkRKcscrB175TBjA
         Ic2QYDsmHwDTsty8y1pXuqOK31KBBQLo+FwXHXvpVAjHvTJrBG37ITiS5udz3DU6S58r
         cr5EdQAEGCmZqOQ48oGAGKNteBZE7EJ8ETE6O7ZU6gbo2qQyLTQ8uz5bXs2zDMOVpqG9
         aAuYNep1z1gBOD9/vj4g2HjMtTgQjvpmoOdWvPq7UbWC1vsXS1tegTGUKkdoqDXW64Wz
         NXrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gZvIFke54EXtAZYQklJLeEG4nGrqObiFFpAoFCoKObw=;
        b=ugZuH8dVfM2jt94zx0MP/acrFkTAFQGlrQNjFxeVdPWK9cI9QPAY6o338WhH5f/sfP
         qbMLIfcIsuKxKDkjvUBE14kaq1/I4kYPTZ6paNgSteJsLAvvVv9CFkSDyFQVHDk2HVbE
         RAWDC6Mj+eQn+wku/ZO7JrtJ9HODSuMdD31YIYzMdB+ovVAkhAdrz+pjgukRF8krl0yP
         FZmlLzTJN3cN1R2RVUGh5hh9dlJSSQGmYJkTKd6RWJiTuk0GtymF5secrZjosnNzLMEb
         RtEQjls0mtum9trGyFUK6EMYYpXS0OOcO3N1p15r/fdyvDMLyZK6ysCuk/mLGIFcZYtp
         JiSQ==
X-Gm-Message-State: AJIora+8pUS3WCRXjRXJx68TrKe2iOzb/NVZhvXPZdZhw6ZO3azhUEuv
        7Mjqu3t+GkhGrCsh+xI6FX701jeVNhkGT0OrKaYmyA==
X-Google-Smtp-Source: AGRyM1ux00ZPLkrJk3ugrfBC3muu5Ivl0prRGB189c9sUUlINMYP+ka3sY/JpqeDcIknsxIIOYszbolAx6SgX9B+TH8=
X-Received: by 2002:a2e:b5d6:0:b0:25e:13f7:8083 with SMTP id
 g22-20020a2eb5d6000000b0025e13f78083mr234032ljn.275.1658792745472; Mon, 25
 Jul 2022 16:45:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220723012325.1715714-1-seanjc@google.com> <20220723012325.1715714-2-seanjc@google.com>
 <Yt8eC2OyolG9QE3g@google.com> <Yt8mo6XbT/60UcpS@google.com>
In-Reply-To: <Yt8mo6XbT/60UcpS@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 25 Jul 2022 16:45:19 -0700
Message-ID: <CALzav=esXG1yekYk1zCtLt3VGsuGJKYycBhUgtgwiU8w1Anucw@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] KVM: x86/mmu: Tag disallowed NX huge pages even if
 they're not tracked
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yosry Ahmed <yosryahmed@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 25, 2022 at 4:26 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Jul 25, 2022, David Matlack wrote:
> > On Sat, Jul 23, 2022 at 01:23:20AM +0000, Sean Christopherson wrote:
> > > Tag shadow pages that cannot be replaced with an NX huge page even if
> > > zapping the page would not allow KVM to create a huge page, e.g. because
> > > something else prevents creating a huge page.
> >
> > This sentence looks messed up :). Should it read:
> >
> >   Tag shadow pages that cannot be replaced with an NX huge page, e.g.
> >   because something else prevents creating a huge page.
> >
> > ?
>
> Hmm, not quite.  Does this read better?
>
>   Tag shadow pages that cannot be replaced with an NX huge page regardless
>   of whether or not zapping the page would allow KVM to immediately create
>   a huge page, e.g. because something else prevents creating a huge page.
>
> What I'm trying to call out is that, today, KVM tracks pages that were disallowed
> from being huge due to the NX workaround if and only if the page could otherwise
> be huge.  After this patch, KVM will track pages that were disallowed regardless
> of whether or they could have been huge at the time of fault.

Ah I see now! The way you explained it in the second paragraph here
clarified it for me, so if you can fit that into the commit message as
well that would be great.

>
> > > +void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
> > > +                     bool nx_huge_page_possible)
> > > +{
> > > +   sp->nx_huge_page_disallowed = true;
> > > +
> > > +   if (!nx_huge_page_possible)
> > > +           untrack_possible_nx_huge_page(kvm, sp);
> >
> > What would be a scenario where calling untrack_possible_nx_huge_page()
> > is actually necessary here?
>
> The only scenario that jumps to mind is the non-coherent DMA with funky MTRRs
> case.  There might be others, but it's been a while since I wrote this...
>
> The MTRRs are per-vCPU (KVM really should just track them as per-VM, but whatever),
> so it's possible that KVM could encounter a fault with a lower fault->req_level
> than a previous fault that set nx_huge_page_disallowed=true (and added the page
> to the possible_nx_huge_pages list because it had a higher req_level).

But in that case the lower level SP would already have been installed,
so we wouldn't end up calling account_nx_huge_page() and getting to
this point. (account_nx_huge_page() is only called when linking in an
SP.)

Maybe account_nx_huge_page() needs to be pulled out and called for
every SP on the walk during a fault?

>
> > > @@ -5970,7 +5993,7 @@ int kvm_mmu_init_vm(struct kvm *kvm)
> > >
> > >     INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
> > >     INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
> > > -   INIT_LIST_HEAD(&kvm->arch.lpage_disallowed_mmu_pages);
> > > +   INIT_LIST_HEAD(&kvm->arch.possible_nx_huge_pages);
> > >     spin_lock_init(&kvm->arch.mmu_unsync_pages_lock);
> > >
> > >     r = kvm_mmu_init_tdp_mmu(kvm);
> > > @@ -6845,23 +6868,25 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
> >
> > Can you rename this to kvm_recover_nx_huge_pages() while you're here?
>
> Will do.
>
> > > @@ -1134,7 +1136,7 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
> > >     spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> > >     list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
> > >     if (account_nx)
> > > -           account_huge_nx_page(kvm, sp);
> > > +           account_nx_huge_page(kvm, sp, true);
> >
> >
> > account_nx is fault->huge_page_disallowed && fault->req_level >=
> > iter.level. So this is equivalent to:
> >
> >   if (fault->huge_page_disallowed && fault->req_level >= iter.level)
> >           account_nx_huge_page(kvm, sp, true);
> >
> > Whereas __direct_map() uses:
> >
> >   if (fault->is_tdp && fault->huge_page_disallowed)
> >         account_nx_huge_page(vcpu->kvm, sp, fault->req_level >= it.level);
> >
> > Aside from is_tdp (which you cover in another patch), why is there a
> > discrepancy in the NX Huge Page accounting?
>
> That wart gets fixed in patch 3.  Fixing the TDP MMU requires more work due to
> mmu_lock being held for read and so I wanted to separate it out.  And as a minor
> detail, the Fixes: from this patch predates the TDP MMU, so in a way it's kinda
> sorta a different bug.
>
> > >     spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> > >
> > >     return 0;
> > > --
> > > 2.37.1.359.gd136c6c3e2-goog
> > >
