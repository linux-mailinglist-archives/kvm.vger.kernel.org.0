Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF5C514F99F
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 19:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbgBASwl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 13:52:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:11283 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727275AbgBASwe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 13:52:34 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 10:52:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,390,1574150400"; 
   d="scan'208";a="248075604"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga002.jf.intel.com with ESMTP; 01 Feb 2020 10:52:26 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 58/61] KVM: x86/mmu: Configure max page level during hardware setup
Date:   Sat,  1 Feb 2020 10:52:15 -0800
Message-Id: <20200201185218.24473-59-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200201185218.24473-1-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
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

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +--
 arch/x86/kvm/mmu/mmu.c          | 13 +++++++++++--
 arch/x86/kvm/svm.c              |  9 +--------
 arch/x86/kvm/vmx/vmx.c          | 24 +++++++++++-------------
 4 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1a13a53bbaeb..4165d3ef11e4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1142,7 +1142,6 @@ struct kvm_x86_ops {
 	int (*set_identity_map_addr)(struct kvm *kvm, u64 ident_addr);
 	int (*get_tdp_level)(struct kvm_vcpu *vcpu);
 	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
-	int (*get_lpage_level)(void);
 
 	void (*set_tdp_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
 
@@ -1494,7 +1493,7 @@ void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva);
 void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid);
 void kvm_mmu_new_cr3(struct kvm_vcpu *vcpu, gpa_t new_cr3, bool skip_tlb_flush);
 
-void kvm_configure_mmu(bool enable_tdp);
+void kvm_configure_mmu(bool enable_tdp, int tdp_page_level);
 
 static inline gpa_t translate_gpa(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
 				  struct x86_exception *exception)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 08c80c7c88d4..1aedb71e7a20 100644
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
@@ -3280,7 +3282,7 @@ static int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 	if (!slot)
 		return PT_PAGE_TABLE_LEVEL;
 
-	max_level = min(max_level, kvm_x86_ops->get_lpage_level());
+	max_level = min(max_level, max_page_level);
 	for ( ; max_level > PT_PAGE_TABLE_LEVEL; max_level--) {
 		linfo = lpage_info_slot(gfn, slot, max_level);
 		if (!linfo->disallow_lpage)
@@ -5541,9 +5543,16 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_invpcid_gva);
 
-void kvm_configure_mmu(bool enable_tdp)
+void kvm_configure_mmu(bool enable_tdp, int tdp_page_level)
 {
 	tdp_enabled = enable_tdp;
+
+	if (tdp_enabled)
+		max_page_level = tdp_page_level;
+	else if (boot_cpu_has(X86_FEATURE_GBPAGES))
+		max_page_level = PT_PDPE_LEVEL;
+	else
+		max_page_level = PT_DIRECTORY_LEVEL;
 }
 EXPORT_SYMBOL_GPL(kvm_configure_mmu);
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 19dc74ae1efb..76c24b3491f6 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1443,7 +1443,7 @@ static __init int svm_hardware_setup(void)
 	if (npt_enabled && !npt)
 		npt_enabled = false;
 
-	kvm_configure_mmu(npt_enabled);
+	kvm_configure_mmu(npt_enabled, PT_PDPE_LEVEL);
 	pr_info("kvm: Nested Paging %sabled\n", npt_enabled ? "en" : "dis");
 
 	if (nrips) {
@@ -6064,11 +6064,6 @@ static void svm_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
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
@@ -7424,8 +7419,6 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 
 	.get_exit_info = svm_get_exit_info,
 
-	.get_lpage_level = svm_get_lpage_level,
-
 	.cpuid_update = svm_cpuid_update,
 
 	.set_supported_cpuid = svm_set_supported_cpuid,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 59206c22b5e1..3ad24ca692a6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6889,15 +6889,6 @@ static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
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
@@ -7584,7 +7575,7 @@ static __init int hardware_setup(void)
 {
 	unsigned long host_bndcfgs;
 	struct desc_ptr dt;
-	int r, i;
+	int r, i, ept_lpage_level;
 
 	rdmsrl_safe(MSR_EFER, &host_efer);
 
@@ -7677,7 +7668,16 @@ static __init int hardware_setup(void)
 
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
@@ -7855,8 +7855,6 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 
 	.get_exit_info = vmx_get_exit_info,
 
-	.get_lpage_level = vmx_get_lpage_level,
-
 	.cpuid_update = vmx_cpuid_update,
 	.set_supported_cpuid = vmx_set_supported_cpuid,
 
-- 
2.24.1

