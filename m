Return-Path: <kvm+bounces-26212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04617972D35
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 11:15:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 378FD1C24860
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 09:15:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FFC31885A6;
	Tue, 10 Sep 2024 09:15:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BD911779BC;
	Tue, 10 Sep 2024 09:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725959722; cv=none; b=CGexC3214o6vLSDN2QQhNgqyE0tAo/qIqlJp0bdfmm5kQbu0tD5jgG95hEQEziUXM5JjN8pwQtHZ9y9DG1MpaGoU9/xC2CTe/5Vmncbjk4OX1Y5x+mywOyzjnyIQQ868apdlfRRCUcgep95jig8L1j5qFAFSY8WQ+7YgtxWFPH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725959722; c=relaxed/simple;
	bh=sWmvYjt7uSUB9j2qE+JpMvBWwIknNNTJ9dnFTdiTjzM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:References:
	 In-Reply-To:Content-Type; b=SfF1gnqWKkLJ+Y83+ZNPGWNSXRdDpH9lWqgsIph7tC4Vypb/BPaw9ylAD9GBbCK5aYPdHywhXbRQEV0o2Oc9Z0IJMrFFcSI84TPvmo/vdbiKAdrIMZ6FBAxXQ3lWAvau0B6HiKSYuVSimZW9FISmT8LVyuqj64QGsY4I18f5MSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E4C1E113E;
	Tue, 10 Sep 2024 02:15:47 -0700 (PDT)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 689113F66E;
	Tue, 10 Sep 2024 02:15:14 -0700 (PDT)
Message-ID: <dfc21e62-8429-4df3-8df7-2460781e3c58@arm.com>
Date: Tue, 10 Sep 2024 10:15:13 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 12/19] efi: arm64: Map Device with Prot Shared
To: Gavin Shan <gshan@redhat.com>, Steven Price <steven.price@arm.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-13-steven.price@arm.com>
 <29016e56-e632-422d-a4d2-1891fad2c565@redhat.com>
In-Reply-To: <29016e56-e632-422d-a4d2-1891fad2c565@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/09/2024 05:15, Gavin Shan wrote:
> On 8/19/24 11:19 PM, Steven Price wrote:
>> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>> Device mappings need to be emualted by the VMM so must be mapped shared
>> with the host.
>>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v4:
>>   * Reworked to use arm64_is_iomem_private() to decide whether the memory
>>     needs to be decrypted or not.
>> ---
>>   arch/arm64/kernel/efi.c | 12 ++++++++++--
>>   1 file changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
>> index 712718aed5dd..95f8e8bf07f8 100644
>> --- a/arch/arm64/kernel/efi.c
>> +++ b/arch/arm64/kernel/efi.c
>> @@ -34,8 +34,16 @@ static __init pteval_t 
>> create_mapping_protection(efi_memory_desc_t *md)
>>       u64 attr = md->attribute;
>>       u32 type = md->type;
>> -    if (type == EFI_MEMORY_MAPPED_IO)
>> -        return PROT_DEVICE_nGnRE;
>> +    if (type == EFI_MEMORY_MAPPED_IO) {
>> +        pgprot_t prot = __pgprot(PROT_DEVICE_nGnRE);
>> +
>> +        if (arm64_is_iomem_private(md->phys_addr,
>> +                       md->num_pages << EFI_PAGE_SHIFT))
>> +            prot = pgprot_encrypted(prot);
>> +        else
>> +            prot = pgprot_decrypted(prot);
>> +        return pgprot_val(prot);
>> +    }
> 
> Question: the second parameter (@size) passed to 
> arm64_is_iomem_private() covers the
> whole region. In [PATCH v5 10/19] arm64: Override set_fixmap_io, the 
> size has been
> truncated to the granule size (4KB). They look inconsistent and I don't 
> understand
> the reason.

Agreed, and the comment in patches 09/19 and 10/19 kind of vaguely 
explains this. For set_fixmap_io, we are trying to map a PAGE_SIZE, 
always. And when we want to check the "Is the range Private ?" the
answer could be different based on the PAGE_SIZE used by the kernel.
This is due to the fact that RMM always tracks the RIPAS for a 4K
granule and not the OS page size. So, if the kernel uses a 64K page
size, the RMM cannot confirm that the region is entirely RIPAS_DEV
if only the 4K granule is indeed marked as RIPAS_DEV. However, given
the same driver works for a 4K page size kernel, we can safely assume
that the driver doesn't access it beyond the 4K range  with FIXMAP.

e.g:

Addr  = 0x100000        +0x2000              0x110000
RIPAS = [ EMPTY | EMPTY | DEV | EMPTY | ...] [EMPTY | ...]

So, if we were to check the RIPAS of 0x102000, we have to restrict the
check to 4K (for the FIXMAP). Elswhere, we get the exact size of the
requested map region and can use that to check the state.

I agree that we should have a comment explaining this in the appropriate
patch.

Kind regards
Suzuki


> 
> Thanks,
> Gavin
> 


