Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B15536B6474
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbjCLJ5W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjCLJ4z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:56:55 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50C95372E
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:56:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614983; x=1710150983;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0UXC/P7kOOvt5TTOAefEQzZTDPHNaq6f5o4PmwUXVjo=;
  b=ZVEOM6fcZN0jR0Nejox60sA4+2ou7Z/hYVkpu2VheyUHwDXepdPPvaMT
   0B09BlaFnvaHxlYEisbmCUopXhXk9mXc4sV+xnNiUZy8qaKh7okbLBTVc
   z0TLi8/DxcpJ4sdxtxeu4wddpUFeBQSRONieJra9NnJKjBVxWaUGiJ7LC
   wI38MNXm8pZrYEqqaEzJtGTSubfp9WbPJm5hh/NqxKnk/x5oAiRmeFLhA
   8byi1B3lB0KB8bUT7xeibrq10n/dGHxu05YmREeMZZH4sjS0ayGRq9FRR
   yxaN5hhsAj9gFyMFtK49y7P7NtgjMz+x4uqPASPv5ybcJD7gj5oPe7+yq
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316623063"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316623063"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="655660849"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="655660849"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:27 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Shaoqin Huang <shaoqin.huang@intel.com>,
        Chuanxiao Dong <chuanxiao.dong@intel.com>
Subject: [RFC PATCH part-3 19/22] pkvm: x86: Create host EPT pgtable in init-finalise hypercall
Date:   Mon, 13 Mar 2023 02:01:49 +0800
Message-Id: <20230312180152.1778338-20-jason.cj.chen@intel.com>
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

Create host EPT pgtable for pKVM, which ensure host VM keep accessing
all system memory except pKVM ones - the code/data sections and
reserved memory of pKVM.

The memory pool of this host EPT pgtable is allocated from pKVM
reserved memory. All system memory block in hyp_memory[] array is
firstly mapped in host EPT, the holes among these memory blocks are also
mapped in case for MMIO accessing. Then the code/data sections and
reserved memory block of pKVM is unmapped to remove the host
accessing.

After host EPT pgtable got created, set host vcpu's EPT pointer to it.

This patch also makes the init-finalise hypercall take effect at the end
of pkvm_init.

Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/ept.c           |  2 +
 arch/x86/kvm/vmx/pkvm/hyp/ept.h           |  5 ++
 arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c | 98 ++++++++++++++++++++++-
 arch/x86/kvm/vmx/pkvm/hyp/vmx.h           | 48 +++++++++++
 arch/x86/kvm/vmx/pkvm/include/pkvm.h      |  1 +
 arch/x86/kvm/vmx/pkvm/pkvm_host.c         |  2 +-
 6 files changed, 153 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/ept.c b/arch/x86/kvm/vmx/pkvm/hyp/ept.c
index fd366cb1570f..5b7b0d84b457 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/ept.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/ept.c
@@ -12,6 +12,7 @@
 #include <pkvm.h>
 #include <gfp.h>
 
+#include "pkvm_hyp.h"
 #include "early_alloc.h"
 #include "pgtable.h"
 #include "ept.h"
@@ -147,5 +148,6 @@ int pkvm_host_ept_init(struct pkvm_pgtable_cap *cap,
 	if (ret)
 		return ret;
 
+	pkvm_hyp->host_vm.ept = &host_ept;
 	return pkvm_pgtable_init(&host_ept, &host_ept_mm_ops, &ept_ops, cap, true);
 }
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/ept.h b/arch/x86/kvm/vmx/pkvm/hyp/ept.h
index 26220325feec..43c7e418db6a 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/ept.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/ept.h
@@ -5,6 +5,11 @@
 #ifndef __PKVM_EPT_H
 #define __PKVM_EPT_H
 
+#define HOST_EPT_DEF_MEM_PROT   (VMX_EPT_RWX_MASK |				\
+				(MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT))
+#define HOST_EPT_DEF_MMIO_PROT	(VMX_EPT_RWX_MASK |				\
+				(MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT))
+
 int pkvm_host_ept_map(unsigned long vaddr_start, unsigned long phys_start,
 		unsigned long size, int pgsz_mask, u64 prot);
 int pkvm_host_ept_unmap(unsigned long vaddr_start, unsigned long phys_start,
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c b/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c
index dc4c0b6213ea..ae10d550448d 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/init_finalise.c
@@ -15,10 +15,13 @@
 #include "memory.h"
 #include "pgtable.h"
 #include "mmu.h"
+#include "ept.h"
+#include "vmx.h"
 #include "debug.h"
 
 void *pkvm_mmu_pgt_base;
 void *pkvm_vmemmap_base;
+void *host_ept_pgt_base;
 
 static int divide_memory_pool(phys_addr_t phys, unsigned long size)
 {
@@ -40,6 +43,11 @@ static int divide_memory_pool(phys_addr_t phys, unsigned long size)
 	if (!pkvm_mmu_pgt_base)
 		return -ENOMEM;
 
+	nr_pages = host_ept_pgtable_pages();
+	host_ept_pgt_base = pkvm_early_alloc_contig(nr_pages);
+	if (!host_ept_pgt_base)
+		return -ENOMEM;
+
 	return 0;
 }
 
@@ -140,6 +148,77 @@ static int create_mmu_mapping(const struct pkvm_section sections[],
 	return 0;
 }
 
+static int create_host_ept_mapping(void)
+{
+	struct memblock_region *reg;
+	int ret, i;
+	unsigned long phys = 0;
+	u64 entry_prot;
+
+	ret = pkvm_host_ept_init(&pkvm_hyp->ept_cap,
+			host_ept_pgt_base, host_ept_pgtable_pages());
+	if (ret)
+		return ret;
+
+	/*
+	 * Create EPT mapping for memory with WB + RWX property
+	 */
+	entry_prot = HOST_EPT_DEF_MEM_PROT;
+
+	for (i = 0; i < hyp_memblock_nr; i++) {
+		reg = &hyp_memory[i];
+		ret = pkvm_host_ept_map((unsigned long)reg->base,
+				  (unsigned long)reg->base,
+				  (unsigned long)reg->size,
+				  0, entry_prot);
+		if (ret)
+			return ret;
+	}
+
+	/*
+	 * The holes in memblocks are treated as MMIO with the
+	 * mapping UC + RWX.
+	 */
+	entry_prot = HOST_EPT_DEF_MMIO_PROT;
+	for (i = 0; i < hyp_memblock_nr; i++, phys = reg->base + reg->size) {
+		reg = &hyp_memory[i];
+		ret = pkvm_host_ept_map(phys, phys, (unsigned long)reg->base - phys,
+				  0, entry_prot);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int protect_pkvm_pages(const struct pkvm_section sections[],
+		       int section_sz, phys_addr_t phys, unsigned long size)
+{
+	int i, ret;
+
+	for (i = 0; i < section_sz; i++) {
+		u64 pa, size;
+
+		if (sections[i].type == PKVM_CODE_DATA_SECTIONS) {
+			pa = __pkvm_pa_symbol(sections[i].addr);
+			size = sections[i].size;
+			ret = pkvm_host_ept_unmap(pa, pa, size);
+			if (ret) {
+				pkvm_err("%s: failed to protect section\n", __func__);
+				return ret;
+			}
+		}
+	}
+
+	ret = pkvm_host_ept_unmap(phys, phys, size);
+	if (ret) {
+		pkvm_err("%s: failed to protect reserved memory\n", __func__);
+		return ret;
+	}
+
+	return 0;
+}
+
 #define TMP_SECTION_SZ	16UL
 int __pkvm_init_finalise(struct kvm_vcpu *vcpu, struct pkvm_section sections[],
 			 int section_sz)
@@ -151,6 +230,7 @@ int __pkvm_init_finalise(struct kvm_vcpu *vcpu, struct pkvm_section sections[],
 	struct pkvm_section tmp_sections[TMP_SECTION_SZ];
 	phys_addr_t hyp_mem_base;
 	unsigned long hyp_mem_size = 0;
+	u64 eptp;
 
 	if (pkvm_init)
 		goto switch_pgt;
@@ -188,15 +268,29 @@ int __pkvm_init_finalise(struct kvm_vcpu *vcpu, struct pkvm_section sections[],
 	if (ret)
 		goto out;
 
-	/* TODO: setup host EPT page table */
+	ret = create_host_ept_mapping();
+	if (ret)
+		goto out;
+
+	ret = protect_pkvm_pages(tmp_sections, section_sz,
+			hyp_mem_base, hyp_mem_size);
+	if (ret)
+		goto out;
 
 	pkvm_init = true;
 
 switch_pgt:
-	/* switch mmu, TODO: switch EPT */
+	/* switch mmu */
 	vmcs_writel(HOST_CR3, pkvm_hyp->mmu->root_pa);
 	pcpu->cr3 = pkvm_hyp->mmu->root_pa;
 
+	/* enable ept */
+	eptp = pkvm_construct_eptp(pkvm_hyp->host_vm.ept->root_pa, pkvm_hyp->host_vm.ept->level);
+	secondary_exec_controls_setbit(&pkvm_host_vcpu->vmx, SECONDARY_EXEC_ENABLE_EPT);
+	vmcs_write64(EPT_POINTER, eptp);
+
+	ept_sync_global();
+
 out:
 	return ret;
 }
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/vmx.h b/arch/x86/kvm/vmx/pkvm/hyp/vmx.h
new file mode 100644
index 000000000000..c0a42cc56764
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/vmx.h
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+
+#ifndef __PKVM_VMX_H
+#define __PKVM_VMX_H
+
+static inline bool vmx_ept_capability_check(u32 bit)
+{
+	struct vmx_capability *vmx_cap = &pkvm_hyp->vmx_cap;
+
+	return vmx_cap->ept & bit;
+}
+
+static inline bool vmx_ept_has_4levels(void)
+{
+	return vmx_ept_capability_check(VMX_EPT_PAGE_WALK_4_BIT);
+}
+
+static inline bool vmx_ept_has_5levels(void)
+{
+	return vmx_ept_capability_check(VMX_EPT_PAGE_WALK_5_BIT);
+}
+
+static inline bool vmx_ept_has_mt_wb(void)
+{
+	return vmx_ept_capability_check(VMX_EPTP_WB_BIT);
+}
+
+static inline u64 pkvm_construct_eptp(unsigned long root_hpa, int level)
+{
+	u64 eptp = 0;
+
+	if ((level == 4) && vmx_ept_has_4levels())
+		eptp = VMX_EPTP_PWL_4;
+	else if ((level == 5) && vmx_ept_has_5levels())
+		eptp = VMX_EPTP_PWL_5;
+
+	if (vmx_ept_has_mt_wb())
+		eptp |= VMX_EPTP_MT_WB;
+
+	eptp |= (root_hpa & PAGE_MASK);
+
+	return eptp;
+}
+
+#endif
diff --git a/arch/x86/kvm/vmx/pkvm/include/pkvm.h b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
index 8db295cf80c5..d0a7283b0e19 100644
--- a/arch/x86/kvm/vmx/pkvm/include/pkvm.h
+++ b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
@@ -37,6 +37,7 @@ struct pkvm_host_vcpu {
 
 struct pkvm_host_vm {
 	struct pkvm_host_vcpu *host_vcpus[CONFIG_NR_CPUS];
+	struct pkvm_pgtable *ept;
 };
 
 struct pkvm_hyp {
diff --git a/arch/x86/kvm/vmx/pkvm/pkvm_host.c b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
index 101b7b190662..4120f9ef2a7e 100644
--- a/arch/x86/kvm/vmx/pkvm/pkvm_host.c
+++ b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
@@ -854,7 +854,7 @@ __init int pkvm_init(void)
 
 	pkvm->num_cpus = num_possible_cpus();
 
-	return 0;
+	return pkvm_init_finalise();
 
 out:
 	pkvm_sym(pkvm_hyp) = NULL;
-- 
2.25.1

