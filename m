Return-Path: <kvm+bounces-8973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B15798592C1
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 21:41:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E45371C2102B
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 20:41:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09A907F490;
	Sat, 17 Feb 2024 20:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KMwCgN1I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE601D6A4
	for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 20:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708202477; cv=none; b=eCZeEEeZl8axN1OdT8eNiOcpmZjV0xV2+i1PWclnQko7INd2c0QDRzoGuTZrrPVHUVqhfBOHBsTnm5FiN0aUZRvA/ixnzZoX3FsY0k3ySFer4gGF0okinM5q4EXFJsxdKKwa+3iqIPiZA4Bb5041bH1e2z5ZpK9SePtPJcIsXe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708202477; c=relaxed/simple;
	bh=exGwfqVCZ6GJdIg68Xiq51OyEGXxqGXpnrwckSYCqag=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RttjAsZubSKMba2Ai55TuMfZhkOnsyb3bvESiaHLqb3IDVncLe+IyLOttj6ctKvumU+Zr/9AyZS0kASfE6SmRnUwquhOOcrCb24dJLaq5MbBTPUIx/8Pm2mobvsY72r82/Nl4+Xkbple1ic4mzV78ulUkvqOJq3ejU1xq8H4Pmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KMwCgN1I; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-3c1374db828so2690135b6e.1
        for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 12:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708202474; x=1708807274; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7JzjLBKap7J0DbzYGpEUhSjnn0WH/hYWUzSacKN7Rdk=;
        b=KMwCgN1I+TCFuVWYBHzfsv35VUkgwbaLjKnAid9be+cyqx8cmSuwQqIKmvtn4pKSrh
         0lSs+W8zImJ8qUd55F+/xz+5d7Fid5umr6zbsDWTxTLKQB4FV+mrYgAJH6aZsnw1Kwkz
         crEwgKLS9KhinrOmkBGQL1qjEaGs9G+PPn3PS9w0q/cpLqQcAVpZRZ9jRoxHBUAMP8Aj
         bN/WRW/D1sdMkAGSyI7UK6CVTjo7SdVh4v6kYd4nhJBSE2wD14sk/0h5wbGFLJLHu8SS
         /fAryliTLbm6wt1SduxwFR0Wm/Nd+zWR3CtzVCpXz+UlW9PhRdf4q/K96BesZ1M/PStG
         uYhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708202474; x=1708807274;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7JzjLBKap7J0DbzYGpEUhSjnn0WH/hYWUzSacKN7Rdk=;
        b=Mjpmfjn/iBCl6wJvzeIwNGpTAfrq0MOhLgbcXFsvZuswnRPF/HQpaw+X3A5aEwKcbS
         HcupqFQvwS1yEUFl/CnBr5YMdhw7a3Z5BOepJfQRzXiS3bcwtz+rXyQjmPkir2wuhiWg
         i4fkXF0my74KOk5OnyH7HE/gBuxwxIct1MpEjzCzMJLwSzE3tJxmxSIUbE6zU+NVPwll
         tzEQnAcYv3X5M5uqWKqyr98GE8voSXNBkh9Pljg3X4a5Nyd2uaQTsyn2BIoH7aqLDVhq
         e2IsWFDTbuAARudT9Xs6azVv3uukYy2pJvHynBub+0VV31Y9+Ot2nTQyQ+KR8XriUrkk
         Tp6A==
X-Forwarded-Encrypted: i=1; AJvYcCXfglnow+WifXKBZss8tFmOh2772/Ac4k/u4glhg97tv30w7zI7H11Dc0o69u50VlLZOFmctbuxhyRiG4VIYKTgRSbg
X-Gm-Message-State: AOJu0Ywjs5Tn9qntNZWKtXmGrlnwUTi9Zuvlb/7pRFUB8v8HTz5c+yh7
	04iWXbXvVymCFLM95AdDGTwnqlIn5Lw4As/HyZfqJQNC9fVpupAfAID/KF++XLo=
X-Google-Smtp-Source: AGHT+IFS6AygoyOC4y1LWOPZSoJG6M4i4IMV1wp+brZBmeCioWUL1K7bqDY1D2ky/Mviw1WsxhwUyA==
X-Received: by 2002:a05:6808:22a4:b0:3c0:3733:bbe1 with SMTP id bo36-20020a05680822a400b003c03733bbe1mr10844398oib.30.1708202474673;
        Sat, 17 Feb 2024 12:41:14 -0800 (PST)
Received: from [172.20.1.19] (173-197-098-125.biz.spectrum.com. [173.197.98.125])
        by smtp.gmail.com with ESMTPSA id n15-20020aa7984f000000b006e0651ec052sm2049388pfq.32.2024.02.17.12.41.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Feb 2024 12:41:14 -0800 (PST)
Message-ID: <98343599-9a1f-4298-80ab-4c41c47233e3@linaro.org>
Date: Sat, 17 Feb 2024 10:41:11 -1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] hw/display/pl110: Pass frame buffer memory region as
 link property
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
 <20240216153517.49422-3-philmd@linaro.org>
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20240216153517.49422-3-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/16/24 05:35, Philippe Mathieu-Daudé wrote:
> Add the PL110::'framebuffer-memory' property. Have the different
> ARM boards set it. We don't need to call sysbus_address_space()
> anymore.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   hw/arm/realview.c    |  2 ++
>   hw/arm/versatilepb.c |  2 ++
>   hw/arm/vexpress.c    |  5 +++++
>   hw/display/pl110.c   | 20 ++++++++++++++++----
>   4 files changed, 25 insertions(+), 4 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

