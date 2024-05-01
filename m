Return-Path: <kvm+bounces-16349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E58E8B8C61
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 16:59:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF2D91C21911
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 14:59:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CAB3131733;
	Wed,  1 May 2024 14:56:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6287112F5AC;
	Wed,  1 May 2024 14:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714575398; cv=none; b=qYzUi71udQLDaDN3GtLkiye0k/a638D3F6gD6ZNDT21Kaf1HgeHDD9h+jsPgILFE3DO6UXjX+bOJQiQBCFUH717ctuDP/Gi0AoLO2udlhty10V4nz3vmLPYV0M7pNbWbQhcJ/RbCKww3C03OwQFXudJ3S2CP/3EeQEzunMO0oSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714575398; c=relaxed/simple;
	bh=p52p3F37XvyVfrfrsqWyEV0jgw7gj7LU4qdYq7WAN2o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gMycCskeuPq+65i2dpuGkCIOiWnmpIbaqHar+8POcAQXSKEfZVisPTqrNWQPKopW1HZT/Ht3120iT6vVxA8UQV3tjFssfgu7yLVc5sOLuQ9Mpgu9m2Z51pYYS5mkcsn+ofysynMv2Q9IVMgRcVAubqwJhSbZ23xfRa1Vt5gigiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 20F062F4;
	Wed,  1 May 2024 07:57:03 -0700 (PDT)
Received: from [10.57.82.68] (unknown [10.57.82.68])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B37333F793;
	Wed,  1 May 2024 07:56:34 -0700 (PDT)
Message-ID: <fcb0cd30-ba40-48d2-8ce1-c5aa1d36cd1f@arm.com>
Date: Wed, 1 May 2024 15:56:33 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 17/43] arm64: RME: Allow VMM to set RIPAS
Content-Language: en-GB
To: Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084309.1733783-1-steven.price@arm.com>
 <20240412084309.1733783-18-steven.price@arm.com>
 <20240501142712.GB484338@myrica>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20240501142712.GB484338@myrica>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01/05/2024 15:27, Jean-Philippe Brucker wrote:
> On Fri, Apr 12, 2024 at 09:42:43AM +0100, Steven Price wrote:
>> +static inline bool realm_is_addr_protected(struct realm *realm,
>> +					   unsigned long addr)
>> +{
>> +	unsigned int ia_bits = realm->ia_bits;
>> +
>> +	return !(addr & ~(BIT(ia_bits - 1) - 1));
> 
> Is it enough to return !(addr & BIT(realm->ia_bits - 1))?

I thought about that too. But if we are dealing with an IPA
that is > (BIT(realm->ia_bits)), we don't want to be treating
that as a protected address. This could only happen if the Realm
is buggy (or the VMM has tricked it). So the existing check
looks safer.

> 
>> +static void realm_unmap_range_shared(struct kvm *kvm,
>> +				     int level,
>> +				     unsigned long start,
>> +				     unsigned long end)
>> +{
>> +	struct realm *realm = &kvm->arch.realm;
>> +	unsigned long rd = virt_to_phys(realm->rd);
>> +	ssize_t map_size = rme_rtt_level_mapsize(level);
>> +	unsigned long next_addr, addr;
>> +	unsigned long shared_bit = BIT(realm->ia_bits - 1);
>> +
>> +	if (WARN_ON(level > RME_RTT_MAX_LEVEL))
>> +		return;
>> +
>> +	start |= shared_bit;
>> +	end |= shared_bit;
>> +
>> +	for (addr = start; addr < end; addr = next_addr) {
>> +		unsigned long align_addr = ALIGN(addr, map_size);
>> +		int ret;
>> +
>> +		next_addr = ALIGN(addr + 1, map_size);
>> +
>> +		if (align_addr != addr || next_addr > end) {
>> +			/* Need to recurse deeper */
>> +			if (addr < align_addr)
>> +				next_addr = align_addr;
>> +			realm_unmap_range_shared(kvm, level + 1, addr,
>> +						 min(next_addr, end));
>> +			continue;
>> +		}
>> +
>> +		ret = rmi_rtt_unmap_unprotected(rd, addr, level, &next_addr);
>> +		switch (RMI_RETURN_STATUS(ret)) {
>> +		case RMI_SUCCESS:
>> +			break;
>> +		case RMI_ERROR_RTT:
>> +			if (next_addr == addr) {
>> +				next_addr = ALIGN(addr + 1, map_size);
>> +				realm_unmap_range_shared(kvm, level + 1, addr,
>> +							 next_addr);
>> +			}
>> +			break;
>> +		default:
>> +			WARN_ON(1);
> 
> In this case we also need to return, because RMM returns with next_addr ==
> 0, causing an infinite loop. At the moment a VMM can trigger this easily
> by creating guest memfd before creating a RD, see below

Thats a good point. I agree.

> 
>> +		}
>> +	}
>> +}
>> +
>> +static void realm_unmap_range_private(struct kvm *kvm,
>> +				      unsigned long start,
>> +				      unsigned long end)
>> +{
>> +	struct realm *realm = &kvm->arch.realm;
>> +	ssize_t map_size = RME_PAGE_SIZE;
>> +	unsigned long next_addr, addr;
>> +
>> +	for (addr = start; addr < end; addr = next_addr) {
>> +		int ret;
>> +
>> +		next_addr = ALIGN(addr + 1, map_size);
>> +
>> +		ret = realm_destroy_protected(realm, addr, &next_addr);
>> +
>> +		if (WARN_ON(ret))
>> +			break;
>> +	}
>> +}
>> +
>> +static void realm_unmap_range(struct kvm *kvm,
>> +			      unsigned long start,
>> +			      unsigned long end,
>> +			      bool unmap_private)
>> +{
> 
> Should this check for a valid kvm->arch.realm.rd, or a valid realm state?
> I'm not sure what the best place is but none of the RMM calls will succeed
> if the RD is NULL, causing some WARNs.
> 
> I can trigger this with set_memory_attributes() ioctls before creating a
> RD for example.
> 

True, this could be triggered by a buggy VMM in other ways, and we could
easily gate it on the Realm state >= NEW.

Suzuki



