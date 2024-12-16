Return-Path: <kvm+bounces-33872-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1963A9F37E3
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 18:51:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4BB081674BB
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 17:51:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 855B7207641;
	Mon, 16 Dec 2024 17:51:11 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A1B42063C4;
	Mon, 16 Dec 2024 17:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734371471; cv=none; b=PYqunYyeD1MsWDoPBwULRndMh3WvSNo/nHqggd6j92i170aVBcW6qgdo2nhP+Se7UUv/vIATZo5ODzrQQ7gDcU3r1s1sVoEkN1mm/mlhOveEPDS42dyYsecFEs+nguev0ZNpoZHBAg1DyPg69gDKtllaYJ6Vht5iKv0rh+Gj64s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734371471; c=relaxed/simple;
	bh=rBCWtRTu5Vr8cgrNPrVT8W5KU7Hajgp2sLYgmxLWcRU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AgpjhYoVNH9SXMUVwpVx+7LGjf1LhrzL/YrRAZ4zzf4gYSql2Lwixwqz49uoEbc+vUMd+F6NFrZYsXK32m+sAVuFWw3gMLSu9Qfv5+YRJ+uZ9VpKzKtAgOgSnhx488EVcLo02EwV/CI3Mw+PI9gZedgJNHSbOAdceHf6dXDHVm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 65D33106F;
	Mon, 16 Dec 2024 09:51:35 -0800 (PST)
Received: from [10.57.71.247] (unknown [10.57.71.247])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4F4BF3F58B;
	Mon, 16 Dec 2024 09:51:04 -0800 (PST)
Message-ID: <e88930d3-f933-41a3-a698-3a34633e5019@arm.com>
Date: Mon, 16 Dec 2024 17:51:03 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 04/43] arm64: RME: Add SMC definitions for calling the
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
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>
References: <20241212155610.76522-1-steven.price@arm.com>
 <20241212155610.76522-5-steven.price@arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20241212155610.76522-5-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/2024 15:55, Steven Price wrote:
> The RMM (Realm Management Monitor) provides functionality that can be
> accessed by SMC calls from the host.
> 
> The SMC definitions are based on DEN0137[1] version 1.0-rel0
> 
> [1] https://developer.arm.com/documentation/den0137/1-0rel0/
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v5:
>   * Sorted the SMC #defines by value.
>   * Renamed SMI_RxI_CALL to SMI_RMI_CALL since the macro is only used for
>     RMI calls.
>   * Renamed REC_GIC_NUM_LRS to REC_MAX_GIC_NUM_LRS since the actual
>     number of available list registers could be lower.
>   * Provided a define for the reserved fields of FeatureRegister0.
>   * Fix inconsistent names for padding fields.
> Changes since v4:
>   * Update to point to final released RMM spec.
>   * Minor rearrangements.
> Changes since v3:
>   * Update to match RMM spec v1.0-rel0-rc1.
> Changes since v2:
>   * Fix specification link.
>   * Rename rec_entry->rec_enter to match spec.
>   * Fix size of pmu_ovf_status to match spec.
> ---
>   arch/arm64/include/asm/rmi_smc.h | 259 +++++++++++++++++++++++++++++++
>   1 file changed, 259 insertions(+)
>   create mode 100644 arch/arm64/include/asm/rmi_smc.h
> 
> diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
> new file mode 100644
> index 000000000000..eec659e284cd
> --- /dev/null
> +++ b/arch/arm64/include/asm/rmi_smc.h
> @@ -0,0 +1,259 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) 2023-2024 ARM Ltd.
> + *
> + * The values and structures in this file are from the Realm Management Monitor
> + * specification (DEN0137) version 1.0-rel0:
> + * https://developer.arm.com/documentation/den0137/1-0rel0/
> + */
> +
> +#ifndef __ASM_RME_SMC_H
> +#define __ASM_RME_SMC_H
> +
> +#include <linux/arm-smccc.h>
> +
> +#define SMC_RMI_CALL(func)				\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
> +			   ARM_SMCCC_SMC_64,		\
> +			   ARM_SMCCC_OWNER_STANDARD,	\
> +			   (func))
> +
> +#define SMC_RMI_VERSION			SMC_RMI_CALL(0x0150)
> +#define SMC_RMI_GRANULE_DELEGATE	SMC_RMI_CALL(0x0151)
> +#define SMC_RMI_GRANULE_UNDELEGATE	SMC_RMI_CALL(0x0152)
> +#define SMC_RMI_DATA_CREATE		SMC_RMI_CALL(0x0153)
> +#define SMC_RMI_DATA_CREATE_UNKNOWN	SMC_RMI_CALL(0x0154)
> +#define SMC_RMI_DATA_DESTROY		SMC_RMI_CALL(0x0155)
> +
> +#define SMC_RMI_REALM_ACTIVATE		SMC_RMI_CALL(0x0157)
> +#define SMC_RMI_REALM_CREATE		SMC_RMI_CALL(0x0158)
> +#define SMC_RMI_REALM_DESTROY		SMC_RMI_CALL(0x0159)
> +#define SMC_RMI_REC_CREATE		SMC_RMI_CALL(0x015a)
> +#define SMC_RMI_REC_DESTROY		SMC_RMI_CALL(0x015b)
> +#define SMC_RMI_REC_ENTER		SMC_RMI_CALL(0x015c)
> +#define SMC_RMI_RTT_CREATE		SMC_RMI_CALL(0x015d)
> +#define SMC_RMI_RTT_DESTROY		SMC_RMI_CALL(0x015e)
> +#define SMC_RMI_RTT_MAP_UNPROTECTED	SMC_RMI_CALL(0x015f)
> +
> +#define SMC_RMI_RTT_READ_ENTRY		SMC_RMI_CALL(0x0161)
> +#define SMC_RMI_RTT_UNMAP_UNPROTECTED	SMC_RMI_CALL(0x0162)
> +
> +#define SMC_RMI_PSCI_COMPLETE		SMC_RMI_CALL(0x0164)
> +#define SMC_RMI_FEATURES		SMC_RMI_CALL(0x0165)
> +#define SMC_RMI_RTT_FOLD		SMC_RMI_CALL(0x0166)
> +#define SMC_RMI_REC_AUX_COUNT		SMC_RMI_CALL(0x0167)
> +#define SMC_RMI_RTT_INIT_RIPAS		SMC_RMI_CALL(0x0168)
> +#define SMC_RMI_RTT_SET_RIPAS		SMC_RMI_CALL(0x0169)
> +
> +#define RMI_ABI_MAJOR_VERSION	1
> +#define RMI_ABI_MINOR_VERSION	0
> +
> +#define RMI_ABI_VERSION_GET_MAJOR(version) ((version) >> 16)
> +#define RMI_ABI_VERSION_GET_MINOR(version) ((version) & 0xFFFF)
> +#define RMI_ABI_VERSION(major, minor)      (((major) << 16) | (minor))
> +
> +#define RMI_UNASSIGNED			0
> +#define RMI_ASSIGNED			1
> +#define RMI_TABLE			2
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
> +enum rmi_ripas {
> +	RMI_EMPTY = 0,
> +	RMI_RAM = 1,
> +	RMI_DESTROYED = 2,
> +};
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
> +#define RMI_FEATURE_REGISTER_0_Reserved		GENMASK(63, 42)
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
> +		u8 padding0[0x400];
> +	};
> +	union { /* 0x400 */
> +		u8 rpv[64];
> +		u8 padding1[0x400];
> +	};
> +	union { /* 0x800 */
> +		struct {
> +			u64 vmid;
> +			u64 rtt_base;
> +			s64 rtt_level_start;
> +			u64 rtt_num_start;
> +		};
> +		u8 padding2[0x800];
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
> +		u8 padding0[0x100];
> +	};
> +	union { /* 0x100 */
> +		u64 mpidr;
> +		u8 padding1[0x100];
> +	};
> +	union { /* 0x200 */
> +		u64 pc;
> +		u8 padding2[0x100];
> +	};
> +	union { /* 0x300 */
> +		u64 gprs[REC_CREATE_NR_GPRS];
> +		u8 padding3[0x500];
> +	};
> +	union { /* 0x800 */
> +		struct {
> +			u64 num_rec_aux;
> +			u64 aux[REC_PARAMS_AUX_GRANULES];
> +		};
> +		u8 padding4[0x800];
> +	};
> +};
> +
> +#define REC_ENTER_EMULATED_MMIO		BIT(0)
> +#define REC_ENTER_INJECT_SEA		BIT(1)
> +#define REC_ENTER_TRAP_WFI		BIT(2)
> +#define REC_ENTER_TRAP_WFE		BIT(3)
> +#define REC_ENTER_RIPAS_RESPONSE	BIT(4)
> +

Minor nit: Everywhere else, the flags bit definitions indicate

OBJECT_FLAG_xyz

inline with that should this be :

REC_ENTER_FLAG_xyz ?


Rest looks fine to me

Suzuki


