Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A45C36D8269
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 17:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239036AbjDEPrS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 11:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239002AbjDEPrQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 11:47:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4F67285
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 08:46:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 679D163F0B
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 15:46:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0AB2C433D2;
        Wed,  5 Apr 2023 15:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680709606;
        bh=o5cJBmfCEPFW7Sj2/hEQQSLCVBPoNNQnxjP0r7BKxYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QXJ631+Bsy2upXwXEAbmCTevLEqjfbGO550oHtopUl1HRXvY0pmvfQxQDL0Wclbsz
         t6rPNQTpVqQz/muBS8I23k/SumdNfXLBiAJuUY7txexlyzRc2+tFU2XpHP/Ur8wBIc
         APo8tKK5jBn0dB/kjUUiqLPcD+QWOdi+gzg5gb76LsxxVLcOpdd9t5xZWR09PpUx1e
         eR1C12KCxg2Oh8A9leFfFyB7GpkbomSiXPu+aBcR/efZiLYAIBCm3gJMCeDwnsc/qw
         HOHjscrkwpKyR7dmbN/JiYxHfnn4IqBtoT//pFe1t2Gr8AbbM21yVPadKPzNmeUTe4
         v9o00FLjrqX2A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pk5FZ-0062PV-9z;
        Wed, 05 Apr 2023 16:40:42 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
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
Subject: [PATCH v9 35/50] KVM: arm64: nv: Add handling of FEAT_TTL TLB invalidation
Date:   Wed,  5 Apr 2023 16:39:53 +0100
Message-Id: <20230405154008.3552854-36-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230405154008.3552854-1-maz@kernel.org>
References: <20230405154008.3552854-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
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
 arch/arm64/kvm/nested.c             | 90 +++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c           | 26 +--------
 3 files changed, 92 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index a65db37a44f7..9e5ffb68a5cd 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -129,6 +129,7 @@ extern bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg,
 extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
 extern bool forward_nv_traps(struct kvm_vcpu *vcpu);
 extern bool forward_nv1_traps(struct kvm_vcpu *vcpu);
+unsigned long compute_tlb_inval_range(struct kvm_s2_mmu *mmu, u64 val);
 
 struct sys_reg_params;
 struct sys_reg_desc;
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index d672157de574..b46d58d4542c 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -357,6 +357,96 @@ int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
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
+		switch (mmu->vtcr & VTCR_EL2_TG0_MASK) {
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
index 25dc3f2fb45c..6bd78b58894f 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3036,36 +3036,12 @@ static void s2_mmu_unmap_stage2_ipa(struct kvm_s2_mmu *mmu,
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
-	switch (mmu->vtcr & VTCR_EL2_TG0_MASK) {
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
2.34.1

