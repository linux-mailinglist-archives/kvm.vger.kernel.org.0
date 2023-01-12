Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF27B667B01
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240038AbjALQhz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:37:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234936AbjALQhR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:37:17 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB22BC83;
        Thu, 12 Jan 2023 08:33:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541219; x=1705077219;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hHXfZWBO3i3gmjASuR43Qbpq072vooXyFmyTXZZjivc=;
  b=bfXukyS2bO62gH+JZSabaSeVp2tpSDNCly+wTcL9APv55HBKlYZ9+e7X
   2BKSSfvZJIv8PSuv/oj7gXU7mtHgiGekCUszm68ykOLNFwGzJWr5TLL36
   5xW90Czz/A/USi1mXLAfsGOXFf9cYhwV3WN+f5M1gFMYVT4dtRL8TerJy
   3VCjgQSPjZw4hRROWSEkeDTG7E05QibKJRr+7baZdG7meLMGo+Nlj1km6
   1TPCDVSUIuHyMIYqAnrXIKChzNMxlVC7sKrjMVfcfG7Y3ZJvg2U8IpzEJ
   I36LRxYjc8zY0jlOxlWv6RjZejHgcxtPBrNSySzvTJqc0AUISkZ1V32nE
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="386089666"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="386089666"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:34 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="726372511"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="726372511"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:34 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v11 081/113] KVM: VMX: Modify NMI and INTR handlers to take intr_info as function argument
Date:   Thu, 12 Jan 2023 08:32:29 -0800
Message-Id: <8fb7861e935b0558bff2948abbb572c83aec40dd.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

TDX uses different ABI to get information about VM exit.  Pass intr_info to
the NMI and INTR handlers instead of pulling it from vcpu_vmx in
preparation for sharing the bulk of the handlers with TDX.

When the guest TD exits to VMM, RAX holds status and exit reason, RCX holds
exit qualification etc rather than the VMCS fields because VMM doesn't have
access to the VMCS.  The eventual code will be

VMX:
  - get exit reason, intr_info, exit_qualification, and etc from VMCS
  - call NMI/INTR handlers (common code)

TDX:
  - get exit reason, intr_info, exit_qualification, and etc from guest
    registers
  - call NMI/INTR handlers (common code)

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmx.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 051952544375..63cff4d02211 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6919,28 +6919,27 @@ static void handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
 		rdmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
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
 	/* if exit due to NM, handle before interrupts are enabled */
 	else if (is_nm_fault(intr_info))
-		handle_nm_fault_irqoff(&vmx->vcpu);
+		handle_nm_fault_irqoff(vcpu);
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
 
@@ -6960,9 +6959,9 @@ void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 		return;
 
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

