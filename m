Return-Path: <kvm+bounces-66114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AC786CC7A9A
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 13:41:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4DA8130991E9
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 12:37:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C5B733D6E5;
	Wed, 17 Dec 2025 10:12:09 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD4CC33C1A6;
	Wed, 17 Dec 2025 10:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765966329; cv=none; b=FTm7e/foK4FblakjCznngM3Dyeil/XOAK1gKQLi/j2rsqJdiGcKN4TW76KDWZ38NYe9QX+1dPBgH2aEMhV8pVXmN7OwFF3ZCnpiM2gdybiNweThOFfb/S8PlMIQdxA6yDCxxGVXbYEEOfAQzb9/JMF49iH5Kh3x7pZK8UZTNGSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765966329; c=relaxed/simple;
	bh=ZWAra3IVE0mUYK0eG1EV+o/n0koFcmgvAyZKXua+W5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d9k5JRY1FIOAd5RX4mKprTd+7PCjTe2q5lzZuIW31ZEDpKcv+BuNa4IAb1G43qsPW22qP84YT3+t5dkpoQdIv5wr69bhkVXPndX3HDUMzmSnbSIkDFp9/QlTkK9vtvsAQxIR1bz0IfwzweW5oD+VhjjgfLFovwkqau6cpnXHTwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DD08D1684;
	Wed, 17 Dec 2025 02:11:53 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.45.201])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 411973F73B;
	Wed, 17 Dec 2025 02:11:56 -0800 (PST)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>
Subject: [PATCH v12 03/46] arm64: RMI: Add SMC definitions for calling the RMM
Date: Wed, 17 Dec 2025 10:10:40 +0000
Message-ID: <20251217101125.91098-4-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251217101125.91098-1-steven.price@arm.com>
References: <20251217101125.91098-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The RMM (Realm Management Monitor) provides functionality that can be
accessed by SMC calls from the host.

The SMC definitions are based on DEN0137[1] version 1.0-rel0

[1] https://developer.arm.com/documentation/den0137/1-0rel0/

Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v9:
 * Corrected size of 'ripas_value' in struct rec_exit. The spec states
   this is an 8-bit type with padding afterwards (rather than a u64).
Changes since v8:
 * Added RMI_PERMITTED_GICV3_HCR_BITS to define which bits the RMM
   permits to be modified.
Changes since v6:
 * Renamed REC_ENTER_xxx defines to include 'FLAG' to make it obvious
   these are flag values.
Changes since v5:
 * Sorted the SMC #defines by value.
 * Renamed SMI_RxI_CALL to SMI_RMI_CALL since the macro is only used for
   RMI calls.
 * Renamed REC_GIC_NUM_LRS to REC_MAX_GIC_NUM_LRS since the actual
   number of available list registers could be lower.
 * Provided a define for the reserved fields of FeatureRegister0.
 * Fix inconsistent names for padding fields.
Changes since v4:
 * Update to point to final released RMM spec.
 * Minor rearrangements.
Changes since v3:
 * Update to match RMM spec v1.0-rel0-rc1.
Changes since v2:
 * Fix specification link.
 * Rename rec_entry->rec_enter to match spec.
 * Fix size of pmu_ovf_status to match spec.
---
 arch/arm64/include/asm/rmi_smc.h | 269 +++++++++++++++++++++++++++++++
 1 file changed, 269 insertions(+)
 create mode 100644 arch/arm64/include/asm/rmi_smc.h

diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
new file mode 100644
index 000000000000..1000368f1bca
--- /dev/null
+++ b/arch/arm64/include/asm/rmi_smc.h
@@ -0,0 +1,269 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2023-2024 ARM Ltd.
+ *
+ * The values and structures in this file are from the Realm Management Monitor
+ * specification (DEN0137) version 1.0-rel0:
+ * https://developer.arm.com/documentation/den0137/1-0rel0/
+ */
+
+#ifndef __ASM_RMI_SMC_H
+#define __ASM_RMI_SMC_H
+
+#include <linux/arm-smccc.h>
+
+#define SMC_RMI_CALL(func)				\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
+			   ARM_SMCCC_SMC_64,		\
+			   ARM_SMCCC_OWNER_STANDARD,	\
+			   (func))
+
+#define SMC_RMI_VERSION			SMC_RMI_CALL(0x0150)
+#define SMC_RMI_GRANULE_DELEGATE	SMC_RMI_CALL(0x0151)
+#define SMC_RMI_GRANULE_UNDELEGATE	SMC_RMI_CALL(0x0152)
+#define SMC_RMI_DATA_CREATE		SMC_RMI_CALL(0x0153)
+#define SMC_RMI_DATA_CREATE_UNKNOWN	SMC_RMI_CALL(0x0154)
+#define SMC_RMI_DATA_DESTROY		SMC_RMI_CALL(0x0155)
+
+#define SMC_RMI_REALM_ACTIVATE		SMC_RMI_CALL(0x0157)
+#define SMC_RMI_REALM_CREATE		SMC_RMI_CALL(0x0158)
+#define SMC_RMI_REALM_DESTROY		SMC_RMI_CALL(0x0159)
+#define SMC_RMI_REC_CREATE		SMC_RMI_CALL(0x015a)
+#define SMC_RMI_REC_DESTROY		SMC_RMI_CALL(0x015b)
+#define SMC_RMI_REC_ENTER		SMC_RMI_CALL(0x015c)
+#define SMC_RMI_RTT_CREATE		SMC_RMI_CALL(0x015d)
+#define SMC_RMI_RTT_DESTROY		SMC_RMI_CALL(0x015e)
+#define SMC_RMI_RTT_MAP_UNPROTECTED	SMC_RMI_CALL(0x015f)
+
+#define SMC_RMI_RTT_READ_ENTRY		SMC_RMI_CALL(0x0161)
+#define SMC_RMI_RTT_UNMAP_UNPROTECTED	SMC_RMI_CALL(0x0162)
+
+#define SMC_RMI_PSCI_COMPLETE		SMC_RMI_CALL(0x0164)
+#define SMC_RMI_FEATURES		SMC_RMI_CALL(0x0165)
+#define SMC_RMI_RTT_FOLD		SMC_RMI_CALL(0x0166)
+#define SMC_RMI_REC_AUX_COUNT		SMC_RMI_CALL(0x0167)
+#define SMC_RMI_RTT_INIT_RIPAS		SMC_RMI_CALL(0x0168)
+#define SMC_RMI_RTT_SET_RIPAS		SMC_RMI_CALL(0x0169)
+
+#define RMI_ABI_MAJOR_VERSION	1
+#define RMI_ABI_MINOR_VERSION	0
+
+#define RMI_ABI_VERSION_GET_MAJOR(version) ((version) >> 16)
+#define RMI_ABI_VERSION_GET_MINOR(version) ((version) & 0xFFFF)
+#define RMI_ABI_VERSION(major, minor)      (((major) << 16) | (minor))
+
+#define RMI_UNASSIGNED			0
+#define RMI_ASSIGNED			1
+#define RMI_TABLE			2
+
+#define RMI_RETURN_STATUS(ret)		((ret) & 0xFF)
+#define RMI_RETURN_INDEX(ret)		(((ret) >> 8) & 0xFF)
+
+#define RMI_SUCCESS		0
+#define RMI_ERROR_INPUT		1
+#define RMI_ERROR_REALM		2
+#define RMI_ERROR_REC		3
+#define RMI_ERROR_RTT		4
+
+enum rmi_ripas {
+	RMI_EMPTY = 0,
+	RMI_RAM = 1,
+	RMI_DESTROYED = 2,
+};
+
+#define RMI_NO_MEASURE_CONTENT	0
+#define RMI_MEASURE_CONTENT	1
+
+#define RMI_FEATURE_REGISTER_0_S2SZ		GENMASK(7, 0)
+#define RMI_FEATURE_REGISTER_0_LPA2		BIT(8)
+#define RMI_FEATURE_REGISTER_0_SVE_EN		BIT(9)
+#define RMI_FEATURE_REGISTER_0_SVE_VL		GENMASK(13, 10)
+#define RMI_FEATURE_REGISTER_0_NUM_BPS		GENMASK(19, 14)
+#define RMI_FEATURE_REGISTER_0_NUM_WPS		GENMASK(25, 20)
+#define RMI_FEATURE_REGISTER_0_PMU_EN		BIT(26)
+#define RMI_FEATURE_REGISTER_0_PMU_NUM_CTRS	GENMASK(31, 27)
+#define RMI_FEATURE_REGISTER_0_HASH_SHA_256	BIT(32)
+#define RMI_FEATURE_REGISTER_0_HASH_SHA_512	BIT(33)
+#define RMI_FEATURE_REGISTER_0_GICV3_NUM_LRS	GENMASK(37, 34)
+#define RMI_FEATURE_REGISTER_0_MAX_RECS_ORDER	GENMASK(41, 38)
+#define RMI_FEATURE_REGISTER_0_Reserved		GENMASK(63, 42)
+
+#define RMI_REALM_PARAM_FLAG_LPA2		BIT(0)
+#define RMI_REALM_PARAM_FLAG_SVE		BIT(1)
+#define RMI_REALM_PARAM_FLAG_PMU		BIT(2)
+
+/*
+ * Note many of these fields are smaller than u64 but all fields have u64
+ * alignment, so use u64 to ensure correct alignment.
+ */
+struct realm_params {
+	union { /* 0x0 */
+		struct {
+			u64 flags;
+			u64 s2sz;
+			u64 sve_vl;
+			u64 num_bps;
+			u64 num_wps;
+			u64 pmu_num_ctrs;
+			u64 hash_algo;
+		};
+		u8 padding0[0x400];
+	};
+	union { /* 0x400 */
+		u8 rpv[64];
+		u8 padding1[0x400];
+	};
+	union { /* 0x800 */
+		struct {
+			u64 vmid;
+			u64 rtt_base;
+			s64 rtt_level_start;
+			u64 rtt_num_start;
+		};
+		u8 padding2[0x800];
+	};
+};
+
+/*
+ * The number of GPRs (starting from X0) that are
+ * configured by the host when a REC is created.
+ */
+#define REC_CREATE_NR_GPRS		8
+
+#define REC_PARAMS_FLAG_RUNNABLE	BIT_ULL(0)
+
+#define REC_PARAMS_AUX_GRANULES		16
+
+struct rec_params {
+	union { /* 0x0 */
+		u64 flags;
+		u8 padding0[0x100];
+	};
+	union { /* 0x100 */
+		u64 mpidr;
+		u8 padding1[0x100];
+	};
+	union { /* 0x200 */
+		u64 pc;
+		u8 padding2[0x100];
+	};
+	union { /* 0x300 */
+		u64 gprs[REC_CREATE_NR_GPRS];
+		u8 padding3[0x500];
+	};
+	union { /* 0x800 */
+		struct {
+			u64 num_rec_aux;
+			u64 aux[REC_PARAMS_AUX_GRANULES];
+		};
+		u8 padding4[0x800];
+	};
+};
+
+#define REC_ENTER_FLAG_EMULATED_MMIO	BIT(0)
+#define REC_ENTER_FLAG_INJECT_SEA	BIT(1)
+#define REC_ENTER_FLAG_TRAP_WFI		BIT(2)
+#define REC_ENTER_FLAG_TRAP_WFE		BIT(3)
+#define REC_ENTER_FLAG_RIPAS_RESPONSE	BIT(4)
+
+#define REC_RUN_GPRS			31
+#define REC_MAX_GIC_NUM_LRS		16
+
+#define RMI_PERMITTED_GICV3_HCR_BITS	(ICH_HCR_EL2_UIE |		\
+					 ICH_HCR_EL2_LRENPIE |		\
+					 ICH_HCR_EL2_NPIE |		\
+					 ICH_HCR_EL2_VGrp0EIE |		\
+					 ICH_HCR_EL2_VGrp0DIE |		\
+					 ICH_HCR_EL2_VGrp1EIE |		\
+					 ICH_HCR_EL2_VGrp1DIE |		\
+					 ICH_HCR_EL2_TDIR)
+
+struct rec_enter {
+	union { /* 0x000 */
+		u64 flags;
+		u8 padding0[0x200];
+	};
+	union { /* 0x200 */
+		u64 gprs[REC_RUN_GPRS];
+		u8 padding1[0x100];
+	};
+	union { /* 0x300 */
+		struct {
+			u64 gicv3_hcr;
+			u64 gicv3_lrs[REC_MAX_GIC_NUM_LRS];
+		};
+		u8 padding2[0x100];
+	};
+	u8 padding3[0x400];
+};
+
+#define RMI_EXIT_SYNC			0x00
+#define RMI_EXIT_IRQ			0x01
+#define RMI_EXIT_FIQ			0x02
+#define RMI_EXIT_PSCI			0x03
+#define RMI_EXIT_RIPAS_CHANGE		0x04
+#define RMI_EXIT_HOST_CALL		0x05
+#define RMI_EXIT_SERROR			0x06
+
+struct rec_exit {
+	union { /* 0x000 */
+		u8 exit_reason;
+		u8 padding0[0x100];
+	};
+	union { /* 0x100 */
+		struct {
+			u64 esr;
+			u64 far;
+			u64 hpfar;
+		};
+		u8 padding1[0x100];
+	};
+	union { /* 0x200 */
+		u64 gprs[REC_RUN_GPRS];
+		u8 padding2[0x100];
+	};
+	union { /* 0x300 */
+		struct {
+			u64 gicv3_hcr;
+			u64 gicv3_lrs[REC_MAX_GIC_NUM_LRS];
+			u64 gicv3_misr;
+			u64 gicv3_vmcr;
+		};
+		u8 padding3[0x100];
+	};
+	union { /* 0x400 */
+		struct {
+			u64 cntp_ctl;
+			u64 cntp_cval;
+			u64 cntv_ctl;
+			u64 cntv_cval;
+		};
+		u8 padding4[0x100];
+	};
+	union { /* 0x500 */
+		struct {
+			u64 ripas_base;
+			u64 ripas_top;
+			u8 ripas_value;
+			u8 padding8[7];
+		};
+		u8 padding5[0x100];
+	};
+	union { /* 0x600 */
+		u16 imm;
+		u8 padding6[0x100];
+	};
+	union { /* 0x700 */
+		struct {
+			u8 pmu_ovf_status;
+		};
+		u8 padding7[0x100];
+	};
+};
+
+struct rec_run {
+	struct rec_enter enter;
+	struct rec_exit exit;
+};
+
+#endif /* __ASM_RMI_SMC_H */
-- 
2.43.0


