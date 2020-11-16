Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704CB2B4F79
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388528AbgKPS34 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:29:56 -0500
Received: from mga06.intel.com ([134.134.136.31]:20648 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388279AbgKPS2O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:14 -0500
IronPort-SDR: 1OC5OsQfz1WMZZtsR6jl+281GQ6D1FZeTv8n5NgxTEq6W13oLszpaWN1JtLhvjAhz/T5C76pHb
 7drPuLJNpCaQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232410065"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232410065"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:14 -0800
IronPort-SDR: 2BaVWLE3VepDjro43gDMggXU3wky1zPXMm1oOA52AJigpjRXLRQ9LvGnWpk3TpbG6oWNsfgQsA
 FyPbUwfkQ4BA==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400528211"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:13 -0800
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
Subject: [RFC PATCH 46/67] KVM: VMX: Split out guts of EPT violation to common/exposed function
Date:   Mon, 16 Nov 2020 10:26:31 -0800
Message-Id: <fbcc4f78f566367a1264ced885a6e646bfde5431.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/common.h | 29 +++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c    | 32 +++++---------------------------
 2 files changed, 34 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index 146f1da9c88d..58edf1296cbd 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -5,8 +5,11 @@
 #include <linux/kvm_host.h>
 
 #include <asm/traps.h>
+#include <asm/vmx.h>
 
+#include "mmu.h"
 #include "vmcs.h"
+#include "vmx.h"
 #include "x86.h"
 
 void vmx_handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu, u32 intr_info);
@@ -51,4 +54,30 @@ static inline void vmx_handle_exception_nmi_irqoff(struct kvm_vcpu *vcpu,
 		vmx_handle_interrupt_nmi_irqoff(vcpu, intr_info);
 }
 
+static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
+					     unsigned long exit_qualification)
+{
+	u64 error_code;
+
+	/* Is it a read fault? */
+	error_code = (exit_qualification & EPT_VIOLATION_ACC_READ)
+		     ? PFERR_USER_MASK : 0;
+	/* Is it a write fault? */
+	error_code |= (exit_qualification & EPT_VIOLATION_ACC_WRITE)
+		      ? PFERR_WRITE_MASK : 0;
+	/* Is it a fetch fault? */
+	error_code |= (exit_qualification & EPT_VIOLATION_ACC_INSTR)
+		      ? PFERR_FETCH_MASK : 0;
+	/* ept page table entry is present? */
+	error_code |= (exit_qualification &
+		       (EPT_VIOLATION_READABLE | EPT_VIOLATION_WRITABLE |
+			EPT_VIOLATION_EXECUTABLE))
+		      ? PFERR_PRESENT_MASK : 0;
+
+	error_code |= (exit_qualification & 0x100) != 0 ?
+	       PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
+
+	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
+}
+
 #endif /* __KVM_X86_VMX_COMMON_H */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e8b60d447e27..0dad9d1816b0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5277,11 +5277,10 @@ static int handle_task_switch(struct kvm_vcpu *vcpu)
 
 static int handle_ept_violation(struct kvm_vcpu *vcpu)
 {
-	unsigned long exit_qualification;
-	gpa_t gpa;
-	u64 error_code;
+	unsigned long exit_qualification = vmx_get_exit_qual(vcpu);
+	gpa_t gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
 
-	exit_qualification = vmx_get_exit_qual(vcpu);
+	trace_kvm_page_fault(gpa, exit_qualification);
 
 	/*
 	 * EPT violation happened while executing iret from NMI,
@@ -5290,30 +5289,9 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 	 * AAK134, BY25.
 	 */
 	if (!(to_vmx(vcpu)->idt_vectoring_info & VECTORING_INFO_VALID_MASK) &&
-			enable_vnmi &&
-			(exit_qualification & INTR_INFO_UNBLOCK_NMI))
+	    enable_vnmi && (exit_qualification & INTR_INFO_UNBLOCK_NMI))
 		vmcs_set_bits(GUEST_INTERRUPTIBILITY_INFO, GUEST_INTR_STATE_NMI);
 
-	gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
-	trace_kvm_page_fault(gpa, exit_qualification);
-
-	/* Is it a read fault? */
-	error_code = (exit_qualification & EPT_VIOLATION_ACC_READ)
-		     ? PFERR_USER_MASK : 0;
-	/* Is it a write fault? */
-	error_code |= (exit_qualification & EPT_VIOLATION_ACC_WRITE)
-		      ? PFERR_WRITE_MASK : 0;
-	/* Is it a fetch fault? */
-	error_code |= (exit_qualification & EPT_VIOLATION_ACC_INSTR)
-		      ? PFERR_FETCH_MASK : 0;
-	/* ept page table entry is present? */
-	error_code |= (exit_qualification &
-		       (EPT_VIOLATION_READABLE | EPT_VIOLATION_WRITABLE |
-			EPT_VIOLATION_EXECUTABLE))
-		      ? PFERR_PRESENT_MASK : 0;
-
-	error_code |= (exit_qualification & 0x100) != 0 ?
-	       PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
 
 	vcpu->arch.exit_qualification = exit_qualification;
 
@@ -5328,7 +5306,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 	if (unlikely(allow_smaller_maxphyaddr && kvm_vcpu_is_illegal_gpa(vcpu, gpa)))
 		return kvm_emulate_instruction(vcpu, 0);
 
-	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
+	return __vmx_handle_ept_violation(vcpu, gpa, exit_qualification);
 }
 
 static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
-- 
2.17.1

