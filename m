Return-Path: <kvm+bounces-58866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 48C89BA36F8
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 13:04:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE6DE56132D
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 11:04:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D746D2F90EA;
	Fri, 26 Sep 2025 11:03:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3A532F8BF1;
	Fri, 26 Sep 2025 11:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758884610; cv=none; b=ZGDFq/QRcAwuMAJXsNxx9wzeHmTfRybLTatFwfxfrK7eFBrK/pkS54T2X+3BX/xJ9AATULuU7qIi6L3/3HvueMCbfmWPrNtZX00MtZx4Sv8PyV4QYyaUu0N6AYj+kRem/Tu3fJpujSWQBn+Y6RiwXLlyUJF7IfDUOKXQte1gyTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758884610; c=relaxed/simple;
	bh=NiM5bywEe+hqZEp48MCP0PMFIY9nEmXjNWVKXBI6nW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B2t83yIikSXvEBS3ERyayL1+35zs0Xe+WwcUuucdnxnPLZm1S1nkLTJoQjryFM7T1vCkCFn/gJJ5bcQOGtVgMERtrLnZkyYJ2EM0EDK0Jnc83JsgSXMU2E9VO2Hk5WPRJG0JQwfB0OiPinrdcbZ9v3jbCKHrjHJ6Q0IIGh30Uw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 35699168F;
	Fri, 26 Sep 2025 04:03:20 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.38.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D63AF3F66E;
	Fri, 26 Sep 2025 04:03:24 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
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
Subject: [RFC PATCH 5/5] arm64: RME: Support num_aux_places & rtt_tree_pp realm parameters
Date: Fri, 26 Sep 2025 12:02:54 +0100
Message-ID: <20250926110254.55449-6-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250926110254.55449-1-steven.price@arm.com>
References: <20250926110254.55449-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CCA planes provides new parameters to the VMM:
 - num_aux_planes defines the number of extra planes
 - rtt_tree_pp controls whether each plane has it's own page table tree,
   of if they share one tree.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/uapi/asm/kvm.h | 12 +++++
 arch/arm64/kvm/rme.c              | 77 +++++++++++++++++++++++++++++--
 2 files changed, 86 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 9b5d67ecbc5e..1d83da0f3aaa 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -440,6 +440,8 @@ enum {
 /* List of configuration items accepted for KVM_CAP_ARM_RME_CONFIG_REALM */
 #define ARM_RME_CONFIG_RPV			0
 #define ARM_RME_CONFIG_HASH_ALGO		1
+#define ARM_RME_CONFIG_NUM_AUX_PLANES		2
+#define ARM_RME_CONFIG_RTT_TREE_PP		3
 
 #define ARM_RME_CONFIG_HASH_ALGO_SHA256		0
 #define ARM_RME_CONFIG_HASH_ALGO_SHA512		1
@@ -459,6 +461,16 @@ struct arm_rme_config {
 			__u32	hash_algo;
 		};
 
+		/* cfg == ARM_RME_CONFIG_NUM_AUX_PLANES */
+		struct {
+			__u32	num_aux_planes;
+		};
+
+		/* cfg == ARM_RME_CONFIG_RTT_TREE_PP */
+		struct {
+			__u32	rtt_tree_pp;
+		};
+
 		/* Fix the size of the union */
 		__u8	reserved[256];
 	};
diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
index 6cb938957510..fca305da1843 100644
--- a/arch/arm64/kvm/rme.c
+++ b/arch/arm64/kvm/rme.c
@@ -43,6 +43,28 @@ bool kvm_rme_supports_sve(void)
 	return rme_has_feature(RMI_FEATURE_REGISTER_0_SVE_EN);
 }
 
+static bool kvm_rme_supports_rtt_tree_single(void)
+{
+	int i = u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_RTT_PLANE);
+
+	switch (i) {
+	case RMI_RTT_PLANE_AUX:
+		return false;
+	case RMI_RTT_PLANE_AUX_SINGLE:
+	case RMI_RTT_PLANE_SINGLE:
+		return true;
+	default:
+		WARN(1, "Unknown encoding for RMI_FEATURE_REGISTER_0_RTT_PLANE: %#x", i);
+	}
+	return false;
+}
+
+static unsigned int rme_get_max_num_aux_planes(void)
+{
+	return u64_get_bits(rmm_feat_reg0,
+			    RMI_FEATURE_REGISTER_0_MAX_NUM_AUX_PLANES);
+}
+
 static int rmi_check_version(void)
 {
 	struct arm_smccc_res res;
@@ -1077,6 +1099,14 @@ int realm_map_protected(struct realm *realm,
 	return -ENXIO;
 }
 
+static unsigned long pi_index_to_s2tte(unsigned long idx)
+{
+	return FIELD_PREP(BIT(PTE_PI_IDX_0), (idx >> 0) & 1) |
+	       FIELD_PREP(BIT(PTE_PI_IDX_1), (idx >> 1) & 1) |
+	       FIELD_PREP(BIT(PTE_PI_IDX_2), (idx >> 2) & 1) |
+	       FIELD_PREP(BIT(PTE_PI_IDX_3), (idx >> 3) & 1);
+}
+
 int realm_map_non_secure(struct realm *realm,
 			 unsigned long ipa,
 			 kvm_pfn_t pfn,
@@ -1101,9 +1131,17 @@ int realm_map_non_secure(struct realm *realm,
 		 * so for now we permit both read and write.
 		 */
 		unsigned long desc = phys |
-				     PTE_S2_MEMATTR(MT_S2_FWB_NORMAL) |
-				     KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R |
-				     KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
+				     PTE_S2_MEMATTR(MT_S2_FWB_NORMAL);
+		/*
+		 * FIXME: Read+Write permissions for now, and no support yet
+		 * for setting RMI_REALM_PARAM_FLAG1_RTT_S2AP_ENCODING
+		 */
+		if (1)
+			desc |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R |
+				KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
+		else
+			desc |= pi_index_to_s2tte(RMI_BASE_PERM_RW_INDEX);
+
 		ret = rmi_rtt_map_unprotected(rd, ipa, map_level, desc);
 
 		if (RMI_RETURN_STATUS(ret) == RMI_ERROR_RTT) {
@@ -1653,6 +1691,33 @@ static int config_realm_hash_algo(struct realm *realm,
 	return 0;
 }
 
+static int config_num_aux_planes(struct realm *realm,
+				 struct arm_rme_config *cfg)
+{
+	if (cfg->num_aux_planes > rme_get_max_num_aux_planes())
+		return -EINVAL;
+
+	realm->num_aux_planes = cfg->num_aux_planes;
+	realm->params->num_aux_planes = cfg->num_aux_planes;
+
+	return 0;
+}
+
+static int config_rtt_tree_pp(struct realm *realm,
+			      struct arm_rme_config *cfg)
+{
+	if (!kvm_rme_supports_rtt_tree_single() && !cfg->rtt_tree_pp)
+		return -EINVAL;
+
+	realm->rtt_tree_pp = !!cfg->rtt_tree_pp;
+	if (realm->rtt_tree_pp)
+		realm->params->flags1 |= RMI_REALM_PARAM_FLAG1_RTT_TREE_PP;
+	else
+		realm->params->flags1 &= ~RMI_REALM_PARAM_FLAG1_RTT_TREE_PP;
+
+	return 0;
+}
+
 static int kvm_rme_config_realm(struct kvm *kvm, struct kvm_enable_cap *cap)
 {
 	struct arm_rme_config cfg;
@@ -1672,6 +1737,12 @@ static int kvm_rme_config_realm(struct kvm *kvm, struct kvm_enable_cap *cap)
 	case ARM_RME_CONFIG_HASH_ALGO:
 		r = config_realm_hash_algo(realm, &cfg);
 		break;
+	case ARM_RME_CONFIG_NUM_AUX_PLANES:
+		r = config_num_aux_planes(realm, &cfg);
+		break;
+	case ARM_RME_CONFIG_RTT_TREE_PP:
+		r = config_rtt_tree_pp(realm, &cfg);
+		break;
 	default:
 		r = -EINVAL;
 	}
-- 
2.43.0


