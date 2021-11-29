Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37CD4621BD
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 21:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbhK2UMo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 15:12:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43010 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231811AbhK2UKn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 15:10:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4A49B815FE
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 20:07:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7E0C53FCF;
        Mon, 29 Nov 2021 20:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638216443;
        bh=cSLyIVV3jyyOi65ucV97mpaNj+BNKs5gCIo0BmVWpyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hb+2Jv7Bkg8+uKEWqwdveMtpGIrCoF43d9keDNo7xsBlSB8tVyr6qBv14xTcetbBs
         1M8UmCkA1fldyfkckM/ERmM29z711PPhQ4Qdaxm6XRIh2fBBpOjneEEZzjyfMj1lXr
         K3Tf2OMAluER5ifnhfT4k0WjnqSU15wT/3CMMi3qlzZJLkGPtWa4tmRakLut4V+Qed
         sXfkEOGaHEdbu5kJIIHfAkXragIV4zPjP/xcxGc+ksD2EFAHcSkq2AXuOtTXxF4C8o
         rVUiUl8Bo3/N/8Tz1ERI6qGj4hXpSWnOuoUaRfKeWpR13lVdAUjc5f5WxPZEdlHW0l
         qvoxXLfjkMH1g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mrmrF-008gvR-Qk; Mon, 29 Nov 2021 20:02:37 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v5 58/69] KVM: arm64: nv: Add handling of ARMv8.4-TTL TLB invalidation
Date:   Mon, 29 Nov 2021 20:01:39 +0000
Message-Id: <20211129200150.351436-59-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129200150.351436-1-maz@kernel.org>
References: <20211129200150.351436-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Support guest-provided information information to find out about
the range of required invalidation.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h |  1 +
 arch/arm64/kvm/nested.c             | 57 +++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c           | 78 ++++++++++++++++++-----------
 3 files changed, 108 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 5fa3c634c8e1..7c47ad655e2e 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -123,6 +123,7 @@ extern bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg,
 			    u64 control_bit);
 extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
 extern bool forward_nv_traps(struct kvm_vcpu *vcpu);
+unsigned int ttl_to_size(u8 ttl);
 
 struct sys_reg_params;
 struct sys_reg_desc;
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 198169648c3c..6f738b5f57dd 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -363,6 +363,63 @@ int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 	return ret;
 }
 
+
+unsigned int ttl_to_size(u8 ttl)
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
 /* Must be called with kvm->lock held */
 struct kvm_s2_mmu *lookup_s2_mmu(struct kvm *kvm, u64 vttbr, u64 hcr)
 {
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 55f3e94c24f1..e0f088de2cad 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2699,59 +2699,81 @@ static bool handle_vmalls12e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static unsigned long compute_tlb_inval_range(struct kvm_vcpu *vcpu,
+					     struct kvm_s2_mmu *mmu,
+					     u64 val)
+{
+	unsigned long max_size;
+	u8 ttl = 0;
+
+	if (cpus_have_const_cap(ARM64_HAS_ARMv8_4_TTL)) {
+		ttl = FIELD_GET(GENMASK_ULL(47, 44), val);
+	}
+
+	max_size = ttl_to_size(ttl);
+
+	if (!max_size) {
+		u64 vtcr = vcpu_read_sys_reg(vcpu, VTCR_EL2);
+
+		/* Compute the maximum extent of the invalidation */
+		switch ((vtcr & VTCR_EL2_TG0_MASK)) {
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
+			/* FIXME: remove the 52bit PA support from the IDregs */
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
 static bool handle_ipas2e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			     const struct sys_reg_desc *r)
 {
 	u64 vttbr = vcpu_read_sys_reg(vcpu, VTTBR_EL2);
-	u64 vtcr = vcpu_read_sys_reg(vcpu, VTCR_EL2);
 	struct kvm_s2_mmu *mmu;
 	u64 base_addr;
-	int max_size;
+	unsigned long max_size;
 
 	/*
 	 * We drop a number of things from the supplied value:
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
 	base_addr = (p->regval & GENMASK_ULL(35, 0)) << 12;
 
-	/* Compute the maximum extent of the invalidation */
-	switch ((vtcr & VTCR_EL2_TG0_MASK)) {
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
 	spin_lock(&vcpu->kvm->mmu_lock);
 
 	mmu = lookup_s2_mmu(vcpu->kvm, vttbr, HCR_VM);
-	if (mmu)
+	if (mmu) {
+		max_size = compute_tlb_inval_range(vcpu, mmu, p->regval);
+		base_addr &= ~(max_size - 1);
 		kvm_unmap_stage2_range(mmu, base_addr, max_size);
+	}
 
 	mmu = lookup_s2_mmu(vcpu->kvm, vttbr, 0);
-	if (mmu)
+	if (mmu) {
+		max_size = compute_tlb_inval_range(vcpu, mmu, p->regval);
+		base_addr &= ~(max_size - 1);
 		kvm_unmap_stage2_range(mmu, base_addr, max_size);
+	}
 
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
-- 
2.30.2

