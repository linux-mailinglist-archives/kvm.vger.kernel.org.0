Return-Path: <kvm+bounces-45446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 25B80AA9BD7
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 20:45:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC0F816846D
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 18:45:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C787C26F463;
	Mon,  5 May 2025 18:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aSKs7cvD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9BB10E9
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 18:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746470682; cv=none; b=fHYdwKNkSqDKfW9FEKwuK+yzL829SHaO9djKhdin7Y7e0IgFID2/1xnYnFg5M4sbQRrWZaTFO4miEMTmAO9CRW3Bx0dHUdpdf/lp8sCmmnr+Y3VdkQ+vnfjYmDmn/NyA6jYl57x0yuYxr6bM9VKPqLOdruZYgvmaLB08vQaRDls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746470682; c=relaxed/simple;
	bh=g9J+2u0ezXHbNKmphvOMOEkFQsqj3F2JINVCwqT2wVU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tJUDDZddkEGG3PzxDZRHVnKkcz38UY3ijvUfYBWMMuODgspMETTmxGuKdwIJDR0dHx4YdIfs9Ddvnki8vSopwotxAwh4Kkz/+wcs5WoUYel9xKNwGf3++bLTtMiIFydiVg3ntenW6MVx4+yv4SGaF+ReTpyBZf0RFjwg30LqFxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aSKs7cvD; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-301a4d5156aso6290261a91.1
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 11:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746470679; x=1747075479; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GKKv/xMbQTGSWwlpOo8WHdB3SggIft/5hm7DLXoKBbI=;
        b=aSKs7cvD4/KnkyjqFZFqI2RBDq5cjYvbHt7NapK5u0nhOc5HdbB2ClLTdrhhP23AO9
         NRF6ybDBVdY8Dbg0QmZlBnT/oCEeilmofx6w4UBZd3lFE5tCMPAYXxxG9ARIS70ybkLc
         W5xVTq+vqFc+3enGOylQnyeo3nLeieYRMNJVhdl8IshSoCnfPgr6HhDCl26hMnWkde5Z
         ZgjwLLKGYW4nYFhwitvrLAaXdF0tzFXYE0NCOrawXRV7tnXyEk8LBh/WTbNcvK+NUrMg
         +qIFVieyIQexDQjiQKm4aJgF5HTnKNi6f+8pHs4xrlrNTQXCVBNbCHheUfTjgr1AWWYc
         k6LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746470679; x=1747075479;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GKKv/xMbQTGSWwlpOo8WHdB3SggIft/5hm7DLXoKBbI=;
        b=b9tBdP/LD75/0nOGq78Rk3eAOd64B07J8/e0Hcptyz7qdW98HuH4HQNC64RVKP+Z+q
         39m6AQ9RDiyL8iL2Q4Rz2coD+y5af2LA/LpW097aVIy4Qqi2kZGYqn1ZCH53WJeezzFg
         IMbbZ32jO31xr0FLxHuMyAoPRC/rt1DWCweSRC+9oHoh9LautdRuASKUtjR7b+4uagS+
         sv53INR8D0N4oi3SG7e84LzeTBoBpr7sfTSTxgex7Ohe4Nmzw/ZzOYz8pHYXKXp9xYDP
         RoTszWxIbkiVBdEWiNfPGKhNZlNDb6FACdiquBhGYB1/kTrEjw/t/YtWOdeGfmGr4qq2
         tRmg==
X-Forwarded-Encrypted: i=1; AJvYcCUZFOyhbApsU3DC1k1nD/DhRa5k3lxGhHRu8bW0OrFKjdrG0q2QNB3CnzReJD3GtXayF2M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yya5gH1Rr1CT/0Zm4kVY/YQThcgtZAip6MQkHbG+9p8ZDggS6+l
	JIWq9xgcn/uBQHdbxEU6X9h6e5pae5PKjm/xCVXN4+xhOLOEFb0BDl4wHJoGQ9k=
X-Gm-Gg: ASbGncu7jwGZUDudsVrMOOlqpyMAHa0AABXag6aAR6bYooCZg1PSHg/wKjBYb9v75Gw
	48RePMfUTm84ilxDpczCI2BF2CBqQmwI5SlZRP3J9SR7SW+Z7LpCC7LoakAHYfj5JhStOiFrqhk
	Rzp75m4+cPm9KmSNCa3Sr64wBO2/0gSEPOLCgXCVmZaN37EjnUGow4aDsu88VyapZeEBnZSkxS7
	UJEgt7TRBzJs38bjgYixVpcv0Lk5LnVAbtYdGtvISTrKSWyDrZHE0P7OBgc/u3PpRhBn35wMJrw
	NRBAJV4TyDsmAA+yYEUbhWjq7q1rjAlIynsQEU4lQTLFTpEYfBWP7NIPsnR7cKsQ916cufpyzUT
	HwPjeKlc=
X-Google-Smtp-Source: AGHT+IFypvcmIyf2TlfQ3FqOGv9EEEj4vApmLoTRsCwsw90TW1X57hFXURA9wAliPhoUB+iklAARJA==
X-Received: by 2002:a17:90b:586f:b0:2ee:5bc9:75c3 with SMTP id 98e67ed59e1d1-30a5adf4ea8mr14076314a91.5.1746470679444;
        Mon, 05 May 2025 11:44:39 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a4745fab6sm9298182a91.10.2025.05.05.11.44.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 11:44:39 -0700 (PDT)
Message-ID: <7ff2dff3-20dd-4144-8905-149f30f665b1@linaro.org>
Date: Mon, 5 May 2025 11:44:37 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 44/48] target/arm/tcg/neon_helper: compile file twice
 (system, user)
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
 <20250505015223.3895275-45-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250505015223.3895275-45-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/4/25 18:52, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/tcg/neon_helper.c | 4 +++-
>   target/arm/tcg/meson.build   | 3 ++-
>   2 files changed, 5 insertions(+), 2 deletions(-)

Likewise, I think this could be built once.


r~

> 
> diff --git a/target/arm/tcg/neon_helper.c b/target/arm/tcg/neon_helper.c
> index e2cc7cf4ee6..2cc8241f1e4 100644
> --- a/target/arm/tcg/neon_helper.c
> +++ b/target/arm/tcg/neon_helper.c
> @@ -9,11 +9,13 @@
>   
>   #include "qemu/osdep.h"
>   #include "cpu.h"
> -#include "exec/helper-proto.h"
>   #include "tcg/tcg-gvec-desc.h"
>   #include "fpu/softfloat.h"
>   #include "vec_internal.h"
>   
> +#define HELPER_H "tcg/helper.h"
> +#include "exec/helper-proto.h.inc"
> +
>   #define SIGNBIT (uint32_t)0x80000000
>   #define SIGNBIT64 ((uint64_t)1 << 63)
>   
> diff --git a/target/arm/tcg/meson.build b/target/arm/tcg/meson.build
> index 3482921ccf0..ec087076b8c 100644
> --- a/target/arm/tcg/meson.build
> +++ b/target/arm/tcg/meson.build
> @@ -32,7 +32,6 @@ arm_ss.add(files(
>     'translate-vfp.c',
>     'm_helper.c',
>     'mve_helper.c',
> -  'neon_helper.c',
>     'op_helper.c',
>     'tlb_helper.c',
>     'vec_helper.c',
> @@ -65,9 +64,11 @@ arm_common_system_ss.add(files(
>     'crypto_helper.c',
>     'hflags.c',
>     'iwmmxt_helper.c',
> +  'neon_helper.c',
>   ))
>   arm_user_ss.add(files(
>     'crypto_helper.c',
>     'hflags.c',
>     'iwmmxt_helper.c',
> +  'neon_helper.c',
>   ))


