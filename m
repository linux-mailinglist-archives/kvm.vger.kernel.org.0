Return-Path: <kvm+bounces-1016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D5F467E42DA
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:09:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1278D1C2129A
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:09:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 894773589E;
	Tue,  7 Nov 2023 15:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E8eHonsg"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E868131584
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 15:05:18 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E0259E3;
	Tue,  7 Nov 2023 07:01:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369317; x=1730905317;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=H6bofqLvTV8ECGuEAP0F+avzpMANMJu7Req3n68UBbo=;
  b=E8eHonsgrZ9wbpIvZu1Xwd4uWpxCUOX4e6yXGJ5ew+sSnLxTPgI39Sdf
   M1RBs+2kSYTHIIkc6K3R4Z+01qs9A8If9s85mTHHapVdrxGbTdqu6+mA7
   HwMRY/HoeXzrXi/lKnRELcPFs9KRAMIRubdQs98SHkXTX+lPMEFzvh3wy
   3fjRa3GI4REMRTp7hCTRg9K+CeDTUC6jjFA0NaflhvBFJ3w48vcOe666b
   Ix7x8gQU32f5VrPfjGL7bpemsu0iGeULuDMyLJ39MmDcTN8IDC4Gef67d
   li7iiKrN0hpCP4i1aEbXSJgjIcPteurMpAG1UPb3pcsBiU2E0+0JuPTK2
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="2462520"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="2462520"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10851519"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:21 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v17 079/116] KVM: VMX: Modify NMI and INTR handlers to take intr_info as function argument
Date: Tue,  7 Nov 2023 06:56:45 -0800
Message-Id: <07a8bf7ec33a957b846c7a4dd25dfe158e74face.1699368322.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699368322.git.isaku.yamahata@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
index d010c34d2eed..8efc7f15b7f4 100644
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


