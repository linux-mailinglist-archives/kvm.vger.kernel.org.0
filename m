Return-Path: <kvm+bounces-24497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2991C956BAB
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 15:20:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E8CA1C2233C
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 13:20:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A7B416C86C;
	Mon, 19 Aug 2024 13:19:48 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6660716C68B;
	Mon, 19 Aug 2024 13:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724073587; cv=none; b=A0MVruIXOZlsvdsbIm480d38Pzla+T/iBkSe3+h+eQKeixpH0VvXoosaELC6uUBS7LGFxI2cCuE8WciMa55cM+T25eUnMCOgOTDrzaB7PfOmEDYo+Zkx7UBoNrtJfw/gyHOmv43mguKNt+Vsbo18KH6TcihVaE3IUKBJTdq0pNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724073587; c=relaxed/simple;
	bh=JsStGkCgNb6gy2BWmOepJzcY7eBBGSwzX/ny0Aat0xU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b0E9D1pgTHhIQDSM/x/3X13HHpdmnbmtJzBMiEWrFdZaBg1SQyhD+Sy2fAGgxCOFNBcwjxEB3YKKdAos9kfPvuZySZNF7VVDRQbNCkFNMk15QTGRXv3ZW7MinCetFiM2l398d+FMNmnU85ynDN4WPsqRzpTxFCsQhOkYPEwmQ/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D68C11063;
	Mon, 19 Aug 2024 06:20:11 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.85.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A21603F73B;
	Mon, 19 Aug 2024 06:19:41 -0700 (PDT)
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
	Alper Gun <alpergun@google.com>
Subject: [PATCH v5 01/19] arm64: mm: Add top-level dispatcher for internal mem_encrypt API
Date: Mon, 19 Aug 2024 14:19:06 +0100
Message-Id: <20240819131924.372366-2-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240819131924.372366-1-steven.price@arm.com>
References: <20240819131924.372366-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Will Deacon <will@kernel.org>

Implementing the internal mem_encrypt API for arm64 depends entirely on
the Confidential Computing environment in which the kernel is running.

Introduce a simple dispatcher so that backend hooks can be registered
depending upon the environment in which the kernel finds itself.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Steven Price <steven.price@arm.com>
---
Patch 'borrowed' from Will's series for pKVM:
https://lore.kernel.org/r/20240730151113.1497-4-will%40kernel.org
---
 arch/arm64/Kconfig                   |  1 +
 arch/arm64/include/asm/mem_encrypt.h | 15 +++++++++
 arch/arm64/include/asm/set_memory.h  |  1 +
 arch/arm64/mm/Makefile               |  2 +-
 arch/arm64/mm/mem_encrypt.c          | 50 ++++++++++++++++++++++++++++
 5 files changed, 68 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/include/asm/mem_encrypt.h
 create mode 100644 arch/arm64/mm/mem_encrypt.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b3fc891f1544..68d77a2f4d1a 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -34,6 +34,7 @@ config ARM64
 	select ARCH_HAS_KERNEL_FPU_SUPPORT if KERNEL_MODE_NEON
 	select ARCH_HAS_KEEPINITRD
 	select ARCH_HAS_MEMBARRIER_SYNC_CORE
+	select ARCH_HAS_MEM_ENCRYPT
 	select ARCH_HAS_NMI_SAFE_THIS_CPU_OPS
 	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
 	select ARCH_HAS_PTE_DEVMAP
diff --git a/arch/arm64/include/asm/mem_encrypt.h b/arch/arm64/include/asm/mem_encrypt.h
new file mode 100644
index 000000000000..b0c9a86b13a4
--- /dev/null
+++ b/arch/arm64/include/asm/mem_encrypt.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __ASM_MEM_ENCRYPT_H
+#define __ASM_MEM_ENCRYPT_H
+
+struct arm64_mem_crypt_ops {
+	int (*encrypt)(unsigned long addr, int numpages);
+	int (*decrypt)(unsigned long addr, int numpages);
+};
+
+int arm64_mem_crypt_ops_register(const struct arm64_mem_crypt_ops *ops);
+
+int set_memory_encrypted(unsigned long addr, int numpages);
+int set_memory_decrypted(unsigned long addr, int numpages);
+
+#endif	/* __ASM_MEM_ENCRYPT_H */
diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/set_memory.h
index 0f740b781187..917761feeffd 100644
--- a/arch/arm64/include/asm/set_memory.h
+++ b/arch/arm64/include/asm/set_memory.h
@@ -3,6 +3,7 @@
 #ifndef _ASM_ARM64_SET_MEMORY_H
 #define _ASM_ARM64_SET_MEMORY_H
 
+#include <asm/mem_encrypt.h>
 #include <asm-generic/set_memory.h>
 
 bool can_set_direct_map(void);
diff --git a/arch/arm64/mm/Makefile b/arch/arm64/mm/Makefile
index 60454256945b..2fc8c6dd0407 100644
--- a/arch/arm64/mm/Makefile
+++ b/arch/arm64/mm/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-y				:= dma-mapping.o extable.o fault.o init.o \
 				   cache.o copypage.o flush.o \
-				   ioremap.o mmap.o pgd.o mmu.o \
+				   ioremap.o mmap.o pgd.o mem_encrypt.o mmu.o \
 				   context.o proc.o pageattr.o fixmap.o
 obj-$(CONFIG_ARM64_CONTPTE)	+= contpte.o
 obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o
diff --git a/arch/arm64/mm/mem_encrypt.c b/arch/arm64/mm/mem_encrypt.c
new file mode 100644
index 000000000000..ee3c0ab04384
--- /dev/null
+++ b/arch/arm64/mm/mem_encrypt.c
@@ -0,0 +1,50 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Implementation of the memory encryption/decryption API.
+ *
+ * Since the low-level details of the operation depend on the
+ * Confidential Computing environment (e.g. pKVM, CCA, ...), this just
+ * acts as a top-level dispatcher to whatever hooks may have been
+ * registered.
+ *
+ * Author: Will Deacon <will@kernel.org>
+ * Copyright (C) 2024 Google LLC
+ *
+ * "Hello, boils and ghouls!"
+ */
+
+#include <linux/bug.h>
+#include <linux/compiler.h>
+#include <linux/err.h>
+#include <linux/mm.h>
+
+#include <asm/mem_encrypt.h>
+
+static const struct arm64_mem_crypt_ops *crypt_ops;
+
+int arm64_mem_crypt_ops_register(const struct arm64_mem_crypt_ops *ops)
+{
+	if (WARN_ON(crypt_ops))
+		return -EBUSY;
+
+	crypt_ops = ops;
+	return 0;
+}
+
+int set_memory_encrypted(unsigned long addr, int numpages)
+{
+	if (likely(!crypt_ops) || WARN_ON(!PAGE_ALIGNED(addr)))
+		return 0;
+
+	return crypt_ops->encrypt(addr, numpages);
+}
+EXPORT_SYMBOL_GPL(set_memory_encrypted);
+
+int set_memory_decrypted(unsigned long addr, int numpages)
+{
+	if (likely(!crypt_ops) || WARN_ON(!PAGE_ALIGNED(addr)))
+		return 0;
+
+	return crypt_ops->decrypt(addr, numpages);
+}
+EXPORT_SYMBOL_GPL(set_memory_decrypted);
-- 
2.34.1


