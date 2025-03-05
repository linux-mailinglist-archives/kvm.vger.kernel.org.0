Return-Path: <kvm+bounces-40196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B18EA53E81
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 00:32:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 55C6B16C258
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 23:32:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 221D220767C;
	Wed,  5 Mar 2025 23:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KwmRMPOZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F973206F2C
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 23:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741217529; cv=none; b=N/kI597y33kufTLIi7LjMm3h9zR1W/UsnS432Uzn2SGEOkArEo0Q+edSl0AZCaJhBsOD0W3ajXG0bV/WN30z5f9VDVboDADXoiPk3S7YHUnGDJEul4DgCLVrpiw2Xs5rzC+/+RMt4WGGr1+k6wY3KALCd+UBiZHpYa7kUWcaELY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741217529; c=relaxed/simple;
	bh=REQ/IfjD8heLKs2fU0174gHx+56fArKa2gF2nY/f/EM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Keyk0YWpeQh+myyNPoeqrq/Gxc2231SvkMiOWUP5RVi9FzLeZXkES85ogwtNpGajV1O3WwKWyHCROuBnDJ6LAudYOVqhiBvC7IWz8hmrhanAYcNeMTki5Z7iOn9u+AD0S/7MBA/Fe6AtHpLjf7iSqaEtFDSMB5nEhGu1vmHlDOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KwmRMPOZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741217526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kFCm6qFAyYGc4VFf2sS3vwJnAyvK+30pL4l8MO3Di54=;
	b=KwmRMPOZTSuvqFnSV09SUs794M2/gNQh2iErXElkR64QshcykLT1IeuAgOd5Pt60BEEdgz
	lZqMpIezXoGCF5Zyb3p6I7bnK/hcd9k118jsUoEuFqC3k0fwxXb7SQ75BUGuL46/FmcREP
	03PaTge4VkwZI8rxQaCrPgtqZcV4/Bc=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-113--Tm7EsBcNMW3khgHZfjVsw-1; Wed, 05 Mar 2025 18:31:54 -0500
X-MC-Unique: -Tm7EsBcNMW3khgHZfjVsw-1
X-Mimecast-MFC-AGG-ID: -Tm7EsBcNMW3khgHZfjVsw_1741217513
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2217a4bfcc7so222765ad.3
        for <kvm@vger.kernel.org>; Wed, 05 Mar 2025 15:31:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741217513; x=1741822313;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kFCm6qFAyYGc4VFf2sS3vwJnAyvK+30pL4l8MO3Di54=;
        b=QQb4oEzfuPe8/0rCrSaYqCKkBT315u6FkabX1ZmRK3LjX5fVbGnkge907V+WJzscss
         JyEArtp+SvWDQ5lillgjZL7wvcBfg92/1s1Q5krSu4IiRhC/6U3IQxOSHLEnEPJu2Xkq
         Jt3WtVf+hrmMEQlZEarrbsui4QFGVISeix+lXidm0Qf/gGJLon5ChbETlOOoGqHrxtgV
         kOn8TXgljukKABoTMwzpChXRfc+ps7tJgulu57DdfpLMYm+gtAC4IulmF3HSeBD/1XfV
         9ki1QxQpdaSbljc2u+3oo8EKuvfs/8fqCuVgFU5ahSC1o/2Je3Q8cF5I5s0ty+aSm9VC
         akEA==
X-Forwarded-Encrypted: i=1; AJvYcCXKKUCQXtSSvJfohWCFiztNDAzKgLZ8m9bpze5zBD6oTSWPSQHvAigyTeml2qlN172AYtE=@vger.kernel.org
X-Gm-Message-State: AOJu0YymNFyQ0veP/uIqqyyaP1JTTeIpVmNFvwIIIYa4D6KgAsT7KKub
	reywP1gv3FYcN8D/RoENB+bSbPZRSKvAplzNNH4byniGpFfPndw+JMhh67BQSGXmUZvfnnYkmxo
	TWpEtdftBnv3ct4MRsWmZb9Nc4XiGogsux5ByV54aK4UZmiYvoA==
X-Gm-Gg: ASbGnct7f5UwRQV/k3qXtQSXtI1vMtnc3tr+E3krVonWRe9Yn63t3n+wBfzosZ+BJZa
	iUrWdxAIYL+cJ46Lwf1K8NBEZRcXft7Pxhpg3/8J91TUyJ2HY93kB4h/B2gqGYf/jNi5tlepHea
	FDXyTqf8Ydo+WSQYhl68zrsHxHU8WPi7t0A3wi3EC70dskjjM81BPvPvKqmoM2sTP/bMLZzgsKK
	0i1aCDCbc7Q3xWYFKTH7ONoA3u0DhcVsoKDEfxWSrX/9ftZEzt2FXdzzvkP9vpFfARJUh6g2IAJ
	ew2otpjycxAS4f8=
X-Received: by 2002:a05:6a00:856:b0:736:51a6:78b1 with SMTP id d2e1a72fcca58-73682bdf13fmr5864415b3a.11.1741217512912;
        Wed, 05 Mar 2025 15:31:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFr5llQOo8uwX2X7Rw/daISqoaMPhAadKna3dfRjuli6+dA3NfteMRLNkx9LXdBAsG0P/3xwA==
X-Received: by 2002:a05:6a00:856:b0:736:51a6:78b1 with SMTP id d2e1a72fcca58-73682bdf13fmr5864388b3a.11.1741217512567;
        Wed, 05 Mar 2025 15:31:52 -0800 (PST)
Received: from [192.168.68.55] ([180.233.125.1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-734a00400a0sm13952388b3a.140.2025.03.05.15.31.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Mar 2025 15:31:51 -0800 (PST)
Message-ID: <3190c4b0-4826-4d9b-9b12-8063acff57fa@redhat.com>
Date: Thu, 6 Mar 2025 09:31:43 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 09/45] kvm: arm64: Expose debug HW register numbers for
 Realm
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-10-steven.price@arm.com>
 <cec600f2-2ddc-4c71-9bab-0a0403132b43@redhat.com>
 <ea9bb982-cf31-4079-8fea-dc39e91a975b@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <ea9bb982-cf31-4079-8fea-dc39e91a975b@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Steven,

On 3/6/25 2:25 AM, Steven Price wrote:
> On 03/03/2025 04:48, Gavin Shan wrote:
>> On 2/14/25 2:13 AM, Steven Price wrote:
>>> From: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>
>>> Expose VM specific Debug HW register numbers.
> 
> Looking at this now, this patch description is garbage. Probably the
> patch has changed over time - so I suspect it's my fault not Suzuki's.
> We're not exposing anything new here. This is purely about telling the
> VMM that a realm cannot (currently) be debugged. Something like the
> below would be more accurate:
> 
> """
> kvm: arm64: Don't expose debug capabilities for realm guests
> 
> RMM v1.0 provides no mechanism for the host to perform debug operations
> on the guest. So don't expose KVM_CAP_SET_GUEST_DEBUG and report 0
> breakpoints and 0 watch points.
> """
> 

Yes, the improved change log looks good to me.

>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
>>>    arch/arm64/kvm/arm.c | 24 +++++++++++++++++++++---
>>>    1 file changed, 21 insertions(+), 3 deletions(-)
>>>
>>
>> Documentation/virt/kvm/api.rst needs to be updated accordingly.
> 
> I don't think (with the above clarification) there's anything to update
> in the API documentation. There's nothing new being added, just
> capabilities being hidden where the functionality isn't available.
> 
> And eventually we hope to add support for this (in a later RMM spec) - I
> don't yet know exactly what form this will take, but I hope to keep the
> interfaces as close as possible to what we already have so that existing
> tooling can be used.
> 

Ok.

>>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>>> index b8fa82be251c..df6eb5e9ca96 100644
>>> --- a/arch/arm64/kvm/arm.c
>>> +++ b/arch/arm64/kvm/arm.c
>>> @@ -78,6 +78,22 @@ bool is_kvm_arm_initialised(void)
>>>        return kvm_arm_initialised;
>>>    }
>>>    +static u32 kvm_arm_get_num_brps(struct kvm *kvm)
>>> +{
>>> +    if (!kvm_is_realm(kvm))
>>> +        return get_num_brps();
>>> +    /* Realm guest is not debuggable. */
>>> +    return 0;
>>> +}
>>> +
>>> +static u32 kvm_arm_get_num_wrps(struct kvm *kvm)
>>> +{
>>> +    if (!kvm_is_realm(kvm))
>>> +        return get_num_wrps();
>>> +    /* Realm guest is not debuggable. */
>>> +    return 0;
>>> +}
>>> +
>>
>> The above two comments "Realm guest is not debuggable." can be dropped
>> since
>> the code is self-explanatory, and those two functions are unnecessary to be
>> kept in that way, for example:
>>
>>      case KVM_CAP_GUEST_DEBUG_HW_BPS:
>>          return kvm_is_realm(kvm) ? 0 : get_num_brps();
>>      case KVM_CAP_GUEST_DEBUG_HW_WRPS:
>>          return kvm_is_realm(kvm) ? 0 : get_num_wrps();
>>
>>
>>>    int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
>>>    {
>>>        return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
>>> @@ -323,7 +339,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,
>>> long ext)
>>>        case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
>>>        case KVM_CAP_ARM_NISV_TO_USER:
>>>        case KVM_CAP_ARM_INJECT_EXT_DABT:
>>> -    case KVM_CAP_SET_GUEST_DEBUG:
>>>        case KVM_CAP_VCPU_ATTRIBUTES:
>>>        case KVM_CAP_PTP_KVM:
>>>        case KVM_CAP_ARM_SYSTEM_SUSPEND:
>>> @@ -331,6 +346,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,
>>> long ext)
>>>        case KVM_CAP_COUNTER_OFFSET:
>>>            r = 1;
>>>            break;
>>> +    case KVM_CAP_SET_GUEST_DEBUG:
>>> +        r = !kvm_is_realm(kvm);
>>> +        break;
>>>        case KVM_CAP_SET_GUEST_DEBUG2:
>>>            return KVM_GUESTDBG_VALID_MASK;
>>>        case KVM_CAP_ARM_SET_DEVICE_ADDR:
>>> @@ -376,10 +394,10 @@ int kvm_vm_ioctl_check_extension(struct kvm
>>> *kvm, long ext)
>>>            r = cpus_have_final_cap(ARM64_HAS_32BIT_EL1);
>>>            break;
>>>        case KVM_CAP_GUEST_DEBUG_HW_BPS:
>>> -        r = get_num_brps();
>>> +        r = kvm_arm_get_num_brps(kvm);
>>>            break;
>>>        case KVM_CAP_GUEST_DEBUG_HW_WPS:
>>> -        r = get_num_wrps();
>>> +        r = kvm_arm_get_num_wrps(kvm);
>>>            break;
>>>        case KVM_CAP_ARM_PMU_V3:
>>>            r = kvm_arm_support_pmu_v3();
>>

Thanks,
Gavin


