Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09538220333
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 06:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728232AbgGOEGW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 00:06:22 -0400
Received: from mga17.intel.com ([192.55.52.151]:16671 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgGOEGD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 00:06:03 -0400
IronPort-SDR: aipBzOJaBJz0bNzeZDTaUcoYiBrOu0MFfNLR8ngP1sEChmv2H93zE3cyxvUjZwi/0Ss8w2Od4X
 mydyhdB/uf9g==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="129167483"
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="129167483"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 21:06:02 -0700
IronPort-SDR: 3/tSJsbV1kth+vL90NuOXt0MSE1ewk2QrNAiCMgDJC3UycF1FqgaDyB7SVNU0XISNwRPML4NPA
 e3DxAv+fqbiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="485587020"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga006.fm.intel.com with ESMTP; 14 Jul 2020 21:06:02 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dan Cross <dcross@google.com>,
        Peter Shier <pshier@google.com>
Subject: [PATCH 4/7] KVM: nVMX: Move free_nested() below vmx_switch_vmcs()
Date:   Tue, 14 Jul 2020 21:05:54 -0700
Message-Id: <20200715040557.5889-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200715040557.5889-1-sean.j.christopherson@intel.com>
References: <20200715040557.5889-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
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
index 7d4457aaab2ef..e9b27c6478da3 100644
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
2.26.0

