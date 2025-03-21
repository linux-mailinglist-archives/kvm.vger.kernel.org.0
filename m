Return-Path: <kvm+bounces-41709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C5E3A6C215
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 19:05:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2834E7A79A0
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 18:02:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37F0622E405;
	Fri, 21 Mar 2025 18:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rczvm5XE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00BAA78F5B
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 18:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742580212; cv=none; b=buQItJo5DWNJsJNhohkjHV/3oV/yrnbAWJtSfDcLPQQCrKTpBk/JMQRhXvtEWmfihOc72txt2q7tDA+y3+OtenkbhkwWoeeyUEyFuEo8BWiR9MnFyPD+aVP7kMGty6cyhV2CjZCOTuKMYCr6LVaNqgV/qucdskmxnHf+DfEkGH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742580212; c=relaxed/simple;
	bh=E6S/LwxyvGWjLoGUKp36wDFln2i0HB7ULLPU/8zZb/E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l4RoQqWTR6Xv+QK20ghx5TJgMJfNtYfShhiMZqXgWi5wDjOUzYsRpBHR7KMteCQNCshCt6vaKLvNE7z5nJVTyIRgKSpwejsR3b19B4k0Yn9VmKkdE2S89m7iGIkV0lRYhDPnecgMBwZXWoDtC87N0zjeoWobbr4cmWIUpoBLxkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rczvm5XE; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2254e0b4b79so21832075ad.2
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 11:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742580210; x=1743185010; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FHWrgu4CI1pd1XxzLhTETskG12YT/MMg2wUOB15BvDw=;
        b=rczvm5XE7DYxXrhF+FIW+Q0Eap8oOMQCCra/TcSXrAzvoShmTkvVepWnCD1oauGMoR
         XUWwjDCbb0ad1m8Zf0YdoMxgiEgxCTIJEMhNBsaGK+8uR/SA4u0/58ZGfhjVo0cwqUxa
         AoAacQc6GdVEI4kDTHbzdWhuRQcPKDC1vSRCuIcKncXoN5ub0P/wjFna91SOFeDsLMb8
         YlHLIcyiYWIMOdLui0I0NYnDvIJCFSufhX13mgP7XwJ3m3Menj8dluAkQOpM6pO9tuMH
         xsJw3CcGJK3og0wQtRcPjfAge96z1e/btDD3OvQ69G942Y/1JSxwqI3gDzmD5vHQz3TF
         1iEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742580210; x=1743185010;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FHWrgu4CI1pd1XxzLhTETskG12YT/MMg2wUOB15BvDw=;
        b=Acb8Y5WJn0+SnToI9jS4hftC/f9w8sY6Bh6YO2zc1po4wgEBriwiUvJQORohfjCiAi
         NKTYRmBBLLR2gOfIgGgbjiulTES1haciVWePlHqi2NkU5Ct0Iz783lCE5fRsF/9We8G3
         poiabLqIU3uIWV+M6yObZmcaeTtEb4mDLAFr84CRs0HUtR5niSuiRMTr4nSJY3LJdQk9
         al/zCWqLFcogBlIkxf0eo+Q3K3z10XIajbNplS+ZLWg9Pk11T9+5v2nwB9B8/2RJAeqS
         kpLKM6PYo103HiHuKNQFSmQkW4SUGapkbcvQmwJkVGcdwtqVLnfH2/CN1IHozNCNSD3b
         QIyg==
X-Gm-Message-State: AOJu0YwnKVSKeKobpRE74cxirMqNPk5LoS74C2jxxm0DoqQdjJL3JDzx
	FV8KhL7s4d5Y3QKobsiMMPsGgVrp8pOuvs9M3Jf4AhhxUKnOjhS5ujxRKyQ81Mo=
X-Gm-Gg: ASbGncsBqlvyexeDgE4krw5CfN89K6M+VcSZ8U19SzXiIOdhhwN9aYBiUMNdjnW5gB/
	CO2BDqz8/W2wXyOjp7Q3i22+eed5kj7ofeWC+6XnImAyGdWxA+r8pPjDGhJm15PGAFtqy8EsDJT
	DvIL6CGSfEIxXeQy+Ht7eD9THE21cypjAVZygezdBrNWTxoVbyOomp0/Idt2/tarfqN4OKwreeJ
	C04bwGTXy/niX+U/3h4fO5XSIteyzoCBM8MFNBCi32uFSt/5RvO7d+wZJHQKLgn2eJ7L/8Lwc2q
	mEJygldE3YNGxRUj8oWoGEw5aKgC6lG9UKYQgI91AzwwE5OsNnhgO/1MYBV9vrAbuZDCPo8Ep4l
	FguhFh+l+
X-Google-Smtp-Source: AGHT+IFw1l5Jp6Qozd56AnDUA+f0dW6g+9lo+kicQ35LV6Y00Wjk+3zxrVeXUdhwG9mrH+L7/mOUQg==
X-Received: by 2002:a17:903:2f47:b0:224:376:7a21 with SMTP id d9443c01a7336-22780e0969cmr66161015ad.42.1742580210285;
        Fri, 21 Mar 2025 11:03:30 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f39797sm20285935ad.11.2025.03.21.11.03.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 11:03:29 -0700 (PDT)
Message-ID: <d1a86799-a978-4af1-9505-0d972f8e0f88@linaro.org>
Date: Fri, 21 Mar 2025 11:03:28 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 15/30] exec/cpu-all: transfer exec/cpu-common include
 to cpu.h headers
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-16-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250320223002.2915728-16-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/25 15:29, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   include/exec/cpu-all.h  | 2 --
>   include/exec/cpu_ldst.h | 1 +
>   target/alpha/cpu.h      | 1 +
>   target/arm/cpu.h        | 1 +
>   target/avr/cpu.h        | 1 +
>   target/hexagon/cpu.h    | 1 +
>   target/hppa/cpu.h       | 1 +
>   target/i386/cpu.h       | 1 +
>   target/loongarch/cpu.h  | 1 +
>   target/m68k/cpu.h       | 1 +
>   target/microblaze/cpu.h | 1 +
>   target/mips/cpu.h       | 1 +
>   target/openrisc/cpu.h   | 1 +
>   target/ppc/cpu.h        | 1 +
>   target/riscv/cpu.h      | 1 +
>   target/rx/cpu.h         | 1 +
>   target/s390x/cpu.h      | 1 +
>   target/sh4/cpu.h        | 1 +
>   target/sparc/cpu.h      | 1 +
>   target/tricore/cpu.h    | 1 +
>   target/xtensa/cpu.h     | 1 +
>   cpu-target.c            | 1 +
>   22 files changed, 21 insertions(+), 2 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~

