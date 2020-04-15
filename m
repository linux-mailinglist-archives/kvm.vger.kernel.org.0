Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D365E1AB043
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 20:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411651AbgDOR7z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 13:59:55 -0400
Received: from mga14.intel.com ([192.55.52.115]:26433 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440838AbgDORz1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 13:55:27 -0400
IronPort-SDR: 6J7Oj7zOEQyyfoKE0hoVRvzB4d6oVze5uvudHuos8RHivlCl8zjpT/kKdupJ+aMwrk353Tlj++
 d4BQWhN27awQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2020 10:55:22 -0700
IronPort-SDR: kWS9u8585CphTfY+LSSOAuZedzr9iIx47OjuEYLf7Mpf1RC3u6uQxUpwk90Owge0nP/rdYg5os
 czUrfE1jc9ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,387,1580803200"; 
   d="scan'208";a="332567337"
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
Subject: [PATCH v2 01/10] KVM: nVMX: Move reflection check into nested_vmx_reflect_vmexit()
Date:   Wed, 15 Apr 2020 10:55:10 -0700
Message-Id: <20200415175519.14230-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200415175519.14230-1-sean.j.christopherson@intel.com>
References: <20200415175519.14230-1-sean.j.christopherson@intel.com>
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

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.h | 16 +++++++++++-----
 arch/x86/kvm/vmx/vmx.c    |  4 ++--
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index e8f4a74f7251..d6112b3e9ecf 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -81,12 +81,16 @@ static inline bool nested_ept_ad_enabled(struct kvm_vcpu *vcpu)
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
@@ -94,6 +98,8 @@ static inline int nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu,
 	 * we need to query the in-kernel LAPIC.
 	 */
 	WARN_ON(exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT);
+
+	exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
 	if ((exit_intr_info &
 	     (INTR_INFO_VALID_MASK | INTR_INFO_DELIVER_CODE_MASK)) ==
 	    (INTR_INFO_VALID_MASK | INTR_INFO_DELIVER_CODE_MASK)) {
@@ -105,7 +111,7 @@ static inline int nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu,
 
 	nested_vmx_vmexit(vcpu, exit_reason, exit_intr_info,
 			  vmcs_readl(EXIT_QUALIFICATION));
-	return 1;
+	return true;
 }
 
 /*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index aa1b8cf7c915..d92ed73b22da 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5905,8 +5905,8 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
 		 */
 		nested_mark_vmcs12_pages_dirty(vcpu);
 
-		if (nested_vmx_exit_reflected(vcpu, exit_reason))
-			return nested_vmx_reflect_vmexit(vcpu, exit_reason);
+		if (nested_vmx_reflect_vmexit(vcpu, exit_reason))
+			return 1;
 	}
 
 	if (exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY) {
-- 
2.26.0

