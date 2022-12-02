Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4927F640DE9
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 19:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234739AbiLBSwm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 13:52:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234347AbiLBSwg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 13:52:36 -0500
Received: from out-242.mta0.migadu.com (out-242.mta0.migadu.com [IPv6:2001:41d0:1004:224b::f2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B490ECA2A
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 10:52:28 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1670007146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=36q34GkAdZNcp02VfFJ/fMceb+GlTAxgwL6t8UJ/nCU=;
        b=LAPfFRXkfCOfssjRADm7/jdYZ7LQl2uW9dy14PfWeo2914srk2DSSW7OAI1GrB7JEscgbY
        DxllYbdQAX26FIFaFFLzCntc4Uhua5fSy2WeUOjvTWcv81z6joZgp064csO8ICW67kHF+9
        cSAdicod8mmQR59+MNnYmUOZe79b8Wc=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Ricardo Koller <ricarkol@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/6] KVM: arm64: Handle access faults behind the read lock
Date:   Fri,  2 Dec 2022 18:51:55 +0000
Message-Id: <20221202185156.696189-6-oliver.upton@linux.dev>
In-Reply-To: <20221202185156.696189-1-oliver.upton@linux.dev>
References: <20221202185156.696189-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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
 arch/arm64/kvm/hyp/pgtable.c | 3 ++-
 arch/arm64/kvm/mmu.c         | 4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index aa36d896bd8c..30575b5f5dcd 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1120,7 +1120,8 @@ kvm_pte_t kvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr)
 
 	ret = stage2_update_leaf_attrs(pgt, addr, 1, KVM_PTE_LEAF_ATTR_LO_S2_AF, 0,
 				       &pte, NULL,
-				       KVM_PGTABLE_WALK_HANDLE_FAULT);
+				       KVM_PGTABLE_WALK_HANDLE_FAULT |
+				       KVM_PGTABLE_WALK_SHARED);
 	if (!ret)
 		dsb(ishst);
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index dd8c715f0775..25e18e1d9a15 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1406,10 +1406,10 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 
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
2.39.0.rc0.267.gcb52ba06e7-goog

