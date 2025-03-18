Return-Path: <kvm+bounces-41437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB1B0A67C3E
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 19:50:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CF478826E8
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 18:50:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2DE720FA8B;
	Tue, 18 Mar 2025 18:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pzm8rNh3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D97B1DD88D
	for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 18:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742323841; cv=none; b=tFyj9IJzVOpbqxnepEEyCCBNXUy2i+hCT6/XbR3yjfxLdKfs96P6QrX9bXyvTOVxWSyXWIT4wEo05CSkIPK3A1NZCtdfWGhjrDWXoY8/5g3rhLg74qDK518MF9nsct0ZLni+OAqIAPg9wBqo3ijS6zK5SdoRgG9WS4H2leIP8YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742323841; c=relaxed/simple;
	bh=kitAy8EChziF35fsMuQhrNRy/xQipz0lKIrE83Q6sgQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hDwq0ewmJfVFBOjZiw+7QxI6X2NfbMK8nEiNs9yeNJcinRybgCkNfy7uMKgdft4XpreYtAFJoICohxt8OeSJ2945G035V4gizUf7t7cBva2aU5A64ie2+k2fqmsHVKUdRIZp/P9JvSUoFlzvAkz4GziqBjt/Iil5VhEUl1NF9h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pzm8rNh3; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43cf05f0c3eso28016335e9.0
        for <kvm@vger.kernel.org>; Tue, 18 Mar 2025 11:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742323838; x=1742928638; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Pb8edXtU/tnxak4C/Cgcr8vuawSDN9htQBMBeu74gNA=;
        b=pzm8rNh372dq44dii7yr2Jjrgw96ubL6HLiwQy36h78h4veTY4U5dBKicAbrGKwHAP
         kemOUjrQ0Erv5GIpw4MwAY0jm2gGxc8hLXZevTQ0CnB0qaYeACF6gcxrCJ8hLWU07RoJ
         FdZDAEnI4+8KtZYyFpkOEJ+gQ9KvRDptam6HMUzr7CZwvU+Fs4bPxeD2TcLJ3JvwBlyk
         y2GnqX4IYunRv+3TzQwXRijv7bzWSUk8aaNHfrAsNnFJtYoq8VfL2zCF6CxkAu6GeXy8
         tFkptqwgr7HFQPFggKpVRVS9Xcm8ddJeG+g4SkZ63XR8zkDnqQxzZw+o+28Ap2my8BPG
         +j7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742323838; x=1742928638;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pb8edXtU/tnxak4C/Cgcr8vuawSDN9htQBMBeu74gNA=;
        b=mO7xlleqzQ8ZLM0q3QyDhxMYm6zI+TzFxIngH4yW8G0p67lVlzptCIwhbXEl8pgVfJ
         zafWIuJqTVbcLxzXcPsDKSc8TZ5bXhRiHidhOmjGVtkXWuhUAFdYTbKQYbU/3F9SO7la
         g1JXrTDb7qdjWKC+uf1RllWna+riebszYm7sRB5VYpurIsro8UTfxkDs8Bo3Np0Z3I5w
         CefmM1V26ICe9SZQoMS0bPpxDQm1qbD3HO8RKukjurqpqC3mZeyJI+h7+azdlcxdvlgj
         GbjXsNZLN0w9JuXuuKPhn6mwjCY5PLirvmeArtJfyKoktbd0HtE/NISj1JpTSzaEHzWN
         54EA==
X-Forwarded-Encrypted: i=1; AJvYcCUBhh4msRrSuqeRUPcnxxrwc2nqrP9jWJJ+P4The+I13CxseRafsPxterJyHbcwE4PpmIo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9igF3oBfrySCWebQXNOUyHcCACiStZOhyH9WTOT4HLU2GSS0s
	5mxB3YEJF8XL3lAmY1241sdXUDumyNKwVKJwzIT9FhW8i01814EGD+wWQq2oa3s=
X-Gm-Gg: ASbGncu+TGQaFlBrrpwwneTT0vBmbRlqWFg9ix7RW7XnBjyUArC7DoavDaxpc3mmIpJ
	bLsTmoUB+sA+1Mt94QjR6tHjRpY8WjLc0rvlwlRP16ciEKXNjDhZ/Hbx4TJPcJZukT74mC6VJ5V
	PHIJvkJSu/UACKch39zBbFnWG3fMkX1SG4x9g2c3Sy8+ScyO5Cy+F5IlS9Yg7CTxoRp1A0h8gWM
	ktnSgjCh5PT2d9LXrTNOkuR4/bAVzh+wc9l4As/ybzwLdraT2kwMM640RFf59dB/a3CMqmtY4/l
	OMyLZvKkJoutuBsgwfWhrV6jasGZtPK/ZSWPnTjdQrZRL6hX/PBKzFezOoUjUFn5dr+TK5N5ftb
	tK6y3VrC8H70V
X-Google-Smtp-Source: AGHT+IHc6bB1TMekdEnRg8WWvTC5IvU6RseA1FLMd6Is9WRWqk3FY+zcYaKlvS8rTcAwam40KfJI/A==
X-Received: by 2002:a05:600c:138c:b0:43c:eec7:eabb with SMTP id 5b1f17b1804b1-43d3b97f061mr32907705e9.8.1742323838301;
        Tue, 18 Mar 2025 11:50:38 -0700 (PDT)
Received: from [192.168.69.235] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d1fe524ccsm142287535e9.0.2025.03.18.11.50.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 11:50:37 -0700 (PDT)
Message-ID: <a88f54cb-73be-4947-b3be-aa12b120f07e@linaro.org>
Date: Tue, 18 Mar 2025 19:50:36 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/13] target/arm/cpu: define ARM_MAX_VQ once for aarch32
 and aarch64
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 qemu-arm@nongnu.org, alex.bennee@linaro.org,
 Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>
References: <20250318045125.759259-1-pierrick.bouvier@linaro.org>
 <20250318045125.759259-10-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250318045125.759259-10-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18/3/25 05:51, Pierrick Bouvier wrote:
> This will affect zregs field for aarch32.
> This field is used for MVE and SVE implementations. MVE implementation
> is clipping index value to 0 or 1 for zregs[*].d[],
> so we should not touch the rest of data in this case anyway.

We should describe why it is safe for migration.

I.e. vmstate_za depends on za_needed() -> SME, not included in 32-bit
cpus, etc.

Should we update target/arm/machine.c in this same patch, or a
preliminary one?

> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/cpu.h | 6 +-----
>   1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> index 27a0d4550f2..00f78d64bd8 100644
> --- a/target/arm/cpu.h
> +++ b/target/arm/cpu.h
> @@ -169,11 +169,7 @@ typedef struct ARMGenericTimer {
>    * Align the data for use with TCG host vector operations.
>    */
>   
> -#ifdef TARGET_AARCH64
> -# define ARM_MAX_VQ    16
> -#else
> -# define ARM_MAX_VQ    1
> -#endif
> +#define ARM_MAX_VQ    16
>   
>   typedef struct ARMVectorReg {
>       uint64_t d[2 * ARM_MAX_VQ] QEMU_ALIGNED(16);


