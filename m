Return-Path: <kvm+bounces-21953-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D7E8937AFF
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 18:29:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7B870B23993
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 16:29:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCB741448F6;
	Fri, 19 Jul 2024 16:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="iK/xf+kD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B378128812
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 16:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721406575; cv=none; b=LyPKWVhrFeJMxDwCLFfbw97llhIjHwM0YQVJ0eAFVr9q+Am8ggTuSonLn3aMpMIDYkTAWwMDG15rGqSjZ5rtQ6lI72MZDNFHkdQ3fjjVGaOGtwI/dLNFkJsXl41QU1o08UYaj2+sRwZaVgeZDRtmOVUBThF1+uj0erGhPApnGio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721406575; c=relaxed/simple;
	bh=Azpz80wMRlP8lCt8CC0IfRe1hJrR9eEvn43osrhUevI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P3HTiw+V43UNRj1jdOH4Czo3e1mk/EZF+whxfdc1sILz7dpPmx/fnfo9HkEJXq7wH47jlzHEyPQy4bptC1KdwH/url9eIFdvjxn1Iu95zA9YH/gkOGWdjAIrVvKj0Udiei0csJQ8KsCjazkgcpGPG9w94KDUZ0u5Zk6OKkyYvR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=iK/xf+kD; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-70b12572bd8so813032b3a.2
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 09:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1721406573; x=1722011373; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TWuFYjkE1q20mT6m9Gz+SjZGLVtg8tkx2StoOgf/mng=;
        b=iK/xf+kD1mlXCI1PD1APNrkuWqGtj5izxrdxlAwrEwsZ4VokmzPm6Wj9ZM3CCxmWJr
         pPOmfBPmnoxlXCI6TS69Gmw4r8Y02plcc1CdCbg1R4wt+c3AUGCV6hy7ELcyA9lenKkR
         lruzQj6PMhYG6cLL9bN+2UqPgUFhygAkjxJW2mhnUW9nb8fx+QsdMYmhktvZi0Q/gdvg
         ugZTTVmHvjZqiaL1INngQYBJJPl9vQoLR2WOxIntDFSpF3IGQgPbwQ4QjIuMu65bphsB
         NpGW1zU/US0Ioi0RVA59knQtS0Cm8tpD+YF5A7dhD1/GpwxUZTJg++Aenq2pXvLnTApB
         D8kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721406573; x=1722011373;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TWuFYjkE1q20mT6m9Gz+SjZGLVtg8tkx2StoOgf/mng=;
        b=tvfCxwAbW5y/keTgM/zu3ZZUUDl++vAge4suYLGlPlRZ3zB8DcYrCKvhc14vKyhHXl
         7NXCHJ0LqeGMxFtunbLPE7rK3OW6OQf3LdPIVuj7HPr1XG57kHRvcfxod67qXLeq6izM
         eodOg7IAT0fsgFZ+ctUHHqkz6y5s6SSr2FzgqYbdJmLk4TQVglKrgNEpSiJrc3WCgQ95
         sQKKi6PmnRFLC9pSiyOMngAkYXmmyCF0K+oTTr8Xw7XKESDho9cmC31bZrrYeh6urFfR
         Tlk3yIv/1Kt7DRFYviqXvf84wlRm5Yhd/cwHGbFqbaOmKNYBAgOeScSQgo2Z2EfnUp9D
         S0uw==
X-Forwarded-Encrypted: i=1; AJvYcCVlr4jxMca99bRqDCDULIajz2/cAvjDaEC4uxC2NSkS3mlRLhglCRDdnM8MqvNzR6UV7yGpqxRB837UghRJSEDdvVep
X-Gm-Message-State: AOJu0Ywsf7uPBRZuiSP4RmpOEcq14O+zUlgYTf8dFF28KITfu7GipbIe
	8dm6cfsm2bl7iLZgsMp2iZjIGDnpmDuDyuyTC169fgwprdKzzmIOna1YAJpaou0=
X-Google-Smtp-Source: AGHT+IEKT4AGXtfvIyGaqgqG/ujci4q9QMV+Yb5g27ubDgaaGctBNWqX4OR++3iFt+dPhMFsXZWTiQ==
X-Received: by 2002:a05:6a00:2353:b0:70b:8190:d555 with SMTP id d2e1a72fcca58-70ce4f43908mr10405084b3a.32.1721406572554;
        Fri, 19 Jul 2024 09:29:32 -0700 (PDT)
Received: from ?IPV6:2400:4050:a840:1e00:9ac7:6d57:2b16:6932? ([2400:4050:a840:1e00:9ac7:6d57:2b16:6932])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70cff5587e4sm1371596b3a.135.2024.07.19.09.29.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jul 2024 09:29:32 -0700 (PDT)
Message-ID: <414c64cb-7d01-4e63-83ea-90eca0de0942@daynix.com>
Date: Sat, 20 Jul 2024 01:29:29 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/5] target/arm/kvm: Fix PMU feature bit early
To: Cornelia Huck <cohuck@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>
Cc: Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20240716-pmu-v3-0-8c7c1858a227@daynix.com>
 <20240716-pmu-v3-2-8c7c1858a227@daynix.com>
 <CAFEAcA8tFtdpCQobU9ytzxvf3_y3DiA1TwNq8fWgFUtCUYT4hQ@mail.gmail.com>
 <f9cf0616-34df-42c3-a753-4dec8e2d25b5@daynix.com> <87cyn9a7yn.fsf@redhat.com>
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <87cyn9a7yn.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/07/19 21:21, Cornelia Huck wrote:
> On Fri, Jul 19 2024, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
> 
>> On 2024/07/18 21:07, Peter Maydell wrote:
>>> On Tue, 16 Jul 2024 at 13:50, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>>>
>>>> kvm_arm_get_host_cpu_features() used to add the PMU feature
>>>> unconditionally, and kvm_arch_init_vcpu() removed it when it is actually
>>>> not available. Conditionally add the PMU feature in
>>>> kvm_arm_get_host_cpu_features() to save code.
>>>>
>>>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
>>>> ---
>>>>    target/arm/kvm.c | 7 +------
>>>>    1 file changed, 1 insertion(+), 6 deletions(-)
>>>>
>>>> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>>>> index 70f79eda33cd..849e2e21b304 100644
>>>> --- a/target/arm/kvm.c
>>>> +++ b/target/arm/kvm.c
>>>> @@ -280,6 +280,7 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>>>>        if (kvm_arm_pmu_supported()) {
>>>>            init.features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
>>>>            pmu_supported = true;
>>>> +        features |= 1ULL << ARM_FEATURE_PMU;
>>>>        }
>>>>
>>>>        if (!kvm_arm_create_scratch_host_vcpu(cpus_to_try, fdarray, &init)) {
>>>> @@ -448,7 +449,6 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>>>>        features |= 1ULL << ARM_FEATURE_V8;
>>>>        features |= 1ULL << ARM_FEATURE_NEON;
>>>>        features |= 1ULL << ARM_FEATURE_AARCH64;
>>>> -    features |= 1ULL << ARM_FEATURE_PMU;
>>>>        features |= 1ULL << ARM_FEATURE_GENERIC_TIMER;
>>>>
>>>>        ahcf->features = features;
>>>> @@ -1888,13 +1888,8 @@ int kvm_arch_init_vcpu(CPUState *cs)
>>>>        if (!arm_feature(env, ARM_FEATURE_AARCH64)) {
>>>>            cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_EL1_32BIT;
>>>>        }
>>>> -    if (!kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PMU_V3)) {
>>>> -        cpu->has_pmu = false;
>>>> -    }
>>>>        if (cpu->has_pmu) {
>>>>            cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
>>>> -    } else {
>>>> -        env->features &= ~(1ULL << ARM_FEATURE_PMU);
>>>>        }
>>>>        if (cpu_isar_feature(aa64_sve, cpu)) {
>>>>            assert(kvm_arm_sve_supported());
>>>
>>> Not every KVM CPU is necessarily the "host" CPU type.
>>> The "cortex-a57" and "cortex-a53" CPU types will work if you
>>> happen to be on a host of that CPU type, and they don't go
>>> through kvm_arm_get_host_cpu_features().
>>
>> kvm_arm_vcpu_init() will emit an error in such a situation and I think
>> it's better than silently removing a feature that the requested CPU type
>> has. A user can still disable the feature if desired.
> 
> OTOH, if we fail for the named cpu models if the kernel does not provide
> the cap, but silently disable for the host cpu model in that case, that
> also seems inconsistent. I'd rather keep it as it is now.

There are two perspectives of consistency:
1) The initial value of pmu
2) The behavior with the pmu value

This change introduces inconsistency for 1); the host cpu model will 
have pmu=off by default and the other cpu models will keep default 
pmu=on value on a system that does not support PMU. It still keeps 
consistency for 2); it fails if the user sets pmu=on for any cpu model 
on such a system.

We should align 1) for better consistency, but I don't think such a 
change would be useful. It is likely that something is wrong with the 
system when the system reports a cpu model but it doesn't support its 
feature. I think that is the reason why we assert 
kvm_arm_sve_supported() for SVE; however I don't think such an assertion 
would help either because kvm_arm_vcpu_init() will fail anyway.

Regards,
Akihiko Odaki

