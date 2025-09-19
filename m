Return-Path: <kvm+bounces-58273-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 87203B8B8AE
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:45:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F8993A6BBD
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:45:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 003942D9EFA;
	Fri, 19 Sep 2025 22:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LlcAEKRr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38246323413
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321268; cv=none; b=LAIremehTN7K6isSYwVdXoHXbtD+BRVaE9abeO2pIvgV/oTS9heSXnUcPJodPCj/t0hsuygEUH+RaROp40qRMD/wOxmIoLF/rV255s4JRmw69cVbdK3Erx+i24r8AUEs+YKscOXpABZYS4E9X2Qe74P8SKgpXlcmk1bWudPn52I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321268; c=relaxed/simple;
	bh=739sFd75JbfTZd2JQ/f88NIygvMkSAvVwIAhM+keCYA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gN4HycetkgFeh9msmb5LYOiZxSEPqSQQTIKVy+1aIrZ6nPPKu8h62PCB7IF410SU8xJze6ojwFsIwb0zvC328yfxhDm1Pp/L3EFMSrK56N0wjP6BIRcznTpdk9OjckxAqijlyZbBi9FOkZ7h0ujpNyU/SLScfwXLqlki7MyM/2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LlcAEKRr; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-329cb4c3f78so2221436a91.2
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321265; x=1758926065; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Uz5WbVdGFOKFFG8geSidlTTPBbGKijNVu8RT00a9O10=;
        b=LlcAEKRr/DeAFSuMfONz2qIv8ug0ZbcUV7/EUyT08eCCrFO3TsCGIjdGmEQ8iG6tBg
         /TsYZoQHeBX29kTAN3GTqWhi72aP4DJLgyWjK93vwN910aw8Vgk85rXP+XWTHbgj1FJS
         n15hvQyJwdbBYsFbQdcvdUBNDA49PJ730WH0Y3IkjYtMvS1yWQxZc9Ry5djkmwj625Ej
         vPFjDfCmTvvI2l5YAKCpXgkM1Iq5YOmfUq0Ta4N9ZlPMPiOWiq30z1tRMlpHZGOkSEQ9
         Q9k7lNR0kvEvGUadrgaegfy53NS45ASH8a1xjxUIF/cIn65ZrhMMH4mYJ2yB4zkv69Tl
         2F3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321266; x=1758926066;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Uz5WbVdGFOKFFG8geSidlTTPBbGKijNVu8RT00a9O10=;
        b=bT4yZjtdPHuzMfDXDc0Xm0VC5mPHWEMHtO4i7GWGOjlnJADkRiOgsHMuenjo3AecXo
         JXIxRLKEDYQu0Wv+GwvtB7JeNrPvkKeiUaV+OW+l0pNWHv3fPuvKDIJBkkTr7kUUZ02+
         bc+T/g31rw2fHkl4arPadVmpO6dscLndul+/djWMTZai+RFMkRew6x2KpwVBGQR3IF/Y
         4vPWvZbhjg428UoHMXJTztoihw5T0D8Txu2GRehJbiPTY50pR1tKr1mUdN0V9OX7Kfb6
         W6W3JvicgIhTZ89DOnfukDbqbw7U7kkrTlmzd5hlIs06WMXXhlI+pQx5xsk4iVDqcs3s
         EfaQ==
X-Gm-Message-State: AOJu0YzoPzkNGnwBIbDW1WSHerRdOu+sVWmcZ6qk6A4t+4OyIueDUm+N
	cC6EjRDZsDASrh2wzlwO9LPJ5bZExbO075Emia+DfRLOVCV7uwuOSWng5/8JEUjMF09OCvbNMFS
	e/IA6CA==
X-Google-Smtp-Source: AGHT+IEFOYMZwCDxA0dNp9/IIIzI57FK/zoTxKYkQHdd9WyTyHR3Zg6sxzYC/nh0qQBdtiC68BiAVy8cwbk=
X-Received: from pjwx15.prod.google.com ([2002:a17:90a:c2cf:b0:329:6ac4:ea2e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1b50:b0:32e:859:c79
 with SMTP id 98e67ed59e1d1-33097c2d656mr6382353a91.0.1758321265630; Fri, 19
 Sep 2025 15:34:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:52 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-46-seanjc@google.com>
Subject: [PATCH v16 45/51] KVM: selftests: Add an MSR test to exercise
 guest/host and read/write
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

Add a selftest to verify reads and writes to various MSRs, from both the
guest and host, and expect success/failure based on whether or not the
vCPU supports the MSR according to supported CPUID.

Note, this test is extremely similar to KVM-Unit-Test's "msr" test, but
provides more coverage with respect to host accesses, and will be extended
to provide addition testing of CPUID-based features, save/restore lists,
and KVM_{G,S}ET_ONE_REG, all which are extremely difficult to validate in
KUT.

If kvm.ignore_msrs=true, skip the unsupported and reserved testcases as
KVM's ABI is a mess; what exactly is supposed to be ignored, and when,
varies wildly.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/include/x86/processor.h     |   5 +
 tools/testing/selftests/kvm/x86/msrs_test.c   | 315 ++++++++++++++++++
 3 files changed, 321 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86/msrs_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 66c82f51837b..1d1b77dabb36 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -87,6 +87,7 @@ TEST_GEN_PROGS_x86 += x86/kvm_clock_test
 TEST_GEN_PROGS_x86 += x86/kvm_pv_test
 TEST_GEN_PROGS_x86 += x86/kvm_buslock_test
 TEST_GEN_PROGS_x86 += x86/monitor_mwait_test
+TEST_GEN_PROGS_x86 += x86/msrs_test
 TEST_GEN_PROGS_x86 += x86/nested_emulation_test
 TEST_GEN_PROGS_x86 += x86/nested_exceptions_test
 TEST_GEN_PROGS_x86 += x86/platform_info_test
diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 2ad84f3809e8..fb3e6ab81a80 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -1357,6 +1357,11 @@ static inline bool kvm_is_unrestricted_guest_enabled(void)
 	return get_kvm_intel_param_bool("unrestricted_guest");
 }
 
+static inline bool kvm_is_ignore_msrs(void)
+{
+	return get_kvm_param_bool("ignore_msrs");
+}
+
 uint64_t *__vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr,
 				    int *level);
 uint64_t *vm_get_page_table_entry(struct kvm_vm *vm, uint64_t vaddr);
diff --git a/tools/testing/selftests/kvm/x86/msrs_test.c b/tools/testing/selftests/kvm/x86/msrs_test.c
new file mode 100644
index 000000000000..9285cf51ef75
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/msrs_test.c
@@ -0,0 +1,315 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <asm/msr-index.h>
+
+#include <stdint.h>
+
+#include "kvm_util.h"
+#include "processor.h"
+
+/* Use HYPERVISOR for MSRs that are emulated unconditionally (as is HYPERVISOR). */
+#define X86_FEATURE_NONE X86_FEATURE_HYPERVISOR
+
+struct kvm_msr {
+	const struct kvm_x86_cpu_feature feature;
+	const struct kvm_x86_cpu_feature feature2;
+	const char *name;
+	const u64 reset_val;
+	const u64 write_val;
+	const u64 rsvd_val;
+	const u32 index;
+};
+
+#define ____MSR_TEST(msr, str, val, rsvd, reset, feat, f2)		\
+{									\
+	.index = msr,							\
+	.name = str,							\
+	.write_val = val,						\
+	.rsvd_val = rsvd,						\
+	.reset_val = reset,						\
+	.feature = X86_FEATURE_ ##feat,					\
+	.feature2 = X86_FEATURE_ ##f2,					\
+}
+
+#define __MSR_TEST(msr, str, val, rsvd, reset, feat)			\
+	____MSR_TEST(msr, str, val, rsvd, reset, feat, feat)
+
+#define MSR_TEST_NON_ZERO(msr, val, rsvd, reset, feat)			\
+	__MSR_TEST(msr, #msr, val, rsvd, reset, feat)
+
+#define MSR_TEST(msr, val, rsvd, feat)					\
+	__MSR_TEST(msr, #msr, val, rsvd, 0, feat)
+
+#define MSR_TEST2(msr, val, rsvd, feat, f2)				\
+	____MSR_TEST(msr, #msr, val, rsvd, 0, feat, f2)
+
+/*
+ * Note, use a page aligned value for the canonical value so that the value
+ * is compatible with MSRs that use bits 11:0 for things other than addresses.
+ */
+static const u64 canonical_val = 0x123456789000ull;
+
+#define MSR_TEST_CANONICAL(msr, feat)					\
+	__MSR_TEST(msr, #msr, canonical_val, NONCANONICAL, 0, feat)
+
+/*
+ * The main struct must be scoped to a function due to the use of structures to
+ * define features.  For the global structure, allocate enough space for the
+ * foreseeable future without getting too ridiculous, to minimize maintenance
+ * costs (bumping the array size every time an MSR is added is really annoying).
+ */
+static struct kvm_msr msrs[128];
+static int idx;
+
+static bool ignore_unsupported_msrs;
+
+static u64 fixup_rdmsr_val(u32 msr, u64 want)
+{
+	/*
+	 * AMD CPUs drop bits 63:32 on some MSRs that Intel CPUs support.  KVM
+	 * is supposed to emulate that behavior based on guest vendor model
+	 * (which is the same as the host vendor model for this test).
+	 */
+	if (!host_cpu_is_amd)
+		return want;
+
+	switch (msr) {
+	case MSR_IA32_SYSENTER_ESP:
+	case MSR_IA32_SYSENTER_EIP:
+	case MSR_TSC_AUX:
+		return want & GENMASK_ULL(31, 0);
+	default:
+		return want;
+	}
+}
+
+static void __rdmsr(u32 msr, u64 want)
+{
+	u64 val;
+	u8 vec;
+
+	vec = rdmsr_safe(msr, &val);
+	__GUEST_ASSERT(!vec, "Unexpected %s on RDMSR(0x%x)", ex_str(vec), msr);
+
+	__GUEST_ASSERT(val == want, "Wanted 0x%lx from RDMSR(0x%x), got 0x%lx",
+		       want, msr, val);
+}
+
+static void __wrmsr(u32 msr, u64 val)
+{
+	u8 vec;
+
+	vec = wrmsr_safe(msr, val);
+	__GUEST_ASSERT(!vec, "Unexpected %s on WRMSR(0x%x, 0x%lx)",
+		       ex_str(vec), msr, val);
+	__rdmsr(msr, fixup_rdmsr_val(msr, val));
+}
+
+static void guest_test_supported_msr(const struct kvm_msr *msr)
+{
+	__rdmsr(msr->index, msr->reset_val);
+	__wrmsr(msr->index, msr->write_val);
+	GUEST_SYNC(fixup_rdmsr_val(msr->index, msr->write_val));
+
+	__rdmsr(msr->index, msr->reset_val);
+}
+
+static void guest_test_unsupported_msr(const struct kvm_msr *msr)
+{
+	u64 val;
+	u8 vec;
+
+	/*
+	 * KVM's ABI with respect to ignore_msrs is a mess and largely beyond
+	 * repair, just skip the unsupported MSR tests.
+	 */
+	if (ignore_unsupported_msrs)
+		goto skip_wrmsr_gp;
+
+	if (this_cpu_has(msr->feature2))
+		goto skip_wrmsr_gp;
+
+	vec = rdmsr_safe(msr->index, &val);
+	__GUEST_ASSERT(vec == GP_VECTOR, "Wanted #GP on RDMSR(0x%x), got %s",
+		       msr->index, ex_str(vec));
+
+	vec = wrmsr_safe(msr->index, msr->write_val);
+	__GUEST_ASSERT(vec == GP_VECTOR, "Wanted #GP on WRMSR(0x%x, 0x%lx), got %s",
+		       msr->index, msr->write_val, ex_str(vec));
+
+skip_wrmsr_gp:
+	GUEST_SYNC(0);
+}
+
+void guest_test_reserved_val(const struct kvm_msr *msr)
+{
+	/* Skip reserved value checks as well, ignore_msrs is trully a mess. */
+	if (ignore_unsupported_msrs)
+		return;
+
+	/*
+	 * If the CPU will truncate the written value (e.g. SYSENTER on AMD),
+	 * expect success and a truncated value, not #GP.
+	 */
+	if (!this_cpu_has(msr->feature) ||
+	    msr->rsvd_val == fixup_rdmsr_val(msr->index, msr->rsvd_val)) {
+		u8 vec = wrmsr_safe(msr->index, msr->rsvd_val);
+
+		__GUEST_ASSERT(vec == GP_VECTOR,
+			       "Wanted #GP on WRMSR(0x%x, 0x%lx), got %s",
+			       msr->index, msr->rsvd_val, ex_str(vec));
+	} else {
+		__wrmsr(msr->index, msr->rsvd_val);
+		__wrmsr(msr->index, msr->reset_val);
+	}
+}
+
+static void guest_main(void)
+{
+	for (;;) {
+		const struct kvm_msr *msr = &msrs[READ_ONCE(idx)];
+
+		if (this_cpu_has(msr->feature))
+			guest_test_supported_msr(msr);
+		else
+			guest_test_unsupported_msr(msr);
+
+		if (msr->rsvd_val)
+			guest_test_reserved_val(msr);
+
+		GUEST_SYNC(msr->reset_val);
+	}
+}
+
+static void host_test_msr(struct kvm_vcpu *vcpu, u64 guest_val)
+{
+	u64 reset_val = msrs[idx].reset_val;
+	u32 msr = msrs[idx].index;
+	u64 val;
+
+	if (!kvm_cpu_has(msrs[idx].feature))
+		return;
+
+	val = vcpu_get_msr(vcpu, msr);
+	TEST_ASSERT(val == guest_val, "Wanted 0x%lx from get_msr(0x%x), got 0x%lx",
+		    guest_val, msr, val);
+
+	vcpu_set_msr(vcpu, msr, reset_val);
+
+	val = vcpu_get_msr(vcpu, msr);
+	TEST_ASSERT(val == reset_val, "Wanted 0x%lx from get_msr(0x%x), got 0x%lx",
+		    reset_val, msr, val);
+}
+
+static void do_vcpu_run(struct kvm_vcpu *vcpu)
+{
+	struct ucall uc;
+
+	for (;;) {
+		vcpu_run(vcpu);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_SYNC:
+			host_test_msr(vcpu, uc.args[1]);
+			return;
+		case UCALL_PRINTF:
+			pr_info("%s", uc.buffer);
+			break;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+		case UCALL_DONE:
+			TEST_FAIL("Unexpected UCALL_DONE");
+		default:
+			TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
+		}
+	}
+}
+
+static void vcpus_run(struct kvm_vcpu **vcpus, const int NR_VCPUS)
+{
+	int i;
+
+	for (i = 0; i < NR_VCPUS; i++)
+		do_vcpu_run(vcpus[i]);
+}
+
+#define MISC_ENABLES_RESET_VAL (MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL | MSR_IA32_MISC_ENABLE_BTS_UNAVAIL)
+
+static void test_msrs(void)
+{
+	const struct kvm_msr __msrs[] = {
+		MSR_TEST_NON_ZERO(MSR_IA32_MISC_ENABLE,
+				  MISC_ENABLES_RESET_VAL | MSR_IA32_MISC_ENABLE_FAST_STRING,
+				  MSR_IA32_MISC_ENABLE_FAST_STRING, MISC_ENABLES_RESET_VAL, NONE),
+		MSR_TEST_NON_ZERO(MSR_IA32_CR_PAT, 0x07070707, 0, 0x7040600070406, NONE),
+
+		/*
+		 * TSC_AUX is supported if RDTSCP *or* RDPID is supported.  Add
+		 * entries for each features so that TSC_AUX doesn't exists for
+		 * the "unsupported" vCPU, and obviously to test both cases.
+		 */
+		MSR_TEST2(MSR_TSC_AUX, 0x12345678, canonical_val, RDTSCP, RDPID),
+		MSR_TEST2(MSR_TSC_AUX, 0x12345678, canonical_val, RDPID, RDTSCP),
+
+		MSR_TEST(MSR_IA32_SYSENTER_CS, 0x1234, 0, NONE),
+		/*
+		 * SYSENTER_{ESP,EIP} are technically non-canonical on Intel,
+		 * but KVM doesn't emulate that behavior on emulated writes,
+		 * i.e. this test will observe different behavior if the MSR
+		 * writes are handed by hardware vs. KVM.  KVM's behavior is
+		 * intended (though far from ideal), so don't bother testing
+		 * non-canonical values.
+		 */
+		MSR_TEST(MSR_IA32_SYSENTER_ESP, canonical_val, 0, NONE),
+		MSR_TEST(MSR_IA32_SYSENTER_EIP, canonical_val, 0, NONE),
+
+		MSR_TEST_CANONICAL(MSR_FS_BASE, LM),
+		MSR_TEST_CANONICAL(MSR_GS_BASE, LM),
+		MSR_TEST_CANONICAL(MSR_KERNEL_GS_BASE, LM),
+		MSR_TEST_CANONICAL(MSR_LSTAR, LM),
+		MSR_TEST_CANONICAL(MSR_CSTAR, LM),
+		MSR_TEST(MSR_SYSCALL_MASK, 0xffffffff, 0, LM),
+
+		MSR_TEST_CANONICAL(MSR_IA32_PL0_SSP, SHSTK),
+		MSR_TEST(MSR_IA32_PL0_SSP, canonical_val, canonical_val | 1, SHSTK),
+		MSR_TEST_CANONICAL(MSR_IA32_PL1_SSP, SHSTK),
+		MSR_TEST(MSR_IA32_PL1_SSP, canonical_val, canonical_val | 1, SHSTK),
+		MSR_TEST_CANONICAL(MSR_IA32_PL2_SSP, SHSTK),
+		MSR_TEST(MSR_IA32_PL2_SSP, canonical_val, canonical_val | 1, SHSTK),
+		MSR_TEST_CANONICAL(MSR_IA32_PL3_SSP, SHSTK),
+		MSR_TEST(MSR_IA32_PL3_SSP, canonical_val, canonical_val | 1, SHSTK),
+	};
+
+	/*
+	 * Create two vCPUs, but run them on the same task, to validate KVM's
+	 * context switching of MSR state.  Don't pin the task to a pCPU to
+	 * also validate KVM's handling of cross-pCPU migration.
+	 */
+	const int NR_VCPUS = 2;
+	struct kvm_vcpu *vcpus[NR_VCPUS];
+	struct kvm_vm *vm;
+
+	kvm_static_assert(sizeof(__msrs) <= sizeof(msrs));
+	kvm_static_assert(ARRAY_SIZE(__msrs) <= ARRAY_SIZE(msrs));
+	memcpy(msrs, __msrs, sizeof(__msrs));
+
+	ignore_unsupported_msrs = kvm_is_ignore_msrs();
+
+	vm = vm_create_with_vcpus(NR_VCPUS, guest_main, vcpus);
+
+	sync_global_to_guest(vm, msrs);
+	sync_global_to_guest(vm, ignore_unsupported_msrs);
+
+	for (idx = 0; idx < ARRAY_SIZE(__msrs); idx++) {
+		sync_global_to_guest(vm, idx);
+
+		vcpus_run(vcpus, NR_VCPUS);
+		vcpus_run(vcpus, NR_VCPUS);
+	}
+
+	kvm_vm_free(vm);
+}
+
+int main(void)
+{
+	test_msrs();
+}
-- 
2.51.0.470.ga7dc726c21-goog


