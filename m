Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE7A96EF947
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 19:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236232AbjDZRYD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 13:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235771AbjDZRX5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 13:23:57 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FAC64C1F
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 10:23:50 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-b8f46dc51bdso14360768276.3
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 10:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682529829; x=1685121829;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sE3hhdSl5tr6WG2te1Crxj8j6FfP3pDHNH+CnGtudCY=;
        b=f4FKbnTz1Jcn1D2ju6kiCEOK49MTh9vQaq8lwpWsZv1TlwMnWmRaD/ECmkt/o/9/h7
         1vJ3XsidivxyLIfjE6IyVx9V/VQuTKZkgcG8G98TdVd7SibJy5MAgi0aGOETRFaIT3Bo
         LzGmex2pM2cQo0sUBEfn/W53XmCe2dHCJ9CFNHFVoglVbfTnau5db7aVROGo/4aVrfS+
         j7JzxyXO/5zuLipn6SiRbgAmD2QX64y9aWE3oKqbxhthfG9tQZrJVKUvJ3mXPTNwGvHv
         piFNVXz//abn2pq4CugG7QDyY2Q6MpWHjFjHvXP+3JD0QJe5SuHAqbo3tkFvsOzkM8yp
         Hmxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682529829; x=1685121829;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sE3hhdSl5tr6WG2te1Crxj8j6FfP3pDHNH+CnGtudCY=;
        b=gEBOuxj1JiPowSyA35HWtzaSkUN454Fl43+w7/wvN/VRuoUhS+UpdmJOkYz9xZzH0k
         vVxnkodPsDG92S9HTEV3qo77zb6iatFJQO6vjxD8iYAGw12xegIes5dydFvSCHiPxvti
         5htVY1QLdiA9ouhipPc1qhwL4rC+Z5bqR28dbj00Sdw+5vpFgU93+hDLRoXfvRxPkc1S
         ybszDsn6VjOxHcupw9x6CTGQDN22r+eF4aT29onME2BIl8i7REVBZR5IfFTLouqlRx/D
         gTasJmuK/GVVNIRBJ8dRhBwjq+fNVDJ3jBaSMGXrjVnfIIt+pjMEdWfTJ6iTi+GhF5ar
         wHlA==
X-Gm-Message-State: AAQBX9f2xegocd47eB/yubM2BylZERCBY5lGuu+QAGGQarebZUULu/tX
        3+kej/B5rwSxjXB0l0i/aMQ81wwGdAM+EQ==
X-Google-Smtp-Source: AKy350aZ4VFCXnr8iZE7WOQ+YBnsbKMtQWJ76QKvZkbFSDYts+CL1JGQyKVz+sgYD6CMwROxkGwG0iIXa63AFQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:7683:0:b0:b95:31a3:9d8a with SMTP id
 r125-20020a257683000000b00b9531a39d8amr12387090ybc.4.1682529829573; Wed, 26
 Apr 2023 10:23:49 -0700 (PDT)
Date:   Wed, 26 Apr 2023 17:23:27 +0000
In-Reply-To: <20230426172330.1439644-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230426172330.1439644-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
Message-ID: <20230426172330.1439644-10-ricarkol@google.com>
Subject: [PATCH v8 09/12] KVM: arm64: Split huge pages when dirty logging is enabled
From:   Ricardo Koller <ricarkol@google.com>
To:     pbonzini@redhat.com, maz@kernel.org, oupton@google.com,
        yuzenghui@huawei.com, dmatlack@google.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
        catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        eric.auger@redhat.com, gshan@redhat.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, ricarkol@gmail.com,
        Ricardo Koller <ricarkol@google.com>,
        Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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

Eager page splitting only takes effect when the huge page mapping has
been existing in the stage-2 page table. Otherwise, the huge page will
be mapped to multiple non-huge pages on page fault.

The benefits of eager page splitting are the same as in x86, added
with commit a3fe5dbda0a4 ("KVM: x86/mmu: Split huge pages mapped by
the TDP MMU when dirty logging is enabled"). For example, when running
dirty_log_perf_test with 64 virtual CPUs (Ampere Altra), 1GB per vCPU,
50% reads, and 2MB HugeTLB memory, the time it takes vCPUs to access
all of their memory after dirty logging is enabled decreased by 44%
from 2.58s to 1.42s.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/mmu.c | 127 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 123 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 46f005a894e57..4256c4a307531 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -31,14 +31,21 @@ static phys_addr_t __ro_after_init hyp_idmap_vector;
 
 static unsigned long __ro_after_init io_map_base;
 
-static phys_addr_t stage2_range_addr_end(phys_addr_t addr, phys_addr_t end)
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
@@ -75,6 +82,79 @@ static int stage2_apply_range(struct kvm_s2_mmu *mmu, phys_addr_t addr,
 #define stage2_apply_range_resched(mmu, addr, end, fn)			\
 	stage2_apply_range(mmu, addr, end, fn, true)
 
+/*
+ * Get the maximum number of page-tables pages needed to split a range
+ * of blocks into PAGE_SIZE PTEs. It assumes the range is already
+ * mapped at level 2, or at level 1 if allowed.
+ */
+static int kvm_mmu_split_nr_page_tables(u64 range)
+{
+	int n = 0;
+
+	if (KVM_PGTABLE_MIN_BLOCK_LEVEL < 2)
+		n += DIV_ROUND_UP_ULL(range, PUD_SIZE);
+	n += DIV_ROUND_UP_ULL(range, PMD_SIZE);
+	return n;
+}
+
+static bool need_split_memcache_topup_or_resched(struct kvm *kvm)
+{
+	struct kvm_mmu_memory_cache *cache;
+	u64 chunk_size, min;
+
+	if (need_resched() || rwlock_needbreak(&kvm->mmu_lock))
+		return true;
+
+	chunk_size = kvm->arch.mmu.split_page_chunk_size;
+	min = kvm_mmu_split_nr_page_tables(chunk_size);
+	cache = &kvm->arch.mmu.split_page_cache;
+	return kvm_mmu_memory_cache_nr_free_objects(cache) < min;
+}
+
+static int kvm_mmu_split_huge_pages(struct kvm *kvm, phys_addr_t addr,
+				    phys_addr_t end)
+{
+	struct kvm_mmu_memory_cache *cache;
+	struct kvm_pgtable *pgt;
+	int ret, cache_capacity;
+	u64 next, chunk_size;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	chunk_size = kvm->arch.mmu.split_page_chunk_size;
+	cache_capacity = kvm_mmu_split_nr_page_tables(chunk_size);
+
+	if (chunk_size == 0)
+		return 0;
+
+	cache = &kvm->arch.mmu.split_page_cache;
+
+	do {
+		if (need_split_memcache_topup_or_resched(kvm)) {
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
+		next = __stage2_range_addr_end(addr, end, chunk_size);
+		ret = kvm_pgtable_stage2_split(pgt, addr, next - addr, cache);
+		if (ret)
+			break;
+	} while (addr = next, addr != end);
+
+	return ret;
+}
+
 static bool memslot_is_logging(struct kvm_memory_slot *memslot)
 {
 	return memslot->dirty_bitmap && !(memslot->flags & KVM_MEM_READONLY);
@@ -774,6 +854,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 void kvm_uninit_stage2_mmu(struct kvm *kvm)
 {
 	kvm_free_stage2_pgd(&kvm->arch.mmu);
+	kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
 }
 
 static void stage2_unmap_memslot(struct kvm *kvm,
@@ -1000,6 +1081,34 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
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
+	struct kvm_memslots *slots;
+	struct kvm_memory_slot *memslot;
+	phys_addr_t start, end;
+
+	lockdep_assert_held(&kvm->slots_lock);
+
+	slots = kvm_memslots(kvm);
+	memslot = id_to_memslot(slots, slot);
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
@@ -1783,8 +1892,8 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 			return;
 
 		/*
-		 * Pages are write-protected on either of these two
-		 * cases:
+		 * Huge and normal pages are write-protected and split
+		 * on either of these two cases:
 		 *
 		 * 1. with initial-all-set: gradually with CLEAR ioctls,
 		 */
@@ -1796,6 +1905,16 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 		 *    enabling dirty logging.
 		 */
 		kvm_mmu_wp_memory_region(kvm, new->id);
+		kvm_mmu_split_memory_region(kvm, new->id);
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
2.40.1.495.gc816e09b53d-goog

