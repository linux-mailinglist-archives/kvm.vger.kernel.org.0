Return-Path: <kvm+bounces-21918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 78E4A937455
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 09:21:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3289E283B2F
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 07:21:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E637D50A80;
	Fri, 19 Jul 2024 07:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="KcylxIdU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0FC446CF
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 07:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721373689; cv=none; b=K9UYVO3Nthbf42aFrhy1+ahsEi5uFnBbYHfxkENSFsiHRwtQJAtnjB9xVWnnzqeDlFGuhGnUKh5nYq4vatgJLpONmBeP3FowGZf8XHYz9VDGRHvx2a6fPGdxjXt3p5m3u+uuufjMskQ7RR1hQI7D+Knzi63D17E6iOfsn7NLrk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721373689; c=relaxed/simple;
	bh=sRDEOXFKzogPYOcgzywO9xR6dXngsPveQJ7tZepmb7U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eoftRnfMEMqrdQEIICnY6/phQZz4MX59di3RUn/UwtlfA6QrJ1ye9DEnLJdZbwLwM6SoSEVqQMZF+ks3yOPjwglR64vQPXfr3i0/Qv2qkVRrgExkjFzPLNjZxvkMZKD3Gq3jvLQ1J4/TtCx7TfAxfhAfzF39R5yIsiJc3iTUNnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=KcylxIdU; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1fc4fccdd78so11401245ad.2
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 00:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1721373687; x=1721978487; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l+InLfvy3Wi5yP9doSp4CIHfQTGOwoe0asCqSW+LgII=;
        b=KcylxIdUyNzGACUoOrq0nczAB5aQB/OZvH/b7uiEjTroXkunrx51yl2E1YAEJAxaQI
         GtD+CP6Ozq4iDk57QjbSWh42p9IXZdDrC5beKYZneJSaKAIbTmU07FmeXP/pVViYKDq4
         b+huY6mUFo/VDaZ2CFr4xZe6+eUW4JnQcvxCk/RCuptDHEeO8xe0+An58xqcPIKLhTdT
         IszZ7GGhC4BAL604xKAqEukdRW3qledFobUlNwNnkjwua2rm1bfvggLdLrJ/Z9VK7w9J
         rthKggJaOcO0hTHILeo28wqSruDAL88YMFnwAIxp9b+z8MLCfPmB6MD0xSXxxFEUpstv
         yhdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721373687; x=1721978487;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l+InLfvy3Wi5yP9doSp4CIHfQTGOwoe0asCqSW+LgII=;
        b=VJAWqXJYWLijAvh7FP+pwrZOZpAqUNv0LS9c25ptH9RI3SUiraBx7wlEPM3RJ+zkvx
         I7GEuU4L9gg/1z+xszAF+MMOL6pm7GlUJiDxaHm3yvAu1tXQm1AizemI1qYDTYplJjBU
         Lo07ykU/yYlYOzE8sBg91glTYREWZ2qiUQHs/8HgZoEgrG31JjFmJmrRPGyEi5R4vePy
         OKfMTVQV1oH/c5e0znCnqomR0FWB/pYLUUbM9Yq1IDxPwsetGerasag20N+qJ/duDJav
         J4GgIcO86UYdmKd58RRjFYfH9LryK3RFhPKP3S91gDvO4PibpGqQYi1gOgKfYjS7dYZJ
         ouHg==
X-Forwarded-Encrypted: i=1; AJvYcCXuLMp+Z/38u1E0cAhsE3hQxMUyqs/GH+QK4yyrAcRVXmiUcJRUbei3GvboHxJ2pFWDiifXSOKKlqT0hp0VjPWP5imf
X-Gm-Message-State: AOJu0Yw+mzsr1lqWxracieVw+8t9EVOweX6oGbVccs8g4pbsXJsf2bUo
	SpleNvWDqElSvTWSTXtYx/k4IigZjNWC585J03E6u2ArBL5mAoe4pDsvAiAprZk=
X-Google-Smtp-Source: AGHT+IG7pRZucV2pX7tEVeC3k9EOYe78N/rINrMJ7dbtG9GdYk8KtIyq0X7XFRJmyzfRif5BJbm9rw==
X-Received: by 2002:a17:902:c948:b0:1fb:8a0e:76f9 with SMTP id d9443c01a7336-1fc4e17ec73mr57478355ad.39.1721373686807;
        Fri, 19 Jul 2024 00:21:26 -0700 (PDT)
Received: from [133.11.54.222] (h222.csg.ci.i.u-tokyo.ac.jp. [133.11.54.222])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fd64d0703bsm7344875ad.155.2024.07.19.00.21.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jul 2024 00:21:26 -0700 (PDT)
Message-ID: <f9cf0616-34df-42c3-a753-4dec8e2d25b5@daynix.com>
Date: Fri, 19 Jul 2024 16:21:22 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/5] target/arm/kvm: Fix PMU feature bit early
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20240716-pmu-v3-0-8c7c1858a227@daynix.com>
 <20240716-pmu-v3-2-8c7c1858a227@daynix.com>
 <CAFEAcA8tFtdpCQobU9ytzxvf3_y3DiA1TwNq8fWgFUtCUYT4hQ@mail.gmail.com>
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <CAFEAcA8tFtdpCQobU9ytzxvf3_y3DiA1TwNq8fWgFUtCUYT4hQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/07/18 21:07, Peter Maydell wrote:
> On Tue, 16 Jul 2024 at 13:50, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>
>> kvm_arm_get_host_cpu_features() used to add the PMU feature
>> unconditionally, and kvm_arch_init_vcpu() removed it when it is actually
>> not available. Conditionally add the PMU feature in
>> kvm_arm_get_host_cpu_features() to save code.
>>
>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
>> ---
>>   target/arm/kvm.c | 7 +------
>>   1 file changed, 1 insertion(+), 6 deletions(-)
>>
>> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>> index 70f79eda33cd..849e2e21b304 100644
>> --- a/target/arm/kvm.c
>> +++ b/target/arm/kvm.c
>> @@ -280,6 +280,7 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>>       if (kvm_arm_pmu_supported()) {
>>           init.features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
>>           pmu_supported = true;
>> +        features |= 1ULL << ARM_FEATURE_PMU;
>>       }
>>
>>       if (!kvm_arm_create_scratch_host_vcpu(cpus_to_try, fdarray, &init)) {
>> @@ -448,7 +449,6 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>>       features |= 1ULL << ARM_FEATURE_V8;
>>       features |= 1ULL << ARM_FEATURE_NEON;
>>       features |= 1ULL << ARM_FEATURE_AARCH64;
>> -    features |= 1ULL << ARM_FEATURE_PMU;
>>       features |= 1ULL << ARM_FEATURE_GENERIC_TIMER;
>>
>>       ahcf->features = features;
>> @@ -1888,13 +1888,8 @@ int kvm_arch_init_vcpu(CPUState *cs)
>>       if (!arm_feature(env, ARM_FEATURE_AARCH64)) {
>>           cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_EL1_32BIT;
>>       }
>> -    if (!kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PMU_V3)) {
>> -        cpu->has_pmu = false;
>> -    }
>>       if (cpu->has_pmu) {
>>           cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
>> -    } else {
>> -        env->features &= ~(1ULL << ARM_FEATURE_PMU);
>>       }
>>       if (cpu_isar_feature(aa64_sve, cpu)) {
>>           assert(kvm_arm_sve_supported());
> 
> Not every KVM CPU is necessarily the "host" CPU type.
> The "cortex-a57" and "cortex-a53" CPU types will work if you
> happen to be on a host of that CPU type, and they don't go
> through kvm_arm_get_host_cpu_features().

kvm_arm_vcpu_init() will emit an error in such a situation and I think 
it's better than silently removing a feature that the requested CPU type 
has. A user can still disable the feature if desired.

Regards,
Akihiko Odaki

