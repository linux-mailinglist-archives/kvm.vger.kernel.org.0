Return-Path: <kvm+bounces-22534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59A909401C0
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 01:37:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BFD61C21E93
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 23:37:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6938218F2C8;
	Mon, 29 Jul 2024 23:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a7NBVWMS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47FE18D4C4
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 23:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722296256; cv=none; b=tcQh4A1VMYkGj0al+lLsmxZp2hkyQoScbFzoQIQW5k3Ux1YQ8UWfSH+pskhLQgVxE/XjsIpmnPbABqvGdgXvCNt2pxK5itw8Xn4hfjkE/ZXolakNwgq1KgsyjbkVuMIS2GOSgkfZ4G9aMlYgT16V7M530njzuuemNrEF35P9lho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722296256; c=relaxed/simple;
	bh=6/Xeogy1vRIFeiQoVc/PqoB3FLIDLiX+0Nry6YB4b2A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=htptoQjLf7YupXrrrSnYGk/PFySNr10zdgdVF130XHSAup0wZVxVWR//CvV/f8232CqJ/phKuiRJdznsqG+ClLfzXRjaTkfeLJvnlsbWxFHjn1/2PSYO7eis1tD8v3/4XPig+/J7hHpdc75DiBucZTltRJNsh525H+OlrIP/fkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a7NBVWMS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722296253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rYmAAB0qlkdPhNU6H9rrHKoah3EbC4V9mtuIUUVAOEw=;
	b=a7NBVWMSRsKrzU5ES69xGOcbMmjGZ6Xf4KJqiF4pwfQlexsTG5pSpLEDrDj9/fC8sa+vGV
	kMJx0DY1gtyYNz4yPs5BXn3K51NAh8gsJEN4nKuia8eSXzacwlmeV63VN1O2D+qpNX4Q4B
	agOPRcPevDgc1+vUT6+kIS6NDtv5/Xo=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-b-KirG6RMKGeBfhJtF__8g-1; Mon, 29 Jul 2024 19:37:31 -0400
X-MC-Unique: b-KirG6RMKGeBfhJtF__8g-1
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-3db2b8a3ed6so2621082b6e.2
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 16:37:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722296251; x=1722901051;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rYmAAB0qlkdPhNU6H9rrHKoah3EbC4V9mtuIUUVAOEw=;
        b=qJk8SQKSsO30qGIDhR7XnHPWBTLc/3dSYsh4YBqWK0GwOM6+5JIgPYUJSeqDWaxhnl
         xETFWVlBrkJyKj230BjQyR1T+4TGDgjBsZJpGcZFeqA9Px34IIGEbZaZ69j2nnxveO/q
         tsL01AJPdd2gQCNiMvurwsUagjGIpMHr+dXYbdyD0Dh5MeXNTxGD5NlL+wguygjYZ8f9
         GAEU/abbugvNW9F0MngeslabVoIPFFXkusynPrI4MVh8g4JPcMOA1QnJAyeRo8gJvlhT
         qSxjSTaMFHMd4TpavfApsATrRbKJtvdMyo3kNC+aR7+uNVvrOzLdxPBaCV1/OzTpE11J
         L6Yg==
X-Forwarded-Encrypted: i=1; AJvYcCUZpSx2sN3kBt2Qt8JvGH6Z99HlWkUKswxtgKp2rkpZhhRAZcBF5bdHDh4yARzG5f5k2ftTdq9RFAzf3BoOCAGgCdYq
X-Gm-Message-State: AOJu0YyO3D87Ez8K1vqWYGqXHxweYi2GuEaNEreLhQeTYPFhHNuaHSDl
	+SWJu/XGuS06TiPjlYgaQHUuioeoIuYQcCAlDZ3xgbUPeAxImPDROr+50aTZDIeTT1D24nnVjRK
	H2nkrb7d2iX5niyl7JQSmoClphzf1x69o0IPlaZ+zLoWqTk9ApA==
X-Received: by 2002:a05:6808:bd5:b0:3d9:22a4:d5f3 with SMTP id 5614622812f47-3db239d09a4mr13603397b6e.21.1722296250648;
        Mon, 29 Jul 2024 16:37:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IETOHCPOcvWc5jhOBqkV2140PExLjmylzs4Ybfkt9mudPgH3Q9MtP9S9MSCOGtMrFMDNMPzbg==
X-Received: by 2002:a05:6808:bd5:b0:3d9:22a4:d5f3 with SMTP id 5614622812f47-3db239d09a4mr13603373b6e.21.1722296250208;
        Mon, 29 Jul 2024 16:37:30 -0700 (PDT)
Received: from [192.168.68.54] ([43.252.112.134])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7a9fa5a3760sm7618434a12.94.2024.07.29.16.37.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jul 2024 16:37:29 -0700 (PDT)
Message-ID: <2b4f0496-99f4-4bc6-af6c-a8be8fca69a8@redhat.com>
Date: Tue, 30 Jul 2024 09:37:19 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/15] arm64: Detect if in a realm and set RIPAS RAM
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
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
References: <20240701095505.165383-1-steven.price@arm.com>
 <20240701095505.165383-4-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20240701095505.165383-4-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/1/24 7:54 PM, Steven Price wrote:
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
>   arch/arm64/include/asm/rsi.h      | 64 +++++++++++++++++++++++++
>   arch/arm64/include/asm/rsi_cmds.h | 22 +++++++++
>   arch/arm64/kernel/Makefile        |  3 +-
>   arch/arm64/kernel/rsi.c           | 77 +++++++++++++++++++++++++++++++
>   arch/arm64/kernel/setup.c         |  8 ++++
>   5 files changed, 173 insertions(+), 1 deletion(-)
>   create mode 100644 arch/arm64/include/asm/rsi.h
>   create mode 100644 arch/arm64/kernel/rsi.c
> 
> diff --git a/arch/arm64/include/asm/rsi.h b/arch/arm64/include/asm/rsi.h
> new file mode 100644
> index 000000000000..29fdc194d27b
> --- /dev/null
> +++ b/arch/arm64/include/asm/rsi.h
> @@ -0,0 +1,64 @@
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

@flags has been defined as int instead of unsigned long, which is inconsistent
to TF-RMM's definitions since it has type of 'unsigned long'.

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
> +	return rsi_set_memory_range(start, end, RSI_RIPAS_EMPTY, 0);
> +}
> +#endif

s/0/RSI_NO_CHANGE_DESTROYED
s/#endif/#endif /* __ASM_RSI_H_ */

> diff --git a/arch/arm64/include/asm/rsi_cmds.h b/arch/arm64/include/asm/rsi_cmds.h
> index 89e907f3af0c..acb557dd4b88 100644
> --- a/arch/arm64/include/asm/rsi_cmds.h
> +++ b/arch/arm64/include/asm/rsi_cmds.h
> @@ -10,6 +10,11 @@
>   
>   #include <asm/rsi_smc.h>
>   
> +enum ripas {
> +	RSI_RIPAS_EMPTY,
> +	RSI_RIPAS_RAM,
> +};
> +
>   static inline unsigned long rsi_request_version(unsigned long req,
>   						unsigned long *out_lower,
>   						unsigned long *out_higher)
> @@ -35,4 +40,21 @@ static inline unsigned long rsi_get_realm_config(struct realm_config *cfg)
>   	return res.a0;
>   }
>   
> +static inline unsigned long rsi_set_addr_range_state(phys_addr_t start,
> +						     phys_addr_t end,
> +						     enum ripas state,
> +						     unsigned long flags,
> +						     phys_addr_t *top)
> +{
> +	struct arm_smccc_res res;
> +
> +	arm_smccc_smc(SMC_RSI_IPA_STATE_SET, start, end, state,
> +		      flags, 0, 0, 0, &res);
> +
> +	if (top)
> +		*top = res.a1;
> +
> +	return res.a0;
> +}
> +
>   #endif
> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> index 763824963ed1..a483b916ed11 100644
> --- a/arch/arm64/kernel/Makefile
> +++ b/arch/arm64/kernel/Makefile
> @@ -33,7 +33,8 @@ obj-y			:= debug-monitors.o entry.o irq.o fpsimd.o		\
>   			   return_address.o cpuinfo.o cpu_errata.o		\
>   			   cpufeature.o alternative.o cacheinfo.o		\
>   			   smp.o smp_spin_table.o topology.o smccc-call.o	\
> -			   syscall.o proton-pack.o idle.o patching.o pi/
> +			   syscall.o proton-pack.o idle.o patching.o pi/	\
> +			   rsi.o
>   
>   obj-$(CONFIG_COMPAT)			+= sys32.o signal32.o			\
>   					   sys_compat.o
> diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
> new file mode 100644
> index 000000000000..f01bff9dab04
> --- /dev/null
> +++ b/arch/arm64/kernel/rsi.c
> @@ -0,0 +1,77 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2023 ARM Ltd.
> + */
> +
> +#include <linux/jump_label.h>
> +#include <linux/memblock.h>
> +#include <linux/psci.h>
> +#include <asm/rsi.h>
> +
> +DEFINE_STATIC_KEY_FALSE_RO(rsi_present);
> +EXPORT_SYMBOL(rsi_present);
> +
> +static bool rsi_version_matches(void)
> +{
> +	unsigned long ver_lower, ver_higher;
> +	unsigned long ret = rsi_request_version(RSI_ABI_VERSION,
> +						&ver_lower,
> +						&ver_higher);
> +
> +	if (ret == SMCCC_RET_NOT_SUPPORTED)
> +		return false;
> +
> +	if (ret != RSI_SUCCESS) {
> +		pr_err("RME: RMM doesn't support RSI version %u.%u. Supported range: %lu.%lu-%lu.%lu\n",
> +		       RSI_ABI_VERSION_MAJOR, RSI_ABI_VERSION_MINOR,
> +		       RSI_ABI_VERSION_GET_MAJOR(ver_lower),
> +		       RSI_ABI_VERSION_GET_MINOR(ver_lower),
> +		       RSI_ABI_VERSION_GET_MAJOR(ver_higher),
> +		       RSI_ABI_VERSION_GET_MINOR(ver_higher));
> +		return false;
> +	}
> +
> +	pr_info("RME: Using RSI version %lu.%lu\n",
> +		RSI_ABI_VERSION_GET_MAJOR(ver_lower),
> +		RSI_ABI_VERSION_GET_MINOR(ver_lower));
> +
> +	return true;
> +}
> +
> +void __init arm64_rsi_setup_memory(void)
> +{
> +	u64 i;
> +	phys_addr_t start, end;
> +
> +	if (!is_realm_world())
> +		return;
> +
> +	/*
> +	 * Iterate over the available memory ranges and convert the state to
                                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                                              blocks and convert them to

> +	 * protected memory. We should take extra care to ensure that we DO NOT
> +	 * permit any "DESTROYED" pages to be converted to "RAM".
> +	 *
> +	 * BUG_ON is used because if the attempt to switch the memory to
> +	 * protected has failed here, then future accesses to the memory are
> +	 * simply going to be reflected as a fault which we can't handle.
> +	 * Bailing out early prevents the guest limping on and dieing later.
> +	 */
> +	for_each_mem_range(i, &start, &end) {
> +		BUG_ON(rsi_set_memory_range_protected_safe(start, end));
> +	}
> +}
> +

If I'm understanding the code completely, this changes the memory state from
RIPAS_EMPTY to RIPAS_RAM so that the following page faults can be routed to
host properly. Otherwise, a SEA is injected to the realm according to
tf-rmm/runtime/core/exit.c::handle_data_abort(). The comments can be more
explicit to replace "fault" with "SEA (Synchronous External Abort)".

Besides, this forces a guest exit with reason RMI_EXIT_RIPAS_CHANGE which is
handled by the host, where RMI_RTT_SET_RIPAS is triggered to convert the memory
state from RIPAS_EMPTY to RIPAS_RAM. The question is why the conversion can't
be done by VMM (QEMU)?

> +void __init arm64_rsi_init(void)
> +{
> +	/*
> +	 * If PSCI isn't using SMC, RMM isn't present. Don't try to execute an
> +	 * SMC as it could be UNDEFINED.
> +	 */
> +	if (!psci_early_test_conduit(SMCCC_CONDUIT_SMC))
> +		return;
> +	if (!rsi_version_matches())
> +		return;
> +
> +	static_branch_enable(&rsi_present);
> +}
> +
> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
> index a096e2451044..143f87615af0 100644
> --- a/arch/arm64/kernel/setup.c
> +++ b/arch/arm64/kernel/setup.c
> @@ -43,6 +43,7 @@
>   #include <asm/cpu_ops.h>
>   #include <asm/kasan.h>
>   #include <asm/numa.h>
> +#include <asm/rsi.h>
>   #include <asm/scs.h>
>   #include <asm/sections.h>
>   #include <asm/setup.h>
> @@ -293,6 +294,11 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
>   	 * cpufeature code and early parameters.
>   	 */
>   	jump_label_init();
> +	/*
> +	 * Init RSI before early param so that "earlycon" console uses the
> +	 * shared alias when in a realm
> +	 */
> +	arm64_rsi_init();
>   	parse_early_param();
>   
>   	dynamic_scs_init();
> @@ -328,6 +334,8 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
>   
>   	arm64_memblock_init();
>   
> +	arm64_rsi_setup_memory();
> +
>   	paging_init();
>   
>   	acpi_table_upgrade();

Thanks,
Gavin


