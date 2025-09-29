Return-Path: <kvm+bounces-59005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 615A8BA9F2E
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:06:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F28A1C6A89
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 16:06:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7563E30E0EB;
	Mon, 29 Sep 2025 16:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QYk1Jx3C"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043F630CDA0;
	Mon, 29 Sep 2025 16:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759161907; cv=none; b=oil332WpUSbcdkbZpDgiyx9+28B6qntwws1flgGtuo3zM4/+GcAXXBm0Wi+GIwb8fv0wiDPdE2ULHnmhmqXVPCvrn2h980SfIRY6gfU2cY6XL7f4F8i/UUwP/3IsJS2vKvtzGX8XocnZrCxx94zB2tYqKnNtqjTPAtWomcYjWeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759161907; c=relaxed/simple;
	bh=FYkTMaNMt2gav9jtrgpiFbBiAEdFV/eKHpXBBf6r0zI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=laT0/YlbKHlxGF7ioDQ9HpDsPzGLWUKOy19wn3eifiKtfCTSxqlHZjhaUSrJt/2L07NOUVJdEjKPCzRq/6a7gdTlS7xz1FCXWKYuIcGnjnZJ+ECzPYpcWyUla9tcwwVSDgxG1+TDLoj3CAbPBJTaxXajF7Lyf3n7OuCAwRkGzbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QYk1Jx3C; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA67C4CEF4;
	Mon, 29 Sep 2025 16:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759161906;
	bh=FYkTMaNMt2gav9jtrgpiFbBiAEdFV/eKHpXBBf6r0zI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QYk1Jx3C9g/vRs0glnODl3QGMP5q04jeBbuom1x5rZAzaSmTNgIRrKxL+hogX/iTV
	 PbnPqQp37JzMUk4Qhw5fyrjdvQO9MHz/bOHLxxH/HXxO0LUAXuNapWtPuII7liqktX
	 1TcmW4+czUMy9gf+peGJL8bL8X5oG5Di4WXmQ5y1PtrzyTHo3/UOUdQjP+dqoQOQwY
	 vGtF370TQ1kH48zonUFxHHZ2wNzrUqbRIqJh4seY6lP9iQlbvEK3N6xzKPYGMZ8xF9
	 wmDLMCtXlEoJOrucz6rIGtAH2w+3xE5kRWduBq9zgLecprKOtuB7s1Uwv8WWcgGmfE
	 MrMFgcBHan8pg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1v3GN6-0000000AHqo-3IjN;
	Mon, 29 Sep 2025 16:05:04 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 06/13] KVM: arm64: Move CNT*_CTL_EL0 userspace accessors to generic infrastructure
Date: Mon, 29 Sep 2025 17:04:50 +0100
Message-ID: <20250929160458.3351788-7-maz@kernel.org>
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

Remove the handling of CNT*_CTL_EL0 from guest.c, and move it to
sys_regs.c, using a new TIMER_REG() definition to encapsulate it.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/guest.c    |  4 ----
 arch/arm64/kvm/sys_regs.c | 36 +++++++++++++++++++++++++++++++-----
 2 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 16ba5e9ac86c3..dea648706fd52 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -592,10 +592,8 @@ static unsigned long num_core_regs(const struct kvm_vcpu *vcpu)
 }
 
 static const u64 timer_reg_list[] = {
-	KVM_REG_ARM_TIMER_CTL,
 	KVM_REG_ARM_TIMER_CNT,
 	KVM_REG_ARM_TIMER_CVAL,
-	KVM_REG_ARM_PTIMER_CTL,
 	KVM_REG_ARM_PTIMER_CNT,
 	KVM_REG_ARM_PTIMER_CVAL,
 };
@@ -605,10 +603,8 @@ static const u64 timer_reg_list[] = {
 static bool is_timer_reg(u64 index)
 {
 	switch (index) {
-	case KVM_REG_ARM_TIMER_CTL:
 	case KVM_REG_ARM_TIMER_CNT:
 	case KVM_REG_ARM_TIMER_CVAL:
-	case KVM_REG_ARM_PTIMER_CTL:
 	case KVM_REG_ARM_PTIMER_CNT:
 	case KVM_REG_ARM_PTIMER_CVAL:
 		return true;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 8e6f50f54b4bf..d97aacf4c1dc9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1594,6 +1594,23 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static int arch_timer_set_user(struct kvm_vcpu *vcpu,
+			       const struct sys_reg_desc *rd,
+			       u64 val)
+{
+	switch (reg_to_encoding(rd)) {
+	case SYS_CNTV_CTL_EL0:
+	case SYS_CNTP_CTL_EL0:
+	case SYS_CNTHV_CTL_EL2:
+	case SYS_CNTHP_CTL_EL2:
+		val &= ~ARCH_TIMER_CTRL_IT_STAT;
+		break;
+	}
+
+	__vcpu_assign_sys_reg(vcpu, rd->reg, val);
+	return 0;
+}
+
 static s64 kvm_arm64_ftr_safe_value(u32 id, const struct arm64_ftr_bits *ftrp,
 				    s64 new, s64 cur)
 {
@@ -2496,15 +2513,20 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
 			"trap of EL2 register redirected to EL1");
 }
 
-#define EL2_REG_FILTERED(name, acc, rst, v, filter) {	\
+#define SYS_REG_USER_FILTER(name, acc, rst, v, gu, su, filter) { \
 	SYS_DESC(SYS_##name),			\
 	.access = acc,				\
 	.reset = rst,				\
 	.reg = name,				\
+	.get_user = gu,				\
+	.set_user = su,				\
 	.visibility = filter,			\
 	.val = v,				\
 }
 
+#define EL2_REG_FILTERED(name, acc, rst, v, filter)	\
+	SYS_REG_USER_FILTER(name, acc, rst, v, NULL, NULL, filter)
+
 #define EL2_REG(name, acc, rst, v)			\
 	EL2_REG_FILTERED(name, acc, rst, v, el2_visibility)
 
@@ -2515,6 +2537,10 @@ static bool bad_redir_trap(struct kvm_vcpu *vcpu,
 	EL2_REG_VNCR_FILT(name, hidden_visibility)
 #define EL2_REG_REDIR(name, rst, v)	EL2_REG(name, bad_redir_trap, rst, v)
 
+#define TIMER_REG(name, vis)					   \
+	SYS_REG_USER_FILTER(name, access_arch_timer, reset_val, 0, \
+			    NULL, arch_timer_set_user, vis)
+
 /*
  * Since reset() callback and field val are not used for idregs, they will be
  * used for specific purposes for idregs.
@@ -3485,11 +3511,11 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_CNTPCTSS_EL0), access_arch_timer },
 	{ SYS_DESC(SYS_CNTVCTSS_EL0), access_arch_timer },
 	{ SYS_DESC(SYS_CNTP_TVAL_EL0), access_arch_timer },
-	{ SYS_DESC(SYS_CNTP_CTL_EL0), access_arch_timer },
+	TIMER_REG(CNTP_CTL_EL0, NULL),
 	{ SYS_DESC(SYS_CNTP_CVAL_EL0), access_arch_timer },
 
 	{ SYS_DESC(SYS_CNTV_TVAL_EL0), access_arch_timer },
-	{ SYS_DESC(SYS_CNTV_CTL_EL0), access_arch_timer },
+	TIMER_REG(CNTV_CTL_EL0, NULL),
 	{ SYS_DESC(SYS_CNTV_CVAL_EL0), access_arch_timer },
 
 	/* PMEVCNTRn_EL0 */
@@ -3688,11 +3714,11 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG_VNCR(CNTVOFF_EL2, reset_val, 0),
 	EL2_REG(CNTHCTL_EL2, access_rw, reset_val, 0),
 	{ SYS_DESC(SYS_CNTHP_TVAL_EL2), access_arch_timer },
-	EL2_REG(CNTHP_CTL_EL2, access_arch_timer, reset_val, 0),
+	TIMER_REG(CNTHP_CTL_EL2, el2_visibility),
 	EL2_REG(CNTHP_CVAL_EL2, access_arch_timer, reset_val, 0),
 
 	{ SYS_DESC(SYS_CNTHV_TVAL_EL2), access_arch_timer, .visibility = cnthv_visibility },
-	EL2_REG_FILTERED(CNTHV_CTL_EL2, access_arch_timer, reset_val, 0, cnthv_visibility),
+	TIMER_REG(CNTHV_CTL_EL2, cnthv_visibility),
 	EL2_REG_FILTERED(CNTHV_CVAL_EL2, access_arch_timer, reset_val, 0, cnthv_visibility),
 
 	{ SYS_DESC(SYS_CNTKCTL_EL12), access_cntkctl_el12 },
-- 
2.47.3


