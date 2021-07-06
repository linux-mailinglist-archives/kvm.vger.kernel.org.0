Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74023BDF92
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 01:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbhGFXIo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 19:08:44 -0400
Received: from forward104p.mail.yandex.net ([77.88.28.107]:58972 "EHLO
        forward104p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229811AbhGFXIo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 19:08:44 -0400
Received: from forward101q.mail.yandex.net (forward101q.mail.yandex.net [IPv6:2a02:6b8:c0e:4b:0:640:4012:bb98])
        by forward104p.mail.yandex.net (Yandex) with ESMTP id DEC4E4B00314;
        Wed,  7 Jul 2021 02:06:02 +0300 (MSK)
Received: from vla1-2e2fe8fd096a.qloud-c.yandex.net (vla1-2e2fe8fd096a.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:3495:0:640:2e2f:e8fd])
        by forward101q.mail.yandex.net (Yandex) with ESMTP id D9312CF40004;
        Wed,  7 Jul 2021 02:06:02 +0300 (MSK)
Received: from vla3-3dd1bd6927b2.qloud-c.yandex.net (vla3-3dd1bd6927b2.qloud-c.yandex.net [2a02:6b8:c15:350f:0:640:3dd1:bd69])
        by vla1-2e2fe8fd096a.qloud-c.yandex.net (mxback/Yandex) with ESMTP id PtNx3hMGWH-62HaI1ZU;
        Wed, 07 Jul 2021 02:06:02 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1625612762;
        bh=oAYZNOFbHlhVDwuJ5LN7ZhvWdDTJex9Tg0E1Nb1NYpA=;
        h=In-Reply-To:From:To:Subject:Message-ID:Cc:Date:References;
        b=bcbb48aknCM3L3MuaWAPuznLWRgMuCm8MENHHq7UdG4FOj2Wo6g0/5mcn1Rhb9IqR
         Kk55qabSqkFdQdZHvqZVC6GjzSSBY9dEkFhXV3PgP01izGoJYTXPMp3qsQ89nn09M5
         71rcvuYOiTXLDRETFnnWBhwZSh45yB8YUpNGDb6w=
Authentication-Results: vla1-2e2fe8fd096a.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by vla3-3dd1bd6927b2.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id uIozHO3iih-61PKCZtr;
        Wed, 07 Jul 2021 02:06:01 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [PATCH v2] KVM: X86: Fix exception untrigger on ret to user
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
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
From:   stsp <stsp2@yandex.ru>
Message-ID: <dc6a64d0-a77e-b85e-6a8e-c5ca3b42dd59@yandex.ru>
Date:   Wed, 7 Jul 2021 02:06:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <6c0a0ffe6103272b648dbc3099f0445d5458059b.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

07.07.2021 02:00, Maxim Levitsky пишет:
> On Wed, 2021-07-07 at 00:50 +0300, stsp wrote:
>> 06.07.2021 23:29, Maxim Levitsky пишет:
>>> On Tue, 2021-07-06 at 15:06 +0300, stsp wrote:
>>>> 06.07.2021 14:49, Maxim Levitsky пишет:
>>>>> Now about the KVM's userspace API where this is exposed:
>>>>>     
>>>>> I see now too that KVM_SET_REGS clears the pending exception.
>>>>> This is new to me and it is IMHO *wrong* thing to do.
>>>>> However I bet that someone somewhere depends on this,
>>>>> since this behavior is very old.
>>>> What alternative would you suggest?
>>>> Check for ready_for_interrupt_injection
>>>> and never call KVM_SET_REGS if it indicates
>>>> "not ready"?
>>>> But what if someone calls it nevertheless?
>>>> Perhaps return an error from KVM_SET_REGS
>>>> if exception is pending? Also KVM_SET_SREGS
>>>> needs some treatment here too, as it can
>>>> also be called when an exception is pending,
>>>> leading to problems.
>>> As I explained you can call KVM_GET_VCPU_EVENTS before calling
>>> KVM_SET_REGS and then call KVM_SET_VCPU_EVENTS with the struct
>>> that was filled by KVM_GET_VCPU_EVENTS.
>>> That will preserve all the cpu events.
>> The question is different.
>> I wonder how _should_ the KVM
>> API behave when someone calls
>> KVM_SET_REGS/KVM_SET_SREGS
> KVM_SET_REGS should not clear the pending exception.
> but fixing this can break API compatibilitly if some
> hypervisor (not qemu) relies on it.
>
> Thus either a new ioctl is needed or as I said,
> KVM_GET_VCPU_EVENTS/KVM_SET_VCPU_EVENTS can be used
> to preserve the events around that call as workaround.
But I don't need to preserve
events. Canceling is perfectly
fine with me because, if I inject
the interrupt at that point, the
exception will be re-triggered
anyway after interrupt handler
returns.

What I ask is how SHOULD the
KVM_SET_REGS and KVM_SET_SREGS
behave when someone (mistakenly)
calls them with the exception pending.
Should they return an error
instead of canceling exception?
