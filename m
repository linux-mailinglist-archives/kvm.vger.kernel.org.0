Return-Path: <kvm+bounces-45639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B82B7AACB62
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 18:47:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17CCD1BC81DE
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:47:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B7B82882D0;
	Tue,  6 May 2025 16:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tYfljZ1K"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F56287511;
	Tue,  6 May 2025 16:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746549854; cv=none; b=DLVLMV8szdVxjAIoqn61jT+XjxTpHQfEkbjoC3nkz4yEuxX/O5pY4NykZuzn7CkyYeutP/T8wl52SQh1PS2HmJbszFnyUtQ9pSnGBYkpvu3NUZmcNpn2ZrEo1a+ZENdyP8ju0NTuRhEKsVyW6HhT3YzPRMCaq23VQgdLu0gUyek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746549854; c=relaxed/simple;
	bh=ceQ5h51pgohC6eDTheM4F75C9biUzOEEkPGcwL/xiRg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=THgwYGn62/NXJW8jzlwEWC4nJS3GhGOd2h3FaTwX1o1uBDGo4iSF/suwAX0b7UsWfPsts3FM4jTBxoiYeWLSJKK4JWBrcqjTnChouU+fpQXFENw9/+HZsbTwdx4riAk8KpfSaJvVgNY8mPJ07cqaJ6lAD39mm33W/pqIKElufg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tYfljZ1K; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1843CC4CEF1;
	Tue,  6 May 2025 16:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746549854;
	bh=ceQ5h51pgohC6eDTheM4F75C9biUzOEEkPGcwL/xiRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tYfljZ1KHDOy8Uq0SkDvg9+cCfthb4EVLF4GeuaBmY893DuwZJl5VHs+zHbgzmIHc
	 A8dg4w1TA0ANOg/cNucDo67gXaTmziq9qyz58y/vLdZuSDQoRmgZJZhk27RZScDv/s
	 N6wpVWaFHY+4j+09ODnluCJ+Vy0Rx22JHyl+atJoR/GhkBVn0CKLGWaUBuOzDFAgYc
	 S8cW7HaP2cf0VkO7VOM99T5dQl7aUDE4EwrkF67NxQCHqJcsLbg7wM40/jEeVrbgZr
	 tO31hqkVgtrtGqBu68z0Xc6RaCiIzyYgtoJyOAEYfZB/3k3JENyGXwbzAUS2scoZ4W
	 eaAiednFd4Swg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uCLOu-00CJkN-Bb;
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
Subject: [PATCH v4 27/43] KVM: arm64: Use computed FGT masks to setup FGT registers
Date: Tue,  6 May 2025 17:43:32 +0100
Message-Id: <20250506164348.346001-28-maz@kernel.org>
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

Flip the hyervisor FGT configuration over to the computed FGT
masks.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 45 +++++++++++++++++++++----
 1 file changed, 38 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 925a3288bd5be..e8645375499df 100644
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


