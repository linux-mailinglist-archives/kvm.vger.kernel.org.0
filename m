Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7EBA51C71C
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383728AbiEESXR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383337AbiEESTr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:19:47 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 816B518E10;
        Thu,  5 May 2022 11:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651774563; x=1683310563;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eYmfvBfYMquS6jwfZ3SHdNcbFWex4Khf+QLEW+sIm5g=;
  b=m2FidzIGh0E1vo+TmnE8MhYqTXGYV7tSTmm7N5nP845K+TUvkW4paaON
   b/FUnV7ZXGR8Ppcwq7IxxiGx4izRcoT2HqI5uSQOcfnQmtCCiAgAacTNq
   MILzO9iG2bwsRObl6miSFl9JXSlwYJe5qq3YCpSMmnQUzCD0SlM4UhAeb
   tBx+QGBTgeErrgt82xViBn4Hdak22ri5o4wY/FlMNjT3UoWJKFgr4lq72
   K9Fug5XAwrJCTbvaHM6Pdh0+P/5/L09GDM89N5KT+eF+af8606Bv2Fju2
   q9FCLEt8U/mG36cmBufD2W1GM5oyI1BDtl8brV2m1tpb4lZ/5URKL9gBL
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="248742041"
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="248742041"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:48 -0700
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="665083321"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:47 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH v6 051/104] KVM: VMX: Split out guts of EPT violation to common/exposed function
Date:   Thu,  5 May 2022 11:14:45 -0700
Message-Id: <edf100867cc00bd9038dd5fca7f63fab750b93b1.1651774250.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651774250.git.isaku.yamahata@intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

The difference of TDX EPT violation is how to retrieve information, GPA,
and exit qualification.  To share the code to handle EPT violation, split
out the guts of EPT violation handler so that VMX/TDX exit handler can call
it after retrieving GPA and exit qualification.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/common.h | 33 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c    | 32 ++++++--------------------------
 2 files changed, 39 insertions(+), 26 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/common.h

diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
new file mode 100644
index 000000000000..235908f3e044
--- /dev/null
+++ b/arch/x86/kvm/vmx/common.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __KVM_X86_VMX_COMMON_H
+#define __KVM_X86_VMX_COMMON_H
+
+#include <linux/kvm_host.h>
+
+#include "mmu.h"
+
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
+	error_code |= (exit_qualification & EPT_VIOLATION_RWX_MASK)
+		      ? PFERR_PRESENT_MASK : 0;
+
+	error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) != 0 ?
+	       PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
+
+	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
+}
+
+#endif /* __KVM_X86_VMX_COMMON_H */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 60dedae31426..1a2e8d195891 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -50,6 +50,7 @@
 #include <asm/vmx.h>
 
 #include "capabilities.h"
+#include "common.h"
 #include "cpuid.h"
 #include "evmcs.h"
 #include "hyperv.h"
@@ -5513,11 +5514,10 @@ static int handle_task_switch(struct kvm_vcpu *vcpu)
 
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
@@ -5526,29 +5526,9 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
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
-	error_code |= (exit_qualification & EPT_VIOLATION_RWX_MASK)
-		      ? PFERR_PRESENT_MASK : 0;
-
-	error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) != 0 ?
-	       PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
-
 	vcpu->arch.exit_qualification = exit_qualification;
 
 	/*
@@ -5562,7 +5542,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 	if (unlikely(allow_smaller_maxphyaddr && kvm_vcpu_is_illegal_gpa(vcpu, gpa)))
 		return kvm_emulate_instruction(vcpu, 0);
 
-	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
+	return __vmx_handle_ept_violation(vcpu, gpa, exit_qualification);
 }
 
 static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
-- 
2.25.1

