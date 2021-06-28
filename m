Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41E03B5CCB
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 12:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbhF1K7B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 06:59:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37983 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232614AbhF1K67 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Jun 2021 06:58:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624877793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pFMAVyznb5Po1Z0GLzHFclCCYOYTe9bnEtkElWTPRIA=;
        b=GPLZnehLlM58rr/bWZouHikTFNsM3cAe33XmFaEWcSJ30vbT/GkJABhqG+otEUtWSVoSPt
        mm9gLFBx83fw7J/+iAC9tkrDRAJ7kqcPSzeSLskPhjwWlEJYlBN4Homb7TCSAYHDEgn5cG
        eo7fHCKDmOmjHrEbI/xnT3loOZ4qLd4=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-537-wmUYm_qaNjKp6MHtMpNIJA-1; Mon, 28 Jun 2021 06:56:27 -0400
X-MC-Unique: wmUYm_qaNjKp6MHtMpNIJA-1
Received: by mail-ej1-f70.google.com with SMTP id 16-20020a1709063010b029037417ca2d43so4183436ejz.5
        for <kvm@vger.kernel.org>; Mon, 28 Jun 2021 03:56:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=pFMAVyznb5Po1Z0GLzHFclCCYOYTe9bnEtkElWTPRIA=;
        b=msT7X9cagVBxevU4HW1ygwiVuikTGzEJH7b162eepUUsb5xg+Qy2ucAg3xc+Cfzo7O
         8dVWKo/saiASikGcjV47un4guxYjMTmIg96biQlsMifclv2ef7kmuHoAd6lU8U+KzJWS
         eOg/Y2guOI1vQ2Pxnnc6U8L8FfzaJAMnjTkTO2pWEGuJqUN9Q3ypRBS36grXMhBn6vB9
         DDBIIxAdXktVQ+lNqqzQ1HsSQm4AICySjv5H7fckhrq9QAGz+u2P8MAPDFDDsJ9nMZQX
         gd+74Qj/CMKk+uagOhQfLA5jK2iF4HhkWyoyT1e3+lyYrtKwfP652wGf7LOzqTGMUVtG
         lQVg==
X-Gm-Message-State: AOAM531LROp0+idcs4kwxRBpRSLyoX77zZVHXJ3c4MVJz9wV4OXmycHn
        1cJYDoxq4/h1BpFi6ehFUbFzjjWpWiapPDGXvO177+IOJ2HkxSc5peIwkfraHUDsiO3QQseMVtr
        iFByBlLrspbsiGw8+sWBoBFAGR1Ncsu8itfoTZmO5H/OmkRIPwPqv/TDp2VW43Aim
X-Received: by 2002:a05:6402:120b:: with SMTP id c11mr32336008edw.209.1624877786667;
        Mon, 28 Jun 2021 03:56:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwD6Fyl35u/FQBtX8cYs7Rm5t/LEbLxRl51RUQoBqGaXY5efXzXJMJAEUuLNvFTuI+pJiHnjg==
X-Received: by 2002:a05:6402:120b:: with SMTP id c11mr32335968edw.209.1624877786351;
        Mon, 28 Jun 2021 03:56:26 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id ec24sm9584220edb.74.2021.06.28.03.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 03:56:25 -0700 (PDT)
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
In-Reply-To: <b08399e2-ce68-e895-ed0d-b97920f721ce@yandex.ru>
References: <20210627233819.857906-1-stsp2@yandex.ru>
 <87zgva3162.fsf@vitty.brq.redhat.com>
 <b3ee97c8-318a-3134-07c7-75114e96b7cf@yandex.ru>
 <87o8bq2tfm.fsf@vitty.brq.redhat.com>
 <b08399e2-ce68-e895-ed0d-b97920f721ce@yandex.ru>
Date:   Mon, 28 Jun 2021 12:56:24 +0200
Message-ID: <87lf6u2r6v.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

stsp <stsp2@yandex.ru> writes:

> 28.06.2021 13:07, Vitaly Kuznetsov =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>> stsp <stsp2@yandex.ru> writes:
>>
>>> 28.06.2021 10:20, Vitaly Kuznetsov =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>>>> Stas Sergeev <stsp2@yandex.ru> writes:
>>>>
>>>>> When returning to user, the special care is taken about the
>>>>> exception that was already injected to VMCS but not yet to guest.
>>>>> cancel_injection removes such exception from VMCS. It is set as
>>>>> pending, and if the user does KVM_SET_REGS, it gets completely cancel=
ed.
>>>>>
>>>>> This didn't happen though, because the vcpu->arch.exception.injected
>>>>> and vcpu->arch.exception.pending were forgotten to update in
>>>>> cancel_injection. As the result, KVM_SET_REGS didn't cancel out
>>>>> anything, and the exception was re-injected on the next KVM_RUN,
>>>>> even though the guest registers (like EIP) were already modified.
>>>>> This was leading to an exception coming from the "wrong place".
>>>> It shouldn't be that hard to reproduce this in selftests, I
>>>> believe.
>>> Unfortunately the problem happens only on core2 CPU. I believe the reas=
on
>>> is perhaps that more modern CPUs do not go to software for the exception
>>> injection?
>> Hm, I've completely missed that from the original description. As I read
>> it, 'cancel_injection' path in vcpu_enter_guest() is always broken when
>> vcpu->arch.exception.injected is set as we forget to clear it...
>
> Yes, cancel_injection is supposed to
> be always broken indeed. But there
> are a few more things to it.
> Namely:
> - Other CPUs do not seem to exhibit
> that path. My guess here is that they
> just handle the exception in hardware,
> without returning to KVM for that. I
> am not sure why Core2 vmexits per
> each page fault. Is it incapable of
> handling the PF in hardware, or maybe
> some other bug is around?

Wild guess: no EPT support and running on shadow pages?

>
> - Even if you followed the broken
> path, in most cases everything is still
> fine: the exception will just be re-injected.
> The unfortunate scenario is when you
> have _TIF_SIGPENDING at exactly
> right place. Then you go to user-space,
> and the user-space is unlucky to use
> SET_REGS right here. These conditions
> are not very likely to happen. I wrote a
> test-case for it, but it involves the entire
> buildroot setup and you need to wait
> a bit while it is trying to trigger the race.

Maybe there's an easier way to trigger imminent exit to userspace which
doesn't involve=20

>
>
>>>>    'exception.injected' can even be set through
>>>> KVM_SET_VCPU_EVENTS and then we call KVM_SET_REGS.
>>> Does this mean I shouldn't add WARN_ON_ONCE()?
>> WARN_ON_ONCE() is fine IMO in case there's no valid case when
>> 'vcpu->arch.exception.injected' is set during __set_regs().
>
> But you said:
>
>> 'exception.injected' can even be set through
>> KVM_SET_VCPU_EVENTS and then we call KVM_SET_REGS.
>
> ... which makes such scenario valid?
>

We should not add userspace-triggerable WARNs in kernel, right. I was
not sure if the WARN you add stays triggerable post-patch.=20

>=20=20=20
>
>>>
>>>>    Alternatively, we can
>>>> trigger a real exception from the guest. Could you maybe add something
>>>> like this to tools/testing/selftests/kvm/x86_64/set_sregs_test.c?
>>> Even if you have the right CPU to reproduce that (Core2), you also
>>> need the _TIF_SIGPENDING at the right moment to provoke the cancel_inje=
ction
>>> path. This is like triggering a race. If you don't get _TIF_SIGPENDING
>>> then it will just re-enter guest and  inject the exception properly.
>> I'd like to understand the hardware dependency first. Is it possible
>> that the exception which causes the problem is not triggered on other
>> CPUs?
>
> No, exception is triggered, but I
> have never seen the race on any
> other CPUs, and none of the people
> who reported that problem to me,
> have seen it on any other CPU.
> I think other CPU just injects the PF
> without doing any vmexit, but I've
> no idea why Core2 does not do the
> same thing. Should it?

Maybe the huge amount of injected #PFs (which are triggered because
there's no EPT) contribute to the easiness of the reproduction? Purely
from from looking at the code of your patch, the issue should also
happen with other exceptions, KVM just doesn't inject them that
often. It doesn't mean that we can't craft something from selftests,
just need to understand the required conditions...

--=20
Vitaly

