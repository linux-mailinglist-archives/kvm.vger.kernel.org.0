Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53DED1768D3
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 01:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727917AbgCBX7n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 18:59:43 -0500
Received: from mga03.intel.com ([134.134.136.65]:17173 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727083AbgCBX52 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 18:57:28 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 15:57:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="243384805"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 02 Mar 2020 15:57:23 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 60/66] KVM: x86/mmu: Configure max page level during hardware setup
Date:   Mon,  2 Mar 2020 15:57:03 -0800
Message-Id: <20200302235709.27467-61-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200302235709.27467-1-sean.j.christopherson@intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Configure the max page level during hardware setup to avoid a retpoline
in the page fault handler.  Drop ->get_lpage_level() as the page fault
handler was the last user.

No functional change intended.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +--
 arch/x86/kvm/mmu/mmu.c          | 20 ++++++++++++++++++--
 arch/x86/kvm/svm.c              |  9 +--------
 arch/x86/kvm/vmx/vmx.c          | 24 +++++++++++-------------
 4 files changed, 31 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 036bb0ddeca3..e0f5607c66b5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1148,7 +1148,6 @@ struct kvm_x86_ops {
 	int (*set_identity_map_addr)(struct kvm *kvm, u64 ident_addr);
 	int (*get_tdp_level)(struct kvm_vcpu *vcpu);
 	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
-	int (*get_lpage_level)(void);
 
 	void (*set_tdp_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
 
@@ -1503,7 +1502,7 @@ void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva);
 void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid);
 void kvm_mmu_new_cr3(struct kvm_vcpu *vcpu, gpa_t new_cr3, bool skip_tlb_flush);
 
-void kvm_configure_mmu(bool enable_tdp);
+void kvm_configure_mmu(bool enable_tdp, int tdp_page_level);
 
 static inline gpa_t translate_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
 				  struct x86_exception *exception)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8e4fe2b13db5..9e4da9f4e34e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -86,6 +86,8 @@ __MODULE_PARM_TYPE(nx_huge_pages_recovery_ratio, "uint");
  */
 bool tdp_enabled = false;
 
+static int max_page_level __read_mostly;
+
 enum {
 	AUDIT_PRE_PAGE_FAULT,
 	AUDIT_POST_PAGE_FAULT,
@@ -3292,7 +3294,7 @@ static int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 	if (!slot)
 		return PT_PAGE_TABLE_LEVEL;
 
-	max_level = min(max_level, kvm_x86_ops->get_lpage_level());
+	max_level = min(max_level, max_page_level);
 	for ( ; max_level > PT_PAGE_TABLE_LEVEL; max_level--) {
 		linfo = lpage_info_slot(gfn, slot, max_level);
 		if (!linfo->disallow_lpage)
@@ -5546,9 +5548,23 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_invpcid_gva);
 
-void kvm_configure_mmu(bool enable_tdp)
+void kvm_configure_mmu(bool enable_tdp, int tdp_page_level)
 {
 	tdp_enabled = enable_tdp;
+
+	/*
+	 * max_page_level reflects the capabilities of KVM's MMU irrespective
+	 * of kernel support, e.g. KVM may be capable of using 1GB pages when
+	 * the kernel is not.  But, KVM never creates a page size greater than
+	 * what is used by the kernel for any given HVA, i.e. the kernel's
+	 * capabilities are ultimately consulted by kvm_mmu_hugepage_adjust().
+	 */
+	if (tdp_enabled)
+		max_page_level = tdp_page_level;
+	else if (boot_cpu_has(X86_FEATURE_GBPAGES))
+		max_page_level = PT_PDPE_LEVEL;
+	else
+		max_page_level = PT_DIRECTORY_LEVEL;
 }
 EXPORT_SYMBOL_GPL(kvm_configure_mmu);
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 75c735c9425c..f32fc3c03667 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1460,7 +1460,7 @@ static __init int svm_hardware_setup(void)
 	if (npt_enabled && !npt)
 		npt_enabled = false;
 
-	kvm_configure_mmu(npt_enabled);
+	kvm_configure_mmu(npt_enabled, PT_PDPE_LEVEL);
 	pr_info("kvm: Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
 
 	if (nrips) {
@@ -6060,11 +6060,6 @@ static void svm_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
 	}
 }
 
-static int svm_get_lpage_level(void)
-{
-	return PT_PDPE_LEVEL;
-}
-
 static bool svm_has_wbinvd_exit(void)
 {
 	return true;
@@ -7420,8 +7415,6 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 
 	.get_exit_info = svm_get_exit_info,
 
-	.get_lpage_level = svm_get_lpage_level,
-
 	.cpuid_update = svm_cpuid_update,
 
 	.set_supported_cpuid = svm_set_supported_cpuid,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d664a3f892b8..f8eb081b63fe 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6909,15 +6909,6 @@ static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	return (cache << VMX_EPT_MT_EPTE_SHIFT) | ipat;
 }
 
-static int vmx_get_lpage_level(void)
-{
-	if (enable_ept && !cpu_has_vmx_ept_1g_page())
-		return PT_DIRECTORY_LEVEL;
-	else
-		/* For shadow and EPT supported 1GB page */
-		return PT_PDPE_LEVEL;
-}
-
 static void vmcs_set_secondary_exec_control(struct vcpu_vmx *vmx)
 {
 	/*
@@ -7649,7 +7640,7 @@ static __init int hardware_setup(void)
 {
 	unsigned long host_bndcfgs;
 	struct desc_ptr dt;
-	int r, i;
+	int r, i, ept_lpage_level;
 
 	rdmsrl_safe(MSR_EFER, &host_efer);
 
@@ -7742,7 +7733,16 @@ static __init int hardware_setup(void)
 
 	if (enable_ept)
 		vmx_enable_tdp();
-	kvm_configure_mmu(enable_ept);
+
+	if (!enable_ept)
+		ept_lpage_level = 0;
+	else if (cpu_has_vmx_ept_1g_page())
+		ept_lpage_level = PT_PDPE_LEVEL;
+	else if (cpu_has_vmx_ept_2m_page())
+		ept_lpage_level = PT_DIRECTORY_LEVEL;
+	else
+		ept_lpage_level = PT_PAGE_TABLE_LEVEL;
+	kvm_configure_mmu(enable_ept, ept_lpage_level);
 
 	/*
 	 * Only enable PML when hardware supports PML feature, and both EPT
@@ -7920,8 +7920,6 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 
 	.get_exit_info = vmx_get_exit_info,
 
-	.get_lpage_level = vmx_get_lpage_level,
-
 	.cpuid_update = vmx_cpuid_update,
 	.set_supported_cpuid = vmx_set_supported_cpuid,
 
-- 
2.24.1

