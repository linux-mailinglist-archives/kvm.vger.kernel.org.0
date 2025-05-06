Return-Path: <kvm+bounces-45547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 34EDFAAB8C3
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 08:41:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E3AB16864C
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 06:40:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D39C6298CA0;
	Tue,  6 May 2025 03:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MW2fIkft"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6474A3537CA
	for <kvm@vger.kernel.org>; Tue,  6 May 2025 01:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746493976; cv=none; b=rvxvd8OLnO5jyQv1OJbAF3/wkXUCsdCISNUGWlIC76hcQx1sy41ZaUb6X2fyW4b1SeOv671DnQ4NTnqLDo7FDUhvp2eDY5NK+mz2H4mdsAJRB/OL4PwYSax/Kn+mmm8L9lYngb4/yyup8Zw8IPNqQ5HrhBsspThJFhHkdei7LSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746493976; c=relaxed/simple;
	bh=ByqIMP6Nh3w5W69TJIMu1deyWSJVf6m4KcbXUwNDpV4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=S2TiLrZ5N/n+RT0dtrBGhWXblhoMXARAc3RWoUJYu8Uo5+ueBbt/X5R7jPIMSkZZn/gWoPnvYwximrwfLU+B95Rmdfor8CBatyUe5S9Xd21Z5+AqT2W6cF8LzD4gkeSr5uSuDLdt9+/9X3w92P6U3WM2EZ8XZ3/0Kh1TSLC9ss0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MW2fIkft; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-309e8dc1e21so4849738a91.0
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 18:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746493972; x=1747098772; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CEVGH9kkgwJIz3AfndqYyl8Bygb46xzfOaZWEs7TXHE=;
        b=MW2fIkftNV6DloozJPoVbX0m0833seYL6u6Ve6FhEg3+DvgtXZK9abWsYISYjkQnYQ
         eAKCz8J+tNoJ8gsU3B4+6dGhpb9B5c5jNYh6qdP0EhiQME/RYxA0dppclOu6tG7nIYBz
         9Pqsa9z54q105OQM8oysgxrNWltyYaXdy3HLH9dBDCgqQLneKyJeigNSCJIy9Gupfw6r
         CR2/MkgT2EO+R9nt4kCJ6XB80coWEGJOm8Ascpbv2FiwAwWl0u6WXISWf90DAqe2JdML
         Z1rS93j2s2Q0qf7Wb7F4NVge+b13c4Q/wvy+VM+heymNpYCCO+N+KWABg0//4oFO7xm/
         G2FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746493972; x=1747098772;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CEVGH9kkgwJIz3AfndqYyl8Bygb46xzfOaZWEs7TXHE=;
        b=R0euYCLfIX5BJkXjFvhQBT77ydAPLHNdZGsTugVi/NutKAKdMzwVjQ0cpjwbq7u9VG
         FFLg8BZEyhweR9ORq3KqrHAskahOBr3cNvW71pCtG54GiMS6PJhp27pXd9OzCs1TZkTB
         pu+DdUibihoRX8TwYI/Ezuwr0TdUDUVwfRopiuwocQKZcBnDvelMK0hwrwh+fk/cD41y
         RRKka2TTQZ496jFKy5/OLd2ly067GgvXoB7d95mR+YxP/C5WMoswgLRTFGCcU+9XxVcI
         QHIqzY4z0yX396Vd0XwXUAQzb1Jd0+VCXz3HsU0mm6Z0pjGpd5GQvihk0B24dUxoMsZS
         jFZw==
X-Gm-Message-State: AOJu0YyNJAmMlPvbgokmcJ4YjHQFd/4rcNrQJbrGc52RSkQc6q1klUcH
	CPaKLH2IQPsxgSNTIlhzr+ooHAjv3Zrx+sEHUDj8NFTlodD9VlCSmqjyMV59j/UWtym/fy69BIa
	e+A==
X-Google-Smtp-Source: AGHT+IHgYChK2GebS8daaWohYQeS4T0jHHXxX01AdhMPXg4gIABW2m4Tzyl1WWyigJ23sIW+H2nARb09coI=
X-Received: from pjgg12.prod.google.com ([2002:a17:90b:57cc:b0:2fa:15aa:4d1e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d60b:b0:2fa:2133:bc87
 with SMTP id 98e67ed59e1d1-30a7bad8b05mr2222611a91.6.1746493972553; Mon, 05
 May 2025 18:12:52 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon,  5 May 2025 18:12:50 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250506011250.1089254-1-seanjc@google.com>
Subject: [PATCH] KVM: selftests: Add a test for x86's fastops emulation
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add a test to verify KVM's fastops emulation via forced emulation.  KVM's
so called "fastop" infrastructure executes the to-be-emulated instruction
directly on hardware instead of manually emulating the instruction in
software, using various shenanigans to glue together the emulator context
and CPU state, e.g. to get RFLAGS fed into the instruction and back out
for the emulator.

Add testcases for all instructions that are low hanging fruit.  While the
primary goal of the selftest is to validate the glue code, a secondary
goal is to ensure "emulation" matches hardware exactly, including for
arithmetic flags that are architecturally undefined.  While arithmetic
flags may be *architecturally* undefined, their behavior is deterministic
for a given CPU (likely a given uarch, and possibly even an entire family
or class of CPUs).  I.e. KVM has effectively been emulating underlying
hardware behavior for years.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../testing/selftests/kvm/x86/fastops_test.c  | 165 ++++++++++++++++++
 2 files changed, 166 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86/fastops_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index f62b0a5aba35..411c3d5eb5b1 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -66,6 +66,7 @@ TEST_GEN_PROGS_x86 += x86/cr4_cpuid_sync_test
 TEST_GEN_PROGS_x86 += x86/dirty_log_page_splitting_test
 TEST_GEN_PROGS_x86 += x86/feature_msrs_test
 TEST_GEN_PROGS_x86 += x86/exit_on_emulation_failure_test
+TEST_GEN_PROGS_x86 += x86/fastops_test
 TEST_GEN_PROGS_x86 += x86/fix_hypercall_test
 TEST_GEN_PROGS_x86 += x86/hwcr_msr_test
 TEST_GEN_PROGS_x86 += x86/hyperv_clock
diff --git a/tools/testing/selftests/kvm/x86/fastops_test.c b/tools/testing/selftests/kvm/x86/fastops_test.c
new file mode 100644
index 000000000000..2ac89d6c1e46
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/fastops_test.c
@@ -0,0 +1,165 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+
+/*
+ * Execute a fastop() instruction, with or without forced emulation.  BT bit 0
+ * to set RFLAGS.CF based on whether or not the input is even or odd, so that
+ * instructions like ADC and SBB are deterministic.
+ */
+#define guest_execute_fastop_1(FEP, insn, __val, __flags)				\
+({											\
+	__asm__ __volatile__("bt $0, %[val]\n\t"					\
+			     FEP insn " %[val]\n\t"					\
+			     "pushfq\n\t"						\
+			     "pop %[flags]\n\t"						\
+			     : [val]"+r"(__val), [flags]"=r"(__flags)			\
+			     : : "cc", "memory");					\
+})
+
+#define guest_test_fastop_1(insn, type_t, __val)					\
+({											\
+	type_t val = __val, ex_val = __val, input = __val;				\
+	uint64_t flags, ex_flags;							\
+											\
+	guest_execute_fastop_1("", insn, ex_val, ex_flags);				\
+	guest_execute_fastop_1(KVM_FEP, insn, val, flags);				\
+											\
+	__GUEST_ASSERT(val == ex_val,							\
+		       "Wanted 0x%lx for '%s 0x%lx', got 0x%lx",			\
+		       (uint64_t)ex_val, insn, (uint64_t)input, (uint64_t)val);		\
+	__GUEST_ASSERT(flags == ex_flags,						\
+			"Wanted flags 0x%lx for '%s 0x%lx', got 0x%lx",			\
+			ex_flags, insn, (uint64_t)input, flags);			\
+})
+
+#define guest_execute_fastop_2(FEP, insn, __input, __output, __flags)			\
+({											\
+	__asm__ __volatile__("bt $0, %[output]\n\t"					\
+			     FEP insn " %[input], %[output]\n\t"			\
+			     "pushfq\n\t"						\
+			     "pop %[flags]\n\t"						\
+			     : [output]"+r"(__output), [flags]"=r"(__flags)		\
+			     : [input]"r"(__input) : "cc", "memory");			\
+})
+
+#define guest_test_fastop_2(insn, type_t, __val1, __val2)				\
+({											\
+	type_t input = __val1, input2 = __val2, output = __val2, ex_output = __val2;	\
+	uint64_t flags, ex_flags;							\
+											\
+	guest_execute_fastop_2("", insn, input, ex_output, ex_flags);			\
+	guest_execute_fastop_2(KVM_FEP, insn, input, output, flags);			\
+											\
+	__GUEST_ASSERT(output == ex_output,						\
+		       "Wanted 0x%lx for '%s 0x%lx 0x%lx', got 0x%lx",			\
+		       (uint64_t)ex_output, insn, (uint64_t)input,			\
+		       (uint64_t)input2, (uint64_t)output);				\
+	__GUEST_ASSERT(flags == ex_flags,						\
+			"Wanted flags 0x%lx for '%s 0x%lx, 0x%lx', got 0x%lx",		\
+			ex_flags, insn, (uint64_t)input, (uint64_t)input2, flags);	\
+})
+
+#define guest_execute_fastop_cl(FEP, insn, __shift, __output, __flags)			\
+({											\
+	__asm__ __volatile__("bt $0, %[output]\n\t"					\
+			     FEP insn " %%cl, %[output]\n\t"				\
+			     "pushfq\n\t"						\
+			     "pop %[flags]\n\t"						\
+			     : [output]"+r"(__output), [flags]"=r"(__flags)		\
+			     : "c"(__shift) : "cc", "memory");				\
+})
+
+#define guest_test_fastop_cl(insn, type_t, __val1, __val2)				\
+({											\
+	type_t output = __val2, ex_output = __val2, input = __val2;			\
+	uint8_t shift = __val1;								\
+	uint64_t flags, ex_flags;							\
+											\
+	guest_execute_fastop_cl("", insn, shift, ex_output, ex_flags);			\
+	guest_execute_fastop_cl(KVM_FEP, insn, shift, output, flags);			\
+											\
+	__GUEST_ASSERT(output == ex_output,						\
+		       "Wanted 0x%lx for '%s 0x%x, 0x%lx', got 0x%lx",			\
+		       (uint64_t)ex_output, insn, shift, (uint64_t)input,		\
+		       (uint64_t)output);						\
+	__GUEST_ASSERT(flags == ex_flags,						\
+			"Wanted flags 0x%lx for '%s 0x%x, 0x%lx', got 0x%lx",		\
+			ex_flags, insn, shift, (uint64_t)input, flags);			\
+})
+
+static const uint64_t vals[] = {
+	0,
+	1,
+	2,
+	4,
+	7,
+	0x5555555555555555,
+	0xaaaaaaaaaaaaaaaa,
+	0xfefefefefefefefe,
+	0xffffffffffffffff,
+};
+
+#define guest_test_fastops(type_t, suffix)						\
+do {											\
+	int i, j;									\
+											\
+	for (i = 0; i < ARRAY_SIZE(vals); i++) {					\
+		guest_test_fastop_1("dec" suffix, type_t, vals[i]);			\
+		guest_test_fastop_1("inc" suffix, type_t, vals[i]);			\
+		guest_test_fastop_1("neg" suffix, type_t, vals[i]);			\
+		guest_test_fastop_1("not" suffix, type_t, vals[i]);			\
+											\
+		for (j = 0; j < ARRAY_SIZE(vals); j++) {				\
+			guest_test_fastop_2("add" suffix, type_t, vals[i], vals[j]);	\
+			guest_test_fastop_2("adc" suffix, type_t, vals[i], vals[j]);	\
+			guest_test_fastop_2("and" suffix, type_t, vals[i], vals[j]);	\
+			guest_test_fastop_2("bsf" suffix, type_t, vals[i], vals[j]);	\
+			guest_test_fastop_2("bsr" suffix, type_t, vals[i], vals[j]);	\
+			guest_test_fastop_2("bt" suffix, type_t, vals[i], vals[j]);	\
+			guest_test_fastop_2("btc" suffix, type_t, vals[i], vals[j]);	\
+			guest_test_fastop_2("btr" suffix, type_t, vals[i], vals[j]);	\
+			guest_test_fastop_2("bts" suffix, type_t, vals[i], vals[j]);	\
+			guest_test_fastop_2("cmp" suffix, type_t, vals[i], vals[j]);	\
+			guest_test_fastop_2("imul" suffix, type_t, vals[i], vals[j]);	\
+			guest_test_fastop_2("or" suffix, type_t, vals[i], vals[j]);	\
+			guest_test_fastop_2("sbb" suffix, type_t, vals[i], vals[j]);	\
+			guest_test_fastop_2("sub" suffix, type_t, vals[i], vals[j]);	\
+			guest_test_fastop_2("test" suffix, type_t, vals[i], vals[j]);	\
+			guest_test_fastop_2("xor" suffix, type_t, vals[i], vals[j]);	\
+											\
+			guest_test_fastop_cl("rol" suffix, type_t, vals[i], vals[j]);	\
+			guest_test_fastop_cl("ror" suffix, type_t, vals[i], vals[j]);	\
+			guest_test_fastop_cl("rcl" suffix, type_t, vals[i], vals[j]);	\
+			guest_test_fastop_cl("rcr" suffix, type_t, vals[i], vals[j]);	\
+			guest_test_fastop_cl("sar" suffix, type_t, vals[i], vals[j]);	\
+			guest_test_fastop_cl("shl" suffix, type_t, vals[i], vals[j]);	\
+			guest_test_fastop_cl("shr" suffix, type_t, vals[i], vals[j]);	\
+		}									\
+	}										\
+} while (0)
+
+static void guest_code(void)
+{
+	guest_test_fastops(uint16_t, "w");
+	guest_test_fastops(uint32_t, "l");
+	guest_test_fastops(uint64_t, "q");
+
+	GUEST_DONE();
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	TEST_REQUIRE(is_forced_emulation_enabled);
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+
+	vcpu_run(vcpu);
+	TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
+
+	kvm_vm_free(vm);
+}

base-commit: 661b7ddb2d10258b53106d7c39c309806b00a99c
-- 
2.49.0.967.g6a0df3ecc3-goog


