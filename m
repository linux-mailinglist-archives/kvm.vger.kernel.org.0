Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61920414D03
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 17:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236422AbhIVPb7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 11:31:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44621 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236395AbhIVPb6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 11:31:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632324628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d3JsLpxzQ+uhSu3TGOCWtptCmz4xP0JT6j/hot5bD5w=;
        b=BwD2cZWvnbp6icZN7rR1YOW2VoSQvSJks460NA1mERvpBB2Lxdjc0Cs69Ap8PpOqVozPdK
        +BwRDIbu31o6pwYCfzb6gRB150ai8nbuUl0Ts4WEgN3E1WVPeETkq4t3/+ZdPchRDun8PG
        n8IMX8Dtj/JMJUbD7PT9SDxmU3JVF7U=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-V0oyaDIyMsSTEcIGk3VDzw-1; Wed, 22 Sep 2021 11:30:27 -0400
X-MC-Unique: V0oyaDIyMsSTEcIGk3VDzw-1
Received: by mail-ed1-f69.google.com with SMTP id c7-20020a05640227c700b003d27f41f1d4so3448832ede.16
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 08:30:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d3JsLpxzQ+uhSu3TGOCWtptCmz4xP0JT6j/hot5bD5w=;
        b=4dUywdODSHCYyZ0/oov3/yI3xwME5kPkGBKV2cj7yVtMypNNxZL/mrCJLbn3f3sxT+
         7d/tj5BJ4WYgJSxvVS2t7HAwIBj2Wn3arpdnTz5zuUD+zQYA2UUYgVs/X1I4FZPNlyq/
         jHdPHHFrvbOoDfIowpO8AjdOcvKToPCR5+506OFiqLDg5uvbEKASQA6QPKewdA2v/EBg
         uwkngslUZ7Je/ZV2Gl/q4b0V+RmbLeQ/tLC+x6Ze1CB9hcdul2MBJuHp64wSRofmfxw9
         pzcgdrLAbjO8TMNuXEvEeGMlx4z7Apkw1Hz3tsghN3E3DikpB97LVpFL2EwZnKHfsiyG
         ZJ/A==
X-Gm-Message-State: AOAM531MWp+3z/I8bIiuAGJVJDRBzfTmdqzwldHDRHr9nIX605mSHweo
        ISTkS4SIz7SvvAkvZ3VCoDZDaJxM+TCtLx9viIdQSNMtGokYRWVYgGp2NuF8knHT67+HhV8O5IQ
        hIPLQ/bVc1ubf
X-Received: by 2002:a50:c31c:: with SMTP id a28mr216091edb.384.1632324625936;
        Wed, 22 Sep 2021 08:30:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw02+/MQdKVUxCJnsyoBcCJU+R107o2lVynj8H1Ua46GB1mUTBMgqeB9rChSSQAr9JrISxe/g==
X-Received: by 2002:a50:c31c:: with SMTP id a28mr216042edb.384.1632324625725;
        Wed, 22 Sep 2021 08:30:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id n13sm1186280ejk.97.2021.09.22.08.30.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 08:30:25 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: Add AMD PMU MSRs to msrs_to_save_all[]
To:     Fares Mehanna <faresx@amazon.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210915133951.22389-1-faresx@amazon.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3932c56b-a12a-904d-b727-1dad2b1d35b1@redhat.com>
Date:   Wed, 22 Sep 2021 17:30:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210915133951.22389-1-faresx@amazon.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/09/21 15:39, Fares Mehanna wrote:
> Intel PMU MSRs is in msrs_to_save_all[], so add AMD PMU MSRs to have a
> consistent behavior between Intel and AMD when using KVM_GET_MSRS,
> KVM_SET_MSRS or KVM_GET_MSR_INDEX_LIST.
> 
> We have to add legacy and new MSRs to handle guests running without
> X86_FEATURE_PERFCTR_CORE.
> 
> Signed-off-by: Fares Mehanna <faresx@amazon.de>
> ---
>   arch/x86/kvm/x86.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 28ef14155726..14bc21fb698c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1332,6 +1332,13 @@ static const u32 msrs_to_save_all[] = {
>   	MSR_ARCH_PERFMON_EVENTSEL0 + 12, MSR_ARCH_PERFMON_EVENTSEL0 + 13,
>   	MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 + 15,
>   	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
> +
> +	MSR_K7_EVNTSEL0, MSR_K7_EVNTSEL1, MSR_K7_EVNTSEL2, MSR_K7_EVNTSEL3,
> +	MSR_K7_PERFCTR0, MSR_K7_PERFCTR1, MSR_K7_PERFCTR2, MSR_K7_PERFCTR3,
> +	MSR_F15H_PERF_CTL0, MSR_F15H_PERF_CTL1, MSR_F15H_PERF_CTL2,
> +	MSR_F15H_PERF_CTL3, MSR_F15H_PERF_CTL4, MSR_F15H_PERF_CTL5,
> +	MSR_F15H_PERF_CTR0, MSR_F15H_PERF_CTR1, MSR_F15H_PERF_CTR2,
> +	MSR_F15H_PERF_CTR3, MSR_F15H_PERF_CTR4, MSR_F15H_PERF_CTR5,
>   };
>   
>   static u32 msrs_to_save[ARRAY_SIZE(msrs_to_save_all)];
> 

Queued, thanks.

Paolo

