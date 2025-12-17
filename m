Return-Path: <kvm+bounces-66152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id CF786CC70A3
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 11:18:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E7902300A8FC
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 10:18:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7875732572F;
	Wed, 17 Dec 2025 10:15:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8326C358D01;
	Wed, 17 Dec 2025 10:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765966505; cv=none; b=ZgeklylaA7HCm3UrAFLj0sJyObP7ksQsAXdeUkubv5n0HSbE7vSwD4iVuNqg7wpNRGPCzUlLi42uAl1c1Wdc6WaJhSix/LxMIZhtG4+eK7hDn6J9c2HHtOBfeKbuhfol7sAG6Mon/D3oyYi0Jou3wrwSGOLjSQZC/meTGE+BdTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765966505; c=relaxed/simple;
	bh=/2aGgS+X+lP+90bnJa+L/ODzERXeWnYn7cz3iC12W4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2D7kj8SCl5GOI2vX1aRgFe/rHA4EVGyZdpzi6+hqalYSJAhfJoylgu6L596oCGVFC8pY5Ro9Ls/D23VcDHFd+NQAlUXgFIt+y04oYuyQ14q17klLIb7WTehiowkHaoWcQi3C1rhMyBk1LzdJfIJG8iV0zk9K1krTO7xUGV7JfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CF7BF1517;
	Wed, 17 Dec 2025 02:14:56 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.45.201])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D37C23F73B;
	Wed, 17 Dec 2025 02:14:59 -0800 (PST)
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
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH v12 41/46] arm64: RMI: Propagate max SVE vector length from RMM
Date: Wed, 17 Dec 2025 10:11:18 +0000
Message-ID: <20251217101125.91098-42-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251217101125.91098-1-steven.price@arm.com>
References: <20251217101125.91098-1-steven.price@arm.com>
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
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/include/asm/kvm_rmi.h  |  1 +
 arch/arm64/kvm/guest.c            |  2 +-
 arch/arm64/kvm/reset.c            | 12 ++++++++++--
 arch/arm64/kvm/rmi.c              |  6 ++++++
 5 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7590d86c78a5..97c747cfb5be 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -78,9 +78,9 @@ enum kvm_mode kvm_get_mode(void);
 static inline enum kvm_mode kvm_get_mode(void) { return KVM_MODE_NONE; };
 #endif
 
-extern unsigned int __ro_after_init kvm_sve_max_vl;
 extern unsigned int __ro_after_init kvm_host_sve_max_vl;
 int __init kvm_arm_init_sve(void);
+unsigned int kvm_sve_get_max_vl(struct kvm *kvm);
 
 u32 __attribute_const__ kvm_target_cpu(void);
 void kvm_reset_vcpu(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
index 39770d9e9fcb..073b999bcd96 100644
--- a/arch/arm64/include/asm/kvm_rmi.h
+++ b/arch/arm64/include/asm/kvm_rmi.h
@@ -89,6 +89,7 @@ void kvm_init_rmi(void);
 u32 kvm_realm_ipa_limit(void);
 u32 kvm_realm_vgic_nr_lr(void);
 u8 kvm_realm_max_pmu_counters(void);
+unsigned int kvm_realm_sve_max_vl(void);
 
 u64 kvm_realm_reset_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val);
 
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 7cf919db1adc..705c2ccc335d 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -375,7 +375,7 @@ static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 		if (vq_present(vqs, vq))
 			max_vq = vq;
 
-	if (max_vq > sve_vq_from_vl(kvm_sve_max_vl))
+	if (max_vq > sve_vq_from_vl(kvm_sve_get_max_vl(vcpu->kvm)))
 		return -EINVAL;
 
 	/*
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 4bbf58892928..08883c9e848f 100644
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
diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 4e1c7bc2f52a..b719c39329c8 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -97,6 +97,12 @@ u8 kvm_realm_max_pmu_counters(void)
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


