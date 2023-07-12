Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5676750B91
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 16:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232221AbjGLO7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 10:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232187AbjGLO7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 10:59:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A871BE8
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 07:58:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EDDC6185C
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 14:58:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A73CC433CD;
        Wed, 12 Jul 2023 14:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689173931;
        bh=zJ2DaSSywT4VFmaweCUIQeRPT100KbjmHq7Kg16dWvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a3ts59uXJYCIwPjFXDre+qqbK4nuS5xlfnzmTja66ZtOBSd4eMJIAXXv9neukI+NB
         1l6X0yf/J9UtDF3k6OEUd/SrfIo+6VeCJOlzZ0aBU/JUJgE30h3vdYliTJ3bJdosOZ
         kErBLeb8AXwrHnL7+SZHODUU24VcaMke//KvloIIbQp8tBK3KSOOQoHBBl+prr8/xl
         eNT+iHoHEgE8RPaM3S8ubIHvSWP/f4sCm6qoKt+LISFEMtHYFvfzdiciVu7QHHCg+e
         AgO/CqjNFWGRhrE2BPX+767Ytx6qRkQnJSRfz7LIXiBGEODpIbmA3x5AtgHEgiJ86H
         pj/3CWCTxZYtQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qJbIn-00CUNF-5c;
        Wed, 12 Jul 2023 15:58:49 +0100
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
Subject: [PATCH 06/27] arm64: Add debug registers affected by HDFGxTR_EL2
Date:   Wed, 12 Jul 2023 15:57:49 +0100
Message-Id: <20230712145810.3864793-7-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230712145810.3864793-1-maz@kernel.org>
References: <20230712145810.3864793-1-maz@kernel.org>
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

The HDFGxTR_EL2 registers trap a (huge) set of debug and trace
related registers. Add their encodings (and only that, because
we really don't care about what these registers actually do at
this stage).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/sysreg.h | 78 +++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 76289339b43b..9dfd127be55a 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -194,6 +194,84 @@
 #define SYS_DBGDTRTX_EL0		sys_reg(2, 3, 0, 5, 0)
 #define SYS_DBGVCR32_EL2		sys_reg(2, 4, 0, 7, 0)
 
+#define SYS_BRBINF_EL1(n)		sys_reg(2, 1, 8, (n & 15), (((n & 16) >> 2) | 0))
+#define SYS_BRBINFINJ_EL1		sys_reg(2, 1, 9, 1, 0)
+#define SYS_BRBSRC_EL1(n)		sys_reg(2, 1, 8, (n & 15), (((n & 16) >> 2) | 1))
+#define SYS_BRBSRCINJ_EL1		sys_reg(2, 1, 9, 1, 1)
+#define SYS_BRBTGT_EL1(n)		sys_reg(2, 1, 8, (n & 15), (((n & 16) >> 2) | 2))
+#define SYS_BRBTGTINJ_EL1		sys_reg(2, 1, 9, 1, 2)
+#define SYS_BRBTS_EL1			sys_reg(2, 1, 9, 0, 2)
+
+#define SYS_BRBCR_EL1			sys_reg(2, 1, 9, 0, 0)
+#define SYS_BRBFCR_EL1			sys_reg(2, 1, 9, 0, 1)
+#define SYS_BRBIDR0_EL1			sys_reg(2, 1, 9, 2, 0)
+
+#define SYS_TRCITECR_EL1		sys_reg(3, 0, 1, 2, 3)
+#define SYS_TRCITECR_EL1		sys_reg(3, 0, 1, 2, 3)
+#define SYS_TRCACATR(m)			sys_reg(2, 1, 2, ((m & 7) << 1), (2 | (m >> 3)))
+#define SYS_TRCACVR(m)			sys_reg(2, 1, 2, ((m & 7) << 1), (0 | (m >> 3)))
+#define SYS_TRCAUTHSTATUS		sys_reg(2, 1, 7, 14, 6)
+#define SYS_TRCAUXCTLR			sys_reg(2, 1, 0, 6, 0)
+#define SYS_TRCBBCTLR			sys_reg(2, 1, 0, 15, 0)
+#define SYS_TRCCCCTLR			sys_reg(2, 1, 0, 14, 0)
+#define SYS_TRCCIDCCTLR0		sys_reg(2, 1, 3, 0, 2)
+#define SYS_TRCCIDCCTLR1		sys_reg(2, 1, 3, 1, 2)
+#define SYS_TRCCIDCVR(m)		sys_reg(2, 1, 3, ((m & 7) << 1), 0)
+#define SYS_TRCCLAIMCLR			sys_reg(2, 1, 7, 9, 6)
+#define SYS_TRCCLAIMSET			sys_reg(2, 1, 7, 8, 6)
+#define SYS_TRCCNTCTLR(m)		sys_reg(2, 1, 0, (4 | (m & 3)), 5)
+#define SYS_TRCCNTRLDVR(m)		sys_reg(2, 1, 0, (0 | (m & 3)), 5)
+#define SYS_TRCCNTVR(m)			sys_reg(2, 1, 0, (8 | (m & 3)), 5)
+#define SYS_TRCCONFIGR			sys_reg(2, 1, 0, 4, 0)
+#define SYS_TRCDEVARCH			sys_reg(2, 1, 7, 15, 6)
+#define SYS_TRCDEVID			sys_reg(2, 1, 7, 2, 7)
+#define SYS_TRCEVENTCTL0R		sys_reg(2, 1, 0, 8, 0)
+#define SYS_TRCEVENTCTL1R		sys_reg(2, 1, 0, 9, 0)
+#define SYS_TRCEXTINSELR(m)		sys_reg(2, 1, 0, (8 | (m & 3)), 4)
+#define SYS_TRCIDR0			sys_reg(2, 1, 0, 8, 7)
+#define SYS_TRCIDR10			sys_reg(2, 1, 0, 2, 6)
+#define SYS_TRCIDR11			sys_reg(2, 1, 0, 3, 6)
+#define SYS_TRCIDR12			sys_reg(2, 1, 0, 4, 6)
+#define SYS_TRCIDR13			sys_reg(2, 1, 0, 5, 6)
+#define SYS_TRCIDR1			sys_reg(2, 1, 0, 9, 7)
+#define SYS_TRCIDR2			sys_reg(2, 1, 0, 10, 7)
+#define SYS_TRCIDR3			sys_reg(2, 1, 0, 11, 7)
+#define SYS_TRCIDR4			sys_reg(2, 1, 0, 12, 7)
+#define SYS_TRCIDR5			sys_reg(2, 1, 0, 13, 7)
+#define SYS_TRCIDR6			sys_reg(2, 1, 0, 14, 7)
+#define SYS_TRCIDR7			sys_reg(2, 1, 0, 15, 7)
+#define SYS_TRCIDR8			sys_reg(2, 1, 0, 0, 6)
+#define SYS_TRCIDR9			sys_reg(2, 1, 0, 1, 6)
+#define SYS_TRCIMSPEC0			sys_reg(2, 1, 0, 0, 7)
+#define SYS_TRCIMSPEC(m)		sys_reg(2, 1, 0, (m & 7), 7)
+#define SYS_TRCITEEDCR			sys_reg(2, 1, 0, 2, 1)
+#define SYS_TRCOSLSR			sys_reg(2, 1, 1, 1, 4)
+#define SYS_TRCPRGCTLR			sys_reg(2, 1, 0, 1, 0)
+#define SYS_TRCQCTLR			sys_reg(2, 1, 0, 1, 1)
+#define SYS_TRCRSCTLR(m)		sys_reg(2, 1, 1, (m & 15), (0 | (m >> 4)))
+#define SYS_TRCRSR			sys_reg(2, 1, 0, 10, 0)
+#define SYS_TRCSEQEVR(m)		sys_reg(2, 1, 0, (m & 3), 4)
+#define SYS_TRCSEQRSTEVR		sys_reg(2, 1, 0, 6, 4)
+#define SYS_TRCSEQSTR			sys_reg(2, 1, 0, 7, 4)
+#define SYS_TRCSSCCR(m)			sys_reg(2, 1, 1, (m & 7), 2)
+#define SYS_TRCSSCSR(m)			sys_reg(2, 1, 1, (8 | (m & 7)), 2)
+#define SYS_TRCSSPCICR(m)		sys_reg(2, 1, 1, (m & 7), 3)
+#define SYS_TRCSTALLCTLR		sys_reg(2, 1, 0, 11, 0)
+#define SYS_TRCSTATR			sys_reg(2, 1, 0, 3, 0)
+#define SYS_TRCSYNCPR			sys_reg(2, 1, 0, 13, 0)
+#define SYS_TRCTRACEIDR			sys_reg(2, 1, 0, 0, 1)
+#define SYS_TRCTSCTLR			sys_reg(2, 1, 0, 12, 0)
+#define SYS_TRCVICTLR			sys_reg(2, 1, 0, 0, 2)
+#define SYS_TRCVIIECTLR			sys_reg(2, 1, 0, 1, 2)
+#define SYS_TRCVIPCSSCTLR		sys_reg(2, 1, 0, 3, 2)
+#define SYS_TRCVISSCTLR			sys_reg(2, 1, 0, 2, 2)
+#define SYS_TRCVMIDCCTLR0		sys_reg(2, 1, 3, 2, 2)
+#define SYS_TRCVMIDCCTLR1		sys_reg(2, 1, 3, 3, 2)
+#define SYS_TRCVMIDCVR(m)		sys_reg(2, 1, 3, ((m & 7) << 1), 1)
+
+/* ETM */
+#define SYS_TRCOSLAR			sys_reg(2, 1, 1, 0, 4)
+
 #define SYS_MIDR_EL1			sys_reg(3, 0, 0, 0, 0)
 #define SYS_MPIDR_EL1			sys_reg(3, 0, 0, 0, 5)
 #define SYS_REVIDR_EL1			sys_reg(3, 0, 0, 0, 6)
-- 
2.34.1

