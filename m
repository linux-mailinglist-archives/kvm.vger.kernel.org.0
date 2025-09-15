Return-Path: <kvm+bounces-57537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C400B57745
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 12:55:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 95647189E4A4
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 10:56:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2317C2FDC28;
	Mon, 15 Sep 2025 10:55:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E592F2D77E4;
	Mon, 15 Sep 2025 10:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757933732; cv=none; b=RzpXfDa5KGmbE+MdI254qF6p1xe6c5xn46skCHQ5ESPLm5VV+FeE2fqPAs+4WlBOMiFkPLZRX2uOYCe6RWNrqaloJDAqV91G6jvWTaoY2NoXtk40r4cC0+mJTzyJQnD34oKd7Ih0TVFs35j6h80E28fWyFnWsQlCn3MjiMbp7hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757933732; c=relaxed/simple;
	bh=b2mf4Z3CF2NmHVs2TZP+YQo6OPUtx5t0zbzVahIcsKk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bMSrZkYj2jwWP8a2d/vwsmVtQqlbr4dImrlQVhOWH1o2hdTkKwmWaWm+3HEdK8zCtvikYKQc5N9DsyL+D94P5ljQQ0ms5DvIEjq8wwLTaOmEgYfa9ifV0Rfjaw2pfNoAPpF3PvPHNoFnfvh6Il1zjhCEfdh9/MUDLaWEk3adKVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 020F21BF7;
	Mon, 15 Sep 2025 03:55:22 -0700 (PDT)
Received: from [10.57.5.5] (unknown [10.57.5.5])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E6C5D3F694;
	Mon, 15 Sep 2025 03:55:24 -0700 (PDT)
Message-ID: <bc17ddc9-ed9d-4d51-93f4-784a73036e7c@arm.com>
Date: Mon, 15 Sep 2025 11:55:22 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 02/43] arm64: RME: Handle Granule Protection Faults
 (GPFs)
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Marc Zyngier
 <maz@kernel.org>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20250820145606.180644-1-steven.price@arm.com>
 <20250820145606.180644-3-steven.price@arm.com> <aLGRNc5u1EPlCpyb@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <aLGRNc5u1EPlCpyb@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 29/08/2025 12:38, Catalin Marinas wrote:
> On Wed, Aug 20, 2025 at 03:55:22PM +0100, Steven Price wrote:
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
>> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v2:
>>  * Include missing "Granule Protection Fault at level -1"
>> ---
>>  arch/arm64/mm/fault.c | 31 +++++++++++++++++++++++++------
>>  1 file changed, 25 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
>> index d816ff44faff..e4237637cd8f 100644
>> --- a/arch/arm64/mm/fault.c
>> +++ b/arch/arm64/mm/fault.c
>> @@ -854,6 +854,25 @@ static int do_tag_check_fault(unsigned long far, unsigned long esr,
>>  	return 0;
>>  }
>>  
>> +static int do_gpf_ptw(unsigned long far, unsigned long esr, struct pt_regs *regs)
>> +{
>> +	const struct fault_info *inf = esr_to_fault_info(esr);
>> +
>> +	die_kernel_fault(inf->name, far, esr, regs);
>> +	return 0;
>> +}
> 
> This is fine, it's irrelevant whether the fault happened at EL0 or EL1.
> 
>> +static int do_gpf(unsigned long far, unsigned long esr, struct pt_regs *regs)
>> +{
>> +	const struct fault_info *inf = esr_to_fault_info(esr);
>> +
>> +	if (!is_el1_instruction_abort(esr) && fixup_exception(regs, esr))
>> +		return 0;
>> +
>> +	arm64_notify_die(inf->name, regs, inf->sig, inf->code, far, esr);
>> +	return 0;
>> +}
> 
> The end result is somewhat similar but why not just return 1 and avoid
> the arm64_notify_die() call? Let do_mem_abort() handle the oops vs user
> signal. With die_kernel_fault() we print the "Unable to handle
> kernel..." message and some more information.
> 

Yes, that makes sense - something has gone very wrong if the kernel hits
a GPF but that's no reason not to output a (more) useful message.

Thanks,
Steve

