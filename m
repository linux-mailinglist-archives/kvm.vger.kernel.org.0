Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D90D5A6DD9
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 21:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbiH3TwU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 15:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbiH3TwM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 15:52:12 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664CC7F121;
        Tue, 30 Aug 2022 12:52:08 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661889126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ODGgNehZ2DBuO47qbixsRPCIopuXBTJM37fQBZmKNGY=;
        b=p3adtOImKuuHlKbTTqLcKwCBydEl0j/c+w/vbd+ofPgw9Mhwk6riSV9oOPI2/zM7kmCPKQ
        7kv+idgOio54jiwFe4raiZ5ZbxER28J66uBOxZyU27rNQffLERWmfEyMxVD5FK4YCEDQn4
        nAPzOJ8qXbftpvkL9G+bg9Jsd0/3z8o=
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
Subject: [PATCH 13/14] KVM: arm64: Make table->block changes parallel-aware
Date:   Tue, 30 Aug 2022 19:51:51 +0000
Message-Id: <20220830195151.964912-1-oliver.upton@linux.dev>
In-Reply-To: <20220830194132.962932-1-oliver.upton@linux.dev>
References: <20220830194132.962932-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

stage2_map_walk_leaf() and friends now handle stage-2 PTEs generically,
and perform the correct flush when a table PTE is removed. Additionally,
they've been made parallel-aware, using an atomic break to take
ownership of the PTE.

Stop clearing the PTE in the pre-order callback and instead let
stage2_map_walk_leaf() deal with it.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/pgtable.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index de1d352657d0..92e230e7bf3a 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -871,21 +871,12 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
 	if (!stage2_leaf_mapping_allowed(addr, end, level, data))
 		return 0;
 
-	kvm_clear_pte(ptep);
-
-	/*
-	 * Invalidate the whole stage-2, as we may have numerous leaf
-	 * entries below us which would otherwise need invalidating
-	 * individually.
-	 */
-	kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
-
 	ret = stage2_map_walk_leaf(addr, end, level, ptep, old, data);
+	if (ret)
+		return ret;
 
-	mm_ops->put_page(ptep);
 	mm_ops->free_removed_table(childp, level + 1, pgt);
-
-	return ret;
+	return 0;
 }
 
 static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
-- 
2.37.2.672.g94769d06f0-goog

