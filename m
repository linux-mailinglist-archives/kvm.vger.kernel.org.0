Return-Path: <kvm+bounces-63828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7ACADC7367E
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 11:13:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2B8554ECA38
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 10:10:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0981930E82E;
	Thu, 20 Nov 2025 10:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hMu2yIsU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F32921FF28
	for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 10:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763633435; cv=none; b=UIgeWVPvx+YdlsEEMsR7lCDMN9dHawh1tPEtHxmCt8+PnmpbbIzb6y04EJwG3nj/f1a/SDQGk5AD7GVrnNubGgdsoWMKQWcYOK6zwZieeFx5HhqbzRmHNINcPNAR2dGrWFvBbYZKiErcbPC3CSUH2C6pCETmTJ6pp+GmDYdEFy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763633435; c=relaxed/simple;
	bh=HeoDb+vlF915PRVllvP6sQ90CREKCg4bhArXpU7WssA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=feesyrfveJY5BD8EXJDrO5USejgT2wr6CNID1YgiE1sc76g9NfRRbKnhkCBfe1UUKVxamhCuTxJEYTUvZOFb6M75Xaowq0OJYuxQmzHujH3ghgz9F+TFfdI+iKrZDWU+6Q37Ga1cQAqpktrxcaoCN7prVAV3JXg/4QAw6KSkcB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hMu2yIsU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763633432;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HeoDb+vlF915PRVllvP6sQ90CREKCg4bhArXpU7WssA=;
	b=hMu2yIsUqdFfENqzpl+UZDV/K4XXos+QfFgtQnVkKcJxV4ABoyZvPvGpL4xAgQoFwjLwy9
	8HBbuhvbUPFgIbLLN0RqjIPEEAPIk42f6m882AA2n3NwjUhyCFclaNb3VFswpEakiCHwhJ
	sezuJ/obmhXGpwZN0C8u7koawztJ408=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-cMA8gCDJOnqDg5FSJJxFpQ-1; Thu, 20 Nov 2025 05:10:29 -0500
X-MC-Unique: cMA8gCDJOnqDg5FSJJxFpQ-1
X-Mimecast-MFC-AGG-ID: cMA8gCDJOnqDg5FSJJxFpQ_1763633428
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-47106720618so6614515e9.1
        for <kvm@vger.kernel.org>; Thu, 20 Nov 2025 02:10:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763633428; x=1764238228;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HeoDb+vlF915PRVllvP6sQ90CREKCg4bhArXpU7WssA=;
        b=cXzGn/sT7GeGJ0yvMzT9Ox3f2MMpmzRao4ElhnKiHv+4Y9KeXIq6pN13L4BRIGv2hj
         Tk+DzCrUEuhiOQcDcXOBy8ePtyjvfd4Febox/Hy7PrteHZGCujd0Cm9T0DpCcamNRSCq
         ZZNP23mGvUX6dt/vNMOh32GpTPSOxfaJd4y+yoRIPTGg8wkZ8eACq+iu1jl1OGKkUlJX
         Es2YejQxoAP3WnTqRgeUWtrCA1Ute0F59Vec/PAGCZKK+yJeNLOaGSzfnWwyCH0pnRLC
         qhZtUHiT87bTbthTnaDt0LYcnwdGkxuN5VSMbE1ASjZ3C7ZTd4EdvaymdzJDNj/8O4kJ
         gg8g==
X-Forwarded-Encrypted: i=1; AJvYcCU6YHkd2Zc7N3tAFBBnGj+ZMwLj10kgrFWd/2g0O7QxqnjcHc+GbIzedcNLzbGkptNSWm0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAFt/HUg/OhL4PUKOclmAXZJb8yuRzuP5biO2rtvb6q9gVrbSE
	2BUAvdKVk41p6iTR1ZfWYzw1w4JjaRSHJj0vstQ3pr/CPG7nXOfl1AnLLOQCMOlBi9O6MbdGLZT
	CJFXkDaqfRjzgrh1f8/OQvN7tNrj96gNCTUH3I0uY83PRgANTxoPqiOdeDz4wDA==
X-Gm-Gg: ASbGncugvMVEJggKpihJuTVhw3BWxij/q1AguiWW34Ne2VGKypYPol1/l416lLA5HI0
	/A7hLwftYM1I8wQ4PPN+wkY7pAsKLJMMUegz14B/4I4AOC8dbEnmVuc5XhgI8T8hrJzHVeRPL0g
	VCp5b34kUv+SwOenyJag+ks/S7PliIYNZZPwr/F0ObSHsdR5nzfP/NUM6KKcyoUtcjxi6utoVYN
	iYcMfeAY7IBTYqFGaFP/1j8aBLynQ9/+o2i2dejrwHWthZTzW/57PV3n4lA0FZH+wQRtgAB/FTB
	Ay0kEcSQwBRRa2nN5NGxPgc1fCsj17TkYBKk9MA3Mn/HAJXh1lneZkdz/YBUoa/TBCzaqWY6BRK
	iD/0YhnzGphsvvdsmgt9pQNV7JrwJ25tJsbZhpZ3RpJm+2qOEeKWx9B/wsg==
X-Received: by 2002:a05:600c:1d26:b0:471:1717:411 with SMTP id 5b1f17b1804b1-477b9e2bcb6mr19350405e9.24.1763633428204;
        Thu, 20 Nov 2025 02:10:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHn8i/nIi7fng7vNcKrFRWxYoraaRwDoQuaqyZbsNoVahq6dZkJgw5xsH9XpdRKx7HNqjDlIA==
X-Received: by 2002:a05:600c:1d26:b0:471:1717:411 with SMTP id 5b1f17b1804b1-477b9e2bcb6mr19349995e9.24.1763633427742;
        Thu, 20 Nov 2025 02:10:27 -0800 (PST)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477a96a58c5sm64071555e9.0.2025.11.20.02.10.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Nov 2025 02:10:26 -0800 (PST)
Message-ID: <a2d0ddf1-f00c-42dd-851d-53f2ec789986@redhat.com>
Date: Thu, 20 Nov 2025 11:10:25 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 2/2] target/arm/kvm: add kvm-psci-version vcpu property
Content-Language: en-US
To: Sebastian Ott <sebott@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev
References: <20251112181357.38999-1-sebott@redhat.com>
 <20251112181357.38999-3-sebott@redhat.com>
 <d4f17034-94d9-4fdb-9d9d-c027dbc1e9b3@linaro.org>
 <c082340f-31b1-e690-8c29-c8d39edf8d35@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <c082340f-31b1-e690-8c29-c8d39edf8d35@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 11/13/25 1:05 PM, Sebastian Ott wrote:
> Hi Philippe,
>
> On Wed, 12 Nov 2025, Philippe Mathieu-Daudé wrote:
>> On 12/11/25 19:13, Sebastian Ott wrote:
>>>  Provide a kvm specific vcpu property to override the default
>>>  (as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
>>>  by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
>>>
>>>  Note: in order to support PSCI v0.1 we need to drop vcpu
>>>  initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
>>>
>>>  Signed-off-by: Sebastian Ott <sebott@redhat.com>
>>>  ---
>>>    docs/system/arm/cpu-features.rst |  5 +++
>>>    target/arm/cpu.h                 |  6 +++
>>>    target/arm/kvm.c                 | 64
>>> +++++++++++++++++++++++++++++++-
>>>    3 files changed, 74 insertions(+), 1 deletion(-)
>>
>>
>>>  diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>>>  index 0d57081e69..e91b1abfb8 100644
>>>  --- a/target/arm/kvm.c
>>>  +++ b/target/arm/kvm.c
>>>  @@ -484,6 +484,49 @@ static void kvm_steal_time_set(Object *obj, bool
>>>  value, Error **errp)
>>>        ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON :
>>>    ON_OFF_AUTO_OFF;
>>>    }
>>>
>>>  +struct psci_version {
>>>  +    uint32_t number;
>>>  +    const char *str;
>>>  +};
>>>  +
>>>  +static const struct psci_version psci_versions[] = {
>>>  +    { QEMU_PSCI_VERSION_0_1, "0.1" },
>>>  +    { QEMU_PSCI_VERSION_0_2, "0.2" },
>>>  +    { QEMU_PSCI_VERSION_1_0, "1.0" },
>>>  +    { QEMU_PSCI_VERSION_1_1, "1.1" },
>>>  +    { QEMU_PSCI_VERSION_1_2, "1.2" },
>>>  +    { QEMU_PSCI_VERSION_1_3, "1.3" },
>>>  +    { -1, NULL },
>>>  +};
>>
>>
>>>  @@ -505,6 +548,12 @@ void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
>>>                                 kvm_steal_time_set);
>>>        object_property_set_description(obj, "kvm-steal-time",
>>>                                        "Set off to disable KVM steal
>>>  time.");
>>>  +
>>>  +    object_property_add_str(obj, "kvm-psci-version",
>>>  kvm_get_psci_version,
>>>  +                            kvm_set_psci_version);
>>>  +    object_property_set_description(obj, "kvm-psci-version",
>>>  +                                    "Set PSCI version. "
>>>  +                                    "Valid values are 0.1, 0.2,
>>> 1.0, 1.1,
>>>  1.2, 1.3");
>>
>> Could we enumerate from psci_versions[] here?
>>
>
> Hm, we'd need to concatenate these. Either manually:
> "Valid values are " psci_versions[0].str ", " psci_versions[1].str ",
> " ... which is not pretty and still needs to be touched for a new
> version.
>
> Or by a helper function that puts these in a new array and uses smth like
> g_strjoinv(", ", array);
> But that's quite a bit of extra code that needs to be maintained without
> much gain.
>
> Or we shy away from the issue and rephrase that to:
> "Valid values include 1.0, 1.1, 1.2, 1.3" 
Personally I would vote for keeping it as is (by the way why did you
moit 0.1 and 0.2 above?)

Eric
>
> Since the intended use case is via machine types and I don't expect a
> lot of users setting the psci version manually - I vote for option 3.
>
> Opinions?
>
> Sebastian


