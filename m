Return-Path: <kvm+bounces-45121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 23F1FAA60B1
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 17:23:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CCBBD1B6749B
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:23:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49FC7201276;
	Thu,  1 May 2025 15:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pVHhE/pJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A951EEA46
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 15:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746113017; cv=none; b=GFqwerrAJGZY8vRNWLQ11xMM1qbqGEmYxeemaz1KhCzwO+oQwhQnPsJ5n9DDuziunUWcWWmCa7rWjychzkzCxRRivCg8sasl8NCU5MabXejNaWvvFqyNcgb1z77emtDC2TaZ8IXSBot3gk5w5LVcIXytAhdWC3gV5eXvL0/GKas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746113017; c=relaxed/simple;
	bh=x1Ix/T3stb3ZI5rKM3qG1WUrlRAG+1pian9YiBtC5M4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aJ7LI7vLJ0xdl6v85tYQANNCNCCHmHO7WaJrDZrEa5FB/2i8nJWE4aZs16oWmmq7wmJyumH4S9bqxrhG5deg2Jj1VLCSDBr2OyrqxMFZSafupmcCH7D72xKGuleGId/GvKp9EJlz5MFl6KofkqQKouzFJ8MzbPg/35K7O8joET4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pVHhE/pJ; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-73712952e1cso1187039b3a.1
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 08:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746113014; x=1746717814; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b7n108UvSqkNg4G+6t+Prq0mGC9LU+Xzgi3XWfeqdPY=;
        b=pVHhE/pJXSiW0fRwtQFs1Zme6021BizKFnDRSY1GjoYIrk/WT7twyvZgrwD9A22ktZ
         tlMhnXbSBllcEs/uzuKuBpMk0FHLAvWXb9xannnZcmADlqN1e1noamPvFQDBB/JGRfxh
         L+Gi7OoX217mbxSFCtyBhcV7uc85Ltrz4n/kx+5WDMfja2uNLo1MaJiBEGgQ50t3N1Qc
         NmkJu/CklGevbnT1wSOX2IBIb50DJijbc2DpcXZsN3GCBwrwl1CcXwDoEQJHvI60kkZN
         43hmmcKQ6T/8p7RDa1N8UkE6X5bVt/Aad7ZFZ/XYP02fcrytDo8ZPnaWrT39nfSFF+GD
         NBxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746113014; x=1746717814;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b7n108UvSqkNg4G+6t+Prq0mGC9LU+Xzgi3XWfeqdPY=;
        b=Vb6uXVcCvAbbYqU/8xCLHAt08sJEVV0CIUGqKht6Yskn2mWWXuLGKRLAs1sVc+IuMT
         VQEwKBVO6TIMvGww78IXSrIOQGDIE3Snq5afMhxAwiBU7qKduhvzsgj23gFY6uDZLHDj
         vD2zZRZN+8qeDcCuu5okm2/ASKUqqCFkNgbpFlXeuicGLnQm16jtJx4hp5NVZRQlk1uU
         7N9t0Vh8C7z5Zn3IlQvbNDWGgfKG9hWDDPke3c2czC9UCFqxUxrX4FwVP8qiZ9t8I1ke
         44a2z2OrG0HeeUe5lwNs7xRcKSygJaZWX5PwIM+q/m5YYrftLkARuiz99+U9oGaS727b
         T9VA==
X-Forwarded-Encrypted: i=1; AJvYcCVVndlfIygMu1AqWxdjbY0T5jf/G9RFF2FW+q/hOeYTEDduOoBCW/in+XcHS0eUEOTK60s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy36Q7InKO2CnUGE87igCA32IeuyomJxCZklAT2R9cjegU/Gtgy
	RP0k88cIMZ6ct1XPHeazWl8Rbv8TqdhSnSjYCe6387GnKz0jWaDQ5HLuRuHTGpY=
X-Gm-Gg: ASbGncvEC/Gtj8iNBdrfWcbG1BMwNSi6iS0v+B4PYswkt9mAY95l5YrPCzWiD6C96dM
	NCamBMwvEU6H66vHP08EayKrd/YN/LRKfmmVAYJDYC1PcPKhq/tpffJZdIMcf92GKfGa57u2pMq
	ggG52bTbGlk/DoPITa6jQJLEIL2WBdFlu5gtMs9NpMi7Cd8KEIOgaTyzIko2yimHUqX2o2Fc71r
	uBl/0xLaobVvEA8ZP9O91+Z6RaSaDKqNXqIC8+adA6lrkPUdVYZstBgmlUt5RcERLj7ZgRRpk/P
	+gJ2mmgEodqMdAYZnIANb/5xQBZnY4N3gsTI2sYVdPGYq3Mfx1i7l/nQ+zLUX7OPBIYHBHyKOur
	FNX91GACisqnm4SuEiA==
X-Google-Smtp-Source: AGHT+IG+xQpwe9JF6Emr8LMDFsv4jviepaSVeUO75oUuLU3qAugUOfQvpi7rbysYNF5LL/QQQa9dMA==
X-Received: by 2002:a05:6a00:c91:b0:736:8c0f:7758 with SMTP id d2e1a72fcca58-74047785114mr4469458b3a.10.1746113014345;
        Thu, 01 May 2025 08:23:34 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404eeb195bsm933775b3a.36.2025.05.01.08.23.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 08:23:33 -0700 (PDT)
Message-ID: <cf287b71-59c4-45a9-b0cd-42b9425b410f@linaro.org>
Date: Thu, 1 May 2025 08:23:32 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 25/33] target/arm/arch_dump: remove TARGET_AARCH64
 conditionals
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-26-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250501062344.2526061-26-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 23:23, Pierrick Bouvier wrote:
> Associated code is protected by cpu_isar_feature(aa64*)
> 
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   target/arm/arch_dump.c | 6 ------
>   1 file changed, 6 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

