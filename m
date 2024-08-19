Return-Path: <kvm+bounces-24524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AEE61956C9F
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 16:04:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B90B11C21F19
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 14:04:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD42316CD10;
	Mon, 19 Aug 2024 14:04:37 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAEFD166F14;
	Mon, 19 Aug 2024 14:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724076277; cv=none; b=ZbrJr6ws9qx+VXr5gKYdCIWd1EVdt95dlI4jEAZw3XL9QtBxtCmiWpfYy0bvUQZg4x8UZiJC7PPMXT3Q6iezfhN+lnvx7FpmG8FOw80GsAGRywSmZtrz6oRfhDlRGRV2GxCgoW1DbGFSKf8OD4EuG+GwWuFmpjvPO9d3HeGetfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724076277; c=relaxed/simple;
	bh=XLs5mWwOe//LOpNWPEWluBimnD/2iOrU99fgDSewvhY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kemL/cvmtGvTQQYcR74Hk5tJ7ADbZ2oBrBGkHo4BwqwjGC/048WNsupgz1vjKMdyCl1vvU0xmCE56cRaZe153ewtEB4CBbIKKMDd20tdW60VgrKsb9FJ7+5eHxI78xDBMeAbyvP6I8V0UMKyBOSPc5giBZufldO03NagkmaHCvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ED059339;
	Mon, 19 Aug 2024 07:04:59 -0700 (PDT)
Received: from [10.1.36.36] (FVFF763DQ05P.cambridge.arm.com [10.1.36.36])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9A59D3F73B;
	Mon, 19 Aug 2024 07:04:31 -0700 (PDT)
Message-ID: <ff5a11d6-8208-4987-af03-f67b10cc5904@arm.com>
Date: Mon, 19 Aug 2024 15:04:30 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/19] arm64: Detect if in a realm and set RIPAS RAM
Content-Language: en-GB
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
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
 Alper Gun <alpergun@google.com>
References: <20240819131924.372366-1-steven.price@arm.com>
 <20240819131924.372366-6-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20240819131924.372366-6-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steven

On 19/08/2024 14:19, Steven Price wrote:
> From: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> Detect that the VM is a realm guest by the presence of the RSI
> interface.
> 
> If in a realm then all memory needs to be marked as RIPAS RAM initially,
> the loader may or may not have done this for us. To be sure iterate over
> all RAM and mark it as such. Any failure is fatal as that implies the
> RAM regions passed to Linux are incorrect - which would mean failing
> later when attempting to access non-existent RAM.
> 
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Co-developed-by: Steven Price <steven.price@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v4:
>   * Minor tidy ups.
> Changes since v3:
>   * Provide safe/unsafe versions for converting memory to protected,
>     using the safer version only for the early boot.
>   * Use the new psci_early_test_conduit() function to avoid calling an
>     SMC if EL3 is not present (or not configured to handle an SMC).
> Changes since v2:
>   * Use DECLARE_STATIC_KEY_FALSE rather than "extern struct
>     static_key_false".
>   * Rename set_memory_range() to rsi_set_memory_range().
>   * Downgrade some BUG()s to WARN()s and handle the condition by
>     propagating up the stack. Comment the remaining case that ends in a
>     BUG() to explain why.
>   * Rely on the return from rsi_request_version() rather than checking
>     the version the RMM claims to support.
>   * Rename the generic sounding arm64_setup_memory() to
>     arm64_rsi_setup_memory() and move the call site to setup_arch().
> ---
>   arch/arm64/include/asm/rsi.h | 65 ++++++++++++++++++++++++++++++
>   arch/arm64/kernel/Makefile   |  3 +-
>   arch/arm64/kernel/rsi.c      | 78 ++++++++++++++++++++++++++++++++++++
>   arch/arm64/kernel/setup.c    |  8 ++++
>   4 files changed, 153 insertions(+), 1 deletion(-)
>   create mode 100644 arch/arm64/include/asm/rsi.h
>   create mode 100644 arch/arm64/kernel/rsi.c
> 
> diff --git a/arch/arm64/include/asm/rsi.h b/arch/arm64/include/asm/rsi.h
> new file mode 100644
> index 000000000000..2bc013badbc3
> --- /dev/null
> +++ b/arch/arm64/include/asm/rsi.h
> @@ -0,0 +1,65 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (C) 2024 ARM Ltd.
> + */
> +
> +#ifndef __ASM_RSI_H_
> +#define __ASM_RSI_H_
> +
> +#include <linux/jump_label.h>
> +#include <asm/rsi_cmds.h>
> +
> +DECLARE_STATIC_KEY_FALSE(rsi_present);
> +
> +void __init arm64_rsi_init(void);
> +void __init arm64_rsi_setup_memory(void);
> +static inline bool is_realm_world(void)
> +{
> +	return static_branch_unlikely(&rsi_present);
> +}
> +
> +static inline int rsi_set_memory_range(phys_addr_t start, phys_addr_t end,
> +				       enum ripas state, unsigned long flags)
> +{
> +	unsigned long ret;
> +	phys_addr_t top;
> +
> +	while (start != end) {
> +		ret = rsi_set_addr_range_state(start, end, state, flags, &top);
> +		if (WARN_ON(ret || top < start || top > end))
> +			return -EINVAL;
> +		start = top;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Convert the specified range to RAM. Do not use this if you rely on the
> + * contents of a page that may already be in RAM state.
> + */
> +static inline int rsi_set_memory_range_protected(phys_addr_t start,
> +						 phys_addr_t end)
> +{
> +	return rsi_set_memory_range(start, end, RSI_RIPAS_RAM,
> +				    RSI_CHANGE_DESTROYED);
> +}
> +
> +/*
> + * Convert the specified range to RAM. Do not convert any pages that may have
> + * been DESTROYED, without our permission.
> + */
> +static inline int rsi_set_memory_range_protected_safe(phys_addr_t start,
> +						      phys_addr_t end)
> +{
> +	return rsi_set_memory_range(start, end, RSI_RIPAS_RAM,
> +				    RSI_NO_CHANGE_DESTROYED);
> +}
> +
> +static inline int rsi_set_memory_range_shared(phys_addr_t start,
> +					      phys_addr_t end)
> +{
> +	return rsi_set_memory_range(start, end, RSI_RIPAS_EMPTY,
> +				    RSI_NO_CHANGE_DESTROYED);

I think this should be RSI_CHANGE_DESTROYED, as we are transitioning a 
page to "shared" (i.e, IPA state to EMPTY) and we do not expect the data
to be retained over the transition. Thus we do not care if the IPA was
in RIPAS_DESTROYED.

Rest looks good to me.


Suzuki

