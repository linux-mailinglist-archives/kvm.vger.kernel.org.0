Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC0A6B7880
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 14:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbjCMNK5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 09:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbjCMNK4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 09:10:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29E35B5F0
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 06:10:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 624E5B810E8
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 13:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8ABC433D2;
        Mon, 13 Mar 2023 13:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678713051;
        bh=T5TzBinFvNtJrCG3LVLJH0W0QQB95zTzrahKqxBr9YM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uPaSbgobaaib9NWqxMj/CH6QVapsOOY3C7ApBOOQew5TEk+MQnM3gsx0PtMbsTSsd
         Z2ZK/AWKwc4mfKvdY7+7t+kXi8183wxLlq3pZ6x6i1fxiTNJ9NUrKmiaYZdIR7bj1H
         MdZACPIdDxVLxgppYB9XhlY7GZ6L0lje1eZnK1f9lI1k5/qjIBJOvoP4tf2iikyxaO
         uW7Y8vyJHZLh2jwGzrxUZTUR76ukVVlzVnDGH/JXXpS5lWCk4C9AebYhpNigSIUbe3
         rkqvc/eRVkz6/mrYvKWLOBYKvQ+02Itq7f+u059PNaH6Iui2Za5fJSeOvwsJsgS7jb
         oJgnvpCXMMpHA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pbhbk-00HEdE-5T;
        Mon, 13 Mar 2023 12:48:56 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Ricardo Koller <ricarkol@google.com>,
        Simon Veith <sveith@amazon.de>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        Joey Gouly <joey.gouly@arm.com>, dwmw2@infradead.org
Subject: [PATCH v2 19/19] KVM: arm64: selftests: Deal with spurious timer interrupts
Date:   Mon, 13 Mar 2023 12:48:37 +0000
Message-Id: <20230313124837.2264882-20-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230313124837.2264882-1-maz@kernel.org>
References: <20230313124837.2264882-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, reijiw@google.com, coltonlewis@google.com, joey.gouly@arm.com, dwmw2@infradead.org
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

Make sure the timer test can properly handle a spurious timer
interrupt, something that is far from being unlikely.

This involves checking for the GIC IAR return value (don't bother
handling the interrupt if it was spurious) as well as the timer
control register (don't do anything if the interrupt is masked
or the timer disabled). Take this opportunity to rewrite the
timer handler in a more readable way.

This solves a bunch of failures that creep up on systems that
are slow to retire the interrupt, something that the GIC architecture
makes no guarantee about.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 .../selftests/kvm/aarch64/arch_timer.c        | 40 ++++++++++++-------
 1 file changed, 25 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index 6d2e811fbf85..ed88580c0a99 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -123,25 +123,35 @@ static void guest_validate_irq(unsigned int intid,
 	uint64_t xcnt = 0, xcnt_diff_us, cval = 0;
 	unsigned long xctl = 0;
 	unsigned int timer_irq = 0;
+	unsigned int accessor;
 
-	if (stage == GUEST_STAGE_VTIMER_CVAL ||
-		stage == GUEST_STAGE_VTIMER_TVAL) {
-		xctl = timer_get_ctl(VIRTUAL);
-		timer_set_ctl(VIRTUAL, CTL_IMASK);
-		xcnt = timer_get_cntct(VIRTUAL);
-		cval = timer_get_cval(VIRTUAL);
+	if (intid == IAR_SPURIOUS)
+		return;
+
+	switch (stage) {
+	case GUEST_STAGE_VTIMER_CVAL:
+	case GUEST_STAGE_VTIMER_TVAL:
+		accessor = VIRTUAL;
 		timer_irq = vtimer_irq;
-	} else if (stage == GUEST_STAGE_PTIMER_CVAL ||
-		stage == GUEST_STAGE_PTIMER_TVAL) {
-		xctl = timer_get_ctl(PHYSICAL);
-		timer_set_ctl(PHYSICAL, CTL_IMASK);
-		xcnt = timer_get_cntct(PHYSICAL);
-		cval = timer_get_cval(PHYSICAL);
+		break;
+	case GUEST_STAGE_PTIMER_CVAL:
+	case GUEST_STAGE_PTIMER_TVAL:
+		accessor = PHYSICAL;
 		timer_irq = ptimer_irq;
-	} else {
+		break;
+	default:
 		GUEST_ASSERT(0);
+		return;
 	}
 
+	xctl = timer_get_ctl(accessor);
+	if ((xctl & CTL_IMASK) || !(xctl & CTL_ENABLE))
+		return;
+
+	timer_set_ctl(accessor, CTL_IMASK);
+	xcnt = timer_get_cntct(accessor);
+	cval = timer_get_cval(accessor);
+
 	xcnt_diff_us = cycles_to_usec(xcnt - shared_data->xcnt);
 
 	/* Make sure we are dealing with the correct timer IRQ */
@@ -150,6 +160,8 @@ static void guest_validate_irq(unsigned int intid,
 	/* Basic 'timer condition met' check */
 	GUEST_ASSERT_3(xcnt >= cval, xcnt, cval, xcnt_diff_us);
 	GUEST_ASSERT_1(xctl & CTL_ISTATUS, xctl);
+
+	WRITE_ONCE(shared_data->nr_iter, shared_data->nr_iter + 1);
 }
 
 static void guest_irq_handler(struct ex_regs *regs)
@@ -160,8 +172,6 @@ static void guest_irq_handler(struct ex_regs *regs)
 
 	guest_validate_irq(intid, shared_data);
 
-	WRITE_ONCE(shared_data->nr_iter, shared_data->nr_iter + 1);
-
 	gic_set_eoi(intid);
 }
 
-- 
2.34.1

