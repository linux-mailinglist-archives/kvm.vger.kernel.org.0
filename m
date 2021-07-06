Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8163BDF61
	for <lists+kvm@lfdr.de>; Wed,  7 Jul 2021 00:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbhGFWZY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 18:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbhGFWZX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jul 2021 18:25:23 -0400
Received: from forward102j.mail.yandex.net (forward102j.mail.yandex.net [IPv6:2a02:6b8:0:801:2::102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B21C061574
        for <kvm@vger.kernel.org>; Tue,  6 Jul 2021 15:22:44 -0700 (PDT)
Received: from iva8-6377ea28ef3a.qloud-c.yandex.net (iva8-6377ea28ef3a.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:6f19:0:640:6377:ea28])
        by forward102j.mail.yandex.net (Yandex) with ESMTP id AF2DBF202F9;
        Wed,  7 Jul 2021 01:22:40 +0300 (MSK)
Received: from iva3-dd2bb2ff2b5f.qloud-c.yandex.net (iva3-dd2bb2ff2b5f.qloud-c.yandex.net [2a02:6b8:c0c:7611:0:640:dd2b:b2ff])
        by iva8-6377ea28ef3a.qloud-c.yandex.net (mxback/Yandex) with ESMTP id rgVV9zx2kQ-MeHCws2I;
        Wed, 07 Jul 2021 01:22:40 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1625610160;
        bh=ReSJK/P+S/6BgBfYS5T5iSD0E+mhGfgqycMtoAvj94U=;
        h=In-Reply-To:From:Date:References:To:Subject:Message-ID:Cc;
        b=DsDMWTBHFN91dpOfi+iTKykwdbhUqxe1nKT4IBUxQ59c31LTZyaOj8nySB/u2Leo9
         6Bjy1bNwW0pyqzbD4Abmd9IXY/OlVZkbF3SoHbL2yW/ZD1JrdhyEO5ICghjFAqQ/dJ
         yWJ8p+3UimKT9DjEweNurEL5pp90EYzN1z5xSciY=
Authentication-Results: iva8-6377ea28ef3a.qloud-c.yandex.net; dkim=pass header.i=@yandex.ru
Received: by iva3-dd2bb2ff2b5f.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id TYv4hg1BtW-MdP8pfaT;
        Wed, 07 Jul 2021 01:22:39 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: exception vs SIGALRM race (was: Re: guest/host mem out of sync on
 core2duo?)
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Woodhouse <dwmw@amazon.co.uk>,
        "ntsironis@arrikto.com" <ntsironis@arrikto.com>
References: <bd4a2d30-5fb4-3612-c855-946d97068b9a@yandex.ru>
 <YMeMov42fihXptQm@google.com>
 <73f1f90e-f952-45a4-184e-1aafb3e4a8fd@yandex.ru>
 <YMtfQHGJL7XP/0Rq@google.com>
 <23b00d8a-1732-0b0b-cd8d-e802f7aca87c@yandex.ru>
 <CALMp9eSpJ8=O=6YExpOtdnA=gQkWfQJ+oz0bBcV4gOPFdnciVA@mail.gmail.com>
 <d5bf20f4-9aef-8e7e-8a8f-47d10510724e@yandex.ru>
 <CALMp9eQANi7SPAvue5VQazG7A0=b_2vkUxYK+GMLbzNkxbXM5w@mail.gmail.com>
 <bf512c29-e6e2-9609-52e5-549d80d865d0@yandex.ru>
 <CALMp9eSnUhE61VcS5tDfmJwKFO9_en5iQhFeakiJ54gnH3QRvg@mail.gmail.com>
 <b15c78e6-4ae3-5825-50c2-396c4e600d02@yandex.ru>
 <CALMp9eT9XSuk2=WuunKsLpUw8zbE1xtzRzHesN3MOJPYuh0KkQ@mail.gmail.com>
 <1501d6d3-4dab-3eca-1d82-1e1954e293e1@redhat.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <eadbc511-3270-8a8e-a2d8-a8eb1fccb8c0@yandex.ru>
Date:   Wed, 7 Jul 2021 01:22:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1501d6d3-4dab-3eca-1d82-1e1954e293e1@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

06.07.2021 19:28, Paolo Bonzini пишет:
> On 29/06/21 00:27, Jim Mattson wrote:
>>> static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu 
>>> *vcpu)
>>> {
>>>           return kvm_arch_interrupt_allowed(vcpu) &&
>>>                   kvm_cpu_accept_dm_intr(vcpu);
>>> }
>>   It looks like Paolo may have broken this in commit 71cc849b7093
>> ("KVM: x86: Fix split-irqchip vs interrupt injection window request").
>> The commit message seems focused only on
>> vcpu->arch.interrupt.injected. Perhaps he overlooked
>> vcpu->arch.exception.injected.
>
> I was expecting the exception to be injected first and the interrupt 
> second.
> But something like this should fix it:
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 21877ad2214e..dddff682c9c2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4277,6 +4277,9 @@ static int kvm_vcpu_ioctl_set_lapic(struct 
> kvm_vcpu *vcpu,
>
>  static int kvm_cpu_accept_dm_intr(struct kvm_vcpu *vcpu)
>  {
> +    if (kvm_event_needs_reinjection(vcpu))
> +        return false;
> +
>      /*
>       * We can accept userspace's request for interrupt injection
>       * as long as we have a place to store the interrupt number.
>
> I'll figure out a selftest to better understand what's going on. In 
> the meanwhile
> Stas can test it!
I confirm that this works, thanks.
Sadly the problematic patch was
CCed to -stable, and is now present
in all kernels, like ubuntu's 5.8.0-55-generic.
Since AFAICT it didn't contain the
important/security fix, I think it
shouldn't have been CCed to -stable.

Can we revert it from -stable?
That will mean a relatively quick
fix for most of current users.
