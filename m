Return-Path: <kvm+bounces-46323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C1DBAAB5128
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 12:10:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F049D3BEDFE
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 10:08:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB03A23D29F;
	Tue, 13 May 2025 10:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iZvhxYwS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E4823C4F5
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 10:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747130797; cv=none; b=u/jDMXasv3p3QjlaRTL/7xl7QsdXRGb/1CrgIRrlwanNogKxIdikck83DbJuBspFp/20nZF3CkVCW/S5qzss4ujSqZKGGZKeZ3du1Nkt3YBG6gPoC5JqYFkWp9aUbtjNVCJfbqcKenrmihdEFD3vgsnmCpiibC6Y2pCf/zFFkms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747130797; c=relaxed/simple;
	bh=GgDw17/UV9K3dt+gDXgN0Xtyl4Bjy11aGH/SumRNbrA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dZggkNhkW46SNqVASSzu3UA1fp4PDOphdqkCCNAWAG23RMp0d4R9Z0cG3HRmA/SknRR38/iddU3rH0T2/s/0CZ+8q9JcaVhUxUQmYMGfLPpSkyh3MkDt2M7M5UEyy4Nsi+pdrU8yxyJfEjlMlITbfHE52Rkd6muYANJlW/iHwIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iZvhxYwS; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-441c99459e9so36489375e9.3
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 03:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747130793; x=1747735593; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J4FOJ3+jCdkOTdzBlJQDGCZ0Aj6URs9ripel+V7MJhs=;
        b=iZvhxYwSCgVT8/BErfWU+2zajiztrnbhUx0HQg32nuDGoPDAMGPeZj9HTRn31CwhE3
         3zNJJTW1bOPk3nlZh4MX8N+LiGSrEKrrFZEngxz8Eq5EZ7UFMbNS5cVCuWXq7vGQfDlN
         NPK3zPyVquCIhSzZnHTnZ4AXtQo1J3ssSQwZqW7u3u0Tec6oCHNmutDgDHjXpnCeKN3f
         /BWd54Dgt5Vvol6tdP0a9omIrPqoZrOJW/XO/ZkLN5AztRoHCIFofzVbXCn7IKRTaFAh
         8miUAnW/XjSmg2SOUNWryg1lFz5zPsH5518Zc03XO0iKO0qUPCBMkzGZ6Woff31dvTPj
         PIng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747130793; x=1747735593;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J4FOJ3+jCdkOTdzBlJQDGCZ0Aj6URs9ripel+V7MJhs=;
        b=f/H1I+z2Xofu8jNmZ6LEXj/LC6DCFtyxsPecjIQaCWKgXIh9zB8NBFozLGUgg9d82h
         K6oJeqIyqHFJQdCD+jcA5Y9xEAO4iir8t+C+WV/V26MgGHcyNuOUkmeV4bbPkfv2SQiA
         n848LSOf6xTo+nsZIizA8gap2XPzn/Wt1TldbkPzO8yXymVkNwX/gfDqXzOi5f4mDSRN
         LKRz/bays1e0yWTXUBzcLxc87MMgx53rb63Vy/hPliNhzsignM9+en8R26+ztYtgheWj
         6L+n2f95j3gcgMtLsQ4RQ3s2Vny7owQqTMjNyRTxcfMgDDT7k0CCYMPwNUIkMk8pfVID
         Rj6g==
X-Gm-Message-State: AOJu0Yy7QDsgNKlktFFGcwa10ZqXDBOFXzRkJk+tKrBtOJT1leVxpe99
	MkpQCVQNW5Hpvys6/xCa4BsxjgIeE04bQTioKVyEycxa8oQiWoVrte0nS55+Iqc=
X-Gm-Gg: ASbGncuzaoN6OsdcYXcJBBVkCM9XOhqeHmpjsEZ9jv6/UoOemYhPlqziOWgeGduMpD4
	wxCm8XSafnCj3alinAN7f/OCB+3Ag2N6deDgra2cXsMwRM8clXeMNuONLzCf0oAeXh16e5k9/9h
	4V/pqHjPHq7Wg9ryllVjrfa09Doenxf21n9+84UPjJhbyvEdXen7XkstWFklj6AucoBA7K9MmJD
	stZucHdlaWpN2ikHbWn7GAGkUyZc2jyVxixHhfBq/wN2UdvzqB1PDZ61JzQmbnQIEmngmnhEMmX
	Yeq5c8HjdSjzigJZarJoCPcJZ0GuEdrD2sV9lQfxiOEoYlKZLbyhhBhEKF7livGQuhgzsRwd5C6
	mR011okVtOqRb5Eg2YQ==
X-Google-Smtp-Source: AGHT+IFHLrSF9XA++jfCq5+p5aY1/NBqp7sUwHhhZmRH0EhB15YL0OESBl1s/DFkWQ+4RjFm1GwXZQ==
X-Received: by 2002:a05:6000:401e:b0:390:f9d0:5e3 with SMTP id ffacd0b85a97d-3a1f6429791mr13293184f8f.1.1747130793581;
        Tue, 13 May 2025 03:06:33 -0700 (PDT)
Received: from [10.61.1.197] (110.8.30.213.rev.vodafone.pt. [213.30.8.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f5a4d0dbsm15346027f8f.88.2025.05.13.03.06.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 03:06:33 -0700 (PDT)
Message-ID: <e5c421d4-2e8a-440f-ab1c-87aa642f529b@linaro.org>
Date: Tue, 13 May 2025 11:06:32 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 22/48] target/arm/helper: remove remaining
 TARGET_AARCH64
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, alex.bennee@linaro.org, anjo@rev.ng,
 qemu-arm@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
 <20250512180502.2395029-23-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <20250512180502.2395029-23-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/5/25 20:04, Pierrick Bouvier wrote:
> They were hiding aarch64_sve_narrow_vq and aarch64_sve_change_el, which
> we can expose safely.
> 
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/helper.c | 9 +--------
>   1 file changed, 1 insertion(+), 8 deletions(-)

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>


