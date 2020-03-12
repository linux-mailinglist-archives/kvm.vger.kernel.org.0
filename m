Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCBBF1838DE
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 19:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgCLSp1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 14:45:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:23441 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726683AbgCLSpY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 14:45:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 11:45:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,545,1574150400"; 
   d="scan'208";a="416041235"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 12 Mar 2020 11:45:23 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 04/10] KVM: VMX: Convert local exit_reason to u16 in nested_vmx_exit_reflected()
Date:   Thu, 12 Mar 2020 11:45:15 -0700
Message-Id: <20200312184521.24579-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312184521.24579-1-sean.j.christopherson@intel.com>
References: <20200312184521.24579-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Store only the basic exit reason in the local "exit_reason" variable in
nested_vmx_exit_reflected().  Except for tracing, all references to
exit_reason are expecting to encounter only the basic exit reason.

Opportunistically align the params to nested_vmx_exit_handled_msr().

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index cb05bcbbfc4e..1848ca0116c0 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5374,7 +5374,7 @@ static bool nested_vmx_exit_handled_io(struct kvm_vcpu *vcpu,
  * MSR bitmap. This may be the case even when L0 doesn't use MSR bitmaps.
  */
 static bool nested_vmx_exit_handled_msr(struct kvm_vcpu *vcpu,
-	struct vmcs12 *vmcs12, u32 exit_reason)
+					struct vmcs12 *vmcs12, u16 exit_reason)
 {
 	u32 msr_index = kvm_rcx_read(vcpu);
 	gpa_t bitmap;
@@ -5523,7 +5523,7 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu)
 	u32 intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
-	u32 exit_reason = vmx->exit_reason;
+	u16 exit_reason;
 
 	if (vmx->nested.nested_run_pending)
 		return false;
@@ -5548,13 +5548,15 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu)
 	 */
 	nested_mark_vmcs12_pages_dirty(vcpu);
 
-	trace_kvm_nested_vmexit(kvm_rip_read(vcpu), exit_reason,
+	trace_kvm_nested_vmexit(kvm_rip_read(vcpu), vmx->exit_reason,
 				vmcs_readl(EXIT_QUALIFICATION),
 				vmx->idt_vectoring_info,
 				intr_info,
 				vmcs_read32(VM_EXIT_INTR_ERROR_CODE),
 				KVM_ISA_VMX);
 
+	exit_reason = vmx->exit_reason;
+
 	switch (exit_reason) {
 	case EXIT_REASON_EXCEPTION_NMI:
 		if (is_nmi(intr_info))
-- 
2.24.1

