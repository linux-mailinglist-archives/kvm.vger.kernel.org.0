Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A40741838EC
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 19:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgCLSpY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 14:45:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:23434 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726643AbgCLSpY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 14:45:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 11:45:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,545,1574150400"; 
   d="scan'208";a="416041226"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 12 Mar 2020 11:45:22 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 01/10] KVM: nVMX: Move reflection check into nested_vmx_reflect_vmexit()
Date:   Thu, 12 Mar 2020 11:45:12 -0700
Message-Id: <20200312184521.24579-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312184521.24579-1-sean.j.christopherson@intel.com>
References: <20200312184521.24579-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the call to nested_vmx_exit_reflected() from vmx_handle_exit() into
nested_vmx_reflect_vmexit() and change the semantics of the return value
for nested_vmx_reflect_vmexit() to indicate whether or not the exit was
reflected into L1.  nested_vmx_exit_reflected() and
nested_vmx_reflect_vmexit() are intrinsically tied together, calling one
without simultaneously calling the other makes little sense.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.h | 16 +++++++++++-----
 arch/x86/kvm/vmx/vmx.c    |  4 ++--
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 21d36652f213..6bc379cf4755 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -72,12 +72,16 @@ static inline bool nested_ept_ad_enabled(struct kvm_vcpu *vcpu)
 }
 
 /*
- * Reflect a VM Exit into L1.
+ * Conditionally reflect a VM-Exit into L1.  Returns %true if the VM-Exit was
+ * reflected into L1.
  */
-static inline int nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu,
-					    u32 exit_reason)
+static inline bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu,
+					     u32 exit_reason)
 {
-	u32 exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
+	u32 exit_intr_info;
+
+	if (!nested_vmx_exit_reflected(vcpu, exit_reason))
+		return false;
 
 	/*
 	 * At this point, the exit interruption info in exit_intr_info
@@ -85,6 +89,8 @@ static inline int nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu,
 	 * we need to query the in-kernel LAPIC.
 	 */
 	WARN_ON(exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT);
+
+	exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
 	if ((exit_intr_info &
 	     (INTR_INFO_VALID_MASK | INTR_INFO_DELIVER_CODE_MASK)) ==
 	    (INTR_INFO_VALID_MASK | INTR_INFO_DELIVER_CODE_MASK)) {
@@ -96,7 +102,7 @@ static inline int nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu,
 
 	nested_vmx_vmexit(vcpu, exit_reason, exit_intr_info,
 			  vmcs_readl(EXIT_QUALIFICATION));
-	return 1;
+	return true;
 }
 
 /*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 57742ddfd854..c1caac7e8f57 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5863,8 +5863,8 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
 	if (vmx->emulation_required)
 		return handle_invalid_guest_state(vcpu);
 
-	if (is_guest_mode(vcpu) && nested_vmx_exit_reflected(vcpu, exit_reason))
-		return nested_vmx_reflect_vmexit(vcpu, exit_reason);
+	if (is_guest_mode(vcpu) && nested_vmx_reflect_vmexit(vcpu, exit_reason))
+		return 1;
 
 	if (exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY) {
 		dump_vmcs();
-- 
2.24.1

