Return-Path: <kvm+bounces-14022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E0F5489E1F2
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 19:56:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 974DE1F21D44
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 17:56:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03D1F157495;
	Tue,  9 Apr 2024 17:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hc6ZQhOc"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A37E156876;
	Tue,  9 Apr 2024 17:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712685324; cv=none; b=lcUHGm2zk2u9e9nn8Ju36Nv+gR2FPIzHaOMvs0QXqpxm/lGoVNPy418RusXKWNgDtmMbw+wltTdQ88PEm/o1h9YabeiqsjhnFeFAoPfu2JER3xfG5mBT0YuzDVM3RNOrFKmeJdsd8K811Bj6I6PU/oDRWtPQz7sKUmx7/IM74eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712685324; c=relaxed/simple;
	bh=fQYYTTBSKdRqPAgOa4SWQZm1+liJ9v/ZGYrOEIE0iqo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nITOhe3M/VU8tgU5HMaym9ropsruIbz2Whu9U5BgnupPux7ZGAhRfs0/cU2P04xZEKiQEWWpRjUk7l38AcCHuoZtcLXa1Lsckmk5/MesCInyoRfTjPQixu2WGWB4j4iX8J5a6z2+uqRLBf8UrW4ot5KIXEYb/uHaMph2uD0b97c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hc6ZQhOc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BAA0C433C7;
	Tue,  9 Apr 2024 17:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712685324;
	bh=fQYYTTBSKdRqPAgOa4SWQZm1+liJ9v/ZGYrOEIE0iqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hc6ZQhOc4wF4j2MuG3XdNsESnkaKIQwiASLrIJ/8iuXnxk6MQaCfWDms6zFK71W7L
	 rtaDaDE2ABhYJA5WjMdl6Y9TbJm72q3iuRLXRxdt9XMd65FRaC2mtS+I743geusqm0
	 x69Ju3Ht7qLmfCY2CfNKZRrTp6CgTszltyign2tZQXmI0oo7mECevZX4cnkruBiZHM
	 +9QN3S6ekbO1+orfOTlM+H1hI8ERQfpS/LA0inbnf50UQXIudGi8yEZeD11yj+q88E
	 Vvqopwxip47luiwPDj/K5DE+CuPI+EOQRtBCdq8Hnm+sR2TewOPfcibyy9ixxVWnuB
	 sI5GBh4hTk+3Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ruFgo-002szC-C5;
	Tue, 09 Apr 2024 18:55:22 +0100
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
	Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH 13/16] KVM: arm64: nv: Invalidate TLBs based on shadow S2 TTL-like information
Date: Tue,  9 Apr 2024 18:54:45 +0100
Message-Id: <20240409175448.3507472-14-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240409175448.3507472-1-maz@kernel.org>
References: <20240409175448.3507472-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, christoffer.dall@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

In order to be able to make S2 TLB invalidations more performant on NV,
let's use a scheme derived from the FEAT_TTL extension.

If bits [56:55] in the leaf descriptor translating the address in the
corresponding shadow S2 are non-zero, they indicate a level which can
be used as an invalidation range. This allows further reduction of the
systematic over-invalidation that takes place otherwise.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/nested.c | 83 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 82 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 5abdf82bb9a4..8163f7308b82 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -4,6 +4,7 @@
  * Author: Jintack Lim <jintack.lim@linaro.org>
  */
 
+#include <linux/bitfield.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 
@@ -405,12 +406,92 @@ static unsigned int ttl_to_size(u8 ttl)
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
+		ttl = (TLBI_TTL_TG_4K << 2);
+		break;
+	case VTCR_EL2_TG0_16K:
+		ttl = (TLBI_TTL_TG_16K << 2);
+		break;
+	case VTCR_EL2_TG0_64K:
+	default:	    /* IMPDEF: treat any other value as 64k */
+		ttl = (TLBI_TTL_TG_64K << 2);
+		break;
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
+	default:	    /* IMPDEF: treat any other value as 64k */
+		if	(sz < SZ_64K)	sz = SZ_64K;
+		else if (sz < SZ_512M)	sz = SZ_512M;
+		else			sz = 0;
+		break;
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
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
 	unsigned long max_size;
 	u8 ttl;
 
-	ttl = FIELD_GET(GENMASK_ULL(47, 44), val);
+	ttl = FIELD_GET(TLBI_TTL_MASK, val);
+
+	if (!ttl || !kvm_has_feat(kvm, ID_AA64MMFR2_EL1, TTL, IMP)) {
+		/* No TTL, check the shadow S2 for a hint */
+		u64 addr = (val & GENMASK_ULL(35, 0)) << 12;
+		ttl = get_guest_mapping_ttl(mmu, addr);
+	}
 
 	max_size = ttl_to_size(ttl);
 
-- 
2.39.2


