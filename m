Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8783B59AB
	for <lists+kvm@lfdr.de>; Mon, 28 Jun 2021 09:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232353AbhF1HXY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 03:23:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26979 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229998AbhF1HXY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Jun 2021 03:23:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624864858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g/gsxyXbBGL4U/9Urom1L8AjvctSWmIZPyFCDSnYDcI=;
        b=JDZaKLp1R1topqIlgDuTPt/dySINdxB/vY/W2048wyLR9Ao1Ap75ECGIwVz/Uq44NTDHQ+
        OILL4A561pO9JopCL3Lh5amq4qG35skNTtP19whyUr1+P57oOkiDST0EmfV3qOVRaCFOL0
        8tGX+QS55lhj9f88G3TMPpB988QvOCw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-QDGWvTZiObG-I8_483ag2Q-1; Mon, 28 Jun 2021 03:20:56 -0400
X-MC-Unique: QDGWvTZiObG-I8_483ag2Q-1
Received: by mail-ed1-f72.google.com with SMTP id ds1-20020a0564021cc1b02903956bf3b50cso559106edb.8
        for <kvm@vger.kernel.org>; Mon, 28 Jun 2021 00:20:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=g/gsxyXbBGL4U/9Urom1L8AjvctSWmIZPyFCDSnYDcI=;
        b=JADEeGWBxyjTD8iZ5K3nMDM0z5AgwnP1BjznHeh8tW4MV9t8/IpLJXli2ba1bNr2KB
         3NT4ilhF+cimv7yVgR/sdemwnkq0/UWVM/Nb/SeLmDqF5KueUGaVO5JH+ROh10ASMjYZ
         zmJ9BOxZnGEVx6CC4EcMEW9ftmllccI0C3jQo6BTkBGy91fQEIWHfHgWmCv6YUERjjUB
         Hvnttg3cx2HWPaRZqSi8k0awgwdOJSIu6CT2uW+YM0ibBbjnfIUETAIK1AX1cPMtTRvC
         9WjhtO8SeKpbrcAB5dk6RxzPsfQdf+2vmUt9zlVeGdFB0CLaZXkA3Og2n9XpqHbW6ujD
         feAw==
X-Gm-Message-State: AOAM533rKA8s9mfZxNa/WCwuSHStAMrE1TYDNFq0ru/LcHl+Z9QgpZja
        iFewKOq/urkoBCtTzIphl4fe8JnzYK95wt2er0kR1V+Y8fEMLg/EuhAojsQJWW5XPYTgdoLYXWV
        Gv9a7AnAu/E/qjMjAdCpJwjVhHROHHc1ODS5ng+ThjYEdF9PDXzma+cnaxtwKo3EC
X-Received: by 2002:a17:906:234d:: with SMTP id m13mr9279335eja.518.1624864855633;
        Mon, 28 Jun 2021 00:20:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx7oMF7Qtj6Qyasmzj3CsCReJ4bcaUyoLRtJLJg7krEmwVLlTMpZqOD17d0fhQ4VHPORpLJOw==
X-Received: by 2002:a17:906:234d:: with SMTP id m13mr9279305eja.518.1624864855391;
        Mon, 28 Jun 2021 00:20:55 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id i18sm9078533edc.7.2021.06.28.00.20.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 00:20:54 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Stas Sergeev <stsp2@yandex.ru>
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
In-Reply-To: <20210627233819.857906-1-stsp2@yandex.ru>
References: <20210627233819.857906-1-stsp2@yandex.ru>
Date:   Mon, 28 Jun 2021 09:20:53 +0200
Message-ID: <87zgva3162.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Stas Sergeev <stsp2@yandex.ru> writes:

> When returning to user, the special care is taken about the
> exception that was already injected to VMCS but not yet to guest.
> cancel_injection removes such exception from VMCS. It is set as
> pending, and if the user does KVM_SET_REGS, it gets completely canceled.
>
> This didn't happen though, because the vcpu->arch.exception.injected
> and vcpu->arch.exception.pending were forgotten to update in
> cancel_injection. As the result, KVM_SET_REGS didn't cancel out
> anything, and the exception was re-injected on the next KVM_RUN,
> even though the guest registers (like EIP) were already modified.
> This was leading to an exception coming from the "wrong place".

It shouldn't be that hard to reproduce this in selftests, I
believe. 'exception.injected' can even be set through
KVM_SET_VCPU_EVENTS and then we call KVM_SET_REGS. Alternatively, we can
trigger a real exception from the guest. Could you maybe add something
like this to tools/testing/selftests/kvm/x86_64/set_sregs_test.c?

>
> This patch makes sure the vcpu->arch.exception.injected and
> vcpu->arch.exception.pending are in sync with the reality (and
> with VMCS). Also it adds WARN_ON_ONCE() to __set_regs() to make
> sure vcpu->arch.exception.injected is never set here, because
> if it is, the exception context is going to be corrupted the same
> way it was before that patch.
> Adding WARN_ON_ONCE() alone, without the fix, was verified to
> actually trigger and detect a buggy scenario.
>
> Signed-off-by: Stas Sergeev <stsp2@yandex.ru>
>
> CC: Paolo Bonzini <pbonzini@redhat.com>
> CC: Sean Christopherson <seanjc@google.com>
> CC: Vitaly Kuznetsov <vkuznets@redhat.com>
> CC: Wanpeng Li <wanpengli@tencent.com>
> CC: Jim Mattson <jmattson@google.com>
> CC: Joerg Roedel <joro@8bytes.org>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: Borislav Petkov <bp@alien8.de>
> CC: x86@kernel.org
> CC: "H. Peter Anvin" <hpa@zytor.com>
> CC: kvm@vger.kernel.org
> ---
>  arch/x86/kvm/x86.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e0f4a46649d7..bc6ca8641824 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9450,7 +9450,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>  cancel_injection:
>  	if (req_immediate_exit)
>  		kvm_make_request(KVM_REQ_EVENT, vcpu);
> -	static_call(kvm_x86_cancel_injection)(vcpu);
> +	if (vcpu->arch.exception.injected) {
> +		static_call(kvm_x86_cancel_injection)(vcpu);
> +		vcpu->arch.exception.injected = false;
> +		vcpu->arch.exception.pending = true;
> +	}
>  	if (unlikely(vcpu->arch.apic_attention))
>  		kvm_lapic_sync_from_vapic(vcpu);
>  out:
> @@ -9822,6 +9826,7 @@ static void __set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
>  	kvm_rip_write(vcpu, regs->rip);
>  	kvm_set_rflags(vcpu, regs->rflags | X86_EFLAGS_FIXED);
>  
> +	WARN_ON_ONCE(vcpu->arch.exception.injected);
>  	vcpu->arch.exception.pending = false;
>  
>  	kvm_make_request(KVM_REQ_EVENT, vcpu);

-- 
Vitaly

