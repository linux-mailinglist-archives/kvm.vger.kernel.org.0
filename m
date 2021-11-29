Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 379114621C6
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 21:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234254AbhK2UNG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 15:13:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:43218 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232424AbhK2ULE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 15:11:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECAACB81636
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 20:07:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF2BC53FD1;
        Mon, 29 Nov 2021 20:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638216464;
        bh=EYeh0Lg5aZN74mfocLytDlC5zUmfjAuH0WowocTwWvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uj6n4AqFMtrk71GZ8maLMN3czt9ScQKmmEei66FkAqWF3eXhNOG2O7VzTW5AMnDb0
         MClBwmZIA5dUR+TeVIW+Ik2fqyY8h5XCXOS9chCKklklxKMs6lKipsfxxNRHzwErph
         kdrLi6Nopgs2TqN7dSGD5zZo+V6QHSMoov85gfRy91ECTSg5sLYQns3bTizRly+l7D
         DLbKyW1jzyVvl4NpX3x2cx3gqruVaZHJGsyeGt8tSKK/dJ1wYtqsP46n5Z1KBt6nPb
         faM7pmZ+hMgF64s1b9K9FHZNz/YJGuikifKIw/PPV0/OapGw4F77304u7wy7TodtsJ
         eytUUfRltWWtA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mrmr2-008gvR-Bj; Mon, 29 Nov 2021 20:02:24 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v5 44/69] KVM: arm64: nv: Set a handler for the system instruction traps
Date:   Mon, 29 Nov 2021 20:01:25 +0000
Message-Id: <20211129200150.351436-45-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129200150.351436-1-maz@kernel.org>
References: <20211129200150.351436-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jintack Lim <jintack.lim@linaro.org>

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
 arch/arm64/include/asm/kvm_host.h |  4 +--
 arch/arm64/kvm/handle_exit.c      |  2 +-
 arch/arm64/kvm/sys_regs.c         | 48 +++++++++++++++++++++++++------
 3 files changed, 42 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 00c3366129b8..35f3d7939484 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -411,7 +411,7 @@ struct kvm_vcpu_arch {
 	/*
 	 * Guest registers we preserve during guest debugging.
 	 *
-	 * These shadow registers are updated by the kvm_handle_sys_reg
+	 * These shadow registers are updated by the kvm_handle_sys
 	 * trap handler if the guest accesses or updates them while we
 	 * are using guest debug.
 	 */
@@ -729,7 +729,7 @@ int kvm_handle_cp14_32(struct kvm_vcpu *vcpu);
 int kvm_handle_cp14_64(struct kvm_vcpu *vcpu);
 int kvm_handle_cp15_32(struct kvm_vcpu *vcpu);
 int kvm_handle_cp15_64(struct kvm_vcpu *vcpu);
-int kvm_handle_sys_reg(struct kvm_vcpu *vcpu);
+int kvm_handle_sys(struct kvm_vcpu *vcpu);
 
 void kvm_reset_sys_regs(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 6ff709c124d0..8b3b758e674e 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -234,7 +234,7 @@ static exit_handle_fn arm_exit_handlers[] = {
 	[ESR_ELx_EC_SMC32]	= handle_smc,
 	[ESR_ELx_EC_HVC64]	= handle_hvc,
 	[ESR_ELx_EC_SMC64]	= handle_smc,
-	[ESR_ELx_EC_SYS64]	= kvm_handle_sys_reg,
+	[ESR_ELx_EC_SYS64]	= kvm_handle_sys,
 	[ESR_ELx_EC_SVE]	= handle_sve,
 	[ESR_ELx_EC_ERET]	= kvm_handle_eret,
 	[ESR_ELx_EC_IABT_LOW]	= kvm_handle_guest_abort,
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 77f07f960d84..222f8c6f1d7e 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1770,10 +1770,6 @@ static bool access_spsr_el2(struct kvm_vcpu *vcpu,
  * more demanding guest...
  */
 static const struct sys_reg_desc sys_reg_descs[] = {
-	{ SYS_DESC(SYS_DC_ISW), access_dcsw },
-	{ SYS_DESC(SYS_DC_CSW), access_dcsw },
-	{ SYS_DESC(SYS_DC_CISW), access_dcsw },
-
 	DBG_BCR_BVR_WCR_WVR_EL1(0),
 	DBG_BCR_BVR_WCR_WVR_EL1(1),
 	{ SYS_DESC(SYS_MDCCINT_EL1), trap_debug_regs, reset_val, MDCCINT_EL1, 0 },
@@ -2240,6 +2236,14 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	{ SYS_DESC(SYS_SP_EL2), NULL, reset_unknown, SP_EL2 },
 };
 
+#define SYS_INSN_TO_DESC(insn, access_fn, forward_fn)	\
+	{ SYS_DESC((insn)), (access_fn), NULL, 0, 0, NULL, NULL, (forward_fn) }
+static struct sys_reg_desc sys_insn_descs[] = {
+	{ SYS_DESC(SYS_DC_ISW), access_dcsw },
+	{ SYS_DESC(SYS_DC_CSW), access_dcsw },
+	{ SYS_DESC(SYS_DC_CISW), access_dcsw },
+};
+
 static bool trap_dbgdidr(struct kvm_vcpu *vcpu,
 			struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
@@ -2794,6 +2798,24 @@ static int emulate_sys_reg(struct kvm_vcpu *vcpu,
 	return 1;
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
 /**
  * kvm_reset_sys_regs - sets system registers to reset value
  * @vcpu: The VCPU pointer
@@ -2811,10 +2833,11 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
 }
 
 /**
- * kvm_handle_sys_reg -- handles a mrs/msr trap on a guest sys_reg access
+ * kvm_handle_sys-- handles a system instruction or mrs/msr instruction trap
+		    on a guest execution
  * @vcpu: The VCPU pointer
  */
-int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
+int kvm_handle_sys(struct kvm_vcpu *vcpu)
 {
 	struct sys_reg_params params;
 	unsigned long esr = kvm_vcpu_get_esr(vcpu);
@@ -2826,10 +2849,16 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
 	params = esr_sys64_to_params(esr);
 	params.regval = vcpu_get_reg(vcpu, Rt);
 
-	ret = emulate_sys_reg(vcpu, &params);
+	if (params.Op0 == 1) {
+		/* System instructions */
+		ret = emulate_sys_instr(vcpu, &params);
+	} else {
+		/* MRS/MSR instructions */
+		ret = emulate_sys_reg(vcpu, &params);
+		if (!params.is_write)
+			vcpu_set_reg(vcpu, Rt, params.regval);
+	}
 
-	if (!params.is_write)
-		vcpu_set_reg(vcpu, Rt, params.regval);
 	return ret;
 }
 
@@ -3245,6 +3274,7 @@ void kvm_sys_reg_table_init(void)
 	BUG_ON(check_sysreg_table(cp15_regs, ARRAY_SIZE(cp15_regs), true));
 	BUG_ON(check_sysreg_table(cp15_64_regs, ARRAY_SIZE(cp15_64_regs), true));
 	BUG_ON(check_sysreg_table(invariant_sys_regs, ARRAY_SIZE(invariant_sys_regs), false));
+	BUG_ON(check_sysreg_table(sys_insn_descs, ARRAY_SIZE(sys_insn_descs), false));
 
 	/* We abuse the reset function to overwrite the table itself. */
 	for (i = 0; i < ARRAY_SIZE(invariant_sys_regs); i++)
-- 
2.30.2

