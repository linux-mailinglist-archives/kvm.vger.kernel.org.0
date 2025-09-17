Return-Path: <kvm+bounces-57936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 35AE9B81EEF
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 23:21:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF6861894C60
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 21:22:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37040309DDB;
	Wed, 17 Sep 2025 21:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VErmrEAY"
X-Original-To: kvm@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665433043A4
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 21:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758144096; cv=none; b=VobCYHsr9YXqOu5NAlZmFgmv0ExvmZIkoN2coMp+iNEhkt4t3Q8HzqGrVvM7JeljLgH4CjS+iQ86/b9ZwslvrR9t4XqJhUtbpxATWR7qtdgkaY85tT9F0JDrfqr+GpO/qBUbvHLyEb1IQISebLJ0ZAg214UZl7OUxf2UAwbCnEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758144096; c=relaxed/simple;
	bh=/atXdS33qHzbQBoklMrt5RogYRlQVImRE1bAAABri8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MpC/0gIXC52Sepr/ZTrJwOFxyA3Q/kROV/4/t2UpvtGY8Hw2jOVYlZp7R0xYSS42nNRoTpEhXqJVi5j5uSwu/z0Z6tC+4suLCM+5fgWBw3I/dvZzXLWKVSvs9If8fMPk4LlDnYpl2xWpUg6BURuba5jCIU0+pNjcQShQ4iKyh2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VErmrEAY; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758144092;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XMhvnhQYreEpSw4/nebuiGe96gEzDo6efwFyIU7Yj0s=;
	b=VErmrEAY8bDgU74c8WDBKvFDLIKBrnyf5QwrlZ2T70b7h560MEZhXQZsud1kNPupNJqQKb
	SbUDOjesHJOc2DtRHgL2KN5sB0UyEGjcS0NNeax9ERJL6p/qq0N+ieW792GynE5XqPBHU7
	4eRO/dgje2jaHzmh0ijzCU/4TePzZT0=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 06/13] KVM: arm64: selftests: Alias EL1 registers to EL2 counterparts
Date: Wed, 17 Sep 2025 14:20:36 -0700
Message-ID: <20250917212044.294760-7-oliver.upton@linux.dev>
In-Reply-To: <20250917212044.294760-1-oliver.upton@linux.dev>
References: <20250917212044.294760-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

FEAT_VHE has the somewhat nice property of implicitly redirecting EL1
register aliases to their corresponding EL2 representations when E2H=1.
Unfortunately, there's no such abstraction for userspace and EL2
registers are always accessed by their canonical encoding.

Introduce a helper that applies EL2 redirections to sysregs and use
aggressive inlining to catch misuse at compile time. Go a little past
the architectural definition for ease of use for test authors (e.g. the
stack pointer).

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 .../selftests/kvm/arm64/vpmu_counter_access.c |  4 +-
 .../selftests/kvm/include/arm64/processor.h   | 54 +++++++++++++++++++
 .../testing/selftests/kvm/include/kvm_util.h  |  3 ++
 .../selftests/kvm/lib/arm64/processor.c       | 19 +++----
 4 files changed, 69 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
index 4a7e8e85a1b8..36a3a8b4e0b5 100644
--- a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
@@ -517,7 +517,7 @@ static void run_access_test(uint64_t pmcr_n)
 	vcpu = vpmu_vm.vcpu;
 
 	/* Save the initial sp to restore them later to run the guest again */
-	sp = vcpu_get_reg(vcpu, ARM64_CORE_REG(sp_el1));
+	sp = vcpu_get_reg(vcpu, ctxt_reg_alias(vcpu, SYS_SP_EL1));
 
 	run_vcpu(vcpu, pmcr_n);
 
@@ -529,7 +529,7 @@ static void run_access_test(uint64_t pmcr_n)
 	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
 	aarch64_vcpu_setup(vcpu, &init);
 	vcpu_init_descriptor_tables(vcpu);
-	vcpu_set_reg(vcpu, ARM64_CORE_REG(sp_el1), sp);
+	vcpu_set_reg(vcpu, ctxt_reg_alias(vcpu, SYS_SP_EL1), sp);
 	vcpu_set_reg(vcpu, ARM64_CORE_REG(regs.pc), (uint64_t)guest_code);
 
 	run_vcpu(vcpu, pmcr_n);
diff --git a/tools/testing/selftests/kvm/include/arm64/processor.h b/tools/testing/selftests/kvm/include/arm64/processor.h
index 8c066ba1deb5..5a4b29c1b965 100644
--- a/tools/testing/selftests/kvm/include/arm64/processor.h
+++ b/tools/testing/selftests/kvm/include/arm64/processor.h
@@ -303,4 +303,58 @@ void wfi(void);
 void test_wants_mte(void);
 void test_disable_default_vgic(void);
 
+static bool vcpu_has_el2(struct kvm_vcpu *vcpu)
+{
+	return vcpu->init.features[0] & BIT(KVM_ARM_VCPU_HAS_EL2);
+}
+
+#define MAPPED_EL2_SYSREG(el2, el1)		\
+	case SYS_##el1:				\
+		if (vcpu_has_el2(vcpu))		\
+			alias = SYS_##el2;	\
+		break
+
+
+static __always_inline u64 ctxt_reg_alias(struct kvm_vcpu *vcpu, u32 encoding)
+{
+	u32 alias = encoding;
+
+	BUILD_BUG_ON(!__builtin_constant_p(encoding));
+
+	switch (encoding) {
+	MAPPED_EL2_SYSREG(SCTLR_EL2,		SCTLR_EL1);
+	MAPPED_EL2_SYSREG(CPTR_EL2,		CPACR_EL1);
+	MAPPED_EL2_SYSREG(TTBR0_EL2,		TTBR0_EL1);
+	MAPPED_EL2_SYSREG(TTBR1_EL2,		TTBR1_EL1);
+	MAPPED_EL2_SYSREG(TCR_EL2,		TCR_EL1);
+	MAPPED_EL2_SYSREG(VBAR_EL2,		VBAR_EL1);
+	MAPPED_EL2_SYSREG(AFSR0_EL2,		AFSR0_EL1);
+	MAPPED_EL2_SYSREG(AFSR1_EL2,		AFSR1_EL1);
+	MAPPED_EL2_SYSREG(ESR_EL2,		ESR_EL1);
+	MAPPED_EL2_SYSREG(FAR_EL2,		FAR_EL1);
+	MAPPED_EL2_SYSREG(MAIR_EL2,		MAIR_EL1);
+	MAPPED_EL2_SYSREG(TCR2_EL2,		TCR2_EL1);
+	MAPPED_EL2_SYSREG(PIR_EL2,		PIR_EL1);
+	MAPPED_EL2_SYSREG(PIRE0_EL2,		PIRE0_EL1);
+	MAPPED_EL2_SYSREG(POR_EL2,		POR_EL1);
+	MAPPED_EL2_SYSREG(AMAIR_EL2,		AMAIR_EL1);
+	MAPPED_EL2_SYSREG(ELR_EL2,		ELR_EL1);
+	MAPPED_EL2_SYSREG(SPSR_EL2,		SPSR_EL1);
+	MAPPED_EL2_SYSREG(ZCR_EL2,		ZCR_EL1);
+	MAPPED_EL2_SYSREG(CONTEXTIDR_EL2,	CONTEXTIDR_EL1);
+	MAPPED_EL2_SYSREG(SCTLR2_EL2,		SCTLR2_EL1);
+	MAPPED_EL2_SYSREG(CNTHCTL_EL2,		CNTKCTL_EL1);
+	case SYS_SP_EL1:
+		if (!vcpu_has_el2(vcpu))
+			return ARM64_CORE_REG(sp_el1);
+
+		alias = SYS_SP_EL2;
+		break;
+	default:
+		BUILD_BUG();
+	}
+
+	return KVM_ARM64_SYS_REG(alias);
+}
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 3ab1fffbc3f2..11b6c5aa3f12 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -63,6 +63,9 @@ struct kvm_vcpu {
 	struct kvm_run *run;
 #ifdef __x86_64__
 	struct kvm_cpuid2 *cpuid;
+#endif
+#ifdef __aarch64__
+	struct kvm_vcpu_init init;
 #endif
 	struct kvm_binary_stats stats;
 	struct kvm_dirty_gfn *dirty_gfns;
diff --git a/tools/testing/selftests/kvm/lib/arm64/processor.c b/tools/testing/selftests/kvm/lib/arm64/processor.c
index de77d9a7e0cd..311660a9f655 100644
--- a/tools/testing/selftests/kvm/lib/arm64/processor.c
+++ b/tools/testing/selftests/kvm/lib/arm64/processor.c
@@ -283,15 +283,16 @@ void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init)
 	}
 
 	vcpu_ioctl(vcpu, KVM_ARM_VCPU_INIT, init);
+	vcpu->init = *init;
 
 	/*
 	 * Enable FP/ASIMD to avoid trapping when accessing Q0-Q15
 	 * registers, which the variable argument list macros do.
 	 */
-	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_CPACR_EL1), 3 << 20);
+	vcpu_set_reg(vcpu, ctxt_reg_alias(vcpu, SYS_CPACR_EL1), 3 << 20);
 
-	sctlr_el1 = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_SCTLR_EL1));
-	tcr_el1 = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_TCR_EL1));
+	sctlr_el1 = vcpu_get_reg(vcpu, ctxt_reg_alias(vcpu, SYS_SCTLR_EL1));
+	tcr_el1 = vcpu_get_reg(vcpu, ctxt_reg_alias(vcpu, SYS_TCR_EL1));
 
 	/* Configure base granule size */
 	switch (vm->mode) {
@@ -358,10 +359,10 @@ void aarch64_vcpu_setup(struct kvm_vcpu *vcpu, struct kvm_vcpu_init *init)
 	if (use_lpa2_pte_format(vm))
 		tcr_el1 |= TCR_DS;
 
-	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_SCTLR_EL1), sctlr_el1);
-	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_TCR_EL1), tcr_el1);
-	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MAIR_EL1), DEFAULT_MAIR_EL1);
-	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_TTBR0_EL1), ttbr0_el1);
+	vcpu_set_reg(vcpu, ctxt_reg_alias(vcpu, SYS_SCTLR_EL1), sctlr_el1);
+	vcpu_set_reg(vcpu, ctxt_reg_alias(vcpu, SYS_TCR_EL1), tcr_el1);
+	vcpu_set_reg(vcpu, ctxt_reg_alias(vcpu, SYS_MAIR_EL1), DEFAULT_MAIR_EL1);
+	vcpu_set_reg(vcpu, ctxt_reg_alias(vcpu, SYS_TTBR0_EL1), ttbr0_el1);
 	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_TPIDR_EL1), vcpu->id);
 }
 
@@ -396,7 +397,7 @@ static struct kvm_vcpu *__aarch64_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 
 	aarch64_vcpu_setup(vcpu, init);
 
-	vcpu_set_reg(vcpu, ARM64_CORE_REG(sp_el1), stack_vaddr + stack_size);
+	vcpu_set_reg(vcpu, ctxt_reg_alias(vcpu, SYS_SP_EL1), stack_vaddr + stack_size);
 	return vcpu;
 }
 
@@ -466,7 +467,7 @@ void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu)
 {
 	extern char vectors;
 
-	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_VBAR_EL1), (uint64_t)&vectors);
+	vcpu_set_reg(vcpu, ctxt_reg_alias(vcpu, SYS_VBAR_EL1), (uint64_t)&vectors);
 }
 
 void route_exception(struct ex_regs *regs, int vector)
-- 
2.47.3


