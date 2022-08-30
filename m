Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC0CE5A6D9C
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 21:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbiH3Tmk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 15:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbiH3TmW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 15:42:22 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6685C7C30F;
        Tue, 30 Aug 2022 12:42:16 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661888534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yispcYoWHwz6WUZiyFc9UJ/2hA2X4vwfQ9rtB9AplkE=;
        b=QKKwh0mZHI3VDDYssNZqIJUh8qzZEqcGK2T3WlXJOjZzzlmkUOBcLFJw1Cstm2IhK1GFIz
        0JosO5MJyt2ok6BmAv66t0Zcb9QGbJ1ROXv1n/pZjIFhAB7qdZSTbe5HfblFcESL/uykDN
        qbUixnxPOgyPrKiBk/pc54SO8HjqpOI=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Gavin Shan <gshan@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/14] KVM: arm64: Return next table from map callbacks
Date:   Tue, 30 Aug 2022 19:41:24 +0000
Message-Id: <20220830194132.962932-7-oliver.upton@linux.dev>
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

The map walkers install new page tables during their traversal. Return
the newly-installed table PTE from the map callbacks to point the walker
at the new table w/o rereading the ptep.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/pgtable.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 331f6e3b2c20..f911509e6512 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -202,13 +202,12 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 	if (!table && (flags & KVM_PGTABLE_WALK_LEAF)) {
 		ret = kvm_pgtable_visitor_cb(data, addr, level, ptep, &pte,
 					     KVM_PGTABLE_WALK_LEAF);
-		pte = *ptep;
-		table = kvm_pte_table(pte, level);
 	}
 
 	if (ret)
 		goto out;
 
+	table = kvm_pte_table(pte, level);
 	if (!table) {
 		data->addr = ALIGN_DOWN(data->addr, kvm_granule_size(level));
 		data->addr += kvm_granule_size(level);
@@ -427,6 +426,7 @@ static int hyp_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep, kvm_pte
 	new = kvm_init_table_pte(childp, mm_ops);
 	mm_ops->get_page(ptep);
 	smp_store_release(ptep, new);
+	*old = new;
 
 	return 0;
 }
@@ -768,7 +768,7 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 }
 
 static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
-				struct stage2_map_data *data);
+				kvm_pte_t *old, struct stage2_map_data *data);
 
 static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
 				     kvm_pte_t *ptep, kvm_pte_t *old,
@@ -791,7 +791,7 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
 	 */
 	kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
 
-	ret = stage2_map_walk_leaf(addr, end, level, ptep, data);
+	ret = stage2_map_walk_leaf(addr, end, level, ptep, old, data);
 
 	mm_ops->put_page(ptep);
 	mm_ops->free_removed_table(childp, level + 1, pgt);
@@ -832,6 +832,7 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	new = kvm_init_table_pte(childp, mm_ops);
 	mm_ops->get_page(ptep);
 	smp_store_release(ptep, new);
+	*old = new;
 
 	return 0;
 }
-- 
2.37.2.672.g94769d06f0-goog

