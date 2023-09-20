Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDDC7A752B
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 10:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232960AbjITIB7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 04:01:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232708AbjITIB6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 04:01:58 -0400
Received: from out-227.mta1.migadu.com (out-227.mta1.migadu.com [95.215.58.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14AFE97
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 01:01:53 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695196911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uvviR8Tdi7KfiLkhBYZ0V8IZJiQLCIG8mWutZwpfO4Y=;
        b=Q1pRgANn7cLFCdOOTwJefgK8ef5xMI97aclHzaRwSuCodeYZsifg5u26btwIoIXqgTSVun
        Tw5dCgzGObGsSXFOGHa8XwTJ6jjKLuelPFfppgW7g6gr8g2E+AslCe0NHEtcrlsoyqagbw
        4cFdYCu7vDkYD7n60OEMvc9d7EF3pPc=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Gavin Shan <gshan@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 2/2] KVM: arm64: Avoid soft lockups due to I-cache maintenance
Date:   Wed, 20 Sep 2023 08:01:33 +0000
Message-ID: <20230920080133.944717-3-oliver.upton@linux.dev>
In-Reply-To: <20230920080133.944717-1-oliver.upton@linux.dev>
References: <20230920080133.944717-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Gavin reports of soft lockups on his Ampere Altra Max machine when
backing KVM guests with hugetlb pages. Upon further investigation, it
was found that the system is unable to keep up with parallel I-cache
invalidations done by KVM's stage-2 fault handler.

This is ultimately an implementation problem. I-cache maintenance
instructions are available at EL0, so nothing stops a malicious
userspace from hammering a system with CMOs and cause it to fall over.
"Fixing" this problem in KVM is nothing more than slapping a bandage
over a much deeper problem.

Anyway, the kernel already has a heuristic for limiting TLB
invalidations to avoid soft lockups. Reuse that logic to limit I-cache
CMOs done by KVM to map executable pages on systems without FEAT_DIC.
While at it, restructure __invalidate_icache_guest_page() to improve
readability and squeeze our new condition into the existing branching
structure.

Link: https://lore.kernel.org/kvmarm/20230904072826.1468907-1-gshan@redhat.com/
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_mmu.h | 37 ++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 96a80e8f6226..a425ecdd7be0 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -224,16 +224,41 @@ static inline void __clean_dcache_guest_page(void *va, size_t size)
 	kvm_flush_dcache_to_poc(va, size);
 }
 
+static inline size_t __invalidate_icache_max_range(void)
+{
+	u8 iminline;
+	u64 ctr;
+
+	asm volatile(ALTERNATIVE_CB("movz %0, #0\n"
+				    "movk %0, #0, lsl #16\n"
+				    "movk %0, #0, lsl #32\n"
+				    "movk %0, #0, lsl #48\n",
+				    ARM64_ALWAYS_SYSTEM,
+				    kvm_compute_final_ctr_el0)
+		     : "=r" (ctr));
+
+	iminline = SYS_FIELD_GET(CTR_EL0, IminLine, ctr) + 2;
+	return MAX_DVM_OPS << iminline;
+}
+
 static inline void __invalidate_icache_guest_page(void *va, size_t size)
 {
-	if (icache_is_aliasing()) {
-		/* any kind of VIPT cache */
+	/*
+	 * VPIPT I-cache maintenance must be done from EL2. See comment in the
+	 * nVHE flavor of __kvm_tlb_flush_vmid_ipa().
+	 */
+	if (icache_is_vpipt() && read_sysreg(CurrentEL) != CurrentEL_EL2)
+		return;
+
+	/*
+	 * Blow the whole I-cache if it is aliasing (i.e. VIPT) or the
+	 * invalidation range exceeds our arbitrary limit on invadations by
+	 * cache line.
+	 */
+	if (icache_is_aliasing() || size > __invalidate_icache_max_range())
 		icache_inval_all_pou();
-	} else if (read_sysreg(CurrentEL) != CurrentEL_EL1 ||
-		   !icache_is_vpipt()) {
-		/* PIPT or VPIPT at EL2 (see comment in __kvm_tlb_flush_vmid_ipa) */
+	else
 		icache_inval_pou((unsigned long)va, (unsigned long)va + size);
-	}
 }
 
 void kvm_set_way_flush(struct kvm_vcpu *vcpu);
-- 
2.42.0.459.ge4e396fd5e-goog

