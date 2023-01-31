Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0636828C4
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 10:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232619AbjAaJZu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 04:25:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232474AbjAaJZn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 04:25:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C7A222DD
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 01:25:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77C75B81A84
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 09:25:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23055C433D2;
        Tue, 31 Jan 2023 09:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675157132;
        bh=bs/YrObwitf4kEvM0zuHy+3mBo5vDAOzoljTOjtCkfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fQ1QOsZf6KwuzEQEaeJ9P3zOpcfONingCoxqPHCDwc8Dv8QgAQPEaW6YLJEGgZovl
         eoRYZVxJlnY2IU9yjTJIlDtFDQ1tT8kyPdXAouzpo/dyw7Iewv9l6TcnDomk4TBE8M
         mFM065ybHZjxld4voOhyIkONOjlg7qgfziKd7Zf5X7y0KmjDTur+c8RbAom/3OpVXT
         cTJlGd67QG2i6BBZFhX1NWS6ux/4p0/NUveGirjn8TwgOhBK/SBrIltXusFgyqetVS
         fMavNVZCrrPIXpsiSrGZWFZWXsW1c+OiFopIbL3UrJrEZdxQ2KUVXESahEMUCkkDdO
         qYFHE248snePw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1pMmtO-0067U2-5T;
        Tue, 31 Jan 2023 09:25:30 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH v8 02/69] KVM: arm64: Use the S2 MMU context to iterate over S2 table
Date:   Tue, 31 Jan 2023 09:23:57 +0000
Message-Id: <20230131092504.2880505-3-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230131092504.2880505-1-maz@kernel.org>
References: <20230131092504.2880505-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, alexandru.elisei@arm.com, andre.przywara@arm.com, chase.conklin@arm.com, christoffer.dall@arm.com, gankulkarni@os.amperecomputing.com, jintack@cs.columbia.edu, rmk+kernel@armlinux.org.uk, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Most of our S2 helpers take a kvm_s2_mmu pointer, but quickly
revert back to using the kvm structure. By doing so, we lose
track of which S2 MMU context we were initially using, and fallback
to the "canonical" context.

If we were trying to unmap a S2 context managed by a guest hypervisor,
we end-up parsing the wrong set of page tables, and bad stuff happens
(as this is often happening on the back of a trapped TLBI from the
guest hypervisor).

Instead, make sure we always use the provided MMU context all the way.
This has no impact on non-NV, as we always pass the canonical MMU
context.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index cfc7777fa490..217a511eb271 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -46,16 +46,17 @@ static phys_addr_t stage2_range_addr_end(phys_addr_t addr, phys_addr_t end)
  * long will also starve other vCPUs. We have to also make sure that the page
  * tables are not freed while we released the lock.
  */
-static int stage2_apply_range(struct kvm *kvm, phys_addr_t addr,
+static int stage2_apply_range(struct kvm_s2_mmu *mmu, phys_addr_t addr,
 			      phys_addr_t end,
 			      int (*fn)(struct kvm_pgtable *, u64, u64),
 			      bool resched)
 {
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
 	int ret;
 	u64 next;
 
 	do {
-		struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
+		struct kvm_pgtable *pgt = mmu->pgt;
 		if (!pgt)
 			return -EINVAL;
 
@@ -71,8 +72,8 @@ static int stage2_apply_range(struct kvm *kvm, phys_addr_t addr,
 	return ret;
 }
 
-#define stage2_apply_range_resched(kvm, addr, end, fn)			\
-	stage2_apply_range(kvm, addr, end, fn, true)
+#define stage2_apply_range_resched(mmu, addr, end, fn)			\
+	stage2_apply_range(mmu, addr, end, fn, true)
 
 static bool memslot_is_logging(struct kvm_memory_slot *memslot)
 {
@@ -235,7 +236,7 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 	WARN_ON(size & ~PAGE_MASK);
-	WARN_ON(stage2_apply_range(kvm, start, end, kvm_pgtable_stage2_unmap,
+	WARN_ON(stage2_apply_range(mmu, start, end, kvm_pgtable_stage2_unmap,
 				   may_block));
 }
 
@@ -934,8 +935,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
  */
 static void stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
 {
-	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
-	stage2_apply_range_resched(kvm, addr, end, kvm_pgtable_stage2_wrprotect);
+	stage2_apply_range_resched(mmu, addr, end, kvm_pgtable_stage2_wrprotect);
 }
 
 /**
-- 
2.34.1

