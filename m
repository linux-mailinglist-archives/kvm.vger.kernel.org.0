Return-Path: <kvm+bounces-17968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B63F8CC47E
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 17:52:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E204A1F2271A
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 15:52:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7FD6210EC;
	Wed, 22 May 2024 15:52:48 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEA0022EEF;
	Wed, 22 May 2024 15:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716393168; cv=none; b=VVXyLGVSaYLWRfCOGMfnEpFk2gIEE5euyaB8HZ00DLA3GHxVmT1rAPDugWSnh/QuhAWP/3FhQXBhhKatg3xN3oZJC5I32BUeaUz6fxVRsshikLc1FRK40kwtP22rXlWbdU8dNbWUTXtkc4CZ9GCkkyfZxp0alO90meyPT8+cXew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716393168; c=relaxed/simple;
	bh=qomkeV47ofGNKX2qxIYOG8pKPZ+HtOWd2vxGJO/oq9I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QhOr5kcXS36YSXJmisb7FEB68zDusRC+Q4hMs3llCkpL5rWuliE5PPaNrgKs0ybs03zEsZJWQAmJ4YabxiWJrk8RNIPGbIft9Z8csiw2fT238iSs0A8gY9Q9y/s4gRp1B2XRzcxzL9TDXa/EGp7hWuR3gUV+hPtFhZAgrLpR8lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0FC60339;
	Wed, 22 May 2024 08:53:09 -0700 (PDT)
Received: from [10.57.35.73] (unknown [10.57.35.73])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B985F3F766;
	Wed, 22 May 2024 08:52:41 -0700 (PDT)
Message-ID: <74011ac1-34e0-4ee3-a00d-f78ad334fce2@arm.com>
Date: Wed, 22 May 2024 16:52:45 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/14] arm64: realm: Support nonsecure ITS emulation
 shared
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
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240412084213.1733764-1-steven.price@arm.com>
 <20240412084213.1733764-13-steven.price@arm.com> <ZkSV7Z8QFQYLETzD@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <ZkSV7Z8QFQYLETzD@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 15/05/2024 12:01, Catalin Marinas wrote:
> On Fri, Apr 12, 2024 at 09:42:11AM +0100, Steven Price wrote:
>> @@ -198,6 +201,33 @@ static DEFINE_IDA(its_vpeid_ida);
>>  #define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
>>  #define gic_data_rdist_vlpi_base()	(gic_data_rdist_rd_base() + SZ_128K)
>>  
>> +static struct page *its_alloc_shared_pages_node(int node, gfp_t gfp,
>> +						unsigned int order)
>> +{
>> +	struct page *page;
>> +
>> +	if (node == NUMA_NO_NODE)
>> +		page = alloc_pages(gfp, order);
>> +	else
>> +		page = alloc_pages_node(node, gfp, order);
> 
> I think you can just call alloc_pages_node() in both cases. This
> function takes care of the NUMA_NO_NODE case itself.
> 
>> +
>> +	if (page)
>> +		set_memory_decrypted((unsigned long)page_address(page),
>> +				     1 << order);
>> +	return page;
>> +}
>> +
>> +static struct page *its_alloc_shared_pages(gfp_t gfp, unsigned int order)
>> +{
>> +	return its_alloc_shared_pages_node(NUMA_NO_NODE, gfp, order);
>> +}
>> +
>> +static void its_free_shared_pages(void *addr, unsigned int order)
>> +{
>> +	set_memory_encrypted((unsigned long)addr, 1 << order);
>> +	free_pages((unsigned long)addr, order);
>> +}
> 
> More of a nitpick on the naming: Are these functions used by the host as
> well? The 'shared' part of the name does not make much sense, so maybe
> just call them its_alloc_page() etc.

Yes, the host is emulating this so the pages need to be in the shared
region. However this is only for realms, for a normal guest this
functions obviously aren't "sharing" with anything - so perhaps dropping
the 'shared' part makes sense.

>> @@ -3432,7 +3468,16 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
>>  	nr_ites = max(2, nvecs);
>>  	sz = nr_ites * (FIELD_GET(GITS_TYPER_ITT_ENTRY_SIZE, its->typer) + 1);
>>  	sz = max(sz, ITS_ITT_ALIGN) + ITS_ITT_ALIGN - 1;
>> -	itt = kzalloc_node(sz, GFP_KERNEL, its->numa_node);
>> +	itt_order = get_order(sz);
>> +	page = its_alloc_shared_pages_node(its->numa_node,
>> +					   GFP_KERNEL | __GFP_ZERO,
>> +					   itt_order);
> 
> How much do we waste by going for a full page always if this is going to
> be used on the host?

sz is a minimum of ITS_ITT_ALIGN*2-1 - which is 511 bytes. So
potentially PAGE_SIZE-512 bytes could be wasted here (minus kmalloc
overhead).

>> +	if (!page)
>> +		return NULL;
>> +	itt = (void *)page_address(page);
> 
> page_address() has the void * type already.
> 

Indeed, the cast is pointless. I'll remove.

Thanks,

Steve


