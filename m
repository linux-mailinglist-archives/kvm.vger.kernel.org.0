Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63D9C6E08B4
	for <lists+kvm@lfdr.de>; Thu, 13 Apr 2023 10:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbjDMIOz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Apr 2023 04:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbjDMIOw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Apr 2023 04:14:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA00F5FD4
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 01:14:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 441B4619D2
        for <kvm@vger.kernel.org>; Thu, 13 Apr 2023 08:14:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03F1C433A0;
        Thu, 13 Apr 2023 08:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681373690;
        bh=ssGIGapEX7W9wNVAFXirqDVqgvwzBthGP08DUYy3w04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fSSlUmww/bhflKQrsaGCMT9KSau9hd7ktOCvVx1z6D6W0+bVlEKZGQQ77NAIlZXht
         IVV+YXbk1/6lG+hdjMPuiLqZ8qVo7uwm8eEBWri6qjmgzbSsQoVmS9GQ+oi2tuVGt1
         Jr5MvyqLKt8esOSLOuRLTf013vlhktwRFFPb84bCEgU/etIGBcNtvFkFizE1mA40tL
         PkmTTBRZ3+++dERjINrWSKGIyOA0SxDnF9Vb2T5XuTa/85CePy/7I5NxeuTekkEvJ9
         /O0jnawnAvGtyEPCDHHdDaoGz9FY9qp24Eh8iQQb+qVnM3eTwVwAmVg2KO07on3Tbc
         d1i+Rmw0FyVFA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pms6S-0082qd-Mf;
        Thu, 13 Apr 2023 09:14:48 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Ricardo Koller <ricarkol@google.com>
Subject: [PATCH v3 2/5] KVM: arm64: nvhe: Synchronise with page table walker on TLBI
Date:   Thu, 13 Apr 2023 09:14:38 +0100
Message-Id: <20230413081441.165134-3-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230413081441.165134-1-maz@kernel.org>
References: <20230413081441.165134-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, ricarkol@google.com
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

A TLBI from EL2 impacting EL1 involves messing with the EL1&0
translation regime, and the page table walker may still be
performing speculative walks.

Piggyback on the existing DSBs to always have a DSB ISH that
will synchronise all load/store operations that the PTW may
still have.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/tlb.c | 38 ++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index d296d617f589..1da2fc35f94e 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -15,8 +15,31 @@ struct tlb_inv_context {
 };
 
 static void __tlb_switch_to_guest(struct kvm_s2_mmu *mmu,
-				  struct tlb_inv_context *cxt)
+				  struct tlb_inv_context *cxt,
+				  bool nsh)
 {
+	/*
+	 * We have two requirements:
+	 *
+	 * - ensure that the page table updates are visible to all
+         *   CPUs, for which a dsb(DOMAIN-st) is what we need, DOMAIN
+         *   being either ish or nsh, depending on the invalidation
+         *   type.
+	 *
+	 * - complete any speculative page table walk started before
+         *   we trapped to EL2 so that we can mess with the MM
+         *   registers out of context, for which dsb(nsh) is enough
+	 *
+	 * The composition of these two barriers is a dsb(DOMAIN), and
+	 * the 'nsh' parameter tracks the distinction between
+	 * Inner-Shareable and Non-Shareable, as specified by the
+	 * callers.
+	 */
+	if (nsh)
+		dsb(nsh);
+	else
+		dsb(ish);
+
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		u64 val;
 
@@ -60,10 +83,8 @@ void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
 {
 	struct tlb_inv_context cxt;
 
-	dsb(ishst);
-
 	/* Switch to requested VMID */
-	__tlb_switch_to_guest(mmu, &cxt);
+	__tlb_switch_to_guest(mmu, &cxt, false);
 
 	/*
 	 * We could do so much better if we had the VA as well.
@@ -113,10 +134,8 @@ void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
 {
 	struct tlb_inv_context cxt;
 
-	dsb(ishst);
-
 	/* Switch to requested VMID */
-	__tlb_switch_to_guest(mmu, &cxt);
+	__tlb_switch_to_guest(mmu, &cxt, false);
 
 	__tlbi(vmalls12e1is);
 	dsb(ish);
@@ -130,7 +149,7 @@ void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu)
 	struct tlb_inv_context cxt;
 
 	/* Switch to requested VMID */
-	__tlb_switch_to_guest(mmu, &cxt);
+	__tlb_switch_to_guest(mmu, &cxt, false);
 
 	__tlbi(vmalle1);
 	asm volatile("ic iallu");
@@ -142,7 +161,8 @@ void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu)
 
 void __kvm_flush_vm_context(void)
 {
-	dsb(ishst);
+	/* Same remark as in __tlb_switch_to_guest() */
+	dsb(ish);
 	__tlbi(alle1is);
 
 	/*
-- 
2.34.1

