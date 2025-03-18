Return-Path: <kvm+bounces-41457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08155A67FA9
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 23:22:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EB88F7A5915
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 22:21:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ECA41F8756;
	Tue, 18 Mar 2025 22:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WQQHsSg1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7957F9DA
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 22:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742336540; cv=none; b=PvvjeZ0awiNJ9jJef4pRSBKNLhT3Troi1FEP3bMVctFX2Nzc6iVOJnUz67xMdokckD/QCwIDOmgS8d7sGm7oeR8eieXDVO3VP+MrEuJfR0d9L6S0fBWHKZtB99LEbk0+nBXPQ50edJyfI7ND5MP+OnAXgTiaHkpURr4CfKH2n60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742336540; c=relaxed/simple;
	bh=R/LFy2X/8YlSRUdrn9ElzuAnH3t8NMG9mh3ycHRTW7M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RhxWkV2uHzbvMKB1LJSHGtBY8CKae58orZpUKOUoYHn4s8Ejp289ahf8hTc1SPLzPtHRAshFSrQFrLouktacM4HHdr9pk73Q85OxDdhlxFxD/yFNkRoKp/a8a+YPWoJjfE141KYhltCSbNpfijrbmfYg3AjFt8R3DZ0dPZ8exb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WQQHsSg1; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2ff694d2d4dso5422856a91.0
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 15:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742336538; x=1742941338; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x68VORxlBgR+vaVz63DYy5hXfdc/JnPHU4P/9E+3mn4=;
        b=WQQHsSg17In/qohwExUxkJaLS2kEDLk2gNYhbQXoIhTrUEOupdRHrVMgjqnIBTiwXr
         fCPq9KaeF+OmkIT1DAwpawiOWMZcvF+2dmbshLpQA3q++4RmO/adoPfUAXVOabkPBU1F
         NgtHheeNT3KewzHcHDiquTPAGBt3T31qisdIo1bI6/p55XiXMHv0gt3asUmDwmvQib7j
         MqvqFtEOBRRr4mKVQUuIg5OBiNRAFqQ4/CgNoR2e2jhUDLedvM6CVTrIxB8Fg7e06r3K
         S61H9q2WcfQoVA6Bnvrhm5rHDEXivwN4q6UmbOd5fJxPrisxabR0nWGYhLQS/o4MrCVh
         a9vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742336538; x=1742941338;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x68VORxlBgR+vaVz63DYy5hXfdc/JnPHU4P/9E+3mn4=;
        b=enFRwavqUSoqfD7B5Z4swRCDyDS7i7dEk2iGUkvHkMGwGpoStho8U4DLNQB1TPmbj3
         IX9Nk1G8xgJUhlU1GY7NzTBrloAeYM32SrdyW2ZSXSh1HK7zOtGzwptWiwgkTy58hzmc
         l/eH/zvJ9lrok3V8y6xfWXW5ya1MHypUL2jfJ5iY8qHD4g1VokFHK1x4veOjVJz6iD0B
         Dr1EYxG73Jt8c501yAZS8nuywcQq6aKbRLV2agXM2/GghEVvVVSeY7Ef8WTDk8pVRo8n
         fCu+HBTMXu+RvU5NzEyQoxKhn5K6wBdnOPsRGyB67HYm2MSzRJx4kvtc5a7JeHEqYSOv
         yDoA==
X-Forwarded-Encrypted: i=1; AJvYcCXGT3BgMJfONyp/567w5Qo3t1cK59/0Pm47zCxz4HLdboQZwOpY4d8dtFGcirffXhdfo8I=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6H9HMWaK/O5nzelcvWCfHwBctDUq0LcfPy1KD4vSjHZN1kaI8
	20ranjMQ8N1HhKndFuGO68srUFcZq8cjRoZYCUTTI2sk/McUX+kTFzqHQJ5r7EI=
X-Gm-Gg: ASbGncubPdxBR7PmZMkzkdFGT+BMzkfLwat9IV97MhN/QShKN1iV+MaSBzRY+q6QrX0
	gNN0TKFdKrfG145gEZWHvYddZc53ixucb9roJ6nqVGCWnR7tXI9DPiTxV9MihEzK+MwcDd8uOsU
	eMS8p66tClPFA3CrLXWld6jupkzbhwyltOP8rqIQlur4Wr7dISdECAkLil2sJI6ARJaVHt1pLEl
	qEaefGXdJW+1KV8aSrKDjaiVrxELHyJJdO+FwlfKU2DvU3TSiw/XSXwIASl/f88Je2tsJDNuu20
	9tULjwTN27MVJhkmOAkvynFzut0Hun55pZeJ1FWSy3laHmpqDKKxNmDhnBbqBleqibAKbnLMhUQ
	JkNDi7L1r
X-Google-Smtp-Source: AGHT+IGHOPLTv3C8biqU57+QSpWJ1D+6cb2Vab07bfb4qaxvU3/KRShK+UJOqz2p7OL3amQORqXatA==
X-Received: by 2002:a17:90b:3b88:b0:2ff:5a9d:9390 with SMTP id 98e67ed59e1d1-301bde749cdmr500107a91.8.1742336538060;
        Tue, 18 Mar 2025 15:22:18 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf5cfd9dsm19227a91.44.2025.03.18.15.22.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 15:22:17 -0700 (PDT)
Message-ID: <c71143a0-2759-4c9f-b7ac-6a1d580dbec0@linaro.org>
Date: Tue, 18 Mar 2025 15:22:16 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/13] exec/poison: KVM_HAVE_MCE_INJECTION can now be
 poisoned
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 qemu-arm@nongnu.org, alex.bennee@linaro.org,
 Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
 <20250318045125.759259-7-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250318045125.759259-7-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/17/25 21:51, Pierrick Bouvier wrote:
> We prevent common code to use this define by mistake.
> 
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   include/exec/poison.h | 2 ++
>   1 file changed, 2 insertions(+)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

