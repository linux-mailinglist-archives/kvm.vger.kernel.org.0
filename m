Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63F3A17CEF0
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2020 16:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbgCGPLC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Mar 2020 10:11:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:48956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbgCGPLC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Mar 2020 10:11:02 -0500
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F5F7206D5
        for <kvm@vger.kernel.org>; Sat,  7 Mar 2020 15:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583593860;
        bh=6NdNS0GAHUDfvT4DtjAA+fDfKBLy7jzUedqlH8lqoYQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NUCnUlC/h2VWFBjTRzxiq9DJMLSiZiQtYB7g4vw40LUa6l1b4FGJzDSfsb+bkHSrA
         su+wv/PJdjLYNSnTai2BXNNtMiji59+mvLamFp9YJTd92uv8MGhdESm05B5bYfwExQ
         DTg1G/0YNjxnSuuIGYnGwxqe8CiMHslCTOdLmbA8=
Received: by mail-wm1-f51.google.com with SMTP id a25so11484977wmm.0
        for <kvm@vger.kernel.org>; Sat, 07 Mar 2020 07:11:00 -0800 (PST)
X-Gm-Message-State: ANhLgQ0OF7xoLcaM24xDoQniwrzPWRjCrZMaU5bOavaAbjTYlJsNI21N
        0sPIHCydyIMPNHVZxj1OCDrY2Y48gTt77IL/dlJRzw==
X-Google-Smtp-Source: ADFU+vufcAJjVQHbdpKJ/AKtOP092nZ3gCqnJW3XccZOJdjunHUTHNhXXH8lgIOGgbiH8MqBCcuCMLu0f5GPFIouTWM=
X-Received: by 2002:a7b:cbcf:: with SMTP id n15mr10106227wmi.21.1583593858853;
 Sat, 07 Mar 2020 07:10:58 -0800 (PST)
MIME-Version: 1.0
References: <20200306234204.847674001@linutronix.de> <20200307000259.448059232@linutronix.de>
 <CALCETrV74siTTHHWRPv+Gz=YS3SAUA6eqB6FX1XaHKvZDCbaNg@mail.gmail.com> <87r1y4a3gw.fsf@nanos.tec.linutronix.de>
In-Reply-To: <87r1y4a3gw.fsf@nanos.tec.linutronix.de>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sat, 7 Mar 2020 07:10:47 -0800
X-Gmail-Original-Message-ID: <CALCETrWc0wM1x-mAcKCPRUiGtzONtXiNVMFgWZwkRD3v3K3jsA@mail.gmail.com>
Message-ID: <CALCETrWc0wM1x-mAcKCPRUiGtzONtXiNVMFgWZwkRD3v3K3jsA@mail.gmail.com>
Subject: Re: [patch 2/2] x86/kvm: Sanitize kvm_async_pf_task_wait()
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Mar 7, 2020 at 2:01 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Andy Lutomirski <luto@kernel.org> writes:
> >> On Mar 6, 2020, at 4:12 PM, Thomas Gleixner <tglx@linutronix.de> wrote=
:
> >> Aside of that the actual code is a convoluted one fits it all swiss ar=
my
> >> knife. It is invoked from different places with different RCU constrai=
nts:
> >>
> >> 1) Host side:
> >>
> >>   vcpu_enter_guest()
> >>     kvm_x86_ops->handle_exit()
> >>       kvm_handle_page_fault()
> >>         kvm_async_pf_task_wait()
> >>
> >>   The invocation happens from fully preemptible context.
> >
> > I=E2=80=99m a bit baffled as to why the host uses this code at all inst=
ead of
> > just sleeping the old fashioned way when the guest takes a (host) page
> > fault.  Oh well.
>
> If I can trust the crystal ball which I used to decode this maze then it
> actually makes sense.
>
> Aysnc faults are faults which cannot be handled by the guest, i.e. the
> host either pulled a page away under the guest or did not populate it in
> the first place.
>
> So the reasoning is that if this happens the guest might be in a
> situation where it can schedule other tasks instead of being stopped
> completely by the host until the page arrives.
>
> Now you could argue that this mostly makes sense for CPL 0 faults, but
> there is definitely code in the kernel where it makes sense as well,
> e.g. exec. But of course as this is designed without a proper handshake
> there is no way for the hypervisor to figure out whether it makes sense
> or not.
>
> If the async fault cannot be delivered to the guest (async PF disabled,
> async PF only enabled for CPL 0, IF =3D=3D 0) then the host utilizes the
> same data structure and wait mechanism. That really makes sense.
>
> The part which does not make sense in the current implementation is the
> kvm_async_pf_task_wait() trainwreck. A clear upfront separation of
> schedulable and non schedulable wait mechanisms would have avoided all
> the RCU duct tape nonsense and also spared me the brain damage caused by
> reverse engineering this completely undocumented mess.
>
> >> +static void kvm_async_pf_task_wait_halt(u32 token)
> >> +{
> >> +    struct kvm_task_sleep_node n;
> >> +
> >> +    if (!kvm_async_pf_queue_task(token, true, &n))
> >> +        return;
> >>
> >>  for (;;) {
> >> -        if (!n.halted)
> >> -            prepare_to_swait_exclusive(&n.wq, &wait, TASK_UNINTERRUPT=
IBLE);
> >>      if (hlist_unhashed(&n.link))
> >>          break;
> >> +        /*
> >> +         * No point in doing anything about RCU here. Any RCU read
> >> +         * side critical section or RCU watching section can be
> >> +         * interrupted by VMEXITs and the host is free to keep the
> >> +         * vCPU scheduled out as long as it sees fit. This is not
> >> +         * any different just because of the halt induced voluntary
> >> +         * VMEXIT.
> >> +         *
> >> +         * Also the async page fault could have interrupted any RCU
> >> +         * watching context, so invoking rcu_irq_exit()/enter()
> >> +         * around this is not gaining anything.
> >> +         */
> >> +        native_safe_halt();
> >> +        local_irq_disable();
> >
> > What=E2=80=99s the local_irq_disable() here for? I would believe a
> > lockdep_assert_irqs_disabled() somewhere in here would make sense.
> > (Yes, I see you copied this from the old code. It=E2=80=99s still nonse=
nse.)
>
> native_safe_halt() does:
>
>          STI
>          HLT
>
> So the irq disable is required as the loop should exit with interrupts
> disabled.

Oops, should have looked at what native_safe_halt() does.

>
> > I also find it truly bizarre that hlt actually works in this context.
> > Does KVM in fact wake a HLTed guest that HLTed with IRQs off when a
> > pending async pf is satisfied?  This would make sense if the wake
> > event were an interrupt, but it=E2=80=99s not according to Paolo.
>
> See above. safe halt enables interrupts, which means IF =3D=3D 1 and the
> host sanity check for IF =3D=3D 1 is satisfied.
>
> In fact, if e.g. some regular interrupt arrives before the page becomes
> available and the guest entered the halt loop because the fault happened
> inside a RCU read side critical section with preemption enabled, then
> the interrupt might wake up another task, set need resched and this
> other task can run.

Now I'm confused again.  Your patch is very careful not to schedule if
we're in an RCU read-side critical section, but the regular preemption
code (preempt_schedule_irq, etc) seems to be willing to schedule
inside an RCU read-side critical section.  Why is the latter okay but
not the async pf case?

Ignoring that, this still seems racy:

STI
nested #PF telling us to wake up
#PF returns
HLT

doesn't this result in putting the CPU asleep for no good reason until
the next interrupt hits?


> > All this being said, the only remotely sane case is when regs->flags
> > has IF=3D=3D1. Perhaps this code should actually do:
> >
> > WARN_ON(!(regs->flags & X86_EFLAGS_IF));
>
> Yes, that want's to be somewhere early and also cover the async wake
> case. Neither wake nor wait can be injected when IF =3D=3D 0.

Sadly, wrmsr to turn off async pf will inject wakeups even if IF =3D=3D 0.
