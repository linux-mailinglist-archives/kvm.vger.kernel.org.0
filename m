Return-Path: <kvm+bounces-45641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B1B4AACB60
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 18:47:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 39B194E2C42
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:46:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82746288509;
	Tue,  6 May 2025 16:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZGoUmdes"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79A52882AE;
	Tue,  6 May 2025 16:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746549854; cv=none; b=M6WIZ+WoZHrYbVvun2qAZQDlDoK58KyNo34bncodJZRMMa7iyaCVu03VtQ5ncqBqSOgpocWLjGdJVQGNr+RhCFvjNOPZ/e6FnTR0/voMmh0co0ZTKENLxJ6Ei/AbavBVtHPUpM8LAnr5Cg1rnrL+yXZaIQBDAN1ti5QEToicGfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746549854; c=relaxed/simple;
	bh=6uAlKiHTvc9TSiNne1XoUzLhn9bnKM2FX7gNzgC18gs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AlD6GRyiIlxbUr86Kwy/n7ni7SdrICurH/kwgizfh2HRaamhdP6ACCEOfnw8AmlR1Gcxbs5tIhLpXmtQeIFe8dCZkPqOG5M4rVRzIaXIOdKI+fhyIJ9VNoo58bVca074t4pttSTTzJJEAx7T+d1KNPm7BPKbZlVAgJL7vsQUpzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZGoUmdes; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88CB6C4CEEF;
	Tue,  6 May 2025 16:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746549854;
	bh=6uAlKiHTvc9TSiNne1XoUzLhn9bnKM2FX7gNzgC18gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZGoUmdesQeQ+ydtoPZcYJbHAYRBC5LulZsBIEWlW37FqtksajtVHJbqv42d4hrPqY
	 k9ZqrZiVA1bKFq6/ecUWtEm8IxVpcV22JQE9A7GvqBnrYStADYLapuE+UZgL+0Vh24
	 c/xUQyDehao5g7yDlFb7VDPI+1aFFMhfipIIZbf/2Z8dEB273XgZsiMHh0ZdlytYBO
	 UasdscDMnoWnV+Ph6SskhWTAtr50ElDTuivmNdRo3oO4jJ73YJlkUxmfriQOrC+k4B
	 utp7xzu6RNgxXmzz5VNB1TQAcfr/NLjaZTNIh3w8n5rvhGMfr5vBs/E/MYpCPAYQ6L
	 0WgYDk5hKLlVw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uCLOu-00CJkN-Q7;
	Tue, 06 May 2025 17:44:12 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ben Horgan <ben.horgan@arm.com>
Subject: [PATCH v4 29/43] KVM: arm64: Use KVM-specific HCRX_EL2 RES0 mask
Date: Tue,  6 May 2025 17:43:34 +0100
Message-Id: <20250506164348.346001-30-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250506164348.346001-1-maz@kernel.org>
References: <20250506164348.346001-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com, ben.horgan@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We do not have a computed table for HCRX_EL2, so statically define
the bits we know about. A warning will fire if the architecture
grows bits that are not handled yet.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h | 18 ++++++++++++++----
 arch/arm64/kvm/emulate-nested.c  |  5 +++++
 arch/arm64/kvm/nested.c          |  4 ++--
 3 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index e7c73d16cd451..52b3aeb19efc6 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -315,10 +315,20 @@
 				 GENMASK(19, 18) |	\
 				 GENMASK(15, 0))
 
-/* Polarity masks for HCRX_EL2 */
-#define __HCRX_EL2_RES0         HCRX_EL2_RES0
-#define __HCRX_EL2_MASK		(BIT(6))
-#define __HCRX_EL2_nMASK	~(__HCRX_EL2_RES0 | __HCRX_EL2_MASK)
+/*
+ * Polarity masks for HCRX_EL2, limited to the bits that we know about
+ * at this point in time. It doesn't mean that we actually *handle*
+ * them, but that at least those that are not advertised to a guest
+ * will be RES0 for that guest.
+ */
+#define __HCRX_EL2_MASK		(BIT_ULL(6))
+#define __HCRX_EL2_nMASK	(GENMASK_ULL(24, 14) | \
+				 GENMASK_ULL(11, 7)  | \
+				 GENMASK_ULL(5, 0))
+#define __HCRX_EL2_RES0		~(__HCRX_EL2_nMASK | __HCRX_EL2_MASK)
+#define __HCRX_EL2_RES1		~(__HCRX_EL2_nMASK | \
+				  __HCRX_EL2_MASK  | \
+				  __HCRX_EL2_RES0)
 
 /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
 #define HPFAR_MASK	(~UL(0xf))
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index c30d970bf81cb..c581cf29bc59e 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2157,6 +2157,7 @@ int __init populate_nv_trap_config(void)
 	BUILD_BUG_ON(__NR_CGT_GROUP_IDS__ > BIT(TC_CGT_BITS));
 	BUILD_BUG_ON(__NR_FGT_GROUP_IDS__ > BIT(TC_FGT_BITS));
 	BUILD_BUG_ON(__NR_FG_FILTER_IDS__ > BIT(TC_FGF_BITS));
+	BUILD_BUG_ON(__HCRX_EL2_MASK & __HCRX_EL2_nMASK);
 
 	for (int i = 0; i < ARRAY_SIZE(encoding_to_cgt); i++) {
 		const struct encoding_to_trap_config *cgt = &encoding_to_cgt[i];
@@ -2182,6 +2183,10 @@ int __init populate_nv_trap_config(void)
 		}
 	}
 
+	if (__HCRX_EL2_RES0 != HCRX_EL2_RES0)
+		kvm_info("Sanitised HCR_EL2_RES0 = %016llx, expecting %016llx\n",
+			 __HCRX_EL2_RES0, HCRX_EL2_RES0);
+
 	kvm_info("nv: %ld coarse grained trap handlers\n",
 		 ARRAY_SIZE(encoding_to_cgt));
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 479ffd25eea63..666df85230c9b 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1058,8 +1058,8 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 	set_sysreg_masks(kvm, HCR_EL2, res0, res1);
 
 	/* HCRX_EL2 */
-	res0 = HCRX_EL2_RES0;
-	res1 = HCRX_EL2_RES1;
+	res0 = __HCRX_EL2_RES0;
+	res1 = __HCRX_EL2_RES1;
 	if (!kvm_has_feat(kvm, ID_AA64ISAR3_EL1, PACM, TRIVIAL_IMP))
 		res0 |= HCRX_EL2_PACMEn;
 	if (!kvm_has_feat(kvm, ID_AA64PFR2_EL1, FPMR, IMP))
-- 
2.39.2


