Return-Path: <kvm+bounces-25839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 343A896B473
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 10:25:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BA549B252A2
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 08:24:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3254186600;
	Wed,  4 Sep 2024 08:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VA4vu3BP"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D766A17C9AA;
	Wed,  4 Sep 2024 08:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725438280; cv=none; b=AwKHxxKH3Dd2LYlOk6BEJgCUOWwmga8thy2Eh21Hgo7UW9ofkL0VPAauybUTxpNDqojkttUgZl42NniFy/DWI0FfzOc4a7GBJsql9aGFYwgyTeTbJJkSrPE6pO8bmP0VaJ1Uq+MdHGtR8CSm9XWMVoqOO4OomaghnDgQG5f33c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725438280; c=relaxed/simple;
	bh=Fhau2/U9M+BMgStDw+xZRk0wrsOilXlXn/q0zd3fcrw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lNLjq3vv3Nz1DmE/JR/4swdGXrTAEK5O4hnpgE2vu75vVQQ3oPQPGHRAPL6skegibV7Y48XtRz4zd2FoegAkYEhPJAyUx/FeDBjJYVqdQ08Q93P+MaHHIO8TT98evGxU1guB83esrlhlsgaQekorWg/HNlnyIdkjxWfzQYzdQVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VA4vu3BP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D573C4CEC8;
	Wed,  4 Sep 2024 08:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725438280;
	bh=Fhau2/U9M+BMgStDw+xZRk0wrsOilXlXn/q0zd3fcrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VA4vu3BPknG/Obx0pIjackogjRv5u15j+TfoA+6I8De+vJGJoZkn2Qewj2a4EMlhF
	 6Szr1TPenZP55XizUZNyvSHWJcTknL/8k4JO49FrPcBmHaT4XyXtbCIdRdjGCEoCJv
	 Syrk2DV5UJQ/bz7+9pk06uLfatWG7LAjaGxfMlEnpWotn+ZXa/BQPx8oa0xRM7jQAG
	 k5Z52WyUmpBq24z7kW/devw2p2ZEk/jY54fCLu4nqEl16jIQL/KC3iKnJ1ao+hPYyK
	 CWFmvR8V6gHO0Ny6DK59XsRWuP/vJU6Rp4W4stNpa4bTSM1cpMfWAfwRZwHuQ9Heqx
	 VRuptPWSKW/lQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sllJe-009VF3-R3;
	Wed, 04 Sep 2024 09:24:38 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 3/3] KVM: arm64: Get rid of REG_HIDDEN_USER visibility qualifier
Date: Wed,  4 Sep 2024 09:24:19 +0100
Message-Id: <20240904082419.1982402-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240904082419.1982402-1-maz@kernel.org>
References: <20240904082419.1982402-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that REG_HIDDEN_USER has no direct user anymore, remove it
entirely and update all users of sysreg_hidden_user() to call
sysreg_hidden() instead.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 17 +++--------------
 arch/arm64/kvm/sys_regs.h | 14 ++------------
 2 files changed, 5 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2586ad29eaa0..09a6a45efb49 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2094,17 +2094,6 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
 #define EL2_REG_VNCR(name, rst, v)	EL2_REG(name, bad_vncr_trap, rst, v)
 #define EL2_REG_REDIR(name, rst, v)	EL2_REG(name, bad_redir_trap, rst, v)
 
-/*
- * EL{0,1}2 registers are the EL2 view on an EL0 or EL1 register when
- * HCR_EL2.E2H==1, and only in the sysreg table for convenience of
- * handling traps. Given that, they are always hidden from userspace.
- */
-static unsigned int hidden_user_visibility(const struct kvm_vcpu *vcpu,
-					   const struct sys_reg_desc *rd)
-{
-	return REG_HIDDEN_USER;
-}
-
 /*
  * Since reset() callback and field val are not used for idregs, they will be
  * used for specific purposes for idregs.
@@ -4364,7 +4353,7 @@ int kvm_sys_reg_get_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 	int ret;
 
 	r = id_to_sys_reg_desc(vcpu, reg->id, table, num);
-	if (!r || sysreg_hidden_user(vcpu, r))
+	if (!r || sysreg_hidden(vcpu, r))
 		return -ENOENT;
 
 	if (r->get_user) {
@@ -4408,7 +4397,7 @@ int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 		return -EFAULT;
 
 	r = id_to_sys_reg_desc(vcpu, reg->id, table, num);
-	if (!r || sysreg_hidden_user(vcpu, r))
+	if (!r || sysreg_hidden(vcpu, r))
 		return -ENOENT;
 
 	if (sysreg_user_write_ignore(vcpu, r))
@@ -4494,7 +4483,7 @@ static int walk_one_sys_reg(const struct kvm_vcpu *vcpu,
 	if (!(rd->reg || rd->get_user))
 		return 0;
 
-	if (sysreg_hidden_user(vcpu, rd))
+	if (sysreg_hidden(vcpu, rd))
 		return 0;
 
 	if (!copy_reg_to_user(rd, uind))
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index dfb2ec83b284..1d94ed6efad2 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -95,9 +95,8 @@ struct sys_reg_desc {
 };
 
 #define REG_HIDDEN		(1 << 0) /* hidden from userspace and guest */
-#define REG_HIDDEN_USER		(1 << 1) /* hidden from userspace only */
-#define REG_RAZ			(1 << 2) /* RAZ from userspace and guest */
-#define REG_USER_WI		(1 << 3) /* WI from userspace only */
+#define REG_RAZ			(1 << 1) /* RAZ from userspace and guest */
+#define REG_USER_WI		(1 << 2) /* WI from userspace only */
 
 static __printf(2, 3)
 inline void print_sys_reg_msg(const struct sys_reg_params *p,
@@ -165,15 +164,6 @@ static inline bool sysreg_hidden(const struct kvm_vcpu *vcpu,
 	return sysreg_visibility(vcpu, r) & REG_HIDDEN;
 }
 
-static inline bool sysreg_hidden_user(const struct kvm_vcpu *vcpu,
-				      const struct sys_reg_desc *r)
-{
-	if (likely(!r->visibility))
-		return false;
-
-	return r->visibility(vcpu, r) & (REG_HIDDEN | REG_HIDDEN_USER);
-}
-
 static inline bool sysreg_visible_as_raz(const struct kvm_vcpu *vcpu,
 					 const struct sys_reg_desc *r)
 {
-- 
2.39.2


