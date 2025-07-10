Return-Path: <kvm+bounces-52014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 57BCFAFF867
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 07:24:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 29B351C42DD4
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 05:25:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D2F3281530;
	Thu, 10 Jul 2025 05:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PA1ejXCQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6924527F749
	for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 05:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752125081; cv=none; b=gHhvFicRsz458Ve+48BnIKBRoL0Rmo2fytU6cdMsHUA5Kn+qRLOt6mZGT/E8mKmBOBH575QxWgUxZsNdD87ti/5cbh1QRWvLwv8RysT4ZucUk/ZB93ydDE1oxkLNrpm+3sEDjWVGrD+obgEYGp+nigR+5mRb5Tg8HFf8Yp/fQEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752125081; c=relaxed/simple;
	bh=Ey67Z/gTuqQmc1QbGtinKiUnNLbmMPU31ReUX4pxfq8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E4ckFEoghXIq32N78DvGbnL7hvSaFrFRIjgVtlDB/ozUOHxCWXtrpC6YqnkqwLOgRPucko2NA41e6QpjJOE3X32vDgtA/Z3sPB34zI47s3H7x5OfQubsBSPoIfplAGc/3isFpHGodcFJuTCXBkAO046Cquxz8ps2vH6CG+3HN10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PA1ejXCQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752125077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CceeV7J/K+B1j1BDTYnc8IYXP16jroD6AWzd6NMmE60=;
	b=PA1ejXCQF3lanNT1eKanBHahBUhLUSMeZwuzRNiEeB7vlOmbzhfxScWOqbQ1L8UVlDK+OA
	k1S4+eJvq+bL53vUyfkYo+8//z5L2llovCm2O1ePI9Ys6N6EDrQ8qv5Lr3uxR3ySMaVlbH
	fYZAcmRCBAv3VpHmRSj0kwCTy5vJJOQ=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-252-Y3ZF9DimMXmEE5d7J3_gvQ-1; Thu, 10 Jul 2025 01:24:35 -0400
X-MC-Unique: Y3ZF9DimMXmEE5d7J3_gvQ-1
X-Mimecast-MFC-AGG-ID: Y3ZF9DimMXmEE5d7J3_gvQ_1752125073
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-748cf01de06so997144b3a.3
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 22:24:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752125073; x=1752729873;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CceeV7J/K+B1j1BDTYnc8IYXP16jroD6AWzd6NMmE60=;
        b=fuRRnCn2NMT2AnuNPnkIU/GmQsOYSi0DfaINrdrLiRg2jjqfC586Dc1F5S6dvtUz8s
         YnGSOccPnZd+jUf0XPyv89zXU9cbrPZ/DXjKqxOnU6Rp6xsY3U8AkE8dmoh8DwmSiZIN
         VrRueEAWK/4iczwZmeSemRq5kb1/9fo+8UBCg+JwwKqUto8zfnS4Us59BfrToe3cb9Pg
         ep+q8UaJZiwnpNn8mOHOGZLvsu/tz4mC64/KinIeN2qkpDTWiPNogcZKq9h9YeavwBEd
         dYBrc1w3uUTHkPopnxP557GqpxvQwJ/xPxRiUgBdT/K0PzWiAx2hGpEBbQMNcApgVuzZ
         4bcQ==
X-Forwarded-Encrypted: i=1; AJvYcCVNlOeRsO7K4S+Uue3Efdpx1wTxLC5gajwGHwasBtMDxObd0CvURoAcn9TY1jIcxFL/7lw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxzWPCmzn4gJTQAsu+Clr5cd9lvo97/a4imxYepEKLW87XrIkFN
	f+ZOsDgDgfLUUgU9MYfbzIx0rz+ZHY/ZC7KmDJMaCgrVrpCGQi4dmFXiWbvtKvPHXMOz4RbcKuL
	DHZvKygAmut9rI5JJh5vzD6G9XK9G0k4nWog5heFYNDGJeR2BhUArag==
X-Gm-Gg: ASbGnctZ7CuxaW0gVRV5E0uX+AYakcnnZzRZuon3tNiVclmj7gfcW8vyKkfVtV0WK1g
	Loz2m88rMsmi0JSF9rfyaIWfpYQXxYsW8KoIgKSG9YlMkO/Yc+v3BIuqupgq8CdzulL4wFgIoSC
	1z9fEcpiYeTPjGPuIdsU4cBe0L77G2/Xtm/u5G8jPkO8rfhY48JkFBQNYpF9QCknjoUz1pbWRU1
	j7YswV9Vy+LbJ0A25Ul0jrxYI/3fN8lchAj1zSOkojX7my3ik9VqhZmWJRndL/hGC1F2wA1Rps3
	vHWUrSc2sT/PciYn+24kZ5K2JWtT+WnFqvIFVXeMAgwvGm3oKoH/Nhl8WqH24w==
X-Received: by 2002:a05:6a21:33aa:b0:1f5:8a1d:3904 with SMTP id adf61e73a8af0-23003fd7f75mr2412341637.7.1752125073442;
        Wed, 09 Jul 2025 22:24:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFhW5qdYaRRhJg7AUBogJ5g2fTOaOL30BzyYQhpOK9w1RwhZRAF6XqSga3MM3ZEdVwm9ACHkA==
X-Received: by 2002:a05:6a21:33aa:b0:1f5:8a1d:3904 with SMTP id adf61e73a8af0-23003fd7f75mr2412277637.7.1752125072831;
        Wed, 09 Jul 2025 22:24:32 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74eb9dd7140sm950086b3a.24.2025.07.09.22.24.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jul 2025 22:24:31 -0700 (PDT)
Message-ID: <a8183dcd-f82e-49b3-b5b4-96e5363e060a@redhat.com>
Date: Thu, 10 Jul 2025 15:24:22 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 15/43] arm64: RME: Allow VMM to set RIPAS
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
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
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>
References: <20250611104844.245235-1-steven.price@arm.com>
 <20250611104844.245235-16-steven.price@arm.com>
 <60bb33b4-133e-4ebd-950c-e9e2ba8fc38b@redhat.com>
 <b2f3ddac-956e-4779-9202-fc393266aa6c@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <b2f3ddac-956e-4779-9202-fc393266aa6c@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Steve,

On 7/10/25 12:42 AM, Steven Price wrote:
> On 02/07/2025 01:37, Gavin Shan wrote:
>> On 6/11/25 8:48 PM, Steven Price wrote:
>>> Each page within the protected region of the realm guest can be marked
>>> as either RAM or EMPTY. Allow the VMM to control this before the guest
>>> has started and provide the equivalent functions to change this (with
>>> the guest's approval) at runtime.
>>>
>>> When transitioning from RIPAS RAM (1) to RIPAS EMPTY (0) the memory is
>>> unmapped from the guest and undelegated allowing the memory to be reused
>>> by the host. When transitioning to RIPAS RAM the actual population of
>>> the leaf RTTs is done later on stage 2 fault, however it may be
>>> necessary to allocate additional RTTs to allow the RMM track the RIPAS
>>> for the requested range.
>>>
>>> When freeing a block mapping it is necessary to temporarily unfold the
>>> RTT which requires delegating an extra page to the RMM, this page can
>>> then be recovered once the contents of the block mapping have been
>>> freed.
>>>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
>>> Changes from v8:
>>>    * Propagate the 'may_block' flag to allow conditional calls to
>>>      cond_resched_rwlock_write().
>>>    * Introduce alloc_rtt() to wrap alloc_delegated_granule() and
>>>      kvm_account_pgtable_pages() and use when allocating RTTs.
>>>    * Code reorganisation to allow init_ipa_state and set_ipa_state to
>>>      share a common ripas_change() function,
>>>    * Other minor changes following review.
>>> Changes from v7:
>>>    * Replace use of "only_shared" with the upstream "attr_filter" field
>>>      of struct kvm_gfn_range.
>>>    * Clean up the logic in alloc_delegated_granule() for when to call
>>>      kvm_account_pgtable_pages().
>>>    * Rename realm_destroy_protected_granule() to
>>>      realm_destroy_private_granule() to match the naming elsewhere. Also
>>>      fix the return codes in the function to be descriptive.
>>>    * Several other minor changes to names/return codes.
>>> Changes from v6:
>>>    * Split the code dealing with the guest triggering a RIPAS change into
>>>      a separate patch, so this patch is purely for the VMM setting up the
>>>      RIPAS before the guest first runs.
>>>    * Drop the useless flags argument from alloc_delegated_granule().
>>>    * Account RTTs allocated for a guest using kvm_account_pgtable_pages().
>>>    * Deal with the RMM granule size potentially being smaller than the
>>>      host's PAGE_SIZE. Although note alloc_delegated_granule() currently
>>>      still allocates an entire host page for every RMM granule (so wasting
>>>      memory when PAGE_SIZE>4k).
>>> Changes from v5:
>>>    * Adapt to rebasing.
>>>    * Introduce find_map_level()
>>>    * Rename some functions to be clearer.
>>>    * Drop the "spare page" functionality.
>>> Changes from v2:
>>>    * {alloc,free}_delegated_page() moved from previous patch to this one.
>>>    * alloc_delegated_page() now takes a gfp_t flags parameter.
>>>    * Fix the reference counting of guestmem pages to avoid leaking memory.
>>>    * Several misc code improvements and extra comments.
>>> ---
>>>    arch/arm64/include/asm/kvm_rme.h |   6 +
>>>    arch/arm64/kvm/mmu.c             |   8 +-
>>>    arch/arm64/kvm/rme.c             | 447 +++++++++++++++++++++++++++++++
>>>    3 files changed, 458 insertions(+), 3 deletions(-)
>>>
>>
>> With below nitpicks addressed. The changes looks good to me.
>>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
> 
> Thanks, most the nitpicks I agree - thanks for raising. Just one below I
> wanted to comment on...
> 
> [...]

You're welcome.

>>> +
>>> +enum ripas_action {
>>> +    RIPAS_INIT,
>>> +    RIPAS_SET,
>>> +};
>>> +
>>> +static int ripas_change(struct kvm *kvm,
>>> +            struct kvm_vcpu *vcpu,
>>> +            unsigned long ipa,
>>> +            unsigned long end,
>>> +            enum ripas_action action,
>>> +            unsigned long *top_ipa)
>>> +{
>>
>> The 'enum ripas_action' is used in limited scope, I would replace it
>> with a 'bool'
>> parameter to ripas_change(), something like below. If we plan to support
>> more actions
>> in future, then the 'enum ripas_action' makes sense to me.
> 
> The v1.1 spec[1] adds RMI_RTT_SET_S2AP (set stage 2 access permission).
> So that adds a third option to the enum. I agree the enum is a little
> clunky but it allows extension and at least spells out the action which
> is occurring.
> 
> The part I'm not especially happy with is the 'vcpu' argument which is
> not applicable to RIPAS_INIT but otherwise required (and in those cases
> could replace 'kvm'). But I couldn't come up with a better solution for
> that.
> 
> [1] Available from:
> https://developer.arm.com/documentation/den0137/latest (following the
> small "here" link near the end).
> 

Right, it's as I guessed. A enum looks good if we need to extend it
to cover the third case (RMI_RTT_SET_S2AP in RMMv1.1). Note that I just
started looking into RMMv1.1 implementation several days ago and didn't
have a good understanding on RMMv1.1 at present :-)

Thanks,
Gavin

> Thanks,
> Steve
> 
>> static int ripas_change(struct kvm *kvm,
>>              struct kvm_vcpu *vcpu,
>>              unsigned long ipa,
>>              unsigned long end,
>>              bool set_ripas,
>>              unsigned long *top_ipa)
>>
>>> +    struct realm *realm = &kvm->arch.realm;
>>> +    phys_addr_t rd_phys = virt_to_phys(realm->rd);
>>> +    phys_addr_t rec_phys;
>>> +    struct kvm_mmu_memory_cache *memcache = NULL;
>>> +    int ret = 0;
>>> +
>>> +    if (vcpu) {
>>> +        rec_phys = virt_to_phys(vcpu->arch.rec.rec_page);
>>> +        memcache = &vcpu->arch.mmu_page_cache;
>>> +
>>> +        WARN_ON(action != RIPAS_SET);
>>> +    } else {
>>> +        WARN_ON(action != RIPAS_INIT);
>>> +    }
>>> +
>>> +    while (ipa < end) {
>>> +        unsigned long next;
>>> +
>>> +        switch (action) {
>>> +        case RIPAS_INIT:
>>> +            ret = rmi_rtt_init_ripas(rd_phys, ipa, end, &next);
>>> +            break;
>>> +        case RIPAS_SET:
>>> +            ret = rmi_rtt_set_ripas(rd_phys, rec_phys, ipa, end,
>>> +                        &next);
>>> +            break;
>>> +        }
>>> +
>>
>> if 'enum ripas_action' is replaced by 'bool set_ripas' as above, this needs
>> twist either.
>>
>>> +        switch (RMI_RETURN_STATUS(ret)) {
>>> +        case RMI_SUCCESS:
>>> +            ipa = next;
>>> +            break;
>>> +        case RMI_ERROR_RTT:
>>> +            int err_level = RMI_RETURN_INDEX(ret);
>>> +            int level = find_map_level(realm, ipa, end);
>>> +
>>> +            if (err_level >= level)
>>> +                return -EINVAL;
>>> +
>>> +            ret = realm_create_rtt_levels(realm, ipa, err_level,
>>> +                              level, memcache);
>>> +            if (ret)
>>> +                return ret;
>>> +            /* Retry with the RTT levels in place */
>>> +            break;
>>> +        default:
>>> +            WARN_ON(1);
>>> +            return -ENXIO;
>>> +        }
>>> +    }
>>> +
>>> +    if (top_ipa)
>>> +        *top_ipa = ipa;
>>> +
>>> +    return 0;
>>> +}
>>> +
>>> +static int realm_init_ipa_state(struct kvm *kvm,
>>> +                unsigned long ipa,
>>> +                unsigned long end)
>>> +{
>>> +    return ripas_change(kvm, NULL, ipa, end, RIPAS_INIT, NULL);
>>> +}
>>> +
>>> +static int kvm_init_ipa_range_realm(struct kvm *kvm,
>>> +                    struct arm_rme_init_ripas *args)
>>> +{
>>> +    gpa_t addr, end;
>>> +
>>> +    addr = args->base;
>>> +    end = addr + args->size;
>>> +
>>> +    if (end < addr)
>>> +        return -EINVAL;
>>> +
>>> +    if (kvm_realm_state(kvm) != REALM_STATE_NEW)
>>> +        return -EPERM;
>>> +
>>> +    return realm_init_ipa_state(kvm, addr, end);
>>> +}
>>> +
>>>    /* Protects access to rme_vmid_bitmap */
>>>    static DEFINE_SPINLOCK(rme_vmid_lock);
>>>    static unsigned long *rme_vmid_bitmap;
>>> @@ -441,6 +876,18 @@ int kvm_realm_enable_cap(struct kvm *kvm, struct
>>> kvm_enable_cap *cap)
>>>        case KVM_CAP_ARM_RME_CREATE_REALM:
>>>            r = kvm_create_realm(kvm);
>>>            break;
>>> +    case KVM_CAP_ARM_RME_INIT_RIPAS_REALM: {
>>> +        struct arm_rme_init_ripas args;
>>> +        void __user *argp = u64_to_user_ptr(cap->args[1]);
>>> +
>>> +        if (copy_from_user(&args, argp, sizeof(args))) {
>>> +            r = -EFAULT;
>>> +            break;
>>> +        }
>>> +
>>> +        r = kvm_init_ipa_range_realm(kvm, &args);
>>> +        break;
>>> +    }
>>>        default:
>>>            r = -EINVAL;
>>>            break;
>>
>> Thanks,
>> Gavin
>>
> 


