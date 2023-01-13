Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D66E9668A6C
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 04:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235476AbjAMDuV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 22:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233786AbjAMDuO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 22:50:14 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956672F7BD
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:50:12 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id k204-20020a256fd5000000b007b8b040bc50so19852700ybc.1
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 19:50:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=j5IWILtFhYwjjiNl1bo1qzza8egckK4zHijflhnnttM=;
        b=K5uKbAzjF8REXeEArNdBe8EWe6X1KFfCfVs8/OsWG025d/P+jkby7bJ9U89qMJ8I3x
         P0gxRuDwX0Hy8k8Brpb6NgjqHPPDzjtJSYBWOhEI6umJBn/Qtjiya2wDm4xvqRT44eAF
         EZVSbN51Q+bMTnDjSQoMQ2okgY3N9fC0zmyFxNPnihOv9apEAecEh1Tps8IOWhgCNRcR
         FcmKcby2g5iRZ2n5Zqz6+FbWFSA5786/cxm38Qf276IXMUJ8OEfjP3YSZV8IB9HqXVVW
         otCNXEcSIf8ZZLRuk0rDUyZt4RLLYzk5fWeEtF66DocCcBj/fwpNUWJQQc8RuuaN3qK2
         STyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j5IWILtFhYwjjiNl1bo1qzza8egckK4zHijflhnnttM=;
        b=NHJ3dBmoP3pUjdcJHh9IM856hZ1v7HYK2iqv3vBNxZuehO8tHGgXkqAGtc/tuHkLhz
         xKc6T32rOV4jinLTfIjYBMURo0o1I/mBHLYWfuJdG2WdiOfjkHSVpw6b7cm+EFOSZh7M
         beDTUw5nWe82Uq0UO0IZH0V1/CgtKbkZDwoi+9ilTnr8yqBD0uN5tw4efXzzD7MJupJI
         d2pWdtbpOsJwG8A+TtaZAXuvSkwCyLvq3IrUJH1a8CiGMnQVOC+Hj4VzcCqLSEJEkxl6
         xkeOtmCmns/ZZ8telsVrQcgbbsVjTeMsR1MlpdETjQdoGlU9X/QkMZ0V8lPz47ngL9gh
         P63w==
X-Gm-Message-State: AFqh2kocegpUrkFpotFDNkNTyJcXv+KwdzIBNSSf4YUH/4N9vM4yUAge
        0v2VwN2q0BWFhT6Cu0tUB6npO/rLyFVBFA==
X-Google-Smtp-Source: AMrXdXtr4MUR0c7pEsnGR03P21EnyU6o4Ft3N/6wVnlFn7yIM+45Cae2QqPlkI3okSk3coJ7jY8g6+XoICWDGQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:6a06:0:b0:735:ea17:94d9 with SMTP id
 f6-20020a256a06000000b00735ea1794d9mr7614716ybc.378.1673581811889; Thu, 12
 Jan 2023 19:50:11 -0800 (PST)
Date:   Fri, 13 Jan 2023 03:49:57 +0000
In-Reply-To: <20230113035000.480021-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230113035000.480021-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230113035000.480021-7-ricarkol@google.com>
Subject: [PATCH 6/9] KVM: arm64: Split huge pages when dirty logging is enabled
From:   Ricardo Koller <ricarkol@google.com>
To:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
        Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Split huge pages eagerly when enabling dirty logging. The goal is to
avoid doing it while faulting on write-protected pages, which
negatively impacts guest performance.

A memslot marked for dirty logging is split in 1GB pieces at a time.
This is in order to release the mmu_lock and give other kernel threads
the opportunity to run, and also in order to allocate enough pages to
split a 1GB range worth of huge pages (or a single 1GB huge page).
Note that these page allocations can fail, so eager page splitting is
best-effort.  This is not a correctness issue though, as huge pages
can still be split on write-faults.

The benefits of eager page splitting are the same as in x86, added
with commit a3fe5dbda0a4 ("KVM: x86/mmu: Split huge pages mapped by
the TDP MMU when dirty logging is enabled"). For example, when running
dirty_log_perf_test with 64 virtual CPUs (Ampere Altra), 1GB per vCPU,
50% reads, and 2MB HugeTLB memory, the time it takes vCPUs to access
all of their memory after dirty logging is enabled decreased by 44%
from 2.58s to 1.42s.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  30 ++++++++
 arch/arm64/kvm/mmu.c              | 110 +++++++++++++++++++++++++++++-
 2 files changed, 138 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 35a159d131b5..6ab37209b1d1 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -153,6 +153,36 @@ struct kvm_s2_mmu {
 	/* The last vcpu id that ran on each physical CPU */
 	int __percpu *last_vcpu_ran;
 
+	/*
+	 * Memory cache used to split EAGER_PAGE_SPLIT_CHUNK_SIZE worth of huge
+	 * pages. It is used to allocate stage2 page tables while splitting
+	 * huge pages. Its capacity should be EAGER_PAGE_SPLIT_CACHE_CAPACITY.
+	 * Note that the choice of EAGER_PAGE_SPLIT_CHUNK_SIZE influences both
+	 * the capacity of the split page cache (CACHE_CAPACITY), and how often
+	 * KVM reschedules. Be wary of raising CHUNK_SIZE too high.
+	 *
+	 * A good heuristic to pick CHUNK_SIZE is that it should be larger than
+	 * all the available huge-page sizes, and be a multiple of all the
+	 * other ones; for example, 1GB when all the available huge-page sizes
+	 * are (1GB, 2MB, 32MB, 512MB).
+	 *
+	 * CACHE_CAPACITY should have enough pages to cover CHUNK_SIZE; for
+	 * example, 1GB requires the following number of PAGE_SIZE-pages:
+	 * - 512 when using 2MB hugepages with 4KB granules (1GB / 2MB).
+	 * - 513 when using 1GB hugepages with 4KB granules (1 + (1GB / 2MB)).
+	 * - 32 when using 32MB hugepages with 16KB granule (1GB / 32MB).
+	 * - 2 when using 512MB hugepages with 64KB granules (1GB / 512MB).
+	 * CACHE_CAPACITY below assumes the worst case: 1GB hugepages with 4KB
+	 * granules.
+	 *
+	 * Protected by kvm->slots_lock.
+	 */
+#define EAGER_PAGE_SPLIT_CHUNK_SIZE		       SZ_1G
+#define EAGER_PAGE_SPLIT_CACHE_CAPACITY					\
+	(DIV_ROUND_UP_ULL(EAGER_PAGE_SPLIT_CHUNK_SIZE, SZ_1G) +		\
+	 DIV_ROUND_UP_ULL(EAGER_PAGE_SPLIT_CHUNK_SIZE, SZ_2M))
+	struct kvm_mmu_memory_cache split_page_cache;
+
 	struct kvm_arch *arch;
 };
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 700c5774b50d..41ee330edae3 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -31,14 +31,24 @@ static phys_addr_t hyp_idmap_vector;
 
 static unsigned long io_map_base;
 
-static phys_addr_t stage2_range_addr_end(phys_addr_t addr, phys_addr_t end)
+bool __read_mostly eager_page_split = true;
+module_param(eager_page_split, bool, 0644);
+
+static phys_addr_t __stage2_range_addr_end(phys_addr_t addr, phys_addr_t end,
+					   phys_addr_t size)
 {
-	phys_addr_t size = kvm_granule_size(KVM_PGTABLE_MIN_BLOCK_LEVEL);
 	phys_addr_t boundary = ALIGN_DOWN(addr + size, size);
 
 	return (boundary - 1 < end - 1) ? boundary : end;
 }
 
+static phys_addr_t stage2_range_addr_end(phys_addr_t addr, phys_addr_t end)
+{
+	phys_addr_t size = kvm_granule_size(KVM_PGTABLE_MIN_BLOCK_LEVEL);
+
+	return __stage2_range_addr_end(addr, end, size);
+}
+
 /*
  * Release kvm_mmu_lock periodically if the memory region is large. Otherwise,
  * we may see kernel panics with CONFIG_DETECT_HUNG_TASK,
@@ -71,6 +81,64 @@ static int stage2_apply_range(struct kvm *kvm, phys_addr_t addr,
 	return ret;
 }
 
+static inline bool need_topup(struct kvm_mmu_memory_cache *cache, int min)
+{
+	return kvm_mmu_memory_cache_nr_free_objects(cache) < min;
+}
+
+static bool need_topup_split_page_cache_or_resched(struct kvm *kvm)
+{
+	struct kvm_mmu_memory_cache *cache;
+
+	if (need_resched() || rwlock_needbreak(&kvm->mmu_lock))
+		return true;
+
+	cache = &kvm->arch.mmu.split_page_cache;
+	return need_topup(cache, EAGER_PAGE_SPLIT_CACHE_CAPACITY);
+}
+
+static int kvm_mmu_split_huge_pages(struct kvm *kvm, phys_addr_t addr,
+			      phys_addr_t end)
+{
+	struct kvm_mmu_memory_cache *cache;
+	struct kvm_pgtable *pgt;
+	int ret;
+	u64 next;
+	int cache_capacity = EAGER_PAGE_SPLIT_CACHE_CAPACITY;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	lockdep_assert_held(&kvm->slots_lock);
+
+	cache = &kvm->arch.mmu.split_page_cache;
+
+	do {
+		if (need_topup_split_page_cache_or_resched(kvm)) {
+			write_unlock(&kvm->mmu_lock);
+			cond_resched();
+			/* Eager page splitting is best-effort. */
+			ret = __kvm_mmu_topup_memory_cache(cache,
+							   cache_capacity,
+							   cache_capacity);
+			write_lock(&kvm->mmu_lock);
+			if (ret)
+				break;
+		}
+
+		pgt = kvm->arch.mmu.pgt;
+		if (!pgt)
+			return -EINVAL;
+
+		next = __stage2_range_addr_end(addr, end,
+					       EAGER_PAGE_SPLIT_CHUNK_SIZE);
+		ret = kvm_pgtable_stage2_split(pgt, addr, next - addr, cache);
+		if (ret)
+			break;
+	} while (addr = next, addr != end);
+
+	return ret;
+}
+
 #define stage2_apply_range_resched(kvm, addr, end, fn)			\
 	stage2_apply_range(kvm, addr, end, fn, true)
 
@@ -755,6 +823,8 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	for_each_possible_cpu(cpu)
 		*per_cpu_ptr(mmu->last_vcpu_ran, cpu) = -1;
 
+	mmu->split_page_cache.gfp_zero = __GFP_ZERO;
+
 	mmu->pgt = pgt;
 	mmu->pgd_phys = __pa(pgt->pgd);
 	return 0;
@@ -769,6 +839,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 void kvm_uninit_stage2_mmu(struct kvm *kvm)
 {
 	kvm_free_stage2_pgd(&kvm->arch.mmu);
+	kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
 }
 
 static void stage2_unmap_memslot(struct kvm *kvm,
@@ -996,6 +1067,29 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
 	stage2_wp_range(&kvm->arch.mmu, start, end);
 }
 
+/**
+ * kvm_mmu_split_memory_region() - split the stage 2 blocks into PAGE_SIZE
+ *				   pages for memory slot
+ * @kvm:	The KVM pointer
+ * @slot:	The memory slot to split
+ *
+ * Acquires kvm->mmu_lock. Called with kvm->slots_lock mutex acquired,
+ * serializing operations for VM memory regions.
+ */
+static void kvm_mmu_split_memory_region(struct kvm *kvm, int slot)
+{
+	struct kvm_memslots *slots = kvm_memslots(kvm);
+	struct kvm_memory_slot *memslot = id_to_memslot(slots, slot);
+	phys_addr_t start, end;
+
+	start = memslot->base_gfn << PAGE_SHIFT;
+	end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
+
+	write_lock(&kvm->mmu_lock);
+	kvm_mmu_split_huge_pages(kvm, start, end);
+	write_unlock(&kvm->mmu_lock);
+}
+
 /*
  * kvm_arch_mmu_enable_log_dirty_pt_masked - enable dirty logging for selected
  * dirty pages.
@@ -1783,7 +1877,19 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
 			return;
 
+		if (READ_ONCE(eager_page_split))
+			kvm_mmu_split_memory_region(kvm, new->id);
+
 		kvm_mmu_wp_memory_region(kvm, new->id);
+	} else {
+		/*
+		 * Free any leftovers from the eager page splitting cache. Do
+		 * this when deleting, moving, disabling dirty logging, or
+		 * creating the memslot (a nop). Doing it for deletes makes
+		 * sure we don't leak memory, and there's no need to keep the
+		 * cache around for any of the other cases.
+		 */
+		kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
 	}
 }
 
-- 
2.39.0.314.g84b9a713c41-goog

