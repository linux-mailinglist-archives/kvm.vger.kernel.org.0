Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCA71155CF4
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 18:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbgBGRhw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 12:37:52 -0500
Received: from mga06.intel.com ([134.134.136.31]:53093 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727117AbgBGRhv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 12:37:51 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Feb 2020 09:37:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,414,1574150400"; 
   d="scan'208";a="346067538"
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
Subject: [PATCH v2 4/7] KVM: nVMX: Rename nested_ept_get_cr3() to nested_ept_get_eptp()
Date:   Fri,  7 Feb 2020 09:37:44 -0800
Message-Id: <20200207173747.6243-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200207173747.6243-1-sean.j.christopherson@intel.com>
References: <20200207173747.6243-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename the accessor for vmcs12.EPTP to use "eptp" instead of "cr3".  The
accessor has no relation to cr3 whatsoever, other than it being assigned
to the also poorly named kvm_mmu->get_cr3() hook.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 4 ++--
 arch/x86/kvm/vmx/nested.h | 4 ++--
 arch/x86/kvm/vmx/vmx.c    | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d5fc4bfea0e2..1a5db5f64352 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -353,9 +353,9 @@ static void nested_ept_init_mmu_context(struct kvm_vcpu *vcpu)
 			to_vmx(vcpu)->nested.msrs.ept_caps &
 			VMX_EPT_EXECUTE_ONLY_BIT,
 			nested_ept_ad_enabled(vcpu),
-			nested_ept_get_cr3(vcpu));
+			nested_ept_get_eptp(vcpu));
 	vcpu->arch.mmu->set_cr3           = vmx_set_cr3;
-	vcpu->arch.mmu->get_cr3           = nested_ept_get_cr3;
+	vcpu->arch.mmu->get_cr3           = nested_ept_get_eptp;
 	vcpu->arch.mmu->inject_page_fault = nested_ept_inject_page_fault;
 	vcpu->arch.mmu->get_pdptr         = kvm_pdptr_read;
 
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index fc874d4ead0f..9d1c2fc81221 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -59,7 +59,7 @@ static inline int vmx_has_valid_vmcs12(struct kvm_vcpu *vcpu)
 		vmx->nested.hv_evmcs;
 }
 
-static inline unsigned long nested_ept_get_cr3(struct kvm_vcpu *vcpu)
+static inline unsigned long nested_ept_get_eptp(struct kvm_vcpu *vcpu)
 {
 	/* return the page table to be shadowed - in our case, EPT12 */
 	return get_vmcs12(vcpu)->ept_pointer;
@@ -67,7 +67,7 @@ static inline unsigned long nested_ept_get_cr3(struct kvm_vcpu *vcpu)
 
 static inline bool nested_ept_ad_enabled(struct kvm_vcpu *vcpu)
 {
-	return nested_ept_get_cr3(vcpu) & VMX_EPTP_AD_ENABLE_BIT;
+	return nested_ept_get_eptp(vcpu) & VMX_EPTP_AD_ENABLE_BIT;
 }
 
 /*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e6d5c9277ba5..5b4aea535958 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2948,7 +2948,7 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 static int get_ept_level(struct kvm_vcpu *vcpu)
 {
 	if (is_guest_mode(vcpu) && nested_cpu_has_ept(get_vmcs12(vcpu)))
-		return vmx_eptp_page_walk_level(nested_ept_get_cr3(vcpu));
+		return vmx_eptp_page_walk_level(nested_ept_get_eptp(vcpu));
 	if (cpu_has_vmx_ept_5levels() && (cpuid_maxphyaddr(vcpu) > 48))
 		return 5;
 	return 4;
-- 
2.24.1

