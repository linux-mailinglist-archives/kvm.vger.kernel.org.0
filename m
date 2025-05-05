Return-Path: <kvm+bounces-45458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98A01AA9C5A
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 21:18:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB98F3AF902
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 19:18:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 787031624C5;
	Mon,  5 May 2025 19:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="O79XA8Sc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129B5265626
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 19:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746472716; cv=none; b=BdoiF/DEwGLrmZoFJwqxWSjhHOkDaTQUkK+hBP5nuuDW47mlM19IV1ErYCxd4r0ptDZ4Ava1+ffhWZ+FOBdbu41Rx8UDQxSf8R4qxegsyclq5aEHL04BdrYSmwkExwXphef+O2bb1kqaHQyd5kITriQecC1fDeGBQDimN09mgzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746472716; c=relaxed/simple;
	bh=G4kW0ItD9/EHyHROeYBwA9vDOGIbJc4R8TcN/292Sqw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TWsgAt7ZeXZi129UmbwQ37av5icwzAhe65Tg86f5Lkmiz7tj5+WAdf+x1Y7rmfuD/kgBVckMblnXKAFwxkSMMQItmBK529YTsDpgbzR7jLEreQMkRA3hdGjO1Mtv7nMCbPgXNJQY2l88mDGw3SpkRcQH47lG78BiSaJN+AsEPCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=O79XA8Sc; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-22e09f57ed4so45085495ad.0
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 12:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746472714; x=1747077514; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qgUGiM/DYUpZaxD+L893gwF6KdedTU2Fc07gbGMU5x0=;
        b=O79XA8ScJDoBT3riqvERPBG5m3R20NHtBBPEcskBVk5mYrfqlQmLMr5fOQgHUqlYid
         0Uxtkho8kQ8QFHRtXoQzhRSvVfGe2A9squN5PoTlkbuoV/eN76gGAC/XgpQi8QghZxsO
         ICV/M1GN76MNlfDO/fN5OCrH+cXkxvbLyR3EZN1TtBE4S0RhZy2qRWURXyT8CdEQTdoN
         E6TiKMfkoOUU3qOWf0WcWYOLl8Qnb/coTya84vU+NyLcUjy/wAklDOZvxZiiu/4DcUJK
         BfHdGX6OAThOEF4M9hGDhWmhnFFvHV/9haAN1zZFeSXjEVykjBJA+NnXgnKeWKFut9Nx
         +DLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746472714; x=1747077514;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qgUGiM/DYUpZaxD+L893gwF6KdedTU2Fc07gbGMU5x0=;
        b=fDy4RNRQR0+d0m4kbNB4xNLUTjPl3/8oxRPCeE8+GEJFckd9D75CKBUFGDzUtmfTBZ
         Od72kYNmnGnHBHR8jhVwmHLSg+YZom2GkbYBOfBmRKiGjwsZ179q63iK0C0S4U46nuLi
         xNh2J1VzeqaK3gwNMHxyPwQcPcUg09KW3DeLVvndcRaj9iZ9PrktGPvQQ9e9XZIGy+EJ
         P2g/Jv4XM9nDwwnBNgrhUZeqSRzg+LMJK1LRyOAAf27paHe4Z6nOSeGG45yn+4tVbAvi
         KJcWp0KC8CpWDuh5+PaEVA7BiLhcsw1Dik32dNj5dw49v2zpQM9XcR7fA20t7hj5AIWz
         OM3Q==
X-Forwarded-Encrypted: i=1; AJvYcCWC8AvkCh32ZrVDdtJjSUMZUT65CpBiNe/fhWXgE8IrxGtaFCTiv5wUvcRDS5U+RWohZqQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyA3Wb5V3bKgdnatVou7yjsf7RRoHoDuKohks9DsObgQT48kUVj
	f23Il5Oi2sdZTvItxkgqQJCexeSI8X3TThUXnbVzVSwa6n2RPBKwqYI2S7FArAE=
X-Gm-Gg: ASbGncuJ4i5x+mKIHPoqP0bnGRzWBM7LGc21n0Ow1Ss5IiJ16NvO53NxLXCOnJR9mYn
	ov3O5NlVvGCOtvIFJhGtugvxzgGuCkvZJ8EwrZJ4hRoy6BfK0SyHP500lUuYoP1T8/xMCYowGCg
	AHbcQaNI5CCFdxXVFiulha6LncPASLG9qChAhV4cgcmH1LbjpoPoxBqE1X/PVv/C7QlHci/7LRu
	gPcP9Yq3tM31Y5o1WfJjHo/GZv8APOtCLGMLbr9YUK0oWGMQTs1ndnaLx+5z5Gk+4I+m4RAwY2+
	ZHXZkmd37klHngLT7WdwkT+VUNe295Iga6q1mWAHeQJ2/oQUERxwNQ==
X-Google-Smtp-Source: AGHT+IHIZp9iXH90LNiEVwJbpi1Wd+mM2hRGG2JijV+Y1BkDIa/U6IW8Pa8ko2+EKFWM6e6m28nelw==
X-Received: by 2002:a17:903:110f:b0:221:1497:7b08 with SMTP id d9443c01a7336-22e328cc817mr8874575ad.23.1746472714255;
        Mon, 05 May 2025 12:18:34 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3b7c5b8sm4963587a12.39.2025.05.05.12.18.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 12:18:33 -0700 (PDT)
Message-ID: <45230c51-4fc1-4953-a914-eb61dd6add99@linaro.org>
Date: Mon, 5 May 2025 12:18:33 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 43/48] target/arm/tcg/iwmmxt_helper: compile file twice
 (system, user)
Content-Language: en-US
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
 <20250505015223.3895275-44-pierrick.bouvier@linaro.org>
 <2c005b5f-1308-4c7e-9b0c-9640aef294e9@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <2c005b5f-1308-4c7e-9b0c-9640aef294e9@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/5/25 11:43 AM, Richard Henderson wrote:
> On 5/4/25 18:52, Pierrick Bouvier wrote:
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> ---
>>    target/arm/tcg/iwmmxt_helper.c | 4 +++-
>>    target/arm/tcg/meson.build     | 3 ++-
>>    2 files changed, 5 insertions(+), 2 deletions(-)
> 
> It appears iwmmxt_helper.c could be built once, like crypto_helper.c.
> 

It needs to access env->iwmmxt.cregs, and ARM_IWMMXT_wCASF define, so it 
pulls cpu.h, which contains CONFIG_USER_ONLY ifdefs.
So we need to compile it twice for now.

> 
> r~
> 


