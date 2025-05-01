Return-Path: <kvm+bounces-45101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CEEF3AA6061
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 17:03:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 936FA9C1C3C
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:02:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D81B202C21;
	Thu,  1 May 2025 15:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nPhmgSoF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07BF201033
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 15:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746111782; cv=none; b=ClWXAM6bluNpEGkyMJ9qw+qjEVMtJGV2wXJtKu43Y3C8DHLAuUd2xsjKwsJRs0O05Aubz+yoBKZCTCr681BYFpWYukt+dgKXKFQW0FGCsq0EPIaJJW7nqahZ7fepDJNtfyX9jxQOk61gSCiwY6g8ITtGhkP8CKm6t0H9DCh4IlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746111782; c=relaxed/simple;
	bh=ChhYFXHG+mLnhJ/0qrPdGyDw3G+wslc1EN5nj5VMuCU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qy8kLrqKZMzg2SSjQ+A6QVA4PwlaHG6ViSEJ8tsRLkOw7VS26r96JOU3gPZ5HCbB/KmUFzyZMOgaXa4hMx+CsnYMRDVvfVdH5MGO7SSV3LPpmLK37f3r7Yc7fM6Ke6wSOFuUQql94mFuFuogNpt20u0OXCpNU1HjN5MJZkSV61w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nPhmgSoF; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7370a2d1981so969855b3a.2
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 08:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746111780; x=1746716580; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wkq/VdLFYJfyJvgcdgfMRsRb6Gxm8UUMs/yuzG02xU4=;
        b=nPhmgSoFKlm4ZOoOmWTgRPvwEgHmreRgxjshw1nPx6UD0kmmJaAcDVEcSl9pkiCnQU
         dmds1BtPufU3KKo11pdS0ZkgrVZQ2R/4qDNgb/1ssIcAtmawz7yL2x02E5I/MtdmMRz6
         kslscDlwVckoaMH/wrWSF6wClvOwY9JveeeCzs7IDNLFr4WAFQnHYCZR6XxQrQEpXd0R
         TGPcPo8TzjTlOZSS8T7Lv55P4ge3UCsUgAkPLeV329c62DPkvczZenAyi2Y7PM95bExq
         6TvGXBMNcaYNHhKfDme8O9iy2vaxjDW3CDP9hgUaxG/9KoyIOdQITi7h1emYeH+WATHX
         xYGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746111780; x=1746716580;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wkq/VdLFYJfyJvgcdgfMRsRb6Gxm8UUMs/yuzG02xU4=;
        b=bBryzbgoB9z2KhixvQlwYgOBAwFmLAJSaSVUaALQ+BhphAvwiRL0+R4KNjSFPBl9cN
         ZhYGRAEK0Ay37m/LDo4t4yypzFI2c9ZxMeSsXlJ5PVKbQW5mz+y+eiJXPWOXHjytmKXW
         2dan1NrhvT6zgsSYK4GhKjPLkZbEjye+ZuHy32q3bkd0ReWPw7MrzY9OTEpuv8C3qW0P
         7JFUU3MKt2W3bIGCImzkDHw02XDzW1TBg9VSI9ymXzPiU/E85PBcmL4vgfvJ7SceRo7N
         ZL2igEXAbO7vDaJJCTHNArpkCvvPhbCZFdsF3aMJuBqKusyD5KO0Bclw7FROqaLlaEMJ
         FGpw==
X-Forwarded-Encrypted: i=1; AJvYcCV0VX/GSp4iuvB48sjQKQWbgL+U3bvSuUC9Ij9JlvMN6BGLaIZrKYdVzsBf8dksy0BZhIA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuxCjobO1+GMqMSHAFv7avgqYoWNzyQ15FnWeAUowXYB2Kr65A
	nS2iCKyWxO1Jdivdciu3XMniXqwTNGyC2Cbcc4lgoduRsOZ/D5Db3A//Ox1azpU=
X-Gm-Gg: ASbGncsjzM9Cfpn32jyPnXqshjahGz/hbUW93/YH7nfViZM+9R2EenKBGL1lXlVyYiM
	YcEUlaeIHpavr3M2O984tNc7BjrZ8FJUqd8xLUU7j8KnYeIrT00RtoAAZkYddwMDgiGcVJK58S2
	vLsmOFvObkQVO9iw9aeO2W8UaNDHPK5aPVVe0N1Ef0CG6bANTXP0CNgScV9qqWJCnyOpiRLMM75
	x+x304ll6/KXBwcJ8qJOta4Qk1ODjKq6vNbitMy4bCU4C0bFerYZA8bg5tedFY81G71F8sxFxme
	hLN/gCG2LYWfWs5NFF0o4dglQTGxqgYUpjBNaCoICd6iPRz8l13B6u8XCdb4Bxf/8oob9Yz7USd
	16Ru/Yh8=
X-Google-Smtp-Source: AGHT+IFpQDWzZkr7SDEpQqkD/ISUrJM6vDV/PLa2LIk+1brnq5oSIluMSLUP33z0eD1oTrBqKei8Ew==
X-Received: by 2002:a05:6a00:1311:b0:740:3830:4119 with SMTP id d2e1a72fcca58-7404790521fmr4868652b3a.18.1746111779927;
        Thu, 01 May 2025 08:02:59 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404eeb1935sm938020b3a.18.2025.05.01.08.02.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 08:02:59 -0700 (PDT)
Message-ID: <8fdaed14-d2a1-4939-9b9b-5cf388e20ea8@linaro.org>
Date: Thu, 1 May 2025 08:02:57 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 13/33] target/arm/helper: use i64 for
 exception_pc_alignment
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-14-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250501062344.2526061-14-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 23:23, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   target/arm/helper.h            | 2 +-
>   target/arm/tcg/tlb_helper.c    | 2 +-
>   target/arm/tcg/translate-a64.c | 2 +-
>   target/arm/tcg/translate.c     | 2 +-
>   4 files changed, 4 insertions(+), 4 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

