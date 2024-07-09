Return-Path: <kvm+bounces-21178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D9FB92B9FE
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 14:54:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C37D2851D6
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 12:54:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DA6015B116;
	Tue,  9 Jul 2024 12:54:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7112E14884D;
	Tue,  9 Jul 2024 12:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720529662; cv=none; b=uMIl8+bXz4/JQp56xPvi2beb9Z8RBXbnm01q/7w0cGSKEX9xDVQw+Go4Q99t0t5RMamT0+djKnF/OUwh1oPqYpO71zeFzY8TISsfE5Le+i1TaOpKWiWuwI2n0p/juSLEi62jodXKDTh0szN88feUPOv7ps/KoddZ9OwE6vFY9Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720529662; c=relaxed/simple;
	bh=p7zs1IS07rD+Ld+gadpw7nC9GeBWJcNEHZrW9TdYU6A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PZh0NYnKUvy0DlFHLh06yApt8HDFM0WuzkcPzwE/GIaXxHPExcazXk7efqctdqFnyuiDcdJPsmAvFxVSPndT4wL9Oe9nzxNU9x8I2esNRlOL4VUE9JXt0dibwCYNR93muDYSWvwEQ09KusSkL3dr4X6VAXqLWMC8+cfVzmSXVwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AC626153B;
	Tue,  9 Jul 2024 05:54:44 -0700 (PDT)
Received: from [10.57.74.191] (unknown [10.57.74.191])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 817EB3F766;
	Tue,  9 Jul 2024 05:54:16 -0700 (PDT)
Message-ID: <f8dca28c-e5d6-4a1b-8bd3-6a711dae7078@arm.com>
Date: Tue, 9 Jul 2024 13:54:14 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/15] arm64: Mark all I/O as non-secure shared
Content-Language: en-GB
To: Will Deacon <will@kernel.org>, Steven Price <steven.price@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240701095505.165383-1-steven.price@arm.com>
 <20240701095505.165383-6-steven.price@arm.com>
 <20240709113925.GA13242@willie-the-truck>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20240709113925.GA13242@willie-the-truck>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Will

On 09/07/2024 12:39, Will Deacon wrote:
> On Mon, Jul 01, 2024 at 10:54:55AM +0100, Steven Price wrote:
>> All I/O is by default considered non-secure for realms. As such
>> mark them as shared with the host.
>>
>> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v3:
>>   * Add PROT_NS_SHARED to FIXMAP_PAGE_IO rather than overriding
>>     set_fixmap_io() with a custom function.
>>   * Modify ioreamp_cache() to specify PROT_NS_SHARED too.
>> ---
>>   arch/arm64/include/asm/fixmap.h | 2 +-
>>   arch/arm64/include/asm/io.h     | 8 ++++----
>>   2 files changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
>> index 87e307804b99..f2c5e653562e 100644
>> --- a/arch/arm64/include/asm/fixmap.h
>> +++ b/arch/arm64/include/asm/fixmap.h
>> @@ -98,7 +98,7 @@ enum fixed_addresses {
>>   #define FIXADDR_TOT_SIZE	(__end_of_fixed_addresses << PAGE_SHIFT)
>>   #define FIXADDR_TOT_START	(FIXADDR_TOP - FIXADDR_TOT_SIZE)
>>   
>> -#define FIXMAP_PAGE_IO     __pgprot(PROT_DEVICE_nGnRE)
>> +#define FIXMAP_PAGE_IO     __pgprot(PROT_DEVICE_nGnRE | PROT_NS_SHARED)
>>   
>>   void __init early_fixmap_init(void);
>>   
>> diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
>> index 4ff0ae3f6d66..07fc1801c6ad 100644
>> --- a/arch/arm64/include/asm/io.h
>> +++ b/arch/arm64/include/asm/io.h
>> @@ -277,12 +277,12 @@ static inline void __const_iowrite64_copy(void __iomem *to, const void *from,
>>   
>>   #define ioremap_prot ioremap_prot
>>   
>> -#define _PAGE_IOREMAP PROT_DEVICE_nGnRE
>> +#define _PAGE_IOREMAP (PROT_DEVICE_nGnRE | PROT_NS_SHARED)
>>   
>>   #define ioremap_wc(addr, size)	\
>> -	ioremap_prot((addr), (size), PROT_NORMAL_NC)
>> +	ioremap_prot((addr), (size), (PROT_NORMAL_NC | PROT_NS_SHARED))
>>   #define ioremap_np(addr, size)	\
>> -	ioremap_prot((addr), (size), PROT_DEVICE_nGnRnE)
>> +	ioremap_prot((addr), (size), (PROT_DEVICE_nGnRnE | PROT_NS_SHARED))
> 
> Hmm. I do wonder whether you've pushed the PROT_NS_SHARED too far here.
> 
> There's nothing _architecturally_ special about the top address bit.
> Even if the RSI divides the IPA space in half, the CPU doesn't give two
> hoots about it in the hardware. In which case, it feels wrong to bake
> PROT_NS_SHARED into ioremap_prot -- it feels much better to me if the
> ioremap() code OR'd that into the physical address when passing it down

Actually we would like to push the decision of applying the 
"pgprot_decrypted" vs pgprot_encrypted into ioremap_prot(), rather
than sprinkling every user of ioremap_prot().

This could be made depending on the address that is passed on to the
ioremap_prot(). I guess we would need explicit requests from the callers
to add "encrypted vs decrypted". Is that what you guys are looking at ?

> 
> There's a selfish side of that argument, in that we need to hook
> ioremap() for pKVM protected guests, but I do genuinely feel that
> treating address bits as protection bits is arbitrary and doesn't belong
> in these low-level definitions. In a similar vein, AMD has its
> sme_{set,clr}() macros that operate on the PA (e.g. via dma_to_phys()),
> which feels like a more accurate abstraction to me.

I believe that doesn't solve all the problems. They do have a hook in
__ioremap_caller() that implicitly applies pgprot_{en,de}crypted
depending on other info.

Cheers
Suzuki

> 
> Will


