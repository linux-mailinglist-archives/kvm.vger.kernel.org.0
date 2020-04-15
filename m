Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F74C1AB01C
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 19:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415536AbgDORzb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 13:55:31 -0400
Received: from mga14.intel.com ([192.55.52.115]:26432 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440818AbgDORz0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 13:55:26 -0400
IronPort-SDR: 8AqdmUkZaXAazSCe56EUX5p/qLHYsER1XTVYtQ+kVmP7GbvEhlFkcv3vqlo/aQvt4zr+0imOFr
 OhNr2eSUOjUQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2020 10:55:22 -0700
IronPort-SDR: zfGAZ303F//sCntmHIxHvT4Bv2JxWA2y+M4W4aY7YeZ02E5Oe33fpCGd/j6mpTKWSdlrUhswYR
 DK/9qhpTbORg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,387,1580803200"; 
   d="scan'208";a="332567340"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 15 Apr 2020 10:55:22 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 02/10] KVM: nVMX: Uninline nested_vmx_reflect_vmexit(), i.e. move it to nested.c
Date:   Wed, 15 Apr 2020 10:55:11 -0700
Message-Id: <20200415175519.14230-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200415175519.14230-1-sean.j.christopherson@intel.com>
References: <20200415175519.14230-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Uninline nested_vmx_reflect_vmexit() in preparation of refactoring
nested_vmx_exit_reflected() to split up the reflection logic into more
consumable chunks, e.g. VM-Fail vs. L1 wants the exit vs. L0 always
handles the exit.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 34 +++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/nested.h | 36 +-----------------------------------
 2 files changed, 34 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index aca57d8da400..afc8c3538ab3 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5646,7 +5646,7 @@ static bool nested_vmx_exit_handled_mtf(struct vmcs12 *vmcs12)
  * should handle it ourselves in L0 (and then continue L2). Only call this
  * when in is_guest_mode (L2).
  */
-bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
+static bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
 {
 	u32 intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -5813,6 +5813,38 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
 	}
 }
 
+/*
+ * Conditionally reflect a VM-Exit into L1.  Returns %true if the VM-Exit was
+ * reflected into L1.
+ */
+bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason)
+{
+	u32 exit_intr_info;
+
+	if (!nested_vmx_exit_reflected(vcpu, exit_reason))
+		return false;
+
+	/*
+	 * At this point, the exit interruption info in exit_intr_info
+	 * is only valid for EXCEPTION_NMI exits.  For EXTERNAL_INTERRUPT
+	 * we need to query the in-kernel LAPIC.
+	 */
+	WARN_ON(exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT);
+
+	exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
+	if ((exit_intr_info &
+	     (INTR_INFO_VALID_MASK | INTR_INFO_DELIVER_CODE_MASK)) ==
+	    (INTR_INFO_VALID_MASK | INTR_INFO_DELIVER_CODE_MASK)) {
+		struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
+
+		vmcs12->vm_exit_intr_error_code =
+			vmcs_read32(VM_EXIT_INTR_ERROR_CODE);
+	}
+
+	nested_vmx_vmexit(vcpu, exit_reason, exit_intr_info,
+			  vmcs_readl(EXIT_QUALIFICATION));
+	return true;
+}
 
 static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 				struct kvm_nested_state __user *user_kvm_nested_state,
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index d6112b3e9ecf..bd959bd2eb58 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -25,7 +25,7 @@ void nested_vmx_set_vmcs_shadowing_bitmap(void);
 void nested_vmx_free_vcpu(struct kvm_vcpu *vcpu);
 enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 						     bool from_vmentry);
-bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason);
+bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason);
 void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 		       u32 exit_intr_info, unsigned long exit_qualification);
 void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu);
@@ -80,40 +80,6 @@ static inline bool nested_ept_ad_enabled(struct kvm_vcpu *vcpu)
 	return nested_ept_get_eptp(vcpu) & VMX_EPTP_AD_ENABLE_BIT;
 }
 
-/*
- * Conditionally reflect a VM-Exit into L1.  Returns %true if the VM-Exit was
- * reflected into L1.
- */
-static inline bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu,
-					     u32 exit_reason)
-{
-	u32 exit_intr_info;
-
-	if (!nested_vmx_exit_reflected(vcpu, exit_reason))
-		return false;
-
-	/*
-	 * At this point, the exit interruption info in exit_intr_info
-	 * is only valid for EXCEPTION_NMI exits.  For EXTERNAL_INTERRUPT
-	 * we need to query the in-kernel LAPIC.
-	 */
-	WARN_ON(exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT);
-
-	exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
-	if ((exit_intr_info &
-	     (INTR_INFO_VALID_MASK | INTR_INFO_DELIVER_CODE_MASK)) ==
-	    (INTR_INFO_VALID_MASK | INTR_INFO_DELIVER_CODE_MASK)) {
-		struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
-
-		vmcs12->vm_exit_intr_error_code =
-			vmcs_read32(VM_EXIT_INTR_ERROR_CODE);
-	}
-
-	nested_vmx_vmexit(vcpu, exit_reason, exit_intr_info,
-			  vmcs_readl(EXIT_QUALIFICATION));
-	return true;
-}
-
 /*
  * Return the cr0 value that a nested guest would read. This is a combination
  * of the real cr0 used to run the guest (guest_cr0), and the bits shadowed by
-- 
2.26.0

