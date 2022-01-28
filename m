Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF7F049F9EE
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 13:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348700AbiA1Mu0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 07:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348695AbiA1MuU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 07:50:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A44DC061749
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 04:50:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D05AE619CF
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 12:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 443C3C340E6;
        Fri, 28 Jan 2022 12:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643374219;
        bh=XnXYamFtn0pKGTplz+YFZgvmBJgBZToc3ZKsAOGe3MY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZTZjRUqgZ77vCMqvmXB6Bawu1jyYqOk5jazrzJiiTbEcFy+feGkywNVI7MjhVQMRv
         Sz8A8MXlEpDhxciZZNVQFCcNU/CR0Foz2OqGgRPKTObJnSiZyTAkuJZFI/jJ2VsSOZ
         9YsfDSfGGeKkziqNdclJAuB8u95OyC42QthgmScAy5zGiev1d35REf3j08JO6tx2I8
         BRkW7d8hZxnL41dxQJoMAFYH5anF3ogdv5HsszQo6sf+WZTXHGTotDDX19CT5JY+VB
         V97OzUagqaS82SKyntRRiMQW4suWxH8rnx+UiW2Hyn32FZ+7ySj9c0GdYUa8YtcN95
         JrSRpjEbow/gQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nDQEY-003njR-76; Fri, 28 Jan 2022 12:20:06 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Chase Conklin <chase.conklin@arm.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        karl.heubaum@oracle.com, mihai.carabas@oracle.com,
        miguel.luis@oracle.com, kernel-team@android.com
Subject: [PATCH v6 54/64] KVM: arm64: nv: Invalidate TLBs based on shadow S2 TTL-like information
Date:   Fri, 28 Jan 2022 12:19:02 +0000
Message-Id: <20220128121912.509006-55-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220128121912.509006-1-maz@kernel.org>
References: <20220128121912.509006-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, chase.conklin@arm.com, linux@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, karl.heubaum@oracle.com, mihai.carabas@oracle.com, miguel.luis@oracle.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to be able to make S2 TLB invalidations more performant on NV,
let's use a scheme derived from the ARMv8.4 TTL extension.

If bits [56:55] in the descriptor are non-zero, they indicate a level
which can be used as an invalidation range.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h |  4 ++
 arch/arm64/kvm/nested.c             | 98 +++++++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c           | 13 ++--
 3 files changed, 110 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 8bfbeca2f4cd..847b652bd376 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -128,6 +128,8 @@ extern bool __forward_traps(struct kvm_vcpu *vcpu, unsigned int reg,
 extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
 extern bool forward_nv_traps(struct kvm_vcpu *vcpu);
 extern bool forward_nv1_traps(struct kvm_vcpu *vcpu);
+u8 get_guest_mapping_ttl(struct kvm_vcpu *vcpu, struct kvm_s2_mmu *mmu,
+			 u64 addr);
 unsigned int ttl_to_size(u8 ttl);
 
 struct sys_reg_params;
@@ -136,4 +138,6 @@ struct sys_reg_desc;
 void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
 			  const struct sys_reg_desc *r);
 
+#define KVM_NV_GUEST_MAP_SZ	(KVM_PGTABLE_PROT_SW1 | KVM_PGTABLE_PROT_SW0)
+
 #endif /* __ARM64_KVM_NESTED_H */
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 7e4ff98c4e95..8e99690cdde1 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -4,6 +4,7 @@
  * Author: Jintack Lim <jintack.lim@linaro.org>
  */
 
+#include <linux/bitfield.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 
@@ -351,6 +352,29 @@ int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 	return ret;
 }
 
+static int read_host_s2_desc(phys_addr_t pa, u64 *desc, void *data)
+{
+	u64 *va = phys_to_virt(pa);
+
+	*desc = *va;
+
+	return 0;
+}
+
+static int kvm_walk_shadow_s2(struct kvm_s2_mmu *mmu, phys_addr_t gipa,
+			      struct kvm_s2_trans *result)
+{
+	struct s2_walk_info wi = { };
+
+	wi.read_desc = read_host_s2_desc;
+	wi.baddr = mmu->pgd_phys;
+
+	vtcr_to_walk_info(mmu->arch->vtcr, &wi);
+
+	wi.be = IS_ENABLED(CONFIG_CPU_BIG_ENDIAN);
+
+	return walk_nested_s2_pgd(gipa, &wi, result);
+}
 
 unsigned int ttl_to_size(u8 ttl)
 {
@@ -408,6 +432,80 @@ unsigned int ttl_to_size(u8 ttl)
 	return max_size;
 }
 
+/*
+ * Compute the equivalent of the TTL field by parsing the shadow PT.
+ * The granule size is extracted from VTCR_EL2.TG0 while the level is
+ * retrieved from first entry carrying the level as a tag.
+ */
+u8 get_guest_mapping_ttl(struct kvm_vcpu *vcpu, struct kvm_s2_mmu *mmu,
+			 u64 addr)
+{
+	u64 tmp, sz = 0, vtcr = vcpu_read_sys_reg(vcpu, VTCR_EL2);
+	struct kvm_s2_trans out;
+	u8 ttl, level;
+
+	switch (vtcr & VTCR_EL2_TG0_MASK) {
+	case VTCR_EL2_TG0_4K:
+		ttl = (1 << 2);
+		break;
+	case VTCR_EL2_TG0_16K:
+		ttl = (2 << 2);
+		break;
+	case VTCR_EL2_TG0_64K:
+		ttl = (3 << 2);
+		break;
+	default:
+		BUG();
+	}
+
+	tmp = addr;
+
+again:
+	/* Iteratively compute the block sizes for a particular granule size */
+	switch (vtcr & VTCR_EL2_TG0_MASK) {
+	case VTCR_EL2_TG0_4K:
+		if	(sz < SZ_4K)	sz = SZ_4K;
+		else if (sz < SZ_2M)	sz = SZ_2M;
+		else if (sz < SZ_1G)	sz = SZ_1G;
+		else			sz = 0;
+		break;
+	case VTCR_EL2_TG0_16K:
+		if	(sz < SZ_16K)	sz = SZ_16K;
+		else if (sz < SZ_32M)	sz = SZ_32M;
+		else			sz = 0;
+		break;
+	case VTCR_EL2_TG0_64K:
+		if	(sz < SZ_64K)	sz = SZ_64K;
+		else if (sz < SZ_512M)	sz = SZ_512M;
+		else			sz = 0;
+		break;
+	default:
+		BUG();
+	}
+
+	if (sz == 0)
+		return 0;
+
+	tmp &= ~(sz - 1);
+	out = (struct kvm_s2_trans) { };
+	kvm_walk_shadow_s2(mmu, tmp, &out);
+	level = FIELD_GET(KVM_NV_GUEST_MAP_SZ, out.upper_attr);
+	if (!level)
+		goto again;
+
+	ttl |= level;
+
+	/*
+	 * We now have found some level information in the shadow S2. Check
+	 * that the resulting range is actually including the original IPA.
+	 */
+	sz = ttl_to_size(ttl);
+	if (addr < (tmp + sz))
+		return ttl;
+
+	return 0;
+}
+
 /* Must be called with kvm->lock held */
 struct kvm_s2_mmu *lookup_s2_mmu(struct kvm *kvm, u64 vttbr, u64 hcr)
 {
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ebe6fad76b4b..32b8f4c1074a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2736,10 +2736,13 @@ static unsigned long compute_tlb_inval_range(struct kvm_vcpu *vcpu,
 					     u64 val)
 {
 	unsigned long max_size;
-	u8 ttl = 0;
+	u8 ttl;
 
-	if (cpus_have_const_cap(ARM64_HAS_ARMv8_4_TTL)) {
-		ttl = FIELD_GET(GENMASK_ULL(47, 44), val);
+	ttl = FIELD_GET(GENMASK_ULL(47, 44), val);
+
+	if (!(cpus_have_const_cap(ARM64_HAS_ARMv8_4_TTL) && ttl)) {
+		u64 addr = (val & GENMASK_ULL(35, 0)) << 12;
+		ttl = get_guest_mapping_ttl(vcpu, mmu, addr);
 	}
 
 	max_size = ttl_to_size(ttl);
@@ -2783,6 +2786,8 @@ static bool handle_ipas2e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (vcpu_has_nv(vcpu) && forward_nv_traps(vcpu))
 		return false;
 
+	spin_lock(&vcpu->kvm->mmu_lock);
+
 	/*
 	 * We drop a number of things from the supplied value:
 	 *
@@ -2794,8 +2799,6 @@ static bool handle_ipas2e1is(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	 */
 	base_addr = (p->regval & GENMASK_ULL(35, 0)) << 12;
 
-	spin_lock(&vcpu->kvm->mmu_lock);
-
 	mmu = lookup_s2_mmu(vcpu->kvm, vttbr, HCR_VM);
 	if (mmu) {
 		max_size = compute_tlb_inval_range(vcpu, mmu, p->regval);
-- 
2.30.2

