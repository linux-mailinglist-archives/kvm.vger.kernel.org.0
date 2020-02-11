Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5639315968C
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 18:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730125AbgBKRuC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 12:50:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:52364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730085AbgBKRuB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 12:50:01 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07C1C21569;
        Tue, 11 Feb 2020 17:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581443400;
        bh=iaPvHhL1DahVBvUNkh+yyOVLWQlC65rw+u5cb6z/KaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yASocWOyK4GYSUUWqNBMHTyoOswWx8yjJaBXOdOnuSnfZ+YHD8cMbn15yRi2e4AAR
         olLSpWob1gnH0I+7Slp6AFi3xosleDCY2kDIF8tQAFRPTO/J8SeZXYAiKGOgD3A/rr
         w03PH58i1FarRw4rpV4X0zpzv9srhRKvOCd8JJKg=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j1Zfa-004O7k-CP; Tue, 11 Feb 2020 17:49:58 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 08/94] KVM: arm64: nv: Add nested virt VCPU primitives for vEL2 VCPU state
Date:   Tue, 11 Feb 2020 17:48:12 +0000
Message-Id: <20200211174938.27809-9-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200211174938.27809-1-maz@kernel.org>
References: <20200211174938.27809-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
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
index 688c63412cc2..9646ad7c2640 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -194,6 +194,61 @@ static inline void vcpu_set_reg(struct kvm_vcpu *vcpu, u8 reg_num,
 		vcpu_gp_regs(vcpu)->regs.regs[reg_num] = val;
 }
 
+static inline bool vcpu_mode_el2_ctxt(const struct kvm_cpu_context *ctxt)
+{
+	unsigned long cpsr = ctxt->gp_regs.regs.pstate;
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
+	return ctxt->sys_regs[HCR_EL2] & HCR_E2H;
+}
+
+static inline bool vcpu_el2_e2h_is_set(const struct kvm_vcpu *vcpu)
+{
+	return __vcpu_el2_e2h_is_set(&vcpu->arch.ctxt);
+}
+
+static inline bool __vcpu_el2_tge_is_set(const struct kvm_cpu_context *ctxt)
+{
+	return ctxt->sys_regs[HCR_EL2] & HCR_TGE;
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
 static inline unsigned long vcpu_read_spsr(const struct kvm_vcpu *vcpu)
 {
 	if (vcpu_mode_is_32bit(vcpu))
-- 
2.20.1

