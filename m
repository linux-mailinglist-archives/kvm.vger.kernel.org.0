Return-Path: <kvm+bounces-60615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 882EFBF5119
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 09:49:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5309618C681B
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 07:50:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06CE32BE03B;
	Tue, 21 Oct 2025 07:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Gct4AoJk"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6420A28D83D
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 07:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761032917; cv=none; b=A5uqfIN15XPpqzTz5Z9NhI9C5aiYFJdun26usp53a6IjQ/88UvwuSr3GQmrLVkEi7ifdN3OrbP45uBL9+FB5+LJ3kU/gnGFD0ve64Rqntvaza96YkJNIDiFK1DvVCv3blooNt//dTKwFBTEMSiHTiABVSlKgd0aXTZq6xqCQrmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761032917; c=relaxed/simple;
	bh=cvs3HMhN6GheOAwab4ch6RvRzc8y2IIlbw2Kq3Nf/HA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mdzKXbdqDnbbDQLul6WIFYg/BuC2qO86svzRaMFp9K1sCAgK2+UXUm6DsfRWas6oeI0TGbEYxGEZSoWwztwVaH7smxiw3EWRvxBlIvTABdDWXbCmui1/q849clT0ZOiZdovonlqXXue0dzLNkvIQnNN4ouDDqSM7I0vfuRKjuGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Gct4AoJk; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761032910;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dg5RcfHhODublfTAqLGUz0lPtfc+ssoS6SJ2IDNtuJI=;
	b=Gct4AoJkHL3qL1ip3g6MiK0od4V3dEE/TL9Eoh8esqWISSp4Vq4T5xHZxK7pB97cJljJK4
	MJV2Q0hUoAPCKVtW26E5aFLBUqX9B9xAnTPrpzcuKMmhsUsICqewxGbGOMP2zCVVPmCXR6
	cUdO71JKNcDNvg8/uUI2IfMHfXb5uG8=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v2 05/23] KVM: selftests: Move nested invalid CR3 check to its own test
Date: Tue, 21 Oct 2025 07:47:18 +0000
Message-ID: <20251021074736.1324328-6-yosry.ahmed@linux.dev>
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

vmx_tsc_adjust_test currently verifies that a nested VMLAUNCH fails with
an invalid CR3. This is irrelevant to TSC scaling, move it to a
standalone test.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/Makefile.kvm      |  1 +
 .../kvm/x86/nested_invalid_cr3_test.c         | 81 +++++++++++++++++++
 .../selftests/kvm/x86/vmx_tsc_adjust_test.c   | 10 ---
 3 files changed, 82 insertions(+), 10 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86/nested_invalid_cr3_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index bb2ff7927ef57..b78700c574fc7 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -88,6 +88,7 @@ TEST_GEN_PROGS_x86 += x86/kvm_pv_test
 TEST_GEN_PROGS_x86 += x86/kvm_buslock_test
 TEST_GEN_PROGS_x86 += x86/monitor_mwait_test
 TEST_GEN_PROGS_x86 += x86/msrs_test
+TEST_GEN_PROGS_x86 += x86/nested_invalid_cr3_test
 TEST_GEN_PROGS_x86 += x86/nested_emulation_test
 TEST_GEN_PROGS_x86 += x86/nested_exceptions_test
 TEST_GEN_PROGS_x86 += x86/platform_info_test
diff --git a/tools/testing/selftests/kvm/x86/nested_invalid_cr3_test.c b/tools/testing/selftests/kvm/x86/nested_invalid_cr3_test.c
new file mode 100644
index 0000000000000..b9853ab532cfe
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/nested_invalid_cr3_test.c
@@ -0,0 +1,81 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * nested_invalid_cr3_test
+ *
+ * Copyright (C) 2025, Google LLC.
+ *
+ * This test verifies that L1 fails to enter L2 with an invalid CR3, and
+ * succeeds otherwise.
+ */
+#include "kvm_util.h"
+#include "vmx.h"
+#include "kselftest.h"
+
+
+#define L2_GUEST_STACK_SIZE 64
+
+static void l2_guest_code(void)
+{
+	vmcall();
+}
+
+static void l1_vmx_code(struct vmx_pages *vmx_pages)
+{
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	uintptr_t save_cr3;
+
+	GUEST_ASSERT(prepare_for_vmx_operation(vmx_pages));
+	GUEST_ASSERT(load_vmcs(vmx_pages));
+
+	prepare_vmcs(vmx_pages, l2_guest_code,
+		     &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	/* Try to run L2 with invalid CR3 and make sure it fails */
+	save_cr3 = vmreadz(GUEST_CR3);
+	vmwrite(GUEST_CR3, -1ull);
+	GUEST_ASSERT(!vmlaunch());
+	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) ==
+		     (EXIT_REASON_FAILED_VMENTRY | EXIT_REASON_INVALID_STATE));
+
+	/* Now restore CR3 and make sure L2 runs successfully */
+	vmwrite(GUEST_CR3, save_cr3);
+	GUEST_ASSERT(!vmlaunch());
+	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
+
+	GUEST_DONE();
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	vm_vaddr_t guest_gva = 0;
+
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
+
+	vm = vm_create_with_one_vcpu(&vcpu, l1_vmx_code);
+	vcpu_alloc_vmx(vm, &guest_gva);
+	vcpu_args_set(vcpu, 1, guest_gva);
+
+	for (;;) {
+		struct ucall uc;
+
+		vcpu_run(vcpu);
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+		case UCALL_SYNC:
+			break;
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+	}
+
+done:
+	kvm_vm_free(vm);
+	return 0;
+}
diff --git a/tools/testing/selftests/kvm/x86/vmx_tsc_adjust_test.c b/tools/testing/selftests/kvm/x86/vmx_tsc_adjust_test.c
index 2ceb5c78c4427..2dcc0306a0d9b 100644
--- a/tools/testing/selftests/kvm/x86/vmx_tsc_adjust_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_tsc_adjust_test.c
@@ -77,7 +77,6 @@ static void l1_guest_code(struct vmx_pages *vmx_pages)
 #define L2_GUEST_STACK_SIZE 64
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
 	uint32_t control;
-	uintptr_t save_cr3;
 
 	GUEST_ASSERT(rdtsc() < TSC_ADJUST_VALUE);
 	wrmsr(MSR_IA32_TSC, rdtsc() - TSC_ADJUST_VALUE);
@@ -94,15 +93,6 @@ static void l1_guest_code(struct vmx_pages *vmx_pages)
 	vmwrite(CPU_BASED_VM_EXEC_CONTROL, control);
 	vmwrite(TSC_OFFSET, TSC_OFFSET_VALUE);
 
-	/* Jump into L2.  First, test failure to load guest CR3.  */
-	save_cr3 = vmreadz(GUEST_CR3);
-	vmwrite(GUEST_CR3, -1ull);
-	GUEST_ASSERT(!vmlaunch());
-	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) ==
-		     (EXIT_REASON_FAILED_VMENTRY | EXIT_REASON_INVALID_STATE));
-	check_ia32_tsc_adjust(-1 * TSC_ADJUST_VALUE);
-	vmwrite(GUEST_CR3, save_cr3);
-
 	GUEST_ASSERT(!vmlaunch());
 	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
 
-- 
2.51.0.869.ge66316f041-goog


