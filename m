Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AADDE7667B4
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 10:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235042AbjG1Isx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 04:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235163AbjG1Ir4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 04:47:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3352738
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 01:47:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4488362067
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 08:47:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77CCC433C7;
        Fri, 28 Jul 2023 08:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690534047;
        bh=4BzR1NCOP+ORq+irY0Pl/wE9oH7q6Sq/SdYoZC9+tEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Axi5OjfCRbCAj84KrBvZ0w8D9x1/46/wDtm6EcE1XC53hhdCjKwF+jdxfyFR5vC7D
         q34IDnw46/140Emt/7IIlDIlPTtxTgw0SPayOjeXhkU8xWrNpLHqI2DMTxHhUgqZ+s
         /E6IOeCnRQ/A3NRRpFNtUIRiBf5c+2GiAFfcm5l3foCf3vUjaatPRyM+SxWB/IRRzf
         3HMDI3XdDvEjrJcUVIIwDJwA97wUOe/ZhapuOH6Rb7eHAuLC7RmYY2j1O+qmezq8ha
         pLPUVAvdnKLpYn63yG7qxkYhzQfYXaW69BteTLwIdEE+x+izPeZSbXzl78ys4eldKf
         PUX3z3KQXrYng==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qPIrK-0000EO-Hu;
        Fri, 28 Jul 2023 09:30:02 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v2 13/26] KVM: arm64: Restructure FGT register switching
Date:   Fri, 28 Jul 2023 09:29:39 +0100
Message-Id: <20230728082952.959212-14-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230728082952.959212-1-maz@kernel.org>
References: <20230728082952.959212-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, eric.auger@redhat.com, broonie@kernel.org, mark.rutland@arm.com, will@kernel.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As we're about to majorly extend the handling of FGT registers,
restructure the code to actually save/restore the registers
as required. This is made easy thanks to the previous addition
of the EL2 registers, allowing us to use the host context for
this purpose.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h        | 21 ++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h | 56 +++++++++++++------------
 2 files changed, 50 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 028049b147df..85908aa18908 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -333,6 +333,27 @@
 				 BIT(18) |		\
 				 GENMASK(16, 15))
 
+/*
+ * FGT register definitions
+ *
+ * RES0 and polarity masks as of DDI0487J.a, to be updated as needed.
+ * We're not using the generated masks as they are usually ahead of
+ * the published ARM ARM, which we use as a reference.
+ *
+ * Once we get to a point where the two describe the same thing, we'll
+ * merge the definitions. One day.
+ */
+#define __HFGRTR_EL2_RES0	(GENMASK(63, 56) | GENMASK(53, 51))
+#define __HFGRTR_EL2_MASK	GENMASK(49, 0)
+#define __HFGRTR_EL2_nMASK	(GENMASK(55, 54) | BIT(50))
+
+#define __HFGWTR_EL2_RES0	(GENMASK(63, 56) | GENMASK(53, 51) |	\
+				 BIT(46) | BIT(42) | BIT(40) | BIT(28) | \
+				 GENMASK(26, 25) | BIT(21) | BIT(18) |	\
+				 GENMASK(15, 14) | GENMASK(10, 9) | BIT(2))
+#define __HFGWTR_EL2_MASK	GENMASK(49, 0)
+#define __HFGWTR_EL2_nMASK	(GENMASK(55, 54) | BIT(50))
+
 /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
 #define HPFAR_MASK	(~UL(0xf))
 /*
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 4bddb8541bec..966295178aee 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -70,20 +70,19 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
 	}
 }
 
-static inline bool __hfgxtr_traps_required(void)
-{
-	if (cpus_have_final_cap(ARM64_SME))
-		return true;
-
-	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
-		return true;
 
-	return false;
-}
 
-static inline void __activate_traps_hfgxtr(void)
+static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
 	u64 r_clr = 0, w_clr = 0, r_set = 0, w_set = 0, tmp;
+	u64 r_val, w_val;
+
+	if (!cpus_have_final_cap(ARM64_HAS_FGT))
+		return;
+
+	ctxt_sys_reg(hctxt, HFGRTR_EL2) = read_sysreg_s(SYS_HFGRTR_EL2);
+	ctxt_sys_reg(hctxt, HFGWTR_EL2) = read_sysreg_s(SYS_HFGWTR_EL2);
 
 	if (cpus_have_final_cap(ARM64_SME)) {
 		tmp = HFGxTR_EL2_nSMPRI_EL1_MASK | HFGxTR_EL2_nTPIDR2_EL0_MASK;
@@ -98,26 +97,31 @@ static inline void __activate_traps_hfgxtr(void)
 	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
 		w_set |= HFGxTR_EL2_TCR_EL1_MASK;
 
-	sysreg_clear_set_s(SYS_HFGRTR_EL2, r_clr, r_set);
-	sysreg_clear_set_s(SYS_HFGWTR_EL2, w_clr, w_set);
+
+	/* The default is not to trap amything but ACCDATA_EL1 */
+	r_val = __HFGRTR_EL2_nMASK & ~HFGxTR_EL2_nACCDATA_EL1;
+	r_val |= r_set;
+	r_val &= ~r_clr;
+
+	w_val = __HFGWTR_EL2_nMASK & ~HFGxTR_EL2_nACCDATA_EL1;
+	w_val |= w_set;
+	w_val &= ~w_clr;
+
+	write_sysreg_s(r_val, SYS_HFGRTR_EL2);
+	write_sysreg_s(w_val, SYS_HFGWTR_EL2);
 }
 
-static inline void __deactivate_traps_hfgxtr(void)
+static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 {
-	u64 r_clr = 0, w_clr = 0, r_set = 0, w_set = 0, tmp;
+	struct kvm_cpu_context *hctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
 
-	if (cpus_have_final_cap(ARM64_SME)) {
-		tmp = HFGxTR_EL2_nSMPRI_EL1_MASK | HFGxTR_EL2_nTPIDR2_EL0_MASK;
+	if (!cpus_have_final_cap(ARM64_HAS_FGT))
+		return;
 
-		r_set |= tmp;
-		w_set |= tmp;
-	}
+	write_sysreg_s(ctxt_sys_reg(hctxt, HFGRTR_EL2), SYS_HFGRTR_EL2);
+	write_sysreg_s(ctxt_sys_reg(hctxt, HFGWTR_EL2), SYS_HFGWTR_EL2);
 
-	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
-		w_clr |= HFGxTR_EL2_TCR_EL1_MASK;
 
-	sysreg_clear_set_s(SYS_HFGRTR_EL2, r_clr, r_set);
-	sysreg_clear_set_s(SYS_HFGWTR_EL2, w_clr, w_set);
 }
 
 static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
@@ -145,8 +149,7 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 	vcpu->arch.mdcr_el2_host = read_sysreg(mdcr_el2);
 	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
 
-	if (__hfgxtr_traps_required())
-		__activate_traps_hfgxtr();
+	__activate_traps_hfgxtr(vcpu);
 }
 
 static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
@@ -162,8 +165,7 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
 		vcpu_clear_flag(vcpu, PMUSERENR_ON_CPU);
 	}
 
-	if (__hfgxtr_traps_required())
-		__deactivate_traps_hfgxtr();
+	__deactivate_traps_hfgxtr(vcpu);
 }
 
 static inline void ___activate_traps(struct kvm_vcpu *vcpu)
-- 
2.34.1

