Return-Path: <kvm+bounces-59142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EF302BAC7ED
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 12:33:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2659E188FB3B
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 10:33:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE83E2FC016;
	Tue, 30 Sep 2025 10:32:09 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 894462FBDE3;
	Tue, 30 Sep 2025 10:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759228329; cv=none; b=CS40c0OPyJWtBq6CfjWETooiEIkNVfzoHCU9kCcfYHYPB7++S/Zu9KPqzedQ+AYXN8/sWwXLNS1B2cf2f31wmVA4UCV54QbOR5hK1vbazrxaq3oBiwLmAZ4WuXutyhj7WvhYKKNwZqBzCCUTiM3Ir6jV7EAvFUmlavmQtas2Krc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759228329; c=relaxed/simple;
	bh=o4B+S59z6sqFBoafis1yhVBnv55ilM2ESRaRPeUIBT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKa6qB5so7x4FyPKrqt+0PNyuAHNY+mavnqoHvE+0X/lbMy6iKi+8gpe1FK2ILDg3CiTZs1dgs59ZZXnhdfp0+NBzmONhzgp7EKfYNPG4cgWMp7joJCVAsDuPN69pMYqxtNSnkiWkirC8b514Kqs6I/+beRtwSJiTIkVDfn/X+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 47818267F;
	Tue, 30 Sep 2025 03:31:59 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id F0ACB3F66E;
	Tue, 30 Sep 2025 03:32:05 -0700 (PDT)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	will@kernel.org,
	oliver.upton@linux.dev,
	maz@kernel.org,
	alexandru.elisei@arm.com,
	aneesh.kumar@kernel.org,
	steven.price@arm.com,
	tabba@google.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH kvmtool v4 04/15] Import arm-smccc.h from Linux 6.17-rc7
Date: Tue, 30 Sep 2025 11:31:19 +0100
Message-ID: <20250930103130.197534-6-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250930103130.197534-1-suzuki.poulose@arm.com>
References: <20250930103130.197534-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Oliver Upton <oliver.upton@linux.dev>

Copy in the SMCCC definitions from the kernel, which will be used to
implement SMCCC handling in userspace. Strip off unnecessary kernel specific
bits.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 include/linux/arm-smccc.h | 305 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 305 insertions(+)
 create mode 100644 include/linux/arm-smccc.h

diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
new file mode 100644
index 00000000..121a9608
--- /dev/null
+++ b/include/linux/arm-smccc.h
@@ -0,0 +1,305 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2015, Linaro Limited
+ * Copied from $linux/include/linux/arm-smccc.h
+ */
+#ifndef __LINUX_ARM_SMCCC_H
+#define __LINUX_ARM_SMCCC_H
+
+#include <linux/const.h>
+
+/*
+ * This file provides common defines for ARM SMC Calling Convention as
+ * specified in
+ * https://developer.arm.com/docs/den0028/latest
+ *
+ * This code is up-to-date with version DEN 0028 C
+ */
+
+#define ARM_SMCCC_STD_CALL	        _AC(0,U)
+#define ARM_SMCCC_FAST_CALL	        _AC(1,U)
+#define ARM_SMCCC_TYPE_SHIFT		31
+
+#define ARM_SMCCC_SMC_32		0
+#define ARM_SMCCC_SMC_64		1
+#define ARM_SMCCC_CALL_CONV_SHIFT	30
+
+#define ARM_SMCCC_OWNER_MASK		0x3F
+#define ARM_SMCCC_OWNER_SHIFT		24
+
+#define ARM_SMCCC_FUNC_MASK		0xFFFF
+
+#define ARM_SMCCC_IS_FAST_CALL(smc_val)	\
+	((smc_val) & (ARM_SMCCC_FAST_CALL << ARM_SMCCC_TYPE_SHIFT))
+#define ARM_SMCCC_IS_64(smc_val) \
+	((smc_val) & (ARM_SMCCC_SMC_64 << ARM_SMCCC_CALL_CONV_SHIFT))
+#define ARM_SMCCC_FUNC_NUM(smc_val)	((smc_val) & ARM_SMCCC_FUNC_MASK)
+#define ARM_SMCCC_OWNER_NUM(smc_val) \
+	(((smc_val) >> ARM_SMCCC_OWNER_SHIFT) & ARM_SMCCC_OWNER_MASK)
+
+#define ARM_SMCCC_CALL_VAL(type, calling_convention, owner, func_num) \
+	(((type) << ARM_SMCCC_TYPE_SHIFT) | \
+	((calling_convention) << ARM_SMCCC_CALL_CONV_SHIFT) | \
+	(((owner) & ARM_SMCCC_OWNER_MASK) << ARM_SMCCC_OWNER_SHIFT) | \
+	((func_num) & ARM_SMCCC_FUNC_MASK))
+
+#define ARM_SMCCC_OWNER_ARCH		0
+#define ARM_SMCCC_OWNER_CPU		1
+#define ARM_SMCCC_OWNER_SIP		2
+#define ARM_SMCCC_OWNER_OEM		3
+#define ARM_SMCCC_OWNER_STANDARD	4
+#define ARM_SMCCC_OWNER_STANDARD_HYP	5
+#define ARM_SMCCC_OWNER_VENDOR_HYP	6
+#define ARM_SMCCC_OWNER_TRUSTED_APP	48
+#define ARM_SMCCC_OWNER_TRUSTED_APP_END	49
+#define ARM_SMCCC_OWNER_TRUSTED_OS	50
+#define ARM_SMCCC_OWNER_TRUSTED_OS_END	63
+
+#define ARM_SMCCC_FUNC_QUERY_CALL_UID  0xff01
+
+#define ARM_SMCCC_QUIRK_NONE		0
+#define ARM_SMCCC_QUIRK_QCOM_A6		1 /* Save/restore register a6 */
+
+#define ARM_SMCCC_VERSION_1_0		0x10000
+#define ARM_SMCCC_VERSION_1_1		0x10001
+#define ARM_SMCCC_VERSION_1_2		0x10002
+#define ARM_SMCCC_VERSION_1_3		0x10003
+
+#define ARM_SMCCC_1_3_SVE_HINT		0x10000
+#define ARM_SMCCC_CALL_HINTS		ARM_SMCCC_1_3_SVE_HINT
+
+
+#define ARM_SMCCC_VERSION_FUNC_ID					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 0)
+
+#define ARM_SMCCC_ARCH_FEATURES_FUNC_ID					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 1)
+
+#define ARM_SMCCC_ARCH_SOC_ID						\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 2)
+
+#define ARM_SMCCC_ARCH_WORKAROUND_1					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 0x8000)
+
+#define ARM_SMCCC_ARCH_WORKAROUND_2					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 0x7fff)
+
+#define ARM_SMCCC_ARCH_WORKAROUND_3					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 0x3fff)
+
+#define ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID				\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_FUNC_QUERY_CALL_UID)
+
+
+/* KVM "vendor specific" services */
+#define ARM_SMCCC_KVM_FUNC_FEATURES		0
+#define ARM_SMCCC_KVM_FUNC_PTP			1
+/* Start of pKVM hypercall range */
+#define ARM_SMCCC_KVM_FUNC_HYP_MEMINFO		2
+#define ARM_SMCCC_KVM_FUNC_MEM_SHARE		3
+#define ARM_SMCCC_KVM_FUNC_MEM_UNSHARE		4
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_5		5
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_6		6
+#define ARM_SMCCC_KVM_FUNC_MMIO_GUARD		7
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_8		8
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_9		9
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_10		10
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_11		11
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_12		12
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_13		13
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_14		14
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_15		15
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_16		16
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_17		17
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_18		18
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_19		19
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_20		20
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_21		21
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_22		22
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_23		23
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_24		24
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_25		25
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_26		26
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_27		27
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_28		28
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_29		29
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_30		30
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_31		31
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_32		32
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_33		33
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_34		34
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_35		35
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_36		36
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_37		37
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_38		38
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_39		39
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_40		40
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_41		41
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_42		42
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_43		43
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_44		44
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_45		45
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_46		46
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_47		47
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_48		48
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_49		49
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_50		50
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_51		51
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_52		52
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_53		53
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_54		54
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_55		55
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_56		56
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_57		57
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_58		58
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_59		59
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_60		60
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_61		61
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_62		62
+#define ARM_SMCCC_KVM_FUNC_PKVM_RESV_63		63
+/* End of pKVM hypercall range */
+#define ARM_SMCCC_KVM_FUNC_DISCOVER_IMPL_VER	64
+#define ARM_SMCCC_KVM_FUNC_DISCOVER_IMPL_CPUS	65
+
+#define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
+#define ARM_SMCCC_KVM_NUM_FUNCS			128
+
+#define ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID			\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_FEATURES)
+
+#define SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED	1
+
+/*
+ * ptp_kvm is a feature used for time sync between vm and host.
+ * ptp_kvm module in guest kernel will get service from host using
+ * this hypercall ID.
+ */
+#define ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID				\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_PTP)
+
+#define ARM_SMCCC_VENDOR_HYP_KVM_HYP_MEMINFO_FUNC_ID			\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_64,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_HYP_MEMINFO)
+
+#define ARM_SMCCC_VENDOR_HYP_KVM_MEM_SHARE_FUNC_ID			\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_64,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_MEM_SHARE)
+
+#define ARM_SMCCC_VENDOR_HYP_KVM_MEM_UNSHARE_FUNC_ID			\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_64,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_MEM_UNSHARE)
+
+#define ARM_SMCCC_VENDOR_HYP_KVM_MMIO_GUARD_FUNC_ID			\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_64,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_MMIO_GUARD)
+
+#define ARM_SMCCC_VENDOR_HYP_KVM_DISCOVER_IMPL_VER_FUNC_ID		\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_64,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_DISCOVER_IMPL_VER)
+
+#define ARM_SMCCC_VENDOR_HYP_KVM_DISCOVER_IMPL_CPUS_FUNC_ID		\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_64,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_DISCOVER_IMPL_CPUS)
+
+/* ptp_kvm counter type ID */
+#define KVM_PTP_VIRT_COUNTER			0
+#define KVM_PTP_PHYS_COUNTER			1
+
+/* Paravirtualised time calls (defined by ARM DEN0057A) */
+#define ARM_SMCCC_HV_PV_TIME_FEATURES				\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_64,			\
+			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
+			   0x20)
+
+#define ARM_SMCCC_HV_PV_TIME_ST					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_64,			\
+			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
+			   0x21)
+
+/* TRNG entropy source calls (defined by ARM DEN0098) */
+#define ARM_SMCCC_TRNG_VERSION					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_32,			\
+			   ARM_SMCCC_OWNER_STANDARD,		\
+			   0x50)
+
+#define ARM_SMCCC_TRNG_FEATURES					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_32,			\
+			   ARM_SMCCC_OWNER_STANDARD,		\
+			   0x51)
+
+#define ARM_SMCCC_TRNG_GET_UUID					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_32,			\
+			   ARM_SMCCC_OWNER_STANDARD,		\
+			   0x52)
+
+#define ARM_SMCCC_TRNG_RND32					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_32,			\
+			   ARM_SMCCC_OWNER_STANDARD,		\
+			   0x53)
+
+#define ARM_SMCCC_TRNG_RND64					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
+			   ARM_SMCCC_SMC_64,			\
+			   ARM_SMCCC_OWNER_STANDARD,		\
+			   0x53)
+
+/*
+ * Return codes defined in ARM DEN 0070A
+ * ARM DEN 0070A is now merged/consolidated into ARM DEN 0028 C
+ */
+#define SMCCC_RET_SUCCESS			0
+#define SMCCC_RET_NOT_SUPPORTED			-1
+#define SMCCC_RET_NOT_REQUIRED			-2
+#define SMCCC_RET_INVALID_PARAMETER		-3
+
+/**
+ * struct arm_smccc_res - Result from SMC/HVC call
+ * @a0-a3 result values from registers 0 to 3
+ */
+struct arm_smccc_res {
+	unsigned long a0;
+	unsigned long a1;
+	unsigned long a2;
+	unsigned long a3;
+};
+
+#endif /*__LINUX_ARM_SMCCC_H*/
-- 
2.43.0


