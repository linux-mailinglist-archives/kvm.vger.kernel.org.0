Return-Path: <kvm+bounces-54165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F984B1CCF5
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 22:05:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A61117A45B
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 20:05:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 404912D94A7;
	Wed,  6 Aug 2025 19:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mp40kJwt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28672D59E5
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 19:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510299; cv=none; b=R6L5EelyBFWqMqwRsVamXs9Nfc9/48ol4/jad6BKE4FZXtJj847kvhup62h3fh42x3o4dWZ2I6Vdtbb7ki0LKqCgDoZLaqhgqF/3uwvmT5heu+zP/GfXFzV4nD9bi3agvFye4wZjHpZQm8bsGe0fj/keqgTm36qkBiLrE6y0xi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510299; c=relaxed/simple;
	bh=HjF6VqOOZUHrkl/7iev8rEDWaKamWaXyDUM+ISWFM5M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CC4AOKY/Ydz02KD0+1jW1cHRbXT7P1MV68E6u5bRdAdT7Sv3ncz3Y8/vgJ7X2Mjiqpsxa8WFTc7q/8Yuy54ormivDRBn2OdUDNme+ouadDGLSS3/+Oa9Vwxyz3CSxJ2qwdh3E5x2bSPXOYycq/UcUGZTtSKj8OKDXa8dwNJmuy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mp40kJwt; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2400a0ad246so1472805ad.2
        for <kvm@vger.kernel.org>; Wed, 06 Aug 2025 12:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510291; x=1755115091; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/FX2+DfXNwgRGe/WbgJvV/8z8g7IlIB9y4b49oQ5nSU=;
        b=mp40kJwttBkOnbdJqg+ZIXn87T5lnBzz+UDT//G0D1jdpLHYc1pMDbv5CIKfZUJz3n
         QYriK5s4sfB1ZFLX4YZvZmRhKKRnXe3Edi+wIaaHH1zhPpj6+97rPxWh3C0hmfBSM0KP
         YEQK2tikqxcgPjpDTFRXvVFB81LqhfngPbgHVakAoT205J5ygdHa/PJl6INv9Cvt9M0V
         Y76LOcH5/ik2zmA1BJ7NIMAvlGMXakmrHhUdIZJ+YtZt82RiCeW52xe2Uh4BPsdbOhj6
         nbVqqRnp6osme26eR66rcqCzS1nt7bs/cwvuQnWt/cEFeNEqeMtrtkKW4uq4ikcdBSAh
         EPQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510291; x=1755115091;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/FX2+DfXNwgRGe/WbgJvV/8z8g7IlIB9y4b49oQ5nSU=;
        b=sACpkVMKk1xP8VKBCGbcmVYHUu6D6cnTaYAtMP25Akw4DZLTk5+TlYglfXL8nkdp0w
         ros07KH1YKwZ9F1QXIkxqhpfxjJo74Sg4RqfhF9z/X+z0yzVO7A6nXBxe2c6ihfmTxpy
         KHn2cOZJTV+J6uTL2IDXizTbUMDb4pGK0Cr57i+/d/JvAn4m8Rw3DslE6uOggRnIKHWG
         /YBzNf9VPCCCcINzeX2678oZUXi8ScWYBHa9gKvq9n46jI1Y5IYxYHfUnxv8J2zq0Igu
         7KGfbl44Cs+hOUk9UbhqdjJIidcI2v7oxeq6UB2DFItJt9/QZsQCw1Od7QkkpZSG8YbR
         x1GQ==
X-Forwarded-Encrypted: i=1; AJvYcCUY/0d2pukUvBKByEjyIfegAo9WBm9KBVlq/vBsV6vWJfUq6YY2dKHog97tUu6KYiTASMU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzhgP4xnKFW6UEqbU0aZQrsfydKFVi27muAy1zDBDDhqnCzOVaV
	NGwgH8EAvXY592uGgofDmTaRay1u7/PqgwCUQKX/ziDXFyn724Nx6K9SWUlURGCjL+XmFtSTJAk
	p0SM9yQ==
X-Google-Smtp-Source: AGHT+IGe4jBR2KHz8e2goINgF4EUoH0wWvJHG6ysYfktepmzpkGXYfj1vM33eEgiesUpU8kg3lcTp4Ph7gE=
X-Received: from plbmv16.prod.google.com ([2002:a17:903:b90:b0:231:de34:f9f6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:98d:b0:240:417d:8115
 with SMTP id d9443c01a7336-2429ee89eb4mr58062565ad.16.1754510291288; Wed, 06
 Aug 2025 12:58:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:56:45 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-24-seanjc@google.com>
Subject: [PATCH v5 23/44] KVM: x86/pmu: Move PMU_CAP_{FW_WRITES,LBR_FMT} into
 msr-index.h header
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>, 
	Yongwei Ma <yongwei.ma@intel.com>, Mingwei Zhang <mizhang@google.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

Move PMU_CAP_{FW_WRITES,LBR_FMT} into msr-index.h and rename them with
PERF_CAP prefix to keep consistent with other perf capabilities macros.

No functional change intended.

Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/msr-index.h | 15 +++++++++------
 arch/x86/kvm/vmx/capabilities.h  |  3 ---
 arch/x86/kvm/vmx/pmu_intel.c     |  6 +++---
 arch/x86/kvm/vmx/vmx.c           | 12 ++++++------
 4 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index c29127ac626a..f19d1ee9a396 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -315,12 +315,15 @@
 #define PERF_CAP_PT_IDX			16
 
 #define MSR_PEBS_LD_LAT_THRESHOLD	0x000003f6
-#define PERF_CAP_PEBS_TRAP             BIT_ULL(6)
-#define PERF_CAP_ARCH_REG              BIT_ULL(7)
-#define PERF_CAP_PEBS_FORMAT           0xf00
-#define PERF_CAP_PEBS_BASELINE         BIT_ULL(14)
-#define PERF_CAP_PEBS_MASK	(PERF_CAP_PEBS_TRAP | PERF_CAP_ARCH_REG | \
-				 PERF_CAP_PEBS_FORMAT | PERF_CAP_PEBS_BASELINE)
+
+#define PERF_CAP_LBR_FMT		0x3f
+#define PERF_CAP_PEBS_TRAP		BIT_ULL(6)
+#define PERF_CAP_ARCH_REG		BIT_ULL(7)
+#define PERF_CAP_PEBS_FORMAT		0xf00
+#define PERF_CAP_FW_WRITES		BIT_ULL(13)
+#define PERF_CAP_PEBS_BASELINE		BIT_ULL(14)
+#define PERF_CAP_PEBS_MASK		(PERF_CAP_PEBS_TRAP | PERF_CAP_ARCH_REG | \
+					 PERF_CAP_PEBS_FORMAT | PERF_CAP_PEBS_BASELINE)
 
 #define MSR_IA32_RTIT_CTL		0x00000570
 #define RTIT_CTL_TRACEEN		BIT(0)
diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 854e54c352f8..26ff606ff139 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -20,9 +20,6 @@ extern int __read_mostly pt_mode;
 #define PT_MODE_SYSTEM		0
 #define PT_MODE_HOST_GUEST	1
 
-#define PMU_CAP_FW_WRITES	(1ULL << 13)
-#define PMU_CAP_LBR_FMT		0x3f
-
 struct nested_vmx_msrs {
 	/*
 	 * We only store the "true" versions of the VMX capability MSRs. We
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 8df8d7b4f212..7ab35ef4a3b1 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -138,7 +138,7 @@ static inline u64 vcpu_get_perf_capabilities(struct kvm_vcpu *vcpu)
 
 static inline bool fw_writes_is_enabled(struct kvm_vcpu *vcpu)
 {
-	return (vcpu_get_perf_capabilities(vcpu) & PMU_CAP_FW_WRITES) != 0;
+	return (vcpu_get_perf_capabilities(vcpu) & PERF_CAP_FW_WRITES) != 0;
 }
 
 static inline struct kvm_pmc *get_fw_gp_pmc(struct kvm_pmu *pmu, u32 msr)
@@ -588,7 +588,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 
 	perf_capabilities = vcpu_get_perf_capabilities(vcpu);
 	if (intel_pmu_lbr_is_compatible(vcpu) &&
-	    (perf_capabilities & PMU_CAP_LBR_FMT))
+	    (perf_capabilities & PERF_CAP_LBR_FMT))
 		memcpy(&lbr_desc->records, &vmx_lbr_caps, sizeof(vmx_lbr_caps));
 	else
 		lbr_desc->records.nr = 0;
@@ -787,7 +787,7 @@ static bool intel_pmu_is_mediated_pmu_supported(struct x86_pmu_capability *host_
 	 * Require v4+ for MSR_CORE_PERF_GLOBAL_STATUS_SET, and full-width
 	 * writes so that KVM can precisely load guest counter values.
 	 */
-	return host_pmu->version >= 4 && host_perf_cap & PMU_CAP_FW_WRITES;
+	return host_pmu->version >= 4 && host_perf_cap & PERF_CAP_FW_WRITES;
 }
 
 struct kvm_pmu_ops intel_pmu_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7b0b51809f0e..93b87f9e6dfd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2127,7 +2127,7 @@ u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated)
 	    (host_initiated || guest_cpu_cap_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT)))
 		debugctl |= DEBUGCTLMSR_BUS_LOCK_DETECT;
 
-	if ((kvm_caps.supported_perf_cap & PMU_CAP_LBR_FMT) &&
+	if ((kvm_caps.supported_perf_cap & PERF_CAP_LBR_FMT) &&
 	    (host_initiated || intel_pmu_lbr_is_enabled(vcpu)))
 		debugctl |= DEBUGCTLMSR_LBR | DEBUGCTLMSR_FREEZE_LBRS_ON_PMI;
 
@@ -2412,9 +2412,9 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			vmx->pt_desc.guest.addr_a[index / 2] = data;
 		break;
 	case MSR_IA32_PERF_CAPABILITIES:
-		if (data & PMU_CAP_LBR_FMT) {
-			if ((data & PMU_CAP_LBR_FMT) !=
-			    (kvm_caps.supported_perf_cap & PMU_CAP_LBR_FMT))
+		if (data & PERF_CAP_LBR_FMT) {
+			if ((data & PERF_CAP_LBR_FMT) !=
+			    (kvm_caps.supported_perf_cap & PERF_CAP_LBR_FMT))
 				return 1;
 			if (!cpuid_model_is_consistent(vcpu))
 				return 1;
@@ -7786,7 +7786,7 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 static __init u64 vmx_get_perf_capabilities(void)
 {
-	u64 perf_cap = PMU_CAP_FW_WRITES;
+	u64 perf_cap = PERF_CAP_FW_WRITES;
 	u64 host_perf_cap = 0;
 
 	if (!enable_pmu)
@@ -7807,7 +7807,7 @@ static __init u64 vmx_get_perf_capabilities(void)
 		if (!vmx_lbr_caps.has_callstack)
 			memset(&vmx_lbr_caps, 0, sizeof(vmx_lbr_caps));
 		else if (vmx_lbr_caps.nr)
-			perf_cap |= host_perf_cap & PMU_CAP_LBR_FMT;
+			perf_cap |= host_perf_cap & PERF_CAP_LBR_FMT;
 	}
 
 	if (vmx_pebs_supported()) {
-- 
2.50.1.565.gc32cd1483b-goog


