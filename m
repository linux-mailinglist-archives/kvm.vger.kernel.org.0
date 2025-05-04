Return-Path: <kvm+bounces-45346-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC64CAA880F
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 18:30:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5BF72174456
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 16:30:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A3CE1DE2CB;
	Sun,  4 May 2025 16:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fUXfSZ+p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9DA1CAB3
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 16:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746376195; cv=none; b=GIegk71ODUTJE6Dsl2v0qeH2X61fIY1JUG4jn2qSP7CfkyphfQBIOxkV25j0ggvYf7M7nJm927p3MVToQsQvJ5dbds6nPwNqw0Ez6o06GPzFPnsxxaOXM46vP9PXterKTjfhzYDYqnVuHQ2XNiKxRYgPrGhzual/Tp+ATVz6ST4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746376195; c=relaxed/simple;
	bh=2EyVuJ9FIm9VU5Kvu/ekfGpJkHg/QbpZB/YJnft1g9g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IQXrs9iNti9MfuyzbnsPEc6PdlgpQraM3vxOTt2vHBZ3a50J9rvx6Ev2mcUHJ/BGef+i2vqAQg0tb9jlleEt6qi7365bnj0HXAp5Sq5MGrCjZPxoVFuzvSjNeonrRsz0PcIQ/gQouHjElTNoc5By2m7VN0ycVaGuKRPEKGRWQ94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fUXfSZ+p; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-224100e9a5cso50541295ad.2
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 09:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746376193; x=1746980993; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=flwasTZuJuRJQjKKfHx/Jki6vfwUMVpkVeX2nZYOmHc=;
        b=fUXfSZ+pFYY5VnjT3mdUJzyFF7h/CKoM0itFWpFerSy63gouQhbkbl3LMXct1fISBA
         DdQwICG4pf3hwwzPwdC6FQOpdd3aNlRlgFBuGj94FZze+75yFZ3R6nGz595WRyk3Z9s8
         eJaje1VgDRGAZAFhNFZic0XVB/qFAJNuDIVDRJMeaqK+2o3O836f/P0S91zL3ouQqk4b
         j8NFsupDll1l9QaocPvIzCswokzUgWBe2/Lol799LV8SQqOBEcCN5GXlCmWdpYg9VuFr
         3DgwF5Gyy5k9kfE85tcMDj0nIIMrakNiyMmBbQ6jAW33yYycyFoFXRGaQ+aWUe5XSB2j
         sRqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746376193; x=1746980993;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=flwasTZuJuRJQjKKfHx/Jki6vfwUMVpkVeX2nZYOmHc=;
        b=G2gp+YdE/yKdI8SHeJgGdCT4c/nlUT0Oddcfe2HoWACJI7nSX6Y5Hc90J0CEkngLD+
         r3FqxaEl59XEMTNS7nDeS53/EtKvWhPBPQyOZsnGxX1F58Zo+rxdbYW9KgtNyHyPKHOb
         jh7iIQ51yvGK0XC6dTxMTqboQ0FF09knrgJbyeXaxD2awZ0Jen5LX9WuxRcJ8e2eo8S3
         5x1YckYnJ0P/rqBvt5qXBCEPYGwooSRUXvplUK6JUOg8SqKH9wFWbWEBaE2kUUpUmPCM
         ZmOENt24nT0VyZVCAWII6yqBuZQbnDIeTwzSfxx5lswSfJkRVCd1pMxWJ25HN3QgYrmn
         7AgA==
X-Forwarded-Encrypted: i=1; AJvYcCWU3MbPBi8YukIek17e8ygnV4R9jXgLLjVi7A4l9/UV22qmzDG5JRMlwQs0xRRL+CFJDP0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMCEG2VIJfYXzOIIpom3luAQGCraGCOuY06VJLXQHUd0SMl4qo
	o/N5tCcXzRFzPaApYG+iKZFiIu6At7IkAhJf2wFo7DZQm0dym7SKMGDEibVleIc=
X-Gm-Gg: ASbGncuEql1Yhlp+kYlFGN4NO/fSweZJ2NLNySZ6r9ROfWW6lCZ96Famn4aYEgF3v9E
	KdfYRvpn506wxsuPN8g+cwpFCw1fupYljFcL28ormoZLkVs3QPxv8QBxuXAbzuztSGlplL3j18J
	tgRAV12ZiAEyc9VHIZKoUii65SLHA8uxU4UBiDaWtPRRIWfJxaqFUoiTrEBpT2yB0+3gRElVbNp
	AfTzVD0+3uUX7OuNsWA0eV2AQYtjXIjCOIWIxyN5mUXgUmatet1gqU9x7Q4TI1hj//WsNdMZjDs
	HVxxOZxX3Ofa5Wf3eNWMWnbm5+6/eNiH4BnoQrLjNaK2YM6rI2lnVA==
X-Google-Smtp-Source: AGHT+IFUvkPvo+NhY3ntt8T6pn9WxQwRYyY1sF5qimroiZid0sEQmoCyAGZR+08a4QGy+f2RwIsoaw==
X-Received: by 2002:a17:903:11c9:b0:226:5dbf:373f with SMTP id d9443c01a7336-22e1e8ca3cbmr61521405ad.10.1746376193168;
        Sun, 04 May 2025 09:29:53 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1521fae5sm39307645ad.132.2025.05.04.09.29.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 May 2025 09:29:52 -0700 (PDT)
Message-ID: <e9381208-fdcd-4c62-b1c7-60cc9f6542ab@linaro.org>
Date: Sun, 4 May 2025 09:29:51 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 16/40] target/arm/helper: use vaddr instead of
 target_ulong for probe_access
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, anjo@rev.ng,
 kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 alex.bennee@linaro.org
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
 <20250504052914.3525365-17-pierrick.bouvier@linaro.org>
 <5b152664-a752-4be8-aa15-8c71c040b026@linaro.org>
Content-Language: en-US
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <5b152664-a752-4be8-aa15-8c71c040b026@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/4/25 9:17 AM, Richard Henderson wrote:
> On 5/3/25 22:28, Pierrick Bouvier wrote:
>> +++ b/target/arm/tcg/translate-a64.c
>> @@ -258,7 +258,7 @@ static void gen_address_with_allocation_tag0(TCGv_i64 dst, TCGv_i64 src)
>>    static void gen_probe_access(DisasContext *s, TCGv_i64 ptr,
>>                                 MMUAccessType acc, int log2_size)
>>    {
>> -    gen_helper_probe_access(tcg_env, ptr,
>> +    gen_helper_probe_access(tcg_env, (TCGv_vaddr) ptr,
>>                                tcg_constant_i32(acc),
>>                                tcg_constant_i32(get_mem_index(s)),
>>                                tcg_constant_i32(1 << log2_size));
> 
> This cast is incorrect.

I'll change to i32/i64 typedef, but I wonder if it's ok in tcg code to 
do this kind of cast, when you know the dh_typecode will match behind 
the hoods?

In this case, I thought it was ok since this compilation units is only 
compiled for 64 bits hosts, thus ensuring TCGv_vaddr has the same 
storage size and dh_typecode behind the hoods.

> You need something akin to tcg_gen_trunc_i64_ptr.
> 
> Alternately, do not create TCGv_vaddr as a distinct type,
> but simply a #define for either TCGv_{i32,i64}.
> 

Ok.

> In this case, it'll be TCGv_i64 and everything will match.
> 
> 
> r~
> 
> 


