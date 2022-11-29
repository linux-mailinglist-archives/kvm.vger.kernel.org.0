Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE5B963C830
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 20:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236895AbiK2TV0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 14:21:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236737AbiK2TUw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 14:20:52 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12AFF6B3BF;
        Tue, 29 Nov 2022 11:20:04 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1669749602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kcCcdEvvwNGIdQ75NLzM3W5ItGtWtDkpHRzsetWKNGE=;
        b=hxIfAAInTnpV80RJl1MOplU9B+F7wko1aZ0kXwoNfPeIZ7mLgQMPu/2k0UoJcp40WP/Rbd
        2bDrV8+x6MOHHN9BWWHQ5tkBOIM2kbW4M6a6SKLfqI8MCQ80kj47HEfkIrGFCirYKQP9u7
        OmDozB0QEQ52eFKqV6Kq+CasS6AhCOg=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] KVM: arm64: Handle access faults behind the read lock
Date:   Tue, 29 Nov 2022 19:19:45 +0000
Message-Id: <20221129191946.1735662-4-oliver.upton@linux.dev>
In-Reply-To: <20221129191946.1735662-1-oliver.upton@linux.dev>
References: <20221129191946.1735662-1-oliver.upton@linux.dev>
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

As the underlying software walkers are able to traverse and update
stage-2 in parallel there is no need to serialize access faults.

Only take the read lock when handling an access fault.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/pgtable.c | 2 +-
 arch/arm64/kvm/mmu.c         | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 9626f615d9b8..1a3dd9774707 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1097,7 +1097,7 @@ kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr)
 	int ret;
 
 	ret = stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
-				       &pte, NULL, 0);
+				       &pte, NULL, KVM_PGTABLE_WALK_SHARED);
 	if (!ret)
 		dsb(ishst);
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 886ad5ee767a..347985a56414 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1404,10 +1404,10 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 
 	trace_kvm_access_fault(fault_ipa);
 
-	write_lock(&vcpu->kvm->mmu_lock);
+	read_lock(&vcpu->kvm->mmu_lock);
 	mmu = vcpu->arch.hw_mmu;
 	pte = kvm_pgtable_stage2_mkyoung(mmu->pgt, fault_ipa);
-	write_unlock(&vcpu->kvm->mmu_lock);
+	read_unlock(&vcpu->kvm->mmu_lock);
 
 	if (kvm_pte_valid(pte))
 		kvm_set_pfn_accessed(kvm_pte_to_pfn(pte));
-- 
2.38.1.584.g0f3c55d4c2-goog

