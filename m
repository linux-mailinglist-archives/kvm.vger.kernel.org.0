Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540BA34EF11
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 19:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbhC3RLH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 13:11:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57107 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232457AbhC3RKg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 13:10:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617124235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TFwpUnq0kgwILzToS/wJKW9SoXVCyZoJNsli3PBlunY=;
        b=caJq9TQ2Oail/mJ+rKZG1Jr6kNaAAEZ54nR2ZMXsPkBw+KcjizkWq9a+5YBueNmlvkiyRt
        1lPNKgflY2PzeNHQ14ndERzBbkAyCiFmEi1GESt0wy05ohv4nT4icvzplecD4zdZIkPy3/
        ke1RFoZ/zThX4NTGvkI92LDjP3QDgao=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-Vdai6b6BMduD4korod21Gw-1; Tue, 30 Mar 2021 13:10:33 -0400
X-MC-Unique: Vdai6b6BMduD4korod21Gw-1
Received: by mail-wm1-f70.google.com with SMTP id n2so941265wmi.2
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 10:10:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TFwpUnq0kgwILzToS/wJKW9SoXVCyZoJNsli3PBlunY=;
        b=i2dSA14u7KtKnVcFVaQ7RnJNk+3YGkoKvMhh8zrQZeNcrmEv2kupeFQJk6igb8Scsy
         05Fry62UU7q7AN3yI3oooAZrMrULAF1RfBrYeU+e/gCEzxfJyZW+jM0vKFTzMBhIBn+i
         i/vBmSTbf9X6fH2xLwiN1Tg/jBJlgdakVtVqY4AlKoO50PAJjB1f3QFExDle4kaxVHuq
         y0y9ZtAeFP52gpAx+hmRDww3kMO8Whtfs0w/ys+t4UrWmQCQ9NAUatwBbGGxZobjxn5i
         W41qHKlsKM5Q/iW7z0IuskrnccLak6M8gFJz+wdfK9U+6uWoKIeT8E0nm5wePsw85+z7
         quOw==
X-Gm-Message-State: AOAM530wtAsA/ucJsFKUpxkFBfXy2w7JRUJokbk9ezvrk/OmtQy/Rd0T
        2R7PNgNFG5Y6fjJmXi9Nj3nP/QJy7ZsmIbrbMN2a1cUt2x4nR5cGv87FBVtiejtVuNyi/KZWX7D
        CbuRnKqqkDf4a
X-Received: by 2002:a05:6000:137b:: with SMTP id q27mr35532649wrz.168.1617124232330;
        Tue, 30 Mar 2021 10:10:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxOgnSwZvnObko157H9qbs/TyqT9KDVWZzR1c4S8s6PgUCi55KDyUl1kb6x5OBQfTUDfoLc+Q==
X-Received: by 2002:a05:6000:137b:: with SMTP id q27mr35532629wrz.168.1617124232156;
        Tue, 30 Mar 2021 10:10:32 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id 21sm4679202wme.6.2021.03.30.10.10.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Mar 2021 10:10:31 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86/vPMU: Forbid reading from MSR_F15H_PERF MSRs
 when guest doesn't have X86_FEATURE_PERFCTR_CORE
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Wei Huang <wei.huang2@amd.com>, Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei.kernel@gmail.com>,
        linux-kernel@vger.kernel.org
References: <20210329124804.170173-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3a741047-48a7-ee72-27ec-f83b0b7669f6@redhat.com>
Date:   Tue, 30 Mar 2021 19:10:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210329124804.170173-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/03/21 14:48, Vitaly Kuznetsov wrote:
> MSR_F15H_PERF_CTL0-5, MSR_F15H_PERF_CTR0-5 MSRs have a CPUID bit assigned
> to them (X86_FEATURE_PERFCTR_CORE) and when it wasn't exposed to the guest
> the correct behavior is to inject #GP an not just return zero.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>   arch/x86/kvm/x86.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fe806e894212..125453155ede 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3381,6 +3381,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		msr_info->data = 0;
>   		break;
>   	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
> +		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
> +			return kvm_pmu_get_msr(vcpu, msr_info);
> +		if (!msr_info->host_initiated)
> +			return 1;
> +		msr_info->data = 0;
> +		break;
>   	case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL3:
>   	case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
>   	case MSR_P6_PERFCTR0 ... MSR_P6_PERFCTR1:
> 

Queued to kvm/next, thanks (the write side goes to kvm/master instead).

Paolo

