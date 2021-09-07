Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA14402E3B
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 20:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343833AbhIGSPU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 14:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244207AbhIGSPU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 14:15:20 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DAD1C061575
        for <kvm@vger.kernel.org>; Tue,  7 Sep 2021 11:14:13 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id y6so24321lje.2
        for <kvm@vger.kernel.org>; Tue, 07 Sep 2021 11:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=22psKZppfuCAffbrjrbw25DXVA7uHKusFcTh62wjOrA=;
        b=ZsPluqlohe8YzCmrUxmZMF/+jjRmjT5KYoRJs1opsmNsf3Bp4ae3ForwixHWgEgCeY
         5Y8I9R0Cz5x2Xma89hhMFvqu6DQxARrBceZRsr3XFr/WM5wtjuJoW0GHaFhNzAXwFhhI
         S1EkHrF5JrPEWMWAGZjUnkxdYtLDIUE7KMwMyn4xYU4QeBH/t8iIaHdO2kpHUqQE7RbN
         RL8K3WMYRyk4pFWxhzkrYv3BNPmMYdweSvLfB9g+HYjS108Vu9oxTz0gG+Iszdc9QpNp
         o7ntk257yaGK+2j+yToa9OxS2zAfN7wH4SwuVmKDeGT+RLp6l+BxSBfGS7/9x8i9T/P6
         V4bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=22psKZppfuCAffbrjrbw25DXVA7uHKusFcTh62wjOrA=;
        b=QkXL0HlBMl5WZbda0MUnletUiboyr+h9iyXH8I0eVDLFb1+EqAK2+e4S81y2pfB3RH
         OyzotMlHwIH2J5QoGUkI7gD67KH2EaFZ52e3270+7jD7RbxMeqyjMCFTkSvyuqiJ3tX7
         i577/75C15PqjevAMnX9K0bi62FI1yfFwhMyaoAKBzJZuJXS8hhVzb50/NhBtW0LwAol
         rzERoAQ7zhmgKgN7sY2jTmhroo+380o89TA8fRI6afOF+BnjcW6Gxjq7YuQSkqrv0P/l
         pfA55odYNc5nh7Vu0sthRWgG2uD7Kx2f9C3leNTumrntcaKUxtIqDfT8/nx7bBfgBeK1
         nRFg==
X-Gm-Message-State: AOAM5306pp+YIVWfH59b5iSjtYeydSPp1DqbbNs7pYa3wN0I9mkwkW7w
        ysq27R7ZKmoYjRzsDsYvojW8XCyZE+BWDgwo6ZlL+w==
X-Google-Smtp-Source: ABdhPJxpRADUwGV2bBvnW+3ObzfFz4JybOlhXviFqaZUe/0MV2VIaZSPxY+osoNDQi1BW1Iz/9zAmiTORRFOB6YNqaQ=
X-Received: by 2002:a2e:154e:: with SMTP id 14mr16249321ljv.374.1631038451111;
 Tue, 07 Sep 2021 11:14:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210819223640.3564975-1-oupton@google.com> <87ilzecbkj.wl-maz@kernel.org>
 <CAOQ_QsgOtufyB6_qGAs4fQf6kd81FSMSj44uiVRgoFQWOf3nRA@mail.gmail.com> <87a6kocmcx.wl-maz@kernel.org>
In-Reply-To: <87a6kocmcx.wl-maz@kernel.org>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 7 Sep 2021 13:14:00 -0500
Message-ID: <CAOQ_QshZe8ay03XqCo4DkM6zUaOuEoS5bRbrOy+FsuXaJ=YyKA@mail.gmail.com>
Subject: Re: [PATCH 0/6] KVM: arm64: Implement PSCI SYSTEM_SUSPEND support
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 7, 2021 at 12:43 PM Marc Zyngier <maz@kernel.org> wrote:
> > > Although the definition of SYSTEM_SUSPEND is very simple from a PSCI
> > > perspective, I don't think it is that simple at the system level,
> > > because PSCI is only concerned with the CPU.
> > >
> > > For example, what is a wake-up event? My first approach would be to
> > > consider interrupts to be such events. However, this approach suffers
> > > from at least two issues:
> > >
> > > - How do you define which interrupts are actual wake-up events?
> > >   Nothing in the GIC architecture defines what a wake-up is (let alone
> > >   a wake-up event).
> >
> > Good point.
> >
> > One possible implementation of suspend could just be a `WFI` in a
> > higher EL. In this case, KVM could emulate WFI wake up events
> > according to D1.16.2 in DDI 0487G.a. But I agree, it isn't entirely
> > clear what constitutes a wakeup from powered down state.
>
> It isn't, and it is actually IMPDEF (there isn't much in the ARM ARM
> in terms of what constitutes a low power state). And even if you
> wanted to emulate a WFI in userspace, the problem of interrupts that
> have their source in the kernel remains. How to you tell userspace
> that such an event has occurred if the vcpu thread isn't in the
> kernel?

Well, are there any objections to saying for the KVM implementation we
observe the WFI wake-up events per the cited section of the ARM ARM?

> > > It looks to me that your implementation can only work with userspace
> > > provided events, which is pretty limited.
> >
> > Right. I implemented this from the mindset that userspace may do
> > something heavyweight when a guest suspends, like save it to a
> > persistent store to resume later on. No matter what we do in KVM, I
> > think it's probably best to give userspace the right of first refusal
> > to handle the suspension.
>
> Maybe. But if you want to handle wake-up from interrupts to actually
> work, you must return to the kernel for the wake-up to occurs.
>
> The problem is that you piggyback on an existing feature (suspend) to
> implement something else (opportunistic save/restore?). Oddly enough
> the stars don't exactly align! ;-)
>
> I have the feeling that a solution to this problem would be to exit to
> userspace with something indicating an *intent* to suspend. At this
> stage, userspace can do two things:
>
> - resume the guest: the guest may have been moved to some other
>   machine, cold storage, whatever... The important thing is that the
>   guest is directly runnable without any extra event
>
> - confirm the suspension by returning to the kernel, which will
>   execute a blocking WFI on behalf of the guest
>
> With this, you end-up with something that is works from an interrupt
> perspective (even for directly injected interrupts), and you can save
> your guest on suspend.

This is exactly what I was trying to get at with my last mail,
although not quite as eloquently stated. So I completely agree.

Just to check understanding for v2:

We agree that an exit to userspace is fine so it has the opportunity
to do something crazy when the guest attempts a suspend. If a VMM does
nothing and immediately re-enters the kernel, we emulate the suspend
there by waiting for some event to fire, which for our purposes we
will say is an interrupt originating from userspace or the kernel
(WFI). In all, the SUSPEND exit type does not indicate that emulation
terminates with the VMM. It only indicates we are about to block in
the kernel.

If there is some IMPDEF event specific to the VMM, it should signal
the vCPU thread to kick it out of the kernel, make it runnable, and
re-enter. No need to do anything special from the kernel perspective
for this. This is only for the case where we decide to block in the
kernel.

>
> >
> > > Other items worth considering: ongoing DMA, state of the caches at
> > > suspend time, device state in general All of this really needs to be
> > > defined before we can move forward with this feature.
> >
> > I believe it is largely up to the caller to get devices in a quiesced
> > state appropriate for a system suspend, but PSCI is delightfully vague
> > on this topic.
>
> Indeed, it only deals with the CPU. Oh look, another opportunity to
> write a new spec! :)
>
> > On the contrary, it is up to KVM's implementation to
> > guarantee caches are clean when servicing the guest request.
>
> This last point is pretty unclear to me. If the guest doesn't clean to
> the PoC (or even to one of the PoPs) when it calls into suspend,
> that's a clear indication that it doesn't care about its data. Why
> should KVM be more conservative here? It shouldn't be in the business
> of working around guest bugs.

PSCI is vague on this, sadly. DEN0022D.b, 5.4.8 "Implementation
responsibilities: Cache and coherency management states" that for
CPU_SUSPEND, the PSCI implementation must perform a cache clean
operation before entering the powerdown state. I don't see any reason
why SYSTEM_SUSPEND should be excluded from this requirement.

--
Thanks,
Oliver
