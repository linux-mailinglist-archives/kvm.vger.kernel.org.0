Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD7849794F
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 08:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241520AbiAXHSC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 02:18:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232558AbiAXHSB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 02:18:01 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8D6C06173B;
        Sun, 23 Jan 2022 23:18:01 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id d18so1958354plg.2;
        Sun, 23 Jan 2022 23:18:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=TJe7v+cpeA/AbZQEDvwzWvMztqsmrrZnwzLc62/U118=;
        b=hF79jafzLTMGkrxZKntZTXWpXzRn4yHGBCrDn/6pF5SFnJUVKNAGeh1+sCaFcGLF0e
         Brm57BqT7JnL7ibA7zeI0fJ73/rymWR57kH4DV46a/d/mEqaq346nknPUNWy3YNaupFe
         euskkMKcRqnhn0PwXrL/ibFon5OA1xQKmhTMauLOHP2QD8YCBhamrfa8LwnMUa12fwH2
         lfFrA22CHEknhY2IYiflSjcjFSXCpXo529uO7n4BClhmcUTbaZ+6LV6DyX8N3OvoUAHB
         3xuZRv7Zg47ful6f0RrYWeInvtYZFfuSA8/MnszJWU3gm6s2xt2eqfeEOkI+E8te8Q+s
         Traw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=TJe7v+cpeA/AbZQEDvwzWvMztqsmrrZnwzLc62/U118=;
        b=ZiV6f18i2xsXy18B3iDkEdux8PeAhSuQLLWvLHs3kFhsop+gjfq9S69HZftVIj6vVz
         0m/CbXVtQO1jnY3MTict+UosHg/FPskNJkEn6YxRgevX4tOm39DGgEXUP0rOvNm7tB1u
         ksgDZx3Z3aFLaVbUX54TF2VrXCYhABbzdODOQYTV+83/pjRcacqVl2evDIiGB9C0Et8Y
         DQTT36ZLLjtX/QLxaDoAZgPKJGAAR8ztCwXvDc6FE7/Fmtwrya2j+jhkhI6PsK3lmuOc
         hSkEi888s7MdeojPGJ1SsKXyUdBbG5413kFR/VRtzlwbOTKlMZcr5H2BYDAP0jw9CWMR
         ySuw==
X-Gm-Message-State: AOAM532LKWP8x4opsYC+NxQt249aHq4uplsn7P7aOrS8ARZSJk0L+O8E
        zPzjXCk1yuyT7VwLMaaNUD8=
X-Google-Smtp-Source: ABdhPJzdDM3eih4VGw2JKXNbohcb/vgY/zRFNuULEsTG4ijJ895Ic5esno2Gk5ywZTNWO1r90snUXQ==
X-Received: by 2002:a17:903:2287:b0:149:fa57:ea87 with SMTP id b7-20020a170903228700b00149fa57ea87mr13427034plh.94.1643008681295;
        Sun, 23 Jan 2022 23:18:01 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 189sm3540196pfg.142.2022.01.23.23.17.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Jan 2022 23:18:01 -0800 (PST)
Message-ID: <38c1fbc3-d770-48f3-5432-8fa1fde033f5@gmail.com>
Date:   Mon, 24 Jan 2022 15:17:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH] KVM: x86/cpuid: Exclude unpermitted xfeatures for
 vcpu->arch.guest_supported_xcr0
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Liu, Jing2" <jing2.liu@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220123055025.81342-1-likexu@tencent.com>
 <BN9PR11MB52762E2DEF810DF9AFAE1DDC8C5E9@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <BN9PR11MB52762E2DEF810DF9AFAE1DDC8C5E9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/1/2022 3:06 pm, Tian, Kevin wrote:
>> From: Like Xu <like.xu.linux@gmail.com>
>> Sent: Sunday, January 23, 2022 1:50 PM
>>
>> From: Like Xu <likexu@tencent.com>
>>
>> A malicious user space can bypass xstate_get_guest_group_perm() in the
>> KVM_GET_SUPPORTED_CPUID mechanism and obtain unpermitted xfeatures,
>> since the validity check of xcr0 depends only on guest_supported_xcr0.
> 
> Unpermitted xfeatures cannot pass kvm_check_cpuid()...

Indeed, 5ab2f45bba4894a0db4af8567da3efd6228dd010.

This part of logic is pretty fragile and fragmented due to semantic
inconsistencies between supported_xcr0 and guest_supported_xcr0
in other three places:

- __do_cpuid_func
- kvm_mpx_supported
- kvm_vcpu_ioctl_x86_set_xsave

Have you identified all their areas of use ?

> 
>>
>> Fixes: 445ecdf79be0 ("kvm: x86: Exclude unpermitted xfeatures at
>> KVM_GET_SUPPORTED_CPUID")
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   arch/x86/kvm/cpuid.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 3902c28fb6cb..1bd4d560cbdd 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -266,7 +266,8 @@ static void kvm_vcpu_after_set_cpuid(struct
>> kvm_vcpu *vcpu)
>>   		vcpu->arch.guest_supported_xcr0 = 0;
>>   	else
>>   		vcpu->arch.guest_supported_xcr0 =
>> -			(best->eax | ((u64)best->edx << 32)) &
>> supported_xcr0;
>> +			(best->eax | ((u64)best->edx << 32)) &
>> +			(supported_xcr0 & xstate_get_guest_group_perm());
>>
>>   	/*
>>   	 * Bits 127:0 of the allowed SECS.ATTRIBUTES (CPUID.0x12.0x1)
>> enumerate
>> --
>> 2.33.1
> 
