Return-Path: <kvm+bounces-24833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 83FC495BACE
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 17:44:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 093201F22003
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 15:44:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00C751CC89B;
	Thu, 22 Aug 2024 15:44:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1219A17C7C9;
	Thu, 22 Aug 2024 15:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724341468; cv=none; b=ggdmv0iv/bf1/aiwHhDzHM0izSJitLtBFLjLjRrZPaHxKtQ63Fb4w9OYRBbw61SLQ3IlL00g+hcU9twkWoJVZ5/ArdSpVz1qJP6d/+/juPltTZlFG3l77RT1ReKFf4tNeMVxp2FULcvNQvo5J7ajtT/mtRRqe/txSQaiepuhrD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724341468; c=relaxed/simple;
	bh=bVp52h0ZAViCvx5Fu8FuOEuKUIw7N5AReDsofzoN+IQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IN2H/KfEV+WMn0bnEoiry5fGKV4wpwYB43LfYL3Uizy3KWpXdZrRjDwgfejRYVROd9bqy+bJ2wv6ROFTdrscBK8EweznfxXYwC+gMcArbi1z4i8hz5/Jppg5453CnVu4g7vt6mYRKsjA+cEg1LGBYJD3QQMO9XLnI3N1gnjWT5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9B73ADA7;
	Thu, 22 Aug 2024 08:44:51 -0700 (PDT)
Received: from [10.57.72.240] (unknown [10.57.72.240])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0DA2D3F58B;
	Thu, 22 Aug 2024 08:44:22 -0700 (PDT)
Message-ID: <26c56f74-629b-48f9-bf73-e559be0cca75@arm.com>
Date: Thu, 22 Aug 2024 16:44:21 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/43] arm64: RME: Add SMC definitions for calling the
 RMM
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
References: <20240821153844.60084-1-steven.price@arm.com>
 <20240821153844.60084-6-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20240821153844.60084-6-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steven

On 21/08/2024 16:38, Steven Price wrote:
> The RMM (Realm Management Monitor) provides functionality that can be
> accessed by SMC calls from the host.
> 
> The SMC definitions are based on DEN0137[1] version 1.0-rel0-rc1
> 
> [1] https://developer.arm.com/-/cdn-downloads/permalink/PDF/Architectures/DEN0137_1.0-rel0-rc1_rmm-arch_external.pdf
> 

The definitions match RMM spec. Some ultra minor comments below, feel 
free to ignore ;-)

> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v3:
>   * Update to match RMM spec v1.0-rel0-rc1.
> Changes since v2:
>   * Fix specification link.
>   * Rename rec_entry->rec_enter to match spec.
>   * Fix size of pmu_ovf_status to match spec.
> ---
>   arch/arm64/include/asm/rmi_smc.h | 253 +++++++++++++++++++++++++++++++
>   1 file changed, 253 insertions(+)
>   create mode 100644 arch/arm64/include/asm/rmi_smc.h
> 
> diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
> new file mode 100644
> index 000000000000..5ee71c12a9cd
> --- /dev/null
> +++ b/arch/arm64/include/asm/rmi_smc.h
> @@ -0,0 +1,253 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2023-2024 ARM Ltd.
> + *
> + * The values and structures in this file are from the Realm Management Monitor
> + * specification (DEN0137) version 1.0-rel0-rc1:
> + * https://developer.arm.com/-/cdn-downloads/permalink/PDF/Architectures/DEN0137_1.0-rel0-rc1_rmm-arch_external.pdf
> + */
> +
> +#ifndef __ASM_RME_SMC_H
> +#define __ASM_RME_SMC_H
> +
> +#include <linux/arm-smccc.h>
> +
> +#define SMC_RxI_CALL(func)				\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
> +			   ARM_SMCCC_SMC_64,		\
> +			   ARM_SMCCC_OWNER_STANDARD,	\
> +			   (func))
> +
> +#define SMC_RMI_DATA_CREATE		SMC_RxI_CALL(0x0153)
> +#define SMC_RMI_DATA_CREATE_UNKNOWN	SMC_RxI_CALL(0x0154)
> +#define SMC_RMI_DATA_DESTROY		SMC_RxI_CALL(0x0155)
> +#define SMC_RMI_FEATURES		SMC_RxI_CALL(0x0165)
> +#define SMC_RMI_GRANULE_DELEGATE	SMC_RxI_CALL(0x0151)
> +#define SMC_RMI_GRANULE_UNDELEGATE	SMC_RxI_CALL(0x0152)
> +#define SMC_RMI_PSCI_COMPLETE		SMC_RxI_CALL(0x0164)
> +#define SMC_RMI_REALM_ACTIVATE		SMC_RxI_CALL(0x0157)
> +#define SMC_RMI_REALM_CREATE		SMC_RxI_CALL(0x0158)
> +#define SMC_RMI_REALM_DESTROY		SMC_RxI_CALL(0x0159)
> +#define SMC_RMI_REC_AUX_COUNT		SMC_RxI_CALL(0x0167)
> +#define SMC_RMI_REC_CREATE		SMC_RxI_CALL(0x015a)
> +#define SMC_RMI_REC_DESTROY		SMC_RxI_CALL(0x015b)
> +#define SMC_RMI_REC_ENTER		SMC_RxI_CALL(0x015c)
> +#define SMC_RMI_RTT_CREATE		SMC_RxI_CALL(0x015d)
> +#define SMC_RMI_RTT_DESTROY		SMC_RxI_CALL(0x015e)
> +#define SMC_RMI_RTT_FOLD		SMC_RxI_CALL(0x0166)
> +#define SMC_RMI_RTT_INIT_RIPAS		SMC_RxI_CALL(0x0168)
> +#define SMC_RMI_RTT_MAP_UNPROTECTED	SMC_RxI_CALL(0x015f)
> +#define SMC_RMI_RTT_READ_ENTRY		SMC_RxI_CALL(0x0161)
> +#define SMC_RMI_RTT_SET_RIPAS		SMC_RxI_CALL(0x0169)
> +#define SMC_RMI_RTT_UNMAP_UNPROTECTED	SMC_RxI_CALL(0x0162)
> +#define SMC_RMI_VERSION			SMC_RxI_CALL(0x0150)
> +
> +#define RMI_ABI_MAJOR_VERSION	1
> +#define RMI_ABI_MINOR_VERSION	0
> +
> +#define RMI_UNASSIGNED			0
> +#define RMI_ASSIGNED			1
> +#define RMI_TABLE			2
> +
> +#define RMI_ABI_VERSION_GET_MAJOR(version) ((version) >> 16)
> +#define RMI_ABI_VERSION_GET_MINOR(version) ((version) & 0xFFFF)
> +#define RMI_ABI_VERSION(major, minor)      (((major) << 16) | (minor))

super minor nit: Please could we keep it closer to the 
RMI_ABI_M..R_VERSION defintions ?
	
> +
> +#define RMI_RETURN_STATUS(ret)		((ret) & 0xFF)
> +#define RMI_RETURN_INDEX(ret)		(((ret) >> 8) & 0xFF)
> +
> +#define RMI_SUCCESS		0
> +#define RMI_ERROR_INPUT		1
> +#define RMI_ERROR_REALM		2
> +#define RMI_ERROR_REC		3
> +#define RMI_ERROR_RTT		4
> +
> +#define RMI_EMPTY		0
> +#define RMI_RAM			1
> +#define RMI_DESTROYED		2
> +
> +#define RMI_NO_MEASURE_CONTENT	0
> +#define RMI_MEASURE_CONTENT	1
> +
> +#define RMI_FEATURE_REGISTER_0_S2SZ		GENMASK(7, 0)
> +#define RMI_FEATURE_REGISTER_0_LPA2		BIT(8)
> +#define RMI_FEATURE_REGISTER_0_SVE_EN		BIT(9)
> +#define RMI_FEATURE_REGISTER_0_SVE_VL		GENMASK(13, 10)
> +#define RMI_FEATURE_REGISTER_0_NUM_BPS		GENMASK(19, 14)
> +#define RMI_FEATURE_REGISTER_0_NUM_WPS		GENMASK(25, 20)
> +#define RMI_FEATURE_REGISTER_0_PMU_EN		BIT(26)
> +#define RMI_FEATURE_REGISTER_0_PMU_NUM_CTRS	GENMASK(31, 27)
> +#define RMI_FEATURE_REGISTER_0_HASH_SHA_256	BIT(32)
> +#define RMI_FEATURE_REGISTER_0_HASH_SHA_512	BIT(33)
> +#define RMI_FEATURE_REGISTER_0_GICV3_NUM_LRS	GENMASK(37, 34)
> +#define RMI_FEATURE_REGISTER_0_MAX_RECS_ORDER	GENMASK(41, 38)
> +
> +#define RMI_REALM_PARAM_FLAG_LPA2		BIT(0)
> +#define RMI_REALM_PARAM_FLAG_SVE		BIT(1)
> +#define RMI_REALM_PARAM_FLAG_PMU		BIT(2)
> +
> +/*
> + * Note many of these fields are smaller than u64 but all fields have u64
> + * alignment, so use u64 to ensure correct alignment.
> + */
> +struct realm_params {
> +	union { /* 0x0 */
> +		struct {
> +			u64 flags;
> +			u64 s2sz;
> +			u64 sve_vl;
> +			u64 num_bps;
> +			u64 num_wps;
> +			u64 pmu_num_ctrs;
> +			u64 hash_algo;
> +		};
> +		u8 padding_1[0x400];

super minor nit: padding_[0-9] vs padding[0-9] below for other objects.
It may be nicer to keep them consistent.

> +	};
> +	union { /* 0x400 */
> +		u8 rpv[64];
> +		u8 padding_2[0x400];
> +	};
> +	union { /* 0x800 */
> +		struct {
> +			u64 vmid;
> +			u64 rtt_base;
> +			s64 rtt_level_start;
> +			u64 rtt_num_start;
> +		};
> +		u8 padding_3[0x800];
> +	};
> +};
> +
> +/*
> + * The number of GPRs (starting from X0) that are
> + * configured by the host when a REC is created.
> + */
> +#define REC_CREATE_NR_GPRS		8
> +
> +#define REC_PARAMS_FLAG_RUNNABLE	BIT_ULL(0)
> +
> +#define REC_PARAMS_AUX_GRANULES		16
> +
> +struct rec_params {
> +	union { /* 0x0 */
> +		u64 flags;
> +		u8 padding1[0x100];
> +	};
> +	union { /* 0x100 */
> +		u64 mpidr;
> +		u8 padding2[0x100];
> +	};
> +	union { /* 0x200 */
> +		u64 pc;
> +		u8 padding3[0x100];
> +	};
> +	union { /* 0x300 */
> +		u64 gprs[REC_CREATE_NR_GPRS];
> +		u8 padding4[0x500];
> +	};
> +	union { /* 0x800 */
> +		struct {
> +			u64 num_rec_aux;
> +			u64 aux[REC_PARAMS_AUX_GRANULES];
> +		};
> +		u8 padding5[0x800];
> +	};
> +};
> +
> +#define RMI_EMULATED_MMIO		BIT(0)
> +#define RMI_INJECT_SEA			BIT(1)
> +#define RMI_TRAP_WFI			BIT(2)
> +#define RMI_TRAP_WFE			BIT(3)
> +#define RMI_RIPAS_RESPONSE		BIT(4)

minor nit: I was hoping to suggest something that gives a clue of
REC_ENTER_FLAGS, but it may be too long.

#define RMI_REC_ENTER_FLAG_EMULATED_MMIO	BIT(0)
#define RMI_REC_ENTER_..

similar to REC_PARAM_FLAG/RMI_PARAM_FLAG.

May be REC_ENTER_FLAG_xxx even. Thoughts ?

Suzuki

> +
> +#define REC_RUN_GPRS			31
> +#define REC_GIC_NUM_LRS			16
> +
> +struct rec_enter {
> +	union { /* 0x000 */
> +		u64 flags;
> +		u8 padding0[0x200];
> +	};
> +	union { /* 0x200 */
> +		u64 gprs[REC_RUN_GPRS];
> +		u8 padding2[0x100];
> +	};
> +	union { /* 0x300 */
> +		struct {
> +			u64 gicv3_hcr;
> +			u64 gicv3_lrs[REC_GIC_NUM_LRS];
> +		};
> +		u8 padding3[0x100];
> +	};
> +	u8 padding4[0x400];
> +};
> +
> +#define RMI_EXIT_SYNC			0x00
> +#define RMI_EXIT_IRQ			0x01
> +#define RMI_EXIT_FIQ			0x02
> +#define RMI_EXIT_PSCI			0x03
> +#define RMI_EXIT_RIPAS_CHANGE		0x04
> +#define RMI_EXIT_HOST_CALL		0x05
> +#define RMI_EXIT_SERROR			0x06
> +
> +struct rec_exit {
> +	union { /* 0x000 */
> +		u8 exit_reason;
> +		u8 padding0[0x100];
> +	};
> +	union { /* 0x100 */
> +		struct {
> +			u64 esr;
> +			u64 far;
> +			u64 hpfar;
> +		};
> +		u8 padding1[0x100];
> +	};
> +	union { /* 0x200 */
> +		u64 gprs[REC_RUN_GPRS];
> +		u8 padding2[0x100];
> +	};
> +	union { /* 0x300 */
> +		struct {
> +			u64 gicv3_hcr;
> +			u64 gicv3_lrs[REC_GIC_NUM_LRS];
> +			u64 gicv3_misr;
> +			u64 gicv3_vmcr;
> +		};
> +		u8 padding3[0x100];
> +	};
> +	union { /* 0x400 */
> +		struct {
> +			u64 cntp_ctl;
> +			u64 cntp_cval;
> +			u64 cntv_ctl;
> +			u64 cntv_cval;
> +		};
> +		u8 padding4[0x100];
> +	};
> +	union { /* 0x500 */
> +		struct {
> +			u64 ripas_base;
> +			u64 ripas_top;
> +			u64 ripas_value;
> +		};
> +		u8 padding5[0x100];
> +	};
> +	union { /* 0x600 */
> +		u16 imm;
> +		u8 padding6[0x100];
> +	};
> +	union { /* 0x700 */
> +		struct {
> +			u8 pmu_ovf_status;
> +		};
> +		u8 padding7[0x100];
> +	};
> +};
> +
> +struct rec_run {
> +	struct rec_enter enter;
> +	struct rec_exit exit;
> +};
> +
> +#endif


