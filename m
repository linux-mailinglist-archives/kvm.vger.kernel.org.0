Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E173F7A752A
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 10:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbjITIB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 04:01:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232708AbjITIB4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 04:01:56 -0400
Received: from out-210.mta1.migadu.com (out-210.mta1.migadu.com [95.215.58.210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED18CA
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 01:01:50 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695196909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xfbh8qQL9QW5BcJKxEDXewQuyfv4M5lak2q1jy6348Q=;
        b=kJfWlYzUpeP9zIU/DMOihsHo4wNb5lISvzWIPxEGTfLtXeW7QzzHIIFQUt9VdXyBJ1qfNl
        XiaSonGNvCmM14etc2Y/yw2NIdjgpfkvUQetSAj2KPbk3CxgvpQSN8SiJ0Wq53/yyOAWAy
        WmgKUWt8goAWcxpo1wvmmhksbPK/EN8=
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
Subject: [PATCH 1/2] arm64: tlbflush: Rename MAX_TLBI_OPS
Date:   Wed, 20 Sep 2023 08:01:32 +0000
Message-ID: <20230920080133.944717-2-oliver.upton@linux.dev>
In-Reply-To: <20230920080133.944717-1-oliver.upton@linux.dev>
References: <20230920080133.944717-1-oliver.upton@linux.dev>
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

Perhaps unsurprisingly, I-cache invalidations suffer from performance
issues similar to TLB invalidations on certain systems. TLB and I-cache
maintenance all result in DVM on the mesh, which is where the real
bottleneck lies.

Rename the heuristic to point the finger at DVM, such that it may be
reused for limiting I-cache invalidations.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/tlbflush.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index b149cf9f91bc..3431d37e5054 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -333,7 +333,7 @@ static inline void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
  * This is meant to avoid soft lock-ups on large TLB flushing ranges and not
  * necessarily a performance improvement.
  */
-#define MAX_TLBI_OPS	PTRS_PER_PTE
+#define MAX_DVM_OPS	PTRS_PER_PTE
 
 /*
  * __flush_tlb_range_op - Perform TLBI operation upon a range
@@ -413,12 +413,12 @@ static inline void __flush_tlb_range(struct vm_area_struct *vma,
 
 	/*
 	 * When not uses TLB range ops, we can handle up to
-	 * (MAX_TLBI_OPS - 1) pages;
+	 * (MAX_DVM_OPS - 1) pages;
 	 * When uses TLB range ops, we can handle up to
 	 * (MAX_TLBI_RANGE_PAGES - 1) pages.
 	 */
 	if ((!system_supports_tlb_range() &&
-	     (end - start) >= (MAX_TLBI_OPS * stride)) ||
+	     (end - start) >= (MAX_DVM_OPS * stride)) ||
 	    pages >= MAX_TLBI_RANGE_PAGES) {
 		flush_tlb_mm(vma->vm_mm);
 		return;
@@ -451,7 +451,7 @@ static inline void flush_tlb_kernel_range(unsigned long start, unsigned long end
 {
 	unsigned long addr;
 
-	if ((end - start) > (MAX_TLBI_OPS * PAGE_SIZE)) {
+	if ((end - start) > (MAX_DVM_OPS * PAGE_SIZE)) {
 		flush_tlb_all();
 		return;
 	}
-- 
2.42.0.459.ge4e396fd5e-goog

