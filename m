Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A378B1AB01D
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 19:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1416535AbgDORzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Apr 2020 13:55:40 -0400
Received: from mga14.intel.com ([192.55.52.115]:26430 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440927AbgDORz2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Apr 2020 13:55:28 -0400
IronPort-SDR: GVDve5BPv8QyC3VGM1+LiHVeM5YffHki+/tVt0iSM61f8m9v3dEiXOK7SaSKd2/R/O2NThOWH0
 r9uvKMCwp0Ig==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2020 10:55:22 -0700
IronPort-SDR: NX0simyYSQcxn3Xrg50DsJPrFfL9ZUBEoIAoxUUaBmsUcx/eTNSFPPpythjvLGee+7u8FUOOjW
 qDby75eUUCbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,387,1580803200"; 
   d="scan'208";a="332567350"
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
Subject: [PATCH v2 04/10] KVM: nVMX: Move nested VM-Exit tracepoint into nested_vmx_reflect_vmexit()
Date:   Wed, 15 Apr 2020 10:55:13 -0700
Message-Id: <20200415175519.14230-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200415175519.14230-1-sean.j.christopherson@intel.com>
References: <20200415175519.14230-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the tracepoint for nested VM-Exits in preparation of splitting the
reflection logic into L1 wants the exit vs. L0 always handles the exit.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index cb7fd78ad9da..de122ef3eeed 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5648,19 +5648,13 @@ static bool nested_vmx_exit_handled_mtf(struct vmcs12 *vmcs12)
  */
 static bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
 {
-	u32 intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
-
-	trace_kvm_nested_vmexit(kvm_rip_read(vcpu), exit_reason,
-				vmcs_readl(EXIT_QUALIFICATION),
-				vmx->idt_vectoring_info,
-				intr_info,
-				vmcs_read32(VM_EXIT_INTR_ERROR_CODE),
-				KVM_ISA_VMX);
+	u32 intr_info;
 
 	switch (exit_reason) {
 	case EXIT_REASON_EXCEPTION_NMI:
+		intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
 		if (is_nmi(intr_info))
 			return false;
 		else if (is_page_fault(intr_info))
@@ -5828,6 +5822,14 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason)
 		goto reflect_vmexit;
 	}
 
+	exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
+	exit_qual = vmcs_readl(EXIT_QUALIFICATION);
+
+	trace_kvm_nested_vmexit(kvm_rip_read(vcpu), exit_reason, exit_qual,
+				vmx->idt_vectoring_info, exit_intr_info,
+				vmcs_read32(VM_EXIT_INTR_ERROR_CODE),
+				KVM_ISA_VMX);
+
 	if (!nested_vmx_exit_reflected(vcpu, exit_reason))
 		return false;
 
@@ -5838,7 +5840,6 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason)
 	 */
 	WARN_ON(exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT);
 
-	exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
 	if ((exit_intr_info &
 	     (INTR_INFO_VALID_MASK | INTR_INFO_DELIVER_CODE_MASK)) ==
 	    (INTR_INFO_VALID_MASK | INTR_INFO_DELIVER_CODE_MASK)) {
@@ -5847,7 +5848,6 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason)
 		vmcs12->vm_exit_intr_error_code =
 			vmcs_read32(VM_EXIT_INTR_ERROR_CODE);
 	}
-	exit_qual = vmcs_readl(EXIT_QUALIFICATION);
 
 reflect_vmexit:
 	nested_vmx_vmexit(vcpu, exit_reason, exit_intr_info, exit_qual);
-- 
2.26.0

