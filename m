Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B837626819
	for <lists+kvm@lfdr.de>; Sat, 12 Nov 2022 09:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234865AbiKLIRs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Nov 2022 03:17:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234834AbiKLIRf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Nov 2022 03:17:35 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAAA35BD6C
        for <kvm@vger.kernel.org>; Sat, 12 Nov 2022 00:17:33 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id x11-20020a056a000bcb00b0056c6ec11eefso3834812pfu.14
        for <kvm@vger.kernel.org>; Sat, 12 Nov 2022 00:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/nyvYrLnUX10u/zF5USAFv55ycigc2WUWemyEOx8j2Q=;
        b=a9DgRqDEG78Q13PysBXgEQHBs3v+AOKF3ZTp/R3w1pYSl6K1z/1HUaMcMOWWsQc7GK
         7WV7hPRPYBvb4SZ++risseWFaFTi/LgWPuL1hJoO0URpmybMW/tMCIIiA0WAvD/+ktWe
         /frWILdNkZ1lRQzSGKAe6ls9M+5RpX4iXAg+QYAFI4a/O6eH1pBASsjbov4yefay9gKb
         V//B3z75dq2OucbGBe+U71M2J7jiSNFLfHUAHMFXeH840ZgJhiILhtTpmTeh9vpTA8s+
         4VFTxNdkqJ9f1Y6nsAwG35z6jKXz+Kh+8MEayqTVbvvrUYJ8kcpl8t5EndQ70b0XyGqA
         qxPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/nyvYrLnUX10u/zF5USAFv55ycigc2WUWemyEOx8j2Q=;
        b=KEWZkSVpImmXLMwrJg7Liv38EVM7Vyc9q0HujibrSopDMloAoK9Ft299nIhIFfcvxk
         4UySpdxmIT54g3DTT2Nrp656hFm1ler6116zrUUYhavaECKI7Yds5GaZ6IkhVN0d69uk
         w2AcKBOPdtosJSszQJ1IyPXxAWCUE54bvY2b8moK7c6wcIZroU2nK5FLHGtdPic496Qw
         tR8iSvuccBml18nRzO4Py2tuD0nkZ9ECOPrBFt2jozx6yPdY9zgRMfA4OGq88foG2vaT
         wovWgSBG3a2PUo3tph6PIkU8bl6ZzLfG/wrb+kquVOo0pxf+XQii3MPfcoMTh7oLkXgX
         Bd0w==
X-Gm-Message-State: ANoB5pkv02w7gjheT57HwUbHv8QVakDRPWNkKu/sIEx9EU+Lrp/ybmVT
        1vvyHFQCG4Gz6YNQ8v/1u1vVlIl4Mg3Tug==
X-Google-Smtp-Source: AA0mqf5W+cKOm4H2QUN9ELMxJnqbqLO4qKu4CKYJGn0F2XaHfpwZz+cFqTYqhYawS6t216IFJFGztOsAzPbN5w==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:4187:b0:56e:3a98:1089 with SMTP
 id ca7-20020a056a00418700b0056e3a981089mr6053383pfb.38.1668241053045; Sat, 12
 Nov 2022 00:17:33 -0800 (PST)
Date:   Sat, 12 Nov 2022 08:17:11 +0000
In-Reply-To: <20221112081714.2169495-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221112081714.2169495-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221112081714.2169495-10-ricarkol@google.com>
Subject: [RFC PATCH 09/12] KVM: arm64: Split huge pages when dirty logging is enabled
From:   Ricardo Koller <ricarkol@google.com>
To:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        dmatlack@google.com, qperret@google.com, catalin.marinas@arm.com,
        andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, ricarkol@gmail.com,
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
avoid doing it while faulting on write-protected pages, which negatively
impacts guest performance.

A memslot marked for dirty logging is split in 1GB pieces at a time.
This is in order to release the mmu_lock and give other kernel threads
the opportunity to run, and also in order to allocate enough pages to
split a 1GB range worth of huge pages (or a single 1GB huge page).  Note
that these page allocations can fail, so eager page splitting is
best-effort.  This is not a correctness issue though, as huge pages can
still be split on write-faults.

The benefits of eager page splitting are the same as in x86, added with
commit a3fe5dbda0a4 ("KVM: x86/mmu: Split huge pages mapped by the TDP MMU
when dirty logging is enabled"). For example, when running
dirty_log_perf_test with 64 virtual CPUs (Ampere Altra), 1GB per vCPU, 50%
reads, and 2MB HugeTLB memory, the time it takes vCPUs to access all of
their memory after dirty logging is enabled decreased by 44% from 2.58s to
1.42s.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  30 ++++++++
 arch/arm64/kvm/mmu.c              | 110 +++++++++++++++++++++++++++++-
 2 files changed, 138 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 63307e7dc9c5..d43f133518cf 100644
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
index 94865c5ce181..f2753d9deb19 100644
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
@@ -1795,7 +1889,19 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
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
2.38.1.431.g37b22c650d-goog

