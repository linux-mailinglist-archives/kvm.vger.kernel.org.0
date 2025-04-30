Return-Path: <kvm+bounces-44969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DF96BAA5405
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 20:46:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66BB13BF891
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 18:45:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0140E26656F;
	Wed, 30 Apr 2025 18:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zCtZpII1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941341E51E0
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 18:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746038718; cv=none; b=Ehz+eOguo8ateOKj9sXRO1SOWLr3LDdmFIZGrCAJ3Zh5KmreNPP4P848loW9xVNR5Siim0drw1ESdnfloLAt0UZH51xnns+Rjm3y2COqkrNCiBh3KhF4IHkrm+RFm4qqpmlQ5KxUvzghmqJHxVOUV0emE5bMKzZqmPZC5IN+3og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746038718; c=relaxed/simple;
	bh=DJpycYuj/gKrjiDpvpZOS2UCl+voezRTPleMnyilkUc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X216Kcyms29LS+9e9y1cS8ZpsqhiEUDAjBjnhrMuwym8QO1NafJBy6ZabomTl3NaPaE3sbLgWAQcAELNR+41/p+/lgN2SPzAERlso6bqVkOmJnP8GSaZj9uFwxqntBC6kh5VnPbFDcRkkmw+wK7sBtPxyw3xycAL2hFtRyWU+Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zCtZpII1; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-736a72220edso272950b3a.3
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 11:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746038715; x=1746643515; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fsQTa6aM8pUm6+W+yQoeVEUdk05s2En8LozWleTdmgY=;
        b=zCtZpII11+8x+58KyLEllU61+SNV9lEyQgf451UQyU4vApTw4hXAPZAS78CCFhKsk0
         6WVaFAtN9P23z6HU6cgKKYDg+IcWgaVsWDwX5oe3DL0M+Rfv8voI5tBweX3+MeSIAd2d
         WQ/eA/FWPm1COzM2dvV/aluAL+X5nYG0auWqFeJDGuVsNj7QgXoqIgO/bE4WF/0rYQYl
         SPcRxK8aqfTMFxYAI/cnLNSdefgH6qK6mhDXXsCuOLDjG1CXuucGY74uvAdugLpGcWa6
         0IXjlsbtGq0SW+ycSPI2VE+oxnEJUR593dBXtRKdc7ftUIRL6BOrdeK+ITh8Mlb/L6vK
         vgIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746038715; x=1746643515;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fsQTa6aM8pUm6+W+yQoeVEUdk05s2En8LozWleTdmgY=;
        b=WQfukyQmpunQrXmskqRsDhfVAkVSqYq/RV2hVs6DCgHHLHGIPTBOOT0DhFfGh65STs
         TsEKZl62W/Oa3a3w0q4/v9EPuSoJrl3qiJZm/51DMJ6AssUWXFofTBr4rfJ0n3/qKiDb
         UJ6qh3im1fyE4M3IMF3OfDqKAgA/O3GRlT9pcOK3Szlb1xTShSAPTm1D9WjawLkc0eIp
         mCnCv0PNn5Kc7I3wQWY4iiyWsf/m8hDCqPRoQ3/9aLGpRi0AhzN63e0TMjO6fK3LsHE3
         ZjtUuRXVse1pBOyE8nrsg15JzqwSG+Bz3Qoml3tY1TCsk7q/jezLrgZSXghDh1SRCY2f
         bbkg==
X-Forwarded-Encrypted: i=1; AJvYcCUorEPi1FdIACRyN6xEg56yl3GiUKh5Y7BOuTr4n3aPMuIvcBXppPnZBcQewrVfilQKaAw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwatjFajeSxsYNNUEIZ0fptbLZpKlK848ne03HdjoaINeiyW/O
	A5xTz9gyq7pq6pAA1lEdBW8L4POHp9R7ssqQ4iwHo2hqCKuyN9IlHKvJDjP4pzkUHXy+fMxyWx3
	l
X-Gm-Gg: ASbGncvsr0vdo2HXvC5PdzJuA57f+zWjMH+J+KwKrZjxXSCsljtRkf1Eu2aE6ibt5Vm
	sCB6fZWxhh1nh3i4K4TD4x5+d8AfvrpP9PoHVXdAR9OCtzp/9wqc8iD/BDMQQ2UqpYsggFiW2P/
	S5yIsfU5etfa+uaNLM3uSRRWf35wUt/P0nUZ/sJ2D61hoYExKNY7eUCaAQBXYirCFVsESkkqAjm
	yFushuej6BZ0f4gKzVuAhpRijAlnJz6cYxRm7NLJMdSJMuH/eAGiyrVvLzKr1y9g5U4m9O6Qf61
	XbFmqQFu0EXC5Q1BigKhraiWs8rs3BW2B78Zm3oWh++V52RBEe2hc68tzqWugXHDwEL502ZaZb2
	mYxhiC5o=
X-Google-Smtp-Source: AGHT+IHtC2XOyb5ncAh/Gm1bPrXbAXsePWuOtbVjsr2pTjPf8jIhNQ0VPaT8JV5fxgSAeyHrhuC3lA==
X-Received: by 2002:a05:6a00:1312:b0:736:6043:69f9 with SMTP id d2e1a72fcca58-7404790137cmr19770b3a.19.1746038714831;
        Wed, 30 Apr 2025 11:45:14 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740398f9a6csm2038201b3a.7.2025.04.30.11.45.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 11:45:14 -0700 (PDT)
Message-ID: <f076ffe9-09fa-4704-a816-98c5bae61dbc@linaro.org>
Date: Wed, 30 Apr 2025 11:45:12 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/12] target/arm/cpu: remove TARGET_AARCH64 around
 aarch64_cpu_dump_state common
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 alex.bennee@linaro.org, anjo@rev.ng
References: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
 <20250430145838.1790471-10-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250430145838.1790471-10-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 07:58, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/cpu.c | 11 -----------
>   1 file changed, 11 deletions(-)


Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

> 
> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
> index 37b11e8866f..00ae2778058 100644
> --- a/target/arm/cpu.c
> +++ b/target/arm/cpu.c
> @@ -1183,8 +1183,6 @@ static void arm_disas_set_info(CPUState *cpu, disassemble_info *info)
>   #endif
>   }
>   
> -#ifdef TARGET_AARCH64
> -
>   static void aarch64_cpu_dump_state(CPUState *cs, FILE *f, int flags)
>   {
>       ARMCPU *cpu = ARM_CPU(cs);
> @@ -1342,15 +1340,6 @@ static void aarch64_cpu_dump_state(CPUState *cs, FILE *f, int flags)
>       }
>   }
>   
> -#else
> -
> -static inline void aarch64_cpu_dump_state(CPUState *cs, FILE *f, int flags)
> -{
> -    g_assert_not_reached();
> -}
> -
> -#endif
> -
>   static void arm_cpu_dump_state(CPUState *cs, FILE *f, int flags)
>   {
>       ARMCPU *cpu = ARM_CPU(cs);


