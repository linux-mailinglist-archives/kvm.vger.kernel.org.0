Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2125169C3E
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 03:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727287AbgBXCNK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Feb 2020 21:13:10 -0500
Received: from mga06.intel.com ([134.134.136.31]:24747 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727151AbgBXCNI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Feb 2020 21:13:08 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Feb 2020 18:13:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,478,1574150400"; 
   d="scan'208";a="255437207"
Received: from lxy-dell.sh.intel.com ([10.239.13.109])
  by orsmga002.jf.intel.com with ESMTP; 23 Feb 2020 18:13:05 -0800
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH 2/2] kvm: nvmx: Use basic(exit_reason) when checking specific EXIT_REASON
Date:   Mon, 24 Feb 2020 10:07:51 +0800
Message-Id: <20200224020751.1469-3-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20200224020751.1469-1-xiaoyao.li@intel.com>
References: <20200224020751.1469-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the basic exit reason when checking if it equals the specific EXIT
REASON for nested.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 6 +++---
 arch/x86/kvm/vmx/nested.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 657c2eda357c..2746687fd186 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4281,7 +4281,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 		 * message for details.
 		 */
 		if (nested_exit_intr_ack_set(vcpu) &&
-		    exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT &&
+		    basic(exit_reason) == EXIT_REASON_EXTERNAL_INTERRUPT &&
 		    kvm_cpu_has_interrupt(vcpu)) {
 			int irq = kvm_cpu_get_interrupt(vcpu);
 			WARN_ON(irq < 0);
@@ -5321,7 +5321,7 @@ static bool nested_vmx_exit_handled_msr(struct kvm_vcpu *vcpu,
 	 * First we need to figure out which of the four to use:
 	 */
 	bitmap = vmcs12->msr_bitmap;
-	if (exit_reason == EXIT_REASON_MSR_WRITE)
+	if (basic(exit_reason) == EXIT_REASON_MSR_WRITE)
 		bitmap += 2048;
 	if (msr_index >= 0xc0000000) {
 		msr_index -= 0xc0000000;
@@ -5487,7 +5487,7 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
 				vmcs_read32(VM_EXIT_INTR_ERROR_CODE),
 				KVM_ISA_VMX);
 
-	switch (exit_reason) {
+	switch (basic(exit_reason)) {
 	case EXIT_REASON_EXCEPTION_NMI:
 		if (is_nmi(intr_info))
 			return false;
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index fc874d4ead0f..6af2e0dabe94 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -83,7 +83,7 @@ static inline int nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu,
 	 * is only valid for EXCEPTION_NMI exits.  For EXTERNAL_INTERRUPT
 	 * we need to query the in-kernel LAPIC.
 	 */
-	WARN_ON(exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT);
+	WARN_ON(basic(exit_reason) == EXIT_REASON_EXTERNAL_INTERRUPT);
 	if ((exit_intr_info &
 	     (INTR_INFO_VALID_MASK | INTR_INFO_DELIVER_CODE_MASK)) ==
 	    (INTR_INFO_VALID_MASK | INTR_INFO_DELIVER_CODE_MASK)) {
-- 
2.23.0

