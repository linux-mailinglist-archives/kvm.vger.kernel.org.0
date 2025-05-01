Return-Path: <kvm+bounces-45105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 404D6AA606F
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 17:06:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F29C31BC64D7
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:06:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B01B20297D;
	Thu,  1 May 2025 15:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aHkEDcXN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEEEB6FB9
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 15:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746111987; cv=none; b=PE6Lj5/tHkj7Blwc/Vnm9sjKKVBlxe/FWE0vYOlFS9gOkKcQ0kYSvb8+4qG7xRremugKgpusWWyBQsM0AuK/NQCrW5Z+TSLNKzR7/ImAVVV94YpDMAgjfz+3W2XOiOqgG3iBCscwhu2GKHFFWShYwN6I+y30wkU139y9L0woHFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746111987; c=relaxed/simple;
	bh=S8v7+c8C6WggcnK3Aht4xRlF4y8+GbtuoPyu9JtJZlk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BxYUDz1pdRzJRW9I5wvYplccQuoKTnolxPxd6ZhVYly22kWlou4818aG783TfEFkTxP8zU6rP0Z902rbEcYES2AN7KsDFRAGOxQjBgtw82Giv5tMVtvnP19Sf5aNU2dBvS4zUcN8B8Lj8fAytqvcRBB/l8Z7RRYTPEEkLZNCE8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aHkEDcXN; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-afc857702d1so1118616a12.3
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 08:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746111985; x=1746716785; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iZWcy/gQwmgZzW18F5hJaXUmKEUe5Bw5th9wm/LSgKg=;
        b=aHkEDcXN+nJwtPJlYq8wEAtgUB37zejs9zCOxrEIITf3AsqZWnAbBxx+4HzPuE8Gaq
         cQvdENB+1fX4xMZSB2MI4kAvhJdiqfJJkCXN4RhpTfl+ESgZmKgG2sXx5hV3g27GDEZr
         D5W58v94JxMr84hbxFHWHNuh5sCO6urqHZf9EfukiCsUyxhlUl5CfLE5O0Fra8SVCfZ/
         w4VGrh9sEuQ3vK63TZ7bhxHmyIycApjrK0yL2KylZxItTfHmfsffeC0l0XJATpbJVqFP
         yVV97yWQNo3pGomLDfRfFWfTbuM0JVy12PzjX8oJpJdVQiGFng2C4I9N+ZAjJ+S7jrbu
         2Cuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746111985; x=1746716785;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iZWcy/gQwmgZzW18F5hJaXUmKEUe5Bw5th9wm/LSgKg=;
        b=Aw+8CG+0JVSHCcmCJpyV8uDGrtNLTt5ZCHrwGhLR/knTh1EkUghNdroD9qUAPgz3Fi
         rkbcyORFMcjbjdcbq23yIeIwT8Zd1jYlFXhC5LuNK8ai+3WEvHuHVJDsLlJIH3O7v3GD
         0UEO1y2jDjdWMShnT89c1w3LNvRqo9wlgSmwZDMxd5OstxsylWyXbeSlI4Ye874VDDK9
         4+opVCUMj4sU1VWwH+0jXYzTNz3bjf7CghZ96m6gbX60aj2gHG9u9lAL6ePIzdhPrMqh
         6S53YWa8rwVkF4zrP0OEPwKiM4GX2E+yY2Q1KrYQTu2z9u012lGv6wTR6RdZgThSv1En
         9aeg==
X-Forwarded-Encrypted: i=1; AJvYcCUZoXJSpwAjv4eu8UG+ttoKzcf9aUICF0aFUvwqFfkgCTHADynBHlubZ+0OAijVyRJ1um8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwlfJ0zoTtSZgOMBkAuWSbdSYvAlbe3h0WiBjupfMvsop0YSVN6
	MJG810UxfIPi0IR0cTilRxJFn+BSgj4rm9InLz5kZ/32P4muDJwHBerMNO29E+0=
X-Gm-Gg: ASbGncsOSpVLYtG8ud8DeF9ipoIppiy/d4fYxgxDcIVDnlw5y6n3nUYq9TUEbeycgZw
	t+o4CMJqFB1RlqAGCpZyVVmxSV1lI7FT9Kk0dFtRv9QTugcFmmy5Nh2D5lQZg90duUHTWak4wNi
	BbMhOCOOxLpdHVZVaisU/H+zEUtLvhgkBqSBCSnzVxLs4xAZ1Q72DCgLxrVRwnHPNDgcbJEq3zs
	wWj42HJiPSSM4QyQEZuikR+qrMiz2oa1GHbQ4RrnfzOz1Qocb9phT1f8TN6PXErV+OhP53gDdCF
	i7sa1IkXNYtSBJWARuXkrL93XHtzk0P5djm0F1IL/+ws86F3iKYxbvdhKq1mxce/Bxw4xJ2QW/m
	/q3DyWSQ=
X-Google-Smtp-Source: AGHT+IEYYi57/VU7OygPpKRkUXmhr7nlLM7U1UenGjpFwEyAsZYWV7KSkhl1VmFWd5WF1whtavzxLA==
X-Received: by 2002:a05:6a21:1788:b0:1f5:730b:e09a with SMTP id adf61e73a8af0-20ba73fbe81mr4682296637.20.1746111984650;
        Thu, 01 May 2025 08:06:24 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404ef18c61sm933502b3a.62.2025.05.01.08.06.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 08:06:24 -0700 (PDT)
Message-ID: <8f480fa1-609f-4b90-b6e7-02a76d2767d2@linaro.org>
Date: Thu, 1 May 2025 08:06:22 -0700
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

Why?

r~

