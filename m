Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14400176A67
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 03:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbgCCCDM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 21:03:12 -0500
Received: from mga05.intel.com ([192.55.52.43]:54062 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727097AbgCCCCn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 21:02:43 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 18:02:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="440384958"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 02 Mar 2020 18:02:42 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/7] KVM: nVMX: Rename nested_ept_get_cr3() to nested_ept_get_eptp()
Date:   Mon,  2 Mar 2020 18:02:37 -0800
Message-Id: <20200303020240.28494-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200303020240.28494-1-sean.j.christopherson@intel.com>
References: <20200303020240.28494-1-sean.j.christopherson@intel.com>
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
index c9c2d254f316..f8717c1e4e51 100644
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
index 9aeda46f473e..21d36652f213 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -60,7 +60,7 @@ static inline int vmx_has_valid_vmcs12(struct kvm_vcpu *vcpu)
 		vmx->nested.hv_evmcs;
 }
 
-static inline unsigned long nested_ept_get_cr3(struct kvm_vcpu *vcpu)
+static inline unsigned long nested_ept_get_eptp(struct kvm_vcpu *vcpu)
 {
 	/* return the page table to be shadowed - in our case, EPT12 */
 	return get_vmcs12(vcpu)->ept_pointer;
@@ -68,7 +68,7 @@ static inline unsigned long nested_ept_get_cr3(struct kvm_vcpu *vcpu)
 
 static inline bool nested_ept_ad_enabled(struct kvm_vcpu *vcpu)
 {
-	return nested_ept_get_cr3(vcpu) & VMX_EPTP_AD_ENABLE_BIT;
+	return nested_ept_get_eptp(vcpu) & VMX_EPTP_AD_ENABLE_BIT;
 }
 
 /*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d04efe0f0109..85991f2d9ef0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2986,7 +2986,7 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
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

