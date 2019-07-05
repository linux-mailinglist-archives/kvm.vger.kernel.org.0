Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3260A60610
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 14:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728921AbfGEMka (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 08:40:30 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42934 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727469AbfGEMka (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 08:40:30 -0400
Received: by mail-wr1-f66.google.com with SMTP id a10so8704399wrp.9
        for <kvm@vger.kernel.org>; Fri, 05 Jul 2019 05:40:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l8x9dhvz7TMokwr3sn5UWhMUIMcQlqc6m7Wb8cBeajU=;
        b=RGeMz53iVzUXvwPGKY67w53JgnfEvpF/dxPMLNp7p3HelyX/xG7NT8XGRFrMvu/DWS
         vGUB/6ApGyTI0GfnmMRmydhNBOIeny1zdaED7s8T0gyiOIjYW/qjKFV9YwKcOMSY9LP9
         o0tmgu2+Al5m2mZ1oDTl43KFBomZ7Awdz0gKz9hQeeCJGgRMGi6E7dX9VhKsnQVQ6kEI
         IgIwkocXhRL4TvqnzI7HHskR9CeCj5Q7j1VmU/q/vAMGp832t11+GUaOixmhL+CrJ4Sp
         7M+H9gqtGQCzkWUa84Jff+QOBjmblsnky9FHBeyR0USv1mdD6Oi72WViDiMXpdN2uZu3
         vTHA==
X-Gm-Message-State: APjAAAVroZxtnLP0nzEjrX1jfW2mzPG4yhB3+Emp10VirsHQf95+IJzw
        jecs3DgOFccyvhgGMHcC5RaxCQ==
X-Google-Smtp-Source: APXvYqzsvfIgDRLDpqO1yoitLvd8abmdL76b4tnZhwgDNNS9W39D4awx5a3XB+tWwAH1tYKngkhEjQ==
X-Received: by 2002:adf:ab1d:: with SMTP id q29mr4339062wrc.18.1562330428452;
        Fri, 05 Jul 2019 05:40:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e943:5a4e:e068:244a? ([2001:b07:6468:f312:e943:5a4e:e068:244a])
        by smtp.gmail.com with ESMTPSA id n2sm7067453wmi.38.2019.07.05.05.40.27
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 05:40:27 -0700 (PDT)
Subject: Re: [PATCH v5 4/4] KVM: LAPIC: Don't inject already-expired timer via
 posted interrupt
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
References: <1561110002-4438-1-git-send-email-wanpengli@tencent.com>
 <1561110002-4438-5-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <67fad01b-8a77-5892-d963-77a3d321bb65@redhat.com>
Date:   Fri, 5 Jul 2019 14:40:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1561110002-4438-5-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/06/19 11:40, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> already-expired timer interrupt can be injected to guest when vCPU who 
> arms the lapic timer re-vmentry, don't posted inject in this case.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/lapic.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index ae575c0..7cd95ea 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1452,7 +1452,7 @@ static void kvm_apic_inject_pending_timer_irqs(struct kvm_lapic *apic)
>  	}
>  }
>  
> -static void apic_timer_expired(struct kvm_lapic *apic)
> +static void apic_timer_expired(struct kvm_lapic *apic, bool can_pi_inject)
>  {
>  	struct kvm_vcpu *vcpu = apic->vcpu;
>  	struct swait_queue_head *q = &vcpu->wq;
> @@ -1464,7 +1464,7 @@ static void apic_timer_expired(struct kvm_lapic *apic)
>  	if (apic_lvtt_tscdeadline(apic) || ktimer->hv_timer_in_use)
>  		ktimer->expired_tscdeadline = ktimer->tscdeadline;
>  
> -	if (posted_interrupt_inject_timer(apic->vcpu)) {
> +	if (can_pi_inject && posted_interrupt_inject_timer(apic->vcpu)) {

Perhaps it should use a posted interrupt if kvm_arch_should_kick(vcpu),
i.e. just add kvm_arch_vcpu_should_kick(apic->vcpu) to
posted_interrupt_inject_timer?

Paolo

>  		if (apic->lapic_timer.timer_advance_ns)
>  			kvm_wait_lapic_expire(vcpu, true);
>  		kvm_apic_inject_pending_timer_irqs(apic);
> @@ -1607,7 +1607,7 @@ static void start_sw_tscdeadline(struct kvm_lapic *apic)
>  		expire = ktime_sub_ns(expire, ktimer->timer_advance_ns);
>  		hrtimer_start(&ktimer->timer, expire, HRTIMER_MODE_ABS);
>  	} else
> -		apic_timer_expired(apic);
> +		apic_timer_expired(apic, false);
>  
>  	local_irq_restore(flags);
>  }
> @@ -1697,7 +1697,7 @@ static void start_sw_period(struct kvm_lapic *apic)
>  
>  	if (ktime_after(ktime_get(),
>  			apic->lapic_timer.target_expiration)) {
> -		apic_timer_expired(apic);
> +		apic_timer_expired(apic, false);
>  
>  		if (apic_lvtt_oneshot(apic))
>  			return;
> @@ -1759,7 +1759,7 @@ static bool start_hv_timer(struct kvm_lapic *apic)
>  		if (atomic_read(&ktimer->pending)) {
>  			cancel_hv_timer(apic);
>  		} else if (expired) {
> -			apic_timer_expired(apic);
> +			apic_timer_expired(apic, false);
>  			cancel_hv_timer(apic);
>  		}
>  	}
> @@ -1809,7 +1809,7 @@ void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu)
>  		goto out;
>  	WARN_ON(swait_active(&vcpu->wq));
>  	cancel_hv_timer(apic);
> -	apic_timer_expired(apic);
> +	apic_timer_expired(apic, false);
>  
>  	if (apic_lvtt_period(apic) && apic->lapic_timer.period) {
>  		advance_periodic_target_expiration(apic);
> @@ -2312,7 +2312,7 @@ static enum hrtimer_restart apic_timer_fn(struct hrtimer *data)
>  	struct kvm_timer *ktimer = container_of(data, struct kvm_timer, timer);
>  	struct kvm_lapic *apic = container_of(ktimer, struct kvm_lapic, lapic_timer);
>  
> -	apic_timer_expired(apic);
> +	apic_timer_expired(apic, true);
>  
>  	if (lapic_is_periodic(apic)) {
>  		advance_periodic_target_expiration(apic);
> 

