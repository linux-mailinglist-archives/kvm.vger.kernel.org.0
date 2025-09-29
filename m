Return-Path: <kvm+bounces-59006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 861F3BA9F16
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:06:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22F87189C585
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 16:06:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 753E430E0E2;
	Mon, 29 Sep 2025 16:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KLSnMbRb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5950D30DD13;
	Mon, 29 Sep 2025 16:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759161907; cv=none; b=J0nGdvYbJCZRvbyj6gJ372hwwnuSZy4HWNemA6SjsKkmB694vdkkTHxlQgyWYCR4hcbD1xEJBoLJuw1lIxWHNlMRBj2rUo/X0qOfkgClkqBkZqdJra6I/onnSTI2/IMZILRMWeeejUFZ5UNp5uCBvJu5ysRYXJSkFUslQhnyVyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759161907; c=relaxed/simple;
	bh=l+H5Z+otL/wcs/vzwPMAF3OWoHvg6UJ42LI358e1qcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nzai3yC5NlTKirZXhMJRbcSW+BFFZwkG54WxHlsiAvnEzeQ+hrU0qhGWwP02aX8LAIjkrH7nR9gxylnypVPQCP73rnldSn9msGCwYJQNzhVDr/qGRCdcIQyPtx2hnXeAqzOB9JeiDN5O5i1osuIrAIxkzPB/M8HqYk39V8sw76A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KLSnMbRb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A72CC4CEF4;
	Mon, 29 Sep 2025 16:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759161907;
	bh=l+H5Z+otL/wcs/vzwPMAF3OWoHvg6UJ42LI358e1qcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KLSnMbRbkVfBINQ2qteCNrqEidcv7LWJL7o2GAMNpwrka7dEX86CneOAk48nZ7NB6
	 MwHC2gUTAix72z4uykC0uQZ73OHjIBr/XynRO3ZQuWHWYQgx99e6OAS0bYXZ/co2mB
	 +yzQ/IuMWqIE55wp9fDjQE9vYtgg9PehMXCskXQ20wTncJDwk/eXRv1ub0X/JzWIip
	 vRxhN6FPSaj6Ulg0OLVZnzPO+uy62OytYzOrTVMDrLb1qq6N740ZhINmJYE3YueXeS
	 e3bq1HbHk+nb6klCfZ8e7TdNSZEkAY36fbpYsaI0/XSb0WCLVpl9q11QzrOy2XLx6k
	 jMh54S8yD7Fzg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v3GN7-0000000AHqo-0tsR;
	Mon, 29 Sep 2025 16:05:05 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 08/13] KVM: arm64: Move CNT*CT_EL0 userspace accessors to generic infrastructure
Date: Mon, 29 Sep 2025 17:04:52 +0100
Message-ID: <20250929160458.3351788-9-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250929160458.3351788-1-maz@kernel.org>
References: <20250929160458.3351788-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Moving the counter registers is a bit more involved than for the control
and comparator (there is no shadow data for the counter), but still
pretty manageable.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/guest.c    |  7 -------
 arch/arm64/kvm/sys_regs.c | 34 +++++++++++++++++++++++++++++++---
 2 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index c23ec9be4ce27..138e5e2dc10c8 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -592,19 +592,12 @@ static unsigned long num_core_regs(const struct kvm_vcpu *vcpu)
 }
 
 static const u64 timer_reg_list[] = {
-	KVM_REG_ARM_TIMER_CNT,
-	KVM_REG_ARM_PTIMER_CNT,
 };
 
 #define NUM_TIMER_REGS ARRAY_SIZE(timer_reg_list)
 
 static bool is_timer_reg(u64 index)
 {
-	switch (index) {
-	case KVM_REG_ARM_TIMER_CNT:
-	case KVM_REG_ARM_PTIMER_CNT:
-		return true;
-	}
 	return false;
 }
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 68e88d5c0dfb5..e67eb39ddc118 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1605,12 +1605,38 @@ static int arch_timer_set_user(struct kvm_vcpu *vcpu,
 	case SYS_CNTHP_CTL_EL2:
 		val &= ~ARCH_TIMER_CTRL_IT_STAT;
 		break;
+	case SYS_CNTVCT_EL0:
+		if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags))
+			timer_set_offset(vcpu_vtimer(vcpu), kvm_phys_timer_read() - val);
+		return 0;
+	case SYS_CNTPCT_EL0:
+		if (!test_bit(KVM_ARCH_FLAG_VM_COUNTER_OFFSET, &vcpu->kvm->arch.flags))
+			timer_set_offset(vcpu_ptimer(vcpu), kvm_phys_timer_read() - val);
+		return 0;
 	}
 
 	__vcpu_assign_sys_reg(vcpu, rd->reg, val);
 	return 0;
 }
 
+static int arch_timer_get_user(struct kvm_vcpu *vcpu,
+			       const struct sys_reg_desc *rd,
+			       u64 *val)
+{
+	switch (reg_to_encoding(rd)) {
+	case SYS_CNTVCT_EL0:
+		*val = kvm_phys_timer_read() - timer_get_offset(vcpu_vtimer(vcpu));
+		break;
+	case SYS_CNTPCT_EL0:
+		*val = kvm_phys_timer_read() - timer_get_offset(vcpu_ptimer(vcpu));
+		break;
+	default:
+		*val = __vcpu_sys_reg(vcpu, rd->reg);
+	}
+
+	return 0;
+}
+
 static s64 kvm_arm64_ftr_safe_value(u32 id, const struct arm64_ftr_bits *ftrp,
 				    s64 new, s64 cur)
 {
@@ -2539,7 +2565,7 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
 
 #define TIMER_REG(name, vis)					   \
 	SYS_REG_USER_FILTER(name, access_arch_timer, reset_val, 0, \
-			    NULL, arch_timer_set_user, vis)
+			    arch_timer_get_user, arch_timer_set_user, vis)
 
 /*
  * Since reset() callback and field val are not used for idregs, they will be
@@ -3506,8 +3532,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	AMU_AMEVTYPER1_EL0(14),
 	AMU_AMEVTYPER1_EL0(15),
 
-	{ SYS_DESC(SYS_CNTPCT_EL0), access_arch_timer },
-	{ SYS_DESC(SYS_CNTVCT_EL0), access_arch_timer },
+	{ SYS_DESC(SYS_CNTPCT_EL0), .access = access_arch_timer,
+	  .get_user = arch_timer_get_user, .set_user = arch_timer_set_user },
+	{ SYS_DESC(SYS_CNTVCT_EL0), .access = access_arch_timer,
+	  .get_user = arch_timer_get_user, .set_user = arch_timer_set_user },
 	{ SYS_DESC(SYS_CNTPCTSS_EL0), access_arch_timer },
 	{ SYS_DESC(SYS_CNTVCTSS_EL0), access_arch_timer },
 	{ SYS_DESC(SYS_CNTP_TVAL_EL0), access_arch_timer },
-- 
2.47.3


