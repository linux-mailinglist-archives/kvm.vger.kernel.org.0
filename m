Return-Path: <kvm+bounces-36624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42E74A1CE6A
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 21:33:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 60EC21657F4
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 20:33:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 893F3155333;
	Sun, 26 Jan 2025 20:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ko1JfNtI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D9F25A658
	for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 20:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737923583; cv=none; b=FEbblaNUyGurjyw0em+C/vukRFfoFv1a/v+7wY7puveRAdQV8xnwwEkQ0HrKW6yGukpgV3lj0iAgWn8Rq27rplIrctwYaLG/KULscaT/nuvIWSKg8m+K3wWAmxptnFIXWJrxqDI7gsMZh0xrevmqH9E5tvBqwMSTm/3h3QEzHUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737923583; c=relaxed/simple;
	bh=orVKH2HWHE8G78mVy7D/36xA7szMxGnctcxlHEujzMc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HwwVsXjPl2kCP+bVL1rtthtqc3iIloRdsdd8dVeZYU8aTbqcBpxYryZXzNe5VL0gnJDAdcx8cmMwCEK8RWaIzYuOVch980VoM/FXsKODh6hiuGBpGlEpPS1eGGzVnsSzqTTJl66xhrAHKqjoPlqvi/6nuGYdkSnVGASSNDGwF7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Ko1JfNtI; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2ee74291415so4945557a91.3
        for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 12:33:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737923581; x=1738528381; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GarlRROndxCjTPZHSIwatKna1U0gu9y5c+dSUp9779s=;
        b=Ko1JfNtIytj2jgrU9RJw3pLXd5U+tMOvEyJLRDiY38QueiicP+n1pR4V88psqgk5XB
         SPGiVGj9Ug8/ZYmjME/nj6BGrfXMus9SrtTXsOu4uC3zxBmHDo+Y2lPn1I8z4I5jL9Va
         NMq1Y9No7WsXkSteXHV0vviNAnT7tTe5ieforX02O8lh8HMUCNdU+DJPFqQldHiuUkOC
         qAurCK75rFzhV/64XmegR7TrfjKcAIN79lhxvAZU1taVnq+L7uVfAMA/YYCwAoyb7LDc
         LcxZsFHlGDvYa9AuN4dQ59lqbnYwR29iLgC5SFCrjRcsDBjIFq+Va6jJMeMRIpPC+Xgd
         5Jrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737923581; x=1738528381;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GarlRROndxCjTPZHSIwatKna1U0gu9y5c+dSUp9779s=;
        b=DE7MVOiPQK4XFBeWA2RJNyEyB6skGrT5/Ery+jz6ij0/SqUbSuKEbDQ047Ko2O3LLz
         jNBqeJABu2HO2dm4mKu+MZzIj5PBaqrWGcUQfM/DJ9iiCUE+tVb4LmW/Y4cFIXjd301k
         7DO1YZU1tI+FagVuIGhD99mYe3LvQiCtCJaB5wvSo71OKfssPbTHBP53HmFZ/HrnYz3S
         x7SAb5otE+vawSHJtcFNdyYbSt3FqiSIMSK/ihP0hVeNff32HQakrelHQYDdXlLuJTEj
         HKfMwPn5UN0r8aH7HhNvUDqns7UBwEV70tMz+bYAT1/wIthZhrJVmU3+QOJvUp+sNoii
         RSfw==
X-Forwarded-Encrypted: i=1; AJvYcCVwOkJXPCrHdUoxDy0kFu9aVldLE8ni+F+3XMWCUnArmjLDKxwYMHv5QPfvhhZJP9Lbzjg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCD/2eskRcIgPOVhaD2lBqD07osX6WNe24qeubFwL1dXsx/z7m
	iaPgZMVwHTpCrISbvx0qa4pEbgKZWqoeRsY9fO71Z1qodtmS2gP6dZgM5SzOqRc=
X-Gm-Gg: ASbGncsZrm2vuNIJFwlDzjAzOEcQNr6fjoMYM58rIWxj+eWbRSFNzdif32T2Qy/WCI8
	8dMThxNb7B1XRv5qNjwZO7ob5r3pj/tDXh/LX+gdKIIx7B0YS4XDgTtuJj/hiedMPcqjhIGVEke
	AmkaA3Ri+F01vqEhQvtScuzNmU+8cufq0Zc2hu4W/+bKPKAC4FFJEBXrSrW8ZrrwQ0/YpC63omx
	cUK+++YcAeeJUYVUTaefSvlW5VJym4IHjjZeZtlWlU9LDdRgjIJz/3OpTzCZYiTvRbhylhLrzGY
	9pQ/JWdQ0VfbdCVDQUUZwuUm7Ozf1CCjpbZ4x1QS3uY7Kfc=
X-Google-Smtp-Source: AGHT+IGrTF0ua3JOvhdmIhcZ60si5thXhjyK00MEnuyxWBq+ow6bXi0deca44yvyI2f3m7/CVHkiOg==
X-Received: by 2002:a17:90b:3a0e:b0:2f7:7680:51a6 with SMTP id 98e67ed59e1d1-2f782c55be4mr50581605a91.6.1737923581153;
        Sun, 26 Jan 2025 12:33:01 -0800 (PST)
Received: from [192.168.0.4] (174-21-71-127.tukw.qwest.net. [174.21.71.127])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f7ffa8122fsm5509332a91.41.2025.01.26.12.33.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2025 12:33:00 -0800 (PST)
Message-ID: <525918e8-b114-49de-bf4f-5b6e1c04d29c@linaro.org>
Date: Sun, 26 Jan 2025 12:32:59 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/20] accel/tcg: Restrict tlb_init() / destroy() to TCG
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 Igor Mammedov <imammedo@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
 qemu-riscv@nongnu.org, David Hildenbrand <david@redhat.com>,
 qemu-s390x@nongnu.org, xen-devel@lists.xenproject.org,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>
References: <20250123234415.59850-1-philmd@linaro.org>
 <20250123234415.59850-9-philmd@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250123234415.59850-9-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/23/25 15:44, Philippe Mathieu-Daudé wrote:
> Move CPU TLB related methods to accel/tcg/ scope,
> in "internal-common.h".
> 
> Suggested-by: Richard Henderson<richard.henderson@linaro.org>
> Reviewed-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   accel/tcg/internal-common.h | 11 +++++++++++
>   include/exec/exec-all.h     | 16 ----------------
>   accel/tcg/user-exec-stub.c  | 11 +++++++++++
>   3 files changed, 22 insertions(+), 16 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

