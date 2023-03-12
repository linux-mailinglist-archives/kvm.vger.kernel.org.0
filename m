Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 252126B6473
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbjCLJ5Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjCLJ4u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:56:50 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44EC05370A
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:56:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614979; x=1710150979;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sPyyqVEcrUlAgQrngh8xr8aDfZR/mRlEFehSuIczKRw=;
  b=Wj76IR6KWCi7cSFOllLzN2mtoE+cuYdEyG2Wm/5e1f+HkpnbjmwA6Uto
   6ahHrlrKtsc3lLbsMG2nh4LCCDswNUw9QCerlYvgRGG7uNEjDWLPog5f3
   nUoTBv6TT1CyTiX/hsrNLxB0F7iY5fQLGoH/L4/D9Pt1aDB1JlKGGRdJv
   QKyXveTMZQ2hJVLr11QVAEVTZcdBqFnkQUgh7jR1IBGwtJZdBU0+sT1Fg
   0wDkVUU1ze7617egSb9Xn7PoH9z5B/uLgJXW4WZV0OgrjEaC2IVAmQ1yw
   CSbfhxYO+l8/rpQpeJ0bnVPi/a9aUCDCxLRN+ds+WzLe61N7slbwavtH6
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316623059"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316623059"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="655660844"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="655660844"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:25 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Shaoqin Huang <shaoqin.huang@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-3 18/22] pkvm: x86: Introduce host EPT pgtable support
Date:   Mon, 13 Mar 2023 02:01:48 +0800
Message-Id: <20230312180152.1778338-19-jason.cj.chen@intel.com>
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

pKVM need to setup host EPT page table to isolate its memory from
host VM.

Add ept.c for pKVM, which provide APIs to enable host VM EPT pgtable
mapping. As buddy page allocator is ready, use it for this host EPT
pgtable.

The tlb flush ops is still a TODO for host EPT, which need to shootdown
all CPUs to make INVEPT.

Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/Makefile |   2 +-
 arch/x86/kvm/vmx/pkvm/hyp/ept.c    | 151 +++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/ept.h    |  15 +++
 3 files changed, 167 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/Makefile b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
index 383ddf75f50e..9a1cb483a55e 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/Makefile
+++ b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
@@ -13,7 +13,7 @@ lib-dir		:= lib
 virt-dir	:= ../../../../../../$(KVM_PKVM)
 
 pkvm-hyp-y	:= vmx_asm.o vmexit.o memory.o early_alloc.o pgtable.o mmu.o pkvm.o \
-		   init_finalise.o
+		   init_finalise.o ept.o
 
 pkvm-hyp-y	+= $(lib-dir)/memset_64.o
 pkvm-hyp-$(CONFIG_RETPOLINE)	+= $(lib-dir)/retpoline.o
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/ept.c b/arch/x86/kvm/vmx/pkvm/hyp/ept.c
new file mode 100644
index 000000000000..fd366cb1570f
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/ept.c
@@ -0,0 +1,151 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+
+#include <linux/types.h>
+#include <linux/memblock.h>
+#include <asm/kvm_pkvm.h>
+#include <mmu.h>
+#include <mmu/spte.h>
+
+#include <pkvm.h>
+#include <gfp.h>
+
+#include "early_alloc.h"
+#include "pgtable.h"
+#include "ept.h"
+
+static struct hyp_pool host_ept_pool;
+static struct pkvm_pgtable host_ept;
+
+static void flush_tlb_noop(void) { };
+static void *host_ept_zalloc_page(void)
+{
+	return hyp_alloc_pages(&host_ept_pool, 0);
+}
+
+static void host_ept_get_page(void *vaddr)
+{
+	hyp_get_page(&host_ept_pool, vaddr);
+}
+
+static void host_ept_put_page(void *vaddr)
+{
+	hyp_put_page(&host_ept_pool, vaddr);
+}
+
+/*TODO: add tlb flush support for host ept */
+struct pkvm_mm_ops host_ept_mm_ops = {
+	.phys_to_virt = pkvm_phys_to_virt,
+	.virt_to_phys = pkvm_virt_to_phys,
+	.zalloc_page = host_ept_zalloc_page,
+	.get_page = host_ept_get_page,
+	.put_page = host_ept_put_page,
+	.page_count = hyp_page_count,
+	.flush_tlb = flush_tlb_noop,
+};
+
+static bool ept_entry_present(void *ptep)
+{
+	u64 val = *(u64 *)ptep;
+
+	return !!(val & VMX_EPT_RWX_MASK);
+}
+
+static bool ept_entry_huge(void *ptep)
+{
+	return is_large_pte(*(u64 *)ptep);
+}
+
+static void ept_entry_mkhuge(void *ptep)
+{
+	*(u64 *)ptep |= PT_PAGE_SIZE_MASK;
+}
+
+static unsigned long ept_entry_to_phys(void *ptep)
+{
+	return *(u64 *)ptep & SPTE_BASE_ADDR_MASK;
+}
+
+static u64 ept_entry_to_prot(void *ptep)
+{
+	u64 prot = *(u64 *)ptep & ~(SPTE_BASE_ADDR_MASK);
+
+	return prot & ~PT_PAGE_SIZE_MASK;
+}
+
+static int ept_entry_to_index(unsigned long vaddr, int level)
+{
+	return SPTE_INDEX(vaddr, level);
+}
+
+static bool ept_entry_is_leaf(void *ptep, int level)
+{
+	if (level == PG_LEVEL_4K ||
+		!ept_entry_present(ptep) ||
+		ept_entry_huge(ptep))
+		return true;
+
+	return false;
+
+}
+
+static int ept_level_entry_size(int level)
+{
+	return PAGE_SIZE / SPTE_ENT_PER_PAGE;
+}
+
+static int ept_level_to_entries(int level)
+{
+	return SPTE_ENT_PER_PAGE;
+}
+
+static unsigned long ept_level_to_size(int level)
+{
+	return KVM_HPAGE_SIZE(level);
+}
+
+static void ept_set_entry(void *sptep, u64 spte)
+{
+	WRITE_ONCE(*(u64 *)sptep, spte);
+}
+
+struct pkvm_pgtable_ops ept_ops = {
+	.pgt_entry_present = ept_entry_present,
+	.pgt_entry_huge = ept_entry_huge,
+	.pgt_entry_mkhuge = ept_entry_mkhuge,
+	.pgt_entry_to_phys = ept_entry_to_phys,
+	.pgt_entry_to_prot = ept_entry_to_prot,
+	.pgt_entry_to_index = ept_entry_to_index,
+	.pgt_entry_is_leaf = ept_entry_is_leaf,
+	.pgt_level_entry_size = ept_level_entry_size,
+	.pgt_level_to_entries = ept_level_to_entries,
+	.pgt_level_to_size = ept_level_to_size,
+	.pgt_set_entry = ept_set_entry,
+};
+
+int pkvm_host_ept_map(unsigned long vaddr_start, unsigned long phys_start,
+		unsigned long size, int pgsz_mask, u64 prot)
+{
+	return pkvm_pgtable_map(&host_ept, vaddr_start, phys_start, size, pgsz_mask, prot);
+}
+
+int pkvm_host_ept_unmap(unsigned long vaddr_start, unsigned long phys_start,
+		unsigned long size)
+{
+	return pkvm_pgtable_unmap(&host_ept, vaddr_start, phys_start, size);
+}
+
+int pkvm_host_ept_init(struct pkvm_pgtable_cap *cap,
+		void *ept_pool_base, unsigned long ept_pool_pages)
+{
+	unsigned long pfn = __pkvm_pa(ept_pool_base) >> PAGE_SHIFT;
+	int ret;
+
+	ret = hyp_pool_init(&host_ept_pool, pfn, ept_pool_pages, 0);
+	if (ret)
+		return ret;
+
+	return pkvm_pgtable_init(&host_ept, &host_ept_mm_ops, &ept_ops, cap, true);
+}
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/ept.h b/arch/x86/kvm/vmx/pkvm/hyp/ept.h
new file mode 100644
index 000000000000..26220325feec
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/ept.h
@@ -0,0 +1,15 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+#ifndef __PKVM_EPT_H
+#define __PKVM_EPT_H
+
+int pkvm_host_ept_map(unsigned long vaddr_start, unsigned long phys_start,
+		unsigned long size, int pgsz_mask, u64 prot);
+int pkvm_host_ept_unmap(unsigned long vaddr_start, unsigned long phys_start,
+		unsigned long size);
+int pkvm_host_ept_init(struct pkvm_pgtable_cap *cap, void *ept_pool_base,
+		unsigned long ept_pool_pages);
+
+#endif
-- 
2.25.1

