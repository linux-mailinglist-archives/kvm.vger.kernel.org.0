Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 159D943C3BD
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 09:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238607AbhJ0HXh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 03:23:37 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:38710 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240460AbhJ0HXZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 03:23:25 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=cuibixuan@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0Utrsrjs_1635319253;
Received: from VM20210331-25.tbsite.net(mailfrom:cuibixuan@linux.alibaba.com fp:SMTPD_---0Utrsrjs_1635319253)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 27 Oct 2021 15:20:57 +0800
From:   Bixuan Cui <cuibixuan@linux.alibaba.com>
To:     kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.or, linux-kernel@vger.kernel.org
Cc:     anup.patel@wdc.com, atish.patra@wdc.com, paul.walmsley@sifive.com,
        palmer@dabbelt.com, aou@eecs.berkeley.edu,
        cuibixuan@linux.alibaba.com
Subject: [PATCH -next] RISC-V: KVM: fix boolreturn.cocci warnings
Date:   Wed, 27 Oct 2021 15:20:53 +0800
Message-Id: <1635319253-100581-1-git-send-email-cuibixuan@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix boolreturn.cocci warnings:
./arch/riscv/kvm/mmu.c:603:9-10: WARNING: return of 0/1 in function
'kvm_age_gfn' with return type bool
./arch/riscv/kvm/mmu.c:582:9-10: WARNING: return of 0/1 in function
'kvm_set_spte_gfn' with return type bool
./arch/riscv/kvm/mmu.c:621:9-10: WARNING: return of 0/1 in function
'kvm_test_age_gfn' with return type bool
./arch/riscv/kvm/mmu.c:568:9-10: WARNING: return of 0/1 in function
'kvm_unmap_gfn_range' with return type bool

Signed-off-by: Bixuan Cui <cuibixuan@linux.alibaba.com>
---
 arch/riscv/kvm/mmu.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 3a00c2d..d81bae8 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -565,12 +565,12 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	if (!kvm->arch.pgd)
-		return 0;
+		return false;
 
 	stage2_unmap_range(kvm, range->start << PAGE_SHIFT,
 			   (range->end - range->start) << PAGE_SHIFT,
 			   range->may_block);
-	return 0;
+	return false;
 }
 
 bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
@@ -579,7 +579,7 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	kvm_pfn_t pfn = pte_pfn(range->pte);
 
 	if (!kvm->arch.pgd)
-		return 0;
+		return false;
 
 	WARN_ON(range->end - range->start != 1);
 
@@ -587,10 +587,10 @@ bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 			      __pfn_to_phys(pfn), PAGE_SIZE, true, true);
 	if (ret) {
 		kvm_debug("Failed to map stage2 page (error %d)\n", ret);
-		return 1;
+		return true;
 	}
 
-	return 0;
+	return false;
 }
 
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
@@ -600,13 +600,13 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	u64 size = (range->end - range->start) << PAGE_SHIFT;
 
 	if (!kvm->arch.pgd)
-		return 0;
+		return false;
 
 	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PGDIR_SIZE);
 
 	if (!stage2_get_leaf_entry(kvm, range->start << PAGE_SHIFT,
 				   &ptep, &ptep_level))
-		return 0;
+		return false;
 
 	return ptep_test_and_clear_young(NULL, 0, ptep);
 }
@@ -618,13 +618,13 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	u64 size = (range->end - range->start) << PAGE_SHIFT;
 
 	if (!kvm->arch.pgd)
-		return 0;
+		return false;
 
 	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PGDIR_SIZE);
 
 	if (!stage2_get_leaf_entry(kvm, range->start << PAGE_SHIFT,
 				   &ptep, &ptep_level))
-		return 0;
+		return false;
 
 	return pte_young(*ptep);
 }
-- 
1.8.3.1

