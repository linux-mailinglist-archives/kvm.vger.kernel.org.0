Return-Path: <kvm+bounces-60176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 93E2DBE4CCA
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 19:12:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9EC4B1A65F44
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 17:12:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 431163346B5;
	Thu, 16 Oct 2025 17:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BpsmiVcm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACCC334680
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760634742; cv=none; b=PtG/5pmJmvxO/sQVViH3Qg1uyhacm8tVh0HsTdMjzZ1ThzQaXXmNtk3u6nOx2h+hoWeJ/mU7EZldZzgg/mgqW/CZQpSHW6rk1UT/WAuUiAAXDaHSoDx6GYTah4ewU28MYQuw1cS04dBRMvl1idnT+7mztSjCXm3d5FOHHlyUJns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760634742; c=relaxed/simple;
	bh=10C5p9/I9KgZDZ9emDZirgoHmJEhu364HuyzI4sSv38=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RQveeP8s3gMVLzczPOL5BpsdyILRfaa5dmzlezMund4HEfMqfl+3pDywxpS/sOdELEOH2KVl7gaM4heM6M3caQMLTOTYplAuZcmywaDCmtkQWe2o1dLCoXS0Fz5cgTN1+wCJQlQQS6y+A1fkp5BohBPQIXavxJABQbzkRRYNpZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BpsmiVcm; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-33292adb180so997057a91.3
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 10:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760634740; x=1761239540; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wqblu1nTC6KBf9GQr3KlSotdtAc28SYiKW3vv2OoNSk=;
        b=BpsmiVcmagqUYaiLIKWxot4CN9STkKjpMJEzCmoo1Vmk/JUvi2M+1SOhTd3kxptIda
         VQAec9UWjq3W9YnAHFiLjkV/nV4FhY3/MmMqHX6Y+bkMg4wb6Ll9MkD2fjCPdZa2SIto
         wlXZKYHZSXCsVDjGAUirY/Yw0MMYMiHwIZHi51ImxLZ8KtnR8Wj2oF/sBl/41FBYejm2
         Sx2cJtQ0n85QGksmN7Y1VYaDERzcfi+8kjTYrq2hARdSdXAsYQ0+VXyY7u2NqSfox3ox
         TM5+QDW27kpumaErFdvlqV2Ou5Rn4U5yQc5gGp6h70QzFDoNDoZaVsCSs7FI4liIH+kQ
         GJxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760634740; x=1761239540;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wqblu1nTC6KBf9GQr3KlSotdtAc28SYiKW3vv2OoNSk=;
        b=IvEBU2m8te1u/FP71/Aav8xJ3JLT7y6vFw0S8Ilh1MndTxo+s5VLkaA1JtamN+2QQ+
         VrCRtAqAKZkIPUdC9pV1dXjvvUCWQN6FoXisS8NRF0iKTcFGiPU7BrQ+1ptaQksNNoWn
         dqynLVFjlt8GJmnIGY7GN8OEpMcXMI0Skd9EBsppW8/HzsDjxi2SYKXXWR+cfqwJyD2R
         2kbBLkWGqkmwa+ryN32rcleYoXufHztMsa0fqNNydM9clxYDoSsx0o6XA0bjpaParEIt
         OfyrjSakBywkiHMBgsNNQ/aIj6DiEn7zLKeNaFY6Y5U3FzDOI9l5DPvpI5sbmKNPvD6J
         s3Gw==
X-Forwarded-Encrypted: i=1; AJvYcCULil2FOLIyNGTPNG/7owpfPEH6RUCJsl0rtxez4F2IsnsMKKMu4rqdScbssEjPp5icMxs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRmHzCPIjg0kiYqu9nt/E5qM+t4j99rQ/bOpNqhTTMS22ZWjA2
	k36wMSQbooAi1+96XSmNymMRsSC95e105Myrn5c20GF/mosbT/+0+oI9QpEbC5Geypk=
X-Gm-Gg: ASbGnctHWW4fg9BLmTHpJdtDWEHNVjpGW5z0kotZuNitudNdfqLXW2gEeDPN3cEpuZL
	jkl1PLxwFF50ML/sPMU/sjOFEFzbRN5QT0SQiWJYBu/RNaGKfViNm64sgWBjfZLfriRfqq6vnmM
	NQT59nhrrRr0L8AQXlLGuuC0QoNUy4OXOLeEXfRCrRoVzZRbpCmbK5pGWux2XbCsNSD4LQQUucm
	NzDtlnZk2nq8pzHG1RPfD6npNS85ijWvzCzoDAumwegt0qenPHKB6CtJQmUW61GcOi+2LxSAcBW
	mAJi2ov5qbQouqoEA3HQ4asSwcLu4lsCQWpFCVkTUksXCxz53XUHBLIkHH8c9hHLDn/uZrrpN5r
	8Hmxgj1qAovY/O9dTPrQGbVzKRJUFBcm7SUl6VKvFZ+TJfIF4Q4Fsrtl2jTKgWr00NdHmCkil3Z
	HtmpzxL3tKEkrS
X-Google-Smtp-Source: AGHT+IHelTFD/6eyJl55bPn6h0h2qCPlAEcjf6xEmaHE7c0nv5FzNep3RfWsm3FjU/yzVLvG86PL9g==
X-Received: by 2002:a17:90b:28c4:b0:338:3789:2e7b with SMTP id 98e67ed59e1d1-33bcf86b5bbmr642520a91.13.1760634740118;
        Thu, 16 Oct 2025 10:12:20 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33bb66c4a93sm2557506a91.23.2025.10.16.10.12.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 10:12:19 -0700 (PDT)
Message-ID: <d44a4957-4b0e-4ab3-a720-04b7fc88978b@linaro.org>
Date: Thu, 16 Oct 2025 10:12:18 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 19/24] whpx: arm64: implement -cpu host
Content-Language: en-US
To: Mohamed Mediouni <mohamed@unpredictable.fr>, qemu-devel@nongnu.org
Cc: Alexander Graf <agraf@csgraf.de>,
 Richard Henderson <richard.henderson@linaro.org>,
 Cameron Esfahani <dirty@apple.com>, Mads Ynddal <mads@ynddal.dk>,
 qemu-arm@nongnu.org, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Ani Sinha <anisinha@redhat.com>,
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
 <20251016165520.62532-20-mohamed@unpredictable.fr>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20251016165520.62532-20-mohamed@unpredictable.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/16/25 9:55 AM, Mohamed Mediouni wrote:
> Logic to fetch MIDR_EL1 for cpu 0 adapted from:
> https://github.com/FEX-Emu/FEX/blob/e6de17e72ef03aa88ba14fa0ec13163061608c74/Source/Windows/Common/CPUFeatures.cpp#L62
> 
> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable.fr>
> ---
>   hw/arm/virt.c              |   2 +-
>   target/arm/cpu64.c         |  19 ++++---
>   target/arm/whpx/whpx-all.c | 104 +++++++++++++++++++++++++++++++++++++
>   target/arm/whpx_arm.h      |   1 +
>   4 files changed, 119 insertions(+), 7 deletions(-)

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>


