Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6D54FE287
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 15:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349653AbiDLN05 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 09:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356069AbiDLN0p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 09:26:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A388427C4
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 06:19:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2703A61A46
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 13:19:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A31C385A5;
        Tue, 12 Apr 2022 13:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649769590;
        bh=NsQzBnqyQikJz4t5vv6/pIfEg6KlxVdCJGyHvursnek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O0k74iqoL5o7Qwdl/g2m0Wt2gcW6UwwG9JM0tdNoZBChhIqxXmFt7DCzgWDdtVBZ2
         be1ONXbHXUzWgYVCw4H2oeoGXfD0SnlqV2genWUInfDRGphVmwh+O1aamoOJnu/qym
         TatiUUwL1cuwnE7wc9DiebmqnFDbWZU9rEgY5NUyV5Njfh+weSyag6pY9FAiazsWH/
         etzpOuPgi+RBCGw4+Q2I+f3j/1lvSfj3Ed176dXUhPxI5FIVfLu+52sbqfw/kLVzvJ
         m3OSuBNxNv9Y7pLyGPAFU1qSWWa0YXh4/KGheeP63OWL7C6iTYcPHYkijY9tCNAhqM
         x4t0tODjfxj3w==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1neGLC-003mvX-8X; Tue, 12 Apr 2022 14:13:54 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH 10/10] arm64: Use WFxT for __delay() when possible
Date:   Tue, 12 Apr 2022 14:13:03 +0100
Message-Id: <20220412131303.504690-11-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220412131303.504690-1-maz@kernel.org>
References: <20220412131303.504690-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
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

