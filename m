Return-Path: <kvm+bounces-45169-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FA5AAA6421
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 21:35:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B2A5A7B5B3F
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 19:34:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A4B820AF98;
	Thu,  1 May 2025 19:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bISvyFNk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD2818DB3D
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 19:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746128122; cv=none; b=TJfUxRr6XYGZ7r8SbEHVqdbLemMIJKztlW0jAQoQl2c/hEEJuZDY8o0JSbsRSeA7cLBB1Kw/KFKdJZz6ruDByd4wIYxY3QuNq2N7di66dAESd3LIfs5vSoCog3DyQ+9mC0LXif5Gvc5CLbVSIK1vzVtA9kAXALv4KtlYBS9C2KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746128122; c=relaxed/simple;
	bh=hSJPpZblxMqJzf2QI24cJaOdq0K4xJFiiCQVPyarlhU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VWV74dlD+JvhYC0smhxLTgIuRJEENX3Hkpa04vurERYODI3/U1Uj4L6znApV3wcDDeQaE4aKywGzKWk4wcxfQCwZCR02dKyYL97zhnyLs5PzMK4MnF/10jkLBzu5zcKFXEjXHIJtosnDdhteXex7U/sDo/sw/3ph9jULlgvZBlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bISvyFNk; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3d93c060279so4883485ab.3
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 12:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746128116; x=1746732916; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=doptPJHNTX3efdtdZHHQCZKFb5/ogmLoNZ91COmEnTY=;
        b=bISvyFNkPi983TIVY71EtFYDC2XppfRNvPNgqYvUTDBeidn5DWw9W8BnIlGLc6CBC4
         1G2C42O3x7gYEhY4qp2oOd/S25hnzsOFrx+PtW1sQzVrsveXG4UE59vPMkCjasYYNWIb
         CkTHy9+LWqCKooqhHxb+r9zxpuMpbYtlgWBO8ddIBSkvOQwVhiEnueSRFQxJCx8/vZiW
         YWZ4G/dJyDjuQRVoS99Ljpch0LvAbKcJT2I7Rx7I7o9T0LMFB7PXp4NSoynouTzBA2bZ
         DW/qY/44DN/mmL2C9UGKXd/cE7oDCiGSTwnchxLxf8WkgEDNi7abAMB54riaTmJG3MRm
         GCdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746128116; x=1746732916;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=doptPJHNTX3efdtdZHHQCZKFb5/ogmLoNZ91COmEnTY=;
        b=fUJxMpQyHZjC9upZi7EqJumeq+BwepTRhqoBhwXvB2EpgpjT98nAfgvJuzMMYSDzDl
         g2HLaKjgOW+mH8C4n64EVQMyNj53lGp13ydcFzpxXq7cAqMDSZmOAxNES+7532QLnsiO
         jJPu3zeiJBKrDv9vNzEfPlOVf/65hFIw6tm4os2YqtlwAGZl9ioKfQx21kMJhQAt0E+2
         a8zLOBd4OIlDBBcgjTgacpSjZo58UDXR5zi8J48PJjrvy44RAKQt4DcAmKvi23FgUHtQ
         ysY8uw5PcrlEPMDmfr/f3Q1XedyLla3rTa5XKQLuQ7xhPKQHzFQBbQ/jpx8HnWAtFX6t
         8TKA==
X-Forwarded-Encrypted: i=1; AJvYcCV8dgHq6PH4TaS11yoEnxmZPHAbPqiB3BB9QI7gNrZZYDfAR51YEU2VB8eCjPHnaNbEfMk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyciw+cDAQJDQAYPl7o2aVbaO3hu/f828FDPgjDtCR4H1JXcSWb
	2+zIghAAgf97psSCx62QiUc5K4KIjw7NHWypsrso3femHz3TLAxp/+6sc2y9Jds=
X-Gm-Gg: ASbGncuMJZxVbYFHZIxT9ee9iP+a4khSoXvuaCJgA7M0kHTr4WAFtZ3vpUGsfPx39qI
	KBEBmjswPsYW0fcwoAtLrPovqI4g3GocKb50JMGWc6jcDZIahvnd21OweeYtxFFOBCKRWYcbPI8
	vBroSjxnwYnbbRtaAQvG3BDwtwyybqjQDloJ7vc1xuszoSLiAXD7SeJBcxCXYZAGzmsctOQI4WW
	5ry8pRuI9HCnnWTqnvj26xQC4s+7dl0mS5dxB51i7H0ErLk3CpqVn9MLKx9aG1rFpCJmCGAT6Gu
	DPcQVFB7tOEiiE5SOT3YWaqKeADIOhxzAWIcGAY94+mwxpWSwic7LLnNlRaGRWha/iXeWfNL8+N
	+lKe37IhV4WpFHw==
X-Google-Smtp-Source: AGHT+IEsLtLhUNgdAp+p0rJEpvTqY2CYZqSy/735WowJEunJNXpSHddb1hTwFvyRnYt3F+iH6gsyCw==
X-Received: by 2002:a05:6e02:1b03:b0:3d5:7f32:8d24 with SMTP id e9e14a558f8ab-3d97c2272c5mr2037515ab.15.1746128116614;
        Thu, 01 May 2025 12:35:16 -0700 (PDT)
Received: from [192.168.69.244] (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f88aa959f9sm9995173.130.2025.05.01.12.35.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 12:35:16 -0700 (PDT)
Message-ID: <21d32a4f-8954-4a36-ba0d-6cb7a50f242d@linaro.org>
Date: Thu, 1 May 2025 21:35:13 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 29/33] target/arm/ptw: replace target_ulong with
 uint64_t
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org,
 Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng, kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-30-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250501062344.2526061-30-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/5/25 08:23, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/ptw.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/target/arm/ptw.c b/target/arm/ptw.c
> index d0a53d0987f..424d1b54275 100644
> --- a/target/arm/ptw.c
> +++ b/target/arm/ptw.c
> @@ -1660,7 +1660,7 @@ static bool get_phys_addr_lpae(CPUARMState *env, S1Translate *ptw,
>       uint64_t ttbr;
>       hwaddr descaddr, indexmask, indexmask_grainsize;
>       uint32_t tableattrs;
> -    target_ulong page_size;
> +    uint64_t page_size;

Alternatively size_t.

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

Maybe use int64_t for signed? Anyway, pre-existing, so:

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>

>           if (-top_bits != param.select) {
>               /* The gap between the two regions is a Translation fault */


