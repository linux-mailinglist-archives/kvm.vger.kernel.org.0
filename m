Return-Path: <kvm+bounces-2107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0E6C7F1419
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 14:14:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1BBF1C2167B
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 13:14:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D302922330;
	Mon, 20 Nov 2023 13:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PqU15/iH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713802032D;
	Mon, 20 Nov 2023 13:11:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0ADC433C7;
	Mon, 20 Nov 2023 13:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700485860;
	bh=l/gtHG0HBFAaxZfPBD+BDAxDNa7v+3EQFQ+5hx9mbC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PqU15/iHcng7zj+211oG/ObNeVqiukz2D391w0u6XkUFyCr88pvG6No5HyuRe4wfP
	 bz2Rr/hhvtobsEHU0HBj054mSJVDw6yat82hE/CxxfxPdmTVLZdF9nTXCBi4xkKTcA
	 vp92OcZFyI1OMh0Kw92E6UO/oi+61ey07hjgTgruLmy4vm/Xe/tezSzaAhkC84RFag
	 /WCDASrybH0Vke8oRgV2cGj75Fm08BMyFu+7haVP24mpCbRMBVZODMxJGVMhRzqSpA
	 10eOmFuPsEFbyb0Amqn/G3U4GrvyT/qSU04u2dRHYLClTAajk2oIorJog25/H+QIr2
	 ZfOpadXg8NdOQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r543G-00EjnU-CZ;
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
Subject: [PATCH v11 36/43] KVM: arm64: nv: Invalidate TLBs based on shadow S2 TTL-like information
Date: Mon, 20 Nov 2023 13:10:20 +0000
Message-Id: <20231120131027.854038-37-maz@kernel.org>
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

In order to be able to make S2 TLB invalidations more performant on NV,
let's use a scheme derived from the ARMv8.4 TTL extension.

If bits [56:55] in the descriptor are non-zero, they indicate a level
which can be used as an invalidation range.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h |  2 +
 arch/arm64/kvm/nested.c             | 81 +++++++++++++++++++++++++++++
 2 files changed, 83 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index b878577bc2ce..128c1d8281af 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -132,4 +132,6 @@ unsigned long compute_tlb_inval_range(struct kvm_s2_mmu *mmu, u64 val);
 
 int kvm_init_nv_sysregs(struct kvm *kvm);
 
+#define KVM_NV_GUEST_MAP_SZ	(KVM_PGTABLE_PROT_SW1 | KVM_PGTABLE_PROT_SW0)
+
 #endif /* __ARM64_KVM_NESTED_H */
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 6f574602b7df..4a90ec0268e4 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -4,6 +4,7 @@
  * Author: Jintack Lim <jintack.lim@linaro.org>
  */
 
+#include <linux/bitfield.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 
@@ -407,6 +408,81 @@ static unsigned int ttl_to_size(u8 ttl)
 	return max_size;
 }
 
+/*
+ * Compute the equivalent of the TTL field by parsing the shadow PT.  The
+ * granule size is extracted from the cached VTCR_EL2.TG0 while the level is
+ * retrieved from first entry carrying the level as a tag.
+ */
+static u8 get_guest_mapping_ttl(struct kvm_s2_mmu *mmu, u64 addr)
+{
+	u64 tmp, sz = 0, vtcr = mmu->tlb_vtcr;
+	kvm_pte_t pte;
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
+	if (kvm_pgtable_get_leaf(mmu->pgt, tmp, &pte, NULL))
+		goto again;
+	if (!(pte & PTE_VALID))
+		goto again;
+	level = FIELD_GET(KVM_NV_GUEST_MAP_SZ, pte);
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
 unsigned long compute_tlb_inval_range(struct kvm_s2_mmu *mmu, u64 val)
 {
 	unsigned long max_size;
@@ -414,6 +490,11 @@ unsigned long compute_tlb_inval_range(struct kvm_s2_mmu *mmu, u64 val)
 
 	ttl = FIELD_GET(GENMASK_ULL(47, 44), val);
 
+	if (!(cpus_have_final_cap(ARM64_HAS_ARMv8_4_TTL) && ttl)) {
+		u64 addr = (val & GENMASK_ULL(35, 0)) << 12;
+		ttl = get_guest_mapping_ttl(mmu, addr);
+	}
+
 	max_size = ttl_to_size(ttl);
 
 	if (!max_size) {
-- 
2.39.2


