Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBA13BA57B
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 00:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbhGBWI1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 18:08:27 -0400
Received: from mga17.intel.com ([192.55.52.151]:15270 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233228AbhGBWIC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 18:08:02 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10033"; a="189168370"
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="189168370"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:29 -0700
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="642814839"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:28 -0700
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v2 49/69] KVM: VMX: Modify NMI and INTR handlers to take intr_info as param
Date:   Fri,  2 Jul 2021 15:04:55 -0700
Message-Id: <19efa94306ba82e433602af45d122265fa39b0c4.1625186503.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625186503.git.isaku.yamahata@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Pass intr_info to the NMI and INTR handlers instead of pulling it from
vcpu_vmx in preparation for sharing the bulk of the handlers with TDX.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7ce15a2c3490..e08f85c93e55 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6404,25 +6404,24 @@ static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu,
 	kvm_after_interrupt(vcpu);
 }
 
-static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
+static void handle_exception_nmi_irqoff(struct kvm_vcpu *vcpu, u32 intr_info)
 {
 	const unsigned long nmi_entry = (unsigned long)asm_exc_nmi_noist;
-	u32 intr_info = vmx_get_intr_info(&vmx->vcpu);
 
 	/* if exit due to PF check for async PF */
 	if (is_page_fault(intr_info))
-		vmx->vcpu.arch.apf.host_apf_flags = kvm_read_and_reset_apf_flags();
+		vcpu->arch.apf.host_apf_flags = kvm_read_and_reset_apf_flags();
 	/* Handle machine checks before interrupts are enabled */
 	else if (is_machine_check(intr_info))
 		kvm_machine_check();
 	/* We need to handle NMIs before interrupts are enabled */
 	else if (is_nmi(intr_info))
-		handle_interrupt_nmi_irqoff(&vmx->vcpu, nmi_entry);
+		handle_interrupt_nmi_irqoff(vcpu, nmi_entry);
 }
 
-static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
+static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu,
+					     u32 intr_info)
 {
-	u32 intr_info = vmx_get_intr_info(vcpu);
 	unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
 	gate_desc *desc = (gate_desc *)host_idt_base + vector;
 
@@ -6438,9 +6437,9 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	if (vmx->exit_reason.basic == EXIT_REASON_EXTERNAL_INTERRUPT)
-		handle_external_interrupt_irqoff(vcpu);
+		handle_external_interrupt_irqoff(vcpu, vmx_get_intr_info(vcpu));
 	else if (vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI)
-		handle_exception_nmi_irqoff(vmx);
+		handle_exception_nmi_irqoff(vcpu, vmx_get_intr_info(vcpu));
 }
 
 /*
-- 
2.25.1

