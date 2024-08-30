Return-Path: <kvm+bounces-25545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A156B966632
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 17:56:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B22F71C20C36
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 15:56:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB6921B790A;
	Fri, 30 Aug 2024 15:55:03 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBB391B9B5B;
	Fri, 30 Aug 2024 15:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725033303; cv=none; b=ijSzfF1wcjBe+4kVJxj3q+0i+Ix1amOHhi4vWjL5E6NOmo+LqVmQACBo04P3fTLtrSgeFiRp5nyskmwARHblIRM8o+PwNIttl4sofDytHVVtMb6BIpekRjCCXgpaoBiJ2M4zhNdffUTqcS5Fynro9NC4905Z0decAbeljEHu//M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725033303; c=relaxed/simple;
	bh=8nPUBbYoUtNAT80wKKkWO+YB8VEQnVa8FilYwX9Bjfg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hAsmKsWeIqoeRBljpE2FFayG9Ytxmw6dbJYg34rsTwG0pWW5T3lMQkDz48Vju49jVSXTaJC4JJtM7WJwLj9ZhpZq8RoM1MBdWQMsmG9tSS2e83brasyUQd8IaspVsFwvChUx4qYD40AwVRUquWG3jSf5iPmm2gJz8iCtwJIsGHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7194B1063;
	Fri, 30 Aug 2024 08:55:26 -0700 (PDT)
Received: from [10.1.30.22] (e122027.cambridge.arm.com [10.1.30.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7C38F3F762;
	Fri, 30 Aug 2024 08:54:56 -0700 (PDT)
Message-ID: <5dfccae9-58c3-4159-b1df-1b783e513dfa@arm.com>
Date: Fri, 30 Aug 2024 16:54:49 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/19] firmware/psci: Add psci_early_test_conduit()
To: Will Deacon <will@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-5-steven.price@arm.com>
 <20240823132918.GD32156@willie-the-truck>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <20240823132918.GD32156@willie-the-truck>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 23/08/2024 14:29, Will Deacon wrote:
> On Mon, Aug 19, 2024 at 02:19:09PM +0100, Steven Price wrote:
>> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
>>
>> Add a function to test early if PSCI is present and what conduit it
>> uses. Because the PSCI conduit corresponds to the SMCCC one, this will
>> let the kernel know whether it can use SMC instructions to discuss with
>> the Realm Management Monitor (RMM), early enough to enable RAM and
>> serial access when running in a Realm.
>>
>> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> v4: New patch
>> ---
>>  drivers/firmware/psci/psci.c | 25 +++++++++++++++++++++++++
>>  include/linux/psci.h         |  5 +++++
>>  2 files changed, 30 insertions(+)
>>
>> diff --git a/drivers/firmware/psci/psci.c b/drivers/firmware/psci/psci.c
>> index 2328ca58bba6..2b308f97ef2c 100644
>> --- a/drivers/firmware/psci/psci.c
>> +++ b/drivers/firmware/psci/psci.c
>> @@ -13,6 +13,7 @@
>>  #include <linux/errno.h>
>>  #include <linux/linkage.h>
>>  #include <linux/of.h>
>> +#include <linux/of_fdt.h>
>>  #include <linux/pm.h>
>>  #include <linux/printk.h>
>>  #include <linux/psci.h>
>> @@ -769,6 +770,30 @@ int __init psci_dt_init(void)
>>  	return ret;
>>  }
>>  
>> +/*
>> + * Test early if PSCI is supported, and if its conduit matches @conduit
>> + */
>> +bool __init psci_early_test_conduit(enum arm_smccc_conduit conduit)
>> +{
>> +	int len;
>> +	int psci_node;
>> +	const char *method;
>> +	unsigned long dt_root;
>> +
>> +	/* DT hasn't been unflattened yet, we have to work with the flat blob */
>> +	dt_root = of_get_flat_dt_root();
>> +	psci_node = of_get_flat_dt_subnode_by_name(dt_root, "psci");
>> +	if (psci_node <= 0)
>> +		return false;
>> +
>> +	method = of_get_flat_dt_prop(psci_node, "method", &len);
>> +	if (!method)
>> +		return false;
>> +
>> +	return  (conduit == SMCCC_CONDUIT_SMC && strncmp(method, "smc", len) == 0) ||
>> +		(conduit == SMCCC_CONDUIT_HVC && strncmp(method, "hvc", len) == 0);
>> +}
> 
> This still looks incomplete to me as per my earlier comments:
> 
> https://lore.kernel.org/all/20240709104851.GE12978@willie-the-truck/
> 
> For the first implementation, can we punt the RIPAS_RAM to the bootloader
> and drop support for earlycon? Even if we manage to shoe-horn enough code
> into the early boot path, I think we'll regret it later on because there's
> always something that wants to be first and it inevitably ends up being
> a nightmare to maintain.

Short-answer: yes, although it has drawbacks.

I've never been keen on the RIPAS_RAM requirement, the logic behind it
is that it makes it easier to have varying amounts of RAM given to the
guest without affecting the attestation. But it's a weak argument and
I'd personally prefer to punt the responsibility to a bootloader/VMM.

earlycon should be fairly easy to remove - and it doesn't have to
actually kill earlycon because we can pass in the address with the top
bit set - it just requires fixing up the VMM.

EFI is the main issue.

I'll have a go at coming up with a cut down series - at the very least
I'll see if I can rearrange to have the troublesome parts at the end so
they can be dropped if necessary.

Steve


