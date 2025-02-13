Return-Path: <kvm+bounces-38069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C6A7BA34A0B
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 17:36:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 172F93B7E53
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 16:27:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D10FE286AD8;
	Thu, 13 Feb 2025 16:17:40 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C80F1286AC8;
	Thu, 13 Feb 2025 16:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739463460; cv=none; b=N0dFDRMN16iEw71unjEYBsz6I/3tZxjaR9l4XObrMHP3LfCrXXtr6lV3f9SFS6I4dmvisZkOM4WITxtxUBtxsIsTTDIIhhXwB9ggcZmrHqwVlP/jbRKmPzRgq6i77uRvnJwd2dV+bnZzc0aExl+qmaBvb1BknjXdVW2rZrVn3Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739463460; c=relaxed/simple;
	bh=GRHihhhrGEaI+C8eaiAI2maE9hOkBq7w/keu+oRh8EM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNNCYMFbVgX2uVEgw/VImOVwaiqFgr4vqoBqQRedTwH0+H/Yl98NVrnIoEsoOAX+VVUiTohwF5pgHhrDjyyJYi6o9UXUzHRAKRsSoxbjVMm6C/+n6mpj+VGj3JuHevz5y8UP+Abj5ulpQbzmjpJ9RteUNyE9q/6OWWQ+pN5GlNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A3B71756;
	Thu, 13 Feb 2025 08:17:59 -0800 (PST)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.32.44])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 64B563F6A8;
	Thu, 13 Feb 2025 08:17:33 -0800 (PST)
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
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH v7 38/45] arm64: RME: Propagate max SVE vector length from RMM
Date: Thu, 13 Feb 2025 16:14:18 +0000
Message-ID: <20250213161426.102987-39-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250213161426.102987-1-steven.price@arm.com>
References: <20250213161426.102987-1-steven.price@arm.com>
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
index 016d0685958d..6f05aecfda99 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -75,9 +75,9 @@ enum kvm_mode kvm_get_mode(void);
 static inline enum kvm_mode kvm_get_mode(void) { return KVM_MODE_NONE; };
 #endif
 
-extern unsigned int __ro_after_init kvm_sve_max_vl;
 extern unsigned int __ro_after_init kvm_host_sve_max_vl;
 int __init kvm_arm_init_sve(void);
+unsigned int kvm_sve_get_max_vl(struct kvm *kvm);
 
 u32 __attribute_const__ kvm_target_cpu(void);
 void kvm_reset_vcpu(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
index 8a8ec70f3626..9644947e0b9b 100644
--- a/arch/arm64/include/asm/kvm_rme.h
+++ b/arch/arm64/include/asm/kvm_rme.h
@@ -85,6 +85,7 @@ void kvm_init_rme(void);
 u32 kvm_realm_ipa_limit(void);
 u32 kvm_realm_vgic_nr_lr(void);
 u8 kvm_realm_max_pmu_counters(void);
+unsigned int kvm_realm_sve_max_vl(void);
 
 u64 kvm_realm_reset_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val);
 
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index dbd45d0a0d54..17d988289100 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -374,7 +374,7 @@ static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		if (vq_present(vqs, vq))
 			max_vq = vq;
 
-	if (max_vq > sve_vq_from_vl(kvm_sve_max_vl))
+	if (max_vq > sve_vq_from_vl(kvm_sve_get_max_vl(vcpu->kvm)))
 		return -EINVAL;
 
 	/*
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index a6423ef20144..584fc40e04aa 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -46,7 +46,7 @@ unsigned int __ro_after_init kvm_host_sve_max_vl;
 #define VCPU_RESET_PSTATE_SVC	(PSR_AA32_MODE_SVC | PSR_AA32_A_BIT | \
 				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
 
-unsigned int __ro_after_init kvm_sve_max_vl;
+static unsigned int __ro_after_init kvm_sve_max_vl;
 
 int __init kvm_arm_init_sve(void)
 {
@@ -76,9 +76,17 @@ int __init kvm_arm_init_sve(void)
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
index f620a64551d9..c7a3802cedb4 100644
--- a/arch/arm64/kvm/rme.c
+++ b/arch/arm64/kvm/rme.c
@@ -92,6 +92,12 @@ u8 kvm_realm_max_pmu_counters(void)
 	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_PMU_NUM_CTRS);
 }
 
+unsigned int kvm_realm_sve_max_vl(void)
+{
+	return sve_vl_from_vq(u64_get_bits(rmm_feat_reg0,
+					   RMI_FEATURE_REGISTER_0_SVE_VL) + 1);
+}
+
 u64 kvm_realm_reset_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
 {
 	u32 bps = u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_NUM_BPS);
-- 
2.43.0


