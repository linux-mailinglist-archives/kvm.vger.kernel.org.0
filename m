Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B87A7667A6
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 10:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235134AbjG1Irw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 04:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235131AbjG1IrU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 04:47:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665AA3A93
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 01:47:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEFF862064
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 08:47:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24FB9C433CA;
        Fri, 28 Jul 2023 08:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690534036;
        bh=3YV1lCeZm9WHk6m5k4lSdNsxPkAA+Wwr3Y/DiYqxSgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ipRizDiJ2U3TOn5in7d08sYHWMvc4KOaMatK1o8s+Ki+5tgxy1IXZtbbCwv4bkw3Z
         anPWGKQ6gkuopayhZYj1LGu/aTtlKIZ4mv91TioPVcPMildxbf9aEYq9nMeUU1+7xo
         IQ7pOjVONqubX6mqY/g/uz648FTsom55tZZOFXKx04GefP0nkwRamNmfkKMhz/IKa2
         0WJtxNkq3mDO3eYK8P1MTUPdVkkj744Itn6yClRzOg/CFvoudaWrDT7r/v0tLCYD8H
         7tj3ObeuxrtwkQNWQrbTwUFBPab9hHV26tUGFj3RoH3qVaICpyEpnEevzVzhgCDEhc
         81NfdT6MNNusg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qPIrM-0000EO-LW;
        Fri, 28 Jul 2023 09:30:04 +0100
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
Subject: [PATCH v2 20/26] KVM: arm64: nv: Add trap forwarding for HFGITR_EL2
Date:   Fri, 28 Jul 2023 09:29:46 +0100
Message-Id: <20230728082952.959212-21-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230728082952.959212-1-maz@kernel.org>
References: <20230728082952.959212-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, eric.auger@redhat.com, broonie@kernel.org, mark.rutland@arm.com, will@kernel.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Similarly, implement the trap forwarding for instructions affected
by HFGITR_EL2.

Note that the TLBI*nXS instructions should be affected by HCRX_EL2,
which will be dealt with down the line.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h |   4 ++
 arch/arm64/kvm/emulate-nested.c  | 109 +++++++++++++++++++++++++++++++
 2 files changed, 113 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 85908aa18908..809bc86acefd 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -354,6 +354,10 @@
 #define __HFGWTR_EL2_MASK	GENMASK(49, 0)
 #define __HFGWTR_EL2_nMASK	(GENMASK(55, 54) | BIT(50))
 
+#define __HFGITR_EL2_RES0	GENMASK(63, 57)
+#define __HFGITR_EL2_MASK	GENMASK(54, 0)
+#define __HFGITR_EL2_nMASK	GENMASK(56, 55)
+
 /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
 #define HPFAR_MASK	(~UL(0xf))
 /*
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 5f4cf824eadc..72619d845cc8 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -925,6 +925,7 @@ static DEFINE_XARRAY(sr_forward_xa);
 enum fgt_group_id {
 	__NO_FGT_GROUP__,
 	HFGxTR_GROUP,
+	HFGITR_GROUP,
 };
 
 #define SR_FGT(sr, g, b, p)					\
@@ -1002,6 +1003,110 @@ static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
 	SR_FGT(SYS_AIDR_EL1, 		HFGxTR, AIDR_EL1, 1),
 	SR_FGT(SYS_AFSR1_EL1, 		HFGxTR, AFSR1_EL1, 1),
 	SR_FGT(SYS_AFSR0_EL1, 		HFGxTR, AFSR0_EL1, 1),
+	/* HFGITR_EL2 */
+	SR_FGT(OP_BRB_IALL, 		HFGITR, nBRBIALL, 0),
+	SR_FGT(OP_BRB_INJ, 		HFGITR, nBRBINJ, 0),
+	SR_FGT(SYS_DC_CVAC, 		HFGITR, DCCVAC, 1),
+	SR_FGT(SYS_DC_CGVAC, 		HFGITR, DCCVAC, 1),
+	SR_FGT(SYS_DC_CGDVAC, 		HFGITR, DCCVAC, 1),
+	SR_FGT(OP_CPP_RCTX, 		HFGITR, CPPRCTX, 1),
+	SR_FGT(OP_DVP_RCTX, 		HFGITR, DVPRCTX, 1),
+	SR_FGT(OP_CFP_RCTX, 		HFGITR, CFPRCTX, 1),
+	SR_FGT(OP_TLBI_VAALE1, 		HFGITR, TLBIVAALE1, 1),
+	SR_FGT(OP_TLBI_VALE1, 		HFGITR, TLBIVALE1, 1),
+	SR_FGT(OP_TLBI_VAAE1, 		HFGITR, TLBIVAAE1, 1),
+	SR_FGT(OP_TLBI_ASIDE1, 		HFGITR, TLBIASIDE1, 1),
+	SR_FGT(OP_TLBI_VAE1, 		HFGITR, TLBIVAE1, 1),
+	SR_FGT(OP_TLBI_VMALLE1, 	HFGITR, TLBIVMALLE1, 1),
+	SR_FGT(OP_TLBI_RVAALE1, 	HFGITR, TLBIRVAALE1, 1),
+	SR_FGT(OP_TLBI_RVALE1, 		HFGITR, TLBIRVALE1, 1),
+	SR_FGT(OP_TLBI_RVAAE1, 		HFGITR, TLBIRVAAE1, 1),
+	SR_FGT(OP_TLBI_RVAE1, 		HFGITR, TLBIRVAE1, 1),
+	SR_FGT(OP_TLBI_RVAALE1IS, 	HFGITR, TLBIRVAALE1IS, 1),
+	SR_FGT(OP_TLBI_RVALE1IS, 	HFGITR, TLBIRVALE1IS, 1),
+	SR_FGT(OP_TLBI_RVAAE1IS, 	HFGITR, TLBIRVAAE1IS, 1),
+	SR_FGT(OP_TLBI_RVAE1IS, 	HFGITR, TLBIRVAE1IS, 1),
+	SR_FGT(OP_TLBI_VAALE1IS, 	HFGITR, TLBIVAALE1IS, 1),
+	SR_FGT(OP_TLBI_VALE1IS, 	HFGITR, TLBIVALE1IS, 1),
+	SR_FGT(OP_TLBI_VAAE1IS, 	HFGITR, TLBIVAAE1IS, 1),
+	SR_FGT(OP_TLBI_ASIDE1IS, 	HFGITR, TLBIASIDE1IS, 1),
+	SR_FGT(OP_TLBI_VAE1IS, 		HFGITR, TLBIVAE1IS, 1),
+	SR_FGT(OP_TLBI_VMALLE1IS, 	HFGITR, TLBIVMALLE1IS, 1),
+	SR_FGT(OP_TLBI_RVAALE1OS, 	HFGITR, TLBIRVAALE1OS, 1),
+	SR_FGT(OP_TLBI_RVALE1OS, 	HFGITR, TLBIRVALE1OS, 1),
+	SR_FGT(OP_TLBI_RVAAE1OS, 	HFGITR, TLBIRVAAE1OS, 1),
+	SR_FGT(OP_TLBI_RVAE1OS, 	HFGITR, TLBIRVAE1OS, 1),
+	SR_FGT(OP_TLBI_VAALE1OS, 	HFGITR, TLBIVAALE1OS, 1),
+	SR_FGT(OP_TLBI_VALE1OS, 	HFGITR, TLBIVALE1OS, 1),
+	SR_FGT(OP_TLBI_VAAE1OS, 	HFGITR, TLBIVAAE1OS, 1),
+	SR_FGT(OP_TLBI_ASIDE1OS, 	HFGITR, TLBIASIDE1OS, 1),
+	SR_FGT(OP_TLBI_VAE1OS, 		HFGITR, TLBIVAE1OS, 1),
+	SR_FGT(OP_TLBI_VMALLE1OS, 	HFGITR, TLBIVMALLE1OS, 1),
+	/* FIXME: nXS variants must be checked against HCRX_EL2.FGTnXS */
+	SR_FGT(OP_TLBI_VAALE1NXS, 	HFGITR, TLBIVAALE1, 1),
+	SR_FGT(OP_TLBI_VALE1NXS, 	HFGITR, TLBIVALE1, 1),
+	SR_FGT(OP_TLBI_VAAE1NXS, 	HFGITR, TLBIVAAE1, 1),
+	SR_FGT(OP_TLBI_ASIDE1NXS, 	HFGITR, TLBIASIDE1, 1),
+	SR_FGT(OP_TLBI_VAE1NXS, 	HFGITR, TLBIVAE1, 1),
+	SR_FGT(OP_TLBI_VMALLE1NXS, 	HFGITR, TLBIVMALLE1, 1),
+	SR_FGT(OP_TLBI_RVAALE1NXS, 	HFGITR, TLBIRVAALE1, 1),
+	SR_FGT(OP_TLBI_RVALE1NXS, 	HFGITR, TLBIRVALE1, 1),
+	SR_FGT(OP_TLBI_RVAAE1NXS, 	HFGITR, TLBIRVAAE1, 1),
+	SR_FGT(OP_TLBI_RVAE1NXS, 	HFGITR, TLBIRVAE1, 1),
+	SR_FGT(OP_TLBI_RVAALE1ISNXS, 	HFGITR, TLBIRVAALE1IS, 1),
+	SR_FGT(OP_TLBI_RVALE1ISNXS, 	HFGITR, TLBIRVALE1IS, 1),
+	SR_FGT(OP_TLBI_RVAAE1ISNXS, 	HFGITR, TLBIRVAAE1IS, 1),
+	SR_FGT(OP_TLBI_RVAE1ISNXS, 	HFGITR, TLBIRVAE1IS, 1),
+	SR_FGT(OP_TLBI_VAALE1ISNXS, 	HFGITR, TLBIVAALE1IS, 1),
+	SR_FGT(OP_TLBI_VALE1ISNXS, 	HFGITR, TLBIVALE1IS, 1),
+	SR_FGT(OP_TLBI_VAAE1ISNXS, 	HFGITR, TLBIVAAE1IS, 1),
+	SR_FGT(OP_TLBI_ASIDE1ISNXS, 	HFGITR, TLBIASIDE1IS, 1),
+	SR_FGT(OP_TLBI_VAE1ISNXS, 	HFGITR, TLBIVAE1IS, 1),
+	SR_FGT(OP_TLBI_VMALLE1ISNXS, 	HFGITR, TLBIVMALLE1IS, 1),
+	SR_FGT(OP_TLBI_RVAALE1OSNXS, 	HFGITR, TLBIRVAALE1OS, 1),
+	SR_FGT(OP_TLBI_RVALE1OSNXS, 	HFGITR, TLBIRVALE1OS, 1),
+	SR_FGT(OP_TLBI_RVAAE1OSNXS, 	HFGITR, TLBIRVAAE1OS, 1),
+	SR_FGT(OP_TLBI_RVAE1OSNXS, 	HFGITR, TLBIRVAE1OS, 1),
+	SR_FGT(OP_TLBI_VAALE1OSNXS, 	HFGITR, TLBIVAALE1OS, 1),
+	SR_FGT(OP_TLBI_VALE1OSNXS, 	HFGITR, TLBIVALE1OS, 1),
+	SR_FGT(OP_TLBI_VAAE1OSNXS, 	HFGITR, TLBIVAAE1OS, 1),
+	SR_FGT(OP_TLBI_ASIDE1OSNXS, 	HFGITR, TLBIASIDE1OS, 1),
+	SR_FGT(OP_TLBI_VAE1OSNXS, 	HFGITR, TLBIVAE1OS, 1),
+	SR_FGT(OP_TLBI_VMALLE1OSNXS, 	HFGITR, TLBIVMALLE1OS, 1),
+	SR_FGT(OP_AT_S1E1WP, 		HFGITR, ATS1E1WP, 1),
+	SR_FGT(OP_AT_S1E1RP, 		HFGITR, ATS1E1RP, 1),
+	SR_FGT(OP_AT_S1E0W, 		HFGITR, ATS1E0W, 1),
+	SR_FGT(OP_AT_S1E0R, 		HFGITR, ATS1E0R, 1),
+	SR_FGT(OP_AT_S1E1W, 		HFGITR, ATS1E1W, 1),
+	SR_FGT(OP_AT_S1E1R, 		HFGITR, ATS1E1R, 1),
+	SR_FGT(SYS_DC_ZVA, 		HFGITR, DCZVA, 1),
+	SR_FGT(SYS_DC_GVA, 		HFGITR, DCZVA, 1),
+	SR_FGT(SYS_DC_GZVA, 		HFGITR, DCZVA, 1),
+	SR_FGT(SYS_DC_CIVAC, 		HFGITR, DCCIVAC, 1),
+	SR_FGT(SYS_DC_CIGVAC, 		HFGITR, DCCIVAC, 1),
+	SR_FGT(SYS_DC_CIGDVAC, 		HFGITR, DCCIVAC, 1),
+	SR_FGT(SYS_DC_CVADP, 		HFGITR, DCCVADP, 1),
+	SR_FGT(SYS_DC_CGVADP, 		HFGITR, DCCVADP, 1),
+	SR_FGT(SYS_DC_CGDVADP, 		HFGITR, DCCVADP, 1),
+	SR_FGT(SYS_DC_CVAP, 		HFGITR, DCCVAP, 1),
+	SR_FGT(SYS_DC_CGVAP, 		HFGITR, DCCVAP, 1),
+	SR_FGT(SYS_DC_CGDVAP, 		HFGITR, DCCVAP, 1),
+	SR_FGT(SYS_DC_CVAU, 		HFGITR, DCCVAU, 1),
+	SR_FGT(SYS_DC_CISW, 		HFGITR, DCCISW, 1),
+	SR_FGT(SYS_DC_CIGSW, 		HFGITR, DCCISW, 1),
+	SR_FGT(SYS_DC_CIGDSW, 		HFGITR, DCCISW, 1),
+	SR_FGT(SYS_DC_CSW, 		HFGITR, DCCSW, 1),
+	SR_FGT(SYS_DC_CGSW, 		HFGITR, DCCSW, 1),
+	SR_FGT(SYS_DC_CGDSW, 		HFGITR, DCCSW, 1),
+	SR_FGT(SYS_DC_ISW, 		HFGITR, DCISW, 1),
+	SR_FGT(SYS_DC_IGSW, 		HFGITR, DCISW, 1),
+	SR_FGT(SYS_DC_IGDSW, 		HFGITR, DCISW, 1),
+	SR_FGT(SYS_DC_IVAC, 		HFGITR, DCIVAC, 1),
+	SR_FGT(SYS_DC_IGVAC, 		HFGITR, DCIVAC, 1),
+	SR_FGT(SYS_DC_IGDVAC, 		HFGITR, DCIVAC, 1),
+	SR_FGT(SYS_IC_IVAU, 		HFGITR, ICIVAU, 1),
+	SR_FGT(SYS_IC_IALLU, 		HFGITR, ICIALLU, 1),
+	SR_FGT(SYS_IC_IALLUIS, 		HFGITR, ICIALLUIS, 1),
 };
 
 static union trap_config get_trap_config(u32 sysreg)
@@ -1135,6 +1240,10 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
 		else
 			val = sanitised_sys_reg(vcpu, HFGWTR_EL2);
 		break;
+
+	case HFGITR_GROUP:
+		val = sanitised_sys_reg(vcpu, HFGITR_EL2);
+		break;
 	}
 
 	if (tc.fgt != __NO_FGT_GROUP__ && check_fgt_bit(val, tc))
-- 
2.34.1

