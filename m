Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8F977D20B
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 20:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239253AbjHOSjs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Aug 2023 14:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239267AbjHOSj1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Aug 2023 14:39:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6920E19B5
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 11:39:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DBD065F09
        for <kvm@vger.kernel.org>; Tue, 15 Aug 2023 18:39:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E616C433C7;
        Tue, 15 Aug 2023 18:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692124759;
        bh=je3e0ZBK/CYrP+OnwG3vx0E8FfjGCXOLqb8t9dVc5S4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LwL1yxbhF0yV1p8DOAEh69oFvAQm+Jgxo8x6dBOb4Is4UwRIp9w3wYVt6TnKdv5Ya
         Mw2cbi3stQI1s0UjJbs5+NEqocMttm/8EczylzhNVxpw52LArKbwwJ2iUpHlaCunzA
         h32Wzx/1obOGNyjIcLBHsQcB7LGw+J8selTPnUkSput9wFfIqZxLeDYTekWcfvOZcD
         A9XtAgTHWtYGWm29uMCcMQ7wrt1ZbpmiL6KGBOFbIAqZAogD1MzDBV+fR8nQ7zpIn4
         Bua80UpPw3fZ8KksnX2GGhof0dfD4gRWm04SaRPbpZGb87XDUCkSU4UTpXS+lE3r6t
         bqYSjR1qfCXeA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qVywn-0055Sd-DL;
        Tue, 15 Aug 2023 19:39:17 +0100
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
Subject: [PATCH v4 08/28] arm64: Add HDFGRTR_EL2 and HDFGWTR_EL2 layouts
Date:   Tue, 15 Aug 2023 19:38:42 +0100
Message-Id: <20230815183903.2735724-9-maz@kernel.org>
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

As we're about to implement full support for FEAT_FGT, add the
full HDFGRTR_EL2 and HDFGWTR_EL2 layouts.

Reviewed-by: Mark Brown <broonie@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Miguel Luis <miguel.luis@oracle.com>
Reviewed-by: Jing Zhang <jingzhangos@google.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h |   2 -
 arch/arm64/tools/sysreg         | 129 ++++++++++++++++++++++++++++++++
 2 files changed, 129 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 6d9d7ac4b31c..043c677e9f04 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -495,8 +495,6 @@
 #define SYS_VTCR_EL2			sys_reg(3, 4, 2, 1, 2)
 
 #define SYS_TRFCR_EL2			sys_reg(3, 4, 1, 2, 1)
-#define SYS_HDFGRTR_EL2			sys_reg(3, 4, 3, 1, 4)
-#define SYS_HDFGWTR_EL2			sys_reg(3, 4, 3, 1, 5)
 #define SYS_HAFGRTR_EL2			sys_reg(3, 4, 3, 1, 6)
 #define SYS_SPSR_EL2			sys_reg(3, 4, 4, 0, 0)
 #define SYS_ELR_EL2			sys_reg(3, 4, 4, 0, 1)
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 65866bf819c3..2517ef7c21cf 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2156,6 +2156,135 @@ Field	1	ICIALLU
 Field	0	ICIALLUIS
 EndSysreg
 
+Sysreg HDFGRTR_EL2	3	4	3	1	4
+Field	63	PMBIDR_EL1
+Field	62	nPMSNEVFR_EL1
+Field	61	nBRBDATA
+Field	60	nBRBCTL
+Field	59	nBRBIDR
+Field	58	PMCEIDn_EL0
+Field	57	PMUSERENR_EL0
+Field	56	TRBTRG_EL1
+Field	55	TRBSR_EL1
+Field	54	TRBPTR_EL1
+Field	53	TRBMAR_EL1
+Field	52	TRBLIMITR_EL1
+Field	51	TRBIDR_EL1
+Field	50	TRBBASER_EL1
+Res0	49
+Field	48	TRCVICTLR
+Field	47	TRCSTATR
+Field	46	TRCSSCSRn
+Field	45	TRCSEQSTR
+Field	44	TRCPRGCTLR
+Field	43	TRCOSLSR
+Res0	42
+Field	41	TRCIMSPECn
+Field	40	TRCID
+Res0	39:38
+Field	37	TRCCNTVRn
+Field	36	TRCCLAIM
+Field	35	TRCAUXCTLR
+Field	34	TRCAUTHSTATUS
+Field	33	TRC
+Field	32	PMSLATFR_EL1
+Field	31	PMSIRR_EL1
+Field	30	PMSIDR_EL1
+Field	29	PMSICR_EL1
+Field	28	PMSFCR_EL1
+Field	27	PMSEVFR_EL1
+Field	26	PMSCR_EL1
+Field	25	PMBSR_EL1
+Field	24	PMBPTR_EL1
+Field	23	PMBLIMITR_EL1
+Field	22	PMMIR_EL1
+Res0	21:20
+Field	19	PMSELR_EL0
+Field	18	PMOVS
+Field	17	PMINTEN
+Field	16	PMCNTEN
+Field	15	PMCCNTR_EL0
+Field	14	PMCCFILTR_EL0
+Field	13	PMEVTYPERn_EL0
+Field	12	PMEVCNTRn_EL0
+Field	11	OSDLR_EL1
+Field	10	OSECCR_EL1
+Field	9	OSLSR_EL1
+Res0	8
+Field	7	DBGPRCR_EL1
+Field	6	DBGAUTHSTATUS_EL1
+Field	5	DBGCLAIM
+Field	4	MDSCR_EL1
+Field	3	DBGWVRn_EL1
+Field	2	DBGWCRn_EL1
+Field	1	DBGBVRn_EL1
+Field	0	DBGBCRn_EL1
+EndSysreg
+
+Sysreg HDFGWTR_EL2	3	4	3	1	5
+Res0	63
+Field	62	nPMSNEVFR_EL1
+Field	61	nBRBDATA
+Field	60	nBRBCTL
+Res0	59:58
+Field	57	PMUSERENR_EL0
+Field	56	TRBTRG_EL1
+Field	55	TRBSR_EL1
+Field	54	TRBPTR_EL1
+Field	53	TRBMAR_EL1
+Field	52	TRBLIMITR_EL1
+Res0	51
+Field	50	TRBBASER_EL1
+Field	49	TRFCR_EL1
+Field	48	TRCVICTLR
+Res0	47
+Field	46	TRCSSCSRn
+Field	45	TRCSEQSTR
+Field	44	TRCPRGCTLR
+Res0	43
+Field	42	TRCOSLAR
+Field	41	TRCIMSPECn
+Res0	40:38
+Field	37	TRCCNTVRn
+Field	36	TRCCLAIM
+Field	35	TRCAUXCTLR
+Res0	34
+Field	33	TRC
+Field	32	PMSLATFR_EL1
+Field	31	PMSIRR_EL1
+Res0	30
+Field	29	PMSICR_EL1
+Field	28	PMSFCR_EL1
+Field	27	PMSEVFR_EL1
+Field	26	PMSCR_EL1
+Field	25	PMBSR_EL1
+Field	24	PMBPTR_EL1
+Field	23	PMBLIMITR_EL1
+Res0	22
+Field	21	PMCR_EL0
+Field	20	PMSWINC_EL0
+Field	19	PMSELR_EL0
+Field	18	PMOVS
+Field	17	PMINTEN
+Field	16	PMCNTEN
+Field	15	PMCCNTR_EL0
+Field	14	PMCCFILTR_EL0
+Field	13	PMEVTYPERn_EL0
+Field	12	PMEVCNTRn_EL0
+Field	11	OSDLR_EL1
+Field	10	OSECCR_EL1
+Res0	9
+Field	8	OSLAR_EL1
+Field	7	DBGPRCR_EL1
+Res0	6
+Field	5	DBGCLAIM
+Field	4	MDSCR_EL1
+Field	3	DBGWVRn_EL1
+Field	2	DBGWCRn_EL1
+Field	1	DBGBVRn_EL1
+Field	0	DBGBCRn_EL1
+EndSysreg
+
 Sysreg	ZCR_EL2	3	4	1	2	0
 Fields	ZCR_ELx
 EndSysreg
-- 
2.34.1

