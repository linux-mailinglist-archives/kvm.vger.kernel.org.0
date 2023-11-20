Return-Path: <kvm+bounces-2106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A2D67F1418
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 14:14:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B6CB1C215D3
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 13:14:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8195721A12;
	Mon, 20 Nov 2023 13:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="leRIynKs"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2835520310;
	Mon, 20 Nov 2023 13:11:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4047C433C8;
	Mon, 20 Nov 2023 13:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700485860;
	bh=f2wnhl3iS5UjWwLnmUkNaAlpevGDuNY/t92e4wzTMrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=leRIynKs02vga32hLrfxV9KFM13y2IcEoDDpVZz7JBAejU4j/2rvFcgA3puYdwioY
	 nYAxr59mXRyiVXzxaNYYR9fsf5GERxVzHlXvEgS8B3fpJ+noG3R1Gn8XOhwOGYWfsJ
	 pH8HYr+lrX2qVUEH+grFYMBldLT/js+RSh4MjoSYPPNeUQIzbtEF712pu74bDTG1H3
	 eoPxLHGC/Hsp+Z5TbAQxmB+7krVIus6LHfZChvDtnUBhUBUefvJQJuRRPNlrMsFVHT
	 HPIGjR0xYLUafnIzCUtXKZ6QRVWAk1t+sDZwDZ39iF1uap/QCJHpLjENSyYVGwkgRN
	 gsPYjj7tYD43A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r543G-00EjnU-45;
	Mon, 20 Nov 2023 13:10:58 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Darren Hart <darren@os.amperecomputing.com>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Miguel Luis <miguel.luis@oracle.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v11 35/43] KVM: arm64: nv: Add handling of FEAT_TTL TLB invalidation
Date: Mon, 20 Nov 2023 13:10:19 +0000
Message-Id: <20231120131027.854038-36-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231120131027.854038-1-maz@kernel.org>
References: <20231120131027.854038-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Support guest-provided information information to find out about
the range of required invalidation.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h |  2 +
 arch/arm64/kvm/nested.c             | 90 +++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c           | 26 +--------
 3 files changed, 93 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 4f94aef8a750..b878577bc2ce 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -128,6 +128,8 @@ int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe);
 extern bool forward_smc_trap(struct kvm_vcpu *vcpu);
 extern bool __check_nv_sr_forward(struct kvm_vcpu *vcpu);
 
+unsigned long compute_tlb_inval_range(struct kvm_s2_mmu *mmu, u64 val);
+
 int kvm_init_nv_sysregs(struct kvm *kvm);
 
 #endif /* __ARM64_KVM_NESTED_H */
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index ad1df851997d..6f574602b7df 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -351,6 +351,96 @@ int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 	return ret;
 }
 
+static unsigned int ttl_to_size(u8 ttl)
+{
+	int level = ttl & 3;
+	int gran = (ttl >> 2) & 3;
+	unsigned int max_size = 0;
+
+	switch (gran) {
+	case TLBI_TTL_TG_4K:
+		switch (level) {
+		case 0:
+			break;
+		case 1:
+			max_size = SZ_1G;
+			break;
+		case 2:
+			max_size = SZ_2M;
+			break;
+		case 3:
+			max_size = SZ_4K;
+			break;
+		}
+		break;
+	case TLBI_TTL_TG_16K:
+		switch (level) {
+		case 0:
+		case 1:
+			break;
+		case 2:
+			max_size = SZ_32M;
+			break;
+		case 3:
+			max_size = SZ_16K;
+			break;
+		}
+		break;
+	case TLBI_TTL_TG_64K:
+		switch (level) {
+		case 0:
+		case 1:
+			/* No 52bit IPA support */
+			break;
+		case 2:
+			max_size = SZ_512M;
+			break;
+		case 3:
+			max_size = SZ_64K;
+			break;
+		}
+		break;
+	default:			/* No size information */
+		break;
+	}
+
+	return max_size;
+}
+
+unsigned long compute_tlb_inval_range(struct kvm_s2_mmu *mmu, u64 val)
+{
+	unsigned long max_size;
+	u8 ttl;
+
+	ttl = FIELD_GET(GENMASK_ULL(47, 44), val);
+
+	max_size = ttl_to_size(ttl);
+
+	if (!max_size) {
+		/* Compute the maximum extent of the invalidation */
+		switch (mmu->tlb_vtcr & VTCR_EL2_TG0_MASK) {
+		case VTCR_EL2_TG0_4K:
+			max_size = SZ_1G;
+			break;
+		case VTCR_EL2_TG0_16K:
+			max_size = SZ_32M;
+			break;
+		case VTCR_EL2_TG0_64K:
+			/*
+			 * No, we do not support 52bit IPA in nested yet. Once
+			 * we do, this should be 4TB.
+			 */
+			max_size = SZ_512M;
+			break;
+		default:
+			BUG();
+		}
+	}
+
+	WARN_ON(!max_size);
+	return max_size;
+}
+
 /*
  * We can have multiple *different* MMU contexts with the same VMID:
  *
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c9e55c7697d5..9a82f42b45ed 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3229,36 +3229,12 @@ static void s2_mmu_unmap_stage2_ipa(struct kvm_s2_mmu *mmu,
 	 *
 	 * - NS bit: we're non-secure only.
 	 *
-	 * - TTL field: We already have the granule size from the
-	 *   VTCR_EL2.TG0 field, and the level is only relevant to the
-	 *   guest's S2PT.
-	 *
 	 * - IPA[51:48]: We don't support 52bit IPA just yet...
 	 *
 	 * And of course, adjust the IPA to be on an actual address.
 	 */
 	base_addr = (info->ipa.addr & GENMASK_ULL(35, 0)) << 12;
-
-	/* Compute the maximum extent of the invalidation */
-	switch (mmu->tlb_vtcr & VTCR_EL2_TG0_MASK) {
-	case VTCR_EL2_TG0_4K:
-		max_size = SZ_1G;
-		break;
-	case VTCR_EL2_TG0_16K:
-		max_size = SZ_32M;
-		break;
-	case VTCR_EL2_TG0_64K:
-		/*
-		 * No, we do not support 52bit IPA in nested yet. Once
-		 * we do, this should be 4TB.
-		 */
-		/* FIXME: remove the 52bit PA support from the IDregs */
-		max_size = SZ_512M;
-		break;
-	default:
-		BUG();
-	}
-
+	max_size = compute_tlb_inval_range(mmu, info->ipa.addr);
 	base_addr &= ~(max_size - 1);
 
 	kvm_unmap_stage2_range(mmu, base_addr, max_size);
-- 
2.39.2


