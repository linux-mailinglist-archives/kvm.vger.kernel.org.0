Return-Path: <kvm+bounces-55178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 08B22B2E083
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 17:16:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B1C2189A053
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 15:12:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E574B369987;
	Wed, 20 Aug 2025 15:00:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3EB632A3D2;
	Wed, 20 Aug 2025 15:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755702015; cv=none; b=SPc4vVQxOtTDRl7MwYtofMnv5LmDI58oy5TiKqePcPjCKVOseQ/i/mPsg9w14XZixDf93rmHIIirAYX3z4O70sECcHCcY5UrOuOt4nSPfQEskp0QaeFx1Eg/uPLzdSEr2/FCLWu7pabq5ToA0d83GmdOKnjmiyS24jiKpfxk/A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755702015; c=relaxed/simple;
	bh=INp6/V0chc4MosaoqsyL+pUp21+qzi+VKjjP3vtRX2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MDlfxgmRZEvoHmeKrKrJV6ymsZ0zQOY0XOd9GxoeFkwlAOVlA2TYwHJwJCgN2OAoQMA19oe78hRxCr+g4YEJO8Gfua0Gb3v3JKHkDvIRUmbjF3NuvDPEqBoPSnaR0KCD4Jn840Ud4G6e8Lo8gsgrkxbrt1RL4XEvaswxxOrZYOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 17CF42F27;
	Wed, 20 Aug 2025 08:00:05 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.2.58])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E65913F738;
	Wed, 20 Aug 2025 08:00:08 -0700 (PDT)
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
Subject: [PATCH v10 38/43] arm64: RME: Configure max SVE vector length for a Realm
Date: Wed, 20 Aug 2025 15:55:58 +0100
Message-ID: <20250820145606.180644-39-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250820145606.180644-1-steven.price@arm.com>
References: <20250820145606.180644-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

Obtain the max vector length configured by userspace on the vCPUs, and
write it into the Realm parameters. By default the vCPU is configured
with the max vector length reported by RMM, and userspace can reduce it
with a write to KVM_REG_ARM64_SVE_VLS.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Steven Price <steven.price@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since v6:
 * Rename max_vl/realm_max_vl to vl/last_vl - there is nothing "maximum"
   about them, we're just checking that all realms have the same vector
   length
---
 arch/arm64/kvm/guest.c |  3 ++-
 arch/arm64/kvm/rme.c   | 42 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index eb5ff28a69d7..5dcf3728fe25 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -361,7 +361,7 @@ static int set_sve_vls(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	if (!vcpu_has_sve(vcpu))
 		return -ENOENT;
 
-	if (kvm_arm_vcpu_sve_finalized(vcpu))
+	if (kvm_arm_vcpu_sve_finalized(vcpu) || kvm_realm_is_created(vcpu->kvm))
 		return -EPERM; /* too late! */
 
 	if (WARN_ON(vcpu->arch.sve_state))
@@ -823,6 +823,7 @@ static bool validate_realm_set_reg(struct kvm_vcpu *vcpu,
 		switch (reg->id) {
 		case KVM_REG_ARM_PMCR_EL0:
 		case KVM_REG_ARM_ID_AA64DFR0_EL1:
+		case KVM_REG_ARM64_SVE_VLS:
 			return true;
 		}
 	}
diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
index 2955498e9e94..55ef3143a7b2 100644
--- a/arch/arm64/kvm/rme.c
+++ b/arch/arm64/kvm/rme.c
@@ -578,6 +578,44 @@ static void realm_unmap_shared_range(struct kvm *kvm,
 			     start, end);
 }
 
+static int realm_init_sve_param(struct kvm *kvm, struct realm_params *params)
+{
+	int ret = 0;
+	unsigned long i;
+	struct kvm_vcpu *vcpu;
+	int vl, last_vl = -1;
+
+	/*
+	 * Get the preferred SVE configuration, set by userspace with the
+	 * KVM_ARM_VCPU_SVE feature and KVM_REG_ARM64_SVE_VLS pseudo-register.
+	 */
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		mutex_lock(&vcpu->mutex);
+		if (vcpu_has_sve(vcpu)) {
+			if (!kvm_arm_vcpu_sve_finalized(vcpu))
+				ret = -EINVAL;
+			vl = vcpu->arch.sve_max_vl;
+		} else {
+			vl = 0;
+		}
+		mutex_unlock(&vcpu->mutex);
+		if (ret)
+			return ret;
+
+		/* We need all vCPUs to have the same SVE config */
+		if (last_vl >= 0 && last_vl != vl)
+			return -EINVAL;
+
+		last_vl = vl;
+	}
+
+	if (last_vl > 0) {
+		params->sve_vl = sve_vq_from_vl(last_vl) - 1;
+		params->flags |= RMI_REALM_PARAM_FLAG_SVE;
+	}
+	return 0;
+}
+
 /* Calculate the number of s2 root rtts needed */
 static int realm_num_root_rtts(struct realm *realm)
 {
@@ -644,6 +682,10 @@ static int realm_create_rd(struct kvm *kvm)
 		params->flags |= RMI_REALM_PARAM_FLAG_PMU;
 	}
 
+	r = realm_init_sve_param(kvm, params);
+	if (r)
+		goto out_undelegate_tables;
+
 	params_phys = virt_to_phys(params);
 
 	if (rmi_realm_create(rd_phys, params_phys)) {
-- 
2.43.0


