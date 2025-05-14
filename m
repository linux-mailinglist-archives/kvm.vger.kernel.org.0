Return-Path: <kvm+bounces-46471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF182AB68B9
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 12:24:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 511F0860CD4
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 10:24:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 590E5270552;
	Wed, 14 May 2025 10:24:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63D371E04BD;
	Wed, 14 May 2025 10:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747218259; cv=none; b=fYL8opt0OS7e02vdq18Y8lWH+ZgSz2OhM4vmuP3hrXwqS090DjjWO4Gi5RIeUErdxKgKlzfQ1ZePFaC+TSnTYnqAlEX+8cIfXN5yxdHip4c46z8BRdth2v4S4vvtbVjXsTPzs7gvhp7UtQ3dI+twqsRUmxydo6ulHoG4qFKWk5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747218259; c=relaxed/simple;
	bh=BOofkBfaOlAL0tDVDzAKaauS2ThgBGfeSjAHZg5HhgQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TOSZHhLe7ujLvJ2cD17NBtTK0w+6FND7XSdxV9AItVovUL7e43e8LCExhABJ97dZMOhwBXPjSoIOSxQc62rf+/3op2TCiY/XorJl1ZVyV9yKNkUNRDnzkq4MNcRKnyDJ6B77+tMg+n06BF5T0KC1+4xhJVSph+0zDdDBLSr6RR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6673E14BF;
	Wed, 14 May 2025 03:24:05 -0700 (PDT)
Received: from [10.57.24.82] (unknown [10.57.24.82])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A00C53F673;
	Wed, 14 May 2025 03:24:12 -0700 (PDT)
Message-ID: <36c46f16-85c2-43f8-b460-942f34631e0d@arm.com>
Date: Wed, 14 May 2025 11:24:10 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 15/43] arm64: RME: Allow VMM to set RIPAS
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
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>
References: <20250416134208.383984-1-steven.price@arm.com>
 <20250416134208.383984-16-steven.price@arm.com>
 <83071e55-cbe4-4786-b60e-d26ce16368b3@arm.com>
 <f4ee678d-112d-46d1-8b87-70e55d6617e1@arm.com>
 <d0cbb637-6ba1-4858-b326-31271e9949ea@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <d0cbb637-6ba1-4858-b326-31271e9949ea@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 13/05/2025 11:43, Suzuki K Poulose wrote:
> On 12/05/2025 15:45, Steven Price wrote:
>> On 06/05/2025 14:23, Suzuki K Poulose wrote:
>>> Hi Steven
>>>
>>> On 16/04/2025 14:41, Steven Price wrote:

[...]

> 
>>
>>>> +    }
>>>> +
>>>> +    realm_fold_rtt_level(realm, get_start_level(realm) + 1,
>>>> +                 start, end);
>>>
>>> We don't seem to be reclaiing the RTTs from shared mapping case ?
>>
>> I'm not sure I follow: realm_fold_rtt_level() will free any RTTs that
>> are released.
>>
>> Or are you referring to the fact that we don't (yet) fold the shared
>> range? I have been purposefully leaving that for now as normally we'd
> 
> sorry it was a bit vague. We don't seem to be reclaiming the RTTs in
> realm_unmap_shared_range(), like we do for the private range.

Ah, you mean we potentially leave empty RTTs which are only reclaimed
when destroying the realm. Whereas in the private range we
opportunistically fold which will (usually) cause these to be freed.

>> follow the page size in the VMM to choose the page size on the guest,
>> but that doesn't work when the RMM might have a different page size to
>> the host. So my reasons for leaving it for later are:
>>
>>   * First huge pages is very much a TODO in general.
>>
>>   * When we support >4K host pages then a huge page on the host may not
>>     be available in the RMM, so we can't just follow the VMM.
>>
>>   * We don't have support in realm_unmap_shared_range() to split a block
>>     mapping up - it could be added, but it's not clear to me if it's best
>>     to split a block mapping, or remove the whole and refault as
>>     required.
>>
>>   * guest_memfd might well be able to provide some good hints here, but
>>     we'll have to wait for that series to settle.
> 
> I am not sure I follow. None of this affects folding, once we have
> "unmapped". For that matter, we could easily DESTROY the RTTs in
> shared side without unmapping, but we can do that later as an
> optimisation.

Yeah, ignore the above - like you say it's not relevant to unmapping, I
hadn't understood your point ;)

I'll stick a call to realm_fold_rtt_level() at the end of
realm_unmap_shared_range() which should opportunistically free unused
RTTs. Like you say there's a optimisation to just straight to destroying
the RTTs in the shared region - but I think that's best left until later.

>>
>>>> +}
>>>> +
>>>> +void kvm_realm_unmap_range(struct kvm *kvm, unsigned long start,
>>>> +               unsigned long size, bool unmap_private)
>>>> +{
>>>> +    unsigned long end = start + size;
>>>> +    struct realm *realm = &kvm->arch.realm;
>>>> +
>>>> +    end = min(BIT(realm->ia_bits - 1), end);
>>>> +
>>>> +    if (realm->state == REALM_STATE_NONE)
>>>> +        return;
>>>> +
>>>> +    realm_unmap_shared_range(kvm, find_map_level(realm, start, end),
>>>> +                 start, end);
>>>> +    if (unmap_private)
>>>> +        realm_unmap_private_range(kvm, start, end);
>>>> +}
>>>> +
>>>> +static int realm_init_ipa_state(struct realm *realm,
>>>> +                unsigned long ipa,
>>>> +                unsigned long end)
>>>> +{
>>>> +    phys_addr_t rd_phys = virt_to_phys(realm->rd);
>>>> +    int ret;
>>>> +
>>>> +    while (ipa < end) {
>>>> +        unsigned long next;
>>>> +
>>>> +        ret = rmi_rtt_init_ripas(rd_phys, ipa, end, &next);
>>>> +
>>>> +        if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
>>>> +            int err_level = RMI_RETURN_INDEX(ret);
>>>> +            int level = find_map_level(realm, ipa, end);
>>>> +
>>>> +            if (WARN_ON(err_level >= level))
>>>
>>> I am wondering if WARN_ON() is required here. A buggy VMM could trigger
>>> the WARN_ON(). (e.g, INIT_IPA after POPULATE, where L3 table is
>>> created.). The only case where it may be worth WARNING is if the level
>>> == 3.
>>
>> I have to admit I've struggled to get my head round this ;)
>>
>> init_ripas will fail with ERROR_RTT in three cases:
>>
>>   1. (base_align) The base address isn't aligned for the level reached.
>>
>>   2. (rtt_state) The rtte state is !UNASSIGNED.
>>
>>   3. (no_progress) base==walk_top - the while condition should prevent
>>      this.
>>
>> So I think case 1 is the case we're expecting, and creating RTTs should
>> resolve it.
>>
>> Case 2 is presumably the case you are concerned about, although it's not
>> because tables have been created, but because INIT_RIPAS is invalid on
>> areas that have been populated already.
> 
> Correct, this is the case I was referring to.
> 
>>
>> If my reading of the spec is correct, then level == 3 isn't a possible
>> result, so beyond potentially finding RMM bugs I don't think a WARN for
> 
> It is almost certainly possible, with L3 page mapping created for
> POPULATE and a follow up INIT_RIPAS with 2M or even 1G alignment, could
> lead us to expect that only L1 or L2 is required (find_map_level) but
> the RTT walk reached L3 and failed. This is not a case of RMM bug, but
> a VMM not following the rules.

Sorry, I wasn't clear. I mean "level == 3" isn't something that we
should be WARNing on.

>> that is very interesting. So for now I'll just drop the WARN_ON here
>> altogether.
> 
> Thanks, that is much safer

Ack.

Thanks,
Steve

> Suzuki
> 


