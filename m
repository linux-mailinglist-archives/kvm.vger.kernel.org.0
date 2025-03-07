Return-Path: <kvm+bounces-40341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F9BCA56C62
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 16:44:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DD063AEA4A
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 15:44:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7381821E088;
	Fri,  7 Mar 2025 15:44:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C895521D5BE;
	Fri,  7 Mar 2025 15:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741362241; cv=none; b=gEpjLSXgja3pGbRd62As0a+54Fin+9NDydsbH6Ntc4rjzarL8WBHvpb9P1f6lfgGuPSRy6p9rUjPjoETzphmSKPFCVZYg7sO6Zf7RFa3mYxCHkzyv5TONSeucbZA55RVhEVyAsm/bjs9mPGkxYEd+3jJFP2ejke2kLrARhy6YBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741362241; c=relaxed/simple;
	bh=WYGYqIE7tjs3Ndvg97TJgF3DQFNARamHvv9Sv/QBZgk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NnG8wv9UAyN/ExzYZq7SXvgSWRTSKIiSa2OfaualMJiUUjoDXV1GkS8yn+8/l7hZeYR3Kow5EdoG5oLJIh9/MMnEEIv9ue61cPyEb+IivhfXOA8Ilz8FuXLbM5uGcnsey8koGMl0orX+6IiWwFBUXGU0CIeiRmBY9Yvtjbq6iGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8239C1477;
	Fri,  7 Mar 2025 07:44:10 -0800 (PST)
Received: from [10.1.35.22] (e122027.cambridge.arm.com [10.1.35.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D558B3F66E;
	Fri,  7 Mar 2025 07:43:53 -0800 (PST)
Message-ID: <4566d2d1-1f59-49e3-ad75-45c27ac4dfda@arm.com>
Date: Fri, 7 Mar 2025 15:43:51 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 12/45] arm64: RME: Allocate/free RECs to match vCPUs
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
 <20250213161426.102987-13-steven.price@arm.com>
 <7639eca7-8fd8-491c-90bd-1be084fbd710@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <7639eca7-8fd8-491c-90bd-1be084fbd710@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Gavin,

On 03/03/2025 07:08, Gavin Shan wrote:
> On 2/14/25 2:13 AM, Steven Price wrote:
>> The RMM maintains a data structure known as the Realm Execution Context
>> (or REC). It is similar to struct kvm_vcpu and tracks the state of the
>> virtual CPUs. KVM must delegate memory and request the structures are
>> created when vCPUs are created, and suitably tear down on destruction.
>>
>> RECs must also be supplied with addition pages - auxiliary (or AUX)
>> granules - for storing the larger registers state (e.g. for SVE). The
>> number of AUX granules for a REC depends on the parameters with which
>> the Realm was created - the RMM makes this information available via the
>> RMI_REC_AUX_COUNT call performed after creating the Realm Descriptor
>> (RD).
>>
>> Note that only some of register state for the REC can be set by KVM, the
>> rest is defined by the RMM (zeroed). The register state then cannot be
>> changed by KVM after the REC is created (except when the guest
>> explicitly requests this e.g. by performing a PSCI call). The RMM also
>> requires that the VMM creates RECs in ascending order of the MPIDR.
>>
>> See Realm Management Monitor specification (DEN0137) for more
>> information:
>> https://developer.arm.com/documentation/den0137/
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> Changes since v6:
>>   * Avoid reporting the KVM_ARM_VCPU_REC feature if the guest isn't a
>>     realm guest.
>>   * Support host page size being larger than RMM's granule size when
>>     allocating/freeing aux granules.
>> Changes since v5:
>>   * Separate the concept of vcpu_is_rec() and
>>     kvm_arm_vcpu_rec_finalized() by using the KVM_ARM_VCPU_REC feature as
>>     the indication that the VCPU is a REC.
>> Changes since v2:
>>   * Free rec->run earlier in kvm_destroy_realm() and adapt to previous
>> patches.
>> ---
>>   arch/arm64/include/asm/kvm_emulate.h |   7 ++
>>   arch/arm64/include/asm/kvm_host.h    |   3 +
>>   arch/arm64/include/asm/kvm_rme.h     |  18 +++
>>   arch/arm64/kvm/arm.c                 |  13 +-
>>   arch/arm64/kvm/reset.c               |  11 ++
>>   arch/arm64/kvm/rme.c                 | 179 +++++++++++++++++++++++++++
>>   6 files changed, 229 insertions(+), 2 deletions(-)
>>
> 
> With the following one comment addressed:
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> 
> [...]
> 
>>     /*
>> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/
>> asm/kvm_rme.h
>> index 698bb48a8ae1..5db377943db4 100644
>> --- a/arch/arm64/include/asm/kvm_rme.h
>> +++ b/arch/arm64/include/asm/kvm_rme.h
>> @@ -6,6 +6,7 @@
>>   #ifndef __ASM_KVM_RME_H
>>   #define __ASM_KVM_RME_H
>>   +#include <asm/rmi_smc.h>
>>   #include <uapi/linux/kvm.h>
>>     /**
>> @@ -65,6 +66,21 @@ struct realm {
>>       unsigned int ia_bits;
>>   };
>>   +/**
>> + * struct realm_rec - Additional per VCPU data for a Realm
>> + *
>> + * @mpidr: MPIDR (Multiprocessor Affinity Register) value to identify
>> this VCPU
>> + * @rec_page: Kernel VA of the RMM's private page for this REC
>> + * @aux_pages: Additional pages private to the RMM for this REC
>> + * @run: Kernel VA of the RmiRecRun structure shared with the RMM
>> + */
>> +struct realm_rec {
>> +    unsigned long mpidr;
>> +    void *rec_page;
>> +    struct page *aux_pages[REC_PARAMS_AUX_GRANULES];
>> +    struct rec_run *run;
>> +};
>> +
> 
> REC_PARAMS_AUX_GRANULES represents the maximal number of the auxiliary
> granules.
> Since the base page size is always larger than or equal to granule size
> (4KB).
> The capacity of array @aux_pages[] needs to be REC_PARAMS_AUX_GRANULES.
> Ideally,
> the array's size can be computed dynamically and it's allocated in
> kvm_create_rec().

This is indeed another example of where pages and granules have got
mixed. The RMM specification provides a maximum number of granules (and
there's a similar array in struct rec_params). Here the use of
REC_PARAMS_AUX_GRANULES is just to keep the structure more simple (no
dynamic allocation) with the cost of ~128bytes. Obviously if
PAGE_SIZE>4k then this array could be smaller.

> Alternatively, to keep the code simple, a comment is needed here to
> explain why
> the array's size has been set to REC_PARAMS_AUX_GRANULES.

Definitely a valid point - this could do with a comment explaining the
situation.

> An relevant question: Do we plan to support differentiated sizes between
> page
> and granule? I had the assumption this feature will be supported in the
> future
> after the base model (equal page and granule size) gets merged first.

Yes I do plan to support it. This series actually has the basic support
in it already, with an experimental patch at the end enabling that
support. It "works" but I haven't tested it well and I think some of the
error handling isn't quite right yet.

But there's also a bunch more work to be done (like here) to avoid
over-allocating memory when PAGE_SIZE>4k. E.g. RTTs need an
sub-allocator so that we don't waste an entire (larger) page on each RTT.

Steve


