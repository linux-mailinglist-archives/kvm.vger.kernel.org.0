Return-Path: <kvm+bounces-52388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B1459B04B66
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 01:04:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CC534E1353
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 23:03:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D008F298984;
	Mon, 14 Jul 2025 22:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lsBl+MQ7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D0928C87D
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 22:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752533988; cv=none; b=RxLcQEFuRVC7vtZNM3PGjkq324eOR3F9glKddgiiiMP8vwbXqNxaKBr4qYgkeqGBe/JPvf71MSF2iRPZLoBy0+gdE14E0zieNlasYAkaQLsAInWo2v50NH7N8JGJjpS7CZU5RKbC1/NDfAZZSG0+dPmQuiLNUlo79Jn8izoW0GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752533988; c=relaxed/simple;
	bh=ncTcOod7yCrp61IU4E/ZxVDp0M1AnUaADW8CBXec3HY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FxgRV/ctKdzrn3JCJNnEtHpaaL+str19+v8BGzOQKbrSjn7ps8t5yl6bOsj47avsPLjCXRfTwzM6hamcZ1uhqRvrQmO/pJOhZmstKHouo21pYrqLUxan6lN4l0E25OGKw923AIJGv7kjnxy0qFe0A34Gh4kt2pJU7ulKUqFy1pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lsBl+MQ7; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3e168c6bb92so93948645ab.3
        for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 15:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752533985; x=1753138785; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FlCY+xVyEz2zjr3F2/cg+ko0FQSJ5xemxrZgto3SvkM=;
        b=lsBl+MQ7teSo19ILaGyxx/gK1WIXUhLJvWSfHVjeW8r8usWCVfc2ZF+yZNQRY/mm6r
         aat9Km7Kv+xU0n+Tv0Dzz35g1dT8winJOmJ6JYHvzhm4Gbesln4VFY8/Ci9lE7z6v/de
         ygz1AjJHGwJXfznEA+n5zQmgDTo22fIWyh90ziUOhceoEpO02bgCGrgeG4MUYuWCFcVz
         PVkpw4fj3cgzUnoHTW7zTHvD6RDD3NEAfMdtFXzzZBe2XpRIT1/i4gdDnESlM5DctbJa
         SORzj4KS/jU6DjmBNl4zX37ENT9l3ETGCSo8EgEHfZam4h5gE3SVnQsybWZho/1u5Mc5
         jNaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752533985; x=1753138785;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FlCY+xVyEz2zjr3F2/cg+ko0FQSJ5xemxrZgto3SvkM=;
        b=nPkltDRNjfUDscFuZu/c9JPd2uLnzMJsgGNexD8Go0NQKVhkXiat0oNRsDiOuPYZk4
         vVd8ygZge7PRZ2lj9Ggfp8xATauPGW+ens2ufj+wWusMHhwK1vHkOmHKpulhBid0+5VX
         8QKyZVYBFEHy+kOfJfnyCp56qtLtCh9KQJwylHcVkvJSfXfTaXul7CSZZVUvmXmFiHHy
         6I6iiqgbhsvTgz1lOCOkw2h+ib+MU+G41EyAo1MGFXh8xkjXl3u7CMhk5aCuUmoh2sN1
         F1ICX1ueRC0VKGZxgqSiOrK6ASEkKGMxpXEa901scEOVFByfD1og6S/AX03qhY8hXspV
         VaQQ==
X-Gm-Message-State: AOJu0YzpAKG23326PB7KL/oK5XtOoC3VCooKzrJEoWa2hqGefs3K3cuP
	lhvtdCrLJEzb2wgosnOlvFQyiu0zh14gM0U9lpP4q077dbSvvjG6s8M6dwtpTEBBcA3LmUv64D7
	V6KmcRkGPWFi71NbQ4x1q9iTAl2cKpwhp5GEtIu6DzO/V+vXfGDmMt1ZUYqwKp46uOiS3c/KqMl
	zgS3QUzmZDxpo6EmaIKej5Ivup3W2R8/Awo7a8GoW1EJAgVq9mbfkHB//K32Q=
X-Google-Smtp-Source: AGHT+IFGXdkNXkw8CoL88YaoE7byRV8SLefT+pkkqRRylYQFB4bn+wurTk8lSssQNgyaC/vm8Th1YX76JUVCTQT87g==
X-Received: from ilpp15.prod.google.com ([2002:a92:d28f:0:b0:3e2:47cf:3c9a])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:1582:b0:3df:49fa:7af5 with SMTP id e9e14a558f8ab-3e279250199mr5991275ab.21.1752533984589;
 Mon, 14 Jul 2025 15:59:44 -0700 (PDT)
Date: Mon, 14 Jul 2025 22:59:08 +0000
In-Reply-To: <20250714225917.1396543-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250714225917.1396543-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250714225917.1396543-15-coltonlewis@google.com>
Subject: [PATCH v4 14/23] KVM: arm64: Setup MDCR_EL2 to handle a partitioned PMU
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

Setup MDCR_EL2 to handle a partitioned PMU. That means calculate an
appropriate value for HPMN instead of the maximum setting the host
allows (which implies no partition) so hardware enforces that a guest
will only see the counters in the guest partition.

With HPMN set, we can now leave the TPM and TPMCR bits unset unless
FGT is not available, in which case we need to fall back to that.

Also, if available, set the filtering bits HPMD and HCCD to be extra
sure nothing counts at EL2.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/asm/kvm_pmu.h | 11 ++++++
 arch/arm64/kvm/debug.c           | 23 ++++++++++---
 arch/arm64/kvm/pmu-direct.c      | 57 ++++++++++++++++++++++++++++++++
 3 files changed, 86 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pmu.h b/arch/arm64/include/asm/kvm_pmu.h
index 62c8032a548f..35674879aae0 100644
--- a/arch/arm64/include/asm/kvm_pmu.h
+++ b/arch/arm64/include/asm/kvm_pmu.h
@@ -96,6 +96,9 @@ u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu);
 void kvm_pmu_host_counters_enable(void);
 void kvm_pmu_host_counters_disable(void);
 
+u8 kvm_pmu_guest_num_counters(struct kvm_vcpu *vcpu);
+u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu);
+
 #if !defined(__KVM_NVHE_HYPERVISOR__)
 bool kvm_vcpu_pmu_is_partitioned(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_pmu_use_fgt(struct kvm_vcpu *vcpu);
@@ -158,6 +161,14 @@ static inline bool kvm_vcpu_pmu_use_fgt(struct kvm_vcpu *vcpu)
 {
 	return false;
 }
+static inline u8 kvm_pmu_guest_num_counters(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+static inline u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
 static inline void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu,
 					     u64 select_idx, u64 val) {}
 static inline void kvm_pmu_set_counter_value_user(struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 1a7dab333f55..8ae9d141cad4 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -36,15 +36,28 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 	 * This also clears MDCR_EL2_E2PB_MASK and MDCR_EL2_E2TB_MASK
 	 * to disable guest access to the profiling and trace buffers
 	 */
-	vcpu->arch.mdcr_el2 = FIELD_PREP(MDCR_EL2_HPMN,
-					 *host_data_ptr(nr_event_counters));
-	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
-				MDCR_EL2_TPMS |
-				MDCR_EL2_TTRF |
+	vcpu->arch.mdcr_el2 = FIELD_PREP(MDCR_EL2_HPMN, kvm_pmu_hpmn(vcpu));
+	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TTRF |
 				MDCR_EL2_TPMCR |
 				MDCR_EL2_TDRA |
 				MDCR_EL2_TDOSA);
 
+	if (kvm_vcpu_pmu_is_partitioned(vcpu)
+	    && is_pmuv3p1(read_pmuver())) {
+		/*
+		 * Filtering these should be redundant because we trap
+		 * all the TYPER and FILTR registers anyway and ensure
+		 * they filter EL2, but set the bits if they are here.
+		 */
+		vcpu->arch.mdcr_el2 |= MDCR_EL2_HPMD;
+
+		if (is_pmuv3p5(read_pmuver()))
+			vcpu->arch.mdcr_el2 |= MDCR_EL2_HCCD;
+	}
+
+	if (!kvm_vcpu_pmu_use_fgt(vcpu))
+		vcpu->arch.mdcr_el2 |= MDCR_EL2_TPM | MDCR_EL2_TPMCR;
+
 	/* Is the VM being debugged by userspace? */
 	if (vcpu->guest_debug)
 		/* Route all software debug exceptions to EL2 */
diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index 2eef77e8340d..0fac82b152ca 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -136,3 +136,60 @@ void kvm_pmu_host_counters_disable(void)
 	mdcr &= ~MDCR_EL2_HPME;
 	write_sysreg(mdcr, mdcr_el2);
 }
+
+/**
+ * kvm_pmu_guest_num_counters() - Number of counters to show to guest
+ * @vcpu: Pointer to struct kvm_vcpu
+ *
+ * Calculate the number of counters to show to the guest via
+ * PMCR_EL0.N, making sure to respect the maximum the host allows,
+ * which is hpmn_max if partitioned and host_max otherwise.
+ *
+ * Return: Valid value for PMCR_EL0.N
+ */
+u8 kvm_pmu_guest_num_counters(struct kvm_vcpu *vcpu)
+{
+	u8 nr_cnt = vcpu->kvm->arch.nr_pmu_counters;
+	int hpmn_max = vcpu->kvm->arch.arm_pmu->hpmn_max;
+	u8 host_max = *host_data_ptr(nr_event_counters);
+
+	if (kvm_vcpu_pmu_is_partitioned(vcpu)) {
+		if (nr_cnt <= hpmn_max && nr_cnt <= host_max)
+			return nr_cnt;
+		if (hpmn_max <= host_max)
+			return hpmn_max;
+	}
+
+	if (nr_cnt <= host_max)
+		return nr_cnt;
+
+	return host_max;
+}
+
+/**
+ * kvm_pmu_hpmn() - Calculate HPMN field value
+ * @vcpu: Pointer to struct kvm_vcpu
+ *
+ * Calculate the appropriate value to set for MDCR_EL2.HPMN, ensuring
+ * it always stays below the number of counters on the current CPU and
+ * above 0 unless the CPU has FEAT_HPMN0.
+ *
+ * This function works whether or not the PMU is partitioned.
+ *
+ * Return: A valid HPMN value
+ */
+u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu)
+{
+	u8 hpmn = kvm_pmu_guest_num_counters(vcpu);
+	int hpmn_max = vcpu->kvm->arch.arm_pmu->hpmn_max;
+	u8 host_max = *host_data_ptr(nr_event_counters);
+
+	if (hpmn == 0 && !cpus_have_final_cap(ARM64_HAS_HPMN0)) {
+		if (kvm_vcpu_pmu_is_partitioned(vcpu))
+			return hpmn_max;
+		else
+			return host_max;
+	}
+
+	return hpmn;
+}
-- 
2.50.0.727.gbf7dc18ff4-goog


