Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2B9C766730
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 10:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235014AbjG1Ibk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 04:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234986AbjG1IbA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 04:31:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32773AB1
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 01:30:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E75E66205F
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 08:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8672C433D9;
        Fri, 28 Jul 2023 08:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690533002;
        bh=RIE+O0mSseIUwpjMx6KuBwnImJGKSzMs3mz4SxHAlZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CakPw2pyQIiXgGAHt7QM4dCJPr3CU4fZmfsOUEtv4PZASqZVqcNQyco0v/pVAUucR
         J3yc1+aZR3T7M6+us+Cb2/T4qRobEPv3JN9XZhqGU7FxPAKX39SL2TQI8GY954yDIZ
         KMPn3gGSFhkFIopYIR/zg6VqShepSkvS8wUGphWF8M64AxrzXw/xRVUmKSrfl6ikw5
         pdzlVAbtqiq5GOJKPpIbxNDs4ouLdUUlTW9m/hnb7qAjGMEs2op8KK8i05eSOMrYlF
         FLQ5ZGmgpjlsbN0quHmj1uHAv5AHMNMw1QisAocl5ONuTZ2K1CNOFnWTcaPpj5iS5G
         AmcVtF67kXf7g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qPIrI-0000EO-UN;
        Fri, 28 Jul 2023 09:30:01 +0100
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
Subject: [PATCH v2 08/26] arm64: Add HDFGRTR_EL2 and HDFGWTR_EL2 layouts
Date:   Fri, 28 Jul 2023 09:29:34 +0100
Message-Id: <20230728082952.959212-9-maz@kernel.org>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As we're about to implement full support for FEAT_FGT, add the
full HDFGRTR_EL2 and HDFGWTR_EL2 layouts.

Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h |   2 -
 arch/arm64/tools/sysreg         | 129 ++++++++++++++++++++++++++++++++
 2 files changed, 129 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index e2357529c633..6d3d16fac227 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -497,8 +497,6 @@
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

