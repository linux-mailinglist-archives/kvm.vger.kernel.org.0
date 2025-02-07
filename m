Return-Path: <kvm+bounces-37609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9435AA2C9B9
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 18:05:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7373B162FC0
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 17:05:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C58A192B6D;
	Fri,  7 Feb 2025 17:04:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37A7A23C8DB;
	Fri,  7 Feb 2025 17:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738947899; cv=none; b=S8gpg07rnS4GQH1O0DDMSBp+XcyNg0qRxNEz/O9+7+riZKazDi3DfPdhBVzmackWKp+KnG9MDYTlWi3nFEX31UE+K6GEziIonukMsGYpHGFgu/OP1d/Jmnm0ATWYMsZap7PT2HEJdsnCfVmPk9zhGew0bovVI/eCGZUyrP4LKzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738947899; c=relaxed/simple;
	bh=32Sb1iSbflEzaLzZ3eY24dRpm8vfRuffGR5PJQt9ks4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t63rB48AOY23Ic+lJWnEOvlZeQzTH7AuAf+uspiU3re7jJgpgrQLi4HILYzNNPQH94cAt+bOdENxRIz3mkG2RAU6FMddDsHE6Ok+gxKHB0+DvfNi0lALcgMs4CarCpkgp0ddoP2TLFZ2dEMG7fV04K6KXGT25Tl+/qdA4A3pFD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 17653113E;
	Fri,  7 Feb 2025 09:05:18 -0800 (PST)
Received: from [10.1.26.24] (e122027.cambridge.arm.com [10.1.26.24])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CD7CB3F63F;
	Fri,  7 Feb 2025 09:04:50 -0800 (PST)
Message-ID: <f4411830-067e-448e-b43b-1418bb264e11@arm.com>
Date: Fri, 7 Feb 2025 17:04:48 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 20/43] arm64: RME: Runtime faulting of memory
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
 <20241212155610.76522-21-steven.price@arm.com>
 <3f0caace-ee05-4ddf-ae75-2157e77aa57c@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <3f0caace-ee05-4ddf-ae75-2157e77aa57c@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 30/01/2025 05:22, Gavin Shan wrote:
> On 12/13/24 1:55 AM, Steven Price wrote:
[...]
>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>> index d4561e368cd5..146ef598a581 100644
>> --- a/arch/arm64/kvm/rme.c
>> +++ b/arch/arm64/kvm/rme.c
>> @@ -602,6 +602,162 @@ static int fold_rtt(struct realm *realm,
>> unsigned long addr, int level)
>>       return 0;
>>   }
>>   +int realm_map_protected(struct realm *realm,
>> +            unsigned long ipa,
>> +            kvm_pfn_t pfn,
>> +            unsigned long map_size,
>> +            struct kvm_mmu_memory_cache *memcache)
>> +{
>> +    phys_addr_t phys = __pfn_to_phys(pfn);
>> +    phys_addr_t rd = virt_to_phys(realm->rd);
>> +    unsigned long base_ipa = ipa;
>> +    unsigned long size;
>> +    int map_level;
>> +    int ret = 0;
>> +
>> +    if (WARN_ON(!IS_ALIGNED(ipa, map_size)))
>> +        return -EINVAL;
>> +
>> +    switch (map_size) {
>> +    case PAGE_SIZE:
>> +        map_level = 3;
>> +        break;
>> +    case RMM_L2_BLOCK_SIZE:
>> +        map_level = 2;
>> +        break;
>> +    default:
>> +        return -EINVAL;
>> +    }
>> +
> 
> The same block of code, to return the RTT level according to the map
> size, has been
> used for multiple times. It would be nice to introduce a helper for this.

I have some changes to support larger host (and guest) page sizes which
rework this code which should help clean this up.

>> +    if (map_level < RMM_RTT_MAX_LEVEL) {
>> +        /*
>> +         * A temporary RTT is needed during the map, precreate it,
>> +         * however if there is an error (e.g. missing parent tables)
>> +         * this will be handled below.
>> +         */
>> +        realm_create_rtt_levels(realm, ipa, map_level,
>> +                    RMM_RTT_MAX_LEVEL, memcache);
>> +    }
>> +
> 
> This block of code could be dropped. If the RTTs have been existing,
> realm_create_rtt_levels()
> doesn't nothing, but several RMI calls are issued. RMI calls aren't
> cheap and it can cause
> performance lost.

As mentioned in the patch 19 this is to prevent the first call to
rmi_data_create_unknown() failing when we know we're going to need to
create the RTTs. So this should generally reduce the number of RMIs
calls not increase.

>> +    for (size = 0; size < map_size; size += PAGE_SIZE) {
>> +        if (rmi_granule_delegate(phys)) {
>> +            /*
>> +             * It's likely we raced with another VCPU on the same
>> +             * fault. Assume the other VCPU has handled the fault
>> +             * and return to the guest.
>> +             */
>> +            return 0;
>> +        }
> 
> We probably can't bail immediately when error is returned from
> rmi_granule_delegate()
> because we intend to map a region whose size is 'map_size'. So a
> 'continue' instead
> of 'return 0' seems correct to me.

The logic here is that two (or more) vCPUs have faulted on the same
region. So if we get a failure here it means that we're the second vCPU
to hit the fault. While we could continue, it's highly likely that the
other vCPU will be faulting in the later parts of the region so we
expect to hit more delegation failures.

Returning to the guest and letting the guest retry the access means:
a) The access might now continue because the other vCPU has completed
(enough of) the mapping, or
b) We fault a second time, but give the other vCPU some more time to
progress in creating the mapping (and prevent the other vCPU being
tripped up by continued attempts by this vCPU from delegating the pages).

"continue" would work, but it's likely to waste CPU time with the two
vCPUs fighting each other to complete the mapping.

>> +
>> +        ret = rmi_data_create_unknown(rd, phys, ipa);
>> +
>> +        if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
>> +            /* Create missing RTTs and retry */
>> +            int level = RMI_RETURN_INDEX(ret);
>> +
>> +            ret = realm_create_rtt_levels(realm, ipa, level,
>> +                              RMM_RTT_MAX_LEVEL,
>> +                              memcache);
>> +            WARN_ON(ret);
>> +            if (ret)
>> +                goto err_undelegate;
> 
>             if (WARN_ON(ret))

ack

>> +
>> +            ret = rmi_data_create_unknown(rd, phys, ipa);
>> +        }
>> +        WARN_ON(ret);
>> +
>> +        if (ret)
>> +            goto err_undelegate;
> 
>         if (WARN_ON(ret))

ack

>> +
>> +        phys += PAGE_SIZE;
>> +        ipa += PAGE_SIZE;
>> +    }
>> +
>> +    if (map_size == RMM_L2_BLOCK_SIZE)
>> +        ret = fold_rtt(realm, base_ipa, map_level);
>> +    if (WARN_ON(ret))
>> +        goto err;
>> +
> 
> The nested if statements are needed here because the WARN_ON() only
> take effect on the return value from fold_rtt().
> 
>     if (map_size == RMM_L2_BLOCK_SIZE) {
>         ret = fold_rtt(realm, base_ipa, map_level);
>         if (WARN_ON(ret))
>             goto err;
>     }

Technically to get here then ret==0 so there's no need to nest like
this. But I agree it makes the intent much clearer so I'll update.

Thanks,
Steve


