Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1258154EAE
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 23:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbgBFWIj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 17:08:39 -0500
Received: from mga14.intel.com ([192.55.52.115]:64211 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727496AbgBFWIi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 17:08:38 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Feb 2020 14:08:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,411,1574150400"; 
   d="scan'208";a="404625088"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 06 Feb 2020 14:08:37 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] KVM: nVMX: Allow L1 to use 5-level page walks for nested EPT
Date:   Thu,  6 Feb 2020 14:08:32 -0800
Message-Id: <20200206220836.22743-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200206220836.22743-1-sean.j.christopherson@intel.com>
References: <20200206220836.22743-1-sean.j.christopherson@intel.com>
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
 arch/x86/include/asm/vmx.h | 12 ++++++++++++
 arch/x86/kvm/mmu/mmu.c     | 11 ++++++-----
 arch/x86/kvm/vmx/nested.c  | 21 +++++++++++++++++----
 arch/x86/kvm/vmx/vmx.c     |  3 +--
 4 files changed, 36 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index d716fe938fc0..e77d8a05597d 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -495,6 +495,18 @@ enum vmcs_field {
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
index 84eeb61d06aa..33baa2b79652 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4999,14 +4999,14 @@ EXPORT_SYMBOL_GPL(kvm_init_shadow_mmu);
 
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
@@ -5030,9 +5030,10 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 			     bool accessed_dirty, gpa_t new_eptp)
 {
 	struct kvm_mmu *context = vcpu->arch.mmu;
+	u8 level = vmx_eptp_page_walk_level(new_eptp);
 	union kvm_mmu_role new_role =
 		kvm_calc_shadow_ept_root_page_role(vcpu, accessed_dirty,
-						   execonly);
+						   execonly, level);
 
 	__kvm_mmu_new_cr3(vcpu, new_eptp, new_role.base, false);
 
@@ -5040,7 +5041,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 	if (new_role.as_u64 == context->mmu_role.as_u64)
 		return;
 
-	context->shadow_root_level = PT64_ROOT_4LEVEL;
+	context->shadow_root_level = level;
 
 	context->nx = true;
 	context->ept_ad = accessed_dirty;
@@ -5049,7 +5050,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 	context->sync_page = ept_sync_page;
 	context->invlpg = ept_invlpg;
 	context->update_pte = ept_update_pte;
-	context->root_level = PT64_ROOT_4LEVEL;
+	context->root_level = level;
 	context->direct_map = false;
 	context->mmu_role.as_u64 = new_role.as_u64;
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 95b3f4306ac2..11f98ee10ac5 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2581,9 +2581,19 @@ static bool valid_ept_address(struct kvm_vcpu *vcpu, u64 address)
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
@@ -6056,8 +6066,11 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps,
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
index 46161f4e4b42..da70ef12266c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2970,9 +2970,8 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 
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

