Return-Path: <kvm+bounces-45291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 277D6AA833F
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 00:39:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F30F16C223
	for <lists+kvm@lfdr.de>; Sat,  3 May 2025 22:39:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CD2F1DF254;
	Sat,  3 May 2025 22:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZAAHM4nX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB79723CE
	for <kvm@vger.kernel.org>; Sat,  3 May 2025 22:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746311939; cv=none; b=iWMFTmfImSF9bDk1x6/PnlxaWgMTaor+v5m8Hp1d6m37/IJWGhJUxecOOxrNeCzLGSwjH9/3p7lpct5Tr2W6S84NPyWtUvJqpHCZ/VM4ek11TPAMHCSec6k+Py+w89msolgso91KqcWOZIZE6wBlpUkoISwKkLnW6IBGKlrKge0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746311939; c=relaxed/simple;
	bh=iFM3y4+EGdHtp6Ll8Gyt+iKYp2Ui0ssVgWjKEaZ+3qQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B3fy6n48sxbvKgX/tt6UhtP1B+4Ldy2P9/zhc30CQ66vAhKXM48iEbSxfvs8IV4V7mj/e7tkOO2yw9ch06yY4OgPWjSSpPydVdf28zFkE3PTjuyCRnFea8pAXguY+Z48uCEPGeT4p58G+ufTQxYwRSzRYZqTGfX+IRYy2D/IswI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZAAHM4nX; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-227d6b530d8so30366875ad.3
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 15:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746311937; x=1746916737; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TzZ6/rd4q6aCbwYQPJ+KXhulQgHBRP5Hhq/AeRCnMhA=;
        b=ZAAHM4nXeEghaT5PuV+u0M9oZOMlaESsqWUsk2dBdnv7vOYtmWbaK9DklnK/A8os/o
         3CTwSWXpWVYPcbO+HhKfuFvNhQzjjKWr7+LfvkzgXMUthlNVbdhgV6nvB/oCBzSFW4dp
         w6lcb0J7Ld8zXRQQkqCpZxl3uJ00ZnjHtjSyWmQYMfhtSQzxD5xgqlzngGgPKsXLLxMM
         fPVvXfI7sHVlvL8cGUUN+k1A8G4/jkljgtYVAv6fheWBt7TD+PKm7sgCtwUEbbiw4f+K
         7tYB+3t1/wr0rTJpQnRWHJiuJ3UkmvyQ/HRXHG4zwWd1gPnmH4+7EarwBozolftA2yDg
         +69Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746311937; x=1746916737;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TzZ6/rd4q6aCbwYQPJ+KXhulQgHBRP5Hhq/AeRCnMhA=;
        b=usbkxH+W6Jnp038GTn/PPSY1yPApj2L1NH6oVNYAsW2YyJhaaAzoOsnSzlBe5UCOzS
         b+248d1xcPRvJRGum4Rw0OeBOUR1GlaV+VJM3cdTXKAqHw0z3+WIbtomLpQEBdt5Wvkx
         dcyAV6xCBFIfGxtFJuFz5iRkPc9yvyg3cNCFDZl7PszFO34CbJXvw29jFMbAMlbWDqAR
         i+C3dwlvGn1N2fGPImL7Mt1NRxCqhK1HHM4VZ4PyIMnSw2r0Gm9JFQq/Ipv7163Ki7HO
         2RZXkIEQ5uTeOTmCHSiudaFdXqmH1QXceCtEzMnn9Snd9TWSg+fqfKEeP9igZ2bHgjkU
         G2Eg==
X-Forwarded-Encrypted: i=1; AJvYcCVeSkv4Y6Kgi3eCkY6okxtYnNiJbD3Gwtq3GeCxZmk2nQwMZDlrTWrT6Zvd4z2/rcn7Q1o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2+91JFDDf6XnrRlvuKBHVpUEg81Hf+a6lUYQ2zpap/XqjPyp7
	xqZBQ55rbqnKhBKyRT2Y5dannpK+c0efxO/tfNX2EQYRT6AgD7X2lANWBlAsg14=
X-Gm-Gg: ASbGncujwn0bg0o32+IHryVnV0B2Ip5aUTXJTs/SVTd0TmAnF+1r2dyOk6cWdjKvGD+
	E7TwZrvs759xU6thSQckO47CP2QpOglbxcjher62nti7J7SyLPsjEAS0AHMKrrhWrx2CKUFTWio
	aBl5XMg7c65md5K45EPPfwD076uuwK5w3tLcryVsRfIIY8pXSBkuAXYA+UFm3/PFs6TcznsJQAp
	B5SLhZ16fjDUZTVqApIm6B1CTFoERhDCsJDPWsaAOYzLoX6jYHecuELL2Hsnt7KnbEricdPiJtz
	rmGcaydipN7u3UP7XVF/aBv2QnHeNabfABxMvy0UsLYst/B2AuFAkA==
X-Google-Smtp-Source: AGHT+IGbvuzrDbhbsKgBrbhL/DT5H2efQa2r3sIZ0UPYi0CpGdc8SJZM4M9idFIWtsGgO9FOv6TJ6Q==
X-Received: by 2002:a17:903:1c3:b0:223:7006:4db2 with SMTP id d9443c01a7336-22e1031fc0emr143723965ad.31.1746311937096;
        Sat, 03 May 2025 15:38:57 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74058d7aea7sm3875921b3a.8.2025.05.03.15.38.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 May 2025 15:38:56 -0700 (PDT)
Message-ID: <ab094518-f0a3-4b2f-8c13-ec77b4b2e9e2@linaro.org>
Date: Sat, 3 May 2025 15:38:56 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 30/33] target/arm/ptw: remove TARGET_AARCH64 from
 arm_casq_ptw
Content-Language: en-US
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-31-pierrick.bouvier@linaro.org>
 <a6fdb501-438e-4591-b166-87c8dbd14887@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <a6fdb501-438e-4591-b166-87c8dbd14887@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/1/25 9:24 AM, Richard Henderson wrote:
> On 4/30/25 23:23, Pierrick Bouvier wrote:
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> ---
>>    target/arm/ptw.c | 13 ++++++++-----
>>    1 file changed, 8 insertions(+), 5 deletions(-)
>>
>> diff --git a/target/arm/ptw.c b/target/arm/ptw.c
>> index 424d1b54275..f428c9b9267 100644
>> --- a/target/arm/ptw.c
>> +++ b/target/arm/ptw.c
>> @@ -737,7 +737,14 @@ static uint64_t arm_casq_ptw(CPUARMState *env, uint64_t old_val,
>>                                 uint64_t new_val, S1Translate *ptw,
>>                                 ARMMMUFaultInfo *fi)
>>    {
>> -#if defined(TARGET_AARCH64) && defined(CONFIG_TCG)
>> +#ifndef CONFIG_TCG
>> +    /* non-TCG guests only use debug-mode. */
>> +    g_assert_not_reached();
>> +#endif
>> +
>> +    /* AArch32 does not have FEAT_HADFS */
>> +    g_assert(arm_feature(env, ARM_FEATURE_AARCH64));
>> +
> 
> I don't think we need an assert here.
> 
> The ifdef for aarch64 also protects the qatomic_cmpxchg__nocheck below, because aarch64
> guest can only be built with a 64-bit host.
> 
> Are we still able to build qemu-system-arm on a 32-bit host with these changes?  It may be
> tricky to check, because the two easiest 32-bit hosts (i686, armv7) also happen to have a
> 64-bit cmpxchg.  I think "make docker-test-build@debian-mipsel-cross" will be the right test.
>

Good catch.
I was indeed building only with i686. I'll add mipsel instead.

/usr/lib/gcc-cross/mipsel-linux-gnu/12/../../../../mipsel-linux-gnu/bin/ld:
libtarget_system_arm.a.p/target_arm_ptw.c.o: undefined reference to
symbol '__atomic_compare_exchange_8@@LIBATOMIC_1.0'

> If that fails, I think you could s/TARGET_AARCH64/CONFIG_ATOMIC64/ here.
> 

I'll revert this change and simply do this replace, adding a comment as 
well.

> 
> r~


