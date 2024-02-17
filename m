Return-Path: <kvm+bounces-8975-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BC068592CD
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 21:44:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B1F54B21119
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 20:44:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E24357F7E3;
	Sat, 17 Feb 2024 20:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oPqmsx9q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D147F464
	for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 20:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708202653; cv=none; b=DjF296MKgB3qGjnB11AHwp4HMkfd76BwnA2CeU+VhwNKUm89nQNDHzko72136y69gm05Q5UFZDNltANwq89B/8l71PV0dJ3G1lEN9mKEzE7AU5HwdowwP+/8dDdyYrejjYJt18GxE3GjY4tX9elgT9QqrGjJhKO4723dzzgxID0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708202653; c=relaxed/simple;
	bh=rXBp/AyMq/OAo5mJpf2rMDoTH17ekSw+yjZsCNHNLkk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cxMI1j/Upu1Kk9I7ZHYLKgR3MeD4Rm4IjKs24cbAWnd+YQm8dDf7M/G7y/Xm9XxyqoQv3MyR9F7WT8nOek+OxkwaO96QMPWuY2loHv8RdDIBd30NYJ9xt2ALDg3u2WIRZbyWqlkxfKubXaP5m9qJVk1xau+D/tdOTaN5OqrvNM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oPqmsx9q; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-290b37bb7deso2624506a91.0
        for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 12:44:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708202651; x=1708807451; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M/KURmixgPMCy/7Mb3v5DHX0msHKFJrA8nPc7bgaBhM=;
        b=oPqmsx9qqUfDznkXOMitsF1nUV3kZ2KNO2wykCJkueOw3eNWYbIP0/hwNC3u7USj71
         OQr2tT/xxXR+KU7BwFThzzvwjS/MmBZ4NG7IExwciJgRWGuAVoosjsqJA81jStjMMhEj
         CSNLrD8x/FkTQ6jFSwH+2iQHRYjSH41fQl0z/nhfR0Oo6OSTF6vChbKjMcZfuRDd0HZy
         4v14fXaY3VgRO2LjjvWUkPvO7cI+Yr/V6iCG/w1Dd3Q5jWbVv+RDvMzDSa/vuzFtqKgp
         pazsuuq9xXwNTDaPEMqj7jGPePoAKrtYzaokuLzSQULqLSqvasKqW8IPvwS5F64Qlg3v
         48MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708202651; x=1708807451;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M/KURmixgPMCy/7Mb3v5DHX0msHKFJrA8nPc7bgaBhM=;
        b=qoNeVOnZzWo8YR2G93W8T3fbMb7UNHfgYW1047qrgFF3mLFdNhodg/yp2DVjoPpPlc
         06qDnBPPVRTDiTW1IvugXiTCck2FRy6+y01yxn0ZVpmhnlwBtXaStHksWvLYORuIh7j3
         81/c2GU3McZAE/EG46I8uVk6nXYDk9/bjNu5Nk64Det7ip/MeIgNpJ5pj/jMO2usjjbi
         kppVfdVZuQBZk06tbiiWcPCnITI+EBxa5i8j3InjyNaASKZSYIiyYWw9FF0CNIAmP1aZ
         WDczpxvPpoVjkgHLpQV7/TEin+GRZBE9wBkxMEqyNwgPCYfBNB+3GrWStxA95U3XFu0m
         sBtw==
X-Forwarded-Encrypted: i=1; AJvYcCX7skxiEIlFgFkomQOvuZSjyoUyXwWVOEY5omrFqKyNtaF4KhwOueqDMfzFP6vpI3uBEXzvR7L03gzRFf4aZ8dRdB1k
X-Gm-Message-State: AOJu0Yxy1Pa2n/DjXtTq0sA/H/0iEdw2gG7JvuTf/riXgXAGTYqcqCEB
	RXVaMdWRnKNN07rmWD6GapfRo4cDVmIPwUSB5oTPIBmr3sJjdojRNlQHePC3j94vbb/cXoZnolb
	g
X-Google-Smtp-Source: AGHT+IHe9ktPhSPOcZTpITgJ6rHwyLgGJHm6K4p4yIa9A6DBIER0/jANKC+x2/l09itAT8yYZWe1Ug==
X-Received: by 2002:a17:902:da92:b0:1db:80d3:1af8 with SMTP id j18-20020a170902da9200b001db80d31af8mr12027422plx.19.1708202650772;
        Sat, 17 Feb 2024 12:44:10 -0800 (PST)
Received: from [172.20.1.19] (173-197-098-125.biz.spectrum.com. [173.197.98.125])
        by smtp.gmail.com with ESMTPSA id y4-20020a17090aca8400b00296f2c1d2c9sm2227236pjt.18.2024.02.17.12.44.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Feb 2024 12:44:10 -0800 (PST)
Message-ID: <a69dc66a-5227-47c4-8491-8d4666e4eeb6@linaro.org>
Date: Sat, 17 Feb 2024 10:44:06 -1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] hw/display/exynos4210_fimd: Pass frame buffer memory
 region as link
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
 <20240216153517.49422-5-philmd@linaro.org>
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20240216153517.49422-5-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/16/24 05:35, Philippe Mathieu-Daudé wrote:
> Add the Exynos4210fimdState::'framebuffer-memory' property. Have
> the board set it. We don't need to call sysbus_address_space()
> anymore.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   hw/display/exynos4210_fimd.c | 19 ++++++++++++++++---
>   1 file changed, 16 insertions(+), 3 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

