Return-Path: <kvm+bounces-2076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07A057F13FB
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 14:11:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E71D1C217FA
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 13:11:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15E321C694;
	Mon, 20 Nov 2023 13:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="clSAcH8o"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766321A732;
	Mon, 20 Nov 2023 13:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E00C433C9;
	Mon, 20 Nov 2023 13:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700485852;
	bh=gR1LvKiJaEvZSzi0tUwiJmVeL3N/tQhyOxtVYxfY56c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=clSAcH8oMJ1GIjRncQhBxCCeXdE3AMq8iiIpTpcri8Vh6Hw6XQKEWkzXUftKHNVJV
	 imTyIMVTXWkYYjJjZE+2ZcOt9NVVkA4GZS4N1x/FE8EGOO2P/pS35Ren1i/pKzoAUy
	 LoCKPL+Wvcc/ortKof8j+F14KLXtAjNhBVhysgnMmP67lo4RlSII7UMkBH6ZeFcK9r
	 V4162fsql7PjMRM6PwdvGTo512cOoQ8oZJg4577vkRGyvvWG3GWX8s2zx/DWuLv+m/
	 lpCc2LgeJQ7wznyTab2AIuuCuaaUEa3AsiHXU5MC8rJMkurDp+3jOtNkpgbCFXB/8d
	 WZFanA+q9rz/Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1r5438-00EjnU-8v;
	Mon, 20 Nov 2023 13:10:50 +0000
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
Subject: [PATCH v11 05/43] KVM: arm64: nv: Add non-VHE-EL2->EL1 translation helpers
Date: Mon, 20 Nov 2023 13:09:49 +0000
Message-Id: <20231120131027.854038-6-maz@kernel.org>
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

Some EL2 system registers immediately affect the current execution
of the system, so we need to use their respective EL1 counterparts.
For this we need to define a mapping between the two. In general,
this only affects non-VHE guest hypervisors, as VHE system registers
are compatible with the EL1 counterparts.

These helpers will get used in subsequent patches.

Co-developed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h | 50 ++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 249b03fc2cce..4882905357f4 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -2,8 +2,9 @@
 #ifndef __ARM64_KVM_NESTED_H
 #define __ARM64_KVM_NESTED_H
 
-#include <asm/kvm_emulate.h>
+#include <linux/bitfield.h>
 #include <linux/kvm_host.h>
+#include <asm/kvm_emulate.h>
 
 static inline bool vcpu_has_nv(const struct kvm_vcpu *vcpu)
 {
@@ -12,6 +13,53 @@ static inline bool vcpu_has_nv(const struct kvm_vcpu *vcpu)
 		vcpu_has_feature(vcpu, KVM_ARM_VCPU_HAS_EL2));
 }
 
+/* Translation helpers from non-VHE EL2 to EL1 */
+static inline u64 tcr_el2_ps_to_tcr_el1_ips(u64 tcr_el2)
+{
+	return (u64)FIELD_GET(TCR_EL2_PS_MASK, tcr_el2) << TCR_IPS_SHIFT;
+}
+
+static inline u64 translate_tcr_el2_to_tcr_el1(u64 tcr)
+{
+	return TCR_EPD1_MASK |				/* disable TTBR1_EL1 */
+	       ((tcr & TCR_EL2_TBI) ? TCR_TBI0 : 0) |
+	       tcr_el2_ps_to_tcr_el1_ips(tcr) |
+	       (tcr & TCR_EL2_TG0_MASK) |
+	       (tcr & TCR_EL2_ORGN0_MASK) |
+	       (tcr & TCR_EL2_IRGN0_MASK) |
+	       (tcr & TCR_EL2_T0SZ_MASK);
+}
+
+static inline u64 translate_cptr_el2_to_cpacr_el1(u64 cptr_el2)
+{
+	u64 cpacr_el1 = 0;
+
+	if (cptr_el2 & CPTR_EL2_TTA)
+		cpacr_el1 |= CPACR_ELx_TTA;
+	if (!(cptr_el2 & CPTR_EL2_TFP))
+		cpacr_el1 |= CPACR_ELx_FPEN;
+	if (!(cptr_el2 & CPTR_EL2_TZ))
+		cpacr_el1 |= CPACR_ELx_ZEN;
+
+	return cpacr_el1;
+}
+
+static inline u64 translate_sctlr_el2_to_sctlr_el1(u64 val)
+{
+	/* Only preserve the minimal set of bits we support */
+	val &= (SCTLR_ELx_M | SCTLR_ELx_A | SCTLR_ELx_C | SCTLR_ELx_SA |
+		SCTLR_ELx_I | SCTLR_ELx_IESB | SCTLR_ELx_WXN | SCTLR_ELx_EE);
+	val |= SCTLR_EL1_RES1;
+
+	return val;
+}
+
+static inline u64 translate_ttbr0_el2_to_ttbr0_el1(u64 ttbr0)
+{
+	/* Clear the ASID field */
+	return ttbr0 & ~GENMASK_ULL(63, 48);
+}
+
 extern bool __check_nv_sr_forward(struct kvm_vcpu *vcpu);
 
 int kvm_init_nv_sysregs(struct kvm *kvm);
-- 
2.39.2


