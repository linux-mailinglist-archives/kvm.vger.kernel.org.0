Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D40648EA1F
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 13:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241128AbiANMvS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 07:51:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235721AbiANMvR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 07:51:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553D7C061574
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 04:51:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFF36B825ED
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 12:51:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C01C36AE5;
        Fri, 14 Jan 2022 12:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642164674;
        bh=dPXq9cLFgWXLcBFy2+9YcSrY9JD0ytJBG2TzdVinXGA=;
        h=From:To:Cc:Subject:Date:From;
        b=mtMg7A7Tnmm79zBf0Dd/R5J5h17JnfA5hZ/0jQlsnNbU6unYIqe32Zt5r62L1+r68
         ziVSep55J/TTnYAfQY9TrojkURSL2/9O2KfMmcRwH2j+4zGwVuGtBj8GxmT10s0s2O
         FR4nhFSikADvGEBduN3+4/W5U5UNc1M6OGOJK2oMndMZ1HAIywZBR/o9vJ+d9Py+2E
         A92CLHBZNXe4QWpFE0Taw3lzPv/dQcmM6KNwmdL7MjGu1mNJ8rozxcooBqKDtGLa9x
         MjtshmQ1u/xDk8XK5FSavmyNVDorEw7+iOUGOD7DFamr7yRPZbT+MO8swG3gtBbi/C
         3SjfkEVuCi9Qw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1n8M2x-000UM5-Cv; Fri, 14 Jan 2022 12:51:11 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Will Deacon <will@kernel.org>, Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>
Subject: [PATCH] KVM: arm64: pkvm: Use the mm_ops indirection for cache maintenance
Date:   Fri, 14 Jan 2022 12:50:38 +0000
Message-Id: <20220114125038.1336965-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, will@kernel.org, tabba@google.com, qperret@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CMOs issued from EL2 cannot directly use the kernel helpers,
as EL2 doesn't have a mapping of the guest pages. Oops.

Instead, use the mm_ops indirection to use helpers that will
perform a mapping at EL2 and allow the CMO to be effective.

Fixes: 25aa28691bb9 ("KVM: arm64: Move guest CMOs to the fault handlers")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/pgtable.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 844a6f003fd5..2cb3867eb7c2 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -983,13 +983,9 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	 */
 	stage2_put_pte(ptep, mmu, addr, level, mm_ops);
 
-	if (need_flush) {
-		kvm_pte_t *pte_follow = kvm_pte_follow(pte, mm_ops);
-
-		dcache_clean_inval_poc((unsigned long)pte_follow,
-				    (unsigned long)pte_follow +
-					    kvm_granule_size(level));
-	}
+	if (need_flush && mm_ops->dcache_clean_inval_poc)
+		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(pte, mm_ops),
+					       kvm_granule_size(level));
 
 	if (childp)
 		mm_ops->put_page(childp);
@@ -1151,15 +1147,13 @@ static int stage2_flush_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	struct kvm_pgtable *pgt = arg;
 	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
 	kvm_pte_t pte = *ptep;
-	kvm_pte_t *pte_follow;
 
 	if (!kvm_pte_valid(pte) || !stage2_pte_cacheable(pgt, pte))
 		return 0;
 
-	pte_follow = kvm_pte_follow(pte, mm_ops);
-	dcache_clean_inval_poc((unsigned long)pte_follow,
-			    (unsigned long)pte_follow +
-				    kvm_granule_size(level));
+	if (mm_ops->dcache_clean_inval_poc)
+		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(pte, mm_ops),
+					       kvm_granule_size(level));
 	return 0;
 }
 
-- 
2.30.2

