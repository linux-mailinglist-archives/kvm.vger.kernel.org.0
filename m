Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671B42CF3E2
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 19:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730088AbgLDSUl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 13:20:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:45422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729780AbgLDSUl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Dec 2020 13:20:41 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE9AD22C9C;
        Fri,  4 Dec 2020 18:20:00 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1klFgV-00G3EZ-5G; Fri, 04 Dec 2020 18:19:59 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Keqian Zhu <zhukeqian1@huawei.com>, Will Deacon <will@kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>, kernel-team@android.com,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/3] KVM: arm64: Fix memory leak on stage2 update of a valid PTE
Date:   Fri,  4 Dec 2020 18:19:12 +0000
Message-Id: <20201204181914.783445-2-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201204181914.783445-1-maz@kernel.org>
References: <20201204181914.783445-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, zhukeqian1@huawei.com, will@kernel.org, wangyanan55@huawei.com, kernel-team@android.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yanan Wang <wangyanan55@huawei.com>

When installing a new leaf PTE onto an invalid ptep, we need to
get_page(ptep) to account for the new mapping.

However, simply updating a valid PTE shouldn't result in any
additional refcounting, as there is new mapping. This otherwise
results in a page being forever wasted.

Address this by fixing-up the refcount in stage2_map_walker_try_leaf()
if the PTE was already valid, balancing out the later get_page()
in stage2_map_walk_leaf().

Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
[maz: update commit message, add comment in the code]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20201201201034.116760-2-wangyanan55@huawei.com
---
 arch/arm64/kvm/hyp/pgtable.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 0271b4a3b9fe..2beba1dc40ec 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -470,6 +470,15 @@ static bool stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 	if (!kvm_block_mapping_supported(addr, end, phys, level))
 		return false;
 
+	/*
+	 * If the PTE was already valid, drop the refcount on the table
+	 * early, as it will be bumped-up again in stage2_map_walk_leaf().
+	 * This ensures that the refcount stays constant across a valid to
+	 * valid PTE update.
+	 */
+	if (kvm_pte_valid(*ptep))
+		put_page(virt_to_page(ptep));
+
 	if (kvm_set_valid_leaf_pte(ptep, phys, data->attr, level))
 		goto out;
 
-- 
2.28.0

