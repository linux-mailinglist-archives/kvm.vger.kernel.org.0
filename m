Return-Path: <kvm+bounces-41051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A27CA61045
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 12:44:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1C078837D8
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 11:44:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60F411FE463;
	Fri, 14 Mar 2025 11:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="fKRJZn8O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE901FDA99
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 11:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741952651; cv=none; b=HQO9tFVx95AbxzD3mR1IJjbTYcK7g8cFbWD4An2i0Rv4w7RjNJzBwbqLlIipdwClLe9VfMbWkoUsai67lr4OHxxc3YWjnsVE2buCqTAhu8jPeM8exXgehx9S17oQd7cqTRm0epI+84p2vU1fVCB/hxRW5d90+3yxatqLgEf68mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741952651; c=relaxed/simple;
	bh=k3VquhwGBzj/qmce5+dPovhxa6xW5DKGhqNFIz459Pw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HIq4skcIWvE+8ckNYDtGrPF27BdMH97fYmwCG2pQfJlUWIMePaZmnrWPGYaATbTb+wMgn5o1l3MsOR9xtDZivbqNIHV3WO6g0Ams7nVWUbDW8WkIkzwoGr7lySwCMk7o+UHT+iutdIDHHuCBWNaIchRLg4vEY2ou8ZSjP8aYPNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=fKRJZn8O; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-38f2f391864so1147469f8f.3
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 04:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1741952647; x=1742557447; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yNXP4301/EYAJtyOh9G36QhlKo8rLTXV/iJ66ebNv0k=;
        b=fKRJZn8O5LWILPL61QJWy9PcxsKvfPy7Vy3XP94utIj0okxdSdAuFC/A/Gu54GYAIT
         W+MWYhJdrxU88ULgbjBEfyDOigvxGPg5J3GFoNCpValNaUjLNun4tXjmOUfuTN0dzvxH
         7by+9njDjWaSLHhi0I1q5vm4Y13ziVqzdU8LbKSJc1dtoB2Y53oxOvz38z59sLyBnwJM
         AQKfPNUirYs4PBoeCWd9uffKuQPegE3TJnL8RDzDOzmf/9hDWAO2XwUGco6+ySHK9vGb
         WDylJrV4EqjG1qDQQ3lRLDguRb+wR7PB4i8Wzf4s+RBDERDY71Cc6KGc5Gdp/WbitUvG
         EApw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741952647; x=1742557447;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yNXP4301/EYAJtyOh9G36QhlKo8rLTXV/iJ66ebNv0k=;
        b=PI7sSjfxCzNk2AfUrG7jp5ZjevjCi1JgLocDEZPmhPOITLbPiTQEYg074KRxH7Mrc+
         cPi8h0F0H42IewvKCh7gVCuy7H12uQuRxrdlWYcinixAQ1j65r8V/GjzFbnXRoimy5nP
         glndvzXOxV2+5iTx+2/6mWiiXGNZs8nflrPP2I4LWQlONeRKdD2jRQc/YeDwzUz2IfWt
         qJiFXSbx2QnqByqGUmh1D9+rwV5iO/MFAWw97btb1vjlpOdBeAjI7ZSA1u32ObO8we9R
         FfWtlGtCy9PXVhnWoaV0A/Xni9AHhWtKetkrgnSqL63B4wnjrzS5VovjE1zhzCEhm40y
         J5Bg==
X-Forwarded-Encrypted: i=1; AJvYcCV2usuwk0KJzV7JaiXBgTMe/psEvipa7cqrcbu0NePCmiVq/pKMhVZrt41CZETzX5WG61A=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZ3aDGlm6AOMQWkhDKJqR9feZb82RQ8FwlkzDncssVYd9V6NXQ
	ssGmS9/HD/7IvxdUFOSvoHWS6+IdU2UmhA90CmWUbtEsxekmFFgsQhWhXodrFbc=
X-Gm-Gg: ASbGncvcxyv4LAt7GEMFE7Ulsay865kltuXAUoKe1uyvbkKfkOihk5zN9Vr3tZnIDnk
	14AGKboqICtg80wXGJ8EqApaVmeU8E7wwkh6fsjk4JGwBmvdztKutZReSXsB2g0QH52Mj1TSFK1
	O4Gwc8CFOHzoFPsbGz8fAfuRfpgMIpj/YwxW9G3NP3oUcOvoaiKe2s1GPlqK1nV+yB0Hfa8nZiF
	mOYZd889NdkZZGeLNXnZ1QmcIQR4KcKBbrEHJLEPOoHTxF/ylavw1xyzMgpbVqGKfsunRe32wNa
	Gi/NZ2CEA2RCQ7IKg4QLM390cbIac1nYRWhoZNSsM6HuTxwJqV221v68fCdtxSH21yHwcKprbfD
	4vGTkG4ifZ8iO3w==
X-Google-Smtp-Source: AGHT+IF+PcMLniUgUw+7z04HFQAwTiKLbHivzVvB0Zh2bIees9zyWsKr40uUY0pHyf5dEv8vx5Q9WQ==
X-Received: by 2002:a5d:5f49:0:b0:390:fb37:1bd with SMTP id ffacd0b85a97d-3971f7f8fccmr2700791f8f.46.1741952647046;
        Fri, 14 Mar 2025 04:44:07 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:e17:9700:16d2:7456:6634:9626? ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395c83b6a32sm5420094f8f.33.2025.03.14.04.44.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Mar 2025 04:44:06 -0700 (PDT)
Message-ID: <1942580f-cd67-4ddd-b489-0532f95c1ef2@rivosinc.com>
Date: Fri, 14 Mar 2025 12:44:05 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/17] riscv: misaligned: use on_each_cpu() for scalar
 misaligned access probing
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Anup Patel <anup@brainfault.org>,
 Atish Patra <atishp@atishpatra.org>, Shuah Khan <shuah@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Samuel Holland <samuel.holland@sifive.com>
References: <20250310151229.2365992-1-cleger@rivosinc.com>
 <20250310151229.2365992-6-cleger@rivosinc.com>
 <20250313-311b94f9bafe73bcd41158a1@orel>
Content-Language: en-US
From: =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>
In-Reply-To: <20250313-311b94f9bafe73bcd41158a1@orel>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 13/03/2025 13:57, Andrew Jones wrote:
> On Mon, Mar 10, 2025 at 04:12:12PM +0100, Clément Léger wrote:
>> schedule_on_each_cpu() was used without any good reason while documented
>> as very slow. This call was in the boot path, so better use
>> on_each_cpu() for scalar misaligned checking. Vector misaligned check
>> still needs to use schedule_on_each_cpu() since it requires irqs to be
>> enabled but that's less of a problem since this code is ran in a kthread.
>> Add a comment to explicit that.
>>
>> Signed-off-by: Clément Léger <cleger@rivosinc.com>
>> ---
>>  arch/riscv/kernel/traps_misaligned.c | 9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
>> index 90ac74191357..ffac424faa88 100644
>> --- a/arch/riscv/kernel/traps_misaligned.c
>> +++ b/arch/riscv/kernel/traps_misaligned.c
>> @@ -616,6 +616,11 @@ bool check_vector_unaligned_access_emulated_all_cpus(void)
>>  		return false;
>>  	}
>>  
>> +	/*
>> +	 * While being documented as very slow, schedule_on_each_cpu() is used
>> +	 * since kernel_vector_begin() expects irqs to be enabled or it will panic().
> 
> which expects

Hum that would yield the following:

"schedule_on_each_cpu() is used since kernel_vector_begin() that is
called inside the vector code 'which' expects irqs to be enabled or it
will panic()." which seems wrong as well.

I guess something like this would be better:

"While being documented as very slow, schedule_on_each_cpu() is used
since kernel_vector_begin() expects irqs to be enabled or it will panic()"

Thanks,

Clément

> 
>> +	 */
>>  	schedule_on_each_cpu(check_vector_unaligned_access_emulated);
>>  
>>  	for_each_online_cpu(cpu)
>> @@ -636,7 +641,7 @@ bool check_vector_unaligned_access_emulated_all_cpus(void)
>>  
>>  static bool unaligned_ctl __read_mostly;
>>  
>> -static void check_unaligned_access_emulated(struct work_struct *work __always_unused)
>> +static void check_unaligned_access_emulated(void *arg __always_unused)
>>  {
>>  	int cpu = smp_processor_id();
>>  	long *mas_ptr = per_cpu_ptr(&misaligned_access_speed, cpu);
>> @@ -677,7 +682,7 @@ bool check_unaligned_access_emulated_all_cpus(void)
>>  	 * accesses emulated since tasks requesting such control can run on any
>>  	 * CPU.
>>  	 */
>> -	schedule_on_each_cpu(check_unaligned_access_emulated);
>> +	on_each_cpu(check_unaligned_access_emulated, NULL, 1);
>>  
>>  	for_each_online_cpu(cpu)
>>  		if (per_cpu(misaligned_access_speed, cpu)
>> -- 
>> 2.47.2
>>
> 
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>


