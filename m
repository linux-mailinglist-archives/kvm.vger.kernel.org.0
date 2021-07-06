Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9EF3BDB58
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 18:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbhGFQas (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 12:30:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22271 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230110AbhGFQar (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 12:30:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625588888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bmk7gs1ZXDu/jD70JSvYcIzTuBRAP4T/0m2MLqDgdZ0=;
        b=fGvaSgw+XjWkFLGOT4paySj7ItbNNDq/5N0zNiJSR3tiQKaMXnjNPGohy/BLPAqWF1I5I7
        /ww9XzMVz56xb0xrfdTN7cixSS9ioVXQbq8IjqSHtQOYxp7hByI2mI5BG3EGXfgc9NO50R
        uU+HqoqM1ZG3ESnGkKp/BlhuXblTMrU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50-CjOBsfaXP8SrWNkjnUmJYw-1; Tue, 06 Jul 2021 12:28:06 -0400
X-MC-Unique: CjOBsfaXP8SrWNkjnUmJYw-1
Received: by mail-wm1-f72.google.com with SMTP id n37-20020a05600c3ba5b02901fe49ba3bd0so1147945wms.1
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 09:28:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Bmk7gs1ZXDu/jD70JSvYcIzTuBRAP4T/0m2MLqDgdZ0=;
        b=Fm5Jj8AD0svtfgYO+tmzcDPSrwfz9Hx3npeGZxTqf2Negr/V41NFhjIsrGgZ0VFre2
         OMoJ9gJDmvCKYTIxBwd8T8SKBGNv78qyixe+8/9e77F4wBES5Y6Zbw0own3AKHSoMUbV
         zCCoOQnC4MkYgqgRs21fgScFxQu8KJCm3vDUIuXFFbn44VdPWOechgbpFgg36CeYNqeC
         e7e9YWpcjDA3mNZkaL9P2xQ7gBE1CVY9vSJ4rMnTgXZSA23qs+jyPw56Wt9I2oxqfVEp
         fFKgAzeFnNiMiEsXz8/YtDEXiaxh2GuOBf85K6pFTivsZ4H2aOw7p90/UxXBLg3HG445
         gjYw==
X-Gm-Message-State: AOAM533YHoJZdYT6TntPviWKk6yWbUG6oyCmqn4XnSBJqDRbfX0xnHmB
        2nR9ozk50gv6LjzrSreGCzZ3VABMkU1G9pGD4xd8qSXV0RUHMVINJGiaS1d6eJzgYnuJKyGNZB6
        8T+aSGXwAJWYB
X-Received: by 2002:adf:f612:: with SMTP id t18mr22308096wrp.314.1625588885825;
        Tue, 06 Jul 2021 09:28:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxW1kcVjhbNzE2sI2x3Os1w2y+bMq6mY6E7bWgYYm8U7vePEAUqsbFR1M/KU8g2OkRUfjE/3Q==
X-Received: by 2002:adf:f612:: with SMTP id t18mr22308077wrp.314.1625588885652;
        Tue, 06 Jul 2021 09:28:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s9sm6561751wrn.87.2021.07.06.09.28.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 09:28:04 -0700 (PDT)
Subject: Re: exception vs SIGALRM race (was: Re: guest/host mem out of sync on
 core2duo?)
To:     Jim Mattson <jmattson@google.com>, stsp <stsp2@yandex.ru>
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
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1501d6d3-4dab-3eca-1d82-1e1954e293e1@redhat.com>
Date:   Tue, 6 Jul 2021 18:28:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eT9XSuk2=WuunKsLpUw8zbE1xtzRzHesN3MOJPYuh0KkQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/06/21 00:27, Jim Mattson wrote:
>> static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
>> {
>>           return kvm_arch_interrupt_allowed(vcpu) &&
>>                   kvm_cpu_accept_dm_intr(vcpu);
>> }
>   It looks like Paolo may have broken this in commit 71cc849b7093
> ("KVM: x86: Fix split-irqchip vs interrupt injection window request").
> The commit message seems focused only on
> vcpu->arch.interrupt.injected. Perhaps he overlooked
> vcpu->arch.exception.injected.

I was expecting the exception to be injected first and the interrupt second.
But something like this should fix it:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 21877ad2214e..dddff682c9c2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4277,6 +4277,9 @@ static int kvm_vcpu_ioctl_set_lapic(struct kvm_vcpu *vcpu,
  
  static int kvm_cpu_accept_dm_intr(struct kvm_vcpu *vcpu)
  {
+	if (kvm_event_needs_reinjection(vcpu))
+		return false;
+
  	/*
  	 * We can accept userspace's request for interrupt injection
  	 * as long as we have a place to store the interrupt number.

I'll figure out a selftest to better understand what's going on.  In the meanwhile
Stas can test it!

Thanks,

Paolo

