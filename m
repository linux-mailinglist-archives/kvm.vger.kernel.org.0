Return-Path: <kvm+bounces-57477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DC62B55A40
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:33:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E800165195
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 23:33:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1EE22E5B26;
	Fri, 12 Sep 2025 23:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="joukzraZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D32E2E4254
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 23:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757719468; cv=none; b=rj3Zi+lqdE8jmPeE4E4ryd9U4GhAaDa86PsHB1ZeZMol7ZQ2DsLhd09wRRzN7JR8PB/+24ejhOMWrJIOZHiE7O5lZZI/d0IgpOhUb19rD74YyOEej2mWaUhMUmsA194T3Wdp/asZiKdf6oOPOj03I0NQN2EBtiLz7+Tt/9iYEvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757719468; c=relaxed/simple;
	bh=UPKnKQSfYJAo3EQ9x1VivoNxgTxUElKxA35GroyTf1g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Is8TIcTzfX/ENiFxlfM3mK5nLR5FOr/DS0mAfi5cDQWbnj8Wj9MYci06+qoVNafNiGXvpjvhGtMpYyoH0Zj7wyI026y6aAApXo449mXAkKjQuBOOnMA8M+RsXl1yIBkzAUxwOh4R1gNPTRHrU7WlhSDgiANYkhNoI+MhqPW1qcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=joukzraZ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-329ee69e7deso2264773a91.3
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 16:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757719466; x=1758324266; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Sdm8oDN0/ysJNEKU/fuPIP7nuYKdlTH627rUAA97AnA=;
        b=joukzraZHJupODE/eznr9DtbHrj5GQttsTmasLb8Rtoda1kelTClQUulyRFOY1PPgR
         xG1bcR6eoEQAn8jjJrxgV/cGcniVU5csSzMHTvyYSBdp2TuBaMHw4yK4CrZ3ugBQ28ME
         tdBLl87awDlphX90KrXjZut7vImXBuG4mbK0oNIZo1IWV4s0wyW/uPNszdKFn/QvzLAR
         BUZ++3MybLVYf9192UGn6oS8YMtlsPnJ35cahXSi+S3/ZVHXeskXVLEPRe7phvmNAE14
         /4BnewtNO/nb7uOInOT+sJL/Zi0ryaoqZr7v8SsQEGYnizcpsbnvyGGE4GXXSqoSTQy7
         qu3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719466; x=1758324266;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sdm8oDN0/ysJNEKU/fuPIP7nuYKdlTH627rUAA97AnA=;
        b=CJnt10w893x01D5mMS7pB6GYsN7p78on2A+qB667w53XNS26jmali6UO9jDqgbF1Pv
         B6fEZcW9nZYEK/r4qP9UtrIoXZxHpxLtUL/8WA7Mf1CYPv6BXFxh8iHRIch3DCXTwDhO
         2l0/iZJEYk9dsedxcu7/C3tzgZENbCJldb8uY3s9Zu6Ejp+KeBaU/3zHU7+uW36egQuz
         3ie1POluyu7zK3E0exQkYAqryxu26Yn1+PfXqT7hlLzr0cmiKjNeUwOGwbbYz2i0fDuh
         1k6F/vfWjKbQSML/7iFKJXyfyYt72PQg4XxRlw4hcn19MYGnVzfS0kjh7uPwen6xp9Ue
         3dWQ==
X-Gm-Message-State: AOJu0YxPlsvt9xHYDBFYS9sTQVn1NaeZ0PlzbqLhJ0DtRrkTSfszqFNz
	X0xHSwILMQXZaSyZ4PJV6D0pbCUTEsJZ2fbJVl/JaAxPS+HWJ+ka4Q9XAQp0lxpgBg6+oFP3sj4
	NDm1l7A==
X-Google-Smtp-Source: AGHT+IFdxaEc5cFiTTkclO1uSvqiG8c+ZQArkHF+CDxCdQDXFCgmSomwPdUgdl7m0VNTqmhTJiPLYIpJ6Jc=
X-Received: from pjbqb3.prod.google.com ([2002:a17:90b:2803:b0:32b:8eda:24e8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:17cc:b0:327:9e88:7714
 with SMTP id 98e67ed59e1d1-32de4fba10dmr5159788a91.37.1757719466439; Fri, 12
 Sep 2025 16:24:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Sep 2025 16:23:12 -0700
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912232319.429659-35-seanjc@google.com>
Subject: [PATCH v15 34/41] KVM: selftests: Add ex_str() to print human
 friendly name of exception vectors
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Steal exception_mnemonic() from KVM-Unit-Tests as ex_str() (to keep line
lengths reasonable) and use it in assert messages that currently print the
raw vector number.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86/processor.h     |  2 ++
 .../testing/selftests/kvm/lib/x86/processor.c | 33 +++++++++++++++++++
 .../selftests/kvm/x86/hyperv_features.c       | 16 ++++-----
 .../selftests/kvm/x86/vmx_pmu_caps_test.c     |  4 +--
 .../selftests/kvm/x86/xcr0_cpuid_test.c       | 12 +++----
 5 files changed, 51 insertions(+), 16 deletions(-)

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
2.51.0.384.g4c02a37b29-goog


