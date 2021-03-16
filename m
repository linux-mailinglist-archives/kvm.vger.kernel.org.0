Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42EAA33DA43
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 18:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239077AbhCPRHZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 13:07:25 -0400
Received: from gecko.sbs.de ([194.138.37.40]:34495 "EHLO gecko.sbs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239084AbhCPRHI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 13:07:08 -0400
Received: from mail2.sbs.de (mail2.sbs.de [192.129.41.66])
        by gecko.sbs.de (8.15.2/8.15.2) with ESMTPS id 12GH6dC0010712
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 18:06:39 +0100
Received: from [167.87.27.98] ([167.87.27.98])
        by mail2.sbs.de (8.15.2/8.15.2) with ESMTP id 12GH1al7023551;
        Tue, 16 Mar 2021 18:01:36 +0100
Subject: Re: [PATCH 2/3] KVM: x86: guest debug: don't inject interrupts while
 single stepping
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
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
References: <20210315221020.661693-3-mlevitsk@redhat.com>
 <YE/vtYYwMakERzTS@google.com>
 <1259724f-1bdb-6229-2772-3192f6d17a4a@siemens.com>
 <bede3450413a7c5e7e55b19a47c8f079edaa55a2.camel@redhat.com>
 <ca41fe98-0e5d-3b4c-8ed8-bdd7cd5bc60f@siemens.com>
 <71ae8b75c30fd0f87e760216ad310ddf72d31c7b.camel@redhat.com>
 <2a44c302-744e-2794-59f6-c921b895726d@siemens.com>
 <1d27b215a488f8b8fc175e97c5ab973cc811922d.camel@redhat.com>
 <727e5ef1-f771-1301-88d6-d76f05540b01@siemens.com>
 <e2cd978e357155dbab21a523bb8981973bd10da7.camel@redhat.com>
 <CAMS+r+XFLsFRFLGLaAH3_EnBcxOmyN-XiZqcmKEx2utjNErYsQ@mail.gmail.com>
From:   Jan Kiszka <jan.kiszka@siemens.com>
Message-ID: <31c0bba9-0399-1f15-a59b-a8f035e366e8@siemens.com>
Date:   Tue, 16 Mar 2021 18:01:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CAMS+r+XFLsFRFLGLaAH3_EnBcxOmyN-XiZqcmKEx2utjNErYsQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16.03.21 17:50, Sean Christopherson wrote:
> On Tue, Mar 16, 2021, Maxim Levitsky wrote:
>> On Tue, 2021-03-16 at 16:31 +0100, Jan Kiszka wrote:
>>> Back then, when I was hacking on the gdb-stub and KVM support, the
>>> monitor trap flag was not yet broadly available, but the idea to once
>>> use it was already there. Now it can be considered broadly available,
>>> but it would still require some changes to get it in.
>>>
>>> Unfortunately, we don't have such thing with SVM, even recent versions,
>>> right? So, a proper way of avoiding diverting event injections while we
>>> are having the guest in an "incorrect" state should definitely be the goal.
>> Yes, I am not aware of anything like monitor trap on SVM.
>>
>>>
>>> Given that KVM knows whether TF originates solely from guest debugging
>>> or was (also) injected by the guest, we should be able to identify the
>>> cases where your approach is best to apply. And that without any extra
>>> control knob that everyone will only forget to set.
>> Well I think that the downside of this patch is that the user might actually
>> want to single step into an interrupt handler, and this patch makes it a bit
>> more complicated, and changes the default behavior.
> 
> Yes.  And, as is, this also blocks NMIs and SMIs.  I suspect it also doesn't
> prevent weirdness if the guest is running in L2, since IRQs for L1 will cause
> exits from L2 during nested_ops->check_events().
> 
>> I have no objections though to use this patch as is, or at least make this
>> the new default with a new flag to override this.
> 
> That's less bad, but IMO still violates the principle of least surprise, e.g.
> someone that is single-stepping a guest and is expecting an IRQ to fire will be
> all kinds of confused if they see all the proper IRR, ISR, EFLAGS.IF, etc...
> settings, but no interrupt.

From my practical experience with debugging guests via single step,
seeing an interrupt in that case is everything but handy and generally
also not expected (though logical, I agree). IOW: When there is a knob
for it, it will remain off in 99% of the time.

But I see the point of having some control, in an ideal world also an
indication that there are pending events, permitting the user to decide
what to do. But I suspect the gdb frontend and protocol does not easily
permit that.

> 
>> Sean Christopherson, what do you think?
> 
> Rather than block all events in KVM, what about having QEMU "pause" the timer?
> E.g. save MSR_TSC_DEADLINE and APIC_TMICT (or inspect the guest to find out
> which flavor it's using), clear them to zero, then restore both when
> single-stepping is disabled.  I think that will work?
> 

No one can stop the clock, and timers are only one source of interrupts.
Plus they do not all come from QEMU, some also from KVM or in-kernel
sources directly. Would quickly become a mess.

Jan

-- 
Siemens AG, T RDA IOT
Corporate Competence Center Embedded Linux
