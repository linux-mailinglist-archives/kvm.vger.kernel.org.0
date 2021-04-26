Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4713C36B1B3
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 12:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbhDZKgz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 06:36:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232800AbhDZKgy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 06:36:54 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA44761185;
        Mon, 26 Apr 2021 10:36:12 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1layb4-009SqT-Lt; Mon, 26 Apr 2021 11:36:10 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Krishna Reddy <vdumpa@nvidia.com>,
        Sumit Gupta <sumitg@nvidia.com>
Subject: [PATCH] KVM: arm64: Skip CMOs when updating a PTE pointing to non-memory
Date:   Mon, 26 Apr 2021 11:36:05 +0100
Message-Id: <20210426103605.616908-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com, jean-philippe@linaro.org, vdumpa@nvidia.com, sumitg@nvidia.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sumit Gupta and Krishna Reddy both reported that for MMIO regions
mapped into userspace using VFIO, a PTE update can trigger a MMU
notifier reaching kvm_set_spte_hva().

There is an assumption baked in kvm_set_spte_hva() that it only
deals with memory pages, and not MMIO. For this purpose, it
performs a cache cleaning of the potentially newly mapped page.
However, for a MMIO range, this explodes as there is no linear
mapping for this range (and doing cache maintenance on it would
make little sense anyway).

Check for the validity of the page before performing the CMO
addresses the problem.

Reported-by: Krishna Reddy <vdumpa@nvidia.com>
Reported-by: Sumit Gupta <sumitg@nvidia.com>,
Tested-by: Sumit Gupta <sumitg@nvidia.com>,
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/5a8825bc-286e-b316-515f-3bd3c9c70a80@nvidia.com
---
 arch/arm64/kvm/mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index cd4d51ae3d4a..564a0f7fcd05 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1236,7 +1236,8 @@ int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
 	 * We've moved a page around, probably through CoW, so let's treat it
 	 * just like a translation fault and clean the cache to the PoC.
 	 */
-	clean_dcache_guest_page(pfn, PAGE_SIZE);
+	if (!kvm_is_device_pfn(pfn))
+		clean_dcache_guest_page(pfn, PAGE_SIZE);
 	handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &pfn);
 	return 0;
 }
-- 
2.30.2

