Return-Path: <kvm+bounces-9720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1DD9866D5D
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:59:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 008AA1C22EDE
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:59:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1172B7E111;
	Mon, 26 Feb 2024 08:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n7gOygWI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D65C7C0B2;
	Mon, 26 Feb 2024 08:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936136; cv=none; b=RuOUYNWwGuFIcQqDv/0TtVuaO7nFyVIHK4403j5ogr9qdpaVX4+h9tLhduBKOkxo+ink1CtsQAb8FzSfZlg23F+bbiw1KrjnuXQGuGihTMvX7i2rW9RCZdHornL11hrGUKi/CvuCtzKDMbsA23oGwOysq65rDrt1o0gHUCPVXfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936136; c=relaxed/simple;
	bh=IWPbF7kZorjnaCcjYxxog90DbjeIj9s2BnbE9skJqgc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nSqDUYS7EF1kMD7t1+Tjtcp4smWJVrXh3D+5NrJDG9jl3LKhrjxmngOD8lr8YqV8IoiAySgP6aARtTxQpg3FhKv6JEM+uVFnvdoBscGwH7Y4kkDX+jG81acCxUH/SXhVSKmMGZOjyZQBCDku+yiSTwix3Wt4Ie2nTasFA7QYR8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n7gOygWI; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936134; x=1740472134;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IWPbF7kZorjnaCcjYxxog90DbjeIj9s2BnbE9skJqgc=;
  b=n7gOygWI4do3yG7L2pmJfWAc3i5aLceBpHChDsTRUel8KvTOyqw/gq5h
   YUZ1vePOyCBcz8bU4KdBUQvUFmym6hdXl6VVAnFCvTZ3eHuInntqsJ+eq
   om9p8JvxTHuXzHNWbBzM850H6nmuNo3fUE7SlAFEiNCXuNmiot3pJccui
   RFjvDhKQd73GyFgJH49Fo+Lb6I5+Z+VvdXk5uHzcmWYuMt6m95/MQB50w
   /uxE2semFsB9jLEsUSFTnfl6A0/g+fPFdDswxPugOk96ZDSiEFSWzxfMC
   O+ShRPcjI5lsS9nkTjgKnmeVDKveR0hI6oZgEmXIbc07yxRhEA1dfA9w+
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="3069583"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="3069583"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="11272669"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:53 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v19 096/130] KVM: VMX: Move NMI/exception handler to common helper
Date: Mon, 26 Feb 2024 00:26:38 -0800
Message-Id: <b709dc92da98e6bd0ba15c80c1f291beafc9dada.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <sean.j.christopherson@intel.com>

TDX mostly handles NMI/exception exit mostly the same to VMX case.  The
difference is how to retrieve exit qualification.  To share the code with
TDX, move NMI/exception to a common header, common.h.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/common.h | 59 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c    | 68 +++++----------------------------------
 2 files changed, 67 insertions(+), 60 deletions(-)

diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index 6f21d0d48809..632af7a76d0a 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -4,8 +4,67 @@
 
 #include <linux/kvm_host.h>
 
+#include <asm/traps.h>
+
 #include "posted_intr.h"
 #include "mmu.h"
+#include "vmcs.h"
+#include "x86.h"
+
+extern unsigned long vmx_host_idt_base;
+void vmx_do_interrupt_irqoff(unsigned long entry);
+void vmx_do_nmi_irqoff(void);
+
+static inline void vmx_handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Save xfd_err to guest_fpu before interrupt is enabled, so the
+	 * MSR value is not clobbered by the host activity before the guest
+	 * has chance to consume it.
+	 *
+	 * Do not blindly read xfd_err here, since this exception might
+	 * be caused by L1 interception on a platform which doesn't
+	 * support xfd at all.
+	 *
+	 * Do it conditionally upon guest_fpu::xfd. xfd_err matters
+	 * only when xfd contains a non-zero value.
+	 *
+	 * Queuing exception is done in vmx_handle_exit. See comment there.
+	 */
+	if (vcpu->arch.guest_fpu.fpstate->xfd)
+		rdmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
+}
+
+static inline void vmx_handle_exception_irqoff(struct kvm_vcpu *vcpu,
+					       u32 intr_info)
+{
+	/* if exit due to PF check for async PF */
+	if (is_page_fault(intr_info))
+		vcpu->arch.apf.host_apf_flags = kvm_read_and_reset_apf_flags();
+	/* if exit due to NM, handle before interrupts are enabled */
+	else if (is_nm_fault(intr_info))
+		vmx_handle_nm_fault_irqoff(vcpu);
+	/* Handle machine checks before interrupts are enabled */
+	else if (is_machine_check(intr_info))
+		kvm_machine_check();
+}
+
+static inline void vmx_handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu,
+							u32 intr_info)
+{
+	unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
+	gate_desc *desc = (gate_desc *)vmx_host_idt_base + vector;
+
+	if (KVM_BUG(!is_external_intr(intr_info), vcpu->kvm,
+	    "unexpected VM-Exit interrupt info: 0x%x", intr_info))
+		return;
+
+	kvm_before_interrupt(vcpu, KVM_HANDLING_IRQ);
+	vmx_do_interrupt_irqoff(gate_offset(desc));
+	kvm_after_interrupt(vcpu);
+
+	vcpu->arch.at_instruction_boundary = true;
+}
 
 static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
 					     unsigned long exit_qualification)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 29d891e0795e..f8a00a766c40 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -518,7 +518,7 @@ static inline void vmx_segment_cache_clear(struct vcpu_vmx *vmx)
 	vmx->segment_cache.bitmask = 0;
 }
 
-static unsigned long host_idt_base;
+unsigned long vmx_host_idt_base;
 
 #if IS_ENABLED(CONFIG_HYPERV)
 static bool __read_mostly enlightened_vmcs = true;
@@ -4273,7 +4273,7 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
 	vmcs_write16(HOST_SS_SELECTOR, __KERNEL_DS);  /* 22.2.4 */
 	vmcs_write16(HOST_TR_SELECTOR, GDT_ENTRY_TSS*8);  /* 22.2.4 */
 
-	vmcs_writel(HOST_IDTR_BASE, host_idt_base);   /* 22.2.4 */
+	vmcs_writel(HOST_IDTR_BASE, vmx_host_idt_base);   /* 22.2.4 */
 
 	vmcs_writel(HOST_RIP, (unsigned long)vmx_vmexit); /* 22.2.5 */
 
@@ -5166,7 +5166,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 	intr_info = vmx_get_intr_info(vcpu);
 
 	/*
-	 * Machine checks are handled by handle_exception_irqoff(), or by
+	 * Machine checks are handled by vmx_handle_exception_irqoff(), or by
 	 * vmx_vcpu_run() if a #MC occurs on VM-Entry.  NMIs are handled by
 	 * vmx_vcpu_enter_exit().
 	 */
@@ -5174,7 +5174,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 		return 1;
 
 	/*
-	 * Queue the exception here instead of in handle_nm_fault_irqoff().
+	 * Queue the exception here instead of in vmx_handle_nm_fault_irqoff().
 	 * This ensures the nested_vmx check is not skipped so vmexit can
 	 * be reflected to L1 (when it intercepts #NM) before reaching this
 	 * point.
@@ -6889,59 +6889,6 @@ void vmx_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
 	vmcs_write64(EOI_EXIT_BITMAP3, eoi_exit_bitmap[3]);
 }
 
-void vmx_do_interrupt_irqoff(unsigned long entry);
-void vmx_do_nmi_irqoff(void);
-
-static void handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
-{
-	/*
-	 * Save xfd_err to guest_fpu before interrupt is enabled, so the
-	 * MSR value is not clobbered by the host activity before the guest
-	 * has chance to consume it.
-	 *
-	 * Do not blindly read xfd_err here, since this exception might
-	 * be caused by L1 interception on a platform which doesn't
-	 * support xfd at all.
-	 *
-	 * Do it conditionally upon guest_fpu::xfd. xfd_err matters
-	 * only when xfd contains a non-zero value.
-	 *
-	 * Queuing exception is done in vmx_handle_exit. See comment there.
-	 */
-	if (vcpu->arch.guest_fpu.fpstate->xfd)
-		rdmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
-}
-
-static void handle_exception_irqoff(struct kvm_vcpu *vcpu, u32 intr_info)
-{
-	/* if exit due to PF check for async PF */
-	if (is_page_fault(intr_info))
-		vcpu->arch.apf.host_apf_flags = kvm_read_and_reset_apf_flags();
-	/* if exit due to NM, handle before interrupts are enabled */
-	else if (is_nm_fault(intr_info))
-		handle_nm_fault_irqoff(vcpu);
-	/* Handle machine checks before interrupts are enabled */
-	else if (is_machine_check(intr_info))
-		kvm_machine_check();
-}
-
-static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu,
-					     u32 intr_info)
-{
-	unsigned int vector = intr_info & INTR_INFO_VECTOR_MASK;
-	gate_desc *desc = (gate_desc *)host_idt_base + vector;
-
-	if (KVM_BUG(!is_external_intr(intr_info), vcpu->kvm,
-	    "unexpected VM-Exit interrupt info: 0x%x", intr_info))
-		return;
-
-	kvm_before_interrupt(vcpu, KVM_HANDLING_IRQ);
-	vmx_do_interrupt_irqoff(gate_offset(desc));
-	kvm_after_interrupt(vcpu);
-
-	vcpu->arch.at_instruction_boundary = true;
-}
-
 void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -6950,9 +6897,10 @@ void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 		return;
 
 	if (vmx->exit_reason.basic == EXIT_REASON_EXTERNAL_INTERRUPT)
-		handle_external_interrupt_irqoff(vcpu, vmx_get_intr_info(vcpu));
+		vmx_handle_external_interrupt_irqoff(vcpu,
+						     vmx_get_intr_info(vcpu));
 	else if (vmx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI)
-		handle_exception_irqoff(vcpu, vmx_get_intr_info(vcpu));
+		vmx_handle_exception_irqoff(vcpu, vmx_get_intr_info(vcpu));
 }
 
 /*
@@ -8284,7 +8232,7 @@ __init int vmx_hardware_setup(void)
 	int r;
 
 	store_idt(&dt);
-	host_idt_base = dt.address;
+	vmx_host_idt_base = dt.address;
 
 	vmx_setup_user_return_msrs();
 
-- 
2.25.1


