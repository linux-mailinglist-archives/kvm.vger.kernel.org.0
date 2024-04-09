Return-Path: <kvm+bounces-13938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 256BF89CF73
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 02:33:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 931BB1F23400
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 00:33:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D41CF4C85;
	Tue,  9 Apr 2024 00:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="xxjMqRFJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85ABC15D1
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 00:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712622795; cv=none; b=F6OEwLPqs0EeZ3xOGyEJ8V9nHSQQih51b0OT/WkJL2XU/DDAQbDK6e9YbsnXZuF1SN8R9eEfXD2jo7NHkEi79xMkWXvd6ABcuZFh0jQIuGah6RB4SDEZIpMP6NGaaFAo3wDKx2nJX2lLmxw2CS3EDEkOk2DXM7yegllyFzb70EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712622795; c=relaxed/simple;
	bh=DJ/hQ2jxsHQO4QqjkfXY3cUKzfZdwjLfN1fz+yoHqxE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rwiwo352xy0Oa8RKb9In0c1vo5vR1Mj42YjNEx6JsIULaJP7EBVHF+2DCfbRjVd4Rj9qh8bF51Fb2aCUpi5+MzDOa8uknI4goVnj7GhCtiRHkNn9p7kE4s+j281PIngHzwFH1lqAG7BfC9HTtcZVFnmqpSIAMU+gnK+OLdUnEtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=xxjMqRFJ; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1e2232e30f4so44663065ad.2
        for <kvm@vger.kernel.org>; Mon, 08 Apr 2024 17:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1712622793; x=1713227593; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f/CJmT3YaooE8CB2QIvUgCnYPke09ytqabQq9mjiodg=;
        b=xxjMqRFJX1wc7+u49+U3+8x4Pqk2B9OVV5fbFWwUO0aym8a7lbG27R2Jfo5QDgbCVc
         9QoP3iiqOXwRqbneH+3iWosL/p+xAwh3Hq7f1p0LywVzeRmq2lgFNM32OlwinE7UzbVX
         yMW9teTKnrj1Al46kiue0AB2n3296lIF42hqhQFGgeE1vYpTHhiuXQuxwc2hZ4nNKwRH
         isA0vOLM6Aa4TQeEtVhR2R81nZamtF1/iOsjZOC3ar487+3vl16xMVtexSifyI/awolf
         +wrULRrO5VVEyPLcc+k6aohGJJjWcxCSy9zQwhsImkE65xdVBXi8GyYTRLgqnsLsV/Cc
         G8gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712622793; x=1713227593;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f/CJmT3YaooE8CB2QIvUgCnYPke09ytqabQq9mjiodg=;
        b=LDFj/RHWdqyYvPTdmrKpqED+3K5YTbzetntMWQz/R2Fos+1snLdHhOCBXEZggHOJLa
         DMjYnJdHxk+JmjJ2MnenyB/PLLmAh+1650r5rdNs29QZkjjKZqIPbNAEEd3Qp4AMremS
         IRAupr8YWTYsEcSrDn9UeMHvaaAj5+pl18Jr5bQSl2N2H6iolO8ywUviD3IRORtGzOc7
         J2w2zSfEo1j56lPiRUg+anz6b1F69eGsq8f8gFGdPMEakcZ2KSO6OxeVFCdtGgwBsCEs
         LgD1uvN/38YKy0DN0Yz0cLk81hVjVrWdNEi/9QN0l1zfTYUV4GwJ/3So2s7Une3JMbAy
         CKdA==
X-Forwarded-Encrypted: i=1; AJvYcCVLRXy5WjsFoDWh2j/oxLHv45m5Om04JgcnZN4lR0VztDYgM1R69K+7xlAVfLP0X90ex09ka28CuDm0ECIBXKzOZ2Jx
X-Gm-Message-State: AOJu0YzstLEtXZGtGZSJg+kk/5WW9oK9VTF4Mzc/CekGYLNPDg7/hQUB
	YqwTvY338xG26WRhQSp8roaOnjpxRxZH1GTq7P40KmZPk0nIaZGoAiAYCrAWHZA=
X-Google-Smtp-Source: AGHT+IEvUCM8edq+BJU6njmxP2S88uAHY8Y4uoAWuaqv8e2rJW7YxBXFjZFMDPCzo+f8OYSJfA0hYA==
X-Received: by 2002:a17:903:404b:b0:1e4:35b9:f150 with SMTP id n11-20020a170903404b00b001e435b9f150mr2977778pla.11.1712622792665;
        Mon, 08 Apr 2024 17:33:12 -0700 (PDT)
Received: from ?IPV6:2601:647:4180:9630::e8c1? ([2601:647:4180:9630::e8c1])
        by smtp.gmail.com with ESMTPSA id m10-20020a170902db0a00b001e0e977f655sm7621722plx.159.2024.04.08.17.33.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Apr 2024 17:33:12 -0700 (PDT)
Message-ID: <a50d426c-a7c0-49d9-8bdf-d15ba53ba40f@rivosinc.com>
Date: Mon, 8 Apr 2024 17:33:10 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 12/22] RISC-V: KVM: Implement SBI PMU Snapshot feature
Content-Language: en-US
To: Andrew Jones <ajones@ventanamicro.com>
Cc: linux-kernel@vger.kernel.org, Anup Patel <anup@brainfault.org>,
 Ajay Kaher <akaher@vmware.com>, Alexandre Ghiti <alexghiti@rivosinc.com>,
 Alexey Makhalov <amakhalov@vmware.com>,
 Conor Dooley <conor.dooley@microchip.com>, Juergen Gross <jgross@suse.com>,
 kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org,
 Mark Rutland <mark.rutland@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Shuah Khan <shuah@kernel.org>,
 virtualization@lists.linux.dev,
 VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
 Will Deacon <will@kernel.org>, x86@kernel.org
References: <20240403080452.1007601-1-atishp@rivosinc.com>
 <20240403080452.1007601-13-atishp@rivosinc.com>
 <20240405-1060c986299eaac3528c7d4f@orel>
From: Atish Patra <atishp@rivosinc.com>
In-Reply-To: <20240405-1060c986299eaac3528c7d4f@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/5/24 04:23, Andrew Jones wrote:
> On Wed, Apr 03, 2024 at 01:04:41AM -0700, Atish Patra wrote:
>> PMU Snapshot function allows to minimize the number of traps when the
>> guest access configures/access the hpmcounters. If the snapshot feature
>> is enabled, the hypervisor updates the shared memory with counter
>> data and state of overflown counters. The guest can just read the
>> shared memory instead of trap & emulate done by the hypervisor.
>>
>> This patch doesn't implement the counter overflow yet.
>>
>> Reviewed-by: Anup Patel <anup@brainfault.org>
>> Signed-off-by: Atish Patra <atishp@rivosinc.com>
>> ---
>>   arch/riscv/include/asm/kvm_vcpu_pmu.h |   7 ++
>>   arch/riscv/kvm/vcpu_pmu.c             | 121 +++++++++++++++++++++++++-
>>   arch/riscv/kvm/vcpu_sbi_pmu.c         |   3 +
>>   3 files changed, 130 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/riscv/include/asm/kvm_vcpu_pmu.h b/arch/riscv/include/asm/kvm_vcpu_pmu.h
>> index 395518a1664e..77a1fc4d203d 100644
>> --- a/arch/riscv/include/asm/kvm_vcpu_pmu.h
>> +++ b/arch/riscv/include/asm/kvm_vcpu_pmu.h
>> @@ -50,6 +50,10 @@ struct kvm_pmu {
>>   	bool init_done;
>>   	/* Bit map of all the virtual counter used */
>>   	DECLARE_BITMAP(pmc_in_use, RISCV_KVM_MAX_COUNTERS);
>> +	/* The address of the counter snapshot area (guest physical address) */
>> +	gpa_t snapshot_addr;
>> +	/* The actual data of the snapshot */
>> +	struct riscv_pmu_snapshot_data *sdata;
>>   };
>>   
>>   #define vcpu_to_pmu(vcpu) (&(vcpu)->arch.pmu_context)
>> @@ -85,6 +89,9 @@ int kvm_riscv_vcpu_pmu_ctr_cfg_match(struct kvm_vcpu *vcpu, unsigned long ctr_ba
>>   int kvm_riscv_vcpu_pmu_ctr_read(struct kvm_vcpu *vcpu, unsigned long cidx,
>>   				struct kvm_vcpu_sbi_return *retdata);
>>   void kvm_riscv_vcpu_pmu_init(struct kvm_vcpu *vcpu);
>> +int kvm_riscv_vcpu_pmu_snapshot_set_shmem(struct kvm_vcpu *vcpu, unsigned long saddr_low,
>> +				      unsigned long saddr_high, unsigned long flags,
>> +				      struct kvm_vcpu_sbi_return *retdata);
>>   void kvm_riscv_vcpu_pmu_deinit(struct kvm_vcpu *vcpu);
>>   void kvm_riscv_vcpu_pmu_reset(struct kvm_vcpu *vcpu);
>>   
>> diff --git a/arch/riscv/kvm/vcpu_pmu.c b/arch/riscv/kvm/vcpu_pmu.c
>> index 2d9929bbc2c8..f706c688b338 100644
>> --- a/arch/riscv/kvm/vcpu_pmu.c
>> +++ b/arch/riscv/kvm/vcpu_pmu.c
>> @@ -14,6 +14,7 @@
>>   #include <asm/csr.h>
>>   #include <asm/kvm_vcpu_sbi.h>
>>   #include <asm/kvm_vcpu_pmu.h>
>> +#include <asm/sbi.h>
>>   #include <linux/bitops.h>
>>   
>>   #define kvm_pmu_num_counters(pmu) ((pmu)->num_hw_ctrs + (pmu)->num_fw_ctrs)
>> @@ -311,6 +312,80 @@ int kvm_riscv_vcpu_pmu_read_hpm(struct kvm_vcpu *vcpu, unsigned int csr_num,
>>   	return ret;
>>   }
>>   
>> +static void kvm_pmu_clear_snapshot_area(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
>> +	int snapshot_area_size = sizeof(struct riscv_pmu_snapshot_data);
>> +
>> +	if (kvpmu->sdata) {
>> +		if (kvpmu->snapshot_addr != INVALID_GPA) {
>> +			memset(kvpmu->sdata, 0, snapshot_area_size);
>> +			kvm_vcpu_write_guest(vcpu, kvpmu->snapshot_addr,
>> +					     kvpmu->sdata, snapshot_area_size);
>> +		} else {
>> +			pr_warn("snapshot address invalid\n");
>> +		}
>> +		kfree(kvpmu->sdata);
>> +		kvpmu->sdata = NULL;
>> +	}
>> +	kvpmu->snapshot_addr = INVALID_GPA;
>> +}
>> +
>> +int kvm_riscv_vcpu_pmu_snapshot_set_shmem(struct kvm_vcpu *vcpu, unsigned long saddr_low,
>> +				      unsigned long saddr_high, unsigned long flags,
>> +				      struct kvm_vcpu_sbi_return *retdata)
>> +{
>> +	struct kvm_pmu *kvpmu = vcpu_to_pmu(vcpu);
>> +	int snapshot_area_size = sizeof(struct riscv_pmu_snapshot_data);
>> +	int sbiret = 0;
>> +	gpa_t saddr;
>> +	unsigned long hva;
>> +	bool writable;
>> +
>> +	if (!kvpmu || flags) {
>> +		sbiret = SBI_ERR_INVALID_PARAM;
>> +		goto out;
>> +	}
>> +
>> +	if (saddr_low == SBI_SHMEM_DISABLE && saddr_high == SBI_SHMEM_DISABLE) {
>> +		kvm_pmu_clear_snapshot_area(vcpu);
>> +		return 0;
>> +	}
>> +
>> +	saddr = saddr_low;
>> +
>> +	if (saddr_high != 0) {
>> +		if (IS_ENABLED(CONFIG_32BIT))
>> +			saddr |= ((gpa_t)saddr << 32);
> 
> saddr |= ((gpa_t)saddr_high << 32)
> 

Oops. Thanks for catching it. Fixed.


>> +		else
>> +			sbiret = SBI_ERR_INVALID_ADDRESS;
>> +		goto out;
>> +	}
>> +
> 
> Thanks,
> drew


