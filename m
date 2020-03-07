Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4149C17CF2C
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2020 16:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgCGPwW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 7 Mar 2020 10:52:22 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55636 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbgCGPwV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Mar 2020 10:52:21 -0500
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jAbkP-0006ge-Qx; Sat, 07 Mar 2020 16:52:17 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 37D92104088; Sat,  7 Mar 2020 16:52:17 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [patch 2/2] x86/kvm: Sanitize kvm_async_pf_task_wait()
In-Reply-To: <CALCETrWc0wM1x-mAcKCPRUiGtzONtXiNVMFgWZwkRD3v3K3jsA@mail.gmail.com>
References: <20200306234204.847674001@linutronix.de> <20200307000259.448059232@linutronix.de> <CALCETrV74siTTHHWRPv+Gz=YS3SAUA6eqB6FX1XaHKvZDCbaNg@mail.gmail.com> <87r1y4a3gw.fsf@nanos.tec.linutronix.de> <CALCETrWc0wM1x-mAcKCPRUiGtzONtXiNVMFgWZwkRD3v3K3jsA@mail.gmail.com>
Date:   Sat, 07 Mar 2020 16:52:17 +0100
Message-ID: <87d09o9n7y.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Andy Lutomirski <luto@kernel.org> writes:
> On Sat, Mar 7, 2020 at 2:01 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>> > What’s the local_irq_disable() here for? I would believe a
>> > lockdep_assert_irqs_disabled() somewhere in here would make sense.
>> > (Yes, I see you copied this from the old code. It’s still nonsense.)
>>
>> native_safe_halt() does:
>>
>>          STI
>>          HLT
>>
>> So the irq disable is required as the loop should exit with interrupts
>> disabled.
>
> Oops, should have looked at what native_safe_halt() does.
>
>>
>> > I also find it truly bizarre that hlt actually works in this context.
>> > Does KVM in fact wake a HLTed guest that HLTed with IRQs off when a
>> > pending async pf is satisfied?  This would make sense if the wake
>> > event were an interrupt, but it’s not according to Paolo.
>>
>> See above. safe halt enables interrupts, which means IF == 1 and the
>> host sanity check for IF == 1 is satisfied.
>>
>> In fact, if e.g. some regular interrupt arrives before the page becomes
>> available and the guest entered the halt loop because the fault happened
>> inside a RCU read side critical section with preemption enabled, then
>> the interrupt might wake up another task, set need resched and this
>> other task can run.
>
> Now I'm confused again.  Your patch is very careful not to schedule if
> we're in an RCU read-side critical section, but the regular preemption
> code (preempt_schedule_irq, etc) seems to be willing to schedule
> inside an RCU read-side critical section.  Why is the latter okay but
> not the async pf case?

Preemption is fine, but voluntary schedule not. voluntary schedule might
end up in idle if this is the last runnable task.

> Ignoring that, this still seems racy:
>
> STI
> nested #PF telling us to wake up
> #PF returns
> HLT

You will say Ooops, should have looked .... when I tell you that the
above cannot happen. From the SDM:

  If IF = 0, maskable hardware interrupts remain inhibited on the
  instruction boundary following an execution of STI.

Otherwise safe_halt would not work at all :)

> doesn't this result in putting the CPU asleep for no good reason until
> the next interrupt hits?

No :)

>
>> > All this being said, the only remotely sane case is when regs->flags
>> > has IF==1. Perhaps this code should actually do:
>> >
>> > WARN_ON(!(regs->flags & X86_EFLAGS_IF));
>>
>> Yes, that want's to be somewhere early and also cover the async wake
>> case. Neither wake nor wait can be injected when IF == 0.
>
> Sadly, wrmsr to turn off async pf will inject wakeups even if IF == 0.

WHAT? That's fundamentally broken. Can you point me to the code in
question?

Thanks,

        tglx


