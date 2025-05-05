Return-Path: <kvm+bounces-45461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EFF3AA9CA2
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 21:29:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2ECF3A7CA8
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 19:29:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22A802701BA;
	Mon,  5 May 2025 19:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="I1btsTi8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5642557C
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 19:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746473353; cv=none; b=K1oe+R8/PAH8QoY3WRelM++UxV11D357tmT8ErhXbnAHC4bKAd/E50anYrHvKBCJtMNe6qNEUVMFcZRwZOVcPwJvYVVOYhyyUMwuNw3w3KPDWYRKdgx46/g01Vm3ihoCGPnBKO5H5uVbBrYLa3hcMrkNFCx3+cr26GK5iAyr/r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746473353; c=relaxed/simple;
	bh=wvg/sDk8aA/grGdAnqUQ3CVNz46px2FwSnD8T+KQQbs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kTR7xbSNRGBo6MAlfPkYp8zNsyRfLFprHS5R9duHBVyxXLIXojGPeCpyU71hvvlPSM5/o4aah4FSsvmvMtbAZ2JpOEBlAQb11Ta/6+a6aHyvGoNUZtv85mKXepyrqjjsoIPMlBQ7bnYqgIGb9ItgFf3kfJq9fOm1wt3NWk4hRH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=I1btsTi8; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-227d6b530d8so45176495ad.3
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 12:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746473350; x=1747078150; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yURQyFKz9afRJKAQgVl7CD65mRk3F+jUNJqazHFq1Y0=;
        b=I1btsTi8rrmzwZxZ2bQZe5qAwEPhT5K0Pf/sK6SA4qS5D/V1dJusO5dY8XcQEzq/0I
         6ntBAun7fNpgha9rhlDkeI1bcgWqHM3awOxLO2w3aTMK/QkSJ4Zc7JHkVvJzPj2n3CM1
         Ie8Du/GjoBEmhCSJQqKphPaFkS7jhyKOTK/Y/9He31IkmHMmDL0qgQMbAyAK6o7dv0AX
         2E5171/pbBoSerInsMgJso2ZJYgtL+WMQ+gNbLrOqsOTaHFfHb1VubqS5DeXT5PDcuPE
         zBQxJBXvQpbHzbmltzAtBNbITRUiwOu5kRiypsRP3UhOahNUSOpfYe7+pdi9mhhD7Lhb
         DRUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746473350; x=1747078150;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yURQyFKz9afRJKAQgVl7CD65mRk3F+jUNJqazHFq1Y0=;
        b=qRQV+nh5BniAMO/82DeLpkrenDRJa9EX6YysDnpxRNuCUetaQWB9GyZQ8ZrEUZnoT7
         yXwzBVrrrnVIGCePZBlkjV61INIxQpLKs06zgr/bHLP8QYJtPj3Aj0fPbUjRtmWCtcAH
         5E2PkfbI+QLGtgVONxq1daOlIcK3wblqxlwGOBOxLqJstnWpZs9rgqBFZcgLZ8b9I2z0
         b9dwAYRMV5OpzBX7csvU39PjlX7Z3CGlla/GOg/WuS4Oqx9/sUk158rlhFGOud5KPUDG
         Gw6GbZWiqp9i7hlSX6B0CysbZLf0vOg/G/gB0N3eQJIQaNDhwcp6nRriX+IlpyrkZMYc
         Raxw==
X-Forwarded-Encrypted: i=1; AJvYcCXHzqutlOc08wVIN2LpOLKQYC9y2uAlAsYbw0dboBVIoZs8MvILCOxu5fTRRv4NTLWIBq0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMozOA/mJNCRpDBe9dN2h4+WGUkNKQyffLD40Hz+6lmuxYRR+j
	lTqVtpbWTlyMtWb1hEluxQOSpBskSHZdpgzkRiNrp37X492/jLHOuEmbol+WD3o=
X-Gm-Gg: ASbGncsvKEsCCvuOIemZEofUL1BHCApoWs6jMGArj16Gc78dP6hnlBn2/8pnwHyuQug
	x4sAHZKlWz1ay+k+kYzXDd+Zae2QpSkhwKE9FplIjYsXPpLxWlri89OUiAeEZqsH/JCFJgBc2MW
	y9bkhztLKkS52oWQFBOKAmbib8CI9fLg624gAl5Lu9yMiIVlkHeWa1LhAI1/IrxfpGGXDZ6V/UM
	JIft8h1kHLEx3kj4QuawG3QPUsgKa7A9r2x38EMMkITOfnlXwSUY8nFZdOd0jYUVI5J0qiwwVnR
	6ClnnAM/+IGckZ4DQ0mnzP2dG8L84hsgOoHSj/adeed0njqxjsiD9Q==
X-Google-Smtp-Source: AGHT+IHXcnbWalst4/hE1ZfwwMw+XiyM0HwfWbIZImJe9tYnLocKvZ2N+wRJlZ8k0NpagIhi7EIV1w==
X-Received: by 2002:a17:902:d4c7:b0:223:5c77:7ef1 with SMTP id d9443c01a7336-22e102f33afmr235209025ad.21.1746473349941;
        Mon, 05 May 2025 12:29:09 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e151ebc54sm59439335ad.98.2025.05.05.12.29.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 12:29:09 -0700 (PDT)
Message-ID: <afbc803d-204d-4a99-b7ed-18101e6ff909@linaro.org>
Date: Mon, 5 May 2025 12:29:08 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 46/48] target/arm/tcg/tlb-insns: compile file twice
 (system, user)
Content-Language: en-US
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
 <20250505015223.3895275-47-pierrick.bouvier@linaro.org>
 <b381f802-9eb9-40ee-a7de-f3b5c49abfff@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <b381f802-9eb9-40ee-a7de-f3b5c49abfff@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/5/25 11:49 AM, Richard Henderson wrote:
> On 5/4/25 18:52, Pierrick Bouvier wrote:
>> aarch64 specific code is guarded by cpu_isar_feature(aa64*), so it's
>> safe to expose it.
>>
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> ---
>>    target/arm/tcg/tlb-insns.c | 7 -------
>>    target/arm/tcg/meson.build | 3 ++-
>>    2 files changed, 2 insertions(+), 8 deletions(-)
> 
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> 
> In an ideal world, this would only be included within the system build, since all tlb
> flushing insns are privileged.  However, it would appear helper.c needs more cleanup
> before that could happen.
>

I added the ifndef CONFIG_USER_ONLY around define_tlb_insn_regs(cpu) in 
helper.c, which allows to build this tlb-insns only for system.

> 
> r~


