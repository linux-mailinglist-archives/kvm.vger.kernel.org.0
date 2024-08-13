Return-Path: <kvm+bounces-23967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BAE4895020C
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 12:08:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A23A1F21865
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 10:08:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91EEF19CCF7;
	Tue, 13 Aug 2024 10:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pvX2mMsF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDB219B5B5;
	Tue, 13 Aug 2024 10:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723543585; cv=none; b=NM6jc2Xj7eVyCAR8g7MDgTngUd8/+gJEBQ7nsDOarbCRfIlhEkN78m7LNGKiBS1Pt7nRYoeImjCKu8Pqp/jC3pYt+hB3JqNo8rP2c/8ZoiQ/ZB3jJnpXoLQOFH7Zqb6Vewxxjv//UVfdB5sYwmam0Coi8+5H/l7SLorCPxtxf5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723543585; c=relaxed/simple;
	bh=gQN6nCKWBkprbcXGO7KrP8gwMcmhmNPkCSpin2Fq/QY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t0HH+4vsGea583IWZXK7dj/wc3qO/y8r7zBJapbeS2ZIn4N9y4L+Qf+xHAGDkHQogkdoDTcz2qYuH9VqxRg23N8PuA+Ww7e3Q46PTOKCYh5watZNJ/e/2iCIt/dhjjYx0LrH6JdSGBn5iFYTzQKo9qAF8aR/GQ0kg3QbTODx7vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pvX2mMsF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80653C4AF0B;
	Tue, 13 Aug 2024 10:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723543585;
	bh=gQN6nCKWBkprbcXGO7KrP8gwMcmhmNPkCSpin2Fq/QY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pvX2mMsFy2dAwweXMwNTTHpaUl19jr9tsOYKfqLiWQsN/65bkDT3aWvjpeSG2TMG3
	 NnZ8HOp1OWwSd54VaITrOyjPfZ3qG63HclVHVNr084IvU0UfztzWb8VjqyyrjobomR
	 cNzG8iTc189y8bq66W24jdA9iRPNEQBuOshsRjpd6H8ib/8FyOhTZC5BdFknItyIO7
	 ZpR3pV6gY72SYwkhdqkTyjieY92mgiuSt7q+MXhj6aeGR0Ay77ubC4+PzO2B5Laql2
	 Fbe0mSIsgG+1+tkX0Ci5HiQQZifX1+KnYUBvfVO2g1TuyeNqAK1/Xl1LXowrnTsYRI
	 t33qs0vhRLabw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sdoQ2-003INM-TE;
	Tue, 13 Aug 2024 11:06:23 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Przemyslaw Gaj <pgaj@cadence.com>
Subject: [PATCH v3 12/18] KVM: arm64: nv: Add emulation of AT S12E{0,1}{R,W}
Date: Tue, 13 Aug 2024 11:05:34 +0100
Message-Id: <20240813100540.1955263-13-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240813100540.1955263-1-maz@kernel.org>
References: <20240813100540.1955263-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, alexandru.elisei@arm.com, anshuman.khandual@arm.com, pgaj@cadence.com
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
 arch/arm64/kvm/at.c              | 253 +++++++++++++++++++++++++++++++
 2 files changed, 254 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 6ec062296976..b36a3b6cc011 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -238,6 +238,7 @@ extern int __kvm_tlbi_s1e2(struct kvm_s2_mmu *mmu, u64 va, u64 sys_encoding);
 extern void __kvm_timer_set_cntvoff(u64 cntvoff);
 extern void __kvm_at_s1e01(struct kvm_vcpu *vcpu, u32 op, u64 vaddr);
 extern void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr);
+extern void __kvm_at_s12(struct kvm_vcpu *vcpu, u32 op, u64 vaddr);
 
 extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
index 34736c1fe398..9865d29b3149 100644
--- a/arch/arm64/kvm/at.c
+++ b/arch/arm64/kvm/at.c
@@ -71,6 +71,200 @@ static bool at_s1e1p_fast(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 	return fail;
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
+#define ATTR_NSH	0b00
+#define ATTR_RSV	0b01
+#define ATTR_OSH	0b10
+#define ATTR_ISH	0b11
+
+static u8 compute_sh(u8 attr, u64 desc)
+{
+	u8 sh;
+
+	/* Any form of device, as well as NC has SH[1:0]=0b10 */
+	if (MEMATTR_IS_DEVICE(attr) || attr == MEMATTR(NC, NC))
+		return ATTR_OSH;
+
+	sh = FIELD_GET(PTE_SHARED, desc);
+	if (sh == ATTR_RSV)		/* Reserved, mapped to NSH */
+		sh = ATTR_NSH;
+
+	return sh;
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
 /*
  * Return the PAR_EL1 value as the result of a valid translation.
  *
@@ -215,3 +409,62 @@ void __kvm_at_s1e2(struct kvm_vcpu *vcpu, u32 op, u64 vaddr)
 
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


