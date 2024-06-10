Return-Path: <kvm+bounces-19225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13FB5902326
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 15:55:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A10F2282D9B
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 13:55:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F455158876;
	Mon, 10 Jun 2024 13:44:22 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E16C158860;
	Mon, 10 Jun 2024 13:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718027061; cv=none; b=Kmx74Yhf3dH1mTEK0SCNLKJB4n079hKFXxlryfqACPN/nE3ayWeu0its2Ewpb9Lwx+m9BiRiLQ1zBw8toQXdO29oJGTsmeKb1DMYtqoEOJNyDEMzaRPkoTbhbHeYMB+sZQ7VTfWkdP89fAxQCdFF69SKGDixSdooWygrduvJxvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718027061; c=relaxed/simple;
	bh=EqIVL99RksMyW03r7beE76IMLiT2LRaV5fyaTOjnp8c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PvvArmWbFgCat3G0eFina+amZP7TPa3OXwAbomqqyo/oOYZ19rDQQV0++FmTnO92JlZJbN9GqQXcHzB/Izo9fUZSsZwM9wgILEbDEAZ6wG573mSOYJfCJFWMfYZBcUoDxIuC2GzMaX277IxZbv2pa0X4KBHp9b2ZwFMpx1/LVW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 52CE412FC;
	Mon, 10 Jun 2024 06:44:44 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.35.41])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 154403F58B;
	Mon, 10 Jun 2024 06:44:16 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH v3 38/43] arm64: RME: Propagate max SVE vector length from RMM
Date: Mon, 10 Jun 2024 14:41:57 +0100
Message-Id: <20240610134202.54893-39-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240610134202.54893-1-steven.price@arm.com>
References: <20240610134202.54893-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

RMM provides the maximum vector length it supports for a guest in its
feature register. Make it visible to the rest of KVM and to userspace
via KVM_REG_ARM64_SVE_VLS.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/include/asm/kvm_rme.h  |  1 +
 arch/arm64/kvm/guest.c            |  2 +-
 arch/arm64/kvm/reset.c            | 12 ++++++++++--
 arch/arm64/kvm/rme.c              |  6 ++++++
 5 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bacd2bf1f084..804da7337439 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -76,8 +76,8 @@ static inline enum kvm_mode kvm_get_mode(void) { return KVM_MODE_NONE; };
 
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
-extern unsigned int __ro_after_init kvm_sve_max_vl;
 int __init kvm_arm_init_sve(void);
+unsigned int kvm_sve_get_max_vl(struct kvm *kvm);
 
 u32 __attribute_const__ kvm_target_cpu(void);
 void kvm_reset_vcpu(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
index c30d7899f58b..a72e06cf4ea6 100644
--- a/arch/arm64/include/asm/kvm_rme.h
+++ b/arch/arm64/include/asm/kvm_rme.h
@@ -89,6 +89,7 @@ struct realm_rec {
 void kvm_init_rme(void);
 u32 kvm_realm_ipa_limit(void);
 u8 kvm_realm_max_pmu_counters(void);
+unsigned int kvm_realm_sve_max_vl(void);
 u64 kvm_realm_reset_id_aa64dfr0_el1(struct kvm_vcpu *vcpu, u64 val);
 
 bool kvm_rme_supports_sve(void);
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index ad77e1343269..c06098bc5392 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -355,7 +355,7 @@ static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		if (vq_present(vqs, vq))
 			max_vq = vq;
 
-	if (max_vq > sve_vq_from_vl(kvm_sve_max_vl))
+	if (max_vq > sve_vq_from_vl(kvm_sve_get_max_vl(vcpu->kvm)))
 		return -EINVAL;
 
 	/*
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 073c9b6b9285..f8b56f6b6dc5 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -45,7 +45,7 @@ static u32 __ro_after_init kvm_ipa_limit;
 #define VCPU_RESET_PSTATE_SVC	(PSR_AA32_MODE_SVC | PSR_AA32_A_BIT | \
 				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
 
-unsigned int __ro_after_init kvm_sve_max_vl;
+static unsigned int __ro_after_init kvm_sve_max_vl;
 
 int __init kvm_arm_init_sve(void)
 {
@@ -73,9 +73,17 @@ int __init kvm_arm_init_sve(void)
 	return 0;
 }
 
+unsigned int kvm_sve_get_max_vl(struct kvm *kvm)
+{
+	if (kvm_is_realm(kvm))
+		return kvm_realm_sve_max_vl();
+	else
+		return kvm_sve_max_vl;
+}
+
 static void kvm_vcpu_enable_sve(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.sve_max_vl = kvm_sve_max_vl;
+	vcpu->arch.sve_max_vl = kvm_sve_get_max_vl(vcpu->kvm);
 
 	/*
 	 * Userspace can still customize the vector lengths by writing
diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
index 1d355f0bb0eb..81964d87daa6 100644
--- a/arch/arm64/kvm/rme.c
+++ b/arch/arm64/kvm/rme.c
@@ -291,6 +291,12 @@ u8 kvm_realm_max_pmu_counters(void)
 	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_PMU_NUM_CTRS);
 }
 
+unsigned int kvm_realm_sve_max_vl(void)
+{
+	return sve_vl_from_vq(u64_get_bits(rmm_feat_reg0,
+					   RMI_FEATURE_REGISTER_0_SVE_VL) + 1);
+}
+
 u64 kvm_realm_reset_id_aa64dfr0_el1(struct kvm_vcpu *vcpu, u64 val)
 {
 	u32 bps = u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_NUM_BPS);
-- 
2.34.1


