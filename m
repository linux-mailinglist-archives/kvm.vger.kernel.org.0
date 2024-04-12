Return-Path: <kvm+bounces-14418-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 631B18A2988
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:43:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D5CB91F23698
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:43:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 316C851C45;
	Fri, 12 Apr 2024 08:42:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF97550287;
	Fri, 12 Apr 2024 08:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712911349; cv=none; b=BSYATSiwMvCWXYChkJJNUEPneOELwC3dgvbZyXodZM7zSGb/M1vqTyxriFPEeTDo01Y93MJcrpBGzO1dXu0zjtPbCsINKAQV+01JS8p3b/rN6CEpAdo1s16U7+AiHQds6rgYmKLIng57liAwBe9u8PJf3NTwc8x2Ye0hCAK4CyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712911349; c=relaxed/simple;
	bh=wL+CvsDGyUanb/xwR2ALLaRzOW7NIKWLLYjszPVm9hw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ipq/5ByYZ9Kl95V8jLU53DJJfP5Bmv8WVw1411PNqwGAHoxtI5W1L97agAXe0dvn1QehdylT9aGbTCWRoWnqyhDI87rE36E5VPUVJkgPMe6eDQOqYqNVuHMtf5n7hO90vePQRAjGVqJsgSHRzPr6nWXFPn8N2WrF462gX5o/yoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BF2D614BF;
	Fri, 12 Apr 2024 01:42:55 -0700 (PDT)
Received: from e112269-lin.cambridge.arm.com (e112269-lin.cambridge.arm.com [10.1.194.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 67EDC3F6C4;
	Fri, 12 Apr 2024 01:42:24 -0700 (PDT)
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
Subject: [PATCH v2 02/14] arm64: Detect if in a realm and set RIPAS RAM
Date: Fri, 12 Apr 2024 09:42:01 +0100
Message-Id: <20240412084213.1733764-3-steven.price@arm.com>
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
 arch/arm64/include/asm/rsi.h      | 46 ++++++++++++++++++++++++
 arch/arm64/include/asm/rsi_cmds.h | 22 ++++++++++++
 arch/arm64/kernel/Makefile        |  3 +-
 arch/arm64/kernel/rsi.c           | 58 +++++++++++++++++++++++++++++++
 arch/arm64/kernel/setup.c         |  3 ++
 arch/arm64/mm/init.c              |  2 ++
 6 files changed, 133 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/include/asm/rsi.h
 create mode 100644 arch/arm64/kernel/rsi.c

diff --git a/arch/arm64/include/asm/rsi.h b/arch/arm64/include/asm/rsi.h
new file mode 100644
index 000000000000..3b56aac5dc43
--- /dev/null
+++ b/arch/arm64/include/asm/rsi.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2023 ARM Ltd.
+ */
+
+#ifndef __ASM_RSI_H_
+#define __ASM_RSI_H_
+
+#include <linux/jump_label.h>
+#include <asm/rsi_cmds.h>
+
+extern struct static_key_false rsi_present;
+
+void arm64_setup_memory(void);
+
+void __init arm64_rsi_init(void);
+static inline bool is_realm_world(void)
+{
+	return static_branch_unlikely(&rsi_present);
+}
+
+static inline void set_memory_range(phys_addr_t start, phys_addr_t end,
+				    enum ripas state)
+{
+	unsigned long ret;
+	phys_addr_t top;
+
+	while (start != end) {
+		ret = rsi_set_addr_range_state(start, end, state, &top);
+		BUG_ON(ret);
+		BUG_ON(top < start);
+		BUG_ON(top > end);
+		start = top;
+	}
+}
+
+static inline void set_memory_range_protected(phys_addr_t start, phys_addr_t end)
+{
+	set_memory_range(start, end, RSI_RIPAS_RAM);
+}
+
+static inline void set_memory_range_shared(phys_addr_t start, phys_addr_t end)
+{
+	set_memory_range(start, end, RSI_RIPAS_EMPTY);
+}
+#endif
diff --git a/arch/arm64/include/asm/rsi_cmds.h b/arch/arm64/include/asm/rsi_cmds.h
index 458fb58c4251..b4cbeafa2f41 100644
--- a/arch/arm64/include/asm/rsi_cmds.h
+++ b/arch/arm64/include/asm/rsi_cmds.h
@@ -10,6 +10,11 @@
 
 #include <asm/rsi_smc.h>
 
+enum ripas {
+	RSI_RIPAS_EMPTY,
+	RSI_RIPAS_RAM,
+};
+
 static inline void invoke_rsi_fn_smc_with_res(unsigned long function_id,
 					      unsigned long arg0,
 					      unsigned long arg1,
@@ -44,4 +49,21 @@ static inline unsigned long rsi_get_realm_config(struct realm_config *cfg)
 	return res.a0;
 }
 
+static inline unsigned long rsi_set_addr_range_state(phys_addr_t start,
+						     phys_addr_t end,
+						     enum ripas state,
+						     phys_addr_t *top)
+{
+	struct arm_smccc_res res;
+
+	invoke_rsi_fn_smc_with_res(SMC_RSI_IPA_STATE_SET,
+				   start, end, state, RSI_NO_CHANGE_DESTROYED,
+				   &res);
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
index 000000000000..1076649ac082
--- /dev/null
+++ b/arch/arm64/kernel/rsi.c
@@ -0,0 +1,58 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2023 ARM Ltd.
+ */
+
+#include <linux/jump_label.h>
+#include <linux/memblock.h>
+#include <asm/rsi.h>
+
+DEFINE_STATIC_KEY_FALSE_RO(rsi_present);
+EXPORT_SYMBOL(rsi_present);
+
+static bool rsi_version_matches(void)
+{
+	unsigned long ver;
+	unsigned long ret = rsi_get_version(RSI_ABI_VERSION, &ver, NULL);
+
+	if (ret == SMCCC_RET_NOT_SUPPORTED)
+		return false;
+
+	if (ver != RSI_ABI_VERSION) {
+		pr_err("RME: RSI version %lu.%lu not supported\n",
+		       RSI_ABI_VERSION_GET_MAJOR(ver),
+		       RSI_ABI_VERSION_GET_MINOR(ver));
+		return false;
+	}
+
+	pr_info("RME: Using RSI version %lu.%lu\n",
+		RSI_ABI_VERSION_GET_MAJOR(ver),
+		RSI_ABI_VERSION_GET_MINOR(ver));
+
+	return true;
+}
+
+void arm64_setup_memory(void)
+{
+	u64 i;
+	phys_addr_t start, end;
+
+	if (!static_branch_unlikely(&rsi_present))
+		return;
+
+	/*
+	 * Iterate over the available memory ranges
+	 * and convert the state to protected memory.
+	 */
+	for_each_mem_range(i, &start, &end) {
+		set_memory_range_protected(start, end);
+	}
+}
+
+void __init arm64_rsi_init(void)
+{
+	if (!rsi_version_matches())
+		return;
+
+	static_branch_enable(&rsi_present);
+}
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 65a052bf741f..a4bd97e74704 100644
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
@@ -293,6 +294,8 @@ void __init __no_sanitize_address setup_arch(char **cmdline_p)
 	 * cpufeature code and early parameters.
 	 */
 	jump_label_init();
+	/* Init RSI after jump_labels are active */
+	arm64_rsi_init();
 	parse_early_param();
 
 	dynamic_scs_init();
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 03efd86dce0a..786fd6ce5f17 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -40,6 +40,7 @@
 #include <asm/kvm_host.h>
 #include <asm/memory.h>
 #include <asm/numa.h>
+#include <asm/rsi.h>
 #include <asm/sections.h>
 #include <asm/setup.h>
 #include <linux/sizes.h>
@@ -313,6 +314,7 @@ void __init arm64_memblock_init(void)
 	early_init_fdt_scan_reserved_mem();
 
 	high_memory = __va(memblock_end_of_DRAM() - 1) + 1;
+	arm64_setup_memory();
 }
 
 void __init bootmem_init(void)
-- 
2.34.1


