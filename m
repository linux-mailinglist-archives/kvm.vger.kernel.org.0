Return-Path: <kvm+bounces-29551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 096009ACDFB
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:04:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BEE26284282
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:04:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79008209F2E;
	Wed, 23 Oct 2024 14:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dwzu1iiO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90406201273;
	Wed, 23 Oct 2024 14:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695237; cv=none; b=Tl59+OQ7RoCf3Kefvo8oxY4kPrjdDB16C0emGiVQ9865fPhxNxxpDDHkuDfg9hllqEN2SXjZ0VU5Iw7DJ7qXVupxK19NPmu7Z1zz4nhpII7Yri1cvXP+5ELF07Stm7BiygzAwyxH0dMt9iIZP5zcXX3eduWd4gdJwUKALNo0q3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695237; c=relaxed/simple;
	bh=DU3dgMf4tNeWjgG0Nf5jlTQ88fuhiFgtrah3HTYYgiY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=S/tTpe6kyGatHiUNZo2Jl+sUFvRtsYhKYVNgzQxDgojFPRgGXbEHNlXF7Ryg2ncWnZ1lNoi89O+BkSmzduvafvocH2wxEKkcQi7hNLnUBud2vkBMPqW4mAfZ3Mwa3nEEQ+2bJ7pBRyFmvWBpIPOFpCavGLuDPichBPT4SUDPTtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dwzu1iiO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7369CC4CEE6;
	Wed, 23 Oct 2024 14:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729695237;
	bh=DU3dgMf4tNeWjgG0Nf5jlTQ88fuhiFgtrah3HTYYgiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dwzu1iiO0ANew1vizSSs9G3Ijh6Qos4m5/AdEqkvpl5CTxjaT0KF/s+27obe0BIos
	 cgeC08BrktDqn8HPwFPbZWrJq8SuFdRoqOfzbAJfdvfy/6UusOhk2IAqJr07OeDWCQ
	 c9095/8BxJ8C/UBJU/qBIHzKVag7aL9BKOVoTpJTSrITUSAkrcf19elsjQQmUvp5JD
	 UBJUzGMt9MKpZHyYBxAT5MYDq7HTJKEeODBMdMo6Pc8IZPW9pXrC5uErftFosUoo8i
	 JZGytgHCE5xnvFxpZLAINDvmh5klkpNOx1KyMl/lYtz6BItVftwTYTNmFSEax3JEQq
	 SMq/NJBBQMj7Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t3ckF-0068vz-O3;
	Wed, 23 Oct 2024 15:53:55 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v5 30/37] KVM: arm64: Add kvm_has_s1poe() helper
Date: Wed, 23 Oct 2024 15:53:38 +0100
Message-Id: <20241023145345.1613824-31-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241023145345.1613824-1-maz@kernel.org>
References: <20241023145345.1613824-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, alexandru.elisei@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Just like we have kvm_has_s1pie(), add its S1POE counterpart,
making the code slightly more readable.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h          | 3 +++
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 2 +-
 arch/arm64/kvm/nested.c                    | 4 ++--
 arch/arm64/kvm/sys_regs.c                  | 4 ++--
 4 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9a6997827ad49..3c435e88d74b8 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1517,4 +1517,7 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
 #define kvm_has_s1pie(k)				\
 	(kvm_has_feat((k), ID_AA64MMFR3_EL1, S1PIE, IMP))
 
+#define kvm_has_s1poe(k)				\
+	(kvm_has_feat((k), ID_AA64MMFR3_EL1, S1POE, IMP))
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index a306ea70502c4..a651c43ad679f 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -80,7 +80,7 @@ static inline bool ctxt_has_s1poe(struct kvm_cpu_context *ctxt)
 		return false;
 
 	vcpu = ctxt_to_vcpu(ctxt);
-	return kvm_has_feat(kern_hyp_va(vcpu->kvm), ID_AA64MMFR3_EL1, S1POE, IMP);
+	return kvm_has_s1poe(kern_hyp_va(vcpu->kvm));
 }
 
 static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 47be71279c304..ff047a84d15dc 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1082,7 +1082,7 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
 		res0 |= HFGxTR_EL2_nRCWMASK_EL1;
 	if (!kvm_has_s1pie(kvm))
 		res0 |= (HFGxTR_EL2_nPIRE0_EL1 | HFGxTR_EL2_nPIR_EL1);
-	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S1POE, IMP))
+	if (!kvm_has_s1poe(kvm))
 		res0 |= (HFGxTR_EL2_nPOR_EL0 | HFGxTR_EL2_nPOR_EL1);
 	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S2POE, IMP))
 		res0 |= HFGxTR_EL2_nS2POR_EL1;
@@ -1192,7 +1192,7 @@ int kvm_init_nv_sysregs(struct kvm *kvm)
 		res0 |= TCR2_EL2_PTTWI | TCR2_EL2_PnCH;
 	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, AIE, IMP))
 		res0 |= TCR2_EL2_AIE;
-	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S1POE, IMP))
+	if (!kvm_has_s1poe(kvm))
 		res0 |= TCR2_EL2_POE | TCR2_EL2_E0POE;
 	if (!kvm_has_s1pie(kvm))
 		res0 |= TCR2_EL2_PIE;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 6c20de8607b2d..c89a165408498 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2316,7 +2316,7 @@ static bool access_zcr_el2(struct kvm_vcpu *vcpu,
 static unsigned int s1poe_visibility(const struct kvm_vcpu *vcpu,
 				     const struct sys_reg_desc *rd)
 {
-	if (kvm_has_feat(vcpu->kvm, ID_AA64MMFR3_EL1, S1POE, IMP))
+	if (kvm_has_s1poe(vcpu->kvm))
 		return 0;
 
 	return REG_HIDDEN;
@@ -4802,7 +4802,7 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 		kvm->arch.fgu[HFGxTR_GROUP] |= (HFGxTR_EL2_nPIRE0_EL1 |
 						HFGxTR_EL2_nPIR_EL1);
 
-	if (!kvm_has_feat(kvm, ID_AA64MMFR3_EL1, S1POE, IMP))
+	if (!kvm_has_s1poe(kvm))
 		kvm->arch.fgu[HFGxTR_GROUP] |= (HFGxTR_EL2_nPOR_EL1 |
 						HFGxTR_EL2_nPOR_EL0);
 
-- 
2.39.2


