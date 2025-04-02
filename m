Return-Path: <kvm+bounces-42440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B06EA786D3
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 05:31:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5CB817A3D63
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 03:30:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33536230268;
	Wed,  2 Apr 2025 03:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="F+4+DJCH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404F518FC89
	for <kvm@vger.kernel.org>; Wed,  2 Apr 2025 03:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743564694; cv=none; b=VrTrNNLftAsflXSHRkcoi+ltDZZadJha8NYi6fDMOGXTygA5/uQcSnJNx8SCKHOLc4YAXo50V6j7nYemvLsfbRLd6dQfGP8lesWPHwUT0PZ9HZLRLk4U93YMricwRQoveOLUZAp0KG7dsmQDjwVjp5+LKGzbelBDEVfVvfXCpwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743564694; c=relaxed/simple;
	bh=rV7Wm0eFwooPGT2XsKT4XFsWUJQlX3kStQPLbVavzms=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=flKbLMeuWFbhY5Oy4yvVYk825VelxpOX6+ncoFuwy7Icnv2cteYYA3KMzacnWgygNE8wtMyLW92SRXv1uug8bYjI8+c6S1xNqrYBF3sIx/c9DjI4atJ3w0sp8Cy7q731f8ZgI0TVzO54XBB26LcjRbqSwdsDyJbaggOvq28GDBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=F+4+DJCH; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-43cfe574976so43055265e9.1
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 20:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743564690; x=1744169490; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CujPIjkhOlnkWqCu+Rfx8WsNvtOQeLj1Mtett7H+ZGg=;
        b=F+4+DJCHuhSCz03YizaH/Yi8On9bWcZF53zHDyI2D+JR2skHLicfvd+/u/6KwFc3Bg
         f8lE/vsg+fIUUwGaxDXWkeSvL64lo3yNNDO3p3Q6M4kSgQQelUyo0wp1lKcseQ9JAHwH
         pRRP2v4n+caNdSvSHmE3ADbHLqBuuz550+gExBgh+t8tVYrM6Bnx+lNS222xZTgNUVQ7
         EdG4clRNmVVIRLTUendbqLd37ykZfSZLnHqC4uC6HEjUfMBw850cJYN/JZdYPpxW0Nk/
         mM20ge3KQcoAT4+nTp1C2WENm/iK9SlxSbfbOmImrzxTYhHVoJvRti+rU1OC1PpXGxEa
         gASA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743564690; x=1744169490;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CujPIjkhOlnkWqCu+Rfx8WsNvtOQeLj1Mtett7H+ZGg=;
        b=jCqyUD4PzMI0uhJdFOlWhpFnFyFDbqCfesr+KRhd+nu7n9jwCPIrL6nZhOSghb4kcF
         /Tl7UY/1BBUVnm4E2JDJMFLkzaSxD4k7FTBd3SE4BDNL5AuQfzvr892w3fLxXxh9Jzp/
         xVGWErhP2b+FVBelFZFMRX9WHIwNr4sYaA8LCI0mMefFE9lH5UXibCOIhWd+gQ1HoLiP
         jJAIq7rSsHREYSEWktiXmxsxvAED2PGumopMMiCIows3G5A+3KTF5gvIRIR7/P8b+CY1
         eGHiCm8UiaUO2ZCCdTEWYZLTF+UDdAP3BUKWY76Qdk4twsJdfyqaFuahdJE4wOJ38+IR
         S4Hw==
X-Forwarded-Encrypted: i=1; AJvYcCUs+qUiJmhkLk5zUbo5V0x7UBXWDTgA9yiEGvQHxpOL7PoFQFgf4XwUJlkChSjrmRYCoxo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+Cq8Fo6YhelW7C2ZO0FGGdrwBlY/dGRCoD8PEd5GiyaN57qXW
	WoLc+36pinFDZRAqpN5i+vIVFs0ZSOFkBYZyofmHazCWFAOo5bheeOvdGZRhxJY=
X-Gm-Gg: ASbGncvDc0QnEL9A8LdfonhDZ7OjM11d1gI3GokP4TZNxjghbBxhEU9/p8obAJioY3a
	lQBmPJTjYZo/WCqBt4qbi1ej2/vKYWr6c9wPfhCYvW1M5erZovReiLj7qqxFXHTvRJck+7UOXl5
	0JFA9bDWAjnjWruwL3JviEZHI1mKsHp6065fYB1Nt/44xGW66+nzR6NIaOgLAGfIPGCVUp3cEvo
	aRhK6pKjvazDqVVa2jUCgWrZpLqrZ9wN6K43vDFcH2a7T40ydWMRugyzgQxz+qnYaeWeFLrLZn2
	+/ywICUNy8odVuxxSzsPpbIfmapP1i0eKHmQN/L0IyhfFcqmzMmALoQNgx5ckz+CeI+g1LhFUU1
	kLL5PThFDy7vo
X-Google-Smtp-Source: AGHT+IGgC8MDVGkRqw2vbt917abdXWZ3MG1OlSLGeOEkxOX+DZ8OMBXDOpAWTPmY0jfwqNvKSOTMnQ==
X-Received: by 2002:a05:600c:1554:b0:43c:fa24:8721 with SMTP id 5b1f17b1804b1-43ea7c965ebmr56831035e9.17.1743564690488;
        Tue, 01 Apr 2025 20:31:30 -0700 (PDT)
Received: from [192.168.69.235] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43eb613a283sm7175535e9.37.2025.04.01.20.31.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Apr 2025 20:31:29 -0700 (PDT)
Message-ID: <e11f5f2e-0838-4f28-88c1-a7241504d28a@linaro.org>
Date: Wed, 2 Apr 2025 05:31:28 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/29] include/exec/cpu-all: move compile time check
 for CPUArchState to cpu-target.c
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Richard Henderson <richard.henderson@linaro.org>, qemu-arm@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
 <20250325045915.994760-4-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250325045915.994760-4-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 25/3/25 05:58, Pierrick Bouvier wrote:
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   include/exec/cpu-all.h | 4 ----
>   cpu-target.c           | 4 ++++
>   2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
> index 74017a5ce7c..b1067259e6b 100644
> --- a/include/exec/cpu-all.h
> +++ b/include/exec/cpu-all.h
> @@ -34,8 +34,4 @@
>   
>   #include "cpu.h"

This include ^^^^^^ ...

>   
> -/* Validate correct placement of CPUArchState. */
> -QEMU_BUILD_BUG_ON(offsetof(ArchCPU, parent_obj) != 0);
> -QEMU_BUILD_BUG_ON(offsetof(ArchCPU, env) != sizeof(CPUState));
> -
>   #endif /* CPU_ALL_H */
> diff --git a/cpu-target.c b/cpu-target.c
> index 519b0f89005..587f24b34e5 100644
> --- a/cpu-target.c
> +++ b/cpu-target.c
> @@ -29,6 +29,10 @@
>   #include "accel/accel-cpu-target.h"
>   #include "trace/trace-root.h"

... is also needed here, otherwise we get:

../../cpu-target.c:30:19: error: offsetof of incomplete type 'ArchCPU' 
(aka 'struct ArchCPU')
    30 | QEMU_BUILD_BUG_ON(offsetof(ArchCPU, parent_obj) != 0);
       |                   ^

>   
 > +/* Validate correct placement of CPUArchState. */> 
+QEMU_BUILD_BUG_ON(offsetof(ArchCPU, parent_obj) != 0);
> +QEMU_BUILD_BUG_ON(offsetof(ArchCPU, env) != sizeof(CPUState));
> +
>   char *cpu_model_from_type(const char *typename)
>   {
>       const char *suffix = "-" CPU_RESOLVING_TYPE;

With "cpu.h" include:
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Tested-by: Philippe Mathieu-Daudé <philmd@linaro.org>


