Return-Path: <kvm+bounces-51345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 66DA6AF6409
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 23:30:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F36094E31A0
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 21:29:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C662D23BD09;
	Wed,  2 Jul 2025 21:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BZ1A2qOt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7002C22D4C0
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 21:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751491809; cv=none; b=B8wmr2HTkOJIs2H0hujrl6Z1meH8gDkLTh6PlWe9pSMcwuBOFyeHFAapd01Mw4MceKJN4h9hhnWKCKfaWluRN+o1C52A5nLPG8AgvwxbqMcK/qHMpVrDXjSK1USlNM6RQyClmkejfVnLvTkehK1xC1koh23KtqjG0vztfMDazFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751491809; c=relaxed/simple;
	bh=D1G0IA3bYL9hCJxeL0jvyoa1uf1m6XKJU7xRpuR8F0M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IXbYyqLd/Ck0U4lELj8NHJmConV+JwprfC5HoP5HNGiY9D9rH7lGlvc+gFA06VjWePElQBm03cschDtxl94twiVrqsxV+MytXmZq9cksuHiXdDFfWT9TkHcQazxI2KwtPy3oawYZiXGcdVpKItCuryHMoqEd9qIOthMS6yU0ldY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BZ1A2qOt; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-23636167b30so46267255ad.1
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 14:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751491807; x=1752096607; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uZehWfMyIfkq6yTIuw9X1Gv3CLzMTYrvvswzJWpiCog=;
        b=BZ1A2qOtOVlW9pDmAEkJ0Sf3ZUmcQ/MjE9vIw8Fm8Kau0/2u72lwc4wxYs9pjdCTwr
         mM4rZ5RPf/3Z2WAquudlxoa/p0MzzXLG16zvHgR0kbQoiSqMiLjuIVSHovAt6tclXXDu
         wEl39kGWp6MxosQP+LqAzxQzH43Q9Oy4rqntDmf1RfF2dgX47vvxDHkxBVD0Wdjgjq7j
         3PV2fCGgAA/7sDkLK2CpVutHV40bbZ5DJcdP+QEHmu3dHysv5PcPN9xCRvyjQ8mUxg8y
         Zf5yVAGMEPgSaU8nTbhcRb7NxdcihD/G0UESxUXbPgMwe1kL+NAbBPKcVGyuTD9QfLe5
         zFzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751491807; x=1752096607;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uZehWfMyIfkq6yTIuw9X1Gv3CLzMTYrvvswzJWpiCog=;
        b=LtyPvQMc0nZ5xV/aIhWXJ3nMNvEqyahWHxO0MjB47q8WMhC7sZ5vgc7SSA/5x5ZEru
         JbAbRbU+4BIDa20Qm/iIWTc95OJOh0hbJPWeupWsnbQA62Jpd3oa0eh9Ku32iJYBzbKy
         ApcUZ+I7k1lwtSDL5E2DLfRB6LP2kjiWFQa1o7RN+6M04i+ur01y2sm0Cyj4nbluQWdd
         OBPONmnSYg+HQxSf/0AnbB/nXwNRldZkTqJYFbZGVLm/b+82Rl6HvOOjiGF33YPckJTc
         8cLonUDQI4M7+ezu9YWwyhx2I2xFEvBwiOACCv9mwbrH4lWvesufI48YjvhIG5CFCVtb
         MbnQ==
X-Forwarded-Encrypted: i=1; AJvYcCUu/9WYdk8R+BgkD8j0pD5DTBGkIlsjjaS63ZNdP+8cUEWnYPJ1NGP0DsX8QpJ33jbNbKU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPXABf26FaaQp7yi8AajoCGSS884rQyeFXw6syU3B5k7XAtvA0
	/edyeir+iYApu9qtrmMz+82X1ltDlXZI2qfEnvkJSndhpMGVZci1Us1FdURNiIZ0UFM=
X-Gm-Gg: ASbGncs1ggeK5ZIInoIbV0imszUsWabW8LKQ3OmYCVF2fQUJyt4HREBX5ut1VkrJSx/
	LWE4YcQSb/4b9MlBhe7k5FazOD3URuRwTG3EmU+YS1Joeq1Kg2Bpb94s22dcIGIokUy78x0s/yf
	G8n4iYGWZVKTGyW46QoSJMPKefkr0MS/wgPXXr4IP0Ztxfv+dxAPJnihqGkknS/8XRohgafGpb0
	QeJcDHp+bc//8SX9I7Cpdkd2NMh8ww4CMZum3Nd4OKlhbicz0smvsyRL01ynlXG6aSdPoHFN+e9
	Di8d0Zck5sk2FUNf9LP/3lz5Xpo1DeQtWey7oDKz5VqjEaHyLzTc42kTXKbeffPZ+tysRNmlm9s
	=
X-Google-Smtp-Source: AGHT+IG9no+Unkyg/FYILPO1RDG3pnFNTZHuoOP0I7KlSIk1kl7bNstbmqliucHtTcpqKD2VVL5JCg==
X-Received: by 2002:a17:903:238a:b0:235:6f7:b918 with SMTP id d9443c01a7336-23c797a85a4mr15391395ad.28.1751491806805;
        Wed, 02 Jul 2025 14:30:06 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b34e31da845sm13498733a12.53.2025.07.02.14.30.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jul 2025 14:30:06 -0700 (PDT)
Message-ID: <ec12909f-4a74-413f-a600-2882b67d09df@linaro.org>
Date: Wed, 2 Jul 2025 14:30:05 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 59/65] accel: Always register
 AccelOpsClass::get_virtual_clock() handler
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Cameron Esfahani <dirty@apple.com>, Roman Bolshakov <rbolshakov@ddn.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>, Mads Ynddal <mads@ynddal.dk>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Anthony PERARD <anthony@xenproject.org>, Paul Durrant <paul@xen.org>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Reinoud Zandijk <reinoud@netbsd.org>,
 Sunil Muthuswamy <sunilmut@microsoft.com>, kvm@vger.kernel.org,
 xen-devel@lists.xenproject.org
References: <20250702185332.43650-1-philmd@linaro.org>
 <20250702185332.43650-60-philmd@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20250702185332.43650-60-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/2/25 11:53 AM, Philippe Mathieu-Daudé wrote:
> In order to dispatch over AccelOpsClass::get_virtual_clock(),
> we need it always defined, not calling a hidden handler under
> the hood. Make AccelOpsClass::get_virtual_clock() mandatory.
> Register the default cpus_kick_thread() for each accelerator.

Same same.

>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   include/system/accel-ops.h        | 2 ++
>   accel/hvf/hvf-accel-ops.c         | 1 +
>   accel/kvm/kvm-accel-ops.c         | 1 +
>   accel/tcg/tcg-accel-ops.c         | 2 ++
>   accel/xen/xen-all.c               | 1 +
>   system/cpus.c                     | 7 ++++---
>   target/i386/nvmm/nvmm-accel-ops.c | 1 +
>   target/i386/whpx/whpx-accel-ops.c | 1 +
>   8 files changed, 13 insertions(+), 3 deletions(-)

Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>


