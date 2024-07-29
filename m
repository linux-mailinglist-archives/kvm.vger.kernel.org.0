Return-Path: <kvm+bounces-22517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D965A93FB52
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 18:36:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93AA6285AA6
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 16:36:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72C9E15FA6B;
	Mon, 29 Jul 2024 16:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="zRLotdyU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0153C77119
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 16:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722270742; cv=none; b=WAJYy5Jqj1pdyeg7okRyoaXrFJu/XTRfH2I43Mnjk0fWRnkWreSBv7X/PYXEN313OVJ8w8r0XndVvTActdzdVqfyBRFP7w+5H0Ap4C/NlVmIHxFPtWVVTde/Vab4XBWfcGi7jTNhy/p5IfnRI7F6x7TtU2lTRf5H16WkhF2+jFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722270742; c=relaxed/simple;
	bh=/8SS+S02sUIo8V2/nt9h3LxGebVzHxnrgvUCpRqJ084=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bpN23l0Jtqp5wWPhFUQIOkJqglNNDwr3hAUdENyl0grPIx9kHqsgu7gHFCOqeDJvQpDGwZNrXcvsaCFl5nS1nu3Grf9dWFsvF/Hz6Yt8xUQIhAGCifcVbYrz9tmmlPhbpADx3MRSdAIF7rb1F/UBhpiuI7Sg2gMlNsSif27YpFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=zRLotdyU; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-70d153fec2fso2721655b3a.1
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 09:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1722270739; x=1722875539; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NP0mnjphVBIb1VHUp9w1Gbv9MySDgOtzxAXgvoRoCWk=;
        b=zRLotdyUiHnYB+9PwD58bpOOp2+j+2tMYhE836iWV3YE1Fm11hAFD8CjJi/bKPWZBY
         VAwiXJDSx2UwNh2cEGrdz8rBQIvrL1xv9tSTb5eBbAek7a2PaE9OiyqUZOl6TKy1BvLm
         aWJa/hwejPa65tFFNbkB8KlK8OQX70nDXrZP1PWvy1pVhDpxCBtn2DOiWMxbQCLsiv/d
         XLvjhg7O3hkBmJCgPBJ/ruA8+uf6jWbT5GbmwKSBuEiHgQYjPvpDyFnvNUKw+4ZLL/W+
         7zmowjxKuS5fTPLHVWpZ9OGrA7PVweRU3CFzMb2uZDcl9o8qwwO4kvmFtt4npDRWYNcb
         mPfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722270739; x=1722875539;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NP0mnjphVBIb1VHUp9w1Gbv9MySDgOtzxAXgvoRoCWk=;
        b=P8/GkSvLD6qq8/LmM8fnlF5eTerPV1TBkltgoD9oWMwOZuNth5+twku5UGwoHN3sf5
         U8Jhq2l0tt/nslKqsuS1VfWWT+N3NqhG7y7R1MUUPbflkX3BW4Fojz3Fw4C/oNU2oKhk
         fDpRxmC2mu5Rpavpgks/cA+cHEJm7cT+Pl0LEgrf6qhnyvc4KcBT1/a+Pw3GyfS+vxrD
         p7BhmhtCggNrmvm92+/+PEcMjNSNXpqgzmZKzoeE5Q1SMwiUVX1bjPjbNcIPR0QIpOw4
         vzBSC7/jDkoZZ7HW/PQW6FLORMTmAZD2txA7Z7uOgsuorEzZqBS9LApDKXw9YxL5jdRD
         AOGA==
X-Forwarded-Encrypted: i=1; AJvYcCV6an+rqnTLrUpfkKh2wgsb+FURUG2ZMO++oQOuZkAmi46FyhqAf82zEHk9QPBuGWf3KQ3yhCKtscStvrWhsq92Zgpp
X-Gm-Message-State: AOJu0YwY48qUYWdhxZPhBiqFCej0u5sNGcp53HalkhSPA9064KN2KqGP
	V7klemxVddjPHrtPOTnGV2e6MoBirzuuILRYogC1ZquON897GG3vvut9wm3kOSQ=
X-Google-Smtp-Source: AGHT+IE8USeonXb4Pm9/EG3A3k5KbT5WMV9i2oo6wxOG6M5W2IsdmVYvAs1TCLj8GNJj8VLKjiJU2g==
X-Received: by 2002:a05:6a21:3406:b0:1c3:18f9:16d8 with SMTP id adf61e73a8af0-1c4a1511038mr10516471637.52.1722270739318;
        Mon, 29 Jul 2024 09:32:19 -0700 (PDT)
Received: from ?IPV6:2400:4050:a840:1e00:32ed:25ae:21b1:72d6? ([2400:4050:a840:1e00:32ed:25ae:21b1:72d6])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70ead7120easm7010598b3a.55.2024.07.29.09.32.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jul 2024 09:32:18 -0700 (PDT)
Message-ID: <361cec8b-cd35-416b-b3d2-9e6d87981edd@daynix.com>
Date: Tue, 30 Jul 2024 01:32:15 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/6] target/arm: Always add pmu property for Armv7-A/R+
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
 qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20240720-pmu-v4-0-2a2b28f6b08f@daynix.com>
 <20240720-pmu-v4-3-2a2b28f6b08f@daynix.com>
 <CAFEAcA_HWfCU09NfZDf6EC=rpvHn148avySCztQ8PqPBMFx4_Q@mail.gmail.com>
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <CAFEAcA_HWfCU09NfZDf6EC=rpvHn148avySCztQ8PqPBMFx4_Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/07/30 0:13, Peter Maydell wrote:
> On Sat, 20 Jul 2024 at 10:31, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>
>> kvm-steal-time and sve properties are added for KVM even if the
>> corresponding features are not available. Always add pmu property for
>> Armv8. Note that the property is added only for Armv7-A/R+ as QEMU
>> currently emulates PMU only for such versions, and a different
>> version may have a different definition of PMU or may not have one at
>> all.
>>
>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
>> ---
>>   target/arm/cpu.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
>> index 19191c239181..c1955a82fb3c 100644
>> --- a/target/arm/cpu.c
>> +++ b/target/arm/cpu.c
>> @@ -1741,6 +1741,10 @@ void arm_cpu_post_init(Object *obj)
>>
>>       if (!arm_feature(&cpu->env, ARM_FEATURE_M)) {
>>           qdev_property_add_static(DEVICE(obj), &arm_cpu_reset_hivecs_property);
>> +
>> +        if (arm_feature(&cpu->env, ARM_FEATURE_V7)) {
>> +            object_property_add_bool(obj, "pmu", arm_get_pmu, arm_set_pmu);
>> +        }
> 
> Not every V7 CPU has a PMU[*]. Unfortunately for PMUv1 the
> architecture did not define an ID register field for it,
> so there's no ID field you can look at to distinguish
> "has PMUv1" from "has no PMU". (For PMUv2 and later you
> can look at ID_DFR0 bits [27:24]; or for AArch64
> ID_AA64DFR0_EL1.PMUVer.) This is why we have the
> ARM_FEATURE_PMU feature bit. So the correct way to determine
> "does this CPU have a PMU and so it's OK to add the 'pmu'
> property" is to look at ARM_FEATURE_PMU. Which is what
> we already do.
> 
> Alternatively, if you want to make the property always
> present even on CPUs where it can't be set, you need
> to have some mechanism for having the user's attempt to
> enable it fail. But mostly for Arm at the moment we
> have properties which are only present when they're
> meaningful. (I'm not opposed to changing this -- it would
> arguably be cleaner to have properties be per-class,
> not per-object, to aid in introspection. But it's a big
> task and probably not easy.)

Why not disabling PMU fail for V7 then? If the guest cannot know the 
presence or the lack of PMUv1, disabling PMUv1 for a V7 CPU that has one 
is as wrong as enabling PMUv1 for a V7 CPU lacking PMUv1.

Regards,
Akihiko Odaki

