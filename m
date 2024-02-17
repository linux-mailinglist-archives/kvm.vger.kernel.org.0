Return-Path: <kvm+bounces-8974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BCAD8592C3
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 21:42:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF5131C2112E
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 20:42:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 807297F464;
	Sat, 17 Feb 2024 20:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UcMI1P72"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494E41CF83
	for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 20:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708202520; cv=none; b=as9X+DGQY7snT1tqsCVleTsyXRJrGps7H0sawMMa0iCWyPbnAWYIqtZrP18tBh9oWSJtsmvEWL17p2xQMXAC+fRDZlsSsm0fy6V5fk3bZSDy6MnJ2c4iHgCprgIL2elPtn2CWqoF5TFcgDGY8KOOAXCguKOmrW+f8AI/XZVg7+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708202520; c=relaxed/simple;
	bh=HSK0YJMENbGe3ZTUj7HvQAfjZh8tff9sRnTpMOgYNh4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zirepk+TBZHxhyQfXOPp9ELIbBkxKJgWMlSURCzU9+lMmB23wGbG0oGmnZ0fG7WQQ/r8TlC4sBx2GNrxUntjqrtqZzzGNH7+/lN9AwRkH2CAarP1YXk+DbHG2AkeygtZeBe4NuNY1BnJuRZi8bgdIFQYxjZV9AQO/xmK9cZ5hVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UcMI1P72; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6e09493eb8eso3292049b3a.1
        for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 12:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708202518; x=1708807318; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z0UqvPkpb9ecPBq7dVKSHXlt2oGkZD2BEKAVLZck7Z4=;
        b=UcMI1P72t4gW3tLFkXQogmYU0Rz8xf9M7Wextf88JKkE2q+jHLZlk4e/S/BXG6u8b4
         prrPbk67oZSX2Dc4fyVA6lhhKMc2yHDCAxZaj9Wcux8zWkjjFwlfQKRfWNK9V4/iazAu
         Hudxbwdd4tBn1rAJb+FRTWuYfr2hEXOJ+XD4YiUdF43bZWUwuHSVs8pUB64i+faSJB3o
         Tf/5/0WNlh2C1EZ9frsphCplVHAntMLlf/spMq2pxA9ehdAkWRE+AbsD0H3OL4hQq10D
         lXlU8B4xU64TxluwoRUtqXnpJD3TF2vkAmig/ITqnU1fyzzKUObNRbkkYjMHcrRZaTD5
         GzQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708202518; x=1708807318;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z0UqvPkpb9ecPBq7dVKSHXlt2oGkZD2BEKAVLZck7Z4=;
        b=FUT4/FP0Q4mJVKP6ow61fmxZoP2inX9NQF5pAn6v6X/10zvjTy/8/ATkS4zCMz4A0l
         VkisiXaK4jS/GKy2ZzfQB38eh7NM1mOIm67GiABrpDq6ftGVsK14A/xygysbh5fmzg0l
         Ey0nAUf8KCH06mdu79hDIGWkEOkPqowbc5Qx2wJYcaDWq0u902VUnhYuN9ioNzYaKqZA
         tVIVQZSXWaidHIJn66KHS+WZF1B9pxET2RnNRgZfpi7x9aN2rTv5w/LmKYmXZEjPQnle
         N7mQPyG5DSANDdgjaPJ/28Kg1/HrZTiEarAArdu4gXbcDxa5uk8+hCSO6Zaw+c9Ns2/8
         VT5Q==
X-Forwarded-Encrypted: i=1; AJvYcCUVzfrEERgd8+y7GxKqr0Rz6pEhe0bOsCYp0hPr23vaFiLD029WgnS9xAO2HYt2NpeA3VDW2alrTs4tk1lFxHAfFu0j
X-Gm-Message-State: AOJu0YwVDq4Vej4uVqI6lL9EVdeuXKeLuFETsDgLCVNZZYXzqCZe4e4O
	sUZVwDgsDmZmFkq1zyaoVFTltfe8QsdnX5zYTzvjvofXEozpw+DVOOtDP1yARKE=
X-Google-Smtp-Source: AGHT+IF+W585RP8//p3e7tK3fa/JyAfftPhcDrBHBY/IHS505gG6spQdGLAb83xueeaoYD4WmSxqrw==
X-Received: by 2002:a05:6a21:8cc1:b0:19e:cbe9:63b with SMTP id ta1-20020a056a218cc100b0019ecbe9063bmr11755465pzb.3.1708202518531;
        Sat, 17 Feb 2024 12:41:58 -0800 (PST)
Received: from [172.20.1.19] (173-197-098-125.biz.spectrum.com. [173.197.98.125])
        by smtp.gmail.com with ESMTPSA id n15-20020aa7984f000000b006e0651ec052sm2049388pfq.32.2024.02.17.12.41.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Feb 2024 12:41:58 -0800 (PST)
Message-ID: <9a7edc62-c18a-4d23-abc5-78ba11ae0be0@linaro.org>
Date: Sat, 17 Feb 2024 10:41:55 -1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] hw/arm/exynos4210: Inline
 sysbus_create_varargs(EXYNOS4210_FIMD)
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>, qemu-arm@nongnu.org,
 kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
 Igor Mitsyanko <i.mitsyanko@gmail.com>, "Michael S. Tsirkin"
 <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20240216153517.49422-1-philmd@linaro.org>
 <20240216153517.49422-4-philmd@linaro.org>
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20240216153517.49422-4-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/16/24 05:35, Philippe Mathieu-Daudé wrote:
> We want to set another qdev property (a link) for the FIMD
> device, we can not use sysbus_create_varargs() which only
> passes sysbus base address and IRQs as arguments. Inline
> it so we can set the link property in the next commit.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   hw/arm/exynos4210.c | 12 +++++++-----
>   1 file changed, 7 insertions(+), 5 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

