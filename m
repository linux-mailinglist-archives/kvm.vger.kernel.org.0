Return-Path: <kvm+bounces-21315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8078492D508
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 17:34:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 364111F2326D
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 15:34:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 782C4194A5E;
	Wed, 10 Jul 2024 15:34:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CED110A09;
	Wed, 10 Jul 2024 15:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720625663; cv=none; b=Hq+QXh5Qz+j2xXPbykz8gZ4884AD8fbxxso/eZupmBtZW+P9uAcKuu5mDsVOwGquMCtoxwZ8hupeWe0fRSQ1B03AlikNFMvXyPXeeNWzfMoa/Q/L59ZQhsKmPot0oqH2Tc7qZP8HlUQ7zXyPT4zpdTsUu5AWPhOvZgPje3gNJNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720625663; c=relaxed/simple;
	bh=/QJtzxMrG869X7Mr3TxWX75XthbFhEwegQXEjkb58Oc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YqmpV3s6W9zcjvdYC/aVXwa8B7Jg/loqMNm6a6dYdnIpmz3jLq81Xza92HKqt6UH25gvj8qB24kD5ny+O5S3L6I3cwKpkKGYfLnNutkwnu5L91o6oatjEjn9KxEYP60CBINzxRpdB/SsOC7OiejvuyNaim49Nf6FmO1EBeTwg6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0510B113E;
	Wed, 10 Jul 2024 08:34:46 -0700 (PDT)
Received: from [10.57.8.115] (unknown [10.57.8.115])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8CC303F766;
	Wed, 10 Jul 2024 08:34:15 -0700 (PDT)
Message-ID: <e28ea56b-112d-4b15-bac1-71536113bbc6@arm.com>
Date: Wed, 10 Jul 2024 16:34:12 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/15] firmware/psci: Add psci_early_test_conduit()
To: Will Deacon <will@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240701095505.165383-1-steven.price@arm.com>
 <20240701095505.165383-3-steven.price@arm.com>
 <20240709104851.GE12978@willie-the-truck>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <20240709104851.GE12978@willie-the-truck>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Will!

On 09/07/2024 11:48, Will Deacon wrote:
> On Mon, Jul 01, 2024 at 10:54:52AM +0100, Steven Price wrote:
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
>> index d9629ff87861..a40dcaf17822 100644
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
>> @@ -767,6 +768,30 @@ int __init psci_dt_init(void)
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
> Hmm, I don't think this is sufficient to check for SMCCC reliably.
> Instead, I think you need to do something more involved:
> 
> 1. Check for PSCI in the DT
> 2. Check that the PSCI major version is >= 1
> 3. Use PSCI_FEATURES to check that you have SMCCC
> 4. Use SMCCC_VERSION to find out which version of SMCCC you have
> 
> That's roughly what the PSCI driver does, so we should avoid duplicating
> that logic.

Hmm, you have a point. This was an improvement over the previous (assume
that making an SMC call is going to work well enough to return at error
for non-realms), but I guess it's technically possible for a system to
have PSCI but not implement enough of SMCCC to reliably get an error
code back.

Do you have any pointers on how pKVM detects it is a guest? Currently we
have a couple of things we have to do very early as a realm guest:

 * Mark memory as RIPAS_RAM. My preference would be to punt this problem
to the VMM (or UEFI) and make it a boot requirement. But it gets in the
way for attestation purposes as you can't have the same attestation
report for VMs which differ only by available RAM in that case.

 * earlycon - we need to know if the serial device is in unprotected
MMIO as that needs mapping with the top IPA bit set.

(I think that's all that's really early - everything else I can think of
should be after the usual PSCI probe should have happened)

Thanks for taking a look!

Steve

