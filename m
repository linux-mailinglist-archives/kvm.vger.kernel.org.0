Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCB146588C
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 22:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343519AbhLAVvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 16:51:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353142AbhLAVu1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 16:50:27 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85320C061574
        for <kvm@vger.kernel.org>; Wed,  1 Dec 2021 13:47:05 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id t26so66432089lfk.9
        for <kvm@vger.kernel.org>; Wed, 01 Dec 2021 13:47:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F99WCI455FQ9yLpRrO5kIrSFWi87ma7VQ3wbenSp+wo=;
        b=n5RLlkTlYO7omnP4HFzunmDZnoEsyC8jebThaW9ZVaQe72tOBZiqTqc/QVuwH8fqIY
         QjhlSO40ccldAtVgeXVfG1+7/R+nWkM2iYU3/psQzviQ71CwUK//iAKAhTHnO7El98wi
         ai0m1vlzlJKrhrt0zFgNX/pL99J7DPPHRZkRasIh760Jv8AJWKrbntd1p2Cq+Z7RYYSV
         uk6Gx4imYLyexUjcfuwlehC73jI6qKPtGTkPGgPy+VJ5rEL6sc3DZn0g5dCx9ZG9LkZm
         QMU9fXUxUm948jMxLLrHX3PqnLqJHkzssDlnyn8x33jET5Jw9xMBi0fbPVUtQFxREs96
         adPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F99WCI455FQ9yLpRrO5kIrSFWi87ma7VQ3wbenSp+wo=;
        b=mnDXQn9mnOeqDoGaO73zqZztsKYiS2WkCUqKXM+aq1vEzPBCER2x4Rg2dUBgPKUemT
         OwK8Yo8WlUarohmKMo/TevR/jeg5UWUzcUhSJJUWjGnYFSuosV5DKqafH3iOUGOjFYyN
         F4gTMbHMgfLYPKIomIN+gROXPb/AuaRMEKWA8b/M9aX6Tyg02tBGvIzXHUS6ZwszFKZ8
         mtJf2pLAZpoD5MVPSb3zhDnBnx0uKrJStBcYelFkwxsy23KAuFaOZiLYuGjO9spiwHnp
         2YhaHKcUCH+l6ER+hqTQuoTNbybufLm649ee43DQE0v1Mp5wpsg01QvlGVUyydDLjEEV
         G9tg==
X-Gm-Message-State: AOAM531QVIcstOvkK8tcJLRYs4Z3mQENR2BznI/mXddJePQ6nahh2XkM
        DLcLk3VVqWvqTsLSbfELojrA96qFjWb1T1q5zgUiig==
X-Google-Smtp-Source: ABdhPJy6Z9CLzEIpGNBHyJyy/bkpIl7+3sQuG11i8+64p50J3LXAFO+xc0UHgVSIBT/pVUiXhGgnwWOg56X5Q2kzijo=
X-Received: by 2002:ac2:558d:: with SMTP id v13mr8363685lfg.190.1638395223614;
 Wed, 01 Dec 2021 13:47:03 -0800 (PST)
MIME-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com> <YaDrmNVsXSMXR72Z@xz-m1.local>
 <CALzav=c7Px_X-MvoRixs=yy7wW4GdhavOAD=ZfHKy+n+Kih+bQ@mail.gmail.com> <Yab1vgF6ls5KFkVk@xz-m1.local>
In-Reply-To: <Yab1vgF6ls5KFkVk@xz-m1.local>
From:   David Matlack <dmatlack@google.com>
Date:   Wed, 1 Dec 2021 13:46:37 -0800
Message-ID: <CALzav=cJO1FuP9KFq8WqnEBy=30s1Q6v90ais3eQnzHKHupsNg@mail.gmail.com>
Subject: Re: [RFC PATCH 00/15] KVM: x86/mmu: Eager Page Splitting for the TDP MMU
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
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
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 30, 2021 at 8:10 PM Peter Xu <peterx@redhat.com> wrote:
>
> On Tue, Nov 30, 2021 at 03:22:29PM -0800, David Matlack wrote:
> > On Fri, Nov 26, 2021 at 6:13 AM Peter Xu <peterx@redhat.com> wrote:
> > >
> > > Hi, David,
> > >
> > > On Fri, Nov 19, 2021 at 11:57:44PM +0000, David Matlack wrote:
> > > > This series is a first pass at implementing Eager Page Splitting for the
> > > > TDP MMU. For context on the motivation and design of Eager Page
> > > > Splitting, please see the RFC design proposal and discussion [1].
> > > >
> > > > Paolo, I went ahead and added splitting in both the intially-all-set
> > > > case (only splitting the region passed to CLEAR_DIRTY_LOG) and the
> > > > case where we are not using initially-all-set (splitting the entire
> > > > memslot when dirty logging is enabled) to give you an idea of what
> > > > both look like.
> > > >
> > > > Note: I will be on vacation all of next week so I will not be able to
> > > > respond to reviews until Monday November 29. I thought it would be
> > > > useful to seed discussion and reviews with an early version of the code
> > > > rather than putting it off another week. But feel free to also ignore
> > > > this until I get back :)
> > > >
> > > > This series compiles and passes the most basic splitting test:
> > > >
> > > > $ ./dirty_log_perf_test -s anonymous_hugetlb_2mb -v 2 -i 4
> > > >
> > > > But please operate under the assumption that this code is probably
> > > > buggy.
> > > >
> > > > [1] https://lore.kernel.org/kvm/CALzav=dV_U4r1K9oDq4esb4mpBQDQ2ROQ5zH5wV3KpOaZrRW-A@mail.gmail.com/#t
> > >
> > > Will there be more numbers to show in the formal patchset?
> >
> > Yes definitely. I didn't have a lot of time to test this series, hence
> > the RFC status. I'll include more thorough testing and performance
> > evaluation in the cover letter for v1.
> >
> >
> > > It's interesting to
> > > know how "First Pass Dirty Memory Time" will change comparing to the rfc
> > > numbers; I can have a feel of it, but still. :) Also, not only how it speedup
> > > guest dirty apps, but also some general measurement on how it slows down
> > > KVM_SET_USER_MEMORY_REGION (!init-all-set) or CLEAR_LOG (init-all-set) would be
> > > even nicer (for CLEAR, I guess the 1st/2nd+ round will have different overhead).
> > >
> > > Besides that, I'm also wondering whether we should still have a knob for it, as
> > > I'm wondering what if the use case is the kind where eager split huge page may
> > > not help at all.  What I'm thinking:
> > >
> > >   - Read-mostly guest overload; split huge page will speed up rare writes, but
> > >     at the meantime drag readers down due to huge->small page mappings.
> > >
> > >   - Writes-over-very-limited-region workload: say we have 1T guest and the app
> > >     in the guest only writes 10G part of it.  Hmm not sure whether it exists..
> > >
> > >   - Postcopy targeted: it means precopy may only run a few iterations just to
> > >     send the static pages, so the migration duration will be relatively short,
> > >     and the write just didn't spread a lot to the whole guest mem.
> > >
> > > I don't really think any of the example is strong enough as they're all very
> > > corner cased, but just to show what I meant to raise this question on whether
> > > unconditionally eager split is the best approach.
> >
> > I'd be happy to add a knob if there's a userspace that wants to use
> > it. I think the main challenge though is knowing when it is safe to
> > disable eager splitting.
>
> Isn't it a performance feature?  Why it'll be not safe?

Heh, "safe" is a bit overzealous. But we've found that as the vCPU
count scales in VMs, not doing Eager Page Splitting leads to
unacceptable performance degradations (per customers), especially when
using the shadow MMU where hugepage write-protection faults are done
while holding the MMU lock in write mode. So from that perspective,
it's "unsafe" to skip Eager Page Splitting unless you are absolutely
sure the guest workload will not be doing much writes.

>
> > For a small deployment where you know the VM workload, it might make
> > sense. But for a public cloud provider the only feasible way would be to
> > dynamically monitor the guest writing patterns. But then we're back at square
> > one because that would require dirty logging. And even then, there's no
> > guaranteed way to predict future guest write patterns based on past patterns.
>
> Agreed, what I was thinking was not for public cloud usages, but for the cases
> where we can do specific tunings on some specific scenarios.  It normally won't
> matter a lot with small or medium sized VMs but extreme use cases.

Ack. I'll include a module parameter in v1 like you suggested your other email.

>
> >
> > The way forward here might be to do a hybrid of 2M and 4K dirty
> > tracking (and maybe even 1G). For example, first start dirty logging
> > at 2M granularity, and then log at 4K for any specific regions or
> > memslots that aren't making progress. We'd still use Eager Page
> > Splitting unconditionally though, first to split to 2M and then to
> > split to 4K.
>
> Do you mean we'd also offer different granule dirty bitmap to the userspace
> too?

Perhaps. The 2M dirty tracking work is still in very early research
phases and the first version will likely not be so dynamic. But I
could imagine we eventually get to the point where we are doing some
hybrid approach.

>
> I remembered you mentioned 2mb dirty tracking in your rfc series, but I didn't
> expect it can be dynamically switched during tracking.  That sounds a very
> intersting idea.
>
> Thanks,

Thanks for all the reviews and feedback on this series!

>
> --
> Peter Xu
>
