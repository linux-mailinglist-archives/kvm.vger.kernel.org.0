Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7DD5A6DD7
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 21:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbiH3Tvt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 15:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbiH3Tvp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 15:51:45 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C757E316;
        Tue, 30 Aug 2022 12:51:44 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661889102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BmHJR6N3rI3NqVKRQnsaZiBFli5RmIY4C8X+Uix5thU=;
        b=eBaq5OcegB50cLDgGEiduR4Tgk5pLMtHfEruHLpo036HKXFf0YTXH2bWlsFFUmU/6mHlgb
        4V4yxrZtBF7lSii3YCwzkHciBjKh7H1kMwVqh8gok5JQ6GRUH7NmjinsnU6ud9D2trTwEX
        A/qAC0OBx34lJZlbrfIE1UPaqv+pv/k=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Quentin Perret <qperret@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Gavin Shan <gshan@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/14] KVM: arm64: Make leaf->leaf PTE changes parallel-aware
Date:   Tue, 30 Aug 2022 19:51:32 +0000
Message-Id: <20220830195132.964800-1-oliver.upton@linux.dev>
In-Reply-To: <20220830194132.962932-1-oliver.upton@linux.dev>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert stage2_map_walker_try_leaf() to use the new break-before-make
helpers, thereby making the handler parallel-aware. As before, avoid the
break-before-make if recreating the existing mapping. Additionally,
retry execution if another vCPU thread is modifying the same PTE.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/pgtable.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 71ae96608752..de1d352657d0 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -829,18 +829,17 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 	else
 		new = kvm_init_invalid_leaf_owner(data->owner_id);
 
-	if (stage2_pte_is_counted(old)) {
-		/*
-		 * Skip updating the PTE if we are trying to recreate the exact
-		 * same mapping or only change the access permissions. Instead,
-		 * the vCPU will exit one more time from guest if still needed
-		 * and then go through the path of relaxing permissions.
-		 */
-		if (!stage2_pte_needs_update(old, new))
-			return -EAGAIN;
+	/*
+	 * Skip updating the PTE if we are trying to recreate the exact
+	 * same mapping or only change the access permissions. Instead,
+	 * the vCPU will exit one more time from guest if still needed
+	 * and then go through the path of relaxing permissions.
+	 */
+	if (!stage2_pte_needs_update(old, new))
+		return -EAGAIN;
 
-		stage2_put_pte(ptep, data->mmu, addr, level, mm_ops);
-	}
+	if (!stage2_try_break_pte(ptep, old, addr, level, data))
+		return -EAGAIN;
 
 	/* Perform CMOs before installation of the guest stage-2 PTE */
 	if (mm_ops->dcache_clean_inval_poc && stage2_pte_cacheable(pgt, new))
@@ -850,9 +849,8 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 	if (mm_ops->icache_inval_pou && stage2_pte_executable(new))
 		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
 
-	smp_store_release(ptep, new);
-	if (stage2_pte_is_counted(new))
-		mm_ops->get_page(ptep);
+	stage2_make_pte(ptep, old, new, data);
+
 	if (kvm_phys_is_valid(phys))
 		data->phys += granule;
 	return 0;
-- 
2.37.2.672.g94769d06f0-goog

