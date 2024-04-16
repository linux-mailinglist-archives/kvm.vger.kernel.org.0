Return-Path: <kvm+bounces-14736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B05748A6633
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 10:33:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3DAFE1F21E24
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 08:33:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75B5784FD2;
	Tue, 16 Apr 2024 08:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="pZksqERT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F8F8289C
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 08:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713256409; cv=none; b=TO2ryyKtoFJ/n9StQhR317WTy/+gM+IroEdSQqeBc/MqR6tceb0ZCfdx3WapbdTDk22r+FmvXPiKnwqKPIk63R1+mdzRhRBqn3AZVV4exdZg+4LIWfCSJZJ4fJkPfLWsU9tjvWt1//vWsKK3uV+Fq89cy6x2cJ0CnRBQWaFi9Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713256409; c=relaxed/simple;
	bh=1r2dYmGOG85xb9RvVvwdeFQUgSPsmVG5HQTBso1uuLg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tordm9RYDeQPDbf7dl4aqktH8cIFCJjh0wGByCiM4y6n+bv03Go4vFAbLWG+DZH9fYNwIOnhnzvlbs6xnH+TNkBqtD8kDeUQIXVY6W8ErWrGe7+omZ+0GqGuhQuqVXRyyz3l8BXfwpMlQx95F4gTjoQW2un35vpDGp8dthqD918=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=pZksqERT; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6ead4093f85so3342022b3a.3
        for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 01:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1713256405; x=1713861205; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5TvjvzDX9+vy4W2zxmJXwerRo6Lh0Y1bVDzHJUICCWo=;
        b=pZksqERTbBW99qFXhmT8dWj1ZfN+zVxjVOFSGZhWwnVA0WVaulsfxSUCphKXlsjA20
         iRo3t3oTN/0qD6wdcA8za6hzoWLwuc0G5vL+9EDoNaDdAxhl14/oD/TQV0y7rmH0u0A3
         AJCytknoVRY6wUlnofVYBj2cEH45vo7WI1oobjnZQf37KijVH/oP14YMjdqoUxNKgNdk
         0Jud0YycsKQWpdN3OAPtq4rKG1piXqmBeVnmO7mvVdApiMW/nL71KvSEEymtBAUsLDN8
         hg+NuY2wuc/lDZKtOU3pSWf6Y+/iHF4Hasg9u8lP3LFvUqRqkyQx3ZNazNdyoeAMM0R2
         T69g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713256405; x=1713861205;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5TvjvzDX9+vy4W2zxmJXwerRo6Lh0Y1bVDzHJUICCWo=;
        b=HGzBpSmSam+UkDl2vh4Tt5di/mKGk72J+5sv7jbT8ne7MCdasMUTnAM0Fa3j/nxGDb
         QuGmD5hEzAYxMTaIqgDd7SxPm7j4kAh/9V4itCRcuhTvV5wMBXLDA8p7mdKoPjfdv4Z1
         +h4OCOdS05p0Oh9CAe+lNQZ/O9i45F54w/Ss/kVt+mWghS1h58BHYeZco7qPRXEVj5be
         Zjn+v/scfF/bi6lB8RpR/D5hDMLGZpJ3Uea2n42EDD0DGHYbMlXKYdaSN7Jk+8Kt/mqx
         4sgm35fKpb/KLRFjYkhJgYE+j0ExLFTfr4amzT9K2/PmkEpzcSuQ6yf6jUe7htpN2w8Y
         BpIA==
X-Forwarded-Encrypted: i=1; AJvYcCVT+56hdWU1siTXxhDU2uZzFh1aOUrgGywowgfN/kvRvFiNutOfPsbYL3QHTkcVwJxOIu1g/kguuA0t5bOJ+1Vk/FI6
X-Gm-Message-State: AOJu0YyHmR4wf8aD+Fjhojw2l3pVjJDCHE3Pd+SW8Uqi4PyJGhEN8nh4
	4Q9QW1e2JFkh1Qxkw9C4jHbAu9dq3hYElQfyOgRZFJk9kOLEjTpkfFCG6nD20DY=
X-Google-Smtp-Source: AGHT+IHrkeBmdYGDSxY9lkjSHA0b7Iv/w+m0cDIN2acr0IYgXgd79F0r3F5ys4RmCJ4iNsyU6E2Lrg==
X-Received: by 2002:a05:6a20:d49b:b0:1a9:c6fd:d2b9 with SMTP id im27-20020a056a20d49b00b001a9c6fdd2b9mr8196272pzb.8.1713256404819;
        Tue, 16 Apr 2024 01:33:24 -0700 (PDT)
Received: from [172.16.0.33] (c-67-188-2-18.hsd1.ca.comcast.net. [67.188.2.18])
        by smtp.gmail.com with ESMTPSA id y25-20020aa78559000000b006e6c0f8ce1bsm8490363pfn.47.2024.04.16.01.33.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Apr 2024 01:33:24 -0700 (PDT)
Message-ID: <dd14fc53-deda-4086-aac0-2dde7f065bb0@rivosinc.com>
Date: Tue, 16 Apr 2024 01:33:22 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 08/24] drivers/perf: riscv: Implement SBI PMU snapshot
 function
Content-Language: en-US
To: Andrew Jones <ajones@ventanamicro.com>
Cc: linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@rivosinc.com>,
 Anup Patel <anup@brainfault.org>, Conor Dooley <conor.dooley@microchip.com>,
 Ajay Kaher <ajay.kaher@broadcom.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alexghiti@rivosinc.com>,
 Alexey Makhalov <alexey.amakhalov@broadcom.com>,
 Atish Patra <atishp@atishpatra.org>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Juergen Gross <jgross@suse.com>,
 kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org,
 Mark Rutland <mark.rutland@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Shuah Khan <shuah@kernel.org>,
 virtualization@lists.linux.dev, Will Deacon <will@kernel.org>, x86@kernel.org
References: <20240411000752.955910-1-atishp@rivosinc.com>
 <20240411000752.955910-9-atishp@rivosinc.com>
 <20240415-1654deb9446d6c0ebb858b30@orel>
From: Atish Patra <atishp@rivosinc.com>
In-Reply-To: <20240415-1654deb9446d6c0ebb858b30@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/15/24 06:15, Andrew Jones wrote:
> On Wed, Apr 10, 2024 at 05:07:36PM -0700, Atish Patra wrote:
>> SBI v2.0 SBI introduced PMU snapshot feature which adds the following
>> features.
>>
>> 1. Read counter values directly from the shared memory instead of
>> csr read.
>> 2. Start multiple counters with initial values with one SBI call.
>>
>> These functionalities optimizes the number of traps to the higher
>> privilege mode. If the kernel is in VS mode while the hypervisor
>> deploy trap & emulate method, this would minimize all the hpmcounter
>> CSR read traps. If the kernel is running in S-mode, the benefits
>> reduced to CSR latency vs DRAM/cache latency as there is no trap
>> involved while accessing the hpmcounter CSRs.
>>
>> In both modes, it does saves the number of ecalls while starting
>> multiple counter together with an initial values. This is a likely
>> scenario if multiple counters overflow at the same time.
>>
>> Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
>> Reviewed-by: Anup Patel <anup@brainfault.org>
>> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
>> Signed-off-by: Atish Patra <atishp@rivosinc.com>
>> ---
>>   drivers/perf/riscv_pmu.c       |   1 +
>>   drivers/perf/riscv_pmu_sbi.c   | 224 +++++++++++++++++++++++++++++++--
>>   include/linux/perf/riscv_pmu.h |   6 +
>>   3 files changed, 219 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/perf/riscv_pmu.c b/drivers/perf/riscv_pmu.c
>> index b4efdddb2ad9..36d348753d05 100644
>> --- a/drivers/perf/riscv_pmu.c
>> +++ b/drivers/perf/riscv_pmu.c
>> @@ -408,6 +408,7 @@ struct riscv_pmu *riscv_pmu_alloc(void)
>>   		cpuc->n_events = 0;
>>   		for (i = 0; i < RISCV_MAX_COUNTERS; i++)
>>   			cpuc->events[i] = NULL;
>> +		cpuc->snapshot_addr = NULL;
>>   	}
>>   	pmu->pmu = (struct pmu) {
>>   		.event_init	= riscv_pmu_event_init,
>> diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
>> index f23501898657..e2881415ca0a 100644
>> --- a/drivers/perf/riscv_pmu_sbi.c
>> +++ b/drivers/perf/riscv_pmu_sbi.c
>> @@ -58,6 +58,9 @@ PMU_FORMAT_ATTR(event, "config:0-47");
>>   PMU_FORMAT_ATTR(firmware, "config:63");
>>   
>>   static bool sbi_v2_available;
>> +static DEFINE_STATIC_KEY_FALSE(sbi_pmu_snapshot_available);
>> +#define sbi_pmu_snapshot_available() \
>> +	static_branch_unlikely(&sbi_pmu_snapshot_available)
>>   
>>   static struct attribute *riscv_arch_formats_attr[] = {
>>   	&format_attr_event.attr,
>> @@ -508,14 +511,109 @@ static int pmu_sbi_event_map(struct perf_event *event, u64 *econfig)
>>   	return ret;
>>   }
>>   
>> +static void pmu_sbi_snapshot_free(struct riscv_pmu *pmu)
>> +{
>> +	int cpu;
>> +
>> +	for_each_possible_cpu(cpu) {
>> +		struct cpu_hw_events *cpu_hw_evt = per_cpu_ptr(pmu->hw_events, cpu);
>> +
>> +		if (!cpu_hw_evt->snapshot_addr)
>> +			continue;
>> +
>> +		free_page((unsigned long)cpu_hw_evt->snapshot_addr);
>> +		cpu_hw_evt->snapshot_addr = NULL;
>> +		cpu_hw_evt->snapshot_addr_phys = 0;
>> +	}
>> +}
>> +
>> +static int pmu_sbi_snapshot_alloc(struct riscv_pmu *pmu)
>> +{
>> +	int cpu;
>> +	struct page *snapshot_page;
>> +
>> +	for_each_possible_cpu(cpu) {
>> +		struct cpu_hw_events *cpu_hw_evt = per_cpu_ptr(pmu->hw_events, cpu);
>> +
>> +		if (cpu_hw_evt->snapshot_addr)
>> +			continue;
>> +
>> +		snapshot_page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
>> +		if (!snapshot_page) {
>> +			pmu_sbi_snapshot_free(pmu);
>> +			return -ENOMEM;
>> +		}
>> +		cpu_hw_evt->snapshot_addr = page_to_virt(snapshot_page);
>> +		cpu_hw_evt->snapshot_addr_phys = page_to_phys(snapshot_page);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int pmu_sbi_snapshot_disable(void)
>> +{
>> +	struct sbiret ret;
>> +
>> +	ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_SNAPSHOT_SET_SHMEM, -1,
>> +			-1, 0, 0, 0, 0);
> 
> The SBI_SHMEM_DISABLE patch got moved in front of this patch, but looks
> like it was forgotten to apply it.
> 

Oops. My bad. Fixed it.

> Otherwise,
> 
> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
> 
> Thanks,
> drew
> 
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv


