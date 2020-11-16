Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABA5C2B4F80
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388565AbgKPSaS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:30:18 -0500
Received: from mga06.intel.com ([134.134.136.31]:20648 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388240AbgKPS2N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:13 -0500
IronPort-SDR: YQbaj94sw+AtP1tvP/5R/h80PGTpyMTZjl0PGRhINPKO+fPE/mfq8Ra4p5E8kWWzDYUv+LoNBW
 U0YEbAhib0Bw==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232410062"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232410062"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:13 -0800
IronPort-SDR: MHJoYFi5Z2B04lQPD5n2C8aTvhG0LAxXfzFdOcOSg7d2aB6iJx111GYsH4ertiuWfguigXDUfX
 eXR3NZzaXBmw==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400528190"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:12 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 44/67] KVM: VMX: Modify NMI and INTR handlers to take intr_info as param
Date:   Mon, 16 Nov 2020 10:26:29 -0800
Message-Id: <ea5bbfb9c889588148f31f8ecb02ac6c4c692dea.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Pass intr_info to the NMI and INTR handlers instead of pulling it from
vcpu_vmx in preparation for sharing the bulk of the handlers with TDX.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 997a391f0842..5d6c3a50230d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6358,25 +6358,21 @@ static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu, u32 intr_info)
 	kvm_after_interrupt(vcpu);
 }
 
-static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
+static void handle_exception_nmi_irqoff(struct kvm_vcpu *vcpu, u32 intr_info)
 {
-	u32 intr_info = vmx_get_intr_info(&vmx->vcpu);
-
 	/* if exit due to PF check for async PF */
 	if (is_page_fault(intr_info))
-		vmx->vcpu.arch.apf.host_apf_flags = kvm_read_and_reset_apf_flags();
+		vcpu->arch.apf.host_apf_flags = kvm_read_and_reset_apf_flags();
 	/* Handle machine checks before interrupts are enabled */
 	else if (is_machine_check(intr_info))
 		kvm_machine_check();
 	/* We need to handle NMIs before interrupts are enabled */
 	else if (is_nmi(intr_info))
-		handle_interrupt_nmi_irqoff(&vmx->vcpu, intr_info);
+		handle_interrupt_nmi_irqoff(vcpu, intr_info);
 }
 
-static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
+static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu, u32 intr_info)
 {
-	u32 intr_info = vmx_get_intr_info(vcpu);
-
 	if (KVM_BUG(!is_external_intr(intr_info), vcpu->kvm,
 	    "KVM: unexpected VM-Exit interrupt info: 0x%x", intr_info))
 		return;
@@ -6389,9 +6385,9 @@ static void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	if (vmx->exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
-		handle_external_interrupt_irqoff(vcpu);
+		handle_external_interrupt_irqoff(vcpu, vmx_get_intr_info(vcpu));
 	else if (vmx->exit_reason == EXIT_REASON_EXCEPTION_NMI)
-		handle_exception_nmi_irqoff(vmx);
+		handle_exception_nmi_irqoff(vcpu, vmx_get_intr_info(vcpu));
 }
 
 static bool vmx_has_emulated_msr(struct kvm *kvm, u32 index)
-- 
2.17.1

