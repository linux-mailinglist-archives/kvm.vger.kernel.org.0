Return-Path: <kvm+bounces-37614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B001CA2C9C5
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 18:06:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B7B416DDEA
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 17:06:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B61A9193429;
	Fri,  7 Feb 2025 17:05:48 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A40CD193409;
	Fri,  7 Feb 2025 17:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738947948; cv=none; b=oiiYSHHv9IhUKoTJcuiBkShQQlYulg1Q4HHYVkpwnIg/Lod0zBJ71g7kgdpa5eOUsCVy7IAOZdgIbiOCnZZ6wR1m1wKoMAG6hTK2fSAODRvWzaq4p48TZZeyoaTkGRtrHDnQJbx0uqSwRAXnNA646fYrGb4qH/TgFCWVqTb8w4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738947948; c=relaxed/simple;
	bh=LnUyiUX8WRVb1HIMzOzw7mBMmuEm6kKe8ECJuYjGN6Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZxqFD6iprOFkqUqKxwZNS09l9RV/98TwSP9Ptg34HnjyBUxEzO0NOo6O1e8ngGaT6FpErj9Fcy210509XNcghLwaZ6+wFzUydLk6/Gw8CSW1ccFRwGD0UnIqEAPZ1F02Snj/98LA/CavJIjJvSDF3I6YPsduHqVVOqfe4ItWwVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D024C113E;
	Fri,  7 Feb 2025 09:06:08 -0800 (PST)
Received: from [10.1.26.24] (e122027.cambridge.arm.com [10.1.26.24])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CA6573F63F;
	Fri,  7 Feb 2025 09:05:41 -0800 (PST)
Message-ID: <7e03ad4a-ca82-4fe6-b789-1990dbbaf256@arm.com>
Date: Fri, 7 Feb 2025 17:05:39 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 29/43] arm64: RME: Always use 4k pages for realms
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-30-steven.price@arm.com>
 <82659880-f7a6-48ad-bf54-8371fc3d41d8@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <82659880-f7a6-48ad-bf54-8371fc3d41d8@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 02/02/2025 06:52, Gavin Shan wrote:
> On 12/13/24 1:55 AM, Steven Price wrote:
>> Always split up huge pages to avoid problems managing huge pages. There
>> are two issues currently:
>>
>> 1. The uABI for the VMM allows populating memory on 4k boundaries even
>>     if the underlying allocator (e.g. hugetlbfs) is using a larger page
>>     size. Using a memfd for private allocations will push this issue onto
>>     the VMM as it will need to respect the granularity of the allocator.
>>
>> 2. The guest is able to request arbitrary ranges to be remapped as
>>     shared. Again with a memfd approach it will be up to the VMM to deal
>>     with the complexity and either overmap (need the huge mapping and add
>>     an additional 'overlapping' shared mapping) or reject the request as
>>     invalid due to the use of a huge page allocator.
>>
>> For now just break everything down to 4k pages in the RMM controlled
>> stage 2.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>   arch/arm64/kvm/mmu.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index e88714903ce5..9ede143ccef1 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1603,6 +1603,10 @@ static int user_mem_abort(struct kvm_vcpu
>> *vcpu, phys_addr_t fault_ipa,
>>       if (logging_active) {
>>           force_pte = true;
>>           vma_shift = PAGE_SHIFT;
>> +    } else if (kvm_is_realm(kvm)) {
>> +        // Force PTE level mappings for realms
>> +        force_pte = true;
>> +        vma_shift = PAGE_SHIFT;
>>       } else {
>>           vma_shift = get_vma_page_shift(vma, hva);
>>       }
> 
> Since a memory abort is specific to a vCPU instead of a VM, so
> vcpu_is_rec()
> instead of kvm_is_realm() is more accurate for the check. Besides, it looks
> duplicate to the check added by "PATCH[20/43] arm64: RME: Runtime faulting
> of memory", which is as below.
> 
>        /* FIXME: We shouldn't need to disable this for realms */
>        if (vma_pagesize == PAGE_SIZE && !(force_pte || device ||
> kvm_is_realm(kvm))) {
>                                                                 
> ^^^^^^^^^^^^^^^^^
>                                                                  Can be
> dropped now.

Indeed, thanks for that - one less FIXME ;)

Thanks,
Steve

> Thanks,
> Gavin
>                 
> 


