Return-Path: <kvm+bounces-46923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B590ABA6BF
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 01:53:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11F384E27AE
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 23:53:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5669281359;
	Fri, 16 May 2025 23:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="ss1zWcoL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3974231856
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 23:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747439619; cv=none; b=mpVr8f6Zwiewy6+PLTAhlDF6OvPafl01xDy/g3R8yx+PaHes0F54xKgshTiVjPktB9T9uqxWNeFsXNquwZ+xVaLhT/UAyFM6Fnk29JtKkvDH6RVY89cRAwZcsr0WbM4S4nkPhQ7rPikrQ2s0nHm5MojXnklmZnkksRg+XhVr/Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747439619; c=relaxed/simple;
	bh=Jin3yk6dEqe8GxRTxVuJZ/xNO3DOAiT60Ttp+cflGnA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KezuMhXnzlbaLIWM/GKpSRNVqyTe/VP68J7NhmeiJzFgYEFHuLFXyiB/8sVc8b4LmfRfUfPH93nn0PR5++ALrhoFBl8Naax66NJSnjCotlwtmISIQgWeGKc6T2IwK+dmYitJfkOpx7P+vJPFBay56BJnDZYZeyuhfRW7wHq/lYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=ss1zWcoL; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-231e331baceso11583745ad.0
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 16:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747439617; x=1748044417; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+X0sEMByIYCJp9C2VC0Yrhh05RdaqRYJfaKNmUnn3Dg=;
        b=ss1zWcoLjm+yyyGpvkpDHNG2ZmRtR4JDINtig19pEH+jr6OVvg+yICzTbzobfg0yty
         IWPWCxzQf3+c8YM9xjF25PLmrEcT8SCrKnQbAcWIftx2eepjmn2iJ0Sb2RcYmIyOhsrK
         QN/1xjGYisF0zUIsARxu4ajVnhe4llRazcB5+h21G1Cw8LWI/yI/aqtZbScM7/HNY1Ly
         2naChlrZ9x4UmrL+Nwj+hen6EKge2ARk1HeRVzlJAak50MYf9LvKVr4/njfNAmQWeHb5
         VMhnhG7HEZkyxAeHQP96dKWhFhEG+Y+jpkmd3QdNvPk0m3bceEBdRP2s6ZLCz4rG0J5j
         J2OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747439617; x=1748044417;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+X0sEMByIYCJp9C2VC0Yrhh05RdaqRYJfaKNmUnn3Dg=;
        b=fOaxOx4baWmFDzmux8zQCFurp3ZBHc73LVUUaUoaZZ4AQULLquSR8iJ14FgPAh5fHy
         2UDNFPwX4PRTZk/vsNvhwH9lK1f3W91EzfaAZx1FGmloXcZgh9PLuHPRyS05tgXsy7G+
         f8HCcDYYRQhPCv9NF1CVHG0lzF6l5pgc/iseXmyabJqY1yOsQNUz1wwMGwv8bdWG2ALg
         2aVQdYv7M6ZFh275jgg0JLDpLPBUgXDO6DlrZP1ZW6sjL3AIPuXR2tbJz80Qvo6haC3k
         IEYlOGCritXq95NVuntZcxEjLvbwKeSqtL/rmerGjXtDif6Mhk0OfUZ46XM/Cj//EIiv
         QLww==
X-Forwarded-Encrypted: i=1; AJvYcCWznRE45eyeVJ7PFJIZXSTV1rR5NGNY3wi9x6FeKwuGAuSvqPiyZ2bdsnNBG01y0ZqJhnk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvTF/ljZWWZrn9eYyZmEI7CyBNCvZGcXSjQdyxHYZZtR0nCI9W
	hywu5SCSbHJpkATJU9LdSju6VUfvdLXJErRmXiUjci9yLXZ7vV7NgGHB0N+EKOJxwLg+z7VUr0h
	hbWJiuWQ=
X-Gm-Gg: ASbGncu7bDyD3UMOkecoQCaLbaNVnkuDgciYqeKXfgNPmOxy9CjctY7+iuvSg1fRcom
	Gp2FNTRWdwmm95jqY16QKZcVKx4TG7IFZwJVORpAtn6JDvitGK+BZctLnc/E43UTJcsNmoGs9EQ
	Ci0kaftp05N/D8/oJo9b2EnKgvn43W7/zhh64iFpe5Jb9CkntZhNG7pSmS2mJqMQY90MOjkEO7S
	vpVkwgFoErspqmELXXaRToVbZODrrdIPsNAaU0oEEofZ1TGKUAOWjLPssUYgMauHzLwMRbfw5SJ
	Lop+9e1E8u9Dio9KAuONt+re2mrJ2qsXRKoxN40Q1I6VvYo5mxb1
X-Google-Smtp-Source: AGHT+IFRzWoflz3ycvTOCP0vPm7ds3Ft1eoTh6/GYuCA/U8J5Mo9M+nIUUI5eWrfofGnl4RnIgS3/Q==
X-Received: by 2002:a17:903:f8d:b0:21f:1549:a563 with SMTP id d9443c01a7336-231d43d56ccmr63299065ad.2.1747439616878;
        Fri, 16 May 2025 16:53:36 -0700 (PDT)
Received: from [192.168.1.23] ([50.34.76.202])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4ac95e1sm19998765ad.20.2025.05.16.16.53.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 May 2025 16:53:36 -0700 (PDT)
Message-ID: <386489f5-e814-403f-9997-849e55345210@rivosinc.com>
Date: Fri, 16 May 2025 16:53:34 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] RISC-V: KVM: Remove scounteren initialization
To: Anup Patel <anup@brainfault.org>
Cc: Atish Patra <atishp@atishpatra.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <20250515-fix_scounteren_vs-v3-1-729dc088943e@rivosinc.com>
 <CAAhSdy38s0WWc7Cv4KF+0_pGC3xKU3_PLgeedz7Pu04-xKm4jw@mail.gmail.com>
Content-Language: en-US
From: Atish Patra <atishp@rivosinc.com>
In-Reply-To: <CAAhSdy38s0WWc7Cv4KF+0_pGC3xKU3_PLgeedz7Pu04-xKm4jw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 5/16/25 5:18 AM, Anup Patel wrote:
> On Fri, May 16, 2025 at 4:41 AM Atish Patra <atishp@rivosinc.com> wrote:
>> Scounteren CSR controls the direct access the hpmcounters and cycle/
>> instret/time from the userspace. It's the supervisor's responsibility
>> to set it up correctly for it's user space. They hypervisor doesn't
>> need to decide the policy on behalf of the supervisor.
>>
>> Signed-off-by: Atish Patra <atishp@rivosinc.com>
>> ---
>> Changes in v3:
>> - Removed the redundant declaration
>> - Link to v2: https://lore.kernel.org/r/20250515-fix_scounteren_vs-v2-1-1fd8dc0693e8@rivosinc.com
>>
>> Changes in v2:
>> - Remove the scounteren initialization instead of just setting the TM bit.
>> - Link to v1: https://lore.kernel.org/r/20250513-fix_scounteren_vs-v1-1-c1f52af93c79@rivosinc.com
>> ---
>>   arch/riscv/kvm/vcpu.c | 4 ----
>>   1 file changed, 4 deletions(-)
>>
>> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
>> index 60d684c76c58..9bfaae9a11ea 100644
>> --- a/arch/riscv/kvm/vcpu.c
>> +++ b/arch/riscv/kvm/vcpu.c
>> @@ -111,7 +111,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>>   {
>>          int rc;
>>          struct kvm_cpu_context *cntx;
>> -       struct kvm_vcpu_csr *reset_csr = &vcpu->arch.guest_reset_csr;
>>
>>          spin_lock_init(&vcpu->arch.mp_state_lock);
>>
>> @@ -146,9 +145,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>>          if (kvm_riscv_vcpu_alloc_vector_context(vcpu, cntx))
>>                  return -ENOMEM;
>>
>> -       /* By default, make CY, TM, and IR counters accessible in VU mode */
>> -       reset_csr->scounteren = 0x7;
>> -
>>          /* Setup VCPU timer */
>>          kvm_riscv_vcpu_timer_init(vcpu);
>>
>>
>> ---
>> base-commit: 01f95500a162fca88cefab9ed64ceded5afabc12
>> change-id: 20250513-fix_scounteren_vs-fdd86255c7b7
>> --
> Overall, this looks good.
>
> Reviewed-by: Anup Patel <anup@brainfault.org>
>
> Currently, the scounteren.TM bit is only set by the Linux SBI PMU
> driver but KVM RISC-V only provides SBI PMU for guest when
> Sscofpmf is available in host so we need the below hunk to
> completely get rid-off scounteren initialization in KVM RISC-V.
>
> diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
> index 356d5397b2a2..bdf3352acf4c 100644
> --- a/arch/riscv/kernel/head.S
> +++ b/arch/riscv/kernel/head.S
> @@ -131,6 +131,12 @@ secondary_start_sbi:
>       csrw CSR_IE, zero
>       csrw CSR_IP, zero
>
> +#ifndef CONFIG_RISCV_M_MODE
> +    /* Enable time CSR */
> +    li t0, 0x2
> +    csrw CSR_SCOUNTEREN, t0
> +#endif
> +
>       /* Load the global pointer */
>       load_global_pointer
>
> @@ -226,6 +232,10 @@ SYM_CODE_START(_start_kernel)
>        * to hand it to us.
>        */
>       csrr a0, CSR_MHARTID
> +#else
> +    /* Enable time CSR */
> +    li t0, 0x2
> +    csrw CSR_SCOUNTEREN, t0
>   #endif /* CONFIG_RISCV_M_MODE */
>
>       /* Load the global pointer */
>
> I have queued this patch for Linux-6.16 with the above hunk squashed.

Yes. Thanks for adding this.

> Thanks,
> Anup

