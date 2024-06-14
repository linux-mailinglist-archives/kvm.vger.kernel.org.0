Return-Path: <kvm+bounces-19709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 59C6B90929E
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 20:57:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D7AA61F22418
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 18:57:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D750C1A0B05;
	Fri, 14 Jun 2024 18:57:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A17DC1474B1;
	Fri, 14 Jun 2024 18:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718391442; cv=none; b=IXMGNXdYt2jZRfHape57AVxTUllD9YGZMeSrjOSWk5k1Mm8rF9jMFY4gI5obrovhwRKoHDYN0KSzPWu4U0zPJacOAHRz1OneX/nYrxsOWX5G1W4ih5daNk886HaF/HkxNfLk3RtCVutlOkOnpJgU8Lbk12DHeqKStQok2+sJLJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718391442; c=relaxed/simple;
	bh=iDPcJaA7xeFloUdvPGvsZvDIj62pzgEpRyrRvAp9jk0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S+Ei/pi64bnB87VbhMjXpBfgfSzbNaJfF0rvmschozupc9wSHE0YIDrh2Cv26Pe8G+RtzlZ61fx17oca2OFNZaDsybAiFjoN9l3CRG2ylYnYtyl3ErlPMhocrjqdS61Wrs33EBsVuihd+l5q1w5QfIkYjrIZGtR2Gi+HtqI+65U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4D1D9FEC;
	Fri, 14 Jun 2024 11:57:42 -0700 (PDT)
Received: from [10.57.72.20] (unknown [10.57.72.20])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E3BEE3F73B;
	Fri, 14 Jun 2024 11:57:14 -0700 (PDT)
Message-ID: <6bdb0ff9-dba0-408c-9472-ef03339bfa7a@arm.com>
Date: Fri, 14 Jun 2024 19:57:13 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/14] arm64: Detect if in a realm and set RIPAS RAM
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
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
References: <20240605093006.145492-1-steven.price@arm.com>
 <20240605093006.145492-3-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20240605093006.145492-3-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steven

On 05/06/2024 10:29, Steven Price wrote:
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
>   arch/arm64/include/asm/rsi.h      | 48 +++++++++++++++++++++
>   arch/arm64/include/asm/rsi_cmds.h | 22 ++++++++++
>   arch/arm64/kernel/Makefile        |  3 +-
>   arch/arm64/kernel/rsi.c           | 69 +++++++++++++++++++++++++++++++
>   arch/arm64/kernel/setup.c         |  8 ++++
>   arch/arm64/mm/init.c              |  1 +
>   6 files changed, 150 insertions(+), 1 deletion(-)
>   create mode 100644 arch/arm64/include/asm/rsi.h
>   create mode 100644 arch/arm64/kernel/rsi.c
> 
> diff --git a/arch/arm64/include/asm/rsi.h b/arch/arm64/include/asm/rsi.h
> new file mode 100644
> index 000000000000..ce2cdb501d84
> --- /dev/null
> +++ b/arch/arm64/include/asm/rsi.h
> @@ -0,0 +1,48 @@
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
> +				       enum ripas state)
> +{
> +	unsigned long ret;
> +	phys_addr_t top;
> +
> +	while (start != end) {
> +		ret = rsi_set_addr_range_state(start, end, state, &top);
> +		if (WARN_ON(ret || top < start || top > end))
> +			return -EINVAL;
> +		start = top;
> +	}
> +
> +	return 0;
> +}
> +
> +static inline int rsi_set_memory_range_protected(phys_addr_t start,
> +						 phys_addr_t end)
> +{
> +	return rsi_set_memory_range(start, end, RSI_RIPAS_RAM);
> +}
> +
> +static inline int rsi_set_memory_range_shared(phys_addr_t start,
> +					      phys_addr_t end)
> +{
> +	return rsi_set_memory_range(start, end, RSI_RIPAS_EMPTY);
> +}
> +#endif
> diff --git a/arch/arm64/include/asm/rsi_cmds.h b/arch/arm64/include/asm/rsi_cmds.h
> index ad425c5d6f1b..ab8ad435f10e 100644
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
>   static inline void invoke_rsi_fn_smc_with_res(unsigned long function_id,
>   					      unsigned long arg0,
>   					      unsigned long arg1,
> @@ -44,4 +49,21 @@ static inline unsigned long rsi_get_realm_config(struct realm_config *cfg)
>   	return res.a0;
>   }
>   
> +static inline unsigned long rsi_set_addr_range_state(phys_addr_t start,
> +						     phys_addr_t end,
> +						     enum ripas state,
> +						     phys_addr_t *top)
> +{
> +	struct arm_smccc_res res;
> +
> +	invoke_rsi_fn_smc_with_res(SMC_RSI_IPA_STATE_SET,
> +				   start, end, state, RSI_NO_CHANGE_DESTROYED,

Though this is fine from the KVM as NS Host perspective, it may be 
unnecessarily restrictive in general for a Host implementation. We only
need that RSI_NO_CHANGE_DESTROYED flag for "init all DRAM range as RAM"
(where we want to prevent a host from "destroying pages" that were
populated before activation, without consent). But in all other cases
where we do not rely on the content of the "newly" encrypted page,
we could drop the flag.

I think we need could have variants of this helper one which allows 
"DESTROYED" granules to be converted, which must be only used while 
"transitioning" a page to encrypted, where we don't rely on the contents 
of the page.

Something like :

rsi_set_memory_range_protected_safe() : Do not allow DESTROYED contents 
to be converted.

rsi_set_memory_range_protected().

Something like:

---8>---

diff --git a/arch/arm64/include/asm/rsi.h b/arch/arm64/include/asm/rsi.h
index ce2cdb501d84..dea2ed99f6d1 100644
--- a/arch/arm64/include/asm/rsi.h
+++ b/arch/arm64/include/asm/rsi.h
@@ -19,13 +19,13 @@ static inline bool is_realm_world(void)
  }

  static inline int rsi_set_memory_range(phys_addr_t start, phys_addr_t end,
-				       enum ripas state)
+				       enum ripas state, unsigned long flags)
  {
  	unsigned long ret;
  	phys_addr_t top;

  	while (start != end) {
-		ret = rsi_set_addr_range_state(start, end, state, &top);
+		ret = rsi_set_addr_range_state(start, end, state, flags, &top);
  		if (WARN_ON(ret || top < start || top > end))
  			return -EINVAL;
  		start = top;
@@ -34,15 +34,29 @@ static inline int rsi_set_memory_range(phys_addr_t 
start, phys_addr_t end,
  	return 0;
  }

+/*
+ * Convert the specified range to RAM. Do not use this if you rely on 
the contents
+ * of a page that may already be in RAM state.
+ */
  static inline int rsi_set_memory_range_protected(phys_addr_t start,
  						 phys_addr_t end)
  {
-	return rsi_set_memory_range(start, end, RSI_RIPAS_RAM);
+	return rsi_set_memory_range(start, end, RSI_RIPAS_RAM, 0);
+}
+
+/*
+ * Convert the specified range to RAM. Do not convert any pages that 
may have
+ * been DESTROYED, without our permission.
+ */
+static inline int rsi_set_memory_range_protected_safe(phys_addr_t start,
+						      phys_addr_t end)
+{
+	return rsi_set_memory_range(start, end, RSI_RIPAS_RAM, 
RSI_NO_CHANGE_DESTROYED);
  }

  static inline int rsi_set_memory_range_shared(phys_addr_t start,
  					      phys_addr_t end)
  {
-	return rsi_set_memory_range(start, end, RSI_RIPAS_EMPTY);
+	return rsi_set_memory_range(start, end, RSI_RIPAS_EMPTY, 0);
  }
  #endif
diff --git a/arch/arm64/include/asm/rsi_cmds.h 
b/arch/arm64/include/asm/rsi_cmds.h
index ab8ad435f10e..466615ff90de 100644
--- a/arch/arm64/include/asm/rsi_cmds.h
+++ b/arch/arm64/include/asm/rsi_cmds.h
@@ -52,12 +52,13 @@ static inline unsigned long 
rsi_get_realm_config(struct realm_config *cfg)
  static inline unsigned long rsi_set_addr_range_state(phys_addr_t start,
  						     phys_addr_t end,
  						     enum ripas state,
+						     unsigned long flags,
  						     phys_addr_t *top)
  {
  	struct arm_smccc_res res;

  	invoke_rsi_fn_smc_with_res(SMC_RSI_IPA_STATE_SET,
-				   start, end, state, RSI_NO_CHANGE_DESTROYED,
+				   start, end, state, flags,
  				   &res);

  	if (top)
diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
index 3a992bdfd6bb..e6a6681524a0 100644
--- a/arch/arm64/kernel/rsi.c
+++ b/arch/arm64/kernel/rsi.c
@@ -46,8 +46,9 @@ void __init arm64_rsi_setup_memory(void)
  		return;

  	/*
-	 * Iterate over the available memory ranges
-	 * and convert the state to protected memory.
+	 * Iterate over the available memory ranges and convert the state to
+	 * protected memory. We should take extra care to ensure that we DO NOT
+	 * permit any "DESTROYED" pages to be converted to "RAM".
  	 *
  	 * BUG_ON is used because if the attempt to switch the memory to
  	 * protected has failed here, then future accesses to the memory are
@@ -55,7 +56,7 @@ void __init arm64_rsi_setup_memory(void)
  	 * Bailing out early prevents the guest limping on and dieing later.
  	 */
  	for_each_mem_range(i, &start, &end) {
-		BUG_ON(rsi_set_memory_range_protected(start, end));
+		BUG_ON(rsi_set_memory_range_protected_safe(start, end));
  	}
  }



Kind regards


Suzuki


> +				   &res);
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
> index 000000000000..3a992bdfd6bb
> --- /dev/null
> +++ b/arch/arm64/kernel/rsi.c
> @@ -0,0 +1,69 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2023 ARM Ltd.
> + */
> +
> +#include <linux/jump_label.h>
> +#include <linux/memblock.h>
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
> +	 * Iterate over the available memory ranges
> +	 * and convert the state to protected memory.
> +	 *
> +	 * BUG_ON is used because if the attempt to switch the memory to
> +	 * protected has failed here, then future accesses to the memory are
> +	 * simply going to be reflected as a fault which we can't handle.
> +	 * Bailing out early prevents the guest limping on and dieing later.
> +	 */
> +	for_each_mem_range(i, &start, &end) {
> +		BUG_ON(rsi_set_memory_range_protected(start, end));
> +	}
> +}
> +
> +void __init arm64_rsi_init(void)
> +{
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
> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> index 9b5ab6818f7f..9d8d38e3bee2 100644
> --- a/arch/arm64/mm/init.c
> +++ b/arch/arm64/mm/init.c
> @@ -41,6 +41,7 @@
>   #include <asm/kvm_host.h>
>   #include <asm/memory.h>
>   #include <asm/numa.h>
> +#include <asm/rsi.h>
>   #include <asm/sections.h>
>   #include <asm/setup.h>
>   #include <linux/sizes.h>


