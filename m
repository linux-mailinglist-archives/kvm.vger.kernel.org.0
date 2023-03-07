Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 872306AD5DC
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 04:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbjCGDqb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 22:46:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230158AbjCGDq0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 22:46:26 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D8E5849D
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 19:46:13 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id in10-20020a17090b438a00b002376d8554eeso4462858pjb.1
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 19:46:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678160773;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0kbdUxROCJTBS8z9lmIYx9gACkJGPeujB5l0piGpv+k=;
        b=TbCw9eJ0dM9E7T8mQceJoTr90wmJa9vgnDpZxVYs4ylE9snyO4kkWxk0fgY71llqak
         d9SxYdnweG/2Vk6QQ7BAgzpmJ/JJlo7/ok2JsNk1CMwtVS7dPSdx2J9mjMEDpU+PjkAG
         c1mnkbc6H4KId/ZTCsgwx5BQ5Gku2OLiDkh4JjVBc44//yFs9nmn/PBU0BGuA+mOk8jy
         2OOH88g7O5cqBxQNj+1VJTWD/NAribPH5NG1zZcTMdS59e6pieIwynN++/zqNlA6gJoj
         nbuV82Y+7lV1MKhYWN5li1Y1n4CF2V42WNTX76H40+AauUzH45qOtt2NofFlHDZ/X382
         5hdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678160773;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0kbdUxROCJTBS8z9lmIYx9gACkJGPeujB5l0piGpv+k=;
        b=r4iZ4RdrspQxYdAEgrN31BaQK1tibDlkodvOshDfMwB4VKhzcNXtTneud7Uunfttu5
         ETln1228h/7UU096aPAepnPhflBdth0T2CMkE7g0WuVWwkIpfAj9Oag9AEPlJoi22Eki
         ZQebMpW4leSQUisUdvVkiIrPhipPyFbXsmuCg/AZ2zPLsF6SslKyIXVnXNIhniYPp8uy
         aa9HTI6UXSHWUW18zU4Lx01x1jTvp3REiQVLYs4LEAEGNlC+CE2hvvWWrWhRangaV9Zy
         G6Wle6nq2lH3yKaZh+KAREwaQlauEH+gGLGCqj7Xn+GzfbSOcplguudZY7w/FkC6+SKp
         nS7A==
X-Gm-Message-State: AO0yUKXNlfKgJRymJEXkNBJjthnwFDc6ZpahsoC6FWnnpwCgG+X/9eID
        Gz58w/BcDYUKuY0WfxIBh25dz1WkLK4BQw==
X-Google-Smtp-Source: AK7set+pIqg7F05Y0jFwWRARKotBU8WUlIZMPZZX1myzX9R3zeOnMYhUb8jioQEEeJsOkhW8UGKmlBu1GaTZVA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a63:ab42:0:b0:4fd:72f3:5859 with SMTP id
 k2-20020a63ab42000000b004fd72f35859mr4598315pgp.2.1678160772927; Mon, 06 Mar
 2023 19:46:12 -0800 (PST)
Date:   Tue,  7 Mar 2023 03:45:52 +0000
In-Reply-To: <20230307034555.39733-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20230307034555.39733-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230307034555.39733-10-ricarkol@google.com>
Subject: [PATCH v6 09/12] KVM: arm64: Split huge pages when dirty logging is enabled
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
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/arm64/kvm/mmu.c | 118 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 116 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 898985b09321..b1b8da5f8b6c 100644
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
@@ -75,6 +82,77 @@ static int stage2_apply_range(struct kvm_s2_mmu *mmu, phys_addr_t addr,
 #define stage2_apply_range_resched(mmu, addr, end, fn)			\
 	stage2_apply_range(mmu, addr, end, fn, true)
 
+static bool need_topup_split_page_cache_or_resched(struct kvm *kvm, uint64_t min)
+{
+	struct kvm_mmu_memory_cache *cache;
+
+	if (need_resched() || rwlock_needbreak(&kvm->mmu_lock))
+		return true;
+
+	cache = &kvm->arch.mmu.split_page_cache;
+	return kvm_mmu_memory_cache_nr_free_objects(cache) < min;
+}
+
+/*
+ * Get the maximum number of page-tables needed to split a range of
+ * blocks into PAGE_SIZE PTEs. It assumes the range is already mapped
+ * at the PMD level, or at the PUD level if allowed.
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
+static int kvm_mmu_split_huge_pages(struct kvm *kvm, phys_addr_t addr,
+				    phys_addr_t end)
+{
+	struct kvm_mmu_memory_cache *cache;
+	struct kvm_pgtable *pgt;
+	int ret;
+	u64 next;
+	u64 chunk_size = kvm->arch.mmu.split_page_chunk_size;
+	int cache_capacity = kvm_mmu_split_nr_page_tables(chunk_size);
+
+	if (chunk_size == 0)
+		return 0;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	cache = &kvm->arch.mmu.split_page_cache;
+
+	do {
+		if (need_topup_split_page_cache_or_resched(kvm,
+							   cache_capacity)) {
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
+		ret = kvm_pgtable_stage2_split(pgt, addr, next - addr,
+					       cache, cache_capacity);
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
@@ -773,6 +851,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 void kvm_uninit_stage2_mmu(struct kvm *kvm)
 {
 	kvm_free_stage2_pgd(&kvm->arch.mmu);
+	kvm_mmu_free_memory_cache(&kvm->arch.mmu.split_page_cache);
 }
 
 static void stage2_unmap_memslot(struct kvm *kvm,
@@ -999,6 +1078,31 @@ static void kvm_mmu_write_protect_pt_masked(struct kvm *kvm,
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
+	lockdep_assert_held(&kvm->slots_lock);
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
@@ -1790,6 +1894,16 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 			return;
 
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
2.40.0.rc0.216.gc4246ad0f0-goog

