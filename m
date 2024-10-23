Return-Path: <kvm+bounces-29545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 86FBC9ACDF4
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 17:03:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17AC61F23236
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:03:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12A51206E89;
	Wed, 23 Oct 2024 14:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CB3D9WZw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BBA204089;
	Wed, 23 Oct 2024 14:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729695236; cv=none; b=QBXcoOVhJx2Eko7PrtsMiitsHYrZY7KZ1Ro8cQLB/+HelTesH3BN9BKX8d4GX7+Ignsi04DxANoOnm7DGwFI3uqrUFb8iLYZyDgDg/OVSsmhU4i805i6ttiADI+KT8cgLp+spSgPkfxW6YRvlfWv+V3hxwFFtDd8BBmVUAxoL5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729695236; c=relaxed/simple;
	bh=LYdBETnn2M88/sr9XD6Wu4WwdOew9iodz0Dr8K47paA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tuxFsxkyQkHobMdHrZcL54QmJHB+N9/Erd+Qm+jHp5OOZomjAeR3r1ffeaJYEnWioqaU9X46o4ZCaY1H2qul1we8rE62D5Caprv6DdQSXuyUj5GmX2xDFYXcWW9XUOJ66LV8Np2+tryPUVjq2p4+S/scdSTyViVN4NGrdpekNYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CB3D9WZw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96600C4CECD;
	Wed, 23 Oct 2024 14:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729695235;
	bh=LYdBETnn2M88/sr9XD6Wu4WwdOew9iodz0Dr8K47paA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CB3D9WZwyVqUkgAk6CJ0EmYhuneyYy+AN+Rm4VE3DukctgyrCmv4P4k2wErFNzI7P
	 9BGIz96t3aFMmU8aSNsxNN+8pMrPONEeNR/WP/MPP9mnOjQ4cNNug3yHIFLaDKX4yj
	 R3O3pSEbkRVoIDYr5dkaJrt80GoR/oqD/nuEw4qd/EOS2DIGnj7PdtljFLuQothzid
	 7/9/rIr+z3B4DohK0aQENLBGS2lMWx0HmuNpRFwS3oXXnTXtWnTaAj2YrEHW0f2iYb
	 M+ux05CnhqZOQAKiLrD9IQjBLEAL7WXr5N9H7JxixX/S+4+S7EZvpS1ZK8aXB8dUBq
	 EcP2q6K/a5LDw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1t3ckD-0068vz-RV;
	Wed, 23 Oct 2024 15:53:53 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v5 21/37] KVM: arm64: Implement AT S1PIE support
Date: Wed, 23 Oct 2024 15:53:29 +0100
Message-Id: <20241023145345.1613824-22-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241023145345.1613824-1-maz@kernel.org>
References: <20241023145345.1613824-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, alexandru.elisei@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

It doesn't take much effort to implement S1PIE support in AT.

It is only a matter of using the AArch64.S1IndirectBasePermissions()
encodings for the permission, ignoring GCS which has no impact on AT,
and enforce FEAT_PAN3 being enabled as this is a requirement of
FEAT_S1PIE.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/at.c | 117 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 116 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index f5bd750288ff5..3d93ed1795603 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -781,6 +781,9 @@ static bool pan3_enabled(struct kvm_vcpu *vcpu, enum trans_regime regime)
 	if (!kvm_has_feat(vcpu->kvm, ID_AA64MMFR1_EL1, PAN, PAN3))
 		return false;
 
+	if (s1pie_enabled(vcpu, regime))
+		return true;
+
 	if (regime == TR_EL10)
 		sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
 	else
@@ -862,11 +865,123 @@ static void compute_s1_hierarchical_permissions(struct kvm_vcpu *vcpu,
 	}
 }
 
+#define perm_idx(v, r, i)	((vcpu_read_sys_reg((v), (r)) >> ((i) * 4)) & 0xf)
+
+#define set_priv_perms(wr, r, w, x)	\
+	do {				\
+		(wr)->pr = (r);		\
+		(wr)->pw = (w);		\
+		(wr)->px = (x);		\
+	} while (0)
+
+#define set_unpriv_perms(wr, r, w, x)	\
+	do {				\
+		(wr)->ur = (r);		\
+		(wr)->uw = (w);		\
+		(wr)->ux = (x);		\
+	} while (0)
+
+/* Similar to AArch64.S1IndirectBasePermissions(), without GCS  */
+#define set_perms(w, wr, ip)						\
+	do {								\
+		/* R_LLZDZ */						\
+		switch ((ip)) {						\
+		case 0b0000:						\
+			set_ ## w ## _perms((wr), false, false, false);	\
+			break;						\
+		case 0b0001:						\
+			set_ ## w ## _perms((wr), true , false, false);	\
+			break;						\
+		case 0b0010:						\
+			set_ ## w ## _perms((wr), false, false, true );	\
+			break;						\
+		case 0b0011:						\
+			set_ ## w ## _perms((wr), true , false, true );	\
+			break;						\
+		case 0b0100:						\
+			set_ ## w ## _perms((wr), false, false, false);	\
+			break;						\
+		case 0b0101:						\
+			set_ ## w ## _perms((wr), true , true , false);	\
+			break;						\
+		case 0b0110:						\
+			set_ ## w ## _perms((wr), true , true , true );	\
+			break;						\
+		case 0b0111:						\
+			set_ ## w ## _perms((wr), true , true , true );	\
+			break;						\
+		case 0b1000:						\
+			set_ ## w ## _perms((wr), true , false, false);	\
+			break;						\
+		case 0b1001:						\
+			set_ ## w ## _perms((wr), true , false, false);	\
+			break;						\
+		case 0b1010:						\
+			set_ ## w ## _perms((wr), true , false, true );	\
+			break;						\
+		case 0b1011:						\
+			set_ ## w ## _perms((wr), false, false, false);	\
+			break;						\
+		case 0b1100:						\
+			set_ ## w ## _perms((wr), true , true , false);	\
+			break;						\
+		case 0b1101:						\
+			set_ ## w ## _perms((wr), false, false, false);	\
+			break;						\
+		case 0b1110:						\
+			set_ ## w ## _perms((wr), true , true , true );	\
+			break;						\
+		case 0b1111:						\
+			set_ ## w ## _perms((wr), false, false, false);	\
+			break;						\
+		}							\
+	} while (0)
+
+static void compute_s1_indirect_permissions(struct kvm_vcpu *vcpu,
+					    struct s1_walk_info *wi,
+					    struct s1_walk_result *wr)
+{
+	u8 up, pp, idx;
+
+	idx = pte_pi_index(wr->desc);
+
+	switch (wi->regime) {
+	case TR_EL10:
+		pp = perm_idx(vcpu, PIR_EL1, idx);
+		up = perm_idx(vcpu, PIRE0_EL1, idx);
+		break;
+	case TR_EL20:
+		pp = perm_idx(vcpu, PIR_EL2, idx);
+		up = perm_idx(vcpu, PIRE0_EL2, idx);
+		break;
+	case TR_EL2:
+		pp = perm_idx(vcpu, PIR_EL2, idx);
+		up = 0;
+		break;
+	}
+
+	set_perms(priv, wr, pp);
+
+	if (wi->regime != TR_EL2)
+		set_perms(unpriv, wr, up);
+	else
+		set_unpriv_perms(wr, false, false, false);
+
+	/* R_VFPJF */
+	if (wr->px && wr->uw) {
+		set_priv_perms(wr, false, false, false);
+		set_unpriv_perms(wr, false, false, false);
+	}
+}
+
 static void compute_s1_permissions(struct kvm_vcpu *vcpu, u32 op,
 				   struct s1_walk_info *wi,
 				   struct s1_walk_result *wr)
 {
-	compute_s1_direct_permissions(vcpu, wi, wr);
+	if (!s1pie_enabled(vcpu, wi->regime))
+		compute_s1_direct_permissions(vcpu, wi, wr);
+	else
+		compute_s1_indirect_permissions(vcpu, wi, wr);
 
 	if (!wi->hpd)
 		compute_s1_hierarchical_permissions(vcpu, wi, wr);
-- 
2.39.2


