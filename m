Return-Path: <kvm+bounces-14495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48E408A2C6C
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 12:35:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C6FB1C2205B
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:35:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B43EB3398E;
	Fri, 12 Apr 2024 10:34:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C61C926AF9
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 10:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918079; cv=none; b=gpITWvm5a5HIUSG09AgNKLhVssLQPSW8qx+HofOZteq1m21RlEFffWQGUQ/xHACQmvMOkkw0Y3ZG/j1f7OvGhwy8aOTwYv/OAci+OHQvf72Dqwl8VtTgo46pU/+wkPudn6HSPDy/huOmJF7MVpRPWU22acqYyJgnWiucoqAdvW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918079; c=relaxed/simple;
	bh=EQh050uJpwE670ii9aFFIzRCiywTZNR9LXFPG5YZIks=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mKDZ18Xd4Zjyq4kjuW4h3LCMr8qE7p3/p/Y1P7tiSmaTAjTTpxVkRoDWFU98Y0GVY1Mvtx34dA1S8pfbs2g9dBvGtRucMiEv4dV9BzLisHk38pMSEkVGmuioDiqTK6EtS67dAZ+AzE0kVNE4GfG14dymeN9/A7SvZEY5WDG2w08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9AFB6113E;
	Fri, 12 Apr 2024 03:35:06 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7CC7E3F64C;
	Fri, 12 Apr 2024 03:34:35 -0700 (PDT)
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
Subject: [kvm-unit-tests PATCH 09/33] arm: realm: Realm initialisation
Date: Fri, 12 Apr 2024 11:33:44 +0100
Message-Id: <20240412103408.2706058-10-suzuki.poulose@arm.com>
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

During the boot, run a check for the presence of RMM. If we are Realm,
detect the Realm configuration using RSI and initialise the key parameters.

Also expose a helper to indicate if this is running inside a Realm

Co-developed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/Makefile.arm64        |  1 +
 lib/arm/asm/rsi.h         | 18 ++++++++++
 lib/arm/setup.c           |  3 ++
 lib/arm64/asm/processor.h |  8 +++++
 lib/arm64/asm/rsi.h       | 37 ++++++++++++++++++++
 lib/arm64/rsi.c           | 73 +++++++++++++++++++++++++++++++++++++++
 6 files changed, 140 insertions(+)
 create mode 100644 lib/arm/asm/rsi.h
 create mode 100644 lib/arm64/asm/rsi.h
 create mode 100644 lib/arm64/rsi.c

diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index 960880f1..bd167db1 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -26,6 +26,7 @@ cflatobjs += lib/arm64/stack.o
 cflatobjs += lib/arm64/processor.o
 cflatobjs += lib/arm64/spinlock.o
 cflatobjs += lib/arm64/gic-v3-its.o lib/arm64/gic-v3-its-cmd.o
+cflatobjs += lib/arm64/rsi.o
 
 ifeq ($(CONFIG_EFI),y)
 cflatobjs += lib/acpi.o
diff --git a/lib/arm/asm/rsi.h b/lib/arm/asm/rsi.h
new file mode 100644
index 00000000..5ff8d011
--- /dev/null
+++ b/lib/arm/asm/rsi.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Arm Limited.
+ * All rights reserved.
+ */
+#ifndef __ASMARM_RSI_H_
+#define __ASMARM_RSI_H_
+
+#include <stdbool.h>
+
+static inline bool is_realm(void)
+{
+	return false;
+}
+
+static inline void arm_rsi_init(void) {}
+
+#endif /* __ASMARM_RSI_H_ */
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index fbb8f523..ebd6d058 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -25,6 +25,7 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/processor.h>
+#include <asm/rsi.h>
 #include <asm/smp.h>
 #include <asm/timer.h>
 #include <asm/psci.h>
@@ -248,6 +249,8 @@ void setup(const void *fdt, phys_addr_t freemem_start)
 	assert(sizeof(long) == 8 || freemem_start < (3ul << 30));
 	freemem = (void *)(unsigned long)freemem_start;
 
+	arm_rsi_init();
+
 	freemem_push_fdt(&freemem, fdt);
 	freemem_push_dt_initrd(&freemem);
 
diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 1c73ba32..320ebaef 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -114,6 +114,14 @@ static inline unsigned long get_id_aa64mmfr0_el1(void)
 #define ID_AA64MMFR0_TGRAN64_SUPPORTED	0x0
 #define ID_AA64MMFR0_TGRAN16_SUPPORTED	0x1
 
+static inline unsigned long get_id_aa64pfr0_el1(void)
+{
+	return read_sysreg(id_aa64pfr0_el1);
+}
+
+#define ID_AA64PFR0_EL1_EL3	(0xf << 12)
+#define ID_AA64PFR0_EL1_EL3_NI	(0x0 << 12)
+
 static inline bool system_supports_granule(size_t granule)
 {
 	u32 shift;
diff --git a/lib/arm64/asm/rsi.h b/lib/arm64/asm/rsi.h
new file mode 100644
index 00000000..37103210
--- /dev/null
+++ b/lib/arm64/asm/rsi.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Arm Limited.
+ * All rights reserved.
+ */
+#ifndef __ASMARM64_RSI_H_
+#define __ASMARM64_RSI_H_
+
+#include <stdbool.h>
+
+#include <asm/arm-smccc.h>
+#include <asm/io.h>
+#include <asm/smc-rsi.h>
+
+#define RSI_GRANULE_SIZE	SZ_4K
+
+extern bool rsi_present;
+
+void arm_rsi_init(void);
+
+int rsi_invoke(unsigned int function_id, unsigned long arg0,
+	       unsigned long arg1, unsigned long arg2,
+	       unsigned long arg3, unsigned long arg4,
+	       unsigned long arg5, unsigned long arg6,
+	       unsigned long arg7, unsigned long arg8,
+	       unsigned long arg9, unsigned long arg10,
+	       struct smccc_result *result);
+
+int __rsi_get_version(unsigned long ver, struct smccc_result *res);
+int rsi_get_version(unsigned long ver);
+
+static inline bool is_realm(void)
+{
+	return rsi_present;
+}
+
+#endif /* __ASMARM64_RSI_H_ */
diff --git a/lib/arm64/rsi.c b/lib/arm64/rsi.c
new file mode 100644
index 00000000..c4560866
--- /dev/null
+++ b/lib/arm64/rsi.c
@@ -0,0 +1,73 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 Arm Limited.
+ * All rights reserved.
+ */
+#include <libcflat.h>
+
+#include <asm/pgtable.h>
+#include <asm/processor.h>
+#include <asm/rsi.h>
+
+bool rsi_present;
+
+int rsi_invoke(unsigned int function_id, unsigned long arg0,
+	       unsigned long arg1, unsigned long arg2,
+	       unsigned long arg3, unsigned long arg4,
+	       unsigned long arg5, unsigned long arg6,
+	       unsigned long arg7, unsigned long arg8,
+	       unsigned long arg9, unsigned long arg10,
+	       struct smccc_result *result)
+{
+	return arm_smccc_smc(function_id, arg0, arg1, arg2, arg3, arg4, arg5,
+			     arg6, arg7, arg8, arg9, arg10, result);
+}
+
+struct rsi_realm_config __attribute__((aligned(RSI_GRANULE_SIZE))) config;
+
+static unsigned long rsi_get_realm_config(struct rsi_realm_config *cfg)
+{
+	struct smccc_result res;
+
+	rsi_invoke(SMC_RSI_REALM_CONFIG, __virt_to_phys((unsigned long)cfg),
+		   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, &res);
+
+	return res.r0;
+}
+
+int __rsi_get_version(unsigned long ver, struct smccc_result *res)
+{
+	if ((get_id_aa64pfr0_el1() & ID_AA64PFR0_EL1_EL3) == ID_AA64PFR0_EL1_EL3_NI)
+		return -1;
+
+	return rsi_invoke(SMC_RSI_ABI_VERSION, ver, 0, 0, 0, 0, 0, 0, 0, 0, 0,
+		          0, res);
+}
+
+int rsi_get_version(unsigned long ver)
+{
+	struct smccc_result res = {};
+	int ret;
+
+
+	ret = __rsi_get_version(ver, &res);
+	if (ret == -1)
+		return ret;
+
+	return res.r0;
+}
+
+void arm_rsi_init(void)
+{
+	if (rsi_get_version(RSI_ABI_VERSION) != RSI_SUCCESS)
+		return;
+
+	if (rsi_get_realm_config(&config))
+		return;
+
+	rsi_present = true;
+
+	phys_mask_shift = (config.ipa_width - 1);
+	/* Set the upper bit of the IPA as the NS_SHARED pte attribute */
+	prot_ns_shared = (1UL << phys_mask_shift);
+}
-- 
2.34.1


