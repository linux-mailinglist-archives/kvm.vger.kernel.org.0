Return-Path: <kvm+bounces-46338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AC52AB5324
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 12:47:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 47AE9188A573
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 10:44:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9ED723C8DB;
	Tue, 13 May 2025 10:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HTyweTwN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4728E213259
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 10:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747133033; cv=none; b=mqNPlQM+aWi7Zm7HKcKTl5c4A2YbdZ5qulJF1z+7LQhGGkomvYQ935PKvo/yb631/hEK+najKmoXFa9SGCTSfyJToOs1BOzpeeELxv5GgWzc9OIGmMBFCNqk7n2131ewt7ualXovrZ+2+SVz0kyWta8mmNOX2J0+/JfGt4K4IQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747133033; c=relaxed/simple;
	bh=IxD/ExCNH9Tpj5+Pqo9QwfX0HZfqK0qq1s9aqtdK6zI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dnVDHmg4xpvQxqLbx/Scl+wwKmASjXYTo6FOhUIlmRmqriJGLuou1U+RgrzkbR5PFtMlYYYaMrudU8CvJsSYgohAxmqTkp/dv86SrGPJ63aDMlOo/Tf+6XvM7nueWwosp8c56YaKpaRikgMt/9AtwTr/FuV0nJVm92vkL9mI6Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HTyweTwN; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3a1d8c09674so2898392f8f.1
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 03:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747133029; x=1747737829; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mJvVulSRNfflEB8cQn+WQSd8w0kajqIwEFRa+psHWy8=;
        b=HTyweTwN44Hm1ZSOoL9ZCrub1Ear8ZVusM8yjscOGRLvMYHaxJE8MieDKLRbQRqxeM
         HVdjrRYbQ0HS8a6avA/6YJKJAacJClWewuIXtwUnK3ilraDg8/lsISa7wItW84YFNpdY
         i+dUt0geQ/Jo5FIhcD+Wdm5yjmUHINMkEUdpwiSsoxhu/1bXBKuG+LRgSmOcRtetcHVc
         6f42Rg0DXOO2rWe4lbgVocPqml8mGmqedVgVrSRwGTLhxo33/3UJ5exhI8uHIAp/hC9E
         ge82c3jqNjheW4IwMQTxdbUIRYvLbh0WqTVwHHwP5ZkvuzaxELV1dAkqENexGgCTABZ4
         zMbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747133029; x=1747737829;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mJvVulSRNfflEB8cQn+WQSd8w0kajqIwEFRa+psHWy8=;
        b=W6bdZadCmC75yjTICzIsEo21zHqYiHhE6HYmbu4oarecQoWP6fxsHpuOdXjDdh/qvt
         TR49UBxKwb7qiRcxvDY+PxA4YQ7RxxamnDcqSdrz1VEdD69ci7hd6t/E406wclp+qu/q
         R/ZXgCiNzivaaf4sxh7b4jRgeW2ZnTRSlMjDfnQXZ+UCQt3CQNHCESzHTRSw9mewlTtg
         2jJQjk5rm1DHA3H8gdXUpQVWPuQDhNS9Z9WFsvV/6uqxOlQERKrMe2pjeJzRKHLnPoEK
         d7oDwXnO8a7+rkj9WfbJczVzSiou0FNYQTmT/YudiGLCnSlWCHfGeVMdeaumTMC0Mxf4
         KMDg==
X-Gm-Message-State: AOJu0YzrHyAvtXaTiag44Pjldzt7u94T98fn7/i9U5ZRRZgBB9rEIdLv
	G76UIxkwRZykyLYe5aWq/wVB0jsiY5Ap0+7Op/LFiEEwo+MtaV1x57yzUa0NDYo=
X-Gm-Gg: ASbGncuWkV3khHT3rLhbZEpt2apa6CO9ZXHHxTxnnjJa5wlf1+WDJppLct2thSLGO21
	inmlOOH2z4WgEf5OwI0vZx/KbNSo0rJnksac5aWTNVtB9wiG1TNQki6wX04Ltlp51kxOhBlPRPD
	zDyVpsdLde5+npCqKpa/4vzWutpvg1TX3Q920TbNJ63EPexp7Rnhrp5+x5etAsjd5fuaByVm4OA
	uXxIFV+1xzcqyMU1y3JwTFXFRa8K1TgmkQesGqncWNh2kkEQ8dS0mBzxUPxeLbSLLOTJbeioI6/
	bwegT8aT1Rgv/3MuHkSyA0lV/RbAP8EqIMvRHjvxhWHYOnwNPWLYb45edbfl4YBcKw277CS6H7X
	Vv9QuZTCumnduIGNCpA==
X-Google-Smtp-Source: AGHT+IE7SsWW23d4HuC9Pllcgg0YtTVNoY6INYytzgrD/bzPNjDtRytLc0ANVeFDV9A+rxypcRpFkQ==
X-Received: by 2002:a05:6000:250d:b0:3a3:447c:c341 with SMTP id ffacd0b85a97d-3a3447cc490mr1847209f8f.27.1747133029496;
        Tue, 13 May 2025 03:43:49 -0700 (PDT)
Received: from [10.61.1.197] (110.8.30.213.rev.vodafone.pt. [213.30.8.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f57ee95asm15868601f8f.11.2025.05.13.03.43.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 03:43:49 -0700 (PDT)
Message-ID: <b050aa86-b6b1-4cb4-baa7-44cab9412ef9@linaro.org>
Date: Tue, 13 May 2025 11:43:48 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 34/48] target/arm/machine: reduce migration include to
 avoid target specific definitions
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, alex.bennee@linaro.org, anjo@rev.ng,
 qemu-arm@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
 <20250512180502.2395029-35-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250512180502.2395029-35-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/5/25 20:04, Pierrick Bouvier wrote:
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/machine.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/target/arm/machine.c b/target/arm/machine.c
> index 978249fb71b..f7956898fa1 100644
> --- a/target/arm/machine.c
> +++ b/target/arm/machine.c
> @@ -6,7 +6,8 @@
>   #include "kvm_arm.h"
>   #include "internals.h"
>   #include "cpu-features.h"
> -#include "migration/cpu.h"
> +#include "migration/qemu-file-types.h"
> +#include "migration/vmstate.h"

Ah indeed I did the same for microblaze.

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


