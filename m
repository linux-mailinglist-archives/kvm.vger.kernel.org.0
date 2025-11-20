Return-Path: <kvm+bounces-63830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 160ABC7382B
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 11:44:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4173A4E2CF5
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 10:43:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF75332C94A;
	Thu, 20 Nov 2025 10:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qyjqM7N8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C1130E843
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 10:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763635428; cv=none; b=ddAGfJwszMd7vmUYRpzSaTRvqWeVd8LMBWjMjt84+JapocnI3ZKt8MJ72OzDQ6E71Xa5SsgDLYiEySjEdt+vcRNfHkIsUxf4f8lkz5k5npkXboJGKVLNWCX82b9WZOsTL8vGHcQAZalBy73fRxV9Ful2DPG4TxogsBFows++xh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763635428; c=relaxed/simple;
	bh=MbA9H+RwW5ZqdWuv+HONXve++UBdBrFLTUyzU+kGvVk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ntcN4UogHyvIS6UJ8G3uY4yk092dKsrbhAOq8xo/pMC9XzUs6OS3gPUpc+9QCoiPxvtoM83DPUFmhUVguFxdsEfHM6xxuLYiu9Hly5gxLGAOWfs23CaeWmDFKIk5RuMSRe9JW09gDofOaNvkdVuf5gyX2q4gBjDgPJYqNSFbboY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qyjqM7N8; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4779d47be12so5998905e9.2
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 02:43:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763635424; x=1764240224; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7oHOv6TarlQbLUVDxxSIUN/NgK6M7FvSaHEHJevpMjw=;
        b=qyjqM7N8YEz3NH7mwWsTHv7wf9MJVKZXZ/oVEjmVCpj7AzVR6WeOG6UwDFM6XWAMWT
         KlCzWcx8W7WMYbHH52aiM2X5tWgxIKI2MltqNH8dEuxz+5yRwRdVaiDW4csJWJStnEiG
         IPWr6UpYNBb49qPWvC4vV5Q4vEwj7gLJIkFjma4ZSh1hwZiNJijvRPElHt0I/tE5jdn9
         TlEpSOHSOqtKf4ZCA8mFIDKOo7eSDuQ3JEqbPrUmXaFoGFVYa6JLfpNBonBRD+6qyMQd
         TMxDAgw07TdqvzOJTNipBIFJupKKcPAt0DdbhMfHCjC/asygo6Vd4uQx8ZR2YzMkEwC2
         dtPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763635424; x=1764240224;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7oHOv6TarlQbLUVDxxSIUN/NgK6M7FvSaHEHJevpMjw=;
        b=B0W3KH+97dXGzaZsv7aZDGiFZyGpB/AlZhAKtbY79xTHsHHi3WjOiN4/6aJq2vbICj
         gECJoNm1z9AO7fvb7g6YMu4OEMhx6F/s4K0qCwq/SYI7n9euFkrL1w8+2+DtbzUVTBue
         lkp/HFEOpTbKohe8m7ucXK5NcrHmylbs5//6Mz013OINalolOO7xjfS9Cogk6w+dovzh
         VQ2yngz8TlofHFYGb0kj3Q6Ta2CshGAxWUcSm+LyANTUQ0Ao3vlF99+xnuK4nIhMkBOT
         wg0NtB/RnK4GVQzIkQpQ7bTkd9GunnAtghSK4q816zTIxQQZZjPH9KGi8Ql6NFElST8P
         QeaA==
X-Forwarded-Encrypted: i=1; AJvYcCXL6Z2TrtXcwEkeqzfeIWyxM/sXO1/UXusoCOh8zdvxi7J05DpFheJvJPIEegnufkW53q0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLwVYl95vpAf0/WdAeL7KUCBrAlu4zZYPbgEa+UWsvJnkmejFj
	UPuMdVA4Gv1vXuTvUDcphofYZzbTFigu/dl3LbLsRd8H5vaDS3pEdNX01KXMm680lVk=
X-Gm-Gg: ASbGnctIdbVKBvigT0gsvTlAyOvcfwEzO4WQpN+bTb6Ax5XE7CjK64FYTudrDbl5RJZ
	UKNKvQvIcMdrToFXT6raN3pqHgE6PyMZ+aIhJG25/W6n7jkJJE0GT2wcXFs34V12XayBY3iE4lX
	0KRuPD9s03ArSA3hD23KwFs2WjO8bE/Dk5aGgBHQtG18GEkjBlHpB+QJl14iL+izDhjzOXfostT
	eb/jjqHFVCm81eBfI2H/075eY8DVUijOdb0whz1QpkDxQppse5pfHIDBiudUOWp4bYcp0RRdejM
	lPt6P3C+2ePDY/P6IGlk9mE8PeUt6qjmgJ6rkW1E/GhNXp5EFFYl0GQ2HQnIQFbaqdzRSiWHQXe
	Npw8nudUCUZSMA1cAZRIuu90Fu1DD9d66VBoP+pDMjRGu2C6fd3W4UA/RI8gEMjcKWWGvWgo0AI
	X2IsmeInJxvm/Xqvc+SXgbswUmvaSXRNM5VcqlKTyqc9p7aqlmaqsdLw==
X-Google-Smtp-Source: AGHT+IEMgQ5A/ngM4oB7aYVi/VQg/3amHDLzSn7jIdobyyplBkmG3dA8rWbfZr7EIB9azrG7yf2qjA==
X-Received: by 2002:a05:600c:1550:b0:477:a54a:acba with SMTP id 5b1f17b1804b1-477b9e1cbe5mr23604595e9.17.1763635424278;
        Thu, 20 Nov 2025 02:43:44 -0800 (PST)
Received: from [192.168.69.210] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477b831421fsm40121035e9.10.2025.11.20.02.43.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Nov 2025 02:43:43 -0800 (PST)
Message-ID: <43427fac-db73-43af-bbf6-93bc3d978706@linaro.org>
Date: Thu, 20 Nov 2025 11:43:42 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] target/arm/kvm: add kvm-psci-version vcpu property
Content-Language: en-US
To: eric.auger@redhat.com, Sebastian Ott <sebott@redhat.com>
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev
References: <20251112181357.38999-1-sebott@redhat.com>
 <20251112181357.38999-3-sebott@redhat.com>
 <d4f17034-94d9-4fdb-9d9d-c027dbc1e9b3@linaro.org>
 <c082340f-31b1-e690-8c29-c8d39edf8d35@redhat.com>
 <a2d0ddf1-f00c-42dd-851d-53f2ec789986@redhat.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <a2d0ddf1-f00c-42dd-851d-53f2ec789986@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 20/11/25 11:10, Eric Auger wrote:
> 
> 
> On 11/13/25 1:05 PM, Sebastian Ott wrote:
>> Hi Philippe,
>>
>> On Wed, 12 Nov 2025, Philippe Mathieu-Daudé wrote:
>>> On 12/11/25 19:13, Sebastian Ott wrote:
>>>>   Provide a kvm specific vcpu property to override the default
>>>>   (as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
>>>>   by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
>>>>
>>>>   Note: in order to support PSCI v0.1 we need to drop vcpu
>>>>   initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
>>>>
>>>>   Signed-off-by: Sebastian Ott <sebott@redhat.com>
>>>>   ---
>>>>     docs/system/arm/cpu-features.rst |  5 +++
>>>>     target/arm/cpu.h                 |  6 +++
>>>>     target/arm/kvm.c                 | 64
>>>> +++++++++++++++++++++++++++++++-
>>>>     3 files changed, 74 insertions(+), 1 deletion(-)
>>>
>>>
>>>>   diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>>>>   index 0d57081e69..e91b1abfb8 100644
>>>>   --- a/target/arm/kvm.c
>>>>   +++ b/target/arm/kvm.c
>>>>   @@ -484,6 +484,49 @@ static void kvm_steal_time_set(Object *obj, bool
>>>>   value, Error **errp)
>>>>         ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON :
>>>>     ON_OFF_AUTO_OFF;
>>>>     }
>>>>
>>>>   +struct psci_version {
>>>>   +    uint32_t number;
>>>>   +    const char *str;
>>>>   +};
>>>>   +
>>>>   +static const struct psci_version psci_versions[] = {
>>>>   +    { QEMU_PSCI_VERSION_0_1, "0.1" },
>>>>   +    { QEMU_PSCI_VERSION_0_2, "0.2" },
>>>>   +    { QEMU_PSCI_VERSION_1_0, "1.0" },
>>>>   +    { QEMU_PSCI_VERSION_1_1, "1.1" },
>>>>   +    { QEMU_PSCI_VERSION_1_2, "1.2" },
>>>>   +    { QEMU_PSCI_VERSION_1_3, "1.3" },
>>>>   +    { -1, NULL },
>>>>   +};
>>>
>>>
>>>>   @@ -505,6 +548,12 @@ void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
>>>>                                  kvm_steal_time_set);
>>>>         object_property_set_description(obj, "kvm-steal-time",
>>>>                                         "Set off to disable KVM steal
>>>>   time.");
>>>>   +
>>>>   +    object_property_add_str(obj, "kvm-psci-version",
>>>>   kvm_get_psci_version,
>>>>   +                            kvm_set_psci_version);
>>>>   +    object_property_set_description(obj, "kvm-psci-version",
>>>>   +                                    "Set PSCI version. "
>>>>   +                                    "Valid values are 0.1, 0.2,
>>>> 1.0, 1.1,
>>>>   1.2, 1.3");
>>>
>>> Could we enumerate from psci_versions[] here?
>>>
>>
>> Hm, we'd need to concatenate these. Either manually:
>> "Valid values are " psci_versions[0].str ", " psci_versions[1].str ",
>> " ... which is not pretty and still needs to be touched for a new
>> version.
>>
>> Or by a helper function that puts these in a new array and uses smth like
>> g_strjoinv(", ", array);
>> But that's quite a bit of extra code that needs to be maintained without
>> much gain.
>>
>> Or we shy away from the issue and rephrase that to:
>> "Valid values include 1.0, 1.1, 1.2, 1.3"
> Personally I would vote for keeping it as is

OK.

> (by the way why did you
> moit 0.1 and 0.2 above?)
> 
> Eric
>>
>> Since the intended use case is via machine types and I don't expect a
>> lot of users setting the psci version manually - I vote for option 3.
>>
>> Opinions?
>>
>> Sebastian
> 


