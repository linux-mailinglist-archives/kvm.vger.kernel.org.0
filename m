Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 973EF50796B
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 20:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355615AbiDSSwy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 14:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357388AbiDSSwk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 14:52:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6FA11C31
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 11:49:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B73AB819A3
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 18:49:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE55C385A7;
        Tue, 19 Apr 2022 18:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650394193;
        bh=NsQzBnqyQikJz4t5vv6/pIfEg6KlxVdCJGyHvursnek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PsLZPyeR7NEosrxFAH6xo9aVOEo6xXUnhE0ADprj/RG8wklR6ikAnBz7hQ+9OLSXl
         HHgdTY7IfFkZUoVq2EeG/HvVtxxvENLGsyOewpM8GPBxlGo4q1wfJ9zI8vWAChkfKu
         3YBW4VpWYO2vqgSyIM/S8lNvXcX+ibogecHS/l4Fo+pEgPRpC04qWELX/lIunJFHv/
         YbzkjzijOxaOU55uM3q5P2bvFuned33fzZoacKbSHw/bntB/pytKsNkzAygbOpFH73
         QZbR4KQiY2YMF98jIHplltBySjBtq7QXoI4L1k7t8aCoKDFcoIxF2Toq3wYchN978F
         /O9RSgkhYi2Rg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1ngsa7-005QYF-Vt; Tue, 19 Apr 2022 19:28:08 +0100
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
Subject: [PATCH v2 10/10] arm64: Use WFxT for __delay() when possible
Date:   Tue, 19 Apr 2022 19:27:55 +0100
Message-Id: <20220419182755.601427-11-maz@kernel.org>
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

Marginally optimise __delay() by using a WFIT/WFET sequence.
It probably is a win if no interrupt fires during the delay.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/lib/delay.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/lib/delay.c b/arch/arm64/lib/delay.c
index 1688af0a4c97..5b7890139bc2 100644
--- a/arch/arm64/lib/delay.c
+++ b/arch/arm64/lib/delay.c
@@ -27,7 +27,17 @@ void __delay(unsigned long cycles)
 {
 	cycles_t start = get_cycles();
 
-	if (arch_timer_evtstrm_available()) {
+	if (cpus_have_const_cap(ARM64_HAS_WFXT)) {
+		u64 end = start + cycles;
+
+		/*
+		 * Start with WFIT. If an interrupt makes us resume
+		 * early, use a WFET loop to complete the delay.
+		 */
+		wfit(end);
+		while ((get_cycles() - start) < cycles)
+			wfet(end);
+	} else 	if (arch_timer_evtstrm_available()) {
 		const cycles_t timer_evt_period =
 			USECS_TO_CYCLES(ARCH_TIMER_EVT_STREAM_PERIOD_US);
 
-- 
2.34.1

