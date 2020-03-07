Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F41C017CD65
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2020 11:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgCGKBb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 7 Mar 2020 05:01:31 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55339 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbgCGKBa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Mar 2020 05:01:30 -0500
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jAWGr-0004yV-HQ; Sat, 07 Mar 2020 11:01:25 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 2BA96104088; Sat,  7 Mar 2020 11:01:19 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [patch 2/2] x86/kvm: Sanitize kvm_async_pf_task_wait()
In-Reply-To: <CALCETrV74siTTHHWRPv+Gz=YS3SAUA6eqB6FX1XaHKvZDCbaNg@mail.gmail.com>
References: <20200306234204.847674001@linutronix.de> <20200307000259.448059232@linutronix.de> <CALCETrV74siTTHHWRPv+Gz=YS3SAUA6eqB6FX1XaHKvZDCbaNg@mail.gmail.com>
Date:   Sat, 07 Mar 2020 11:01:19 +0100
Message-ID: <87r1y4a3gw.fsf@nanos.tec.linutronix.de>
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
>> On Mar 6, 2020, at 4:12 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> Aside of that the actual code is a convoluted one fits it all swiss army
>> knife. It is invoked from different places with different RCU constraints:
>>
>> 1) Host side:
>>
>>   vcpu_enter_guest()
>>     kvm_x86_ops->handle_exit()
>>       kvm_handle_page_fault()
>>         kvm_async_pf_task_wait()
>>
>>   The invocation happens from fully preemptible context.
>
> I’m a bit baffled as to why the host uses this code at all instead of
> just sleeping the old fashioned way when the guest takes a (host) page
> fault.  Oh well.

If I can trust the crystal ball which I used to decode this maze then it
actually makes sense.

Aysnc faults are faults which cannot be handled by the guest, i.e. the
host either pulled a page away under the guest or did not populate it in
the first place.

So the reasoning is that if this happens the guest might be in a
situation where it can schedule other tasks instead of being stopped
completely by the host until the page arrives.

Now you could argue that this mostly makes sense for CPL 0 faults, but
there is definitely code in the kernel where it makes sense as well,
e.g. exec. But of course as this is designed without a proper handshake
there is no way for the hypervisor to figure out whether it makes sense
or not.

If the async fault cannot be delivered to the guest (async PF disabled,
async PF only enabled for CPL 0, IF == 0) then the host utilizes the
same data structure and wait mechanism. That really makes sense.

The part which does not make sense in the current implementation is the
kvm_async_pf_task_wait() trainwreck. A clear upfront separation of
schedulable and non schedulable wait mechanisms would have avoided all
the RCU duct tape nonsense and also spared me the brain damage caused by
reverse engineering this completely undocumented mess.

>> +static void kvm_async_pf_task_wait_halt(u32 token)
>> +{
>> +    struct kvm_task_sleep_node n;
>> +
>> +    if (!kvm_async_pf_queue_task(token, true, &n))
>> +        return;
>>
>>  for (;;) {
>> -        if (!n.halted)
>> -            prepare_to_swait_exclusive(&n.wq, &wait, TASK_UNINTERRUPTIBLE);
>>      if (hlist_unhashed(&n.link))
>>          break;
>> +        /*
>> +         * No point in doing anything about RCU here. Any RCU read
>> +         * side critical section or RCU watching section can be
>> +         * interrupted by VMEXITs and the host is free to keep the
>> +         * vCPU scheduled out as long as it sees fit. This is not
>> +         * any different just because of the halt induced voluntary
>> +         * VMEXIT.
>> +         *
>> +         * Also the async page fault could have interrupted any RCU
>> +         * watching context, so invoking rcu_irq_exit()/enter()
>> +         * around this is not gaining anything.
>> +         */
>> +        native_safe_halt();
>> +        local_irq_disable();
>
> What’s the local_irq_disable() here for? I would believe a
> lockdep_assert_irqs_disabled() somewhere in here would make sense.
> (Yes, I see you copied this from the old code. It’s still nonsense.)

native_safe_halt() does:

         STI
         HLT

So the irq disable is required as the loop should exit with interrupts
disabled.

> I also find it truly bizarre that hlt actually works in this context.
> Does KVM in fact wake a HLTed guest that HLTed with IRQs off when a
> pending async pf is satisfied?  This would make sense if the wake
> event were an interrupt, but it’s not according to Paolo.

See above. safe halt enables interrupts, which means IF == 1 and the
host sanity check for IF == 1 is satisfied.

In fact, if e.g. some regular interrupt arrives before the page becomes
available and the guest entered the halt loop because the fault happened
inside a RCU read side critical section with preemption enabled, then
the interrupt might wake up another task, set need resched and this
other task can run. At some point the halt waiting task gets back into
the loop and either finds the page ready or goes back into halt.

If the fault hit a preempt disabled region then still the interrupt and
eventual resulting soft interrupts can be handled.

Both scenarios are correct when you actually manage to mentaly
disconnect regular #PF and async #PF completely.

Of course the overloading of regular #PF, the utter lack of
documentation and the crappy and duct taped implementation makes this
really a mind boggling exercise.

> All this being said, the only remotely sane case is when regs->flags
> has IF==1. Perhaps this code should actually do:
>
> WARN_ON(!(regs->flags & X86_EFLAGS_IF));

Yes, that want's to be somewhere early and also cover the async wake
case. Neither wake nor wait can be injected when IF == 0.

> while (the page isn’t ready) {
>  local_irq_enable();
>  native_safe_halt();
>  local_irq_disable();
> }
>
> with some provision to survive the case where the warning fires so we
> at least get logs.

I don't think that any attempt to survive a async #PF injection into a
interrupt disabled region makes sense aside of looking smart and being
uncomprehensible voodoo.

If this ever happens then the host side is completely buggered and all
we can do is warn and pray or warn and die hard.

My personal preference is to warn and die hard.

> In any event, I just sent a patch to disable async page faults that
> happen in kernel mode.

I don't think it's justified. The host side really makes sure that the
guest does have IF == 1 before injecting anything which is not a NMI. If
the guest enables interrupts at the wrong place then this is really not
the hosts problem.

Having a warning in that async pf entry for the IF == 0 injection case
is good enough IMO.

Thanks,

        tglx
