Return-Path: <kvm+bounces-44868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AE41AA4584
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 10:34:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B2D381C01357
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 08:33:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B833213E85;
	Wed, 30 Apr 2025 08:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mGaFpQzv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C656920C472
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 08:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746001942; cv=none; b=blDq9QqlqDsdQudN3so5ii8veZ9VpZNkDC1P6RaSW5c4Ag3gP6OLTDkU9z19dy4NolsHZxKoEBto1zDU1Zpk2v+f0Pbftqb8hMoVQa1d5VGyXXyVozzbuxgBW57wkJTpGXsAJ+D+lEerxHApSIsXnv82evTM2JWfYSeWqEgEktU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746001942; c=relaxed/simple;
	bh=ni77Hs75vXZHZ+w3OcTWho3j2xVPCcEKnChLNfIkVYc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RJUXcVeMMlcspEQuy8dzQ3MAPC0HydBrZIsGty1H6VMHM6jaoA0nsc9ITIXyDo+4JL0XRNCLdNwHHhUfF1a0dRsUfnGk/dkbf0dYrKCKUcXNJTtmcddVLgZUR7BeWF/rRcVgsta1YoJLBbnmp9LWN1/hmITDpmeDhBKNIhuuB6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mGaFpQzv; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43d0782d787so42888375e9.0
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 01:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746001939; x=1746606739; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2qvonH+2UdIFy8nw1UMPJbLg1oAPPZJBDd5LZzjkU1c=;
        b=mGaFpQzv81OmmUdTKv78NqgtIltpA6MbaunZVvSKtfCl62NUR88dbzk1i6M8ld9T2s
         591iVecGxRbupJYzKHEEx4nCj9VicAPUCENyemPXeXh334LgQp3JrwNBR4M3YKoRLzAV
         cpccBX3DN2yYbie84gKtP1h9MCoxafo56YA/D+Gwv9YT2vk37eiXkjSlNaV4Ts3cEyl1
         0YJJp/1xTWfYwr6nEpntZyRS0b3R49X/kQGEED8c2+VC8KB13ls0Euceh5xMU2yZmukC
         KPAjOLHuRiYQpTfu0g8hotSKDeOTn/u0RJ/LkLdEyapuEI7bG6k2bgS7smugHhMCNdol
         2C/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746001939; x=1746606739;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2qvonH+2UdIFy8nw1UMPJbLg1oAPPZJBDd5LZzjkU1c=;
        b=DdvjWqOAQKWrWv41XMTIXp/m0TVXaMdnjM4yJevSxpHWuVDNfaFEMI4e8vcCDNeLsN
         aofK1hiAZE9hOyEQVvbFgHBedpk+dIrn/GCR6RXqpRt6/kcX1DGBn/7VmAjjoi2/iDrs
         7a9gFBK4dnEy1WRUp/GBKiH8fzm2X1FSTtPSG1ssxzBJcgP1QxKEj5Igz1Qfv+MBYjHd
         iFvuhj3kCbRwBDtjBZ2QadPvteL28FY4USinmMRYgHIc40o8hlTSyIvauV3063BE3GAQ
         0gFPfrxFKLAzg1Uob3+bGU0ED4EzFmK7rurrW4xgdBOCo0fBUprfonosRAGD0W1BIkoR
         0aXg==
X-Forwarded-Encrypted: i=1; AJvYcCXDCBg3zadT2dxExVlqECG8enpI6/sk4mxlFTSr0Vzcbo707TIB3IOOroXU+HRRytT7Whc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYszMSR7mr/6RHF2lz4LpZrQ3k1T0IRwvtHP/Xb299ZG7N1KQy
	D1qyr+mOQ+ryux8jCXqzSQmijYMLt7/zsCrhpvGrawqlJd8wKEaKWfmjzxitbLU=
X-Gm-Gg: ASbGncvWpX51uWRcL/4ad06ceurcefTdCOnfyziGedt7eJe9oqvjACEhTg2F9lxFUfI
	jPGTsenUG2p937c5wqMTnE3O3Atw2qBoeSTKYtVlQySG+aKeNA3SmByG2LR/Zcj8vxZ9HarZXdK
	kP527qPtb+RVwGyT0jTwOZWPnusvy/b3CdW7yMnoTXdFFYO2sCpKbt64OSdu6cCsTspqA9PE6Na
	oFzRuml96qUnT5D+cBObynAwGMqciESFevGOply0R7nt5mcEwskQWyoohSjrfPEPTe9vkFxdiu1
	J3f10tmlrfXEAAmZqrPsa8e0SDkHoOyQJHNlOKdHOxPYzqsJ3wezssjZnrbRd3b0quCVQhx+TBA
	Iax2PdluVHHg5UvfmWy3TsUJo
X-Google-Smtp-Source: AGHT+IERAra2NjcLKE4jV51pt8p4zQVzESu3IBG3Q1PyFrG6gIshOZrE95suQGiFVeUO2wpirjpSCg==
X-Received: by 2002:a05:600c:1385:b0:43c:e8a5:87a with SMTP id 5b1f17b1804b1-441b1f3a597mr21245755e9.16.1746001938912;
        Wed, 30 Apr 2025 01:32:18 -0700 (PDT)
Received: from [192.168.69.226] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-441b2bbc0a2sm15637755e9.30.2025.04.30.01.32.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 01:32:18 -0700 (PDT)
Message-ID: <dbc62384-b05e-4f30-b82a-395a82812f65@linaro.org>
Date: Wed, 30 Apr 2025 10:32:16 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/13] target/arm/cpu: compile file twice (user, system)
 only
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>,
 qemu-arm@nongnu.org, anjo@rev.ng, richard.henderson@linaro.org
References: <20250429050010.971128-1-pierrick.bouvier@linaro.org>
 <20250429050010.971128-13-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250429050010.971128-13-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29/4/25 07:00, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/meson.build | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/target/arm/meson.build b/target/arm/meson.build
> index c39ddc4427b..89e305eb56a 100644
> --- a/target/arm/meson.build
> +++ b/target/arm/meson.build
> @@ -1,6 +1,6 @@
>   arm_ss = ss.source_set()
> +arm_common_ss = ss.source_set()

Unused AFAICT.

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


