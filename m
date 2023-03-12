Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D63116B6472
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbjCLJ5K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbjCLJ4n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:56:43 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB425073E
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:56:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614973; x=1710150973;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EPQc7xEG6SrHZTDMIUYt7VmVn8W2qJ2E1Z42clayvAE=;
  b=MWwFfp+yl7zC5++l8KoThtszqyoWlAumq6KA2oWwtxN63cm0vzXjhj2V
   h8REXjWxwfRIDO7+ZuOQhN0hhDAr/JV5d89KFtorZP/GaiVbUSerNtLu+
   8+1Zf4efXmcJTA4WlHJYBSk2V5qEla+6uIl6P/B2/NBmmqkp8TppDip2l
   7ua/E4OMDdTjo+ftOZaQIhAiaWEqOr2VmEJTNyXtTLWRFKJpxjhwZXpVC
   CN3Wvlxrt5s8MRYDdQd6A1tQUP4emL2cjjyLfp+D4XEg8O/cM1wqzgLZj
   K7zHpcoxYVtBd7fMDXgzRjuyFPlfbORYPnNhNMOq1ojxTmJJGWIlaEwVk
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316623057"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316623057"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="655660840"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="655660840"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:23 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Shaoqin Huang <shaoqin.huang@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-3 17/22] pkvm: x86: Add vmemmap and switch to buddy page allocator
Date:   Mon, 13 Mar 2023 02:01:47 +0800
Message-Id: <20230312180152.1778338-18-jason.cj.chen@intel.com>
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

pKVM's buddy page allocator manages all system memory pages through
vmemmap region, which contains hyp_page array equal to the page number
of system memory. The vmemmap region's memory need allocating from
pKVM's reserved memory, and its virtual address is start from 0,
such mapping need setting up through MMU page table.

After buddy page allocator got setup, the pKVM's MMU page table can
switch to use it, through pkvm_later_mmu_init(). As early allocated
pages' usage is not tracked by buddy page allocator, fix the page
refcount for all present page in current MMU page table.

Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c |  58 +++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/mmu.c           | 100 ++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/mmu.h           |   2 +
 3 files changed, 160 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c b/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c
index 15a3f110b2cf..dc4c0b6213ea 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c
@@ -9,6 +9,7 @@
 #include <asm/kvm_pkvm.h>
 
 #include <pkvm.h>
+#include <gfp.h>
 #include "pkvm_hyp.h"
 #include "early_alloc.h"
 #include "memory.h"
@@ -17,6 +18,7 @@
 #include "debug.h"
 
 void *pkvm_mmu_pgt_base;
+void *pkvm_vmemmap_base;
 
 static int divide_memory_pool(phys_addr_t phys, unsigned long size)
 {
@@ -28,6 +30,11 @@ static int divide_memory_pool(phys_addr_t phys, unsigned long size)
 
 	pkvm_early_alloc_init(virt, size - data_struct_size);
 
+	nr_pages = pkvm_vmemmap_pages(sizeof(struct hyp_page));
+	pkvm_vmemmap_base = pkvm_early_alloc_contig(nr_pages);
+	if (!pkvm_vmemmap_base)
+		return -ENOMEM;
+
 	nr_pages = pkvm_mmu_pgtable_pages();
 	pkvm_mmu_pgt_base = pkvm_early_alloc_contig(nr_pages);
 	if (!pkvm_mmu_pgt_base)
@@ -36,6 +43,51 @@ static int divide_memory_pool(phys_addr_t phys, unsigned long size)
 	return 0;
 }
 
+static int pkvm_back_vmemmap(phys_addr_t back_pa)
+{
+	unsigned long i, start, start_va, size, end, end_va = 0;
+	struct memblock_region *reg;
+	int ret;
+
+	/* vmemmap region map to virtual address 0 */
+	__hyp_vmemmap = 0;
+
+	for (i = 0; i < hyp_memblock_nr; i++) {
+		reg = &hyp_memory[i];
+		start = reg->base;
+		/* Translate a range of memory to vmemmap range */
+		start_va = ALIGN_DOWN((unsigned long)hyp_phys_to_page(start),
+				   PAGE_SIZE);
+		/*
+		 * The beginning of the pkvm_vmemmap region for the current
+		 * memblock may already be backed by the page backing the end
+		 * of the previous region, so avoid mapping it twice.
+		 */
+		start_va = max(start_va, end_va);
+
+		end = reg->base + reg->size;
+		end_va = ALIGN((unsigned long)hyp_phys_to_page(end), PAGE_SIZE);
+		if (start_va >= end_va)
+			continue;
+
+		size = end_va - start_va;
+		/*
+		 * Create mapping for vmemmap virtual address
+		 * [start, start+size) to physical address
+		 * [back, back+size).
+		 */
+		ret = pkvm_mmu_map(start_va, back_pa, size, 0,
+				  (u64)pgprot_val(PAGE_KERNEL));
+		if (ret)
+			return ret;
+
+		memset(__pkvm_va(back_pa), 0, size);
+		back_pa += size;
+	}
+
+	return 0;
+}
+
 static int create_mmu_mapping(const struct pkvm_section sections[],
 				 int section_sz)
 {
@@ -76,9 +128,15 @@ static int create_mmu_mapping(const struct pkvm_section sections[],
 			return ret;
 	}
 
+	ret = pkvm_back_vmemmap(__pkvm_pa(pkvm_vmemmap_base));
+	if (ret)
+		return ret;
+
 	/* Switch the mmu pgtable to enable pkvm_vmemmap */
 	native_write_cr3(pkvm_hyp->mmu->root_pa);
 
+	pkvm_later_mmu_init(pkvm_mmu_pgt_base, nr_pages);
+
 	return 0;
 }
 
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/mmu.c b/arch/x86/kvm/vmx/pkvm/hyp/mmu.c
index b139823298c0..0902f457d682 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/mmu.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/mmu.c
@@ -10,14 +10,43 @@
 #include <mmu/spte.h>
 
 #include <pkvm.h>
+#include <gfp.h>
 #include "pkvm_hyp.h"
 #include "early_alloc.h"
 #include "pgtable.h"
 #include "mmu.h"
 #include "debug.h"
 
+static struct hyp_pool mmu_pool;
 static struct pkvm_pgtable hyp_mmu;
 
+static void *mmu_zalloc_page(void)
+{
+	return hyp_alloc_pages(&mmu_pool, 0);
+}
+
+static void mmu_get_page(void *vaddr)
+{
+	hyp_get_page(&mmu_pool, vaddr);
+}
+
+static void mmu_put_page(void *vaddr)
+{
+	hyp_put_page(&mmu_pool, vaddr);
+}
+
+static void flush_tlb_noop(void) { };
+
+static struct pkvm_mm_ops mmu_mm_ops = {
+	.phys_to_virt = pkvm_phys_to_virt,
+	.virt_to_phys = pkvm_virt_to_phys,
+	.zalloc_page = mmu_zalloc_page,
+	.get_page = mmu_get_page,
+	.put_page = mmu_put_page,
+	.page_count = hyp_page_count,
+	.flush_tlb = flush_tlb_noop,
+};
+
 static bool mmu_entry_present(void *ptep)
 {
 	return pte_present(*(pte_t *)ptep);
@@ -94,6 +123,51 @@ struct pkvm_pgtable_ops mmu_ops = {
 	.pgt_set_entry = mmu_set_entry,
 };
 
+static int finalize_host_mappings_walker(struct pkvm_pgtable *mmu,
+					 unsigned long vaddr,
+					 unsigned long vaddr_end,
+					 int level,
+					 void *ptep,
+					 unsigned long flags,
+					 struct pgt_flush_data *flush_data,
+					 void *const arg)
+{
+	struct pkvm_mm_ops *mm_ops = arg;
+	struct pkvm_pgtable_ops *pgt_ops = mmu->pgt_ops;
+
+	if (!pgt_ops->pgt_entry_present(ptep))
+		return 0;
+
+	/*
+	 * Fix-up the refcount for the page-table pages as the early allocator
+	 * was unable to access the pkvm_vmemmap and so the buddy allocator has
+	 * initialized the refcount to '1'.
+	 */
+	mm_ops->get_page(ptep);
+
+	return 0;
+}
+
+static int fix_pgtable_refcnt(void)
+{
+	unsigned long size;
+	struct pkvm_pgtable_ops *pgt_ops;
+	struct pkvm_pgtable_walker walker = {
+		.cb 	= finalize_host_mappings_walker,
+		.flags 	= PKVM_PGTABLE_WALK_LEAF | PKVM_PGTABLE_WALK_TABLE_POST,
+		.arg 	= hyp_mmu.mm_ops,
+	};
+
+	pgt_ops = hyp_mmu.pgt_ops;
+	/*
+	 * Calculate the max address space, then walk the [0, size) address
+	 * range to fixup refcount of every used page.
+	 */
+	size = pgt_ops->pgt_level_to_size(hyp_mmu.level + 1);
+
+	return pgtable_walk(&hyp_mmu, 0, size, &walker);
+}
+
 int pkvm_mmu_map(unsigned long vaddr_start, unsigned long phys_start,
 		unsigned long size, int pgsz_mask, u64 prot)
 {
@@ -122,3 +196,29 @@ int pkvm_early_mmu_init(struct pkvm_pgtable_cap *cap,
 
 	return pkvm_pgtable_init(&hyp_mmu, &pkvm_early_alloc_mm_ops, &mmu_ops, cap, true);
 }
+
+/* later mmu init after vmemmap ready, switch to buddy allocator */
+int pkvm_later_mmu_init(void *mmu_pool_base, unsigned long mmu_pool_pages)
+{
+	unsigned long reserved_pages, pfn;
+	int ret;
+
+	/* Enable buddy allocator */
+	pfn = __pkvm_pa(mmu_pool_base) >> PAGE_SHIFT;
+	reserved_pages = pkvm_early_alloc_nr_used_pages();
+	ret = hyp_pool_init(&mmu_pool, pfn, mmu_pool_pages, reserved_pages);
+	if (ret) {
+		pkvm_err("fail to init mmu_pool");
+		return ret;
+	}
+
+	/* The ops should alloc memory from mmu_pool now */
+	hyp_mmu.mm_ops = &mmu_mm_ops;
+
+	/*
+	 * as we used early alloc mm_ops to create early pgtable mapping for mmu,
+	 * the refcount was not maintained at that time, we need fix it by re-walk
+	 * the pgtable
+	 */
+	return fix_pgtable_refcnt();
+}
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/mmu.h b/arch/x86/kvm/vmx/pkvm/hyp/mmu.h
index 1cb5eef6aa2e..6b678ae94b31 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/mmu.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/mmu.h
@@ -14,4 +14,6 @@ int pkvm_mmu_unmap(unsigned long vaddr_start, unsigned long phys_start,
 int pkvm_early_mmu_init(struct pkvm_pgtable_cap *cap,
 		void *mmu_pool_base, unsigned long mmu_pool_pages);
 
+int pkvm_later_mmu_init(void *mmu_pool_base, unsigned long mmu_pool_pages);
+
 #endif
-- 
2.25.1

