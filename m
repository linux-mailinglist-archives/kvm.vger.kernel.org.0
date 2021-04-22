Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0196D367F08
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 12:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235917AbhDVKuM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 06:50:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25799 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235455AbhDVKuJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 06:50:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619088574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cepH4DVmZgMHRHW+WV87UBOsh4wAs3M6NCnks6Bbd8Y=;
        b=I98JjUVOdepGVuTw5k2kwn+qPVr3FMwUfKpN7sa/uylvEkb4Qguhh0AcrwEkB25qrKCtqy
        3jhzFWYhqvfAtY7G2OTleD2xYq5R3uErlTMNMuCRzzWNUKDL+DGH3y/z3+SaJ2tUzIL8Kc
        g1lMhrBf4XRZKDLwzhrbOcssTErDNQQ=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-2bJXaFlmMfWEVmlwf5-fnw-1; Thu, 22 Apr 2021 06:49:32 -0400
X-MC-Unique: 2bJXaFlmMfWEVmlwf5-fnw-1
Received: by mail-ej1-f72.google.com with SMTP id k5-20020a1709061c05b029037cb8a99e03so7010452ejg.16
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 03:49:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=cepH4DVmZgMHRHW+WV87UBOsh4wAs3M6NCnks6Bbd8Y=;
        b=R0CLLCpquj0bc9q1YH5V0UOgpvaJANTLrsg4mbV97WiVX20DejcrJsvkIveD0W500O
         BDDhFVm+NlupFWnGZg4iFz4Hok6gRc2/i41VMmmyDhoJqZaQIimx72KAXd9t/oslPZg6
         XqQP97zXKYdeU06LYcHTDsD08GD07+tNuLdjHY99DE9zS7OdN7qgwK2GHfi8r5ylJz3d
         ATpeqHQ0xleHuhfzf59eNVbzABCGRlr8Kf/T1zEFB0SW9+JkxNiKYU4YiI6cgbGlbqq9
         idegs43RDFn5Og2uyDfl530cvdgwv9v6WarqnUEedgA5Xv+3FNBXCnuU4XYSTqiHTK7i
         RmBg==
X-Gm-Message-State: AOAM5319RRyFhIxUBoGhqCe15Xjplff0jruOWk6fWy6cwgnQFymZ2hsH
        tX8R1ZG57+8MmQOloRsk6CT/ljjdvLzbgg/v9IT6tBSSLx7CJF7NIM/rBgAF6T4Q6ndnJC9wODu
        KRYXq1MXfGHr+
X-Received: by 2002:aa7:d9ce:: with SMTP id v14mr3085679eds.110.1619088571579;
        Thu, 22 Apr 2021 03:49:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzLGo5TNn7MXo/voi472GduRwPJLEiKPNQM3olHulqQpsFAmVYDu4AmUn1ZFcytO2+nkGT0YQ==
X-Received: by 2002:aa7:d9ce:: with SMTP id v14mr3085671eds.110.1619088571445;
        Thu, 22 Apr 2021 03:49:31 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id n13sm1598355ejx.27.2021.04.22.03.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 03:49:31 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Babu Moger <babu.moger@amd.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        David Woodhouse <dwmw@amazon.co.uk>
Subject: Re: [PATCH v2 7/9] KVM: x86/xen: Drop RAX[63:32] when processing
 hypercall
In-Reply-To: <2ddcc979-519c-a38c-065f-a9036cc2b58e@redhat.com>
References: <20210422022128.3464144-1-seanjc@google.com>
 <20210422022128.3464144-8-seanjc@google.com>
 <877dkuhcl7.fsf@vitty.brq.redhat.com>
 <2ddcc979-519c-a38c-065f-a9036cc2b58e@redhat.com>
Date:   Thu, 22 Apr 2021 12:49:30 +0200
Message-ID: <874kfyh9vp.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 22/04/21 11:51, Vitaly Kuznetsov wrote:
>> Sean Christopherson <seanjc@google.com> writes:
>> 
>>> Truncate RAX to 32 bits, i.e. consume EAX, when retrieving the hypecall
>>> index for a Xen hypercall.  Per Xen documentation[*], the index is EAX
>>> when the vCPU is not in 64-bit mode.
>>>
>>> [*] http://xenbits.xenproject.org/docs/sphinx-unstable/guest-guide/x86/hypercall-abi.html
>>>
>>> Fixes: 23200b7a30de ("KVM: x86/xen: intercept xen hypercalls if enabled")
>>> Cc: Joao Martins <joao.m.martins@oracle.com>
>>> Cc: David Woodhouse <dwmw@amazon.co.uk>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> ---
>>>   arch/x86/kvm/xen.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
>>> index ae17250e1efe..7f27bb65a572 100644
>>> --- a/arch/x86/kvm/xen.c
>>> +++ b/arch/x86/kvm/xen.c
>>> @@ -673,7 +673,7 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
>>>   	bool longmode;
>>>   	u64 input, params[6];
>>>   
>>> -	input = (u64)kvm_register_read(vcpu, VCPU_REGS_RAX);
>>> +	input = (u64)kvm_register_readl(vcpu, VCPU_REGS_RAX);
>>>   
>>>   	/* Hyper-V hypercalls get bit 31 set in EAX */
>>>   	if ((input & 0x80000000) &&
>> 
>> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> 
>> Alternatively, as a minor optimization, you could've used '!longmode'
>> check below, something like:
>> 
>> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
>> index ae17250e1efe..7df1498d3a41 100644
>> --- a/arch/x86/kvm/xen.c
>> +++ b/arch/x86/kvm/xen.c
>> @@ -682,6 +682,7 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
>>   
>>          longmode = is_64_bit_mode(vcpu);
>>          if (!longmode) {
>> +               input = (u32)input;
>>                  params[0] = (u32)kvm_rbx_read(vcpu);
>>                  params[1] = (u32)kvm_rcx_read(vcpu);
>>                  params[2] = (u32)kvm_rdx_read(vcpu);
>> 
>
> You haven't seen patch 9 yet. :)
>

True; suggestion dismissed :-)

-- 
Vitaly

