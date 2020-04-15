Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006651AB035
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 19:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1416534AbgDORzp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 13:55:45 -0400
Received: from mga18.intel.com ([134.134.136.126]:30605 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440971AbgDORz2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 13:55:28 -0400
IronPort-SDR: GeDD2N3Y/Yzaz+6FAwdmx16qDu87+sO+ZGwnmsYFfhypTB09f+Ow7jHpY/afu3oVU8WfZw2qSl
 rAn5BtyWJSnw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2020 10:55:24 -0700
IronPort-SDR: ogea85NK6Gbmxvg/UmpwMxjLZYQ2b7YqxPeCM176mN4a/z29wRpR93EzGOj0Zm12fkn4ltPylZ
 rFXk6zAMvtOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,387,1580803200"; 
   d="scan'208";a="332567343"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 15 Apr 2020 10:55:23 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v2 03/10] KVM: nVMX: Move VM-Fail check out of nested_vmx_exit_reflected()
Date:   Wed, 15 Apr 2020 10:55:12 -0700
Message-Id: <20200415175519.14230-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200415175519.14230-1-sean.j.christopherson@intel.com>
References: <20200415175519.14230-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check for VM-Fail on nested VM-Enter in nested_vmx_reflect_vmexit() in
preparation for separating nested_vmx_exit_reflected() into separate "L0
wants exit exit" and "L1 wants the exit" helpers.

Explicitly set exit_intr_info and exit_qual to zero instead of reading
them from vmcs02, as they are invalid on VM-Fail (and thankfully ignored
by nested_vmx_vmexit() for nested VM-Fail).

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index afc8c3538ab3..cb7fd78ad9da 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5652,15 +5652,6 @@ static bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 
-	WARN_ON_ONCE(vmx->nested.nested_run_pending);
-
-	if (unlikely(vmx->fail)) {
-		trace_kvm_nested_vmenter_failed(
-			"hardware VM-instruction error: ",
-			vmcs_read32(VM_INSTRUCTION_ERROR));
-		return true;
-	}
-
 	trace_kvm_nested_vmexit(kvm_rip_read(vcpu), exit_reason,
 				vmcs_readl(EXIT_QUALIFICATION),
 				vmx->idt_vectoring_info,
@@ -5819,7 +5810,23 @@ static bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
  */
 bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason)
 {
-	u32 exit_intr_info;
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	u32 exit_intr_info, exit_qual;
+
+	WARN_ON_ONCE(vmx->nested.nested_run_pending);
+
+	/*
+	 * Late nested VM-Fail shares the same flow as nested VM-Exit since KVM
+	 * has already loaded L2's state.
+	 */
+	if (unlikely(vmx->fail)) {
+		trace_kvm_nested_vmenter_failed(
+			"hardware VM-instruction error: ",
+			vmcs_read32(VM_INSTRUCTION_ERROR));
+		exit_intr_info = 0;
+		exit_qual = 0;
+		goto reflect_vmexit;
+	}
 
 	if (!nested_vmx_exit_reflected(vcpu, exit_reason))
 		return false;
@@ -5840,9 +5847,10 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason)
 		vmcs12->vm_exit_intr_error_code =
 			vmcs_read32(VM_EXIT_INTR_ERROR_CODE);
 	}
+	exit_qual = vmcs_readl(EXIT_QUALIFICATION);
 
-	nested_vmx_vmexit(vcpu, exit_reason, exit_intr_info,
-			  vmcs_readl(EXIT_QUALIFICATION));
+reflect_vmexit:
+	nested_vmx_vmexit(vcpu, exit_reason, exit_intr_info, exit_qual);
 	return true;
 }
 
-- 
2.26.0

