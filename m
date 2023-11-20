Return-Path: <kvm+bounces-2096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AAC97F140D
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 14:13:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E49B81F244B4
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 13:13:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58C551EA95;
	Mon, 20 Nov 2023 13:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P3F1NjfF"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66A61DDE3;
	Mon, 20 Nov 2023 13:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B19C433CB;
	Mon, 20 Nov 2023 13:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700485857;
	bh=m3fCvk3TbMsX9a05jxUjn43MOoqRNn5Np8oLcc2YHrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P3F1NjfFQ6JN0c9ltCsVAHDa938f0gy0QJwr2B7qZnaK6Wi7EKIyrWxoPiI97uotu
	 sGru8O53Gq+zkyiCEZBasMdoamGnsdHI9ub5uQT4L+gMf29Keffd3gOsoBXnt4AJkB
	 qZhd7xXloMJxNyZC9WsZbMnDmAcIG5afJ4kVigi2b8l4CuZFzQSQc2zZfeHsoI0FKC
	 1cAPqFvm/GlMQcAU8SAaJStjzlvZe+NUXR76XASPrLDbg0OpepVTRVM9rqcwK34Bj9
	 7CEjPLaJUOXb6dNwVl36hAmuRbpf5FwqYLNsxLnKxq6hHD+Bs3atJAUQRgc/9dZhmX
	 XruRYlZJ0PIWw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r543D-00EjnU-Oa;
	Mon, 20 Nov 2023 13:10:55 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Chase Conklin <chase.conklin@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Darren Hart <darren@os.amperecomputing.com>,
	Jintack Lim <jintack@cs.columbia.edu>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Miguel Luis <miguel.luis@oracle.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v11 26/43] KVM: arm64: nv: Add handling of EL2-specific timer registers
Date: Mon, 20 Nov 2023 13:10:10 +0000
Message-Id: <20231120131027.854038-27-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231120131027.854038-1-maz@kernel.org>
References: <20231120131027.854038-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Add the required handling for EL2 and EL02 registers, as
well as EL1 registers used in the E2H context. This includes
handling the virtual timer accesses when CNTHCTL_EL2.EL1TVT is set.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h |   2 +
 arch/arm64/kvm/sys_regs.c       | 123 ++++++++++++++++++++++++++++++++
 2 files changed, 125 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 30952f1ac997..e36abbcbf4fa 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -457,6 +457,7 @@
 #define SYS_CNTFRQ_EL0			sys_reg(3, 3, 14, 0, 0)
 
 #define SYS_CNTPCT_EL0			sys_reg(3, 3, 14, 0, 1)
+#define SYS_CNTVCT_EL0			sys_reg(3, 3, 14, 0, 2)
 #define SYS_CNTPCTSS_EL0		sys_reg(3, 3, 14, 0, 5)
 #define SYS_CNTVCTSS_EL0		sys_reg(3, 3, 14, 0, 6)
 
@@ -464,6 +465,7 @@
 #define SYS_CNTP_CTL_EL0		sys_reg(3, 3, 14, 2, 1)
 #define SYS_CNTP_CVAL_EL0		sys_reg(3, 3, 14, 2, 2)
 
+#define SYS_CNTV_TVAL_EL0		sys_reg(3, 3, 14, 3, 0)
 #define SYS_CNTV_CTL_EL0		sys_reg(3, 3, 14, 3, 1)
 #define SYS_CNTV_CVAL_EL0		sys_reg(3, 3, 14, 3, 2)
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7405053a6dc8..a24feb4b2839 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1424,26 +1424,130 @@ static bool access_arch_timer(struct kvm_vcpu *vcpu,
 
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
 		tmr = TIMER_PTIMER;
 		treg = TIMER_REG_CNT;
 		break;
+
 	default:
 		print_sys_reg_msg(p, "%s", "Unhandled trapped timer register");
 		kvm_inject_undefined(vcpu);
@@ -2640,6 +2744,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_CNTP_CTL_EL0), access_arch_timer },
 	{ SYS_DESC(SYS_CNTP_CVAL_EL0), access_arch_timer },
 
+	{ SYS_DESC(SYS_CNTV_TVAL_EL0), access_arch_timer },
+	{ SYS_DESC(SYS_CNTV_CTL_EL0), access_arch_timer },
+	{ SYS_DESC(SYS_CNTV_CVAL_EL0), access_arch_timer },
+
 	/* PMEVCNTRn_EL0 */
 	PMU_PMEVCNTR_EL0(0),
 	PMU_PMEVCNTR_EL0(1),
@@ -2771,9 +2879,24 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 
 	EL2_REG_VNCR(CNTVOFF_EL2, reset_val, 0),
 	EL2_REG(CNTHCTL_EL2, access_rw, reset_val, 0),
+	{ SYS_DESC(SYS_CNTHP_TVAL_EL2), access_arch_timer },
+	EL2_REG(CNTHP_CTL_EL2, access_arch_timer, reset_val, 0),
+	EL2_REG(CNTHP_CVAL_EL2, access_arch_timer, reset_val, 0),
+
+	{ SYS_DESC(SYS_CNTHV_TVAL_EL2), access_arch_timer },
+	EL2_REG(CNTHV_CTL_EL2, access_arch_timer, reset_val, 0),
+	EL2_REG(CNTHV_CVAL_EL2, access_arch_timer, reset_val, 0),
 
 	EL12_REG(CNTKCTL, access_rw, reset_val, 0),
 
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
 
-- 
2.39.2


