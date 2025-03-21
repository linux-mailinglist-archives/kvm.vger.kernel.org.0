Return-Path: <kvm+bounces-41685-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A8655A6C01B
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 17:38:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9AC881894BA4
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 16:38:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEB2022D4E9;
	Fri, 21 Mar 2025 16:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SdJaIYZD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78E122CBC8
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 16:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742575061; cv=none; b=q0y1/fM3yyKK5rp63c42JodIT/PNyZ2PPDFeRU9yBewnozvWMkLZhAqpFqcHnVqkr1FwpQ0MSTfmVjmEv97/pMJ2aEFDJ5281OdczUmXFhyRybr4+xMbOIsaDht4sHrQzYsPILsjYd99dx2lsdLvirEergrEl8gdnyaTK+uWGkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742575061; c=relaxed/simple;
	bh=1DTo1js5qn8+vQGgQVzUyBWsBETaUF3k2znBDdyTlDI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d9YXKtL/LjvAmawegp0THVEq0O9u/QULTVMUDXECgXa1MAcLLhw264OvBKyTUo3MOweCz5kzLHRSrXazjjWL7zweiPTVR4w9w3m+Ah3HLcGSnf2tv19rLhF/zkjWKckKFeRlPG4UnZy7FJcwGqpKVxFiBUn8ApYWIXJ29T8mcQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SdJaIYZD; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2ff694d2d4dso3539054a91.0
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 09:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742575059; x=1743179859; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y59C5Qrj18DiWWjCyKGAGj8vz+PXlW5k6VnD2BYRmjo=;
        b=SdJaIYZDe9GzlFFZhBSPZ4zLf/BxAmJZmPw6PsEaCViIGM11BnLVKXxCAbU0wlySKw
         AaHvA1oMTpPfo0Hnzvm56ElSgLyJZOskI1cLuYpn7J/KZIoQ8CHu6RTiQ1NS/GJ72ZYo
         t7A9pmQkk4TZ1UW+xeTdzCOyIQrCyLCFNxqmoRgy3SzZ17iOu5+wvmHXdpUQ1lhS53Fa
         bDpXfzOJ0JG4s6n7wa55b1g1zaqjOD3O0bV3F0F59wCJQ2lkJSgPJuYLGiEJL3W9akru
         kJFfEkSxQ2oGkXu+4lH8rPVlTpohqv6m/Cu2grjCeIRkEt3Mi0V6ncm0kbZgQM7tuO9L
         ldYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742575059; x=1743179859;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y59C5Qrj18DiWWjCyKGAGj8vz+PXlW5k6VnD2BYRmjo=;
        b=vfE4JPOEdG/sUMMCNDyOvuFVAb05NV6OYxrBI5d/1wghEwBwRtALTicxxSeoT68zg0
         D2ZCAd6akQxmtKGHwx3wjY9BHs6K8i3cqrJieyRW5/syURWt7166ARUzsuTO23hh+R84
         hoT8GV2vfgI+8yjJp8oJTCmyXuqRfG0z4uqbgRybHSPWIXWhQg/+kSD5OqomH0fz9EiS
         rfNMGS62M6B9UnGMqYtiKsThqgtAjvCVzWKYSqqR7cZ2r/FAMx/g7gzwzRvxLLo7BTMc
         WBhU4H2sx0H12mQRVNTPZH9/XjqBJH2Y9ooLbUHMZIvoikkFc+VFk3SkaWzqzkS51Zso
         T9WQ==
X-Gm-Message-State: AOJu0YxATVKr01Qti4DfTWCdvzlpH6pviVY1W/0KGWmTAJsCctRWuxXX
	7IS6o0EH2w1WXvOo8HAwJ9++CVUkro/bX4L7AfuyoBOrrfrMsCUCuV3Sb2GTn64=
X-Gm-Gg: ASbGncsaozTh4HIHKcZOa1W6XpL1+3Gk2/XcL6cs6q1URPWPLxO77MS21Swu2gxhbCi
	wRPIq6tbhGmWKN0SKRc8ikHt///yp5DTx4slZaSTzasHQMysOacK86fjoBna9YRjRrUZT6ph4u2
	NScALFLu+GCazzilVq+pX0G7by09BJofrhDQ6I46qAzuWLghOk9gqU6SpPltXECcyyajzOMcXmy
	FWD+/11c+Q3PVd6NsBHDjV588weW0TwUqUHIE3vkhmvYGmX3OizYHvVLya8cgLQCKK8Bj6FhFB6
	zFXwgkrVsLdJ+WGJScm/rJc4K54oMrbeNG84pm18eA4w/Rt4kqRmK8PO1FHWs18DyVNdcLIjenI
	CS3yOGp/1
X-Google-Smtp-Source: AGHT+IEZrO7nUw4P8/L9oXnNbpWNLCvFQg8dOSD+kcKxwvCK1Gn6uemtpZ/wD0vshfT03aSdYi8KUw==
X-Received: by 2002:a17:90b:2703:b0:2fe:8282:cb9d with SMTP id 98e67ed59e1d1-3030fee5ef6mr6721415a91.28.1742575058884;
        Fri, 21 Mar 2025 09:37:38 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-227811f45b2sm19128455ad.214.2025.03.21.09.37.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 09:37:38 -0700 (PDT)
Message-ID: <543e972d-8154-4a35-bd00-b8b950f4c794@linaro.org>
Date: Fri, 21 Mar 2025 09:37:36 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/30] exec/cpu-all: remove tswap include
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-8-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250320223002.2915728-8-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/25 15:29, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   include/exec/cpu-all.h               | 1 -
>   target/ppc/mmu-hash64.h              | 2 ++
>   target/i386/tcg/system/excp_helper.c | 1 +
>   target/i386/xsave_helper.c           | 1 +
>   target/riscv/vector_helper.c         | 1 +
>   5 files changed, 5 insertions(+), 1 deletion(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

