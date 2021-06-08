Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B3539FC8D
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 18:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233838AbhFHQ3o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 12:29:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36973 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232705AbhFHQ3n (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Jun 2021 12:29:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623169670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6QJBTH37VasFwd3YzJKG/qXO5jT9HboQjodqiDu8+Zc=;
        b=A09mGKRPPIFcVKemNtdOC40ionxPf68bGjb8oUoAUUn1vs0mrXsmpju3dIrAdU1BOi+EOF
        KKsBLEEoX7pmVeOSVIPDK2SR58QHt4CXc/ahfA/no9aLUruKsWIXdaK3Dp+Ru6J0HUcz9g
        mb1cMUIpj2GL9mRMleOtgq+i7G08YeI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-lpyL6dcINY-VTEx0ylmO_Q-1; Tue, 08 Jun 2021 12:27:49 -0400
X-MC-Unique: lpyL6dcINY-VTEx0ylmO_Q-1
Received: by mail-wr1-f69.google.com with SMTP id x9-20020adfffc90000b02901178add5f60so9676240wrs.5
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 09:27:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6QJBTH37VasFwd3YzJKG/qXO5jT9HboQjodqiDu8+Zc=;
        b=e0y5Piu5d1FDHl7tjNmyD/OalD4+/Y/0KEE7K7uwkB7i/G5aEaeCIF4qfV3JSuLSRB
         xGrHJmFWvWCLoKgKqVbdz5AnZfC375IbMjWseyFXEtqmsiw8nfI39VD5EN22xppF7uXC
         ECN8VOoxZvtpdcI7SzKK4HDTXIMWNoxuJkZMgXLjr0vSq/QZFf49RBxN6zgTcTQzjx77
         iYRjOGFhvs3rcrDpGh2B2sRY8Lb5UY3pHEj00suwVCH9yOyjBX8sEF/NOm/Juy4wlF4N
         o5GlfYTlNJECB6FH/F0jGOOY/Llyh9m7trlXOEza/Lrfw6cu0+Ph4pOafJga7Y90jzyO
         s4cA==
X-Gm-Message-State: AOAM533ZMXm2HJv8UHNruh+J+UJQmhU2Jqn06knbhL0Vk7ZiU9c0LbJo
        RwSDUkn2lH7QI0oBtcI9qby6wCBUIJ1HHPTsQ8IzcYX7DZ2mh9cMz1HBHzWez0MkocTa5cAdNq5
        5CuGWr7S+pxH6
X-Received: by 2002:a05:600c:4f87:: with SMTP id n7mr10135472wmq.9.1623169667811;
        Tue, 08 Jun 2021 09:27:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzyk82eyAaBRpiG5MsJi0DtmhJDd0/vl/6wrkRA1oiwkQBvX/Md38hTA4c9uakfmJZYsoLEYg==
X-Received: by 2002:a05:600c:4f87:: with SMTP id n7mr10135450wmq.9.1623169667603;
        Tue, 08 Jun 2021 09:27:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id 25sm3495274wmk.20.2021.06.08.09.27.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 09:27:47 -0700 (PDT)
Subject: Re: [PATCH v2 1/3] KVM: LAPIC: Write 0 to TMICT should also cancel
 vmx-preemption timer
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1623050385-100988-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9a95474c-5430-83d5-db65-2909191bd9f5@redhat.com>
Date:   Tue, 8 Jun 2021 18:27:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <1623050385-100988-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/06/21 09:19, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> According to the SDM 10.5.4.1:
> 
>    A write of 0 to the initial-count register effectively stops the local
>    APIC timer, in both one-shot and periodic mode.
> 
> However, the lapic timer oneshot/periodic mode which is emulated by vmx-preemption
> timer doesn't stop by writing 0 to TMICT since vmx->hv_deadline_tsc is still
> programmed and the guest will receive the spurious timer interrupt later. This
> patch fixes it by also cancelling the vmx-preemption timer when writing 0 to
> the initial-count register.
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
> v1 -> v2:
>   * rename to cancel_apic_timer
>   * update patch description
> 
>   arch/x86/kvm/lapic.c | 17 +++++++++++------
>   1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 8120e86..6d72d8f 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1494,6 +1494,15 @@ static void limit_periodic_timer_frequency(struct kvm_lapic *apic)
>   
>   static void cancel_hv_timer(struct kvm_lapic *apic);
>   
> +static void cancel_apic_timer(struct kvm_lapic *apic)
> +{
> +	hrtimer_cancel(&apic->lapic_timer.timer);
> +	preempt_disable();
> +	if (apic->lapic_timer.hv_timer_in_use)
> +		cancel_hv_timer(apic);
> +	preempt_enable();
> +}
> +
>   static void apic_update_lvtt(struct kvm_lapic *apic)
>   {
>   	u32 timer_mode = kvm_lapic_get_reg(apic, APIC_LVTT) &
> @@ -1502,11 +1511,7 @@ static void apic_update_lvtt(struct kvm_lapic *apic)
>   	if (apic->lapic_timer.timer_mode != timer_mode) {
>   		if (apic_lvtt_tscdeadline(apic) != (timer_mode ==
>   				APIC_LVT_TIMER_TSCDEADLINE)) {
> -			hrtimer_cancel(&apic->lapic_timer.timer);
> -			preempt_disable();
> -			if (apic->lapic_timer.hv_timer_in_use)
> -				cancel_hv_timer(apic);
> -			preempt_enable();
> +			cancel_apic_timer(apic);
>   			kvm_lapic_set_reg(apic, APIC_TMICT, 0);
>   			apic->lapic_timer.period = 0;
>   			apic->lapic_timer.tscdeadline = 0;
> @@ -2092,7 +2097,7 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>   		if (apic_lvtt_tscdeadline(apic))
>   			break;
>   
> -		hrtimer_cancel(&apic->lapic_timer.timer);
> +		cancel_apic_timer(apic);
>   		kvm_lapic_set_reg(apic, APIC_TMICT, val);
>   		start_apic_timer(apic);
>   		break;
> 

Queued this one, thanks.

Paolo

