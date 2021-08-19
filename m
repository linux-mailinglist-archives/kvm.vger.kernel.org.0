Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 374AD3F1F90
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 20:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234203AbhHSSKB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 14:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233792AbhHSSKA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 14:10:00 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98419C061575
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 11:09:23 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id c12so12962505ljr.5
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 11:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bEMB1Q5NQtib4dp2A3rSJpdFteku51IMyIPfFwOsVy0=;
        b=TKbmxJP0kOpGwb0HC+2kh96zFUWxVb9QavRBB0jneDrNJEuzYTmLXdZAzBnf9VPQkm
         5xFJVLByHaXMV3PhyWVie4JP5UkK4NHUxRHMq3a1fKwYbx5XAXj+cZSdOpGtCZ9ekyHn
         BqM9Kn4Yqwiq6SXHsvoIj7RyGI2ZbNsWqjRMnaYtosqSafuAPhwZgkQTrc6qpJvGTQc3
         K9X4tct6gR5fvwN6h28h9gOVx187ZQGC/mqf4kUhf/LxB08kKlUCs6jwcYoYkmsgNmXK
         JnD9qea4nYREI/pCLjOPI0mXPtXCPSCKPZ6ePRE+O1Pa1DNmeAn7iaWop6dTxyzYF7pq
         /quQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bEMB1Q5NQtib4dp2A3rSJpdFteku51IMyIPfFwOsVy0=;
        b=mWr80AwTy4f+AV1qZu389hlaZflOdZexdKB5GAe8rdNg1anQR0Lk5Ofi6knIDWTWJK
         4YzUXIrvtvUpUdnILVhlKzrBfkkFXWJ5WsYb8++qWtkrT9WgekguedIFelvGBZF2JFpu
         LktTvkGYz1ypQg9hryyM7PpaKgCrx1x8ZNb5keJsx1MX29PhToysMxXuhdTz4iJsejh+
         bKpejj8SHnbg7kJpHXBuM/+V/ueUt+JFRwj5u7UOSZGxEhQmf+xr57e6OmB1/hvZJZEi
         sD+N+Op8w7U4UlpRJnAexHkZtPdguob1+cfjZenc+rwkLFgQn2QpPHm1JH7FpShNYwu1
         eNjA==
X-Gm-Message-State: AOAM533KoaCPXbNvmHLWYey2BIfr1Ga0anvlhBXrn4x+EIpd7fupjoFy
        JWq259IdLIsd6L0/QF4pdgwKmBtP45HncdWCFm/mmQ==
X-Google-Smtp-Source: ABdhPJxWODcn5Gn+KrODp16TqHPaHJeB/wYw2Z4kfBfCkLtsROVvXJc6PWJPVJFERsusokZhmG195+H9AXtYtzJ+Bc4=
X-Received: by 2002:a2e:a7d4:: with SMTP id x20mr13340972ljp.394.1629396561480;
 Thu, 19 Aug 2021 11:09:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210817230508.142907-1-jingzhangos@google.com>
 <YRxKZXm68FZ0jr34@google.com> <CAAdAUthw0gT2_K+WzkWeEHApGqM14qpH+kuoO6WZBnjvez6ZAg@mail.gmail.com>
 <CAJfu=UcwHWzqCvTjniAMkGj1mmjw9QCy5a-fGJ2mxTK8EFW7Dg@mail.gmail.com>
In-Reply-To: <CAJfu=UcwHWzqCvTjniAMkGj1mmjw9QCy5a-fGJ2mxTK8EFW7Dg@mail.gmail.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Thu, 19 Aug 2021 11:09:10 -0700
Message-ID: <CAAdAUtgcxZXWnqd6XNW7P=SwRQtGm11vrS9-T7rSOVc4xnySyQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: stats: add stats to detect if vcpu is currently halted
To:     Cannon Matthews <cannonmatthews@google.com>
Cc:     Sean Christopherson <seanjc@google.com>, KVM <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On Wed, Aug 18, 2021 at 10:01 AM Cannon Matthews
<cannonmatthews@google.com> wrote:
>
> +1 to the rephrasing of the commit message.
>
> On Wed, Aug 18, 2021 at 11:09 AM Jing Zhang <jingzhangos@google.com> wrote:
> >
> > Hi Sean,
> >
> > On Tue, Aug 17, 2021 at 4:46 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Tue, Aug 17, 2021, Jing Zhang wrote:
> > > > Current guest/host/halt stats don't show when we are currently halting
> > >
> > > s/we are/KVM is
> > >
> > > And I would probably reword it to "when KVM is blocking a vCPU in response to
> > > the vCPU activity state, e.g. halt".  More on that below.
> > >
> > > > well. If a guest halts for a long period of time they could appear
> > > > pathologically blocked but really it's the opposite there's nothing to
> > > > do.
> > > > Simply count the number of times we enter and leave the kvm_vcpu_block
> > >
> > > s/we/KVM
> > >
> > > In general, it's good practice to avoid pronouns in comments and changelogs as
> > > doing so all but forces using precise, unambiguous language.  Things like 'it'
> > > and 'they' are ok when it's abundantly clear what they refer to, but 'we' and 'us'
> > > are best avoided entirely.
> > >
> > > > function per vcpu, if they are unequal, then a VCPU is currently
> > > > halting.
> > > > The existing stats like halt_exits and halt_wakeups don't quite capture
> > > > this. The time spend halted and halt polling is reported eventually, but
> > > > not until we wakeup and resume. If a guest were to indefinitely halt one
> > > > of it's CPUs we would never know, it may simply appear blocked.
> > >      ^^^^      ^^
> > >      its       userspace?
> > >
> > >
> > > The "blocked" terminology is a bit confusing since KVM is explicitly blocking
> > > the vCPU, it just happens to mostly do so in response to a guest HLT.  I think
> > > "block" is intended to mean "vCPU task not run", but it would be helpful to make
> > > that clear.
> > >
> > That's a good point. Will reword the comments as you suggested.
> > > > Original-by: Cannon Matthews <cannonmatthews@google.com>
> > > > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > > > ---
> > > >  include/linux/kvm_host.h  | 4 +++-
> > > >  include/linux/kvm_types.h | 2 ++
> > > >  virt/kvm/kvm_main.c       | 2 ++
> > > >  3 files changed, 7 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > > index d447b21cdd73..23d2e19af3ce 100644
> > > > --- a/include/linux/kvm_host.h
> > > > +++ b/include/linux/kvm_host.h
> > > > @@ -1459,7 +1459,9 @@ struct _kvm_stats_desc {
> > > >       STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_hist,        \
> > > >                       HALT_POLL_HIST_COUNT),                                 \
> > > >       STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_wait_hist,             \
> > > > -                     HALT_POLL_HIST_COUNT)
> > > > +                     HALT_POLL_HIST_COUNT),                                 \
> > > > +     STATS_DESC_COUNTER(VCPU_GENERIC, halt_block_starts),                   \
> > > > +     STATS_DESC_COUNTER(VCPU_GENERIC, halt_block_ends)
> > >
> > > Why two counters?  It's per-vCPU, can't this just be a "blocked" flag or so?  I
> > > get that all the other stats use "halt", but that's technically wrong as KVM will
> > > block vCPUs that are not runnable for other reason, e.g. because they're in WFS
> > > on x86.
>
> The point is to separate "blocked because not runable" and "guest
> explicitly asked to do nothing"
>
> IIRC I originally wrote this patch to help discriminate how we spent
> VCPU thread time,
> in particular into two categories of essentially  "doing useful work
> on behalf of the guest" and
> "blocked from doing useful work."
>
> Since a guest has explictly asked for a vcpu to HLT, this is "useful
> work on behalf of the guest"
> even though the thread is "blocked" from running.
>
> This allows answering questions like, are we spending too much time
> waiting on mutexes, or
> long running kernel routines rather than running the vcpu in guest
> mode, or did the guest explictly
> tell us to not doing anything.
>
> So I would suggest keeping the "halt" part of the counters' name, and
> remove the "blocked" part
> rather than the other way around. We explicitly do not want to include
> non-halt blockages in this.
>
> That being said I suppose a boolean could work as well. I think we did
> this because it worked with
> and mirrored existing stats rather than anything particularly nuanced.
> Though there might be some
> eventual consistency sort of concerns with how these stats are updated
> and exported that could make
> monotonic increasing counters more useful.
Any more comments on the naming and the increasing counters?
>
> > The two counters are used to determine the reason why vCPU is not
> > running. If the halt_block_ends is one less than halt_block_starts,
> > then we know the vCPU is explicitly blocked by KVM. Otherwise, we know
> > there might be something wrong with the vCPU. Does this make sense?
> > Will rename from "halt_block_*" to "vcpu_block_*".
> >
> > Thanks,
> > Jing
