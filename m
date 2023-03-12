Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 156096B6497
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 11:00:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbjCLJ7r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 05:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbjCLJ7Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:59:24 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF06328E9F
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615103; x=1710151103;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=huQVSFNyg5uuF2dwX4gukurRj2QIYWc9y+vFGsWRP+0=;
  b=MBmGKcdAWJJKKURMZVNuRlZnQf/82P/VAP6Y1/d3lZRrK90gIk52F+ft
   J/pRUCPQ+Uq7CjkqZIODrpy+mWyJXql3A+p3poMGrEosHcdCT80IiaIFK
   8tN9HWp2b2lMFkR5AaJwyA19aSdTrAE3DifB06ZgFNA/RNgsl+opReIbN
   y9GgN81/thlmce8uvxsU7h86tQg6YQuQsT4y3I2FmXdvaSYBpiQ7/tMof
   GEd0U517jWoWK5mznB1zq37v1MbeO+kKu/O/M2cplsrPhN0NxNE+hMJAJ
   gOs5aRuee3BbE0cENYytjLPnSiD6NL/06cUogdotNRudUWKTyhjbjiIkY
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="339344691"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="339344691"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="1007627314"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="1007627314"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:54 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Chuanxiao Dong <chuanxiao.dong@intel.com>,
        Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-6 04/13] pkvm: x86: Introduce shadow EPT
Date:   Mon, 13 Mar 2023 02:03:36 +0800
Message-Id: <20230312180345.1778588-5-jason.cj.chen@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230312180345.1778588-1-jason.cj.chen@intel.com>
References: <20230312180345.1778588-1-jason.cj.chen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Chuanxiao Dong <chuanxiao.dong@intel.com>

KVM in the host VM (KVM-high) can create its guest (nested VM).

Currently the KVM-high created guest EPT for such nested VM is directly
used in its physical VMCS. This means that, the KVM-high is able to map
any memory in this guest EPT, which will make this nested VM able to see
any memory, including the private memory(pKVM's memory and future
supported protected VM's memory) which needed to be protected.

Using shadow EPT can resolve this kind of security issue. In this
solution, pKVM maintains a shadow EPT for each nested VM. Shadow EPT
is populated during handling nested EPT violation with checking the
mapping in guest EPT through page state mechanism first (introduced in
later patches), so that pKVM can guarantee only allowed memory can be
mapped for a nested VM.

This patch introduces APIs to initialize shadow EPT for nested VMs.
How to build the page table entries from virtual EPT (in host VM) will
be introduced later.

FIXME:

The current design is that one VM only has one shadow EPT. This brings
a security issue for a VM to use vSMM mode, which is that the vCPU in
non-vSMM mode will be able to access the memory belongs to vSMM mode
because all vCPU are sharing one single shadow EPT.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/ept.c        | 67 ++++++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/ept.h        |  4 ++
 arch/x86/kvm/vmx/pkvm/hyp/pkvm.c       |  7 +++
 arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h   | 20 ++++++++
 arch/x86/kvm/vmx/pkvm/hyp/vmx.h        | 13 +++++
 arch/x86/kvm/vmx/pkvm/pkvm_constants.c |  2 +-
 6 files changed, 112 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/ept.c b/arch/x86/kvm/vmx/pkvm/hyp/ept.c
index 14bc8f4429db..0edea266b8bc 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/ept.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/ept.c
@@ -18,6 +18,7 @@
 #include "pgtable.h"
 #include "ept.h"
 #include "memory.h"
+#include "vmx.h"
 #include "debug.h"
 
 static struct hyp_pool host_ept_pool;
@@ -230,3 +231,69 @@ int pkvm_shadow_ept_pool_init(void *ept_pool_base, unsigned long ept_pool_pages)
 
 	return hyp_pool_init(&shadow_ept_pool, pfn, ept_pool_pages, 0);
 }
+
+static void *shadow_ept_zalloc_page(void)
+{
+	return hyp_alloc_pages(&shadow_ept_pool, 0);
+}
+
+static void shadow_ept_get_page(void *vaddr)
+{
+	hyp_get_page(&shadow_ept_pool, vaddr);
+}
+
+static void shadow_ept_put_page(void *vaddr)
+{
+	hyp_put_page(&shadow_ept_pool, vaddr);
+}
+
+/*TODO: add tlb flush support for shadow ept */
+static struct pkvm_mm_ops shadow_ept_mm_ops = {
+	.phys_to_virt = pkvm_phys_to_virt,
+	.virt_to_phys = pkvm_virt_to_phys,
+	.zalloc_page = shadow_ept_zalloc_page,
+	.get_page = shadow_ept_get_page,
+	.put_page = shadow_ept_put_page,
+	.page_count = hyp_page_count,
+	.flush_tlb = flush_tlb_noop,
+};
+
+void pkvm_shadow_ept_deinit(struct shadow_ept_desc *desc)
+{
+	struct pkvm_pgtable *sept = &desc->sept;
+	struct pkvm_shadow_vm *vm = sept_desc_to_shadow_vm(desc);
+
+	pkvm_spin_lock(&vm->lock);
+
+	if (desc->shadow_eptp) {
+		pkvm_pgtable_destroy(sept);
+
+		flush_ept(desc->shadow_eptp);
+
+		memset(sept, 0, sizeof(struct pkvm_pgtable));
+		desc->shadow_eptp = 0;
+	}
+
+	pkvm_spin_unlock(&vm->lock);
+}
+
+int pkvm_shadow_ept_init(struct shadow_ept_desc *desc)
+{
+	struct pkvm_pgtable_cap cap = {
+		.level = pkvm_hyp->ept_cap.level,
+		.allowed_pgsz = pkvm_hyp->ept_cap.allowed_pgsz,
+		.table_prot = pkvm_hyp->ept_cap.table_prot,
+	};
+	int ret;
+
+	memset(desc, 0, sizeof(struct shadow_ept_desc));
+
+	ret = pkvm_pgtable_init(&desc->sept, &shadow_ept_mm_ops, &ept_ops, &cap, true);
+	if (ret)
+		return ret;
+
+	desc->shadow_eptp = pkvm_construct_eptp(desc->sept.root_pa, cap.level);
+	flush_ept(desc->shadow_eptp);
+
+	return 0;
+}
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/ept.h b/arch/x86/kvm/vmx/pkvm/hyp/ept.h
index c4ad5c269d5c..7badcb3dd621 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/ept.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/ept.h
@@ -5,6 +5,8 @@
 #ifndef __PKVM_EPT_H
 #define __PKVM_EPT_H
 
+#include "pkvm_hyp.h"
+
 #define HOST_EPT_DEF_MEM_PROT   (VMX_EPT_RWX_MASK |				\
 				(MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT))
 #define HOST_EPT_DEF_MMIO_PROT	(VMX_EPT_RWX_MASK |				\
@@ -18,5 +20,7 @@ int pkvm_host_ept_init(struct pkvm_pgtable_cap *cap, void *ept_pool_base,
 		unsigned long ept_pool_pages);
 int handle_host_ept_violation(unsigned long gpa);
 int pkvm_shadow_ept_pool_init(void *ept_pool_base, unsigned long ept_pool_pages);
+int pkvm_shadow_ept_init(struct shadow_ept_desc *desc);
+void pkvm_shadow_ept_deinit(struct shadow_ept_desc *desc);
 
 #endif
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/pkvm.c b/arch/x86/kvm/vmx/pkvm/hyp/pkvm.c
index 25904252d2dd..321df4dd2998 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/pkvm.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/pkvm.c
@@ -7,6 +7,7 @@
 #include <pkvm.h>
 
 #include "pkvm_hyp.h"
+#include "ept.h"
 
 struct pkvm_hyp *pkvm_hyp;
 
@@ -101,6 +102,10 @@ int __pkvm_init_shadow_vm(unsigned long kvm_va,
 	pkvm_spin_lock_init(&vm->lock);
 
 	vm->host_kvm_va = kvm_va;
+
+	if (pkvm_shadow_ept_init(&vm->sept_desc))
+		return -EINVAL;
+
 	return allocate_shadow_vm_handle(vm);
 }
 
@@ -111,6 +116,8 @@ unsigned long __pkvm_teardown_shadow_vm(int shadow_vm_handle)
 	if (!vm)
 		return 0;
 
+	pkvm_shadow_ept_deinit(&vm->sept_desc);
+
 	memset(vm, 0, sizeof(struct pkvm_shadow_vm) + pkvm_shadow_vcpu_array_size());
 
 	return pkvm_virt_to_phys(vm);
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h b/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h
index b7c3f8c478b4..a1f3644a4a34 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h
@@ -6,6 +6,17 @@
 #define __PKVM_HYP_H
 
 #include <asm/pkvm_spinlock.h>
+#include "pgtable.h"
+
+/*
+ * Descriptor for shadow EPT
+ */
+struct shadow_ept_desc {
+	/* shadow EPTP value configured by pkvm */
+	u64 shadow_eptp;
+
+	struct pkvm_pgtable sept;
+};
 
 #define PKVM_MAX_NORMAL_VM_NUM		8
 #define PKVM_MAX_PROTECTED_VM_NUM	2
@@ -76,9 +87,18 @@ struct pkvm_shadow_vm {
 	/* The host's kvm va. */
 	unsigned long host_kvm_va;
 
+	/*
+	 * VM's shadow EPT. All vCPU shares one mapping.
+	 * FIXME: a potential security issue if some vCPUs are
+	 * in SMM but the others are not.
+	 */
+	struct shadow_ept_desc sept_desc;
+
 	pkvm_spinlock_t lock;
 } __aligned(PAGE_SIZE);
 
+#define sept_desc_to_shadow_vm(desc) container_of(desc, struct pkvm_shadow_vm, sept_desc)
+
 int __pkvm_init_shadow_vm(unsigned long kvm_va, unsigned long shadow_pa,
 			  size_t shadow_size);
 unsigned long __pkvm_teardown_shadow_vm(int shadow_vm_handle);
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/vmx.h b/arch/x86/kvm/vmx/pkvm/hyp/vmx.h
index 54c17e256107..13405166bccf 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/vmx.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/vmx.h
@@ -28,6 +28,11 @@ static inline bool vmx_ept_has_mt_wb(void)
 	return vmx_ept_capability_check(VMX_EPTP_WB_BIT);
 }
 
+static inline bool vmx_has_invept_context(void)
+{
+	return vmx_ept_capability_check(VMX_EPT_EXTENT_CONTEXT_BIT);
+}
+
 static inline u64 pkvm_construct_eptp(unsigned long root_hpa, int level)
 {
 	u64 eptp = 0;
@@ -71,6 +76,14 @@ static inline void vmcs_clear_track(struct vcpu_vmx *vmx, struct vmcs *vmcs)
 	vmcs_clear(vmcs);
 }
 
+static inline void flush_ept(u64 eptp)
+{
+	if (vmx_has_invept_context())
+		__invept(VMX_EPT_EXTENT_CONTEXT, eptp, 0);
+	else
+		__invept(VMX_EPT_EXTENT_GLOBAL, 0, 0);
+}
+
 void pkvm_init_host_state_area(struct pkvm_pcpu *pcpu, int cpu);
 
 #endif
diff --git a/arch/x86/kvm/vmx/pkvm/pkvm_constants.c b/arch/x86/kvm/vmx/pkvm/pkvm_constants.c
index 6222a8fff6af..665d983040e8 100644
--- a/arch/x86/kvm/vmx/pkvm/pkvm_constants.c
+++ b/arch/x86/kvm/vmx/pkvm/pkvm_constants.c
@@ -7,7 +7,7 @@
 #include <linux/bug.h>
 #include <vdso/limits.h>
 #include <buddy_memory.h>
-#include <vmx/vmx.h>
+#include <pkvm.h>
 #include "hyp/pkvm_hyp.h"
 
 int main(void)
-- 
2.25.1

