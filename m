Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66771191433
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 16:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgCXPYv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 11:24:51 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:39906 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728034AbgCXPYv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 11:24:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585063490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xQhXogf83gPdcUUT+dzsTyfiEXNjWAAq9WGL/3QdsRU=;
        b=EfdTOJMd1m+UbO8K/jKvXEuxXS1SKL9eHvofPVBa5r8lk27z9hr/OBExo6UmHgWp42UPYC
        01hvDEPO3W9OBNelW/23oOyKeFaQ1tEyPkMXfrtv+kVhnrhhXfm/2xPk1bpFKJVJx/wzvI
        iFrxvnyJUcg1DS8dbKsrV9Y2fmkx2jE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-34XWmwZnMv61r3VoA5-e4w-1; Tue, 24 Mar 2020 11:24:49 -0400
X-MC-Unique: 34XWmwZnMv61r3VoA5-e4w-1
Received: by mail-wr1-f70.google.com with SMTP id f8so1719755wrp.1
        for <kvm@vger.kernel.org>; Tue, 24 Mar 2020 08:24:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=xQhXogf83gPdcUUT+dzsTyfiEXNjWAAq9WGL/3QdsRU=;
        b=ACqRcMV5C9vksvaeEYI4NEpk2fcEautKN/l4pgDULjfxOdzEQOMqhOg1+ouP7NcrHN
         /xQ0m55oklpN2qNniJbK526BqJcksr3+PYTU4a2Fv7UxPI688L57wruL9q4ny7gUwyNG
         PIRQSsKVLEVu0eTCDZ+dWylM1Tlmiz6Al6oJcVtKrXrev3mDQeTHD+HA4tpUzCS+PaXn
         BthE4HEJqH8x4FHb/VGAPFn5/yfH1PYskIHjKQARblAJgL1X00Jkm4ciXvrnY/UuxYNq
         hkuXlN+hN2G5Kan0Qhrf1GoMNle4OHKmXD/6UnxS77+67+/0f4Nr5s585ZqJ4jEKNYS2
         xJFw==
X-Gm-Message-State: ANhLgQ1tWi5JHtgBxbcs4d0J92fjl9Xy700NdtyqhcL3AJNbzy3nkpGl
        9U7vdcRoQAX3UhTF2h5RHM9/4ENBbZyDBdq/N9GjjWjZzJgQ2PF43PB8X5SfCduA6mUGef0eVHy
        7WOjjZ83MrM4f
X-Received: by 2002:adf:e684:: with SMTP id r4mr6746175wrm.6.1585063487722;
        Tue, 24 Mar 2020 08:24:47 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtWlzNYRSY8iv4SdsIkUBo11qNCxFpdTHuub9iGt/riNcD7HwIClZ/QuMWQVVbxebvgW76tAg==
X-Received: by 2002:adf:e684:: with SMTP id r4mr6746156wrm.6.1585063487562;
        Tue, 24 Mar 2020 08:24:47 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u16sm29555478wro.23.2020.03.24.08.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 08:24:46 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] KVM: LAPIC: Also cancel preemption timer when disarm LAPIC timer
In-Reply-To: <1585031530-19823-1-git-send-email-wanpengli@tencent.com>
References: <1585031530-19823-1-git-send-email-wanpengli@tencent.com>
Date:   Tue, 24 Mar 2020 16:24:45 +0100
Message-ID: <87imit7p36.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wanpeng Li <kernellwp@gmail.com> writes:

> From: Wanpeng Li <wanpengli@tencent.com>
>
> The timer is disarmed when switching between TSC deadline and other modes, 
> we should set everything to disarmed state, however, LAPIC timer can be 
> emulated by preemption timer, it still works if vmx->hv_deadline_timer is 
> not -1. This patch also cancels preemption timer when disarm LAPIC timer.
>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/lapic.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 338de38..a38f1a8 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1445,6 +1445,8 @@ static void limit_periodic_timer_frequency(struct kvm_lapic *apic)
>  	}
>  }
>  
> +static void cancel_hv_timer(struct kvm_lapic *apic);
> +

Nitpick: cancel_hv_timer() is only 4 lines long so I'd suggest we move
it instead of adding a forward declaration.

>  static void apic_update_lvtt(struct kvm_lapic *apic)
>  {
>  	u32 timer_mode = kvm_lapic_get_reg(apic, APIC_LVTT) &
> @@ -1454,6 +1456,10 @@ static void apic_update_lvtt(struct kvm_lapic *apic)
>  		if (apic_lvtt_tscdeadline(apic) != (timer_mode ==
>  				APIC_LVT_TIMER_TSCDEADLINE)) {
>  			hrtimer_cancel(&apic->lapic_timer.timer);
> +			preempt_disable();
> +			if (apic->lapic_timer.hv_timer_in_use)
> +				cancel_hv_timer(apic);
> +			preempt_enable();
>  			kvm_lapic_set_reg(apic, APIC_TMICT, 0);
>  			apic->lapic_timer.period = 0;
>  			apic->lapic_timer.tscdeadline = 0;

-- 
Vitaly

