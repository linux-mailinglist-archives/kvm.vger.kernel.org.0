Return-Path: <kvm+bounces-27925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6035F990675
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 16:44:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D7F151F20ACA
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 14:44:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF95521B459;
	Fri,  4 Oct 2024 14:43:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 619BC2194B9;
	Fri,  4 Oct 2024 14:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728053019; cv=none; b=hl8PVKx/a0pQgNUdg/yWyjpmhGxwkYj7SsbupNspqzdxncW16+EE40hP9qq0vzZR1l4FZiN6Pf/TnvtY6lP6Mxk9GvnMJyktbfEsinRhBmW3forKhnN7f0YtUPpONa+KzsGtc3yX19RF2YZ3ETI58mgR4N+DhThG9tERwksb1RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728053019; c=relaxed/simple;
	bh=k8XUw5rUwgd90SgAde62fNLtRrvCCzRD99MSrx+XqLo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KFmxlxxA2gT2SctomR1DfAnJwXqzBI9Bs0/frX/E310Gt4/7Rn6QV40A0YXNrCow7Jcrm29uNw6s37deZT3lHN4ImW1X7z1d+BcN1TLrM8DRdfIyORXM9/hAt8IoHF/nmkwIFAG3sGJvebzrfx8O81WAii7irhMdfqlEkiqt1tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 497AF1063;
	Fri,  4 Oct 2024 07:44:05 -0700 (PDT)
Received: from e122027.cambridge.arm.com (unknown [10.1.25.25])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EDA433F7C5;
	Fri,  4 Oct 2024 07:43:31 -0700 (PDT)
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
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH v6 02/11] arm64: Detect if in a realm and set RIPAS RAM
Date: Fri,  4 Oct 2024 15:42:57 +0100
Message-Id: <20241004144307.66199-3-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241004144307.66199-1-steven.price@arm.com>
References: <20241004144307.66199-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Detect that the VM is a realm guest by the presence of the RSI
interface. This is done after PSCI has been initialised so that we can
check the SMCCC conduit before making any RSI calls.

If in a realm then all memory needs to be marked as RIPAS RAM initially,
the loader may or may not have done this for us. To be sure iterate over
all RAM and mark it as such. Any failure is fatal as that implies the
RAM regions passed to Linux are incorrect - which would mean failing
later when attempting to access non-existent RAM.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Co-developed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v5:
 * Replace BUG_ON() with a panic() call that provides a message with the
   memory range that couldn't be set to RIPAS_RAM.
 * Move the call to arm64_rsi_init() later so that it is after PSCI,
   this means we can use arm_smccc_1_1_get_conduit() to check if it is
   safe to make RSI calls.
Changes since v4:
 * Minor tidy ups.
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
 arch/arm64/include/asm/rsi.h | 66 +++++++++++++++++++++++++++++++
 arch/arm64/kernel/Makefile   |  3 +-
 arch/arm64/kernel/rsi.c      | 75 ++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/setup.c    |  3 ++
 4 files changed, 146 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/include/asm/rsi.h
 create mode 100644 arch/arm64/kernel/rsi.c

diff --git a/arch/arm64/include/asm/rsi.h b/arch/arm64/include/asm/rsi.h
new file mode 100644
index 000000000000..e4c01796c618
--- /dev/null
+++ b/arch/arm64/include/asm/rsi.h
@@ -0,0 +1,66 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2024 ARM Ltd.
+ */
+
+#ifndef __ASM_RSI_H_
+#define __ASM_RSI_H_
+
+#include <linux/errno.h>
+#include <linux/jump_label.h>
+#include <asm/rsi_cmds.h>
+
+DECLARE_STATIC_KEY_FALSE(rsi_present);
+
+void __init arm64_rsi_init(void);
+
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
+	return rsi_set_memory_range(start, end, RSI_RIPAS_EMPTY,
+				    RSI_CHANGE_DESTROYED);
+}
+#endif /* __ASM_RSI_H_ */
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 2b112f3b7510..71c29a2a2f19 100644
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
index 000000000000..9bf757b4b00c
--- /dev/null
+++ b/arch/arm64/kernel/rsi.c
@@ -0,0 +1,75 @@
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
+		pr_err("RME: RMM doesn't support RSI version %lu.%lu. Supported range: %lu.%lu-%lu.%lu\n",
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
+static void __init arm64_rsi_setup_memory(void)
+{
+	u64 i;
+	phys_addr_t start, end;
+
+	/*
+	 * Iterate over the available memory ranges and convert the state to
+	 * protected memory. We should take extra care to ensure that we DO NOT
+	 * permit any "DESTROYED" pages to be converted to "RAM".
+	 *
+	 * panic() is used because if the attempt to switch the memory to
+	 * protected has failed here, then future accesses to the memory are
+	 * simply going to be reflected as a SEA (Synchronous External Abort)
+	 * which we can't handle.  Bailing out early prevents the guest limping
+	 * on and dying later.
+	 */
+	for_each_mem_range(i, &start, &end) {
+		if (rsi_set_memory_range_protected_safe(start, end))
+			panic("Failed to set memory range to protected: %pa-%pa",
+			      &start, &end);
+	}
+}
+
+void __init arm64_rsi_init(void)
+{
+	if (arm_smccc_1_1_get_conduit() != SMCCC_CONDUIT_SMC)
+		return;
+	if (!rsi_version_matches())
+		return;
+
+	arm64_rsi_setup_memory();
+
+	static_branch_enable(&rsi_present);
+}
+
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index b22d28ec8028..b5e1e306fa51 100644
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
@@ -351,6 +352,8 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
 	else
 		psci_acpi_init();
 
+	arm64_rsi_init();
+
 	init_bootcpu_ops();
 	smp_init_cpus();
 	smp_build_mpidr_hash();
-- 
2.34.1


