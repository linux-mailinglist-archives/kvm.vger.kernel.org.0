Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46EAE402CDC
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 18:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343611AbhIGQby (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 12:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238089AbhIGQbx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 12:31:53 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF9DC061575
        for <kvm@vger.kernel.org>; Tue,  7 Sep 2021 09:30:47 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id j12so17464743ljg.10
        for <kvm@vger.kernel.org>; Tue, 07 Sep 2021 09:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PU8BOGj/hM9faC7h3f2YNkNVZWgFRKQgS/a6ZHKLdP0=;
        b=B2YxoLE3yOMXCXdenJTEuuWIzJXeuBIjukYW+1FgkIzdC/FnXjtjch5h+mN6LvVYOB
         U2XV0GYWoYTNRiAL7Uub16Hi4yVECrWYB0QZh5sYZsbxX8Oi0dS7OeteWGw7+BM6Ejua
         l1xXnR4ylGsFA0jnPsQTo/eSdqJ7Tyr5R/a4jD0+o6npN59dCpV5dh+XF0jKKuY9+I+l
         s6BHDKwUs4H0eVS0MNYyLxJa4jd7lSzC5jzQQG5vkczSm1m2HBSH1/Iu9+++pP++ZYfv
         xzUIeCFGByeZvsjxaqe4g7+bAvYppIzaVt29gVjL1EnUSwinTq4J1mOb1IxBhmMLHm0/
         vYyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PU8BOGj/hM9faC7h3f2YNkNVZWgFRKQgS/a6ZHKLdP0=;
        b=THwoEJw+WpsIieNRwVBbydkv4f7699ICKNT+sibmLRlLcbDI4NmSrUI01LKdoOPhS1
         7hmREIvHAmgLEh3xcGgAry8fsSbnjCTFue3h/w9A7RLHcPTMOGbfE5kaGAYVDEbvjHNk
         frT3pozNdCXPF13q1QGF0FWbH/cbheEZEGl26F1L9AsqCuKp04UJgq+KC6fh/fXHGi9N
         HCxXsnzbZvj4iqrjhKluGSaGTfp3nZziAlhxYwYAsEVAZ+bMqhCGIXohtLBdPuyb5Zew
         klZG5/OmKuk6xBqqu/ZJQliXOv2QCDL/Ozfju/YwXNSP8/X3iO8eRrcRtdKY9NUh0LIM
         lMvQ==
X-Gm-Message-State: AOAM531vFW77117BSciUt5iOTh+w92fToz2bX1VA6jakswhAAnPrZqlQ
        2xbiQGFek+OJ4rOQ/KJDQycnhyQrSxTF04lS4Wovvg==
X-Google-Smtp-Source: ABdhPJycG+lO7/cDng39gVxRn2icxFL6m85mj0anFsna8tzXBF9o4oXgHaqU7jFLXMhCvBkT7i8rLYJz+o19Av0Vj4s=
X-Received: by 2002:a2e:a0c8:: with SMTP id f8mr8445691ljm.170.1631032244856;
 Tue, 07 Sep 2021 09:30:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210819223640.3564975-1-oupton@google.com> <87ilzecbkj.wl-maz@kernel.org>
In-Reply-To: <87ilzecbkj.wl-maz@kernel.org>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 7 Sep 2021 11:30:33 -0500
Message-ID: <CAOQ_QsgOtufyB6_qGAs4fQf6kd81FSMSj44uiVRgoFQWOf3nRA@mail.gmail.com>
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

On Mon, Sep 6, 2021 at 4:12 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Oliver,
>
> On Thu, 19 Aug 2021 23:36:34 +0100,
> Oliver Upton <oupton@google.com> wrote:
> >
> > Certain VMMs/operators may wish to give their guests the ability to
> > initiate a system suspend that could result in the VM being saved to
> > persistent storage to be resumed at a later time. The PSCI v1.0
> > specification describes an SMC, SYSTEM_SUSPEND, that allows a kernel to
> > request a system suspend. This call is optional for v1.0, and KVM
> > elected to not support the call in its v1.0 implementation.
> >
> > This series adds support for the SYSTEM_SUSPEND PSCI call to KVM/arm64.
> > Since this is a system-scoped event, KVM cannot quiesce the VM on its
> > own. We add a new system exit type in this series to clue in userspace
> > that a suspend was requested. Per the KVM_EXIT_SYSTEM_EVENT ABI, a VMM
> > that doesn't care about this event can simply resume the guest without
> > issue (we set up the calling vCPU to come out of reset correctly on next
> > KVM_RUN).
>
> More idle thoughts on this:
>
> Although the definition of SYSTEM_SUSPEND is very simple from a PSCI
> perspective, I don't think it is that simple at the system level,
> because PSCI is only concerned with the CPU.
>
> For example, what is a wake-up event? My first approach would be to
> consider interrupts to be such events. However, this approach suffers
> from at least two issues:
>
> - How do you define which interrupts are actual wake-up events?
>   Nothing in the GIC architecture defines what a wake-up is (let alone
>   a wake-up event).

Good point.

One possible implementation of suspend could just be a `WFI` in a
higher EL. In this case, KVM could emulate WFI wake up events
according to D1.16.2 in DDI 0487G.a. But I agree, it isn't entirely
clear what constitutes a wakeup from powered down state.

> - Assuming you have a way to express the above, how do you handle
>   wake-ups from interrupts that have their source in the kernel (such
>   as timers, irqfd sources)?

I think this could be handled, so long as we allow userspace to
indicate it has woken a vCPU. Depending on this, in the next KVM_RUN
we'd say:

- Some IMP DEF event occurred; I'm waking this CPU now
- I've either chosen to ignore the guest or will defer to KVM's
suspend implementation

> How do you cope with directly injected interrupts?

No expert on this, I'll need to do a bit more reading to give a good
answer here.

> It looks to me that your implementation can only work with userspace
> provided events, which is pretty limited.

Right. I implemented this from the mindset that userspace may do
something heavyweight when a guest suspends, like save it to a
persistent store to resume later on. No matter what we do in KVM, I
think it's probably best to give userspace the right of first refusal
to handle the suspension.

> Other items worth considering: ongoing DMA, state of the caches at
> suspend time, device state in general All of this really needs to be
> defined before we can move forward with this feature.

I believe it is largely up to the caller to get devices in a quiesced
state appropriate for a system suspend, but PSCI is delightfully vague
on this topic. On the contrary, it is up to KVM's implementation to
guarantee caches are clean when servicing the guest request.

I'll crank on this a bit more and see if I have more thoughts.

--
Thanks,
Oliver
