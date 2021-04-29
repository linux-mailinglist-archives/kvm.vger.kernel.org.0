Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5A036ED85
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 17:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbhD2PlN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 11:41:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45908 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233420AbhD2PlN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Apr 2021 11:41:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619710825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kK+PtjkelzcP148tYlX83T1qpvdgbT7Hd+zpcnCGKv4=;
        b=ZQdQxdt7/QCjmt0PV0yQ+/ipaxGVFU7mP0vAbnMZpIHpqbjnSK29aXHzU+SrWLKEXC2PUq
        m/gXuYE1ELYH9avNZnLUYjKBKSDYJfZT1CB9rj00ovWOeZbsaBCb1sjGQfSdbHkvFuto8S
        jtZXYKwFeRJq58s7r+84g1vzYnhaUUg=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478--4z-PWOMPHq4N8A89goKBA-1; Thu, 29 Apr 2021 11:40:23 -0400
X-MC-Unique: -4z-PWOMPHq4N8A89goKBA-1
Received: by mail-ed1-f69.google.com with SMTP id w14-20020aa7da4e0000b02903834aeed684so27185579eds.13
        for <kvm@vger.kernel.org>; Thu, 29 Apr 2021 08:40:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kK+PtjkelzcP148tYlX83T1qpvdgbT7Hd+zpcnCGKv4=;
        b=l1fSwspmcXuFAFJfn0QphWztXIkSt7vj/P+3um6w2AacEtwfS8Neipd6VNO2O8C85r
         vWXHPPW1g0gm6chhmjjlx9UaKFHW/OwZ3JhccZl1NWM5A5VCBAaxyRuR6m8pERxl/TDm
         XjKyRrup7RQtV5R1/smZmn4dVbif0ZSF71IySjorNp3vOmhJIu/CK2v0uB6YprZyHp3m
         3gA1GFKr//0cXghffNos9+5VTt5zA+SzpU/fNP0tQJI0vRB9RB6uThUiZisAAvBz518n
         NC4lmBsPZrdEycybY1x3VDEfCMoPCHA07cZIgK2RIxkMPFjb2R1D7+6M1MTlGbCqpA/R
         K3AA==
X-Gm-Message-State: AOAM532kuHdDj14fhFo0CfaJ33MAV/8zxlg3Z99I/TZKzgCq4IORYgYi
        1Uub2ubySnqBHQGcN8aO2GpHkU6UDVicTiFpJ8EmKfZsIQM0Nbh+kY2CX7aDXd0YVJJfT2Ny/wG
        zXDiep+o513+u
X-Received: by 2002:a50:ab1d:: with SMTP id s29mr156010edc.203.1619710822541;
        Thu, 29 Apr 2021 08:40:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxvGDWWePXYARUeseM/SK8xtoNJZjNSvs627FSZovPJWIisAAmeLX5WcR7hzO/wxYVsh87DbQ==
X-Received: by 2002:a50:ab1d:: with SMTP id s29mr155985edc.203.1619710822325;
        Thu, 29 Apr 2021 08:40:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id lc1sm202408ejb.39.2021.04.29.08.40.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Apr 2021 08:40:21 -0700 (PDT)
Subject: Re: [PATCH] KVM: LAPIC: Accurately guarantee busy wait for timer to
 expire when using hv_timer
To:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1619608082-4187-1-git-send-email-wanpengli@tencent.com>
 <YInoMjNJRgm3gUYX@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7893b6e5-3a4a-1e79-bc7c-2c6368e92471@redhat.com>
Date:   Thu, 29 Apr 2021 17:40:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YInoMjNJRgm3gUYX@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/04/21 00:56, Sean Christopherson wrote:
> On Wed, Apr 28, 2021, Wanpeng Li wrote:
>> From: Wanpeng Li <wanpengli@tencent.com>
>>
>> Commit ee66e453db13d (KVM: lapic: Busy wait for timer to expire when
>> using hv_timer) tries to set ktime->expired_tscdeadline by checking
>> ktime->hv_timer_in_use since lapic timer oneshot/periodic modes which
>> are emulated by vmx preemption timer also get advanced, they leverage
>> the same vmx preemption timer logic with tsc-deadline mode. However,
>> ktime->hv_timer_in_use is cleared before apic_timer_expired() handling,
>> let's delay this clearing in preemption-disabled region.
>>
>> Fixes: ee66e453db13d (KVM: lapic: Busy wait for timer to expire when using hv_timer)
> 
> Well that's embarassing.  I suspect/hope I tested the case where start_hv_timer()
> detects the timer already expired.  On the plus side, start_hv_timer() calls
> cancel_hv_timer() after apic_timer_expired(), so there are unlikely to be hidden
> side effects (and cancel_hv_timer() is tiny).
> 
>> Cc: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> 
>> ---
>>   arch/x86/kvm/lapic.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>> index 152591f..c0ebef5 100644
>> --- a/arch/x86/kvm/lapic.c
>> +++ b/arch/x86/kvm/lapic.c
>> @@ -1913,8 +1913,8 @@ void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu)
>>   	if (!apic->lapic_timer.hv_timer_in_use)
>>   		goto out;
>>   	WARN_ON(rcuwait_active(&vcpu->wait));
>> -	cancel_hv_timer(apic);
>>   	apic_timer_expired(apic, false);
>> +	cancel_hv_timer(apic);
>>   
>>   	if (apic_lvtt_period(apic) && apic->lapic_timer.period) {
>>   		advance_periodic_target_expiration(apic);
>> -- 
>> 2.7.4
>>
> 

Queued, thanks.

Paolo

