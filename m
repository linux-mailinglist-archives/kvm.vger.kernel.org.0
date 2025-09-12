Return-Path: <kvm+bounces-57478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DEF1DB55A41
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:34:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8FE3216FA90
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 23:34:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 588212E62C5;
	Fri, 12 Sep 2025 23:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lODHSsYh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8FE2E54A7
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 23:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757719470; cv=none; b=oG84BjanKN6uEHDuCl+e/IkDZF+0Vdb88+A6/1BIjqqU11FJY1AcEOXOBVgFl97UehXOPnekuZmO7fsgRRTZi1tPvr6KP0p0QtBfqbsqie/Kd6C6CrF1oGluoCF5AK/XYa6JeNkwuky9KI69K46edO2RZxHO+yLae149PS+TgfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757719470; c=relaxed/simple;
	bh=B/+fboJ5jcpg2gOGOCB/m3OcoD4VBafeiF/boJ4NMkk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PTrfba0znyFzGB9bH3C/5v+0BT6VuLMG3iUh5nYAvId9rIkKX/MMunm0ocrWF4DzGNau05gxwCMExulSK0uUVVbtY5wYbOD53aAQhZujgXyFAhZsCQT/kYX8mTIxkhVvyYbY5X1wSwjHk7e5Oc3nMmmIQdX4uyQyhpa39MDlY0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lODHSsYh; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b54abd7e048so764904a12.2
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 16:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757719468; x=1758324268; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Ody2DPDQuuD4Pb68BebF5fqDAK2OZjnGHkBkDngH0Ec=;
        b=lODHSsYh6LOB1Teqsjuf1g/+ybRVCMWQgGGmBsUKfjUi0C2xT1HRyFwuzBDWDbMPpD
         Tv97VIhmNJB088cb3AL1C+L6OroCZr95QTq8dcchEI1vcajbVDbhzbCSrIPItffRmR9q
         8sw6kpAfZOtVp2BBvrpq7MmcIXPdLop1gzdziXMV+jvQHIOui/vxyxiz5nZ9r9ucscAl
         lHARr5A+5Lv4zLywO7gG//aa+DZAxzPPoULj+rA0Tc25lo/IgljZRK4AisFg/J9nrWt8
         GOt47m1x6zHbHiyxoTbohhPj+on6OGR0PAG/GgZURs+09y22184KO2wU52U2xdHgrECd
         yQrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719468; x=1758324268;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ody2DPDQuuD4Pb68BebF5fqDAK2OZjnGHkBkDngH0Ec=;
        b=UsnMjgAFYXxjsACOK9I3PYGCEyGRFs8hWlXj6S/cooXveL91P9e3f8Jv1TpmpMrCfd
         /+FYTxgfoE8kj08aOZI1iJ9wMAZHnUbucIeigjq3Mgo1GvqWAUsaOhodk8XshBIhNKxt
         jx+9EPeaXniT8EEb9yfOLFwnFm9dCo8+N7t7iku9kh0Y+LAtqi3um4ybdBn5D8p3khto
         OEqwv/mnzKNPHVTa3T58xYm5qmC++jL9ONUzwct0RGSnDSZPajTh5UUwRJHUTeR/830M
         c1PV92NzgpELAE3sgdyiegder0n8nD3AW6S7irEz6a8FD8d5kusDdAVTvKUJ/fir40WU
         ySlw==
X-Gm-Message-State: AOJu0YzmW8sUgbcxLUqDHZktirvhQqERr02Wi++qp65WiRKb9pnmgHaa
	sQ3UmTHH2joeY6W6pBPxBSwcwunHGebrSEMktbNiIDmU4pO+giQldeS7emAv39Znz15exJVJNxI
	p8aPFmg==
X-Google-Smtp-Source: AGHT+IHSkHoCYyr2f+mu2dwrdKUG2xiR19xQInw8PU/Rofl1P/JX8mJckrqo+5vlLZh7353SX4R7cbenNtM=
X-Received: from pjbss7.prod.google.com ([2002:a17:90b:2ec7:b0:312:e266:f849])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3ca3:b0:240:1e97:7a15
 with SMTP id adf61e73a8af0-2602af7da02mr6197330637.27.1757719468023; Fri, 12
 Sep 2025 16:24:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Sep 2025 16:23:13 -0700
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912232319.429659-36-seanjc@google.com>
Subject: [PATCH v15 35/41] KVM: selftests: Add an MSR test to exercise
 guest/host and read/write
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Add a selftest to verify reads and writes to various MSRs, from both the
guest and host, and expect success/failure based on whether or not the
vCPU supports the MSR according to supported CPUID.

Note, this test is extremely similar to KVM-Unit-Test's "msr" test, but
provides more coverage with respect to host accesses, and will be extended
to provide addition testing of CPUID-based features, save/restore lists,
and KVM_{G,S}ET_ONE_REG, all which are extremely difficult to validate in
KUT.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm    |   1 +
 tools/testing/selftests/kvm/x86/msrs_test.c | 267 ++++++++++++++++++++
 2 files changed, 268 insertions(+)
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
diff --git a/tools/testing/selftests/kvm/x86/msrs_test.c b/tools/testing/selftests/kvm/x86/msrs_test.c
new file mode 100644
index 000000000000..dcb429cf1440
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/msrs_test.c
@@ -0,0 +1,267 @@
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
+	const char *name;
+	const u64 reset_val;
+	const u64 write_val;
+	const u64 rsvd_val;
+	const u32 index;
+};
+
+#define __MSR_TEST(msr, str, val, rsvd, reset, feat)			\
+{									\
+	.index = msr,							\
+	.name = str,							\
+	.write_val = val,						\
+	.rsvd_val = rsvd,						\
+	.reset_val = reset,						\
+	.feature = X86_FEATURE_ ##feat,					\
+}
+
+#define MSR_TEST_NON_ZERO(msr, val, rsvd, reset, feat)			\
+	__MSR_TEST(msr, #msr, val, rsvd, reset, feat)
+
+#define MSR_TEST(msr, val, rsvd, feat)					\
+	__MSR_TEST(msr, #msr, val, rsvd, 0, feat)
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
+static u64 fixup_rdmsr_val(u32 msr, u64 want)
+{
+	/* AMD CPUs drop bits 63:32, and KVM is supposed to emulate that. */
+	if (host_cpu_is_amd &&
+	    (msr == MSR_IA32_SYSENTER_ESP || msr == MSR_IA32_SYSENTER_EIP))
+		want &= GENMASK_ULL(31, 0);
+
+	return want;
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
+	vec = rdmsr_safe(msr->index, &val);
+	__GUEST_ASSERT(vec == GP_VECTOR, "Wanted #GP on RDMSR(0x%x), got %s",
+		       msr->index, ex_str(vec));
+
+	vec = wrmsr_safe(msr->index, msr->write_val);
+	__GUEST_ASSERT(vec == GP_VECTOR, "Wanted #GP on WRMSR(0x%x, 0x%lx), got %s",
+		       msr->index, msr->write_val, ex_str(vec));
+
+	GUEST_SYNC(0);
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
+		/*
+		 * Skipped the "reserved" value check if the CPU will truncate
+		 * the written value (e.g. SYSENTER on AMD), in which case the
+		 * upper value is simply ignored.
+		 */
+		if (msr->rsvd_val &&
+		    msr->rsvd_val == fixup_rdmsr_val(msr->index, msr->rsvd_val)) {
+			u8 vec = wrmsr_safe(msr->index, msr->rsvd_val);
+
+			__GUEST_ASSERT(vec == GP_VECTOR,
+				       "Wanted #GP on WRMSR(0x%x, 0x%lx), got %s",
+				       msr->index, msr->rsvd_val, ex_str(vec));
+		}
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
+static void __vcpus_run(struct kvm_vcpu **vcpus, const int NR_VCPUS)
+{
+	int i;
+
+	for (i = 0; i < NR_VCPUS; i++)
+		do_vcpu_run(vcpus[i]);
+}
+
+static void vcpus_run(struct kvm_vcpu **vcpus, const int NR_VCPUS)
+{
+	__vcpus_run(vcpus, NR_VCPUS);
+	__vcpus_run(vcpus, NR_VCPUS);
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
+	vm = vm_create_with_vcpus(NR_VCPUS, guest_main, vcpus);
+
+	sync_global_to_guest(vm, msrs);
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
2.51.0.384.g4c02a37b29-goog


