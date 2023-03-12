Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 543BC6B646E
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbjCLJ4q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbjCLJ4R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:56:17 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7CA51FBA
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614962; x=1710150962;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f5bJLWUr+1WBqq8sO7RnSimjTjC/MxbFA00wrb9yBMo=;
  b=a4mGi3Qfw0T0TFkF3+I7E91Y9orRvf8lFYk3qgZLvGfpmV/0VPdAP+G7
   EzxCgKMBJEJQm77Ja19RAdTMUmjc4hkghUO/lGDL2f6Zrxmk2NJDUGwOv
   fU22OIdaztD8mqMIaGtoRS9oO73Bc7+XRanVTuI4pzQMaY+KN6eyp57cP
   +FQS+zvV2Pw2FDgeCdR+Vc+wFopfLgOCOY5JOwv5NzUWVTRVUAOmKxM72
   lAjrNPfBOGoeWAd+AeP0KEnwRyanksNBQoeEC9KirzM7bjAUil2RqEp6V
   toKfZ2JkPuhB3WrOY9rgQ6TCvXoXwKR1fANMsg3evTi66iciLTUMict8V
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316623050"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316623050"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="655660824"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="655660824"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:17 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Shaoqin Huang <shaoqin.huang@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-3 13/22] pkvm: x86: Introduce MMU pgtable support
Date:   Mon, 13 Mar 2023 02:01:43 +0800
Message-Id: <20230312180152.1778338-14-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180152.1778338-1-jason.cj.chen@intel.com>
References: <20230312180152.1778338-1-jason.cj.chen@intel.com>
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

Follow the native Linux setting, pKVM work under paging mode to
access its memory, MMU page table need setting up.

Add mmu.c for pKVM, which provide APIs to enable MMU pgtable mapping.

As buddy page allocator is based on MMU pgtable mapping, MMU page table
initialization is divided into two stages before and after buddy page
allocator setup:
- before buddy page allocator setup, MMU page table mm_ops is based on
  early page allocator, the initialization is done by
  pkvm_early_mmu_init(). After this initialization, MMU page table can
  be created, but its allocated pages usage is not tracked.
- after buddy page allocator setup, the vmemmap MMU mapping is done
  through above early MMU, MMU page table mm_ops then can be switched to
  use buddy page allocator, and meantime the early allocated pages'
  refcount need fixing to ensure the track from buddy allocator.
This patch only implements above first stage.

Some alias of kernel-proper symbols also defined for pKVM usage, like
physical_mask for page level mask, sme_me_mask & __default_kernel_pte_mask
for page prot setting.

Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/include/asm/pkvm_image_vars.h |  18 ++++
 arch/x86/kernel/vmlinux.lds.S          |   4 +
 arch/x86/kvm/vmx/pkvm/hyp/Makefile     |   2 +-
 arch/x86/kvm/vmx/pkvm/hyp/mmu.c        | 122 +++++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/mmu.h        |  17 ++++
 5 files changed, 162 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/pkvm_image_vars.h b/arch/x86/include/asm/pkvm_image_vars.h
new file mode 100644
index 000000000000..a7823dc9b981
--- /dev/null
+++ b/arch/x86/include/asm/pkvm_image_vars.h
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+#ifndef __ASM_x86_PKVM_IMAGE_VARS_H
+#define __ASM_x86_PKVM_IMAGE_VARS_H
+
+#ifdef CONFIG_DYNAMIC_PHYSICAL_MASK
+PKVM_ALIAS(physical_mask);
+#endif
+
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+PKVM_ALIAS(sme_me_mask);
+#endif
+
+PKVM_ALIAS(__default_kernel_pte_mask);
+
+#endif
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 0199d81147db..9f931d39c643 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -541,4 +541,8 @@ INIT_PER_CPU(irq_stack_backing_store);
            "fixed_percpu_data is not at start of per-cpu area");
 #endif
 
+#ifdef CONFIG_PKVM_INTEL
+#include <asm/pkvm_image_vars.h>
+#endif
+
 #endif /* CONFIG_X86_64 */
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/Makefile b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
index 39a51230ad3a..cc869624b201 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/Makefile
+++ b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
@@ -12,7 +12,7 @@ ccflags-y += -D__PKVM_HYP__
 lib-dir		:= lib
 virt-dir	:= ../../../../../../$(KVM_PKVM)
 
-pkvm-hyp-y	:= vmx_asm.o vmexit.o memory.o early_alloc.o pgtable.o
+pkvm-hyp-y	:= vmx_asm.o vmexit.o memory.o early_alloc.o pgtable.o mmu.o
 
 pkvm-hyp-y	+= $(lib-dir)/memset_64.o
 pkvm-hyp-$(CONFIG_RETPOLINE)	+= $(lib-dir)/retpoline.o
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/mmu.c b/arch/x86/kvm/vmx/pkvm/hyp/mmu.c
new file mode 100644
index 000000000000..8b07355c5b96
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/mmu.c
@@ -0,0 +1,122 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+
+#include <linux/memblock.h>
+#include <asm/kvm_pkvm.h>
+#include <asm/pkvm_spinlock.h>
+#include <mmu.h>
+#include <mmu/spte.h>
+
+#include <pkvm.h>
+#include "early_alloc.h"
+#include "pgtable.h"
+#include "mmu.h"
+#include "debug.h"
+
+static struct pkvm_pgtable hyp_mmu;
+
+static bool mmu_entry_present(void *ptep)
+{
+	return pte_present(*(pte_t *)ptep);
+}
+
+static bool mmu_entry_huge(void *ptep)
+{
+	return pte_huge(*(pte_t *)ptep);
+}
+
+static void mmu_entry_mkhuge(void *ptep)
+{
+	pte_t *ptep_ptr = (pte_t *)ptep;
+
+	*ptep_ptr = pte_mkhuge(*ptep_ptr);
+}
+
+static unsigned long mmu_entry_to_phys(void *ptep)
+{
+	return native_pte_val(*(pte_t *)ptep) & PTE_PFN_MASK;
+}
+
+static u64 mmu_entry_to_prot(void *ptep)
+{
+	return (u64)pte_flags(pte_clear_flags(*(pte_t *)ptep, _PAGE_PSE));
+}
+
+static int mmu_entry_to_index(unsigned long vaddr, int level)
+{
+	return SPTE_INDEX(vaddr, level);
+}
+
+static bool mmu_entry_is_leaf(void *ptep, int level)
+{
+	if (level == PG_LEVEL_4K ||
+		!mmu_entry_present(ptep) ||
+		mmu_entry_huge(ptep))
+		return true;
+
+	return false;
+}
+
+static int mmu_level_entry_size(int level)
+{
+	return PAGE_SIZE / PTRS_PER_PTE;
+}
+
+static int mmu_level_to_entries(int level)
+{
+	return PTRS_PER_PTE;
+}
+
+static unsigned long mmu_level_to_size(int level)
+{
+	return page_level_size(level);
+}
+
+static void mmu_set_entry(void *ptep, u64 pte)
+{
+	native_set_pte((pte_t *)ptep, native_make_pte(pte));
+}
+
+struct pkvm_pgtable_ops mmu_ops = {
+	.pgt_entry_present = mmu_entry_present,
+	.pgt_entry_huge = mmu_entry_huge,
+	.pgt_entry_mkhuge = mmu_entry_mkhuge,
+	.pgt_entry_to_phys = mmu_entry_to_phys,
+	.pgt_entry_to_prot = mmu_entry_to_prot,
+	.pgt_entry_to_index = mmu_entry_to_index,
+	.pgt_entry_is_leaf = mmu_entry_is_leaf,
+	.pgt_level_entry_size = mmu_level_entry_size,
+	.pgt_level_to_entries = mmu_level_to_entries,
+	.pgt_level_to_size = mmu_level_to_size,
+	.pgt_set_entry = mmu_set_entry,
+};
+
+int pkvm_mmu_map(unsigned long vaddr_start, unsigned long phys_start,
+		unsigned long size, int pgsz_mask, u64 prot)
+{
+	int ret;
+
+	ret = pkvm_pgtable_map(&hyp_mmu, vaddr_start, phys_start, size, pgsz_mask, prot);
+
+	return ret;
+}
+
+int pkvm_mmu_unmap(unsigned long vaddr_start, unsigned long phys_start, unsigned long size)
+{
+	int ret;
+
+	ret = pkvm_pgtable_unmap(&hyp_mmu, vaddr_start, phys_start, size);
+
+	return ret;
+}
+
+/* early mmu init before vmemmap ready, use early allocator first */
+int pkvm_early_mmu_init(struct pkvm_pgtable_cap *cap,
+		void *mmu_pool_base, unsigned long mmu_pool_pages)
+{
+	pkvm_early_alloc_init(mmu_pool_base, mmu_pool_pages << PAGE_SHIFT);
+
+	return pkvm_pgtable_init(&hyp_mmu, &pkvm_early_alloc_mm_ops, &mmu_ops, cap, true);
+}
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/mmu.h b/arch/x86/kvm/vmx/pkvm/hyp/mmu.h
new file mode 100644
index 000000000000..1cb5eef6aa2e
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/mmu.h
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+#ifndef _PKVM_MMU_H_
+#define _PKVM_MMU_H_
+
+int pkvm_mmu_map(unsigned long vaddr_start, unsigned long phys_start,
+		unsigned long size, int pgsz_mask, u64 prot);
+
+int pkvm_mmu_unmap(unsigned long vaddr_start, unsigned long phys_start,
+		unsigned long size);
+
+int pkvm_early_mmu_init(struct pkvm_pgtable_cap *cap,
+		void *mmu_pool_base, unsigned long mmu_pool_pages);
+
+#endif
-- 
2.25.1

