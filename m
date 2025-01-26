Return-Path: <kvm+bounces-36620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 33BF2A1CE40
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 20:56:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E2FB165DDD
	for <lists+kvm@lfdr.de>; Sun, 26 Jan 2025 19:56:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5831517C21C;
	Sun, 26 Jan 2025 19:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KlndNu1f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11870156C74
	for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 19:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737921377; cv=none; b=rarC/upfAvS4qnPMhO1cQN1BFGWyprrxXlXJQ1AAmyeqEn/o4K+2WJlPxWEbkFqxyS9hJpoCwtMsb+tu5fXudPskM6hZTvl4pO2oNgtqn1Cqf5YSWWMF8JsmPzBm4vzOwO64vsYexwkJTtrQ4u0/I0o+MA1dd7/Q2Qm3ECmBkaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737921377; c=relaxed/simple;
	bh=R3uxaNQHW3+H7eLa3b0RvKCJyszFgh9qZkagaz+1Tpw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nrxnb7NRATwvEBVMnVANdA/DVy5D6oGGH/8LpHYI3OI9l6UevAmMFW0xwVZwp6SFozmtl/OUuSBQwp+r1wEtDh0CWq2xDpOF18/oq6fg7VH0A1NceJDLKr0nPBZcdbUCls6vc3urQwA/7Wrgb5Tn5KmnJOGAOqCUIVs57kfMo7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KlndNu1f; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-21634338cfdso87814005ad.2
        for <kvm@vger.kernel.org>; Sun, 26 Jan 2025 11:56:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737921375; x=1738526175; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oZaiNxyRumKDQ6iU0NUlyhjPpWDJhbWYeJfxDmaXxDo=;
        b=KlndNu1ftdnpNGPoN4HNyLmv/ymDt5EECJD8DQm4/oGErs5vbUq4fm+/Z9OYMk0kvP
         UeaueEhL4zmEvfUjdAHpcsoUxVDqUBjWfJSwOHtXmGbCzcrLRRm5ePIhv7vLoihlkf3y
         FPHFmbGg4VpouYZt8PqXJ4GFsvIH2lcnNUzQCSkzmsdfNGDo4rUYS/YeLuKYJoVx24AT
         73lI4xvEgNguscUK52WyWjtULBo2yI1csqELX9tUa6xnfahsp2A9bW1Gq7pCeE1BAT7x
         O9/4E3OgQbhqHKfZ4hvBJYWX6K52SpIaL3/CuTZAFqAHZRnyrvFmZ7rys1pO3mxKkGDw
         ndpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737921375; x=1738526175;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oZaiNxyRumKDQ6iU0NUlyhjPpWDJhbWYeJfxDmaXxDo=;
        b=NjiAi2lBC4Orcs1P5ox1a23FvaEzNBR+ir1VFmP3NdvWHNLXjO/c/EpVloR6LcBEOq
         rBwmKuWFnpbRl+ZSu9plB9Qfa7bEAtnpYQJUxjWETdNB029CVF3yBWiD0chNF4QqWnig
         99yNNVckKsY0Z2RmZiiKf9cyAqLF0hlta77dDXEQTfAEppTJHATmR1M6ASDEbgPVWK4k
         g8SBlvLOCx+oQOqWozCV5Cx1BboVzKspWLq9BkD9HOQdc+mSBDQbErYwjdRtTPewPHeF
         ZdHGRi9LSI9znbxm3gs/5C+1GPB26y/B/Hqi28hEOWpQX7vqKjkPi3alLH55iyJXhBHb
         YwrA==
X-Forwarded-Encrypted: i=1; AJvYcCWSPUBh/Lj8rOgENLw4x2rBvFhdalPomNy0xX8V4MJgFdSHm0vyhL3vRF0v/nQ9ItF4tCY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFqCIzgVWSZa+wxlhizvUIvyFmzd/1tzPaNUK/dILYQnudDmdQ
	i35eONqUo97B0gXzuH/odKXRxiMSfLwD2dgnUKkgT3MeXySASmRvTjyEK3Z0XUc=
X-Gm-Gg: ASbGncuMPH+5nOcC90qVcs4bmXKT3IEueJ/SG9a5oaZ5i+QHT0HjcBhH265gepvhqux
	NuziBYds1feRciB8nPGlnfn9LnI7188DIya7fMd0769JuDzra/bkkYqTZb/o6h8TUHy6q24uk6X
	t9P7R3PLuFIB/y/DpDDiOwoB+fljecbQpPEW4pARoju0884+2o96vYqtzCe95cLxVGSpq0dC0KE
	GCTtzhaanLDvZ552OYaDHHG3uTuiiyvB6PHzZ2+Hkx+y5RKdaCMGTjCllhRPdhpJFyDakLtGVux
	R5ELFPEJn+oucVhcLGe1cgxUon8KLxiTCIE6hRqi+JgodbU=
X-Google-Smtp-Source: AGHT+IHO4WMUbjm+0GYB5uvcZM2pATyJHyNJ2uKrCdmerCTV19qq9YWTnaUhr9U9sZ/t561e+9mUEA==
X-Received: by 2002:a17:902:e746:b0:215:97c5:52b4 with SMTP id d9443c01a7336-21c35631dd4mr526655615ad.39.1737921375406;
        Sun, 26 Jan 2025 11:56:15 -0800 (PST)
Received: from [192.168.0.4] (174-21-71-127.tukw.qwest.net. [174.21.71.127])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da424ef28sm48976545ad.258.2025.01.26.11.56.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2025 11:56:14 -0800 (PST)
Message-ID: <51770df2-ecbb-47b9-b5c5-a60decf0f751@linaro.org>
Date: Sun, 26 Jan 2025 11:56:12 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/20] gdbstub: Check for TCG before calling tb_flush()
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 Igor Mammedov <imammedo@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
 qemu-riscv@nongnu.org, David Hildenbrand <david@redhat.com>,
 qemu-s390x@nongnu.org, xen-devel@lists.xenproject.org
References: <20250123234415.59850-1-philmd@linaro.org>
 <20250123234415.59850-4-philmd@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250123234415.59850-4-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/23/25 15:43, Philippe Mathieu-Daudé wrote:
> Use the tcg_enabled() check so the compiler can elide
> the call when TCG isn't available, allowing to remove
> the tb_flush() stub.
> 
> Signed-off-by: Philippe Mathieu-Daudé<philmd@linaro.org>
> ---
>   accel/stubs/tcg-stub.c | 4 ----
>   gdbstub/system.c       | 5 ++++-
>   2 files changed, 4 insertions(+), 5 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

