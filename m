Return-Path: <kvm+bounces-20485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59DF0916911
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 15:37:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10807283984
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 13:37:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7C6A16FF2E;
	Tue, 25 Jun 2024 13:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YSwBi9Jx"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CF416C438;
	Tue, 25 Jun 2024 13:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719322525; cv=none; b=sPPoD6qF8PoJiqazxJt3ikM/rbNHesOIIt/I6beSkTWlT/IQLupWtgmepwag1pLx5GIq0AobowumTyVNsm6zeLuwuEDLmwAj56223HJazb69apAmzjs+ah9SOI9u/K76eiTG907n3GE2F52JIwgzob1xKVfu9PVUJKKW/wz4lB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719322525; c=relaxed/simple;
	bh=rn9J8T1s1vtwoAIycftZ9EaEpIfuyGrD/4j0MdkPZd0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=amoOISVfD55HVktGgHpJ2YpsDrNK3KbtlAmABgjEQykozulsXtS43GQ39ANzelxJcINPCYlyVlTF5L6wZCP+SSm2g/bpy0zZFj+zFsZEIC3KIrWOUYCjVPyfIGBD8s0ib6uoKm88MxZPGWjV4acxmguM6HVaplTqduRarSc7GJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YSwBi9Jx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEC6FC4AF0F;
	Tue, 25 Jun 2024 13:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719322525;
	bh=rn9J8T1s1vtwoAIycftZ9EaEpIfuyGrD/4j0MdkPZd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YSwBi9JxQL5EuDs0g9PQ4kfbl1I3XJMq4T+pMZ2Pvv9HIqcL99WjcevqYzOr5BXKd
	 XlA4JTL45PQqqA4MwcKmsQaoh8W5RWhTx1nkuWEkpBJ+M+Xh4HCEmd9redzICNm+sL
	 kTzwCenxaBuQ9K3HEuXnm7v0sxJJGXBDSGyCJIPINjvN6EDND/17hEyY1pg31Fs24K
	 0mr2sOEe/cqdDD/j4UFpEe4JfVyiABustmxh4SDM12Re0u7qsuo4cXJJjVZoeXiYsO
	 KHgonORNwGE6FAAMYoxYniFwvb88yVALu/jrK2aPSV0CtKIdi9dNQv0UYpN5UhTRHC
	 r39/UK9r6ypGw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sM6KR-007A6l-83;
	Tue, 25 Jun 2024 14:35:23 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>
Subject: [PATCH 08/12] KVM: arm64: nv: Add emulation of AT S12E{0,1}{R,W}
Date: Tue, 25 Jun 2024 14:35:07 +0100
Message-Id: <20240625133508.259829-9-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240625133508.259829-1-maz@kernel.org>
References: <20240625133508.259829-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On the face of it, AT S12E{0,1}{R,W} is pretty simple. It is the
combination of AT S1E{0,1}{R,W}, followed by an extra S2 walk.

However, there is a great deal of complexity coming from combining
the S1 and S2 attributes to report something consistent in PAR_EL1.

This is an absolute mine field, and I have a splitting headache.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h |   1 +
 arch/arm64/kvm/at.c              | 242 +++++++++++++++++++++++++++++++
 2 files changed, 243 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 6ec0622969766..b36a3b6cc0116 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -238,6 +238,7 @@ extern int __kvm_tlbi_s1e2(struct kvm_s2_mmu *mmu, u64 va, u64 sys_encoding);
 extern void __kvm_timer_set_cntvoff(u64 cntvoff);
 extern void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr);
 extern void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr);
+extern void __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr);
 
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 147df5a9cc4e0..71e3390b43b4c 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -51,6 +51,189 @@ static void __mmu_config_restore(struct mmu_config *config)
 	isb();
 }
 
+#define MEMATTR(ic, oc)		(MEMATTR_##oc << 4 | MEMATTR_##ic)
+#define MEMATTR_NC		0b0100
+#define MEMATTR_Wt		0b1000
+#define MEMATTR_Wb		0b1100
+#define MEMATTR_WbRaWa		0b1111
+
+#define MEMATTR_IS_DEVICE(m)	(((m) & GENMASK(7, 4)) == 0)
+
+static u8 s2_memattr_to_attr(u8 memattr)
+{
+	memattr &= 0b1111;
+
+	switch (memattr) {
+	case 0b0000:
+	case 0b0001:
+	case 0b0010:
+	case 0b0011:
+		return memattr << 2;
+	case 0b0100:
+		return MEMATTR(Wb, Wb);
+	case 0b0101:
+		return MEMATTR(NC, NC);
+	case 0b0110:
+		return MEMATTR(Wt, NC);
+	case 0b0111:
+		return MEMATTR(Wb, NC);
+	case 0b1000:
+		/* Reserved, assume NC */
+		return MEMATTR(NC, NC);
+	case 0b1001:
+		return MEMATTR(NC, Wt);
+	case 0b1010:
+		return MEMATTR(Wt, Wt);
+	case 0b1011:
+		return MEMATTR(Wb, Wt);
+	case 0b1100:
+		/* Reserved, assume NC */
+		return MEMATTR(NC, NC);
+	case 0b1101:
+		return MEMATTR(NC, Wb);
+	case 0b1110:
+		return MEMATTR(Wt, Wb);
+	case 0b1111:
+		return MEMATTR(Wb, Wb);
+	default:
+		unreachable();
+	}
+}
+
+static u8 combine_s1_s2_attr(u8 s1, u8 s2)
+{
+	bool transient;
+	u8 final = 0;
+
+	/* Upgrade transient s1 to non-transient to simplify things */
+	switch (s1) {
+	case 0b0001 ... 0b0011:	/* Normal, Write-Through Transient */
+		transient = true;
+		s1 = MEMATTR_Wt | (s1 & GENMASK(1,0));
+		break;
+	case 0b0101 ... 0b0111:	/* Normal, Write-Back Transient */
+		transient = true;
+		s1 = MEMATTR_Wb | (s1 & GENMASK(1,0));
+		break;
+	default:
+		transient = false;
+	}
+
+	/* S2CombineS1AttrHints() */
+	if ((s1 & GENMASK(3, 2)) == MEMATTR_NC ||
+	    (s2 & GENMASK(3, 2)) == MEMATTR_NC)
+		final = MEMATTR_NC;
+	else if ((s1 & GENMASK(3, 2)) == MEMATTR_Wt ||
+		 (s2 & GENMASK(3, 2)) == MEMATTR_Wt)
+		final = MEMATTR_Wt;
+	else
+		final = MEMATTR_Wb;
+
+	if (final != MEMATTR_NC) {
+		/* Inherit RaWa hints form S1 */
+		if (transient) {
+			switch (s1 & GENMASK(3, 2)) {
+			case MEMATTR_Wt:
+				final = 0;
+				break;
+			case MEMATTR_Wb:
+				final = MEMATTR_NC;
+				break;
+			}
+		}
+
+		final |= s1 & GENMASK(1, 0);
+	}
+
+	return final;
+}
+
+static u8 compute_sh(u8 attr, u64 desc)
+{
+	/* Any form of device, as well as NC has SH[1:0]=0b10 */
+	if (MEMATTR_IS_DEVICE(attr) || attr == MEMATTR(NC, NC))
+		return 0b10;
+
+	return FIELD_GET(PTE_SHARED, desc) == 0b11 ? 0b11 : 0b10;
+}
+
+static u64 compute_par_s12(struct kvm_vcpu *vcpu, u64 s1_par,
+			   struct kvm_s2_trans *tr)
+{
+	u8 s1_parattr, s2_memattr, final_attr;
+	u64 par;
+
+	/* If S2 has failed to translate, report the damage */
+	if (tr->esr) {
+		par = SYS_PAR_EL1_RES1;
+		par |= SYS_PAR_EL1_F;
+		par |= SYS_PAR_EL1_S;
+		par |= FIELD_PREP(SYS_PAR_EL1_FST, tr->esr);
+		return par;
+	}
+
+	s1_parattr = FIELD_GET(SYS_PAR_EL1_ATTR, s1_par);
+	s2_memattr = FIELD_GET(GENMASK(5, 2), tr->desc);
+
+	if (__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_FWB) {
+		if (!kvm_has_feat(vcpu->kvm, ID_AA64PFR2_EL1, MTEPERM, IMP))
+			s2_memattr &= ~BIT(3);
+
+		/* Combination of R_VRJSW and R_RHWZM */
+		switch (s2_memattr) {
+		case 0b0101:
+			if (MEMATTR_IS_DEVICE(s1_parattr))
+				final_attr = s1_parattr;
+			else
+				final_attr = MEMATTR(NC, NC);
+			break;
+		case 0b0110:
+		case 0b1110:
+			final_attr = MEMATTR(WbRaWa, WbRaWa);
+			break;
+		case 0b0111:
+		case 0b1111:
+			/* Preserve S1 attribute */
+			final_attr = s1_parattr;
+			break;
+		case 0b0100:
+		case 0b1100:
+		case 0b1101:
+			/* Reserved, do something non-silly */
+			final_attr = s1_parattr;
+			break;
+		default:
+			/* MemAttr[2]=0, Device from S2 */
+			final_attr = s2_memattr & GENMASK(1,0) << 2;
+		}
+	} else {
+		/* Combination of R_HMNDG, R_TNHFM and R_GQFSF */
+		u8 s2_parattr = s2_memattr_to_attr(s2_memattr);
+
+		if (MEMATTR_IS_DEVICE(s1_parattr) ||
+		    MEMATTR_IS_DEVICE(s2_parattr)) {
+			final_attr = min(s1_parattr, s2_parattr);
+		} else {
+			/* At this stage, this is memory vs memory */
+			final_attr  = combine_s1_s2_attr(s1_parattr & 0xf,
+							 s2_parattr & 0xf);
+			final_attr |= combine_s1_s2_attr(s1_parattr >> 4,
+							 s2_parattr >> 4) << 4;
+		}
+	}
+
+	if ((__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_CD) &&
+	    !MEMATTR_IS_DEVICE(final_attr))
+		final_attr = MEMATTR(NC, NC);
+
+	par  = FIELD_PREP(SYS_PAR_EL1_ATTR, final_attr);
+	par |= tr->output & GENMASK(47, 12);
+	par |= FIELD_PREP(SYS_PAR_EL1_SH,
+			  compute_sh(final_attr, tr->desc));
+
+	return par;
+}
+
 static bool check_at_pan(struct kvm_vcpu *vcpu, u64 vaddr, u64 *res)
 {
 	u64 par_e0;
@@ -252,3 +435,62 @@ void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 
 	vcpu_write_sys_reg(vcpu, par, PAR_EL1);
 }
+
+void __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
+{
+	struct kvm_s2_trans out = {};
+	u64 ipa, par;
+	bool write;
+	int ret;
+
+	/* Do the stage-1 translation */
+	switch (op) {
+	case OP_AT_S12E1R:
+		op = OP_AT_S1E1R;
+		write = false;
+		break;
+	case OP_AT_S12E1W:
+		op = OP_AT_S1E1W;
+		write = true;
+		break;
+	case OP_AT_S12E0R:
+		op = OP_AT_S1E0R;
+		write = false;
+		break;
+	case OP_AT_S12E0W:
+		op = OP_AT_S1E0W;
+		write = true;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return;
+	}
+
+	__kvm_at_s1e01(vcpu, op, vaddr);
+	par = vcpu_read_sys_reg(vcpu, PAR_EL1);
+	if (par & SYS_PAR_EL1_F)
+		return;
+
+	/*
+	 * If we only have a single stage of translation (E2H=0 or
+	 * TGE=1), exit early. Same thing if {VM,DC}=={0,0}.
+	 */
+	if (!vcpu_el2_e2h_is_set(vcpu) || vcpu_el2_tge_is_set(vcpu) ||
+	    !(vcpu_read_sys_reg(vcpu, HCR_EL2) & (HCR_VM | HCR_DC)))
+		return;
+
+	/* Do the stage-2 translation */
+	ipa = (par & GENMASK_ULL(47, 12)) | (vaddr & GENMASK_ULL(11, 0));
+	out.esr = 0;
+	ret = kvm_walk_nested_s2(vcpu, ipa, &out);
+	if (ret < 0)
+		return;
+
+	/* Check the access permission */
+	if (!out.esr &&
+	    ((!write && !out.readable) || (write && !out.writable)))
+		out.esr = ESR_ELx_FSC_PERM | (out.level & 0x3);
+
+	par = compute_par_s12(vcpu, par, &out);
+	vcpu_write_sys_reg(vcpu, par, PAR_EL1);
+}
-- 
2.39.2


