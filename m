Return-Path: <kvm+bounces-2093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2585D7F140A
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 14:13:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3659282767
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 13:13:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F276E1DFD7;
	Mon, 20 Nov 2023 13:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TRADo5VH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4071D6AB;
	Mon, 20 Nov 2023 13:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DEEC433CB;
	Mon, 20 Nov 2023 13:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700485856;
	bh=uHsVOTPBxLOIvuoMaVSD42zkhWwQiQWMQX6314HFDXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TRADo5VHixJApndTlw/QN86lSVEXwLX+nKLdx2FOFs9YwHMRTrA1F9G+btPtdlO1z
	 57tE/0kKUlHX5OeOZrzb+t11icrNB0ymIUg+q5LsDfQTTaN4Mkml3nSMF1IEmw5F7I
	 ecsaRT+hAaspcscBMFVxnbTwLkYcdI2W2J/9LNyR/QGgE+VH8D4Uh7LH1SipqlN2jm
	 iDRGRam7jhq9v0V6GjZDXRruMw78TKF1QMRbYlcbv1qHrZxWHjHayFKc+MVDaKlvYA
	 omwL6I8aNppmkL3mCdo2ueJQ0m+7enL+434NgV0oANmtbafsdinE77bJnquejTiu65
	 RQ1fODbp9ZzkQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r543C-00EjnU-Lc;
	Mon, 20 Nov 2023 13:10:54 +0000
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
Subject: [PATCH v11 22/43] KVM: arm64: nv: Set a handler for the system instruction traps
Date: Mon, 20 Nov 2023 13:10:06 +0000
Message-Id: <20231120131027.854038-23-maz@kernel.org>
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

When HCR.NV bit is set, execution of the EL2 translation regime address
aranslation instructions and TLB maintenance instructions are trapped to
EL2. In addition, execution of the EL1 translation regime address
aranslation instructions and TLB maintenance instructions that are only
accessible from EL2 and above are trapped to EL2. In these cases,
ESR_EL2.EC will be set to 0x18.

Rework the system instruction emulation framework to handle potentially
all system instruction traps other than MSR/MRS instructions. Those
system instructions would be AT and TLBI instructions controlled by
HCR_EL2.NV, AT, and TTLB bits.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
[maz: squashed two patches together, redispatched various bits around]
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 59 +++++++++++++++++++++++++++++----------
 1 file changed, 44 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f42f3ed3724c..49d00f0cdda0 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2246,16 +2246,6 @@ static u64 reset_hcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
  * guest...
  */
 static const struct sys_reg_desc sys_reg_descs[] = {
-	{ SYS_DESC(SYS_DC_ISW), access_dcsw },
-	{ SYS_DESC(SYS_DC_IGSW), access_dcgsw },
-	{ SYS_DESC(SYS_DC_IGDSW), access_dcgsw },
-	{ SYS_DESC(SYS_DC_CSW), access_dcsw },
-	{ SYS_DESC(SYS_DC_CGSW), access_dcgsw },
-	{ SYS_DESC(SYS_DC_CGDSW), access_dcgsw },
-	{ SYS_DESC(SYS_DC_CISW), access_dcsw },
-	{ SYS_DESC(SYS_DC_CIGSW), access_dcgsw },
-	{ SYS_DESC(SYS_DC_CIGDSW), access_dcgsw },
-
 	DBG_BCR_BVR_WCR_WVR_EL1(0),
 	DBG_BCR_BVR_WCR_WVR_EL1(1),
 	{ SYS_DESC(SYS_MDCCINT_EL1), trap_debug_regs, reset_val, MDCCINT_EL1, 0 },
@@ -2786,6 +2776,18 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(SP_EL2, NULL, reset_unknown, 0),
 };
 
+static struct sys_reg_desc sys_insn_descs[] = {
+	{ SYS_DESC(SYS_DC_ISW), access_dcsw },
+	{ SYS_DESC(SYS_DC_IGSW), access_dcgsw },
+	{ SYS_DESC(SYS_DC_IGDSW), access_dcgsw },
+	{ SYS_DESC(SYS_DC_CSW), access_dcsw },
+	{ SYS_DESC(SYS_DC_CGSW), access_dcgsw },
+	{ SYS_DESC(SYS_DC_CGDSW), access_dcgsw },
+	{ SYS_DESC(SYS_DC_CISW), access_dcsw },
+	{ SYS_DESC(SYS_DC_CIGSW), access_dcgsw },
+	{ SYS_DESC(SYS_DC_CIGDSW), access_dcgsw },
+};
+
 static const struct sys_reg_desc *first_idreg;
 
 static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
@@ -3479,6 +3481,24 @@ static bool emulate_sys_reg(struct kvm_vcpu *vcpu,
 	return false;
 }
 
+static int emulate_sys_instr(struct kvm_vcpu *vcpu, struct sys_reg_params *p)
+{
+	const struct sys_reg_desc *r;
+
+	/* Search from the system instruction table. */
+	r = find_reg(p, sys_insn_descs, ARRAY_SIZE(sys_insn_descs));
+
+	if (likely(r)) {
+		perform_access(vcpu, p, r);
+	} else {
+		kvm_err("Unsupported guest sys instruction at: %lx\n",
+			*vcpu_pc(vcpu));
+		print_sys_reg_instr(p);
+		kvm_inject_undefined(vcpu);
+	}
+	return 1;
+}
+
 static void kvm_reset_id_regs(struct kvm_vcpu *vcpu)
 {
 	const struct sys_reg_desc *idreg = first_idreg;
@@ -3526,7 +3546,8 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
 }
 
 /**
- * kvm_handle_sys_reg -- handles a mrs/msr trap on a guest sys_reg access
+ * kvm_handle_sys_reg -- handles a system instruction or mrs/msr instruction
+ *			 trap on a guest execution
  * @vcpu: The VCPU pointer
  */
 int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
@@ -3543,12 +3564,19 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
 	params = esr_sys64_to_params(esr);
 	params.regval = vcpu_get_reg(vcpu, Rt);
 
-	if (!emulate_sys_reg(vcpu, &params))
+	/* System register? */
+	if (params.Op0 == 2 || params.Op0 == 3) {
+		if (!emulate_sys_reg(vcpu, &params))
+			return 1;
+
+		if (!params.is_write)
+			vcpu_set_reg(vcpu, Rt, params.regval);
+
 		return 1;
+	}
 
-	if (!params.is_write)
-		vcpu_set_reg(vcpu, Rt, params.regval);
-	return 1;
+	/* Hints, PSTATE (Op0 == 0) and System instructions (Op0 == 1) */
+	return emulate_sys_instr(vcpu, &params);
 }
 
 /******************************************************************************
@@ -4002,6 +4030,7 @@ int __init kvm_sys_reg_table_init(void)
 	valid &= check_sysreg_table(cp15_regs, ARRAY_SIZE(cp15_regs), true);
 	valid &= check_sysreg_table(cp15_64_regs, ARRAY_SIZE(cp15_64_regs), true);
 	valid &= check_sysreg_table(invariant_sys_regs, ARRAY_SIZE(invariant_sys_regs), false);
+	valid &= check_sysreg_table(sys_insn_descs, ARRAY_SIZE(sys_insn_descs), false);
 
 	if (!valid)
 		return -EINVAL;
-- 
2.39.2


