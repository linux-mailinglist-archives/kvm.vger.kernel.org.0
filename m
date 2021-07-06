Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6AC3BDF23
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 23:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbhGFVx2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 17:53:28 -0400
Received: from forward103o.mail.yandex.net ([37.140.190.177]:49438 "EHLO
        forward103o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229753AbhGFVx2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 17:53:28 -0400
Received: from myt5-9b032ff2a00e.qloud-c.yandex.net (myt5-9b032ff2a00e.qloud-c.yandex.net [IPv6:2a02:6b8:c12:5a2e:0:640:9b03:2ff2])
        by forward103o.mail.yandex.net (Yandex) with ESMTP id F2F095F81253;
        Wed,  7 Jul 2021 00:50:46 +0300 (MSK)
Received: from myt3-07a4bd8655f2.qloud-c.yandex.net (myt3-07a4bd8655f2.qloud-c.yandex.net [2a02:6b8:c12:693:0:640:7a4:bd86])
        by myt5-9b032ff2a00e.qloud-c.yandex.net (mxback/Yandex) with ESMTP id WmjLLxTsVT-okIOFlIS;
        Wed, 07 Jul 2021 00:50:46 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1625608246;
        bh=jUU/IsaPwqbBzvmZLMvePrUcTDM6TkDOLCkKqYSNK4A=;
        h=In-Reply-To:From:To:Subject:Message-ID:Cc:Date:References;
        b=qUzAPfI1bZ5BjYTpIzYrHIWoinj9cWRdtfHIVf0mQdSzj/7TkPUNJYOQOevl9RbaJ
         L145NB8OlBmxquj744CDArndhM+IBB5KlfHM2oO5RAoG7q7wIAowCHwegYRC34a5/d
         j8vjchyQTQVLiO0InKwS8L4tEF8Dax4U0ZdtwPw8=
Authentication-Results: myt5-9b032ff2a00e.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by myt3-07a4bd8655f2.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id FFZVeGT2lZ-ojPKwe2f;
        Wed, 07 Jul 2021 00:50:45 +0300
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
From:   stsp <stsp2@yandex.ru>
Message-ID: <20b01f9d-de7a-91a3-e086-ddd4ae27629f@yandex.ru>
Date:   Wed, 7 Jul 2021 00:50:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <71e0308e9e289208b8457306b3cb6d6f23e795f9.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

06.07.2021 23:29, Maxim Levitsky пишет:
> On Tue, 2021-07-06 at 15:06 +0300, stsp wrote:
>> 06.07.2021 14:49, Maxim Levitsky пишет:
>>> Now about the KVM's userspace API where this is exposed:
>>>    
>>> I see now too that KVM_SET_REGS clears the pending exception.
>>> This is new to me and it is IMHO *wrong* thing to do.
>>> However I bet that someone somewhere depends on this,
>>> since this behavior is very old.
>> What alternative would you suggest?
>> Check for ready_for_interrupt_injection
>> and never call KVM_SET_REGS if it indicates
>> "not ready"?
>> But what if someone calls it nevertheless?
>> Perhaps return an error from KVM_SET_REGS
>> if exception is pending? Also KVM_SET_SREGS
>> needs some treatment here too, as it can
>> also be called when an exception is pending,
>> leading to problems.
> As I explained you can call KVM_GET_VCPU_EVENTS before calling
> KVM_SET_REGS and then call KVM_SET_VCPU_EVENTS with the struct
> that was filled by KVM_GET_VCPU_EVENTS.
> That will preserve all the cpu events.

The question is different.
I wonder how _should_ the KVM
API behave when someone calls
KVM_SET_REGS/KVM_SET_SREGS
while the exception is pending.
This is currently not handled properly.
We can add/fix the indication with
ready_for_interrupt_injection,
but someone will ignore that
indication, so some handling
(like returning an error) should
be added.
So what would you propose the
KVM_SET_REGS should do if it is
called when an exception is pending?
The question is here because
currently KVM_SET_REGS and
KVM_SET_SREGS handle that differently:
one is trying to cancel the pending
excpetion, and the other one
does nothing, but both are wrong.

