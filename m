Return-Path: <kvm+bounces-37616-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E545A2C9DC
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 18:08:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D79018847AD
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 17:08:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3687194AF9;
	Fri,  7 Feb 2025 17:08:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D30F118FC72;
	Fri,  7 Feb 2025 17:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738948112; cv=none; b=maGO8W5AdTUBfaXkhpwBVpsy2lCi0PN60BwT1go7MiHD9t1SDn/ScUaMZraB5UL4GHGl8w3SO/NrFu8Xe3xpnvfyGzxIcNsF8VjOAVcZAy8xTTUq2mp0V28L5/3W4UYArAQDbzE3jWQXKjRMLSkbq2NMdg4FqRC1viDVCKPY1ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738948112; c=relaxed/simple;
	bh=PCFsR6W63KsJTL3gNOBJCr+bz3JFACcHm5OAo15EtVM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=naSXKo+nCzD8TfLgwZMUH8fid3zR/tUjvpnCwCfD/qgLYEBoGnYjMw9+rWZVsm9YxjND60j3OLapYjGlCcNf5RE0Mbw+7gJj5d0FUZreeAQ+6SjeYNkkPKU5HQ1YK2j9xkr9XSJdUYcosVgV1O9rt7+VKlLLmRLNy5Vd8OveYF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 005A7113E;
	Fri,  7 Feb 2025 09:08:53 -0800 (PST)
Received: from [10.1.26.24] (e122027.cambridge.arm.com [10.1.26.24])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BCF433F63F;
	Fri,  7 Feb 2025 09:08:25 -0800 (PST)
Message-ID: <fb817590-19c4-4242-8942-14c9fa275f0c@arm.com>
Date: Fri, 7 Feb 2025 17:08:23 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 30/43] arm64: rme: Prevent Device mappings for Realms
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
 <20241212155610.76522-31-steven.price@arm.com>
 <f339729a-00a8-40b5-af05-f0f019579e5e@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <f339729a-00a8-40b5-af05-f0f019579e5e@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 02/02/2025 07:12, Gavin Shan wrote:
> On 12/13/24 1:55 AM, Steven Price wrote:
>> Physical device assignment is not yet supported by the RMM, so it
>> doesn't make much sense to allow device mappings within the realm.
>> Prevent them when the guest is a realm.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes from v5:
>>   * Also prevent accesses in user_mem_abort()
>> ---
>>   arch/arm64/kvm/mmu.c | 12 ++++++++++++
>>   1 file changed, 12 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 9ede143ccef1..cef7c3dcbf99 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1149,6 +1149,10 @@ int kvm_phys_addr_ioremap(struct kvm *kvm,
>> phys_addr_t guest_ipa,
>>       if (is_protected_kvm_enabled())
>>           return -EPERM;
>>   +    /* We don't support mapping special pages into a Realm */
>> +    if (kvm_is_realm(kvm))
>> +        return -EINVAL;
>> +
> 
>         return -EPERM;
> 
>>       size += offset_in_page(guest_ipa);
>>       guest_ipa &= PAGE_MASK;
>>   @@ -1725,6 +1729,14 @@ static int user_mem_abort(struct kvm_vcpu
>> *vcpu, phys_addr_t fault_ipa,
>>       if (exec_fault && device)
>>           return -ENOEXEC;
>>   +    /*
>> +     * Don't allow device accesses to protected memory as we don't (yet)
>> +     * support protected devices.
>> +     */
>> +    if (device && kvm_is_realm(kvm) &&
>> +        kvm_gpa_from_fault(kvm, fault_ipa) == fault_ipa)
>> +        return -EINVAL;
>> +
> 
> s/kvm_is_realm/vcpu_is_rec
> 
> I don't understand the check very well. What I understood is mem_abort()
> is called
> only when kvm_gpa_from_fault(kvm, fault_ipa) != fault_ipa, meaning only
> the page
> faults in the shared address space is handled by mem_abort(). So I guess
> we perhaps
> need something like below.

private_memslot_fault() is only when the memslot is a private
guest_memfd(). So there's also the situation of a 'normal' memslot which
can still end up in user_mem_abort().

As things currently stand we can't really deal with this (the bottom
part of the IPA is protected, and therefore must come from
guest_memfd()). But in the future we are expecting to be able to support
protected devices.

So I think really the correct solution for now is to drop the "device"
check and update the comment to reflect the fact that
private_memslot_fault() should be handling all protected address until
we get support for assigning devices.

Thanks,
Steve

>     if (vcpu_is_rec(vcpu) && device)
>         return -EPERM;
> 
> kvm_handle_guest_abort
>   kvm_slot_can_be_private
>     private_memslot_fault    // page fault in the private space is
> handled here
>   io_mem_abort            // MMIO emulation is handled here
>   user_mem_abort                // page fault in the shared space is
> handled here
> 
>>       /*
>>        * Potentially reduce shadow S2 permissions to match the guest's
>> own
>>        * S2. For exec faults, we'd only reach this point if the guest
> 
> Thanks,
> Gavin
> 


