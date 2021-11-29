Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63271462337
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 22:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbhK2V2A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 16:28:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbhK2VZu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 16:25:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E088CC091D38
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 12:07:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88D84B8159E
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 20:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4577DC53FD1;
        Mon, 29 Nov 2021 20:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638216451;
        bh=1Zg7MxAD5sCmymbTc5EDtJN7PJqUKc+Pm1ZgNIxAhTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W4XTdAZp+1uhCCcn0OpsCMPgwIR5JUIoCu7wuBOcTv6GnWqnYOSpk7oOLwNLzsslk
         jHjD6r3f1eIbv40BL/aKgl6QJnHny40IfBmr/BkGMam9zH+2up8EtXhLVkZ8QJPICr
         teUlY1ZlnGVNKUBoL1QWSixEXgPhBlKqNy0ZSPXKmzkE9BJolLS18vwVual0GyFncW
         tzxTJrUYOgMEAjgsq8cQ/TFMQziy2s/80QFumABtoAbNevB79XkTR5HKVNJCEGH2bm
         T6arsamaHwYfWDhww4EYkt00qTPgHLnTyi7fRcHHIZuuNECZx2LE/7SHbSyFH/BcGu
         R8zzIRbsBpvOA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mrmqq-008gvR-Oz; Mon, 29 Nov 2021 20:02:12 +0000
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
Subject: [PATCH v5 11/69] KVM: arm64: nv: Add nested virt VCPU primitives for vEL2 VCPU state
Date:   Mon, 29 Nov 2021 20:00:52 +0000
Message-Id: <20211129200150.351436-12-maz@kernel.org>
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
index f4871e47b2d0..f4b079945d0f 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -176,6 +176,61 @@ static __always_inline void vcpu_set_reg(struct kvm_vcpu *vcpu, u8 reg_num,
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
2.30.2

