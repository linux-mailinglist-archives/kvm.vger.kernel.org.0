Return-Path: <kvm+bounces-17539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 60F318C7992
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 17:34:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17659285CA0
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 15:34:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D018214D452;
	Thu, 16 May 2024 15:34:40 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAF8F14884E;
	Thu, 16 May 2024 15:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715873680; cv=none; b=rvU7XBe1HM9laPpEYJWViD9rJ2z+CsFRMvrthsnQuZTwni9Zy89+RT8wfrKQ0+DrljEDWNpgAanNWbF3myQSuW9Q/Sja0LRjgfVGvsadjiDSPuCuFOReZ1AtORRjACJ0arz680Q+ckT8GRtqpH/KOGLuZxm4M9VBZLpphBl1Bgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715873680; c=relaxed/simple;
	bh=1uiUK9sNfauyJOgS1zPlzqunt1aZuBKd0XvfbKxLQFk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dq8iVB9VK41FE5cae+VEWqiXxQ+B1wMXwZNOTZXMWvfkLML5oNEVP368Op8BTZo6zVT2U9ImcF+jjZC7qypiyr/hU/fzYL5347gwHS3EERm53bYRdtFVuVhLEPKlBZVOkzSfVRftq2KFRHLRQwABow6Nm/9UdzjvVpfFFW0/rjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4266ADA7;
	Thu, 16 May 2024 08:35:02 -0700 (PDT)
Received: from [10.1.25.38] (e122027.cambridge.arm.com [10.1.25.38])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5FBFF3F7A6;
	Thu, 16 May 2024 08:34:35 -0700 (PDT)
Message-ID: <bf2e159e-4e78-407d-b6e9-071916a20816@arm.com>
Date: Thu, 16 May 2024 16:34:34 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/14] arm64: Make the PHYS_MASK_SHIFT dynamic
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, Marc Zyngier
 <maz@kernel.org>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240412084213.1733764-1-steven.price@arm.com>
 <20240412084213.1733764-8-steven.price@arm.com> <ZkJCHcqfXxV1wlB0@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <ZkJCHcqfXxV1wlB0@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 13/05/2024 17:38, Catalin Marinas wrote:
> On Fri, Apr 12, 2024 at 09:42:06AM +0100, Steven Price wrote:
>> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
>> index e01bb5ca13b7..9944aca348bd 100644
>> --- a/arch/arm64/include/asm/kvm_arm.h
>> +++ b/arch/arm64/include/asm/kvm_arm.h
>> @@ -398,7 +398,7 @@
>>   * bits in PAR are res0.
>>   */
>>  #define PAR_TO_HPFAR(par)		\
>> -	(((par) & GENMASK_ULL(52 - 1, 12)) >> 8)
>> +	(((par) & GENMASK_ULL(MAX_PHYS_MASK_SHIFT - 1, 12)) >> 8)
> 
> Why does this need to be changed? It's still a constant not dependent on
> the new dynamic IPA size.

Good question - this appears to be a rebase error. Since commit
a0d37784bfd7 ("KVM: arm64: Fix PAR_TO_HPFAR() to work independently of
PA_BITS.") this macro no longer uses PHYS_MASK_SHIFT. Previously the
change was to just to keep this uses the new 'MAX' constant.

>> diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
>> index ef207a0d4f0d..90dc292bed5f 100644
>> --- a/arch/arm64/include/asm/pgtable-hwdef.h
>> +++ b/arch/arm64/include/asm/pgtable-hwdef.h
>> @@ -206,8 +206,8 @@
>>  /*
>>   * Highest possible physical address supported.
>>   */
>> -#define PHYS_MASK_SHIFT		(CONFIG_ARM64_PA_BITS)
>> -#define PHYS_MASK		((UL(1) << PHYS_MASK_SHIFT) - 1)
>> +#define MAX_PHYS_MASK_SHIFT	(CONFIG_ARM64_PA_BITS)
>> +#define MAX_PHYS_MASK		((UL(1) << PHYS_MASK_SHIFT) - 1)
> 
> I prefer to have MAX as suffix in those definitions, it matches other
> places like TASK_SIZE_MAX, PHYS_ADDR_MAX (I know PHYS_MASK_MAX doesn't
> roll off the tongue easily but very few people tend to read the kernel
> aloud ;)).

I could rename, but actually given the above rebasing errors it appears
these are actually no longer needed, so I'll just drop the MAX_xxx
definitions.

Thanks,

Steve


