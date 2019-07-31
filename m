Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E088C7C26E
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 14:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388162AbfGaM5B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 08:57:01 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37436 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388153AbfGaM5A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 08:57:00 -0400
Received: by mail-wm1-f65.google.com with SMTP id f17so59716740wme.2
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 05:56:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IZIh6MlDVtHPiwAsFVJnNtW03boho+9QyTSEdiXSHBw=;
        b=sdUg7nKZtqhlbPRFs0wBAYy9SbnwcnPWC0cX0WAW+rniw4FY3LOXUCmapUcDmEu86e
         5l4XZwt/VJXi4PWToCvGBg5mUhw3RWi48wGmgVSQP7KQRbmT08Z5s4/lzi8LbXc4GK96
         EXaFMYqGIIdqjQCiozwUEl3TIyWTsjr28eERM6ecubPi5k4SjVI6C5dts3dgVgg3cI1C
         ZqJYvWEHfDp9CR00+BGDcZgXC+E/RnyAfb8rIJAmMjeSGl6n8iFcK73PWRAkpvyAwHGm
         sfAdqpHCWMaMTgk88YEouYW409yUGuXKHORWqUoxt+gJjDOeiDTng4vYeXUtJwya6o08
         DdJg==
X-Gm-Message-State: APjAAAWHEuIky/Pcj7nXCB113bKqKTdYXQcsscxjnzxOIDXCE03EKaOS
        PG9YO8GIlenWArLik6nyDGNCKg==
X-Google-Smtp-Source: APXvYqz8x2TA8RbHG4GAy8dlpCQQz81WPB7zCXKR7/QFoeY/qXr2v3TBsMrBuO+d2w6k9t6UtAvXsg==
X-Received: by 2002:a1c:be05:: with SMTP id o5mr112635648wmf.52.1564577818394;
        Wed, 31 Jul 2019 05:56:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:91e7:65e:d8cd:fdb3? ([2001:b07:6468:f312:91e7:65e:d8cd:fdb3])
        by smtp.gmail.com with ESMTPSA id r4sm40675504wrq.82.2019.07.31.05.56.57
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 05:56:57 -0700 (PDT)
Subject: Re: [PATCH 1/3] KVM: Don't need to wakeup vCPU twice afer timer fire
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <1564572438-15518-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <ab8f8b07-e3f9-4831-c386-0bfa0314f9c3@redhat.com>
Date:   Wed, 31 Jul 2019 14:56:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1564572438-15518-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/07/19 13:27, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> kvm_set_pending_timer() will take care to wake up the sleeping vCPU which 
> has pending timer, don't need to check this in apic_timer_expired() again.

No, it doesn't.  kvm_make_request never kicks the vCPU.

Paolo

> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/lapic.c | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 0aa1586..685d17c 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1548,7 +1548,6 @@ static void kvm_apic_inject_pending_timer_irqs(struct kvm_lapic *apic)
>  static void apic_timer_expired(struct kvm_lapic *apic)
>  {
>  	struct kvm_vcpu *vcpu = apic->vcpu;
> -	struct swait_queue_head *q = &vcpu->wq;
>  	struct kvm_timer *ktimer = &apic->lapic_timer;
>  
>  	if (atomic_read(&apic->lapic_timer.pending))
> @@ -1566,13 +1565,6 @@ static void apic_timer_expired(struct kvm_lapic *apic)
>  
>  	atomic_inc(&apic->lapic_timer.pending);
>  	kvm_set_pending_timer(vcpu);
> -
> -	/*
> -	 * For x86, the atomic_inc() is serialized, thus
> -	 * using swait_active() is safe.
> -	 */
> -	if (swait_active(q))
> -		swake_up_one(q);
>  }
>  
>  static void start_sw_tscdeadline(struct kvm_lapic *apic)
> 

