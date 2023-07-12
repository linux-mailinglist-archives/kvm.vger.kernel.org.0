Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2B6750C25
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 17:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbjGLPRE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 11:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233532AbjGLPRA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 11:17:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5388710C4
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 08:16:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD37F61853
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 15:16:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14BA4C433C8;
        Wed, 12 Jul 2023 15:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689175012;
        bh=cYMMuGTdYirOt+SyJamES1cGZgktYJJvoSKNFhGe6YI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EyNa5AmwHpKPnBknfWrf1zg4xHnprYV7kfbBQumuggmXK1i6LZHu3Z3/lzLDtGmXN
         VcmOBFXG72B7/F0RFM9lpSJ4ZoNLLI30qsZyeaZfW2garQDCLd1VOBkiQ3joEbqBEo
         sA7Lle+CjMuCrTMq4vZca4yDU3pL/YP/yWeLkmR/KN+jkp+rG9Ox59fMptkQ+HyJHi
         URb27s8R72YgWLj8Nihb+r1CeOGuCJfMKrekuorlOWtPiR9kR+5NZcfCqQtEgcYQnN
         Absmv+li6N8Cv6Ghn6K7ZZvsMkW6zuljX7NnrOTz1RQDgFUntvtTExCC3qUXazZMV6
         Zb5FymFiDttPw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qJbIq-00CUNF-Gj;
        Wed, 12 Jul 2023 15:58:52 +0100
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
Subject: [PATCH 18/27] KVM: arm64: nv: Add trap forwarding for MDCR_EL2
Date:   Wed, 12 Jul 2023 15:58:01 +0100
Message-Id: <20230712145810.3864793-19-maz@kernel.org>
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
 arch/arm64/kvm/emulate-nested.c | 262 ++++++++++++++++++++++++++++++++
 1 file changed, 262 insertions(+)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 51901e85e43d..25e4842ac334 100644
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
@@ -593,6 +681,180 @@ static const struct encoding_to_trap_config encoding_to_cgt[] __initdata = {
 	SR_TRAP(SYS_ERXPFGCTL_EL1,	CGT_HCR_FIEN),
 	SR_TRAP(SYS_ERXPFGCDN_EL1,	CGT_HCR_FIEN),
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
+	SR_TRAP(SYS_PMEVCNTRn_EL0(0),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(1),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(2),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(3),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(4),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(5),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(6),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(7),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(8),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(9),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(10),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(11),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(12),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(13),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(14),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(15),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(16),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(17),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(18),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(19),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(20),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(21),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(22),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(23),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(24),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(25),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(26),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(27),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(28),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(29),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVCNTRn_EL0(30),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(0),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(1),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(2),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(3),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(4),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(5),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(6),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(7),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(8),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(9),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(10),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(11),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(12),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(13),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(14),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(15),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(16),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(17),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(18),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(19),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(20),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(21),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(22),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(23),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(24),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(25),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(26),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(27),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(28),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(29),	CGT_MDCR_TPM),
+	SR_TRAP(SYS_PMEVTYPERn_EL0(30),	CGT_MDCR_TPM),
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

