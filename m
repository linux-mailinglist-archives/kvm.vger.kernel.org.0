Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA57A5F8124
	for <lists+kvm@lfdr.de>; Sat,  8 Oct 2022 01:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiJGX3K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 19:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiJGX3J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 19:29:09 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17494DF13
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 16:29:07 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1665185346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KBhDwkl/uoeNpRm2GI1StVfX8yhjK9wyQJiuxvOqoG0=;
        b=fu3t8bnA94DgHIkWh+Z2lJK3C6LopwKf2RvlMPakYhI5ND6a1mbwluJnWvPNJL2enDys8W
        5HIMP3/FhPq2pKzE1ADUQgtCAoaaObRXN1VEOsCoyRyqxFHqN7vVbqwHRpnpzewc5Ax510
        r14sPDZIthb5P1Jtd89u2xGx4DoMZYs=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        David Matlack <dmatlack@google.com>,
        Quentin Perret <qperret@google.com>,
        Ben Gardon <bgardon@google.com>, Gavin Shan <gshan@redhat.com>,
        Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        kvmarm@lists.linux.dev, Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 04/15] KVM: arm64: Don't pass kvm_pgtable through kvm_pgtable_walk_data
Date:   Fri,  7 Oct 2022 23:28:07 +0000
Message-Id: <20221007232818.459650-5-oliver.upton@linux.dev>
In-Reply-To: <20221007232818.459650-1-oliver.upton@linux.dev>
References: <20221007232818.459650-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to tear down page tables from outside the context of
kvm_pgtable (such as an RCU callback), stop passing a pointer through
kvm_pgtable_walk_data.

No functional change intended.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/pgtable.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index db25e81a9890..93989b750a26 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -50,7 +50,6 @@
 #define KVM_MAX_OWNER_ID		1
 
 struct kvm_pgtable_walk_data {
-	struct kvm_pgtable		*pgt;
 	struct kvm_pgtable_walker	*walker;
 
 	u64				addr;
@@ -88,7 +87,7 @@ static u32 kvm_pgtable_idx(struct kvm_pgtable_walk_data *data, u32 level)
 	return (data->addr >> shift) & mask;
 }
 
-static u32 __kvm_pgd_page_idx(struct kvm_pgtable *pgt, u64 addr)
+static u32 kvm_pgd_page_idx(struct kvm_pgtable *pgt, u64 addr)
 {
 	u64 shift = kvm_granule_shift(pgt->start_level - 1); /* May underflow */
 	u64 mask = BIT(pgt->ia_bits) - 1;
@@ -96,11 +95,6 @@ static u32 __kvm_pgd_page_idx(struct kvm_pgtable *pgt, u64 addr)
 	return (addr & mask) >> shift;
 }
 
-static u32 kvm_pgd_page_idx(struct kvm_pgtable_walk_data *data)
-{
-	return __kvm_pgd_page_idx(data->pgt, data->addr);
-}
-
 static u32 kvm_pgd_pages(u32 ia_bits, u32 start_level)
 {
 	struct kvm_pgtable pgt = {
@@ -108,7 +102,7 @@ static u32 kvm_pgd_pages(u32 ia_bits, u32 start_level)
 		.start_level	= start_level,
 	};
 
-	return __kvm_pgd_page_idx(&pgt, -1ULL) + 1;
+	return kvm_pgd_page_idx(&pgt, -1ULL) + 1;
 }
 
 static bool kvm_pte_table(kvm_pte_t pte, u32 level)
@@ -255,11 +249,10 @@ static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
 	return ret;
 }
 
-static int _kvm_pgtable_walk(struct kvm_pgtable_walk_data *data)
+static int _kvm_pgtable_walk(struct kvm_pgtable *pgt, struct kvm_pgtable_walk_data *data)
 {
 	u32 idx;
 	int ret = 0;
-	struct kvm_pgtable *pgt = data->pgt;
 	u64 limit = BIT(pgt->ia_bits);
 
 	if (data->addr > limit || data->end > limit)
@@ -268,7 +261,7 @@ static int _kvm_pgtable_walk(struct kvm_pgtable_walk_data *data)
 	if (!pgt->pgd)
 		return -EINVAL;
 
-	for (idx = kvm_pgd_page_idx(data); data->addr < data->end; ++idx) {
+	for (idx = kvm_pgd_page_idx(pgt, data->addr); data->addr < data->end; ++idx) {
 		kvm_pte_t *ptep = &pgt->pgd[idx * PTRS_PER_PTE];
 
 		ret = __kvm_pgtable_walk(data, pgt->mm_ops, ptep, pgt->start_level);
@@ -283,13 +276,12 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		     struct kvm_pgtable_walker *walker)
 {
 	struct kvm_pgtable_walk_data walk_data = {
-		.pgt	= pgt,
 		.addr	= ALIGN_DOWN(addr, PAGE_SIZE),
 		.end	= PAGE_ALIGN(walk_data.addr + size),
 		.walker	= walker,
 	};
 
-	return _kvm_pgtable_walk(&walk_data);
+	return _kvm_pgtable_walk(pgt, &walk_data);
 }
 
 struct leaf_walk_data {
-- 
2.38.0.rc1.362.ged0d419d3c-goog

