Return-Path: <kvm+bounces-14417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD19D8A2984
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:42:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DFBB61C22D6C
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:42:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54B85502AB;
	Fri, 12 Apr 2024 08:42:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0AC5481C2;
	Fri, 12 Apr 2024 08:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712911346; cv=none; b=fWenut4LI/IurjEfPFi1In5nh336nDN53UTnZw5HtCCK+S+ubEwawsxZoYGj6E8KxRCMHeuVCUMbmHXDCH30Cehqg3rvnhjzDa8w3mjO+xju3NBqAeGi1JJU1XsMAY3CSAlXOofcLZnOHzc5Ht11GUvy4in632tbb1PWNhPtMJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712911346; c=relaxed/simple;
	bh=qbEl0tBuzUBTJn9p568piVxjqIzERrBGbDRCfETn5wE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=M2TvvrZ9tBzREU9sJraxfcai/uzOvaWhAyM6Dxr8Y7roFhrIYFojX4ZOHIQT0Pr/LUcBwq2yXS86Fo5p40GGmwCccXXVCfyc02MQeMtiy/9JcPXZyPQMHEf2cUQz1MAOsu2nqjQp8nesyfJMP6u3EWIov4XcWQW+/T8FvDW8uYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6CC95113E;
	Fri, 12 Apr 2024 01:42:53 -0700 (PDT)
Received: from e112269-lin.cambridge.arm.com (e112269-lin.cambridge.arm.com [10.1.194.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1533D3F6C4;
	Fri, 12 Apr 2024 01:42:21 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH v2 01/14] arm64: rsi: Add RSI definitions
Date: Fri, 12 Apr 2024 09:42:00 +0100
Message-Id: <20240412084213.1733764-2-steven.price@arm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240412084213.1733764-1-steven.price@arm.com>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084213.1733764-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Suzuki K Poulose <suzuki.poulose@arm.com>

The RMM (Realm Management Monitor) provides functionality that can be
accessed by a realm guest through SMC (Realm Services Interface) calls.

The SMC definitions are based on DEN0137[1] version A-eac5.

[1] https://developer.arm.com/documentation/den0137/latest

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/rsi_cmds.h |  47 +++++++++++
 arch/arm64/include/asm/rsi_smc.h  | 136 ++++++++++++++++++++++++++++++
 2 files changed, 183 insertions(+)
 create mode 100644 arch/arm64/include/asm/rsi_cmds.h
 create mode 100644 arch/arm64/include/asm/rsi_smc.h

diff --git a/arch/arm64/include/asm/rsi_cmds.h b/arch/arm64/include/asm/rsi_cmds.h
new file mode 100644
index 000000000000..458fb58c4251
--- /dev/null
+++ b/arch/arm64/include/asm/rsi_cmds.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2023 ARM Ltd.
+ */
+
+#ifndef __ASM_RSI_CMDS_H
+#define __ASM_RSI_CMDS_H
+
+#include <linux/arm-smccc.h>
+
+#include <asm/rsi_smc.h>
+
+static inline void invoke_rsi_fn_smc_with_res(unsigned long function_id,
+					      unsigned long arg0,
+					      unsigned long arg1,
+					      unsigned long arg2,
+					      unsigned long arg3,
+					      struct arm_smccc_res *res)
+{
+	arm_smccc_smc(function_id, arg0, arg1, arg2, arg3, 0, 0, 0, res);
+}
+
+static inline unsigned long rsi_get_version(unsigned long req,
+					    unsigned long *out_lower,
+					    unsigned long *out_higher)
+{
+	struct arm_smccc_res res;
+
+	invoke_rsi_fn_smc_with_res(SMC_RSI_ABI_VERSION, req, 0, 0, 0, &res);
+
+	if (out_lower)
+		*out_lower = res.a1;
+	if (out_higher)
+		*out_higher = res.a2;
+
+	return res.a0;
+}
+
+static inline unsigned long rsi_get_realm_config(struct realm_config *cfg)
+{
+	struct arm_smccc_res res;
+
+	invoke_rsi_fn_smc_with_res(SMC_RSI_REALM_CONFIG, virt_to_phys(cfg), 0, 0, 0, &res);
+	return res.a0;
+}
+
+#endif
diff --git a/arch/arm64/include/asm/rsi_smc.h b/arch/arm64/include/asm/rsi_smc.h
new file mode 100644
index 000000000000..c2c9a3dfed48
--- /dev/null
+++ b/arch/arm64/include/asm/rsi_smc.h
@@ -0,0 +1,136 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2023 ARM Ltd.
+ */
+
+#ifndef __SMC_RSI_H_
+#define __SMC_RSI_H_
+
+/*
+ * This file describes the Realm Services Interface (RSI) Application Binary
+ * Interface (ABI) for SMC calls made from within the Realm to the RMM and
+ * serviced by the RMM.
+ */
+
+#define SMC_RSI_CALL_BASE		0xC4000000
+
+/*
+ * The major version number of the RSI implementation.  Increase this whenever
+ * the binary format or semantics of the SMC calls change.
+ */
+#define RSI_ABI_VERSION_MAJOR		1
+
+/*
+ * The minor version number of the RSI implementation.  Increase this when
+ * a bug is fixed, or a feature is added without breaking binary compatibility.
+ */
+#define RSI_ABI_VERSION_MINOR		0
+
+#define RSI_ABI_VERSION			((RSI_ABI_VERSION_MAJOR << 16) | \
+					 RSI_ABI_VERSION_MINOR)
+
+#define RSI_ABI_VERSION_GET_MAJOR(_version) ((_version) >> 16)
+#define RSI_ABI_VERSION_GET_MINOR(_version) ((_version) & 0xFFFF)
+
+#define RSI_SUCCESS			0
+#define RSI_ERROR_INPUT			1
+#define RSI_ERROR_STATE			2
+#define RSI_INCOMPLETE			3
+
+#define SMC_RSI_FID(_x)			(SMC_RSI_CALL_BASE + (_x))
+
+#define SMC_RSI_ABI_VERSION			SMC_RSI_FID(0x190)
+
+/*
+ * arg1 == Challenge value, bytes:  0 -  7
+ * arg2 == Challenge value, bytes:  7 - 15
+ * arg3 == Challenge value, bytes: 16 - 23
+ * arg4 == Challenge value, bytes: 24 - 31
+ * arg5 == Challenge value, bytes: 32 - 39
+ * arg6 == Challenge value, bytes: 40 - 47
+ * arg7 == Challenge value, bytes: 48 - 55
+ * arg8 == Challenge value, bytes: 56 - 63
+ * ret0 == Status / error
+ * ret1 == Upper bound of token size in bytes
+ */
+#define SMC_RSI_ATTESTATION_TOKEN_INIT		SMC_RSI_FID(0x194)
+
+/*
+ * arg1 == The IPA of token buffer
+ * arg2 == Offset within the granule of the token buffer
+ * arg3 == Size of the granule buffer
+ * ret0 == Status / error
+ * ret1 == Length of token bytes copied to the granule buffer
+ */
+#define SMC_RSI_ATTESTATION_TOKEN_CONTINUE	SMC_RSI_FID(0x195)
+
+/*
+ * arg1  == Index, which measurements slot to extend
+ * arg2  == Size of realm measurement in bytes, max 64 bytes
+ * arg3  == Measurement value, bytes:  0 -  7
+ * arg4  == Measurement value, bytes:  7 - 15
+ * arg5  == Measurement value, bytes: 16 - 23
+ * arg6  == Measurement value, bytes: 24 - 31
+ * arg7  == Measurement value, bytes: 32 - 39
+ * arg8  == Measurement value, bytes: 40 - 47
+ * arg9  == Measurement value, bytes: 48 - 55
+ * arg10 == Measurement value, bytes: 56 - 63
+ * ret0  == Status / error
+ */
+#define SMC_RSI_MEASUREMENT_EXTEND		SMC_RSI_FID(0x193)
+
+/*
+ * arg1 == Index, which measurements slot to read
+ * ret0 == Status / error
+ * ret1 == Measurement value, bytes:  0 -  7
+ * ret2 == Measurement value, bytes:  7 - 15
+ * ret3 == Measurement value, bytes: 16 - 23
+ * ret4 == Measurement value, bytes: 24 - 31
+ * ret5 == Measurement value, bytes: 32 - 39
+ * ret6 == Measurement value, bytes: 40 - 47
+ * ret7 == Measurement value, bytes: 48 - 55
+ * ret8 == Measurement value, bytes: 56 - 63
+ */
+#define SMC_RSI_MEASUREMENT_READ		SMC_RSI_FID(0x192)
+
+#ifndef __ASSEMBLY__
+
+struct realm_config {
+	unsigned long ipa_bits; /* Width of IPA in bits */
+};
+
+#endif /* __ASSEMBLY__ */
+
+/*
+ * arg1 == struct realm_config addr
+ * ret0 == Status / error
+ */
+#define SMC_RSI_REALM_CONFIG			SMC_RSI_FID(0x196)
+
+/*
+ * arg1 == Base IPA address of target region
+ * arg2 == Top of the region
+ * arg3 == RIPAS value
+ * arg4 == flags
+ * ret0 == Status / error
+ * ret1 == Top of modified IPA range
+ */
+#define SMC_RSI_IPA_STATE_SET			SMC_RSI_FID(0x197)
+
+#define RSI_NO_CHANGE_DESTROYED			0
+#define RSI_CHANGE_DESTROYED			1
+
+/*
+ * arg1 == IPA of target page
+ * ret0 == Status / error
+ * ret1 == RIPAS value
+ */
+#define SMC_RSI_IPA_STATE_GET			SMC_RSI_FID(0x198)
+
+/*
+ * arg1 == IPA of host call structure
+ * ret0 == Status / error
+ */
+#define SMC_RSI_HOST_CALL			SMC_RSI_FID(0x199)
+
+#endif /* __SMC_RSI_H_ */
-- 
2.34.1


