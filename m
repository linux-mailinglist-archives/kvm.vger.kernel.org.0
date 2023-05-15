Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88442703A4E
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 19:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244882AbjEORuc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 13:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244694AbjEORuD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 13:50:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4631CA40
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 10:48:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 699AB62F26
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 17:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB61C433EF;
        Mon, 15 May 2023 17:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684172881;
        bh=0FqIGLYVaCXaCuF3bynbn1HuxGMQSRt/G9y2+sdKNxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p92DDGXzC0pLQjWZc8HbhuVjLax+Dl1Ns+IePYQbPMwj6AkAKNmEo5IFrGwkM//cz
         Xc1PDg0eOKtWzR9utKHzZxl2cHNmgDclvtrgJDMakbI94pEM4DsHLOWKhC8Z5mwNim
         SeHHWSMjoyAJsXXqmbkM8PuOA7pjHmJc2Fhm/N4vNxdu8cEr8eeCJosajqF5X9trWF
         SYqRytw0megkKIeinvsslfRzb/h5+oi8ri9qYxoAwUUpJ+3k+QuHU98h8NhfttrdQ/
         gdK1vOOmgbLTmC1RcnuZH2pVjghE/34CDrHsqMMnsrFQ7o2knTnOOABkOqx4AQjpO7
         Gn+aolZSuAflg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pyc2g-00FJAF-DV;
        Mon, 15 May 2023 18:31:26 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
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
Subject: [PATCH v10 12/59] KVM: arm64: nv: Add trap forwarding for MDCR_EL2
Date:   Mon, 15 May 2023 18:30:16 +0100
Message-Id: <20230515173103.1017669-13-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230515173103.1017669-1-maz@kernel.org>
References: <20230515173103.1017669-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, darren@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, miguel.luis@oracle.com, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UPPERCASE_75_100
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Describe the MDCR_EL2 register, and associate it with all the sysregs
it allows to trap.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 204 ++++++++++++++++++++++++++++++++
 1 file changed, 204 insertions(+)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 8be331e5de9d..1e2fe192c9a4 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -65,6 +65,18 @@ enum coarse_grain_trap_id {
 	CGT_HCR_TTLBIS,
 	CGT_HCR_TTLBOS,
 
+	CGT_MDCR_TPMCR,
+	CGT_MDCR_TPM,
+	CGT_MDCR_TDE,
+	CGT_MDCR_TDA,
+	CGT_MDCR_TDOSA,
+	CGT_MDCR_TDRA,
+	CGT_MDCR_E2PB,
+	CGT_MDCR_TPMS,
+	CGT_MDCR_TTRF,
+	CGT_MDCR_E2TB,
+	CGT_MDCR_TDCC,
+
 	/*
 	 * Anything after this point is a combination of trap controls,
 	 * which all must be evaluated to decide what to do.
@@ -78,6 +90,11 @@ enum coarse_grain_trap_id {
 	CGT_HCR_TPU_TICAB,
 	CGT_HCR_TPU_TOCU,
 	CGT_HCR_NV1_ENSCXT,
+	CGT_MDCR_TPM_TPMCR,
+	CGT_MDCR_TDE_TDA,
+	CGT_MDCR_TDE_TDOSA,
+	CGT_MDCR_TDE_TDRA,
+	CGT_MDCR_TDCC_TDE_TDA,
 
 	/*
 	 * Anything after this point requires a callback evaluating a
@@ -249,6 +266,72 @@ static const struct trap_bits coarse_trap_bits[] = {
 		.mask		= HCR_TTLBOS,
 		.behaviour	= BEHAVE_FORWARD_ANY,
 	},
+	[CGT_MDCR_TPMCR] = {
+		.index		= MDCR_EL2,
+		.value		= MDCR_EL2_TPMCR,
+		.mask		= MDCR_EL2_TPMCR,
+		.behaviour	= BEHAVE_FORWARD_ANY,
+	},
+	[CGT_MDCR_TPM] = {
+		.index		= MDCR_EL2,
+		.value		= MDCR_EL2_TPM,
+		.mask		= MDCR_EL2_TPM,
+		.behaviour	= BEHAVE_FORWARD_ANY,
+	},
+	[CGT_MDCR_TDE] = {
+		.index		= MDCR_EL2,
+		.value		= MDCR_EL2_TDE,
+		.mask		= MDCR_EL2_TDE,
+		.behaviour	= BEHAVE_FORWARD_ANY,
+	},
+	[CGT_MDCR_TDA] = {
+		.index		= MDCR_EL2,
+		.value		= MDCR_EL2_TDA,
+		.mask		= MDCR_EL2_TDA,
+		.behaviour	= BEHAVE_FORWARD_ANY,
+	},
+	[CGT_MDCR_TDOSA] = {
+		.index		= MDCR_EL2,
+		.value		= MDCR_EL2_TDOSA,
+		.mask		= MDCR_EL2_TDOSA,
+		.behaviour	= BEHAVE_FORWARD_ANY,
+	},
+	[CGT_MDCR_TDRA] = {
+		.index		= MDCR_EL2,
+		.value		= MDCR_EL2_TDRA,
+		.mask		= MDCR_EL2_TDRA,
+		.behaviour	= BEHAVE_FORWARD_ANY,
+	},
+	[CGT_MDCR_E2PB] = {
+		.index		= MDCR_EL2,
+		.value		= 0,
+		.mask		= BIT(MDCR_EL2_E2PB_SHIFT),
+		.behaviour	= BEHAVE_FORWARD_ANY,
+	},
+	[CGT_MDCR_TPMS] = {
+		.index		= MDCR_EL2,
+		.value		= MDCR_EL2_TPMS,
+		.mask		= MDCR_EL2_TPMS,
+		.behaviour	= BEHAVE_FORWARD_ANY,
+	},
+	[CGT_MDCR_TTRF] = {
+		.index		= MDCR_EL2,
+		.value		= MDCR_EL2_TTRF,
+		.mask		= MDCR_EL2_TTRF,
+		.behaviour	= BEHAVE_FORWARD_ANY,
+	},
+	[CGT_MDCR_E2TB] = {
+		.index		= MDCR_EL2,
+		.value		= 0,
+		.mask		= BIT(MDCR_EL2_E2TB_SHIFT),
+		.behaviour	= BEHAVE_FORWARD_ANY,
+	},
+	[CGT_MDCR_TDCC] = {
+		.index		= MDCR_EL2,
+		.value		= MDCR_EL2_TDCC,
+		.mask		= MDCR_EL2_TDCC,
+		.behaviour	= BEHAVE_FORWARD_ANY,
+	},
 };
 
 #define MCB(id, ...)					\
@@ -266,6 +349,11 @@ static const enum coarse_grain_trap_id *coarse_control_combo[] = {
 	MCB(CGT_HCR_TPU_TICAB,		CGT_HCR_TPU, CGT_HCR_TICAB),
 	MCB(CGT_HCR_TPU_TOCU,		CGT_HCR_TPU, CGT_HCR_TOCU),
 	MCB(CGT_HCR_NV1_ENSCXT,		CGT_HCR_NV1, CGT_HCR_ENSCXT),
+	MCB(CGT_MDCR_TPM_TPMCR,		CGT_MDCR_TPM, CGT_MDCR_TPMCR),
+	MCB(CGT_MDCR_TDE_TDA,		CGT_MDCR_TDE, CGT_MDCR_TDA),
+	MCB(CGT_MDCR_TDE_TDOSA,		CGT_MDCR_TDE, CGT_MDCR_TDOSA),
+	MCB(CGT_MDCR_TDE_TDRA,		CGT_MDCR_TDE, CGT_MDCR_TDRA),
+	MCB(CGT_MDCR_TDCC_TDE_TDA,	CGT_MDCR_TDCC, CGT_MDCR_TDE_TDA),
 };
 
 typedef enum trap_behaviour (*complex_condition_check)(struct kvm_vcpu *);
@@ -565,6 +653,122 @@ static const struct encoding_to_trap_configs encoding_to_traps[] __initdata = {
 	SR_RANGE_TRAP(sys_reg(3, 0, 5, 4, 4),
 		      sys_reg(3, 0, 5, 4, 6), CGT_HCR_FIEN),
 	SR_TRAP(SYS_SCXTNUM_EL0,	CGT_HCR_ENSCXT),
+	SR_TRAP(SYS_PMCR_EL0,		CGT_MDCR_TPM_TPMCR),
+	SR_TRAP(SYS_PMCNTENSET_EL0,	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMCNTENCLR_EL0,	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMOVSSET_EL0,	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMOVSCLR_EL0,	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMCEID0_EL0,	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMCEID1_EL0,	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMXEVTYPER_EL0,	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMSWINC_EL0,	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMSELR_EL0,		CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMXEVCNTR_EL0,	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMCCNTR_EL0,	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMUSERENR_EL0,	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMINTENSET_EL1,	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMINTENCLR_EL1,	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMMIR_EL1,		CGT_MDCR_TPM),
+	SR_RANGE_TRAP(SYS_PMEVCNTRn_EL0(0),
+		      SYS_PMEVCNTRn_EL0(30), CGT_MDCR_TPM),
+	SR_RANGE_TRAP(SYS_PMEVTYPERn_EL0(0),
+		      SYS_PMEVTYPERn_EL0(30), CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMCCFILTR_EL0,	CGT_MDCR_TPM),
+	SR_TRAP(SYS_MDCCSR_EL0,		CGT_MDCR_TDCC_TDE_TDA),
+	SR_TRAP(SYS_MDCCINT_EL1,	CGT_MDCR_TDCC_TDE_TDA),
+	SR_TRAP(SYS_OSDTRRX_EL1,	CGT_MDCR_TDCC_TDE_TDA),
+	SR_TRAP(SYS_OSDTRTX_EL1,	CGT_MDCR_TDCC_TDE_TDA),
+	SR_TRAP(SYS_MDSCR_EL1,		CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_OSECCR_EL1,		CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGBVRn_EL1(0),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGBVRn_EL1(1),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGBVRn_EL1(2),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGBVRn_EL1(3),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGBVRn_EL1(4),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGBVRn_EL1(5),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGBVRn_EL1(6),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGBVRn_EL1(7),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGBVRn_EL1(8),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGBVRn_EL1(9),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGBVRn_EL1(10),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGBVRn_EL1(11),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGBVRn_EL1(12),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGBVRn_EL1(13),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGBVRn_EL1(14),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGBVRn_EL1(15),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGBCRn_EL1(0),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGBCRn_EL1(1),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGBCRn_EL1(2),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGBCRn_EL1(3),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGBCRn_EL1(4),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGBCRn_EL1(5),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGBCRn_EL1(6),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGBCRn_EL1(7),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGBCRn_EL1(8),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGBCRn_EL1(9),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGBCRn_EL1(10),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGBCRn_EL1(11),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGBCRn_EL1(12),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGBCRn_EL1(13),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGBCRn_EL1(14),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGBCRn_EL1(15),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGWVRn_EL1(0),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGWVRn_EL1(1),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGWVRn_EL1(2),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGWVRn_EL1(3),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGWVRn_EL1(4),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGWVRn_EL1(5),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGWVRn_EL1(6),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGWVRn_EL1(7),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGWVRn_EL1(8),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGWVRn_EL1(9),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGWVRn_EL1(10),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGWVRn_EL1(11),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGWVRn_EL1(12),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGWVRn_EL1(13),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGWVRn_EL1(14),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGWVRn_EL1(15),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGWCRn_EL1(0),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGWCRn_EL1(1),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGWCRn_EL1(2),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGWCRn_EL1(3),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGWCRn_EL1(4),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGWCRn_EL1(5),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGWCRn_EL1(6),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGWCRn_EL1(7),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGWCRn_EL1(8),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGWCRn_EL1(9),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGWCRn_EL1(10),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGWCRn_EL1(11),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGWCRn_EL1(12),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGWCRn_EL1(13),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGWCRn_EL1(14),	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGCLAIMSET_EL1,	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGCLAIMCLR_EL1,	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_DBGAUTHSTATUS_EL1,	CGT_MDCR_TDE_TDA),
+	SR_TRAP(SYS_OSLAR_EL1,		CGT_MDCR_TDE_TDOSA),
+	SR_TRAP(SYS_OSLSR_EL1,		CGT_MDCR_TDE_TDOSA),
+	SR_TRAP(SYS_OSDLR_EL1,		CGT_MDCR_TDE_TDOSA),
+	SR_TRAP(SYS_DBGPRCR_EL1,	CGT_MDCR_TDE_TDOSA),
+	SR_TRAP(SYS_MDRAR_EL1,		CGT_MDCR_TDE_TDRA),
+	SR_TRAP(SYS_PMBLIMITR_EL1,	CGT_MDCR_E2PB),
+	SR_TRAP(SYS_PMBPTR_EL1,		CGT_MDCR_E2PB),
+	SR_TRAP(SYS_PMBSR_EL1,		CGT_MDCR_E2PB),
+	SR_TRAP(SYS_PMSCR_EL1,		CGT_MDCR_TPMS),
+	SR_TRAP(SYS_PMSEVFR_EL1,	CGT_MDCR_TPMS),
+	SR_TRAP(SYS_PMSFCR_EL1,		CGT_MDCR_TPMS),
+	SR_TRAP(SYS_PMSICR_EL1,		CGT_MDCR_TPMS),
+	SR_TRAP(SYS_PMSIDR_EL1,		CGT_MDCR_TPMS),
+	SR_TRAP(SYS_PMSIRR_EL1,		CGT_MDCR_TPMS),
+	SR_TRAP(SYS_PMSLATFR_EL1,	CGT_MDCR_TPMS),
+	SR_TRAP(SYS_PMSNEVFR_EL1,	CGT_MDCR_TPMS),
+	SR_TRAP(SYS_TRFCR_EL1,		CGT_MDCR_TTRF),
+	SR_TRAP(SYS_TRBBASER_EL1,	CGT_MDCR_E2TB),
+	SR_TRAP(SYS_TRBLIMITR_EL1,	CGT_MDCR_E2TB),
+	SR_TRAP(SYS_TRBMAR_EL1, 	CGT_MDCR_E2TB),
+	SR_TRAP(SYS_TRBPTR_EL1, 	CGT_MDCR_E2TB),
+	SR_TRAP(SYS_TRBSR_EL1, 		CGT_MDCR_E2TB),
+	SR_TRAP(SYS_TRBTRG_EL1,		CGT_MDCR_E2TB),
 };
 
 static DEFINE_XARRAY(sr_forward_xa);
-- 
2.34.1

