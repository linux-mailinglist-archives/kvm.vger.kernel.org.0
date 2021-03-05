Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD2432EC28
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 14:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhCENax (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 08:30:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25284 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229578AbhCENag (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Mar 2021 08:30:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614951036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9OVHV4aIQmKNqeY5ezSY/nhnAn51P/hCc3Ft8x+FhLo=;
        b=UrU4L3+jqyfBm4qaZaXMMQqBCT4NiDm03UVWL7dXUll6Ngq/luBdQEeyeP5O4R3ULdn5kS
        ZJIr5+vwNX1pKCmyAr2FjMxjcbiqN+zptsHLaWEId1MoDY6obu+NC4Qmb1ZPYOUVBiarr2
        +idtafNCTu7rCKD/oWFr8oGlw3T63dM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-VSCuSniBNrSU8Evi_EcnPw-1; Fri, 05 Mar 2021 08:30:34 -0500
X-MC-Unique: VSCuSniBNrSU8Evi_EcnPw-1
Received: by mail-wr1-f72.google.com with SMTP id e7so1064227wrw.18
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 05:30:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9OVHV4aIQmKNqeY5ezSY/nhnAn51P/hCc3Ft8x+FhLo=;
        b=oMvwp5rIjGpjjG4eEYNpCviBpbzFQhbASUkpKt2+JJf0sg+RXZ1mYJjFLKONBLNwt1
         5iDddc9mVP/mdAkuY9mVWt/mq1UecHiKfHHoOkNYsSLjPGiMgeANneXYhIeQuQhgABIH
         u8+hePztrlvfqr4MsyvPAdOC9ewoZolQwe2b1XPPC0b/pl951lvsSRn78DY3wmGVrGn0
         VkYBQJ6ohMmhahr0FvAbmGtDcVQ6gNXIg6njEtTj/yQ/N6CKX2aGkvTjlPsQaTJOwNMy
         TwMAF9hprZ5QHn/EgcN554LFN+XmgLw9U60TeZrcoHiZSnH5dE3obvSDkJdkpFzDbGz7
         EE/Q==
X-Gm-Message-State: AOAM533t1fmcUGI/1tsyqpTuWdoloC1tA98knjCzzuLFyip9oxsfwQdB
        zVC3+vrBx2TX/hy/fVYEaD/UWlrMHLq/Ot/1Er+XEEzd4bAFSE3x/giVREq/OTAJt/sbNqlmQY0
        lO26u2M/A/5EE
X-Received: by 2002:adf:e60a:: with SMTP id p10mr9547397wrm.291.1614951033444;
        Fri, 05 Mar 2021 05:30:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyfX3peT48F2IQbl9b6JeiTlNsj3AGM3VcOscIAYNSwLFSm2QijPFI0U/uwZeXwlo954oRwkQ==
X-Received: by 2002:adf:e60a:: with SMTP id p10mr9547380wrm.291.1614951033305;
        Fri, 05 Mar 2021 05:30:33 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j125sm4445967wmb.44.2021.03.05.05.30.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Mar 2021 05:30:32 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: Ensure deadline timer has truly expired before
 posting its IRQ
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210305021808.3769732-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <27bc885c-e257-3353-6146-15fdd40f5d4c@redhat.com>
Date:   Fri, 5 Mar 2021 14:30:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210305021808.3769732-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/03/21 03:18, Sean Christopherson wrote:
> When posting a deadline timer interrupt, open code the checks guarding
> __kvm_wait_lapic_expire() in order to skip the lapic_timer_int_injected()
> check in kvm_wait_lapic_expire().  The injection check will always fail
> since the interrupt has not yet be injected.  Moving the call after
> injection would also be wrong as that wouldn't actually delay delivery
> of the IRQ if it is indeed sent via posted interrupt.
> 
> Fixes: 010fd37fddf6 ("KVM: LAPIC: Reduce world switch latency caused by timer_advance_ns")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/lapic.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 45d40bfacb7c..cb8ebfaccfb6 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1642,7 +1642,16 @@ static void apic_timer_expired(struct kvm_lapic *apic, bool from_timer_fn)
>   	}
>   
>   	if (kvm_use_posted_timer_interrupt(apic->vcpu)) {
> -		kvm_wait_lapic_expire(vcpu);
> +		/*
> +		 * Ensure the guest's timer has truly expired before posting an
> +		 * interrupt.  Open code the relevant checks to avoid querying
> +		 * lapic_timer_int_injected(), which will be false since the
> +		 * interrupt isn't yet injected.  Waiting until after injecting
> +		 * is not an option since that won't help a posted interrupt.
> +		 */
> +		if (vcpu->arch.apic->lapic_timer.expired_tscdeadline &&
> +		    vcpu->arch.apic->lapic_timer.timer_advance_ns)
> +			__kvm_wait_lapic_expire(vcpu);
>   		kvm_apic_inject_pending_timer_irqs(apic);
>   		return;
>   	}
> 

Queued, thanks.

Paolo

