Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11FCE3B5D1F
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 13:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbhF1La0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 07:30:26 -0400
Received: from forward105j.mail.yandex.net ([5.45.198.248]:32813 "EHLO
        forward105j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232767AbhF1LaZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Jun 2021 07:30:25 -0400
Received: from myt6-9503d8936a58.qloud-c.yandex.net (myt6-9503d8936a58.qloud-c.yandex.net [IPv6:2a02:6b8:c12:4684:0:640:9503:d893])
        by forward105j.mail.yandex.net (Yandex) with ESMTP id 73E93B2251B;
        Mon, 28 Jun 2021 14:27:58 +0300 (MSK)
Received: from myt6-9bdf92ffd111.qloud-c.yandex.net (myt6-9bdf92ffd111.qloud-c.yandex.net [2a02:6b8:c12:468a:0:640:9bdf:92ff])
        by myt6-9503d8936a58.qloud-c.yandex.net (mxback/Yandex) with ESMTP id ofYBvQQk8P-RvIq4QFv;
        Mon, 28 Jun 2021 14:27:58 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1624879678;
        bh=lNTsgqdhzvi2ZHIHNTN6BquAeDuXnhG5in4TLQkUGRo=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=Kt2GoNA0f9aH2tCGQpi4PLrPSSLepWU8/CGHEP2/xzK/c68lM7UKIsS8BgCbcJkIh
         pC/xq0kXyqiLRK9bk9sh1JUFMwMLT0gEoAN0kO6X7/j8lZrJUGLWMV+oyDjdrvekO2
         uk7sDB3L0btvVYVULlFMb7/FVR3OVoQK7TvuexMc=
Authentication-Results: myt6-9503d8936a58.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by myt6-9bdf92ffd111.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id 4opb6EslvG-RvP4pSPb;
        Mon, 28 Jun 2021 14:27:57 +0300
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
 <b08399e2-ce68-e895-ed0d-b97920f721ce@yandex.ru>
 <87lf6u2r6v.fsf@vitty.brq.redhat.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <17c7da34-7a54-017e-1c2f-870d7e2c5ed7@yandex.ru>
Date:   Mon, 28 Jun 2021 14:27:56 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87lf6u2r6v.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

28.06.2021 13:56, Vitaly Kuznetsov пишет:
> stsp <stsp2@yandex.ru> writes:
>
>> Yes, cancel_injection is supposed to
>> be always broken indeed. But there
>> are a few more things to it.
>> Namely:
>> - Other CPUs do not seem to exhibit
>> that path. My guess here is that they
>> just handle the exception in hardware,
>> without returning to KVM for that. I
>> am not sure why Core2 vmexits per
>> each page fault. Is it incapable of
>> handling the PF in hardware, or maybe
>> some other bug is around?
> Wild guess: no EPT support and running on shadow pages?

That's something you should tell
me, and not the other way around. :)
I am just working with kvm as a user.


>> - Even if you followed the broken
>> path, in most cases everything is still
>> fine: the exception will just be re-injected.
>> The unfortunate scenario is when you
>> have _TIF_SIGPENDING at exactly
>> right place. Then you go to user-space,
>> and the user-space is unlucky to use
>> SET_REGS right here. These conditions
>> are not very likely to happen. I wrote a
>> test-case for it, but it involves the entire
>> buildroot setup and you need to wait
>> a bit while it is trying to trigger the race.
> Maybe there's an easier way to trigger imminent exit to userspace which
> doesn't involve

Any API to intercept all guest exceptions?
But even if there is, I am afraid in that
case cancel_injection is not going to be
executed. It is executed only when
kvm_vcpu_exit_request(vcpu) returns true.


>> ... which makes such scenario valid?
>>
> We should not add userspace-triggerable WARNs in kernel, right. I was
> not sure if the WARN you add stays triggerable post-patch.

I thought its not - at least not when
the exceptions are coming from the
guest. Maybe WARN_ON() can somehow
check if the exception was injected by
user-space, like by checking the events
bitmask?
Or I'll just remove it.


> Maybe the huge amount of injected #PFs (which are triggered because
> there's no EPT) contribute to the easiness of the reproduction? Purely
> from from looking at the code of your patch, the issue should also
> happen with other exceptions, KVM just doesn't inject them that
> often.
I haven't seen the same race with
any other exception, like with GP.
I suspect there is no vmexit
for GP, so it will just be injected in
hardware. I think only PF makes
the problem because of the shadow
page tables, as you pointed before.
While I haven't made a specific
test-case to try GP, I am quite sure
it would have been observed long
ago because GPs in our usage
scenarios are much more frequent
than PFs. But the race was never
observed with GP.
