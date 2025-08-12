Return-Path: <kvm+bounces-54498-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F460B21DDA
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 08:04:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 20EB616BE63
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 06:03:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25B372D8781;
	Tue, 12 Aug 2025 06:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mliuTlzJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8DC23A9AD
	for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 06:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754978600; cv=none; b=ig+riGwrNR+qVkHZ64P/hpkIMYgWmIA3j6YJOXgQTSMtCN8WHUnBBSE67Vh9w90+YWHz5LUeQDNaPWn8EDs5MLMlo/Arjc7YStOVeE83rmInF4wz+ULsegq035UXvkJWlC/hUaeaFUqt1A3d8iuKToo2xxfFhqtppj5NxHLSx4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754978600; c=relaxed/simple;
	bh=/T5hSSFMM3zI9qFANXUrtgjqf3+gG+d+2/q1sXWxauI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=JjVjSYSpt8jTiJh0af5t4QLlVb6MHGFjbf87APWtLuk+80nfCeKmkQVEAZKpT4kOUdSd0f4ZP8iI0eVervN/oa0iJsk+QhoX17kj6R5agrQpfKIb7roSlaCxdnwiZLFFthi1vQG1zPNQ0pTkKancKgQv4DJBLN4osbxfohwX0zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mliuTlzJ; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3b8de6f7556so2834211f8f.1
        for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 23:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754978596; x=1755583396; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=M9B3gMOvx4Se5alAYaJcB7wUIjvXYmRszTA8lXpOl7M=;
        b=mliuTlzJPHqtTbIW1Ph9QnZfDlVBNe2M8dh7qu3r5aSzFbPs0p47V2tqfZo7rnGMp+
         EOznhK+XGKI+L9lZ/xkkO7eSlhnD6/s+pa3a0ukMfBt/KkBqzEXsfbsBHghlqVc6AMrJ
         e0id/Lq5HhE/yBIQh7Wbvx+d1Z+Lg0WoUF2H2iYUFo4eBwzQKeuqxyAFAuGJRX8Xj+J4
         8V0JTb2+yvZdc4j3aandtWHYDQCZoQauOib2ABsknvXKIv4RQWENFknwxRz/wqhwrLgi
         KLhf/5O71w1uliLIfXRdaqqSq2gGK3JcMWQ+IM94oFImgMMsOgDEAlfF/epEuEZlJOtV
         +lfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754978596; x=1755583396;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M9B3gMOvx4Se5alAYaJcB7wUIjvXYmRszTA8lXpOl7M=;
        b=DH/ioTQbfZc5aZ8GXOV6HPhmdBnyIi94yTS/AbkVQW8Y3gdjZn70YGgDkU78H6qon3
         6b1ZuMkUamfwYTDvDvU9PWmT8BEI2V1xHW23KdA0SwG1/XR74qeTgxRjNipige9HVGPj
         O1Ih70sX0d8qSxPAJPzxW266vZT2UBp4dL/RhXzOz58NlzKUs5b8qdd1UEIRs8EtD4F0
         LXJH7V5g0N/EqxKrYbDl32HZXyvjr5K7KZFBwtIuG/FVN1FVAsUL5sGpBY5fJaFA6Gbd
         CfctCi/eh7tHzyRkGCbrQ/w1+bjy/JLsBn2YowW5Apysq1gC7E8xpIrtJlc1Wm3gklT/
         5wAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVjxFYqcm2RXQCV3LZu8XvvL50FdIR6CVX9CsHacqsJZ3+RqansFP2GL1dJ1LvGS1sVlfo=@vger.kernel.org
X-Gm-Message-State: AOJu0YywxS8m0tLI98TNUlcgv7z8/Z7MharwjB7qRBWSyVy7D2AADR5B
	iD7H5hXewbzKtflEE+P2lpAWDI3HKY3+QUe9EpTQIf6RYBTVk8ZaSm1igKYTPmIZPIo=
X-Gm-Gg: ASbGnctotJVs5AnwPP+7ryAcsdtlvOF9kZ92RGXMUCr39lOQ0Y++XoaFbCdNttOpL80
	xD/PjhkR29tUMU4teyAAYGmyEwGoYZn0V7LBeEd+Od7Bv67Pvu0bvmTJeY4gQzabPS8eFqd1wxt
	vnbBhq+C2nTxd6mtKTnUfNiOUFa7HRaArpp7zg4+YrPqKGVTnDt0IQdByccoyaZaiRfa/ESKgaG
	mXMJaM23aAj9HGiMlHxWZW0mAeImbfA3R6AWBiax9D/gqjCzimMMXR7YI5gG3UHzQ2MscktsR04
	UK1L+10x3B+bomjVZn98VgCFJYhbNRus/lDt6rArSpiPHGrCi1+HBpAy9akuAduFWDaI5EA55Wh
	GoXFaDjMscggTg42FB4FhFz7rtvt3S2yr/XbLcukrNxqdaIF2b6TLOw1r6IRye5D5Pg==
X-Google-Smtp-Source: AGHT+IEVieLKhtDwri7judKFhFVZcryIFRk2iDf07UNgJHvD05TsbYJkUUoxvLiicyCioZBqvBmcPA==
X-Received: by 2002:a05:6000:2511:b0:3b7:8dd1:d7a1 with SMTP id ffacd0b85a97d-3b910fe4134mr1504587f8f.19.1754978596484;
        Mon, 11 Aug 2025 23:03:16 -0700 (PDT)
Received: from [192.168.69.210] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459d712c386sm365208165e9.23.2025.08.11.23.03.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Aug 2025 23:03:15 -0700 (PDT)
Message-ID: <3d88ea9c-9cfe-4cd4-a282-2f467f2a502f@linaro.org>
Date: Tue, 12 Aug 2025 08:03:14 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 07/11] target/arm: Replace kvm_arm_pmu_supported by
 host_cpu_feature_supported
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: Miguel Luis <miguel.luis@oracle.com>, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, Haibo Xu <haibo.xu@linaro.org>,
 Mohamed Mediouni <mohamed@unpredictable.fr>,
 Mark Burton <mburton@qti.qualcomm.com>, Alexander Graf <agraf@csgraf.de>,
 Claudio Fontana <cfontana@suse.de>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, Mads Ynddal <mads@ynddal.dk>,
 Eric Auger <eric.auger@redhat.com>, qemu-arm@nongnu.org,
 Cameron Esfahani <dirty@apple.com>
References: <20250811170611.37482-1-philmd@linaro.org>
 <20250811170611.37482-8-philmd@linaro.org>
 <8efcc809-f548-4383-b742-e435d622da73@linaro.org>
 <14d7d948-e840-4ae7-ae93-122755d6a421@linaro.org>
Content-Language: en-US
In-Reply-To: <14d7d948-e840-4ae7-ae93-122755d6a421@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/8/25 06:49, Philippe Mathieu-Daudé wrote:
> On 12/8/25 02:48, Richard Henderson wrote:
>> On 8/12/25 03:06, Philippe Mathieu-Daudé wrote:
>>> +++ b/target/arm/kvm.c
>>> @@ -288,7 +288,7 @@ static bool 
>>> kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>>>                                1 << KVM_ARM_VCPU_PTRAUTH_GENERIC);
>>>       }
>>> -    if (kvm_arm_pmu_supported()) {
>>> +    if (host_cpu_feature_supported(ARM_FEATURE_PMU, false)) {
>>
>> Why is false correct here?  Alternately, in the next patch, why is it 
>> correct to pass true for the EL2 test?
> 
> I think I copied to KVM the HVF use, adapted on top of:
> https://lore.kernel.org/qemu-devel/20250808070137.48716-12- 
> mohamed@unpredictable.fr/
> 
>>
>> What is the purpose of the can_emulate parameter at all?
> 
> When using split-accel on pre-M3, we might emulate EL2:
> 
>         |   feat            |    can_emulate   |    retval
>         +   ----            +      -----       +     ----
 > M1/M2  |  ARM_FEATURE_EL2         false            false> M1/M2  |  
ARM_FEATURE_EL2         true             true
> M3/M4  |  ARM_FEATURE_EL2         any              true

For example in hvf.c:

static bool hvf_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
{
     ...
     if (host_cpu_feature_supported(ARM_FEATURE_EL2, true)) {
         ahcf->features |= 1ULL << ARM_FEATURE_EL2;
     }

and then only when split-accel is not enabled:

hv_return_t hvf_arch_vm_create(MachineState *ms, uint32_t pa_range)
{
     ...
     if (host_cpu_feature_supported(ARM_FEATURE_EL2, false)) {
         ret = hv_vm_config_set_el2_enabled(config, true);
         if (ret != HV_SUCCESS) {
             goto cleanup;
         }
     }


