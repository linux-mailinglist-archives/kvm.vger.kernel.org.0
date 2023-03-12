Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13C526B6467
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjCLJ4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbjCLJzr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:55:47 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA74A37F16
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:55:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614928; x=1710150928;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FBmYfS1lqjTyRcXDzGJr6kUxk5HjfmaARHwQNSS/Z3I=;
  b=YDnsbruBesfmdgp9lBPdD3bLh2kT9cF6L6/E92MmhVI1XiQ1ImqC7yzL
   tulYA59ZWksDPkSc26YRQdvoT8VcE7WWWpTzXZR2YEZCiNgSpfxBgt/lt
   9lI+WGZv6U2DNL2fpveJXXsq2u+izrt70p/eiWNLpW0OSy3LXNpyVXRPZ
   NItac8jFfZJGOaqbCJP8kn9oIwR3oc/arV4/nKSz0iO8NrgMHGytSVfJB
   K48sT0mF3TXOr9NCfC+nsxe0u3skGy7ifUmCRV+x/6jv5fXXVupkfjUUn
   D6gwEU8x5d1kyc9stJS97QJ6mop/p4GGVpBA5SrC4anr8Q3CcooIggfXA
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316623029"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316623029"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="655660800"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="655660800"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:07 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Shaoqin Huang <shaoqin.huang@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-3 06/22] pkvm: x86: Calculate total reserve page numbers
Date:   Mon, 13 Mar 2023 02:01:36 +0800
Message-Id: <20230312180152.1778338-7-jason.cj.chen@intel.com>
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

pKVM need to reserve its own memory for its data or runtime allocation,
such as pkvm data structure, page allocator data structure (vmemmap),
VMX pages, and MMU/EPT page table pages.

Implement hyp_total_reserve_pages to calculate total reserve page
numbers needed by pKVM.

Virtual memory map (vmemmap) for page allocator is calculated based on
system memory size.

3 extra pages for VMX - vmcs area to support VMXON, vmcs page to support
run host vcpu, and msr_bitmap to support msr emulation.

Consider the worst case for page table allocation pages. For host EPT,
allow extra 1 GiB for MMIO mappings.

Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/include/asm/kvm_pkvm.h      | 94 ++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/memory.c   |  4 ++
 arch/x86/kvm/vmx/pkvm/include/pkvm.h |  2 +
 arch/x86/kvm/vmx/pkvm/pkvm_host.c    | 14 +++++
 4 files changed, 114 insertions(+)

diff --git a/arch/x86/include/asm/kvm_pkvm.h b/arch/x86/include/asm/kvm_pkvm.h
index 480051f28ebc..30f7f805bcb8 100644
--- a/arch/x86/include/asm/kvm_pkvm.h
+++ b/arch/x86/include/asm/kvm_pkvm.h
@@ -8,6 +8,15 @@
 
 #ifdef CONFIG_PKVM_INTEL
 
+#include <linux/memblock.h>
+#include <asm/pkvm_image.h>
+
+#define HYP_MEMBLOCK_REGIONS   128
+#define PKVM_PGTABLE_MAX_LEVELS		5U
+
+extern struct memblock_region pkvm_sym(hyp_memory)[];
+extern unsigned int pkvm_sym(hyp_memblock_nr);
+
 void *pkvm_phys_to_virt(unsigned long phys);
 unsigned long pkvm_virt_to_phys(void *virt);
 
@@ -18,6 +27,91 @@ unsigned long pkvm_virt_to_phys(void *virt);
 #define __hyp_pa __pkvm_pa
 #define __hyp_va __pkvm_va
 
+static inline unsigned long __pkvm_pgtable_max_pages(unsigned long nr_pages)
+{
+	unsigned long total = 0, i;
+
+	/* Provision the worst case */
+	for (i = 0; i < PKVM_PGTABLE_MAX_LEVELS; i++) {
+		nr_pages = DIV_ROUND_UP(nr_pages, PTRS_PER_PTE);
+		total += nr_pages;
+	}
+
+	return total;
+}
+
+static inline unsigned long __pkvm_pgtable_total_pages(void)
+{
+	unsigned long total = 0, i;
+
+	for (i = 0; i < pkvm_sym(hyp_memblock_nr); i++) {
+		struct memblock_region *reg = &pkvm_sym(hyp_memory)[i];
+
+		total += __pkvm_pgtable_max_pages(reg->size >> PAGE_SHIFT);
+	}
+
+	return total;
+}
+
+static inline unsigned long host_ept_pgtable_pages(void)
+{
+	unsigned long res;
+
+	/*
+	 * Include an extra 16 pages to safely upper-bound the worst case of
+	 * concatenated pgds.
+	 */
+	res = __pkvm_pgtable_total_pages() + 16;
+
+	/* Allow 1 GiB for MMIO mappings */
+	 res += __pkvm_pgtable_max_pages(SZ_1G >> PAGE_SHIFT);
+
+	return res;
+}
+
+static inline unsigned long pkvm_mmu_pgtable_pages(void)
+{
+	unsigned long res;
+
+	res = __pkvm_pgtable_total_pages();
+
+	return res;
+}
+
+static inline unsigned long pkvm_vmemmap_memblock_size(struct memblock_region *reg,
+		size_t vmemmap_entry_size)
+{
+	unsigned long nr_pages = reg->size >> PAGE_SHIFT;
+	unsigned long start, end;
+
+	/* Translate the pfn to the vmemmap entry */
+	start = (reg->base >> PAGE_SHIFT) * vmemmap_entry_size;
+	end = start + nr_pages * vmemmap_entry_size;
+	start = ALIGN_DOWN(start, PAGE_SIZE);
+	end = ALIGN(end, PAGE_SIZE);
+
+	return end - start;
+}
+
+static inline unsigned long pkvm_vmemmap_pages(size_t vmemmap_entry_size)
+{
+	unsigned long total_size = 0, i;
+
+	for (i = 0; i < pkvm_sym(hyp_memblock_nr); i++) {
+		total_size += pkvm_vmemmap_memblock_size(&pkvm_sym(hyp_memory)[i],
+							 vmemmap_entry_size);
+	}
+
+	return total_size >> PAGE_SHIFT;
+}
+
+static inline unsigned long pkvm_data_struct_pages(unsigned long global_pgs,
+		unsigned long percpu_pgs, int num_cpus)
+{
+	return (percpu_pgs * num_cpus + global_pgs);
+}
+
+u64 hyp_total_reserve_pages(void);
 #endif
 
 #endif
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/memory.c b/arch/x86/kvm/vmx/pkvm/hyp/memory.c
index 62dd80947d8e..eb913cf08691 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/memory.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/memory.c
@@ -4,10 +4,14 @@
  */
 
 #include <linux/types.h>
+#include <asm/kvm_pkvm.h>
 
 unsigned long __page_base_offset;
 unsigned long __symbol_base_offset;
 
+unsigned int hyp_memblock_nr;
+struct memblock_region hyp_memory[HYP_MEMBLOCK_REGIONS];
+
 void *pkvm_phys_to_virt(unsigned long phys)
 {
 	return (void *)__page_base_offset + phys;
diff --git a/arch/x86/kvm/vmx/pkvm/include/pkvm.h b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
index b344165511f7..1c2b70c3788e 100644
--- a/arch/x86/kvm/vmx/pkvm/include/pkvm.h
+++ b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
@@ -47,6 +47,8 @@ struct pkvm_hyp {
 #define PKVM_PAGES (ALIGN(sizeof(struct pkvm_hyp), PAGE_SIZE) >> PAGE_SHIFT)
 #define PKVM_PCPU_PAGES (ALIGN(sizeof(struct pkvm_pcpu), PAGE_SIZE) >> PAGE_SHIFT)
 #define PKVM_HOST_VCPU_PAGES (ALIGN(sizeof(struct pkvm_host_vcpu), PAGE_SIZE) >> PAGE_SHIFT)
+#define PKVM_VMCS_PAGES 3 /*vmxarea+vmcs+msr_bitmap*/
+#define PKVM_PERCPU_PAGES (PKVM_PCPU_PAGES + PKVM_HOST_VCPU_PAGES + PKVM_VMCS_PAGES)
 
 extern char __pkvm_text_start[], __pkvm_text_end[];
 
diff --git a/arch/x86/kvm/vmx/pkvm/pkvm_host.c b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
index 9705aebaab2e..655ee8da2ac2 100644
--- a/arch/x86/kvm/vmx/pkvm/pkvm_host.c
+++ b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
@@ -6,8 +6,10 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <asm/trapnr.h>
+#include <asm/kvm_pkvm.h>
 
 #include <pkvm.h>
+#include "pkvm_constants.h"
 
 MODULE_LICENSE("GPL");
 
@@ -29,6 +31,18 @@ static struct gdt_page pkvm_gdt_page = {
 	},
 };
 
+u64 hyp_total_reserve_pages(void)
+{
+	u64 total;
+
+	total = pkvm_data_struct_pages(PKVM_PAGES, PKVM_PERCPU_PAGES, num_possible_cpus());
+	total += pkvm_vmemmap_pages(PKVM_VMEMMAP_ENTRY_SIZE);
+	total += pkvm_mmu_pgtable_pages();
+	total += host_ept_pgtable_pages();
+
+	return total;
+}
+
 static void *pkvm_early_alloc_contig(int pages)
 {
 	return alloc_pages_exact(pages << PAGE_SHIFT, GFP_KERNEL | __GFP_ZERO);
-- 
2.25.1

