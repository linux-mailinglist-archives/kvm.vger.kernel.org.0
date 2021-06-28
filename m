Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB8E3B5C25
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 12:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbhF1KKb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 06:10:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59501 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232557AbhF1KK3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Jun 2021 06:10:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624874884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=acIMkFdI63AfUwOvhp5SrYDC8917vAjrM2I0aI+kJbA=;
        b=dXk83DvXfdOa/bLyna33shK71ymCrqq4uxLumOuq+qN23hTQ3c9K8aPH6JBrytgCoqfJa7
        Hw6mSQdwDnWwXDX06rIoYZ6SO/b5HqFyCjpNcG+v8X8JzTzg5+19p6NREIBbo/QQszI0jd
        Si9cYWLPSF/CpFwjROzUeT5lNztlq/o=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-jSXS-VLHOrWXHCs0xaoeFw-1; Mon, 28 Jun 2021 06:08:00 -0400
X-MC-Unique: jSXS-VLHOrWXHCs0xaoeFw-1
Received: by mail-ej1-f71.google.com with SMTP id u4-20020a1709061244b02904648b302151so4144537eja.17
        for <kvm@vger.kernel.org>; Mon, 28 Jun 2021 03:08:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=acIMkFdI63AfUwOvhp5SrYDC8917vAjrM2I0aI+kJbA=;
        b=T4DO40gjF1B7Mh6zz1CwJ7MSMG9dJHTCELabrBh0Enz9tlvIe7uEfH359LZw7PP3Hk
         m8iWBqBUg6yb6GVFQfVs39I6FE8oc1d4NSnFR3U3q9UIqEKUf8Dky4zlyr5VCECMDKXL
         KEzl2Y87k0Pl3zL6rtS+1MDMrtXvJwzzcKdRCc6qLfm8bqUFg0BTQQUI9q7nLBR4hpCo
         NAn7K0mLcJzhySorlcvIlACW1PhPm2Tzs+d+tjmE2TsenTRX4/ixzvcxKRyNzoK5kAoa
         4Ts8H32EtwiZj9CXY4Okuo5zpYDf52lLcFShLhIRXrOKGEmn/Dgz86ji6yvGnxt0Id9h
         HXiA==
X-Gm-Message-State: AOAM532JzyATsnSeld66NkrRl5N1qNYQ9p+jXOXEmZkanYa/EYmXvPU7
        YGSR4J8yQ3PyCNqvrH2e1IXwUBbaADmyPaGR8S9st5yBQcrWQ7liACtZTnIusC75ulaF52GiGcQ
        4uEoJq2xzc7jIKqn/D38COc8+rDTi3ZhWbVKmL8b6/qL+rRpV9c8uOzzq54NAzZM5
X-Received: by 2002:a05:6402:848:: with SMTP id b8mr31611229edz.44.1624874879385;
        Mon, 28 Jun 2021 03:07:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxNxKZUWMCsM/y10314aaOMWYNEgEDfMcpMVbB7c6pvO80W85f7r6gTc2EVOl/YY4SKwC7DzQ==
X-Received: by 2002:a05:6402:848:: with SMTP id b8mr31611199edz.44.1624874879205;
        Mon, 28 Jun 2021 03:07:59 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id k21sm6308798edr.90.2021.06.28.03.07.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 03:07:58 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     stsp <stsp2@yandex.ru>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: X86: Fix exception untrigger on ret to user
In-Reply-To: <b3ee97c8-318a-3134-07c7-75114e96b7cf@yandex.ru>
References: <20210627233819.857906-1-stsp2@yandex.ru>
 <87zgva3162.fsf@vitty.brq.redhat.com>
 <b3ee97c8-318a-3134-07c7-75114e96b7cf@yandex.ru>
Date:   Mon, 28 Jun 2021 12:07:57 +0200
Message-ID: <87o8bq2tfm.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

stsp <stsp2@yandex.ru> writes:

> 28.06.2021 10:20, Vitaly Kuznetsov =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>> Stas Sergeev <stsp2@yandex.ru> writes:
>>
>>> When returning to user, the special care is taken about the
>>> exception that was already injected to VMCS but not yet to guest.
>>> cancel_injection removes such exception from VMCS. It is set as
>>> pending, and if the user does KVM_SET_REGS, it gets completely canceled.
>>>
>>> This didn't happen though, because the vcpu->arch.exception.injected
>>> and vcpu->arch.exception.pending were forgotten to update in
>>> cancel_injection. As the result, KVM_SET_REGS didn't cancel out
>>> anything, and the exception was re-injected on the next KVM_RUN,
>>> even though the guest registers (like EIP) were already modified.
>>> This was leading to an exception coming from the "wrong place".
>> It shouldn't be that hard to reproduce this in selftests, I
>> believe.
>
> Unfortunately the problem happens only on core2 CPU. I believe the reason
> is perhaps that more modern CPUs do not go to software for the exception
> injection?

Hm, I've completely missed that from the original description. As I read
it, 'cancel_injection' path in vcpu_enter_guest() is always broken when
vcpu->arch.exception.injected is set as we forget to clear it...

>
>
>>   'exception.injected' can even be set through
>> KVM_SET_VCPU_EVENTS and then we call KVM_SET_REGS.
>
> Does this mean I shouldn't add WARN_ON_ONCE()?

WARN_ON_ONCE() is fine IMO in case there's no valid case when
'vcpu->arch.exception.injected' is set during __set_regs(). selftest is
needed to check for '... this was leading to an exception coming from
the "wrong place"'.

>
>
>>   Alternatively, we can
>> trigger a real exception from the guest. Could you maybe add something
>> like this to tools/testing/selftests/kvm/x86_64/set_sregs_test.c?
> Even if you have the right CPU to reproduce that (Core2), you also
> need the _TIF_SIGPENDING at the right moment to provoke the cancel_inject=
ion
> path. This is like triggering a race. If you don't get _TIF_SIGPENDING
> then it will just re-enter guest and  inject the exception properly.

I'd like to understand the hardware dependency first. Is it possible
that the exception which causes the problem is not triggered on other
CPUs? We can find a different way to trigger an exception from selftest
then.

(Maybe it's just me who still struggles to see the full picure here,
hope Sean/Paolo will see the problem you're trying to address in no
time)

--=20
Vitaly

