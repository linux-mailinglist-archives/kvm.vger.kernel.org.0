Return-Path: <kvm+bounces-21317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 209A592D50B
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 17:35:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5B2791C21EFF
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 15:35:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8152194C66;
	Wed, 10 Jul 2024 15:34:38 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAEE01946D9;
	Wed, 10 Jul 2024 15:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720625678; cv=none; b=fJR8I7AIl5/oF7XJlLx6XqyIE3/UuaDE8vm7AtWyW3bXwcWIIsdepCk9+VeNO4KW6pQYTiRsh/rOtKyDqoxZQlNyFp9Q9PN0GJfyCTxdIME4mm68CekFt1aZkiDxFjeql16Z6c1j8exHg1I7tUge2w1P4U3iKUv680GKWqvG1Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720625678; c=relaxed/simple;
	bh=bLjriFoMARhnDgEhXPye8f2db2fF12WTehS44IJTXZc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z3tfHtg6xMK+abiif/nq5Rkedy5Px9fzb2S/tfwGRYR7UKxv0fu6JhKRQyDZATcTm4sXvOWb97ZuLEPg9hIvxzyg9NkjIkkoqKSSvcDzJMRV9VtFQcbo1f1WsFW/aH7UIaJDosVscaF7hmJGaISIoN8luMcFshIBv+HGWhxaUcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 65615106F;
	Wed, 10 Jul 2024 08:35:01 -0700 (PDT)
Received: from [10.57.8.115] (unknown [10.57.8.115])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C4DCC3F766;
	Wed, 10 Jul 2024 08:34:29 -0700 (PDT)
Message-ID: <ba83b54a-f780-44bc-af11-94c6c05b825f@arm.com>
Date: Wed, 10 Jul 2024 16:34:17 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/15] arm64: Mark all I/O as non-secure shared
To: Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>
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
 <f8dca28c-e5d6-4a1b-8bd3-6a711dae7078@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <f8dca28c-e5d6-4a1b-8bd3-6a711dae7078@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 09/07/2024 13:54, Suzuki K Poulose wrote:
> Hi Will
> 
> On 09/07/2024 12:39, Will Deacon wrote:
>> On Mon, Jul 01, 2024 at 10:54:55AM +0100, Steven Price wrote:
>>> All I/O is by default considered non-secure for realms. As such
>>> mark them as shared with the host.
>>>
>>> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
>>> Changes since v3:
>>>   * Add PROT_NS_SHARED to FIXMAP_PAGE_IO rather than overriding
>>>     set_fixmap_io() with a custom function.
>>>   * Modify ioreamp_cache() to specify PROT_NS_SHARED too.
>>> ---
>>>   arch/arm64/include/asm/fixmap.h | 2 +-
>>>   arch/arm64/include/asm/io.h     | 8 ++++----
>>>   2 files changed, 5 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/fixmap.h
>>> b/arch/arm64/include/asm/fixmap.h
>>> index 87e307804b99..f2c5e653562e 100644
>>> --- a/arch/arm64/include/asm/fixmap.h
>>> +++ b/arch/arm64/include/asm/fixmap.h
>>> @@ -98,7 +98,7 @@ enum fixed_addresses {
>>>   #define FIXADDR_TOT_SIZE    (__end_of_fixed_addresses << PAGE_SHIFT)
>>>   #define FIXADDR_TOT_START    (FIXADDR_TOP - FIXADDR_TOT_SIZE)
>>>   -#define FIXMAP_PAGE_IO     __pgprot(PROT_DEVICE_nGnRE)
>>> +#define FIXMAP_PAGE_IO     __pgprot(PROT_DEVICE_nGnRE | PROT_NS_SHARED)
>>>     void __init early_fixmap_init(void);
>>>   diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
>>> index 4ff0ae3f6d66..07fc1801c6ad 100644
>>> --- a/arch/arm64/include/asm/io.h
>>> +++ b/arch/arm64/include/asm/io.h
>>> @@ -277,12 +277,12 @@ static inline void __const_iowrite64_copy(void
>>> __iomem *to, const void *from,
>>>     #define ioremap_prot ioremap_prot
>>>   -#define _PAGE_IOREMAP PROT_DEVICE_nGnRE
>>> +#define _PAGE_IOREMAP (PROT_DEVICE_nGnRE | PROT_NS_SHARED)
>>>     #define ioremap_wc(addr, size)    \
>>> -    ioremap_prot((addr), (size), PROT_NORMAL_NC)
>>> +    ioremap_prot((addr), (size), (PROT_NORMAL_NC | PROT_NS_SHARED))
>>>   #define ioremap_np(addr, size)    \
>>> -    ioremap_prot((addr), (size), PROT_DEVICE_nGnRnE)
>>> +    ioremap_prot((addr), (size), (PROT_DEVICE_nGnRnE | PROT_NS_SHARED))
>>
>> Hmm. I do wonder whether you've pushed the PROT_NS_SHARED too far here.
>>
>> There's nothing _architecturally_ special about the top address bit.
>> Even if the RSI divides the IPA space in half, the CPU doesn't give two
>> hoots about it in the hardware. In which case, it feels wrong to bake
>> PROT_NS_SHARED into ioremap_prot -- it feels much better to me if the
>> ioremap() code OR'd that into the physical address when passing it down

This is really just a simplification given we don't (yet) have device
assignment.

> Actually we would like to push the decision of applying the
> "pgprot_decrypted" vs pgprot_encrypted into ioremap_prot(), rather
> than sprinkling every user of ioremap_prot().
> 
> This could be made depending on the address that is passed on to the
> ioremap_prot(). I guess we would need explicit requests from the callers
> to add "encrypted vs decrypted". Is that what you guys are looking at ?

There's a missing piece at the moment in terms of how the guest is going
to identify whether a particular device is protected or shared (i.e. a
real assigned device, or emulated by the VMM). When that's added then I
was expecting ioremap_prot() to provide that flag based on discovering
whether the address range passed in is for an assigned device or not.

>>
>> There's a selfish side of that argument, in that we need to hook
>> ioremap() for pKVM protected guests, but I do genuinely feel that
>> treating address bits as protection bits is arbitrary and doesn't belong
>> in these low-level definitions. In a similar vein, AMD has its

I'd be interested to see how pKVM will handle both protected and
emulated (by the VMM) devices. Although we have the 'top bit' flag it's
actually a pain to pass that down to the guest as a flag to use for this
purpose (e.g. 32 bit PCI BARs are too small). So our current thought is
an out-of-band request to identify whether a particular address
corresponds to a protected device or not. We'd then set the top bit
appropriately.

>> sme_{set,clr}() macros that operate on the PA (e.g. via dma_to_phys()),
>> which feels like a more accurate abstraction to me.
> 
> I believe that doesn't solve all the problems. They do have a hook in
> __ioremap_caller() that implicitly applies pgprot_{en,de}crypted
> depending on other info.

This is the other option - which pushes the knowledge down to the
individual drivers to decide whether a region is 'encrypted' (i.e.
protected) or not. It's more flexible, but potentially requires 'fixing'
many drivers to understand this.

Thanks,
Steve

> Cheers
> Suzuki
> 
>>
>> Will
> 


