Return-Path: <kvm+bounces-61142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 15182C0C35D
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 08:57:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3836E4EF129
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 07:56:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E93A2E4279;
	Mon, 27 Oct 2025 07:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KeEf6Nmp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88EB32DF3EA
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 07:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761551765; cv=none; b=rLADlvTYNsr0bskulYcqZbciZ+pI/acthgzMwI/sz27VclsPW0zDIPckgtS3pE/k0B156Jv3C2VUIBUmZy6Nm/4a1oVCwA8gCK1gkQcx3cMY9r+sac968RplMUEMrKL3Z+OeIp3aoLPJ/3P8NhXxTV6jzrQeC5VCxZdbnJ2hu/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761551765; c=relaxed/simple;
	bh=UuWTyC0YdKe/fv6JFmSpSrVM634YBLyHMn3GeG5yC1s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=joXcnzx9ZjcWTQgC/YlEQVqAJRvALZ6wc/EelCkSJsaMRpqa9nRpwMB62OG6Tpc2/e/oAzwobte8jo+3YNR02v3FlryLS2f2V7xzB7/1LUkIx823bh3t0XSj+yYYatDfJmi6nTSyW6UT6X081sJelg5OOyTpuV6CKCntbjDVlTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KeEf6Nmp; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-426f1574a14so2794213f8f.3
        for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 00:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761551761; x=1762156561; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SQl+NisJFxZKOAs0wWeJ4+Zx/WhIYmpfXNRhIe2eUS0=;
        b=KeEf6Nmp4LXY5njgBWNO56hcyIGzSesZslvXNTTZGK4l5pA/iV0P+2492nconXEtnR
         75wGdDCziP93hLB2hefBB2jCZ6SdYWsK4JscmEiExp+G0E18rZRKAjw7v7kTxlZ6DBB0
         WTU0iReld/qwCO4H8y8EemoxNhUWnsg4Liw2DPpeJlpWMhvRmlIMsDEtQSp9/KA3Zz07
         QZIjC4AVnjL8AaL/WeH94L+ibxVG6sOF+Eib7uY7LWytee9mmJhV9o51Ye4vGdv7fKu0
         uaMm8YcevNofAaaIJagItS8Y9jr8MRWuDuvy/q91W3f9Nlx7GijLU9iJC1UYPYActREW
         D1FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761551761; x=1762156561;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SQl+NisJFxZKOAs0wWeJ4+Zx/WhIYmpfXNRhIe2eUS0=;
        b=fvzJ2j2YOri6n2PtQqWhbH4l4gtVbnAvLv/LoT1+ULCHxj3fffWVklXoCiqEORgaLP
         OecLe0zT3StLm52s3Wk/tym6F/zZNxeMS3m5hubcZciOAr3e4PkrcGiZU+8tcq+RDF7r
         +OOqnK13al4VRXUA3iTCnJPAvpgGTwro9L8YWt2i7+QE8jkVHeH1wziu5Dk5bnmuKZ9a
         xpQGFKQx3aMwZA+6p6x1pn4EX5fALX8S/WihoveRzcvA0MKJfWEXQrlob1yASyVoxLLE
         k83OoO8NxkFSzGetvOEnCOX6Os99dZLdPxHjT4yca7UL/rRWu2rpXj6HxEYtA7hjWVyl
         /iYA==
X-Forwarded-Encrypted: i=1; AJvYcCX/M3vFLbtQkx2dTLNYoRnW9/ndvfE0TfuS05SwMuhCH8z26mR2sSuUWA1T7wpoRcvq860=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtwSzjf0JpqakVieT6lGUtlABZesnUT7C+BVCdHx/i9ESDDB21
	7z8vHREhXdrz2rvP8k0Z9G1gALmMvpeBy5LVMqMQyRSUU3ahChXTZrIOd3tbWh8NleM=
X-Gm-Gg: ASbGnctM6Fsi/jbZSeXHAaNVe/Sj3xSI9ZXqc4eEBzmOeKGBrslNFN06XtInHy2TVDu
	E9zSSP7/8V/UTr7Q8RC2XVriMZhe8yQ+yXZEa2Li6EXpqBWO7qqQgpismK4GEgiCbH0YyL69+jP
	2g0jC90ZiY9tdgahLNagGY6P1v5IBVMolLbi6K/Pb2uBJ6nArAA+x9Ji5indcQcSyDjULwEK27g
	oUVpP5B/9bV8rzKLEMzibIgdbdHP46FN2RWLzfbiYuQ7brEM48ml3HH/VOOauoaW+XUDhz5XXB/
	iW9qhRQpD+ZMZYU0Q6hRBNatjkKrF3GhLzVUj39LzUd5Mc5R/xyrqdDVOTTHbQlWIy5opEpDP+e
	yV5wEs8AQpE8/2ZdB6/R90iuiftYo+Cf7nQhyub+qZG0zBUJ1E5wBaQZ1+EZ4a7P8q9cSu8Kr+J
	SnbrMCwiEvAUvvusxB0saOO0UQXc8UtWuGh4dWv8rEvfovloNmevZYfkOx3jTteA38fA==
X-Google-Smtp-Source: AGHT+IEoa7YoqXjwVsW1lLWBoPF6gggZOI6+XF3bY9ecPa74D9gFf4/xAH6v1KQ7ZxIhD5F1vKXGuw==
X-Received: by 2002:a05:6000:2508:b0:427:9d7:8720 with SMTP id ffacd0b85a97d-4298a04e95fmr10995412f8f.24.1761551760763;
        Mon, 27 Oct 2025 00:56:00 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:404:4d10:9f16:e9b1:dc97:28e6? ([2a01:e0a:404:4d10:9f16:e9b1:dc97:28e6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952cb7dcsm13127131f8f.11.2025.10.27.00.55.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 00:56:00 -0700 (PDT)
Message-ID: <05a6fb35-a2ad-45f1-9a84-79477560442c@linaro.org>
Date: Mon, 27 Oct 2025 08:55:55 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 24/24] whpx: apic: use non-deprecated APIs to control
 interrupt controller state
Content-Language: en-US
To: Bernhard Beschow <shentey@gmail.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org, Mohamed Mediouni <mohamed@unpredictable.fr>
Cc: Alexander Graf <agraf@csgraf.de>,
 Richard Henderson <richard.henderson@linaro.org>,
 Cameron Esfahani <dirty@apple.com>, Mads Ynddal <mads@ynddal.dk>,
 qemu-arm@nongnu.org, Ani Sinha <anisinha@redhat.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>,
 Eduardo Habkost <eduardo@habkost.net>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Yanan Wang <wangyanan55@huawei.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Shannon Zhao <shannon.zhaosl@gmail.com>, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Pedro Barbuda <pbarbuda@microsoft.com>, Zhao Liu <zhao1.liu@intel.com>,
 Roman Bolshakov <rbolshakov@ddn.com>
References: <20251016165520.62532-1-mohamed@unpredictable.fr>
 <20251016165520.62532-25-mohamed@unpredictable.fr>
 <2cbd9feb-2c20-46e0-af40-0bd64060dfba@linaro.org>
 <6982BC4E-1F59-47AD-B6E6-9FFF4212C627@gmail.com>
 <60cd413d-d901-4da7-acb6-c9d47a198c9c@linaro.org>
 <0C41CA0E-C523-4C00-AD07-71F6A7890C0E@gmail.com>
 <4F98A2AD-02A7-4A7F-91B8-269E9EC8E5B1@gmail.com>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <4F98A2AD-02A7-4A7F-91B8-269E9EC8E5B1@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2025-10-23 19:02, Bernhard Beschow wrote:
> 
> 
> Am 23. Oktober 2025 09:23:58 UTC schrieb Bernhard Beschow <shentey@gmail.com>:
>>
>>
>> Am 23. Oktober 2025 06:33:18 UTC schrieb "Philippe Mathieu-Daudé" <philmd@linaro.org>:
>>> On 20/10/25 12:27, Bernhard Beschow wrote:
>>>>
>>>>
>>>> Am 16. Oktober 2025 17:15:42 UTC schrieb Pierrick Bouvier <pierrick.bouvier@linaro.org>:
>>>>> On 10/16/25 9:55 AM, Mohamed Mediouni wrote:
>>>>>> WHvGetVirtualProcessorInterruptControllerState2 and
>>>>>> WHvSetVirtualProcessorInterruptControllerState2 are
>>>>>> deprecated since Windows 10 version 2004.
>>>>>>
>>>>>> Use the non-deprecated WHvGetVirtualProcessorState and
>>>>>> WHvSetVirtualProcessorState when available.
>>>>>>
>>>>>> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
>>>>>> ---
>>>>>>     include/system/whpx-internal.h |  9 +++++++
>>>>>>     target/i386/whpx/whpx-apic.c   | 46 +++++++++++++++++++++++++---------
>>>>>>     2 files changed, 43 insertions(+), 12 deletions(-)
>>>>>
>>>>> Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>>>>
>>>> Couldn't we merge this patch already until the rest of the series is figured out?
>>>
>>> OK if you provide your Tested-by tag (:
>>
>> Oh, I did for an older version of the series w/o this patch: <https://lore.kernel.org/qemu-devel/5758AEBA-9E33-4DCA-9B08-0AF91FD03B0E@gmail.com/>
>>
>> I'll retest.
> 
> Unfortunately I get:
> 
> WHvSetVirtualProcessorInterruptControllerState failed: c0350005
> 
> and the VM terminates. Reverting the patch resolves the problem.
> 
> Best regards,
> Bernhard

Thanks for testing it Bernhard.
I didn't have time to run latest versions Mohamed posted.

Pierrick

