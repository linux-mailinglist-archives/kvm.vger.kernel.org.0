Return-Path: <kvm+bounces-45339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F51EAA87EC
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 18:17:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A1551890125
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 16:17:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C0231C860E;
	Sun,  4 May 2025 16:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ma5JdNkj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97227E0E4
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 16:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746375430; cv=none; b=V7NGOS1vToWBRvJOj3+LefneZeJpl2Z9+WCwofTHb/g3C56dLInb9BBSBIp9uDQx55Pc9t8kN8IKtKoRWn7zwrqT+lZTEktOzMEfV2SgWppFbH13NhSklkZBkGirYztzasrr5VARLoC+gIb2Uz/VsYfk0ossKCGCxjDPWLW8r+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746375430; c=relaxed/simple;
	bh=uxzTqWEhtnW+zD/NUkgfceY7SbHFkHGem+zquOAKL1s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tPDDMI6INw8IFSWV8ojF2JRT0tcqF93MqT6JcLBUPRRwR6BKik1oaG82tjaqrEj3zvqlOP+vfECdftbcfp3IwOWk4LvUi9cay/hZgxQ9PJ7c/0uLbmRZ7QUvgNlDGPt+fcilmQzqk8QihKsWtEwm4GIaJ28t5IXeHp7v7+mZ5rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Ma5JdNkj; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-736c1cf75e4so3220258b3a.2
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 09:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746375428; x=1746980228; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gPGn+MwZnc8xQd76t/xYLdPoUTnlVwwJ6Dg5FznPQUQ=;
        b=Ma5JdNkj5AdA4yIcewPYxTvojaC2sLiVoUFHq2lrWEo77gsBDKaJhPD/qlFlDWM6pH
         x1NCQKtSN4MChcE4TjWWC8l72IuLKyJQ57ItAkFsBREDcErKQkiWpaVrJwBddxs7BAky
         UbdjDkFrdUGPtfa2mCgiXI26zU/75IuyOfD3+tS/rVAjDPEfPQqBRwJRPWZXak2PofQW
         YwCalHf9hGZYLk2+oWZvosInmV1NJe0DSOMAvhxjKcBgtuXhNlaq7GAyXq1LJTOWAc8E
         /3Mx0ajqNDtlNbV/6wDAK05ZXuiub+73xlD1zBM9sGyvjNbCKuRR1VpeJr1CrD71tXiO
         +qJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746375428; x=1746980228;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gPGn+MwZnc8xQd76t/xYLdPoUTnlVwwJ6Dg5FznPQUQ=;
        b=TYM6CXQ9sMHHu0tXIjU11r8HjKrJ+9XohypEhU6m69bgCkZl7xdbuja1MudR23mDFf
         SM2bkReG2CFoJwqTJxPgm7+xCf/9ZDzdz5SbdYD52Q2bgEqSSViedibqjrUTO/9aMxZb
         qTFbqJaehwR9DNcGUxFIV4NNKIM9eQMXrxLgsSIrCeHAX77/G8BfstaBYst/HqdoCtsE
         FnCJ4V0Jhw2bGF4hf8shk6JH2ld5xPqfxYU75bnBvnuOUuEzNGvhEPLO8OY4T2wUvVX0
         x5j8ubg2A+5tfgcbNH19Zaj77uVe5b6Vq+P3/OEugMuucl35KDavweggGW/Wa601ZHSg
         PmzA==
X-Forwarded-Encrypted: i=1; AJvYcCVWHCtpOOK56SvIaIUxepVaxIIAFqT3M9z4Co+E6tfzbgVVeJMC7c53LcS8OTEpLsFdOEg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNLLl99sMe2FhsJdvct4w/U3PZivOvVe8tItfIX35ntmVrg1l5
	HRZLNwhT5e45sHY9GUKjJNoHmw07i1aOjty2m00+hREfqupXFwGlLGuWPNfT5fI=
X-Gm-Gg: ASbGncuJ0Ihvs6vhZWX8pq+sg6s0NT9eke4wk/3/fKqEUIy2VLiOpSSKz2pJzmrVMeZ
	YLyZqNDAsjJqLkTS+CPtyDZj/uHhV0N3IkyKSzAgFsOIz9M6UjEHpTYItOyJl6zI5OKkj6Wgo2Q
	A3Z1buhK51L1s2guhJ6E9bmSVCrOGQJoCHNe4OA0Rl1pTdb5sKYZi4rOwCOZunKM7B9X8hKXkmG
	SWml8lAihOMrTTmlC0/nGnp08jS/Hjr+rEWqbVZJf59Xl7MkF9aF7zSuEyEBERis7HfHmcxNN0n
	c22/wPHZPWrxS6Mr0vksFauIUGGarf8XswBya0NwH7PCeHq+R91KcYMnxJbV3NggcNiN30xedws
	Q3YEjzTI=
X-Google-Smtp-Source: AGHT+IF3G5/bfGBl5sy8J3dBUbGQQ6KrLbeTzkDrhzSDPBYgiKocLSfoMUYlYUoHUsjZG5gmsH1W8g==
X-Received: by 2002:a05:6a21:9614:b0:1f5:769a:a4bf with SMTP id adf61e73a8af0-20e97eaa02amr6564145637.36.1746375428049;
        Sun, 04 May 2025 09:17:08 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3b7afd4sm3293173a12.33.2025.05.04.09.17.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 May 2025 09:17:07 -0700 (PDT)
Message-ID: <5b152664-a752-4be8-aa15-8c71c040b026@linaro.org>
Date: Sun, 4 May 2025 09:17:05 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 16/40] target/arm/helper: use vaddr instead of
 target_ulong for probe_access
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, anjo@rev.ng,
 kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 alex.bennee@linaro.org
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
 <20250504052914.3525365-17-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250504052914.3525365-17-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/3/25 22:28, Pierrick Bouvier wrote:
> +++ b/target/arm/tcg/translate-a64.c
> @@ -258,7 +258,7 @@ static void gen_address_with_allocation_tag0(TCGv_i64 dst, TCGv_i64 src)
>   static void gen_probe_access(DisasContext *s, TCGv_i64 ptr,
>                                MMUAccessType acc, int log2_size)
>   {
> -    gen_helper_probe_access(tcg_env, ptr,
> +    gen_helper_probe_access(tcg_env, (TCGv_vaddr) ptr,
>                               tcg_constant_i32(acc),
>                               tcg_constant_i32(get_mem_index(s)),
>                               tcg_constant_i32(1 << log2_size));

This cast is incorrect.
You need something akin to tcg_gen_trunc_i64_ptr.

Alternately, do not create TCGv_vaddr as a distinct type,
but simply a #define for either TCGv_{i32,i64}.

In this case, it'll be TCGv_i64 and everything will match.


r~



