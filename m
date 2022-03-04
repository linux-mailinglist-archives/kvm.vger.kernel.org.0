Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBD424CD5C6
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 14:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239738AbiCDOAR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 09:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239679AbiCDOAO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 09:00:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A475E42A18
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 05:59:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 367C8615E1
        for <kvm@vger.kernel.org>; Fri,  4 Mar 2022 13:59:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EBCDC340E9;
        Fri,  4 Mar 2022 13:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646402365;
        bh=aDDUTrSaHUg2O24fF8jlt5pGcEdXVX897YYvC2Z3OSk=;
        h=From:To:Cc:Subject:Date:From;
        b=gJnJDN56QZOinBigwwaFXm+Tz098AzwejnLtLn604qUkIuSYasb+6HfChp1Yv9a2p
         YKSoziHjOCSCsGXgLg+iehGdjlDxUwOnbtc/MxvUzO1daqLr6gBJDezshs3KgxYZ5o
         BfrNrzkJCkcIZF5bSLapQdXEAL1Tg2sQAggcDBrmND4Z0RI4SWAjp8okF213SecSh6
         yZlKq4Otrc21MpJDSvL/Fng18EYlGH5nlgaP1I4xClxibLID//z3HGRUgpPBjPISV8
         0GtwrZl5dqz6+FBMmFcMMPkuomab15a3a/w+QDIiwK/veCADBrQmz18cpyhAGoLAix
         NsIhMTXzYeDKA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nQ8So-00CEVb-Vn; Fri, 04 Mar 2022 13:59:23 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH] KVM: arm64: Only open the interrupt window on exit due to an interrupt
Date:   Fri,  4 Mar 2022 13:59:14 +0000
Message-Id: <20220304135914.1464721-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, mark.rutland@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that we properly account for interrupts taken whilst the guest
was running, it becomes obvious that there is no need to open
this accounting window if we didn't exit because of an interrupt.

This saves a number of system register accesses and other barriers
if we exited for any other reason (such as a trap, for example).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arm.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fefd5774ab55..f49ebdd9c990 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -887,9 +887,11 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 * context synchronization event) is necessary to ensure that
 		 * pending interrupts are taken.
 		 */
-		local_irq_enable();
-		isb();
-		local_irq_disable();
+		if (ARM_EXCEPTION_CODE(ret) == ARM_EXCEPTION_IRQ) {
+			local_irq_enable();
+			isb();
+			local_irq_disable();
+		}
 
 		guest_timing_exit_irqoff();
 
-- 
2.34.1

