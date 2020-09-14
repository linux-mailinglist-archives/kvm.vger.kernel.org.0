Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 829592695F7
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725984AbgINUBj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:01:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:50589 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725914AbgINUBh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:01:37 -0400
IronPort-SDR: 7+CA0aw7tg0OKbj8RsBbvwl5j63WcNm3nWKL+3CXdHiAEArTiKKJHGWKdXGbnvHdp6/KbIFM2U
 VqJbPhqQBswA==
X-IronPort-AV: E=McAfee;i="6000,8403,9744"; a="177217551"
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="177217551"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 12:56:36 -0700
IronPort-SDR: 1sBngLMG2uIaA0kNsAB/h6+y7+8c4K3PGpKIt2UiotLhtGW5snbGxNNE/9tIngUddrJAf9gftL
 bR3yoY6GcMKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,427,1592895600"; 
   d="scan'208";a="287730769"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga008.fm.intel.com with ESMTP; 14 Sep 2020 12:56:36 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/2] KVM: VMX: Invoke NMI handler via indirect call instead of INTn
Date:   Mon, 14 Sep 2020 12:56:34 -0700
Message-Id: <20200914195634.12881-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200914195634.12881-1-sean.j.christopherson@intel.com>
References: <20200914195634.12881-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rework NMI VM-Exit handling to invoke the kernel handler by function
call instead of INTn.  INTn microcode is relatively expensive, and
aligning the IRQ and NMI handling will make it easier to update KVM
should some newfangled method for invoking the handlers come along.

Suggested-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 391f079d9136..b0eca151931d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6411,40 +6411,40 @@ static void vmx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 
 void vmx_do_interrupt_nmi_irqoff(unsigned long entry);
 
+static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu, u32 intr_info)
+{
+	unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
+	gate_desc *desc = (gate_desc *)host_idt_base + vector;
+
+	kvm_before_interrupt(vcpu);
+	vmx_do_interrupt_nmi_irqoff(gate_offset(desc));
+	kvm_after_interrupt(vcpu);
+}
+
 static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
 {
 	u32 intr_info = vmx_get_intr_info(&vmx->vcpu);
 
 	/* if exit due to PF check for async PF */
-	if (is_page_fault(intr_info)) {
+	if (is_page_fault(intr_info))
 		vmx->vcpu.arch.apf.host_apf_flags = kvm_read_and_reset_apf_flags();
 	/* Handle machine checks before interrupts are enabled */
-	} else if (is_machine_check(intr_info)) {
+	else if (is_machine_check(intr_info))
 		kvm_machine_check();
 	/* We need to handle NMIs before interrupts are enabled */
-	} else if (is_nmi(intr_info)) {
-		kvm_before_interrupt(&vmx->vcpu);
-		asm("int $2");
-		kvm_after_interrupt(&vmx->vcpu);
-	}
+	else if (is_nmi(intr_info))
+		handle_interrupt_nmi_irqoff(&vmx->vcpu, intr_info);
 }
 
 static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
 {
-	unsigned int vector;
-	gate_desc *desc;
 	u32 intr_info = vmx_get_intr_info(vcpu);
 
 	if (WARN_ONCE(!is_external_intr(intr_info),
 	    "KVM: unexpected VM-Exit interrupt info: 0x%x", intr_info))
 		return;
 
-	vector = intr_info & INTR_INFO_VECTOR_MASK;
-	desc = (gate_desc *)host_idt_base + vector;
-
-	kvm_before_interrupt(vcpu);
-	vmx_do_interrupt_nmi_irqoff(gate_offset(desc));
-	kvm_after_interrupt(vcpu);
+	handle_interrupt_nmi_irqoff(vcpu, intr_info);
 }
 
 static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
-- 
2.28.0

