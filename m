Return-Path: <kvm+bounces-60613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37CC0BF5122
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 09:49:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 22E70467F5A
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 07:49:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E8C3299A9E;
	Tue, 21 Oct 2025 07:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lnmPdlU1"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9934278F4A
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 07:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761032912; cv=none; b=hSClpfbBqSHzl+9i4ia32zSZMyb6wnqEy3s7ltlJRb1dfoguQ7qiz/M9j9UXFV5nVqAEplMKn06tzDmGou3mLY6Q5cpAXcYLsrUmgFFYo2JxlzmNgAN+L+gb1XlTaPFzBNVXEQLjkgzYhUjJ4XW7h7ne3gDu1/k6uxx8zJ1Rmes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761032912; c=relaxed/simple;
	bh=6Jx1MhM217SwZM+cxtA/ojGcBN3OS49NXF1+7zwaxDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h8kXScegRdCVMkJRKjXs0xpsaps55fWZiyuWx1INc0fLs7f6epRREZjdyU/xLw+FyDzLWY5wt1fHYpXuLxDe8VrmNNAhzN0nVByx3OoaZ509+MdCxM40JL3SM/H/IMMOisUYBnbSZfDLLLyn2ITSyDvOOjZ+l9lHAuQTml6j+Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lnmPdlU1; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761032907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lW5vlmOxiZfXmXD5G5Wy/XGpsW60h81v/HMTtKxjkGI=;
	b=lnmPdlU1V1Fm94d0Yc+TPQrV25Nlwn44sSXVKYerSrS9OaeMf7zp+emR3q3duM5sRbyqvE
	93L310s0UF7UZeFGwd+s86aHI/CrNCz9OfqKUDRC3roVA0iJcODL72uv8vnL00K5cqOAGd
	An+hdvSr1xzD2qfKdkH0S/firAqmI0Y=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v2 03/23] KVM: selftests: Extend vmx_close_while_nested_test to cover SVM
Date: Tue, 21 Oct 2025 07:47:16 +0000
Message-ID: <20251021074736.1324328-4-yosry.ahmed@linux.dev>
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
 ...ested_test.c => close_while_nested_test.c} | 42 +++++++++++++++----
 2 files changed, 35 insertions(+), 9 deletions(-)
 rename tools/testing/selftests/kvm/x86/{vmx_close_while_nested_test.c => close_while_nested_test.c} (64%)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index acfa22206e6f3..e70a844a52bdc 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -112,7 +112,7 @@ TEST_GEN_PROGS_x86 += x86/ucna_injection_test
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
2.51.0.869.ge66316f041-goog


