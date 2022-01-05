Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 255AB4857CE
	for <lists+kvm@lfdr.de>; Wed,  5 Jan 2022 18:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242617AbiAER6R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jan 2022 12:58:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiAER6Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jan 2022 12:58:16 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A3FCC061245
        for <kvm@vger.kernel.org>; Wed,  5 Jan 2022 09:58:16 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id j11so89077314lfg.3
        for <kvm@vger.kernel.org>; Wed, 05 Jan 2022 09:58:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Aj/b2avp8KUsy2rGXMUdzHUKT1BR1FML2weAB3oLc38=;
        b=pFFa7cxMcDd1zs7kAd4PszwyJsQNAHQU90kRLgowExSkba+PRwvLUfAjFEnW15+FMB
         w+bpV9i9GRSL3Xrsd//UK9yWNpjRbNtF7S7utXgQiao8J2/sUrcHRYdf3KYZ1lGAUFRm
         DkORcClp6mVOuVlEubK3q+aJ1pLL/PvlOcaip2tuF20cGy1xbH2M3Mp6QDafDVV967i/
         51aCKJypG7UCowzfS15Vr/E7sK4umNlBvZeB404EYJSrI+K0lL1NYVzcJqg0WFd4LNoC
         j2j2DrFCfPkaLyWddE6KNcDbKI4b3Z/QSbxjvnVND/Hw9vrcCroSAtvWVPs14t8IaCIl
         RcoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Aj/b2avp8KUsy2rGXMUdzHUKT1BR1FML2weAB3oLc38=;
        b=Bhw5fhP8JTieTTuCAxS2J7wT0zX/37uPOj5vPa1Ns3v6StECjEmsxuiXNuHReZSaHJ
         AC4X390b59adrCk9CyOlMTNuwd5RXyX3tsykBVO9eXXk7OMJkb+rjN1aZ6Jeutl+JycS
         w5iOyUhwhK9plkgs2o05xgWe1vrYnkm28Y9FQ3lE+QOsQZIQdliyAIpWIsvShXjcxUOo
         4aV+4ER9Hm0/FcQuc3h8OrnyiK0G5zZLZSiuzncrLPsrmnlPwe4+tLZ3iQbkYSYE7i+K
         NQEoCyysP6lbWKLfKbnrDS6mXr5wqsVTAmeubU8kBQ0eJQS0qm5hfBevlAxLp4s43mj1
         K7Jw==
X-Gm-Message-State: AOAM530U1muw+VV4rXYXftegMb1QQCXdezsDY37Hx0QxcpgxwrgYCCbM
        mAD6YInxhiHx45IckchuB3YqD7iBAeVO3NnTm57zKQ==
X-Google-Smtp-Source: ABdhPJyOBJiwPMLaXkve/82xH41xD8u7NgWN3c4IV7v+V/eZtmUeu+Jaa4G9aQ3H10OC7TMuTzuTJw28612MqYvaAv8=
X-Received: by 2002:ac2:4c83:: with SMTP id d3mr47298897lfl.102.1641405494144;
 Wed, 05 Jan 2022 09:58:14 -0800 (PST)
MIME-Version: 1.0
References: <20211213225918.672507-1-dmatlack@google.com> <20211213225918.672507-12-dmatlack@google.com>
 <YdVejo2TODD3Z+QC@xz-m1.local> <CALzav=fqg3AzrJkWR3StKLG38vzwcycSu19M=TFfCWg+wG8q9Q@mail.gmail.com>
In-Reply-To: <CALzav=fqg3AzrJkWR3StKLG38vzwcycSu19M=TFfCWg+wG8q9Q@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 5 Jan 2022 09:57:47 -0800
Message-ID: <CALzav=eW-OsLHmECVyYBsvzJ=Th4cfe0+3+aJBL2XBuvrh-8dw@mail.gmail.com>
Subject: Re: [PATCH v1 11/13] KVM: x86/mmu: Split huge pages during CLEAR_DIRTY_LOG
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 5, 2022 at 9:55 AM David Matlack <dmatlack@google.com> wrote:
>
> On Wed, Jan 5, 2022 at 1:02 AM Peter Xu <peterx@redhat.com> wrote:
> >
> > On Mon, Dec 13, 2021 at 10:59:16PM +0000, David Matlack wrote:
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index c9e5fe290714..55640d73df5a 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -1362,6 +1362,20 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
> > >               gfn_t start = slot->base_gfn + gfn_offset + __ffs(mask);
> > >               gfn_t end = slot->base_gfn + gfn_offset + __fls(mask);
> > >
> > > +             /*
> > > +              * Try to proactively split any huge pages down to 4KB so that
> > > +              * vCPUs don't have to take write-protection faults.
> > > +              *
> > > +              * Drop the MMU lock since huge page splitting uses its own
> > > +              * locking scheme and does not require the write lock in all
> > > +              * cases.
> > > +              */
> > > +             if (READ_ONCE(eagerly_split_huge_pages_for_dirty_logging)) {
> > > +                     write_unlock(&kvm->mmu_lock);
> > > +                     kvm_mmu_try_split_huge_pages(kvm, slot, start, end, PG_LEVEL_4K);
> > > +                     write_lock(&kvm->mmu_lock);
> > > +             }
> > > +
> > >               kvm_mmu_slot_gfn_write_protect(kvm, slot, start, PG_LEVEL_2M);
> >
> > Would it be easier to just allow passing in shared=true/false for the new
> > kvm_mmu_try_split_huge_pages(), then previous patch will not be needed?  Or is
> > it intended to do it for performance reasons?
> >
> > IOW, I think this patch does two things: (1) support clear-log on eager split,
> > and (2) allow lock degrade during eager split.
> >
> > It's just that imho (2) may still need some justification on necessity since
> > this function only operates on a very small range of guest mem (at most
> > 4K*64KB=256KB range), so it's not clear to me whether the extra lock operations
> > are needed at all; after all it'll make the code slightly harder to follow.
> > Not to mention the previous patch is preparing for this, and both patches will
> > add lock operations.
> >
> > I think dirty_log_perf_test didn't cover lock contention case, because clear
> > log was run after vcpu threads stopped, so lock access should be mostly hitting
> > the cachelines there, afaict.  While in real life, clear log is run with vcpus
> > running.  Not sure whether that'll be a problem, so raising this question up.
>
> Good point. Dropping the write lock to acquire the read lock is
> probably not necessary since we're splitting a small region of memory
> here. Plus the splitting code detects contention and will drop the
> lock if necessary. And the value of dropping the lock is dubious since
> it adds a lot more lock operations.

I wasn't very clear here. I meant the value of "dropping the write
lock to switch the read lock every time we split" is dubious since it
adds more lock operations. Dropping the lock and yielding when there's
contention detected is not dubious :).

>
> I'll try your suggestion in v3.
>
> >
> > Thanks,
>
>
> >
> > --
> > Peter Xu
> >
