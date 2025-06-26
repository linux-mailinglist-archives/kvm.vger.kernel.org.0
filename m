Return-Path: <kvm+bounces-50890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E5DDAEA7E3
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 22:09:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10A0B17B4B2
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 20:09:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A5F32FC015;
	Thu, 26 Jun 2025 20:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LosUU2eC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3562F49E5
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 20:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750968366; cv=none; b=XMvQPd3MWovgGptxy0ww4tLttR5YqkhnDjaJnPXDeeiU0vL6MJPFo9BE7WYTA535NxTT3vXpKNGbKvns572QA7KZ0AdB0U+Bib9Jfp0VuUHLuSU5Dkd8lA0OX44uh0f5P5K8+YUt3miFcFf+ixI4VCu8Id+RVKx2InV3yK3CNXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750968366; c=relaxed/simple;
	bh=4fAdFsyi27Pf8+Vjrkp71TZRc32rI/HvSzPk9iR23Hc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rJZLOGIRvq/2oj1cWccnW9Ezlm3wvZkDN4k2MsUVe3+DSbZ8T3Wu0E48ez4mNQdwOyviGIni8esd7jena+J/KP9GScEQesY1xcK50u5x2sfDBBVDdCytdSxthmSiCH/Gb/I4a+ZSGjiOdVyqfUp1vk7/lxFvW3/ja2GDBAsuDSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LosUU2eC; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-86cf89ff625so135825939f.0
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 13:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750968362; x=1751573162; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5EUw4Y0mcnEG/FkgSChX2W9q1RZ2xMCnbVv00SQ/fhA=;
        b=LosUU2eCqwlbnab6SSo3tAy6f7jlh65MM46FDRsV9QSKVgc05VhRUkmD7mJeXwVeC3
         /Ob+yHQfAKsTnC0X57l0dUj5WPRaIUZVYroa+sHWSo0rt/sM8F8/Ljs35NQREN/C08aU
         UKChFILDTsJb33KnLuXBJNF0P6d6hhWGyQmr2CVX2RmR/twy/Q7LUJ2oxx9TXhGL415b
         dj3yXKDqZujOhdxmrBoe2XU+qiZLZr9XGZh2DMZsQP+nhZmnP9OpeUtvPWtvgYGhQ8JQ
         xrRrWNQMRej8eyuwdGPUrQyDkxv8QVxQYOgRrNUMGNBUMQeCJV18xc/CvraiCbtNhzQv
         /hug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750968362; x=1751573162;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5EUw4Y0mcnEG/FkgSChX2W9q1RZ2xMCnbVv00SQ/fhA=;
        b=owp/eOq9GAgT7p0MJIlyKHBsydRLl1HGyBm6F1HluL9N0238QpVJPen+jPGxzYF/MC
         olCi2OGgL1SAKpAOlRbfec7LZq9GAw+sorlP2b9As+gh98LJHgdnRwH+wrjaBfU3b47B
         JHhaC1zxkqrf2wYSpJyrd9+nymR5yvv2wN0A9LRrKFvJO1tVI54uUYKve2RSpj7xjDI3
         4UKhHmOclEegcawJ3YHTYGJyykd1srjco85BSYEy7/D43N737oyfVgXobXFswR2Z1hCq
         Rpp9qThfJnSZ9kC1ZySc2LiKXXBGykd/m8ZSkSVtNZPdAlwDgNwaKZajf2v760+DEHKZ
         B4bA==
X-Gm-Message-State: AOJu0Ywwlnimi06vFYLwnTBFw0owioOK0hbCsDH5T2nnewV/ZYwLkott
	2nwnKN3RiMTkX4WBYwq91bu4+p5Msxk8lKj4SMCAWDypA17tuhugxTzDGrvt8e0X144ESUu9JWx
	XcLcE+vDfrT/cGw2kDeClZ6MbV/9MhkEa5dTd9PF0WcTHjHLICM6xOTs/5R+DcbfCpaEkKXdGE7
	39+QNJTig7Xg99xhxcjcmjbGhduWll8DgTdlt568JhJMNsby0VSn1M0fR83+E=
X-Google-Smtp-Source: AGHT+IEGP6p3lSxAsTlEVIC7KYL0WEMMLhnUKbnvL8lg4j3kdPHiyfZtI7gPbyS5YbhTsvYef9EF8diocba00WqnwQ==
X-Received: from ilbbs10.prod.google.com ([2002:a05:6e02:240a:b0:3dd:bbd4:ed74])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:1c23:b0:3dd:ceb0:f603 with SMTP id e9e14a558f8ab-3df4ab6aa68mr11148085ab.2.1750968361548;
 Thu, 26 Jun 2025 13:06:01 -0700 (PDT)
Date: Thu, 26 Jun 2025 20:04:46 +0000
In-Reply-To: <20250626200459.1153955-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250626200459.1153955-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250626200459.1153955-11-coltonlewis@google.com>
Subject: [PATCH v3 10/22] KVM: arm64: Set up FGT for Partitioned PMU
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

In order to gain the best performance benefit from partitioning the
PMU, utilize fine grain traps (FEAT_FGT and FEAT_FGT2) to avoid
trapping common PMU register accesses by the guest to remove that
overhead.

There should be no information leaks between guests as all these
registers are context swapped by a later patch in this series.

Untrapped:
* PMCR_EL0
* PMUSERENR_EL0
* PMSELR_EL0
* PMCCNTR_EL0
* PMINTEN_EL0
* PMEVCNTRn_EL0

Trapped:
* PMOVS_EL0
* PMEVTYPERn_EL0
* PMCCFILTR_EL0
* PMICNTR_EL0
* PMICFILTR_EL0

PMOVS remains trapped so KVM can track overflow IRQs that will need to
be injected into the guest.

PMICNTR remains trapped because KVM is not handling that yet.

PMEVTYPERn remains trapped so KVM can limit which events guests can
count, such as disallowing counting at EL2. PMCCFILTR and PMCIFILTR
are the same.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/asm/kvm_pmu.h        | 23 ++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 58 +++++++++++++++++++++++++
 arch/arm64/kvm/pmu-part.c               | 32 ++++++++++++++
 3 files changed, 113 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pmu.h b/arch/arm64/include/asm/kvm_pmu.h
index 6328e90952ba..73b7161e3f4e 100644
--- a/arch/arm64/include/asm/kvm_pmu.h
+++ b/arch/arm64/include/asm/kvm_pmu.h
@@ -94,6 +94,21 @@ u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu);
 void kvm_pmu_host_counters_enable(void);
 void kvm_pmu_host_counters_disable(void);
 
+#if !defined(__KVM_NVHE_HYPERVISOR__)
+bool kvm_vcpu_pmu_is_partitioned(struct kvm_vcpu *vcpu);
+bool kvm_vcpu_pmu_use_fgt(struct kvm_vcpu *vcpu);
+#else
+static inline bool kvm_vcpu_pmu_is_partitioned(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+
+static inline bool kvm_vcpu_pmu_use_fgt(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+#endif
+
 /*
  * Updates the vcpu's view of the pmu events for this cpu.
  * Must be called before every vcpu run after disabling interrupts, to ensure
@@ -133,6 +148,14 @@ static inline u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu,
 {
 	return 0;
 }
+static inline bool kvm_vcpu_pmu_is_partitioned(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
+static inline bool kvm_vcpu_pmu_use_fgt(struct kvm_vcpu *vcpu)
+{
+	return false;
+}
 static inline void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu,
 					     u64 select_idx, u64 val) {}
 static inline void kvm_pmu_set_counter_value_user(struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 825b81749972..47d2db8446df 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -191,6 +191,61 @@ static inline bool cpu_has_amu(void)
                ID_AA64PFR0_EL1_AMU_SHIFT);
 }
 
+/**
+ * __activate_pmu_fgt() - Activate fine grain traps for partitioned PMU
+ * @vcpu: Pointer to struct kvm_vcpu
+ *
+ * Clear the most commonly accessed registers for a partitioned
+ * PMU. Trap the rest.
+ */
+static inline void __activate_pmu_fgt(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpu_context *hctxt = host_data_ptr(host_ctxt);
+	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
+	u64 set;
+	u64 clr;
+
+	set = HDFGRTR_EL2_PMOVS
+		| HDFGRTR_EL2_PMCCFILTR_EL0
+		| HDFGRTR_EL2_PMEVTYPERn_EL0;
+	clr = HDFGRTR_EL2_PMUSERENR_EL0
+		| HDFGRTR_EL2_PMSELR_EL0
+		| HDFGRTR_EL2_PMINTEN
+		| HDFGRTR_EL2_PMCNTEN
+		| HDFGRTR_EL2_PMCCNTR_EL0
+		| HDFGRTR_EL2_PMEVCNTRn_EL0;
+
+	update_fgt_traps_cs(hctxt, vcpu, kvm, HDFGRTR_EL2, clr, set);
+
+	set = HDFGWTR_EL2_PMOVS
+		| HDFGWTR_EL2_PMCCFILTR_EL0
+		| HDFGWTR_EL2_PMEVTYPERn_EL0;
+	clr = HDFGWTR_EL2_PMUSERENR_EL0
+		| HDFGWTR_EL2_PMCR_EL0
+		| HDFGWTR_EL2_PMSELR_EL0
+		| HDFGWTR_EL2_PMINTEN
+		| HDFGWTR_EL2_PMCNTEN
+		| HDFGWTR_EL2_PMCCNTR_EL0
+		| HDFGWTR_EL2_PMEVCNTRn_EL0;
+
+	update_fgt_traps_cs(hctxt, vcpu, kvm, HDFGWTR_EL2, clr, set);
+
+	if (!cpus_have_final_cap(ARM64_HAS_FGT2))
+		return;
+
+	set = HDFGRTR2_EL2_nPMICFILTR_EL0
+		| HDFGRTR2_EL2_nPMICNTR_EL0;
+	clr = 0;
+
+	update_fgt_traps_cs(hctxt, vcpu, kvm, HDFGRTR2_EL2, clr, set);
+
+	set = HDFGWTR2_EL2_nPMICFILTR_EL0
+		| HDFGWTR2_EL2_nPMICNTR_EL0;
+	clr = 0;
+
+	update_fgt_traps_cs(hctxt, vcpu, kvm, HDFGWTR2_EL2, clr, set);
+}
+
 static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *hctxt = host_data_ptr(host_ctxt);
@@ -210,6 +265,9 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 	if (cpu_has_amu())
 		update_fgt_traps(hctxt, vcpu, kvm, HAFGRTR_EL2);
 
+	if (kvm_vcpu_pmu_use_fgt(vcpu))
+		__activate_pmu_fgt(vcpu);
+
 	if (!cpus_have_final_cap(ARM64_HAS_FGT2))
 	    return;
 
diff --git a/arch/arm64/kvm/pmu-part.c b/arch/arm64/kvm/pmu-part.c
index 4f06a48175e2..92775e19cbf6 100644
--- a/arch/arm64/kvm/pmu-part.c
+++ b/arch/arm64/kvm/pmu-part.c
@@ -41,6 +41,38 @@ bool kvm_pmu_is_partitioned(struct arm_pmu *pmu)
 		pmu->hpmn_max <= *host_data_ptr(nr_event_counters);
 }
 
+/**
+ * kvm_vcpu_pmu_is_partitioned() - Determine if given VCPU has a partitioned PMU
+ * @vcpu: Pointer to kvm_vcpu struct
+ *
+ * Determine if given VCPU has a partitioned PMU by extracting that
+ * field and passing it to :c:func:`kvm_pmu_is_partitioned`
+ *
+ * Return: True if the VCPU PMU is partitioned, false otherwise
+ */
+bool kvm_vcpu_pmu_is_partitioned(struct kvm_vcpu *vcpu)
+{
+	return kvm_pmu_is_partitioned(vcpu->kvm->arch.arm_pmu);
+}
+
+/**
+ * kvm_vcpu_pmu_use_fgt() - Determine if we can use FGT
+ * @vcpu: Pointer to struct kvm_vcpu
+ *
+ * Determine if we can use FGT for direct access to registers. We can
+ * if capabilities permit the number of guest counters requested.
+ *
+ * Return: True if we can use FGT, false otherwise
+ */
+bool kvm_vcpu_pmu_use_fgt(struct kvm_vcpu *vcpu)
+{
+	u8 hpmn = vcpu->kvm->arch.nr_pmu_counters;
+
+	return kvm_vcpu_pmu_is_partitioned(vcpu) &&
+		cpus_have_final_cap(ARM64_HAS_FGT) &&
+		(hpmn != 0 || cpus_have_final_cap(ARM64_HAS_HPMN0));
+}
+
 /**
  * kvm_pmu_host_counter_mask() - Compute bitmask of host-reserved counters
  * @pmu: Pointer to arm_pmu struct
-- 
2.50.0.727.gbf7dc18ff4-goog


