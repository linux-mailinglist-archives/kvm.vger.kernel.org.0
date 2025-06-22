Return-Path: <kvm+bounces-50252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E95B6AE2D9A
	for <lists+kvm@lfdr.de>; Sun, 22 Jun 2025 02:34:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D258D7A4078
	for <lists+kvm@lfdr.de>; Sun, 22 Jun 2025 00:33:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA508E555;
	Sun, 22 Jun 2025 00:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FO7Eg/uh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869E8372
	for <kvm@vger.kernel.org>; Sun, 22 Jun 2025 00:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750552454; cv=none; b=m756MsrcwCU1TTAZSDwWrUk0Joj7xmzEKXIXpQ2CLDuyKlO/KT+dP4oGiXlvbWo6fklNscOEwyz4pd3cTZFCFSP39m4TiMXlxhiDAmGs3zM6i6mQBxFfWzr8Gj+GE9wp6nAb+aYsbPNBWebZ4rKQ6TVhppA6cKZjWUHS1mtNYcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750552454; c=relaxed/simple;
	bh=aPyh81pynyJbX89epEkTHFUNWVXuDCkrr1wM57ftFH0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fEFSje+nx7MqsdEUiAECZV2UoQ+U8nAHyvNd+HbmTezIog27MjnQJQfgFKRD1w6KHCaAMyRQoMOPp2+KGYYp/OX0eIDM8NpVqg3DwKz2qywM0xHtg5UpuIT6rYqExk5r389WbyX7pNsEIBmM4RDFuvwZWObsSNGOsElS3vU7g/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FO7Eg/uh; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7426c44e014so2642998b3a.3
        for <kvm@vger.kernel.org>; Sat, 21 Jun 2025 17:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750552452; x=1751157252; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HQKq9VPzQu2m/paj8efF0ht9BTQlnBGHLNhyyPz0tU0=;
        b=FO7Eg/uheqOH4pHuizZWzJYtFknjHO62lc8s1qZPnIArPGtdrCPBMNIfv9p1f3Aj1/
         KM+oZQtnbLB6DYB2ZRubW+5Cevh+xQ0z0ZAL0J8tDjubruPhkEMTyy+Ue1nfklMa3PeS
         PfUDEtFtwVLQjJV2b32QasEm0bqJ/Jh72ma9uRA0EsdaCeYIdSn99g+CwzaYeVrhcGt7
         XWljgpztb/iGrmClyvGXhXVaWiA1rlmXc8gvPNjZk2KBJSu6M9RylYjKfW2TRQOojz++
         yDvCRFtOjeddIyBaF2pi8o2pgcctFWe9vDtvGGAspvbu59W7jPMNiHUGo2/rnoicLuFz
         vp5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750552452; x=1751157252;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HQKq9VPzQu2m/paj8efF0ht9BTQlnBGHLNhyyPz0tU0=;
        b=Q5yM8vNvLUBE3/XfgW39YxgHUltA0gOIAp7Bf3F14b7jlAM6Sq+maRVWvLhHn7+jtG
         7R1UNLoyJhBuQSaqT0LjZQo+35Df9CihKFNXBbHAKuctKDp3gcKe5Tx+k6UCWok8u4Mv
         4s4R89vcMIrtz1B8zrepDG4NaB/O1kQjU7peyLB33BKnhoQAlSTn8A5sFzBjaAgdlvJN
         xXbSVWRsNSaIsr6SAZ6+uim0uuosdnEiQRJjbgJAqJFwAXus7H4m9wAu5lDcDuzHBLp4
         Os4DNE40UwJoqmIKDuQfiOE9EpJyPvLABd1ZqZAnKXdH7IzF3AIDeudVmfqovSKhd9+Z
         SqIQ==
X-Forwarded-Encrypted: i=1; AJvYcCUs30RnT+3bCSDq7kIL+5zKaPPuhWEbmFekXwVd4LhDwlWtgMlLPzQGq6yUaozVHvvxq9I=@vger.kernel.org
X-Gm-Message-State: AOJu0YwiUryvztGirdN6iOtc/s50RGLT3PLe7IjNBCPl5R0TMA7rCZyO
	LpzYKqvIYpJmXs+fxUinctGEJMDeLJ4DLgsl2itt+vC+W1HflEXx+dW8B0nAydebaIQ=
X-Gm-Gg: ASbGncsZbK8AxjHbzo21HQhTRGPClfzQTy74fQd2zm/6YGSGHGtuSTbPay75i6i18th
	ejaZ2ruYFp3QOK1L3kJ8hDqPYoIKpa964RLq1GwEcn6OIZ2FZ2AaDJ2km1+/TavSzbKjdZjeqf+
	BdgD73GQqJwdKAttvvJPFskwag0uEi5p729eoWJWcnA8qEstZt9Z33K8rV7b9tv8dJcNOjKqVaM
	Rmkpz5qWxwZVAUqPl1OddTumMGwA9DLedv/ndpE9+kVZC8HZbYRW6Nw6C1kG/HAigX99Cxbfaq3
	fdrXfIsDuAxzuIGkGckxVI2Lx5OHrExAruEfJKAZf63xPsp1EnnerlXMLMll51pupCOGZweYlg6
	AK0ax342hXvACY4jOqREM9h+nWh2Z
X-Google-Smtp-Source: AGHT+IE9ZIuXLJEu7AWPd+Sc/mHQkW/SCq5II3XmQewc9+ZNt/tbdvyhY7AYKtITLwaLNN8urQV2zw==
X-Received: by 2002:a05:6a00:22c4:b0:749:112:c172 with SMTP id d2e1a72fcca58-7490d691208mr10318918b3a.16.1750552451700;
        Sat, 21 Jun 2025 17:34:11 -0700 (PDT)
Received: from [192.168.0.4] (174-21-67-243.tukw.qwest.net. [174.21.67.243])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7490a64c203sm4946969b3a.112.2025.06.21.17.34.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Jun 2025 17:34:11 -0700 (PDT)
Message-ID: <9105ea2d-1f18-4977-8ca0-dcbe6c89b166@linaro.org>
Date: Sat, 21 Jun 2025 17:34:09 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 22/26] hw/arm/sbsa-ref: Tidy up use of RAMLIMIT_GB
 definition
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
 Radoslaw Biernacki <rad@semihalf.com>, Alexander Graf <agraf@csgraf.de>,
 Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, Bernhard Beschow <shentey@gmail.com>,
 Cleber Rosa <crosa@redhat.com>, Peter Maydell <peter.maydell@linaro.org>,
 Cameron Esfahani <dirty@apple.com>, kvm@vger.kernel.org,
 qemu-arm@nongnu.org, Eric Auger <eric.auger@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Thomas Huth <thuth@redhat.com>, Roman Bolshakov <rbolshakov@ddn.com>,
 John Snow <jsnow@redhat.com>
References: <20250620130709.31073-1-philmd@linaro.org>
 <20250620130709.31073-23-philmd@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250620130709.31073-23-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/20/25 06:07, Philippe Mathieu-Daudé wrote:
> Define RAMLIMIT_BYTES using the TiB definition and display
> the error parsed with size_to_str():
> 
>    $ qemu-system-aarch64-unsigned -M sbsa-ref -m 9T
>    qemu-system-aarch64-unsigned: sbsa-ref: cannot model more than 8 TiB of RAM
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   hw/arm/sbsa-ref.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

