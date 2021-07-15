Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2524C3CA25F
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 18:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbhGOQfN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 12:35:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231583AbhGOQfK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jul 2021 12:35:10 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08904613F8;
        Thu, 15 Jul 2021 16:32:17 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1m44HX-00DYjr-EX; Thu, 15 Jul 2021 17:32:15 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     will@kernel.org, qperret@google.com, dbrazdil@google.com,
        Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: [PATCH 02/16] KVM: arm64: Don't issue CMOs when the physical address is invalid
Date:   Thu, 15 Jul 2021 17:31:45 +0100
Message-Id: <20210715163159.1480168-3-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210715163159.1480168-1-maz@kernel.org>
References: <20210715163159.1480168-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, will@kernel.org, qperret@google.com, dbrazdil@google.com, vatsa@codeaurora.org, sdonthineni@nvidia.com, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make sure we don't issue CMOs when mapping something that
is not a memory address in the S2 page tables.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/pgtable.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 05321f4165e3..a5874ebd0354 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -619,12 +619,16 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 	}
 
 	/* Perform CMOs before installation of the guest stage-2 PTE */
-	if (mm_ops->dcache_clean_inval_poc && stage2_pte_cacheable(pgt, new))
-		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(new, mm_ops),
-						granule);
-
-	if (mm_ops->icache_inval_pou && stage2_pte_executable(new))
-		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
+	if (kvm_phys_is_valid(phys)) {
+		if (mm_ops->dcache_clean_inval_poc &&
+		    stage2_pte_cacheable(pgt, new))
+			mm_ops->dcache_clean_inval_poc(kvm_pte_follow(new,
+								      mm_ops),
+						       granule);
+		if (mm_ops->icache_inval_pou && stage2_pte_executable(new))
+			mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops),
+						 granule);
+	}
 
 	smp_store_release(ptep, new);
 	if (stage2_pte_is_counted(new))
-- 
2.30.2

