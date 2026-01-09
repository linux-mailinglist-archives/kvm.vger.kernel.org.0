Return-Path: <kvm+bounces-67505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id F18F0D07051
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 04:46:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DF34730477C4
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 03:45:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 144742DB7AB;
	Fri,  9 Jan 2026 03:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3ePBwrgc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C832C2346
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 03:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767930338; cv=none; b=h/wh0xO7YPbT4UQjD8c3hI/caacWjRN8W51GqpjKHOQwBxuWgCAPcW8/WmuW5y2aaXVO4b6mBQlzgaKuWwmpZKUczDnrmC0tWPoLcD1mGBmzZGAt0MV3m8fiSJdex0S+EBJc9cXGSf6W3vlvnZpKdXMYdMZ07EzqtUr+KJBBj18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767930338; c=relaxed/simple;
	bh=HrbrtY53Z04do46sxpdw6vWSFMqntMt3jnTtKj1ZEjI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sRHpeJOJVV6s1QTArmUalKjeh/P7x0ch8WfwIBjtarxeGjDyhxfC5zH6wC3NcIcg1BqjYHxZuLDJg2Gt1/HPN1nkTIiGCrWxQpi+RftakgvjQMaNhLWLBrp/gHXlmLh9bJ+dJ3bqiPMCBwFQaEQNiK3IsrfcxHD4a6d4/swY3f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3ePBwrgc; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34e5a9de94bso7181892a91.0
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 19:45:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767930336; x=1768535136; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=V9I2P65QJ5ZJ2Hyc5FjqLOkel5dKeneY79WO6C867VY=;
        b=3ePBwrgcUdUPpwRCDp8Kujq98cce6gtLla2DX0eDOmnUjy+ZKOq4382JkRbsOqhF4X
         WkqwgPc7+LkhSSK8OZ9Z2BMhD3f7rUg7hlse7APgKIz5EhEr1LcQMWr/sMjtPwZ6vynB
         COSDEg+1XgSrdjg/3EwkWP6LnI1k3t/bOXZZ0UIabF+vxAp4/a1CWN9pPSiZ21IpBgnw
         oSQn2X6meVocTAwY6UKlIolybwgFuHFXjDAFztHcnJ41KZoU/wqK8o0MZjaPFnG0069U
         XDrzyl83eD6IYh6dRH92ZC4oOzNIM7H8d90vXiesgvq2Lt5ImNwJuITgC20fGyRfH9hN
         6rKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767930336; x=1768535136;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V9I2P65QJ5ZJ2Hyc5FjqLOkel5dKeneY79WO6C867VY=;
        b=oMR8fi0n8uKtT200AK8AcxsK8OtI7dqkugkjJpKMjClQN/qZG6xT0IGXEOaABiXbqR
         eMUF1dOCQ5IcNOOgBG3gdGNpydGtOU9tGpMNi2hgZwU/ARX4RaE0+0tPBpTdQOHxxJxF
         ehfjV4tZu5/EERmckkSICN/ZWCfmxrxa56eTg2NYzsUebc8uV6mofMtbuCw6obD/JgPp
         KnjQDBWIIi1500rzOzxtLbvSElr9tADutiSPq9tT4MsKYNKh1ohTfjrjiknOMDtyXUnM
         NOMGdTqqQ0cQ4VIYKEJtxx9tmNErd2FXbkT9JBEBJ+jV/wnYqOhucVFtZrb3L8byDTDX
         yoFw==
X-Gm-Message-State: AOJu0YwpucJEdGrCEY8q9MVAGA/+xS8gO8ecnTZ8sksbBrar6JL9V7uJ
	EXAJxkB529eEaVpPqWb7PPZ3jop5UpquPLD+7cnnaLB/skmV4hzF7ga7LMjviDY6mYlFJ/xR4G/
	M7hxbyg==
X-Google-Smtp-Source: AGHT+IGjfh13G42GvqwGhcOnriZ4ua0Sp3Hzs3dXYEb6lNNyEaUavHEUfDRF7BVDjasM8X/DwOhg+yHd1I4=
X-Received: from pjbha5.prod.google.com ([2002:a17:90a:f3c5:b0:34b:fe89:512c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2fc8:b0:341:88c9:6eb2
 with SMTP id 98e67ed59e1d1-34f68c7a6bbmr7439400a91.1.1767930336140; Thu, 08
 Jan 2026 19:45:36 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  8 Jan 2026 19:45:25 -0800
In-Reply-To: <20260109034532.1012993-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260109034532.1012993-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109034532.1012993-2-seanjc@google.com>
Subject: [PATCH v4 1/8] KVM: selftests: Add a test to verify APICv updates
 (while L2 is active)
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"

Add a test to verify KVM correctly handles a variety of edge cases related
to APICv updates, and in particular updates that are triggered while L2 is
actively running.

Reviewed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/include/x86/apic.h  |   4 +
 .../kvm/x86/vmx_apicv_updates_test.c          | 155 ++++++++++++++++++
 3 files changed, 160 insertions(+)
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
index 000000000000..337c53fddeff
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/vmx_apicv_updates_test.c
@@ -0,0 +1,155 @@
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
+	GUEST_FAIL("Received \"bad\" IPI; ICR MMIO write should have been ignored");
+}
+
+static void l2_guest_code(void)
+{
+	x2apic_enable();
+	vmcall();
+
+	xapic_enable();
+	xapic_write_reg(APIC_ID, 1 << 24);
+	vmcall();
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
+	vcpu_args_set(vcpu, 1, vmx_pages_gva);
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
2.52.0.457.g6b5491de43-goog


