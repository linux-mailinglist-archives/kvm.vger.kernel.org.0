Return-Path: <kvm+bounces-54301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A7F0B1DE34
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 22:25:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2724F3B5187
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 20:24:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 857A428468B;
	Thu,  7 Aug 2025 20:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CDE/in9F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F343273D92
	for <kvm@vger.kernel.org>; Thu,  7 Aug 2025 20:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754597854; cv=none; b=PZKhsJxZ0CVNXiA/JE8lsTdlntlFkbF27ZcWSjm7Hv2d3DKEACf5+3P1StpAR+r08lLlH2R3n1g/V9uQNMzegoa8TmMJoyJ2JzCH7/todJCUjHhctmhPldBQ26FwSyphG6NaA3Y807ZfPBS7Qxg2aLjnEHPEvzrrnER56vJUCZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754597854; c=relaxed/simple;
	bh=fGZK/ZXLopkNT4N/Idl0CuDWio5yEH37+0eJsgwxQLI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G+Hn7aVGaNrEWJYa76rGLPTaWlJ5nO+e6FEf8kKH0MMb3KzsushehaZ6W93HPVbzGoa+oSGVE+v2rVtxSSucWEVW/1BIZ4zyhUc7tyceaCXbwWXooZD/AJWs0f2J6KBu0KMiVRSiFq5x88zBRVcXjnHLD+o6mgIYfHQq44vQA3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CDE/in9F; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76bd2543889so2072283b3a.0
        for <kvm@vger.kernel.org>; Thu, 07 Aug 2025 13:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754597853; x=1755202653; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=15Qpka96Z78Ss7GgewBHLqp6k9wV1uf8bbKpYv0vf/c=;
        b=CDE/in9FSsUdyjakzKmzcQj2IWJhmsx5bUiBdpOK2lTfpNnEBdw05PVt9Upa3ywQ5z
         p8MSorK+QvNXVjA1W71PeQZHGRc19LdFbjPXHdrlNlXIKx6hT2UFWVMkNABKr5ucMs8/
         AKSou+dnlUd/X67dLUR0kP5zJY+vRJ9AmgiPzu9O0yZnvRv/Lsdz3qEITlVA1Rkq8NQX
         S964vhPxf/w8gdA+ok72oKdSMPsAZ8p7vcr7YhiwJgNlAYmxYfdFf/mi86MzbHnv3Q9k
         JAX/P66BISXhzHmfATCP08gm6xmXeXU3pHZ3eUKhg82sjsaWMD6l1SUPAiaI5fftnBhh
         ZT8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754597853; x=1755202653;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=15Qpka96Z78Ss7GgewBHLqp6k9wV1uf8bbKpYv0vf/c=;
        b=hbX0nd1C5RTdKz6CFXu/p+CNFHVOdOsY8gtTKiLJQEiRI89PDf6oupRbxxA3KzuuTy
         B0EVuTUyGcKem63c0vJ2V8Qds2UZMB8npAz4cFH9hD9O/DtGkP23oyVCPOeO3A4A+/Na
         L3vJK+d/1mnLZZi3EEsxQ5KKOrtyeEe/Dx0CkcULEo5WaZtK30tBOp5Qzh9XhzdxLF+D
         Vgcgv6a3DEpoOILFgKijRkEFozH4ORCpbgEZ2rzsJoIOxLnewntWWmsnSGQVAaoOiLoU
         YHiLXBsU1vFnr0Xw2KCDiDyz8by4zmV07SzjVzNawugAAhID1qOTI7Yp9Ptz9TLOeSBn
         45xw==
X-Forwarded-Encrypted: i=1; AJvYcCVH/zNLOBGzOarVcGEa4ovdr/Qn98gXfElMNCPD05J5oS19Egbw4U+Mmp+d27/qWMFFudc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwpKkk1bAtVlStxZKzYX3RXbyybq4ZqqtimA4erXqp5YvWd6xtf
	EF3x4kpNoyRYnmEHA7qd6qhjq29HuqPturRRufvXfzm7K4X2GTeVJAmAYVej754V1lPFMgGOt/9
	3KQ==
X-Google-Smtp-Source: AGHT+IHCtaiYFn/vLOawALqf+Yv3wNQbooOQ7dEJrMNEqHSOnJMVgt+8XOAAcARXXu+JZtBqaOY3X2QjmQ==
X-Received: from pjbsn13.prod.google.com ([2002:a17:90b:2e8d:b0:31f:6965:f3e6])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d4ca:b0:240:2e99:906c
 with SMTP id d9443c01a7336-242c209fa2bmr4556155ad.15.1754597841757; Thu, 07
 Aug 2025 13:17:21 -0700 (PDT)
Date: Thu,  7 Aug 2025 13:16:25 -0700
In-Reply-To: <20250807201628.1185915-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250807201628.1185915-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
Message-ID: <20250807201628.1185915-30-sagis@google.com>
Subject: [PATCH v8 29/30] KVM: selftests: TDX: Add TDX UPM selftests for
 implicit conversion
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Sagi Shahar <sagis@google.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Ackerley Tng <ackerleytng@google.com>

This tests the use of guest memory without explicit TDG.VP.VMCALL<MapGPA>
calls.

Provide a 2MB memory region to the TDX guest with a 40KB focus area at
offset 1MB intended to be shared between host and guest. The guest does
not request memory to be shared or private using TDG.VP.VMCALL<MapGPA> but
instead relies on memory to be converted automatically based on its
access via shared or private mapping. The host automatically
converts the memory when guest exits with KVM_EXIT_MEMORY_FAULT.

The 2MB region starts out as private with the guest filling it with a
pattern, followed by a check from the host to ensure the host is not able
to see the pattern. The guest then accesses the 40KB focus area via
its shared mapping to trigger implicit conversion followed by checks that
the host and guest has the same view of the memory. Finally the guest
accesses the 40KB memory via its private mapping to trigger the implicit
conversion to private followed by checks to confirm this is the case.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 .../testing/selftests/kvm/x86/tdx_upm_test.c  | 88 ++++++++++++++++---
 1 file changed, 76 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/tdx_upm_test.c b/tools/testing/selftests/kvm/x86/tdx_upm_test.c
index 387258ab1a62..2ea5bf6d24b7 100644
--- a/tools/testing/selftests/kvm/x86/tdx_upm_test.c
+++ b/tools/testing/selftests/kvm/x86/tdx_upm_test.c
@@ -150,10 +150,10 @@ enum {
  * Does vcpu_run, and also manages memory conversions if requested by the TD.
  */
 void vcpu_run_and_manage_memory_conversions(struct kvm_vm *vm,
-					    struct kvm_vcpu *vcpu)
+					    struct kvm_vcpu *vcpu, bool handle_conversions)
 {
 	for (;;) {
-		vcpu_run(vcpu);
+		_vcpu_run(vcpu);
 		if (vcpu->run->exit_reason == KVM_EXIT_HYPERCALL &&
 		    vcpu->run->hypercall.nr == KVM_HC_MAP_GPA_RANGE) {
 			uint64_t gpa = vcpu->run->hypercall.args[0];
@@ -164,6 +164,13 @@ void vcpu_run_and_manage_memory_conversions(struct kvm_vm *vm,
 						  KVM_MAP_GPA_RANGE_ENCRYPTED);
 			vcpu->run->hypercall.ret = 0;
 			continue;
+		} else if (handle_conversions &&
+			vcpu->run->exit_reason == KVM_EXIT_MEMORY_FAULT) {
+			handle_memory_conversion(vm, vcpu->id, vcpu->run->memory_fault.gpa,
+						 vcpu->run->memory_fault.size,
+						 vcpu->run->memory_fault.flags ==
+						  KVM_MEMORY_EXIT_FLAG_PRIVATE);
+			continue;
 		} else if (vcpu->run->exit_reason == KVM_EXIT_IO &&
 			   vcpu->run->io.port == TDX_UPM_TEST_ACCEPT_PRINT_PORT) {
 			uint64_t gpa = tdx_test_read_64bit(vcpu,
@@ -241,8 +248,48 @@ static void guest_upm_explicit(void)
 	tdx_test_success();
 }
 
+static void guest_upm_implicit(void)
+{
+	struct tdx_upm_test_area *test_area_gva_private =
+		(struct tdx_upm_test_area *)TDX_UPM_TEST_AREA_GVA_PRIVATE;
+	struct tdx_upm_test_area *test_area_gva_shared =
+		(struct tdx_upm_test_area *)TDX_UPM_TEST_AREA_GVA_SHARED;
+
+	/* Check: host reading private memory does not modify guest's view */
+	fill_test_area(test_area_gva_private, PATTERN_GUEST_GENERAL);
+
+	tdx_test_report_to_user_space(SYNC_CHECK_READ_PRIVATE_MEMORY_FROM_HOST);
+
+	TDX_UPM_TEST_ASSERT(check_test_area(test_area_gva_private, PATTERN_GUEST_GENERAL));
+
+	/* Use focus area as shared */
+	fill_focus_area(test_area_gva_shared, PATTERN_GUEST_FOCUS);
+
+	/* General areas should not be affected */
+	TDX_UPM_TEST_ASSERT(check_general_areas(test_area_gva_private, PATTERN_GUEST_GENERAL));
+
+	tdx_test_report_to_user_space(SYNC_CHECK_READ_SHARED_MEMORY_FROM_HOST);
+
+	/* Check that guest has the same view of shared memory */
+	TDX_UPM_TEST_ASSERT(check_focus_area(test_area_gva_shared, PATTERN_HOST_FOCUS));
+
+	/* Use focus area as private */
+	fill_focus_area(test_area_gva_private, PATTERN_GUEST_FOCUS);
+
+	/* General areas should be unaffected by remapping */
+	TDX_UPM_TEST_ASSERT(check_general_areas(test_area_gva_private, PATTERN_GUEST_GENERAL));
+
+	tdx_test_report_to_user_space(SYNC_CHECK_READ_PRIVATE_MEMORY_FROM_HOST_AGAIN);
+
+	/* Check that guest can use private memory after focus area is remapped as private */
+	TDX_UPM_TEST_ASSERT(fill_and_check(test_area_gva_private, PATTERN_GUEST_GENERAL));
+
+	tdx_test_success();
+}
+
 static void run_selftest(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
-			 struct tdx_upm_test_area *test_area_base_hva)
+			 struct tdx_upm_test_area *test_area_base_hva,
+			 bool implicit)
 {
 	tdx_run(vcpu);
 	tdx_test_assert_io(vcpu, TDX_TEST_REPORT_PORT, TDX_TEST_REPORT_SIZE,
@@ -260,7 +307,7 @@ static void run_selftest(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
 	TEST_ASSERT(check_test_area(test_area_base_hva, PATTERN_CONFIDENCE_CHECK),
 		    "Host should read PATTERN_CONFIDENCE_CHECK from guest's private memory.");
 
-	vcpu_run_and_manage_memory_conversions(vm, vcpu);
+	vcpu_run_and_manage_memory_conversions(vm, vcpu, implicit);
 	tdx_test_assert_io(vcpu, TDX_TEST_REPORT_PORT, TDX_TEST_REPORT_SIZE,
 			   PORT_WRITE);
 	TEST_ASSERT_EQ(*(uint32_t *)((void *)vcpu->run + vcpu->run->io.data_offset),
@@ -276,7 +323,7 @@ static void run_selftest(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
 	TEST_ASSERT(check_focus_area(test_area_base_hva, PATTERN_HOST_FOCUS),
 		    "Host should be able to use shared memory.");
 
-	vcpu_run_and_manage_memory_conversions(vm, vcpu);
+	vcpu_run_and_manage_memory_conversions(vm, vcpu, implicit);
 	tdx_test_assert_io(vcpu, TDX_TEST_REPORT_PORT, TDX_TEST_REPORT_SIZE,
 			   PORT_WRITE);
 	TEST_ASSERT_EQ(*(uint32_t *)((void *)vcpu->run + vcpu->run->io.data_offset),
@@ -322,17 +369,19 @@ static void guest_ve_handler(struct ex_regs *regs)
 	TDX_UPM_TEST_ASSERT(!ret);
 }
 
-static void verify_upm_test(void)
+static void verify_upm_test(bool implicit)
 {
 	struct tdx_upm_test_area *test_area_base_hva;
 	vm_vaddr_t test_area_gva_private;
 	uint64_t test_area_npages;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
+	void *guest_code;
 
 	vm = td_create();
 	td_initialize(vm, VM_MEM_SRC_ANONYMOUS, 0);
-	vcpu = td_vcpu_add(vm, 0, guest_upm_explicit);
+	guest_code = implicit ? guest_upm_implicit : guest_upm_explicit;
+	vcpu = td_vcpu_add(vm, 0, guest_code);
 
 	vm_install_exception_handler(vm, VE_VECTOR, guest_ve_handler);
 
@@ -373,15 +422,28 @@ static void verify_upm_test(void)
 
 	td_finalize(vm);
 
-	printf("Verifying UPM functionality: explicit MapGPA\n");
+	if (implicit)
+		printf("Verifying UPM functionality: implicit conversion\n");
+	else
+		printf("Verifying UPM functionality: explicit MapGPA\n");
 
 	vm_enable_cap(vm, KVM_CAP_EXIT_HYPERCALL, BIT_ULL(KVM_HC_MAP_GPA_RANGE));
 
-	run_selftest(vm, vcpu, test_area_base_hva);
+	run_selftest(vm, vcpu, test_area_base_hva, implicit);
 
 	kvm_vm_free(vm);
 }
 
+void verify_upm_test_explicit(void)
+{
+	verify_upm_test(false);
+}
+
+void verify_upm_test_implicit(void)
+{
+	verify_upm_test(true);
+}
+
 int main(int argc, char **argv)
 {
 	ksft_print_header();
@@ -389,9 +451,11 @@ int main(int argc, char **argv)
 	if (!is_tdx_enabled())
 		ksft_exit_skip("TDX is not supported by the KVM. Exiting.\n");
 
-	ksft_set_plan(1);
-	ksft_test_result(!run_in_new_process(&verify_upm_test),
-			 "verify_upm_test\n");
+	ksft_set_plan(2);
+	ksft_test_result(!run_in_new_process(&verify_upm_test_explicit),
+			 "verify_upm_test_explicit\n");
+	ksft_test_result(!run_in_new_process(&verify_upm_test_implicit),
+			 "verify_upm_test_implicit\n");
 
 	ksft_finished();
 }
-- 
2.51.0.rc0.155.g4a0f42376b-goog


