Return-Path: <kvm+bounces-45337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B638FAA87A8
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 18:10:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2B99176432
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 16:10:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C12E51DDC1B;
	Sun,  4 May 2025 16:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ayZu4WUP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533DF4A24
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 16:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746375044; cv=none; b=dsiRXxs5FuRmGOirvWNFmoVvXkETZzdc2nL+raBfAn1GJEUo5A4VLjnxfAHXo48+JcTvGsfajglEP1VfhRqHsyZVYJkXWhNsZV6WCMBOAM1URDjfsOnRBuypb22/qVL1tQ/64H50id8d7Yjfk3kFYIMoO6ZeBiYynu89gSYwKbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746375044; c=relaxed/simple;
	bh=YWtnTRKTLVoJEn9G5Cm2G3hhOO33Ojm1WBHEIIwRWhY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eObznq88Dy7fnHrwI+kdTHZZ7Ol6+H06pYELOtz462pqbhR7I8hOaGFQUBAPvM5QEHGAjD6FM6TDU3HlxwnYfB5aaR25C6pxiznRVkG8HWdZ03x6l07QPVy3FQgpP63An0xpj2ublglPv2WYOTbdngXCWxgbjw09VUw+lvfedA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ayZu4WUP; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7370a2d1981so2967206b3a.2
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 09:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746375042; x=1746979842; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+FZX6BzeDziVYSdULWMnyjCncL0tE+7MUysxymXwBwQ=;
        b=ayZu4WUPW+GMsiuIO6+GxFN8VtJ/bRJtV0ptjy/e7WiEu7hnwQu+tsFAOv/M6oIRpH
         AP6C1fYegHz3UdarxOwbuMuLW0HuYMWBPaAlkYFJfWH3uPqQzwm933uu863s9DMexbnA
         Q/cHSB0laquSitXh8Noc7tuNqV8UvM+tF/BqYx2wo/7Z4+nSo57vlb0pSEWasovSPoOR
         15qjg1O471IEuO5l8sv6HVhf7iNkDqsUN/sPq0xn+br1uO2AGYBqRLDW0t1YmKLL6NtW
         yqgyZNLmX9ZLtmdwPXxTN6ZdeHjNIxSg1HyHBkKulOn5K1u60Oq3A9lNNY+OU+89ZlWJ
         ZlVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746375042; x=1746979842;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+FZX6BzeDziVYSdULWMnyjCncL0tE+7MUysxymXwBwQ=;
        b=mMtAbz6Xlx47vkuj4+AUGNlBDrIbyPHyqU0FRh6viVZH5wmgh5sNTwflGiuJC3X2SC
         pry1rE76OJRdUO3rIS93fKvTKO7EChdOiw138ita4xlqjwUaMk7gEdFAVfPevlXMl6zy
         0MguWwnmmTuz7/St39wwIDEQ7FSz2TN3e5Q5SzIZxqjiXcQV9DjIuzeyzHml5yZr1xe6
         79dQ4woqYZjL404m3dGG4SegC1UvmW2EePmVFEboDmh5FZvBv38mUYivQ/2+j3rqG313
         k7GVsfXeNENUoR5FA1N7nuP21nK1CXgpOc+WmENNsaP6IsjQP68zN9ly6OaUcSaGkLqb
         fJRA==
X-Forwarded-Encrypted: i=1; AJvYcCU5KECUgDvZH4GBGhEnhjHX6/l1QsILmWzHLU4p6LD24QY9XxzQwNgi6RAPjkOMtaqvtWE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOilGQ7l+H/R1RKEkYqBU1vu9ecLe7RTqrWXJHsop/AXJ8v2I4
	v7DFnBRwrGkI0k6AvtnGIUvTu89h8X9cU/csu/xluz0l2diK/IlcbA+JyMxNk68=
X-Gm-Gg: ASbGncuSIF/ymuDduqTFgOBDH7EDZb79GhwjnnpFylQaWa0Kb717+Tje7TMsGsnWLZA
	mNjCfcTW0KA2KkVBCOgi1HP/aKSeLJnyLNhsbYSQmU0/MxntW1ful+IxOTY7XcQUKs1TCcHCiZt
	UTSZ4ELOB80zGbbEOuwJSOLJ0hPRGUJIYHFzZdg09IaQbqkTFZigSuGKqYPdmit5pj6dp+qAJ7M
	Y05WopBfpsYUlFVqH/xwxgFtP9sjM/eKcZzVhNe3xG6okbsq4ZAuSNvT4wAAl9mlhNkq1h5ZLy7
	Zkwg5rpd1UCcEdTzLea5W8eNBCV3p5GnkIuoWY3p/qRZQIqR+77gJufG+AxRZRQxaLNHp+P5Y9N
	Za+n6aLY=
X-Google-Smtp-Source: AGHT+IF4DmVjYxU5OMHreWY3DuhJ0ArIP4/yXiQNLAIHsXqebkehUJ5U+ALGFOWSzRbbxKy+kOzWxQ==
X-Received: by 2002:a05:6a00:331b:b0:736:5f75:4a44 with SMTP id d2e1a72fcca58-7406f1a38ffmr5483346b3a.22.1746375042534;
        Sun, 04 May 2025 09:10:42 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590a463fsm5223665b3a.173.2025.05.04.09.10.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 May 2025 09:10:42 -0700 (PDT)
Message-ID: <ceab3632-61d3-4c34-a381-7c460d91dee4@linaro.org>
Date: Sun, 4 May 2025 09:10:40 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 14/40] tcg: add vaddr type for helpers
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, anjo@rev.ng,
 kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 alex.bennee@linaro.org
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
 <20250504052914.3525365-15-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250504052914.3525365-15-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/3/25 22:28, Pierrick Bouvier wrote:
> diff --git a/include/exec/helper-head.h.inc b/include/exec/helper-head.h.inc
> index bce5db06ef3..b15256ce14d 100644
> --- a/include/exec/helper-head.h.inc
> +++ b/include/exec/helper-head.h.inc
> @@ -21,6 +21,7 @@
>   #define dh_alias_f32 i32
>   #define dh_alias_f64 i64
>   #define dh_alias_ptr ptr
> +#define dh_alias_vaddr vaddr

Use __SIZEOF_POINTER__ to make vaddr alias to i32 or i64.

> +TCGv_vaddr tcg_constant_vaddr(vaddr val)
> +{
> +    TCGType type = __SIZEOF_POINTER__ == 8 ? TCG_TYPE_I64 : TCG_TYPE_I32;
> +    return temp_tcgv_vaddr(tcg_constant_internal(type, val));
> +}

TCG_TYPE_PTR will work here.


r~

