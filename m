Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7234F4CDE2E
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 21:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiCDUKW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbiCDUHt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:07:49 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D90B2D14F6;
        Fri,  4 Mar 2022 12:02:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646424133; x=1677960133;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8HkNPm4p6ixqVsTq2b6fg8lotfqs570eZGkLrJu+SxI=;
  b=JiuTxZPZvhKSsZnla5h54B7xjyx4sCvBKAlDQ0aDSeY+J2o6qaJfLYtD
   6Ue07ByQHlVZyahUvESXV6wnyC5Vxsw47ybq7lX7sjJZaZlzHSo8WdnNH
   dZ/6TfRFetq7/j4qOEqgspYzEPFrslQ3t6upgRhJ9Tio6hHUXzQYy3/D3
   /sa+oXlo6JYNsVzXPZfJU69wbNbTYZLqm3kHBOkqkDiRQxccCSvPckpZo
   Dnd0u5NnNHqcdkn6YCoZrtlBmW+mDMjHlHJwOPeFrFBj+IE74mPBM7qmS
   SkywEnebNlJdxVBqfqK29DgiksYgZJheeLKApVzB6wS+gGFkgIwRc0+xH
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253983476"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253983476"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:21 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344327"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:21 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 040/104] KVM: VMX: Split out guts of EPT violation to common/exposed function
Date:   Fri,  4 Mar 2022 11:48:56 -0800
Message-Id: <d7ea79b7fbebf723540672bd027d48158fcde0ff.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
---
 arch/x86/kvm/vmx/common.h | 35 +++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c    | 34 ++++++----------------------------
 2 files changed, 41 insertions(+), 28 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/common.h

diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
new file mode 100644
index 000000000000..1052b3c93eb8
--- /dev/null
+++ b/arch/x86/kvm/vmx/common.h
@@ -0,0 +1,35 @@
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
+	error_code |= (exit_qualification &
+		       (EPT_VIOLATION_READABLE | EPT_VIOLATION_WRITABLE |
+			EPT_VIOLATION_EXECUTABLE))
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
index 7838cd177f0e..0edeeed0b4c8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -50,6 +50,7 @@
 #include <asm/vmx.h>
 
 #include "capabilities.h"
+#include "common.h"
 #include "cpuid.h"
 #include "evmcs.h"
 #include "hyperv.h"
@@ -5381,11 +5382,10 @@ static int handle_task_switch(struct kvm_vcpu *vcpu)
 
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
@@ -5394,31 +5394,9 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
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
-	error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) != 0 ?
-	       PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
-
 	vcpu->arch.exit_qualification = exit_qualification;
 
 	/*
@@ -5432,7 +5410,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 	if (unlikely(allow_smaller_maxphyaddr && kvm_vcpu_is_illegal_gpa(vcpu, gpa)))
 		return kvm_emulate_instruction(vcpu, 0);
 
-	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
+	return __vmx_handle_ept_violation(vcpu, gpa, exit_qualification);
 }
 
 static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
-- 
2.25.1

