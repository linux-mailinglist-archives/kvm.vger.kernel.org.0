Return-Path: <kvm+bounces-11981-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CF89487E884
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 12:23:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC4531C21545
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 11:23:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7D92383A2;
	Mon, 18 Mar 2024 11:22:49 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A446376F4;
	Mon, 18 Mar 2024 11:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710760969; cv=none; b=NzbM67YPCla7UJLHKzTEEVpHvuV0HrJv2jivXWHlb0IG4zNotnvWlylhnTkHpXJLgMmdxKVMWOalg2qPcKL35X1rQ8bNJmGWAmlNeGjQzLi6SJjvWdjwlWsnhO6cOAXy3BdWKcQg7GEAmciTVbeXb4tuBFYAHqh1lurl6hJcZmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710760969; c=relaxed/simple;
	bh=Dyf8nAP5CvRaKtnDPPCqW92IsZjNM9dunGL3Is/ffwk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N6leNw5eRhU9UXCG6EntgHnOvvAOP7vQCh27hXRCUIor72nhS6U+eP5btq9FSrO8f3Xd7+834HezAHwU7CMslX0w2ZF64YguFVieunN6WB7FlwyyiT9fheijmgsLMQNaCZfUXHd4fze1gW+4/tmPo0JCq7fJ+7SncgY2Mtr+kDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A3341143D;
	Mon, 18 Mar 2024 04:23:21 -0700 (PDT)
Received: from [10.57.12.69] (unknown [10.57.12.69])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 473A73F762;
	Mon, 18 Mar 2024 04:22:43 -0700 (PDT)
Message-ID: <136e6054-0e08-4a26-8aa4-0572bdf6fd4f@arm.com>
Date: Mon, 18 Mar 2024 11:22:43 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 03/28] arm64: RME: Add wrappers for RMI calls
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
 <20230127112932.38045-4-steven.price@arm.com>
 <aaf10e76-657f-4667-a920-e71b93419efd@os.amperecomputing.com>
From: Steven Price <steven.price@arm.com>
In-Reply-To: <aaf10e76-657f-4667-a920-e71b93419efd@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 18/03/2024 07:03, Ganapatrao Kulkarni wrote:
> 
> Hi Steven,
> 
> On 27-01-2023 04:59 pm, Steven Price wrote:
>> The wrappers make the call sites easier to read and deal with the
>> boiler plate of handling the error codes from the RMM.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>   arch/arm64/include/asm/rmi_cmds.h | 259 ++++++++++++++++++++++++++++++
>>   1 file changed, 259 insertions(+)
>>   create mode 100644 arch/arm64/include/asm/rmi_cmds.h
>>
>> diff --git a/arch/arm64/include/asm/rmi_cmds.h
>> b/arch/arm64/include/asm/rmi_cmds.h
>> new file mode 100644
>> index 000000000000..d5468ee46f35
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/rmi_cmds.h

[...]

>> +static inline int rmi_rtt_read_entry(unsigned long rd, unsigned long
>> map_addr,
>> +                     unsigned long level, struct rtt_entry *rtt)
>> +{
>> +    struct arm_smccc_1_2_regs regs = {
>> +        SMC_RMI_RTT_READ_ENTRY,
>> +        rd, map_addr, level
>> +    };
>> +
>> +    arm_smccc_1_2_smc(&regs, &regs);
>> +
>> +    rtt->walk_level = regs.a1;
>> +    rtt->state = regs.a2 & 0xFF;
>> +    rtt->desc = regs.a3;
>> +    rtt->ripas = regs.a4 & 1;
>> +
>> +    return regs.a0;
>> +}
>> +
>> +static inline int rmi_rtt_set_ripas(unsigned long rd, unsigned long rec,
>> +                    unsigned long map_addr, unsigned long level,
>> +                    unsigned long ripas)
>> +{
>> +    struct arm_smccc_res res;
>> +
>> +    arm_smccc_1_1_invoke(SMC_RMI_RTT_SET_RIPAS, rd, rec, map_addr,
>> level,
>> +                 ripas, &res);
>> +
>> +    return res.a0;
>> +}
>> +
>> +static inline int rmi_rtt_unmap_unprotected(unsigned long rd,
>> +                        unsigned long map_addr,
>> +                        unsigned long level)
>> +{
>> +    struct arm_smccc_res res;
>> +
>> +    arm_smccc_1_1_invoke(SMC_RMI_RTT_UNMAP_UNPROTECTED, rd, map_addr,
>> +                 level, &res);
>> +
>> +    return res.a0;
>> +}
>> +
>> +static inline phys_addr_t rmi_rtt_get_phys(struct rtt_entry *rtt)
>> +{
>> +    return rtt->desc & GENMASK(47, 12);
>> +}
>> +
>> +#endif
> 
> Can we please replace all occurrence of "unsigned long" with u64?

I'm conflicted here. On the one hand I agree with you - it would be
better to use types that are sized according to the RMM spec. However,
this file is a thin wrapper around the low-level SMC calls, and the
SMCCC interface is a bunch of "unsigned longs" (e.g. look at struct
arm_smccc_1_2_regs).

In particular it could be broken to use smaller types (e.g. char/u8) as
it would potentially permit the compiler to leave 'junk' in the top part
of the register.

So the question becomes whether to stick with the SMCCC interface sizes
(unsigned long) or use our knowledge that it must be a 64 bit platform
(RMM isn't support for 32 bit) and therefore use u64. My (mild)
preference is for unsigned long because it makes it obvious how this
relates to the SMCCC interface it's using. It also seems like it would
ease compatibility if (/when?) 128 bit registers become a thing.

> Also as per spec, RTT level is Int64, can we change accordingly?

Here, however, I agree you've definitely got a point. level should be
signed as (at least in theory) it could be negative.

> Please CC me in future cca patch-sets.
> gankulkarni@os.amperecomputing.com

I will do, thanks for the review.

Steve


