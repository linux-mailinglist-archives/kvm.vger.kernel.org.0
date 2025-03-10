Return-Path: <kvm+bounces-40634-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D77B4A59445
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 13:26:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 27F62188265C
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 12:26:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 151FF22AE7E;
	Mon, 10 Mar 2025 12:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xd4n0S6B"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECD722A7EB;
	Mon, 10 Mar 2025 12:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741609516; cv=none; b=h9HVWF7wI43SaA5vXjAjPGxtSoTysTR9LblymmYtZ9udW5w2dxPlytNhGvmpFY9pjnzhclUYZ0SeSukBuLGfpePtVy4s8fCpw3YQWVQR/kx6MOEkj12XRZ7Tx4LSZKl+82y+ojrrByzodKNsi7PtcXXBLIX66Yxxgf5B9WzmY24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741609516; c=relaxed/simple;
	bh=xp93Ax3ZY3cy/9jRe90kxjTcUJ7hVTFmw+yK2iZ3fJY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n5QbkfEd+8tZUZhQchycs4MzWYq2RfKPIwqDTDdE+Uc+W47lRhBPXvseJVsL5Uf1f1R16OMydA2maO9KQuhGzl0b8si2XKAI/9J5qL40gIZjKeItes4dUA9ZAPjMiQ0d1mQivSG8/InTqVLzGqKopI30OFKpSfWd/WrB9bCTd4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xd4n0S6B; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10443C4CEF3;
	Mon, 10 Mar 2025 12:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741609516;
	bh=xp93Ax3ZY3cy/9jRe90kxjTcUJ7hVTFmw+yK2iZ3fJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xd4n0S6Br/rRtAO6GbpR+OIRDQaNv0R4Ld/sANGbUX4cipcAxcwdnOb7Qo1DKlkd7
	 NH7uKc9Awlk6/ZTMh+mVu2AsBUtLrIO0QbWbnN72jYPRVC7nwHXH9/UrpNPr9uh3nd
	 FAXZBfnIi+slIs9c/V6gp9r2V8a5+C0cSqIXthn9p7wDjdeTRWrE0cQP5JkiboN4Db
	 5pO/7gvBaPgOEI6VFDhqFb5CDxwh4iApcW+v9wAvWglUrLY3I+BK0nd3ZcAqWUzRKD
	 mW8aCRUc+SPfYkSZ6dyqXpO1YtTlCJli0bqUJ2VYPAGwrjPWjp1fF6fH05vgxDYh51
	 4CmVfxxWJUcnQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1trcC2-00CAea-6x;
	Mon, 10 Mar 2025 12:25:14 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 16/23] KVM: arm64: Use KVM-specific HCRX_EL2 RES0 mask
Date: Mon, 10 Mar 2025 12:24:58 +0000
Message-Id: <20250310122505.2857610-17-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250310122505.2857610-1-maz@kernel.org>
References: <20250310122505.2857610-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

We do not have a computed table for HCRX_EL2, so statically define
the bits we know about. A warning will fire if the architecture
grows bits that are not handled yet.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h | 18 ++++++++++++++----
 arch/arm64/kvm/emulate-nested.c  |  5 +++++
 arch/arm64/kvm/nested.c          |  4 ++--
 3 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 5bdeea023f01f..66012bbb8032a 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -326,10 +326,20 @@
 #define HFGRTR_EL2_RES0		HFGxTR_EL2_RES0
 #define HFGWTR_EL2_RES0		(HFGRTR_EL2_RES0 | __HFGRTR_ONLY_MASK)
 
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
index 4f468759268c0..f6c7331c21ca4 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2149,6 +2149,7 @@ int __init populate_nv_trap_config(void)
 	BUILD_BUG_ON(__NR_CGT_GROUP_IDS__ > BIT(TC_CGT_BITS));
 	BUILD_BUG_ON(__NR_FGT_GROUP_IDS__ > BIT(TC_FGT_BITS));
 	BUILD_BUG_ON(__NR_FG_FILTER_IDS__ > BIT(TC_FGF_BITS));
+	BUILD_BUG_ON(__HCRX_EL2_MASK & __HCRX_EL2_nMASK);
 
 	for (int i = 0; i < ARRAY_SIZE(encoding_to_cgt); i++) {
 		const struct encoding_to_trap_config *cgt = &encoding_to_cgt[i];
@@ -2174,6 +2175,10 @@ int __init populate_nv_trap_config(void)
 		}
 	}
 
+	if (__HCRX_EL2_RES0 != HCRX_EL2_RES0)
+		kvm_info("Sanitised HCR_EL2_RES0 = %016llx, expecting %016llx\n",
+			 __HCRX_EL2_RES0, HCRX_EL2_RES0);
+
 	kvm_info("nv: %ld coarse grained trap handlers\n",
 		 ARRAY_SIZE(encoding_to_cgt));
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 63fe1595f318d..48b8a700de457 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1039,8 +1039,8 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
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


