Return-Path: <kvm+bounces-61365-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 99D66C17434
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 00:01:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CDDD64F97B6
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 22:59:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57E0436C242;
	Tue, 28 Oct 2025 22:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kyw5Sz/k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ACD836B988
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 22:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761692340; cv=none; b=eYA0lh0rNpT7iK3FfEDwnNeYBV7OVn1ZFbPCvA9K4tpI18mqm2Y6NNedzPzUAw5fjKWL7Q6vGHdSGla6uFDjZO/GU2ewqJG+IQjvLJ7JIWz2fbfDJVQiCY7xGAaFcpknQBYIfEBJwBn09KPJGuJg6s0aBTXXulj9uYctt2pVxxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761692340; c=relaxed/simple;
	bh=93vaNyyTFMuDYRMt2Na8Hg8PCoyUTl7Q8NM8sIET3Q0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=F7R4Ed9F7BxYA5dqXO/MSlA6175JVccDo1Z4x9gMa0ktgZQ/98NvE5T4bORKn6l8h47tmeEERVDpTuzJEH/6LT5T6KpHmWVUhhBnou0muXW1/LrOJIwj9q6HxHwa8fwyunoAEUr8XWqWCQ3TRFXesphqWgF+aMaaHQij+nKIG5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kyw5Sz/k; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33dadf7c5beso5864069a91.0
        for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 15:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761692338; x=1762297138; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CXlFQqVkeSJSGq4nf4h9sY1cU7UxsK+01O4a1p4Iox8=;
        b=Kyw5Sz/kk4eu8lqLBQrGhUdcL6C6w/ToUAmEImqGjoIlpDIFJWY604stq+Q83MYP7p
         dKTXHxd6gYye79AILnpifTZ4g0CJVxL2fRbR7AWbVv+zXPLdxdZSDVBPu1+QVEJRwktO
         MJ0Up5srENpEBlRFdWmx/oEDGb1XiU1R1g9DGa3dseSDdx4ExEOTsce3y3xrhehXcswq
         hYhgoVaSIkRyjL8xRxNXkVrlzU2LMbV79NpLy8E/Tl0WMgRwAOZA08a26y+7FChLe4km
         iw3z9lntoF1JBHueU4Qphxw0UbaRzCrYRyQIi6KrkGt9HF7kB4l6iZE4+tOAvB+kl2fr
         43Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761692338; x=1762297138;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CXlFQqVkeSJSGq4nf4h9sY1cU7UxsK+01O4a1p4Iox8=;
        b=Uc7HDLAwodtZjz6Z9lHlVbzIoqdvCTpPOXTs40OEK1LSiKXAJbygCW4wjqQyPODfNI
         E57nGEKe9iqj1U4yLCTZDOF2LBRYj8ComK8tsRz0C3anGpDX8tjNZZWTuShQnIWQGgIs
         jrjl2KSIZB/VaF0Qus7PzcFj/6+Bz2rzK7YCgAVTdeBsCyNnj3c52jlc6Bv5uqpwiI0C
         FB3ZX5sD1AGhWT2J4GDTlI3si30PpLUL+K1xEy/fuJbPATxDhGlh15tGQCJO5AUJouk4
         InOuDGWQGqJn0HEYpvrtZYbJq0WfQzZiQEEjuhUc4EaktzCnwDOjlhBJWAt0bTJLbuoR
         DyXQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdZT7tRSLEp0AJf+kcDhJtINefNIEQ0Mfgtazwn2RECkAEP0oJiyGjB2STCt22rv3sM14=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywc5h7NWDBxPzCSWwGOCWNCfVOxPnvPIVMXB2SzJkOO/WBMv7CV
	0l2pD5XzzVJih6wM+ZV81K1QX2qGqV8yWU6DCeRDU0+FWlefO7xK048kEsVbZAX1++baukapycf
	e7RTTGYIIauvs/g==
X-Google-Smtp-Source: AGHT+IHe+dJhfOO9m6uEQXw3DM1SrUYb2gIMsEhaThpkWaKsrk/O7HUYRRmxDYScsO608Odc0oikNMx/xTBT8Q==
X-Received: from pjbsw13.prod.google.com ([2002:a17:90b:2c8d:b0:33f:e888:4aad])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:586e:b0:340:299f:e244 with SMTP id 98e67ed59e1d1-3403a26906cmr820669a91.12.1761692337855;
 Tue, 28 Oct 2025 15:58:57 -0700 (PDT)
Date: Tue, 28 Oct 2025 15:30:42 -0700
In-Reply-To: <20251028225827.2269128-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251028225827.2269128-1-jmattson@google.com>
X-Mailer: git-send-email 2.51.1.851.g4ebd6896fd-goog
Message-ID: <20251028225827.2269128-5-jmattson@google.com>
Subject: [PATCH v2 4/4] KVM: selftests: Add a VMX test for LA57 nested state
From: Jim Mattson <jmattson@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Bibo Mao <maobibo@loongson.cn>, Jim Mattson <jmattson@google.com>, 
	"Pratik R. Sampat" <prsampat@amd.com>, James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Add a selftest that verifies KVM's ability to save and restore
nested state when the L1 guest is using 5-level paging and the L2
guest is using 4-level paging. Specifically, canonicality tests of
the VMCS12 host-state fields should accept 57-bit virtual addresses.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../kvm/x86/vmx_la57_nested_state_test.c      | 134 ++++++++++++++++++
 2 files changed, 135 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86/vmx_la57_nested_state_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 148d427ff24b..b9279ce4eaab 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -117,6 +117,7 @@ TEST_GEN_PROGS_x86 += x86/vmx_exception_with_invalid_guest_state
 TEST_GEN_PROGS_x86 += x86/vmx_msrs_test
 TEST_GEN_PROGS_x86 += x86/vmx_invalid_nested_guest_state
 TEST_GEN_PROGS_x86 += x86/vmx_set_nested_state_test
+TEST_GEN_PROGS_x86 += x86/vmx_la57_nested_state_test
 TEST_GEN_PROGS_x86 += x86/vmx_tsc_adjust_test
 TEST_GEN_PROGS_x86 += x86/vmx_nested_tsc_scaling_test
 TEST_GEN_PROGS_x86 += x86/apic_bus_clock_test
diff --git a/tools/testing/selftests/kvm/x86/vmx_la57_nested_state_test.c b/tools/testing/selftests/kvm/x86/vmx_la57_nested_state_test.c
new file mode 100644
index 000000000000..00c6327d5621
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/vmx_la57_nested_state_test.c
@@ -0,0 +1,134 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * vmx_la57_nested_state_test
+ *
+ * Copyright (C) 2025, Google LLC.
+ *
+ * Test KVM's ability to save and restore nested state when the L1 guest
+ * is using 5-level paging and the L2 guest is using 4-level paging.
+ *
+ * This test would have failed prior to commit 9245fd6b8531 ("KVM: x86:
+ * model canonical checks more precisely").
+ */
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "vmx.h"
+
+#define LA57_GS_BASE 0xff2bc0311fb00000ull
+
+static void l2_guest_code(void)
+{
+	/*
+	 * Sync with L0 to trigger save/restore.  After
+	 * resuming, execute VMCALL to exit back to L1.
+	 */
+	GUEST_SYNC(1);
+	vmcall();
+}
+
+static void l1_guest_code(struct vmx_pages *vmx_pages)
+{
+#define L2_GUEST_STACK_SIZE 64
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	u64 guest_cr4;
+	vm_paddr_t pml5_pa, pml4_pa;
+	u64 *pml5;
+	u64 exit_reason;
+
+	/* Set GS_BASE to a value that is only canonical with LA57. */
+	wrmsr(MSR_GS_BASE, LA57_GS_BASE);
+	GUEST_ASSERT(rdmsr(MSR_GS_BASE) == LA57_GS_BASE);
+
+	GUEST_ASSERT(vmx_pages->vmcs_gpa);
+	GUEST_ASSERT(prepare_for_vmx_operation(vmx_pages));
+	GUEST_ASSERT(load_vmcs(vmx_pages));
+
+	prepare_vmcs(vmx_pages, l2_guest_code,
+		     &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	/*
+	 * Set up L2 with a 4-level page table by pointing its CR3 to
+	 * L1's first PML4 table and clearing CR4.LA57. This creates
+	 * the CR4.LA57 mismatch that exercises the bug.
+	 */
+	pml5_pa = get_cr3() & PHYSICAL_PAGE_MASK;
+	pml5 = (u64 *)pml5_pa;
+	pml4_pa = pml5[0] & PHYSICAL_PAGE_MASK;
+	vmwrite(GUEST_CR3, pml4_pa);
+
+	guest_cr4 = vmreadz(GUEST_CR4);
+	guest_cr4 &= ~X86_CR4_LA57;
+	vmwrite(GUEST_CR4, guest_cr4);
+
+	GUEST_ASSERT(!vmlaunch());
+
+	exit_reason = vmreadz(VM_EXIT_REASON);
+	GUEST_ASSERT(exit_reason == EXIT_REASON_VMCALL);
+}
+
+void guest_code(struct vmx_pages *vmx_pages)
+{
+	l1_guest_code(vmx_pages);
+	GUEST_DONE();
+}
+
+int main(int argc, char *argv[])
+{
+	vm_vaddr_t vmx_pages_gva = 0;
+	struct kvm_vm *vm;
+	struct kvm_vcpu *vcpu;
+	struct kvm_x86_state *state;
+	struct ucall uc;
+	int stage;
+
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_LA57));
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_NESTED_STATE));
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+
+	/*
+	 * L1 needs to read its own PML5 table to set up L2. Identity map
+	 * the PML5 table to facilitate this.
+	 */
+	virt_map(vm, vm->pgd, vm->pgd, 1);
+
+	vcpu_alloc_vmx(vm, &vmx_pages_gva);
+	vcpu_args_set(vcpu, 1, vmx_pages_gva);
+
+	for (stage = 1;; stage++) {
+		vcpu_run(vcpu);
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			/* NOT REACHED */
+		case UCALL_SYNC:
+			break;
+		case UCALL_DONE:
+			goto done;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+
+		TEST_ASSERT(uc.args[1] == stage,
+			    "Expected stage %d, got stage %lu", stage, (ulong)uc.args[1]);
+		if (stage == 1) {
+			pr_info("L2 is active; performing save/restore.\n");
+			state = vcpu_save_state(vcpu);
+
+			kvm_vm_release(vm);
+
+			/* Restore state in a new VM. */
+			vcpu = vm_recreate_with_one_vcpu(vm);
+			vcpu_load_state(vcpu, state);
+			kvm_x86_state_cleanup(state);
+		}
+	}
+
+done:
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.51.1.851.g4ebd6896fd-goog


