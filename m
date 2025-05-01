Return-Path: <kvm+bounces-45127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 125E0AA60C5
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 17:32:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 779014C2ED8
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:32:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD5FD1FDA6D;
	Thu,  1 May 2025 15:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YeXWcw3x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C48B18024
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 15:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746113539; cv=none; b=Dbigdq1NmFPx9shYSsgn19ibFFeNIv5SBeTFlVpyogn/elgKrXOJnuG/VsxmgXmHc4E1yvoMSzaJaG3j5TDX6aTS8gTvoM+I53b0JJ6mo5IP8FRSoRCXGM/H4bm2S51TqYlo8shD/9k9yVCvtOgcpYnuMJen9Wz33XyD6FF5xEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746113539; c=relaxed/simple;
	bh=te6FFdvh8yZ3kRwK5Zs2Ap8CxIl2p48QR2EHIBo34gA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r9mWEkK8nThgZjfzft/EJtexEyNln5NlVo3BbqQl+Nzfa44Wb8btcQAtYNVr78FDg6skIR42TUSFGEtGf9YidjSo0+Ss/yH1uDWtyNE6PWTn4isny42jFos7FVCTaQnK6sjzMeUOu6F4o/QEQP9CKjLy3hOOd0B6cUOraZKn1jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YeXWcw3x; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-73bf5aa95e7so1060326b3a.1
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 08:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746113536; x=1746718336; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iAnD1GmafUPGhBO+bMT+SirMBKARuf2EvO+yXD9bfRQ=;
        b=YeXWcw3xr8O4ta0ShNoh8Wb7sMXzJ0e1pxxGp5jiJSUUYi0kM7OD5UcAVRbkWDLHGm
         aXHV+p0AN2s8W/K15RvnTrKYlJvDQWzTJr4Sm/Eo6ToiHDhdZEzMzIpNVRPeXlG8CCWb
         GpR1IQDHJs0ryIZDCALFiUwKlRbc+jD0Ru5sACLqlKGn21j4yAk84J7FatsBPcT0TFLo
         0dCLdGSh1pCGtlr1zUQJZ+P4iynMJ0EW4oiw6ym9lDA9erm2LN3F4+TZLgzrDHVBhXj4
         l5bOgtewC6p+Ui3jNJwqFWsiZeYvEOhwLMNmtlJQ1PNVyvzgmo9VZM/JlQqNmUJQvClo
         Whxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746113536; x=1746718336;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iAnD1GmafUPGhBO+bMT+SirMBKARuf2EvO+yXD9bfRQ=;
        b=Kc3E5qsiLYw/wE9gvJA3esthjF7Z7cq/XYYtFJ9Lf+eoDjt7XcRsXfmpAQ3nvwz6ak
         VW5EmMxZCMb1g+5pbq17zYgkLLNjga7NlexhcFxWushD8ZYTou2gk/VTD6x+32cxvK32
         uEWY95Hp7ejH2A+1G3onf0b9iGcL/SU5FxLoZncRaEZ4/U/nRQIXKW6Kla1QQDPQwsco
         KoSWg3rfnmyPSsVjtHYmuJagG8fYWj4soM+QZ9uwfiVyZFuxCPUM2Qkm0vHfNQ0eSjwe
         zszWzOpioFFWVxxnEehZKcAAO9d9gK0gfKfX+pMJD4U/UFQPkJObvYYgZWrbmCunhZSS
         t9KA==
X-Forwarded-Encrypted: i=1; AJvYcCW3oERLTdRCQkE1Ftlg8M1D/3i7ezsQ4VvkG8y7IvDtRMAlAuBKkewiv6c/SsrBK6mlIWk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6G73xI7THbmpwIUziIGYvyQNvvmONs53pYzfXtRBK7R7w3Khx
	Q2IZ3BArdm9weFvFGjmoAybVDPr7CKlnZBI3Jr2G26oC+ly+qnGcaf5qYXLCsms=
X-Gm-Gg: ASbGnct4012FqoDd8oIeIJsXEmInlhUwxQFQWmk4UESLwNs9L3510DXFk84RwuI//GJ
	5j7xR0wxwVySYMKgr4jvjY2VzE7Q4xmPz2Hr2Ampqoed0B7Th21xQaHSiWd3zLcH8xRtYsC0Evy
	adQyLZfcnc3Lp7uZVMq74qEvx94eo+RnbhCz7sdwIYVqTB1qcfSVSmArdDdEYHvJvxvHCuUZY+T
	MSybcNJrowyz2xGacWenwOjJuAQ5rSdXNGqslV389Pvm2Rw2S994avZCASVbmQrPxv7tqP60e/c
	ZFdUCnN+2B2tCKwYMfKNUNVUDY9v3y2i9UN9fbyuvMGYp6TloVfqwlwWcNOBkP6CM+BygPbv5oj
	Bj3Q49NQ=
X-Google-Smtp-Source: AGHT+IFoBxe2DZWgkVAHcucJCGrG3ZLN/dT4JrPNYQVEAuSwRAoP0fHb5trrXL+sMuISG7evBmLnFg==
X-Received: by 2002:a05:6a21:3390:b0:1f5:6d6f:28e with SMTP id adf61e73a8af0-20bd8644d34mr3612391637.42.1746113535710;
        Thu, 01 May 2025 08:32:15 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404eeb11b6sm946606b3a.2.2025.05.01.08.32.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 08:32:15 -0700 (PDT)
Message-ID: <0f81e684-4da0-4e6e-8e88-7a9f9fde24f8@linaro.org>
Date: Thu, 1 May 2025 08:32:13 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 29/33] target/arm/ptw: replace target_ulong with
 uint64_t
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-30-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250501062344.2526061-30-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 23:23, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/ptw.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/target/arm/ptw.c b/target/arm/ptw.c
> index d0a53d0987f..424d1b54275 100644
> --- a/target/arm/ptw.c
> +++ b/target/arm/ptw.c
> @@ -1660,7 +1660,7 @@ static bool get_phys_addr_lpae(CPUARMState *env, S1Translate *ptw,
>       uint64_t ttbr;
>       hwaddr descaddr, indexmask, indexmask_grainsize;
>       uint32_t tableattrs;
> -    target_ulong page_size;
> +    uint64_t page_size;
>       uint64_t attrs;
>       int32_t stride;
>       int addrsize, inputsize, outputsize;
> @@ -1733,7 +1733,7 @@ static bool get_phys_addr_lpae(CPUARMState *env, S1Translate *ptw,
>        * validation to do here.
>        */
>       if (inputsize < addrsize) {
> -        target_ulong top_bits = sextract64(address, inputsize,
> +        uint64_t top_bits = sextract64(address, inputsize,
>                                              addrsize - inputsize);
>           if (-top_bits != param.select) {
>               /* The gap between the two regions is a Translation fault */

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

