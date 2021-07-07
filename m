Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86C803BECA8
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 18:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbhGGRAx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 13:00:53 -0400
Received: from forward104j.mail.yandex.net ([5.45.198.247]:33239 "EHLO
        forward104j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230373AbhGGRAt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Jul 2021 13:00:49 -0400
Received: from forward103q.mail.yandex.net (forward103q.mail.yandex.net [IPv6:2a02:6b8:c0e:50:0:640:b21c:d009])
        by forward104j.mail.yandex.net (Yandex) with ESMTP id C003F4A2242;
        Wed,  7 Jul 2021 19:58:06 +0300 (MSK)
Received: from vla5-2be56c22b014.qloud-c.yandex.net (vla5-2be56c22b014.qloud-c.yandex.net [IPv6:2a02:6b8:c18:3511:0:640:2be5:6c22])
        by forward103q.mail.yandex.net (Yandex) with ESMTP id B559761E0002;
        Wed,  7 Jul 2021 19:58:06 +0300 (MSK)
Received: from vla3-3dd1bd6927b2.qloud-c.yandex.net (vla3-3dd1bd6927b2.qloud-c.yandex.net [2a02:6b8:c15:350f:0:640:3dd1:bd69])
        by vla5-2be56c22b014.qloud-c.yandex.net (mxback/Yandex) with ESMTP id 4zpvCfPs8F-w6HCrvpc;
        Wed, 07 Jul 2021 19:58:06 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1625677086;
        bh=wVeDA34qWLmiVnIOpCexdC99kU3n+vbfAKrPhmstfPc=;
        h=In-Reply-To:From:To:Subject:Message-ID:Cc:Date:References;
        b=o2j4OuxtUfPgr+3ZAbVI8iuj5Cx6B8iKlGWNQGPpXGIoP4pZrmLsKF2s4NaFkMUlC
         mPuNcQ7kMBk5o5DgPvqO7fGya7MdurneJ8iNWZclpjyuVDTvHW/LDGfmJU5HxXhsAN
         flZQnhroYYil6WvCRnQSAqUXB/RqLdooVpi4gsHk=
Authentication-Results: vla5-2be56c22b014.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by vla3-3dd1bd6927b2.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id rAZGxOklZn-w5PWu1Ng;
        Wed, 07 Jul 2021 19:58:05 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [PATCH v2] KVM: X86: Fix exception untrigger on ret to user
To:     Jim Mattson <jmattson@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jan Kiszka <jan.kiszka@siemens.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
References: <20210628124814.1001507-1-stsp2@yandex.ru>
 <32451d4990cad450f6c8269dbd5fa6a59d126221.camel@redhat.com>
 <7969ff6b1406329a5a931c4ae39cb810db3eefcd.camel@redhat.com>
 <7f264d9f-cb59-0d10-d435-b846f9b61333@yandex.ru>
 <71e0308e9e289208b8457306b3cb6d6f23e795f9.camel@redhat.com>
 <20b01f9d-de7a-91a3-e086-ddd4ae27629f@yandex.ru>
 <6c0a0ffe6103272b648dbc3099f0445d5458059b.camel@redhat.com>
 <dc6a64d0-a77e-b85e-6a8e-c5ca3b42dd59@yandex.ru>
 <CALMp9eQo6aUCz6+KOWJLhOXJET+4HHVA-HyhjHzAjnfFgTec4Q@mail.gmail.com>
 <6b263403-f959-6d9a-2bbe-15a684df6f50@yandex.ru>
 <CALMp9eRk1x-yTragM8OdQP3VSesVOAzezBs4acbqdiJz=nW-Qw@mail.gmail.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <4795d507-22a0-d7ec-c324-a2a87febf97c@yandex.ru>
Date:   Wed, 7 Jul 2021 19:58:05 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eRk1x-yTragM8OdQP3VSesVOAzezBs4acbqdiJz=nW-Qw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

07.07.2021 19:46, Jim Mattson пишет:
> On Wed, Jul 7, 2021 at 9:34 AM stsp <stsp2@yandex.ru> wrote:
>> 07.07.2021 19:16, Jim Mattson пишет:
>>> On Tue, Jul 6, 2021 at 4:06 PM stsp <stsp2@yandex.ru> wrote:
>>>> 07.07.2021 02:00, Maxim Levitsky пишет:
>>>>> On Wed, 2021-07-07 at 00:50 +0300, stsp wrote:
>>>>>> 06.07.2021 23:29, Maxim Levitsky пишет:
>>>>>>> On Tue, 2021-07-06 at 15:06 +0300, stsp wrote:
>>>>>>>> 06.07.2021 14:49, Maxim Levitsky пишет:
>>>>>>>>> Now about the KVM's userspace API where this is exposed:
>>>>>>>>>
>>>>>>>>> I see now too that KVM_SET_REGS clears the pending exception.
>>>>>>>>> This is new to me and it is IMHO *wrong* thing to do.
>>>>>>>>> However I bet that someone somewhere depends on this,
>>>>>>>>> since this behavior is very old.
>>>>>>>> What alternative would you suggest?
>>>>>>>> Check for ready_for_interrupt_injection
>>>>>>>> and never call KVM_SET_REGS if it indicates
>>>>>>>> "not ready"?
>>>>>>>> But what if someone calls it nevertheless?
>>>>>>>> Perhaps return an error from KVM_SET_REGS
>>>>>>>> if exception is pending? Also KVM_SET_SREGS
>>>>>>>> needs some treatment here too, as it can
>>>>>>>> also be called when an exception is pending,
>>>>>>>> leading to problems.
>>>>>>> As I explained you can call KVM_GET_VCPU_EVENTS before calling
>>>>>>> KVM_SET_REGS and then call KVM_SET_VCPU_EVENTS with the struct
>>>>>>> that was filled by KVM_GET_VCPU_EVENTS.
>>>>>>> That will preserve all the cpu events.
>>>>>> The question is different.
>>>>>> I wonder how _should_ the KVM
>>>>>> API behave when someone calls
>>>>>> KVM_SET_REGS/KVM_SET_SREGS
>>>>> KVM_SET_REGS should not clear the pending exception.
>>>>> but fixing this can break API compatibilitly if some
>>>>> hypervisor (not qemu) relies on it.
>>>>>
>>>>> Thus either a new ioctl is needed or as I said,
>>>>> KVM_GET_VCPU_EVENTS/KVM_SET_VCPU_EVENTS can be used
>>>>> to preserve the events around that call as workaround.
>>>> But I don't need to preserve
>>>> events. Canceling is perfectly
>>>> fine with me because, if I inject
>>>> the interrupt at that point, the
>>>> exception will be re-triggered
>>>> anyway after interrupt handler
>>>> returns.
>>> The exception will not be re-triggered if it was a trap,
>> But my assumption was that
>> everything is atomic, except
>> PF with shadow page tables.
>> I guess you mean the cases
>> when the exception delivery
>> causes EPT fault, which is a bit
>> of a corner case.
> No, that's not what I mean. Consider the #DB exception, which is
> intercepted in all configurations to circumvent a DoS attack. Some #DB
> exceptions modify DR6. Once the exception has been 'injected,' DR6 has
> already been modified. If you do not complete the injection, but you
> deliver an interrupt instead, then the interrupt handler can see a DR6
> value that is architecturally impossible.

Yes, I understand that part.
It seems to be called the "exception
payload" in kvm sources, and
includes also CR2 for #PF.
So of course if there are many
non-atomic cases, rather than
just one, then there are no doubts
we need to check ready_for_injection.
Its just that I was looking at that
non-atomicity as a kvm's quirk,
but its probably the fundamental
part of vmx instead.
There is still the problem that
KVM_SET_REGS cancels the
injection and KVM_SET_SREGS not.
But I realize you may want to leave
it that way for compatibility.

