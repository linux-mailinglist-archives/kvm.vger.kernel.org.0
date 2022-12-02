Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90F1F640DDB
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 19:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234571AbiLBSwV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 13:52:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234579AbiLBSwT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 13:52:19 -0500
Received: from out-88.mta0.migadu.com (out-88.mta0.migadu.com [IPv6:2001:41d0:1004:224b::58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F56E347E
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 10:52:16 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1670007134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HSI8GaEsrat3YCFbYitHgJjBxasqUXZCSku/OSEtqlI=;
        b=rn85i92GvmxIPofIBwzmf1lgVTJuWw0qPq1mAfrFEoJGvXJqdyrlRYn1kHDeuX+rlP4Vx/
        tmJ5gmeMa66ZXMnADmpVdaE5YinkQjY/RVPLx5K/leof84T2RL7O+6UkRik8oNep32Mcye
        z1yTKtG3yErw1oBHC6vUD1maCGLrZ00=
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
Subject: [PATCH v2 1/6] KVM: arm64: Use KVM's pte type/helpers in handle_access_fault()
Date:   Fri,  2 Dec 2022 18:51:51 +0000
Message-Id: <20221202185156.696189-2-oliver.upton@linux.dev>
In-Reply-To: <20221202185156.696189-1-oliver.upton@linux.dev>
References: <20221202185156.696189-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Consistently use KVM's own pte types and helpers in
handle_access_fault().

No functional change intended.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h |  5 +++++
 arch/arm64/kvm/mmu.c                 | 10 ++++------
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 63f81b27a4e3..192f33b88dc1 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -71,6 +71,11 @@ static inline kvm_pte_t kvm_phys_to_pte(u64 pa)
 	return pte;
 }
 
+static inline kvm_pfn_t kvm_pte_to_pfn(kvm_pte_t pte)
+{
+	return __phys_to_pfn(kvm_pte_to_phys(pte));
+}
+
 static inline u64 kvm_granule_shift(u32 level)
 {
 	/* Assumes KVM_PGTABLE_MAX_LEVELS is 4 */
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a3c71b5172cd..886ad5ee767a 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1399,20 +1399,18 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 /* Resolve the access fault by making the page young again. */
 static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 {
-	pte_t pte;
-	kvm_pte_t kpte;
+	kvm_pte_t pte;
 	struct kvm_s2_mmu *mmu;
 
 	trace_kvm_access_fault(fault_ipa);
 
 	write_lock(&vcpu->kvm->mmu_lock);
 	mmu = vcpu->arch.hw_mmu;
-	kpte = kvm_pgtable_stage2_mkyoung(mmu->pgt, fault_ipa);
+	pte = kvm_pgtable_stage2_mkyoung(mmu->pgt, fault_ipa);
 	write_unlock(&vcpu->kvm->mmu_lock);
 
-	pte = __pte(kpte);
-	if (pte_valid(pte))
-		kvm_set_pfn_accessed(pte_pfn(pte));
+	if (kvm_pte_valid(pte))
+		kvm_set_pfn_accessed(kvm_pte_to_pfn(pte));
 }
 
 /**
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

