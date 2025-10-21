Return-Path: <kvm+bounces-60671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 33328BF7075
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 16:21:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A85DF3551DB
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 14:21:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 338A82D6E67;
	Tue, 21 Oct 2025 14:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qnVhw4WO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B79081AA8
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 14:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761056503; cv=none; b=mH7N2mztv35/eRp7fbdqLUkFUG1oiADU0gQkKqJf7b/w5NDSrHe7UdyPjB1BxXTzI26TSnsEC5xT5MeuTd6EIQ7sLJy80mpwmAqE+117KP+RuZMX36z+VkZxOw4xRYpRjbQQm+wZElrNSalCWuuokjiAlGf6qgzvVfvfhS8M3xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761056503; c=relaxed/simple;
	bh=yoNcGazAmmBdFKDju/F45MjOX4Pk2Miv9Xj4Xsz3nKA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VJIgiYrEaXf4LMF4FKpaAcR2HYPIF2o/7ekvqX04wA8ja54KVPqU6r95OteZ01vEecgNZDVCpGPWzQoL0j5pSaycEDuqRgjSpkwqPVkt2QWLhqULIinNamb2eUe8dZ3MKMXffkbYVQi5ULBzALFZwX08GRNvz8mzBR9tIbL7klU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qnVhw4WO; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-47112a73785so43266355e9.3
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 07:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761056499; x=1761661299; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TbDfCBsg1ewIRXAuyiRlLRo57QfPgJYdnTBew9UVKu4=;
        b=qnVhw4WO29IlJg586InvvfXAFloZqr+PtXY6mxyf8D5ly0deUQTr3LfqzCo29nK5Sa
         kBXsw3y6g2GM+rHDvdlmmiKkClYT2cPs6tiasfBIi695cNDdYvhvWcyAfhD5fSlfIDNe
         tYu2SPRpQDxffddZpBdAFiYWM7z3VGEXYqEIy52O7UibeIh2BPw36gPiqpKFtaUtgMWy
         Ugwucs5s+/JW5XzjL/wlFLh/EFog/iAkLSAaK2sPS6LnUOqwckrS4rGsbaZXNVi7gcgi
         eQ4dLOAizf0cdF4hcCDWpT/ALQ3a/y13XBEvncmb6EwDlSFAO60HoVTxkxMxwV41iWbS
         u5Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761056499; x=1761661299;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TbDfCBsg1ewIRXAuyiRlLRo57QfPgJYdnTBew9UVKu4=;
        b=vOtHejsiri0zOjoG8mz9svYVvYxT22TCRrMopiT93uM+WG/k2DLcVPmRIk4WHXucnv
         nryZQn+wtSDSGvRt8X01sYoqwcyeFz4+wKL2v48R8jfu1Dvi59Epj1R02qnlH87CfqIC
         x1jynXxDHd8YbUlX+M/oSlXOgZaD9FQ6PpF9X/mG1p39vHwhgEl76kL5gHp88AatCWtf
         vI2XeJz8SbWAgQFbewiE2e7ozV9WvfgnGGTdN7RQnTh7ZSl+LgBlnEcjRxZgB16TEPiY
         YRGrGdm6cKwv/R9wUwrgjzJ18/C9rf9QP8RVqhKUJWZoKsBC8F1ivxNj9hgy2JXLNDZV
         qZTA==
X-Forwarded-Encrypted: i=1; AJvYcCWtw3EaRuq/nYxTPbp/wgw/M8CIfl7QwIRJtGvBY/3QocKNrh9jWNi+it2QB4oWUvXPq2g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxk4nJnjMtocKYGhKigJsJrAvoF/2XvweOzsFDBV04p0GNXVVv8
	D/jQm5jhOZ7fawghph9oglEVN3GFqIpHPdJEvruj/Mei8Z/8QtMd/RlsUssuVvJCzBU=
X-Gm-Gg: ASbGncvLbYfpkWcGqm06Uc0z+fBHhV81giQVI8MUY0Ju21pIKkiAcC3G4b3XGIB3NFk
	M/gM1qAwuHullDzayV4yOHatNin3oU4wQAMzB8HK/JYx2pLBwYx1lZG+p4ALmbbgOcaV32yyuP3
	N+wzXTkMJKkRNmze9XHkttCEBTHFXi13IAixB26oWN64ma7R3Isv1pL7M4obCUVDShfKkgyqN6X
	9mzComuCvOFsqr7GC059Ammp75bT8oeXztRZQFEGwrMf9/ykH0k8JtDw7Zqr5FJov0eZg8980Sf
	HQbDE+OA10YOWasrmRH/WnaHRIrENGSijHU8bl5T8yjfS4KOu58aaJvjbQ6aihGJyj2KCne4qre
	8nvtFggdU2W7YE0JmTMPXdjzbArgfecsVT2camnZ7RUuuybsW+v0ygGeXaTi/1L8odrK2RRVDo5
	wHBq7a+e5Ld5CxCZhtgXCCT/kCag1TMjuyVjvA6Q9lxMQ=
X-Google-Smtp-Source: AGHT+IFEizekRvWtYb0p6De8rFWOEeTQOsDv4QI5SV5e4hWTGxEDcjnyTvXlhwsnfp48OL5LAvw3Lw==
X-Received: by 2002:a05:600c:64cf:b0:46e:45fd:946e with SMTP id 5b1f17b1804b1-4711791ad90mr128608015e9.31.1761056499582;
        Tue, 21 Oct 2025 07:21:39 -0700 (PDT)
Received: from [192.168.69.221] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-471144c82b8sm284071655e9.15.2025.10.21.07.21.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 07:21:38 -0700 (PDT)
Message-ID: <d264c81b-119e-439f-a4c2-68a7336d6ba6@linaro.org>
Date: Tue, 21 Oct 2025 16:21:37 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/11] hw/ppc/spapr: Inline spapr_dtb_needed()
Content-Language: en-US
To: Chinmay Rath <rathc@linux.ibm.com>, qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org, Nicholas Piggin <npiggin@gmail.com>,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>, =?UTF-8?Q?C=C3=A9dric_Le_Goater?=
 <clg@redhat.com>
References: <20251021084346.73671-1-philmd@linaro.org>
 <20251021084346.73671-5-philmd@linaro.org>
 <602c19bc-bed9-43c2-b98c-491b75921604@linux.ibm.com>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <602c19bc-bed9-43c2-b98c-491b75921604@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 21/10/25 15:25, Chinmay Rath wrote:
> Hey Philippe,
> The commit message says that this commit is inline-ing 
> spapr_dtb_needed(), but it is actually removing it. I think it's better 
> to convey that in the commit message.
> Or did I miss something ?
> 
> On 10/21/25 14:13, Philippe Mathieu-Daudé wrote:
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> ---
>>   hw/ppc/spapr.c | 6 ------
>>   1 file changed, 6 deletions(-)
>>
>> diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
>> index 458d1c29b4d..ad9fc61c299 100644
>> --- a/hw/ppc/spapr.c
>> +++ b/hw/ppc/spapr.c
>> @@ -2053,11 +2053,6 @@ static const VMStateDescription 
>> vmstate_spapr_irq_map = {
>>       },
>>   };
>> -static bool spapr_dtb_needed(void *opaque)
>> -{
>> -    return true; /* backward migration compat */
>> -}
>> -
>>   static int spapr_dtb_pre_load(void *opaque)
>>   {
>>       SpaprMachineState *spapr = (SpaprMachineState *)opaque;
>> @@ -2073,7 +2068,6 @@ static const VMStateDescription 
>> vmstate_spapr_dtb = {
>>       .name = "spapr_dtb",
>>       .version_id = 1,
> 
> Does this version number need to be incremented ?

No, this is a no-op.

> 
> Regards,
> Chinmay
> 
>>       .minimum_version_id = 1,
>> -    .needed = spapr_dtb_needed,

Here is the inlining, as '.needed = true' is the default.

Would "Inline and remove spapr_dtb_needed()" be clearer?

>>       .pre_load = spapr_dtb_pre_load,
>>       .fields = (const VMStateField[]) {
>>           VMSTATE_UINT32(fdt_initial_size, SpaprMachineState),


