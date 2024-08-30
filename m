Return-Path: <kvm+bounces-25543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 362F296662D
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 17:55:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DCC31282B50
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 15:55:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 837A01B86DD;
	Fri, 30 Aug 2024 15:54:55 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42D7B1B81C3;
	Fri, 30 Aug 2024 15:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725033295; cv=none; b=hWo3vswH12IdIuZJThvqZ0V0FtS0K9ZxUHJG7g9/AbrsT7aAWYEDUyb2hTAhKMPMrsagen6iD5z7SV7iUrehQS+5bJvtf1J48/go63QIRHaBoFBoJU+Ln9lau9BZ0EBnsIzfg48NVY1GcTJzuFZk7H9FeHW8WoX5D4ud/Sjj65A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725033295; c=relaxed/simple;
	bh=MRRYMjFn7aWtSBHCAj+sJCDuQyVpbXGWsKlTveW1QRw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nQX02PD7ou3P11FmiEG5VQNY+zy7nXBQhs6BLb5IRwEhwfKe7vBD+rD96J9n41ltTJFlmvyfqnKLBtJfZTnEF6zmZIuha1iGbnxIzFjx/RVaCYuFvfKH9WykVXE+mEdfVq8FkPAANF1c5j+xMasCSLSAh0p4QY1qXA/irYWOqCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 18A4D1477;
	Fri, 30 Aug 2024 08:55:19 -0700 (PDT)
Received: from [10.1.30.22] (e122027.cambridge.arm.com [10.1.30.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EB3A13F762;
	Fri, 30 Aug 2024 08:54:48 -0700 (PDT)
Message-ID: <a0c8014a-48c1-44c6-a45e-75ca778a4642@arm.com>
Date: Fri, 30 Aug 2024 16:54:45 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 10/19] arm64: Override set_fixmap_io
To: Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
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
 <20240819131924.372366-11-steven.price@arm.com>
 <13bc77b7-5f68-44ca-93ce-578ffe029437@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <13bc77b7-5f68-44ca-93ce-578ffe029437@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 19/08/2024 15:13, Suzuki K Poulose wrote:
> On 19/08/2024 14:19, Steven Price wrote:
>> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>> Override the set_fixmap_io to set shared permission for the host
>> in case of a CC guest. For now we mark it shared unconditionally.
>>
>> If/when support for device assignment and device emulation in the realm
>> is added in the future then this will need to filter the physical
>> address and make the decision accordingly.
>>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> New patch for v5
>> ---
>>   arch/arm64/include/asm/fixmap.h |  2 ++
>>   arch/arm64/mm/mmu.c             | 17 +++++++++++++++++
>>   2 files changed, 19 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/fixmap.h
>> b/arch/arm64/include/asm/fixmap.h
>> index 87e307804b99..2c20da3a468c 100644
>> --- a/arch/arm64/include/asm/fixmap.h
>> +++ b/arch/arm64/include/asm/fixmap.h
>> @@ -108,6 +108,8 @@ void __init early_fixmap_init(void);
>>   #define __late_clear_fixmap(idx) __set_fixmap((idx), 0,
>> FIXMAP_PAGE_CLEAR)
>>     extern void __set_fixmap(enum fixed_addresses idx, phys_addr_t
>> phys, pgprot_t prot);
>> +#define set_fixmap_io set_fixmap_io
>> +void set_fixmap_io(enum fixed_addresses idx, phys_addr_t phys);
>>     #include <asm-generic/fixmap.h>
>>   diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>> index 353ea5dc32b8..06b66c23c124 100644
>> --- a/arch/arm64/mm/mmu.c
>> +++ b/arch/arm64/mm/mmu.c
>> @@ -1193,6 +1193,23 @@ void vmemmap_free(unsigned long start, unsigned
>> long end,
>>   }
>>   #endif /* CONFIG_MEMORY_HOTPLUG */
>>   +void set_fixmap_io(enum fixed_addresses idx, phys_addr_t phys)
>> +{
>> +    pgprot_t prot = FIXMAP_PAGE_IO;
>> +
>> +    /*
>> +     * The set_fixmap_io maps a single Page covering phys.
>> +     * To make better decision, we stick to the smallest page
>> +     * size supported (4K).
>> +     */
>> +    if (!arm64_is_iomem_private(phys, SZ_4K))
>> +        prot = pgprot_decrypted(prot);
>> +    else
>> +        prot = pgprot_encrypted(prot);
> 
> With the ioremap_prot_hook introduction, this one looks like should use
> that, instead of open coding the same thing. Thoughts ?

I can see the logic, but it's not quite that simple to implement. Either
the ioremap_prot_hook needs moving out (and presumably) renaming to be a
more generic "override device pgprot" mechanism, we it would be a horrid
hack to put ioremap code in arch/arm64/mm/ioremap.c to handle this.

Given that we're not even sure that the set_fixmap hack is a good idea,
I'll leave this alone for now - the open coding is clear even if it's a
duplicate.

Thanks,
Steve


