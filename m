Return-Path: <kvm+bounces-18868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 058208FC7E7
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 11:34:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B844283A8A
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 09:34:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3CF1190049;
	Wed,  5 Jun 2024 09:30:57 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1C54190045;
	Wed,  5 Jun 2024 09:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717579857; cv=none; b=W2jB45gsRBUXsU2AS5PC1NW8qLdKTumfaCHMjzCPfc1rKc7TmrbTI7O4ou9oIYh/nvHQf/OLqTKOvyLxn/lPgUsYIKH/0g6cj58sP86rf6QPmPOcgVmVnJbQv/VJXkwMq1tZL63KXwPkYPSNMX6Wci4ivy20b4VC8i8qNqIhkiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717579857; c=relaxed/simple;
	bh=gmlsJyB6T3MNrPgQ/q4sZa5vwmD5AVjFI3kLXf/9P6o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PtIbVNcJU7ggSfRgp9neXzn/2vqmPvDyjUqZbxzgNBQnTKstUrbqfLwVPXVcy5XnIs9h6Ty5i+0yPdWx7CSt8U/5XAPWc7dnzbrc10Z64Y31KWdmVCVs2c9jQzrSEFy+YNSfS45Kp17iu2ZAAKMthq1g2DIqqBC3+IRxWbq/q18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BC250FEC;
	Wed,  5 Jun 2024 02:31:19 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.39.129])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AEC353F792;
	Wed,  5 Jun 2024 02:30:51 -0700 (PDT)
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
Subject: [PATCH v3 09/14] arm64: Enable memory encrypt for Realms
Date: Wed,  5 Jun 2024 10:30:01 +0100
Message-Id: <20240605093006.145492-10-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240605093006.145492-1-steven.price@arm.com>
References: <20240605093006.145492-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Use the memory encryption APIs to trigger a RSI call to request a
transition between protected memory and shared memory (or vice versa)
and updating the kernel's linear map of modified pages to flip the top
bit of the IPA. This requires that block mappings are not used in the
direct map for realm guests.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Co-developed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v2:
 * Fix location of set_memory_{en,de}crypted() and export them.
 * Break-before-make when changing the top bit of the IPA for
   transitioning to/from shared.
---
 arch/arm64/Kconfig                   |  3 ++
 arch/arm64/include/asm/mem_encrypt.h | 17 ++++++++
 arch/arm64/include/asm/set_memory.h  |  3 ++
 arch/arm64/kernel/rsi.c              | 12 +++++
 arch/arm64/mm/pageattr.c             | 65 ++++++++++++++++++++++++++--
 5 files changed, 97 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm64/include/asm/mem_encrypt.h

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 5d91259ee7b5..0f1480caeeec 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -20,6 +20,7 @@ config ARM64
 	select ARCH_ENABLE_SPLIT_PMD_PTLOCK if PGTABLE_LEVELS > 2
 	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
 	select ARCH_HAS_CACHE_LINE_SIZE
+	select ARCH_HAS_CC_PLATFORM
 	select ARCH_HAS_CURRENT_STACK_POINTER
 	select ARCH_HAS_DEBUG_VIRTUAL
 	select ARCH_HAS_DEBUG_VM_PGTABLE
@@ -41,6 +42,8 @@ config ARM64
 	select ARCH_HAS_SETUP_DMA_OPS
 	select ARCH_HAS_SET_DIRECT_MAP
 	select ARCH_HAS_SET_MEMORY
+	select ARCH_HAS_MEM_ENCRYPT
+	select ARCH_HAS_FORCE_DMA_UNENCRYPTED
 	select ARCH_STACKWALK
 	select ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_HAS_STRICT_MODULE_RWX
diff --git a/arch/arm64/include/asm/mem_encrypt.h b/arch/arm64/include/asm/mem_encrypt.h
new file mode 100644
index 000000000000..e47265cd180a
--- /dev/null
+++ b/arch/arm64/include/asm/mem_encrypt.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2023 ARM Ltd.
+ */
+
+#ifndef __ASM_MEM_ENCRYPT_H
+#define __ASM_MEM_ENCRYPT_H
+
+#include <asm/rsi.h>
+
+/* All DMA must be to non-secure memory for now */
+static inline bool force_dma_unencrypted(struct device *dev)
+{
+	return is_realm_world();
+}
+
+#endif
diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/set_memory.h
index 0f740b781187..3b6619c04677 100644
--- a/arch/arm64/include/asm/set_memory.h
+++ b/arch/arm64/include/asm/set_memory.h
@@ -14,4 +14,7 @@ int set_direct_map_invalid_noflush(struct page *page);
 int set_direct_map_default_noflush(struct page *page);
 bool kernel_page_present(struct page *page);
 
+int set_memory_encrypted(unsigned long addr, int numpages);
+int set_memory_decrypted(unsigned long addr, int numpages);
+
 #endif /* _ASM_ARM64_SET_MEMORY_H */
diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
index 5cb42609219f..898952d135b0 100644
--- a/arch/arm64/kernel/rsi.c
+++ b/arch/arm64/kernel/rsi.c
@@ -6,6 +6,7 @@
 #include <linux/jump_label.h>
 #include <linux/memblock.h>
 #include <linux/swiotlb.h>
+#include <linux/cc_platform.h>
 
 #include <asm/rsi.h>
 
@@ -19,6 +20,17 @@ unsigned int phys_mask_shift = CONFIG_ARM64_PA_BITS;
 DEFINE_STATIC_KEY_FALSE_RO(rsi_present);
 EXPORT_SYMBOL(rsi_present);
 
+bool cc_platform_has(enum cc_attr attr)
+{
+	switch (attr) {
+	case CC_ATTR_MEM_ENCRYPT:
+		return is_realm_world();
+	default:
+		return false;
+	}
+}
+EXPORT_SYMBOL_GPL(cc_platform_has);
+
 static bool rsi_version_matches(void)
 {
 	unsigned long ver_lower, ver_higher;
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index 0e270a1c51e6..3e7d81696756 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -5,10 +5,12 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/mem_encrypt.h>
 #include <linux/sched.h>
 #include <linux/vmalloc.h>
 
 #include <asm/cacheflush.h>
+#include <asm/pgtable-prot.h>
 #include <asm/set_memory.h>
 #include <asm/tlbflush.h>
 #include <asm/kfence.h>
@@ -23,14 +25,16 @@ bool rodata_full __ro_after_init = IS_ENABLED(CONFIG_RODATA_FULL_DEFAULT_ENABLED
 bool can_set_direct_map(void)
 {
 	/*
-	 * rodata_full and DEBUG_PAGEALLOC require linear map to be
-	 * mapped at page granularity, so that it is possible to
+	 * rodata_full, DEBUG_PAGEALLOC and a Realm guest all require linear
+	 * map to be mapped at page granularity, so that it is possible to
 	 * protect/unprotect single pages.
 	 *
 	 * KFENCE pool requires page-granular mapping if initialized late.
+	 *
+	 * Realms need to make pages shared/protected at page granularity.
 	 */
 	return rodata_full || debug_pagealloc_enabled() ||
-	       arm64_kfence_can_set_direct_map();
+		arm64_kfence_can_set_direct_map() || is_realm_world();
 }
 
 static int change_page_range(pte_t *ptep, unsigned long addr, void *data)
@@ -192,6 +196,61 @@ int set_direct_map_default_noflush(struct page *page)
 				   PAGE_SIZE, change_page_range, &data);
 }
 
+static int __set_memory_encrypted(unsigned long addr,
+				  int numpages,
+				  bool encrypt)
+{
+	unsigned long set_prot = 0, clear_prot = 0;
+	phys_addr_t start, end;
+	int ret;
+
+	if (!is_realm_world())
+		return 0;
+
+	if (!__is_lm_address(addr))
+		return -EINVAL;
+
+	start = __virt_to_phys(addr);
+	end = start + numpages * PAGE_SIZE;
+
+	/*
+	 * Break the mapping before we make any changes to avoid stale TLB
+	 * entries or Synchronous External Aborts caused by RIPAS_EMPTY
+	 */
+	ret = __change_memory_common(addr, PAGE_SIZE * numpages,
+				     __pgprot(0),
+				     __pgprot(PTE_VALID));
+
+	if (encrypt) {
+		clear_prot = PROT_NS_SHARED;
+		ret = rsi_set_memory_range_protected(start, end);
+	} else {
+		set_prot = PROT_NS_SHARED;
+		ret = rsi_set_memory_range_shared(start, end);
+	}
+
+	if (ret)
+		return ret;
+
+	set_prot |= PTE_VALID;
+
+	return __change_memory_common(addr, PAGE_SIZE * numpages,
+				      __pgprot(set_prot),
+				      __pgprot(clear_prot));
+}
+
+int set_memory_encrypted(unsigned long addr, int numpages)
+{
+	return __set_memory_encrypted(addr, numpages, true);
+}
+EXPORT_SYMBOL_GPL(set_memory_encrypted);
+
+int set_memory_decrypted(unsigned long addr, int numpages)
+{
+	return __set_memory_encrypted(addr, numpages, false);
+}
+EXPORT_SYMBOL_GPL(set_memory_decrypted);
+
 #ifdef CONFIG_DEBUG_PAGEALLOC
 void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
-- 
2.34.1


