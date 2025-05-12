Return-Path: <kvm+bounces-46143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3899FAB3146
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 10:14:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A6ADE189087E
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 08:15:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8EF1257AF2;
	Mon, 12 May 2025 08:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="ar35yTb7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A590B253F1B
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 08:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747037680; cv=none; b=k5yT82YwdgBfVrcRWI7rGW2PxplikK+Did5DY8MDq8I3Pf3UAFrNhFfaZ8atrweGcNqxxXAUbv+RuIxchJMq+jqXvuVDtHjl3tJ7F2z24hW5S5EPUoH49MKMrjJINjNu67GuQziEDONo7QEwRD2/NRFbGUmtBvgdsBU4WdczIP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747037680; c=relaxed/simple;
	bh=ZTzMqrn1URom1KwjBf0pttZCkEBA9ZhKUjt81jZvKpI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=olLqNvGsrABgTKSD9XXqEe63/JLYer3s8Z85WsbgyrbI8S8alNEgpdZwiq1131Jvmno/ypotNvPPHJLSq+XLR35V0+SsV1iReys46QqlWa8m0rEQqsjf4cLblKO/ssxsNFvetzqv1BchqaKxt15uobOCr0y9Mrj3l1XaK69hA0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=ar35yTb7; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3a0ba0b6b76so2888584f8f.1
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 01:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747037677; x=1747642477; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KUWtnXREtfU0bglSJPdPg3dSI06mpwAnzzgVNIScr4k=;
        b=ar35yTb7To8DY9zWyhaj6CjMROYLdYrYlJZcHgm8BIoBZKjBvh9TZEgkQaroHM/MrB
         0wf28gvakTOoSeYMpA6KMAbG08lbGK/ok2kSq9L1ZmyJh5KXFFlmffG9UELfgi7zB18U
         jP0ErP40tITWcyfs3kIvcjv1BmmqBu8kTyM33P+c6cGRxbXKDOPAGGWPp5h6uRx3cHTR
         31XQCxU138vYBdRT6Hm9wTWKs8uVODmvhntVgrSj6w4mpYbUxROsxbTkO9u26UyFwdNq
         WgXQxFMF4ViuxbOgxtOkjQNkhJhJpamWjzsewC/ctHdizn8euM/TQ+GmPG+em6a4ObwO
         c+ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747037677; x=1747642477;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KUWtnXREtfU0bglSJPdPg3dSI06mpwAnzzgVNIScr4k=;
        b=NV5/GBpThVMA/BfXqsEgQEa77j4WnxqHeJpFuy7D8Awla2Z04jlJpjFeC+aFvXvmYK
         g0iRd7tHZWboRnTfGwp2TLK1uiPheHRBEJlSZP4suNyLaV1Lka7xNJPWKYL40awhdB61
         /xp68KQGoensqlt58Ps4K9pn8JBoPGfgUbWNrO5PBROO8NtpJX6RD3ZWdP1/wtkxBzZ+
         WCsb23ckk5C2W+8ILOalV1TABYdHFDWYT/J6cfYzMfLgWKaoKyeodbjD4kNtRyXsJ6JU
         YwnoNaHayc7y9N9WpZtOKruruROh7TKRTNf1u1teuPZLOjjJfVjZLK58q7qfC/HYn/xI
         Zdug==
X-Forwarded-Encrypted: i=1; AJvYcCVvoIzVyf9k1Qp2w7ntJJQNzynhH2VA5WZD51QW9Qp/6LG8fNfIWhBv6z6rSvYUtrSBxjk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwlnGdk8IUyXuLIsidC9/SeweGbw5ctaL12cNkuRwgnkXoTC1C3
	CGsd7jHon9KshRa5A+TOehJRHJAtjAjm4GvBUZT6oA7+JPiR2fnciTx/bb4TT6s=
X-Gm-Gg: ASbGnctB7yUWMqfpPBl+zrOv0MVtnHsNeuqjIn4knu4mzdKM9Tq9hbwGaDtch9zdfG/
	B9ikX31Ljg+kj0kQn6QcZIncTZ+WtMvUGad/Q44nkttKwUbJycWpRRTSanFbQp7cFeXmgdVQsjd
	RosfCQSANqHobT42I6mDME2NW+dQZC33hF3GjZmkBH9oBUGHhClkOor/VlbRSTwt27TwrvjQHC4
	wSaQ1OKuoc6QzP5LhkRzplW9pd8frdTDNEaZUHxPlYhEevAgpDj5QHG66MYdaAY87+nxL3JW7Vr
	VH5Egb00FHOa74ho3Uy6rmSWNTvIiqATlkhIkyAmVtl/ofaFzj/t5zHQ6T2ZHKwmuyKeNnyNSa5
	1PwaXvNgAWeCyN3B2asDL
X-Google-Smtp-Source: AGHT+IF5FdpyihNwkP+pz8qwsSi03YYChIIL/diT4CyeFnMpdYT9qUG8HkxnvNgaNA1vzLlpCGu/5Q==
X-Received: by 2002:a05:6000:186f:b0:399:6dd9:9f40 with SMTP id ffacd0b85a97d-3a1f643acbemr9221007f8f.9.1747037676817;
        Mon, 12 May 2025 01:14:36 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f5a2cf43sm11626947f8f.70.2025.05.12.01.14.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 May 2025 01:14:36 -0700 (PDT)
Message-ID: <fe9d801b-007d-476d-97fe-96d0f3d218cd@rivosinc.com>
Date: Mon, 12 May 2025 10:14:35 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 04/14] riscv: sbi: add FWFT extension interface
To: Atish Patra <atish.patra@linux.dev>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>, Shuah Khan <shuah@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-kselftest@vger.kernel.org
Cc: Samuel Holland <samuel.holland@sifive.com>,
 Andrew Jones <ajones@ventanamicro.com>, Deepak Gupta <debug@rivosinc.com>
References: <20250424173204.1948385-1-cleger@rivosinc.com>
 <20250424173204.1948385-5-cleger@rivosinc.com>
 <1c385a47-0a01-4be4-a34b-51a2f168e62d@linux.dev>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <1c385a47-0a01-4be4-a34b-51a2f168e62d@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 09/05/2025 02:18, Atish Patra wrote:
> On 4/24/25 10:31 AM, ClÃ©ment LÃ©ger wrote:
>> This SBI extensions enables supervisor mode to control feature that are
>> under M-mode control (For instance, Svadu menvcfg ADUE bit, Ssdbltrp
>> DTE, etc). Add an interface to set local features for a specific cpu
>> mask as well as for the online cpu mask.
>>
>> Signed-off-by: Clément Léger <cleger@rivosinc.com>
>> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
>> ---
>>   arch/riscv/include/asm/sbi.h | 17 +++++++++++
>>   arch/riscv/kernel/sbi.c      | 57 ++++++++++++++++++++++++++++++++++++
>>   2 files changed, 74 insertions(+)
>>
>> diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
>> index 7ec249fea880..3bbef56bcefc 100644
>> --- a/arch/riscv/include/asm/sbi.h
>> +++ b/arch/riscv/include/asm/sbi.h
>> @@ -503,6 +503,23 @@ int sbi_remote_hfence_vvma_asid(const struct
>> cpumask *cpu_mask,
>>                   unsigned long asid);
>>   long sbi_probe_extension(int ext);
>>   +int sbi_fwft_set(u32 feature, unsigned long value, unsigned long
>> flags);
>> +int sbi_fwft_set_cpumask(const cpumask_t *mask, u32 feature,
>> +             unsigned long value, unsigned long flags);
>> +/**
>> + * sbi_fwft_set_online_cpus() - Set a feature on all online cpus
>> + * @feature: The feature to be set
>> + * @value: The feature value to be set
>> + * @flags: FWFT feature set flags
>> + *
>> + * Return: 0 on success, appropriate linux error code otherwise.
>> + */
>> +static inline int sbi_fwft_set_online_cpus(u32 feature, unsigned long
>> value,
>> +                       unsigned long flags)
>> +{
>> +    return sbi_fwft_set_cpumask(cpu_online_mask, feature, value, flags);
>> +}
>> +
>>   /* Check if current SBI specification version is 0.1 or not */
>>   static inline int sbi_spec_is_0_1(void)
>>   {
>> diff --git a/arch/riscv/kernel/sbi.c b/arch/riscv/kernel/sbi.c
>> index 1d44c35305a9..d57e4dae7dac 100644
>> --- a/arch/riscv/kernel/sbi.c
>> +++ b/arch/riscv/kernel/sbi.c
>> @@ -299,6 +299,63 @@ static int __sbi_rfence_v02(int fid, const struct
>> cpumask *cpu_mask,
>>       return 0;
>>   }
>>   +/**
>> + * sbi_fwft_set() - Set a feature on the local hart
>> + * @feature: The feature ID to be set
>> + * @value: The feature value to be set
>> + * @flags: FWFT feature set flags
>> + *
>> + * Return: 0 on success, appropriate linux error code otherwise.
>> + */
>> +int sbi_fwft_set(u32 feature, unsigned long value, unsigned long flags)
>> +{
>> +    return -EOPNOTSUPP;
>> +}
>> +
>> +struct fwft_set_req {
>> +    u32 feature;
>> +    unsigned long value;
>> +    unsigned long flags;
>> +    atomic_t error;
>> +};
>> +
>> +static void cpu_sbi_fwft_set(void *arg)
>> +{
>> +    struct fwft_set_req *req = arg;
>> +    int ret;
>> +
>> +    ret = sbi_fwft_set(req->feature, req->value, req->flags);
>> +    if (ret)
>> +        atomic_set(&req->error, ret);
> 
> What happens when cpuX executed first reported an error but cpuY
> executed this function later and report success.
> 
> The error will be masked in that case.

We actually only set the bit if an error happened (consider it as a
sticky error bit). So if CPUy reports success, it won't clear the bit.

Thanks,

Clément

> 
>> +}
>> +
>> +/**
>> + * sbi_fwft_set_cpumask() - Set a feature for the specified cpumask
>> + * @mask: CPU mask of cpus that need the feature to be set
>> + * @feature: The feature ID to be set
>> + * @value: The feature value to be set
>> + * @flags: FWFT feature set flags
>> + *
>> + * Return: 0 on success, appropriate linux error code otherwise.
>> + */
>> +int sbi_fwft_set_cpumask(const cpumask_t *mask, u32 feature,
>> +                   unsigned long value, unsigned long flags)
>> +{
>> +    struct fwft_set_req req = {
>> +        .feature = feature,
>> +        .value = value,
>> +        .flags = flags,
>> +        .error = ATOMIC_INIT(0),
>> +    };
>> +
>> +    if (feature & SBI_FWFT_GLOBAL_FEATURE_BIT)
>> +        return -EINVAL;
>> +
>> +    on_each_cpu_mask(mask, cpu_sbi_fwft_set, &req, 1);
>> +
>> +    return atomic_read(&req.error);
>> +}
>> +
>>   /**
>>    * sbi_set_timer() - Program the timer for next timer event.
>>    * @stime_value: The value after which next timer event should fire.
> 


