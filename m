Return-Path: <kvm+bounces-44712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BFAFAA0423
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 09:13:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 103B13B1317
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 07:13:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD40126A1C2;
	Tue, 29 Apr 2025 07:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="v4/UjR9D"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA637494
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 07:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745910828; cv=none; b=K9vRHjErwVfk/Q6DXNL31zImfWiHNJHWW2TEmiqZ3HEVTv5mT5Pvnin4Gig3BFZEI26qWDbrPDb1vD+0re1s8LHwOnucET99Y6q3VOPVkCrEikZqyKCIlOZYkjj/UH1s00rdmHiYLo6QAkjh44VLu4Kt4bbJ1/InPAoft2v9LlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745910828; c=relaxed/simple;
	bh=EiP+CKMyJA1gU0f+xTr9I3c0TmDmWP7M6mRuV2VGyH4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iinzn998A//TZiylUxiSk6+9xJbwqdD/LL8XS7tzWft0rU7sWctVf0EI+pLRm8B+8aGHXXv4r2i5An9ZXZZB61zkZn4t00zW8TaqSYoc6O5JA1nh3aaSsmYSOxkhAymXSdr3oAoScUoWpEneelZSRgmUCEJ3iRnKF8VuxNSlHcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=v4/UjR9D; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-39c14016868so5605343f8f.1
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 00:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745910824; x=1746515624; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yehZmGTx7uAqJaLE76x+U27DnExTYI6sNqxGDs8Q0r8=;
        b=v4/UjR9DN4VvJM82ho0hvuEoSigUJRsU6wnwZfvc9pwctJYa9qRiqpfLwBNhpyp37i
         J0szcEpnt0Uax4ZcAarvzWe93XL6HrpMg59fSnp6KqXoGfvq+QG0YguU1TKP84cGs7IG
         tZ6nyklGfsBs6x1A6ExYPl8U4nK9rCnpX0ZPerSLIUCp60+MsxAvvAUm4Gm2wYEYhD06
         96qdD+2HwnkYORT3lkbusraWkORpdGyRzzsQZHXnyxaOKeiJkZhn5yLvOGm2MtGWWUQH
         Z34reea3/GoI+0tpuKLFLxkleKAENLlyjlEtPJg11SBgMqUD1C/HkD56tBLjxatGo36Z
         wUyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745910824; x=1746515624;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yehZmGTx7uAqJaLE76x+U27DnExTYI6sNqxGDs8Q0r8=;
        b=aOtMi9vMK1fOtGyI0WSr0GSrKJ52CBW64+9emQkK85kjw44ruz0Y1F1SHDUVNGPHvm
         5y/10vCqPLmr4xSlLmVREZeO5y3wNnTNFATT19KjWwBfeCiTch6ZnYGYwU1yZsgu3zyk
         ygV7exd2aWZhHYKGFgXgsjinHGap1PkAWlavJ7F7085uZuTzxA2fU+Xj5HQHLVH/iM1x
         u8uaxhUylD5pbyEeQ2sE2CrNwjBqI8LNPCZhYGfBvexS74rkK9H/ygOWlXAUDRT6CeY8
         tkD4z4uNLeFsS2bsmY/Lr5sGLl7zGHiYMGCYpus9F/tu6QLpjFwlp1/aG7SF6wNcRyUu
         g6pw==
X-Forwarded-Encrypted: i=1; AJvYcCVtBC+aPGRJkgOmyTHDbyzWWdapVDVvrNDefpjqL+4sePWA9AUTg1oUV/6IxRFm4ZXTqYk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPgSj9kbjaPvDcosD2GQNeQEoHA7/zwrhkZPg1aj3xAzWmwkDM
	xE00f4Qt2shp2WGaCummZU8iUQdo1prR5mYfCBjGbB5Tnwn8sLcxf7b+HPP8eJo=
X-Gm-Gg: ASbGncuLH8hwVnpFTq/n+03INqcHFBdpxHwuhIMc/uyzaVH4bCrrJsD/qt6NvbPdJ6S
	sOClmrjyA69BDuXAo4wPQQmW6sjar+DEt21IkkPo8pkGKooD1NYVNZiB7Pn6x0AfF1AK38uDKdq
	2/WVponkT6mRSV0+c3lXSBjXKqeU0eccYQA3CXesZycvIJqBeImKmDV+I72XruWXcL4lTtbAd/p
	1zapy/2GzG4RwXX7uBb/X5CaP/haAR5IRspm4XFI6hZMXcn6bI0ga1FnpdwyXYb749uEYqGnAEs
	ZXjdOrSmGpjoS4TZuJGNA12EVauv76HhjQLZgFNo1miDFFie3KSPUgZeNh5uB0Hureia/Sl1aqP
	sIE47vvcDh3eGUg==
X-Google-Smtp-Source: AGHT+IF3jDfaiFaE0KiZ5e+08grYBav5IRWcws2yhNnnOdNJAuGgzhyThrFzk7CHNb/gc6OX5zpWeg==
X-Received: by 2002:a5d:4884:0:b0:39c:141a:6c67 with SMTP id ffacd0b85a97d-3a08949d731mr1735344f8f.45.1745910824440;
        Tue, 29 Apr 2025 00:13:44 -0700 (PDT)
Received: from [192.168.69.169] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a073c8c95dsm12856743f8f.3.2025.04.29.00.13.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Apr 2025 00:13:43 -0700 (PDT)
Message-ID: <e178a430-7916-4294-b0c3-60343ce6f023@linaro.org>
Date: Tue, 29 Apr 2025 09:13:42 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/13] include/system/hvf: missing vaddr include
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>,
 qemu-arm@nongnu.org, anjo@rev.ng, richard.henderson@linaro.org
References: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
 <20250429050010.971128-3-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250429050010.971128-3-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Pierrick,

On 29/4/25 06:59, Pierrick Bouvier wrote:
> On MacOS x86_64:
> In file included from ../target/i386/hvf/x86_task.c:13:
> /Users/runner/work/qemu/qemu/include/system/hvf.h:42:5: error: unknown type name 'vaddr'
>      vaddr pc;
>      ^
> /Users/runner/work/qemu/qemu/include/system/hvf.h:43:5: error: unknown type name 'vaddr'
>      vaddr saved_insn;
>      ^
> /Users/runner/work/qemu/qemu/include/system/hvf.h:45:5: error: type name requires a specifier or qualifier
>      QTAILQ_ENTRY(hvf_sw_breakpoint) entry;
>      ^
> /Users/runner/work/qemu/qemu/include/system/hvf.h:45:18: error: a parameter list without types is only allowed in a function definition
>      QTAILQ_ENTRY(hvf_sw_breakpoint) entry;
>                   ^
> /Users/runner/work/qemu/qemu/include/system/hvf.h:45:36: error: expected ';' at end of declaration list
>      QTAILQ_ENTRY(hvf_sw_breakpoint) entry;
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   include/system/hvf.h | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/include/system/hvf.h b/include/system/hvf.h
> index 730f927f034..356fced63e3 100644
> --- a/include/system/hvf.h
> +++ b/include/system/hvf.h
> @@ -15,6 +15,7 @@
>   
>   #include "qemu/accel.h"
>   #include "qom/object.h"
> +#include "exec/vaddr.h"
>   
>   #ifdef COMPILING_PER_TARGET
>   #include "cpu.h"

What do you think of these changes instead?

https://lore.kernel.org/qemu-devel/20250403235821.9909-27-philmd@linaro.org/

