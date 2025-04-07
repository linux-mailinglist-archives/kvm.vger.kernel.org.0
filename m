Return-Path: <kvm+bounces-42860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 58D05A7E702
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 18:43:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D06D44494D
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 16:36:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6B8B211A0C;
	Mon,  7 Apr 2025 16:34:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B8B620CCFD;
	Mon,  7 Apr 2025 16:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744043690; cv=none; b=U2yoMsHDWppfIKYH//qwIBPkVap78xXC8PPGmakFBT5Cm9331q/zIxj1D87uFM6UZxvlZ+LFA2mThXUZ4Pe0aDXfQgwm0Fw+Y2QNIYqr/p9K6b2TmAiDogrUzAhmq90LL/mGPWSNKPC3PgDq14G+ma6fTLqYfV0vKEVaZ7ETTDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744043690; c=relaxed/simple;
	bh=9qZubxauk9mzSj0tJzP980zYJ0MHrS+RSrLyxtKMBAE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PxO1naYuU77zZlG4nvdLSGi/RTezxP96tJCAIrakMnmj7/Mte07ipO0pbtTien4UKKdWFkbatpHtgxXwSUiHMcRBNxe/E0Rik8pOtKGOk+FZApUdswNmthw2/uVtPxUeiF3o4v9T4JgXOUXbT8to0rataJtY+Y+dwbkVmq9/0A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1AA4112FC;
	Mon,  7 Apr 2025 09:34:49 -0700 (PDT)
Received: from [10.57.17.31] (unknown [10.57.17.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AD2023F694;
	Mon,  7 Apr 2025 09:34:43 -0700 (PDT)
Message-ID: <29103a40-bea4-4e00-a183-83d9c678a935@arm.com>
Date: Mon, 7 Apr 2025 17:34:43 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 30/45] arm64: RME: Always use 4k pages for realms
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
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-31-steven.price@arm.com>
 <9d32bfed-31f2-49ad-ae43-87e60957ad74@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <9d32bfed-31f2-49ad-ae43-87e60957ad74@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 04/03/2025 06:23, Gavin Shan wrote:
> On 2/14/25 2:14 AM, Steven Price wrote:
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
> 
> The change log looks confusing to me. Currently, there are 3 classes of
> stage2 faults,
> handled by their corresponding handlers like below.
> 
> stage2 fault in the private space: private_memslot_fault()
> stage2 fault in the MMIO space:    io_mem_abort()
> stage2 fault in the shared space:  user_mem_abort()
> 
> Only the stage2 fault in the private space needs to allocate a 4KB page
> from guest-memfd.
> This patch is changing user_mem_abort(), which is all about the stage2
> fault in the shared
> space, where a guest-memfd isn't involved. The only intersection between
> the private/shared
> space is the stage2 page table. I'm guessing we want to have enforced
> 4KB page is due to
> the shared stage2 page table by the private/shared space, or I'm wrong.
> 
> What I'm understanding from the change log: it's something to be
> improved in future due to
> only 4KB pages can be supported by guest-memfd. Please correct me if I'm
> wrong.

Yes that commit message is confusing - I'll have a go at rewriting.

The issues are:

 1. The RMM spec (as it stands) says the guest is free to request a
RIPAS change at 4k granularity.

 2. We have no reasonable allocator to allow mapping part of a huge page
in the protected half of the guest's and the other part in the shared half.

Issue (1) also causes problems with larger page size in the host. We
have plans for a RHI (Realm Host Interface) to allow the guest to
discover the host's page size so it can size RIPAS changes appropriately.

Issue (2) is (hopefully) going to be solved by guest_memfd in the
future. I'm hoping in the future guest_memfd will be able to allocate
from a suitable allocator (e.g. hugetlbfs) *AND* it allow mmap() of
pages which are transitioned to shared. The VMM can then provide the
same physical pages for use in the shared region as were originally
provided in the protected region. This means a share/unshare sequence
can get back to a situation where a huge page can once again be used in
the guest's stage 2 (RTTs in RMM speak).

Without a solution to issue 2 then it's hard for the VMM to get hold of
memory which is suitably contiguous/aligned and deal with the guest
potentially wanting to share any portion of it.

When the mmap() support that Fuad has been working on lands it might be
worth revisiting for an opportunistic support for huge pages. But we
really also need the integration with a suitable huge page allocator for
it to work well (i.e. guest_memfd supporting larger page sizes natively).

Thanks,
Steve

>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 994e71cfb358..8c656a0ef4e9 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1641,6 +1641,10 @@ static int user_mem_abort(struct kvm_vcpu
>> *vcpu, phys_addr_t fault_ipa,
>>       if (logging_active || is_protected_kvm_enabled()) {
>>           force_pte = true;
>>           vma_shift = PAGE_SHIFT;
>> +    } else if (vcpu_is_rec(vcpu)) {
>> +        // Force PTE level mappings for realms
>> +        force_pte = true;
>> +        vma_shift = PAGE_SHIFT;
>>       } else {
>>           vma_shift = get_vma_page_shift(vma, hva);
>>       }
> 
> Thanks,
> Gavin
> 


