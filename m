Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E108A7CAEE6
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234127AbjJPQRd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233993AbjJPQRJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:17:09 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2411219E;
        Mon, 16 Oct 2023 09:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473016; x=1729009016;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uNytXurDvexruO8dAP3Ojr8UXqvso3ZFfTBW+KSiFx8=;
  b=cMqKBwbR19lcIQmRA1iO9cO1opV1ETRocM4bw3dVP9Bvwm1fLH6s8t+0
   ezoJVg3gQ7C6pML25i6c7/W4rKisER5q2Q/jLFR+4PnaGCrB++VBKEJpc
   TIbz2uKZXd6UgL2kC2r2vlRJ7n/4HIbNjWmVbhYvSl71I5NtLBBTJaOGt
   XkunUXNB9fxrbxYRdZAcV+G8ksF4cLUIplMCdVIN3j6Teacz5FRierN7S
   yT2mqQ02vrMrUgonzE6Fu3vG3ssQ8gpl2y+vPjqThFnOvN65VDhu8oE5g
   zEniCATIBgVEfxFEZZIMHVX0WUMeWgemvfbOFtVlbQgq9ybePreJCOcxM
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="364921783"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="364921783"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="846448125"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="846448125"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:44 -0700
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
Subject: [PATCH v16 049/116] KVM: VMX: Split out guts of EPT violation to common/exposed function
Date:   Mon, 16 Oct 2023 09:14:01 -0700
Message-Id: <3aff9e07610c2f88ab2a99b2aebed9d88779680e.1697471314.git.isaku.yamahata@intel.com>
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
 arch/x86/kvm/vmx/vmx.c    | 25 +++----------------------
 2 files changed, 36 insertions(+), 22 deletions(-)
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
index 0dc56051589e..4ea2f95a554c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -50,6 +50,7 @@
 #include <asm/vmx.h>
 
 #include "capabilities.h"
+#include "common.h"
 #include "cpuid.h"
 #include "hyperv.h"
 #include "kvm_onhyperv.h"
@@ -5780,11 +5781,8 @@ static int handle_task_switch(struct kvm_vcpu *vcpu)
 
 static int handle_ept_violation(struct kvm_vcpu *vcpu)
 {
-	unsigned long exit_qualification;
+	unsigned long exit_qualification = vmx_get_exit_qual(vcpu);
 	gpa_t gpa;
-	u64 error_code;
-
-	exit_qualification = vmx_get_exit_qual(vcpu);
 
 	/*
 	 * EPT violation happened while executing iret from NMI,
@@ -5799,23 +5797,6 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 
 	gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
 	trace_kvm_page_fault(vcpu, gpa, exit_qualification);
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
@@ -5829,7 +5810,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 	if (unlikely(allow_smaller_maxphyaddr && kvm_vcpu_is_illegal_gpa(vcpu, gpa)))
 		return kvm_emulate_instruction(vcpu, 0);
 
-	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
+	return __vmx_handle_ept_violation(vcpu, gpa, exit_qualification);
 }
 
 static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
-- 
2.25.1

