Return-Path: <kvm+bounces-59304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 37658BB0E8C
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 17:01:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C3D617B3887
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 15:00:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9045B3090D7;
	Wed,  1 Oct 2025 14:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="f7wrumUP"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50757307ADD
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 14:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759330727; cv=none; b=eYeWQJMxAqwF2TKNTU4yIPorwOxEdyKMsvIi6YCBpnHJBAUnXHLj4WJRKqY9jDVrlTOkMgSSybxYW/3sD3+37GfejrHK+101YckRCcAqMHChPwd5Y2QqK0pDvlgwa8Ke6srsz4588hOMauZXM6EOuz1nz0bGvs0fTt7sV//0usA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759330727; c=relaxed/simple;
	bh=CGMcfC36OTSYbmPfj/jQC5cJfDOp207Bq+fccU7iqDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZGjAfEMvs/U9PObpBkRt/yRdb49m505Ruur7SCcmrzWrV4AXZ8U4l4IyudCM1VJmFgrQG/OIu2xcq9kOM5UHkOLsYyx0dd26Ov/AUJxdYFaM/ZbhSWB9rzfMjybxY89sD9avvoZoovxiQrNr/MTjfJJ/XEPTFZguVFN9CY57hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=f7wrumUP; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759330723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+F6Vu+KTu5FASHI0ttB5Ihjm76gIpztWw/dzq8NRVEU=;
	b=f7wrumUPg9nvXSMDQ2+4Wkl4kF5vSloyYZASiA+1Lw9/93D2yy+4iS63tWyUBBxHL8O6CU
	w+OmWtk/qOwJsBWASkIlJv14l6o2Jc2siZE1tgZFO9OazzGERzlGzfnCQ+mDp/Uop8DQaP
	hzhn8mZ7R3LivcBqRmhYcsLlv+tLXvA=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosryahmed@google.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 03/12] KVM: selftests: Extend vmx_close_while_nested_test to cover SVM
Date: Wed,  1 Oct 2025 14:58:07 +0000
Message-ID: <20251001145816.1414855-4-yosry.ahmed@linux.dev>
In-Reply-To: <20251001145816.1414855-1-yosry.ahmed@linux.dev>
References: <20251001145816.1414855-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Yosry Ahmed <yosryahmed@google.com>

Add SVM L1 code to run the nested guest, and allow the test to run with
SVM as well as VMX.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/Makefile.kvm      |  2 +-
 ...ested_test.c => close_while_nested_test.c} | 42 +++++++++++++++----
 2 files changed, 35 insertions(+), 9 deletions(-)
 rename tools/testing/selftests/kvm/x86/{vmx_close_while_nested_test.c => close_while_nested_test.c} (64%)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 6582396518b19..61c6abdc9b36f 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -111,7 +111,7 @@ TEST_GEN_PROGS_x86 += x86/ucna_injection_test
 TEST_GEN_PROGS_x86 += x86/userspace_io_test
 TEST_GEN_PROGS_x86 += x86/userspace_msr_exit_test
 TEST_GEN_PROGS_x86 += x86/vmx_apic_access_test
-TEST_GEN_PROGS_x86 += x86/vmx_close_while_nested_test
+TEST_GEN_PROGS_x86 += x86/close_while_nested_test
 TEST_GEN_PROGS_x86 += x86/vmx_dirty_log_test
 TEST_GEN_PROGS_x86 += x86/vmx_exception_with_invalid_guest_state
 TEST_GEN_PROGS_x86 += x86/vmx_msrs_test
diff --git a/tools/testing/selftests/kvm/x86/vmx_close_while_nested_test.c b/tools/testing/selftests/kvm/x86/close_while_nested_test.c
similarity index 64%
rename from tools/testing/selftests/kvm/x86/vmx_close_while_nested_test.c
rename to tools/testing/selftests/kvm/x86/close_while_nested_test.c
index dad988351493e..cf5f24c83c448 100644
--- a/tools/testing/selftests/kvm/x86/vmx_close_while_nested_test.c
+++ b/tools/testing/selftests/kvm/x86/close_while_nested_test.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * vmx_close_while_nested
+ * close_while_nested_test
  *
  * Copyright (C) 2019, Red Hat, Inc.
  *
@@ -12,6 +12,7 @@
 #include "kvm_util.h"
 #include "processor.h"
 #include "vmx.h"
+#include "svm_util.h"
 
 #include <string.h>
 #include <sys/ioctl.h>
@@ -22,6 +23,8 @@ enum {
 	PORT_L0_EXIT = 0x2000,
 };
 
+#define L2_GUEST_STACK_SIZE 64
+
 static void l2_guest_code(void)
 {
 	/* Exit to L0 */
@@ -29,9 +32,8 @@ static void l2_guest_code(void)
 		     : : [port] "d" (PORT_L0_EXIT) : "rax");
 }
 
-static void l1_guest_code(struct vmx_pages *vmx_pages)
+static void l1_vmx_code(struct vmx_pages *vmx_pages)
 {
-#define L2_GUEST_STACK_SIZE 64
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
 
 	GUEST_ASSERT(prepare_for_vmx_operation(vmx_pages));
@@ -45,19 +47,43 @@ static void l1_guest_code(struct vmx_pages *vmx_pages)
 	GUEST_ASSERT(0);
 }
 
+static void l1_svm_code(struct svm_test_data *svm)
+{
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+
+	/* Prepare the VMCB for L2 execution. */
+	generic_svm_setup(svm, l2_guest_code,
+			  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	run_guest(svm->vmcb, svm->vmcb_gpa);
+	GUEST_ASSERT(0);
+}
+
+static void l1_guest_code(void *data)
+{
+	if (this_cpu_has(X86_FEATURE_VMX))
+		l1_vmx_code(data);
+	else
+		l1_svm_code(data);
+}
+
 int main(int argc, char *argv[])
 {
-	vm_vaddr_t vmx_pages_gva;
+	vm_vaddr_t guest_gva;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 
-	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX) ||
+		     kvm_cpu_has(X86_FEATURE_SVM));
 
 	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
 
-	/* Allocate VMX pages and shared descriptors (vmx_pages). */
-	vcpu_alloc_vmx(vm, &vmx_pages_gva);
-	vcpu_args_set(vcpu, 1, vmx_pages_gva);
+	if (kvm_cpu_has(X86_FEATURE_VMX))
+		vcpu_alloc_vmx(vm, &guest_gva);
+	else
+		vcpu_alloc_svm(vm, &guest_gva);
+
+	vcpu_args_set(vcpu, 1, guest_gva);
 
 	for (;;) {
 		volatile struct kvm_run *run = vcpu->run;
-- 
2.51.0.618.g983fd99d29-goog


