Return-Path: <kvm+bounces-45345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CFB9AA8805
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 18:23:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06D201774C0
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 16:23:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7774E1D63CF;
	Sun,  4 May 2025 16:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AYv9XNZU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0278F7D
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 16:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746375797; cv=none; b=fCWJ/jHdchNvufD9xKwVBjgtruf82L9gpFdzCnjwtwrwiSLJ79+ZyuAHsmTHoIdtKE0zALTP/6Q+QLAJ9GPTUVk9aLDnDUMDn6Q868tpAzbjQKSpymAQbDCJgB6s/NibRO/HqicsCcH8qxN+ZfsV9h731Jjlovl2rcWrrBgFIgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746375797; c=relaxed/simple;
	bh=HRjWH4+yHfljsbJe18NwmOY/3Edzp6ut+iTHr8I65P4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qh4CGetYk17GtrfJ83/Quj94A41WBRMsyObN5j/mqt4eEdAcL1ufwQsBvPQwtb5vG7fuzkKR1NlcUYoLOmkcGzsEAIQyvDUo/woTKyxWI76ni3gDXaXuDD2fe3bEyRan8pctVARnSrnRk3yER1zHs+RFSCndl864esuKzO7w0gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AYv9XNZU; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-af28bc68846so3494207a12.1
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 09:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746375792; x=1746980592; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BLjUVLdVq38E0HUOI0rLguEylIZdL7Xxs7lg4wT4WD4=;
        b=AYv9XNZUrWJAVPgLpOmcFW9LFe6GzSgHv4+JyxEDwWkxeLS4BnfeC2nNFvtaXWgccF
         pwxdSNUE8OluEO/15jr+PsgIhK0SulbMWQ1URtXompBdcXs07ZFwPRncgGFbdp8HEpnd
         8HMsGG2XAMyD/xtsCAAnEj7CuZg/vP8ZAG9furoEIL5rMGgEwYnyUd/MNydpJBZpylWJ
         b1GHnvbeE+r8aad4QPmzsaTpfewaiGcljWnS04pp69Eb53E7oEz31HhwB+/jv19U41e/
         kdHT60EMAshZ2yuXxUGBryN0mMdkouAjLL3R+kIiFz7Odumg4+VSldgLCfLuujeXYUO6
         4g5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746375792; x=1746980592;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BLjUVLdVq38E0HUOI0rLguEylIZdL7Xxs7lg4wT4WD4=;
        b=CXWhRtUCMZ2CZjbpaCcdGn3s5INtOWQaP8VyF/X1IyANar7UXsr+s8DdNHevl8v127
         7pn5QC3yffAcQEv1QbwNjKs3coqPGoX/McHWETdk+wa9VmYSWYDvl7N9Fo9xQfODqgA0
         hrVr85okuiXhm32p3ab7CsuDngPhSYYQahYeGHFGVGk9Bz8HcW7GFDcLNS8szP35a5cj
         GxZcN3aDYnctIVTmiGNZgIf9TZTQGFDy7LlSfkXDY0PoCcMiT0Q6cfqx4hTy0a/APJ6H
         HV30PZmBuO1MrcVmiotZvMbxU5EE9baZzu1dcPd8jAFT/o8hM4y9Gabw04AVVpg+oL3w
         2AEg==
X-Forwarded-Encrypted: i=1; AJvYcCWb8ZN8ksaA/aR+0kkzGZQ8WTtvND0K3tmOiAj8ORbo2xXqgdLh1chqHTeyZgKg0B1gfK4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyU2rOYGpSPBNCrCfdg9PcKAih7BLRHNQDr/+P4r29yI6k6/x1v
	uHUf7nLHJfm13opoyzmFal2gsx2aWKnqQkzp8XD40NzvfKAuGRPkAoCOAxcwNQ0=
X-Gm-Gg: ASbGncv3iJcn4SrO7mLlm3UDfmOnra+LLvz8ZqnGGWEMnxrQnK805YKmryUUK8oYG/i
	0JWUGSiffrpplW/J5GOUCY0ZdxAYxiWx3c33GzdgJYxNAcQjYUe9z7pWXe50/dIz56vbq+FgPxh
	9ACjzTn2TzZuXB0jBoof7hjf2JmaQjhlYNXl4zoCL6QOijT2VhfyW2Pid9INwwzixbOWQIVvr0Z
	/NXMQo5e0rOLb8MQlPe2KonqKA62LIV+mECSLFAUlQLeyRQ3P6rlXToYmisqKx7eFK0lCm5oyoz
	V8wyBvpNZQfvXiG6xjHF50xdpTeHWDQEIxF3sWoyLpV6ouFC6M/A4X7tfMPYZm+FUnR2bxjkaBy
	01LAwuns=
X-Google-Smtp-Source: AGHT+IGG8iLGeA4CdD0ixdSNcxIntlbOJm3it6GQMfYx68he3yFqHRk29MPYt91OlZ6NQtlxvF0qQw==
X-Received: by 2002:a05:6a20:d48b:b0:1f5:86f2:ba57 with SMTP id adf61e73a8af0-20e978cab74mr6244131637.30.1746375791746;
        Sun, 04 May 2025 09:23:11 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3c3e8b9sm3995961a12.47.2025.05.04.09.23.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 May 2025 09:23:11 -0700 (PDT)
Message-ID: <fb79692d-4320-44fc-a555-4c491b172959@linaro.org>
Date: Sun, 4 May 2025 09:23:09 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 40/40] target/arm/machine: compile file once (system)
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, anjo@rev.ng,
 kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 alex.bennee@linaro.org
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
 <20250504052914.3525365-41-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250504052914.3525365-41-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/3/25 22:29, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/meson.build | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/target/arm/meson.build b/target/arm/meson.build
> index bb1c09676d5..b404fa54863 100644
> --- a/target/arm/meson.build
> +++ b/target/arm/meson.build
> @@ -13,7 +13,6 @@ arm_system_ss = ss.source_set()
>   arm_common_system_ss = ss.source_set()
>   arm_system_ss.add(files(
>     'arm-qmp-cmds.c',
> -  'machine.c',
>   ))
>   arm_system_ss.add(when: 'CONFIG_KVM', if_true: files('hyp_gdbstub.c', 'kvm.c'))
>   arm_system_ss.add(when: 'CONFIG_HVF', if_true: files('hyp_gdbstub.c'))
> @@ -39,6 +38,7 @@ arm_common_system_ss.add(files(
>     'cortex-regs.c',
>     'debug_helper.c',
>     'helper.c',
> +  'machine.c',
>     'ptw.c',
>     'vfp_fpscr.c',
>   ))

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

