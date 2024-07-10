Return-Path: <kvm+bounces-21324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 486A192D5B5
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 18:05:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D5D0DB245E8
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 16:05:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08DAE194C74;
	Wed, 10 Jul 2024 16:04:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7927C194156;
	Wed, 10 Jul 2024 16:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720627497; cv=none; b=hOGPImG4+F9+IlXfrPfSSLqomQWJkO+sJRqv9LsPx6kycuz8MchTe3RZrLPzdljfWHo1p6+TSnBHanz17pYgT0CwnZwMPM5/zFbzxlIHDBNrshQsYcNYv+saMYvqv4HLLd9uEU1bGDyYqyO4fDm8OjU4g/EKDIv97+tAn45R8hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720627497; c=relaxed/simple;
	bh=ZT+vmHSzj0V3TRaEXdahnczrOE+RLfpcX61gANIuHEQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CYPhFIiXjyslKYRaSu70txVO8ReKUU/FTq48SunyFcutmc4Dz/JZiT40ohZBuGERe5F2aP5XGaXjdSHr0qbdCemjshD7gkvCsx1kcqSG8Yq25ZcMgVzsQ8Vp6Bv0hRanihmQ8jWx9nzagXatwNWGUulgnwaQ9ujDz/uegcVwTc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1C43A367;
	Wed, 10 Jul 2024 09:05:19 -0700 (PDT)
Received: from [10.57.8.115] (unknown [10.57.8.115])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 548B43F762;
	Wed, 10 Jul 2024 09:04:50 -0700 (PDT)
Message-ID: <862c600c-6803-4c25-8234-c8d056e94f23@arm.com>
Date: Wed, 10 Jul 2024 17:04:48 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/15] arm64: mm: Avoid TLBI when marking pages as
 valid
To: Will Deacon <will@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
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
 <20240701095505.165383-9-steven.price@arm.com>
 <20240709115754.GD13242@willie-the-truck>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <20240709115754.GD13242@willie-the-truck>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 09/07/2024 12:57, Will Deacon wrote:
> On Mon, Jul 01, 2024 at 10:54:58AM +0100, Steven Price wrote:
>> When __change_memory_common() is purely setting the valid bit on a PTE
>> (e.g. via the set_memory_valid() call) there is no need for a TLBI as
>> either the entry isn't changing (the valid bit was already set) or the
>> entry was invalid and so should not have been cached in the TLB.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> v4: New patch
>> ---
>>  arch/arm64/mm/pageattr.c | 8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
>> index 0e270a1c51e6..547a9e0b46c2 100644
>> --- a/arch/arm64/mm/pageattr.c
>> +++ b/arch/arm64/mm/pageattr.c
>> @@ -60,7 +60,13 @@ static int __change_memory_common(unsigned long start, unsigned long size,
>>  	ret = apply_to_page_range(&init_mm, start, size, change_page_range,
>>  					&data);
>>  
>> -	flush_tlb_kernel_range(start, start + size);
>> +	/*
>> +	 * If the memory is being made valid without changing any other bits
>> +	 * then a TLBI isn't required as a non-valid entry cannot be cached in
>> +	 * the TLB.
>> +	 */
>> +	if (pgprot_val(set_mask) != PTE_VALID || pgprot_val(clear_mask))
>> +		flush_tlb_kernel_range(start, start + size);
>>  	return ret;
> 
> Can you elaborate on when this actually happens, please? It feels like a
> case of "Doctor, it hurts when I do this" rather than something we should
> be trying to short-circuit in the low-level code.

This is for the benefit of the following patch. When transitioning a
page between shared and private we need to change the IPA (to set/clear
the top bit). This requires a break-before-make - see
__set_memory_enc_dec() in the following patch.

The easiest way of implementing the code was to just call
__change_memory_common() twice - once to make the entry invalid and then
again to make it valid with the new IPA. But that led to a double TLBI
which Catalin didn't like[1].

So this patch removes the unnecessary second TLBI by detecting that
we're just making the entry valid. Or at least it would if I hadn't
screwed up...

I should have changed the following patch to ensure that the second call
to __change_memory_common was only setting the PTE_VALID bit and not
changing anything else (so that the TLBI could be skipped) and forgot to
do that. So thanks for making me take a look at this again!

Thanks,
Steve

[1] https://lore.kernel.org/lkml/Zmc3euO2YGh-g9Th@arm.com/

