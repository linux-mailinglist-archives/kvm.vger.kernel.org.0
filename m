Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA77777D27A
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 20:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239527AbjHOSuf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 14:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239646AbjHOSuW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 14:50:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F872691
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 11:49:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65CF465F34
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 18:47:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A357CC433C8;
        Tue, 15 Aug 2023 18:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692125250;
        bh=WFcNBIzuCGpIeRjjw0m57t/RNOnSRX8iJW07dM4buws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nWRaSQ6QG8T6G5pDuVd8b9gpGfHWHkAbDdo2dCvPZ6ZtDKL4nvDDUOC46Vu9ThT5N
         eoM1zrfbUI//Dim8LA1Qe03CbDM++dGpdfJ6FCCxpTQaVvjryq/B1bZQ0Bv+5kuPc2
         QkWxm/X3rvL/+FbsvyV24XtBEK29dLDrHeVkJ5yLH/3EOQ0r3/Iue2TP2glNXHmsZU
         HwyoX39mkK5P3Oyh1V8APVAuUb/o+61E9I7aVb4ygIC7ytShTmiFGqGMkApQMHyAz8
         r8uqjTw64ltQiKXO4sK64PpxxTIvnrjakTo8dSZXMkwiI0QE9chkK9wUCflcNQpcMD
         WOMcpQ1QAduVA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qVyws-0055Sd-QH;
        Tue, 15 Aug 2023 19:39:22 +0100
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
        Jing Zhang <jingzhangos@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v4 28/28] KVM: arm64: nv: Add support for HCRX_EL2
Date:   Tue, 15 Aug 2023 19:39:02 +0100
Message-Id: <20230815183903.2735724-29-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230815183903.2735724-1-maz@kernel.org>
References: <20230815183903.2735724-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, eric.auger@redhat.com, broonie@kernel.org, mark.rutland@arm.com, will@kernel.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, miguel.luis@oracle.com, jingzhangos@google.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

HCRX_EL2 has an interesting effect on HFGITR_EL2, as it conditions
the traps of TLBI*nXS.

Expand the FGT support to add a new Fine Grained Filter that will
get checked when the instruction gets trapped, allowing the shadow
register to override the trap as needed.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h        |  5 ++
 arch/arm64/include/asm/kvm_host.h       |  1 +
 arch/arm64/kvm/emulate-nested.c         | 94 ++++++++++++++++---------
 arch/arm64/kvm/hyp/include/hyp/switch.h | 15 +++-
 arch/arm64/kvm/nested.c                 |  3 +-
 arch/arm64/kvm/sys_regs.c               |  2 +
 6 files changed, 83 insertions(+), 37 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index d229f238c3b6..137f732789c9 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -369,6 +369,11 @@
 #define __HDFGWTR_EL2_MASK	~__HDFGWTR_EL2_nMASK
 #define __HDFGWTR_EL2_nMASK	GENMASK(62, 60)
 
+/* Similar definitions for HCRX_EL2 */
+#define __HCRX_EL2_RES0		(GENMASK(63, 16) | GENMASK(13, 12))
+#define __HCRX_EL2_MASK		(0)
+#define __HCRX_EL2_nMASK	(GENMASK(15, 14) | GENMASK(4, 0))
+
 /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
 #define HPFAR_MASK	(~UL(0xf))
 /*
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index cb1c5c54cedd..93c541111dea 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -380,6 +380,7 @@ enum vcpu_sysreg {
 	CPTR_EL2,	/* Architectural Feature Trap Register (EL2) */
 	HSTR_EL2,	/* Hypervisor System Trap Register */
 	HACR_EL2,	/* Hypervisor Auxiliary Control Register */
+	HCRX_EL2,	/* Extended Hypervisor Configuration Register */
 	TTBR0_EL2,	/* Translation Table Base Register 0 (EL2) */
 	TTBR1_EL2,	/* Translation Table Base Register 1 (EL2) */
 	TCR_EL2,	/* Translation Control Register (EL2) */
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index c9662f9a345e..1cc606c16416 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -426,11 +426,13 @@ static const complex_condition_check ccc[] = {
  * [13:10]	enum fgt_group_id (4 bits)
  * [19:14]	bit number in the FGT register (6 bits)
  * [20]		trap polarity (1 bit)
- * [62:21]	Unused (42 bits)
+ * [25:21]	FG filter (5 bits)
+ * [62:26]	Unused (37 bits)
  * [63]		RES0 - Must be zero, as lost on insertion in the xarray
  */
 #define TC_CGT_BITS	10
 #define TC_FGT_BITS	4
+#define TC_FGF_BITS	5
 
 union trap_config {
 	u64	val;
@@ -439,7 +441,8 @@ union trap_config {
 		unsigned long	fgt:TC_FGT_BITS; /* Fine Grained Trap id */
 		unsigned long	bit:6;		 /* Bit number */
 		unsigned long	pol:1;		 /* Polarity */
-		unsigned long	unused:42;	 /* Unused, should be zero */
+		unsigned long	fgf:TC_FGF_BITS; /* Fine Grained Filter */
+		unsigned long	unused:37;	 /* Unused, should be zero */
 		unsigned long	mbz:1;		 /* Must Be Zero */
 	};
 };
@@ -947,7 +950,15 @@ enum fgt_group_id {
 	__NR_FGT_GROUP_IDS__
 };
 
-#define SR_FGT(sr, g, b, p)					\
+enum fg_filter_id {
+	__NO_FGF__,
+	HCRX_FGTnXS,
+
+	/* Must be last */
+	__NR_FG_FILTER_IDS__
+};
+
+#define SR_FGF(sr, g, b, p, f)					\
 	{							\
 		.encoding	= sr,				\
 		.end		= sr,				\
@@ -955,10 +966,13 @@ enum fgt_group_id {
 			.fgt = g ## _GROUP,			\
 			.bit = g ## _EL2_ ## b ## _SHIFT,	\
 			.pol = p,				\
+			.fgf = f,				\
 		},						\
 		.line = __LINE__,				\
 	}
 
+#define SR_FGT(sr, g, b, p)	SR_FGF(sr, g, b, p, __NO_FGF__)
+
 static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
 	/* HFGRTR_EL2, HFGWTR_EL2 */
 	SR_FGT(SYS_TPIDR2_EL0,		HFGxTR, nTPIDR2_EL0, 0),
@@ -1062,37 +1076,37 @@ static const struct encoding_to_trap_config encoding_to_fgt[] __initconst = {
 	SR_FGT(OP_TLBI_ASIDE1OS, 	HFGITR, TLBIASIDE1OS, 1),
 	SR_FGT(OP_TLBI_VAE1OS, 		HFGITR, TLBIVAE1OS, 1),
 	SR_FGT(OP_TLBI_VMALLE1OS, 	HFGITR, TLBIVMALLE1OS, 1),
-	/* FIXME: nXS variants must be checked against HCRX_EL2.FGTnXS */
-	SR_FGT(OP_TLBI_VAALE1NXS, 	HFGITR, TLBIVAALE1, 1),
-	SR_FGT(OP_TLBI_VALE1NXS, 	HFGITR, TLBIVALE1, 1),
-	SR_FGT(OP_TLBI_VAAE1NXS, 	HFGITR, TLBIVAAE1, 1),
-	SR_FGT(OP_TLBI_ASIDE1NXS, 	HFGITR, TLBIASIDE1, 1),
-	SR_FGT(OP_TLBI_VAE1NXS, 	HFGITR, TLBIVAE1, 1),
-	SR_FGT(OP_TLBI_VMALLE1NXS, 	HFGITR, TLBIVMALLE1, 1),
-	SR_FGT(OP_TLBI_RVAALE1NXS, 	HFGITR, TLBIRVAALE1, 1),
-	SR_FGT(OP_TLBI_RVALE1NXS, 	HFGITR, TLBIRVALE1, 1),
-	SR_FGT(OP_TLBI_RVAAE1NXS, 	HFGITR, TLBIRVAAE1, 1),
-	SR_FGT(OP_TLBI_RVAE1NXS, 	HFGITR, TLBIRVAE1, 1),
-	SR_FGT(OP_TLBI_RVAALE1ISNXS, 	HFGITR, TLBIRVAALE1IS, 1),
-	SR_FGT(OP_TLBI_RVALE1ISNXS, 	HFGITR, TLBIRVALE1IS, 1),
-	SR_FGT(OP_TLBI_RVAAE1ISNXS, 	HFGITR, TLBIRVAAE1IS, 1),
-	SR_FGT(OP_TLBI_RVAE1ISNXS, 	HFGITR, TLBIRVAE1IS, 1),
-	SR_FGT(OP_TLBI_VAALE1ISNXS, 	HFGITR, TLBIVAALE1IS, 1),
-	SR_FGT(OP_TLBI_VALE1ISNXS, 	HFGITR, TLBIVALE1IS, 1),
-	SR_FGT(OP_TLBI_VAAE1ISNXS, 	HFGITR, TLBIVAAE1IS, 1),
-	SR_FGT(OP_TLBI_ASIDE1ISNXS, 	HFGITR, TLBIASIDE1IS, 1),
-	SR_FGT(OP_TLBI_VAE1ISNXS, 	HFGITR, TLBIVAE1IS, 1),
-	SR_FGT(OP_TLBI_VMALLE1ISNXS, 	HFGITR, TLBIVMALLE1IS, 1),
-	SR_FGT(OP_TLBI_RVAALE1OSNXS, 	HFGITR, TLBIRVAALE1OS, 1),
-	SR_FGT(OP_TLBI_RVALE1OSNXS, 	HFGITR, TLBIRVALE1OS, 1),
-	SR_FGT(OP_TLBI_RVAAE1OSNXS, 	HFGITR, TLBIRVAAE1OS, 1),
-	SR_FGT(OP_TLBI_RVAE1OSNXS, 	HFGITR, TLBIRVAE1OS, 1),
-	SR_FGT(OP_TLBI_VAALE1OSNXS, 	HFGITR, TLBIVAALE1OS, 1),
-	SR_FGT(OP_TLBI_VALE1OSNXS, 	HFGITR, TLBIVALE1OS, 1),
-	SR_FGT(OP_TLBI_VAAE1OSNXS, 	HFGITR, TLBIVAAE1OS, 1),
-	SR_FGT(OP_TLBI_ASIDE1OSNXS, 	HFGITR, TLBIASIDE1OS, 1),
-	SR_FGT(OP_TLBI_VAE1OSNXS, 	HFGITR, TLBIVAE1OS, 1),
-	SR_FGT(OP_TLBI_VMALLE1OSNXS, 	HFGITR, TLBIVMALLE1OS, 1),
+	/* nXS variants must be checked against HCRX_EL2.FGTnXS */
+	SR_FGF(OP_TLBI_VAALE1NXS, 	HFGITR, TLBIVAALE1, 1, HCRX_FGTnXS),
+	SR_FGF(OP_TLBI_VALE1NXS, 	HFGITR, TLBIVALE1, 1, HCRX_FGTnXS),
+	SR_FGF(OP_TLBI_VAAE1NXS, 	HFGITR, TLBIVAAE1, 1, HCRX_FGTnXS),
+	SR_FGF(OP_TLBI_ASIDE1NXS, 	HFGITR, TLBIASIDE1, 1, HCRX_FGTnXS),
+	SR_FGF(OP_TLBI_VAE1NXS, 	HFGITR, TLBIVAE1, 1, HCRX_FGTnXS),
+	SR_FGF(OP_TLBI_VMALLE1NXS, 	HFGITR, TLBIVMALLE1, 1, HCRX_FGTnXS),
+	SR_FGF(OP_TLBI_RVAALE1NXS, 	HFGITR, TLBIRVAALE1, 1, HCRX_FGTnXS),
+	SR_FGF(OP_TLBI_RVALE1NXS, 	HFGITR, TLBIRVALE1, 1, HCRX_FGTnXS),
+	SR_FGF(OP_TLBI_RVAAE1NXS, 	HFGITR, TLBIRVAAE1, 1, HCRX_FGTnXS),
+	SR_FGF(OP_TLBI_RVAE1NXS, 	HFGITR, TLBIRVAE1, 1, HCRX_FGTnXS),
+	SR_FGF(OP_TLBI_RVAALE1ISNXS, 	HFGITR, TLBIRVAALE1IS, 1, HCRX_FGTnXS),
+	SR_FGF(OP_TLBI_RVALE1ISNXS, 	HFGITR, TLBIRVALE1IS, 1, HCRX_FGTnXS),
+	SR_FGF(OP_TLBI_RVAAE1ISNXS, 	HFGITR, TLBIRVAAE1IS, 1, HCRX_FGTnXS),
+	SR_FGF(OP_TLBI_RVAE1ISNXS, 	HFGITR, TLBIRVAE1IS, 1, HCRX_FGTnXS),
+	SR_FGF(OP_TLBI_VAALE1ISNXS, 	HFGITR, TLBIVAALE1IS, 1, HCRX_FGTnXS),
+	SR_FGF(OP_TLBI_VALE1ISNXS, 	HFGITR, TLBIVALE1IS, 1, HCRX_FGTnXS),
+	SR_FGF(OP_TLBI_VAAE1ISNXS, 	HFGITR, TLBIVAAE1IS, 1, HCRX_FGTnXS),
+	SR_FGF(OP_TLBI_ASIDE1ISNXS, 	HFGITR, TLBIASIDE1IS, 1, HCRX_FGTnXS),
+	SR_FGF(OP_TLBI_VAE1ISNXS, 	HFGITR, TLBIVAE1IS, 1, HCRX_FGTnXS),
+	SR_FGF(OP_TLBI_VMALLE1ISNXS, 	HFGITR, TLBIVMALLE1IS, 1, HCRX_FGTnXS),
+	SR_FGF(OP_TLBI_RVAALE1OSNXS, 	HFGITR, TLBIRVAALE1OS, 1, HCRX_FGTnXS),
+	SR_FGF(OP_TLBI_RVALE1OSNXS, 	HFGITR, TLBIRVALE1OS, 1, HCRX_FGTnXS),
+	SR_FGF(OP_TLBI_RVAAE1OSNXS, 	HFGITR, TLBIRVAAE1OS, 1, HCRX_FGTnXS),
+	SR_FGF(OP_TLBI_RVAE1OSNXS, 	HFGITR, TLBIRVAE1OS, 1, HCRX_FGTnXS),
+	SR_FGF(OP_TLBI_VAALE1OSNXS, 	HFGITR, TLBIVAALE1OS, 1, HCRX_FGTnXS),
+	SR_FGF(OP_TLBI_VALE1OSNXS, 	HFGITR, TLBIVALE1OS, 1, HCRX_FGTnXS),
+	SR_FGF(OP_TLBI_VAAE1OSNXS, 	HFGITR, TLBIVAAE1OS, 1, HCRX_FGTnXS),
+	SR_FGF(OP_TLBI_ASIDE1OSNXS, 	HFGITR, TLBIASIDE1OS, 1, HCRX_FGTnXS),
+	SR_FGF(OP_TLBI_VAE1OSNXS, 	HFGITR, TLBIVAE1OS, 1, HCRX_FGTnXS),
+	SR_FGF(OP_TLBI_VMALLE1OSNXS, 	HFGITR, TLBIVMALLE1OS, 1, HCRX_FGTnXS),
 	SR_FGT(OP_AT_S1E1WP, 		HFGITR, ATS1E1WP, 1),
 	SR_FGT(OP_AT_S1E1RP, 		HFGITR, ATS1E1RP, 1),
 	SR_FGT(OP_AT_S1E0W, 		HFGITR, ATS1E0W, 1),
@@ -1622,6 +1636,7 @@ int __init populate_nv_trap_config(void)
 	BUILD_BUG_ON(sizeof(union trap_config) != sizeof(void *));
 	BUILD_BUG_ON(__NR_CGT_GROUP_IDS__ > BIT(TC_CGT_BITS));
 	BUILD_BUG_ON(__NR_FGT_GROUP_IDS__ > BIT(TC_FGT_BITS));
+	BUILD_BUG_ON(__NR_FG_FILTER_IDS__ > BIT(TC_FGF_BITS));
 
 	for (int i = 0; i < ARRAY_SIZE(encoding_to_cgt); i++) {
 		const struct encoding_to_trap_config *cgt = &encoding_to_cgt[i];
@@ -1812,6 +1827,17 @@ bool __check_nv_sr_forward(struct kvm_vcpu *vcpu)
 
 	case HFGITR_GROUP:
 		val = sanitised_sys_reg(vcpu, HFGITR_EL2);
+		switch (tc.fgf) {
+			u64 tmp;
+
+		case __NO_FGF__:
+			break;
+
+		case HCRX_FGTnXS:
+			tmp = sanitised_sys_reg(vcpu, HCRX_EL2);
+			if (tmp & HCRX_EL2_FGTnXS)
+				tc.fgt = __NO_FGT_GROUP__;
+		}
 		break;
 
 	case __NR_FGT_GROUP_IDS__:
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 060c5a0409e5..3acf6d77e324 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -197,8 +197,19 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 	vcpu->arch.mdcr_el2_host = read_sysreg(mdcr_el2);
 	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
 
-	if (cpus_have_final_cap(ARM64_HAS_HCX))
-		write_sysreg_s(HCRX_GUEST_FLAGS, SYS_HCRX_EL2);
+	if (cpus_have_final_cap(ARM64_HAS_HCX)) {
+		u64 hcrx = HCRX_GUEST_FLAGS;
+		if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) {
+			u64 clr = 0, set = 0;
+
+			compute_clr_set(vcpu, HCRX_EL2, clr, set);
+
+			hcrx |= set;
+			hcrx &= ~clr;
+		}
+
+		write_sysreg_s(hcrx, SYS_HCRX_EL2);
+	}
 
 	__activate_traps_hfgxtr(vcpu);
 }
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 3facd8918ae3..042695a210ce 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -117,7 +117,8 @@ void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
 		break;
 
 	case SYS_ID_AA64MMFR1_EL1:
-		val &= (NV_FTR(MMFR1, PAN)	|
+		val &= (NV_FTR(MMFR1, HCX)	|
+			NV_FTR(MMFR1, PAN)	|
 			NV_FTR(MMFR1, LO)	|
 			NV_FTR(MMFR1, HPDS)	|
 			NV_FTR(MMFR1, VH)	|
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9556896311db..e92ec810d449 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2372,6 +2372,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG(HFGITR_EL2, access_rw, reset_val, 0),
 	EL2_REG(HACR_EL2, access_rw, reset_val, 0),
 
+	EL2_REG(HCRX_EL2, access_rw, reset_val, 0),
+
 	EL2_REG(TTBR0_EL2, access_rw, reset_val, 0),
 	EL2_REG(TTBR1_EL2, access_rw, reset_val, 0),
 	EL2_REG(TCR_EL2, access_rw, reset_val, TCR_EL2_RES1),
-- 
2.34.1

