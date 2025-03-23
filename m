Return-Path: <kvm+bounces-41773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D651A6D0E3
	for <lists+kvm@lfdr.de>; Sun, 23 Mar 2025 20:48:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A867616ECB6
	for <lists+kvm@lfdr.de>; Sun, 23 Mar 2025 19:48:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1640198845;
	Sun, 23 Mar 2025 19:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jnrXPS7Y"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAA92D7BF
	for <kvm@vger.kernel.org>; Sun, 23 Mar 2025 19:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742759299; cv=none; b=kUdSZ64vwBg0tLvq5HLIff4s98E799tiJYMjdWI5kS2tEvqdng5TYyhhhh7plPkysNvinZhuarwF85CuYfORhm+ggRrqp9AmE/U2BQEltzwTqB64MeWrffsiGsR8Vgn9dC3OozllS49am1okc9yskD/fIeBMKW6sF1hLsFERgAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742759299; c=relaxed/simple;
	bh=+oyKntQ+QbTyCLXXUb6dNV4YfhJXfyXmxep2c1kYAPE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n3gT2DU7WszFFkPVjaZlcF1FwjxQM4IqF/4lOJ63h8cKMSQ6yVYagPTAyvsstkV0z1VmSh7iBZlRP35U7bW3VlVHlgFef/Qbqj7Y+jCtSF0EyaSiOjK6dEHlWHP0GIS85YXKTXVTz7Mf38XcM5QsH4sz7fl3iBszESN08iaK+aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jnrXPS7Y; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-227aaa82fafso10235715ad.2
        for <kvm@vger.kernel.org>; Sun, 23 Mar 2025 12:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742759295; x=1743364095; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sPEVhKH/q/YiDuR1n0MgtydSqyeu2nSJ5etPmOtkAlg=;
        b=jnrXPS7YtxyH9r+mkwtgq7vA773339P0D7dmiMh6eWKRL2Ejwvzqx7l4/H13+Mt9UM
         qMO309iwXhwMh5VOu7KMLbh+x53yjgljffuXlAmbXsUMEIDxu1VWe8iIDdxjwEU9p5Sk
         xso/ERO3H1fGSfyMNEgMjfcRaQoTRkX2vJjp9twlXNalQScFw5cjNWXQkxy/mRb4I+9v
         QhfWq4tlF9Nffwfvy6Q6WxcKRJpt7dF9RyCNH59O+VI+xyV/EHR3T/6oN3yAQg/x6DGm
         66mMfg0/BlL4IRT1bQ3tUSIm4V5dh2MSTpk4dat0Zc/UH64LDI4o/GIHHUgG/gF0nW3+
         bdsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742759295; x=1743364095;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sPEVhKH/q/YiDuR1n0MgtydSqyeu2nSJ5etPmOtkAlg=;
        b=V+KBbLBlNpxoIPcJ7y9k6S+o8HmvkxisBQD3+qbbjEZ4mIZBVcQ/yz1+lBcmEch6i1
         HpG2utOe/annqy32nR/RXXasV/2wrPaLmOy/sIsdHmdt+cQVOuVz3LNPYisGm80NPk5O
         JqGuxT63i0eMeOQxIVNiBlqdNS+n2hnbwbj78MRDgxs67wo+ohdpP+qI+zAL/7fKz79b
         LYe0HOPdFpJErQh+eYXailGfBhQFksS+Miom6NLO4nXma3JRZDXJLH2XYN5LxAcdyf1q
         ZNY1GusYytNVIbNx+IRPKALZgM7bG3HrmX+cz2RP2afOUIkSSzl6nGf5iWI7d6cpT8kU
         sPhw==
X-Gm-Message-State: AOJu0Yz7Yj3CM9MZKgO9q4+HXeZC8oeaU1f7/XiKi9iXpi/qYHkSFAYs
	EYJrtSCi3MHLofzACdhiyF5jfA11t+AqqnJ/Y/oQtyr/wFoyvJ+JzRKM9RbI/t8=
X-Gm-Gg: ASbGncuauDgvdYzavo2vrRmJomQ5aaRWhcU36CScdhI2f475117/BM4x5dG+BpGTjOH
	wp1NqPNnS/hPvzwP0+hIkq5Thj2JO2KMYe8ktJtX6RNXtVUdqCGRJex8bPdU6KyzXF8R5sHrVlF
	S1a4NNCihrfB5ayOxSI2hJeYdOe5N3EDqABAjHHMhvyuy/QM0xYX/mDbD0o4krzBFDLa4hA9YSV
	w3T7nYtN/Rr2JD7rbZKtRjRDFKhlKnqQPOL//F3E8G4RfudlDur16RuP5Rf9mAyYlzK1yJgsMXE
	8ad8mmmOytx5GMJWD/IZL1u6Q/KCI8u9mLqh3aDy4mfJgseHTz/jGq6R271O8M+AEda92FQPsq2
	chkO2Zsdw
X-Google-Smtp-Source: AGHT+IGS/XGShXsVnp9yePf8yBN/4F6cSRZ2vjCDtT3evXQqeQKUz31RxiGg0cYlDNvMmndLkLVSVw==
X-Received: by 2002:a05:6a20:430d:b0:1f5:8d8f:27aa with SMTP id adf61e73a8af0-1fe42f08eb7mr16397454637.8.1742759294672;
        Sun, 23 Mar 2025 12:48:14 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af8a2a25dfcsm5566435a12.58.2025.03.23.12.48.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Mar 2025 12:48:14 -0700 (PDT)
Message-ID: <0c9055a3-2650-4802-a28c-e5d79052bc81@linaro.org>
Date: Sun, 23 Mar 2025 12:48:11 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 26/30] hw/arm/armv7m: prepare compilation unit to be
 common
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-27-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250320223002.2915728-27-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/25 15:29, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   hw/arm/armv7m.c | 12 ++++++++----
>   1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/hw/arm/armv7m.c b/hw/arm/armv7m.c
> index 98a69846119..c367c2dcb99 100644
> --- a/hw/arm/armv7m.c
> +++ b/hw/arm/armv7m.c
> @@ -139,8 +139,9 @@ static MemTxResult v7m_sysreg_ns_write(void *opaque, hwaddr addr,
>       if (attrs.secure) {
>           /* S accesses to the alias act like NS accesses to the real region */
>           attrs.secure = 0;
> +        MemOp end = target_words_bigendian() ? MO_BE : MO_LE;
>           return memory_region_dispatch_write(mr, addr, value,
> -                                            size_memop(size) | MO_TE, attrs);
> +                                            size_memop(size) | end, attrs);

target_words_bigendian() is always false for arm system mode.
Just s/TE/LE/.


r~

