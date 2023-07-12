Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1A2750C32
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 17:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233527AbjGLPRc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 11:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233537AbjGLPRa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 11:17:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EEDA1BFF
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 08:17:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0EDB6186B
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 15:17:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33918C433C9;
        Wed, 12 Jul 2023 15:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689175036;
        bh=qFiFCwf9NqO0iROI75+6lAUsxudw2m4gH6UKyYL4dW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OoUZFlzCbmAF2+gAlcnxd9WSk1eXLyfM/rb21XerbUo8D50XBIuYU4QWUi7BaM5Ij
         kALFGEzhT4XraOkpGTdE5/dd9lwXidbtK5X5iCY2a694NMtAIaOj1t0XCXa1V+vYjY
         ajhXmrhDVuVeoHfDQOoQyllBd8fC1uBkhwn5bnTxtebzd5PvK4R8D8LeRyqfV4sUB5
         PQWcy3XvJHB+1/iWKqWLyfEwj5cfzPHSS93CGlIdu07WJVecA0M9G1mzZE1CTt41pW
         YSoCpwPspxp2PoGwxL1FeVRNtPMWcOtKLCWUIRP5XLMjTAurTEfqqWVSbdvuODX9DT
         tCqICpPPM7hkQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qJbIr-00CUNF-2M;
        Wed, 12 Jul 2023 15:58:53 +0100
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
Subject: [PATCH 20/27] KVM: arm64: nv: Add trap forwarding for HFGxTR_EL2
Date:   Wed, 12 Jul 2023 15:58:03 +0100
Message-Id: <20230712145810.3864793-21-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230712145810.3864793-1-maz@kernel.org>
References: <20230712145810.3864793-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, eric.auger@redhat.com, broonie@kernel.org, mark.rutland@arm.com, will@kernel.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fine Grained Traps are fun. Not.

Implement the trap forwarding for traps describer by HFGxTR_EL2,
reusing the Coarse Grained Traps infrastructure previously implemented.

Each sysreg/instruction inserted in the xarray gets a FGT group
(vaguely equivalent to a register number), a bit number in that register,
and a polarity.

It is then pretty easy to check the FGT state at handling time, just
like we do for the coarse version (it is just faster).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 133 +++++++++++++++++++++++++++++++-
 1 file changed, 132 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index c07c0f3361d7..51b9df19bdfa 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -894,6 +894,88 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initdata = {
 
 static DEFINE_XARRAY(sr_forward_xa);
 
+enum fgt_group_id {
+	__NO_FGT_GROUP__,
+	HFGxTR_GROUP,
+};
+
+#define SR_FGT(sr, g, b, p)					\
+	{							\
+		.encoding	= sr,				\
+		.end		= sr,				\
+		.tc		= {				\
+			.fgt = g ## _GROUP,			\
+			.bit = g ## _EL2_ ## b ## _SHIFT,	\
+			.pol = p,				\
+		},						\
+	}
+
+static const struct encoding_to_trap_config encoding_to_fgt[] __initdata = {
+	/* HFGTR_EL2, HFGWTR_EL2 */
+	SR_FGT(SYS_TPIDR2_EL0,		HFGxTR, nTPIDR2_EL0, 0),
+	SR_FGT(SYS_SMPRI_EL1,		HFGxTR, nSMPRI_EL1, 0),
+	SR_FGT(SYS_ACCDATA_EL1,		HFGxTR, nACCDATA_EL1, 0),
+	SR_FGT(SYS_ERXADDR_EL1,		HFGxTR, ERXADDR_EL1, 1),
+	SR_FGT(SYS_ERXPFGCDN_EL1,	HFGxTR, ERXPFGCDN_EL1, 1),
+	SR_FGT(SYS_ERXPFGCTL_EL1,	HFGxTR, ERXPFGCTL_EL1, 1),
+	SR_FGT(SYS_ERXPFGF_EL1,		HFGxTR, ERXPFGF_EL1, 1),
+	SR_FGT(SYS_ERXMISC0_EL1,	HFGxTR, ERXMISCn_EL1, 1),
+	SR_FGT(SYS_ERXMISC1_EL1,	HFGxTR, ERXMISCn_EL1, 1),
+	SR_FGT(SYS_ERXMISC2_EL1,	HFGxTR, ERXMISCn_EL1, 1),
+	SR_FGT(SYS_ERXMISC3_EL1,	HFGxTR, ERXMISCn_EL1, 1),
+	SR_FGT(SYS_ERXSTATUS_EL1,	HFGxTR, ERXSTATUS_EL1, 1),
+	SR_FGT(SYS_ERXCTLR_EL1,		HFGxTR, ERXCTLR_EL1, 1),
+	SR_FGT(SYS_ERXFR_EL1,		HFGxTR, ERXFR_EL1, 1),
+	SR_FGT(SYS_ERRSELR_EL1,		HFGxTR, ERRSELR_EL1, 1),
+	SR_FGT(SYS_ERRIDR_EL1,		HFGxTR, ERRIDR_EL1, 1),
+	SR_FGT(SYS_ICC_IGRPEN0_EL1,	HFGxTR, ICC_IGRPENn_EL1, 1),
+	SR_FGT(SYS_ICC_IGRPEN1_EL1,	HFGxTR, ICC_IGRPENn_EL1, 1),
+	SR_FGT(SYS_VBAR_EL1,		HFGxTR, VBAR_EL1, 1),
+	SR_FGT(SYS_TTBR1_EL1,		HFGxTR, TTBR1_EL1, 1),
+	SR_FGT(SYS_TTBR0_EL1,		HFGxTR, TTBR0_EL1, 1),
+	SR_FGT(SYS_TPIDR_EL0,		HFGxTR, TPIDR_EL0, 1),
+	SR_FGT(SYS_TPIDRRO_EL0,		HFGxTR, TPIDRRO_EL0, 1),
+	SR_FGT(SYS_TPIDR_EL1,		HFGxTR, TPIDR_EL1, 1),
+	SR_FGT(SYS_TCR_EL1,		HFGxTR, TCR_EL1, 1),
+	SR_FGT(SYS_SCXTNUM_EL0,		HFGxTR, SCXTNUM_EL0, 1),
+	SR_FGT(SYS_SCXTNUM_EL1, 	HFGxTR, SCXTNUM_EL1, 1),
+	SR_FGT(SYS_SCTLR_EL1, 		HFGxTR, SCTLR_EL1, 1),
+	SR_FGT(SYS_REVIDR_EL1, 		HFGxTR, REVIDR_EL1, 1),
+	SR_FGT(SYS_PAR_EL1, 		HFGxTR, PAR_EL1, 1),
+	SR_FGT(SYS_MPIDR_EL1, 		HFGxTR, MPIDR_EL1, 1),
+	SR_FGT(SYS_MIDR_EL1, 		HFGxTR, MIDR_EL1, 1),
+	SR_FGT(SYS_MAIR_EL1, 		HFGxTR, MAIR_EL1, 1),
+	SR_FGT(SYS_LORSA_EL1, 		HFGxTR, LORSA_EL1, 1),
+	SR_FGT(SYS_LORN_EL1, 		HFGxTR, LORN_EL1, 1),
+	SR_FGT(SYS_LORID_EL1, 		HFGxTR, LORID_EL1, 1),
+	SR_FGT(SYS_LOREA_EL1, 		HFGxTR, LOREA_EL1, 1),
+	SR_FGT(SYS_LORC_EL1, 		HFGxTR, LORC_EL1, 1),
+	SR_FGT(SYS_ISR_EL1, 		HFGxTR, ISR_EL1, 1),
+	SR_FGT(SYS_FAR_EL1, 		HFGxTR, FAR_EL1, 1),
+	SR_FGT(SYS_ESR_EL1, 		HFGxTR, ESR_EL1, 1),
+	SR_FGT(SYS_DCZID_EL0, 		HFGxTR, DCZID_EL0, 1),
+	SR_FGT(SYS_CTR_EL0, 		HFGxTR, CTR_EL0, 1),
+	SR_FGT(SYS_CSSELR_EL1, 		HFGxTR, CSSELR_EL1, 1),
+	SR_FGT(SYS_CPACR_EL1, 		HFGxTR, CPACR_EL1, 1),
+	SR_FGT(SYS_CONTEXTIDR_EL1, 	HFGxTR, CONTEXTIDR_EL1, 1),
+	SR_FGT(SYS_CLIDR_EL1, 		HFGxTR, CLIDR_EL1, 1),
+	SR_FGT(SYS_CCSIDR_EL1, 		HFGxTR, CCSIDR_EL1, 1),
+	SR_FGT(SYS_APIBKEYLO_EL1, 	HFGxTR, APIBKey, 1),
+	SR_FGT(SYS_APIBKEYHI_EL1, 	HFGxTR, APIBKey, 1),
+	SR_FGT(SYS_APIAKEYLO_EL1, 	HFGxTR, APIAKey, 1),
+	SR_FGT(SYS_APIAKEYHI_EL1, 	HFGxTR, APIAKey, 1),
+	SR_FGT(SYS_APGAKEYLO_EL1, 	HFGxTR, APGAKey, 1),
+	SR_FGT(SYS_APGAKEYHI_EL1, 	HFGxTR, APGAKey, 1),
+	SR_FGT(SYS_APDBKEYLO_EL1, 	HFGxTR, APDBKey, 1),
+	SR_FGT(SYS_APDBKEYHI_EL1, 	HFGxTR, APDBKey, 1),
+	SR_FGT(SYS_APDAKEYLO_EL1, 	HFGxTR, APDAKey, 1),
+	SR_FGT(SYS_APDAKEYHI_EL1, 	HFGxTR, APDAKey, 1),
+	SR_FGT(SYS_AMAIR_EL1, 		HFGxTR, AMAIR_EL1, 1),
+	SR_FGT(SYS_AIDR_EL1, 		HFGxTR, AIDR_EL1, 1),
+	SR_FGT(SYS_AFSR1_EL1, 		HFGxTR, AFSR1_EL1, 1),
+	SR_FGT(SYS_AFSR0_EL1, 		HFGxTR, AFSR0_EL1, 1),
+};
+
 static union trap_config get_trap_config(u32 sysreg)
 {
 	return (union trap_config) {
@@ -915,6 +997,27 @@ void __init populate_nv_trap_config(void)
 	kvm_info("nv: %ld coarse grained trap handlers\n",
 		 ARRAY_SIZE(encoding_to_cgt));
 
+	for (int i = 0; i < ARRAY_SIZE(encoding_to_fgt); i++) {
+		const struct encoding_to_trap_config *fgt = &encoding_to_fgt[i];
+		union trap_config tc;
+
+		tc = get_trap_config(fgt->encoding);
+
+		WARN(tc.fgt,
+		     "Duplicate FGT for sys_reg(%d, %d, %d, %d, %d)\n",
+		     sys_reg_Op0(fgt->encoding),
+		     sys_reg_Op1(fgt->encoding),
+		     sys_reg_CRn(fgt->encoding),
+		     sys_reg_CRm(fgt->encoding),
+		     sys_reg_Op2(fgt->encoding));
+
+		tc.val |= fgt->tc.val;
+		xa_store(&sr_forward_xa, fgt->encoding,
+			 xa_mk_value(tc.val), GFP_KERNEL);
+	}
+
+	kvm_info("nv: %ld fine grained trap handlers\n",
+		 ARRAY_SIZE(encoding_to_fgt));
 }
 
 static enum trap_behaviour get_behaviour(struct kvm_vcpu *vcpu,
@@ -964,13 +1067,26 @@ static enum trap_behaviour compute_behaviour(struct kvm_vcpu *vcpu,
 	return __do_compute_behaviour(vcpu, tc.cgt, b);
 }
 
+static bool check_fgt_bit(u64 val, const union trap_config tc)
+{
+	return ((val >> tc.bit) & 1) == tc.pol;
+}
+
+#define sanitised_sys_reg(vcpu, reg)			\
+	({						\
+		u64 __val;				\
+		__val = __vcpu_sys_reg(vcpu, reg);	\
+		__val &= ~__ ## reg ## _RES0;		\
+		(__val);				\
+	})
+
 bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
 {
 	union trap_config tc;
 	enum trap_behaviour b;
 	bool is_read;
 	u32 sysreg;
-	u64 esr;
+	u64 esr, val;
 
 	if (!vcpu_has_nv(vcpu) || is_hyp_ctxt(vcpu))
 		return false;
@@ -981,6 +1097,21 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
 
 	tc = get_trap_config(sysreg);
 
+	switch ((enum fgt_group_id)tc.fgt) {
+	case __NO_FGT_GROUP__:
+		break;
+
+	case HFGxTR_GROUP:
+		if (is_read)
+			val = sanitised_sys_reg(vcpu, HFGRTR_EL2);
+		else
+			val = sanitised_sys_reg(vcpu, HFGWTR_EL2);
+		break;
+	}
+
+	if (tc.fgt != __NO_FGT_GROUP__ && check_fgt_bit(val, tc))
+		goto inject;
+
 	b = compute_behaviour(vcpu, tc);
 
 	if (((b & BEHAVE_FORWARD_READ) && is_read) ||
-- 
2.34.1

