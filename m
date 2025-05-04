Return-Path: <kvm+bounces-45336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FDC2AA8781
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 18:01:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0392618980AF
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 16:01:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 910D119E98A;
	Sun,  4 May 2025 16:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xW3xyy9w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161CB2F22
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 16:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746374457; cv=none; b=kPx15Em/zEzDEKP1XgEK7lO4zROUSOuvj99agRHE6B4y+xRkAiF4zqIzOYapZfihGhCl9qJjG73QZwvBvpI+lvwIzWgusXlNwpjSzIAIlw52q6qpWQKTEVDed2ZPcZFP00B5KQ6rQB2N/zudTBu90St9EYqRR+WNGaJTWyZiwNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746374457; c=relaxed/simple;
	bh=NjVavwxLxv4HCrNQsERslsh9Ya2l10Fikj2iclDH8NM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LGRfzwkr2QhFzgH0IYf9mlTYLz01Un4nv9muEljca/JfO1NSTYXq25avmxD1zzYjapHpA9roKuI/KT23y0MdEvywcDTtyqFiaiNOOsQjT90ICKBdWZuO/NR7vV/N6kDNGHiE8lObWvH0dPCH3mrxs4DvseX0qdNpfDVhtM2fZ5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xW3xyy9w; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-22c33e5013aso37473365ad.0
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 09:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746374455; x=1746979255; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YzVQpNPT+TL8s16+jQLivHLgw76ZAyXebgPC9LfcVXs=;
        b=xW3xyy9wGRxhcltxIA9Tg3km4KxoZbeFCGlrBjlLoYBm83RKDibAe8gNtn7xkHlvaj
         7pPFbf230c7dpkQjIS6RXjUXP/BeGDw/Li7iLyp9vMq150UDz7F22ROHY9uG2P5cc2lZ
         /2nptQNP8N8TY8PzK0M7RgxUivQ/OjgLb4CrarlUn116E+eWh6365vBSsTHkEW/29rvV
         JljQqY1afpW4H+SRgr0vvvzfrovDZ2ql4eHftey+jVRmUqbIYSS5G2l5SbiMxvwZlli1
         rHgMqWwot/sl8l4Wxqpn2ttB8glFf7AFI7HSApd0qKfxGohMagQnxG0SEbzKeEA0IF6C
         ag1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746374455; x=1746979255;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YzVQpNPT+TL8s16+jQLivHLgw76ZAyXebgPC9LfcVXs=;
        b=pUUOVbTlZDukXkQmw50bLMwSAKH+zYigoIK1N7zZhNkl0i/xxN110EJBLcYoI3ygdv
         wKUrE1qQJmpwWjs6G3gSpHhWfoEBhTI4GV8AAAHHUU0DcWGuSppQRjh95EJqiWv+49kX
         XUlj7245dliAmNhTkWAtRJfaTgrqrXXfOXWnGDEfFG82KjLw7C7nq23i/FSeYzCw/5Ab
         rtF5TpvfgsuzK5N4gOCKoVzUhi5upmdgO3fzhdZPYbQG2/OJxKBSDepHKhSgzuF+INZM
         hAZSaOqDwlOnYJK0zlQ4j847U/DXhrtoh/buGDcPSBUQUtJrqkOMqiXuGYQt1I2g+Oux
         oFJw==
X-Forwarded-Encrypted: i=1; AJvYcCXC3DGRtTiTEkQ3Yt6/Zi07jAS8fAf8pI1u5Idkf15U7ReM9E2T7VaSG6Wt7A2LJpOurwg=@vger.kernel.org
X-Gm-Message-State: AOJu0YybnbA9C2Af97KeM8VdAQ5uNK64vffUTc/bgXL6hwfwp8dXAd5y
	0epMCa81OIEQ+HndShlrcLV7hetLlbmj55Pr72QqYe8mHG8UC+FUeI4QwZxny88=
X-Gm-Gg: ASbGncuptk2pzUWjFtZ3FWpZy5RYup1EdC5I+Wlr+1G29bIY+K9rwQc7ecmlRID/+uc
	AXjucHHbVSavSo57d2YHOmrmpa4leTSon1XTtVVs6+XNfo+vGxtOGr2siWCgif2DfbjlYrfMkPC
	rM+CYgjnZWUm+cs5jWwqk75rHjJHsfg9RmICj5FhOVBGcN1djvtL6ul/N4LDL/hWHWYvopplDD/
	5NP+/oyKVOE4uqAvhJrI5rGE2ELLTeZIuQf03rmJY2/aHjeOdRxemR+hknPYoEbgVWwovA9HBXZ
	iYYhMjllB1M5Pq0BhaA6H/IXSJvAP5v7O7R4oseYeyBWGvjM+si6n5f1d//LccaHvDqmYYFMHWF
	BpmR6H8k=
X-Google-Smtp-Source: AGHT+IE66o3FzhnOoYhmgbYjj7kCGXhJa8dnqD/72XM0gm+75hkSaixle1rVIRPVkTst3i+gp8NmmQ==
X-Received: by 2002:a17:902:d4cd:b0:22d:e458:96a5 with SMTP id d9443c01a7336-22e1eae8762mr70246125ad.38.1746374455257;
        Sun, 04 May 2025 09:00:55 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74058d7a332sm5199607b3a.16.2025.05.04.09.00.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 May 2025 09:00:54 -0700 (PDT)
Message-ID: <6ca071ae-4608-4777-a2b1-719d869e1330@linaro.org>
Date: Sun, 4 May 2025 09:00:53 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 12/40] target/arm/cpu: compile file twice (user,
 system) only
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, anjo@rev.ng,
 kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 alex.bennee@linaro.org
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
 <20250504052914.3525365-13-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250504052914.3525365-13-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/3/25 22:28, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/meson.build | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>


r~

> 
> diff --git a/target/arm/meson.build b/target/arm/meson.build
> index c39ddc4427b..89e305eb56a 100644
> --- a/target/arm/meson.build
> +++ b/target/arm/meson.build
> @@ -1,6 +1,6 @@
>   arm_ss = ss.source_set()
> +arm_common_ss = ss.source_set()
>   arm_ss.add(files(
> -  'cpu.c',
>     'debug_helper.c',
>     'gdbstub.c',
>     'helper.c',
> @@ -20,6 +20,7 @@ arm_ss.add(when: 'TARGET_AARCH64',
>   )
>   
>   arm_system_ss = ss.source_set()
> +arm_common_system_ss = ss.source_set()
>   arm_system_ss.add(files(
>     'arch_dump.c',
>     'arm-powerctl.c',
> @@ -30,6 +31,9 @@ arm_system_ss.add(files(
>   ))
>   
>   arm_user_ss = ss.source_set()
> +arm_user_ss.add(files('cpu.c'))
> +
> +arm_common_system_ss.add(files('cpu.c'), capstone)
>   
>   subdir('hvf')
>   
> @@ -42,3 +46,5 @@ endif
>   target_arch += {'arm': arm_ss}
>   target_system_arch += {'arm': arm_system_ss}
>   target_user_arch += {'arm': arm_user_ss}
> +target_common_arch += {'arm': arm_common_ss}
> +target_common_system_arch += {'arm': arm_common_system_ss}


