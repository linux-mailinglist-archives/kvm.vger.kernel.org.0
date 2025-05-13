Return-Path: <kvm+bounces-46329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BD206AB5288
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 12:31:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C73C51B47DBD
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 10:28:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D3FF23C8B3;
	Tue, 13 May 2025 10:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="srM3iqsS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF6C23CF12
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 10:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747130967; cv=none; b=bUPToLPOnUaQ/j+xrGdd0vVOf2ty57+sfPqmh/o+x+dABy6sbexnCQ/xF/F7MLxgpSsLtEVweIaX5oE1ELKwkg+dJOnLrFbFZkU+cZYZ42AnmaAQV0B+N9oJrN38DmwmwVGd4vC4ib5jjfWFrQ/D290bycksdLbso86qvTf15Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747130967; c=relaxed/simple;
	bh=3QJLKx0IMpOy/V9NZMLrcPtqmwuBmVAFP9jgdsliV/o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HfW26WdLZIFXwiZFdSesV497LBCK1r8E+02Ce6+UHEcZ3rj5jwoZv4wCbtuF2+4AgIrALUdvRuYyG57NeUwYDkdBV4Xl2znDYKXul4YI8rwJMUEikQ38aXVLgE1Y3ndZwv4k6ZXWRQ+r4BA8MUfNWezGTa/1IOQ4f32ztRAByKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=srM3iqsS; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3a1f8c85562so2642160f8f.1
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 03:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747130964; x=1747735764; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qAj39my+7Ge5Cp7+If3CmQHkrz/P16jjralaU9o8Ftk=;
        b=srM3iqsSKxHhZ62Kwnr+IJ3HcsAdRT058WCBZixnGato1MF+YVQzivU6qdH1qIsI5q
         99MMNatZJmW+yiTHiFHTj2FJ0pM8RUcE6BfIKlA3/5o2UAzztkA+775baCSV+8dXF8QZ
         xgpB7kDh+iz1zlGLfNn+sIRPFPRxKGtT4MSUNITYufnfOEJVFzzuetlydUFgAwCelVxb
         iJwGfpeAh8GPPowXMNK9r7Qd/oKyfqbPHBFBBIDEWYILm535HftNoTF1ZTNzETxivAEZ
         t4AREbSZGMogJ/vJB9gpGK7IrYw+qgQauvplZIpgJIwGV+5Ej3JjcxndN8SZwTJAOSn4
         y2Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747130964; x=1747735764;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qAj39my+7Ge5Cp7+If3CmQHkrz/P16jjralaU9o8Ftk=;
        b=hKrhoTTi88rztilYZjheU4R3E/FLtJYCyQkj9R3tVUNlVSL6MjZJQpqJ188CKxgGEU
         YjEbPM4cws2Yf8jY9aOFfhrAQRUDqUF1+IWzQZdy12QaRZz/a+FmEtCDmzdhvcp14pOB
         Pic4I4TbCXn1j7phouU5MX0yzfxChBYtNIUXdwgo9QOidSNLRcKj7nCrkLR5q/bD1X/f
         VHQmXb5baeEVdd+Xlkyy//kCwY2v91SY9L2qhpYHVUpL7wyG4kT5xdEDIBqJvElrK5zD
         G9i4cb2E4bvTsqOQ4yQA04flZArdu9mQf3rQhV+1VVpeyhW/SEGYCqZP6diTFCNOWXp8
         Cbyw==
X-Gm-Message-State: AOJu0YzrMZVbpaVJV1RPc5baWsD/GRihFU4/aaEQdPdh/IsSNl7pA3tP
	C/f7uLjGC3fHFbjf9jOnKJPu1LJD7wbApNahRUPsgKT32EFDeKaRf+K7IeoW0Lg=
X-Gm-Gg: ASbGncsBAg621dajZxsywX4g0o6vD025q8nBxjeFIoqJT0YLYucYpzH0pD924FthdV2
	BvcXwVZGV3cH8ufBFFVKWZX9Vf6Kqm777rlX9CjekS7jitbxRehE9kAQekOt8G5oWf1AfZCHNYQ
	RAiHDIb/Qf/Di1bJExCvGH04ybAis4/2TxJpYl07hTntOJRzJEzn5Qq+3heK2N2ryqnjE8bAGH0
	WbWDblvQu3IwQ8LuJuJb2ps2asz1MTOe+Jaw8l+QJYjjVfMHjcFhg75jEAvUGlFXtH+iCi2ZxC4
	3lbnRd25nHJUrJB0gy8Swlozd+OthqLgfBXWvqnJk7pEOVmgHYbhL+ksONPYh/LEk2Xa74Dxjz1
	5toHrX/KE7vXo8jhQgw==
X-Google-Smtp-Source: AGHT+IEUHm1wZNdfyUY8NiVVrmc8c22MR+Lj4Y4EqfglE9tVmzbAAQqqaSGPkDQdsGEihgYnq0Ecxw==
X-Received: by 2002:a5d:59ae:0:b0:3a0:b84d:60cc with SMTP id ffacd0b85a97d-3a1f6421bd5mr14438192f8f.2.1747130963996;
        Tue, 13 May 2025 03:09:23 -0700 (PDT)
Received: from [10.61.1.197] (110.8.30.213.rev.vodafone.pt. [213.30.8.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f58f2b29sm15846995f8f.53.2025.05.13.03.09.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 03:09:23 -0700 (PDT)
Message-ID: <59b505e1-3cc7-4308-a546-d9c4663c5333@linaro.org>
Date: Tue, 13 May 2025 11:09:22 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 29/48] target/arm/ptw: replace target_ulong with
 int64_t
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, alex.bennee@linaro.org, anjo@rev.ng,
 qemu-arm@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
 <20250512180502.2395029-30-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250512180502.2395029-30-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Pierrick,

On 12/5/25 20:04, Pierrick Bouvier wrote:
> sextract64 returns a signed value.
> 
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/ptw.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/target/arm/ptw.c b/target/arm/ptw.c
> index 89979c07e5a..68ec3f5e755 100644
> --- a/target/arm/ptw.c
> +++ b/target/arm/ptw.c
> @@ -1660,7 +1660,7 @@ static bool get_phys_addr_lpae(CPUARMState *env, S1Translate *ptw,
>       uint64_t ttbr;
>       hwaddr descaddr, indexmask, indexmask_grainsize;
>       uint32_t tableattrs;
> -    target_ulong page_size;
> +    uint64_t page_size;

Subject mentions int64_t, description mentions signed,
but patch uses unsigned uint64_t, is that expected?

>       uint64_t attrs;
>       int32_t stride;
>       int addrsize, inputsize, outputsize;
> @@ -1733,7 +1733,7 @@ static bool get_phys_addr_lpae(CPUARMState *env, S1Translate *ptw,
>        * validation to do here.
>        */
>       if (inputsize < addrsize) {
> -        target_ulong top_bits = sextract64(address, inputsize,
> +        uint64_t top_bits = sextract64(address, inputsize,
>                                              addrsize - inputsize);
>           if (-top_bits != param.select) {
>               /* The gap between the two regions is a Translation fault */


