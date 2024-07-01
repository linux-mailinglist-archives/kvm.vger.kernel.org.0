Return-Path: <kvm+bounces-20773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A0BE91DBCB
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 11:56:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D918E1F23569
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2024 09:56:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7CEB12BEBB;
	Mon,  1 Jul 2024 09:55:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8063F1422D5;
	Mon,  1 Jul 2024 09:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719827730; cv=none; b=CZZPyGwaJISHOg4HQbsreFqjG5CfAvIYoyI52gIBnBGVlZG9WVN31q9LqQVm+PLJnouhszCprQTwnnVKoghYGp1bzk98PGQ7e6rYViNswZfPlx2XEgKSJWsvwcHQ4MKjwZIslcTsBS1kHoMZfgi+ORGu1DM5JgnqFTZeL/tXQYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719827730; c=relaxed/simple;
	bh=DhuBOIoyWMM6/7JwTjK6oBUUiMtIt3p6tNHOMj9vWK0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=s8YT/LempCIa/aQJq+JzhDR9a/7uD6BMy1RmkZ8HdJ10W3CyYW0hS2uievQFrSmjzXpidol0s/3n3kHNLZjt08cG/Rim3c0nJsohUdfk8EQO02nHdyejcf8Ftjbf/p7P+JsFdI8WkatOACaePIv3XDNFc7ZfDwuxaGkvdYF8Mh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 22F36339;
	Mon,  1 Jul 2024 02:55:53 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.44.170])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BC1103F762;
	Mon,  1 Jul 2024 02:55:24 -0700 (PDT)
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
Subject: [PATCH v4 03/15] arm64: Detect if in a realm and set RIPAS RAM
Date: Mon,  1 Jul 2024 10:54:53 +0100
Message-Id: <20240701095505.165383-4-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240701095505.165383-1-steven.price@arm.com>
References: <20240701095505.165383-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Detect that the VM is a realm guest by the presence of the RSI
interface.

If in a realm then all memory needs to be marked as RIPAS RAM initially,
the loader may or may not have done this for us. To be sure iterate over
all RAM and mark it as such. Any failure is fatal as that implies the
RAM regions passed to Linux are incorrect - which would mean failing
later when attempting to access non-existent RAM.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Co-developed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v3:
 * Provide safe/unsafe versions for converting memory to protected,
   using the safer version only for the early boot.
 * Use the new psci_early_test_conduit() function to avoid calling an
   SMC if EL3 is not present (or not configured to handle an SMC).
Changes since v2:
 * Use DECLARE_STATIC_KEY_FALSE rather than "extern struct
   static_key_false".
 * Rename set_memory_range() to rsi_set_memory_range().
 * Downgrade some BUG()s to WARN()s and handle the condition by
   propagating up the stack. Comment the remaining case that ends in a
   BUG() to explain why.
 * Rely on the return from rsi_request_version() rather than checking
   the version the RMM claims to support.
 * Rename the generic sounding arm64_setup_memory() to
   arm64_rsi_setup_memory() and move the call site to setup_arch().
---
 arch/arm64/include/asm/rsi.h      | 64 +++++++++++++++++++++++++
 arch/arm64/include/asm/rsi_cmds.h | 22 +++++++++
 arch/arm64/kernel/Makefile        |  3 +-
 arch/arm64/kernel/rsi.c           | 77 +++++++++++++++++++++++++++++++
 arch/arm64/kernel/setup.c         |  8 ++++
 5 files changed, 173 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/include/asm/rsi.h
 create mode 100644 arch/arm64/kernel/rsi.c

diff --git a/arch/arm64/include/asm/rsi.h b/arch/arm64/include/asm/rsi.h
new file mode 100644
index 000000000000..29fdc194d27b
--- /dev/null
+++ b/arch/arm64/include/asm/rsi.h
@@ -0,0 +1,64 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2024 ARM Ltd.
+ */
+
+#ifndef __ASM_RSI_H_
+#define __ASM_RSI_H_
+
+#include <linux/jump_label.h>
+#include <asm/rsi_cmds.h>
+
+DECLARE_STATIC_KEY_FALSE(rsi_present);
+
+void __init arm64_rsi_init(void);
+void __init arm64_rsi_setup_memory(void);
+static inline bool is_realm_world(void)
+{
+	return static_branch_unlikely(&rsi_present);
+}
+
+static inline int rsi_set_memory_range(phys_addr_t start, phys_addr_t end,
+				       enum ripas state, unsigned long flags)
+{
+	unsigned long ret;
+	phys_addr_t top;
+
+	while (start != end) {
+		ret = rsi_set_addr_range_state(start, end, state, flags, &top);
+		if (WARN_ON(ret || top < start || top > end))
+			return -EINVAL;
+		start = top;
+	}
+
+	return 0;
+}
+
+/*
+ * Convert the specified range to RAM. Do not use this if you rely on the
+ * contents of a page that may already be in RAM state.
+ */
+static inline int rsi_set_memory_range_protected(phys_addr_t start,
+						 phys_addr_t end)
+{
+	return rsi_set_memory_range(start, end, RSI_RIPAS_RAM,
+				    RSI_CHANGE_DESTROYED);
+}
+
+/*
+ * Convert the specified range to RAM. Do not convert any pages that may have
+ * been DESTROYED, without our permission.
+ */
+static inline int rsi_set_memory_range_protected_safe(phys_addr_t start,
+						      phys_addr_t end)
+{
+	return rsi_set_memory_range(start, end, RSI_RIPAS_RAM,
+				    RSI_NO_CHANGE_DESTROYED);
+}
+
+static inline int rsi_set_memory_range_shared(phys_addr_t start,
+					      phys_addr_t end)
+{
+	return rsi_set_memory_range(start, end, RSI_RIPAS_EMPTY, 0);
+}
+#endif
diff --git a/arch/arm64/include/asm/rsi_cmds.h b/arch/arm64/include/asm/rsi_cmds.h
index 89e907f3af0c..acb557dd4b88 100644
--- a/arch/arm64/include/asm/rsi_cmds.h
+++ b/arch/arm64/include/asm/rsi_cmds.h
@@ -10,6 +10,11 @@
 
 #include <asm/rsi_smc.h>
 
+enum ripas {
+	RSI_RIPAS_EMPTY,
+	RSI_RIPAS_RAM,
+};
+
 static inline unsigned long rsi_request_version(unsigned long req,
 						unsigned long *out_lower,
 						unsigned long *out_higher)
@@ -35,4 +40,21 @@ static inline unsigned long rsi_get_realm_config(struct realm_config *cfg)
 	return res.a0;
 }
 
+static inline unsigned long rsi_set_addr_range_state(phys_addr_t start,
+						     phys_addr_t end,
+						     enum ripas state,
+						     unsigned long flags,
+						     phys_addr_t *top)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_smc(SMC_RSI_IPA_STATE_SET, start, end, state,
+		      flags, 0, 0, 0, &res);
+
+	if (top)
+		*top = res.a1;
+
+	return res.a0;
+}
+
 #endif
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 763824963ed1..a483b916ed11 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -33,7 +33,8 @@ obj-y			:= debug-monitors.o entry.o irq.o fpsimd.o		\
 			   return_address.o cpuinfo.o cpu_errata.o		\
 			   cpufeature.o alternative.o cacheinfo.o		\
 			   smp.o smp_spin_table.o topology.o smccc-call.o	\
-			   syscall.o proton-pack.o idle.o patching.o pi/
+			   syscall.o proton-pack.o idle.o patching.o pi/	\
+			   rsi.o
 
 obj-$(CONFIG_COMPAT)			+= sys32.o signal32.o			\
 					   sys_compat.o
diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
new file mode 100644
index 000000000000..f01bff9dab04
--- /dev/null
+++ b/arch/arm64/kernel/rsi.c
@@ -0,0 +1,77 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2023 ARM Ltd.
+ */
+
+#include <linux/jump_label.h>
+#include <linux/memblock.h>
+#include <linux/psci.h>
+#include <asm/rsi.h>
+
+DEFINE_STATIC_KEY_FALSE_RO(rsi_present);
+EXPORT_SYMBOL(rsi_present);
+
+static bool rsi_version_matches(void)
+{
+	unsigned long ver_lower, ver_higher;
+	unsigned long ret = rsi_request_version(RSI_ABI_VERSION,
+						&ver_lower,
+						&ver_higher);
+
+	if (ret == SMCCC_RET_NOT_SUPPORTED)
+		return false;
+
+	if (ret != RSI_SUCCESS) {
+		pr_err("RME: RMM doesn't support RSI version %u.%u. Supported range: %lu.%lu-%lu.%lu\n",
+		       RSI_ABI_VERSION_MAJOR, RSI_ABI_VERSION_MINOR,
+		       RSI_ABI_VERSION_GET_MAJOR(ver_lower),
+		       RSI_ABI_VERSION_GET_MINOR(ver_lower),
+		       RSI_ABI_VERSION_GET_MAJOR(ver_higher),
+		       RSI_ABI_VERSION_GET_MINOR(ver_higher));
+		return false;
+	}
+
+	pr_info("RME: Using RSI version %lu.%lu\n",
+		RSI_ABI_VERSION_GET_MAJOR(ver_lower),
+		RSI_ABI_VERSION_GET_MINOR(ver_lower));
+
+	return true;
+}
+
+void __init arm64_rsi_setup_memory(void)
+{
+	u64 i;
+	phys_addr_t start, end;
+
+	if (!is_realm_world())
+		return;
+
+	/*
+	 * Iterate over the available memory ranges and convert the state to
+	 * protected memory. We should take extra care to ensure that we DO NOT
+	 * permit any "DESTROYED" pages to be converted to "RAM".
+	 *
+	 * BUG_ON is used because if the attempt to switch the memory to
+	 * protected has failed here, then future accesses to the memory are
+	 * simply going to be reflected as a fault which we can't handle.
+	 * Bailing out early prevents the guest limping on and dieing later.
+	 */
+	for_each_mem_range(i, &start, &end) {
+		BUG_ON(rsi_set_memory_range_protected_safe(start, end));
+	}
+}
+
+void __init arm64_rsi_init(void)
+{
+	/*
+	 * If PSCI isn't using SMC, RMM isn't present. Don't try to execute an
+	 * SMC as it could be UNDEFINED.
+	 */
+	if (!psci_early_test_conduit(SMCCC_CONDUIT_SMC))
+		return;
+	if (!rsi_version_matches())
+		return;
+
+	static_branch_enable(&rsi_present);
+}
+
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index a096e2451044..143f87615af0 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -43,6 +43,7 @@
 #include <asm/cpu_ops.h>
 #include <asm/kasan.h>
 #include <asm/numa.h>
+#include <asm/rsi.h>
 #include <asm/scs.h>
 #include <asm/sections.h>
 #include <asm/setup.h>
@@ -293,6 +294,11 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
 	 * cpufeature code and early parameters.
 	 */
 	jump_label_init();
+	/*
+	 * Init RSI before early param so that "earlycon" console uses the
+	 * shared alias when in a realm
+	 */
+	arm64_rsi_init();
 	parse_early_param();
 
 	dynamic_scs_init();
@@ -328,6 +334,8 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
 
 	arm64_memblock_init();
 
+	arm64_rsi_setup_memory();
+
 	paging_init();
 
 	acpi_table_upgrade();
-- 
2.34.1


