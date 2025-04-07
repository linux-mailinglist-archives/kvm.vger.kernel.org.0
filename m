Return-Path: <kvm+bounces-42858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 75A8CA7E6F7
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 18:42:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B843F1723B2
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 16:35:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D24A8211294;
	Mon,  7 Apr 2025 16:34:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E07720C49B;
	Mon,  7 Apr 2025 16:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744043675; cv=none; b=IRv1ilaUysd1IwbUBylfXlA1csYTJ78nVhBDkyD0h8JECls4SSTuDbQ6gI78SmObWkG0nmGWGo+3zVh2ffSaEB0uIIdDXx8yAeCEugzcJpFwl+19PRTSZZD+BlyKccRu26l/y/KzzOoBji0kc0sVwIsTr/isnoSxtIDj+B+tBhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744043675; c=relaxed/simple;
	bh=/9tOmKDQthqbCNmPjw1HNHmnkDLompcRjnGXwn80w4E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s9Pa6z0FS2LQXQAoXkEOqycY89xb6dr6F7PT/zLowMAiPp2cFq13ArbpWeRepXRVOhOs3G/kOdQtMPTTDCCJKKK83jWBqBn7elCRaB+tlHrCJUcH3Ptb841gY/Ac+NOKgfuGs14KMYDfvPhnFgsQ2U2NsZ+aJt30cTAAxDdFFlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB54B106F;
	Mon,  7 Apr 2025 09:34:33 -0700 (PDT)
Received: from [10.57.17.31] (unknown [10.57.17.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B6B343F694;
	Mon,  7 Apr 2025 09:34:28 -0700 (PDT)
Message-ID: <3b563b01-5090-4c9d-a47c-a0aaa13c474b@arm.com>
Date: Mon, 7 Apr 2025 17:34:28 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 18/45] arm64: RME: Handle RMI_EXIT_RIPAS_CHANGE
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
 <20250213161426.102987-19-steven.price@arm.com>
 <b89caaaf-3d26-4ca4-b395-08bf3f90dd1f@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <b89caaaf-3d26-4ca4-b395-08bf3f90dd1f@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 04/03/2025 04:35, Gavin Shan wrote:
> On 2/14/25 2:13 AM, Steven Price wrote:
>> The guest can request that a region of it's protected address space is
>> switched between RIPAS_RAM and RIPAS_EMPTY (and back) using
>> RSI_IPA_STATE_SET. This causes a guest exit with the
>> RMI_EXIT_RIPAS_CHANGE code. We treat this as a request to convert a
>> protected region to unprotected (or back), exiting to the VMM to make
>> the necessary changes to the guest_memfd and memslot mappings. On the
>> next entry the RIPAS changes are committed by making RMI_RTT_SET_RIPAS
>> calls.
>>
>> The VMM may wish to reject the RIPAS change requested by the guest. For
>> now it can only do with by no longer scheduling the VCPU as we don't
>> currently have a usecase for returning that rejection to the guest, but
>> by postponing the RMI_RTT_SET_RIPAS changes to entry we leave the door
>> open for adding a new ioctl in the future for this purpose.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> New patch for v7: The code was previously split awkwardly between two
>> other patches.
>> ---
>>   arch/arm64/kvm/rme.c | 87 ++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 87 insertions(+)
>>
> 
> With the following comments addressed:
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> 
>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>> index 507eb4b71bb7..f965869e9ef7 100644
>> --- a/arch/arm64/kvm/rme.c
>> +++ b/arch/arm64/kvm/rme.c
>> @@ -624,6 +624,64 @@ void kvm_realm_unmap_range(struct kvm *kvm,
>> unsigned long start, u64 size,
>>           realm_unmap_private_range(kvm, start, end);
>>   }
>>   +static int realm_set_ipa_state(struct kvm_vcpu *vcpu,
>> +                   unsigned long start,
>> +                   unsigned long end,
>> +                   unsigned long ripas,
>> +                   unsigned long *top_ipa)
>> +{
>> +    struct kvm *kvm = vcpu->kvm;
>> +    struct realm *realm = &kvm->arch.realm;
>> +    struct realm_rec *rec = &vcpu->arch.rec;
>> +    phys_addr_t rd_phys = virt_to_phys(realm->rd);
>> +    phys_addr_t rec_phys = virt_to_phys(rec->rec_page);
>> +    struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
>> +    unsigned long ipa = start;
>> +    int ret = 0;
>> +
>> +    while (ipa < end) {
>> +        unsigned long next;
>> +
>> +        ret = rmi_rtt_set_ripas(rd_phys, rec_phys, ipa, end, &next);
>> +
> 
> This doesn't look correct to me. Looking at RMM::smc_rtt_set_ripas(),
> it's possible
> the SMC call is returned without updating 'next' to a valid address. In
> this case,
> the garbage content resident in 'next' can be used to updated to 'ipa'
> in next
> iternation. So we need to initialize it in advance, like below.
> 
>     unsigned long ipa = start;
>     unsigned long next = start;
> 
>     while (ipa < end) {
>         ret = rmi_rtt_set_ripas(rd_phys, rec_phys, ipa, end, &next);

I agree this might not be the clearest code, but 'next' should be set if
the return state is RMI_SUCCESS, and we don't actually get to the "ipa =
next" line unless that is the case. But I'll rejig things because it's
not clear.

>> +        if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
>> +            int walk_level = RMI_RETURN_INDEX(ret);
>> +            int level = find_map_level(realm, ipa, end);
>> +
>> +            /*
>> +             * If the RMM walk ended early then more tables are
>> +             * needed to reach the required depth to set the RIPAS.
>> +             */
>> +            if (walk_level < level) {
>> +                ret = realm_create_rtt_levels(realm, ipa,
>> +                                  walk_level,
>> +                                  level,
>> +                                  memcache);
>> +                /* Retry with RTTs created */
>> +                if (!ret)
>> +                    continue;
>> +            } else {
>> +                ret = -EINVAL;
>> +            }
>> +
>> +            break;
>> +        } else if (RMI_RETURN_STATUS(ret) != RMI_SUCCESS) {
>> +            WARN(1, "Unexpected error in %s: %#x\n", __func__,
>> +                 ret);
>> +            ret = -EINVAL;
> 
>             ret = -ENXIO;

Ack

>> +            break;
>> +        }
>> +        ipa = next;
>> +    }
>> +
>> +    *top_ipa = ipa;
>> +
>> +    if (ripas == RMI_EMPTY && ipa != start)
>> +        realm_unmap_private_range(kvm, start, ipa);
>> +
>> +    return ret;
>> +}
>> +
>>   static int realm_init_ipa_state(struct realm *realm,
>>                   unsigned long ipa,
>>                   unsigned long end)
>> @@ -863,6 +921,32 @@ void kvm_destroy_realm(struct kvm *kvm)
>>       kvm_free_stage2_pgd(&kvm->arch.mmu);
>>   }
>>   +static void kvm_complete_ripas_change(struct kvm_vcpu *vcpu)
>> +{
>> +    struct kvm *kvm = vcpu->kvm;
>> +    struct realm_rec *rec = &vcpu->arch.rec;
>> +    unsigned long base = rec->run->exit.ripas_base;
>> +    unsigned long top = rec->run->exit.ripas_top;
>> +    unsigned long ripas = rec->run->exit.ripas_value;
>> +    unsigned long top_ipa;
>> +    int ret;
>> +
> 
> Some checks are needed here to ensure the addresses (@base and @top)
> falls inside
> the protected (private) space for two facts: (1) Those parameters
> originates from
> the guest, which can be misbehaving. (2) RMM::smc_rtt_set_ripas() isn't
> limited to
> the private space, meaning it also can change RIPAS for the ranges in
> the shared
> space.

I might be missing something, but AFAICT this is safe:

 1. The RMM doesn't permit RIPAS changes within the shared space:
    RSI_IPA_STATE_SET has a precondition [rgn_bound]:
    AddrRangeIsProtected(base, top, realm)
    So a malicious guest shouldn't get passed the RMM.

 2. The RMM validates that the range passed here is (a subset of) the
    one provided to the NS-world [base_bound / top_bound].

And even if somehow a malicious guest managed to bypass these checks I
don't see how it would cause harm to the host operating on the wrong region.

I'm happy to be corrected though! What am I missing?

Thank,
Steve

>> +    do {
>> +        kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_page_cache,
>> +                       kvm_mmu_cache_min_pages(vcpu->arch.hw_mmu));
>> +        write_lock(&kvm->mmu_lock);
>> +        ret = realm_set_ipa_state(vcpu, base, top, ripas, &top_ipa);
>> +        write_unlock(&kvm->mmu_lock);
>> +
>> +        if (WARN_RATELIMIT(ret && ret != -ENOMEM,
>> +                   "Unable to satisfy RIPAS_CHANGE for %#lx - %#lx,
>> ripas: %#lx\n",
>> +                   base, top, ripas))
>> +            break;
>> +
>> +        base = top_ipa;
>> +    } while (top_ipa < top);
>> +}
>> +
>>   int kvm_rec_enter(struct kvm_vcpu *vcpu)
>>   {
>>       struct realm_rec *rec = &vcpu->arch.rec;
>> @@ -873,6 +957,9 @@ int kvm_rec_enter(struct kvm_vcpu *vcpu)
>>           for (int i = 0; i < REC_RUN_GPRS; i++)
>>               rec->run->enter.gprs[i] = vcpu_get_reg(vcpu, i);
>>           break;
>> +    case RMI_EXIT_RIPAS_CHANGE:
>> +        kvm_complete_ripas_change(vcpu);
>> +        break;
>>       }
>>         if (kvm_realm_state(vcpu->kvm) != REALM_STATE_ACTIVE)
> 
> Thanks,
> Gavin
> 


