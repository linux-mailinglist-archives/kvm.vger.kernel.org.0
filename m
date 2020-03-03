Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14C7A176A61
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 03:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbgCCCCo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 21:02:44 -0500
Received: from mga05.intel.com ([192.55.52.43]:54060 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727095AbgCCCCn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 21:02:43 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 18:02:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="440384950"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 02 Mar 2020 18:02:41 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/7] KVM: nVMX: Allow L1 to use 5-level page walks for nested EPT
Date:   Mon,  2 Mar 2020 18:02:36 -0800
Message-Id: <20200303020240.28494-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303020240.28494-1-sean.j.christopherson@intel.com>
References: <20200303020240.28494-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for 5-level nested EPT, and advertise said support in the
EPT capabilities MSR.  KVM's MMU can already handle 5-level legacy page
tables, there's no reason to force an L1 VMM to use shadow paging if it
wants to employ 5-level page tables.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/vmx.h     | 12 ++++++++++++
 arch/x86/kvm/mmu/mmu.c         | 11 ++++++-----
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 arch/x86/kvm/vmx/nested.c      | 21 +++++++++++++++++----
 arch/x86/kvm/vmx/vmx.c         |  3 +--
 5 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 8521af3fef27..5e090d1f03f8 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -500,6 +500,18 @@ enum vmcs_field {
 						 VMX_EPT_EXECUTABLE_MASK)
 #define VMX_EPT_MT_MASK				(7ull << VMX_EPT_MT_EPTE_SHIFT)
 
+static inline u8 vmx_eptp_page_walk_level(u64 eptp)
+{
+	u64 encoded_level = eptp & VMX_EPTP_PWL_MASK;
+
+	if (encoded_level == VMX_EPTP_PWL_5)
+		return 5;
+
+	/* @eptp must be pre-validated by the caller. */
+	WARN_ON_ONCE(encoded_level != VMX_EPTP_PWL_4);
+	return 4;
+}
+
 /* The mask to use to trigger an EPT Misconfiguration in order to track MMIO */
 #define VMX_EPT_MISCONFIG_WX_VALUE		(VMX_EPT_WRITABLE_MASK |       \
 						 VMX_EPT_EXECUTABLE_MASK)
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e94f44f84644..4bd94aeefb4a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4997,14 +4997,14 @@ EXPORT_SYMBOL_GPL(kvm_init_shadow_mmu);
 
 static union kvm_mmu_role
 kvm_calc_shadow_ept_root_page_role(struct kvm_vcpu *vcpu, bool accessed_dirty,
-				   bool execonly)
+				   bool execonly, u8 level)
 {
 	union kvm_mmu_role role = {0};
 
 	/* SMM flag is inherited from root_mmu */
 	role.base.smm = vcpu->arch.root_mmu.mmu_role.base.smm;
 
-	role.base.level = PT64_ROOT_4LEVEL;
+	role.base.level = level;
 	role.base.gpte_is_8_bytes = true;
 	role.base.direct = false;
 	role.base.ad_disabled = !accessed_dirty;
@@ -5028,16 +5028,17 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 			     bool accessed_dirty, gpa_t new_eptp)
 {
 	struct kvm_mmu *context = vcpu->arch.mmu;
+	u8 level = vmx_eptp_page_walk_level(new_eptp);
 	union kvm_mmu_role new_role =
 		kvm_calc_shadow_ept_root_page_role(vcpu, accessed_dirty,
-						   execonly);
+						   execonly, level);
 
 	__kvm_mmu_new_cr3(vcpu, new_eptp, new_role.base, false);
 
 	if (new_role.as_u64 == context->mmu_role.as_u64)
 		return;
 
-	context->shadow_root_level = PT64_ROOT_4LEVEL;
+	context->shadow_root_level = level;
 
 	context->nx = true;
 	context->ept_ad = accessed_dirty;
@@ -5046,7 +5047,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 	context->sync_page = ept_sync_page;
 	context->invlpg = ept_invlpg;
 	context->update_pte = ept_update_pte;
-	context->root_level = PT64_ROOT_4LEVEL;
+	context->root_level = level;
 	context->direct_map = false;
 	context->mmu_role.as_u64 = new_role.as_u64;
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index e4c8a4cbf407..6b15b58f3ecc 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -66,7 +66,7 @@
 	#define PT_GUEST_ACCESSED_SHIFT 8
 	#define PT_HAVE_ACCESSED_DIRTY(mmu) ((mmu)->ept_ad)
 	#define CMPXCHG cmpxchg64
-	#define PT_MAX_FULL_LEVELS 4
+	#define PT_MAX_FULL_LEVELS PT64_ROOT_MAX_LEVEL
 #else
 	#error Invalid PTTYPE value
 #endif
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0946122a8d3b..c9c2d254f316 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2582,9 +2582,19 @@ static bool valid_ept_address(struct kvm_vcpu *vcpu, u64 address)
 		return false;
 	}
 
-	/* only 4 levels page-walk length are valid */
-	if (CC((address & VMX_EPTP_PWL_MASK) != VMX_EPTP_PWL_4))
+	/* Page-walk levels validity. */
+	switch (address & VMX_EPTP_PWL_MASK) {
+	case VMX_EPTP_PWL_5:
+		if (CC(!(vmx->nested.msrs.ept_caps & VMX_EPT_PAGE_WALK_5_BIT)))
+			return false;
+		break;
+	case VMX_EPTP_PWL_4:
+		if (CC(!(vmx->nested.msrs.ept_caps & VMX_EPT_PAGE_WALK_4_BIT)))
+			return false;
+		break;
+	default:
 		return false;
+	}
 
 	/* Reserved bits should not be set */
 	if (CC(address >> maxphyaddr || ((address >> 7) & 0x1f)))
@@ -6129,8 +6139,11 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		/* nested EPT: emulate EPT also to L1 */
 		msrs->secondary_ctls_high |=
 			SECONDARY_EXEC_ENABLE_EPT;
-		msrs->ept_caps = VMX_EPT_PAGE_WALK_4_BIT |
-			 VMX_EPTP_WB_BIT | VMX_EPT_INVEPT_BIT;
+		msrs->ept_caps =
+			VMX_EPT_PAGE_WALK_4_BIT |
+			VMX_EPT_PAGE_WALK_5_BIT |
+			VMX_EPTP_WB_BIT |
+			VMX_EPT_INVEPT_BIT;
 		if (cpu_has_vmx_ept_execute_only())
 			msrs->ept_caps |=
 				VMX_EPT_EXECUTE_ONLY_BIT;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index a04017bdae05..d04efe0f0109 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2985,9 +2985,8 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 
 static int get_ept_level(struct kvm_vcpu *vcpu)
 {
-	/* Nested EPT currently only supports 4-level walks. */
 	if (is_guest_mode(vcpu) && nested_cpu_has_ept(get_vmcs12(vcpu)))
-		return 4;
+		return vmx_eptp_page_walk_level(nested_ept_get_cr3(vcpu));
 	if (cpu_has_vmx_ept_5levels() && (cpuid_maxphyaddr(vcpu) > 48))
 		return 5;
 	return 4;
-- 
2.24.1

