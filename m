Return-Path: <kvm+bounces-60617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4520FBF5158
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 09:51:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 319F95004C9
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 07:50:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7CFC2C21C2;
	Tue, 21 Oct 2025 07:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X6tYdIR1"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86BE02877E6
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 07:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761032921; cv=none; b=Doeqhs3+KBG7OLOru/WRXamcsJ2emFWXOs+SRjb85ugpdqOQ9e8p8TPi5+WQpFJ+/phwn0fZ30KOKVEmftaUD61SPqBcZ186TkwkcghZI1xbIrfEaRtJkkW1sVHZCLeOcQmlSnKd8IKWnZ6ffnoSEo8gt50Nz2CZER5ftP26p38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761032921; c=relaxed/simple;
	bh=rCagEhe5Z1joYR3E+FP00tUc6rHYfQXWv8K7pMjbJ+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3e2bJZzrqRIcnA0icJtWNanC0uSCrLs3Fmagt0mXVsUCw/ke78//bS05V4Q2sDj94AJrr3+3PwvY5sGeNoNWxLDvRG+deUWCg3xyu1ytwBXyU295S3ybkbLDDeqMKTuwE+8hdOrwIECFVBwvOTpqXVmQI50SX+ST5TFb61QzKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=X6tYdIR1; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761032915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JcQR03IuKB4fcV0BsXwSI30gbdeQ80y8fSCq4J5LmSk=;
	b=X6tYdIR1JNgenqWgF7NGDAebOCFz5tOQfuuIwwb4t1vA7hiA/sPsjB5MPpdDxKuDOv50Mt
	R8qTe5WsA/0bdMR3NM37cz/KqK9SupLLxJbDSAKsh4vg++4omekYCCM1Igm40mVqNnHLuK
	m/JerC3UsRchDdkQzc/xNooIFyY0rbE=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v2 07/23] KVM: selftests: Extend vmx_tsc_adjust_test to cover SVM
Date: Tue, 21 Oct 2025 07:47:20 +0000
Message-ID: <20251021074736.1324328-8-yosry.ahmed@linux.dev>
In-Reply-To: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
References: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add SVM L1 code to run the nested guest, and allow the test to run with
SVM as well as VMX.

Reviewed-by: Jim Mattson <jmattson@google.com>

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/Makefile.kvm      |  2 +-
 ...adjust_test.c => nested_tsc_adjust_test.c} | 69 ++++++++++++-------
 2 files changed, 46 insertions(+), 25 deletions(-)
 rename tools/testing/selftests/kvm/x86/{vmx_tsc_adjust_test.c => nested_tsc_adjust_test.c} (61%)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index b78700c574fc7..6625ac53545e8 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -119,7 +119,7 @@ TEST_GEN_PROGS_x86 += x86/vmx_exception_with_invalid_guest_state
 TEST_GEN_PROGS_x86 += x86/vmx_msrs_test
 TEST_GEN_PROGS_x86 += x86/vmx_invalid_nested_guest_state
 TEST_GEN_PROGS_x86 += x86/vmx_la57_nested_state_test
-TEST_GEN_PROGS_x86 += x86/vmx_tsc_adjust_test
+TEST_GEN_PROGS_x86 += x86/nested_tsc_adjust_test
 TEST_GEN_PROGS_x86 += x86/nested_tsc_scaling_test
 TEST_GEN_PROGS_x86 += x86/apic_bus_clock_test
 TEST_GEN_PROGS_x86 += x86/xapic_ipi_test
diff --git a/tools/testing/selftests/kvm/x86/vmx_tsc_adjust_test.c b/tools/testing/selftests/kvm/x86/nested_tsc_adjust_test.c
similarity index 61%
rename from tools/testing/selftests/kvm/x86/vmx_tsc_adjust_test.c
rename to tools/testing/selftests/kvm/x86/nested_tsc_adjust_test.c
index 2dcc0306a0d9b..cc825a0b41dbf 100644
--- a/tools/testing/selftests/kvm/x86/vmx_tsc_adjust_test.c
+++ b/tools/testing/selftests/kvm/x86/nested_tsc_adjust_test.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * vmx_tsc_adjust_test
+ * nested_tsc_adjust_test
  *
  * Copyright (C) 2018, Google LLC.
  *
@@ -22,6 +22,7 @@
 #include "kvm_util.h"
 #include "processor.h"
 #include "vmx.h"
+#include "svm_util.h"
 
 #include <string.h>
 #include <sys/ioctl.h>
@@ -35,6 +36,8 @@
 #define TSC_ADJUST_VALUE (1ll << 32)
 #define TSC_OFFSET_VALUE -(1ll << 48)
 
+#define L2_GUEST_STACK_SIZE 64
+
 enum {
 	PORT_ABORT = 0x1000,
 	PORT_REPORT,
@@ -72,32 +75,47 @@ static void l2_guest_code(void)
 	__asm__ __volatile__("vmcall");
 }
 
-static void l1_guest_code(struct vmx_pages *vmx_pages)
+static void l1_guest_code(void *data)
 {
-#define L2_GUEST_STACK_SIZE 64
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
-	uint32_t control;
 
+	/* Set TSC from L1 and make sure TSC_ADJUST is updated correctly */
 	GUEST_ASSERT(rdtsc() < TSC_ADJUST_VALUE);
 	wrmsr(MSR_IA32_TSC, rdtsc() - TSC_ADJUST_VALUE);
 	check_ia32_tsc_adjust(-1 * TSC_ADJUST_VALUE);
 
-	GUEST_ASSERT(prepare_for_vmx_operation(vmx_pages));
-	GUEST_ASSERT(load_vmcs(vmx_pages));
-
-	/* Prepare the VMCS for L2 execution. */
-	prepare_vmcs(vmx_pages, l2_guest_code,
-		     &l2_guest_stack[L2_GUEST_STACK_SIZE]);
-	control = vmreadz(CPU_BASED_VM_EXEC_CONTROL);
-	control |= CPU_BASED_USE_MSR_BITMAPS | CPU_BASED_USE_TSC_OFFSETTING;
-	vmwrite(CPU_BASED_VM_EXEC_CONTROL, control);
-	vmwrite(TSC_OFFSET, TSC_OFFSET_VALUE);
-
-	GUEST_ASSERT(!vmlaunch());
-	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
+	/*
+	 * Run L2 with TSC_OFFSET. L2 will write to TSC, and L1 is not
+	 * intercepting the write so it should update L1's TSC_ADJUST.
+	 */
+	if (this_cpu_has(X86_FEATURE_VMX)) {
+		struct vmx_pages *vmx_pages = data;
+		uint32_t control;
+
+		GUEST_ASSERT(prepare_for_vmx_operation(vmx_pages));
+		GUEST_ASSERT(load_vmcs(vmx_pages));
+
+		prepare_vmcs(vmx_pages, l2_guest_code,
+			     &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+		control = vmreadz(CPU_BASED_VM_EXEC_CONTROL);
+		control |= CPU_BASED_USE_MSR_BITMAPS | CPU_BASED_USE_TSC_OFFSETTING;
+		vmwrite(CPU_BASED_VM_EXEC_CONTROL, control);
+		vmwrite(TSC_OFFSET, TSC_OFFSET_VALUE);
+
+		GUEST_ASSERT(!vmlaunch());
+		GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
+	} else {
+		struct svm_test_data *svm = data;
+
+		generic_svm_setup(svm, l2_guest_code,
+				  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+		svm->vmcb->control.tsc_offset = TSC_OFFSET_VALUE;
+		run_guest(svm->vmcb, svm->vmcb_gpa);
+		GUEST_ASSERT(svm->vmcb->control.exit_code == SVM_EXIT_VMMCALL);
+	}
 
 	check_ia32_tsc_adjust(-2 * TSC_ADJUST_VALUE);
-
 	GUEST_DONE();
 }
 
@@ -109,16 +127,19 @@ static void report(int64_t val)
 
 int main(int argc, char *argv[])
 {
-	vm_vaddr_t vmx_pages_gva;
+	vm_vaddr_t nested_gva;
 	struct kvm_vcpu *vcpu;
 
-	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX) ||
+		     kvm_cpu_has(X86_FEATURE_SVM));
 
-	vm = vm_create_with_one_vcpu(&vcpu, (void *) l1_guest_code);
+	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
+	if (kvm_cpu_has(X86_FEATURE_VMX))
+		vcpu_alloc_vmx(vm, &nested_gva);
+	else
+		vcpu_alloc_svm(vm, &nested_gva);
 
-	/* Allocate VMX pages and shared descriptors (vmx_pages). */
-	vcpu_alloc_vmx(vm, &vmx_pages_gva);
-	vcpu_args_set(vcpu, 1, vmx_pages_gva);
+	vcpu_args_set(vcpu, 1, nested_gva);
 
 	for (;;) {
 		struct ucall uc;
-- 
2.51.0.869.ge66316f041-goog


