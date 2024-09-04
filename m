Return-Path: <kvm+bounces-25813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F4A496AEFE
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 05:16:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 75C0FB228E4
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 03:16:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D411780BEC;
	Wed,  4 Sep 2024 03:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dBtbhDRU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2147D6CDCC;
	Wed,  4 Sep 2024 03:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725419676; cv=none; b=BO3YIusfBXpR0CC6PRKjyw7pyvqpRudM6sZJeXB+yhOjjtIKYqwFwFMgH2/1B5rxXCDOkjppYt0j7Q0jfasQCcIhegq9CiAMQr0e3bCpCPRYhzuw7DtBzp61DPTe9uSyN7OV4SEMC0uvsqqtKYb2JzRY5Uq3VEHzJ2qZaK0bmVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725419676; c=relaxed/simple;
	bh=dJIz3M3DQymfcueoB4QfkdH4fJLqj05YhkoxZc/qRRw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O/EzowXS8+g3lORv9m9m/8TdXtTwc0BDSm5NduBT8fHpq/RYWOAs+xdWHSrAEd5HWelgX5XtVSNcv6FaXvgwm5yphjagbphxD81Jz/WTnZBEa7+qSlDPle6jgJkOU6MyBFUDzSzyz/R/lAv44kngXB0YPtQcj2CG3h3VGP9Jw6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dBtbhDRU; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725419674; x=1756955674;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dJIz3M3DQymfcueoB4QfkdH4fJLqj05YhkoxZc/qRRw=;
  b=dBtbhDRUR/32fxvoKNUUF2TDJYV5E+nLnmW/3SsItHQdwhSzqlGEhpbs
   34lNGkqQcv450k/4fL2T/VVcjacOAazyfr/QXPSGLGkJ1i5/ZYgNsiGbu
   kYXvqtZvC47Vvjml0GYIsD+dWJGEiWLCDgO1c6N6ylQDQYs7qfBTLr5OU
   XFIQTwmAlrC0zEdVU4xJgbo7Y+YzSXXYd0+qes7uwMq8Eku4qWXVRjgmq
   gqxcgKfHxNNOFOqo6nzwod7ZjBRFvphzyZJ1bU7Foo0PAlvEu3PoU2fRl
   sFZTV+DaQg0/gdUrFCTtzlD9WFCoa3Md+KLOAsILh8b+NFhFMtttxR1oT
   Q==;
X-CSE-ConnectionGUID: wJ2ZBED9SAOcvJ9Z3qKE+Q==
X-CSE-MsgGUID: Sn8lkDxtSki6rZduVkXE8Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="23564637"
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="23564637"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:00 -0700
X-CSE-ConnectionGUID: x5BXQv0NRdqDhTPGtlCUSQ==
X-CSE-MsgGUID: WvSENB9dTYOaxEYMYBWDiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="65106237"
Received: from dgramcko-desk.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.221.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:07:59 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	dmatlack@google.com,
	isaku.yamahata@gmail.com,
	yan.y.zhao@intel.com,
	nik.borisov@suse.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: [PATCH 04/21] KVM: VMX: Split out guts of EPT violation to common/exposed function
Date: Tue,  3 Sep 2024 20:07:34 -0700
Message-Id: <20240904030751.117579-5-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <sean.j.christopherson@intel.com>

The difference of TDX EPT violation is how to retrieve information, GPA,
and exit qualification.  To share the code to handle EPT violation, split
out the guts of EPT violation handler so that VMX/TDX exit handler can call
it after retrieving GPA and exit qualification.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
---
 arch/x86/kvm/vmx/common.h | 34 ++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c    | 25 +++----------------------
 2 files changed, 37 insertions(+), 22 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/common.h

diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
new file mode 100644
index 000000000000..78ae39b6cdcd
--- /dev/null
+++ b/arch/x86/kvm/vmx/common.h
@@ -0,0 +1,34 @@
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
+	if (error_code & EPT_VIOLATION_GVA_IS_VALID)
+		error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) ?
+			      PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
+
+	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
+}
+
+#endif /* __KVM_X86_VMX_COMMON_H */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5e7b5732f35d..ade7666febe9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -53,6 +53,7 @@
 #include <trace/events/ipi.h>
 
 #include "capabilities.h"
+#include "common.h"
 #include "cpuid.h"
 #include "hyperv.h"
 #include "kvm_onhyperv.h"
@@ -5771,11 +5772,8 @@ static int handle_task_switch(struct kvm_vcpu *vcpu)
 
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
@@ -5791,23 +5789,6 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 	gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
 	trace_kvm_page_fault(vcpu, gpa, exit_qualification);
 
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
-	if (error_code & EPT_VIOLATION_GVA_IS_VALID)
-		error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) ?
-			      PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
-
 	/*
 	 * Check that the GPA doesn't exceed physical memory limits, as that is
 	 * a guest page fault.  We have to emulate the instruction here, because
@@ -5819,7 +5800,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 	if (unlikely(allow_smaller_maxphyaddr && !kvm_vcpu_is_legal_gpa(vcpu, gpa)))
 		return kvm_emulate_instruction(vcpu, 0);
 
-	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
+	return __vmx_handle_ept_violation(vcpu, gpa, exit_qualification);
 }
 
 static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
-- 
2.34.1


