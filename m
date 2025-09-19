Return-Path: <kvm+bounces-58272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 99CAFB8B8A2
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:45:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E6DC1CC2E21
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:45:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01F85323F42;
	Fri, 19 Sep 2025 22:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y208+KtJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6578F322C68
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321266; cv=none; b=LiC6CfVNQnWxoKTROACxl5+cCrGXwD7pAfAjyZa93VuySDCkmwcvlK/Nx7Dj+Fdy2Z3sOinGB737Wr2Zw8Vg3jNrnADPjRKXwS3MXmPYiWg4jLlZgPdvupqV2BcfFPIjETjjdvJdDCVWRGdfCqwjbLugm9KefpF4S0dc1imR+34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321266; c=relaxed/simple;
	bh=0RiErcI8FDtLgr3FwfUpR8gYIzgU2r/zww9pDcLYU/Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SYOawBvJbJ0Eepemrx9h7Hf5KU3X7DldBRtXzYs8+8TlFqKzuf9JqUPS0YPrkS+nmcdPXsdzOzSHUHbjJuDTg+KbikS7hPwpE/+hijm7iBPLwmjrUkhbALgdfhtYDr8jA6nrvaG7YQkKqUmfkrWAWLDak2v0/UR6gaIC6zLZ06c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y208+KtJ; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-324e41e946eso3910719a91.0
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321264; x=1758926064; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=ZspBnxEuwikP8ZIZtV9+9DQHM/dWGvJThvyQZ8JPEq8=;
        b=Y208+KtJDC10qWetTUUEmSnejhwTCfBXAd384Fia79zOorG6wNyuchrcS2m4rTbV2A
         dHkPw/WdOSgNoKs6M8sZzCwtn3K4qP7MYQvTHLGAOypsm8PK9cpZPJ++mrioDI6/vLcY
         y/lRmi2yhgSBTM0MNzAFmDY7C9q53dS8NWa/KNKy1i5S/sAsibBPMyyTt+pPppjC5JbZ
         4JuWMTdaglhM1BUed9ZPgJ2e/B8JoyvjxICijd34e0xkW6sMqVerfSmMK/YXKZ2SMRPd
         Qf7bZ4vPQgyW9MYRZJ+kR/xT5Ei8Br7YZA8YtZykFxToqn8ViGwxPl+4Eo6Pvtvc8ErZ
         Bvfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321264; x=1758926064;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZspBnxEuwikP8ZIZtV9+9DQHM/dWGvJThvyQZ8JPEq8=;
        b=KoS7m9oh5JS/2O34mGMqL/Jo8FZivW8DrPzEULjS8aiD1RgPwRfZhE2OrRwVEilMG2
         Vb82gQFZ0n05QvYiAwp8aYe8O6dxtMkKfBhoAykYV6IAMDlZNV4kk/dSw61aa/nhrFVS
         LF/LwQCW1/tirynD5+3T+8GBOsewR4S9iUbaLfPRu4wpLGJFLCYtDFGdUHUQKlvoYoUg
         yuPu9Yzb8rVgiRr8MtaBv9xsVuIDl1Hy8a6zhLzPj+QNCJRm3FoSJLLd3h5n0qXEFtDL
         jBgGVf6uSofJ5Q6ZI0jGyEj3kXbQDSHFtCwFN1+1f307BujxWHeQuBh0Wv1h4r4sTLOw
         Ngig==
X-Gm-Message-State: AOJu0Yw/Gh9C0AZ9XFAoBrIg2Zc1Z/MgsFvuz/3lrB7qqGFi6Wom+XLK
	nmn4TaXZvsmqMUHIv+byEva7F4xNeGZ/TtW/ZX3iRi07b+HJYQUuwjRJeiYlWZTDu4Gca9oNc7x
	UQ7uxKQ==
X-Google-Smtp-Source: AGHT+IGFqt8MF81EQPW7BGCnPdLfrXLZaEUWAadhj/2BJFplX7TmryXjGuHvUknv3czIUkBX7tsHCAMl6Qk=
X-Received: from pjh8.prod.google.com ([2002:a17:90b:3f88:b0:32e:e4e6:ecfe])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1e53:b0:32e:6fae:ba53
 with SMTP id 98e67ed59e1d1-33097fd571dmr5828821a91.8.1758321263742; Fri, 19
 Sep 2025 15:34:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:51 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-45-seanjc@google.com>
Subject: [PATCH v16 44/51] KVM: selftests: Add ex_str() to print human
 friendly name of exception vectors
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

Steal exception_mnemonic() from KVM-Unit-Tests as ex_str() (to keep line
lengths reasonable) and use it in assert messages that currently print the
raw vector number.

Co-developed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86/processor.h     |  2 ++
 .../testing/selftests/kvm/lib/x86/processor.c | 33 +++++++++++++++++++
 .../selftests/kvm/x86/hyperv_features.c       | 16 ++++-----
 .../selftests/kvm/x86/monitor_mwait_test.c    |  8 ++---
 .../selftests/kvm/x86/pmu_counters_test.c     |  4 +--
 .../selftests/kvm/x86/vmx_pmu_caps_test.c     |  4 +--
 .../selftests/kvm/x86/xcr0_cpuid_test.c       | 12 +++----
 7 files changed, 57 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index efcc4b1de523..2ad84f3809e8 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -34,6 +34,8 @@ extern uint64_t guest_tsc_khz;
 
 #define NMI_VECTOR		0x02
 
+const char *ex_str(int vector);
+
 #define X86_EFLAGS_FIXED	 (1u << 1)
 
 #define X86_CR4_VME		(1ul << 0)
diff --git a/tools/testing/selftests/kvm/lib/x86/processor.c b/tools/testing/selftests/kvm/lib/x86/processor.c
index 3b63c99f7b96..f9182dbd07f2 100644
--- a/tools/testing/selftests/kvm/lib/x86/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86/processor.c
@@ -23,6 +23,39 @@ bool host_cpu_is_intel;
 bool is_forced_emulation_enabled;
 uint64_t guest_tsc_khz;
 
+const char *ex_str(int vector)
+{
+	switch (vector) {
+#define VEC_STR(v) case v##_VECTOR: return "#" #v
+	case DE_VECTOR: return "no exception";
+	case KVM_MAGIC_DE_VECTOR: return "#DE";
+	VEC_STR(DB);
+	VEC_STR(NMI);
+	VEC_STR(BP);
+	VEC_STR(OF);
+	VEC_STR(BR);
+	VEC_STR(UD);
+	VEC_STR(NM);
+	VEC_STR(DF);
+	VEC_STR(TS);
+	VEC_STR(NP);
+	VEC_STR(SS);
+	VEC_STR(GP);
+	VEC_STR(PF);
+	VEC_STR(MF);
+	VEC_STR(AC);
+	VEC_STR(MC);
+	VEC_STR(XM);
+	VEC_STR(VE);
+	VEC_STR(CP);
+	VEC_STR(HV);
+	VEC_STR(VC);
+	VEC_STR(SX);
+	default: return "#??";
+#undef VEC_STR
+	}
+}
+
 static void regs_dump(FILE *stream, struct kvm_regs *regs, uint8_t indent)
 {
 	fprintf(stream, "%*srax: 0x%.16llx rbx: 0x%.16llx "
diff --git a/tools/testing/selftests/kvm/x86/hyperv_features.c b/tools/testing/selftests/kvm/x86/hyperv_features.c
index 068e9c69710d..99d327084172 100644
--- a/tools/testing/selftests/kvm/x86/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86/hyperv_features.c
@@ -54,12 +54,12 @@ static void guest_msr(struct msr_data *msr)
 
 	if (msr->fault_expected)
 		__GUEST_ASSERT(vector == GP_VECTOR,
-			       "Expected #GP on %sMSR(0x%x), got vector '0x%x'",
-			       msr->write ? "WR" : "RD", msr->idx, vector);
+			       "Expected #GP on %sMSR(0x%x), got %s",
+			       msr->write ? "WR" : "RD", msr->idx, ex_str(vector));
 	else
 		__GUEST_ASSERT(!vector,
-			       "Expected success on %sMSR(0x%x), got vector '0x%x'",
-			       msr->write ? "WR" : "RD", msr->idx, vector);
+			       "Expected success on %sMSR(0x%x), got %s",
+			       msr->write ? "WR" : "RD", msr->idx, ex_str(vector));
 
 	if (vector || is_write_only_msr(msr->idx))
 		goto done;
@@ -102,12 +102,12 @@ static void guest_hcall(vm_vaddr_t pgs_gpa, struct hcall_data *hcall)
 	vector = __hyperv_hypercall(hcall->control, input, output, &res);
 	if (hcall->ud_expected) {
 		__GUEST_ASSERT(vector == UD_VECTOR,
-			       "Expected #UD for control '%lu', got vector '0x%x'",
-			       hcall->control, vector);
+			       "Expected #UD for control '%lu', got %s",
+			       hcall->control, ex_str(vector));
 	} else {
 		__GUEST_ASSERT(!vector,
-			       "Expected no exception for control '%lu', got vector '0x%x'",
-			       hcall->control, vector);
+			       "Expected no exception for control '%lu', got %s",
+			       hcall->control, ex_str(vector));
 		GUEST_ASSERT_EQ(res, hcall->expect);
 	}
 
diff --git a/tools/testing/selftests/kvm/x86/monitor_mwait_test.c b/tools/testing/selftests/kvm/x86/monitor_mwait_test.c
index 0eb371c62ab8..e45c028d2a7e 100644
--- a/tools/testing/selftests/kvm/x86/monitor_mwait_test.c
+++ b/tools/testing/selftests/kvm/x86/monitor_mwait_test.c
@@ -30,12 +30,12 @@ do {									\
 									\
 	if (fault_wanted)						\
 		__GUEST_ASSERT((vector) == UD_VECTOR,			\
-			       "Expected #UD on " insn " for testcase '0x%x', got '0x%x'", \
-			       testcase, vector);			\
+			       "Expected #UD on " insn " for testcase '0x%x', got %s", \
+			       testcase, ex_str(vector));		\
 	else								\
 		__GUEST_ASSERT(!(vector),				\
-			       "Expected success on " insn " for testcase '0x%x', got '0x%x'", \
-			       testcase, vector);			\
+			       "Expected success on " insn " for testcase '0x%x', got %s", \
+			       testcase, ex_str(vector));		\
 } while (0)
 
 static void guest_monitor_wait(void *arg)
diff --git a/tools/testing/selftests/kvm/x86/pmu_counters_test.c b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
index 89c1e462cd1c..24288b460636 100644
--- a/tools/testing/selftests/kvm/x86/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86/pmu_counters_test.c
@@ -346,8 +346,8 @@ static void test_arch_events(uint8_t pmu_version, uint64_t perf_capabilities,
 
 #define GUEST_ASSERT_PMC_MSR_ACCESS(insn, msr, expect_gp, vector)		\
 __GUEST_ASSERT(expect_gp ? vector == GP_VECTOR : !vector,			\
-	       "Expected %s on " #insn "(0x%x), got vector %u",			\
-	       expect_gp ? "#GP" : "no fault", msr, vector)			\
+	       "Expected %s on " #insn "(0x%x), got %s",			\
+	       expect_gp ? "#GP" : "no fault", msr, ex_str(vector))		\
 
 #define GUEST_ASSERT_PMC_VALUE(insn, msr, val, expected)			\
 	__GUEST_ASSERT(val == expected,					\
diff --git a/tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c
index a1f5ff45d518..7d37f0cd4eb9 100644
--- a/tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86/vmx_pmu_caps_test.c
@@ -56,8 +56,8 @@ static void guest_test_perf_capabilities_gp(uint64_t val)
 	uint8_t vector = wrmsr_safe(MSR_IA32_PERF_CAPABILITIES, val);
 
 	__GUEST_ASSERT(vector == GP_VECTOR,
-		       "Expected #GP for value '0x%lx', got vector '0x%x'",
-		       val, vector);
+		       "Expected #GP for value '0x%lx', got %s",
+		       val, ex_str(vector));
 }
 
 static void guest_code(uint64_t current_val)
diff --git a/tools/testing/selftests/kvm/x86/xcr0_cpuid_test.c b/tools/testing/selftests/kvm/x86/xcr0_cpuid_test.c
index c8a5c5e51661..d038c1571729 100644
--- a/tools/testing/selftests/kvm/x86/xcr0_cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86/xcr0_cpuid_test.c
@@ -81,13 +81,13 @@ static void guest_code(void)
 
 	vector = xsetbv_safe(0, XFEATURE_MASK_FP);
 	__GUEST_ASSERT(!vector,
-		       "Expected success on XSETBV(FP), got vector '0x%x'",
-		       vector);
+		       "Expected success on XSETBV(FP), got %s",
+		       ex_str(vector));
 
 	vector = xsetbv_safe(0, supported_xcr0);
 	__GUEST_ASSERT(!vector,
-		       "Expected success on XSETBV(0x%lx), got vector '0x%x'",
-		       supported_xcr0, vector);
+		       "Expected success on XSETBV(0x%lx), got %s",
+		       supported_xcr0, ex_str(vector));
 
 	for (i = 0; i < 64; i++) {
 		if (supported_xcr0 & BIT_ULL(i))
@@ -95,8 +95,8 @@ static void guest_code(void)
 
 		vector = xsetbv_safe(0, supported_xcr0 | BIT_ULL(i));
 		__GUEST_ASSERT(vector == GP_VECTOR,
-			       "Expected #GP on XSETBV(0x%llx), supported XCR0 = %lx, got vector '0x%x'",
-			       BIT_ULL(i), supported_xcr0, vector);
+			       "Expected #GP on XSETBV(0x%llx), supported XCR0 = %lx, got %s",
+			       BIT_ULL(i), supported_xcr0, ex_str(vector));
 	}
 
 	GUEST_DONE();
-- 
2.51.0.470.ga7dc726c21-goog


