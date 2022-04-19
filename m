Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4591507903
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 20:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240137AbiDSShA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 14:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355302AbiDSSgu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 14:36:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5284BFF7
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 11:28:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 289A5B819B5
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 18:28:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0FB9C385A5;
        Tue, 19 Apr 2022 18:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650392886;
        bh=eyarjG0pujg08ghNIttcze1bSsH1oTYJNaOUvDsdFXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PxstLUMXqfTFi/b/V3+ynjHioHwCg+q8pZHPBiUYeoffnBVx10t+WtAxiXBB2g7to
         fs/QISu6+q09GNmbwxRLOvfEYP6c4z5Sb9sOuUgmq4rZYI4yaIhY53V7Uq0Wy0Il7L
         WokcNmnE52M1PdnaW7T1XFbk1BdE/nWnebsjI7eXnT8qszkuho57R0rx4wc2pF5AhU
         m6cDHgbwJYS3Sx7XWTEU3+lsFNKQOWHCZgdlQF5wWXW6b3wQJHox+ASHx0Mf9A6RIS
         lqyUNdC/oF3ThJsAj/EAALoY8QSiVUVWoqj68W1GLR3fB6khYKx12orImQTiK0AQni
         i+TJuo7xwTsuw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1ngsa4-005QYF-Hr; Tue, 19 Apr 2022 19:28:04 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Joey Gouly <joey.gouly@arm.com>, kernel-team@android.com
Subject: [PATCH v2 01/10] arm64: Expand ESR_ELx_WFx_ISS_TI to match its ARMv8.7 definition
Date:   Tue, 19 Apr 2022 19:27:46 +0100
Message-Id: <20220419182755.601427-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220419182755.601427-1-maz@kernel.org>
References: <20220419182755.601427-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, joey.gouly@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Starting with FEAT_WFXT in ARMv8.7, the TI field in the ISS
that is reported on a WFx trap is expanded by one bit to
allow the description of WFET and WFIT.

Special care is taken to exclude the WFxT bit from the mask
used to match WFI so that it also matches WFIT when trapped from
EL0.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/esr.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index d52a0b269ee8..65c2201b11b2 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -133,7 +133,8 @@
 #define ESR_ELx_CV		(UL(1) << 24)
 #define ESR_ELx_COND_SHIFT	(20)
 #define ESR_ELx_COND_MASK	(UL(0xF) << ESR_ELx_COND_SHIFT)
-#define ESR_ELx_WFx_ISS_TI	(UL(1) << 0)
+#define ESR_ELx_WFx_ISS_TI	(UL(3) << 0)
+#define ESR_ELx_WFx_ISS_WFxT	(UL(2) << 0)
 #define ESR_ELx_WFx_ISS_WFI	(UL(0) << 0)
 #define ESR_ELx_WFx_ISS_WFE	(UL(1) << 0)
 #define ESR_ELx_xVC_IMM_MASK	((1UL << 16) - 1)
@@ -146,7 +147,8 @@
 #define DISR_EL1_ESR_MASK	(ESR_ELx_AET | ESR_ELx_EA | ESR_ELx_FSC)
 
 /* ESR value templates for specific events */
-#define ESR_ELx_WFx_MASK	(ESR_ELx_EC_MASK | ESR_ELx_WFx_ISS_TI)
+#define ESR_ELx_WFx_MASK	(ESR_ELx_EC_MASK |			\
+				 (ESR_ELx_WFx_ISS_TI & ~ESR_ELx_WFx_ISS_WFxT))
 #define ESR_ELx_WFx_WFI_VAL	((ESR_ELx_EC_WFx << ESR_ELx_EC_SHIFT) |	\
 				 ESR_ELx_WFx_ISS_WFI)
 
-- 
2.34.1

