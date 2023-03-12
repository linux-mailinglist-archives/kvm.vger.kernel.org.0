Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 439786B649A
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 11:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjCLKAd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 06:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjCLJ7g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 05:59:36 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913064FF34
        for <kvm@vger.kernel.org>; Sun, 12 Mar 2023 01:58:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678615120; x=1710151120;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K1KU+819iqp7KTVDrt/GU0TX621dA6leqpJtrsZaTo8=;
  b=mgxZ/k14SBPfNAN+/gSLyus4R6Rtsa5H9BnBhxXweV/fKAuA5QfxdeK2
   sNVtk1BLxm2GJivLtES6j+6uuRDxLHLqGWLeJm7bDUL8k8vD2ZoKK99/M
   6qAj5G3+tFham/fPgmbFXtpdj9nwWwyR1rIKqaiA9Q6G4ekxDzEIyzMbS
   O+GEuICR8J/Old8OUiQRb+Q+VWlvWh1IH5UyQF+tpsHV4XgIpc9zQJnDE
   88917rRpYYCXzqnutpbR2SIc8oCDMhfpw3VdjZN2ovmbj/0GlI+mo+Z80
   kghgwI8b7UL5jzdjHv06OPxnXH7IzPmyyOdZHs6hwaWPQrLqLztkn+zsG
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="339344698"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="339344698"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10646"; a="1007627330"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="1007627330"
Received: from jiechen-ubuntu-dev.sh.intel.com ([10.239.154.150])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 01:56:55 -0800
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     kvm@vger.kernel.org
Cc:     Chuanxiao Dong <chuanxiao.dong@intel.com>,
        Jason Chen CJ <jason.cj.chen@intel.com>
Subject: [RFC PATCH part-6 05/13] pkvm: x86: Introduce vEPT to record guest EPT information
Date:   Mon, 13 Mar 2023 02:03:37 +0800
Message-Id: <20230312180345.1778588-6-jason.cj.chen@intel.com>
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

KVM-high manages a guest EPT for its nested VM, which shall be shadowed
to shadow EPT in pKVM hypervisor.

Introduce a per vcpu pgtable(vEPT) to save the guest EPT related
information from KVM-high when vmwrite(EPTP).

Each time when a vcpu vmwrites to EPTP, pKVM will setup the vEPT
according to the new value or just do nothing if it is the same
with the last one.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
Signed-off-by: Jason Chen CJ <jason.cj.chen@intel.com>
---
 arch/x86/kvm/vmx/pkvm/hyp/ept.c      | 33 ++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/ept.h      | 10 +++++++++
 arch/x86/kvm/vmx/pkvm/hyp/memory.c   |  6 +++++
 arch/x86/kvm/vmx/pkvm/hyp/memory.h   |  1 +
 arch/x86/kvm/vmx/pkvm/hyp/nested.c   | 16 ++++++++++++++
 arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h |  3 +++
 6 files changed, 69 insertions(+)

diff --git a/arch/x86/kvm/vmx/pkvm/hyp/ept.c b/arch/x86/kvm/vmx/pkvm/hyp/ept.c
index 0edea266b8bc..641b8252071e 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/ept.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/ept.c
@@ -297,3 +297,36 @@ int pkvm_shadow_ept_init(struct shadow_ept_desc *desc)
 
 	return 0;
 }
+
+/*
+ * virtual_ept_mm_ops is used as the ops for the ept constructed by
+ * KVM high in host.
+ * The physical address in this ept is the host VM GPA, which is
+ * the same with HPA.
+ */
+struct pkvm_mm_ops virtual_ept_mm_ops = {
+	.phys_to_virt = host_gpa2hva,
+};
+
+void pkvm_guest_ept_deinit(struct shadow_vcpu_state *shadow_vcpu)
+{
+	struct pkvm_pgtable *vept = &shadow_vcpu->vept;
+
+	memset(vept, 0, sizeof(struct pkvm_pgtable));
+}
+
+void pkvm_guest_ept_init(struct shadow_vcpu_state *shadow_vcpu, u64 guest_eptp)
+{
+	/*
+	 * TODO: we just assume guest will use page level the HW supported,
+	 * it actually need align with KVM high
+	 */
+	struct pkvm_pgtable_cap cap = {
+		.level = pkvm_hyp->ept_cap.level,
+		.allowed_pgsz = pkvm_hyp->ept_cap.allowed_pgsz,
+		.table_prot = pkvm_hyp->ept_cap.table_prot,
+	};
+
+	pkvm_pgtable_init(&shadow_vcpu->vept, &virtual_ept_mm_ops, &ept_ops, &cap, false);
+	shadow_vcpu->vept.root_pa = host_gpa2hpa(guest_eptp & SPTE_BASE_ADDR_MASK);
+}
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/ept.h b/arch/x86/kvm/vmx/pkvm/hyp/ept.h
index 7badcb3dd621..420c9c5816e9 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/ept.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/ept.h
@@ -22,5 +22,15 @@ int handle_host_ept_violation(unsigned long gpa);
 int pkvm_shadow_ept_pool_init(void *ept_pool_base, unsigned long ept_pool_pages);
 int pkvm_shadow_ept_init(struct shadow_ept_desc *desc);
 void pkvm_shadow_ept_deinit(struct shadow_ept_desc *desc);
+void pkvm_guest_ept_init(struct shadow_vcpu_state *shadow_vcpu, u64 guest_eptp);
+void pkvm_guest_ept_deinit(struct shadow_vcpu_state *shadow_vcpu);
 
+static inline bool is_valid_eptp(u64 eptp)
+{
+	if (!eptp || (eptp == INVALID_GPA))
+		return false;
+
+	/* TODO: other bits check */
+	return true;
+}
 #endif
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/memory.c b/arch/x86/kvm/vmx/pkvm/hyp/memory.c
index 6a400aef1bd8..43fc39d44c3d 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/memory.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/memory.c
@@ -73,6 +73,12 @@ void *host_gpa2hva(unsigned long gpa)
 	return pkvm_phys_to_virt(gpa);
 }
 
+unsigned long host_gpa2hpa(unsigned long gpa)
+{
+	/* Host VM is using identity mapping so GPA == HPA */
+	return gpa;
+}
+
 extern struct pkvm_pgtable_ops mmu_ops;
 static struct pkvm_mm_ops mm_ops = {
 	.phys_to_virt = host_gpa2hva,
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/memory.h b/arch/x86/kvm/vmx/pkvm/hyp/memory.h
index 4a75d8dff1b3..a95ae5f71841 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/memory.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/memory.h
@@ -22,6 +22,7 @@ bool mem_range_included(struct mem_range *child, struct mem_range *parent);
 
 #include <linux/kvm_host.h>
 void *host_gpa2hva(unsigned long gpa);
+unsigned long host_gpa2hpa(unsigned long gpa);
 int gva2gpa(struct kvm_vcpu *vcpu, gva_t gva, gpa_t *gpa,
 		u32 access, struct x86_exception *exception);
 int read_gva(struct kvm_vcpu *vcpu, gva_t gva, void *addr,
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/nested.c b/arch/x86/kvm/vmx/pkvm/hyp/nested.c
index 429bfe7bb309..68eddb459cfa 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/nested.c
+++ b/arch/x86/kvm/vmx/pkvm/hyp/nested.c
@@ -9,6 +9,7 @@
 #include "nested.h"
 #include "cpu.h"
 #include "vmx.h"
+#include "ept.h"
 #include "debug.h"
 
 /*
@@ -704,6 +705,18 @@ static void nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	}
 }
 
+static void setup_guest_ept(struct shadow_vcpu_state *shadow_vcpu, u64 guest_eptp)
+{
+	struct vmcs12 *vmcs12 = (struct vmcs12 *)shadow_vcpu->cached_vmcs12;
+
+	if (!is_valid_eptp(guest_eptp))
+		pkvm_guest_ept_deinit(shadow_vcpu);
+	else if (vmcs12->ept_pointer != guest_eptp) {
+		pkvm_guest_ept_deinit(shadow_vcpu);
+		pkvm_guest_ept_init(shadow_vcpu, guest_eptp);
+	}
+}
+
 int handle_vmxon(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -908,6 +921,9 @@ int handle_vmwrite(struct kvm_vcpu *vcpu)
 			if (field >= GUEST_ES_AR_BYTES && field <= GUEST_TR_AR_BYTES)
 				value &= 0x1f0ff;
 
+			if (field == EPT_POINTER)
+				setup_guest_ept(cur_shadow_vcpu, value);
+
 			vmcs12_write_any(vmcs12, field, offset, value);
 
 			if (is_emulated_fields(field)) {
diff --git a/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h b/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h
index a1f3644a4a34..f891660d9085 100644
--- a/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h
+++ b/arch/x86/kvm/vmx/pkvm/hyp/pkvm_hyp.h
@@ -41,6 +41,9 @@ struct shadow_vcpu_state {
 
 	struct vcpu_vmx vmx;
 
+	/* represents for the virtual EPT configured by kvm-high */
+	struct pkvm_pgtable vept;
+
 	/* assume vmcs02 is one page */
 	u8 vmcs02[PAGE_SIZE] __aligned(PAGE_SIZE);
 	u8 cached_vmcs12[VMCS12_SIZE] __aligned(PAGE_SIZE);
-- 
2.25.1

