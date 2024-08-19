Return-Path: <kvm+bounces-24558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 624CE95775B
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 00:20:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 200BB282738
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 22:20:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABB3A1DD394;
	Mon, 19 Aug 2024 22:19:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D95C71DB449;
	Mon, 19 Aug 2024 22:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724105999; cv=none; b=eQdN0DgH27vJaRULVHxVZB/wmSZCCYs71q3aZ+QOSAlI2OZ388XYbr7hzTZ5EZceeY2dO29cHkBnULf5XY3DoJhTHlWgh1qMloc1yBug995GGcfsY6oXl63NueSy6Nble5tKwN9R+hQYmg4meNuBIfupnFZcQfhVE3Htp2ImS8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724105999; c=relaxed/simple;
	bh=yG1zQUbI2Ajj4i85UdepG+N4h7adB4AVz6eU8zpAAkk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ffqyVFsjBh9vQ4PhUD58No/P05M8lnbx939CN+SxzLxKjrtdl92pzfz2qf99JIyaNfSrDmB56elXmC7fypD24cndHWMlmQ0tGO0N9qZz0KSyA6ONxU663ysEdZbzajPw+0df10ggZyGQXGB3qwtwhGDXaGnCRXaPXE1MQduUmwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1B1A6339;
	Mon, 19 Aug 2024 15:20:22 -0700 (PDT)
Received: from [10.57.70.210] (unknown [10.57.70.210])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 02B683F58B;
	Mon, 19 Aug 2024 15:19:52 -0700 (PDT)
Message-ID: <dccfad5a-cda8-436b-87c9-b588cf790e86@arm.com>
Date: Mon, 19 Aug 2024 23:19:51 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 17/19] irqchip/gic-v3-its: Share ITS tables with a
 non-trusted hypervisor
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>
Cc: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-18-steven.price@arm.com>
 <beff9162-e1ba-4f72-91ea-329eaed48dbc@arm.com> <86y14sy1qo.wl-maz@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <86y14sy1qo.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Marc

On 19/08/2024 16:24, Marc Zyngier wrote:
> On Mon, 19 Aug 2024 15:51:00 +0100,
> Suzuki K Poulose <suzuki.poulose@arm.com> wrote:
>>
>> Hi Steven,
>>
>> On 19/08/2024 14:19, Steven Price wrote:
>>> Within a realm guest the ITS is emulated by the host. This means the
>>> allocations must have been made available to the host by a call to
>>> set_memory_decrypted(). Introduce an allocation function which performs
>>> this extra call.
>>>
>>> For the ITT use a custom genpool-based allocator that calls
>>> set_memory_decrypted() for each page allocated, but then suballocates
>>> the size needed for each ITT. Note that there is no mechanism
>>> implemented to return pages from the genpool, but it is unlikely the
>>> peak number of devices will so much larger than the normal level - so
>>> this isn't expected to be an issue.
>>>
>>
>> This may not be sufficient to make it future proof. We need to detect if
>> the GIC is private vs shared, before we make the allocation
>> choice. Please see below :
> 
> What do you mean by that? Do you foresee a *GICv3* implementation on
> the realm side?

No, but it may be emulated in the Realm World (by a higher privileged 
component, with future RMM versions with Planes - Plane0) and this
"Realm guest" may run in a lesser privileged plane and must use
"protected" accesses to make sure the accesses are seen by the "Realm
world" emulator.

> 
> [...]
> 
>> How about something like this folded into this patch ? Or if this
>> patch goes in independently, we could carry the following as part of
>> the CCA
>> series.
>>
>> diff --git a/drivers/irqchip/irq-gic-v3-its.c
>> b/drivers/irqchip/irq-gic-v3-its.c
>> index 6f4ddf7faed1..f1a779b52210 100644
>> --- a/drivers/irqchip/irq-gic-v3-its.c
>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>> @@ -209,7 +209,7 @@ static struct page *its_alloc_pages_node(int node,
>> gfp_t gfp,
>>
>>   	page = alloc_pages_node(node, gfp, order);
>>
>> -	if (page)
>> +	if (gic_rdists->is_shared && page)
>>   		set_memory_decrypted((unsigned long)page_address(page),
>>   				     BIT(order));
>>   	return page;
>> @@ -222,7 +222,8 @@ static struct page *its_alloc_pages(gfp_t gfp,
>> unsigned int order)
>>
>>   static void its_free_pages(void *addr, unsigned int order)
>>   {
>> -	set_memory_encrypted((unsigned long)addr, BIT(order));
>> +	if (gic_rdists->is_shared)
>> +		set_memory_encrypted((unsigned long)addr, BIT(order));
>>   	free_pages((unsigned long)addr, order);
>>   }
>>
>> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
>> index 6fb276504bcc..48c6b2c8dd8c 100644
>> --- a/drivers/irqchip/irq-gic-v3.c
>> +++ b/drivers/irqchip/irq-gic-v3.c
>> @@ -2015,6 +2015,8 @@ static int __init gic_init_bases(phys_addr_t
>> dist_phys_base,
>>   	typer = readl_relaxed(gic_data.dist_base + GICD_TYPER);
>>   	gic_data.rdists.gicd_typer = typer;
>>
>> +	gic_data.rdists.is_shared =
>> !arm64_is_iomem_private(gic_data.dist_phys_base,
>> +							    PAGE_SIZE);
> 
> Why would you base the status of the RDs on that of the distributor?

We expect that, the GIC as a whole is either Realm or non-secure, but
not split (like most of the devices). The only reason for using rdists
is because thats shared and available with the ITS driver code. (and
was an easy hack). Happy to change this to something better.

> 
>>   	gic_enable_quirks(readl_relaxed(gic_data.dist_base + GICD_IIDR),
>>   			  gic_quirks, &gic_data);
>>
>> diff --git a/include/linux/irqchip/arm-gic-v3.h
>> b/include/linux/irqchip/arm-gic-v3.h
>> index 728691365464..1edc33608d52 100644
>> --- a/include/linux/irqchip/arm-gic-v3.h
>> +++ b/include/linux/irqchip/arm-gic-v3.h
>> @@ -631,6 +631,7 @@ struct rdists {
>>   	bool			has_rvpeid;
>>   	bool			has_direct_lpi;
>>   	bool			has_vpend_valid_dirty;
>> +	bool			is_shared;
>>   };
>>
>>   struct irq_domain;
>>
> 
> I really don't like this.
> 
> If we have to go down the route of identifying whether the GIC needs
> encryption or not based on the platform, then maybe we should bite the
> bullet and treat it as a first class device, given that we expect
> devices to be either realm or non-secure.

Agreed and that is exactly we would like. i.e., treat the GIC as either
Realm or NS (as a whole). Now, how do we make that decision is based on
whether GIC Distributor area is private or not. Like I mentioned above, 
we need a cleaner way of making this available in the ITS driver.

Thoughts ? Is that what you were hinting at ?

Suzuki


> Thanks,
> 
> 	M.
> 


