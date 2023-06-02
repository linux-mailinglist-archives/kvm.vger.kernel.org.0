Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 030C9720725
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 18:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236698AbjFBQLJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 12:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236792AbjFBQK5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 12:10:57 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4021810DF
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 09:10:10 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba8a5cbb012so2938144276.3
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 09:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685722190; x=1688314190;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Hryh0ZWAFdBP/1ensclnMWOs6DFcoKq9t8dEIwwzMjM=;
        b=yFcSJ5sk1YiYcQktVHUrIraA4vq3gzBg01wawQ+99X99BcERdv6aw79BJglFIsX38X
         Jmk2e5UaolCr5t1qAVgv5xhRcuwqz8qsPeKTN4dMinvHjEGhpXtPGawN2ICvlDQZGj8D
         ZmOScsl1sdyn4gxehMyRauugNpIrQjpu1KxL67VdJydhpwrAe8TXpUojYixIDTXpkYLZ
         L/KcS63c1WkLy8I19gAWFgXf90HgC8c3L1xN5Hze37jt9RE4scxALJ3lb9KGpgKF7m+y
         IPNOsGvdWwTPZEtqpxeUuo6lpLAcPxZcX9jQeWMRNApjKkg5jyviIXgCTWMDwLFLuVTH
         Fsfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685722190; x=1688314190;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hryh0ZWAFdBP/1ensclnMWOs6DFcoKq9t8dEIwwzMjM=;
        b=WeRECJxWlu8jck00vbCGy/sXvTXbOLbZdQKSray0Ndi1OBbefw8dLwB4iBSc59tSQV
         1vywCzVsd54dsdXJ5IkQ7ldHbhOIm9oMCttgVI5YwJ94vLnEJHoxLBQHRiij/1ujPX79
         SqFZn86W2LGNT1p6MTRjQ3fl8gcRia1/MhmYScYt+QgnJ7UrEUeWBNHmOdGuDnjeprH0
         5k4mI87QJ+wbXbJIOp7oDv8RiBwHrZS+7R3vcvls8966KS8jmVD6MmT50VxjwM/YBp/H
         oSFaqnjb7vmVAV6M+yULqmOwpQUOtL4DVPhfLGc10FLXnMkPYDHiaBm2fmfxzkXXbruk
         k3/Q==
X-Gm-Message-State: AC+VfDyzKTzakswwJZ74p08Mh9eOF8eMV0ouINjJFKAt6X/POTzRMB7P
        esOOeNRc7Ci+J7BHnDzdb9EKuRHZo4fO
X-Google-Smtp-Source: ACHHUZ5M9AG9HKhKFMo8prXUgGc/ucGnPOZDLd1OSRiqHslc40DT/QGSesfErKBawc3k99MHt4wj3TuQ4IOn
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a25:bc7:0:b0:ba8:cbd2:61b3 with SMTP id
 190-20020a250bc7000000b00ba8cbd261b3mr1223005ybl.5.1685722190144; Fri, 02 Jun
 2023 09:09:50 -0700 (PDT)
Date:   Fri,  2 Jun 2023 09:09:13 -0700
In-Reply-To: <20230602160914.4011728-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20230602160914.4011728-1-vipinsh@google.com>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230602160914.4011728-16-vipinsh@google.com>
Subject: [PATCH v2 15/16] KVM: arm64: Provide option to pass page walker flag
 for huge page splits
From:   Vipin Sharma <vipinsh@google.com>
To:     maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com,
        suzuki.poulose@arm.com, yuzenghui@huawei.com,
        catalin.marinas@arm.com, will@kernel.org, chenhuacai@kernel.org,
        aleksandar.qemu.devel@gmail.com, tsbogend@alpha.franken.de,
        anup@brainfault.org, atishp@atishpatra.org,
        paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, seanjc@google.com, pbonzini@redhat.com,
        dmatlack@google.com, ricarkol@google.com
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass enum kvm_pgtable_walk_flags{} to kvm_mmu_split_huge_pages().
Use 0 as the flag value to make it no-op.

In future commit kvm_mmu_split_huge_pages() will be used under both MMU
read lock and MMU write lock. Flag allows to pass intent to use shared
or non-shared page walkers to split the huge pages.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/arm64/kvm/mmu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 34d2bd03cf5f..6dd964e3682c 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -118,7 +118,8 @@ static bool need_split_memcache_topup_or_resched(struct kvm *kvm)
 }
 
 static int kvm_mmu_split_huge_pages(struct kvm *kvm, phys_addr_t addr,
-				    phys_addr_t end)
+				    phys_addr_t end,
+				    enum kvm_pgtable_walk_flags flags)
 {
 	struct kvm_mmu_memory_cache *cache;
 	struct kvm_pgtable *pgt;
@@ -153,7 +154,8 @@ static int kvm_mmu_split_huge_pages(struct kvm *kvm, phys_addr_t addr,
 			return -EINVAL;
 
 		next = __stage2_range_addr_end(addr, end, chunk_size);
-		ret = kvm_pgtable_stage2_split(pgt, addr, next - addr, cache, 0);
+		ret = kvm_pgtable_stage2_split(pgt, addr, next - addr, cache,
+					       flags);
 		if (ret)
 			break;
 	} while (addr = next, addr != end);
@@ -1112,7 +1114,7 @@ static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
 	end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
 
 	write_lock(&kvm->mmu_lock);
-	kvm_mmu_split_huge_pages(kvm, start, end);
+	kvm_mmu_split_huge_pages(kvm, start, end, 0);
 	write_unlock(&kvm->mmu_lock);
 }
 
@@ -1149,7 +1151,7 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
 	 * again.
 	 */
 	if (kvm_dirty_log_manual_protect_and_init_set(kvm))
-		kvm_mmu_split_huge_pages(kvm, start, end);
+		kvm_mmu_split_huge_pages(kvm, start, end, 0);
 	write_unlock(&kvm->mmu_lock);
 }
 
-- 
2.41.0.rc0.172.g3f132b7071-goog

