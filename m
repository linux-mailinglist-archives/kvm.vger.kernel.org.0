Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4805358BD78
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242106AbiHGWJM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241875AbiHGWHQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:07:16 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E0FBBC23;
        Sun,  7 Aug 2022 15:03:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909799; x=1691445799;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EWCmz0YPdEkZKaztOqbl2gxRbnZsK1UUdHs5n1fDHWQ=;
  b=BRY1zyte576aA4AfSSbWTSazj0dO6+4MGIk5oLme1/9qTEfc8P5o1Wb8
   EVy7o0QEjPP2zGhnGbRF3CZy0NsWNIJEWeATFOqrqoBVnJi2mahzoZEl2
   6jgw99HqE9yVEIPeeDM8nTekk8byXwW8S2RzwaH+Dj6/ePY0dhWEhwkrc
   Cij+pvHU2WcyGkyM4NQz91UAaIx6bVVkVuqACp5gNwtf3Nhnc0h0sTJ31
   QgxZXFsXlPGtymm382C+02Foch3S+PrGiM7SQfxqe3SHsXvuZC0vl4xQj
   mEpYNxPBVAFLu5kpGyHaArgilZHal2/zsPySq+fipZCE8qDu0pTxOJ1uZ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="289224144"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="289224144"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:36 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682599"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:36 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 048/103] KVM: VMX: Split out guts of EPT violation to common/exposed function
Date:   Sun,  7 Aug 2022 15:01:33 -0700
Message-Id: <43ba6d1e69e8379fa438fbe15f260c94e2ee8f0b.1659854790.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
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
Reviewed-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/vmx/common.h | 33 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c    | 29 +++++------------------------
 2 files changed, 38 insertions(+), 24 deletions(-)
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
index 4a3b3dc5d4d2..3af8cd164274 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -50,6 +50,7 @@
 #include <asm/vmx.h>
 
 #include "capabilities.h"
+#include "common.h"
 #include "cpuid.h"
 #include "evmcs.h"
 #include "hyperv.h"
@@ -5646,11 +5647,10 @@ static int handle_task_switch(struct kvm_vcpu *vcpu)
 
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
@@ -5663,25 +5663,6 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 			(exit_qualification & INTR_INFO_UNBLOCK_NMI))
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
@@ -5695,7 +5676,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 	if (unlikely(allow_smaller_maxphyaddr && kvm_vcpu_is_illegal_gpa(vcpu, gpa)))
 		return kvm_emulate_instruction(vcpu, 0);
 
-	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
+	return __vmx_handle_ept_violation(vcpu, gpa, exit_qualification);
 }
 
 static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
-- 
2.25.1

