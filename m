Return-Path: <kvm+bounces-20609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ABC6891A943
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 16:34:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B71B1F237DA
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2024 14:34:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BB03196D80;
	Thu, 27 Jun 2024 14:34:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDAA2195FE5;
	Thu, 27 Jun 2024 14:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719498863; cv=none; b=OYRebVG2BmaJJZvl0ecFSzwx5eybuN4SRocV2bNDcTF0/1/og6h39R69DNx3ORPOgKjGhWS1N2GtVgfXg0G44jV3qYT9sViSb3mOqig3XH+qUVoKVA6inF58jAGmxs6947+N7D2B/cB76d5iSsvaLH4Ak2kL9/vfQ0j7KxyigIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719498863; c=relaxed/simple;
	bh=SNPLIFy25DnsBocLv7ze4vOuSndICqg9Fn7HH+IoD7k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hHwUPlqh6AIVUmaOEzzMYxjzAf2zpiR54BEoG6VYio/zgxQzfE1ZHlOom1jyEg5QtdJwheROP//ps7F2UE6cdb4BNga3eEq3j5eN0DGt0BzTrSOcRmcUPeCpzebte0yqf0M/tQ3rkajoDIWO3Y7UaNMBT89f8IkBWgOMaF/BgRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0DD6E367;
	Thu, 27 Jun 2024 07:34:46 -0700 (PDT)
Received: from [10.1.30.72] (e122027.cambridge.arm.com [10.1.30.72])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 95F9A3F73B;
	Thu, 27 Jun 2024 07:34:17 -0700 (PDT)
Message-ID: <e55c8490-4342-4ef4-9d18-23c3dc3a526f@arm.com>
Date: Thu, 27 Jun 2024 15:34:15 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/14] arm64: Enable memory encrypt for Realms
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240605093006.145492-1-steven.price@arm.com>
 <20240605093006.145492-10-steven.price@arm.com> <Zmc3euO2YGh-g9Th@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <Zmc3euO2YGh-g9Th@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/06/2024 18:27, Catalin Marinas wrote:
> On Wed, Jun 05, 2024 at 10:30:01AM +0100, Steven Price wrote:
>> +static int __set_memory_encrypted(unsigned long addr,
>> +				  int numpages,
>> +				  bool encrypt)
>> +{
>> +	unsigned long set_prot = 0, clear_prot = 0;
>> +	phys_addr_t start, end;
>> +	int ret;
>> +
>> +	if (!is_realm_world())
>> +		return 0;
>> +
>> +	if (!__is_lm_address(addr))
>> +		return -EINVAL;
>> +
>> +	start = __virt_to_phys(addr);
>> +	end = start + numpages * PAGE_SIZE;
>> +
>> +	/*
>> +	 * Break the mapping before we make any changes to avoid stale TLB
>> +	 * entries or Synchronous External Aborts caused by RIPAS_EMPTY
>> +	 */
>> +	ret = __change_memory_common(addr, PAGE_SIZE * numpages,
>> +				     __pgprot(0),
>> +				     __pgprot(PTE_VALID));
>> +
>> +	if (encrypt) {
>> +		clear_prot = PROT_NS_SHARED;
>> +		ret = rsi_set_memory_range_protected(start, end);
>> +	} else {
>> +		set_prot = PROT_NS_SHARED;
>> +		ret = rsi_set_memory_range_shared(start, end);
>> +	}
>> +
>> +	if (ret)
>> +		return ret;
>> +
>> +	set_prot |= PTE_VALID;
>> +
>> +	return __change_memory_common(addr, PAGE_SIZE * numpages,
>> +				      __pgprot(set_prot),
>> +				      __pgprot(clear_prot));
>> +}
> 
> This works, does break-before-make and also rejects vmalloc() ranges
> (for the time being).
> 
> One particular aspect I don't like is doing the TLBI twice. It's
> sufficient to do it when you first make the pte invalid. We could guess
> this in __change_memory_common() if set_mask has PTE_VALID. The call
> sites are restricted to this file, just add a comment. An alternative
> would be to add a bool flush argument to this function.
> 

I'm always a bit scared of changing this sort of thing, but AFAICT the 
below should be safe:

-       flush_tlb_kernel_range(start, start + size);
+       /*
+        * If the memory is being made valid without changing any other bits
+        * then a TLBI isn't required as a non-valid entry cannot be cached in
+        * the TLB.
+        */
+       if (set_mask != PTE_VALID || clear_mask)
+               flush_tlb_kernel_range(start, start + size);

It will affect users of set_memory_valid() by removing the TLBI when 
marking memory as valid.

I'll add this change as a separate patch so it can be reverted easily
if there's something I've overlooked.

Thanks,
Steve


