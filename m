Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D40703B5B08
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 11:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbhF1JPL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 05:15:11 -0400
Received: from forward104o.mail.yandex.net ([37.140.190.179]:36948 "EHLO
        forward104o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232284AbhF1JPL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Jun 2021 05:15:11 -0400
Received: from iva3-2436f5349071.qloud-c.yandex.net (iva3-2436f5349071.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:498b:0:640:2436:f534])
        by forward104o.mail.yandex.net (Yandex) with ESMTP id 2CFC8941BDA;
        Mon, 28 Jun 2021 12:12:44 +0300 (MSK)
Received: from iva1-bc1861525829.qloud-c.yandex.net (iva1-bc1861525829.qloud-c.yandex.net [2a02:6b8:c0c:a0e:0:640:bc18:6152])
        by iva3-2436f5349071.qloud-c.yandex.net (mxback/Yandex) with ESMTP id LYzadKIi5H-ChHW0dbr;
        Mon, 28 Jun 2021 12:12:44 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1624871564;
        bh=bQ27ahGlifoFXBKmVQcP6hbPUEWBRLGf/ycKLEjqtTI=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=oy6MSMk7oONIzEc7gqboWZ65yktvfzeOyun8oodDTp55KSloHFogPqhOp9zKMyH+n
         B7Hy3iK3BQfJ/B62n8FY/BB0zYMnKv88DItbQaOZi3MBdY70hX3DlW9XFJuXOsFKCv
         gBsoOadm85wKA6fK5JGhxJ1NR+IHlrdwtR78+G1M=
Authentication-Results: iva3-2436f5349071.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by iva1-bc1861525829.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id UdIBP1W98W-CgPurpiK;
        Mon, 28 Jun 2021 12:12:43 +0300
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
From:   stsp <stsp2@yandex.ru>
Message-ID: <b3ee97c8-318a-3134-07c7-75114e96b7cf@yandex.ru>
Date:   Mon, 28 Jun 2021 12:12:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <87zgva3162.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

28.06.2021 10:20, Vitaly Kuznetsov пишет:
> Stas Sergeev <stsp2@yandex.ru> writes:
>
>> When returning to user, the special care is taken about the
>> exception that was already injected to VMCS but not yet to guest.
>> cancel_injection removes such exception from VMCS. It is set as
>> pending, and if the user does KVM_SET_REGS, it gets completely canceled.
>>
>> This didn't happen though, because the vcpu->arch.exception.injected
>> and vcpu->arch.exception.pending were forgotten to update in
>> cancel_injection. As the result, KVM_SET_REGS didn't cancel out
>> anything, and the exception was re-injected on the next KVM_RUN,
>> even though the guest registers (like EIP) were already modified.
>> This was leading to an exception coming from the "wrong place".
> It shouldn't be that hard to reproduce this in selftests, I
> believe.

Unfortunately the problem happens
only on core2 CPU. I believe the reason
is perhaps that more modern CPUs do
not go to software for the exception
injection?


>   'exception.injected' can even be set through
> KVM_SET_VCPU_EVENTS and then we call KVM_SET_REGS.

Does this mean I shouldn't add
WARN_ON_ONCE()?


>   Alternatively, we can
> trigger a real exception from the guest. Could you maybe add something
> like this to tools/testing/selftests/kvm/x86_64/set_sregs_test.c?
Even if you have the right CPU
to reproduce that (Core2), you also
need the _TIF_SIGPENDING at the
right moment to provoke the cancel_injection
path. This is like triggering a race.
If you don't get _TIF_SIGPENDING
then it will just re-enter guest and
inject the exception properly.
