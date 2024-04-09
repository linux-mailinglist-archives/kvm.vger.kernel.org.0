Return-Path: <kvm+bounces-13934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C41A89CF26
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 02:04:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DAEF282E54
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 00:04:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 537F264F;
	Tue,  9 Apr 2024 00:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="ag5YBuC4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB30618E
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 00:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712621086; cv=none; b=QCLwSt8IKS/Mxa1WPOQy75L1K0lL0amWNNCrkInBjUdl56r5wpCLpSoaVXRxQUcdHsHtsvG0qlLW40nuEV2Aa5bzEZXgVdI7s8eDSl7/A8fJDd1p92TbXwxqnEysNOAB9aF6czrdGUr3na4p42j0xY96bvROhl6/D0qMV2s48IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712621086; c=relaxed/simple;
	bh=tGemAdGs1i/th5kpM2ts3FwXyK6yltFMw9jonLi8+1s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RCRjTptzkhUOdMST9xb28i2ZJLlUy/Cga83dWwXhHPMxsvfvUqmoQeRIhnOZ9CsYmP2mNAH6cIZy8g06c75h2orh4N3JVtcc7KWqK8sFZe0OLbdx3Q7Jel3cj0e9K7t60UyquEkoE4SHBpxL0xiCT0kExEu7wzkw0py0W2zCxkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=ag5YBuC4; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1e424bd30fbso11196895ad.0
        for <kvm@vger.kernel.org>; Mon, 08 Apr 2024 17:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1712621084; x=1713225884; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xd+FWiZlX/lpCLCXGGzdHlU3p21YETfnnn9ljhWHF9I=;
        b=ag5YBuC4jZYDWk+vcemFhfpKim+usl0i89xx/mLRK/sZ5KhQu4noBx6ZHCWYMvbb3z
         1HberzLuUvZ17p8Xp5sTpijGt+9K+T787qIibS53AIQnhGEsCskhHiJHhqTaHTdGbdJB
         4WOrHva4e8dWwlu0Fp50P+XxdpZJEP7HxVU2wenl4GV9nFd6Us/ONeBn8hzAUTCSy0rP
         DM9/owVNWzWVhxY04snMMIxglq4qND5KGAp/5eMeEQb8D8lDXqSzvtKnhAPVRi11mC/P
         xr4qRFRV01w8gYyXp4yy0SLWXIcQUf4OcVnbSIGue3lSE1x4W9UhZEdev9rED215ppxZ
         BJcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712621084; x=1713225884;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xd+FWiZlX/lpCLCXGGzdHlU3p21YETfnnn9ljhWHF9I=;
        b=eQL+emPw5rfemUMPYkIbWyw7JtyvmBZReivTAZNlTEDNFvxwQ37AiiDsC3FdkTwKWc
         ediNR7EIJcaIzsdSU6zBYxL6y9nLjC0mPB4KB1uP9evX1B3JqQb8PxQb/NtmnnEZXFtc
         5TYbxOGw/gXTYQrBL8Zr3H4ANHG2sHZgYvcTLwwUXaxrIIqJ8KpM6zthCUnCMxggl38z
         06ket8FgKsy8es5I+5N3YKeqGjSJcmFITMMjo+iWCB1n+QzWGL6Rk7eQHZwKpqmr1Sz9
         /wxwYljQLbA3bl79Z6LtFt1++Jh5U7t99pjDq/M1INUAZBFLcxssD+3BFZdY6tCk30JC
         2fng==
X-Forwarded-Encrypted: i=1; AJvYcCUhYH5xbOlchIZLwcbNH18m8dqJKygeT9rd+wcesPhCZ8o8shFhwN0twhL/Bjhb4vIhPFWotmjWqePCMgOF2O8wVaa8
X-Gm-Message-State: AOJu0YziNKnNgJZPkpPpeoNGQk3/ppZ0IU8rhiQmN6Y83tM3xqnxhUqm
	+Q+BZ5GEcS8UT/D2F5D2/KlRBPin4OZU2FKxnHzUYVmDv9G+rxyhDNNeS9Vx5+8=
X-Google-Smtp-Source: AGHT+IG0OLdQkdZe7TuiqVfC4hYuT4+LNj+NNHp96L1eyYQkeOCssr3BNq26TdksuIIDjP/3fRra5A==
X-Received: by 2002:a17:902:d2ca:b0:1e4:1932:b0a5 with SMTP id n10-20020a170902d2ca00b001e41932b0a5mr5371923plc.68.1712621084126;
        Mon, 08 Apr 2024 17:04:44 -0700 (PDT)
Received: from ?IPV6:2601:647:4180:9630::e8c1? ([2601:647:4180:9630::e8c1])
        by smtp.gmail.com with ESMTPSA id c17-20020a170902d49100b001e1071cf0bbsm4411011plg.302.2024.04.08.17.04.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Apr 2024 17:04:43 -0700 (PDT)
Message-ID: <e95f9821-e83c-4abb-941d-60ce24b9c0a3@rivosinc.com>
Date: Mon, 8 Apr 2024 17:04:41 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 03/22] drivers/perf: riscv: Read upper bits of a
 firmware counter
Content-Language: en-US
To: Andrew Jones <ajones@ventanamicro.com>
Cc: linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@rivosinc.com>,
 Conor Dooley <conor.dooley@microchip.com>, Anup Patel <anup@brainfault.org>,
 Ajay Kaher <akaher@vmware.com>, Alexandre Ghiti <alexghiti@rivosinc.com>,
 Alexey Makhalov <amakhalov@vmware.com>, Juergen Gross <jgross@suse.com>,
 kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org,
 Mark Rutland <mark.rutland@arm.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Shuah Khan <shuah@kernel.org>,
 virtualization@lists.linux.dev,
 VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
 Will Deacon <will@kernel.org>, x86@kernel.org
References: <20240403080452.1007601-1-atishp@rivosinc.com>
 <20240403080452.1007601-4-atishp@rivosinc.com>
 <20240404-89ee7d7f90a5fcc91809065e@orel>
From: Atish Patra <atishp@rivosinc.com>
In-Reply-To: <20240404-89ee7d7f90a5fcc91809065e@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/4/24 04:02, Andrew Jones wrote:
> On Wed, Apr 03, 2024 at 01:04:32AM -0700, Atish Patra wrote:
>> SBI v2.0 introduced a explicit function to read the upper 32 bits
>> for any firmware counter width that is longer than 32bits.
>> This is only applicable for RV32 where firmware counter can be
>> 64 bit.
>>
>> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
>> Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
>> Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
>> Reviewed-by: Anup Patel <anup@brainfault.org>
>> Signed-off-by: Atish Patra <atishp@rivosinc.com>
>> ---
>>   drivers/perf/riscv_pmu_sbi.c | 25 ++++++++++++++++++++-----
>>   1 file changed, 20 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
>> index 3e44d2fb8bf8..babf1b9a4dbe 100644
>> --- a/drivers/perf/riscv_pmu_sbi.c
>> +++ b/drivers/perf/riscv_pmu_sbi.c
>> @@ -57,6 +57,8 @@ asm volatile(ALTERNATIVE(						\
>>   PMU_FORMAT_ATTR(event, "config:0-47");
>>   PMU_FORMAT_ATTR(firmware, "config:63");
>>   
>> +static bool sbi_v2_available;
>> +
>>   static struct attribute *riscv_arch_formats_attr[] = {
>>   	&format_attr_event.attr,
>>   	&format_attr_firmware.attr,
>> @@ -511,19 +513,29 @@ static u64 pmu_sbi_ctr_read(struct perf_event *event)
>>   	struct hw_perf_event *hwc = &event->hw;
>>   	int idx = hwc->idx;
>>   	struct sbiret ret;
>> -	union sbi_pmu_ctr_info info;
>>   	u64 val = 0;
>> +	union sbi_pmu_ctr_info info = pmu_ctr_list[idx];
>>   
>>   	if (pmu_sbi_is_fw_event(event)) {
>>   		ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_FW_READ,
>>   				hwc->idx, 0, 0, 0, 0, 0);
>> -		if (!ret.error)
>> -			val = ret.value;
>> +		if (ret.error)
>> +			return 0;
>> +
>> +		val = ret.value;
>> +		if (IS_ENABLED(CONFIG_32BIT) && sbi_v2_available && info.width >= 32) {
>> +			ret = sbi_ecall(SBI_EXT_PMU, SBI_EXT_PMU_COUNTER_FW_READ_HI,
>> +					hwc->idx, 0, 0, 0, 0, 0);
>> +			if (!ret.error)
>> +				val |= ((u64)ret.value << 32);
>> +			else
>> +				WARN_ONCE(1, "Unable to read upper 32 bits of firmware counter error: %d\n",
>> +					  sbi_err_map_linux_errno(ret.error));
> 
> I don't think we should use sbi_err_map_linux_errno() in this case since
> we don't have a 1:1 mapping of SBI errors to Linux errors and we don't
> propagate the error as a Linux error. For warnings, it's better to output
> the exact SBI error.
> 

Sure. Fixed it.

>> +		}
>>   	} else {
>> -		info = pmu_ctr_list[idx];
>>   		val = riscv_pmu_ctr_read_csr(info.csr);
>>   		if (IS_ENABLED(CONFIG_32BIT))
>> -			val = ((u64)riscv_pmu_ctr_read_csr(info.csr + 0x80)) << 31 | val;
>> +			val |= ((u64)riscv_pmu_ctr_read_csr(info.csr + 0x80)) << 32;
>>   	}
>>   
>>   	return val;
>> @@ -1135,6 +1147,9 @@ static int __init pmu_sbi_devinit(void)
>>   		return 0;
>>   	}
>>   
>> +	if (sbi_spec_version >= sbi_mk_version(2, 0))
>> +		sbi_v2_available = true;
>> +
>>   	ret = cpuhp_setup_state_multi(CPUHP_AP_PERF_RISCV_STARTING,
>>   				      "perf/riscv/pmu:starting",
>>   				      pmu_sbi_starting_cpu, pmu_sbi_dying_cpu);
>> -- 
>> 2.34.1
>>
> 
> Thanks,
> drew


