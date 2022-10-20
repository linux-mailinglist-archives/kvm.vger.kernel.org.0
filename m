Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28A4D605A9E
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 11:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbiJTJHr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 05:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiJTJHl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 05:07:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1362819B655
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 02:07:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB96FB826A1
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:07:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF67C43144;
        Thu, 20 Oct 2022 09:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666256858;
        bh=xyiyg9il/ViIF4bM3FJ9Dsfm9mqVqIoR7isfo23/NMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tAbIEMlGW44lpBy4A+Jy0Xv5KOgwSHnfozq6Kwr/9VVOntb+tOyDQV03qTIrlIJ8Y
         l/MnIdIr5P7PEIHhwY4K2D30+Mbq713bwK/QtmVGXp3mi2kWkvMS0ySnStahPxnDDf
         R/OwUTMIojl0j9DQbhGulf05qRL9qmRLyeJmPNAY9C9d0TrRTpZl6SFR2uk/wvCbQ0
         L0H+u77VaYd3aj0d1ut1KtLpl9kP/JoARYZICVBPipLG3db0R4Hrn8kk9VeF3cO7qb
         oUZ3w/db57sG/5hO7PxtP2f5fyk9HyLa2tLw1CErlGWQAdyhmhHChiweSqB3SSPPv0
         uah1VH+mkq/sw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1olRWZ-000Buf-T2;
        Thu, 20 Oct 2022 10:07:35 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     <kvmarm@lists.cs.columbia.edu>, <kvmarm@lists.linux.dev>,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>
Subject: [PATCH 05/17] arm64: Allow EL1 physical timer access when running VHE
Date:   Thu, 20 Oct 2022 10:07:15 +0100
Message-Id: <20221020090727.3669908-6-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221020090727.3669908-1-maz@kernel.org>
References: <20221020090727.3669908-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, oliver.upton@linux.dev, qperret@google.com, will@kernel.org, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To initialise the timer access from EL2 when HCR_EL2.E2H is set,
we must make use the CNTHCTL_EL2 formap used is appropriate.

This amounts to shifting the timer/counter enable bits by 10
to the left.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/el2_setup.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 668569adf4d3..fa1045f709bb 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -34,6 +34,11 @@
  */
 .macro __init_el2_timers
 	mov	x0, #3				// Enable EL1 physical timers
+	mrs	x1, hcr_el2
+	and	x1, x1, #HCR_E2H
+	cbz	x1, .LnVHE_\@
+	lsl	x0, x0, #10
+.LnVHE_\@:
 	msr	cnthctl_el2, x0
 	msr	cntvoff_el2, xzr		// Clear virtual offset
 .endm
-- 
2.34.1

