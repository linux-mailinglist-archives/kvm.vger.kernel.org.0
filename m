Return-Path: <kvm+bounces-21701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E8F509325C3
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 13:36:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 14A861C22336
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 11:36:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 747B31991D0;
	Tue, 16 Jul 2024 11:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="eNRv0WV8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E64815491
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 11:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721129790; cv=none; b=Sv7dVxvschdGPXLSOqVt67eeb3WCu/92zPEd76ett9irzQuhkFl5mKw2Atu1d32n09CGDcuqfTkxWFSFZfh3n+xFytJjgZg7TjFjYWrtR42isrVnZxb+NOQpW52ycHATJqDaGrmB390fLkDT+II9TB4U4PKjH2w6wRkBLiE6A+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721129790; c=relaxed/simple;
	bh=A353yTSsiHhTcZ4mUYW/K0lGm/8fHaGdFobufPLc7Es=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kJDrfbgF+PFg0tAdKrWwIDUFB6Cm/V+7ySFb2b0Y60ubHRmy5BaDJGLkanTUoqFRNEPM3uwKU+yqgt2spfZvVImBknZlpj8TCMJINX+qVruFyJGsl91Ft+XCd01uhVYKRLRfv851eKhMXr/iA3RkUxNHsHaBQ2vKYQScDaXC5Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=eNRv0WV8; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-70b1207bc22so4524880b3a.3
        for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 04:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1721129788; x=1721734588; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fIrjmnrcime12URGWOz+U3tVhvhx495pQrmKJbaCEkE=;
        b=eNRv0WV8Oa6j6YflDlyvN+tndvoMwqpEjMO6/Gc3uM2b1DmRUalvbGVgDNvb+JaCk5
         AiQ95IsACkbHGB/hLIw1a/7wNWwJ1dGkqaSCM5u/6V4RdN4cMu61vdwI1B6OArqsmExk
         okToIYa1pBZvzd+yNlA6b6Af1gHJy03Nv/tbz5vL9spJCPlKuDkN/0ShCkiWzYocac40
         MAu+saBNtM+b43p0ObZdzNEzgThfTvEvh5s9rWyMK2Xo2lQgLTYqXxtEtJ7qjkxZFQxs
         y1u37jelUT0NLzmzBOcBwvdt5wRY+B59gT4/HfpvCKvwWPEnrz6is6bOWe32yENuK6Vs
         6RYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721129788; x=1721734588;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fIrjmnrcime12URGWOz+U3tVhvhx495pQrmKJbaCEkE=;
        b=Lj938ArXnFfKCurV5Zha13Q8OIEOpU1eyaOeeqoORAlsJclYMns35O/WgE5rW4aOSp
         dM91+W288jAiohdj0GjHbzZO4LsAEar1IocOz8d2IeEYyqO3LoLqYORlTWhzpyvyl69x
         6xsqCwdh6f6GJIdWDA6gcQdJ9TeJ6nX2toxUYXIazAm5vOso8Y5KibwrUQk5PfSKo9Gv
         IPtOV5olOWIbLK6SIUb9JM/1Uxd2inqBjDrOwFOlmMWjKLD6Sgd2Nq9VN6vVIkhMr2jx
         sTrP1wZQIOyhQh+jZKAr51y4QzSfRDvNI/rWj510Lhfp0JrRUfz0FM4JpyDQpdYRA29R
         FdAA==
X-Forwarded-Encrypted: i=1; AJvYcCUtAerQfh3xx72MiCThLkfSsS4S6Z2xQ3GjSNWPXScV943j4zgLVjAUvPA954ypffAqwQDQWWQkODLl1Vbid0fhb1Pd
X-Gm-Message-State: AOJu0Yy6fSz6RqQJx6UL9cYlH7pI0cjYbV1PofqnS/dwcN5+ddCbchtg
	f+yN4XZdeiFIt7kbkcBY3tgW0C22tfvZhfosf/iYq8VOXHHBYJ2MoWKvhdJowA8=
X-Google-Smtp-Source: AGHT+IEQVrTfKfyPKCJhRlvLtuj+FAKBk0KVvsPqj+ybVV0I53B3fwt1t2Qgzq9+Gr8iqBo42rH2aQ==
X-Received: by 2002:a05:6a20:2590:b0:1c2:1ed4:4f91 with SMTP id adf61e73a8af0-1c3f124ac4bmr1630429637.31.1721129788574;
        Tue, 16 Jul 2024 04:36:28 -0700 (PDT)
Received: from [157.82.202.230] ([157.82.202.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b7ec7da24sm6056707b3a.113.2024.07.16.04.36.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jul 2024 04:36:28 -0700 (PDT)
Message-ID: <cdd5ce60-230f-48a1-bcf3-9591b8bede95@daynix.com>
Date: Tue, 16 Jul 2024 20:36:25 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] target/arm: Always add pmu property
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20240716-pmu-v2-0-f3e3e4b2d3d5@daynix.com>
 <20240716-pmu-v2-4-f3e3e4b2d3d5@daynix.com>
 <CAFEAcA9trFnYaZbVehHhxET68QF=+X6GRsEh+zcavL-1DxDB4w@mail.gmail.com>
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <CAFEAcA9trFnYaZbVehHhxET68QF=+X6GRsEh+zcavL-1DxDB4w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/07/16 20:32, Peter Maydell wrote:
> On Tue, 16 Jul 2024 at 09:28, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>
>> kvm-steal-time and sve properties are added for KVM even if the
>> corresponding features are not available. Always add pmu property too.
>>
>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
>> ---
>>   target/arm/cpu.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
>> index 9e1d15701468..32508644aee7 100644
>> --- a/target/arm/cpu.c
>> +++ b/target/arm/cpu.c
>> @@ -1781,9 +1781,10 @@ void arm_cpu_post_init(Object *obj)
>>
>>       if (arm_feature(&cpu->env, ARM_FEATURE_PMU)) {
>>           cpu->has_pmu = true;
>> -        object_property_add_bool(obj, "pmu", arm_get_pmu, arm_set_pmu);
>>       }
>>
>> +    object_property_add_bool(obj, "pmu", arm_get_pmu, arm_set_pmu);
>> +
>>       /*
>>        * Allow user to turn off VFP and Neon support, but only for TCG --
>>        * KVM does not currently allow us to lie to the guest about its
> 
> Before we do this we need to do something to forbid setting
> the pmu property to true on CPUs which don't have it. That is:
> 
>   * for CPUs which do have a PMU, we should default to present, and
>     allow the user to turn it on and off with pmu=on/off
>   * for CPUs which do not have a PMU, we should not let the user
>     turn it on and off (either by not providing the property, or
>     else by making the property-set method raise an error, or by
>     having realize detect the discrepancy and raise an error)

I don't think there is any reason to prohibit adding a PMU to a CPU that 
doesn't have when you allow to remove one. For example, neoverse-v1 
should always have PMU in the real world.

Perhaps it may make sense to prohibit adding a PMU when the CPU is not 
Armv8 as the PMU we emulate is apparently PMUv3, which is part of Armv8.

Regards,
Akihiko Odaki

