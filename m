Return-Path: <kvm+bounces-17422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E2CC8C6519
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 12:47:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0C9B1C21A67
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 10:47:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD06F5FDD2;
	Wed, 15 May 2024 10:47:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE6D55BAC1;
	Wed, 15 May 2024 10:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715770030; cv=none; b=kFFOFMeYIx1F1YN4Mxt2ab+Erqwk+nhWJMGi+/RSi0UgGatCGfrHNEyeMzTV7nXrdrNICTQCAm5LFLVyNRa6eiMtTPLMfV08YtUpmdbtXj0ySsN2kjkZmNozaen2PF3/ryiatvPPTQhTe+p+xHcDSZ0znoKPkTX/AzamDNttiXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715770030; c=relaxed/simple;
	bh=b3y5whTeAcmp89mTXqOWni8G/ArxQa2txC/ezT9ZwVw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f3OkIH4pW/LvpTALZzypl44MOFv2ci6r+tqsBxAlmIzv/OEOp05incjYMgwK8YpTu/Oslo41cm321t18TVUmC29n6JCP9/xvpAjMvbDOO3P35BW1Ryp7UCXsPKPHydXNnV3Os7DSA4nFF3KrLmzzh7LyOwXLU+Tes/99rKO7imk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 883151042;
	Wed, 15 May 2024 03:47:31 -0700 (PDT)
Received: from [10.57.34.212] (unknown [10.57.34.212])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6A35D3F762;
	Wed, 15 May 2024 03:47:04 -0700 (PDT)
Message-ID: <5b2db977-7f0f-4c3a-b278-f195c7ddbd80@arm.com>
Date: Wed, 15 May 2024 11:47:02 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/14] arm64: Enable memory encrypt for Realms
Content-Language: en-GB
To: Catalin Marinas <catalin.marinas@arm.com>,
 Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Marc Zyngier
 <maz@kernel.org>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240412084213.1733764-1-steven.price@arm.com>
 <20240412084213.1733764-10-steven.price@arm.com> <ZkOmrMIMFCgEKuVw@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <ZkOmrMIMFCgEKuVw@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14/05/2024 19:00, Catalin Marinas wrote:
> On Fri, Apr 12, 2024 at 09:42:08AM +0100, Steven Price wrote:
>>   static int change_page_range(pte_t *ptep, unsigned long addr, void *data)
>> @@ -41,6 +45,7 @@ static int change_page_range(pte_t *ptep, unsigned long addr, void *data)
>>   	pte = clear_pte_bit(pte, cdata->clear_mask);
>>   	pte = set_pte_bit(pte, cdata->set_mask);
>>   
>> +	/* TODO: Break before make for PROT_NS_SHARED updates */
>>   	__set_pte(ptep, pte);
>>   	return 0;
> 
> Oh, this TODO is problematic, not sure we can do it safely. There are
> some patches on the list to trap faults from other CPUs if they happen
> to access the page when broken but so far we pushed back as complex and
> at risk of getting the logic wrong.
> 
>  From an architecture perspective, you are changing the output address
> and D8.16.1 requires a break-before-make sequence (FEAT_BBM doesn't
> help). So we either come up with a way to do BMM safely (stop_machine()
> maybe if it's not too expensive or some way to guarantee no accesses to
> this page while being changed) or we get the architecture clarified on
> the possible side-effects here ("unpredictable" doesn't help).

Thanks, we need to sort this out.


> 
>>   }
>> @@ -192,6 +197,43 @@ int set_direct_map_default_noflush(struct page *page)
>>   				   PAGE_SIZE, change_page_range, &data);
>>   }
>>   
>> +static int __set_memory_encrypted(unsigned long addr,
>> +				  int numpages,
>> +				  bool encrypt)
>> +{
>> +	unsigned long set_prot = 0, clear_prot = 0;
>> +	phys_addr_t start, end;
>> +
>> +	if (!is_realm_world())
>> +		return 0;
>> +
>> +	WARN_ON(!__is_lm_address(addr));
> 
> Just return from this function if it's not a linear map address. No
> point in corrupting other areas since __virt_to_phys() will get it
> wrong.
> 
>> +	start = __virt_to_phys(addr);
>> +	end = start + numpages * PAGE_SIZE;
>> +
>> +	if (encrypt) {
>> +		clear_prot = PROT_NS_SHARED;
>> +		set_memory_range_protected(start, end);
>> +	} else {
>> +		set_prot = PROT_NS_SHARED;
>> +		set_memory_range_shared(start, end);
>> +	}
>> +
>> +	return __change_memory_common(addr, PAGE_SIZE * numpages,
>> +				      __pgprot(set_prot),
>> +				      __pgprot(clear_prot));
>> +}
> 
> Can someone summarise what the point of this protection bit is? The IPA
> memory is marked as protected/unprotected already via the RSI call and
> presumably the RMM disables/permits sharing with a non-secure hypervisor
> accordingly irrespective of which alias the realm guest has the linear
> mapping mapped to. What does it do with the top bit of the IPA? Is it
> that the RMM will prevent (via Stage 2) access if the IPA does not match
> the requested protection? IOW, it unmaps one or the other at Stage 2?

The Realm's IPA space is split in half. The lower half is "protected"
and all pages backing the "protected" IPA is in the Realm world and
thus cannot be shared with the hypervisor. The upper half IPA is
"unprotected" (backed by Non-secure PAS pages) and can be accessed
by the Host/hyp.

The RSI call (RSI_IPA_STATE_SET) doesn't make an IPA unprotected. It
simply "invalidates" a (protected) IPA to "EMPTY" implying the Realm 
doesn't intend to use the "ipa" as RAM anymore and any access to it from
the Realm would trigger an SEA into the Realm. The RSI call triggers an 
exit to the host with the information and is a hint to the hypervisor to 
reclaim the page backing the IPA.

Now, given we need dynamic "sharing" of pages (instead of a dedicated
set of shared pages), "aliasing" of an IPA gives us shared pages.
i.e., If OS wants to share a page "x" (protected IPA) with the host,
we mark that as EMPTY via RSI call and then access the "x" with top-bit
set (aliasing the IPA x). This fault allows the hyp to map the page 
backing IPA "x" as "unprotected" at ALIAS(x) address.

Thus we treat the "top" bit as an attribute in the Realm.

> 
> Also, the linear map is not the only one that points to this IPA. What
> if this is a buffer mapped in user-space or remapped as non-cacheable
> (upgraded to cacheable via FWB) in the kernel, the code above does not
> (and cannot) change the user mappings.
> 
> It needs some digging into dma_direct_alloc() as well, it uses a
> pgprot_decrypted() but that's not implemented by your patches. Not sure
> it helps, it looks like the remap path in this function does not have a
> dma_set_decrypted() call (or maybe I missed it).

Good point. Will take a look.

Suzuki



