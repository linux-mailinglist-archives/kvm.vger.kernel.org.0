Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 976D6B53A4
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 19:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730759AbfIQRHT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 13:07:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43668 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727903AbfIQRHT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 13:07:19 -0400
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7D12E81DE1
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 17:07:18 +0000 (UTC)
Received: by mail-wm1-f69.google.com with SMTP id k9so1510765wmb.0
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 10:07:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1ruT4jB1gaysYVDNCjFP18hxGY2r2nsdaAmRUQTyfVE=;
        b=jL//VWgpokpTQzwcwSd7MkZoM5e0FJvnR97LBgSvubLyZh/5OCUMOAc1UwFvOmQeVh
         7xejhzUg0iN1HSu2+pws+6VLntFC01vzbaGRooR5K236Y6IlfCgesOPnHX2B46PB2dAg
         8jfK5gFWsHROy+zbB0au2WRlHMKqwFeKA6WrK4O3xwvkL+hXoVMyMCd2hocwr3Nxv9XN
         VVcRC694iZ40t9byO4fiBvckdTL/O9p2EtgnxdpAteoRX0kaUYm9HTn5Lk5cTRA4fIpJ
         +7QHR+/2GTmk4HijoaoqihnY0QbtD3CWFoZE/AQlR7RuD0kzoL+1Xxk83OUVraisxfx4
         gaEA==
X-Gm-Message-State: APjAAAWEgqyfON2PdbJLpcl1XoAhEekjNDMQJwTwqdeW7alkkjnHLQEx
        SooOZu9etozbIGos0Eua4xw8Yx6uX2q7yti/Wvmo+B0nyHDd70Bg52szqx9uXv/REBHeGBs/Ogn
        JHLXUC65n2d0V
X-Received: by 2002:a1c:6143:: with SMTP id v64mr4423956wmb.79.1568740037112;
        Tue, 17 Sep 2019 10:07:17 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwIbFrwvol5OymNPikmzOF8yYlM2jDAoFYT60aSA6jpyo8zcnIn7QqaDqNF8TOdzR1saASRcw==
X-Received: by 2002:a1c:6143:: with SMTP id v64mr4423932wmb.79.1568740036822;
        Tue, 17 Sep 2019 10:07:16 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c46c:2acb:d8d2:21d8? ([2001:b07:6468:f312:c46c:2acb:d8d2:21d8])
        by smtp.gmail.com with ESMTPSA id d12sm3670731wme.33.2019.09.17.10.07.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Sep 2019 10:07:16 -0700 (PDT)
Subject: Re: [PATCH v5 3/3] KVM: LAPIC: Tune lapic_timer_advance_ns smoothly
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1568708186-20260-1-git-send-email-wanpengli@tencent.com>
 <1568708186-20260-3-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <879b1950-3ca7-0a53-9e4f-508fd5db4bd4@redhat.com>
Date:   Tue, 17 Sep 2019 19:07:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1568708186-20260-3-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/09/19 10:16, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Filter out drastic fluctuation and random fluctuation, remove
> timer_advance_adjust_done altogether, the adjustment would be
> continuous.
> 
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>

Queued, thanks (I renamed the new variable to lapic_timer_advance_dynamic).

Thanks,

Paolo

> ---
>  arch/x86/kvm/lapic.c | 28 ++++++++++++++--------------
>  arch/x86/kvm/lapic.h |  1 -
>  2 files changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index dbbe478..323bdca 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -65,7 +65,9 @@
>  #define APIC_BROADCAST			0xFF
>  #define X2APIC_BROADCAST		0xFFFFFFFFul
>  
> -#define LAPIC_TIMER_ADVANCE_ADJUST_DONE 100
> +static bool dynamically_adjust_timer_advance __read_mostly;
> +#define LAPIC_TIMER_ADVANCE_ADJUST_MIN 100
> +#define LAPIC_TIMER_ADVANCE_ADJUST_MAX 5000
>  #define LAPIC_TIMER_ADVANCE_ADJUST_INIT 1000
>  /* step-by-step approximation to mitigate fluctuation */
>  #define LAPIC_TIMER_ADVANCE_ADJUST_STEP 8
> @@ -1485,26 +1487,25 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
>  	u32 timer_advance_ns = apic->lapic_timer.timer_advance_ns;
>  	u64 ns;
>  
> +	/* Do not adjust for tiny fluctuations or large random spikes. */
> +	if (abs(advance_expire_delta) > LAPIC_TIMER_ADVANCE_ADJUST_MAX ||
> +	    abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_MIN)
> +		return;
> +
>  	/* too early */
>  	if (advance_expire_delta < 0) {
>  		ns = -advance_expire_delta * 1000000ULL;
>  		do_div(ns, vcpu->arch.virtual_tsc_khz);
> -		timer_advance_ns -= min((u32)ns,
> -			timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
> +		timer_advance_ns -= ns/LAPIC_TIMER_ADVANCE_ADJUST_STEP;
>  	} else {
>  	/* too late */
>  		ns = advance_expire_delta * 1000000ULL;
>  		do_div(ns, vcpu->arch.virtual_tsc_khz);
> -		timer_advance_ns += min((u32)ns,
> -			timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
> +		timer_advance_ns += ns/LAPIC_TIMER_ADVANCE_ADJUST_STEP;
>  	}
>  
> -	if (abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
> -		apic->lapic_timer.timer_advance_adjust_done = true;
> -	if (unlikely(timer_advance_ns > 5000)) {
> +	if (unlikely(timer_advance_ns > LAPIC_TIMER_ADVANCE_ADJUST_MAX))
>  		timer_advance_ns = LAPIC_TIMER_ADVANCE_ADJUST_INIT;
> -		apic->lapic_timer.timer_advance_adjust_done = false;
> -	}
>  	apic->lapic_timer.timer_advance_ns = timer_advance_ns;
>  }
>  
> @@ -1524,7 +1525,7 @@ static void __kvm_wait_lapic_expire(struct kvm_vcpu *vcpu)
>  	if (guest_tsc < tsc_deadline)
>  		__wait_lapic_expire(vcpu, tsc_deadline - guest_tsc);
>  
> -	if (unlikely(!apic->lapic_timer.timer_advance_adjust_done))
> +	if (dynamically_adjust_timer_advance)
>  		adjust_lapic_timer_advance(vcpu, apic->lapic_timer.advance_expire_delta);
>  }
>  
> @@ -2302,13 +2303,12 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
>  	apic->lapic_timer.timer.function = apic_timer_fn;
>  	if (timer_advance_ns == -1) {
>  		apic->lapic_timer.timer_advance_ns = LAPIC_TIMER_ADVANCE_ADJUST_INIT;
> -		apic->lapic_timer.timer_advance_adjust_done = false;
> +		dynamically_adjust_timer_advance = true;
>  	} else {
>  		apic->lapic_timer.timer_advance_ns = timer_advance_ns;
> -		apic->lapic_timer.timer_advance_adjust_done = true;
> +		dynamically_adjust_timer_advance = false;
>  	}
>  
> -
>  	/*
>  	 * APIC is created enabled. This will prevent kvm_lapic_set_base from
>  	 * thinking that APIC state has changed.
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index 50053d2..2aad7e2 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -35,7 +35,6 @@ struct kvm_timer {
>  	s64 advance_expire_delta;
>  	atomic_t pending;			/* accumulated triggered timers */
>  	bool hv_timer_in_use;
> -	bool timer_advance_adjust_done;
>  };
>  
>  struct kvm_lapic {
> 

