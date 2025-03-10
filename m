Return-Path: <kvm+bounces-40632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E5AF3A59443
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 13:26:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD12F3A9548
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 12:26:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7238822A80F;
	Mon, 10 Mar 2025 12:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GDhTVIWL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B1F22A4E9;
	Mon, 10 Mar 2025 12:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741609515; cv=none; b=ZCqz+NqHeOpm5L/Tp9JTXEcIRsIUxHavw6lqA4ZMfnV5Y9uItx7VoFfH2mYhwqWu/4ZwVlfKlvQXQY4cpTSfU9r5/uF3CMiExW1/yaP8hSpyTIMhfWTDGnfMy7V7RQqHTVn7orSzswLKnrips8HY9Q9k75FiMcSn82INanNRRXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741609515; c=relaxed/simple;
	bh=JMcQT9nqn10bS2fDlKJ5y+ZpRjV+00pMYwnQIDjZGFA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Pv6ahl0ppXV2kCFsgEpnkiZbTau/KR/QL/mFGaY1eaERNIkZEYp9GaEXd+y9x2ljNrdk/0rxls6mJoanayST3BbZ2B8UA6/2aH7GL0YYHViDhzMdES0zc89W61XMvEm8k9vrOwCKwGQLSTdmPLPTT6aB+Hn4aJOMsafU94kDWlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GDhTVIWL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DB0C4AF0B;
	Mon, 10 Mar 2025 12:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741609515;
	bh=JMcQT9nqn10bS2fDlKJ5y+ZpRjV+00pMYwnQIDjZGFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GDhTVIWLnScv8xJQgUrQEJ9/CZCDfThLiu0gAG58HSLHlT2irCbOMJseAQJhZFhKJ
	 BwRyVNxZ9ffRLmLqTFDWicf2pGBaLoIh09GF8H7an/iYc3AjOjtdbqN/CHlc4YUlmt
	 Zd1n0QMsWc7QO71Vmoz3bsZcSLBmY45Qk5CTJnCBTkAp3OiVoinXhSffqVBlz5QRrN
	 ZqHLCQvrtqzktq4Fml9+ikjDuDhKAnpE9ZlDU47okKCD1KkYhmN0+3sdiNE1it8LD/
	 vXecRxPUQWhWSYPuppX2aWGuLxRb6RJ9pX8f8kDoXTue40hQsQ1oUHqw02Wlc1zIv8
	 kd6faLkZ07AdA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1trcC1-00CAea-Kt;
	Mon, 10 Mar 2025 12:25:13 +0000
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
Subject: [PATCH v2 14/23] KVM: arm64: Use computed FGT masks to setup FGT registers
Date: Mon, 10 Mar 2025 12:24:56 +0000
Message-Id: <20250310122505.2857610-15-maz@kernel.org>
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

Flip the hyervisor FGT configuration over to the computed FGT
masks.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 45 +++++++++++++++++++++----
 1 file changed, 38 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index c4e12516f6466..b3f02fa5ab79e 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -65,12 +65,41 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
 	}
 }
 
+#define reg_to_fgt_masks(reg)						\
+	({								\
+		struct fgt_masks *m;					\
+		switch(reg) {						\
+		case HFGRTR_EL2:					\
+			m = &hfgrtr_masks;				\
+			break;						\
+		case HFGWTR_EL2:					\
+			m = &hfgwtr_masks;				\
+			break;						\
+		case HFGITR_EL2:					\
+			m = &hfgitr_masks;				\
+			break;						\
+		case HDFGRTR_EL2:					\
+			m = &hdfgrtr_masks;				\
+			break;						\
+		case HDFGWTR_EL2:					\
+			m = &hdfgwtr_masks;				\
+			break;						\
+		case HAFGRTR_EL2:					\
+			m = &hafgrtr_masks;				\
+			break;						\
+		default:						\
+			BUILD_BUG_ON(1);				\
+		}							\
+									\
+		m;							\
+	})
+
 #define compute_clr_set(vcpu, reg, clr, set)				\
 	do {								\
-		u64 hfg;						\
-		hfg = __vcpu_sys_reg(vcpu, reg) & ~__ ## reg ## _RES0;	\
-		set |= hfg & __ ## reg ## _MASK; 			\
-		clr |= ~hfg & __ ## reg ## _nMASK; 			\
+		u64 hfg = __vcpu_sys_reg(vcpu, reg);			\
+		struct fgt_masks *m = reg_to_fgt_masks(reg);		\
+		set |= hfg & m->mask;					\
+		clr |= ~hfg & m->nmask;					\
 	} while(0)
 
 #define reg_to_fgt_group_id(reg)					\
@@ -101,12 +130,14 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
 #define compute_undef_clr_set(vcpu, kvm, reg, clr, set)			\
 	do {								\
 		u64 hfg = kvm->arch.fgu[reg_to_fgt_group_id(reg)];	\
-		set |= hfg & __ ## reg ## _MASK;			\
-		clr |= hfg & __ ## reg ## _nMASK; 			\
+		struct fgt_masks *m = reg_to_fgt_masks(reg);		\
+		set |= hfg & m->mask;					\
+		clr |= hfg & m->nmask;					\
 	} while(0)
 
 #define update_fgt_traps_cs(hctxt, vcpu, kvm, reg, clr, set)		\
 	do {								\
+		struct fgt_masks *m = reg_to_fgt_masks(reg);		\
 		u64 c = clr, s = set;					\
 		u64 val;						\
 									\
@@ -116,7 +147,7 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
 									\
 		compute_undef_clr_set(vcpu, kvm, reg, c, s);		\
 									\
-		val = __ ## reg ## _nMASK;				\
+		val = m->nmask;						\
 		val |= s;						\
 		val &= ~c;						\
 		write_sysreg_s(val, SYS_ ## reg);			\
-- 
2.39.2


