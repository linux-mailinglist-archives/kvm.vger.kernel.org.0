Return-Path: <kvm+bounces-14493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47EE88A2C6A
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 12:35:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7D5A6B21ED5
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:35:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8FE45490F;
	Fri, 12 Apr 2024 10:34:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1B1A54906
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 10:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918075; cv=none; b=BucP3t+eLdV/OEO7G1cJlYiSDQvve2+blIMuQs2C6GbbjzPOSMW9iZl4xrWeOmadLd70h/zuctjoM6HjDwo9zY3nPdz00XgvMVkzlrTvBqM4+bF1jufiP/QkqE3mqWNrG/3HfQV+zTaBH9VvfbIMxVi7IqAHfgie/INxpYM6jQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918075; c=relaxed/simple;
	bh=dSJLXXj+JMGxhXugjpJ11u+PtBVWwPsBCJswOrg2HrY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=inkCUYs6NOA2x0ojNNE8NU1gP5H8fPK5Bc0n4ke+d72MExQXoUsbSltBeielt1UhGvt5Je7bI0wurP/urwIpINRG5OjaZStyFl70bDvaQlQLz5CD7gKqDmjwNMyc0P1YZtFtQSNMi3lmYpx+ri4oITXU9m2cgy7kGWDwZb/79As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 84AA41596;
	Fri, 12 Apr 2024 03:35:02 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8E5433F64C;
	Fri, 12 Apr 2024 03:34:31 -0700 (PDT)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	maz@kernel.org,
	alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	steven.price@arm.com,
	james.morse@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvm-unit-tests PATCH 07/33] arm: realm: Add RSI interface header
Date: Fri, 12 Apr 2024 11:33:42 +0100
Message-Id: <20240412103408.2706058-8-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240412103408.2706058-1-suzuki.poulose@arm.com>
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Joey Gouly <joey.gouly@arm.com>

Add the defintions for the Realm Service Interface (RSI). RSI calls are a way
for the Realm to communicate with the RMM and request information/services.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
[ Update RSI headers to match the RMM spec v1.0-eac5 ]
Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 lib/arm64/asm/smc-rsi.h | 173 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 173 insertions(+)
 create mode 100644 lib/arm64/asm/smc-rsi.h

diff --git a/lib/arm64/asm/smc-rsi.h b/lib/arm64/asm/smc-rsi.h
new file mode 100644
index 00000000..7fafbb69
--- /dev/null
+++ b/lib/arm64/asm/smc-rsi.h
@@ -0,0 +1,173 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Arm Limited.
+ * All rights reserved.
+ */
+#ifndef __SMC_RSI_H_
+#define __SMC_RSI_H_
+
+/*
+ * This file describes the Realm Services Interface (RSI) Application Binary
+ * Interface (ABI) for SMC calls made from within the Realm to the RMM and
+ * serviced by the RMM.
+ */
+
+#define SMC_RSI_CALL_BASE		0xC4000190
+
+#define RSI_ABI_VERSION_MAJOR		1
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
+#define RSI_ERROR_COUNT			4
+
+#define RSI_HASH_SHA_256		0
+#define RSI_HASH_SHA_512		1
+
+
+#define SMC_RSI_FID(_x)			(SMC_RSI_CALL_BASE + (_x))
+
+/*
+ * Returns whether the requested RSI version is compatible.
+ * arg1: Requested interface version.
+ * ret0: RSI_SUCCESS / RSI_ERROR_INPUT
+ * ret1: Lower implemented interface version
+ * ret2: Higher implemented interface version
+ */
+#define SMC_RSI_ABI_VERSION			SMC_RSI_FID(0)
+
+/*
+ * Returns RSI features.
+ * arg1: Feature register index
+ * ret0: Status
+ * ret1: Feature register value
+ */
+#define SMC_RSI_FEATURES			SMC_RSI_FID(1)
+
+
+/*
+ * Returns a measurement
+ * arg1 == Index (0..4), which measurement (RIM or REM) to read
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
+#define SMC_RSI_MEASUREMENT_READ		SMC_RSI_FID(2)
+
+/*
+ * Extend a Realm Exetendable measurement.
+ * arg1  == Index (1..4), which measurement (REM) to extend
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
+#define SMC_RSI_MEASUREMENT_EXTEND		SMC_RSI_FID(3)
+
+/*
+ * Initialise the operation to retrieve an attestation token
+ * arg1 == Challenge value, bytes:  0 -  7
+ * arg2 == Challenge value, bytes:  7 - 15
+ * arg3 == Challenge value, bytes: 16 - 23
+ * arg4 == Challenge value, bytes: 24 - 31
+ * arg5 == Challenge value, bytes: 32 - 39
+ * arg6 == Challenge value, bytes: 40 - 47
+ * arg7 == Challenge value, bytes: 48 - 55
+ * arg8 == Challenge value, bytes: 56 - 63
+ * ret0 == Status / error
+ * ret1 == Upper bound of the token in bytes
+ */
+#define SMC_RSI_ATTEST_TOKEN_INIT		SMC_RSI_FID(4)
+
+/*
+ * Continue the operation to retrieve an attestation token
+ * arg1 == The IPA of token buffer
+ * arg2 == Offset within the from the beginning of @arg1
+ * arg3 == Space available from @arg2 in the buffer.
+ * ret0 == Status / error
+ * ret1 == Size of completed token in bytes
+ */
+#define SMC_RSI_ATTEST_TOKEN_CONTINUE		SMC_RSI_FID(5)
+
+
+
+#ifndef __ASSEMBLY__
+
+struct rsi_realm_config {
+	union {
+		struct {
+			/* Width of IPA in bits */
+			unsigned long ipa_width;
+			/* Hash algorithm */
+			unsigned long algorithm;
+		};
+		unsigned char __reserved0[0x1000];
+	};
+	/* Offset 0x1000 */
+};
+
+#endif /* __ASSEMBLY__ */
+
+/*
+ * arg0 == struct rsi_realm_config addr
+ */
+#define SMC_RSI_REALM_CONFIG			SMC_RSI_FID(6)
+
+/*
+ * arg0 == IPA address of target region
+ * arg1 == size of target region in bytes
+ * arg2 == RIPAS value
+ * arg3 == RipasChangeFlags
+ * ret0 == Status / error
+ * ret1 == Top of modified IPA range
+ */
+#define RSI_NO_CHANGE_DESTROYED			0
+#define RSI_CHANGE_DESTROYED			1
+
+#define SMC_RSI_IPA_STATE_SET			SMC_RSI_FID(7)
+
+/*
+ * Get the IPA state for the given IPA
+ * arg0 == IPA
+ * ret0 == Status/error
+ * ret1 == RIPAS value.
+ */
+#define SMC_RSI_IPA_STATE_GET			SMC_RSI_FID(8)
+
+#define RSI_HOST_CALL_NR_GPRS			31
+
+#ifndef __ASSEMBLY__
+
+struct rsi_host_call {
+	unsigned int imm;
+	unsigned long gprs[RSI_HOST_CALL_NR_GPRS];
+};
+
+#endif /* __ASSEMBLY__ */
+
+/*
+ * arg0 == struct rsi_host_call addr
+ */
+#define SMC_RSI_HOST_CALL			SMC_RSI_FID(9)
+
+#endif /* __SMC_RSI_H_ */
-- 
2.34.1


