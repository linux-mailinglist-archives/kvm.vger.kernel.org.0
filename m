Return-Path: <kvm+bounces-50778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DDD80AE934D
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 02:13:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78C623BF49B
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 00:13:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C10DB1A317D;
	Thu, 26 Jun 2025 00:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZGYnwZMy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3527176242
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 00:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750896757; cv=none; b=LYetrCgh7iF3SUxlNq9/9t+7weHzuC9hdsZlY+NrnhyEtdwmozhBF+bQDiiqMeZuzCPEs5PsTESdCpzmiQJS0xW3YcW/8cgK/BDvR/s90e2jFlJFrc73KmNY0vSdB75XXcjWj84DfCc5IQMuHlqeX++rwZ20jE924vXxEpiLEmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750896757; c=relaxed/simple;
	bh=S8YepjEcxw5aH+WyUJggwrBoMjNRQccpLKuukAOR0KI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AyT0JPGuIV8n1OBVa3/0SWC7rVDOjFQdDxO40VyLOkTq7JeTo0/k+AKVnu52y1fzM7zCEO5/LWfiT8U4oosq1GZpcK8NjJL40EPyW7GW8ZPlkkR66QW68JMpm87Kow4mKjdA4/BZ3EAwjmulsuXAA6g9VOPbu8PKcGB1yCesAwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZGYnwZMy; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3138c50d2a0so517208a91.2
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 17:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750896755; x=1751501555; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yHMfQhJxDmXXWypElOJUlq66wLvvI9/lh/NpqNUW0Yc=;
        b=ZGYnwZMy+x+LXIlYgfZsUSN4ZFRFOxzd8gaQegM9wzipZck/jv/fVBb1rx2onw4hKJ
         QqfpKPGo1S9Q7b3E2D5QXzw+aquCVQNpFGKob6LQ7sRHKEeSFuVWXygqg7IYuWeUJjwo
         SpY5cVKYUOaygIjkhG835p3DsJIDNiJjmNXrByZfXn0DxnzvY7e6CW94UZPaWSOxMTRX
         X6mDkEFaBMR/GTv5/nXj3PzepyAoS9dMfeDM8/2BD8hJggpF1If5thRMJWFGbrAhX5LI
         M5h0qlUax8+EJPW+nBh5iC7okGMb34ytxjmR66xx1nNeWE2tUIACKxxFl8zoLjWcoynF
         AtOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750896755; x=1751501555;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yHMfQhJxDmXXWypElOJUlq66wLvvI9/lh/NpqNUW0Yc=;
        b=PL4ERkq23xk1BeONU55v3xfx4evTKE9ZFg1NJjObTYRmW0Ogq5mhetgMmHx8nM1dIU
         7Au5zcWpg7gLgt53BICFWPjA4iI1CYJwtDF/2kMSCttdtX+ewAgYg26BeIBPAxe5JA9M
         WWBt0dZlBJL95yxXUAXsOddU7jiIIqUhwtiJUIyv/vb2WfjFkxjeRqKvC/IzvSQM9CVp
         ypRkY+NQW/A2Oz7o7c+ScNYKPnCHhOpZNkmxWCkE61eW8m8zWF40RZ+nUCxyT7UY0Pc3
         +XSRp8y2geJeLrKaXgEWr1Xapw2X3r6M+dTxS9qEeDhE1VZ5oF3h79dE/uJCs4LP24pQ
         NkPw==
X-Gm-Message-State: AOJu0Yx/fDAHEebaaG3gOavuVvoOYnrK3/rjRPBRbJ3LgRMiSuD4yWCL
	a5fNeTNymgTDktg40/oZhlBBJGk1KZQHe0+1zlc/JKCCTo9Yjew59BtmRDBHWQrZKVLYl0pY6Zh
	0XuEwwg==
X-Google-Smtp-Source: AGHT+IFowPBB2GQmhp5GlgAqt6FlhUMcLhBMaNbsbDieOoJyK6IVevkDm0adw8K1pYlNDs+iSlSqacu2PHU=
X-Received: from pjbnd12.prod.google.com ([2002:a17:90b:4ccc:b0:2e0:915d:d594])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:350e:b0:312:f54e:ba28
 with SMTP id 98e67ed59e1d1-315f2689fa0mr7190023a91.24.1750896755366; Wed, 25
 Jun 2025 17:12:35 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 25 Jun 2025 17:12:24 -0700
In-Reply-To: <20250626001225.744268-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250626001225.744268-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250626001225.744268-5-seanjc@google.com>
Subject: [PATCH v5 4/5] KVM: selftests: Test behavior of KVM_X86_DISABLE_EXITS_APERFMPERF
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Jim Mattson <jmattson@google.com>

For a VCPU thread pinned to a single LPU, verify that interleaved host
and guest reads of IA32_[AM]PERF return strictly increasing values when
APERFMPERF exiting is disabled.

Run the test in both L1 and L2 to verify that KVM passes through the
APERF and MPERF MSRs when L1 doesn't want to intercept them (or any MSRs).

Signed-off-by: Jim Mattson <jmattson@google.com>
Link: https://lore.kernel.org/r/20250530185239.2335185-4-jmattson@google.com
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/x86/aperfmperf_test.c       | 213 ++++++++++++++++++
 2 files changed, 214 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86/aperfmperf_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 028456f1aae1..40920445bfbe 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -135,6 +135,7 @@ TEST_GEN_PROGS_x86 += x86/amx_test
 TEST_GEN_PROGS_x86 += x86/max_vcpuid_cap_test
 TEST_GEN_PROGS_x86 += x86/triple_fault_event_test
 TEST_GEN_PROGS_x86 += x86/recalc_apic_map_test
+TEST_GEN_PROGS_x86 += x86/aperfmperf_test
 TEST_GEN_PROGS_x86 += access_tracking_perf_test
 TEST_GEN_PROGS_x86 += coalesced_io_test
 TEST_GEN_PROGS_x86 += dirty_log_perf_test
diff --git a/tools/testing/selftests/kvm/x86/aperfmperf_test.c b/tools/testing/selftests/kvm/x86/aperfmperf_test.c
new file mode 100644
index 000000000000..8b15a13df939
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/aperfmperf_test.c
@@ -0,0 +1,213 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Test for KVM_X86_DISABLE_EXITS_APERFMPERF
+ *
+ * Copyright (C) 2025, Google LLC.
+ *
+ * Test the ability to disable VM-exits for rdmsr of IA32_APERF and
+ * IA32_MPERF. When these VM-exits are disabled, reads of these MSRs
+ * return the host's values.
+ *
+ * Note: Requires read access to /dev/cpu/<lpu>/msr to read host MSRs.
+ */
+
+#include <fcntl.h>
+#include <limits.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdint.h>
+#include <unistd.h>
+#include <asm/msr-index.h>
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "svm_util.h"
+#include "test_util.h"
+#include "vmx.h"
+
+#define NUM_ITERATIONS 10000
+
+static int open_dev_msr(int cpu)
+{
+	char path[PATH_MAX];
+
+	snprintf(path, sizeof(path), "/dev/cpu/%d/msr", cpu);
+	return open_path_or_exit(path, O_RDONLY);
+}
+
+static uint64_t read_dev_msr(int msr_fd, uint32_t msr)
+{
+	uint64_t data;
+	ssize_t rc;
+
+	rc = pread(msr_fd, &data, sizeof(data), msr);
+	TEST_ASSERT(rc == sizeof(data), "Read of MSR 0x%x failed", msr);
+
+	return data;
+}
+
+static void guest_read_aperf_mperf(void)
+{
+	int i;
+
+	for (i = 0; i < NUM_ITERATIONS; i++)
+		GUEST_SYNC2(rdmsr(MSR_IA32_APERF), rdmsr(MSR_IA32_MPERF));
+}
+
+#define L2_GUEST_STACK_SIZE	64
+
+static void l2_guest_code(void)
+{
+	guest_read_aperf_mperf();
+	GUEST_DONE();
+}
+
+static void l1_svm_code(struct svm_test_data *svm)
+{
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	struct vmcb *vmcb = svm->vmcb;
+
+	generic_svm_setup(svm, l2_guest_code, &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+	run_guest(vmcb, svm->vmcb_gpa);
+}
+
+static void l1_vmx_code(struct vmx_pages *vmx)
+{
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+
+	GUEST_ASSERT_EQ(prepare_for_vmx_operation(vmx), true);
+	GUEST_ASSERT_EQ(load_vmcs(vmx), true);
+
+	prepare_vmcs(vmx, NULL, &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	/*
+	 * Enable MSR bitmaps (the bitmap itself is allocated, zeroed, and set
+	 * in the VMCS by prepare_vmcs()), as MSR exiting mandatory on Intel.
+	 */
+	vmwrite(CPU_BASED_VM_EXEC_CONTROL,
+		vmreadz(CPU_BASED_VM_EXEC_CONTROL) | CPU_BASED_USE_MSR_BITMAPS);
+
+	GUEST_ASSERT(!vmwrite(GUEST_RIP, (u64)l2_guest_code));
+	GUEST_ASSERT(!vmlaunch());
+}
+
+static void guest_code(void *nested_test_data)
+{
+	guest_read_aperf_mperf();
+
+	if (this_cpu_has(X86_FEATURE_SVM))
+		l1_svm_code(nested_test_data);
+	else if (this_cpu_has(X86_FEATURE_VMX))
+		l1_vmx_code(nested_test_data);
+	else
+		GUEST_DONE();
+
+	TEST_FAIL("L2 should have signaled 'done'");
+}
+
+static void guest_no_aperfmperf(void)
+{
+	uint64_t msr_val;
+	uint8_t vector;
+
+	vector = rdmsr_safe(MSR_IA32_APERF, &msr_val);
+	GUEST_ASSERT(vector == GP_VECTOR);
+
+	vector = rdmsr_safe(MSR_IA32_APERF, &msr_val);
+	GUEST_ASSERT(vector == GP_VECTOR);
+
+	GUEST_DONE();
+}
+
+int main(int argc, char *argv[])
+{
+	const bool has_nested = kvm_cpu_has(X86_FEATURE_SVM) || kvm_cpu_has(X86_FEATURE_VMX);
+	uint64_t host_aperf_before, host_mperf_before;
+	vm_vaddr_t nested_test_data_gva;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	int msr_fd, cpu, i;
+
+	/* Sanity check that APERF/MPERF are unsupported by default. */
+	vm = vm_create_with_one_vcpu(&vcpu, guest_no_aperfmperf);
+	vcpu_run(vcpu);
+	TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
+	kvm_vm_free(vm);
+
+	cpu = pin_self_to_any_cpu();
+
+	msr_fd = open_dev_msr(cpu);
+
+	/*
+	 * This test requires a non-standard VM initialization, because
+	 * KVM_ENABLE_CAP cannot be used on a VM file descriptor after
+	 * a VCPU has been created.
+	 */
+	vm = vm_create(1);
+
+	TEST_REQUIRE(vm_check_cap(vm, KVM_CAP_X86_DISABLE_EXITS) &
+		     KVM_X86_DISABLE_EXITS_APERFMPERF);
+
+	vm_enable_cap(vm, KVM_CAP_X86_DISABLE_EXITS,
+		      KVM_X86_DISABLE_EXITS_APERFMPERF);
+
+	vcpu = vm_vcpu_add(vm, 0, guest_code);
+
+	if (!has_nested)
+		nested_test_data_gva = NONCANONICAL;
+	else if (kvm_cpu_has(X86_FEATURE_SVM))
+		vcpu_alloc_svm(vm, &nested_test_data_gva);
+	else
+		vcpu_alloc_vmx(vm, &nested_test_data_gva);
+
+	vcpu_args_set(vcpu, 1, nested_test_data_gva);
+
+	host_aperf_before = read_dev_msr(msr_fd, MSR_IA32_APERF);
+	host_mperf_before = read_dev_msr(msr_fd, MSR_IA32_MPERF);
+
+	for (i = 0; i <= NUM_ITERATIONS * (1 + has_nested); i++) {
+		uint64_t host_aperf_after, host_mperf_after;
+		uint64_t guest_aperf, guest_mperf;
+		struct ucall uc;
+
+		vcpu_run(vcpu);
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_DONE:
+			goto done;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+		case UCALL_SYNC:
+			guest_aperf = uc.args[0];
+			guest_mperf = uc.args[1];
+
+			host_aperf_after = read_dev_msr(msr_fd, MSR_IA32_APERF);
+			host_mperf_after = read_dev_msr(msr_fd, MSR_IA32_MPERF);
+
+			TEST_ASSERT(host_aperf_before < guest_aperf,
+				    "APERF: host_before (0x%" PRIx64 ") >= guest (0x%" PRIx64 ")",
+				    host_aperf_before, guest_aperf);
+			TEST_ASSERT(guest_aperf < host_aperf_after,
+				    "APERF: guest (0x%" PRIx64 ") >= host_after (0x%" PRIx64 ")",
+				    guest_aperf, host_aperf_after);
+			TEST_ASSERT(host_mperf_before < guest_mperf,
+				    "MPERF: host_before (0x%" PRIx64 ") >= guest (0x%" PRIx64 ")",
+				    host_mperf_before, guest_mperf);
+			TEST_ASSERT(guest_mperf < host_mperf_after,
+				    "MPERF: guest (0x%" PRIx64 ") >= host_after (0x%" PRIx64 ")",
+				    guest_mperf, host_mperf_after);
+
+			host_aperf_before = host_aperf_after;
+			host_mperf_before = host_mperf_after;
+
+			break;
+		}
+	}
+	TEST_FAIL("Didn't receive UCALL_DONE\n");
+done:
+	kvm_vm_free(vm);
+	close(msr_fd);
+
+	return 0;
+}
-- 
2.50.0.727.gbf7dc18ff4-goog


