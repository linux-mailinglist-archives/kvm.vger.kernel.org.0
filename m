Return-Path: <kvm+bounces-44828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DC4F2AA3AE3
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 00:02:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4986C1BC0C4D
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 22:02:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AE5725A2B3;
	Tue, 29 Apr 2025 22:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gBOmwfwg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A4A214234
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 22:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745964157; cv=none; b=hJthDY8Wj2AuO1N10MTlLrfW/aL4se8hYtn1B602Mk89wJFwdshUomVs09gC7Gg0XAMopIj4a5MsNFPiQd0LXUzvPi941IByMg81TxLthL5gwdfqy8ZEXmwrJ3pSWC62XvigIeNiOIg8uMM+iSwhHr5BdOUwQzo207GjfltIBsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745964157; c=relaxed/simple;
	bh=CbJGi4aqf7+miBfxf+olLu9mBMrPmygkK+bymfYm6qU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Z+t7koYmqGyAYNZms4VeC2yL/2yYBEQcDEGyUI6WgKCQ+Tdgm0TBfGuf1PvW1dbYF9/Gy+C32HwHyO1VjwSyECxIOm7OG8f7aFR12d2cxfqgNeNdSCtfMAkOi2pYv8+zyaU7iyihFocKzxVw1ZY4kwqBTx+w3n5lCU/CuHlZv94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gBOmwfwg; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-736c062b1f5so5631532b3a.0
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 15:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745964155; x=1746568955; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=673vfcXckcwVgxogLtZYHU/ZF/jsaUBLKWNXQ1xE/GA=;
        b=gBOmwfwggLAuB7m8W0BYPZYdH4MWoH0eHYbwgEBVvQviD7fighZvQbMSPqTmEK5E2O
         nU/6CMWUl3NGJEPV2t3ve9jeV1bOTd+9gpib6dUytplRNcDsozB4MdOVK/0NiV93VoGp
         w3tYndvVN0KOVKOI0pneZLImNHmrmIBa1tolgEtUkkX/2eBXAon4GrSGD4prODQ0N7s1
         RhIUWL1yX87NT4+yfj+/BXmLfvZhFUS/gd6WxJn0QV9nh1YQ1GEUBJhi5Y5zZ9rpsMJx
         IFjrOU5/drpC/rvmsrA/sZLq+CNebhaAksEZiyFJkF9Pj6Cel9Amq1fFgJqf8qZ1dhSK
         g4wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745964155; x=1746568955;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=673vfcXckcwVgxogLtZYHU/ZF/jsaUBLKWNXQ1xE/GA=;
        b=j0xtbfcod8Y3E/Ece73VHaMkl4+zm+uJPK8F8BkRG+bOUBkRocGeqyisRkm16UNzsZ
         DZjPWGf2RVn+Zwqj0EKGP8/iZf1pCsjkoceNOQdIsV0YsxHjF2Ib3m7w3G4tjDvISOyo
         iS5e/tVF3MBJGr57p6vPcQMqOIylpgUgJ55QmQYK2yM5vbZ0+cTohakVYvm/A0h9fQFz
         gXYhMI74NcFYBkln8xgIqfIcEAbyz4m/ENaWd2ECdiagBwGmj4JCSLUiun6IOvr3rKlN
         IsFh4HeFDxMTwjTOGzPOChFxxeUjpCpg7TyOlx9w8EDztlKc1Q21kG9Vxxwv4p+V/erV
         eWbQ==
X-Forwarded-Encrypted: i=1; AJvYcCUFV7sOEoSrm4gGJ+qIkcLnP9b554Cbbug9kmf5MpySA5Kr1D83rZUOQkOyOx0A0Rpx77k=@vger.kernel.org
X-Gm-Message-State: AOJu0YwI1SAGDbAdGOUOGoFK4TtlV1xUHhlIkTiRGc4o+4IAJmxP13j3
	XG/zbIi+uIHY4ctS6RAJ6hDHFje70mBlBrDfzb/XNlAsrhhJzPX+28T6O5mriKE=
X-Gm-Gg: ASbGncuDkNgwf2iqwVVMd+UnCWfcmSAK58bxTjulj3OSoLgXV+/ihbl4Tj6h0gfRIUl
	XsFvtoMLQppxhW+EURFuUXPOakYUUHwwF1yuiMHp9m0A+98wwV7sgeP+k/J7ODs7vJBSxUpqGyH
	mrjnVfXe+ysNnIrShzFwh8MpMRGd1T4q4Ar9WINHw0G+mcTe8u1tx80+Gn16Gou5eP6de0rkNmk
	F5qOcMdlDrhK5UAwzTvomEOkjDRgaz4Br5vAb2SAkfgYP7pLHAYrap0A1K8WpAFTnqE5nyxlN6P
	74nnseJ06rKgj/BV4Pc8gioRa1K5qaP0FrtpQLnnWsXT/pyARb/Gpw==
X-Google-Smtp-Source: AGHT+IHGsu3aaaZ8AgfQnKJoDLS8J+k1ti2SO5D4FRDqu2askuRacbj0XulqEPxKT1UI/1sN+VOcPg==
X-Received: by 2002:a05:6a00:3981:b0:737:6d4b:f5f8 with SMTP id d2e1a72fcca58-74038a67154mr1037049b3a.17.1745964155371;
        Tue, 29 Apr 2025 15:02:35 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74039a5c376sm197194b3a.129.2025.04.29.15.02.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Apr 2025 15:02:34 -0700 (PDT)
Message-ID: <b044596b-46a0-47ca-a1f0-61160c59efc9@linaro.org>
Date: Tue, 29 Apr 2025 15:02:34 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/13] target/arm/kvm_arm: copy definitions from kvm
 headers
Content-Language: en-US
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-arm@nongnu.org, anjo@rev.ng, richard.henderson@linaro.org
References: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
 <20250429050010.971128-6-pierrick.bouvier@linaro.org>
 <87msbz45y6.fsf@draig.linaro.org>
 <d455055c-a13b-4e00-b921-5ede2be08e89@linaro.org>
In-Reply-To: <d455055c-a13b-4e00-b921-5ede2be08e89@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/29/25 2:14 PM, Pierrick Bouvier wrote:
> On 4/29/25 3:28 AM, Alex Bennée wrote:
>> Pierrick Bouvier <pierrick.bouvier@linaro.org> writes:
>>
>>> "linux/kvm.h" is not included for code compiled without
>>> COMPILING_PER_TARGET, and headers are different depending architecture
>>> (arm, arm64).
>>> Thus we need to manually expose some definitions that will
>>> be used by target/arm, ensuring they are the same for arm amd aarch64.
>>>
>>> As well, we must but prudent to not redefine things if code is already
>>> including linux/kvm.h, thus the #ifndef COMPILING_PER_TARGET guard.
>>>
>>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>>> ---
>>>    target/arm/kvm_arm.h | 15 +++++++++++++++
>>>    1 file changed, 15 insertions(+)
>>>
>>> diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
>>> index c8ddf8beb2e..eedd081064c 100644
>>> --- a/target/arm/kvm_arm.h
>>> +++ b/target/arm/kvm_arm.h
>>> @@ -16,6 +16,21 @@
>>>    #define KVM_ARM_VGIC_V2   (1 << 0)
>>>    #define KVM_ARM_VGIC_V3   (1 << 1)
>>>    
>>> +#ifndef COMPILING_PER_TARGET
>>> +
>>> +/* we copy those definitions from asm-arm and asm-aarch64, as they are the same
>>> + * for both architectures */
>>> +#define KVM_ARM_IRQ_CPU_IRQ 0
>>> +#define KVM_ARM_IRQ_CPU_FIQ 1
>>> +#define KVM_ARM_IRQ_TYPE_CPU 0
>>> +typedef unsigned int __u32;
>>> +struct kvm_vcpu_init {
>>> +    __u32 target;
>>> +    __u32 features[7];
>>> +};
>>> +
>>> +#endif /* COMPILING_PER_TARGET */
>>> +
>>
>> I'm not keen on the duplication. It seems to be the only reason we have
>> struct kvm_vcpu_init is for kvm_arm_create_scratch_host_vcpu() where the
>> only *external* user passes in a NULL.
>>
> 
> I'm not keen about it either, so thanks for pointing it.
> 
>> If kvm_arm_create_scratch_host_vcpu() is made internal static to
>> target/arm/kvm.c which will should always include the real linux headers
>> you just need a QMP helper.
>>
> 
> Yes, sounds like the good approach! Thanks.
>

Alas this function is used in target/arm/arm-qmp-cmds.c, and if we move 
the code using it, it pulls QAPI, which is target dependent at this time.

Since struct kvm_vcpu_init is only used by pointer, I could workaround 
this by doing a simple forward declaration in kvm_arm.h.

>> For the IRQ types is this just a sign of target/arm/cpu.c needing
>> splitting into TCG and KVM bits?
>>
> 
> I'll move relevant functions to target/arm/kvm.c, so cpu.c can be
> isolated from this.
> 
>>
>>>    /**
>>>     * kvm_arm_register_device:
>>>     * @mr: memory region for this device
>>
> 


