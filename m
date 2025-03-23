Return-Path: <kvm+bounces-41774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99D0EA6D0E6
	for <lists+kvm@lfdr.de>; Sun, 23 Mar 2025 20:49:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92C6816D21A
	for <lists+kvm@lfdr.de>; Sun, 23 Mar 2025 19:49:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5282A194C61;
	Sun, 23 Mar 2025 19:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hRe2ebSs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C3128E7
	for <kvm@vger.kernel.org>; Sun, 23 Mar 2025 19:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742759360; cv=none; b=Fns5RdcUXbxeFhWeelb+t2CDzU6grNMr2P6NDHcrJM3G6s/JcL/1b9GCaVaWheZYEt7cwHgjvWpqcDxEP5cGdensUVRy7BpN5Ih12RNQHtCT+rtNmci3JYA/siNl9jOIJMZY6BaDb/sHVY8cTnE1ih7D2MKE7FmduLmsXHopVWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742759360; c=relaxed/simple;
	bh=RAkf9zObxXNnKA1Glb2UStMwFPP9U0BFKxDOE5SlzGM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qakjf0zevcuXWxRYIzr/cY22+HJILwjULYP7f9nZabyxB1hXJDlzjQpZDuRW1BOUWCkjuxjpZ3gBwygJoERwYJ0FssPkA2yuU5+vDYlNkW2pW+4PQtwUcLwUYUyjFup3/eFGj4utreSU+kux+N8aDo9GdInRLXeRmATCVax770E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hRe2ebSs; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-224100e9a5cso67188795ad.2
        for <kvm@vger.kernel.org>; Sun, 23 Mar 2025 12:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742759358; x=1743364158; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0VrTG+OEh2A1X0Mji4obFRoKHQRdQUnTcQeHWGV/Qrg=;
        b=hRe2ebSskCAxdY55UXwq4TRnXrr91Ty5a+LbcqBiuMjxV7is6Aa685vJ1BRMYuEh38
         R46hOTWnZzRhTTEeXN7Fu4vbSNjvL4WTwI1FX9YK0rX2igRQQ5u56TwXjNL26GWqYsUQ
         MCDWMv1wwVy2sLgLFJKNQr8+3VMYlYcHSpF8gFBgMjqYY7V+6JIxKZUDZE983WlmmAJC
         K2Ek4naY5nd0cuqZ+qQP+HPQe5oAxtNf/oQz80C3eN9gpgzau5atwwiwV4Cpmy10lMdf
         wsc81iqk97XsE/7ls3wHWpQ6J0Y5e5hUZHWeuf3qey0sug3QI+sbhTLPaMQtsewBkzDM
         04XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742759358; x=1743364158;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0VrTG+OEh2A1X0Mji4obFRoKHQRdQUnTcQeHWGV/Qrg=;
        b=V4fbErDUvCEUvC5MfOSjm1XJEqC1np65Y8jf6LATC4mci1KTL13uybK+MjqHftCZ29
         ReR37hTOmnnNztiFgHxHMPXZbkn/rNY4lUghJpHT+bXGHDLcSaC8suYc7SyCHVs8vkw3
         8yvD7+s0iFNAnRFpdpYP2DjqEsd5DsXKVbzcGZMGtgdt9RxnrXtAXff/GnH7Wn8Ghox+
         cO2HRsxnqc0uF7scbO4y/ZQiyCOhidZihyI+yRUTa488psls0zsNmlKUorfF7dFW3Ask
         bYAriB/v88Rn97W1DId0qz1qoS6+bBeQdtgY4O3Hyio6RBvu2OENA7EdQVTt9mdk0Yue
         OoCA==
X-Gm-Message-State: AOJu0Yxcpg72YSsmGUcJrp1nhDtwGxhU5OVZSXY1Eplts1eucKx0FCNZ
	D6if382kB+FDusCQbJwsVfRoY6YeaobNoERxZClbVEFEuy45qauYU8RiGkLSHrs=
X-Gm-Gg: ASbGncsWEInCdG7u6u7INS8B6uYs0AMn+2z/m4QG8spIg7k+5JsGAMqMCALJoVRhiEa
	/QlTNG7ytyLDTzFzjjmn9+lPetTDbzY8k2bI3qBsokz7wVbqOrWGTpOd8oDs908NVuwUt5LJua3
	ZwEYgOz7vtSy1sIUDE7DacZASxo/aSFmPXHwRccGNaiFo4FFZyXAm7Nn1q/8WfMwB/sgg/0N46k
	/JvI5KZsr0peng3W85ULxXmDXk6eKBpYLkCzTr5HMwyI0/DhuAXGFAqly6z9dSt/rn1B/g0zftP
	fXoqgJ2mTuCXS4G3M1kSZUciSTla5wHs5VlM87Xjw2FRsIAmXXL5UcFxIhc9lkC6VOyX3afUVZk
	8/6t1pP/uEqspIuWaj78=
X-Google-Smtp-Source: AGHT+IE3dab26w2GkKbxpQ0GrlEU+Vtg4WGY5dK8T0jv2xahW5pgggFyno21qL5No28YGoiYLVYaCA==
X-Received: by 2002:a17:902:d482:b0:224:160d:3f54 with SMTP id d9443c01a7336-227a5222ab0mr53827665ad.31.1742759358106;
        Sun, 23 Mar 2025 12:49:18 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-227811f44bbsm55022875ad.232.2025.03.23.12.49.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Mar 2025 12:49:17 -0700 (PDT)
Message-ID: <eed04dc1-ecee-453f-8f86-83cf72feaaf8@linaro.org>
Date: Sun, 23 Mar 2025 12:49:16 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 27/30] hw/arm/digic_boards: prepare compilation unit to
 be common
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-28-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250320223002.2915728-28-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/25 15:29, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   hw/arm/digic_boards.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/hw/arm/digic_boards.c b/hw/arm/digic_boards.c
> index 2492fafeb85..466b8b84c0e 100644
> --- a/hw/arm/digic_boards.c
> +++ b/hw/arm/digic_boards.c
> @@ -80,7 +80,7 @@ static void digic4_board_init(MachineState *machine, DigicBoard *board)
>   static void digic_load_rom(DigicState *s, hwaddr addr,
>                              hwaddr max_size, const char *filename)
>   {
> -    target_long rom_size;
> +    ssize_t rom_size;
>   
>       if (qtest_enabled()) {
>           /* qtest runs no code so don't attempt a ROM load which

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

