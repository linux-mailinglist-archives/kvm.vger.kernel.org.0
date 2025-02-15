Return-Path: <kvm+bounces-38282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 46151A36EEC
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 16:02:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D0411170E00
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2025 15:02:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E335F1DFD9C;
	Sat, 15 Feb 2025 15:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sx7P7KtB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C31E1A23BA;
	Sat, 15 Feb 2025 15:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739631723; cv=none; b=SjGEy6tkYmxFg3dUQhyedzcpXUnkK47BgVepvx3PXWv5LT+NP9AqDnAu8mJaaqVKaAa7m1L0SAfylOoz+egG1hIpYWJPmQIdg2MmYNDYQhFLBlUY5cFUo08gYt3GSQ3kK2aoznEjO+va4R5v2WHdLcZnr5t9bITZp2NlR1AiTHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739631723; c=relaxed/simple;
	bh=Y1SIsFFdePkSoXD6TczieH/KfTywTo1LZ9uTIrFQwyE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jWbxRbEfxZH3IBuuHmwwTbagH/BQ4XvwNzHO24Jc9gywFF6i8TFZ0ydfcYNwc/ZI4VYPCp1z1vdX4+CDu6zMOXswru/OA4P0lo8SQ/Mh/5oHfyvH2Ky1n4OMP3WSpIP3AGBW5nsT3saG6jUIaOAHiuliFpUkkoj5CUymLEKRP3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sx7P7KtB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B13C4CEE9;
	Sat, 15 Feb 2025 15:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739631722;
	bh=Y1SIsFFdePkSoXD6TczieH/KfTywTo1LZ9uTIrFQwyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sx7P7KtBEpcKE6PXeKVcn9ao21uVLiQ2Td5Q4UeqXNGJ5WLCSxDD1Z85s9mSN26Av
	 7wSDeLJbxLkTiTpcybnKomJbPPmh+86YqRCgc2WwF51Lu2KJWZGH2WikME553wXFXT
	 9LYzCsLwEEPLtS+Yq+bLv7oxI1KKJ8pIge37yiAfcSwvvf5+veilrgLi9/ezAehjnF
	 3PwhHM26WniCEkFkSjvJJhJvpvNzjBOePL0ef8BKMP4foQvH8FL/Q1NdrT4905aYlN
	 wEySYQil9K2/Ctjy7ymJG4S63vsVL0MbA041N2igpNledEuKA/e2ZuynZSu4c/+iba
	 072sSSica/tcA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tjJg8-004Nz6-Oc;
	Sat, 15 Feb 2025 15:02:00 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 03/14] KVM: arm64: nv: Extract translation helper from the AT code
Date: Sat, 15 Feb 2025 15:01:23 +0000
Message-Id: <20250215150134.3765791-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250215150134.3765791-1-maz@kernel.org>
References: <20250215150134.3765791-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The address translation infrastructure is currently pretty tied to
the AT emulation.

However, we also need to features that require the use of VAs, such
as VNCR_EL2 (and maybe one of these days SPE), meaning that we need
a slightly more generic infrastructure.

Start this by introducing a new helper (__kvm_translate_va()) that
performs a S1 walk for a given translation regime, EL and PAN
settings.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h | 54 ++++++++++++++++
 arch/arm64/kvm/at.c                 | 96 +++++++++++------------------
 2 files changed, 91 insertions(+), 59 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 56c4bcd35e2e5..43162f1dc4993 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -244,4 +244,58 @@ static inline unsigned int ps_to_output_size(unsigned int ps)
 	}
 }
 
+enum trans_regime {
+	TR_EL10,
+	TR_EL20,
+	TR_EL2,
+};
+
+struct s1_walk_info {
+	u64	     		baddr;
+	enum trans_regime	regime;
+	unsigned int		max_oa_bits;
+	unsigned int		pgshift;
+	unsigned int		txsz;
+	int 	     		sl;
+	bool			as_el0;
+	bool	     		hpd;
+	bool			e0poe;
+	bool			poe;
+	bool			pan;
+	bool	     		be;
+	bool	     		s2;
+};
+
+struct s1_walk_result {
+	union {
+		struct {
+			u64	desc;
+			u64	pa;
+			s8	level;
+			u8	APTable;
+			bool	UXNTable;
+			bool	PXNTable;
+			bool	uwxn;
+			bool	uov;
+			bool	ur;
+			bool	uw;
+			bool	ux;
+			bool	pwxn;
+			bool	pov;
+			bool	pr;
+			bool	pw;
+			bool	px;
+		};
+		struct {
+			u8	fst;
+			bool	ptw;
+			bool	s2;
+		};
+	};
+	bool	failed;
+};
+
+int __kvm_translate_va(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
+		       struct s1_walk_result *wr, u64 va);
+
 #endif /* __ARM64_KVM_NESTED_H */
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 3a96c96816e93..cded013587178 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -10,56 +10,6 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
-enum trans_regime {
-	TR_EL10,
-	TR_EL20,
-	TR_EL2,
-};
-
-struct s1_walk_info {
-	u64	     		baddr;
-	enum trans_regime	regime;
-	unsigned int		max_oa_bits;
-	unsigned int		pgshift;
-	unsigned int		txsz;
-	int 	     		sl;
-	bool	     		hpd;
-	bool			e0poe;
-	bool			poe;
-	bool			pan;
-	bool	     		be;
-	bool	     		s2;
-};
-
-struct s1_walk_result {
-	union {
-		struct {
-			u64	desc;
-			u64	pa;
-			s8	level;
-			u8	APTable;
-			bool	UXNTable;
-			bool	PXNTable;
-			bool	uwxn;
-			bool	uov;
-			bool	ur;
-			bool	uw;
-			bool	ux;
-			bool	pwxn;
-			bool	pov;
-			bool	pr;
-			bool	pw;
-			bool	px;
-		};
-		struct {
-			u8	fst;
-			bool	ptw;
-			bool	s2;
-		};
-	};
-	bool	failed;
-};
-
 static void fail_s1_walk(struct s1_walk_result *wr, u8 fst, bool ptw, bool s2)
 {
 	wr->fst		= fst;
@@ -145,20 +95,15 @@ static void compute_s1poe(struct kvm_vcpu *vcpu, struct s1_walk_info *wi)
 	}
 }
 
-static int setup_s1_walk(struct kvm_vcpu *vcpu, u32 op, struct s1_walk_info *wi,
+static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
 			 struct s1_walk_result *wr, u64 va)
 {
 	u64 hcr, sctlr, tcr, tg, ps, ia_bits, ttbr;
 	unsigned int stride, x;
-	bool va55, tbi, lva, as_el0;
+	bool va55, tbi, lva;
 
 	hcr = __vcpu_sys_reg(vcpu, HCR_EL2);
 
-	wi->regime = compute_translation_regime(vcpu, op);
-	as_el0 = (op == OP_AT_S1E0R || op == OP_AT_S1E0W);
-	wi->pan = (op == OP_AT_S1E1RP || op == OP_AT_S1E1WP) &&
-		  (*vcpu_cpsr(vcpu) & PSR_PAN_BIT);
-
 	va55 = va & BIT(55);
 
 	if (wi->regime == TR_EL2 && va55)
@@ -319,7 +264,7 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, u32 op, struct s1_walk_info *wi,
 
 	/* R_BNDVG and following statements */
 	if (kvm_has_feat(vcpu->kvm, ID_AA64MMFR2_EL1, E0PD, IMP) &&
-	    as_el0 && (tcr & (va55 ? TCR_E0PD1 : TCR_E0PD0)))
+	    wi->as_el0 && (tcr & (va55 ? TCR_E0PD1 : TCR_E0PD0)))
 		goto transfault_l0;
 
 	/* AArch64.S1StartLevel() */
@@ -1155,7 +1100,12 @@ static u64 handle_at_slow(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	bool perm_fail = false;
 	int ret, idx;
 
-	ret = setup_s1_walk(vcpu, op, &wi, &wr, vaddr);
+	wi.regime = compute_translation_regime(vcpu, op);
+	wi.as_el0 = (op == OP_AT_S1E0R || op == OP_AT_S1E0W);
+	wi.pan = (op == OP_AT_S1E1RP || op == OP_AT_S1E1WP) &&
+		 (*vcpu_cpsr(vcpu) & PSR_PAN_BIT);
+
+	ret = setup_s1_walk(vcpu, &wi, &wr, vaddr);
 	if (ret)
 		goto compute_par;
 
@@ -1444,3 +1394,31 @@ void __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	par = compute_par_s12(vcpu, par, &out);
 	vcpu_write_sys_reg(vcpu, par, PAR_EL1);
 }
+
+/*
+ * Translate a VA for a given EL in a given translation regime, with
+ * or without PAN. This requires wi->{regime, as_el0, pan} to be
+ * set. The rest of the wi and wr should be 0-initialised.
+ */
+int __kvm_translate_va(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
+		       struct s1_walk_result *wr, u64 va)
+{
+	int ret;
+
+	ret = setup_s1_walk(vcpu, wi, wr, va);
+	if (ret)
+		return ret;
+
+	if (wr->level == S1_MMU_DISABLED) {
+		wr->ur = wr->uw = wr->ux = true;
+		wr->pr = wr->pw = wr->px = true;
+	} else {
+		ret = walk_s1(vcpu, wi, wr, va);
+		if (ret)
+			return ret;
+
+		compute_s1_permissions(vcpu, wi, wr);
+	}
+
+	return 0;
+}
-- 
2.39.2


