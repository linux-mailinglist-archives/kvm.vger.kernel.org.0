Return-Path: <kvm+bounces-37721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D635BA2F791
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 19:44:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 08DAB18843C2
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2025 18:44:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 535D2257AED;
	Mon, 10 Feb 2025 18:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ao+s8h7J"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7942586E5;
	Mon, 10 Feb 2025 18:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739212922; cv=none; b=gcT0q/Y1LZmuV33GSiZZWuZkd8zlrKHkA1PyICNqhJbo7AMCrMt5e/qnzMN9SpkZxA8eDoTUzqXPf7FM8tDrJ/zoIK8n7YCiQCB2fs8ddHgScst0fCJo8tLlZ9hZ+3ese+rF4g/5gALRayftxiSxgYjaVaGZyFbyuneD1/zleB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739212922; c=relaxed/simple;
	bh=hbjFazCEEo3fkm2gGkC9A0y65xBRyHIVWr2MdBymzJ8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=H7M9yXiSzhy99ZbOhRETW4Jl/wZTsU/mgqqPRWAe4IYmwp8Tmk+goEU8immGWeSLJH5gawYfMGN0GJzmmlcFBk1hPNRow+pBoiw326N/psxbuTB3hhImzbDOEAmTK0zfZPxyzyyVzlACujY4yJQYwB7dN9aydvT1y8UMfDBTSsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ao+s8h7J; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBDE9C4CED1;
	Mon, 10 Feb 2025 18:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739212921;
	bh=hbjFazCEEo3fkm2gGkC9A0y65xBRyHIVWr2MdBymzJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ao+s8h7Jx7vbNxTFkG13PupBKSY63QRN0LLdDCz9qzIxADkFLejTSt9ZCP+EdxY6r
	 j09NKvzAbx1a0gerU4o5gv11VHoMA8QVbLHJtELFlJ3b/IV5a1qcfjjrte/WshH9RS
	 6jQUybmupoSIoZiKMgUjPoso4d7Jr4/SgmDqNj5YjLGisGJuX6xR2JQVUOhmrQibQa
	 a9J1QHHjZDK52T35BvnmD5uW7k2D2jJGcJS5mzSJol1sJ/wsUlPOiUveD4JPVBihAv
	 /sfNGAJC9CsScuw/Y4CYudF66zbJlmYaRoa5kzgSDcw2QzDlnviUGFZI8CSdhARo8s
	 xeuvKGD0+QzYQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1thYjI-002g2I-1I;
	Mon, 10 Feb 2025 18:42:00 +0000
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
Subject: [PATCH 12/18] KVM: arm64: Use computed FGT masks to setup FGT registers
Date: Mon, 10 Feb 2025 18:41:43 +0000
Message-Id: <20250210184150.2145093-13-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250210184150.2145093-1-maz@kernel.org>
References: <20250210184150.2145093-1-maz@kernel.org>
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
index 29f4110d3758e..f9cf5985561ab 100644
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


