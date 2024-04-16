Return-Path: <kvm+bounces-14767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 29B408A6BF6
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 15:15:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A5B11C20F8B
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 13:15:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE71B12C482;
	Tue, 16 Apr 2024 13:14:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3342C12AAE7;
	Tue, 16 Apr 2024 13:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713273287; cv=none; b=BpJK+Q5sriHAV23cZgYEyoFIIUDtDbPmiEMLr4pYGSv6cqB0iYkag47w/OeXILsYxC7EQJX/gYFtaAtMBzvzb214GOwWrwZB0Sef0qLGmjTvbzkc8EjR1m7yIbynj/02DsQGxn9sZfedb1iHtBowQ3bdgXTSGrCqYdtRd7QM0TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713273287; c=relaxed/simple;
	bh=gu/7yEmTZO3eRUr56dElM2gFoo/BiAjK7fnL+Q6GZV0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dR+YjrK1YGaNolBRRhAazwoqOkkfveJoJi8l0swPY7xYWFCuncf/7gI8dCgEvg2O4fyJwAUuLNJiWdYxClg2qbK/qbVcKkFjrEtT8Fbrtt7tuX5V1EVOsU0Tdtp+uG0ZUofDCK7v/N0FdY9v8Bqevvu6ofDDx7yKsEVydHK3m1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B3C19DA7;
	Tue, 16 Apr 2024 06:15:11 -0700 (PDT)
Received: from [10.1.197.1] (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 458AF3F738;
	Tue, 16 Apr 2024 06:14:41 -0700 (PDT)
Message-ID: <b8019da1-d361-445b-a224-0761640aa616@arm.com>
Date: Tue, 16 Apr 2024 14:14:37 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/43] arm64: RME: Add wrappers for RMI calls
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084309.1733783-1-steven.price@arm.com>
 <20240412084309.1733783-7-steven.price@arm.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20240412084309.1733783-7-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steven

On 12/04/2024 09:42, Steven Price wrote:
> The wrappers make the call sites easier to read and deal with the
> boiler plate of handling the error codes from the RMM.
> 

I have compared the parameters and output values to that of the RMM spec
and they match. There are some minor nits below.

> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>   arch/arm64/include/asm/rmi_cmds.h | 509 ++++++++++++++++++++++++++++++
>   1 file changed, 509 insertions(+)
>   create mode 100644 arch/arm64/include/asm/rmi_cmds.h
> 
> diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
> new file mode 100644
> index 000000000000..c21414127e8e
> --- /dev/null
> +++ b/arch/arm64/include/asm/rmi_cmds.h
> @@ -0,0 +1,509 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2023 ARM Ltd.
> + */
> +
> +#ifndef __ASM_RMI_CMDS_H
> +#define __ASM_RMI_CMDS_H
> +
> +#include <linux/arm-smccc.h>
> +
> +#include <asm/rmi_smc.h>
> +
> +struct rtt_entry {
> +	unsigned long walk_level;
> +	unsigned long desc;
> +	int state;
> +	int ripas;
> +};
> +

...

> +/**
> + * rmi_data_destroy() - Destroy a Data Granule
> + * @rd: PA of the RD
> + * @ipa: IPA at which the granule is mapped in the guest
> + * @data_out: PA of the granule which was destroyed
> + * @top_out: Top IPA of non-live RTT entries
> + *
> + * Transitions the granule to DESTROYED state, the address cannot be used by
> + * the guest for the lifetime of the Realm.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_data_destroy(unsigned long rd, unsigned long ipa,
> +				   unsigned long *data_out,
> +				   unsigned long *top_out)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_DATA_DESTROY, rd, ipa, &res);
> +
> +	*data_out = res.a1;
> +	*top_out = res.a2;

minor nit: Do we need to be safer by checking the parameters before 
filling them in ? i.e.,

	if (ptr)
		*ptr = result_out;

This applies for others calls below.

> +
> +	return res.a0;
> +}

> +
> +/**
> + * rmi_realm_destroy() - Destroy a Realm
> + * @rd: PA of the RD
> + *
> + * Destroys a Realm, all objects belonging to the Realm must be destroyed first.
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_realm_destroy(unsigned long rd)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_1_1_invoke(SMC_RMI_REALM_DESTROY, rd, &res);
> +
> +	return res.a0;
> +}
> +
> +/**
> + * rmi_rec_aux_count() - Get number of auxiliary Granules required
> + * @rd: PA of the RD
> + * @aux_count: Number of pages written to this pointer
> + *
> + * A REC may require extra auxiliary pages to be delegateed for the RMM to

minor nit: "s/delegateed/delegated/"

...

> +/**
> + * rmi_rtt_read_entry() - Read an RTTE
> + * @rd: PA of the RD
> + * @ipa: IPA for which to read the RTTE
> + * @level: RTT level at which to read the RTTE
> + * @rtt: Output structure describing the RTTE
> + *
> + * Reads a RTTE (Realm Translation Table Entry).
> + *
> + * Return: RMI return code
> + */
> +static inline int rmi_rtt_read_entry(unsigned long rd, unsigned long ipa,
> +				     long level, struct rtt_entry *rtt)
> +{
> +	struct arm_smccc_1_2_regs regs = {
> +		SMC_RMI_RTT_READ_ENTRY,
> +		rd, ipa, level
> +	};
> +
> +	arm_smccc_1_2_smc(&regs, &regs);
> +
> +	rtt->walk_level = regs.a1;
> +	rtt->state = regs.a2 & 0xFF;

minor nit: We mask the state, but not the "ripas". Both of them are u8. 
For consistency, we should mask both or neither.

> +	rtt->desc = regs.a3;
> +	rtt->ripas = regs.a4;
> +
> +	return regs.a0;
> +}
> +

...

> +/**
> + * rmi_rtt_get_phys() - Get the PA from a RTTE
> + * @rtt: The RTTE
> + *
> + * Return: the physical address from a RTT entry.
> + */
> +static inline phys_addr_t rmi_rtt_get_phys(struct rtt_entry *rtt)
> +{
> +	return rtt->desc & GENMASK(47, 12);
> +}

I guess this may need to change with the LPA2 support in RMM and must be
used in conjunction with the "realm" object to make the correct
conversion.


Suzuki


> +
> +#endif


