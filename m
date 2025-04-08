Return-Path: <kvm+bounces-42887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 38143A7F516
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 08:38:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A49171893E7D
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 06:38:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BF8F25F98E;
	Tue,  8 Apr 2025 06:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TgxQmS2r"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C99519D882
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 06:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744094272; cv=none; b=QKtBY+HWkyLWkCuIs9tUUU7eHgE/EfCC38O5WYY36qc/Sa1pjxRxVAM2u7f0fwB2Bupf1QWnDhuNZV1Eo06y3nPDkeMzMt9hZ+KK8Pwzn6H8cX7W3Zh4lfvKheG9Elp42cMyRdobdBS/Ya/U3gbq8a/QDl9zW23z5PmvElhSReM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744094272; c=relaxed/simple;
	bh=Oz3GUpFJ10kwqmVTG/QRdcwv51pw9nvmSjTO6MPD85c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XgE6fJ+9eE2AveotwKmHpd3N0VzNaHfFe4QHZzSuE+e0SjzK79lcjJRN7NSldi/jrjGaB6Luj4RlvWBHlI82PcBaAWQc1TYLpIvAh8kMW9MKoRE5D5V3dNrpiynKVexR33N5hkXYtYmiIHLmAb9SMqJHllGs9U8z8I+6UBxdX4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TgxQmS2r; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744094268;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0v20FJ701EIe028OJtt1tD17tf+Uzfk0Oz819ryH+Ys=;
	b=TgxQmS2ra57x1fXgH/vCC75U4u169CtHn4kNWnTTxFj3KVnmFcpaIOI/VInD0hheBmk6aq
	HgyJwPI8XDEFqs0Tl6JNt2cJOsj7nmlOBeR0J82HBlm3CD0TUIe1drEx7qkhauw9nA4z+w
	maR9gx1cR7Jybeu7NLuNrSfe3qMEXO0=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-251-Hwi0e_WlPU6Ctj2hiItWJg-1; Tue, 08 Apr 2025 02:37:47 -0400
X-MC-Unique: Hwi0e_WlPU6Ctj2hiItWJg-1
X-Mimecast-MFC-AGG-ID: Hwi0e_WlPU6Ctj2hiItWJg_1744094267
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2ff854a2541so4726628a91.0
        for <kvm@vger.kernel.org>; Mon, 07 Apr 2025 23:37:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744094267; x=1744699067;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0v20FJ701EIe028OJtt1tD17tf+Uzfk0Oz819ryH+Ys=;
        b=c8M6yU3uouAEWcg+ebYt1hG/cWN297y253RPw9FnMG3Ysb9YWQTk71l0nl3q9YJIaL
         1bZf6+M/IbZLS01YYLCWUse5ou9NRxN/loQgFOmHBjWahP8adpz7BwuZbagBL1cXqfQY
         MIU3N0X7BGZG5UbKO6iUZ55pAvEq7EU3kWNeNhFTu0RIvks3cf8i4tue9RzrVatdHxDw
         GCgCWsp2Bj6QJM6p5j1UZeoAYudp5Tqwbn+KAm4RcYeU6H1G5weAdtI3CPIRWE9nhW5/
         oo63ymKVvyk///xP9tYBGyUdrfq8sKGX+s6w6EmAix5vW0azoeftXjGBetwMn7/YCTAH
         nggw==
X-Forwarded-Encrypted: i=1; AJvYcCV4HY0TB710DGqCtk2k4+Lh1pu+sx7NXgpldg4zoXYnOsWqM1JYpLvm+dToCghgQqzmXjQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6BgJF39/t8gvieM6SM+KI/qdurlS+Ee7YbLm+MY1yPFfglNEX
	nggMIcLMl4N3p6PsC9eq+I2oxwa5G22mcYys0S3GG6P400dyh70Co8qEBudEoLJt+MjLbRjsubm
	9yXckSUrlBq7pMn079yD74QLlZJaSk2VB5yZ/3fnuwkNOYpTmIg==
X-Gm-Gg: ASbGncvzziPairWmgbZRCue7UPdRlsEAstA6/z2siI5XQK1YLk2wmHcgKR7W27ZePU4
	hZQUG+f8Xjcaj+CiMdRFUYcJBGauQINDi/I1MLtp+KjjOnl6rYeq3MPFwtSk4yb6POCXgvZxDkJ
	QPjq2lf7B5o4GQtciu25sjU2u7wS7uG0BWBta3BpvwTqwZ+lbHd0rIYhZsfAKTs7pUp+7OW4utS
	N7WLnrxvHSr81PhAsHg0dX6sYlCmghhJkBy75SKEavmHnZYn5q188OXYhg5Ua7nMnRMxpvdGDXI
	dT4SElRLh4X7G7ce
X-Received: by 2002:a17:90b:514e:b0:304:ec28:4437 with SMTP id 98e67ed59e1d1-306a4b70e72mr18510600a91.22.1744094266485;
        Mon, 07 Apr 2025 23:37:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHnqBBqwWUYhtFhCnTMpC42RqocSQyCJuLXXFnIrjI7SQP3rPRugb4tcWmMuJB3JDe5p/oXtw==
X-Received: by 2002:a17:90b:514e:b0:304:ec28:4437 with SMTP id 98e67ed59e1d1-306a4b70e72mr18510574a91.22.1744094266139;
        Mon, 07 Apr 2025 23:37:46 -0700 (PDT)
Received: from [192.168.68.55] ([180.233.125.65])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-305983bce79sm10080504a91.37.2025.04.07.23.37.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Apr 2025 23:37:45 -0700 (PDT)
Message-ID: <7fa4269b-a20c-4cfc-b6e7-e70214ec6366@redhat.com>
Date: Tue, 8 Apr 2025 16:37:36 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 34/45] kvm: rme: Hide KVM_CAP_READONLY_MEM for realm
 guests
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
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-35-steven.price@arm.com>
 <32a09a27-f131-44dd-8959-abb63b2089a8@redhat.com>
 <d254a8ea-0f02-4826-9af3-4a288efcc90c@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <d254a8ea-0f02-4826-9af3-4a288efcc90c@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/8/25 2:34 AM, Steven Price wrote:
> On 04/03/2025 11:51, Gavin Shan wrote:
>> On 2/14/25 2:14 AM, Steven Price wrote:
>>> For protected memory read only isn't supported. While it may be possible
>>> to support read only for unprotected memory, this isn't supported at the
>>> present time.
>>>
>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>> ---
>>>    arch/arm64/kvm/arm.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>
>> It's worthy to explain why KVM_CAP_READONLY_MEM isn't supported and its
>> negative impact. It's something to be done in the future if I'm correct.
> 
> I'll add to the commit message:
> 
>      Note that this does mean that e.g. ROM (or flash) data cannot be
>      emulated correctly by the VMM.
> 

Please also to mention this if you agree: At present, there is no exposed
APIs from RMM allowing to specifying stage-2 page-table entry's permission.
read-only regions for ROM and flash have to be backed up by read-write stage-2
page-table entries. It's going to rely on the stage-1 page-table to have the
proper permissions for those read-only regions.

>>  From QEMU's perspective, all ROM data, which is populated by it, can
>> be written. It conflicts to the natural limit: all ROM data should be
>> read-only.
> 
> Yes this is my understanding of the main impact. I'm not sure how useful
> (shared) ROM/flash emulation is. It can certainly be added in the future
> if needed. Protected read-only memory I don't believe is useful - the
> only sane response I can see from a write fault in that case is killing
> the guest.
> 

Yes, VMM is still able to write to those regions even they're read-only
since they're emulated. For misbehaving guest where those regions are also
mapped as read-write, the data resident in those regions can be corrupted
by guest. It's not the expected output.

Since RMM doesn't have exposed APIs allowing to specify page-table entry's
permissions, meaning all entries have read-write permissions, we have to
give read-write permission to those read-only regions for now. In long run,
it's something to be fixed, starting from RMM.

Thanks,
Gavin

> Thanks,
> Steve
> 
>> QEMU
>> ====
>> rom_add_blob
>>    rom_set_mr
>>      memory_region_set_readonly
>>        memory_region_transaction_commit
>>          kvm_region_commit
>>            kvm_set_phys_mem
>>              kvm_mem_flags                                    // flag
>> KVM_MEM_READONLY is missed
>>              kvm_set_user_memory_region
>>                kvm_vm_ioctl(KVM_SET_USER_MEMORY_REGION2)
>>
>> non-secure host
>> ===============
>> rec_exit_sync_dabt
>>    kvm_handle_guest_abort
>>      user_mem_abort
>>        __kvm_faultin_pfn                       // writable == true
>>          realm_map_ipa
>>            WARN_ON(!(prot & KVM_PGTABLE_PROT_W)
>>
>> non-secure host
>> ===============
>> kvm_realm_enable_cap(KVM_CAP_ARM_RME_POPULATE_REALM)
>>    kvm_populate_realm
>>      __kvm_faultin_pfn                      // writable == true
>>        realm_create_protected_data_page
>>
>>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>>> index 1f3674e95f03..0f1d65f87e2b 100644
>>> --- a/arch/arm64/kvm/arm.c
>>> +++ b/arch/arm64/kvm/arm.c
>>> @@ -348,7 +348,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,
>>> long ext)
>>>        case KVM_CAP_ONE_REG:
>>>        case KVM_CAP_ARM_PSCI:
>>>        case KVM_CAP_ARM_PSCI_0_2:
>>> -    case KVM_CAP_READONLY_MEM:
>>>        case KVM_CAP_MP_STATE:
>>>        case KVM_CAP_IMMEDIATE_EXIT:
>>>        case KVM_CAP_VCPU_EVENTS:
>>> @@ -362,6 +361,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm,
>>> long ext)
>>>        case KVM_CAP_COUNTER_OFFSET:
>>>            r = 1;
>>>            break;
>>> +    case KVM_CAP_READONLY_MEM:
>>>        case KVM_CAP_SET_GUEST_DEBUG:
>>>            r = !kvm_is_realm(kvm);
>>>            break;
>>
>> Thanks,
>> Gavin
>>
> 


