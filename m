Return-Path: <kvm+bounces-46372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 74C6AAB5AAF
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 19:03:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D6ECA7A1C0B
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 17:02:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12CA61F12F4;
	Tue, 13 May 2025 17:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="r9OCzo2l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4195F2AF10
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 17:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747155816; cv=none; b=FN7B27HICMGeTKJc8XrHmxfTOSEzFeBJPYjxwTlgASAK0phhaQW1g4PGzHN4cULYS2nmGeIaBUDdaeefbqZJcAvRkTqvgPQqLmuZEa12qF36oqfFPCeMOCEU6TdQDPcyeJxQLFSLTpJuWRaD4aaegCaUi8Wg3yRomW44BfYVHjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747155816; c=relaxed/simple;
	bh=miDehVxy4JebDLy1g7nmPhnZqle/nx5c5neN6+mD9v0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=krWdHl1/zGjueJDXCJWnf1myPZ1ZkOPHJ/hN1gw//2O34aUcg/2DarnLEKFSkPO3pSgYK5iaaYvucoiu8i89YfqkwNdjWYxl7Yklu8VhSX90Zm63Sj2QPsaaStLSZSTPkvD8uzCjLKpBtOOZKTTRqLDLXiYqJ8KxiSgO0U39wNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=r9OCzo2l; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43cec5cd73bso40025015e9.3
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 10:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747155812; x=1747760612; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ec7nBzZXny1twVolLK/NIf749kxcJmpJJJ9Zt7x7exA=;
        b=r9OCzo2lO3rkYmFzvaBYeh4d5O9Tr/f8DDQvzZZCNBUfShTkS2Wj4xHpH4m4J36unT
         WVCnVrnBBbz97ptPhFaZJzzW/98IfOMZHzXhlNmykaiKtIfMY9v/Y/wVcyu4FMtYJAdm
         GQ4iaIbNAgUvzN4OkGxYzCwHDmruiD9BHokx1dByTWl47bCB/pXuXzxeWWrYeZIGre1g
         wN3KyTm9hRvDtYZ+FZe8IcSrF5hY7v4LX2UCZag/4TTnidp2bKtF6J31mzVcmMvgY0dd
         fbg9HD1KbQrlQRb3TFcnkHAbYpdyiQCqFhswRN8+LGNwHjfQry5cUqJXVRLTVGURAkin
         pJIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747155812; x=1747760612;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ec7nBzZXny1twVolLK/NIf749kxcJmpJJJ9Zt7x7exA=;
        b=eXilYKUa0Kack+5pMu6+Vctcc2VtkAIgj691G1tIdU7/BZb/CFU8SJGvu90JkgggLC
         guTzS5oT/MLWgTrneaGuFr9rpNkl1hBA3KuYYaonoDge2YStZ5r0RIvlH//N7y8l/HDr
         5v6zC2ydn5b970P7tUgv3i+/4uDMaeatczO8nL33hkD2zeS/runM9G2CeAZTVjqt1FHw
         zo4Du/vZ0R42sKOUiMde7CzoscO1pQLoMRRw8LU3w7Cn7vPuKduJxgF+PCZYIrNsUMQQ
         zp4mChvdyiR4uyuWA6CsO0So3E9g9b7SbiuCgFptVxwDhuKBJIAAsfLU8DC1Q14A/eHX
         qq3g==
X-Gm-Message-State: AOJu0YwpKzZL/vYDx7Rrh/NV2R+QHt6XcNspAEtG1+DUMp+Gkk1BmgzC
	yI7+WThvkqmxXOpdUjj4y/MBgTIv6iw7xj562d8tR1NEPOtzk7u/uLBXJwRGVBc=
X-Gm-Gg: ASbGnculZAGiNrn6Gh0MHG41v9GFPkIoGB8krhxliQAyTJrQZUSwAQrM0xWZ8Sa/0k3
	z1oHdTk0+CWetCDUAfzkVxSthNII96q5qdBVphzkooNs97Yy7VoaGMRuMQ7iMd2bt/B57G87ysH
	WTgYKZVnJ5DpMbxYqzEkWX4X04nX9g6S1Y37/K/t/BVQLtYwQHy1WETUkhZnDWfECzsBEwLlqPk
	B2sPIKQf/7z8Coj695Vt9hmuNQsShxr3EixAuw/sLfSBQhIf/7zh0JjAuw0YU5ajOnyxiBa8ubT
	/UhOCCTBMd5/ubKd8Cy8nK1qZDDSpEBlCG7h+SbDmvYNpb5pJQ8cKrhE4QasarpPTXeLNt23xjp
	QwpmnPBszKpMQhYXQrMzlS+0kMJ0=
X-Google-Smtp-Source: AGHT+IHuvD7b+uKWAZi2SJclzjF+sG6qnTzikqIaAqLvy1x6sWnsYSvbygtOJLCjYHGjW57+5kTnug==
X-Received: by 2002:a05:600c:3b17:b0:43c:f8fc:f686 with SMTP id 5b1f17b1804b1-442f20bb64dmr1242485e9.3.1747155812242;
        Tue, 13 May 2025 10:03:32 -0700 (PDT)
Received: from [10.61.1.204] (110.8.30.213.rev.vodafone.pt. [213.30.8.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442d687bdcbsm176408005e9.40.2025.05.13.10.03.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 10:03:31 -0700 (PDT)
Message-ID: <39c6f5ab-6e45-491d-a0e8-07408e29e2f8@linaro.org>
Date: Tue, 13 May 2025 18:03:29 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 30/48] target/arm/ptw: replace TARGET_AARCH64 by
 CONFIG_ATOMIC64 from arm_casq_ptw
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, alex.bennee@linaro.org, anjo@rev.ng,
 qemu-arm@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
 <20250512180502.2395029-31-pierrick.bouvier@linaro.org>
 <91cd9b9a-8c67-47d3-8b19-ebaf0b4fab5d@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <91cd9b9a-8c67-47d3-8b19-ebaf0b4fab5d@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/13/25 03:41, Philippe Mathieu-Daudé wrote:
> On 12/5/25 20:04, Pierrick Bouvier wrote:
>> This function needs 64 bit compare exchange, so we hide implementation
>> for hosts not supporting it (some 32 bit target, which don't run 64 bit
>> guests anyway).
>>
>> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> ---
>>   target/arm/ptw.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/target/arm/ptw.c b/target/arm/ptw.c
>> index 68ec3f5e755..44170d831cc 100644
>> --- a/target/arm/ptw.c
>> +++ b/target/arm/ptw.c
>> @@ -737,7 +737,7 @@ static uint64_t arm_casq_ptw(CPUARMState *env, uint64_t old_val,
>>                                uint64_t new_val, S1Translate *ptw,
>>                                ARMMMUFaultInfo *fi)
>>   {
>> -#if defined(TARGET_AARCH64) && defined(CONFIG_TCG)
>> +#if defined(CONFIG_ATOMIC64) && defined(CONFIG_TCG)
>>       uint64_t cur_val;
>>       void *host = ptw->out_host;
> 
> I'd feel safer squashing:
> 
> -- >8 --
> @@ -743,2 +743,5 @@ static uint64_t arm_casq_ptw(CPUARMState *env, uint64_t old_val,
> 
> +    /* AArch32 does not have FEAT_HADFS */
> +    assert(cpu_isar_feature(aa64_hafs, env_archcpu(env)));

Why?  This is checked in the setting of param.{ha,hd}.
See aa{32,64}_va_parameters.


r~

