Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB463794CA
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 19:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232370AbhEJRBK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 13:01:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231953AbhEJRAw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 13:00:52 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4F7261490;
        Mon, 10 May 2021 16:59:43 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1lg9Fu-000Uqg-6b; Mon, 10 May 2021 17:59:42 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH v4 06/66] KVM: arm64: nv: Add nested virt VCPU primitives for vEL2 VCPU state
Date:   Mon, 10 May 2021 17:58:20 +0100
Message-Id: <20210510165920.1913477-7-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210510165920.1913477-1-maz@kernel.org>
References: <20210510165920.1913477-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Christoffer Dall <christoffer.dall@arm.com>

When running a nested hypervisor we commonly have to figure out if
the VCPU mode is running in the context of a guest hypervisor or guest
guest, or just a normal guest.

Add convenient primitives for this.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 55 ++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index f612c090f2e4..706ef06c5f2b 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -173,6 +173,61 @@ static __always_inline void vcpu_set_reg(struct kvm_vcpu *vcpu, u8 reg_num,
 		vcpu_gp_regs(vcpu)->regs[reg_num] = val;
 }
 
+static inline bool vcpu_mode_el2_ctxt(const struct kvm_cpu_context *ctxt)
+{
+	unsigned long cpsr = ctxt->regs.pstate;
+
+	switch (cpsr & (PSR_MODE32_BIT | PSR_MODE_MASK)) {
+	case PSR_MODE_EL2h:
+	case PSR_MODE_EL2t:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static inline bool vcpu_mode_el2(const struct kvm_vcpu *vcpu)
+{
+	return vcpu_mode_el2_ctxt(&vcpu->arch.ctxt);
+}
+
+static inline bool __vcpu_el2_e2h_is_set(const struct kvm_cpu_context *ctxt)
+{
+	return ctxt_sys_reg(ctxt, HCR_EL2) & HCR_E2H;
+}
+
+static inline bool vcpu_el2_e2h_is_set(const struct kvm_vcpu *vcpu)
+{
+	return __vcpu_el2_e2h_is_set(&vcpu->arch.ctxt);
+}
+
+static inline bool __vcpu_el2_tge_is_set(const struct kvm_cpu_context *ctxt)
+{
+	return ctxt_sys_reg(ctxt, HCR_EL2) & HCR_TGE;
+}
+
+static inline bool vcpu_el2_tge_is_set(const struct kvm_vcpu *vcpu)
+{
+	return __vcpu_el2_tge_is_set(&vcpu->arch.ctxt);
+}
+
+static inline bool __is_hyp_ctxt(const struct kvm_cpu_context *ctxt)
+{
+	/*
+	 * We are in a hypervisor context if the vcpu mode is EL2 or
+	 * E2H and TGE bits are set. The latter means we are in the user space
+	 * of the VHE kernel. ARMv8.1 ARM describes this as 'InHost'
+	 */
+	return vcpu_mode_el2_ctxt(ctxt) ||
+		(__vcpu_el2_e2h_is_set(ctxt) && __vcpu_el2_tge_is_set(ctxt)) ||
+		WARN_ON(__vcpu_el2_tge_is_set(ctxt));
+}
+
+static inline bool is_hyp_ctxt(const struct kvm_vcpu *vcpu)
+{
+	return __is_hyp_ctxt(&vcpu->arch.ctxt);
+}
+
 /*
  * The layout of SPSR for an AArch32 state is different when observed from an
  * AArch64 SPSR_ELx or an AArch32 SPSR_*. This function generates the AArch32
-- 
2.29.2

