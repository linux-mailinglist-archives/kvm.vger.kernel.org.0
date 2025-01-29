Return-Path: <kvm+bounces-36819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 936CBA21746
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 06:18:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE51E3A5045
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 05:18:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B56318FDC5;
	Wed, 29 Jan 2025 05:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="RkUkHyXj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1C27FD
	for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 05:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738127927; cv=none; b=nwf6s+nmGDnbZBvHssQy9rD4la57Y4ZfkdkoTSEddt5vXlNgo0jZfh4r/njG4bwmRKEtiyf1F00jC+S8BrFExab/GqiQ0KSsr4/xK0vhEmxGY0sayGlU19NORZcA3l3vbTu3W8uwYsyrgtlPRTphyQTHth6VRmNKEU2bxWUfdqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738127927; c=relaxed/simple;
	bh=PWOGJaZDBMQcGvlC4nyKggvT0wU2gmCVIjXXMKkK5BU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WTfUDXz2ysKLEvib1tqK52YnVYT7U7Gcsk1OTjXlbEbH763P0osRuh8zx0CoLCJ+8mluQ8PjcTABsAKI4FWNH+jd+VUB86AynebjF76ws1x5ySvg7OA4P9DAkdu2K+4MTrL8+QUh42y3pcZDfIaHCpX5NyxFsb4tZPraAprq1vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=RkUkHyXj; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2156e078563so91123965ad.2
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2025 21:18:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1738127925; x=1738732725; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+MvKBDTYqZ4kgG+IAuEhkVM5rhrVIL9eA78RgLiixmk=;
        b=RkUkHyXjn6oUJC1NsWQb6h7oLKZyoDxfvskdAsPzI8xI6BTbLSHB+8GpXnLi28S29U
         Txbi8tRSiGaU8v0D5GQ348xO43ibIkVC7HnqA7z7dl5WqaJNiu7EWHIBcjSxRnM5YUjJ
         c7BAnoaSUMAqGK4+8zHOXWltlp9esYFhU8U3ydtGBRMKYUwF+dAhBfRGHeZ6/T0N75Tv
         A1OtaUY/ebZZw4mVVrk6YpD3+vwz07GCr+NrdKWmrx2dXvV4Dv5vnbxi2YlZbzBg8PKz
         GTl/rGMtG9zDWGwa2C4oF4Ftscuuz2KTj/jOgKOhI+GLE36UHnNCCIMguCgdRzchjAbu
         ZLjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738127925; x=1738732725;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+MvKBDTYqZ4kgG+IAuEhkVM5rhrVIL9eA78RgLiixmk=;
        b=Esw4YktdJFx1LMPsJnGBghUvp+s3jL4McrZAZFKR35RtUtTmXx0IM3P5VzGcPD3d62
         tlSgV4C5H2qV32vpdenC7F99f0qK3ALA+TeqbL1k3pec6xxrZ/YCtKfP4C6X+QFoA5e7
         oEZ+gwBNWkKVFd1y9VzjDs9wlEMzWUvviUlkNI8s84elXSXHmGBAjF17dwRAvKmC34tk
         S4jdc5PKPZ5L6bXJLTFgsoQ6gfSoYMxHS5m1Ueffi9tvRq5zYIbt44uOJI0AOIxvFHRY
         RgUweJoY2AdU62+iCJU3a/aNptJlGMxG3SP4w0LXxPnvEd4hKxjRZDNFkDKU+50oXT3a
         bBqA==
X-Forwarded-Encrypted: i=1; AJvYcCWwk7kqG8JEU88UdfVoLL8MB+52tIa6R9KXrJFsrD2WwbgPFP3TUOuA1cggkZC0xkYIVh0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9BeIn+ryhxU0jheB5F1srxbWCSMas0lmxOBmLPQRCzl5FjFcr
	R3qmCthe1L1W/telj+yovl970LowkbkTaKfnv5klDEGNQdYoM0z2OT1UO+7L4nk=
X-Gm-Gg: ASbGnct9MkQqqzfiHj6p/P2WRM7+KIVdgyKalvxCjEQyw78jbGIw5HqG4nDuacKlf9k
	fQHLcb8hzJux1bNap2gdqNy4wKvl6jqAyHhI9g5OenSI37Rdm9JDnr87go2jPc+7Jw0WOIy5myS
	BGxHxkYqOQ4URMWe75hfYEZhhsvT5x+Fh09ZZK3elx0CeXsD5z4v4HM5n8srFmCAM2ngOUOH7Ai
	DtnEkfxUTQO9tW1+dQd2EEM+I1YdLkuRl3zmPHBRcQT0PAiWe59Rt73ckdOIcrpK96TBJq6K+sU
	VkLyHkygD6B47x3VQuJ3gX9NfKGK
X-Google-Smtp-Source: AGHT+IHNV33fcZHTRms+0VcI1kW4iI9FQyT3CGxyPaVhJDp2GhW9NkzGc0l25U9aBMjLUxXYJZCR1w==
X-Received: by 2002:a17:903:287:b0:215:cbbf:8926 with SMTP id d9443c01a7336-21dd7dddeabmr32201765ad.35.1738127925290;
        Tue, 28 Jan 2025 21:18:45 -0800 (PST)
Received: from [157.82.205.237] ([157.82.205.237])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da414db7fsm89756735ad.176.2025.01.28.21.18.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2025 21:18:44 -0800 (PST)
Message-ID: <f3c2af5f-43f9-45f7-871e-ad572b17449a@daynix.com>
Date: Wed, 29 Jan 2025 14:18:41 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] target/arm: Always add pmu property for Armv7-A/R+
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
 qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
 devel@daynix.com
References: <20250104-pmu-v5-1-be9c8777c786@daynix.com>
 <CAFEAcA9NzHeo+V8FpXDBjPK9n2i+LDVCxe1AS8z7O9DX9Cvzuw@mail.gmail.com>
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <CAFEAcA9NzHeo+V8FpXDBjPK9n2i+LDVCxe1AS8z7O9DX9Cvzuw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025/01/28 23:48, Peter Maydell wrote:
> On Sat, 4 Jan 2025 at 07:10, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>
>> kvm-steal-time and sve properties are added for KVM even if the
>> corresponding features are not available. Always add pmu property for
>> Armv7+. Note that the property is added only for Armv7-A/R+ as QEMU
>> currently emulates PMU only for such versions, and a different
>> version may have a different definition of PMU or may not have one at
>> all.
> 
> This isn't how we generally handle CPU properties corresponding
> to features. The standard setup is:
>   * if the CPU can't have feature foo, no property
>   * if the CPU does have feature foo, define a property, so the
>     user can turn it off

Is that really standard? The patch message says kvm-steal-time and sve 
properties are added even if the features are not available. Looking at 
other architectures, I can confirm that IvyBridge, an x86_64 CPU, has a 
property avx512f that can be set to true though the physical CPU model 
does not have one. I believe the situation is no different for RISC-V too.

> 
> See also my longer explanation in reply to this patch in v4:
> 
> https://lore.kernel.org/all/CAFEAcA_HWfCU09NfZDf6EC=rpvHn148avySCztQ8PqPBMFx4_Q@mail.gmail.com/

It explains well why the PMU of ARMv7 is different from other features 
like avx512f on x86_64 or RISC-V features; the architecture does not 
allow feature detection. However, as I noted in an earlier email, it 
also means explicitly disabling the PMU on ARMv7 is equally dangerous as 
enabling the PMU. So I see two logical design options:

1. Forbid to explicitly disable or enable the PMU on ARMv7 at all to 
avoid breaking the guest.
2. Allow explicitly disabling or enabling the PMU on ARMv7 under the 
assumption that the property will be used only by experienced users.

> 
>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
>> ---
>> The "pmu" property is added only when the PMU is available. This makes
>> tests/qtest/arm-cpu-features.c fail as it reads the property to check
>> the availability. Always add the property when the architecture defines
>> the PMU even if it's not available to fix this.
> 
> This seems to me like a bug in the test.
> 
>> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
>> index dcedadc89eaf..e76d42398eb2 100644
>> --- a/target/arm/cpu.c
>> +++ b/target/arm/cpu.c
>> @@ -1761,6 +1761,10 @@ void arm_cpu_post_init(Object *obj)
>>
>>       if (!arm_feature(&cpu->env, ARM_FEATURE_M)) {
>>           qdev_property_add_static(DEVICE(obj), &arm_cpu_reset_hivecs_property);
>> +
>> +        if (arm_feature(&cpu->env, ARM_FEATURE_V7)) {
>> +            object_property_add_bool(obj, "pmu", arm_get_pmu, arm_set_pmu);
>> +        }
>>       }
>>
>>       if (arm_feature(&cpu->env, ARM_FEATURE_V8)) {
>> @@ -1790,7 +1794,6 @@ void arm_cpu_post_init(Object *obj)
>>
>>       if (arm_feature(&cpu->env, ARM_FEATURE_PMU)) {
>>           cpu->has_pmu = true;
>> -        object_property_add_bool(obj, "pmu", arm_get_pmu, arm_set_pmu);
>>       }
>>
>>       /*
> 
> This would allow the user to enable the PMU on a CPU that
> says it doesn't have one. We don't generally permit that.
> 
> thanks
> -- PMM


