Return-Path: <kvm+bounces-69127-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aFOHK6Nbd2maeQEAu9opvQ
	(envelope-from <kvm+bounces-69127-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 13:18:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1602E881CD
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 13:18:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 34EE2304DE8D
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 12:17:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7D9C337107;
	Mon, 26 Jan 2026 12:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bbCBGenk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D315B3358C9;
	Mon, 26 Jan 2026 12:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769429854; cv=none; b=S0/Y7wIDVg3OGx0PFW+5vgRSt6YC9iq2KSPKymUrAZacN7Tyx8emqZAviP4XJ8HaDqHdt1C5JJLjcoHEMwK8G9v/fWRtrEgm/GZpGR/Ws8rlWYdYLJjSF5Xx5dfms4u8jykX+UVS3P3p1tvZBQsG/WvqU5ehge2Mpl28/+EQ4NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769429854; c=relaxed/simple;
	bh=kr89C3frdiHab0sdKVtsH8ewA9/ii8BsN3odPP5LQP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JXwLw04V0st0VUVRKS2zsN9EkH+aW8Ru952paB++tV8xPB/VRTjFiG6nNa9Nu/OR+0LKSHqvxcEM/v5Mxp3xlu3HGomE8Ef0N4II7mcGBbMOOYKXd62my00mn/OtY8ANy8whhLeYxHPqqqiFNA/j8Bb9l1FT750N9rNo1bQ9WXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bbCBGenk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D12CC2BCB0;
	Mon, 26 Jan 2026 12:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769429854;
	bh=kr89C3frdiHab0sdKVtsH8ewA9/ii8BsN3odPP5LQP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bbCBGenkz9HW6uBw/8+qz497olZ0ZurnyYcveWAIDER63DutE0hqqbTgWqIu/5SuA
	 8avQbZto0faYgBO8ZGtDQrC1T01tiQlozk9DTw3YPP6XQbz0eilN7jQHKUeuClmC/K
	 loKbq96vq9wt7S64r2qEPrd0avdIILH1FmG0Fybd8mz2aUrmGVuWMP8BxwRMo5AbR6
	 CGylSFl+yL6MIExFUaDtb7c61eejIMfRhgYrR+CE2ni1ZWfm5dxX0g+iI3tFjFwIqX
	 K82n2x0eLBOJbbXA/+IXq3Ksv9R2n3xJPFxbVYjql5MJjkihi3WEXIhPMz+Iv3Z8G6
	 aNSyyn/B7HNYA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vkLXA-00000005hx6-24da;
	Mon, 26 Jan 2026 12:17:32 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 04/20] KVM: arm64: Introduce data structure tracking both RES0 and RES1 bits
Date: Mon, 26 Jan 2026 12:16:38 +0000
Message-ID: <20260126121655.1641736-5-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260126121655.1641736-1-maz@kernel.org>
References: <20260126121655.1641736-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69127-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maz@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1602E881CD
X-Rspamd-Action: no action

We have so far mostly tracked RES0 bits, but only made a few attempts
at being just as strict for RES1 bits (probably because they are both
rarer and harder to handle).

Start scratching the surface by introducing a data structure tracking
RES0 and RES1 bits at the same time.

Note that contrary to the usual idiom, this structure is mostly passed
around by value -- the ABI handles it nicely, and the resulting code is
much nicer.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  17 ++--
 arch/arm64/kvm/config.c           | 122 +++++++++++++++-------------
 arch/arm64/kvm/nested.c           | 129 +++++++++++++++---------------
 3 files changed, 144 insertions(+), 124 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b552a1e03848c..a7e4cd8ebf56f 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -626,13 +626,20 @@ enum vcpu_sysreg {
 	NR_SYS_REGS	/* Nothing after this line! */
 };
 
+struct resx {
+	u64	res0;
+	u64	res1;
+};
+
 struct kvm_sysreg_masks {
-	struct {
-		u64	res0;
-		u64	res1;
-	} mask[NR_SYS_REGS - __SANITISED_REG_START__];
+	struct resx mask[NR_SYS_REGS - __SANITISED_REG_START__];
 };
 
+#define kvm_set_sysreg_resx(k, sr, resx)		\
+	do {						\
+		(k)->arch.sysreg_masks->mask[sr - __SANITISED_REG_START__] = resx; \
+	} while(0)
+
 struct fgt_masks {
 	const char	*str;
 	u64		mask;
@@ -1607,7 +1614,7 @@ static inline bool kvm_arch_has_irq_bypass(void)
 }
 
 void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt);
-void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *res1);
+struct resx get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg);
 void check_feature_map(void);
 void kvm_vcpu_load_fgt(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index 2122599f7cbbd..a907195bd44b6 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1290,14 +1290,15 @@ static bool idreg_feat_match(struct kvm *kvm, const struct reg_bits_to_feat_map
 	}
 }
 
-static u64 __compute_fixed_bits(struct kvm *kvm,
+static
+struct resx __compute_fixed_bits(struct kvm *kvm,
 				const struct reg_bits_to_feat_map *map,
 				int map_size,
 				u64 *fixed_bits,
 				unsigned long require,
 				unsigned long exclude)
 {
-	u64 val = 0;
+	struct resx resx = {};
 
 	for (int i = 0; i < map_size; i++) {
 		bool match;
@@ -1316,13 +1317,14 @@ static u64 __compute_fixed_bits(struct kvm *kvm,
 			match = idreg_feat_match(kvm, &map[i]);
 
 		if (!match || (map[i].flags & FIXED_VALUE))
-			val |= reg_feat_map_bits(&map[i]);
+			resx.res0 |= reg_feat_map_bits(&map[i]);
 	}
 
-	return val;
+	return resx;
 }
 
-static u64 compute_res0_bits(struct kvm *kvm,
+static
+struct resx compute_resx_bits(struct kvm *kvm,
 			     const struct reg_bits_to_feat_map *map,
 			     int map_size,
 			     unsigned long require,
@@ -1332,34 +1334,43 @@ static u64 compute_res0_bits(struct kvm *kvm,
 				    require, exclude | FIXED_VALUE);
 }
 
-static u64 compute_reg_res0_bits(struct kvm *kvm,
+static
+struct resx compute_reg_resx_bits(struct kvm *kvm,
 				 const struct reg_feat_map_desc *r,
 				 unsigned long require, unsigned long exclude)
 {
-	u64 res0;
+	struct resx resx, tmp;
 
-	res0 = compute_res0_bits(kvm, r->bit_feat_map, r->bit_feat_map_sz,
+	resx = compute_resx_bits(kvm, r->bit_feat_map, r->bit_feat_map_sz,
 				 require, exclude);
 
-	res0 |= compute_res0_bits(kvm, &r->feat_map, 1, require, exclude);
-	res0 |= ~reg_feat_map_bits(&r->feat_map);
+	tmp = compute_resx_bits(kvm, &r->feat_map, 1, require, exclude);
+
+	resx.res0 |= tmp.res0;
+	resx.res0 |= ~reg_feat_map_bits(&r->feat_map);
+	resx.res1 |= tmp.res1;
 
-	return res0;
+	return resx;
 }
 
 static u64 compute_fgu_bits(struct kvm *kvm, const struct reg_feat_map_desc *r)
 {
+	struct resx resx;
+
 	/*
 	 * If computing FGUs, we collect the unsupported feature bits as
-	 * RES0 bits, but don't take the actual RES0 bits or register
+	 * RESx bits, but don't take the actual RESx bits or register
 	 * existence into account -- we're not computing bits for the
 	 * register itself.
 	 */
-	return compute_res0_bits(kvm, r->bit_feat_map, r->bit_feat_map_sz,
+	resx = compute_resx_bits(kvm, r->bit_feat_map, r->bit_feat_map_sz,
 				 0, NEVER_FGU);
+
+	return resx.res0 | resx.res1;
 }
 
-static u64 compute_reg_fixed_bits(struct kvm *kvm,
+static
+struct resx compute_reg_fixed_bits(struct kvm *kvm,
 				  const struct reg_feat_map_desc *r,
 				  u64 *fixed_bits, unsigned long require,
 				  unsigned long exclude)
@@ -1405,91 +1416,94 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt)
 	kvm->arch.fgu[fgt] = val;
 }
 
-void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *res1)
+struct resx get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg)
 {
 	u64 fixed = 0, mask;
+	struct resx resx;
 
 	switch (reg) {
 	case HFGRTR_EL2:
-		*res0 = compute_reg_res0_bits(kvm, &hfgrtr_desc, 0, 0);
-		*res1 = HFGRTR_EL2_RES1;
+		resx = compute_reg_resx_bits(kvm, &hfgrtr_desc, 0, 0);
+		resx.res1 |= HFGRTR_EL2_RES1;
 		break;
 	case HFGWTR_EL2:
-		*res0 = compute_reg_res0_bits(kvm, &hfgwtr_desc, 0, 0);
-		*res1 = HFGWTR_EL2_RES1;
+		resx = compute_reg_resx_bits(kvm, &hfgwtr_desc, 0, 0);
+		resx.res1 |= HFGWTR_EL2_RES1;
 		break;
 	case HFGITR_EL2:
-		*res0 = compute_reg_res0_bits(kvm, &hfgitr_desc, 0, 0);
-		*res1 = HFGITR_EL2_RES1;
+		resx = compute_reg_resx_bits(kvm, &hfgitr_desc, 0, 0);
+		resx.res1 |= HFGITR_EL2_RES1;
 		break;
 	case HDFGRTR_EL2:
-		*res0 = compute_reg_res0_bits(kvm, &hdfgrtr_desc, 0, 0);
-		*res1 = HDFGRTR_EL2_RES1;
+		resx = compute_reg_resx_bits(kvm, &hdfgrtr_desc, 0, 0);
+		resx.res1 |= HDFGRTR_EL2_RES1;
 		break;
 	case HDFGWTR_EL2:
-		*res0 = compute_reg_res0_bits(kvm, &hdfgwtr_desc, 0, 0);
-		*res1 = HDFGWTR_EL2_RES1;
+		resx = compute_reg_resx_bits(kvm, &hdfgwtr_desc, 0, 0);
+		resx.res1 |= HDFGWTR_EL2_RES1;
 		break;
 	case HAFGRTR_EL2:
-		*res0 = compute_reg_res0_bits(kvm, &hafgrtr_desc, 0, 0);
-		*res1 = HAFGRTR_EL2_RES1;
+		resx = compute_reg_resx_bits(kvm, &hafgrtr_desc, 0, 0);
+		resx.res1 |= HAFGRTR_EL2_RES1;
 		break;
 	case HFGRTR2_EL2:
-		*res0 = compute_reg_res0_bits(kvm, &hfgrtr2_desc, 0, 0);
-		*res1 = HFGRTR2_EL2_RES1;
+		resx = compute_reg_resx_bits(kvm, &hfgrtr2_desc, 0, 0);
+		resx.res1 |= HFGRTR2_EL2_RES1;
 		break;
 	case HFGWTR2_EL2:
-		*res0 = compute_reg_res0_bits(kvm, &hfgwtr2_desc, 0, 0);
-		*res1 = HFGWTR2_EL2_RES1;
+		resx = compute_reg_resx_bits(kvm, &hfgwtr2_desc, 0, 0);
+		resx.res1 |= HFGWTR2_EL2_RES1;
 		break;
 	case HFGITR2_EL2:
-		*res0 = compute_reg_res0_bits(kvm, &hfgitr2_desc, 0, 0);
-		*res1 = HFGITR2_EL2_RES1;
+		resx = compute_reg_resx_bits(kvm, &hfgitr2_desc, 0, 0);
+		resx.res1 |= HFGITR2_EL2_RES1;
 		break;
 	case HDFGRTR2_EL2:
-		*res0 = compute_reg_res0_bits(kvm, &hdfgrtr2_desc, 0, 0);
-		*res1 = HDFGRTR2_EL2_RES1;
+		resx = compute_reg_resx_bits(kvm, &hdfgrtr2_desc, 0, 0);
+		resx.res1 |= HDFGRTR2_EL2_RES1;
 		break;
 	case HDFGWTR2_EL2:
-		*res0 = compute_reg_res0_bits(kvm, &hdfgwtr2_desc, 0, 0);
-		*res1 = HDFGWTR2_EL2_RES1;
+		resx = compute_reg_resx_bits(kvm, &hdfgwtr2_desc, 0, 0);
+		resx.res1 |= HDFGWTR2_EL2_RES1;
 		break;
 	case HCRX_EL2:
-		*res0 = compute_reg_res0_bits(kvm, &hcrx_desc, 0, 0);
-		*res1 = __HCRX_EL2_RES1;
+		resx = compute_reg_resx_bits(kvm, &hcrx_desc, 0, 0);
+		resx.res1 |= __HCRX_EL2_RES1;
 		break;
 	case HCR_EL2:
-		mask = compute_reg_fixed_bits(kvm, &hcr_desc, &fixed, 0, 0);
-		*res0 = compute_reg_res0_bits(kvm, &hcr_desc, 0, 0);
-		*res0 |= (mask & ~fixed);
-		*res1 = HCR_EL2_RES1 | (mask & fixed);
+		mask = compute_reg_fixed_bits(kvm, &hcr_desc, &fixed, 0, 0).res0;
+		resx = compute_reg_resx_bits(kvm, &hcr_desc, 0, 0);
+		resx.res0 |= (mask & ~fixed);
+		resx.res1 |= HCR_EL2_RES1 | (mask & fixed);
 		break;
 	case SCTLR2_EL1:
 	case SCTLR2_EL2:
-		*res0 = compute_reg_res0_bits(kvm, &sctlr2_desc, 0, 0);
-		*res1 = SCTLR2_EL1_RES1;
+		resx = compute_reg_resx_bits(kvm, &sctlr2_desc, 0, 0);
+		resx.res1 |= SCTLR2_EL1_RES1;
 		break;
 	case TCR2_EL2:
-		*res0 = compute_reg_res0_bits(kvm, &tcr2_el2_desc, 0, 0);
-		*res1 = TCR2_EL2_RES1;
+		resx = compute_reg_resx_bits(kvm, &tcr2_el2_desc, 0, 0);
+		resx.res1 |= TCR2_EL2_RES1;
 		break;
 	case SCTLR_EL1:
-		*res0 = compute_reg_res0_bits(kvm, &sctlr_el1_desc, 0, 0);
-		*res1 = SCTLR_EL1_RES1;
+		resx = compute_reg_resx_bits(kvm, &sctlr_el1_desc, 0, 0);
+		resx.res1 |= SCTLR_EL1_RES1;
 		break;
 	case MDCR_EL2:
-		*res0 = compute_reg_res0_bits(kvm, &mdcr_el2_desc, 0, 0);
-		*res1 = MDCR_EL2_RES1;
+		resx = compute_reg_resx_bits(kvm, &mdcr_el2_desc, 0, 0);
+		resx.res1 |= MDCR_EL2_RES1;
 		break;
 	case VTCR_EL2:
-		*res0 = compute_reg_res0_bits(kvm, &vtcr_el2_desc, 0, 0);
-		*res1 = VTCR_EL2_RES1;
+		resx = compute_reg_resx_bits(kvm, &vtcr_el2_desc, 0, 0);
+		resx.res1 |= VTCR_EL2_RES1;
 		break;
 	default:
 		WARN_ON_ONCE(1);
-		*res0 = *res1 = 0;
+		resx = (typeof(resx)){};
 		break;
 	}
+
+	return resx;
 }
 
 static __always_inline struct fgt_masks *__fgt_reg_to_masks(enum vcpu_sysreg reg)
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 486eba72bb027..c5a45bc62153e 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1683,22 +1683,19 @@ u64 kvm_vcpu_apply_reg_masks(const struct kvm_vcpu *vcpu,
 	return v;
 }
 
-static __always_inline void set_sysreg_masks(struct kvm *kvm, int sr, u64 res0, u64 res1)
+static __always_inline void set_sysreg_masks(struct kvm *kvm, int sr, struct resx resx)
 {
-	int i = sr - __SANITISED_REG_START__;
-
 	BUILD_BUG_ON(!__builtin_constant_p(sr));
 	BUILD_BUG_ON(sr < __SANITISED_REG_START__);
 	BUILD_BUG_ON(sr >= NR_SYS_REGS);
 
-	kvm->arch.sysreg_masks->mask[i].res0 = res0;
-	kvm->arch.sysreg_masks->mask[i].res1 = res1;
+	kvm_set_sysreg_resx(kvm, sr, resx);
 }
 
 int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
-	u64 res0, res1;
+	struct resx resx;
 
 	lockdep_assert_held(&kvm->arch.config_lock);
 
@@ -1711,110 +1708,112 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 		return -ENOMEM;
 
 	/* VTTBR_EL2 */
-	res0 = res1 = 0;
+	resx = (typeof(resx)){};
 	if (!kvm_has_feat_enum(kvm, ID_AA64MMFR1_EL1, VMIDBits, 16))
-		res0 |= GENMASK(63, 56);
+		resx.res0 |= GENMASK(63, 56);
 	if (!kvm_has_feat(kvm, ID_AA64MMFR2_EL1, CnP, IMP))
-		res0 |= VTTBR_CNP_BIT;
-	set_sysreg_masks(kvm, VTTBR_EL2, res0, res1);
+		resx.res0 |= VTTBR_CNP_BIT;
+	set_sysreg_masks(kvm, VTTBR_EL2, resx);
 
 	/* VTCR_EL2 */
-	get_reg_fixed_bits(kvm, VTCR_EL2, &res0, &res1);
-	set_sysreg_masks(kvm, VTCR_EL2, res0, res1);
+	resx = get_reg_fixed_bits(kvm, VTCR_EL2);
+	set_sysreg_masks(kvm, VTCR_EL2, resx);
 
 	/* VMPIDR_EL2 */
-	res0 = GENMASK(63, 40) | GENMASK(30, 24);
-	res1 = BIT(31);
-	set_sysreg_masks(kvm, VMPIDR_EL2, res0, res1);
+	resx.res0 = GENMASK(63, 40) | GENMASK(30, 24);
+	resx.res1 = BIT(31);
+	set_sysreg_masks(kvm, VMPIDR_EL2, resx);
 
 	/* HCR_EL2 */
-	get_reg_fixed_bits(kvm, HCR_EL2, &res0, &res1);
-	set_sysreg_masks(kvm, HCR_EL2, res0, res1);
+	resx = get_reg_fixed_bits(kvm, HCR_EL2);
+	set_sysreg_masks(kvm, HCR_EL2, resx);
 
 	/* HCRX_EL2 */
-	get_reg_fixed_bits(kvm, HCRX_EL2, &res0, &res1);
-	set_sysreg_masks(kvm, HCRX_EL2, res0, res1);
+	resx = get_reg_fixed_bits(kvm, HCRX_EL2);
+	set_sysreg_masks(kvm, HCRX_EL2, resx);
 
 	/* HFG[RW]TR_EL2 */
-	get_reg_fixed_bits(kvm, HFGRTR_EL2, &res0, &res1);
-	set_sysreg_masks(kvm, HFGRTR_EL2, res0, res1);
-	get_reg_fixed_bits(kvm, HFGWTR_EL2, &res0, &res1);
-	set_sysreg_masks(kvm, HFGWTR_EL2, res0, res1);
+	resx = get_reg_fixed_bits(kvm, HFGRTR_EL2);
+	set_sysreg_masks(kvm, HFGRTR_EL2, resx);
+	resx = get_reg_fixed_bits(kvm, HFGWTR_EL2);
+	set_sysreg_masks(kvm, HFGWTR_EL2, resx);
 
 	/* HDFG[RW]TR_EL2 */
-	get_reg_fixed_bits(kvm, HDFGRTR_EL2, &res0, &res1);
-	set_sysreg_masks(kvm, HDFGRTR_EL2, res0, res1);
-	get_reg_fixed_bits(kvm, HDFGWTR_EL2, &res0, &res1);
-	set_sysreg_masks(kvm, HDFGWTR_EL2, res0, res1);
+	resx = get_reg_fixed_bits(kvm, HDFGRTR_EL2);
+	set_sysreg_masks(kvm, HDFGRTR_EL2, resx);
+	resx = get_reg_fixed_bits(kvm, HDFGWTR_EL2);
+	set_sysreg_masks(kvm, HDFGWTR_EL2, resx);
 
 	/* HFGITR_EL2 */
-	get_reg_fixed_bits(kvm, HFGITR_EL2, &res0, &res1);
-	set_sysreg_masks(kvm, HFGITR_EL2, res0, res1);
+	resx = get_reg_fixed_bits(kvm, HFGITR_EL2);
+	set_sysreg_masks(kvm, HFGITR_EL2, resx);
 
 	/* HAFGRTR_EL2 - not a lot to see here */
-	get_reg_fixed_bits(kvm, HAFGRTR_EL2, &res0, &res1);
-	set_sysreg_masks(kvm, HAFGRTR_EL2, res0, res1);
+	resx = get_reg_fixed_bits(kvm, HAFGRTR_EL2);
+	set_sysreg_masks(kvm, HAFGRTR_EL2, resx);
 
 	/* HFG[RW]TR2_EL2 */
-	get_reg_fixed_bits(kvm, HFGRTR2_EL2, &res0, &res1);
-	set_sysreg_masks(kvm, HFGRTR2_EL2, res0, res1);
-	get_reg_fixed_bits(kvm, HFGWTR2_EL2, &res0, &res1);
-	set_sysreg_masks(kvm, HFGWTR2_EL2, res0, res1);
+	resx = get_reg_fixed_bits(kvm, HFGRTR2_EL2);
+	set_sysreg_masks(kvm, HFGRTR2_EL2, resx);
+	resx = get_reg_fixed_bits(kvm, HFGWTR2_EL2);
+	set_sysreg_masks(kvm, HFGWTR2_EL2, resx);
 
 	/* HDFG[RW]TR2_EL2 */
-	get_reg_fixed_bits(kvm, HDFGRTR2_EL2, &res0, &res1);
-	set_sysreg_masks(kvm, HDFGRTR2_EL2, res0, res1);
-	get_reg_fixed_bits(kvm, HDFGWTR2_EL2, &res0, &res1);
-	set_sysreg_masks(kvm, HDFGWTR2_EL2, res0, res1);
+	resx = get_reg_fixed_bits(kvm, HDFGRTR2_EL2);
+	set_sysreg_masks(kvm, HDFGRTR2_EL2, resx);
+	resx = get_reg_fixed_bits(kvm, HDFGWTR2_EL2);
+	set_sysreg_masks(kvm, HDFGWTR2_EL2, resx);
 
 	/* HFGITR2_EL2 */
-	get_reg_fixed_bits(kvm, HFGITR2_EL2, &res0, &res1);
-	set_sysreg_masks(kvm, HFGITR2_EL2, res0, res1);
+	resx = get_reg_fixed_bits(kvm, HFGITR2_EL2);
+	set_sysreg_masks(kvm, HFGITR2_EL2, resx);
 
 	/* TCR2_EL2 */
-	get_reg_fixed_bits(kvm, TCR2_EL2, &res0, &res1);
-	set_sysreg_masks(kvm, TCR2_EL2, res0, res1);
+	resx = get_reg_fixed_bits(kvm, TCR2_EL2);
+	set_sysreg_masks(kvm, TCR2_EL2, resx);
 
 	/* SCTLR_EL1 */
-	get_reg_fixed_bits(kvm, SCTLR_EL1, &res0, &res1);
-	set_sysreg_masks(kvm, SCTLR_EL1, res0, res1);
+	resx = get_reg_fixed_bits(kvm, SCTLR_EL1);
+	set_sysreg_masks(kvm, SCTLR_EL1, resx);
 
 	/* SCTLR2_ELx */
-	get_reg_fixed_bits(kvm, SCTLR2_EL1, &res0, &res1);
-	set_sysreg_masks(kvm, SCTLR2_EL1, res0, res1);
-	get_reg_fixed_bits(kvm, SCTLR2_EL2, &res0, &res1);
-	set_sysreg_masks(kvm, SCTLR2_EL2, res0, res1);
+	resx = get_reg_fixed_bits(kvm, SCTLR2_EL1);
+	set_sysreg_masks(kvm, SCTLR2_EL1, resx);
+	resx = get_reg_fixed_bits(kvm, SCTLR2_EL2);
+	set_sysreg_masks(kvm, SCTLR2_EL2, resx);
 
 	/* MDCR_EL2 */
-	get_reg_fixed_bits(kvm, MDCR_EL2, &res0, &res1);
-	set_sysreg_masks(kvm, MDCR_EL2, res0, res1);
+	resx = get_reg_fixed_bits(kvm, MDCR_EL2);
+	set_sysreg_masks(kvm, MDCR_EL2, resx);
 
 	/* CNTHCTL_EL2 */
-	res0 = GENMASK(63, 20);
-	res1 = 0;
+	resx.res0 = GENMASK(63, 20);
+	resx.res1 = 0;
 	if (!kvm_has_feat(kvm, ID_AA64PFR0_EL1, RME, IMP))
-		res0 |= CNTHCTL_CNTPMASK | CNTHCTL_CNTVMASK;
+		resx.res0 |= CNTHCTL_CNTPMASK | CNTHCTL_CNTVMASK;
 	if (!kvm_has_feat(kvm, ID_AA64MMFR0_EL1, ECV, CNTPOFF)) {
-		res0 |= CNTHCTL_ECV;
+		resx.res0 |= CNTHCTL_ECV;
 		if (!kvm_has_feat(kvm, ID_AA64MMFR0_EL1, ECV, IMP))
-			res0 |= (CNTHCTL_EL1TVT | CNTHCTL_EL1TVCT |
-				 CNTHCTL_EL1NVPCT | CNTHCTL_EL1NVVCT);
+			resx.res0 |= (CNTHCTL_EL1TVT | CNTHCTL_EL1TVCT |
+				      CNTHCTL_EL1NVPCT | CNTHCTL_EL1NVVCT);
 	}
 	if (!kvm_has_feat(kvm, ID_AA64MMFR1_EL1, VH, IMP))
-		res0 |= GENMASK(11, 8);
-	set_sysreg_masks(kvm, CNTHCTL_EL2, res0, res1);
+		resx.res0 |= GENMASK(11, 8);
+	set_sysreg_masks(kvm, CNTHCTL_EL2, resx);
 
 	/* ICH_HCR_EL2 */
-	res0 = ICH_HCR_EL2_RES0;
-	res1 = ICH_HCR_EL2_RES1;
+	resx.res0 = ICH_HCR_EL2_RES0;
+	resx.res1 = ICH_HCR_EL2_RES1;
 	if (!(kvm_vgic_global_state.ich_vtr_el2 & ICH_VTR_EL2_TDS))
-		res0 |= ICH_HCR_EL2_TDIR;
+		resx.res0 |= ICH_HCR_EL2_TDIR;
 	/* No GICv4 is presented to the guest */
-	res0 |= ICH_HCR_EL2_DVIM | ICH_HCR_EL2_vSGIEOICount;
-	set_sysreg_masks(kvm, ICH_HCR_EL2, res0, res1);
+	resx.res0 |= ICH_HCR_EL2_DVIM | ICH_HCR_EL2_vSGIEOICount;
+	set_sysreg_masks(kvm, ICH_HCR_EL2, resx);
 
 	/* VNCR_EL2 */
-	set_sysreg_masks(kvm, VNCR_EL2, VNCR_EL2_RES0, VNCR_EL2_RES1);
+	resx.res0 = VNCR_EL2_RES0;
+	resx.res1 = VNCR_EL2_RES1;
+	set_sysreg_masks(kvm, VNCR_EL2, resx);
 
 out:
 	for (enum vcpu_sysreg sr = __SANITISED_REG_START__; sr < NR_SYS_REGS; sr++)
-- 
2.47.3


