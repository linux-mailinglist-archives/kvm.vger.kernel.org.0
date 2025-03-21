Return-Path: <kvm+bounces-41723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 59319A6C410
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 21:17:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BCAC648442E
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 20:17:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACE7E230268;
	Fri, 21 Mar 2025 20:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="S99CSTv8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E621EDA36
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 20:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742588240; cv=none; b=cHnML8TbN9F5ewBK2o+JBgxaZYQykDKBA5kkMYSitOYga1IatOhhprTY00Ln30ffrRy0n+2a2QPaw+PMxjhqGP7D5G+3zn507XFSxcLDJ7Npv4SGcY3W4RkkMDgK6wAZF3fb58EKFPEzt8/+XL5UHHIign0zT4amwE5XRuVyb4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742588240; c=relaxed/simple;
	bh=saMLimapiEKvrGnbpahQeAxrn28iQl4kDYTlkYLm2IY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N6tMT0EplnMRpseiV+yUkO/Qgtf8FmPfbWMTE9yvsSxR5hbhb1ks6FPeXC16r6G7laEotDXOE8qpcEb2iJXtJ2hXm+MhIMBQROQ8CHRkEOVlXH7T2NDRESgxYCzdVtV1DrtgakOW5WpF11DQDZaT93eh7QlfTKJGSKYdHVynIkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=S99CSTv8; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-43cfb6e9031so22288185e9.0
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 13:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1742588237; x=1743193037; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R7BG31Q6vK9JpMaOa+K6RrvHXqX/LMxE0XAVM9lzVKM=;
        b=S99CSTv82jWeqO82P19es939GTLbxQ1Jkv/IyPcmLyRzUCxwzC3epCjpnboJfizLvo
         7+vfIa/odihGZoHEJMNLWGH/iSfd/z8Whyt1FcnHqPYxnOUUenjzUO+NhcRC2/kgJe7J
         3tJSgdE/tPzFjXuT+2VujmeDP0iHVLQ+QuRYQqMe0ImUXF2PEKrO/3blqXOpePRr38OM
         4jNL8u7LvYTMeOcR7g1A/WaVUldw7fzbVwk4qcj12c5TtpLwzdoLGhcIy/XwidzK/wSb
         Vm7Bhop667YUpWOVOc55IbrhZT2ADLUJwGnCGSstoXVV4MfGeWGCis/i49ozL9K+jJUY
         tfGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742588237; x=1743193037;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R7BG31Q6vK9JpMaOa+K6RrvHXqX/LMxE0XAVM9lzVKM=;
        b=kh2CaSXxD6uzLenPB+ZBlVk+abc/vq91xHHi6pTbDfBoTVdFvvDHE9ZtwI/I/SdUUW
         VJytLiRPP9H/+EGmsmT2i2tBetd53rYROYoDTiyxb/peFdBXK/ZP649Q9amb3pHCOcFt
         uJ8wuYNy6fGnvkXogjVS0FdCAm8XLJtZl0A59JVFyozt9RLxPb1yKQU9lrs/jTFO+ImM
         1gP/BxnWMCQ8k+0eQ+rCQhAQc3W4fqnbhzTpGhppccDHOvFwEpbZZh4TBGUV03xFqxwe
         cC3UnLHZUAGGDf4j/PRrUGcb4ugM591l2QFN8FLWNZFA7+eCBRbmRQP/3WrrcnZHu1jS
         tCoQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJGHDo766EGsyXxR303bvmX9MaPY5NoTGjwSJfVwPVgn1G1S9FeQnlv4VVQu6qpagcBN0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLK5c+9cyBmS4E2AG4tdtAmyQHM/LiQ6C8XMeY7dQMdY/Y4v/Y
	v0AQF9A9P4dVXLxCCtIagLDh7wLOpI5tz0rSIsH3d+YqutDwifMxrbBh9fevu8U=
X-Gm-Gg: ASbGncsUHAxc1QVwKu50QJBa8NhtChL3P2ruwybDE12pdgur1EqlWkqhLEpgFTdk2JJ
	AT6W+DRR/PXkhVFCaGiS7/YRITECbDOWAn4dwMYdPKSunZN+RddcnrxoXG1u4CZdqESsVvZ4GMk
	JAc8edHiTCFnYTlT2r11oGiK6EDkcudwLaNe/3VdZ+xrnNvzNf1hQIBInAWXrDaZtJ5WNAdrnCR
	3XdIZ3o6wRlQEdpj8NY2I4rubDGc7HJsLIiwFOWYJlgH+2dlmbxaqCvCdPJ5t9iOY+24xPMZ4e4
	kry9E0N7lqR9MOMPplCh12rI2pMcSAMg6QCGbXzoTIG7R5+BDg1JCKoEPKfBK0YiiDfFGykjvRN
	vmvEhHxArLHK2yA==
X-Google-Smtp-Source: AGHT+IG8ZxwPRkOblN342dvVLmBvhNmNS0L0D6XmV0x3o0uuBTTX6peyNiLq+Uw+JiQU4iJC6NDGSw==
X-Received: by 2002:a05:600c:4695:b0:43c:f75a:eb54 with SMTP id 5b1f17b1804b1-43d50a0a023mr43505215e9.13.1742588237049;
        Fri, 21 Mar 2025 13:17:17 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3997f995778sm3302127f8f.11.2025.03.21.13.17.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 13:17:16 -0700 (PDT)
Message-ID: <1f900b99-e260-42cc-9e5d-ea4e7a4365ec@rivosinc.com>
Date: Fri, 21 Mar 2025 21:17:16 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 2/3] riscv: sbi: Add kfail versions of
 sbiret_report functions
To: Andrew Jones <andrew.jones@linux.dev>, kvm-riscv@lists.infradead.org,
 kvm@vger.kernel.org
Cc: atishp@rivosinc.com, akshaybehl231@gmail.com
References: <20250321165403.57859-5-andrew.jones@linux.dev>
 <20250321165403.57859-7-andrew.jones@linux.dev>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250321165403.57859-7-andrew.jones@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 21/03/2025 17:54, Andrew Jones wrote:
> report_kfail is useful for SBI testing to allowing CI to PASS even
> when SBI implementations have known failures. Since sbiret_report
> functions are frequently used by SBI tests, make kfail versions of
> them too.
> 
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---
>  riscv/sbi-tests.h | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/riscv/sbi-tests.h b/riscv/sbi-tests.h
> index ddfad7fef293..d5c4ae709632 100644
> --- a/riscv/sbi-tests.h
> +++ b/riscv/sbi-tests.h
> @@ -39,7 +39,8 @@
>  #include <libcflat.h>
>  #include <asm/sbi.h>
>  
> -#define __sbiret_report(ret, expected_error, expected_value, has_value, expected_error_name, fmt, ...) ({	\
> +#define __sbiret_report(kfail, ret, expected_error, expected_value,						\
> +			has_value, expected_error_name, fmt, ...) ({						\
>  	long ex_err = expected_error;										\
>  	long ex_val = expected_value;										\
>  	bool has_val = !!(has_value);										\
> @@ -48,9 +49,9 @@
>  	bool pass;												\
>  														\
>  	if (has_val)												\
> -		pass = report(ch_err && ch_val, fmt, ##__VA_ARGS__);						\
> +		pass = report_kfail(kfail, ch_err && ch_val, fmt, ##__VA_ARGS__);				\
>  	else													\
> -		pass = report(ch_err, fmt ": %s", ##__VA_ARGS__, expected_error_name);				\
> +		pass = report_kfail(kfail, ch_err, fmt ": %s", ##__VA_ARGS__, expected_error_name);		\
>  														\
>  	if (!pass && has_val)											\
>  		report_info(fmt ": expected (error: %ld, value: %ld), received: (error: %ld, value %ld)",	\
> @@ -63,14 +64,23 @@
>  })
>  
>  #define sbiret_report(ret, expected_error, expected_value, ...) \
> -	__sbiret_report(ret, expected_error, expected_value, true, #expected_error, __VA_ARGS__)
> +	__sbiret_report(false, ret, expected_error, expected_value, true, #expected_error, __VA_ARGS__)
>  
>  #define sbiret_report_error(ret, expected_error, ...) \
> -	__sbiret_report(ret, expected_error, 0, false, #expected_error, __VA_ARGS__)
> +	__sbiret_report(false, ret, expected_error, 0, false, #expected_error, __VA_ARGS__)
>  
>  #define sbiret_check(ret, expected_error, expected_value) \
>  	sbiret_report(ret, expected_error, expected_value, "check sbi.error and sbi.value")
>  
> +#define sbiret_kfail(kfail, ret, expected_error, expected_value, ...) \
> +	__sbiret_report(kfail, ret, expected_error, expected_value, true, #expected_error, __VA_ARGS__)
> +
> +#define sbiret_kfail_error(kfail, ret, expected_error, ...) \
> +	__sbiret_report(kfail, ret, expected_error, 0, false, #expected_error, __VA_ARGS__)
> +
> +#define sbiret_check_kfail(kfail, ret, expected_error, expected_value) \
> +	sbiret_kfail(kfail, ret, expected_error, expected_value, "check sbi.error and sbi.value")
> +
>  static inline bool env_or_skip(const char *env)
>  {
>  	if (!getenv(env)) {

Hi Andrew,

I needed that as well in another test so:

Reviewed-by: Clément Léger <cleger@rivosinc.com>

Thanks,

Clément

