Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 098B36B6471
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjCLJ47 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbjCLJ4j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:56:39 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3664D52F4B
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:56:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614971; x=1710150971;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0SrkqghHATwn2FmcU1WmSp7qbWu7a81D6/vw/w6gGso=;
  b=h8hkA255mx3+qKhBXL0gJebl92uuG5E7j8ee0hG9o2PGS3lYy7VISEDW
   xCJWolSfhGcs2CZ/XiXhm7HI/FcOAX9Y/X57j+yYcBwQ1ORUaIo2xuYFt
   bENLBv1IVhXPf7mdn4EmyBin6SKpzqjiUaAKvw9sfXAC5z/XkvIZ7E6bs
   sjJx/KQ0b6RJZodFkz1GeptdPF0DRQsgOXtqTOTgwJbVzzfFTJUoERUzV
   RbOr1of6oo6sxIccaSP+HKOtAAbmz6zw2/tr3IG28EcC/Mi5Vt5JJ6bMu
   SsLwnOJMql2uRfsXVdn2DigBGBWpRmT/oGYpjIMenITkOtdP6TGQyAxk7
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316623056"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316623056"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="655660837"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="655660837"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:22 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Shaoqin Huang <shaoqin.huang@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-3 16/22] pkvm: x86: Create MMU pgtable in init-finalise hypercall
Date:   Mon, 13 Mar 2023 02:01:46 +0800
Message-Id: <20230312180152.1778338-17-jason.cj.chen@intel.com>
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

Create MMU pgtable for pKVM, this is the first stage to initialize
MMU pgtable, which is based on early page allocator.

Such early page allocator's memory pool is allocated from pKVM
reserved memory, after removed data struct size which already be
allocated during pkvm_init.

Take use of pkvm_early_mmu_init() to initialize hyp_mmu pgtable in
mmu.c, then do MMU page mapping based on it.

The MMU page mapping is setup for each system memory block in
hyp_memory[] array and each memory section from init-finalise hypercall
parameter; the address translation is according to previous commit
"Define hypervisor runtime VA/PA APIs". In summary, pKVM keep same
direct & symbol mapping as Linux kernel.

Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c | 95 ++++++++++++++++++++++-
 arch/x86/kvm/vmx/pkvm/hyp/mmu.c           |  2 +
 arch/x86/kvm/vmx/pkvm/include/pkvm.h      | 14 ++++
 3 files changed, 109 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c b/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c
index c62049728621..15a3f110b2cf 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c
@@ -3,15 +3,93 @@
  * Copyright (C) 2022 Intel Corporation
  */
 
+#include <linux/memblock.h>
+#include <mmu.h>
+#include <mmu/spte.h>
+#include <asm/kvm_pkvm.h>
+
 #include <pkvm.h>
+#include "pkvm_hyp.h"
+#include "early_alloc.h"
+#include "memory.h"
+#include "pgtable.h"
+#include "mmu.h"
 #include "debug.h"
 
+void *pkvm_mmu_pgt_base;
+
+static int divide_memory_pool(phys_addr_t phys, unsigned long size)
+{
+	int data_struct_size = pkvm_data_struct_pages(PKVM_PAGES,
+			PKVM_PCPU_PAGES + PKVM_HOST_VCPU_PAGES
+			+ PKVM_VMCS_PAGES, pkvm_hyp->num_cpus) << PAGE_SHIFT;
+	void *virt = __pkvm_va(phys + data_struct_size);
+	unsigned long nr_pages;
+
+	pkvm_early_alloc_init(virt, size - data_struct_size);
+
+	nr_pages = pkvm_mmu_pgtable_pages();
+	pkvm_mmu_pgt_base = pkvm_early_alloc_contig(nr_pages);
+	if (!pkvm_mmu_pgt_base)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int create_mmu_mapping(const struct pkvm_section sections[],
+				 int section_sz)
+{
+	unsigned long nr_pages = pkvm_mmu_pgtable_pages();
+	struct memblock_region *reg;
+	int ret, i;
+
+	ret = pkvm_early_mmu_init(&pkvm_hyp->mmu_cap,
+			pkvm_mmu_pgt_base, nr_pages);
+	if (ret)
+		return ret;
+
+	/*
+	 * Create mapping for the memory in memblocks.
+	 * This will include all the memory host kernel can see, as well
+	 * as the memory pkvm allocated during init.
+	 *
+	 * The virtual address for this mapping is the same with the kernel
+	 * direct mapping.
+	 */
+	for (i = 0; i < hyp_memblock_nr; i++) {
+		reg = &hyp_memory[i];
+		ret = pkvm_mmu_map((unsigned long)__pkvm_va(reg->base),
+				reg->base, reg->size,
+				0, (u64)pgprot_val(PAGE_KERNEL));
+		if (ret)
+			return ret;
+	}
+
+	for (i = 0; i < section_sz; i++) {
+		if (sections[i].type != PKVM_RESERVED_MEMORY) {
+			ret = pkvm_mmu_map(sections[i].addr,
+					__pkvm_pa_symbol(sections[i].addr),
+					sections[i].size,
+					0, sections[i].prot);
+		}
+		if (ret)
+			return ret;
+	}
+
+	/* Switch the mmu pgtable to enable pkvm_vmemmap */
+	native_write_cr3(pkvm_hyp->mmu->root_pa);
+
+	return 0;
+}
+
 #define TMP_SECTION_SZ	16UL
 int __pkvm_init_finalise(struct kvm_vcpu *vcpu, struct pkvm_section sections[],
 			 int section_sz)
 {
 	int i, ret = 0;
 	static bool pkvm_init;
+	struct pkvm_host_vcpu *pkvm_host_vcpu = to_pkvm_hvcpu(vcpu);
+	struct pkvm_pcpu *pcpu = pkvm_host_vcpu->pcpu;
 	struct pkvm_section tmp_sections[TMP_SECTION_SZ];
 	phys_addr_t hyp_mem_base;
 	unsigned long hyp_mem_size = 0;
@@ -39,14 +117,27 @@ int __pkvm_init_finalise(struct kvm_vcpu *vcpu, struct pkvm_section sections[],
 	if (hyp_mem_size == 0) {
 		pkvm_err("pkvm: no pkvm reserve memory!");
 		ret = -ENOTSUPP;
+		goto out;
+	}
+
+	ret = divide_memory_pool(hyp_mem_base, hyp_mem_size);
+	if (ret) {
+		pkvm_err("pkvm: not reserve enough memory!");
+		goto out;
 	}
 
-	/* TODO: setup MMU & host EPT page tables */
+	ret = create_mmu_mapping(tmp_sections, section_sz);
+	if (ret)
+		goto out;
+
+	/* TODO: setup host EPT page table */
 
 	pkvm_init = true;
 
 switch_pgt:
-	/* TODO: switch MMU & EPT */
+	/* switch mmu, TODO: switch EPT */
+	vmcs_writel(HOST_CR3, pkvm_hyp->mmu->root_pa);
+	pcpu->cr3 = pkvm_hyp->mmu->root_pa;
 
 out:
 	return ret;
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/mmu.c b/arch/x86/kvm/vmx/pkvm/hyp/mmu.c
index 8b07355c5b96..b139823298c0 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/mmu.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/mmu.c
@@ -10,6 +10,7 @@
 #include <mmu/spte.h>
 
 #include <pkvm.h>
+#include "pkvm_hyp.h"
 #include "early_alloc.h"
 #include "pgtable.h"
 #include "mmu.h"
@@ -117,6 +118,7 @@ int pkvm_early_mmu_init(struct pkvm_pgtable_cap *cap,
 		void *mmu_pool_base, unsigned long mmu_pool_pages)
 {
 	pkvm_early_alloc_init(mmu_pool_base, mmu_pool_pages << PAGE_SHIFT);
+	pkvm_hyp->mmu = &hyp_mmu;
 
 	return pkvm_pgtable_init(&hyp_mmu, &pkvm_early_alloc_mm_ops, &mmu_ops, cap, true);
 }
diff --git a/arch/x86/kvm/vmx/pkvm/include/pkvm.h b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
index 42dc76d37c02..8db295cf80c5 100644
--- a/arch/x86/kvm/vmx/pkvm/include/pkvm.h
+++ b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
@@ -48,11 +48,25 @@ struct pkvm_hyp {
 	struct pkvm_pgtable_cap mmu_cap;
 	struct pkvm_pgtable_cap ept_cap;
 
+	struct pkvm_pgtable *mmu;
+
 	struct pkvm_pcpu *pcpus[CONFIG_NR_CPUS];
 
 	struct pkvm_host_vm host_vm;
 };
 
+static inline struct pkvm_host_vcpu *vmx_to_pkvm_hvcpu(struct vcpu_vmx *vmx)
+{
+	return container_of(vmx, struct pkvm_host_vcpu, vmx);
+}
+
+static inline struct pkvm_host_vcpu *to_pkvm_hvcpu(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	return vmx_to_pkvm_hvcpu(vmx);
+}
+
 struct pkvm_section {
 	unsigned long type;
 #define PKVM_RESERVED_MEMORY		0UL
-- 
2.25.1

