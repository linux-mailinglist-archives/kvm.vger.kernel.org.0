Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F0D367EBA
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 12:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235906AbhDVKgV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 06:36:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29188 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235810AbhDVKgT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 06:36:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619087744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LdfhyPjzl93I4RQH6K4cW6ygLnYx8XGst7dOo3yXFqo=;
        b=QJPj21e1r0VDcrqNgLWID3R8mn/Yub+veJUT6B8/uijPt3+tH5IFozGq4VqMYwAXwEJybV
        vo7j11D+tObtKvrHf3W6Al6juqlx0JaeljkbZr1kat48DHnzpi7m/FLmJmXEdkB2QGUTOC
        EVQIKGmvM+DT0ImV6/30zZFps8hT9Uk=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-YAVaBB_4M0-Xw_joTK77yA-1; Thu, 22 Apr 2021 06:35:10 -0400
X-MC-Unique: YAVaBB_4M0-Xw_joTK77yA-1
Received: by mail-ed1-f72.google.com with SMTP id r4-20020a0564022344b0290382ce72b7f9so16497852eda.19
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 03:35:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LdfhyPjzl93I4RQH6K4cW6ygLnYx8XGst7dOo3yXFqo=;
        b=cBA+naNZ9F5ebjziR9M6Ptmhwkve8w5tHrdoP9bLW0uhDrBIqlfiak0de0a28HoPuV
         K5sKN9wOgGTeHbcEQJZxTevIxAW9Yu8l0tVoMWgoDKBTc9Q2pUZ6j5kRIxKkoOvGbEHA
         B3d9byvB8dm+vCtCHUb61cnuZRw1kc5pmNNSgb2zZx5KZUgfxYFEQ2uWFOjv63zt3cwB
         qYP0mu44dHhgAsUUcKLL1AKzhed5fR0Pqvm4Q0N4HLG/RQO4yqwWduSZ8JiMCeDsc8dx
         UAw8UI/UWQUxahHxdMuLmrpoVZiu2Dows5JoIis6Iigq9y3ls7x1KmoPGeS66RDQoOlZ
         GMjw==
X-Gm-Message-State: AOAM530lWJsKw1Ia4VfdI8UCGf6xv6Xga5PVieutCvgQDDAVz4p4VtnH
        lksQaS4BAEaZm0xRVzz72/tzG5Io9RMSL5rXeEaD3FsjysA8ROGfij/hk7yhz1cwsRUczl8NNdr
        Vuzj5/DpvTIjP
X-Received: by 2002:a17:906:5487:: with SMTP id r7mr2693767ejo.550.1619087708899;
        Thu, 22 Apr 2021 03:35:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxOYCcXJDqdwFM+0LB++LtNM+KTanbcqcjFE3HE+WxK++ywXbUncB4GYd3RidtLudCQz//cYA==
X-Received: by 2002:a17:906:5487:: with SMTP id r7mr2693756ejo.550.1619087708767;
        Thu, 22 Apr 2021 03:35:08 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id c13sm1768536edw.88.2021.04.22.03.35.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 03:35:07 -0700 (PDT)
Subject: Re: [PATCH v2 7/9] KVM: x86/xen: Drop RAX[63:32] when processing
 hypercall
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Babu Moger <babu.moger@amd.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        David Woodhouse <dwmw@amazon.co.uk>
References: <20210422022128.3464144-1-seanjc@google.com>
 <20210422022128.3464144-8-seanjc@google.com>
 <877dkuhcl7.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2ddcc979-519c-a38c-065f-a9036cc2b58e@redhat.com>
Date:   Thu, 22 Apr 2021 12:35:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <877dkuhcl7.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/04/21 11:51, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
>> Truncate RAX to 32 bits, i.e. consume EAX, when retrieving the hypecall
>> index for a Xen hypercall.  Per Xen documentation[*], the index is EAX
>> when the vCPU is not in 64-bit mode.
>>
>> [*] http://xenbits.xenproject.org/docs/sphinx-unstable/guest-guide/x86/hypercall-abi.html
>>
>> Fixes: 23200b7a30de ("KVM: x86/xen: intercept xen hypercalls if enabled")
>> Cc: Joao Martins <joao.m.martins@oracle.com>
>> Cc: David Woodhouse <dwmw@amazon.co.uk>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
>>   arch/x86/kvm/xen.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
>> index ae17250e1efe..7f27bb65a572 100644
>> --- a/arch/x86/kvm/xen.c
>> +++ b/arch/x86/kvm/xen.c
>> @@ -673,7 +673,7 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
>>   	bool longmode;
>>   	u64 input, params[6];
>>   
>> -	input = (u64)kvm_register_read(vcpu, VCPU_REGS_RAX);
>> +	input = (u64)kvm_register_readl(vcpu, VCPU_REGS_RAX);
>>   
>>   	/* Hyper-V hypercalls get bit 31 set in EAX */
>>   	if ((input & 0x80000000) &&
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> Alternatively, as a minor optimization, you could've used '!longmode'
> check below, something like:
> 
> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index ae17250e1efe..7df1498d3a41 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -682,6 +682,7 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
>   
>          longmode = is_64_bit_mode(vcpu);
>          if (!longmode) {
> +               input = (u32)input;
>                  params[0] = (u32)kvm_rbx_read(vcpu);
>                  params[1] = (u32)kvm_rcx_read(vcpu);
>                  params[2] = (u32)kvm_rdx_read(vcpu);
> 

You haven't seen patch 9 yet. :)

Paolo

