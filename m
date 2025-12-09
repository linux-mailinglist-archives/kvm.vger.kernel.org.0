Return-Path: <kvm+bounces-65614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CFCECB13E1
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 22:54:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9C1C4315BE49
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 21:51:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C2AB312814;
	Tue,  9 Dec 2025 20:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y2SHgjqz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF46630DD3C
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 20:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313579; cv=none; b=L+70+rvda9NDZHWCTdPSNA2hWi7lTZ1gaGQL26RMkmyONvwgzXkoyjj2ABzkvlf6hGaQJdU9begEqrcyKGK8jwHPgYwHfWw4CZf0zE+h+ROlC1g863nhu847ZDbByhiA7XVx3pm+Cg0Hg5QadxJya2Ht2TN8+mLEZH7zS1f8WDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313579; c=relaxed/simple;
	bh=gmC2k89w1Dte4pd6AnbrWKevbCFa8dAc75+iE7e6/ds=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DUB9v+0A1703aBCQMZ8ZNbUiraeHORqZfq5WFyZdOqhO1NqOFQQa54C3GCKX8hWEFeprNNFNPbpPjFvrhyzJvrmhnzkkZXLU+Kk0EBnFJcZf4nLrgtOxQjGVZIZdXrEX59HuDSHJRi8m2NqlZZn9KOuE+Vq9c+WZ6kqDYY9sq1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y2SHgjqz; arc=none smtp.client-ip=209.85.210.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-7cac9cda2d0so1402747a34.0
        for <kvm@vger.kernel.org>; Tue, 09 Dec 2025 12:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765313565; x=1765918365; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bZ89vuk8IoQwxvZsx0+1wjVs3fhaJQxFPQySDckilYY=;
        b=y2SHgjqz1/cxFp+1tXukiTYVVlWIBloM8Om1VNe5qINv1Gm2y0AhIIMnbNan2dk+am
         NCu3Q5vX9tabQJUa6EhRmfksAYwYDMKdOJanmofpKSReuAfqLN35+mjXclt7gFEOuw4I
         sP/oD1wjkMfz5Pc1eoYyVeCZSlNQZdGa2erR9UuI5cU94JWjbvgXLZeAg0797SP/11l8
         sqATonkRqpwWFxnlCFr4lMUar78dXzP+NPs+pajcTzEFTcvJvLj/Q7frt755H6IC2Va7
         yhGmcHwm5JdcLW1/LqyE3OJtGoQAQAbZnKcO43R9oaN60nOAx6h71bwnbnYxdWAQbJs6
         eAxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765313565; x=1765918365;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bZ89vuk8IoQwxvZsx0+1wjVs3fhaJQxFPQySDckilYY=;
        b=ttM4AWRGRsgyXuc2JAyXfpvxy30PKEtgPVBYLvRvp6QoKgmIgT45+vQ4juuXeCTVkT
         mzF1V2kBcyf7ZtEoDEtS2r6FkuYr34aGgoUujgLqcRgaDXzgWEtyZNlGN411iAJObo5Y
         6Yc7yJtwpST14NZOk/q3StpQOjH379aDWXalv4lOeG2VM+w17k3vTw2TlgooNBtSVQsa
         /uzKdyhccRTSz2vwEDUohVt4wjlG4ij+29+yhuAs/fC83UEjVSIWdYsa5nE50hDPAiwn
         EFkMesL1X8VIHofC7tbP4ZZysWOCiDVfQqXVhhNcSX4R3ZeJdp0I0onsa58pWhix6Fub
         0OSg==
X-Gm-Message-State: AOJu0Yxp4zSANcQieQSyUfYVQh+qcfHjhtRNa2kdNTbMBItzC79iOlrf
	VuhVMeBxkm9KRLVm7lvJaVVOQCmewW1ec7PKsd/f7M95tVHi4q5sFI8s9gq2vMm6LaM6GJS6dR8
	NtCX50nNEMRg8GRsznTU5fvjunBlnYW8iPrdOKulafJG7v7D8dJNz+c2hC4Aa6JztyfWvHy4/n9
	CbCCugbjv/ZHjA33WhBan5QBG6z0+H+nmxxE4D8ZQ2uq3wGzXN2b7PcSWUWvc=
X-Google-Smtp-Source: AGHT+IFMFGhBntVA7e0yxpl28sTmfttt7cHqvVKb12c8Ch6q+0Kzaupkymtg4kVqi74BeZUI4wFyYNpn47IB63gJJg==
X-Received: from ilbea4.prod.google.com ([2002:a05:6e02:4504:b0:436:f324:49])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:4d08:b0:659:9a49:9024 with SMTP id 006d021491bc7-65b2adaf85amr87797eaf.81.1765313565337;
 Tue, 09 Dec 2025 12:52:45 -0800 (PST)
Date: Tue,  9 Dec 2025 20:51:16 +0000
In-Reply-To: <20251209205121.1871534-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251209205121.1871534-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251209205121.1871534-20-coltonlewis@google.com>
Subject: [PATCH v5 19/24] KVM: arm64: Implement lazy PMU context swaps
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Since many guests will never touch the PMU, they need not pay the cost
of context swapping those registers.

Use an enum to implement a simple state machine for PMU register
access. The PMU either accesses registers virtually or physically.

Virtual access implies all PMU registers are trapped coarsely by
MDCR_EL2.TPM and therefore do not need to be context swapped. Physical
access implies some registers are untrapped through FGT and do need to
be context swapped. All vCPUs do virtual access by default and
transition to physical if the PMU is partitioned and the guest
actually tries a PMU access.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/asm/kvm_host.h       |  1 +
 arch/arm64/include/asm/kvm_pmu.h        |  4 ++++
 arch/arm64/include/asm/kvm_types.h      |  7 ++++++-
 arch/arm64/kvm/debug.c                  |  2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 ++
 arch/arm64/kvm/pmu-direct.c             | 21 +++++++++++++++++++++
 arch/arm64/kvm/pmu.c                    |  7 +++++++
 arch/arm64/kvm/sys_regs.c               |  4 ++++
 8 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c7e52aaf469dc..f92027d8fdfd0 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1373,6 +1373,7 @@ static inline bool kvm_system_needs_idmapped_vectors(void)
 	return cpus_have_final_cap(ARM64_SPECTRE_V3A);
 }
 
+void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu);
 void kvm_init_host_debug_data(void);
 void kvm_debug_init_vhe(void);
 void kvm_vcpu_load_debug(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/include/asm/kvm_pmu.h b/arch/arm64/include/asm/kvm_pmu.h
index 25a5eb8c623da..43aa334dce517 100644
--- a/arch/arm64/include/asm/kvm_pmu.h
+++ b/arch/arm64/include/asm/kvm_pmu.h
@@ -38,6 +38,7 @@ struct kvm_pmu {
 	int irq_num;
 	bool created;
 	bool irq_level;
+	enum vcpu_pmu_register_access access;
 };
 
 struct arm_pmu_entry {
@@ -106,6 +107,8 @@ u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu);
 void kvm_pmu_load(struct kvm_vcpu *vcpu);
 void kvm_pmu_put(struct kvm_vcpu *vcpu);
 
+void kvm_pmu_set_physical_access(struct kvm_vcpu *vcpu);
+
 #if !defined(__KVM_NVHE_HYPERVISOR__)
 bool kvm_vcpu_pmu_is_partitioned(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_pmu_use_fgt(struct kvm_vcpu *vcpu);
@@ -188,6 +191,7 @@ static inline u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu)
 }
 static inline void kvm_pmu_load(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_put(struct kvm_vcpu *vcpu) {}
+static inline void kvm_pmu_set_physical_access(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu,
 					     u64 select_idx, u64 val) {}
 static inline void kvm_pmu_set_counter_value_user(struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/include/asm/kvm_types.h b/arch/arm64/include/asm/kvm_types.h
index 9a126b9e2d7c9..9f67165359f5c 100644
--- a/arch/arm64/include/asm/kvm_types.h
+++ b/arch/arm64/include/asm/kvm_types.h
@@ -4,5 +4,10 @@
 
 #define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 40
 
-#endif /* _ASM_ARM64_KVM_TYPES_H */
+enum vcpu_pmu_register_access {
+	VCPU_PMU_ACCESS_UNSET,
+	VCPU_PMU_ACCESS_VIRTUAL,
+	VCPU_PMU_ACCESS_PHYSICAL,
+};
 
+#endif /* _ASM_ARM64_KVM_TYPES_H */
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 0ab89c91e19cb..c2cf6b308ec60 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -34,7 +34,7 @@ static int cpu_has_spe(u64 dfr0)
  *  - Self-hosted Trace Filter controls (MDCR_EL2_TTRF)
  *  - Self-hosted Trace (MDCR_EL2_TTRF/MDCR_EL2_E2TB)
  */
-static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
+void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 {
 	int hpmn = kvm_pmu_hpmn(vcpu);
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index bde79ec1a1836..ea288a712bb5d 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -963,6 +963,8 @@ static bool kvm_hyp_handle_pmu_regs(struct kvm_vcpu *vcpu)
 	if (ret)
 		__kvm_skip_instr(vcpu);
 
+	kvm_pmu_set_physical_access(vcpu);
+
 	return ret;
 }
 
diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index 8d0d6d1a0d851..c5767e2ebc651 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -73,6 +73,7 @@ bool kvm_vcpu_pmu_use_fgt(struct kvm_vcpu *vcpu)
 	u8 hpmn = vcpu->kvm->arch.nr_pmu_counters;
 
 	return kvm_vcpu_pmu_is_partitioned(vcpu) &&
+		vcpu->arch.pmu.access == VCPU_PMU_ACCESS_PHYSICAL &&
 		cpus_have_final_cap(ARM64_HAS_FGT) &&
 		(hpmn != 0 || cpus_have_final_cap(ARM64_HAS_HPMN0));
 }
@@ -92,6 +93,26 @@ u64 kvm_pmu_fgt2_bits(void)
 		| HDFGRTR2_EL2_nPMICNTR_EL0;
 }
 
+/**
+ * kvm_pmu_set_physical_access()
+ * @vcpu: Pointer to vcpu struct
+ *
+ * Reconfigure the guest for physical access of PMU hardware if
+ * allowed. This means reconfiguring mdcr_el2 and loading the vCPU
+ * state onto hardware.
+ *
+ */
+
+void kvm_pmu_set_physical_access(struct kvm_vcpu *vcpu)
+{
+	if (kvm_vcpu_pmu_is_partitioned(vcpu)
+	    && vcpu->arch.pmu.access == VCPU_PMU_ACCESS_VIRTUAL) {
+		vcpu->arch.pmu.access = VCPU_PMU_ACCESS_PHYSICAL;
+		kvm_arm_setup_mdcr_el2(vcpu);
+		kvm_pmu_load(vcpu);
+	}
+}
+
 /**
  * kvm_pmu_host_counter_mask() - Compute bitmask of host-reserved counters
  * @pmu: Pointer to arm_pmu struct
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 48b39f096fa12..c9862e55a4049 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -471,6 +471,12 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static void kvm_pmu_register_init(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.pmu.access == VCPU_PMU_ACCESS_UNSET)
+		vcpu->arch.pmu.access = VCPU_PMU_ACCESS_VIRTUAL;
+}
+
 static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
 {
 	if (irqchip_in_kernel(vcpu->kvm)) {
@@ -496,6 +502,7 @@ static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
 	init_irq_work(&vcpu->arch.pmu.overflow_work,
 		      kvm_pmu_perf_overflow_notify_vcpu);
 
+	kvm_pmu_register_init(vcpu);
 	vcpu->arch.pmu.created = true;
 	return 0;
 }
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f2ae761625a66..d73218706b834 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1197,6 +1197,8 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		p->regval = __vcpu_sys_reg(vcpu, reg);
 	}
 
+	kvm_pmu_set_physical_access(vcpu);
+
 	return true;
 }
 
@@ -1302,6 +1304,8 @@ static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		p->regval = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
 	}
 
+	kvm_pmu_set_physical_access(vcpu);
+
 	return true;
 }
 
-- 
2.52.0.239.gd5f0c6e74e-goog


