Return-Path: <kvm+bounces-45448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C85E1AA9BDF
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 20:47:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FC0E3BECEB
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 18:47:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33AD4EEC3;
	Mon,  5 May 2025 18:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RwWQevWW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0991B0F31
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 18:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746470850; cv=none; b=oIm0mUwu/crZyJPqL6wQcz8h6aaNlTbGHxDWnJgOmPzW3FeR5ir2snpDcpzYkjatlKnlWljl0ceST0eHZ8Ud/aECpa17m8W50RcsWeQCYsqsN325GADwnFVSy1qSbtPNheVeoX0hNIkDUVh5rzMt/arqPnF6eBXpl5+3N23hoVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746470850; c=relaxed/simple;
	bh=aLdfy/UrQEcH/m7jLcG0LldU87pa0pzBIqDP7HfSI6Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bLI2mWBkj8s975Sh9L4dITRxeIKkhWi3un9UzqtlQMHNYMu/NGKoodMCx2pgH02eCSD4Ous0jAN0Ijyk5QcY+9xyXnw2ObQYZ7N6FUayt7G9zObMtnIla+Sgst9bTYQ+CuDrBHEyscICii7FMRAfzYcXsiEQRmJabUiMZXmkaHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RwWQevWW; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-74019695377so3942667b3a.3
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 11:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746470848; x=1747075648; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TrysJu1PXbfeK8SZ2A0j/x6crADYuLFKWDlFDWA0zQo=;
        b=RwWQevWWBoixeRpJGK2C6o0Dwr4vJIFogcETwN6DAsj/sDffsaUpgH8kYvcDN1ErrA
         RTeLfQ57fL2kdMR3IlHht7J485fAup2Q6HIXftknAZ1C9y/sk4953X36Yvf6nZLSGily
         jf1RmsCrFgHN8y1dpcZ+XQAHNHxMGV9H86X9lLxm0I0uugrie8QLge7EVTKehNA50FzG
         ha0ImesSsuUs3H+mRE+aVAIzjG0RJ7XAxSa2hgTvuK83nTDSzW8uIvJy3Wir7UCX0IqX
         h8Aqsy7xUD4ymzRulNBiN6Kx1V4dx9Sg7RH14Q/GyjxlH/9G4KDWhQg1GJurttovBcD1
         nk9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746470848; x=1747075648;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TrysJu1PXbfeK8SZ2A0j/x6crADYuLFKWDlFDWA0zQo=;
        b=ovxp/pbDJskgWM18LG4a5zddWFCfukjyW06auWFWhua16DEY+rKQpkD+Ll7TJaTb+t
         Zwt5SKcTpjrGvMW3rKcW9QJh7TfChzGSxJwSZYOEWajy8W0YH6d80YnA9QDINi3TCYWG
         KZSrbqnSUR/9bBOgypHBd87XVAa6Fd3wDr9YMVJFyUfgGLWeTGCW/Uz6WLvMAjbCVlIb
         UU2bj66zitEQDafPcaN8aF4l+VpQm6UNczrd/qRMcEJ/5agdqyhogRBYx+ciSX3nm/8r
         jcTs4nFhP/pAQbmuBC14oTMEy0BkDXi//JzklQ3n7qMMc8k6NQRQ7V8hf29LRMBVSksS
         DlUA==
X-Forwarded-Encrypted: i=1; AJvYcCURY92m/B4w0ZY0B2ftk2IaIky8Tdn+kjyyyytvV5UFIOMjhBc9ps5NoxDrfuqozqm8gfE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMuEVgp8fPWcbBxQYEt/MLVT3hvG+Qao1HXL5jJKjqfC9mKmf+
	Oql76iJer5YkGCcL/09RFw18Zz/bUcV5flHMt9hRb5nI/iGvGyWxXXT6C+8teIg=
X-Gm-Gg: ASbGncsErP7dG32htipvwHUCgqH7QZkUF5IBwL1dZGA/JSjfj1t8tMw5a7AmW7igZbA
	QVoVCPfkNnxcEOV/Dkfu4ObbP/78da5+jIItMI/J3uJAzmTv6pNVtyTPvBmXl++X6VdfB4MUeYv
	mriKvjCANIcNMYt5lSS1ggsv7ZF7YwOjaevIy3bapQGOcq0GfgomRHE8+YrKe1F8ayqqx3praN+
	VG2AxbPNcYKForXxjomcBINy/aKf62ua5naNUWWUyPcT+nguJV2GcS7iiDqhekm+OYjIHHi6K3D
	i+yROGeGMXNT1bNi2MNL+QRTkXBWAROmPuyGPfX0iB0adH9JEQrj4Q==
X-Google-Smtp-Source: AGHT+IEt7/lwpwdaScb+0p9Fg8aZK81PZGU74vSUU2NY/HtKI988XqzBXbfqUBIR4rmnm1R5PX8mag==
X-Received: by 2002:a05:6a00:8f0c:b0:736:50c4:3e0f with SMTP id d2e1a72fcca58-7406f0b5e78mr9676093b3a.10.1746470847991;
        Mon, 05 May 2025 11:47:27 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74059020f4esm7153739b3a.112.2025.05.05.11.47.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 11:47:27 -0700 (PDT)
Message-ID: <f33fa744-1557-4c01-ba49-e64b4d3b6368@linaro.org>
Date: Mon, 5 May 2025 11:47:26 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 41/48] target/arm/tcg/crypto_helper: compile file twice
 (system, user)
Content-Language: en-US
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
 <20250505015223.3895275-42-pierrick.bouvier@linaro.org>
 <79916f8d-2793-40a7-b769-ee109c52ef63@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <79916f8d-2793-40a7-b769-ee109c52ef63@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/5/25 11:38 AM, Richard Henderson wrote:
> On 5/4/25 18:52, Pierrick Bouvier wrote:
>> --- a/target/arm/tcg/meson.build
>> +++ b/target/arm/tcg/meson.build
>> @@ -30,7 +30,6 @@ arm_ss.add(files(
>>      'translate-mve.c',
>>      'translate-neon.c',
>>      'translate-vfp.c',
>> -  'crypto_helper.c',
>>      'hflags.c',
>>      'iwmmxt_helper.c',
>>      'm_helper.c',
>> @@ -63,3 +62,10 @@ arm_system_ss.add(files(
>>    
>>    arm_system_ss.add(when: 'CONFIG_ARM_V7M', if_true: files('cpu-v7m.c'))
>>    arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files('cpu-v7m.c'))
>> +
>> +arm_common_system_ss.add(files(
>> +  'crypto_helper.c',
>> +))
>> +arm_user_ss.add(files(
>> +  'crypto_helper.c',
>> +))
> 
> Could this use arm_common_ss?  I don't see anything that needs to be built user/system in
> this file...
> 

It needs vec_internal.h (clear_tail), which needs CPUARMState, which 
pulls cpu.h, which uses CONFIG_USER_ONLY.

I'll take a look to break this dependency, so it can be built only once, 
and for other files as well.

> 
> r~


