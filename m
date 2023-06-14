Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE1E730430
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 17:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244753AbjFNPvz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 11:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235239AbjFNPvy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 11:51:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B61D2107
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 08:51:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5DB764257
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 15:51:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BEAC433C8;
        Wed, 14 Jun 2023 15:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686757907;
        bh=aXqtfOPOwE4+iz5gui+z2qSlHu7RCO7EOHT8YCzHfjM=;
        h=From:To:Cc:Subject:Date:From;
        b=Y+JnNjm3LfeUwZ1pdv/r3OMvgTcBrxSU6DkRiywsxq9EYrLkt5UnnNH7ghJ9rTYny
         XiBP2na+f4sK2QAKS0NcM8ykQdlGm9wDqou8P2nKQbIvB1ptW8s3DLalnqC6Qfpkn5
         CGj54INXz4UHJeiORao+pbl4SqtgWXef/LExLZbiIeG57giFCKJ326pRVCokegu98f
         8WczCTQcr+UjE+jkqSoIi23lMatU+NnRwhl7Wgbpefy2tFwyKKYS6r2dPkbFKIE76A
         I/N5WyEIhc0BNPvyR+glsF51EbJujeli8PWDtSupKo6U47BhMXgU+eHyvjrYgkixGu
         5khK1/K/O49AA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1q9Sme-005NHQ-PJ;
        Wed, 14 Jun 2023 16:51:45 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: Fix hVHE init on CPUs where HCR_EL2.E2H is not RES1
Date:   Wed, 14 Jun 2023 16:51:29 +0100
Message-Id: <20230614155129.2697388-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
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

On CPUs where E2H is RES1, we very quickly set the scene for
running EL2 with a VHE configuration, as we do not have any other
choice.

However, CPUs that conform to the current writing of the architecture
start with E2H=0, and only later upgrade with E2H=1. This is all
good, but nothing there is actually reconfiguring EL2 to be able
to correctly run the kernel at EL1. Huhuh...

The "obvious" solution is not to just reinitialise the timer
controls like we do, but to really intitialise *everything*
unconditionally.

This requires a bit of surgery, and is a good opportunity to
remove the macro that messes with SPSR_EL2 in init_el2_state.

With that, hVHE now works correctly on my trusted A55 machine!

Reported-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/el2_setup.h |  1 -
 arch/arm64/kernel/head.S           |  2 ++
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 19 ++++++++++++-------
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index bba508ffa12d..5a353f94e9cd 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -205,7 +205,6 @@
 	__init_el2_nvhe_idregs
 	__init_el2_cptr
 	__init_el2_fgt
-	__init_el2_nvhe_prepare_eret
 .endm
 
 #ifndef __KVM_NVHE_HYPERVISOR__
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index e92caebff46a..23955050da73 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -603,6 +603,8 @@ SYM_INNER_LABEL(init_el2, SYM_L_LOCAL)
 	msr	sctlr_el1, x1
 	mov	x2, xzr
 2:
+	__init_el2_nvhe_prepare_eret
+
 	mov	w0, #BOOT_CPU_MODE_EL2
 	orr	x0, x0, x2
 	eret
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index f9ee10e29497..74ee77d9cfd0 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -83,9 +83,6 @@ SYM_CODE_END(__kvm_hyp_init)
  * x0: struct kvm_nvhe_init_params PA
  */
 SYM_CODE_START_LOCAL(___kvm_hyp_init)
-	ldr	x1, [x0, #NVHE_INIT_TPIDR_EL2]
-	msr	tpidr_el2, x1
-
 	ldr	x1, [x0, #NVHE_INIT_STACK_HYP_VA]
 	mov	sp, x1
 
@@ -99,11 +96,18 @@ SYM_CODE_START_LOCAL(___kvm_hyp_init)
 	and	x2, x1, x2
 	cbz	x2, 1f
 
-	mrs	x1, cnthctl_el2
-	and	x1, x1, #~(BIT(0) | BIT(1))
-	orr	x1, x1, #(BIT(10) | BIT(11))
-	msr	cnthctl_el2, x1
+	// hVHE: Replay the EL2 setup to account for the E2H bit
+	// TPIDR_EL2 is used to preserve x0 across the macro maze...
+	isb
+	msr	tpidr_el2, x0
+	init_el2_state
+	finalise_el2_state
+	mrs	x0, tpidr_el2
+
 1:
+	ldr	x1, [x0, #NVHE_INIT_TPIDR_EL2]
+	msr	tpidr_el2, x1
+
 	ldr	x1, [x0, #NVHE_INIT_VTTBR]
 	msr	vttbr_el2, x1
 
@@ -193,6 +197,7 @@ SYM_CODE_START_LOCAL(__kvm_hyp_init_cpu)
 	/* Initialize EL2 CPU state to sane values. */
 	init_el2_state				// Clobbers x0..x2
 	finalise_el2_state
+	__init_el2_nvhe_prepare_eret
 
 	/* Enable MMU, set vectors and stack. */
 	mov	x0, x28
-- 
2.34.1

