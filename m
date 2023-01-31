Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5CC68296A
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 10:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbjAaJrz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 04:47:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231640AbjAaJri (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 04:47:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8574A4A217
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 01:47:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 893ED6147A
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 09:42:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4BFC433EF;
        Tue, 31 Jan 2023 09:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675158120;
        bh=3YAcWVZAjhAN6J7Oiw9EGD8rLRdIRPR56p+Gaauwfeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RUAkMiMZawI5Q9oBIP/XlYnIto2EIwe/8hWMUWUW7nUR2Q63PV1mqSyQoISxvSxQ2
         6iSaQ73xykoEeSXtJSpECKaW7xzs6V9f9Y3WJEE6J5aObUyT2n9PBuI7i3vkv6sFRi
         cc6pjNnDgbs+psexMQwxqok86U2ajJQTp6Qlt5mUL5vqJmNEd6UizdAs3HGZI3Vgid
         TAKHcyElpUbm8xCJKZB1RLRokouB4WPwtdr9WAlImSR0e+KZG5dew7MUlywMorUm+u
         t+Sho5fJEG/pl0K4TLYvJzy6GNeX6SBDaQjI5Kb408IpFp9/ogsWyzvKdxEN+aqjSi
         Xf9wV0B8Kcqow==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pMmtt-0067U2-RF;
        Tue, 31 Jan 2023 09:26:01 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v8 55/69] KVM: arm64: nv: Add handling of FEAT_TTL TLB invalidation
Date:   Tue, 31 Jan 2023 09:24:50 +0000
Message-Id: <20230131092504.2880505-56-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230131092504.2880505-1-maz@kernel.org>
References: <20230131092504.2880505-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Support guest-provided information information to find out about
the range of required invalidation.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h |  1 +
 arch/arm64/kvm/nested.c             | 56 +++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c           | 78 ++++++++++++++++++-----------
 3 files changed, 107 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 6e44a01403dc..c5b661517cb6 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -122,6 +122,7 @@ extern bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg,
 extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
 extern bool forward_nv_traps(struct kvm_vcpu *vcpu);
 extern bool forward_nv1_traps(struct kvm_vcpu *vcpu);
+unsigned int ttl_to_size(u8 ttl);
 
 struct sys_reg_params;
 struct sys_reg_desc;
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 981a4ff75da6..8b22984a3112 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -357,6 +357,62 @@ int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 	return ret;
 }
 
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
 /* Must be called with kvm->mmu_lock held */
 struct kvm_s2_mmu *lookup_s2_mmu(struct kvm *kvm, u64 vttbr, u64 hcr)
 {
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f02cc109a767..08acb1f8d551 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3002,14 +3002,54 @@ static bool handle_vmalls12e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
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
 
 	if (vcpu_has_nv(vcpu) && forward_nv_traps(vcpu))
 		return false;
@@ -3019,45 +3059,27 @@ static bool handle_ipas2e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
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
 	write_lock(&vcpu->kvm->mmu_lock);
 
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
 
 	write_unlock(&vcpu->kvm->mmu_lock);
 
-- 
2.34.1

