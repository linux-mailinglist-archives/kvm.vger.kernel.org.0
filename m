Return-Path: <kvm+bounces-60614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AA8D3BF513D
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 09:51:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 364BC4FFFBA
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 07:49:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E37329A309;
	Tue, 21 Oct 2025 07:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uoJHc+An"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6828287503
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 07:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761032915; cv=none; b=LeGXNw5DvCgsYPYLKebSaUTUP2Zr9xw4wlqx8V9QSIQxXIRqTXrbLxYZPvZGE4q0P/szVSTRHlPcjGZV3Y4lqWO6LLNvZ4cyqnAtSM2Ffyr8aWp1Xw6RB/voq1PNBxH7gkSNlt7Uewy1RwIqmT7hyXgRyW0uqXsQ+aPhm8VwC5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761032915; c=relaxed/simple;
	bh=Pz6XQMVn6Elmb7c8QL1ecDc8Oi0fpx2DIkOyBjqysYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YpRCsrPTjcULoB5PwJUISRd/a8uC1Z6eScxvouQSxoVIZt9cHwJ+oj81QNHFeRzAxFnJLOo89Am7AL6Ft73B3WtsV9ZyrNPpfYen0lKaZt2vnRZHQL8gIYsmW0oLM1HBt5pDkzTxRsIeAUmc6GFWadyxUGDnX7YdmaKDV3J1M0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uoJHc+An; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761032908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XY6Ex3U4Gi9sCANmVeHAwSsb6Q0TQQaEwGxDyLB/qkU=;
	b=uoJHc+AnTLiVvx/GTn1HZsBbIrwGk0uNr7QWwlvsJ/O1V6XAtp6pK0bmo2etmdMOn8SCoH
	RqsdwKq/nWvfObdQcY00lqCbYXl2Woh/Ng2zKRmnRujCsZebWJFiB2f0q8Y5+ZPya3wncZ
	hVy2lT37lnYkW0LEX+vjpPmKqhxViMw=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v2 04/23] KVM: selftests: Extend vmx_nested_tsc_scaling_test to cover SVM
Date: Tue, 21 Oct 2025 07:47:17 +0000
Message-ID: <20251021074736.1324328-5-yosry.ahmed@linux.dev>
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

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/Makefile.kvm      |  2 +-
 ...aling_test.c => nested_tsc_scaling_test.c} | 48 +++++++++++++++++--
 2 files changed, 44 insertions(+), 6 deletions(-)
 rename tools/testing/selftests/kvm/x86/{vmx_nested_tsc_scaling_test.c => nested_tsc_scaling_test.c} (83%)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index e70a844a52bdc..bb2ff7927ef57 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -119,7 +119,7 @@ TEST_GEN_PROGS_x86 += x86/vmx_msrs_test
 TEST_GEN_PROGS_x86 += x86/vmx_invalid_nested_guest_state
 TEST_GEN_PROGS_x86 += x86/vmx_la57_nested_state_test
 TEST_GEN_PROGS_x86 += x86/vmx_tsc_adjust_test
-TEST_GEN_PROGS_x86 += x86/vmx_nested_tsc_scaling_test
+TEST_GEN_PROGS_x86 += x86/nested_tsc_scaling_test
 TEST_GEN_PROGS_x86 += x86/apic_bus_clock_test
 TEST_GEN_PROGS_x86 += x86/xapic_ipi_test
 TEST_GEN_PROGS_x86 += x86/xapic_state_test
diff --git a/tools/testing/selftests/kvm/x86/vmx_nested_tsc_scaling_test.c b/tools/testing/selftests/kvm/x86/nested_tsc_scaling_test.c
similarity index 83%
rename from tools/testing/selftests/kvm/x86/vmx_nested_tsc_scaling_test.c
rename to tools/testing/selftests/kvm/x86/nested_tsc_scaling_test.c
index 1759fa5cb3f29..4260c9e4f4891 100644
--- a/tools/testing/selftests/kvm/x86/vmx_nested_tsc_scaling_test.c
+++ b/tools/testing/selftests/kvm/x86/nested_tsc_scaling_test.c
@@ -13,6 +13,7 @@
 
 #include "kvm_util.h"
 #include "vmx.h"
+#include "svm_util.h"
 #include "kselftest.h"
 
 /* L2 is scaled up (from L1's perspective) by this factor */
@@ -79,7 +80,30 @@ static void l2_guest_code(void)
 	__asm__ __volatile__("vmcall");
 }
 
-static void l1_guest_code(struct vmx_pages *vmx_pages)
+static void l1_svm_code(struct svm_test_data *svm)
+{
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+
+	/* check that L1's frequency looks alright before launching L2 */
+	check_tsc_freq(UCHECK_L1);
+
+	generic_svm_setup(svm, l2_guest_code,
+			  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	/* enable TSC scaling for L2 */
+	wrmsr(MSR_AMD64_TSC_RATIO, L2_SCALE_FACTOR << 32);
+
+	/* launch L2 */
+	run_guest(svm->vmcb, svm->vmcb_gpa);
+	GUEST_ASSERT(svm->vmcb->control.exit_code == SVM_EXIT_VMMCALL);
+
+	/* check that L1's frequency still looks good */
+	check_tsc_freq(UCHECK_L1);
+
+	GUEST_DONE();
+}
+
+static void l1_vmx_code(struct vmx_pages *vmx_pages)
 {
 	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
 	uint32_t control;
@@ -116,11 +140,19 @@ static void l1_guest_code(struct vmx_pages *vmx_pages)
 	GUEST_DONE();
 }
 
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
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
-	vm_vaddr_t vmx_pages_gva;
+	vm_vaddr_t guest_gva = 0;
 
 	uint64_t tsc_start, tsc_end;
 	uint64_t tsc_khz;
@@ -129,7 +161,8 @@ int main(int argc, char *argv[])
 	uint64_t l1_tsc_freq = 0;
 	uint64_t l2_tsc_freq = 0;
 
-	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX) ||
+		     kvm_cpu_has(X86_FEATURE_SVM));
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_TSC_CONTROL));
 	TEST_REQUIRE(sys_clocksource_is_based_on_tsc());
 
@@ -152,8 +185,13 @@ int main(int argc, char *argv[])
 	printf("real TSC frequency is around: %"PRIu64"\n", l0_tsc_freq);
 
 	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
-	vcpu_alloc_vmx(vm, &vmx_pages_gva);
-	vcpu_args_set(vcpu, 1, vmx_pages_gva);
+
+	if (kvm_cpu_has(X86_FEATURE_VMX))
+		vcpu_alloc_vmx(vm, &guest_gva);
+	else
+		vcpu_alloc_svm(vm, &guest_gva);
+
+	vcpu_args_set(vcpu, 1, guest_gva);
 
 	tsc_khz = __vcpu_ioctl(vcpu, KVM_GET_TSC_KHZ, NULL);
 	TEST_ASSERT(tsc_khz != -1, "vcpu ioctl KVM_GET_TSC_KHZ failed");
-- 
2.51.0.869.ge66316f041-goog


