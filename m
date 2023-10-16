Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFD57CAF90
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234362AbjJPQfN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234364AbjJPQeB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:34:01 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514173AAB;
        Mon, 16 Oct 2023 09:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473168; x=1729009168;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yEf3IPjg+bDdjyb1Hf8PTFsGWUMHA165u/euLiyM95Y=;
  b=WjeFOeph/nt5Mu7G3YzLmRzpKb78RmID0YxdYFwV+X9ttIdTCWRZF4FD
   BzQOv/nyOzDZEYBCUy7uhGHq0pnEfZon/HgF+Dp0X0cNRjr4gKKsmdLQ9
   C3cEfya1ChZbhgddXB1cBbxkPefMOunhwE/p7vELfn71Id2re9YaeM60P
   /jSwJKwb9UZ9BrRQHELPK2bmzBeUEEJtJtGMKM6xyHNl4HHgYJlNIJ7lH
   sOQ7o0GxjiqHP8eTkW2h4xZdzdZK0Jcv/qB2c29m68MFdizdtMoOCMatE
   vcuVyyqinD7ukoGbtI4Cvd3d/RcFZosGjETr7RNhwKwPHwQvYJqYnnJoH
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="364921970"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="364921970"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:16:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="846448247"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="846448247"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:58 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v16 079/116] KVM: VMX: Modify NMI and INTR handlers to take intr_info as function argument
Date:   Mon, 16 Oct 2023 09:14:31 -0700
Message-Id: <f8120505f7a414c21b57af28d967c4d8dd38c8e1.1697471314.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697471314.git.isaku.yamahata@intel.com>
References: <cover.1697471314.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
 arch/x86/kvm/vmx/vmx.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 484c3c7b46c8..b1c36525a81a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6913,24 +6913,22 @@ static void handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
 		rdmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
 }
 
-static void handle_exception_irqoff(struct vcpu_vmx *vmx)
+static void handle_exception_irqoff(struct kvm_vcpu *vcpu, u32 intr_info)
 {
-	u32 intr_info = vmx_get_intr_info(&vmx->vcpu);
-
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
 }
 
-static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
+static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu,
+					     u32 intr_info)
 {
-	u32 intr_info = vmx_get_intr_info(vcpu);
 	unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
 	gate_desc *desc = (gate_desc *)host_idt_base + vector;
 
@@ -6953,9 +6951,9 @@ void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 		return;
 
 	if (vmx->exit_reason.basic == EXIT_REASON_EXTERNAL_INTERRUPT)
-		handle_external_interrupt_irqoff(vcpu);
+		handle_external_interrupt_irqoff(vcpu, vmx_get_intr_info(vcpu));
 	else if (vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI)
-		handle_exception_irqoff(vmx);
+		handle_exception_irqoff(vcpu, vmx_get_intr_info(vcpu));
 }
 
 /*
-- 
2.25.1

