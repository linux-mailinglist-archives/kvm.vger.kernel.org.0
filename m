Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4062B49F92E
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 13:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348425AbiA1MT5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 07:19:57 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36298 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348409AbiA1MT5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 07:19:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C589461B00
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 12:19:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D177C340E0;
        Fri, 28 Jan 2022 12:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643372396;
        bh=h4rsgR8BnZXlOfrI8viPwteQfwTLQDAMHMKc/MPVsEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bX7nO9TvxIYmWz2oXJQzahHuGVVSsKn1FPjZD1qiHrARVUe25OvoSDosbAYve9uxb
         jbZA7dkxlBb72gfSDbx00kwDqHAnMmwtvEOYLxUWUOzmTdk5W8I8rTiBuhn92xyrAT
         Zdct+G+KMLGdW9riVSW+3bpZgHE/FahH2IKIx8//L3jrlh9CU/sGBlrk8na/NxnS+5
         fzPjMCiYyyadk1Mse5+zJtRe+BQ56DVZp79p/JmjrGk9b2stESvteTAfqhBuMz8xBV
         QWV87wxaL33NtyTvFc6/UjOVgLa7KQvSh/+f1xBxbdCGJGqcjhKWU0qoq04Vmw5no1
         AA2jeoAUVXXNA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nDQE2-003njR-TL; Fri, 28 Jan 2022 12:19:35 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Haibo Xu <haibo.xu@linaro.org>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Chase Conklin <chase.conklin@arm.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        karl.heubaum@oracle.com, mihai.carabas@oracle.com,
        miguel.luis@oracle.com, kernel-team@android.com
Subject: [PATCH v6 24/64] KVM: arm64: nv: Respect the virtual HCR_EL2.NV bit setting
Date:   Fri, 28 Jan 2022 12:18:32 +0000
Message-Id: <20220128121912.509006-25-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220128121912.509006-1-maz@kernel.org>
References: <20220128121912.509006-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org, gankulkarni@os.amperecomputing.com, chase.conklin@arm.com, linux@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, karl.heubaum@oracle.com, mihai.carabas@oracle.com, miguel.luis@oracle.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jintack Lim <jintack.lim@linaro.org>

Forward traps due to HCR_EL2.NV bit to the virtual EL2 if they are not
coming from the virtual EL2 and the virtual HCR_EL2.NV bit is set.

In addition to EL2 register accesses, setting NV bit will also make EL12
register accesses trap to EL2. To emulate this for the virtual EL2,
forword traps due to EL12 register accessses to the virtual EL2 if the
virtual HCR_EL2.NV bit is set.

This is for recursive nested virtualization.

Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
[Moved code to emulate-nested.c]
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h    |  1 +
 arch/arm64/include/asm/kvm_nested.h |  2 ++
 arch/arm64/kvm/emulate-nested.c     | 27 +++++++++++++++++++++++++++
 arch/arm64/kvm/handle_exit.c        |  7 +++++++
 arch/arm64/kvm/sys_regs.c           | 21 +++++++++++++++++++++
 5 files changed, 58 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 5acb153a82c8..8043827e7dc0 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -20,6 +20,7 @@
 #define HCR_AMVOFFEN	(UL(1) << 51)
 #define HCR_FIEN	(UL(1) << 47)
 #define HCR_FWB		(UL(1) << 46)
+#define HCR_NV		(UL(1) << 42)
 #define HCR_API		(UL(1) << 41)
 #define HCR_APK		(UL(1) << 40)
 #define HCR_TEA		(UL(1) << 37)
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 79d382fa02ea..37ff6458296d 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -66,5 +66,7 @@ static inline u64 translate_cnthctl_el2_to_cntkctl_el1(u64 cnthctl)
 }
 
 int handle_wfx_nested(struct kvm_vcpu *vcpu, bool is_wfe);
+extern bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit);
+extern bool forward_nv_traps(struct kvm_vcpu *vcpu);
 
 #endif /* __ARM64_KVM_NESTED_H */
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index f52cd4458947..7dd98d6e96e0 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -13,6 +13,26 @@
 
 #include "trace.h"
 
+bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit)
+{
+	bool control_bit_set;
+
+	if (!vcpu_has_nv(vcpu))
+		return false;
+
+	control_bit_set = __vcpu_sys_reg(vcpu, HCR_EL2) & control_bit;
+	if (!vcpu_is_el2(vcpu) && control_bit_set) {
+		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
+		return true;
+	}
+	return false;
+}
+
+bool forward_nv_traps(struct kvm_vcpu *vcpu)
+{
+	return forward_traps(vcpu, HCR_NV);
+}
+
 static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
 {
 	u64 mode = spsr & PSR_MODE_MASK;
@@ -49,6 +69,13 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 	u64 spsr, elr, mode;
 	bool direct_eret;
 
+	/*
+	 * Forward this trap to the virtual EL2 if the virtual
+	 * HCR_EL2.NV bit is set and this is coming from !EL2.
+	 */
+	if (forward_nv_traps(vcpu))
+		return;
+
 	/*
 	 * Going through the whole put/load motions is a waste of time
 	 * if this is a VHE guest hypervisor returning to its own
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index a5c698f188d6..867de65eb766 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -64,6 +64,13 @@ static int handle_smc(struct kvm_vcpu *vcpu)
 {
 	int ret;
 
+	/*
+	 * Forward this trapped smc instruction to the virtual EL2 if
+	 * the guest has asked for it.
+	 */
+	if (forward_traps(vcpu, HCR_TSC))
+		return 1;
+
 	/*
 	 * "If an SMC instruction executed at Non-secure EL1 is
 	 * trapped to EL2 because HCR_EL2.TSC is 1, the exception is a
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 7f074a7f6eb3..ccd063d6cb69 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -267,10 +267,19 @@ static u32 get_ccsidr(u32 csselr)
 	return ccsidr;
 }
 
+static bool el12_reg(struct sys_reg_params *p)
+{
+	/* All *_EL12 registers have Op1=5. */
+	return (p->Op1 == 5);
+}
+
 static bool access_rw(struct kvm_vcpu *vcpu,
 		      struct sys_reg_params *p,
 		      const struct sys_reg_desc *r)
 {
+	if (el12_reg(p) && forward_nv_traps(vcpu))
+		return false;
+
 	if (p->is_write)
 		vcpu_write_sys_reg(vcpu, p->regval, r->reg);
 	else
@@ -339,6 +348,9 @@ static bool access_vm_reg(struct kvm_vcpu *vcpu,
 	bool was_enabled = vcpu_has_cache_enabled(vcpu);
 	u64 val, mask, shift;
 
+	if (el12_reg(p) && forward_nv_traps(vcpu))
+		return false;
+
 	/* We don't expect TRVM on the host */
 	BUG_ON(!vcpu_is_el2(vcpu) && !p->is_write);
 
@@ -1654,6 +1666,9 @@ static bool access_elr(struct kvm_vcpu *vcpu,
 		       struct sys_reg_params *p,
 		       const struct sys_reg_desc *r)
 {
+	if (el12_reg(p) && forward_nv_traps(vcpu))
+		return false;
+
 	if (p->is_write)
 		vcpu_write_sys_reg(vcpu, p->regval, ELR_EL1);
 	else
@@ -1666,6 +1681,9 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
 			struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
 {
+	if (el12_reg(p) && forward_nv_traps(vcpu))
+		return false;
+
 	if (p->is_write)
 		__vcpu_sys_reg(vcpu, SPSR_EL1) = p->regval;
 	else
@@ -1678,6 +1696,9 @@ static bool access_spsr_el2(struct kvm_vcpu *vcpu,
 			    struct sys_reg_params *p,
 			    const struct sys_reg_desc *r)
 {
+	if (el12_reg(p) && forward_nv_traps(vcpu))
+		return false;
+
 	if (p->is_write)
 		vcpu_write_sys_reg(vcpu, p->regval, SPSR_EL2);
 	else
-- 
2.30.2

