Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 345BE3ABBC1
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 20:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbhFQS2z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 14:28:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30899 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232146AbhFQS22 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Jun 2021 14:28:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623954380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XvRDiOu3L2aDPvixr4wW0PI+YISrBEUZXNM7z6Kd0Ug=;
        b=A9MOAYskcWqQSre+6cq8wnuNwFPYM6ED5LYWLQ19t5PjlBirDRHIrzL5pVoElTz5AH9sIq
        ml6ZlhumE2kr5wEqlBMmeCKNlcSwCb/HxAcs3IdEsNDt35X67rhOKpgCwyyMvBKmHYNboK
        KveFczViWaqpD7aMC8PlTdpVu8uuxK4=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-ZoBKr1WFPR65ZL76r-xccA-1; Thu, 17 Jun 2021 14:26:18 -0400
X-MC-Unique: ZoBKr1WFPR65ZL76r-xccA-1
Received: by mail-ej1-f71.google.com with SMTP id u4-20020a1709061244b02904648b302151so2776715eja.17
        for <kvm@vger.kernel.org>; Thu, 17 Jun 2021 11:26:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XvRDiOu3L2aDPvixr4wW0PI+YISrBEUZXNM7z6Kd0Ug=;
        b=askxlr1aOg3+FztHg+xR84arijuDVjuIiekAvIInFuox4LVcBg6hZac1dtISl7eb9u
         oyeCcNSIvkSfGqaso869w/ZBXVmxqe6vV0KyisFPjhJRF22Lp8UsqEcpFuxKDT/dAmYU
         9n7L+NWBBFIQwzB8jgb92GtFJ0JMzcDHSU8ecFlCInSu+/TemJ0QhMfiMNS/MH2/bVLV
         VKaxzh6X4rKylusYApl8oJMX3m2MYAFwQX23PYk08aRr0rFqZXGIhnQ0LgniXCFQ0CNg
         6qN36Tu3nDd3GeCPzDpUsAmFLiMemoDieN2kLskUgFXiWM0SZccwnWK5QgyF3Yg16Oze
         R0TA==
X-Gm-Message-State: AOAM530d0z8vvoO0sK4pBE33mv4+lbABkpVVRBWz1cUvVQ4qwBReUenO
        Zc/bq1/mT3P2a+SVw6U46ITkBSQ0VUSU2wyhp06XKzJuED2KyMcaECXglhFj2e0vNgGK52MAOjj
        lKMBJRYwTBujO
X-Received: by 2002:a05:6402:31f3:: with SMTP id dy19mr8407674edb.153.1623954377523;
        Thu, 17 Jun 2021 11:26:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwHC/0zrifPDrAWmAlm02JHo9HIKYIOLCBfKF2EIzEF/aYCysomV9DjE4RzUEhNqpvTWbYIiA==
X-Received: by 2002:a05:6402:31f3:: with SMTP id dy19mr8407653edb.153.1623954377328;
        Thu, 17 Jun 2021 11:26:17 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u21sm4202016eja.59.2021.06.17.11.26.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jun 2021 11:26:16 -0700 (PDT)
Subject: Re: [PATCH v3] KVM: LAPIC: Keep stored TMCCT register value 0 after
 KVM_SET_LAPIC
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1623223000-18116-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <02391363-6713-1548-fa4b-70b70cc96f79@redhat.com>
Date:   Thu, 17 Jun 2021 20:26:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <1623223000-18116-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/06/21 09:16, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> KVM_GET_LAPIC stores the current value of TMCCT and KVM_SET_LAPIC's memcpy
> stores it in vcpu->arch.apic->regs, KVM_SET_LAPIC could store zero in
> vcpu->arch.apic->regs after it uses it, and then the stored value would
> always be zero. In addition, the TMCCT is always computed on-demand and
> never directly readable.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>   arch/x86/kvm/lapic.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 6d72d8f43310..9bd29b3ca790 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2628,6 +2628,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
>   	apic_manage_nmi_watchdog(apic, kvm_lapic_get_reg(apic, APIC_LVT0));
>   	update_divide_count(apic);
>   	__start_apic_timer(apic, APIC_TMCCT);
> +	kvm_lapic_set_reg(apic, APIC_TMCCT, 0);
>   	kvm_apic_update_apicv(vcpu);
>   	apic->highest_isr_cache = -1;
>   	if (vcpu->arch.apicv_active) {
> 

Queued, thanks.

Paolo

