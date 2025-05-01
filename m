Return-Path: <kvm+bounces-45107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B5AFAA607A
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 17:07:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11CC19C2B09
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:07:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 141C8202C52;
	Thu,  1 May 2025 15:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Z87RIECY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB4F1F2382
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 15:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746112046; cv=none; b=asjpg3KipSRyLZw/tj0+xhkYq9l+QWHG2Tr8pivdJJOskkR2mlR9QeDg7MX0g4Y28g1DY0idMOmFUoTZp+Os+ie8GmpkKurR8JH1mvzMiUvQAjEwiJPAjZKczTLmPX2Eo1eH3DCdtlnJikQQ1UWOnxBw0ccuHWJLPE2LnHlv5y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746112046; c=relaxed/simple;
	bh=XTb96yZrQ+kuJISC7JzhoG6yRu9Ypz+aA9nf/qQNm7A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Em1/tn+JWSMvmqZ18GsKjI9eTYy5Dx1QwENW9fGQeXyWo950ghtLSBb4uCLqIjUOGP9pJkAp4HO1oZoqbL39zXj3YLIBK/MIL7WKnUyypEXUtGOcBRBNuOccoz0luBTpqYWaxC5Fv95mSOzlViosVQozR2AEovj+UgZ2Tsn2CUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Z87RIECY; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-736aa9d0f2aso1550242b3a.0
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 08:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746112044; x=1746716844; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XClG0j609Ch/oadVNHfG3f0UoE0M/4F3xd1IWkCnl1s=;
        b=Z87RIECYfxy756FsEWdh2wEH+Rmz/GSVjIZaQ0gV8oc0sKoJBt8rhubHCfynrUVxUj
         mB44kdqrSKr2P4P701bslJSh9B0U7I8dawOsPEYMkka3M7eQcNuybf5ylxUnp3/4Rsi9
         qslquUslYMDOCxKmReKdkpDfvl5Hy7MQpl0EQm9eihgj9QfvuU7ynNalMFHpYSwcqQkI
         RAJrYZphoFfe8uEqMw6Z0IUKzzNN+PNYMjoiBMtoLJitGjozPsz1ugX3qtfZO49ut0U+
         i4SK7jt99ezyvNn9HalwuYgEPsE/Vkz1SiX0Y43LQWm1dFZL3pDzR7kzD+UsdSq+O8n4
         YIbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746112044; x=1746716844;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XClG0j609Ch/oadVNHfG3f0UoE0M/4F3xd1IWkCnl1s=;
        b=CIlgccW/kLesD8YeufISVS2SqmRs5Bh79XDen+qdIgQ8MjSW2wydeeHRCVfJDEDEW0
         /J/eaw+no1jRBp+biCWm5PEwG3XfCsOt68RJUlcTZ8QLpdBBgdDhX7sGQ4gZPs8k4TqN
         kbuyzjOhFfO+S6pO1SbYl3Ozjw3bHsWkCnCWC7ej+zPV+wlHCTB3pPp3rfFmP3GUlbqC
         2HIS/5RgB/qUaDjUMpJJAAZy0DBDlTrAieL+hmZYdDBhRzUWDGfjoB7EgwMiJnwtKutU
         0AwgfwVmY71YbySZEzR7nUDEf6+1/1MQL4QghZdnxsDWG055aAlKuIkj5Et1nN2aJOxK
         klYg==
X-Forwarded-Encrypted: i=1; AJvYcCWQBMBqd8caOn+lqUmeGqCZ8+Jqw+UnqFQU1e2tFD5SsTqewMoVtH19a5yZGfOZj4lgWeE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5eO1N38Grgol1Tmn7mwM2LJaK8Uz4TgXCDSeGYdPB/4X/mq2t
	Wyrv/b+FhK67FzqwV1GlnrC0a7pq0U/H+p9jNfOVFbLvA8dbuDzMofBC4gVqOOs=
X-Gm-Gg: ASbGncuc8vcYsrLJpwoU8eZn21iizPxdy43XBs0dG3UP6FLDvjOe1MDPuyLjN0CTtx+
	7so8j7HsQg2hCphICzYFbLH+5Gu4qjsFIPw0yw8JTwmraQ2yQs4qDAARL5sq4y19qvyD9KrxEsU
	6T1jDHfgANuB2pryaT2ceaYKJ7bEAQYhRUUmRboYFNtdPsU+1EucSnJoeBjejkfe/D1PetUwr7y
	ZrIsxjtXMU8AbBjhPV9g/Mh5p3mpdopiut+b391mST3QPkGXPg4H7/5ZKUylpLOcHv6C8WXc3F8
	bWVfFJgSDBi+gZLTJmT2nEZJjL9e75joZwjwlfp3IzDvnb9np85tB9XxeFhIfxn670E2H5gG1eh
	NIHNJGzikcUJ/hq2OtQ==
X-Google-Smtp-Source: AGHT+IEhCJO2/YFE9tld0EaF8WnZ+0c1QN8mVDJtPzIdzFiUIxr07ToxwDiFnRR3//WFYEWpPhHmuw==
X-Received: by 2002:a05:6a00:3a09:b0:736:3e50:bfec with SMTP id d2e1a72fcca58-7404777ecd5mr5240803b3a.8.1746112044099;
        Thu, 01 May 2025 08:07:24 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404e5a6fa2sm929983b3a.0.2025.05.01.08.07.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 08:07:23 -0700 (PDT)
Message-ID: <3fd9ef2a-c6eb-4d08-93a2-4eed78cacaa4@linaro.org>
Date: Thu, 1 May 2025 08:07:22 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 15/33] target/arm/helper: extract common helpers
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-16-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250501062344.2526061-16-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 23:23, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   target/arm/helper.h     | 1152 +-------------------------------------
>   target/arm/tcg/helper.h | 1153 +++++++++++++++++++++++++++++++++++++++
>   2 files changed, 1155 insertions(+), 1150 deletions(-)
>   create mode 100644 target/arm/tcg/helper.h

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

