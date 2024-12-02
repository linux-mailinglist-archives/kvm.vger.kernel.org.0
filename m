Return-Path: <kvm+bounces-32828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E7B19E09BA
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 18:22:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E9D2162E3D
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 17:22:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 772B01DBB0C;
	Mon,  2 Dec 2024 17:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z2FHhOeZ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDD51D8DFE;
	Mon,  2 Dec 2024 17:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733160138; cv=none; b=VzmT7S+7EvIigTqefbI4Ds1/1yrbbOwce6s6SU074ORvzJhhnWGY96a3Ah9cPFRGqKNO5GOoSHTbzpmB5+6/afwks6duprw/kRLjdDwMwWD0ALrDXBfZqXnIZdb0bKBtbADQ44zQB7yCY+Bcicg8jpkOMBct1t4LjEGhgbSkY1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733160138; c=relaxed/simple;
	bh=42QPzG6jqI1WKcHLJXMq8RvCPT15C7DIifzJ6603+4M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DtQyLNqoM2hQbmanKLcg7sNv2oEhlAsqxgwV73cWVl5RHIXKU+YMaX+dTj4zBpjEVlqBj3UOP/dk8fkfkBeILuZvTazr2qjTI9qR3vhBOXQOrldob9AIsSjRdC+FqR3MSFeQe3yU2YaakEeIpqL8mwxIb+gzGBpSRJML/iSZ9zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z2FHhOeZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2E0C4CED6;
	Mon,  2 Dec 2024 17:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733160138;
	bh=42QPzG6jqI1WKcHLJXMq8RvCPT15C7DIifzJ6603+4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z2FHhOeZP2Idsb/L6YCuFU+YVD3F7cmdvreTg4CExRhUMhqMmkuGkvDWUGwxetNYS
	 a2IVdIiWNL3QT3KGIyBozwQTrCZw0LUX5p1zlwOZbQHobMYj2vvsz7yXzCJRCYiiAS
	 uJ5aHFrlUHZsjefbwMasLW9ZKTeeOXnUhMLcxJ2mAVw/aqknphUibQ9XDmSq98PylD
	 ACEk4RGSLraCc2Dc+mVdUW3eMhuV1xkeUpa7eY/PaHzD4K1eHZ+ageHu+4qkjDWeyx
	 OCFQQgGjVN8VPGIw1dI9vh0BGMOjOnU+Ch98f08WUEkLlMsd95AWrEJSd/Kyc9coIu
	 emPEwUfhR9lVw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tIA7j-00HQcf-Tx;
	Mon, 02 Dec 2024 17:22:16 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Christoffer Dall <christoffer.dall@arm.com>
Subject: [PATCH 01/11] KVM: arm64: nv: Add handling of EL2-specific timer registers
Date: Mon,  2 Dec 2024 17:21:24 +0000
Message-Id: <20241202172134.384923-2-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241202172134.384923-1-maz@kernel.org>
References: <20241202172134.384923-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andersson@kernel.org, christoffer.dall@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add the required handling for EL2 and EL02 registers, as
well as EL1 registers used in the E2H context. This includes
handling the virtual timer accesses when CNTHCTL_EL2.EL1TVT
or CNTHCTL_EL2.EL1TVCT are set.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h      |   4 +
 arch/arm64/kvm/sys_regs.c            | 143 +++++++++++++++++++++++++++
 include/clocksource/arm_arch_timer.h |   2 +
 3 files changed, 149 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index b8303a83c0bff..2ed33737c7a99 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -477,6 +477,7 @@
 #define SYS_CNTFRQ_EL0			sys_reg(3, 3, 14, 0, 0)
 
 #define SYS_CNTPCT_EL0			sys_reg(3, 3, 14, 0, 1)
+#define SYS_CNTVCT_EL0			sys_reg(3, 3, 14, 0, 2)
 #define SYS_CNTPCTSS_EL0		sys_reg(3, 3, 14, 0, 5)
 #define SYS_CNTVCTSS_EL0		sys_reg(3, 3, 14, 0, 6)
 
@@ -484,14 +485,17 @@
 #define SYS_CNTP_CTL_EL0		sys_reg(3, 3, 14, 2, 1)
 #define SYS_CNTP_CVAL_EL0		sys_reg(3, 3, 14, 2, 2)
 
+#define SYS_CNTV_TVAL_EL0		sys_reg(3, 3, 14, 3, 0)
 #define SYS_CNTV_CTL_EL0		sys_reg(3, 3, 14, 3, 1)
 #define SYS_CNTV_CVAL_EL0		sys_reg(3, 3, 14, 3, 2)
 
 #define SYS_AARCH32_CNTP_TVAL		sys_reg(0, 0, 14, 2, 0)
 #define SYS_AARCH32_CNTP_CTL		sys_reg(0, 0, 14, 2, 1)
 #define SYS_AARCH32_CNTPCT		sys_reg(0, 0, 0, 14, 0)
+#define SYS_AARCH32_CNTVCT		sys_reg(0, 1, 0, 14, 0)
 #define SYS_AARCH32_CNTP_CVAL		sys_reg(0, 2, 0, 14, 0)
 #define SYS_AARCH32_CNTPCTSS		sys_reg(0, 8, 0, 14, 0)
+#define SYS_AARCH32_CNTVCTSS		sys_reg(0, 9, 0, 14, 0)
 
 #define __PMEV_op2(n)			((n) & 0x7)
 #define __CNTR_CRm(n)			(0x8 | (((n) >> 3) & 0x3))
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 83c6b4a07ef56..986e63d4f9faa 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1412,26 +1412,146 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 
 	switch (reg) {
 	case SYS_CNTP_TVAL_EL0:
+		if (is_hyp_ctxt(vcpu) && vcpu_el2_e2h_is_set(vcpu))
+			tmr = TIMER_HPTIMER;
+		else
+			tmr = TIMER_PTIMER;
+		treg = TIMER_REG_TVAL;
+		break;
+
+	case SYS_CNTV_TVAL_EL0:
+		if (is_hyp_ctxt(vcpu) && vcpu_el2_e2h_is_set(vcpu))
+			tmr = TIMER_HVTIMER;
+		else
+			tmr = TIMER_VTIMER;
+		treg = TIMER_REG_TVAL;
+		break;
+
 	case SYS_AARCH32_CNTP_TVAL:
+	case SYS_CNTP_TVAL_EL02:
 		tmr = TIMER_PTIMER;
 		treg = TIMER_REG_TVAL;
 		break;
+
+	case SYS_CNTV_TVAL_EL02:
+		tmr = TIMER_VTIMER;
+		treg = TIMER_REG_TVAL;
+		break;
+
+	case SYS_CNTHP_TVAL_EL2:
+		tmr = TIMER_HPTIMER;
+		treg = TIMER_REG_TVAL;
+		break;
+
+	case SYS_CNTHV_TVAL_EL2:
+		tmr = TIMER_HVTIMER;
+		treg = TIMER_REG_TVAL;
+		break;
+
 	case SYS_CNTP_CTL_EL0:
+		if (is_hyp_ctxt(vcpu) && vcpu_el2_e2h_is_set(vcpu))
+			tmr = TIMER_HPTIMER;
+		else
+			tmr = TIMER_PTIMER;
+		treg = TIMER_REG_CTL;
+		break;
+
+	case SYS_CNTV_CTL_EL0:
+		if (is_hyp_ctxt(vcpu) && vcpu_el2_e2h_is_set(vcpu))
+			tmr = TIMER_HVTIMER;
+		else
+			tmr = TIMER_VTIMER;
+		treg = TIMER_REG_CTL;
+		break;
+
 	case SYS_AARCH32_CNTP_CTL:
+	case SYS_CNTP_CTL_EL02:
 		tmr = TIMER_PTIMER;
 		treg = TIMER_REG_CTL;
 		break;
+
+	case SYS_CNTV_CTL_EL02:
+		tmr = TIMER_VTIMER;
+		treg = TIMER_REG_CTL;
+		break;
+
+	case SYS_CNTHP_CTL_EL2:
+		tmr = TIMER_HPTIMER;
+		treg = TIMER_REG_CTL;
+		break;
+
+	case SYS_CNTHV_CTL_EL2:
+		tmr = TIMER_HVTIMER;
+		treg = TIMER_REG_CTL;
+		break;
+
 	case SYS_CNTP_CVAL_EL0:
+		if (is_hyp_ctxt(vcpu) && vcpu_el2_e2h_is_set(vcpu))
+			tmr = TIMER_HPTIMER;
+		else
+			tmr = TIMER_PTIMER;
+		treg = TIMER_REG_CVAL;
+		break;
+
+	case SYS_CNTV_CVAL_EL0:
+		if (is_hyp_ctxt(vcpu) && vcpu_el2_e2h_is_set(vcpu))
+			tmr = TIMER_HVTIMER;
+		else
+			tmr = TIMER_VTIMER;
+		treg = TIMER_REG_CVAL;
+		break;
+
 	case SYS_AARCH32_CNTP_CVAL:
+	case SYS_CNTP_CVAL_EL02:
 		tmr = TIMER_PTIMER;
 		treg = TIMER_REG_CVAL;
 		break;
+
+	case SYS_CNTV_CVAL_EL02:
+		tmr = TIMER_VTIMER;
+		treg = TIMER_REG_CVAL;
+		break;
+
+	case SYS_CNTHP_CVAL_EL2:
+		tmr = TIMER_HPTIMER;
+		treg = TIMER_REG_CVAL;
+		break;
+
+	case SYS_CNTHV_CVAL_EL2:
+		tmr = TIMER_HVTIMER;
+		treg = TIMER_REG_CVAL;
+		break;
+
 	case SYS_CNTPCT_EL0:
 	case SYS_CNTPCTSS_EL0:
+		if (is_hyp_ctxt(vcpu))
+			tmr = TIMER_HPTIMER;
+		else
+			tmr = TIMER_PTIMER;
+		treg = TIMER_REG_CNT;
+		break;
+
 	case SYS_AARCH32_CNTPCT:
+	case SYS_AARCH32_CNTPCTSS:
 		tmr = TIMER_PTIMER;
 		treg = TIMER_REG_CNT;
 		break;
+
+	case SYS_CNTVCT_EL0:
+	case SYS_CNTVCTSS_EL0:
+		if (is_hyp_ctxt(vcpu))
+			tmr = TIMER_HVTIMER;
+		else
+			tmr = TIMER_VTIMER;
+		treg = TIMER_REG_CNT;
+		break;
+
+	case SYS_AARCH32_CNTVCT:
+	case SYS_AARCH32_CNTVCTSS:
+		tmr = TIMER_VTIMER;
+		treg = TIMER_REG_CNT;
+		break;
+
 	default:
 		print_sys_reg_msg(p, "%s", "Unhandled trapped timer register");
 		return undef_access(vcpu, p, r);
@@ -2901,11 +3021,17 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	AMU_AMEVTYPER1_EL0(15),
 
 	{ SYS_DESC(SYS_CNTPCT_EL0), access_arch_timer },
+	{ SYS_DESC(SYS_CNTVCT_EL0), access_arch_timer },
 	{ SYS_DESC(SYS_CNTPCTSS_EL0), access_arch_timer },
+	{ SYS_DESC(SYS_CNTVCTSS_EL0), access_arch_timer },
 	{ SYS_DESC(SYS_CNTP_TVAL_EL0), access_arch_timer },
 	{ SYS_DESC(SYS_CNTP_CTL_EL0), access_arch_timer },
 	{ SYS_DESC(SYS_CNTP_CVAL_EL0), access_arch_timer },
 
+	{ SYS_DESC(SYS_CNTV_TVAL_EL0), access_arch_timer },
+	{ SYS_DESC(SYS_CNTV_CTL_EL0), access_arch_timer },
+	{ SYS_DESC(SYS_CNTV_CVAL_EL0), access_arch_timer },
+
 	/* PMEVCNTRn_EL0 */
 	PMU_PMEVCNTR_EL0(0),
 	PMU_PMEVCNTR_EL0(1),
@@ -3057,9 +3183,24 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	EL2_REG_VNCR(CNTVOFF_EL2, reset_val, 0),
 	EL2_REG(CNTHCTL_EL2, access_rw, reset_val, 0),
+	{ SYS_DESC(SYS_CNTHP_TVAL_EL2), access_arch_timer },
+	EL2_REG(CNTHP_CTL_EL2, access_arch_timer, reset_val, 0),
+	EL2_REG(CNTHP_CVAL_EL2, access_arch_timer, reset_val, 0),
+
+	{ SYS_DESC(SYS_CNTHV_TVAL_EL2), access_arch_timer },
+	EL2_REG(CNTHV_CTL_EL2, access_arch_timer, reset_val, 0),
+	EL2_REG(CNTHV_CVAL_EL2, access_arch_timer, reset_val, 0),
 
 	{ SYS_DESC(SYS_CNTKCTL_EL12), access_cntkctl_el12 },
 
+	{ SYS_DESC(SYS_CNTP_TVAL_EL02), access_arch_timer },
+	{ SYS_DESC(SYS_CNTP_CTL_EL02), access_arch_timer },
+	{ SYS_DESC(SYS_CNTP_CVAL_EL02), access_arch_timer },
+
+	{ SYS_DESC(SYS_CNTV_TVAL_EL02), access_arch_timer },
+	{ SYS_DESC(SYS_CNTV_CTL_EL02), access_arch_timer },
+	{ SYS_DESC(SYS_CNTV_CVAL_EL02), access_arch_timer },
+
 	EL2_REG(SP_EL2, NULL, reset_unknown, 0),
 };
 
@@ -3879,9 +4020,11 @@ static const struct sys_reg_desc cp15_64_regs[] = {
 	{ SYS_DESC(SYS_AARCH32_CNTPCT),	      access_arch_timer },
 	{ Op1( 1), CRn( 0), CRm( 2), Op2( 0), access_vm_reg, NULL, TTBR1_EL1 },
 	{ Op1( 1), CRn( 0), CRm(12), Op2( 0), access_gic_sgi }, /* ICC_ASGI1R */
+	{ SYS_DESC(SYS_AARCH32_CNTVCT),	      access_arch_timer },
 	{ Op1( 2), CRn( 0), CRm(12), Op2( 0), access_gic_sgi }, /* ICC_SGI0R */
 	{ SYS_DESC(SYS_AARCH32_CNTP_CVAL),    access_arch_timer },
 	{ SYS_DESC(SYS_AARCH32_CNTPCTSS),     access_arch_timer },
+	{ SYS_DESC(SYS_AARCH32_CNTVCTSS),     access_arch_timer },
 };
 
 static bool check_sysreg_table(const struct sys_reg_desc *table, unsigned int n,
diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource/arm_arch_timer.h
index cbbc9a6dc5715..877dcbb2601ae 100644
--- a/include/clocksource/arm_arch_timer.h
+++ b/include/clocksource/arm_arch_timer.h
@@ -22,6 +22,8 @@
 #define CNTHCTL_EVNTDIR			(1 << 3)
 #define CNTHCTL_EVNTI			(0xF << 4)
 #define CNTHCTL_ECV			(1 << 12)
+#define CNTHCTL_EL1TVT			(1 << 13)
+#define CNTHCTL_EL1TVCT			(1 << 14)
 
 enum arch_timer_reg {
 	ARCH_TIMER_REG_CTRL,
-- 
2.39.2


