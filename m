Return-Path: <kvm+bounces-29688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D28FC9AFA25
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 08:37:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E34E11C2249C
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 06:37:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E97B1A4F2F;
	Fri, 25 Oct 2024 06:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SY9tyVTz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3761ACE12
	for <kvm@vger.kernel.org>; Fri, 25 Oct 2024 06:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729838252; cv=none; b=cb9b6pv39Ed6qQNG2eP0kF4J44k3TIn7gXwtbF2ToUWGSqTDc13qUPA24Lzcy4wUyPiTSjj7w6BI+AX6itAy8FT0j535j4oUVhLVpDMl/yyPmgSTilv+neJVvHa12Q1DntP5ojcM4m40eC9CcX8dr5CWiYzoJZqbu7vgOpGjhFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729838252; c=relaxed/simple;
	bh=TbRrNFlRcoAEnxlG27xrooJIVjb4CoZ1xI6UgXu0AXY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Apdw7wNw6dcNdO5rS3zeP/f2mYVEogIsABiu9+IV4oZy1GzC0W1ptshqgytxXSutzOhWIeXDfX8WZNm+bsXyuGntOwQ6l5X0tZspMaV3kh6FKOKaZQgA9MEbVJmVjsHgMFDWtQBGobxoXpZy0kcQi4UKkvZFKVlf0oaxY48ZxA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SY9tyVTz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729838249;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+bDF2PtA8nEwp1BLJ5T0XsLmvVmBVPXORykZ4wJpoak=;
	b=SY9tyVTz2BVeTxiaKR2a52kf1iUdC+yhAKyvh4bTB4dqkEq/igaVP17+s0gse7Z1O5J0Sg
	ppXMqPjf8jYc9953WyoyCOcXu5eeAwdyrv6aifJDD0NuKKoqmZ3K6pZW5gr1tuG3albQco
	58bzM4B83W4JS5mVXtr7ioTCAexFVyY=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-466-nsFyNUeDNN6EyZ--DAqqlw-1; Fri, 25 Oct 2024 02:37:27 -0400
X-MC-Unique: nsFyNUeDNN6EyZ--DAqqlw-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2e3ce03a701so1795717a91.0
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 23:37:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729838246; x=1730443046;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+bDF2PtA8nEwp1BLJ5T0XsLmvVmBVPXORykZ4wJpoak=;
        b=E7E3kEnkZFxSBcCY2E9IA0tpTmSVQd6Nm09gkEXzSv6TtMUsIh2xE6/syJqu3i3ict
         8FikBOtkH6EPQ1yJZ8Cqviie9fl3VZP9xfWcvBWrVyc2GJebWLWN2jQI5XiQfk+vk0L+
         rD+HUI9jQeSMmZPo+NONcB/FbRhpPOjWul4k2VX6al1uugY+5LzhJRYk8v1SwuZ3VUId
         krb5b5ff92emZvJ/RsCu/sRTfnVVI0VtXL/UzhYxHbFQwCBTfZ8onCyNpm9+HBNsQTj8
         01jJ3ELq3q1mONYCQDqrKIpLG4dyDEOk4XypT3aQaN1okRf9qfzwZLvnXrpwQIZGyBif
         xIeA==
X-Forwarded-Encrypted: i=1; AJvYcCXFq3du3zSZExYH+EGn+0Bt0ymmWWCtXhZUiJQxT0otddX02U7UDIjKhNot+S4Ss7rbQJk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGFZe2PSkPaylVpPADUoZyv0j/+IfvW4+zRKd/mIXjIH4m9UGS
	xBpqlrw7n/8G6yX3aVgd6GkrXLANazM3gzyBO6ZmeoXQ4AUu2T58MmHCR/oGzmrX33CSFePZFSO
	+kbRovYzpGXu6JoKBcO7Ov59Jeih5eqPbSHnfPuNXw8arZSiRhg==
X-Received: by 2002:a17:90b:274c:b0:2e2:b922:48a with SMTP id 98e67ed59e1d1-2e76b5fd63dmr9190804a91.18.1729838245863;
        Thu, 24 Oct 2024 23:37:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG+u2nP5jEKVj215KpGw6rOcs0Eagy/ksL64B+QesnMTfSL8FQ2Ri3aw4o0HE9/qEPVorhCqw==
X-Received: by 2002:a17:90b:274c:b0:2e2:b922:48a with SMTP id 98e67ed59e1d1-2e76b5fd63dmr9190789a91.18.1729838245450;
        Thu, 24 Oct 2024 23:37:25 -0700 (PDT)
Received: from [192.168.68.55] ([180.233.125.129])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e7867fd63csm2102774a91.1.2024.10.24.23.37.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 23:37:24 -0700 (PDT)
Message-ID: <c5f65e60-efc1-49c5-b421-55f2be5e9449@redhat.com>
Date: Fri, 25 Oct 2024 16:37:15 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/43] arm64: RME: Add SMC definitions for calling the
 RMM
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
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
References: <20241004152804.72508-1-steven.price@arm.com>
 <20241004152804.72508-6-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20241004152804.72508-6-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/5/24 1:27 AM, Steven Price wrote:
> The RMM (Realm Management Monitor) provides functionality that can be
> accessed by SMC calls from the host.
> 
> The SMC definitions are based on DEN0137[1] version 1.0-rel0
> 
> [1] https://developer.arm.com/documentation/den0137/1-0rel0/
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
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
>   arch/arm64/include/asm/rmi_smc.h | 255 +++++++++++++++++++++++++++++++
>   1 file changed, 255 insertions(+)
>   create mode 100644 arch/arm64/include/asm/rmi_smc.h
> 
> diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
> new file mode 100644
> index 000000000000..0fde2e06d275
> --- /dev/null
> +++ b/arch/arm64/include/asm/rmi_smc.h
> @@ -0,0 +1,255 @@
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
> +#define SMC_RxI_CALL(func)				\
> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
> +			   ARM_SMCCC_SMC_64,		\
> +			   ARM_SMCCC_OWNER_STANDARD,	\
> +			   (func))
> +

I guess the 'x' of 'RxI' here can be 'M' or 'S'. We already had similar macro
(SMC_RSI_FID) in rsi_smc.h, so 'RMI' sounds more appropriate to me since this
macro is only used to define those RMI function calls. SMC_RMI_FID is the name
consistent to SMC_RSI_FID in rsi_smc.h.

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

Similar to what we had in rsi_smc.h, it may be good idea to have those definitions
in the ascending order of the function ID (number). It will help readers to search
based on the function ID (number) if you agree.

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

Those RTT entry states are associated with struct rtt_entry::state only. So the best
place to have those definiation would be rmi_cmds.h where 'struct rtt_entry' is
declared. Besides, there is a enumeration RmiRttEntryState for them as stated in
the specifiction (B4.4.24).

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
> +

The 'Reserved' field can be defined as well so that the definitions are complete
if you agree.

    #define RMI_FEATGURE_REGISTER_0_Reserved	GENMASK(63, 42)

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
> +		u8 padding1[0x400];
> +	};
> +	union { /* 0x400 */
> +		u8 rpv[64];
> +		u8 padding2[0x400];
> +	};
> +	union { /* 0x800 */
> +		struct {
> +			u64 vmid;
> +			u64 rtt_base;
> +			s64 rtt_level_start;
> +			u64 rtt_num_start;
> +		};
> +		u8 padding3[0x800];
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
> +#define REC_ENTER_EMULATED_MMIO		BIT(0)
> +#define REC_ENTER_INJECT_SEA		BIT(1)
> +#define REC_ENTER_TRAP_WFI		BIT(2)
> +#define REC_ENTER_TRAP_WFE		BIT(3)
> +#define REC_ENTER_RIPAS_RESPONSE	BIT(4)
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

The names for the 'padding' field starts from 'padding1' instead of 'padding0'
as we did for other structures.

> +struct rec_run {
> +	struct rec_enter enter;
> +	struct rec_exit exit;
> +};
> +
> +#endif

#endif /* __ASM_RME_SMC_H */

Thanks,
Gavin


