Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E909A63C82C
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 20:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236879AbiK2TVV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 14:21:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236812AbiK2TUv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 14:20:51 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3DAC6D48F;
        Tue, 29 Nov 2022 11:19:58 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1669749597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LAtIXRb0PxV3UcO4TbJwOQlCaH/bLzgHLa5c6EYoqNs=;
        b=trhLlHeGTz/PmAoiA09w30q8K6SNnj0CmzpDhmRBg7tUGjLWpYvph7djOsZrwFb0DDpZjd
        GrOFF+Vpj2I+jmVU2b6vUUyiz1X6AdNx+RwQRy7Iq+wVnC/7WYjaBLfaifsaWR/fs8UaFo
        jU/Xs8zsAjfPx3e1g4ONEZ1v11gRIP4=
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
Subject: [PATCH 1/4] KVM: arm64: Use KVM's pte type/helpers in handle_access_fault()
Date:   Tue, 29 Nov 2022 19:19:43 +0000
Message-Id: <20221129191946.1735662-2-oliver.upton@linux.dev>
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
2.38.1.584.g0f3c55d4c2-goog

