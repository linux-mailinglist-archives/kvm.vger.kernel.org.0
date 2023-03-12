Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 221646B644E
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbjCLJyJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjCLJyE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:54:04 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2236038649
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614843; x=1710150843;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EjRdmzInslfv3YRHLzx1Xi9t+gFmXcNA875Xi8bw/9U=;
  b=mRcwJWdtYDPMrzqivUQRV5cicaTmXTxnyADnwb/Cr5CSHsD6U1tL58fg
   VXwAkSI7h7schbKIxO+SF+GVWoMk6B7fsHkCsdZx+6GJGbsMmojxo2g9e
   AoCX7efTC7r6orDvfol81SF/Gkts1EJyY5t+1Yzagja+rp5UUmO0Q3nej
   aWHQoSYgIckNiXmdWwIJ10Tr1ibuuBDLvepQboLSB3Z6jYcW5SbTkLL27
   aHIU5g64ustsdfOPDdLUR1v/EzdOxDnfjMAKXa7ITQFm6k2Jc++/InKXZ
   dP8fMD4BmbgbVcBUa8kZqstq1+UMruYzz8pULo9j2L/QDiDEpQPWFWKh/
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316622831"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316622831"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:54:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="852408917"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="852408917"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:53:59 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-1 5/5] pkvm: arm64: Move general part of memory reservation to virt/kvm/pkvm
Date:   Mon, 13 Mar 2023 02:00:48 +0800
Message-Id: <20230312180048.1778187-6-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180048.1778187-1-jason.cj.chen@intel.com>
References: <20230312180048.1778187-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Most part of the memory reservation for pKVM is arch agnostic, move
them to virt/kvm/pkvm/pkvm.c. Arch specific pre_reserve_check and
total_reserve_pages caculation are separated to arch-implemented APIs
and remain in arch dir.

Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/arm64/include/asm/kvm_pkvm.h |  3 ++
 arch/arm64/kvm/Makefile           |  2 +
 arch/arm64/kvm/pkvm.c             | 76 +++-------------------------
 virt/kvm/pkvm/pkvm.c              | 84 +++++++++++++++++++++++++++++++
 4 files changed, 96 insertions(+), 69 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index b508c7b63ff4..42d32d99595e 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -26,6 +26,9 @@ void pkvm_destroy_hyp_vm(struct kvm *kvm);
 extern struct memblock_region kvm_nvhe_sym(hyp_memory)[];
 extern unsigned int kvm_nvhe_sym(hyp_memblock_nr);
 
+int hyp_pre_reserve_check(void);
+u64 hyp_total_reserve_pages(void);
+
 static inline unsigned long
 hyp_vmemmap_memblock_size(struct memblock_region *reg, size_t vmemmap_entry_size)
 {
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 119b074b001a..9691fd90de6b 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -22,6 +22,8 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o
 
+kvm-y += ../../../virt/kvm/pkvm/pkvm.o
+
 kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
 
 always-y := hyp_constants.h hyp-constants.s
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index e787bd704043..97b9647f3370 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -5,95 +5,33 @@
  */
 
 #include <linux/kvm_host.h>
-#include <linux/memblock.h>
 #include <linux/mutex.h>
-#include <linux/sort.h>
 
 #include <asm/kvm_pkvm.h>
 
 #include "hyp_constants.h"
 
-static struct memblock_region *hyp_memory = pkvm_sym(hyp_memory);
-static unsigned int *hyp_memblock_nr_ptr = &pkvm_sym(hyp_memblock_nr);
-
-phys_addr_t hyp_mem_base;
-phys_addr_t hyp_mem_size;
-
-static int cmp_hyp_memblock(const void *p1, const void *p2)
+int hyp_pre_reserve_check(void)
 {
-	const struct memblock_region *r1 = p1;
-	const struct memblock_region *r2 = p2;
-
-	return r1->base < r2->base ? -1 : (r1->base > r2->base);
-}
-
-static void __init sort_memblock_regions(void)
-{
-	sort(hyp_memory,
-	     *hyp_memblock_nr_ptr,
-	     sizeof(struct memblock_region),
-	     cmp_hyp_memblock,
-	     NULL);
-}
-
-static int __init register_memblock_regions(void)
-{
-	struct memblock_region *reg;
-
-	for_each_mem_region(reg) {
-		if (*hyp_memblock_nr_ptr >= HYP_MEMBLOCK_REGIONS)
-			return -ENOMEM;
+	if (!is_hyp_mode_available() || is_kernel_in_hyp_mode())
+		return -EINVAL;
 
-		hyp_memory[*hyp_memblock_nr_ptr] = *reg;
-		(*hyp_memblock_nr_ptr)++;
-	}
-	sort_memblock_regions();
+	if (kvm_get_mode() != KVM_MODE_PROTECTED)
+		return -EINVAL;
 
 	return 0;
 }
 
-void __init kvm_hyp_reserve(void)
+u64 hyp_total_reserve_pages(void)
 {
 	u64 hyp_mem_pages = 0;
-	int ret;
-
-	if (!is_hyp_mode_available() || is_kernel_in_hyp_mode())
-		return;
-
-	if (kvm_get_mode() != KVM_MODE_PROTECTED)
-		return;
-
-	ret = register_memblock_regions();
-	if (ret) {
-		*hyp_memblock_nr_ptr = 0;
-		kvm_err("Failed to register hyp memblocks: %d\n", ret);
-		return;
-	}
 
 	hyp_mem_pages += hyp_s1_pgtable_pages();
 	hyp_mem_pages += host_s2_pgtable_pages();
 	hyp_mem_pages += hyp_vm_table_pages();
 	hyp_mem_pages += hyp_vmemmap_pages(STRUCT_HYP_PAGE_SIZE);
 
-	/*
-	 * Try to allocate a PMD-aligned region to reduce TLB pressure once
-	 * this is unmapped from the host stage-2, and fallback to PAGE_SIZE.
-	 */
-	hyp_mem_size = hyp_mem_pages << PAGE_SHIFT;
-	hyp_mem_base = memblock_phys_alloc(ALIGN(hyp_mem_size, PMD_SIZE),
-					   PMD_SIZE);
-	if (!hyp_mem_base)
-		hyp_mem_base = memblock_phys_alloc(hyp_mem_size, PAGE_SIZE);
-	else
-		hyp_mem_size = ALIGN(hyp_mem_size, PMD_SIZE);
-
-	if (!hyp_mem_base) {
-		kvm_err("Failed to reserve hyp memory\n");
-		return;
-	}
-
-	kvm_info("Reserved %lld MiB at 0x%llx\n", hyp_mem_size >> 20,
-		 hyp_mem_base);
+	return hyp_mem_pages;
 }
 
 /*
diff --git a/virt/kvm/pkvm/pkvm.c b/virt/kvm/pkvm/pkvm.c
new file mode 100644
index 000000000000..6f06a41f0e77
--- /dev/null
+++ b/virt/kvm/pkvm/pkvm.c
@@ -0,0 +1,84 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2020 - Google LLC
+ * Author: Quentin Perret <qperret@google.com>
+ */
+
+#include <linux/memblock.h>
+#include <linux/sort.h>
+
+#include <asm/kvm_pkvm.h>
+
+static struct memblock_region *hyp_memory = pkvm_sym(hyp_memory);
+static unsigned int *hyp_memblock_nr_ptr = &pkvm_sym(hyp_memblock_nr);
+
+phys_addr_t hyp_mem_base;
+phys_addr_t hyp_mem_size;
+
+static int cmp_hyp_memblock(const void *p1, const void *p2)
+{
+	const struct memblock_region *r1 = p1;
+	const struct memblock_region *r2 = p2;
+
+	return r1->base < r2->base ? -1 : (r1->base > r2->base);
+}
+
+static void __init sort_memblock_regions(void)
+{
+	sort(hyp_memory,
+	     *hyp_memblock_nr_ptr,
+	     sizeof(struct memblock_region),
+	     cmp_hyp_memblock,
+	     NULL);
+}
+
+static int __init register_memblock_regions(void)
+{
+	struct memblock_region *reg;
+
+	for_each_mem_region(reg) {
+		if (*hyp_memblock_nr_ptr >= HYP_MEMBLOCK_REGIONS)
+			return -ENOMEM;
+
+		hyp_memory[*hyp_memblock_nr_ptr] = *reg;
+		(*hyp_memblock_nr_ptr)++;
+	}
+	sort_memblock_regions();
+
+	return 0;
+}
+
+void __init kvm_hyp_reserve(void)
+{
+	int ret;
+
+	if (hyp_pre_reserve_check() < 0)
+		return;
+
+	ret = register_memblock_regions();
+	if (ret) {
+		*hyp_memblock_nr_ptr = 0;
+		kvm_err("Failed to register hyp memblocks: %d\n", ret);
+		return;
+	}
+
+	/*
+	 * Try to allocate a PMD-aligned region to reduce TLB pressure once
+	 * this is unmapped from the host stage-2, and fallback to PAGE_SIZE.
+	 */
+	hyp_mem_size = hyp_total_reserve_pages() << PAGE_SHIFT;
+	hyp_mem_base = memblock_phys_alloc(ALIGN(hyp_mem_size, PMD_SIZE),
+					   PMD_SIZE);
+	if (!hyp_mem_base)
+		hyp_mem_base = memblock_phys_alloc(hyp_mem_size, PAGE_SIZE);
+	else
+		hyp_mem_size = ALIGN(hyp_mem_size, PMD_SIZE);
+
+	if (!hyp_mem_base) {
+		kvm_err("Failed to reserve hyp memory\n");
+		return;
+	}
+
+	kvm_info("Reserved %lld MiB at 0x%llx\n", hyp_mem_size >> 20,
+		 hyp_mem_base);
+}
-- 
2.25.1

