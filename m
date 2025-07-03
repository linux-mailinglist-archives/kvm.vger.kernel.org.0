Return-Path: <kvm+bounces-51473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D6B6AF7191
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:06:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B837F4E435E
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:03:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45DDD2E718E;
	Thu,  3 Jul 2025 11:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wn20dkTq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9DF2E716C
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 11:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540517; cv=none; b=gUhwZWWelbs5J+I59OFrhce/sfUkGz3HNNHoV3NzN24O7GlXlse+HmEhMFN97faKL/dm5/sgEwEQ7e6CJUYQ/PW0NlgHovUS2wbCCl8DSn6HPci7Ru1WzqI93N2RSG5ma69CDs/eIewzUHt0xbi4BKHiwTbXWBczpsm4Mh3eAdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540517; c=relaxed/simple;
	bh=O5J+uzLkpysr5r2A9U/dXUG3ypPB2FfjcnAU1/orDMo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lEPBdWP00HjvOzhyoPOclZutkkyGxZgVzTM5GAR+tn2kSPB1nUa/iuq/My+vNzArHZ66t3HpSPgWWifVsXEkYD16c+s7bpOFEXWCVaBkBrIXjUYk60Q+Vl37zcSHWLIpqDbhiECxpXbwNEnxEiRcykOH0OH5zSu+PKVF9E0FMpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wn20dkTq; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-451d7b50815so42302205e9.2
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 04:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540514; x=1752145314; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OohUo2uJk7GnemHNOOPbqmlHUCl8DjJKrjMI+LBrmxg=;
        b=wn20dkTqWyB2ibS27o8I12odQR05h8hpSTX7Byv7yXdV4/vG4Ycbl3lJBYi+GMyZ8K
         RpjwjoLE9Mx6iEM2U6H224kPi1IndCrZo2o8zxWsytUE5WeY3AgDtYVV3xaABIi1d7rC
         fheQEe1JkmDTve8hBD4bP5fM6oNzgI0l7aeiXGVnV9wjfCa+aUY5OMXNnYmyqoFnxtaF
         O0RZiPXl7vXGZo4bm0jsF1pKZV8fONwCF2St/Cb3PuLNT91NNE6Ti4pB3Zxcez0mFMaJ
         0mhiFMCk1WxVp/3yB0p++2Hg1cQ8mNxNbKa0J5OLDwK4hvivFlSRBVsve6uFcLAS5CFW
         AdMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540514; x=1752145314;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OohUo2uJk7GnemHNOOPbqmlHUCl8DjJKrjMI+LBrmxg=;
        b=Pxf/vWoujYxG0VhWmOTf/i2szVqw22MPeY3Qetub/hCh7887JoXXR0HxMQXkZY36Vc
         1HnIcXQsm1NQxRnyvENJPZ48cDajMSS3bMJDGC7bPPIIagLxlyXbT1NEppKFMmYj5UH9
         I3143rIqQA67gUh/kprt86pVMthxwm10BwhKwlSKjtjIbgn3UKFI0xF5iSnTkeESIvZp
         n+2QZpw68CBTdnfWfzAip1/2bGL5SQ3qf782RMliPdj6eiVDEuLCcRyHaH20WykHIjrb
         gyqXkAMfT5zEY8Xub4xznFp2ZdgsZAy0zkUTjVgldlC2vsWacCfv2uSgZA8EcfTXUZ2I
         nyRQ==
X-Forwarded-Encrypted: i=1; AJvYcCU23crDN4+Yt0U5xsGDGdnhqoQHhjcMLHEaoDT6drxTMrRTZs8ABxxm1rlluaR6j9AMKuA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwA3uhV0FVNXisGzLwCl6LSY8xYtEGAjsMs4LO8Zn3KSwoAMkLd
	j0z7AdJvkLuayb+FXbEOMwjC20+t+SgXssvuqCGj242noT5LE6BReUfYJkno5T7THSU=
X-Gm-Gg: ASbGncskUYqX1ud3fHdPC9RC9fBfYKClG/SQW8T1Bgvt0AYZLX5g0dpbhJ3kCpwKwzm
	CpDnIzWNdEII5oxgahjbVb+tMDweg1V4ntOLs2mZflvEDK/lNql9qPsG1FvWF0vAu0itD9CllaM
	iM/Fev3KZ5BcnoD6Vz/vGMiGVbOM5gT2JSBWd83VwdGfmnpLiGnK+xlzXnQWyTGlDaCiPC79vvu
	qAGTnLXAtXDz+tr5ECeI1qGN6WH474FzSdhxDnmsQwlNuuTFpaSqFmI7whPw9X6wgUNZyTX88mK
	5I+M9flhdKBlNz5YqaFPClIMCzk91+rtSK7ZaPJbIYOQjsPZ1qPT1rcU+WSRXli4bBKVHEkfwar
	Y
X-Google-Smtp-Source: AGHT+IFCCXZps50G7p4whhH0cZWqb2jr4G/5NcgmjSBVBYoSRhCPrtuIlzc/qLHxS9eIV2c45N/42A==
X-Received: by 2002:a05:600c:46d2:b0:43c:f629:66f4 with SMTP id 5b1f17b1804b1-454a9be9fa3mr39052665e9.0.1751540513894;
        Thu, 03 Jul 2025 04:01:53 -0700 (PDT)
Received: from [10.79.43.25] ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a99a3b81sm23123805e9.26.2025.07.03.04.01.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jul 2025 04:01:53 -0700 (PDT)
Message-ID: <2bf6e6c0-d082-44df-9b13-93bdcfdf79f9@linaro.org>
Date: Thu, 3 Jul 2025 13:01:52 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 44/69] accel/nvmm: Expose nvmm_enabled() to common code
To: qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>, kvm@vger.kernel.org,
 Richard Henderson <richard.henderson@linaro.org>,
 Reinoud Zandijk <reinoud@netbsd.org>
References: <20250703105540.67664-1-philmd@linaro.org>
 <20250703105540.67664-45-philmd@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250703105540.67664-45-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/7/25 12:55, Philippe Mathieu-Daudé wrote:
> Currently nvmm_enabled() is restricted to target-specific code.
> By defining CONFIG_NVMM_IS_POSSIBLE we allow its use anywhere.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> ---
>   include/system/nvmm.h       | 23 ++++++++++++-----------
>   accel/stubs/nvmm-stub.c     | 12 ++++++++++++
>   target/i386/nvmm/nvmm-all.c |  6 ------
>   accel/stubs/meson.build     |  1 +
>   4 files changed, 25 insertions(+), 17 deletions(-)
>   create mode 100644 accel/stubs/nvmm-stub.c
> 
> diff --git a/include/system/nvmm.h b/include/system/nvmm.h
> index 6971ddb3a5a..7390def9adb 100644
> --- a/include/system/nvmm.h
> +++ b/include/system/nvmm.h
> @@ -13,17 +13,18 @@
>   #define QEMU_NVMM_H
>   
>   #ifdef COMPILING_PER_TARGET
> -
> -#ifdef CONFIG_NVMM
> -
> -int nvmm_enabled(void);
> -
> -#else /* CONFIG_NVMM */
> -
> -#define nvmm_enabled() (0)
> -
> -#endif /* CONFIG_NVMM */
> -
> +# ifdef CONFIG_NVMM
> +#  define CONFIG_NVMM_IS_POSSIBLE
> +# endif /* !CONFIG_NVMM */
> +#else
> +# define CONFIG_NVMM_IS_POSSIBLE
>   #endif /* COMPILING_PER_TARGET */
>   
> +#ifdef CONFIG_NVMM_IS_POSSIBLE
> +extern bool nvmm_allowed;
> +#define nvmm_enabled() (nvmm_allowed)
> +#else /* !CONFIG_NVMM_IS_POSSIBLE */
> +#define nvmm_enabled() 0
> +#endif /* !CONFIG_NVMM_IS_POSSIBLE */
> +
>   #endif /* QEMU_NVMM_H */
> diff --git a/accel/stubs/nvmm-stub.c b/accel/stubs/nvmm-stub.c
> new file mode 100644
> index 00000000000..cc58114ceb3
> --- /dev/null
> +++ b/accel/stubs/nvmm-stub.c
> @@ -0,0 +1,12 @@
> +/*
> + * NVMM stubs for QEMU
> + *
> + *  Copyright (c) Linaro
> + *
> + * SPDX-License-Identifier: GPL-2.0-or-later
> + */
> +
> +#include "qemu/osdep.h"
> +#include "system/hvf.h"
> +
> +bool nvmm_allowed;

Consider this missing hunk squashed:

-- >8 --
diff --git a/target/i386/nvmm/nvmm-all.c b/target/i386/nvmm/nvmm-all.c
index a392d3fc232..b4a4d50e860 100644
--- a/target/i386/nvmm/nvmm-all.c
+++ b/target/i386/nvmm/nvmm-all.c
@@ -49 +49 @@ struct qemu_machine {
-static bool nvmm_allowed;
+bool nvmm_allowed;
---

