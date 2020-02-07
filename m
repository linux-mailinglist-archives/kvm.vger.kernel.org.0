Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55A6A155CF9
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 18:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbgBGRhw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 12:37:52 -0500
Received: from mga06.intel.com ([134.134.136.31]:53094 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727138AbgBGRhv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 12:37:51 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Feb 2020 09:37:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,414,1574150400"; 
   d="scan'208";a="346067542"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 07 Feb 2020 09:37:50 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/7] KVM: nVMX: Rename EPTP validity helper and associated variables
Date:   Fri,  7 Feb 2020 09:37:45 -0800
Message-Id: <20200207173747.6243-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200207173747.6243-1-sean.j.christopherson@intel.com>
References: <20200207173747.6243-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename valid_ept_address() to nested_vmx_check_eptp() to follow the nVMX
nomenclature and to reflect that the function now checks a lot more than
just the address contained in the EPTP.  Rename address to new_eptp in
associated code.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1a5db5f64352..4fb05c0e29fe 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2562,13 +2562,13 @@ static int nested_vmx_check_nmi_controls(struct vmcs12 *vmcs12)
 	return 0;
 }
 
-static bool valid_ept_address(struct kvm_vcpu *vcpu, u64 address)
+static bool nested_vmx_check_eptp(struct kvm_vcpu *vcpu, u64 new_eptp)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	int maxphyaddr = cpuid_maxphyaddr(vcpu);
 
 	/* Check for memory type validity */
-	switch (address & VMX_EPTP_MT_MASK) {
+	switch (new_eptp & VMX_EPTP_MT_MASK) {
 	case VMX_EPTP_MT_UC:
 		if (CC(!(vmx->nested.msrs.ept_caps & VMX_EPTP_UC_BIT)))
 			return false;
@@ -2582,7 +2582,7 @@ static bool valid_ept_address(struct kvm_vcpu *vcpu, u64 address)
 	}
 
 	/* Page-walk levels validity. */
-	switch (address & VMX_EPTP_PWL_MASK) {
+	switch (new_eptp & VMX_EPTP_PWL_MASK) {
 	case VMX_EPTP_PWL_5:
 		if (CC(!(vmx->nested.msrs.ept_caps & VMX_EPT_PAGE_WALK_5_BIT)))
 			return false;
@@ -2596,11 +2596,11 @@ static bool valid_ept_address(struct kvm_vcpu *vcpu, u64 address)
 	}
 
 	/* Reserved bits should not be set */
-	if (CC(address >> maxphyaddr || ((address >> 7) & 0x1f)))
+	if (CC(new_eptp >> maxphyaddr || ((new_eptp >> 7) & 0x1f)))
 		return false;
 
 	/* AD, if set, should be supported */
-	if (address & VMX_EPTP_AD_ENABLE_BIT) {
+	if (new_eptp & VMX_EPTP_AD_ENABLE_BIT) {
 		if (CC(!(vmx->nested.msrs.ept_caps & VMX_EPT_AD_BIT)))
 			return false;
 	}
@@ -2649,7 +2649,7 @@ static int nested_check_vm_execution_controls(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 	if (nested_cpu_has_ept(vmcs12) &&
-	    CC(!valid_ept_address(vcpu, vmcs12->ept_pointer)))
+	    CC(!nested_vmx_check_eptp(vcpu, vmcs12->ept_pointer)))
 		return -EINVAL;
 
 	if (nested_cpu_has_vmfunc(vmcs12)) {
@@ -5188,7 +5188,7 @@ static int nested_vmx_eptp_switching(struct kvm_vcpu *vcpu,
 				     struct vmcs12 *vmcs12)
 {
 	u32 index = kvm_rcx_read(vcpu);
-	u64 address;
+	u64 new_eptp;
 	bool accessed_dirty;
 	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
 
@@ -5201,23 +5201,23 @@ static int nested_vmx_eptp_switching(struct kvm_vcpu *vcpu,
 
 
 	if (kvm_vcpu_read_guest_page(vcpu, vmcs12->eptp_list_address >> PAGE_SHIFT,
-				     &address, index * 8, 8))
+				     &new_eptp, index * 8, 8))
 		return 1;
 
-	accessed_dirty = !!(address & VMX_EPTP_AD_ENABLE_BIT);
+	accessed_dirty = !!(new_eptp & VMX_EPTP_AD_ENABLE_BIT);
 
 	/*
 	 * If the (L2) guest does a vmfunc to the currently
 	 * active ept pointer, we don't have to do anything else
 	 */
-	if (vmcs12->ept_pointer != address) {
-		if (!valid_ept_address(vcpu, address))
+	if (vmcs12->ept_pointer != new_eptp) {
+		if (!nested_vmx_check_eptp(vcpu, new_eptp))
 			return 1;
 
 		kvm_mmu_unload(vcpu);
 		mmu->ept_ad = accessed_dirty;
 		mmu->mmu_role.base.ad_disabled = !accessed_dirty;
-		vmcs12->ept_pointer = address;
+		vmcs12->ept_pointer = new_eptp;
 		/*
 		 * TODO: Check what's the correct approach in case
 		 * mmu reload fails. Currently, we just let the next
-- 
2.24.1

