Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFBBC276043
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 20:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgIWSo5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 14:44:57 -0400
Received: from mga07.intel.com ([134.134.136.100]:14510 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726773AbgIWSoz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 14:44:55 -0400
IronPort-SDR: dt2zHc70Iu124FEdgob2ULPmBh/qHl565TzG1QWzQyjsest6nRzrDuuUYlyMWXBueEtN76fzfW
 ELLggUjNZaLQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="225124479"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="225124479"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 11:44:55 -0700
IronPort-SDR: mbwuOKgc2yOPK25bFniFcAjvPh+thE0mG9RaXY1HSBsoWOomHDR9EHpX7TGpiDM3TSx5sTTHey
 7rkD96mI5O0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="347457660"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Sep 2020 11:44:54 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dan Cross <dcross@google.com>,
        Peter Shier <pshier@google.com>
Subject: [PATCH v2 4/7] KVM: nVMX: Move free_nested() below vmx_switch_vmcs()
Date:   Wed, 23 Sep 2020 11:44:49 -0700
Message-Id: <20200923184452.980-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923184452.980-1-sean.j.christopherson@intel.com>
References: <20200923184452.980-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move free_nested() down below vmx_switch_vmcs() so that a future patch
can do an "emergency" invocation of vmx_switch_vmcs() if vmcs01 is not
the loaded VMCS when freeing nested resources.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 88 +++++++++++++++++++--------------------
 1 file changed, 44 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a50714a86dde..03dddf1b6009 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -233,50 +233,6 @@ static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
 	vmx->nested.hv_evmcs = NULL;
 }
 
-/*
- * Free whatever needs to be freed from vmx->nested when L1 goes down, or
- * just stops using VMX.
- */
-static void free_nested(struct kvm_vcpu *vcpu)
-{
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-
-	if (!vmx->nested.vmxon && !vmx->nested.smm.vmxon)
-		return;
-
-	kvm_clear_request(KVM_REQ_GET_VMCS12_PAGES, vcpu);
-
-	vmx->nested.vmxon = false;
-	vmx->nested.smm.vmxon = false;
-	free_vpid(vmx->nested.vpid02);
-	vmx->nested.posted_intr_nv = -1;
-	vmx->nested.current_vmptr = -1ull;
-	if (enable_shadow_vmcs) {
-		vmx_disable_shadow_vmcs(vmx);
-		vmcs_clear(vmx->vmcs01.shadow_vmcs);
-		free_vmcs(vmx->vmcs01.shadow_vmcs);
-		vmx->vmcs01.shadow_vmcs = NULL;
-	}
-	kfree(vmx->nested.cached_vmcs12);
-	vmx->nested.cached_vmcs12 = NULL;
-	kfree(vmx->nested.cached_shadow_vmcs12);
-	vmx->nested.cached_shadow_vmcs12 = NULL;
-	/* Unpin physical memory we referred to in the vmcs02 */
-	if (vmx->nested.apic_access_page) {
-		kvm_release_page_clean(vmx->nested.apic_access_page);
-		vmx->nested.apic_access_page = NULL;
-	}
-	kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
-	kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map, true);
-	vmx->nested.pi_desc = NULL;
-
-	kvm_mmu_free_roots(vcpu, &vcpu->arch.guest_mmu, KVM_MMU_ROOTS_ALL);
-
-	nested_release_evmcs(vcpu);
-
-	free_loaded_vmcs(&vmx->nested.vmcs02);
-}
-
 static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx,
 				     struct loaded_vmcs *prev)
 {
@@ -315,6 +271,50 @@ static void vmx_switch_vmcs(struct kvm_vcpu *vcpu, struct loaded_vmcs *vmcs)
 	vmx_register_cache_reset(vcpu);
 }
 
+/*
+ * Free whatever needs to be freed from vmx->nested when L1 goes down, or
+ * just stops using VMX.
+ */
+static void free_nested(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if (!vmx->nested.vmxon && !vmx->nested.smm.vmxon)
+		return;
+
+	kvm_clear_request(KVM_REQ_GET_VMCS12_PAGES, vcpu);
+
+	vmx->nested.vmxon = false;
+	vmx->nested.smm.vmxon = false;
+	free_vpid(vmx->nested.vpid02);
+	vmx->nested.posted_intr_nv = -1;
+	vmx->nested.current_vmptr = -1ull;
+	if (enable_shadow_vmcs) {
+		vmx_disable_shadow_vmcs(vmx);
+		vmcs_clear(vmx->vmcs01.shadow_vmcs);
+		free_vmcs(vmx->vmcs01.shadow_vmcs);
+		vmx->vmcs01.shadow_vmcs = NULL;
+	}
+	kfree(vmx->nested.cached_vmcs12);
+	vmx->nested.cached_vmcs12 = NULL;
+	kfree(vmx->nested.cached_shadow_vmcs12);
+	vmx->nested.cached_shadow_vmcs12 = NULL;
+	/* Unpin physical memory we referred to in the vmcs02 */
+	if (vmx->nested.apic_access_page) {
+		kvm_release_page_clean(vmx->nested.apic_access_page);
+		vmx->nested.apic_access_page = NULL;
+	}
+	kvm_vcpu_unmap(vcpu, &vmx->nested.virtual_apic_map, true);
+	kvm_vcpu_unmap(vcpu, &vmx->nested.pi_desc_map, true);
+	vmx->nested.pi_desc = NULL;
+
+	kvm_mmu_free_roots(vcpu, &vcpu->arch.guest_mmu, KVM_MMU_ROOTS_ALL);
+
+	nested_release_evmcs(vcpu);
+
+	free_loaded_vmcs(&vmx->nested.vmcs02);
+}
+
 /*
  * Ensure that the current vmcs of the logical processor is the
  * vmcs01 of the vcpu before calling free_nested().
-- 
2.28.0

