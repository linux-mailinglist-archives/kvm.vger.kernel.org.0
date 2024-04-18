Return-Path: <kvm+bounces-15087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 385088A9AFD
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 15:17:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E508928291C
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 13:17:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0979315F3FD;
	Thu, 18 Apr 2024 13:17:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 604E7EECF;
	Thu, 18 Apr 2024 13:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713446244; cv=none; b=SFukHRGE72Qavj1AtjHhf+d6CuRfGmFQU1j64MUs2W6vZc8ZhrT8szd78Rix7J2c4d9hGEAFbNU22qIGpiDu9j8z5WkwZKB90svSUwCYikK09NXTaJPchUcB6cUQoqCSYCoGlej62VCJ7t34cP7BO4O/kIaUSXsL5da8dD3Y/gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713446244; c=relaxed/simple;
	bh=JwQ6WKAgwkgGDjlwTjWbko4n+LA0bmKAxcEWpDK1XLo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C3Ul+Yi27QlK3zvrNijAVU+Jwc26HjMWxFpIQiwe1gcH9HT4X8YvPxKXKEJpPYRB/r0/llfj+lGpZ4GBwxS/zCYUaYgYLo6GxHyBYebWOTAm7kcUivsi/Kjsk7wB1o3OAP445/G3xxgudzzh+9RvoU6t+kMYH6jBts88Gxvx2F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 97EC8339;
	Thu, 18 Apr 2024 06:17:48 -0700 (PDT)
Received: from [10.1.35.34] (e122027.cambridge.arm.com [10.1.35.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DAEDF3F738;
	Thu, 18 Apr 2024 06:17:16 -0700 (PDT)
Message-ID: <f934c0ae-336a-4529-9eaa-71f69291dc71@arm.com>
Date: Thu, 18 Apr 2024 14:17:14 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/43] arm64: RME: Handle Granule Protection Faults
 (GPFs)
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084309.1733783-1-steven.price@arm.com>
 <20240412084309.1733783-5-steven.price@arm.com>
 <d452859e-8b35-4aac-83d5-5b8d44ed4406@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <d452859e-8b35-4aac-83d5-5b8d44ed4406@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 16/04/2024 12:17, Suzuki K Poulose wrote:
> On 12/04/2024 09:42, Steven Price wrote:
>> If the host attempts to access granules that have been delegated for use
>> in a realm these accesses will be caught and will trigger a Granule
>> Protection Fault (GPF).
>>
>> A fault during a page walk signals a bug in the kernel and is handled by
>> oopsing the kernel. A non-page walk fault could be caused by user space
>> having access to a page which has been delegated to the kernel and will
>> trigger a SIGBUS to allow debugging why user space is trying to access a
>> delegated page.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>   arch/arm64/mm/fault.c | 29 ++++++++++++++++++++++++-----
>>   1 file changed, 24 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
>> index 8251e2fea9c7..91da0f446dd9 100644
>> --- a/arch/arm64/mm/fault.c
>> +++ b/arch/arm64/mm/fault.c
>> @@ -765,6 +765,25 @@ static int do_tag_check_fault(unsigned long far,
>> unsigned long esr,
>>       return 0;
>>   }
>>   +static int do_gpf_ptw(unsigned long far, unsigned long esr, struct
>> pt_regs *regs)
>> +{
>> +    const struct fault_info *inf = esr_to_fault_info(esr);
>> +
>> +    die_kernel_fault(inf->name, far, esr, regs);
>> +    return 0;
>> +}
>> +
>> +static int do_gpf(unsigned long far, unsigned long esr, struct
>> pt_regs *regs)
>> +{
>> +    const struct fault_info *inf = esr_to_fault_info(esr);
>> +
>> +    if (!is_el1_instruction_abort(esr) && fixup_exception(regs))
>> +        return 0;
>> +
>> +    arm64_notify_die(inf->name, regs, inf->sig, inf->code, far, esr);
>> +    return 0;
>> +}
>> +
>>   static const struct fault_info fault_info[] = {
>>       { do_bad,        SIGKILL, SI_KERNEL,    "ttbr address size
>> fault"    },
>>       { do_bad,        SIGKILL, SI_KERNEL,    "level 1 address size
>> fault"    },
>> @@ -802,11 +821,11 @@ static const struct fault_info fault_info[] = {
>>       { do_alignment_fault,    SIGBUS,  BUS_ADRALN,    "alignment
>> fault"        },
>>       { do_bad,        SIGKILL, SI_KERNEL,    "unknown 34"            },
>>       { do_bad,        SIGKILL, SI_KERNEL,    "unknown 35"            },
> 
> Should this also be converted to do_gpf_ptw, "GPF at level -1", given we
> support LPA2 ?

Ah, yes I somehow missed that. Although something has gone majorly wrong
if this triggers! ;)

Steve

>> -    { do_bad,        SIGKILL, SI_KERNEL,    "unknown 36"            },
>> -    { do_bad,        SIGKILL, SI_KERNEL,    "unknown 37"            },
>> -    { do_bad,        SIGKILL, SI_KERNEL,    "unknown 38"            },
>> -    { do_bad,        SIGKILL, SI_KERNEL,    "unknown 39"            },
>> -    { do_bad,        SIGKILL, SI_KERNEL,    "unknown 40"            },
>> +    { do_gpf_ptw,        SIGKILL, SI_KERNEL,    "Granule Protection
>> Fault at level 0" },
>> +    { do_gpf_ptw,        SIGKILL, SI_KERNEL,    "Granule Protection
>> Fault at level 1" },
>> +    { do_gpf_ptw,        SIGKILL, SI_KERNEL,    "Granule Protection
>> Fault at level 2" },
>> +    { do_gpf_ptw,        SIGKILL, SI_KERNEL,    "Granule Protection
>> Fault at level 3" },
>> +    { do_gpf,        SIGBUS,  SI_KERNEL,    "Granule Protection Fault
>> not on table walk" },
>>       { do_bad,        SIGKILL, SI_KERNEL,    "level -1 address size
>> fault"    },
>>       { do_bad,        SIGKILL, SI_KERNEL,    "unknown 42"            },
>>       { do_translation_fault,    SIGSEGV, SEGV_MAPERR,    "level -1
>> translation fault"    },
> 
> 
> Rest looks fine to me.
> 
> Suzuki


