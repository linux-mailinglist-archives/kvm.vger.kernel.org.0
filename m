Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2583A33ECF0
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 10:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhCQJ0U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 05:26:20 -0400
Received: from lizzard.sbs.de ([194.138.37.39]:45725 "EHLO lizzard.sbs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229751AbhCQJ0E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 05:26:04 -0400
Received: from mail2.sbs.de (mail2.sbs.de [192.129.41.66])
        by lizzard.sbs.de (8.15.2/8.15.2) with ESMTPS id 12H9PcBs027629
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Mar 2021 10:25:38 +0100
Received: from [167.87.41.130] ([167.87.41.130])
        by mail2.sbs.de (8.15.2/8.15.2) with ESMTP id 12H9KaQL031246;
        Wed, 17 Mar 2021 10:20:36 +0100
Subject: Re: [PATCH 2/3] KVM: x86: guest debug: don't inject interrupts while
 single stepping
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
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
References: <1259724f-1bdb-6229-2772-3192f6d17a4a@siemens.com>
 <bede3450413a7c5e7e55b19a47c8f079edaa55a2.camel@redhat.com>
 <ca41fe98-0e5d-3b4c-8ed8-bdd7cd5bc60f@siemens.com>
 <71ae8b75c30fd0f87e760216ad310ddf72d31c7b.camel@redhat.com>
 <2a44c302-744e-2794-59f6-c921b895726d@siemens.com>
 <1d27b215a488f8b8fc175e97c5ab973cc811922d.camel@redhat.com>
 <727e5ef1-f771-1301-88d6-d76f05540b01@siemens.com>
 <e2cd978e357155dbab21a523bb8981973bd10da7.camel@redhat.com>
 <CAMS+r+XFLsFRFLGLaAH3_EnBcxOmyN-XiZqcmKEx2utjNErYsQ@mail.gmail.com>
 <31c0bba9-0399-1f15-a59b-a8f035e366e8@siemens.com>
 <YFDqSisnoWD5wVdP@google.com>
From:   Jan Kiszka <jan.kiszka@siemens.com>
Message-ID: <d94f9c87-9609-4e7f-04d0-546d27671e51@siemens.com>
Date:   Wed, 17 Mar 2021 10:20:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <YFDqSisnoWD5wVdP@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16.03.21 18:26, Sean Christopherson wrote:
> On Tue, Mar 16, 2021, Jan Kiszka wrote:
>> On 16.03.21 17:50, Sean Christopherson wrote:
>>> Rather than block all events in KVM, what about having QEMU "pause" the timer?
>>> E.g. save MSR_TSC_DEADLINE and APIC_TMICT (or inspect the guest to find out
>>> which flavor it's using), clear them to zero, then restore both when
>>> single-stepping is disabled.  I think that will work?
>>>
>>
>> No one can stop the clock, and timers are only one source of interrupts.
>> Plus they do not all come from QEMU, some also from KVM or in-kernel
>> sources directly.
> 
> But are any other sources of interrupts a chronic problem?  I 100% agree that

If you are debugging a problem, you are not interested in seening
problems of the debugger, only real ones of your target. IOW: Yes, they
are, even if less likely - for idle VMs.

> this would not be a robust solution, but neither is blocking events in KVM.  At
> least with this approach, the blast radius is somewhat contained.
> 
>> Would quickly become a mess.
> 
> Maybe, but it'd be Qemu's mess ;-)
> 

Nope, it would spread to KVM as well, as indicated above.

Jan

-- 
Siemens AG, T RDA IOT
Corporate Competence Center Embedded Linux
