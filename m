Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7546D009C
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 12:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbjC3KFK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 06:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbjC3KEz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 06:04:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC1E10DD
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 03:04:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8BCB61FD8
        for <kvm@vger.kernel.org>; Thu, 30 Mar 2023 10:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39AD2C433EF;
        Thu, 30 Mar 2023 10:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680170670;
        bh=Wq/Jem/6t7SqUQQ2xM4SVVX7/2HHigaqn+8GvfAmjTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tWTLm9rp1GzT20QSJSUEs6Mlcs1qUeTUHube/w5IqJO5xHllv+LZTtW6oNFipJYen
         rUXLHCWRYDRvaa4XiR2Pt55r0PjQFLMI/gf+kH8SRQ+rsOcEapptthraI9PLgtu47s
         JOW5MxM7Sx3Mu40ugenMizrHqeK8qxfVm0zkjvW7LS9avmkXD4pAYW8DWb7fhYp9Z7
         jEuRKfuaWPZQeZ/+S827IRimGMzbNBX++SSZsPzGAAyF7YpGNm/tHHKbSyKU9mz8Yi
         BxJImwDZQRH0ZXtsmj1gn+wz9rOgb2DA7xriSYyCLD0hwcOgUbC2SjI53xYyGWBPvV
         Vt+pNVzTCOIjg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1php8u-004K66-4t;
        Thu, 30 Mar 2023 11:04:28 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 1/2] KVM: arm64: nvhe: Synchronise with page table walker on MMU update
Date:   Thu, 30 Mar 2023 11:04:18 +0100
Message-Id: <20230330100419.1436629-2-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230330100419.1436629-1-maz@kernel.org>
References: <20230330100419.1436629-1-maz@kernel.org>
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

In the case of nVHE, this is a bit involved, as there are a number
of situations where this can happen (such as switching between
host and guest, invalidating TLBs...).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/debug-sr.c    |  2 --
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |  7 +++++++
 arch/arm64/kvm/hyp/nvhe/switch.c      | 18 ++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/tlb.c         |  7 +++++++
 4 files changed, 32 insertions(+), 2 deletions(-)

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
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 552653fa18be..2e9ec4a2a4a3 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -297,6 +297,13 @@ int __pkvm_prot_finalize(void)
 	params->vttbr = kvm_get_vttbr(mmu);
 	params->vtcr = host_mmu.arch.vtcr;
 	params->hcr_el2 |= HCR_VM;
+
+	/*
+	 * The CMO below not only cleans the updated params to the
+	 * PoC, but also provides the DSB that ensures ongoing
+	 * page-table walks that have started before we trapped to EL2
+	 * have completed.
+	 */
 	kvm_flush_dcache_to_poc(params, sizeof(*params));
 
 	write_sysreg(params->hcr_el2, hcr_el2);
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
 
diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index d296d617f589..15c3e782dbd8 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -129,6 +129,13 @@ void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu)
 {
 	struct tlb_inv_context cxt;
 
+	/*
+	 * We're about to restore some guest MMU state. Make sure
+	 * ongoing page-table walks that have started before we
+	 * trapped to EL2 have completed.
+	 */
+	dsb(nsh);
+
 	/* Switch to requested VMID */
 	__tlb_switch_to_guest(mmu, &cxt);
 
-- 
2.34.1

