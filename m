Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE173B5C7D
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 12:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbhF1KfR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 06:35:17 -0400
Received: from forward100p.mail.yandex.net ([77.88.28.100]:47177 "EHLO
        forward100p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231700AbhF1KfP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Jun 2021 06:35:15 -0400
Received: from sas2-3c349b911c75.qloud-c.yandex.net (sas2-3c349b911c75.qloud-c.yandex.net [IPv6:2a02:6b8:c08:bc8b:0:640:3c34:9b91])
        by forward100p.mail.yandex.net (Yandex) with ESMTP id 0CAB85981A44;
        Mon, 28 Jun 2021 13:32:47 +0300 (MSK)
Received: from sas1-37da021029ee.qloud-c.yandex.net (sas1-37da021029ee.qloud-c.yandex.net [2a02:6b8:c08:1612:0:640:37da:210])
        by sas2-3c349b911c75.qloud-c.yandex.net (mxback/Yandex) with ESMTP id gVYQjNAqUe-WjJmsFs4;
        Mon, 28 Jun 2021 13:32:46 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1624876366;
        bh=3kQmJTGFO2c4SH2iYvRbbWPk6MWPP2SOpCSH71um9AY=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=gRy6Pxlbts6G+NJEMMxNSOMaNPDH2ydyHGUXg55Va231Z5CYwYn1tmI3DtkjXvrfy
         8Ybi8hkyqhHkr6MGdWR1XVrZmf9mOe9TjtB+d6ha6HSx7UD1+o+8Ac96HBZsYRsQrF
         hLNYQq1zWHmi38IV3YUdi7ndTgCgEGPMQ5GbrAlU=
Authentication-Results: sas2-3c349b911c75.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by sas1-37da021029ee.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id 63B0I5yiru-Wi2K8S0E;
        Mon, 28 Jun 2021 13:32:45 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [PATCH] KVM: X86: Fix exception untrigger on ret to user
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
References: <20210627233819.857906-1-stsp2@yandex.ru>
 <87zgva3162.fsf@vitty.brq.redhat.com>
 <b3ee97c8-318a-3134-07c7-75114e96b7cf@yandex.ru>
 <87o8bq2tfm.fsf@vitty.brq.redhat.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <b08399e2-ce68-e895-ed0d-b97920f721ce@yandex.ru>
Date:   Mon, 28 Jun 2021 13:32:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87o8bq2tfm.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

28.06.2021 13:07, Vitaly Kuznetsov пишет:
> stsp <stsp2@yandex.ru> writes:
>
>> 28.06.2021 10:20, Vitaly Kuznetsov пишет:
>>> Stas Sergeev <stsp2@yandex.ru> writes:
>>>
>>>> When returning to user, the special care is taken about the
>>>> exception that was already injected to VMCS but not yet to guest.
>>>> cancel_injection removes such exception from VMCS. It is set as
>>>> pending, and if the user does KVM_SET_REGS, it gets completely canceled.
>>>>
>>>> This didn't happen though, because the vcpu->arch.exception.injected
>>>> and vcpu->arch.exception.pending were forgotten to update in
>>>> cancel_injection. As the result, KVM_SET_REGS didn't cancel out
>>>> anything, and the exception was re-injected on the next KVM_RUN,
>>>> even though the guest registers (like EIP) were already modified.
>>>> This was leading to an exception coming from the "wrong place".
>>> It shouldn't be that hard to reproduce this in selftests, I
>>> believe.
>> Unfortunately the problem happens only on core2 CPU. I believe the reason
>> is perhaps that more modern CPUs do not go to software for the exception
>> injection?
> Hm, I've completely missed that from the original description. As I read
> it, 'cancel_injection' path in vcpu_enter_guest() is always broken when
> vcpu->arch.exception.injected is set as we forget to clear it...

Yes, cancel_injection is supposed to
be always broken indeed. But there
are a few more things to it.
Namely:
- Other CPUs do not seem to exhibit
that path. My guess here is that they
just handle the exception in hardware,
without returning to KVM for that. I
am not sure why Core2 vmexits per
each page fault. Is it incapable of
handling the PF in hardware, or maybe
some other bug is around?

- Even if you followed the broken
path, in most cases everything is still
fine: the exception will just be re-injected.
The unfortunate scenario is when you
have _TIF_SIGPENDING at exactly
right place. Then you go to user-space,
and the user-space is unlucky to use
SET_REGS right here. These conditions
are not very likely to happen. I wrote a
test-case for it, but it involves the entire
buildroot setup and you need to wait
a bit while it is trying to trigger the race.


>>>    'exception.injected' can even be set through
>>> KVM_SET_VCPU_EVENTS and then we call KVM_SET_REGS.
>> Does this mean I shouldn't add WARN_ON_ONCE()?
> WARN_ON_ONCE() is fine IMO in case there's no valid case when
> 'vcpu->arch.exception.injected' is set during __set_regs().

But you said:

> 'exception.injected' can even be set through
> KVM_SET_VCPU_EVENTS and then we call KVM_SET_REGS.

... which makes such scenario valid?

  

>>
>>>    Alternatively, we can
>>> trigger a real exception from the guest. Could you maybe add something
>>> like this to tools/testing/selftests/kvm/x86_64/set_sregs_test.c?
>> Even if you have the right CPU to reproduce that (Core2), you also
>> need the _TIF_SIGPENDING at the right moment to provoke the cancel_injection
>> path. This is like triggering a race. If you don't get _TIF_SIGPENDING
>> then it will just re-enter guest and  inject the exception properly.
> I'd like to understand the hardware dependency first. Is it possible
> that the exception which causes the problem is not triggered on other
> CPUs?

No, exception is triggered, but I
have never seen the race on any
other CPUs, and none of the people
who reported that problem to me,
have seen it on any other CPU.
I think other CPU just injects the PF
without doing any vmexit, but I've
no idea why Core2 does not do the
same thing. Should it?

