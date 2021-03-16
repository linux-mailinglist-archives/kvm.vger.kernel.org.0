Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD24533D556
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 15:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235762AbhCPOCY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 10:02:24 -0400
Received: from lizzard.sbs.de ([194.138.37.39]:39484 "EHLO lizzard.sbs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235165AbhCPOBq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 10:01:46 -0400
Received: from mail2.sbs.de (mail2.sbs.de [192.129.41.66])
        by lizzard.sbs.de (8.15.2/8.15.2) with ESMTPS id 12GE1CIs004062
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 15:01:13 +0100
Received: from [167.87.27.98] ([167.87.27.98])
        by mail2.sbs.de (8.15.2/8.15.2) with ESMTP id 12GDkBMq025353;
        Tue, 16 Mar 2021 14:46:11 +0100
Subject: Re: [PATCH 2/3] KVM: x86: guest debug: don't inject interrupts while
 single stepping
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Kieran Bingham <kbingham@kernel.org>,
        Jessica Yu <jeyu@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>
References: <20210315221020.661693-1-mlevitsk@redhat.com>
 <20210315221020.661693-3-mlevitsk@redhat.com> <YE/vtYYwMakERzTS@google.com>
 <1259724f-1bdb-6229-2772-3192f6d17a4a@siemens.com>
 <bede3450413a7c5e7e55b19a47c8f079edaa55a2.camel@redhat.com>
 <ca41fe98-0e5d-3b4c-8ed8-bdd7cd5bc60f@siemens.com>
 <71ae8b75c30fd0f87e760216ad310ddf72d31c7b.camel@redhat.com>
From:   Jan Kiszka <jan.kiszka@siemens.com>
Message-ID: <2a44c302-744e-2794-59f6-c921b895726d@siemens.com>
Date:   Tue, 16 Mar 2021 14:46:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <71ae8b75c30fd0f87e760216ad310ddf72d31c7b.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16.03.21 13:34, Maxim Levitsky wrote:
> On Tue, 2021-03-16 at 12:27 +0100, Jan Kiszka wrote:
>> On 16.03.21 11:59, Maxim Levitsky wrote:
>>> On Tue, 2021-03-16 at 10:16 +0100, Jan Kiszka wrote:
>>>> On 16.03.21 00:37, Sean Christopherson wrote:
>>>>> On Tue, Mar 16, 2021, Maxim Levitsky wrote:
>>>>>> This change greatly helps with two issues:
>>>>>>
>>>>>> * Resuming from a breakpoint is much more reliable.
>>>>>>
>>>>>>   When resuming execution from a breakpoint, with interrupts enabled, more often
>>>>>>   than not, KVM would inject an interrupt and make the CPU jump immediately to
>>>>>>   the interrupt handler and eventually return to the breakpoint, to trigger it
>>>>>>   again.
>>>>>>
>>>>>>   From the user point of view it looks like the CPU never executed a
>>>>>>   single instruction and in some cases that can even prevent forward progress,
>>>>>>   for example, when the breakpoint is placed by an automated script
>>>>>>   (e.g lx-symbols), which does something in response to the breakpoint and then
>>>>>>   continues the guest automatically.
>>>>>>   If the script execution takes enough time for another interrupt to arrive,
>>>>>>   the guest will be stuck on the same breakpoint RIP forever.
>>>>>>
>>>>>> * Normal single stepping is much more predictable, since it won't land the
>>>>>>   debugger into an interrupt handler, so it is much more usable.
>>>>>>
>>>>>>   (If entry to an interrupt handler is desired, the user can still place a
>>>>>>   breakpoint at it and resume the guest, which won't activate this workaround
>>>>>>   and let the gdb still stop at the interrupt handler)
>>>>>>
>>>>>> Since this change is only active when guest is debugged, it won't affect
>>>>>> KVM running normal 'production' VMs.
>>>>>>
>>>>>>
>>>>>> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
>>>>>> Tested-by: Stefano Garzarella <sgarzare@redhat.com>
>>>>>> ---
>>>>>>  arch/x86/kvm/x86.c | 6 ++++++
>>>>>>  1 file changed, 6 insertions(+)
>>>>>>
>>>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>>>>> index a9d95f90a0487..b75d990fcf12b 100644
>>>>>> --- a/arch/x86/kvm/x86.c
>>>>>> +++ b/arch/x86/kvm/x86.c
>>>>>> @@ -8458,6 +8458,12 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
>>>>>>  		can_inject = false;
>>>>>>  	}
>>>>>>  
>>>>>> +	/*
>>>>>> +	 * Don't inject interrupts while single stepping to make guest debug easier
>>>>>> +	 */
>>>>>> +	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
>>>>>> +		return;
>>>>>
>>>>> Is this something userspace can deal with?  E.g. disable IRQs and/or set NMI
>>>>> blocking at the start of single-stepping, unwind at the end?  Deviating this far
>>>>> from architectural behavior will end in tears at some point.
>>>>>
>>>>
>>>> Does this happen to address this suspicious workaround in the kernel?
>>>>
>>>>         /*
>>>>          * The kernel doesn't use TF single-step outside of:
>>>>          *
>>>>          *  - Kprobes, consumed through kprobe_debug_handler()
>>>>          *  - KGDB, consumed through notify_debug()
>>>>          *
>>>>          * So if we get here with DR_STEP set, something is wonky.
>>>>          *
>>>>          * A known way to trigger this is through QEMU's GDB stub,
>>>>          * which leaks #DB into the guest and causes IST recursion.
>>>>          */
>>>>         if (WARN_ON_ONCE(dr6 & DR_STEP))
>>>>                 regs->flags &= ~X86_EFLAGS_TF;
>>>>
>>>> (arch/x86/kernel/traps.c, exc_debug_kernel)
>>>>
>>>> I wonder why this got merged while no one fixed QEMU/KVM, for years? Oh,
>>>> yeah, question to myself as well, dancing around broken guest debugging
>>>> for a long time while trying to fix other issues...
>>>
>>> To be honest I didn't see that warning even once, but I can imagine KVM
>>> leaking #DB due to bugs in that code. That area historically didn't receive
>>> much attention since it can only be triggered by
>>> KVM_GET/SET_GUEST_DEBUG which isn't used in production.
>>
>> I've triggered it recently while debugging a guest, that's why I got
>> aware of the code path. Long ago, all this used to work (soft BPs,
>> single-stepping etc.)
>>
>>> The only issue that I on the other hand  did
>>> see which is mostly gdb fault is that it fails to remove a software breakpoint
>>> when resuming over it, if that breakpoint's python handler messes up 
>>> with gdb's symbols, which is what lx-symbols does.
>>>
>>> And that despite the fact that lx-symbol doesn't mess with the object
>>> (that is the kernel) where the breakpoint is defined.
>>>
>>> Just adding/removing one symbol file is enough to trigger this issue.
>>>
>>> Since lx-symbols already works this around when it reloads all symbols,
>>> I extended that workaround to happen also when loading/unloading 
>>> only a single symbol file.
>>
>> You have no issue with interactive debugging when NOT using gdb scripts
>> / lx-symbol?
> 
> To be honest I don't use guest debugging that much,
> so I probably missed some issues.
> 
> Now that I fixed lx-symbols though I'll probably use 
> guest debugging much more.
> I will keep an eye on any issues that I find.
> 
> The main push to fix lx-symbols actually came
> from me wanting to understand if there is something
> broken with KVM's guest debugging knowing that
> lx-symbols crashes the guest when module is loaded
> after lx-symbols was executed.
> 
> That lx-symbols related guest crash I traced to issue 
> with gdb as I explained, and the lack of blocking of the interrupts 
> on single step is not a bug but more a missing feature
> that should be implemented to make single step easier to use.

Again, this used to work fine. But maybe this patch can change the
picture by avoid that the unavoidable short TF leakage into the guest
escalates beyond the single instruction to step over.

> 
> Another issue which isn't a bug is that you can't place a software
> breakpoint if kernel is not loaded (since there is no code in memory)
> or if the kernel haven't done basic paging initialization 
> (since there is no paging yet to know where to place the breakpoint).
> Hardware breakpoints work for this fine though.
> 
> So in summary I haven't found any major issues with KVM's guest debug
> yet.
> 
> If I do notice issues with guest debug, I will try to isolate
> and debug them.
> For the issue that you mentioned, do you have a way to reproduce it?

I need to spend some time in factoring out a clean test setup, will come
back to you. I'm always pushing this to the back - and then grumble when
hitting it while debugging something urgent. Your patch is a nice reason
to do this systematically now.

Jan

-- 
Siemens AG, T RDA IOT
Corporate Competence Center Embedded Linux
