Return-Path: <kvm+bounces-45288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E923CAA8338
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 00:20:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A4522189CF52
	for <lists+kvm@lfdr.de>; Sat,  3 May 2025 22:20:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A616F1DB12E;
	Sat,  3 May 2025 22:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nfvCpBEo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C41A17A31D
	for <kvm@vger.kernel.org>; Sat,  3 May 2025 22:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746310839; cv=none; b=JvQ6mXhrgFETK9R9lWDqRvK+8vPFaxHvVOoEKZG5FaDinCpFu3A58vFJFvssx6H6TEgxfm5B9tqGkeAKFsF7yIEwaT3HJOMZ5Fligs4Ppq3mB8HzV2ud/2Z6XujvK+wBB6ucaALWYUDptcsouUmMDel1fpb5WBJx1HEmI3gnyr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746310839; c=relaxed/simple;
	bh=ehV1h8+xtgMjIaeESRSpvEZucrwZ1Wc8UFIea+92nlk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HPPWMrUOrw4a7MXtCYReSqyQuHYrjlhGYc2M8T0z424kzUVtxLiRF6aOLTt/ZuYF3rbOzDZi1G3rxVmUZvTHxroYVfk7WRGIWR+E1+WfzQ7WLq8FZeDckpwEFVsfqU+0AhE5Fe9H5ef5doQIsHImAlOa9Wbx6jF0JDiYHmJ1Jag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nfvCpBEo; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b1fb650bdf7so1048127a12.1
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 15:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746310837; x=1746915637; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U3XNTdWrjdDo0RP0WVFaZKWtTI+X6cTatFOOc4Qu1dY=;
        b=nfvCpBEoaLzZRKTKpmBD8uvrbOKTZqF4E2ctMLf88KVmOe8q0ktG1f2Ow+FxXMDnCZ
         mZTJ2DSQURm93abdd2zMyDXwZeE/RUyjf7TralBQQxhql+T+gSwXt7bTVfZB7YsDh7jy
         9m08vuszRiMQuAC4bin6iSNqniG9wN9tx+gMiWVcur7wsRxPa3DEXIjZdXUT+URkhVuy
         aAkNDaRkrOgwXPvQGkbbhJDWn0WVRit5SGn3huJj+d4qNcl3lOaH5GrwiS0dyuWMWG/M
         RMdYq9jlZL4boqSQ7LirydN3P4JNlsq5BWTNMfBky+e7WmJwezYXmXPnhNoSrXerLpNm
         tEYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746310837; x=1746915637;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U3XNTdWrjdDo0RP0WVFaZKWtTI+X6cTatFOOc4Qu1dY=;
        b=qZyidAtPdopUol64DbehrfROIYZIjAzeqJ5lz0GPm2Bw8npaCT2DERp237VlhKb3y8
         CLETyAKawOyFDAUeIo5AFZ0CBG9G3T10PmlrwOvJ5tnXLuZH9+fU9Wd+QoQLi+uuqRfC
         b6g9V7rKE5HoT0p0hapg27soN3sxoQPXCQJ6fnkuj7cEvnK7M5w9U9DOqU/pxdAqjo4K
         FSbzlVji3l962dgAPe6KwDlPGDcZtMo+N9A8H5f11Ah1Fk0KCgzaXfDDwWkgZLuE9hXS
         G1/NKkz1hL/fqcWd5x65GIzypiP2Y7IhjvEOKRJVFu1LyQyqBy8m7tEVBNu1Fb6FncL9
         nHiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUgeZmN6utxUAX9Q80uMhFeHjiMmRPYtPf84quvTEz1pJvdOeiQVbMGQ+RPyUc4MR9QMSM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnCLxtrul2T05lWLSEICuFdU2p+/R4+dwh5jIKiw03yp+9a3Pb
	YSVW1eixIi1g7n/MlPg9xx76kruesxYlBlV1DclgssVNiXFKrNpUc+nik5EdqqE=
X-Gm-Gg: ASbGncvj5M43omlxQ8pCr+GZL6drdI38bWOvBTUG/ZrkEIiAB7d/QFc8KveIxprf/Sn
	8gvDRtmboU9YDD/56XLbZms7KcBqG/9nBsq6sL63gyWjRHGcsqOB56io8UhvnxrW3coBAZ7Hjpl
	VDruSpTwoR5uzvSQYXUrDN6GTsGHpcFWnn44DCmWA2/9PQfmEI2K0ZkN+3RvcsO+dJYYG/Y1iPR
	wkoxNUIoeNen2tanUvcJAWn/XneUHgppQtD0tlC7hMwooOrnTAEHuaL9I+iv3GSFaro1dbxVsuq
	wHtcM/1BJXXC+Bt2hTP3eD7Ti7shirOlGkzBI5J6wYhE/QN45ylRwg==
X-Google-Smtp-Source: AGHT+IG4xBk92Qmb14P3SC+6ErM2U8xgJgOkMaOYZto9rl9Jd5cV8hSFLDBqFi+G7UEQYoIMjleG3Q==
X-Received: by 2002:a17:902:da86:b0:220:e1e6:4457 with SMTP id d9443c01a7336-22e1ea969a0mr29683305ad.26.1746310837360;
        Sat, 03 May 2025 15:20:37 -0700 (PDT)
Received: from [192.168.1.87] ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590610desm3936800b3a.146.2025.05.03.15.20.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 May 2025 15:20:36 -0700 (PDT)
Message-ID: <a5b6548e-b4c3-4e7e-a683-ebb0243154ff@linaro.org>
Date: Sat, 3 May 2025 15:20:36 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 20/33] target/arm/helper: replace target_ulong by vaddr
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org,
 Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng, kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-21-pierrick.bouvier@linaro.org>
 <a9d29064-e4c7-4536-b918-057951dcc1ac@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <a9d29064-e4c7-4536-b918-057951dcc1ac@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/1/25 12:28 PM, Philippe Mathieu-Daudé wrote:
> On 1/5/25 08:23, Pierrick Bouvier wrote:
>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> ---
>>    target/arm/helper.c | 2 +-
>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/target/arm/helper.c b/target/arm/helper.c
>> index 085c1656027..595d9334977 100644
>> --- a/target/arm/helper.c
>> +++ b/target/arm/helper.c
>> @@ -10641,7 +10641,7 @@ static void arm_cpu_do_interrupt_aarch64(CPUState *cs)
>>        ARMCPU *cpu = ARM_CPU(cs);
>>        CPUARMState *env = &cpu->env;
>>        unsigned int new_el = env->exception.target_el;
>> -    target_ulong addr = env->cp15.vbar_el[new_el];
>> +    vaddr addr = env->cp15.vbar_el[new_el];
> 
> Why not directly use the symbol type (uint64_t)? Anyway,
>

Nothing in particular, I was just in the mood following patch 17.
vbar_el is an address, so it makes more sense to use vaddr.

> Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> 


