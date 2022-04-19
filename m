Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6E9F50791E
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 20:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354140AbiDSShF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 14:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357352AbiDSSgu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 14:36:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03BDE3F31F
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 11:28:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6112B6143D
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 18:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6887C385AB;
        Tue, 19 Apr 2022 18:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650392889;
        bh=eBQlI0l4NUr7azBz5ZU4vyP7W5yicZ/ar1oBwnAgjSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vJJDQPvuL753Y4QuIdMO/YqzQy9L9jJV2iJHD7neJ/KT9x/5YuLWdDrxjjoTfIdla
         WRaetdaciSf2alw9EGUb8OHk7uv1e8F+Q3e9onOQTIF6LFytO9X3qVgl9yLBWEPnuK
         GfrL0lDf0MfhARbrFWzdtG1u1uptKkZcaye9IfclJYuQwHlLTM7JoxjGDsEIE+yZos
         Gvu+h4PnftE7H2sWhqo2+xE8x4newfxIPGAuTTBdDFzMkerSb0cWAroJzL1k+3VVox
         L2ZwUMCbPXplf9lpVWfIzD9R9aFtXuclPU7SP4f3KoO08+W/z/Dvj1xsMwXa/cz20/
         1rhjnN0ssQmJA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1ngsa7-005QYF-He; Tue, 19 Apr 2022 19:28:07 +0100
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
Subject: [PATCH v2 09/10] arm64: Add wfet()/wfit() helpers
Date:   Tue, 19 Apr 2022 19:27:54 +0100
Message-Id: <20220419182755.601427-10-maz@kernel.org>
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

Just like we have helpers for WFI and WFE, add the WFxT versions.
Note that the encoding is that reported by objdump, as no currrent
toolchain knows about these instructions yet.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/barrier.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/barrier.h b/arch/arm64/include/asm/barrier.h
index 62217be36217..9f3e2c3d2ca0 100644
--- a/arch/arm64/include/asm/barrier.h
+++ b/arch/arm64/include/asm/barrier.h
@@ -16,7 +16,11 @@
 
 #define sev()		asm volatile("sev" : : : "memory")
 #define wfe()		asm volatile("wfe" : : : "memory")
+#define wfet(val)	asm volatile("msr s0_3_c1_c0_0, %0"	\
+				     : : "r" (val) : "memory")
 #define wfi()		asm volatile("wfi" : : : "memory")
+#define wfit(val)	asm volatile("msr s0_3_c1_c0_1, %0"	\
+				     : : "r" (val) : "memory")
 
 #define isb()		asm volatile("isb" : : : "memory")
 #define dmb(opt)	asm volatile("dmb " #opt : : : "memory")
-- 
2.34.1

