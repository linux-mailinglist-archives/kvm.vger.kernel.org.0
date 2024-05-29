Return-Path: <kvm+bounces-18317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CF518D3A0A
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 16:57:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F6F01C209CD
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 14:57:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AAEF181CEA;
	Wed, 29 May 2024 14:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R1mX91y8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441311802BC;
	Wed, 29 May 2024 14:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716994596; cv=none; b=id69xUtK5w/ie0C6/wQdtU8yG9rD9gK9BTJq3zet961JwL6nDzqOl5Zp/pjOnt3RGtPvVRq7WqaPYSKR9rHWdgxVBl1dnkdnzVfKCIMeXydKWYIrc3BhPhlQJb9FAmAx0w+mp4IAwFT9WA40rL3QT9BkaFmFIYqtYO1fbF/ETYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716994596; c=relaxed/simple;
	bh=hOrXGiyT5sKGEvm9DAf6C1dr+/SltK+NY+jfKPhrs0A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pT6liJGsrmdHWwgbm+0GWfg11Oro4XbmIoKjj9hsILAfxJofpt2Ne8Ur3TSfIkR64N1Qa7WmFhW5N0AmDuZFByRdP1tb3gmY1+sj72lUASwanwEn/+MkOJV5IBC74o1nsb2y+OuUdYULYE2M7SQ8JFUcQMjSZhNB0XH8pEoyAZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R1mX91y8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54B5C4AF07;
	Wed, 29 May 2024 14:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716994595;
	bh=hOrXGiyT5sKGEvm9DAf6C1dr+/SltK+NY+jfKPhrs0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R1mX91y86/Ic6nMGKuJYHkvt+J3OuIHlD+BEpld5+loJ5xyEuEANWLg6WH78Elp0t
	 M+xh1JAWiLnTySutYDnPscugNgafc9lkGuOG2YFIVZltE276avFPDXE0vgC1o5CouH
	 rC+3oQ3UsNQ3gLVTWMumB5z9JL+u9HRV/zCbLD1vi/yhR+w5VcWhwPw1TXdmkPPBie
	 WEmV7FoEmcADzzX/80op/zJmLG86lMnoOCw4p7ir7Gjob+qNHaOsqS4YYaokXsaxon
	 4zxPl9Wzl8pXH7dhya8o9Nx7uZAHEz+g8yt90I3NmZzysJlh3dYlX9UuW2gtHZ34ky
	 GmJnuYJtRkALw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sCKjC-00GekF-5z;
	Wed, 29 May 2024 15:56:34 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v2 11/16] KVM: arm64: nv: Handle FEAT_TTL hinted TLB operations
Date: Wed, 29 May 2024 15:56:23 +0100
Message-Id: <20240529145628.3272630-12-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240529145628.3272630-1-maz@kernel.org>
References: <20240529145628.3272630-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Support guest-provided information information to size the range of
required invalidation. This helps with reducing over-invalidation,
provided that the guest actually provides accurate information.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h |  2 +
 arch/arm64/kvm/nested.c             | 89 +++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c           | 24 +-------
 3 files changed, 92 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 9b7c92ab87cf..fcb0de3a93fe 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -124,6 +124,8 @@ extern void kvm_nested_s2_wp(struct kvm *kvm);
 extern void kvm_nested_s2_unmap(struct kvm *kvm);
 extern void kvm_nested_s2_flush(struct kvm *kvm);
 
+unsigned long compute_tlb_inval_range(struct kvm_s2_mmu *mmu, u64 val);
+
 static inline bool kvm_supported_tlbi_s1e1_op(struct kvm_vcpu *vpcu, u32 instr)
 {
 	struct kvm *kvm = vpcu->kvm;
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 82d2852845de..8570b5bd0289 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -365,6 +365,95 @@ int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
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
+		default:    /* IMPDEF: treat any other value as 64k */
+			/*
+			 * No, we do not support 52bit IPA in nested yet. Once
+			 * we do, this should be 4TB.
+			 */
+			max_size = SZ_512M;
+			break;
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
index 06963f1d206e..5bed362f80d3 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2865,34 +2865,12 @@ static void s2_mmu_unmap_ipa(struct kvm_s2_mmu *mmu,
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
-	default:	    /* IMPDEF: treat any other value as 64k */
-		/*
-		 * No, we do not support 52bit IPA in nested yet. Once
-		 * we do, this should be 4TB.
-		 */
-		max_size = SZ_512M;
-		break;
-	}
-
+	max_size = compute_tlb_inval_range(mmu, info->ipa.addr);
 	base_addr &= ~(max_size - 1);
 
 	kvm_stage2_unmap_range(mmu, base_addr, max_size);
-- 
2.39.2


