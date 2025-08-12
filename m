Return-Path: <kvm+bounces-54500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C58AB21F8E
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 09:33:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0EE631AA5E95
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 07:33:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC1E52C21EC;
	Tue, 12 Aug 2025 07:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SKvbd26U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D3D1A9FA6
	for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 07:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754983995; cv=none; b=YqpLHiSJrA4nCGRtikiU/MtrNmhReKtEzS/RCeI70na3oLt0reBIiLWgExIzO0EVqGDOZjgdTiyALpNzaBtnMb29L4DCesBQwYwQKdsrZ/vUuW4TJwbNHZsQ7epc3J4YHn5CV0to4BIoZOTyHqukTyTlg4GKfY+ZJX44oDAl5qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754983995; c=relaxed/simple;
	bh=vvt2dHuBsAQDhKzRNgDXJnfCZ8zYISh0LwJhlxe7jRE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Du+n98FfyeWeHN+53HpcO8wGCGlXhaFQhQfab3d7CR0Ybdhfnci6/UUM3eqO0uK4dbL2pnXej3R/avNPLbWLsghLGHVmLvacQrTepSZx+OzzP4dW1IhM9yOMvhFMVBruTxsrQCETwVg6cP0ONKJH1mF6KbYOc3DcfToVmGY4XF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SKvbd26U; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-455b00339c8so32832945e9.3
        for <kvm@vger.kernel.org>; Tue, 12 Aug 2025 00:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754983992; x=1755588792; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=U46tZm3WdCz9s6+s67rjcVFpZgOy6vILPUGATvBzyns=;
        b=SKvbd26U39X3QR/bqLvC+4MD1sEOApnZ5dBlZH/vYo4TBWuLikl/8vtXppihtyuiu6
         vz4hk/+nGUkxbr2GtuoM3XUj3cNRhFGhEKBViAclLPkA/2cKOk5WkS2hD0HVzzOyiVHN
         wXjFOHAFbuOFh6YbZz5OlCg+zLEEW4K0olLnfXTGu5NaIhxaHg9ScH3Eapv9VbDtlx8I
         mcR776ZT/nodYbIoW+i7IPVFwC6S4nkiYlhBtTNdN5ebi64l6WMNCUVe3+fcZ6nB6ZGb
         EH/oF4fY6DvcVZ7SAPR04ohjclNeqATxyWoqSPRXLLK+ew2LVsnVyK0KaSdiWQVvhLze
         ZtsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754983992; x=1755588792;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U46tZm3WdCz9s6+s67rjcVFpZgOy6vILPUGATvBzyns=;
        b=iqM8NwCk73k4ydxL4hTSu6kSCkjxa1B0Gv1mrIr5v1xnaV+ZCAlaM6+ukjQkNLqNC4
         04Wll37/TH0p+M/jXgoN+LV6rG+EkFhYiLuI/hTngEuetRwNc3UxDAAt1ZzhQK290bZ8
         eeFluOiHY9U90PP34buvvw2j+3xeXli4BVEClkHey9XW3F0XnrvZZZtxBqzAf9yPeE/b
         KLhOIh6AMo56CQV2mFQkTDnqnVMF2K2BcwkLg/lXhO09IGvgoikWIfYOdm7juixeszdo
         Wjscy2rOgm1K6eW2YpZA0vCuQNDjyOnA/cC5nOH2wBKy46KVhpt5xlSabWKLubUAP0Qj
         +NMg==
X-Forwarded-Encrypted: i=1; AJvYcCWB7PYRYuux2c6B7lIdDbOCH0k4I2kEyZZO6nBrckylHLwV+zD0AtxEdPv66apPx5hIALM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsSEt/uxM9lH1StVzhdNbC+V/LQpK0CdKymA9Ebuyx9IoSnoR8
	eZFPLC7bjVzwshm4LAFPJGBisEgAM5koYaTvTvxhnpxpqMEZ6GJvWKYHmqdy+WChRmAzZGA1XCm
	TjqR6
X-Gm-Gg: ASbGncvmJ57X/mEaCLt2dxCuu4QY02wAxwvbLPRXN6JpKPYGvR5Dj1Oq+jghnFHpN7k
	tfr3FJYDcJ/De9QIf5EEzeaxxeh+v9alsvPtJLRFOV2BQgwKlFuDi6maUCoTEoWo7BBmEbnzONn
	nN3dccvid0IF0+5AXr5hqJwTxeetvtXMWqxLs4Pk773pbHqFCZy9Aap7nLQmAcgKF+reyQTH7QX
	ryKUZBO5LQ7isJIWNRB959pHqYV58HB1AQQuUH8Pob1TGnK2eL/zPZlMu+Tdz1SmbPxreN5lhX8
	C4GplOagteIlVuE+atSGJL6RjS/wy0V62wH5D/DBX3Kp188s5xrNpZX5fjGgIRJ+doUw4KQ9n8Q
	HRKGdGPaMXSyy/XcOayWiOVA63IkNDxFnhuzCt2fYHtwrBTznVZKk1PnpMU7uXWamAE9huus=
X-Google-Smtp-Source: AGHT+IFenbOYBYYL8rtdP5NhvlPx6gH97dvDDxCUDEfprak8jMg7i9COL3O/U+STX2Nwjj//F6/Vtw==
X-Received: by 2002:a05:600c:4e46:b0:456:173c:8a53 with SMTP id 5b1f17b1804b1-45a10e135b6mr21112745e9.2.1754983992162;
        Tue, 12 Aug 2025 00:33:12 -0700 (PDT)
Received: from [192.168.69.210] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458953eb7acsm525015225e9.28.2025.08.12.00.33.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Aug 2025 00:33:11 -0700 (PDT)
Message-ID: <cb6e02cc-1959-419a-bafa-5bb43818c159@linaro.org>
Date: Tue, 12 Aug 2025 09:33:10 +0200
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
 <3d88ea9c-9cfe-4cd4-a282-2f467f2a502f@linaro.org>
Content-Language: en-US
In-Reply-To: <3d88ea9c-9cfe-4cd4-a282-2f467f2a502f@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/8/25 08:03, Philippe Mathieu-Daudé wrote:
> On 12/8/25 06:49, Philippe Mathieu-Daudé wrote:
>> On 12/8/25 02:48, Richard Henderson wrote:
>>> On 8/12/25 03:06, Philippe Mathieu-Daudé wrote:
>>>> +++ b/target/arm/kvm.c
>>>> @@ -288,7 +288,7 @@ static bool 
>>>> kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>>>>                                1 << KVM_ARM_VCPU_PTRAUTH_GENERIC);
>>>>       }
>>>> -    if (kvm_arm_pmu_supported()) {
>>>> +    if (host_cpu_feature_supported(ARM_FEATURE_PMU, false)) {
>>>
>>> Why is false correct here?  Alternately, in the next patch, why is it 
>>> correct to pass true for the EL2 test?
>>
>> I think I copied to KVM the HVF use, adapted on top of:
>> https://lore.kernel.org/qemu-devel/20250808070137.48716-12- 
>> mohamed@unpredictable.fr/
>>
>>>
>>> What is the purpose of the can_emulate parameter at all?
>>
>> When using split-accel on pre-M3, we might emulate EL2:
>>
>>         |   feat            |    can_emulate   |    retval
>>         +   ----            +      -----       +     ----
>  > M1/M2  |  ARM_FEATURE_EL2         false            false> M1/M2  | 
> ARM_FEATURE_EL2         true             true
>> M3/M4  |  ARM_FEATURE_EL2         any              true
> 
> For example in hvf.c:
> 
> static bool hvf_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
> {
>      ...
>      if (host_cpu_feature_supported(ARM_FEATURE_EL2, true)) {
>          ahcf->features |= 1ULL << ARM_FEATURE_EL2;
>      }
> 
> and then only when split-accel is not enabled:
> 
> hv_return_t hvf_arch_vm_create(MachineState *ms, uint32_t pa_range)
> {
>      ...
>      if (host_cpu_feature_supported(ARM_FEATURE_EL2, false)) {
>          ret = hv_vm_config_set_el2_enabled(config, true);
>          if (ret != HV_SUCCESS) {
>              goto cleanup;
>          }
>      }
> 

What I'm looking for:

- Is this feature supported BY HW?

   -> hw_init_feature

- Is this feature supported BY SW?

   -> sw_init_feature

- Is this feature supported BY ANY?

   -> do smth with feature

With split-accel, this isn't specific to HVF/ARM.

I can use a tri-state enum { ANY, HW, SW }.

