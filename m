Return-Path: <kvm+bounces-45449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 32AC0AA9BED
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 20:50:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 25FF31A80D50
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 18:50:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF2E826B959;
	Mon,  5 May 2025 18:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oHC11OSZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7239E269AFD
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 18:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746471001; cv=none; b=Qxcg5oKf9vKFVlf7KcPYYlW+yKvYM30Hmn175VpWa+BjHuF7fmcmuqhUoeiR5P5c3sWghwMnWAh+n0AA3hNexi4DMUheAT9qeK9J4BiiPWSsiDEZB3Zgg1aJEXKb7nTMVuR5j7ox5npsyblZNCxPD30RXpTgWlckOPnxzHYhFvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746471001; c=relaxed/simple;
	bh=cxwubSeG6SSV6JCeg2zCkK8HIfV6u7+1QriGgRzXpsE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b5yZfmAWveiDdgIUGvn2iFag9c5yPpidU97GHxMVUedSLqBztaHHxPvpLK59luklKRjOaDjOQWXCwS8VHgcxw0FaJ/IVYXs+09GeqxzL0zwevk4srQCFX91soYUJrSV8qIQEqzQWTiSbTpVtbE0n9KMyVdj1Q5Pu86ErQdtDnSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oHC11OSZ; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-22928d629faso45051635ad.3
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 11:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746470998; x=1747075798; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ta9jvo3AKEZuDVgunvRvdzr3ATvRL4CLel6LqcL2wrI=;
        b=oHC11OSZHA5U9g7KfjmqcMUWhG1o+M9AvAtFuc+2mN4cgq/AGiDlhHhr6+CbXK7PFR
         2kqihCC1yXPS9cuTwPzw4XaC/kVbfEFRUaAHt+nmion9+2x4Iro8BA5zN2/OX3tSIXYI
         u2Rns0OglowpqJ4gFU+aDu1CUIJBiOalikUxho493WX5sZbNo+Bf2/8YZy5LfNChzfif
         LU7KbfI9yhy4DYbPwlSfrAorgeGTOpcYvucQvUI34CjyEaXztdhnvRIufDwjqGpPYQIl
         IgU0xiSqbfJcFJpk9cwahHDbTA7/KZ0Ywrc50bK0/yMws2qdmhdI4CqXNqLqkl4bM+Xo
         yDog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746470998; x=1747075798;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ta9jvo3AKEZuDVgunvRvdzr3ATvRL4CLel6LqcL2wrI=;
        b=uRinhdWFZCe2xqRe9TNQsefytPsa2jWKsmL37JymyhQbHtuXcb3Hu3IOvN7IHNR10m
         hI7sm1THzrXrPKoImnX+oOoZWURyi4k226VWXHS93WAEN1mfb1Sl6//t76+g8MZTHql1
         lUmxYOQnStmL1IsPpUc1+vIqLOmch+fDj00DqkAzgG0HmXoI7qY65GPqxcg/j2ecayrT
         YvJgjHWvtQHUuPd9egyq0Tiw0Oii6RDg+rTf2pV4R/JBnSo83wOl+gFwYLeNqc2ZXASb
         jusB649MAKKWzLwyyCcoEPqOcdmu8sL+ZkwSpTmFg+U11CDAkXPi/PviPv/+ePnr7sOV
         Gqpw==
X-Forwarded-Encrypted: i=1; AJvYcCW1nJZOCj7UXeu7rjUii6TkJX7PhS0fg1zmx4ycYTap/PwUoSHY5EMUqYVP1ZYhFVgQqrY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIQRIVkVqh3d/9NH4Y9T1+MasykXhXE98zH/IRZhamFQdk0xyQ
	/xXDyQpdo9dFz3FEsyoDX8zUVsPENWaafceMUqkBXleeneL6/gaY/CsGWKCfMn4=
X-Gm-Gg: ASbGncuGPPj/j8LDP2U1ccNFv/akj7s0XXG9YBcnMDI0rOjmQj2ugiaEel+HQF6AQh5
	f+dXnYyKDOBqOFiMCd8u9OGf+U8EmBrApeWSzr0VT6CSUgGyr/Zt/WkdUHlGVlAPdIpqHRXuqWz
	QJBDTxM1MkQUxIHP96VOSWSRNzstiMUTCLT+dN14WBkjckMCrAqv106hkDUkVCdhCJ9NJAW58En
	aDheYKGdp95G4lfarqGmlbjO0gHrM6kk8bSAcim7+2cYnox0pItr6saFSuPe3pcuWUlA7WSFPoK
	BI9R0BgfaN0+mW5ugxwPigUluxY9Qe5HcaVIezFtNkld12QZ58ZxiEp/1QLVu4JdBduny+vKP+U
	FxWkhqmM=
X-Google-Smtp-Source: AGHT+IGwaWwoaIh0UAcV4KiVMS3oBhW2UNucgbSD7FkDN5CheSLqg7kcicpiYhK/ibBbWx3Qh9MTeA==
X-Received: by 2002:a17:902:f543:b0:224:2a6d:55ae with SMTP id d9443c01a7336-22e1eac1872mr152998795ad.48.1746470998678;
        Mon, 05 May 2025 11:49:58 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e15228bbesm58347355ad.164.2025.05.05.11.49.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 May 2025 11:49:58 -0700 (PDT)
Message-ID: <b381f802-9eb9-40ee-a7de-f3b5c49abfff@linaro.org>
Date: Mon, 5 May 2025 11:49:56 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 46/48] target/arm/tcg/tlb-insns: compile file twice
 (system, user)
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
 <20250505015223.3895275-47-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250505015223.3895275-47-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/4/25 18:52, Pierrick Bouvier wrote:
> aarch64 specific code is guarded by cpu_isar_feature(aa64*), so it's
> safe to expose it.
> 
> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> ---
>   target/arm/tcg/tlb-insns.c | 7 -------
>   target/arm/tcg/meson.build | 3 ++-
>   2 files changed, 2 insertions(+), 8 deletions(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

In an ideal world, this would only be included within the system build, since all tlb 
flushing insns are privileged.  However, it would appear helper.c needs more cleanup 
before that could happen.


r~

