Return-Path: <kvm+bounces-11982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 64EBF87E888
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 12:25:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 027221F22A64
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 11:25:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94F2D364BF;
	Mon, 18 Mar 2024 11:25:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC0EF36AF6;
	Mon, 18 Mar 2024 11:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710761133; cv=none; b=YOiwIQHr+4Ep96zkVWd5BMgxFNb1etaIq6elhOXqQK434cS47KDNaYoRJl4KFigdXhL1gElZpOdQ2EvSKUB8m+n8+ZLdeGF9LpZpxCry1mnzOVX1W8R0IGZy3thQfCuILoMlbLY3s9BfrollXdUnc4Y9PND7z90LbTnK8OHmGUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710761133; c=relaxed/simple;
	bh=aC23jAhpl0yvzLg9qN8KuMrly14TJFysyuJEzIOBEaQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tEqybUf5H/4Awhs2pO8l87LpOZ8Bb6enRvwIiSZO67wEbWhvqWEZQcpRxZS2XLG933ipNBHz6/OSKCCOFDHEL079vn/swr0dWuEkn8b2qwWDVCyM9U1vnpVywOSWap/Ter6hiykgAW9L6jPNj6o9iq3FmJJsNiJHA1VmbTQESp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 268A6DA7;
	Mon, 18 Mar 2024 04:26:06 -0700 (PDT)
Received: from [10.57.12.69] (unknown [10.57.12.69])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1102E3F762;
	Mon, 18 Mar 2024 04:25:27 -0700 (PDT)
Message-ID: <ef2e7c22-1efb-427f-8ed4-10f9374c066a@arm.com>
Date: Mon, 18 Mar 2024 11:25:28 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 09/28] arm64: RME: RTT handling
Content-Language: en-GB
To: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127112932.38045-1-steven.price@arm.com>
 <20230127112932.38045-10-steven.price@arm.com>
 <84bb27a2-0649-4ba4-8f31-baff7b3a9b3a@os.amperecomputing.com>
From: Steven Price <steven.price@arm.com>
In-Reply-To: <84bb27a2-0649-4ba4-8f31-baff7b3a9b3a@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 18/03/2024 11:01, Ganapatrao Kulkarni wrote:
> 
> On 27-01-2023 04:59 pm, Steven Price wrote:
>> The RMM owns the stage 2 page tables for a realm, and KVM must request
>> that the RMM creates/destroys entries as necessary. The physical pages
>> to store the page tables are delegated to the realm as required, and can
>> be undelegated when no longer used.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>   arch/arm64/include/asm/kvm_rme.h |  19 +++++
>>   arch/arm64/kvm/mmu.c             |   7 +-
>>   arch/arm64/kvm/rme.c             | 139 +++++++++++++++++++++++++++++++
>>   3 files changed, 162 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_rme.h
>> b/arch/arm64/include/asm/kvm_rme.h
>> index a6318af3ed11..eea5118dfa8a 100644
>> --- a/arch/arm64/include/asm/kvm_rme.h
>> +++ b/arch/arm64/include/asm/kvm_rme.h
>> @@ -35,5 +35,24 @@ u32 kvm_realm_ipa_limit(void);
>>   int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
>>   int kvm_init_realm_vm(struct kvm *kvm);
>>   void kvm_destroy_realm(struct kvm *kvm);
>> +void kvm_realm_destroy_rtts(struct realm *realm, u32 ia_bits, u32
>> start_level);
>> +
>> +#define RME_RTT_BLOCK_LEVEL    2
>> +#define RME_RTT_MAX_LEVEL    3
>> +
>> +#define RME_PAGE_SHIFT        12
>> +#define RME_PAGE_SIZE        BIT(RME_PAGE_SHIFT)
> 
> Can we use PAGE_SIZE and PAGE_SHIFT instead of redefining?
> May be we can use them to define RME_PAGE_SIZE and RME_PAGE_SHIFT.

At the moment the code only supports the host page size matching the
RMM's. But I want to leave open the possibility for the host size being
larger than the RMM's. In this case PAGE_SHIFT/PAGE_SIZE will not equal
RME_PAGE_SIZE and RME_PAGE_SHIFT. The host will have to create multiple
RMM RTTs for each host page.

>> +/* See ARM64_HW_PGTABLE_LEVEL_SHIFT() */
>> +#define RME_RTT_LEVEL_SHIFT(l)    \
>> +    ((RME_PAGE_SHIFT - 3) * (4 - (l)) + 3)
> 
> Instead of defining again, can we define to
> ARM64_HW_PGTABLE_LEVEL_SHIFT?

Same as above - ARM64_HW_PGTABLE_LEVEL_SHIFT uses PAGE_SHIFT, but we
want the same calculation using RME_PAGE_SHIFT which might be different.

Thanks,

Steve


