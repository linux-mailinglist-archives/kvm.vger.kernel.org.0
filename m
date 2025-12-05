Return-Path: <kvm+bounces-65384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3696BCA99B4
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 00:20:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id ABC14303939F
	for <lists+kvm@lfdr.de>; Fri,  5 Dec 2025 23:19:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EFC930103B;
	Fri,  5 Dec 2025 23:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NDy9MtUd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3172FFF95
	for <kvm@vger.kernel.org>; Fri,  5 Dec 2025 23:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764976767; cv=none; b=NqkOchxTieB/lhD/yNYh3bFzLvPvPjLaF/Jp5hwuqSI27orG5KO14pjPzKEMqhVCkNvOdL/HNdbeeHisaFezIAm34Np2noanP3Ea/mDgG4kaWYnkRDJYqiGV+mJ9xaIcYwe80iaH4KC0Mv5WJej2OFl7Nbev6nIdNPyO/M7E+G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764976767; c=relaxed/simple;
	bh=4Fex+pgpP3q+w5hfQVpkoaW6L1kXWK3VkJDR6p+t18Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZVS5oQs0xb2YBKpUgyET7jvSe2lK2T82luuZQTKBTWN1hy6cUnge+kuatC0CZz1xk2VpayZ8u2cUU37p3UOm1G4DFPCNXfVds59wYEoPC8Om509TfxoMvS2s14qx88CSTXl0JeVJeFRtPfU3LvVmLXSQDVKTHAD/yNACdTgH8XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NDy9MtUd; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-349a2f509acso307142a91.1
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 15:19:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764976763; x=1765581563; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qE7acRBvhgKVAvezYXIFc6q852EVZn4fTd5PsAQBmnY=;
        b=NDy9MtUd0gOXkDF+VoxVC8I+f9mvqPkBc0VsN5w7mROH0y8qijcbYBmmfUo8qFqION
         GYLREFKv5D95G6gdFsfR3HyvRoozRLsjrJbB0XidOL0ZdRky4BcSBwSC46lyWXgIXEkn
         3+ruiWYRB+l49/wSQYOKklYSxSeFhzwWokiaD4HgK0pmvUoKJF509pHLnnr5+ha+kjGI
         ZxKQV3+LzGoXhS7aX4/c1hiRJoJISD3/ZOhIB+c7v6HZeO3AEDO8WRBJ9DUPehHriRP5
         HXqvZ37MfYn0eufdSwOOhRqMAL3caGd31bAw+5QeodH+3zZme8d+As07s0NySaWFQXRp
         Q28A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764976763; x=1765581563;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qE7acRBvhgKVAvezYXIFc6q852EVZn4fTd5PsAQBmnY=;
        b=NERcC+oFevrWrOrAEenotUxjYE5bpie2aI6MXCVZgmO0ycdUkYAshcqkO/ED5QDjcT
         1TvoJ8fCKhmNlrvzeC8pcH7NJ+Is9n+oNr7CHD0vh+loqjurvXeQzaL6drWKCP2zW/n3
         P6QpU0bHlxkqF/pcvQ69K3GVkkg8CXhA7AsN5udOu6pNebln+mKVFZX9qcZpcGayChdA
         fiyBxUHPjt4R3Imp/+QtJFZDnv3+izWbrnuOxGx081o4S+yryAh3K6bEBJZQFHO2J+Za
         2/lhNsiF8Q2eXeiktrxSuAc27hDI923IIDK7uv+Qjxa03fQh5QDqjYOn27NUmZrMq+h3
         lruQ==
X-Gm-Message-State: AOJu0Yx0ZBuFQTG17BrMALdnAO1eKsK+q8bMktZBvP8o7MTApRWDdNhZ
	KUEgEzUv0qhz4JsZMb8A8UD8NytMTP0sTBbXu5VFATYutXlj+4r+y636/AtxBri9BPyKfNE/shD
	qi3jTng==
X-Google-Smtp-Source: AGHT+IF8s0h1mmxocVPZHPd28nJzW0w+Qv5m/PrzhL2RdH7GTDs1Qpw6V6jl3Fd5c6lEV/iFc4ugbJdTgKI=
X-Received: from pjbsb13.prod.google.com ([2002:a17:90b:50cd:b0:340:c0e9:24b6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:388b:b0:349:30b4:6367
 with SMTP id 98e67ed59e1d1-349a25e5544mr580362a91.30.1764976762698; Fri, 05
 Dec 2025 15:19:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 15:19:06 -0800
In-Reply-To: <20251205231913.441872-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251205231913.441872-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251205231913.441872-4-seanjc@google.com>
Subject: [PATCH v3 03/10] KVM: selftests: Add a test to verify APICv updates
 (while L2 is active)
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongli Zhang <dongli.zhang@oracle.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"

Add a test to verify KVM correctly handles a variety of edge cases related
to APICv updates, and in particular updates that are triggered while L2 is
actively running.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/include/x86/apic.h  |   4 +
 .../kvm/x86/vmx_apicv_updates_test.c          | 181 ++++++++++++++++++
 3 files changed, 186 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86/vmx_apicv_updates_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index ba5c2b643efa..6f00bd8271c2 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -115,6 +115,7 @@ TEST_GEN_PROGS_x86 += x86/ucna_injection_test
 TEST_GEN_PROGS_x86 += x86/userspace_io_test
 TEST_GEN_PROGS_x86 += x86/userspace_msr_exit_test
 TEST_GEN_PROGS_x86 += x86/vmx_apic_access_test
+TEST_GEN_PROGS_x86 += x86/vmx_apicv_updates_test
 TEST_GEN_PROGS_x86 += x86/vmx_dirty_log_test
 TEST_GEN_PROGS_x86 += x86/vmx_exception_with_invalid_guest_state
 TEST_GEN_PROGS_x86 += x86/vmx_msrs_test
diff --git a/tools/testing/selftests/kvm/include/x86/apic.h b/tools/testing/selftests/kvm/include/x86/apic.h
index 80fe9f69b38d..d42a0998d868 100644
--- a/tools/testing/selftests/kvm/include/x86/apic.h
+++ b/tools/testing/selftests/kvm/include/x86/apic.h
@@ -32,6 +32,7 @@
 #define	APIC_SPIV	0xF0
 #define		APIC_SPIV_FOCUS_DISABLED	(1 << 9)
 #define		APIC_SPIV_APIC_ENABLED		(1 << 8)
+#define	APIC_ISR	0x100
 #define APIC_IRR	0x200
 #define	APIC_ICR	0x300
 #define	APIC_LVTCMCI	0x2f0
@@ -68,6 +69,9 @@
 #define	APIC_TMCCT	0x390
 #define	APIC_TDCR	0x3E0
 
+#define APIC_VECTOR_TO_BIT_NUMBER(v) ((unsigned int)(v) % 32)
+#define APIC_VECTOR_TO_REG_OFFSET(v) ((unsigned int)(v) / 32 * 0x10)
+
 void apic_disable(void);
 void xapic_enable(void);
 void x2apic_enable(void);
diff --git a/tools/testing/selftests/kvm/x86/vmx_apicv_updates_test.c b/tools/testing/selftests/kvm/x86/vmx_apicv_updates_test.c
new file mode 100644
index 000000000000..907d226fd0fd
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/vmx_apicv_updates_test.c
@@ -0,0 +1,181 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "vmx.h"
+
+#define GOOD_IPI_VECTOR 0xe0
+#define BAD_IPI_VECTOR 0xf0
+
+static volatile int good_ipis_received;
+
+static void good_ipi_handler(struct ex_regs *regs)
+{
+	good_ipis_received++;
+}
+
+static void bad_ipi_handler(struct ex_regs *regs)
+{
+	TEST_FAIL("Received \"bad\" IPI; ICR MMIO write should have been ignored");
+}
+
+static void l2_vmcall(void)
+{
+	/*
+	 * Exit to L1.  Assume all registers may be clobbered as selftests's
+	 * VM-Enter code doesn't preserve L2 GPRs.
+	 */
+	asm volatile("push %%rbp\n\t"
+		     "push %%r15\n\t"
+		     "push %%r14\n\t"
+		     "push %%r13\n\t"
+		     "push %%r12\n\t"
+		     "push %%rbx\n\t"
+		     "push %%rdx\n\t"
+		     "push %%rdi\n\t"
+		     "vmcall\n\t"
+		     "pop %%rdi\n\t"
+		     "pop %%rdx\n\t"
+		     "pop %%rbx\n\t"
+		     "pop %%r12\n\t"
+		     "pop %%r13\n\t"
+		     "pop %%r14\n\t"
+		     "pop %%r15\n\t"
+		     "pop %%rbp\n\t"
+		::: "rax", "rcx", "rdx", "rsi", "rdx", "r8", "r9", "r10", "r11", "memory");
+}
+
+static void l2_guest_code(void)
+{
+	x2apic_enable();
+	l2_vmcall();
+
+	xapic_enable();
+	xapic_write_reg(APIC_ID, 1 << 24);
+	l2_vmcall();
+}
+
+static void l1_guest_code(struct vmx_pages *vmx_pages)
+{
+#define L2_GUEST_STACK_SIZE 64
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	uint32_t control;
+
+	GUEST_ASSERT(prepare_for_vmx_operation(vmx_pages));
+	GUEST_ASSERT(load_vmcs(vmx_pages));
+
+	/* Prepare the VMCS for L2 execution. */
+	prepare_vmcs(vmx_pages, l2_guest_code, &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+	control = vmreadz(CPU_BASED_VM_EXEC_CONTROL);
+	control |= CPU_BASED_USE_MSR_BITMAPS;
+	vmwrite(CPU_BASED_VM_EXEC_CONTROL, control);
+
+	/* Modify APIC ID to coerce KVM into inhibiting APICv. */
+	xapic_enable();
+	xapic_write_reg(APIC_ID, 1 << 24);
+
+	/*
+	 * Generate+receive an IRQ without doing EOI to get an IRQ set in vISR
+	 * but not SVI.  APICv should be inhibited due to running with a
+	 * modified APIC ID.
+	 */
+	xapic_write_reg(APIC_ICR, APIC_DEST_SELF | APIC_DM_FIXED | GOOD_IPI_VECTOR);
+	GUEST_ASSERT_EQ(xapic_read_reg(APIC_ID), 1 << 24);
+
+	/* Enable IRQs and verify the IRQ was received. */
+	sti_nop();
+	GUEST_ASSERT_EQ(good_ipis_received, 1);
+
+	/*
+	 * Run L2 to switch to x2APIC mode, which in turn will uninhibit APICv,
+	 * as KVM should force the APIC ID back to its default.
+	 */
+	GUEST_ASSERT(!vmlaunch());
+	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
+	vmwrite(GUEST_RIP, vmreadz(GUEST_RIP) + vmreadz(VM_EXIT_INSTRUCTION_LEN));
+	GUEST_ASSERT(rdmsr(MSR_IA32_APICBASE) & MSR_IA32_APICBASE_EXTD);
+
+	/*
+	 * Scribble the APIC access page to verify KVM disabled xAPIC
+	 * virtualization in vmcs01, and to verify that KVM flushes L1's TLB
+	 * when L2 switches back to accelerated xAPIC mode.
+	 */
+	xapic_write_reg(APIC_ICR2, 0xdeadbeefu);
+	xapic_write_reg(APIC_ICR, APIC_DEST_SELF | APIC_DM_FIXED | BAD_IPI_VECTOR);
+
+	/*
+	 * Verify the IRQ is still in-service and emit an EOI to verify KVM
+	 * propagates the highest vISR vector to SVI when APICv is activated
+	 * (and does so even if APICv was uninhibited while L2 was active).
+	 */
+	GUEST_ASSERT_EQ(x2apic_read_reg(APIC_ISR + APIC_VECTOR_TO_REG_OFFSET(GOOD_IPI_VECTOR)),
+			BIT(APIC_VECTOR_TO_BIT_NUMBER(GOOD_IPI_VECTOR)));
+	x2apic_write_reg(APIC_EOI, 0);
+	GUEST_ASSERT_EQ(x2apic_read_reg(APIC_ISR + APIC_VECTOR_TO_REG_OFFSET(GOOD_IPI_VECTOR)), 0);
+
+	/*
+	 * Run L2 one more time to switch back to xAPIC mode to verify that KVM
+	 * handles the x2APIC => xAPIC transition and inhibits APICv while L2
+	 * is active.
+	 */
+	GUEST_ASSERT(!vmresume());
+	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
+	GUEST_ASSERT(!(rdmsr(MSR_IA32_APICBASE) & MSR_IA32_APICBASE_EXTD));
+
+	xapic_write_reg(APIC_ICR, APIC_DEST_SELF | APIC_DM_FIXED | GOOD_IPI_VECTOR);
+	/* Re-enable IRQs, as VM-Exit clears RFLAGS.IF. */
+	sti_nop();
+	GUEST_ASSERT_EQ(good_ipis_received, 2);
+
+	GUEST_ASSERT_EQ(xapic_read_reg(APIC_ISR + APIC_VECTOR_TO_REG_OFFSET(GOOD_IPI_VECTOR)),
+			BIT(APIC_VECTOR_TO_BIT_NUMBER(GOOD_IPI_VECTOR)));
+	xapic_write_reg(APIC_EOI, 0);
+	GUEST_ASSERT_EQ(xapic_read_reg(APIC_ISR + APIC_VECTOR_TO_REG_OFFSET(GOOD_IPI_VECTOR)), 0);
+	GUEST_DONE();
+}
+
+int main(int argc, char *argv[])
+{
+	vm_vaddr_t vmx_pages_gva;
+	struct vmx_pages *vmx;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	struct ucall uc;
+
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
+
+	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
+
+	vmx = vcpu_alloc_vmx(vm, &vmx_pages_gva);
+	prepare_virtualize_apic_accesses(vmx, vm);
+	vcpu_args_set(vcpu, 2, vmx_pages_gva);
+
+	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
+	vm_install_exception_handler(vm, BAD_IPI_VECTOR, bad_ipi_handler);
+	vm_install_exception_handler(vm, GOOD_IPI_VECTOR, good_ipi_handler);
+
+	vcpu_run(vcpu);
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
+
+	switch (get_ucall(vcpu, &uc)) {
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT(uc);
+		/* NOT REACHED */
+	case UCALL_DONE:
+		break;
+	default:
+		TEST_FAIL("Unexpected ucall %lu", uc.cmd);
+	}
+
+	/*
+	 * Verify at least two IRQs were injected.  Unfortunately, KVM counts
+	 * re-injected IRQs (e.g. if delivering the IRQ hits an EPT violation),
+	 * so being more precise isn't possible given the current stats.
+	 */
+	TEST_ASSERT(vcpu_get_stat(vcpu, irq_injections) >= 2,
+		    "Wanted at least 2 IRQ injections, got %lu\n",
+		    vcpu_get_stat(vcpu, irq_injections));
+
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.52.0.223.gf5cc29aaa4-goog


