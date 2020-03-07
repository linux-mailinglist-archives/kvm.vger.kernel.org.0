Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0643017CFD2
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2020 20:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgCGTSf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Mar 2020 14:18:35 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55808 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgCGTSf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Mar 2020 14:18:35 -0500
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jAexz-0007je-8N; Sat, 07 Mar 2020 20:18:31 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id A78DF104088; Sat,  7 Mar 2020 20:18:30 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Andy Lutomirski <luto@kernel.org>,
        Andy Lutomirski <luto@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [patch 2/2] x86/kvm: Sanitize kvm_async_pf_task_wait()
In-Reply-To: <CALCETrX4p+++nS6N_yW2CnvMGUxngQBua65x9A9T-PB740LY0A@mail.gmail.com>
References: <20200306234204.847674001@linutronix.de> <20200307000259.448059232@linutronix.de> <CALCETrV74siTTHHWRPv+Gz=YS3SAUA6eqB6FX1XaHKvZDCbaNg@mail.gmail.com> <87r1y4a3gw.fsf@nanos.tec.linutronix.de> <CALCETrWc0wM1x-mAcKCPRUiGtzONtXiNVMFgWZwkRD3v3K3jsA@mail.gmail.com> <CALCETrX4p+++nS6N_yW2CnvMGUxngQBua65x9A9T-PB740LY0A@mail.gmail.com>
Date:   Sat, 07 Mar 2020 20:18:30 +0100
Message-ID: <875zfg9do9.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Andy Lutomirski <luto@kernel.org> writes:
> On Sat, Mar 7, 2020 at 7:10 AM Andy Lutomirski <luto@kernel.org> wrote:
>> On Sat, Mar 7, 2020 at 2:01 AM Thomas Gleixner <tglx@linutronix.de> wrote:
>> >
>> > Andy Lutomirski <luto@kernel.org> writes:
>
>> Now I'm confused again.  Your patch is very careful not to schedule if
>> we're in an RCU read-side critical section, but the regular preemption
>> code (preempt_schedule_irq, etc) seems to be willing to schedule
>> inside an RCU read-side critical section.  Why is the latter okay but
>> not the async pf case?
>
> I read more docs.  I guess the relevant situation is
> CONFIG_PREEMPT_CPU, in which case it is legal to preempt an RCU
> read-side critical section and obviously legal to put the whole CPU to
> sleep, but it's illegal to explicitly block in an RCU read-side
> critical section.  So I have a question for Paul: is it, in fact,
> entirely illegal to block or merely illegal to block for an
> excessively long time, e.g. waiting for user space or network traffic?

Two issues here:

    - excessive blocking time

    - entering idle with an RCU read side critical section blocking

>  In this situation, we cannot make progress until the host says we
> can, so we are, in effect, blocking until the host tells us to stop
> blocking.  Regardless, I agree that turning IRQs on is reasonable, and
> allowing those IRQs to preempt us is reasonable.
>
> As it stands in your patch, the situation is rather odd: we'll run
> another task if that task *preempts* us (e.g. we block long enough to
> run out of our time slice), but we won't run another task if we aren't
> preempted.  This seems bizarre.

Yes, it looks odd. We could do:

	preempt_disable();
	while (!page_arrived()) {
		if (preempt_count() == 1 && this_cpu_runnable_tasks() > 1) {
        		set_need_resched();
                	schedule_preempt_disabled();
		} else {
                	native_safe_halt();
                        local_irq_disable();
		}
	}
        preempt_enable();

Don't know if it's worth the trouble. But that's not the problem :)

> I think this issue still stands and is actually a fairly easy race to hit.
>
> STI
> IRQ happens and we get preempted
> another task runs and gets the #PF "async pf wakeup" event
> reschedule, back to original task
> HLT

See the other mail about STI :)

Thanks,

        tglx
