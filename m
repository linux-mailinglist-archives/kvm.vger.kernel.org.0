Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 037936DBC10
	for <lists+kvm@lfdr.de>; Sat,  8 Apr 2023 18:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbjDHQE4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 8 Apr 2023 12:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbjDHQEx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 8 Apr 2023 12:04:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453C4D500
        for <kvm@vger.kernel.org>; Sat,  8 Apr 2023 09:04:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C272760B43
        for <kvm@vger.kernel.org>; Sat,  8 Apr 2023 16:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C61EC433D2;
        Sat,  8 Apr 2023 16:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680969891;
        bh=ccwv9tH1t6Cn5/tuDW4QfW8z+r1vALUHZQx9EhTTIF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oqs///SlMfArkEyC7hr6aTV8TJuqjLcFggwo97O8Ze51BhcFzmrhJCZXui0e/SPj9
         A/vdBI1C4QhwdATZG09RcfGnQ3q2OfY4wiPofj5fOX65u14vhZ9TsXmYKJNbFvMOy9
         YSfVPD0fk8ovzbPISxbEu8A4fczBJO8UfShQYxKGwSwHzVy8jEt+aoUbhlGzI1R0rD
         rlLHgHH7yNOUvFPBCHSkJLnNGjF3cDV56iOeQRjsR8TdPznHk/ck5H4UYm4MuSY0xL
         4jY+15aPavHH0jbtdzyf2yEk/GOv7lVw2ftv3UAjXO+tfniuJf7kFIpca/wvdHhgl6
         Pofce64LZwJNQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1plB3Y-006wc5-UL;
        Sat, 08 Apr 2023 17:04:48 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v2 1/5] KVM: arm64: nvhe: Synchronise with page table walker on vcpu run
Date:   Sat,  8 Apr 2023 17:04:23 +0100
Message-Id: <20230408160427.10672-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230408160427.10672-1-maz@kernel.org>
References: <20230408160427.10672-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When taking an exception between the EL1&0 translation regime and
the EL2 translation regime, the page table walker is allowed to
complete the walks started from EL0 or EL1 while running at EL2.

It means that altering the system registers that define the EL1&0
translation regime is fraught with danger *unless* we wait for
the completion of such walk with a DSB (R_LFHQG and subsequent
statements in the ARM ARM). We already did the right thing for
other external agents (SPE, TRBE), but not the PTW.

Rework the existing SPE/TRBE synchronisation to include the PTW,
and add the missing DSB on guest exit.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/debug-sr.c |  2 --
 arch/arm64/kvm/hyp/nvhe/switch.c   | 18 ++++++++++++++++++
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index 2673bde62fad..d756b939f296 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -37,7 +37,6 @@ static void __debug_save_spe(u64 *pmscr_el1)
 
 	/* Now drain all buffered data to memory */
 	psb_csync();
-	dsb(nsh);
 }
 
 static void __debug_restore_spe(u64 pmscr_el1)
@@ -69,7 +68,6 @@ static void __debug_save_trace(u64 *trfcr_el1)
 	isb();
 	/* Drain the trace buffer to memory */
 	tsb_csync();
-	dsb(nsh);
 }
 
 static void __debug_restore_trace(u64 trfcr_el1)
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index c2cb46ca4fb6..71fa16a0dc77 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -272,6 +272,17 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	 */
 	__debug_save_host_buffers_nvhe(vcpu);
 
+	/*
+	 * We're about to restore some new MMU state. Make sure
+	 * ongoing page-table walks that have started before we
+	 * trapped to EL2 have completed. This also synchronises the
+	 * above disabling of SPE and TRBE.
+	 *
+	 * See DDI0487I.a D8.1.5 "Out-of-context translation regimes",
+	 * rule R_LFHQG and subsequent information statements.
+	 */
+	dsb(nsh);
+
 	__kvm_adjust_pc(vcpu);
 
 	/*
@@ -306,6 +317,13 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	__timer_disable_traps(vcpu);
 	__hyp_vgic_save_state(vcpu);
 
+	/*
+	 * Same thing as before the guest run: we're about to switch
+	 * the MMU context, so let's make sure we don't have any
+	 * ongoing EL1&0 translations.
+	 */
+	dsb(nsh);
+
 	__deactivate_traps(vcpu);
 	__load_host_stage2();
 
-- 
2.34.1

