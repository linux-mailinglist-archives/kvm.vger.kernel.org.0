Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5115060990
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 17:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbfGEPqp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 11:46:45 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34322 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727935AbfGEPqp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 11:46:45 -0400
Received: by mail-wm1-f68.google.com with SMTP id w9so7836344wmd.1
        for <kvm@vger.kernel.org>; Fri, 05 Jul 2019 08:46:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=05Q35+GTTpUYXJL1Rwag0mMQtzgdvg4fi4Hn+VrKK8E=;
        b=TaQXzZQG3jNkjNCmlFwcJhGR0x5ZBFBOlWbl946jTldMIyvTUKI4PePde9FK7Z0DAM
         Qku0lzVmvaslguVvWI1XFx6viIUnd9O6SvL3cqyEeyhw9YiajQ5sIB0Fkxc/YnKW6ycI
         9rZwebEh3zLEd1QzWkN7mW86cda7uXvcKLm1mH4pwjF4niaKLHKTc+xgWliKMnW+8RR8
         vcE3DyTwdJMYQaV0usyo2tZxkek9nj8gJ9vOJPVm9agKf1NgmfbavMQoB0RVx00tuLgP
         1q3YQ4ftLxVG8tC+1V+G/RbhN8iKXVfJA4UM0Upx/vDUkq/JNO9GDa8wnECquXHyIHW3
         hW2g==
X-Gm-Message-State: APjAAAVmHk2/IPZ3/D7ccpUPzuih/feU3MT/ly0nb68H5c2roUd6lFaR
        6T4t+hWEMUZSYlooEhzCs3UEKg==
X-Google-Smtp-Source: APXvYqxLDxgwbbyPy1jXiFOSU0No+ezL7hxBj4s55FwrNPiWik5aUBg2K0Vb9f+kn1IoOV+TemaD/w==
X-Received: by 2002:a1c:7503:: with SMTP id o3mr3948230wmc.170.1562341603285;
        Fri, 05 Jul 2019 08:46:43 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e943:5a4e:e068:244a? ([2001:b07:6468:f312:e943:5a4e:e068:244a])
        by smtp.gmail.com with ESMTPSA id q10sm9019757wrf.32.2019.07.05.08.46.42
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 08:46:42 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: LAPIC: Retry tune per-vCPU timer_advance_ns if
 adaptive tuning goes insane
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <1562340222-31324-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <96d0bcf5-a18e-770d-3962-a8c330a2f803@redhat.com>
Date:   Fri, 5 Jul 2019 17:46:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1562340222-31324-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/07/19 17:23, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Retry tune per-vCPU timer_advance_ns if adaptive tuning goes insane which 
> can happen sporadically in product environment.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v1 -> v2:
>  * retry max 10 times if adaptive tuning goes insane

Is there any advantage at stopping the retry (also it should not be a
local variable of course).

Paolo

>  arch/x86/kvm/lapic.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 95affa5..bd0dbe5 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1538,6 +1538,7 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
>  	struct kvm_lapic *apic = vcpu->arch.apic;
>  	u32 timer_advance_ns = apic->lapic_timer.timer_advance_ns;
>  	u64 ns;
> +	uint retry_count = 0;
>  
>  	/* too early */
>  	if (advance_expire_delta < 0) {
> @@ -1556,8 +1557,10 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
>  	if (abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
>  		apic->lapic_timer.timer_advance_adjust_done = true;
>  	if (unlikely(timer_advance_ns > 5000)) {
> -		timer_advance_ns = 0;
> -		apic->lapic_timer.timer_advance_adjust_done = true;
> +		timer_advance_ns = 1000;
> +		apic->lapic_timer.timer_advance_adjust_done = false;
> +		if (++retry_count > 10)
> +			apic->lapic_timer.timer_advance_adjust_done = true;
>  	}
>  	apic->lapic_timer.timer_advance_ns = timer_advance_ns;
>  }
> 

