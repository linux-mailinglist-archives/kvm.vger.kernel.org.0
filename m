Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82CB26B6469
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 10:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbjCLJ4Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbjCLJzx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:55:53 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238855073B
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:55:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678614940; x=1710150940;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=brT/CTYF8ZBydnN/C+nwkuCMOgiMkwopMiqIAoJv9RU=;
  b=AsmQk3wEBR64KcVNgx16ccSxzPqY3299A4rBTm0XHBA6voi7RCx4cEOb
   mEj9QRzOkAUTwUX63pKtVDcu7n031SA79zsdUs/xZ1TBIDqSFjeCYnTy4
   fDE7cSVy2GDsGdTb+f7QTTY9LvJSuYNsVuzjrv26vduWDekbA8ocU05gE
   yymRni1846T/ateugB7rDOuPLlfIFpauyaLbxDy8C/y4twkyfGAT0rfqc
   2tLum+XP7sPQsUTG48wYbmf68pOQ0hWnHCCvbYk6nIXL2JIJDrdlejk2o
   p2UXoY3WzoIhc6JXs0g7xet8+8DjsgYPeF+vOIouXF4GEu6tVo4kPTSAL
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="316623037"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316623037"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="655660807"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="655660807"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:55:10 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Jason Chen CJ <jason.cj.chen@intel.com>,
        Shaoqin Huang <shaoqin.huang@intel.com>
Subject: [RFC PATCH part-3 08/22] pkvm: x86: Early alloc from reserved memory
Date:   Mon, 13 Mar 2023 02:01:38 +0800
Message-Id: <20230312180152.1778338-9-jason.cj.chen@intel.com>
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

pKVM's data strcuture shall be allocated from its own memory, to
ensure it can be isolated from host Linux.

Add early page allocator which fetch pages from reserved memory of
pKVM. For pkvm_early_alloc_config(), replace alloc_pages_exact()
with the new added early page allocator. And as the allocation is
from reserved memory, pkvm_init failure make reserved memory useless,
there is no need to free such allocated pages anymore.

TODO: return reserved memory to host Linux if pkvm_init fails.

Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/Makefile      |  2 +-
 arch/x86/kvm/vmx/pkvm/hyp/early_alloc.c | 47 +++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/early_alloc.h | 12 +++++
 arch/x86/kvm/vmx/pkvm/include/pkvm.h    |  4 ++
 arch/x86/kvm/vmx/pkvm/pkvm_host.c       | 69 ++++++++-----------------
 5 files changed, 86 insertions(+), 48 deletions(-)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/Makefile b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
index 578d6955a1d1..56db60f5682d 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/Makefile
+++ b/arch/x86/kvm/vmx/pkvm/hyp/Makefile
@@ -12,7 +12,7 @@ ccflags-y += -D__PKVM_HYP__
 lib-dir		:= lib
 virt-dir	:= ../../../../../../$(KVM_PKVM)
 
-pkvm-hyp-y	:= vmx_asm.o vmexit.o memory.o
+pkvm-hyp-y	:= vmx_asm.o vmexit.o memory.o early_alloc.o
 
 pkvm-hyp-y	+= $(lib-dir)/memset_64.o
 pkvm-hyp-$(CONFIG_RETPOLINE)	+= $(lib-dir)/retpoline.o
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/early_alloc.c b/arch/x86/kvm/vmx/pkvm/hyp/early_alloc.c
new file mode 100644
index 000000000000..aac5cf243874
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/early_alloc.c
@@ -0,0 +1,47 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+
+#include <asm/string.h>
+#include <asm/pkvm_spinlock.h>
+#include <pkvm.h>
+
+static unsigned long base;
+static unsigned long end;
+static unsigned long cur;
+
+static pkvm_spinlock_t early_lock = __PKVM_SPINLOCK_UNLOCKED;
+
+void *pkvm_early_alloc_contig(unsigned int nr_pages)
+{
+	unsigned long size = (nr_pages << PAGE_SHIFT);
+	void *ret;
+
+	if (!nr_pages)
+		return NULL;
+
+	pkvm_spin_lock(&early_lock);
+	if (end - cur < size) {
+		pkvm_spin_unlock(&early_lock);
+		return NULL;
+	}
+	ret = (void *)cur;
+	cur += size;
+	pkvm_spin_unlock(&early_lock);
+
+	memset(ret, 0, size);
+
+	return ret;
+}
+
+void *pkvm_early_alloc_page(void)
+{
+	return pkvm_early_alloc_contig(1);
+}
+
+void pkvm_early_alloc_init(void *virt, unsigned long size)
+{
+	base = cur = (unsigned long)virt;
+	end = base + size;
+}
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/early_alloc.h b/arch/x86/kvm/vmx/pkvm/hyp/early_alloc.h
new file mode 100644
index 000000000000..96c041557d92
--- /dev/null
+++ b/arch/x86/kvm/vmx/pkvm/hyp/early_alloc.h
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Intel Corporation
+ */
+#ifndef __PKVM_EARLY_ALLOC_H
+#define __PKVM_EARLY_ALLOC_H
+
+void *pkvm_early_alloc_contig(unsigned int nr_pages);
+void *pkvm_early_alloc_page(void);
+void pkvm_early_alloc_init(void *virt, unsigned long size);
+
+#endif
diff --git a/arch/x86/kvm/vmx/pkvm/include/pkvm.h b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
index 1c2b70c3788e..334630efb233 100644
--- a/arch/x86/kvm/vmx/pkvm/include/pkvm.h
+++ b/arch/x86/kvm/vmx/pkvm/include/pkvm.h
@@ -58,4 +58,8 @@ extern unsigned long pkvm_sym(__symbol_base_offset);
 PKVM_DECLARE(void, __pkvm_vmx_vmexit(void));
 PKVM_DECLARE(int, pkvm_main(struct kvm_vcpu *vcpu));
 
+PKVM_DECLARE(void *, pkvm_early_alloc_contig(unsigned int nr_pages));
+PKVM_DECLARE(void *, pkvm_early_alloc_page(void));
+PKVM_DECLARE(void, pkvm_early_alloc_init(void *virt, unsigned long size));
+
 #endif
diff --git a/arch/x86/kvm/vmx/pkvm/pkvm_host.c b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
index 655ee8da2ac2..ea70f3692044 100644
--- a/arch/x86/kvm/vmx/pkvm/pkvm_host.c
+++ b/arch/x86/kvm/vmx/pkvm/pkvm_host.c
@@ -43,22 +43,12 @@ u64 hyp_total_reserve_pages(void)
 	return total;
 }
 
-static void *pkvm_early_alloc_contig(int pages)
-{
-	return alloc_pages_exact(pages << PAGE_SHIFT, GFP_KERNEL | __GFP_ZERO);
-}
-
-static void pkvm_early_free(void *ptr, int pages)
-{
-	free_pages_exact(ptr, pages << PAGE_SHIFT);
-}
-
 static struct vmcs *pkvm_alloc_vmcs(struct vmcs_config *vmcs_config_ptr)
 {
 	struct vmcs *vmcs;
 	int pages = ALIGN(vmcs_config_ptr->size, PAGE_SIZE) >> PAGE_SHIFT;
 
-	vmcs = pkvm_early_alloc_contig(pages);
+	vmcs = pkvm_sym(pkvm_early_alloc_contig)(pages);
 	if (!vmcs)
 		return NULL;
 
@@ -68,13 +58,6 @@ static struct vmcs *pkvm_alloc_vmcs(struct vmcs_config *vmcs_config_ptr)
 	return vmcs;
 }
 
-static void pkvm_free_vmcs(void *vmcs, struct vmcs_config *vmcs_config_ptr)
-{
-	int pages = ALIGN(vmcs_config_ptr->size, PAGE_SIZE) >> PAGE_SHIFT;
-
-	pkvm_early_free(vmcs, pages);
-}
-
 static inline void vmxon_setup_revid(void *vmxon_region)
 {
 	u32 rev_id = 0;
@@ -136,7 +119,7 @@ static __init int pkvm_enable_vmx(struct pkvm_host_vcpu *vcpu)
 {
 	u64 phys_addr;
 
-	vcpu->vmxarea = pkvm_early_alloc_contig(1);
+	vcpu->vmxarea = pkvm_sym(pkvm_early_alloc_page)();
 	if (!vcpu->vmxarea)
 		return -ENOMEM;
 
@@ -366,7 +349,7 @@ static __init int pkvm_host_init_vmx(struct pkvm_host_vcpu *vcpu, int cpu)
 	if (!vmx->vmcs01.vmcs)
 		return -ENOMEM;
 
-	vmx->vmcs01.msr_bitmap = pkvm_early_alloc_contig(1);
+	vmx->vmcs01.msr_bitmap = pkvm_sym(pkvm_early_alloc_page)();
 	if (!vmx->vmcs01.msr_bitmap) {
 		pr_err("%s: No page for msr_bitmap\n", __func__);
 		return -ENOMEM;
@@ -390,15 +373,11 @@ static __init void pkvm_host_deinit_vmx(struct pkvm_host_vcpu *vcpu)
 
 	pkvm_cpu_vmxoff();
 
-	if (vmx->vmcs01.vmcs) {
-		pkvm_free_vmcs(vmx->vmcs01.vmcs, &pkvm->vmcs_config);
+	if (vmx->vmcs01.vmcs)
 		vmx->vmcs01.vmcs = NULL;
-	}
 
-	if (vmx->vmcs01.msr_bitmap) {
-		pkvm_early_free(vmx->vmcs01.msr_bitmap, 1);
+	if (vmx->vmcs01.msr_bitmap)
 		vmx->vmcs01.msr_bitmap = NULL;
-	}
 }
 
 static __init int pkvm_host_check_and_setup_vmx_cap(struct pkvm_hyp *pkvm)
@@ -520,7 +499,7 @@ static __init int pkvm_setup_pcpu(struct pkvm_hyp *pkvm, int cpu)
 	if (cpu >= CONFIG_NR_CPUS)
 		return -ENOMEM;
 
-	pcpu = pkvm_early_alloc_contig(PKVM_PCPU_PAGES);
+	pcpu = pkvm_sym(pkvm_early_alloc_contig)(PKVM_PCPU_PAGES);
 	if (!pcpu)
 		return -ENOMEM;
 
@@ -543,7 +522,7 @@ static __init int pkvm_host_setup_vcpu(struct pkvm_hyp *pkvm, int cpu)
 	if (cpu >= CONFIG_NR_CPUS)
 		return -ENOMEM;
 
-	pkvm_host_vcpu = pkvm_early_alloc_contig(PKVM_HOST_VCPU_PAGES);
+	pkvm_host_vcpu = pkvm_sym(pkvm_early_alloc_contig)(PKVM_HOST_VCPU_PAGES);
 	if (!pkvm_host_vcpu)
 		return -ENOMEM;
 
@@ -712,7 +691,16 @@ __init int pkvm_init(void)
 {
 	int ret = 0, cpu;
 
-	pkvm = pkvm_early_alloc_contig(PKVM_PAGES);
+	if (!hyp_mem_base) {
+		pr_err("pkvm required memory not get reserved!");
+		ret = -ENOMEM;
+		goto out;
+	}
+	pkvm_sym(pkvm_early_alloc_init)(__va(hyp_mem_base),
+			pkvm_data_struct_pages(PKVM_PAGES, PKVM_PERCPU_PAGES,
+				num_possible_cpus()) << PAGE_SHIFT);
+
+	pkvm = pkvm_sym(pkvm_early_alloc_contig)(PKVM_PAGES);
 	if (!pkvm) {
 		ret = -ENOMEM;
 		goto out;
@@ -720,42 +708,29 @@ __init int pkvm_init(void)
 
 	ret = pkvm_host_check_and_setup_vmx_cap(pkvm);
 	if (ret)
-		goto out_free_pkvm;
+		goto out;
 
 	ret = pkvm_init_mmu();
 	if (ret)
-		goto out_free_pkvm;
+		goto out;
 
 	for_each_possible_cpu(cpu) {
 		ret = pkvm_setup_pcpu(pkvm, cpu);
 		if (ret)
-			goto out_free_cpu;
+			goto out;
 		ret = pkvm_host_setup_vcpu(pkvm, cpu);
 		if (ret)
-			goto out_free_cpu;
+			goto out;
 	}
 
 	ret = pkvm_host_deprivilege_cpus(pkvm);
 	if (ret)
-		goto out_free_cpu;
+		goto out;
 
 	pkvm->num_cpus = num_possible_cpus();
 
 	return 0;
 
-out_free_cpu:
-	for_each_possible_cpu(cpu) {
-		if (pkvm->host_vm.host_vcpus[cpu]) {
-			pkvm_early_free(pkvm->host_vm.host_vcpus[cpu], PKVM_HOST_VCPU_PAGES);
-			pkvm->host_vm.host_vcpus[cpu] = NULL;
-		}
-		if (pkvm->pcpus[cpu]) {
-			pkvm_early_free(pkvm->pcpus[cpu], PKVM_PCPU_PAGES);
-			pkvm->pcpus[cpu] = NULL;
-		}
-	}
-out_free_pkvm:
-	pkvm_early_free(pkvm, PKVM_PAGES);
 out:
 	return ret;
 }
-- 
2.25.1

