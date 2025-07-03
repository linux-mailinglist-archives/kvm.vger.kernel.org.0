Return-Path: <kvm+bounces-51402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CDCDBAF70CF
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:45:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C34247A50F8
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:44:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38E8B2D97B6;
	Thu,  3 Jul 2025 10:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hJuZInas"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3858163
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751539536; cv=none; b=KEw8Mi2mcUPuvehVQXII0SPXxtaZR4VCk+dZQXn+fjrE+IZLAXPYHZH+Va7P6whmBCEoyF1+TcEViE3N0MYI5xWWrEdNbDhWgUGSj1k+zJP+f2qPGVYRK1K14uWWPSC5v5X3H2H25WAE12Al5wSNlRMzv8sPwV62DgqyvMhZfEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751539536; c=relaxed/simple;
	bh=XkLVgOWU+d7Pzk8gklxSb+8w5mD7o5zR/HU4+2WrudQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jmkz7H4btRlAJnpN7HaqwmTZqOwYvAj4Ezdyi14PwAu2RMLknSOcXR6gxGK6aQg7YvRMzAnl1/fWg9yi+6Pbx+wOarGcxaamtTYRRQFF7oX+cVE3tjvRk2/EuUMxewL1WRxXMdbeNRHdIeeAeu9wUSXYjR0+NHTJ7peludrfGLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hJuZInas; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4537edf2c3cso78416275e9.3
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751539533; x=1752144333; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/ZkHDTYnd7w9tT7FcErUb/YTrxXuUo9RA3yVDQCWTRk=;
        b=hJuZInasjzgEiCDoftE2GD5iMh5i4xPZVNuMzLTKQ+33I+usjDRTQe4XihlBPCp8Tl
         /+AWRpcO26qsyXeMJ5e9gUjj8ErYK9GJCxUoiZXCBnEB73JReSwJaai922cpCsJg96+7
         +UrmotTCSg8vmiSQPG0RaZLCgJ7x87NqXv/Zh8SUf5WVrrUb2n17iEqo5628oLlHd8Fc
         D8HQ3hTGWEtC7D+opq2w3ICjQs6JpwPb6ileRcECH2LiK7QCrpZfze+jVfxK3GxKMiK6
         NYX4xsoZGXuHJyVlTTU18QKG/TJuyhbE1KSMHBl6k8NiRPe74NFYPZda+17gp4Tasy3j
         v5Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751539533; x=1752144333;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/ZkHDTYnd7w9tT7FcErUb/YTrxXuUo9RA3yVDQCWTRk=;
        b=GkIBtuiMJCu2IdyWzExQsQbiSopjUXr1XcmrhEA0xugVJ//owpo/0Q2nalyTvj0kyG
         8odkDgG7LnjuCsJuQGWxCdF8XvhwfIhSn8D99Xb0enZbDbskQ0xGV00H9o6CGHB8kwqL
         EIKoT/wZruP3fwqnJ0W1XVI+VjaHnhjX3skfHaBxK+hbeOe5kX5Uj0qgC9TGcjeqytsa
         9/PGwSR5q/9XCKvmnKeGoegxrrXj97s5R4WHO0UiaLTVDabk30Noy6sCszznVle2LLwW
         FWLZ6KrqVCey7zVf9YHRIM94J5bqamGk8izLmPRLU3OhMOLgG1gyfhD5nRRfv8cUrUm5
         z/0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWBG3UAIsHxI19df+NEq9KM1YOIrwzwkEq76Xn/waG/xypigIoI1ED3/nJsM8WkX1TW8jk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxy1bftt+/GAWwEHvRNeX/qNtshKt2SAh84Z3CW2ZVSiW3H0nlh
	Tgfz0ninEStO/2VtJY3bYVsCZxEG1OqeW9MQtZlfQzgME7llAu+o5lLc2hbVPEG1VwY=
X-Gm-Gg: ASbGncuqYALkDq657Vor5eLWiwhG4GHZ6bhUjj85X9rcUHsX97ouvTP4rklrcwSY0fn
	OsiMXjTIbDahqE7vk1N3EZCAcgQwhwgWwOFljHI66LCPwndYbGMA/YMdS/7mumhTvOM1qr6tHlO
	4q2/Espcc1cigk4LuvN8Fo6DeecVOPRSlj5u/6kFB7LeuZFEM9e+Kre/rUJzsc0gfxGK3EpQuPz
	rnktTlWoHAouNbeeNJcUnv02vfPze/x2q5aaN+Xjiwutw4iNm/73+4A0PGftaQ9zL6UhRGQAJzX
	SG4rUaO6raXCvuKWoJqoOy2EF0mQ7amAKop0YkVITQl0NrdRSK8vllS9AJu2jPFTD0/sNItiBws
	y
X-Google-Smtp-Source: AGHT+IElA0mswuuh9WSnt4MDEnV+aPiBDrsxNfrDJ6sq7nHox2RqriJhZeVkOckam7J4GYfITpiuOA==
X-Received: by 2002:a05:600c:4ecd:b0:442:e9eb:cba2 with SMTP id 5b1f17b1804b1-454a9e47500mr31207415e9.0.1751539532844;
        Thu, 03 Jul 2025 03:45:32 -0700 (PDT)
Received: from [10.79.43.25] ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a9bcececsm23244235e9.23.2025.07.03.03.45.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jul 2025 03:45:32 -0700 (PDT)
Message-ID: <d15188cb-fa33-4d94-a3d9-b0ba3b2d71da@linaro.org>
Date: Thu, 3 Jul 2025 12:45:30 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 57/65] accel: Always register
 AccelOpsClass::kick_vcpu_thread() handler
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Fabiano Rosas <farosas@suse.de>, Laurent Vivier <lvivier@redhat.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Anthony PERARD <anthony@xenproject.org>, Paul Durrant <paul@xen.org>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>, kvm@vger.kernel.org,
 xen-devel@lists.xenproject.org
References: <20250702185332.43650-1-philmd@linaro.org>
 <20250702185332.43650-58-philmd@linaro.org>
 <5348f155-5644-497d-b9f9-89924d961cff@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <5348f155-5644-497d-b9f9-89924d961cff@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/7/25 23:26, Pierrick Bouvier wrote:
> On 7/2/25 11:53 AM, Philippe Mathieu-Daudé wrote:
>> In order to dispatch over AccelOpsClass::kick_vcpu_thread(),
>> we need it always defined, not calling a hidden handler under
>> the hood. Make AccelOpsClass::kick_vcpu_thread() mandatory.
>> Register the default cpus_kick_thread() for each accelerator.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
>> ---
>>   include/system/accel-ops.h | 1 +
>>   accel/kvm/kvm-accel-ops.c  | 1 +
>>   accel/qtest/qtest.c        | 1 +
>>   accel/xen/xen-all.c        | 1 +
>>   system/cpus.c              | 7 ++-----
>>   5 files changed, 6 insertions(+), 5 deletions(-)
> 
> Sounds good.
> 
> Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> 
> Unrelated, but I noticed that hvf_kick_vcpu_thread uses hv_vcpus_exit 
> [1] on x86 and hv_vcpu_interrupt [2] on arm64.
> I'm not even sure what's the difference when reading the Apple doc, 
> except that exit existed before interrupt.
> [1] https://developer.apple.com/documentation/hypervisor/ 
> hv_vcpus_exit(_:_:)

This is the "Apple Silicon" documentation,

> [2] https://developer.apple.com/documentation/hypervisor/ 
> hv_vcpu_interrupt(_:_:)

and the "Intel-based Mac" one ;)

> 
> It might be worth moving x86 to use interrupt also, in a future series.
> 
> Regards,
> Pierrick


