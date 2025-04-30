Return-Path: <kvm+bounces-44964-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 89D4FAA53D2
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 20:39:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 31C99189BC76
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 18:39:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10B92265CCF;
	Wed, 30 Apr 2025 18:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dvIGmF7v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7761EEA46
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 18:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746038342; cv=none; b=XLa67zwkQCJgRVcBzBZhkWsNoAuvn5VMqlu54E+vqtV8rOdRoU2dBGZzNTEV5hk7tz0evSDZm4diJvNi3wv4jSKXMC4k+4Spo1xuvDO8sy72lvCuvjP93akb5Aq6MjDlOeGKsBbqLHYS2vytywgbba27t0G9VswbCcKoPvjEsWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746038342; c=relaxed/simple;
	bh=pzb/1w4MfRbw6OJE9BroVuVFnArnA6d4lk9126H+HwA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kFYdhKAY7I5Gu7rtdMUf4dP+eOdDezx/7HMxxMTEAG5zt99gBYGVT3CT0AxAkIjsBhTfVwGQtATVNzAEwku8EnqG1LkEuW95QLtmyKYgSyzfM997NWCLEMSTccj7G+vA5VB8TbWbzJjCva0cUuEihwRNH9osDZE6Au0UC/MBf1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dvIGmF7v; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-736aa9d0f2aso352470b3a.0
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 11:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746038340; x=1746643140; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ssyZKtuVLZxJbpaPVunx4vfUejWQFU4kZAk3nTNGRx8=;
        b=dvIGmF7vuRHlVSQMPQ1gaFUALCx3QYj0So1n5VPfemCNL1rpT6ZFbUl7ZxCmB8VFik
         kO4adRpa7FHEvpF8MXQ77/3j0YTHuj3j1nKPWfu1+bdPI5CQGw+j9LE+5GoaUitYJwhw
         /b4uyxcvpb2Pv08/y7wiZdohEAR3oJRIsR5n1s1vjwaHwiWQED5QgRWuwE/c+nGEEZCY
         rx0J0cCL9G4yYpMtatZq9BQ6+JzBBUIVlvHZZi8Crs8Ljey1EWl5nGTjLDEH5431ng6g
         TFxejVs6i9Fl7u+ENLvZzdAU7TM6yUVeviF89szhlcQ24LQQ/ZLqxpSotJ6DtDHk9NPo
         F+kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746038340; x=1746643140;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ssyZKtuVLZxJbpaPVunx4vfUejWQFU4kZAk3nTNGRx8=;
        b=kudePco0MxbJr4UVCg3Y8+24ZseV6JgONuLIs1TFFyGTbQG8XUE84qJtxrpFe9HovU
         UNHztkUDdvJrAqEf5Mke3krj01kQ47vE0xXRZ0Hhllp8PRg+732hUyAkHbpbe/BAk2bB
         m8Gt2oocjL8KncObmoQLnsNpjU/CLH0wWymlz6XSoOgwLK2fP2BXrY45NT+RERIPyfuH
         v8igvvmcg3HZr/S0dUbbA+zf3BHZ1eBFFFW1Kfq/djc8EVSWs1e46wjtYzfDK+ZNdjPO
         QukoW+eM9C6wxKJWCUrzJ7UroiRzusSOdphZXpzkVOs0SwaOQXD5kfhsJf4f3kGm/1bG
         GTUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpP/nUOPEkY/IhP8N9uNVuzoSzR7qtSVmdyT29DqMmT/W2ReU9R9czV86jS1FxBDtUTfk=@vger.kernel.org
X-Gm-Message-State: AOJu0YycA3HhaV/O/aq4ShiiFJOzchKLARmNzLED7MTgoaDBL35qSLye
	9o/cvnFzHZjLfbD/R+olGZeosGayTDyy99YxEcbGjfYueNyhliarg5u8RCOt8ow=
X-Gm-Gg: ASbGncvldrwR0sUxZnsvWbFefxQxYdCMfw4+xT3VV56nZie4+SaAjoHNZ2J5aLsvpR2
	3YLlvgUuIdyJYjQX85RaQgQYUU/+mixW9dRemsWeiMOrC+2JpHJLoxIq0xmAT+Ph8gjSVjID7hA
	f/zmksza9TxxXIppxGXGEMKJgBlfDwe5LpcbO6jssSk7OtLIXLlnv3y9CoQpJttgdam+XeIRpD7
	pkuMmPFHaXvaZTn4IQ3dpanAFNQU6uNq5NpW97nXYBzbqkdSlBAL7CDMEIFIbZe0By0QHKwmzOc
	YbXVFeMS0wrNa9o+Yi2Ku/R7lXB7oCeAx6cTr/bXSugGW8+WZdSXhIBQIFzjLIIxzmzHNrZvmAs
	XC+K1jG0=
X-Google-Smtp-Source: AGHT+IEISvgiOjRxT8LIY00XzPE7jPD0IXZ43EjcGOEnfrDXNgOwhIFg66+kzDxJM9mdChYST6lrWw==
X-Received: by 2002:a05:6a00:3a09:b0:736:3e50:bfec with SMTP id d2e1a72fcca58-7404777ecd5mr31151b3a.8.1746038339915;
        Wed, 30 Apr 2025 11:38:59 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740398f9ec9sm2028875b3a.26.2025.04.30.11.38.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 11:38:59 -0700 (PDT)
Message-ID: <b3a703ee-d8f7-4b58-bd18-ee71de494e13@linaro.org>
Date: Wed, 30 Apr 2025 11:38:58 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/12] target/arm: move kvm stubs and remove CONFIG_KVM
 from kvm_arm.h
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 alex.bennee@linaro.org, anjo@rev.ng
References: <20250430145838.1790471-1-pierrick.bouvier@linaro.org>
 <20250430145838.1790471-5-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250430145838.1790471-5-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 07:58, Pierrick Bouvier wrote:
> Add a forward decl for struct kvm_vcpu_init to avoid pulling all kvm
> headers.
> 
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   target/arm/kvm_arm.h  | 83 +------------------------------------------
>   target/arm/kvm-stub.c | 77 +++++++++++++++++++++++++++++++++++++++
>   2 files changed, 78 insertions(+), 82 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

