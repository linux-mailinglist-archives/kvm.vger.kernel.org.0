Return-Path: <kvm+bounces-25542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6747796662C
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 17:55:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D47A5B22DFB
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 15:55:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8935B1B790D;
	Fri, 30 Aug 2024 15:54:52 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B5C61B6558;
	Fri, 30 Aug 2024 15:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725033292; cv=none; b=VKO/k9LvImOeI5zgPuRiNUQjilwboBMmdGT9x6fiQ8ag6QKP1EXoD7Wf1ZqxXhB5P3ygWhVAghOdNsJb6Avd/bWjhw78tLP6hKVv89ZrUDHjMtycCNq2gyAKg/GmXUrnlS+snH+L7HSO7vGDfTNKwlzPD8JIW6K3C/oQLvzOXLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725033292; c=relaxed/simple;
	bh=RhTIzyvlvUjOM/TDuhq57upaMaC1n7ZRsS3E3E7lMcQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OmfEKyTVD0FAfOtGedjAjFy8W3k2LLmV/uwLVBr0EUH+c77eXVL58mIaN1E8gNyNxxeTt+nJGZm1y6GLnLK7/j4hzLiXnd3mawZjrUW4oI12Dpol/ZPeWOudMVMP1iWjBMkDyS77igiwYN0B4ijkSqbyeSTKJLIyrqlMlOICxkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C59C11063;
	Fri, 30 Aug 2024 08:55:14 -0700 (PDT)
Received: from [10.1.30.22] (e122027.cambridge.arm.com [10.1.30.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 543CC3F762;
	Fri, 30 Aug 2024 08:54:45 -0700 (PDT)
Message-ID: <2e8caa91-bf66-4555-87b3-52f469b2c7ef@arm.com>
Date: Fri, 30 Aug 2024 16:54:43 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/19] arm64: Detect if in a realm and set RIPAS RAM
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
 Alper Gun <alpergun@google.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-6-steven.price@arm.com> <ZsxTDBm57ga6MkPu@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <ZsxTDBm57ga6MkPu@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 26/08/2024 11:03, Catalin Marinas wrote:
> On Mon, Aug 19, 2024 at 02:19:10PM +0100, Steven Price wrote:
>> +static bool rsi_version_matches(void)
>> +{
>> +	unsigned long ver_lower, ver_higher;
>> +	unsigned long ret = rsi_request_version(RSI_ABI_VERSION,
>> +						&ver_lower,
>> +						&ver_higher);
>> +
>> +	if (ret == SMCCC_RET_NOT_SUPPORTED)
>> +		return false;
>> +
>> +	if (ret != RSI_SUCCESS) {
>> +		pr_err("RME: RMM doesn't support RSI version %lu.%lu. Supported range: %lu.%lu-%lu.%lu\n",
>> +		       RSI_ABI_VERSION_MAJOR, RSI_ABI_VERSION_MINOR,
>> +		       RSI_ABI_VERSION_GET_MAJOR(ver_lower),
>> +		       RSI_ABI_VERSION_GET_MINOR(ver_lower),
>> +		       RSI_ABI_VERSION_GET_MAJOR(ver_higher),
>> +		       RSI_ABI_VERSION_GET_MINOR(ver_higher));
>> +		return false;
>> +	}
>> +
>> +	pr_info("RME: Using RSI version %lu.%lu\n",
>> +		RSI_ABI_VERSION_GET_MAJOR(ver_lower),
>> +		RSI_ABI_VERSION_GET_MINOR(ver_lower));
>> +
>> +	return true;
>> +}
> 
> I don't have the spec at hand now (on a plane) but given the possibility
> of a 1.0 guest regressing on later RMM versions, I wonder whether we
> should simply bail out if it's not an exact version match. I forgot what
> the spec says about returned ranges (they were pretty confusing last
> time I checked).

Well the idea at least is that the RMM can tell us that it is providing
a 1.0 compatible interface. So it might be supporting 1.x but it's
promising that what it's providing is 1.0 compatible.

Indeed the spec allows the RMM to emulate 1.0 while supporting a higher
(incompatible) interface as well - which is where the version ranges
come in. So in the future we might negotiate versions with the RMM, or
opportunistically use newer features if the RMM provides them. But
obviously for now the guest is only 1.0.

I'd prefer not to add an exact version match because then upgrading the
RMM would break existing guests and would probably lead to pressure for
the RMM to simply lie to guests to avoid them breaking on upgrade.

>> +
>> +void __init arm64_rsi_setup_memory(void)
>> +{
>> +	u64 i;
>> +	phys_addr_t start, end;
>> +
>> +	if (!is_realm_world())
>> +		return;
>> +
>> +	/*
>> +	 * Iterate over the available memory ranges and convert the state to
>> +	 * protected memory. We should take extra care to ensure that we DO NOT
>> +	 * permit any "DESTROYED" pages to be converted to "RAM".
>> +	 *
>> +	 * BUG_ON is used because if the attempt to switch the memory to
>> +	 * protected has failed here, then future accesses to the memory are
>> +	 * simply going to be reflected as a SEA (Synchronous External Abort)
>> +	 * which we can't handle.  Bailing out early prevents the guest limping
>> +	 * on and dying later.
>> +	 */
>> +	for_each_mem_range(i, &start, &end) {
>> +		BUG_ON(rsi_set_memory_range_protected_safe(start, end));
>> +	}
> 
> Would it help debugging if we print the memory ranges as well rather
> than just a BUG_ON()?
> 

Yes that would probably be useful - I'll fix that.

Thanks,
Steve


