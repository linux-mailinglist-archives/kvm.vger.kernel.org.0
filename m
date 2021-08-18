Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF6873F09CC
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 19:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbhHRRCe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 13:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232344AbhHRRCd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 13:02:33 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7F7C0613CF
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 10:01:58 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id o15so2041858wmr.3
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 10:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ogBzypcUa1lTzda8tPWMYRgvwhOz6jdmlJy9fp/v4UY=;
        b=k0P4K6sqnCTe/kaKB5/P+ucvQZcXFK/2O5lgvKFmChlC+QbxR6GR14pO1G6EzqWN5i
         VIWRsv0Be68iS/jF9Blx08rps0eu1+Yjal7YvIuUtUxjA2o8Y8UC9ropxssEXNJd6JR2
         R9BDQg2oOn7qZRQaFEdJi4Pcch2H9JQJyY+2uw2HlG2PZ7SHn/d1ISVzKIPMcXkyKcTt
         uDAZULOzw4AcX6qH4O18xoFcxyvwSpYLdG7M1NkqjbanjL9bPWSuByZ28Pbadw3eQ8jC
         ivPAYOmeypeBCHxeGEAPli1Fe76/6iRK83PQEiGLfbEAK7rdVPxmNitHVW0zy0Z/Xh/2
         evJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ogBzypcUa1lTzda8tPWMYRgvwhOz6jdmlJy9fp/v4UY=;
        b=fYmZ1VoHmzHCGrXENFgM5Yjd2CnW7wFKkkVFzV+mGph2Y96RqL42Ur+VHZaKQZ/3Nk
         cHNaFzqxd6JpiaBg2UNGMBZ8+dUcfay7mdtNSo8vEApENjfFUAVUwFlU9qhPme3DUEMM
         LcQctszL1+lcVS8FRGy3T1V7RLEEW2JH5Vvq7CBanWPTSjhs16tJO1xyq3L0RktQVep9
         ZANpDJLPOOZphhCI1VKrWGUbh0VQOdptYsNyWHDwPdNDlBHTsBV+dzAkGFKVZ1HMYQpB
         MrwgHTU4M7p3J7PWd7PcbiynEtU11UO8Hey1+NmQ/iyX5wfhb106af4uwvVxHtBRQL+h
         Z9tQ==
X-Gm-Message-State: AOAM532yWpUc+Jzb+ndv6LFE8RMzzKvYlih5jEv2vw+3x8wjg1Y8kWr1
        T2Vo5bhL9ja9O4vCodNxr3BPr9oW/ICpCXuA728qmw==
X-Google-Smtp-Source: ABdhPJzLb+kYkQv5AfDCY188gkhGXH5aIeH473/dBXIckKFjAM5OFmtRnm6Usz/tzE7/+V8MGxYXZrISnaPkdnM3HUM=
X-Received: by 2002:a1c:a401:: with SMTP id n1mr9492800wme.74.1629306115059;
 Wed, 18 Aug 2021 10:01:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210817230508.142907-1-jingzhangos@google.com>
 <YRxKZXm68FZ0jr34@google.com> <CAAdAUthw0gT2_K+WzkWeEHApGqM14qpH+kuoO6WZBnjvez6ZAg@mail.gmail.com>
In-Reply-To: <CAAdAUthw0gT2_K+WzkWeEHApGqM14qpH+kuoO6WZBnjvez6ZAg@mail.gmail.com>
From:   Cannon Matthews <cannonmatthews@google.com>
Date:   Wed, 18 Aug 2021 12:01:43 -0500
Message-ID: <CAJfu=UcwHWzqCvTjniAMkGj1mmjw9QCy5a-fGJ2mxTK8EFW7Dg@mail.gmail.com>
Subject: Re: [PATCH] KVM: stats: add stats to detect if vcpu is currently halted
To:     Jing Zhang <jingzhangos@google.com>
Cc:     Sean Christopherson <seanjc@google.com>, KVM <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+1 to the rephrasing of the commit message.

On Wed, Aug 18, 2021 at 11:09 AM Jing Zhang <jingzhangos@google.com> wrote:
>
> Hi Sean,
>
> On Tue, Aug 17, 2021 at 4:46 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Tue, Aug 17, 2021, Jing Zhang wrote:
> > > Current guest/host/halt stats don't show when we are currently halting
> >
> > s/we are/KVM is
> >
> > And I would probably reword it to "when KVM is blocking a vCPU in response to
> > the vCPU activity state, e.g. halt".  More on that below.
> >
> > > well. If a guest halts for a long period of time they could appear
> > > pathologically blocked but really it's the opposite there's nothing to
> > > do.
> > > Simply count the number of times we enter and leave the kvm_vcpu_block
> >
> > s/we/KVM
> >
> > In general, it's good practice to avoid pronouns in comments and changelogs as
> > doing so all but forces using precise, unambiguous language.  Things like 'it'
> > and 'they' are ok when it's abundantly clear what they refer to, but 'we' and 'us'
> > are best avoided entirely.
> >
> > > function per vcpu, if they are unequal, then a VCPU is currently
> > > halting.
> > > The existing stats like halt_exits and halt_wakeups don't quite capture
> > > this. The time spend halted and halt polling is reported eventually, but
> > > not until we wakeup and resume. If a guest were to indefinitely halt one
> > > of it's CPUs we would never know, it may simply appear blocked.
> >      ^^^^      ^^
> >      its       userspace?
> >
> >
> > The "blocked" terminology is a bit confusing since KVM is explicitly blocking
> > the vCPU, it just happens to mostly do so in response to a guest HLT.  I think
> > "block" is intended to mean "vCPU task not run", but it would be helpful to make
> > that clear.
> >
> That's a good point. Will reword the comments as you suggested.
> > > Original-by: Cannon Matthews <cannonmatthews@google.com>
> > > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > > ---
> > >  include/linux/kvm_host.h  | 4 +++-
> > >  include/linux/kvm_types.h | 2 ++
> > >  virt/kvm/kvm_main.c       | 2 ++
> > >  3 files changed, 7 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > index d447b21cdd73..23d2e19af3ce 100644
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -1459,7 +1459,9 @@ struct _kvm_stats_desc {
> > >       STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_poll_fail_hist,        \
> > >                       HALT_POLL_HIST_COUNT),                                 \
> > >       STATS_DESC_LOGHIST_TIME_NSEC(VCPU_GENERIC, halt_wait_hist,             \
> > > -                     HALT_POLL_HIST_COUNT)
> > > +                     HALT_POLL_HIST_COUNT),                                 \
> > > +     STATS_DESC_COUNTER(VCPU_GENERIC, halt_block_starts),                   \
> > > +     STATS_DESC_COUNTER(VCPU_GENERIC, halt_block_ends)
> >
> > Why two counters?  It's per-vCPU, can't this just be a "blocked" flag or so?  I
> > get that all the other stats use "halt", but that's technically wrong as KVM will
> > block vCPUs that are not runnable for other reason, e.g. because they're in WFS
> > on x86.

The point is to separate "blocked because not runable" and "guest
explicitly asked to do nothing"

IIRC I originally wrote this patch to help discriminate how we spent
VCPU thread time,
in particular into two categories of essentially  "doing useful work
on behalf of the guest" and
"blocked from doing useful work."

Since a guest has explictly asked for a vcpu to HLT, this is "useful
work on behalf of the guest"
even though the thread is "blocked" from running.

This allows answering questions like, are we spending too much time
waiting on mutexes, or
long running kernel routines rather than running the vcpu in guest
mode, or did the guest explictly
tell us to not doing anything.

So I would suggest keeping the "halt" part of the counters' name, and
remove the "blocked" part
rather than the other way around. We explicitly do not want to include
non-halt blockages in this.

That being said I suppose a boolean could work as well. I think we did
this because it worked with
and mirrored existing stats rather than anything particularly nuanced.
Though there might be some
eventual consistency sort of concerns with how these stats are updated
and exported that could make
monotonic increasing counters more useful.

> The two counters are used to determine the reason why vCPU is not
> running. If the halt_block_ends is one less than halt_block_starts,
> then we know the vCPU is explicitly blocked by KVM. Otherwise, we know
> there might be something wrong with the vCPU. Does this make sense?
> Will rename from "halt_block_*" to "vcpu_block_*".
>
> Thanks,
> Jing
