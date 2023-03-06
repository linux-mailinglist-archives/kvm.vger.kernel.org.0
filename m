Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B42DD6AD1E1
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 23:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbjCFWmr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 17:42:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjCFWmU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 17:42:20 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D3D48616C
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 14:41:57 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id m9-20020a170902db0900b0019ea0e227e4so5087268plx.6
        for <kvm@vger.kernel.org>; Mon, 06 Mar 2023 14:41:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678142515;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IyMdgcKokNAQM99PayI8bLjHWwV0ForFIy4aNy3o9lk=;
        b=KgBV2fZBDR75hRmr5WoQIaFK5nxiY1MuIyQqq/Lz0E/QkDMmYsjZW3MRa34kuMgQMb
         WFHu0aMlW0ZFuhTdf+BmvoqZ42p2tY1SE+KT3f1mhiQULkycdP5rOo+nnu4LzHCaooJ7
         c6KkY1/mkucfLXMoqhCsBuMbnzaO5qx/JDFT0cJHALyKeLvsY4NyqQuiVdy85EjXLsLj
         VqtvdmAWINjXm8+4BEkwg0o7gzzCctUf18vvRdgNMpLF7UkstTX9iKrOdH3J4OBw8Q5n
         YV4u2mNlr9CEFSbUMSh3uexUnEJUUQJOO7ivnf1EBJMSHq80MICp48/sQvCz3yCvWo84
         R6tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678142515;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IyMdgcKokNAQM99PayI8bLjHWwV0ForFIy4aNy3o9lk=;
        b=JccA2QoFuTdoYV42cYf7l0iGRcd9i06oGP/6l7E94aVs/LPp8BUTqhwUh7HgfeaqOc
         g0tBb/v4DPjsmXjfirj4EgVda+5ySND7R+3ZH6UoGYNRGQDfmINFyErejw+dwqoo4y6m
         uk6jlp7PPOcCKGDkBi0AtKNA52Iultf42ae8JQNgbsLLrSAZk9UPagbjZR2WemoXvvqf
         dYa40NZRhkQVVQ8GH9/ztqIlcheqg6pK5xs2l5zq4vGU/Xr1lBI2zSRAAYyw4Emc0NNL
         tqnfazX9en0d3fPJbkw8yU5SllCu4aLfvlBnjoKVZuAz0fZf/hzDXqSM1FW1pJDLOs/h
         XT4g==
X-Gm-Message-State: AO0yUKWUtRK2axPIBAEsPX9R+TwEfdl/w0NIL3k8xHIFeiOnxZPdwoM+
        uKaSnayDRoUFDMojLEazvu1n8f0eydU9
X-Google-Smtp-Source: AK7set9+eOiqb/vToH7alNWaohc4OhzJSaVaQWex5JU8jZbtLK/hP7rjgkLPv4lw0xP+Po/bflIraSs++1b1
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:90a:5993:b0:233:b520:1544 with SMTP id
 l19-20020a17090a599300b00233b5201544mr6781101pji.0.1678142515516; Mon, 06 Mar
 2023 14:41:55 -0800 (PST)
Date:   Mon,  6 Mar 2023 14:41:21 -0800
In-Reply-To: <20230306224127.1689967-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20230306224127.1689967-1-vipinsh@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230306224127.1689967-13-vipinsh@google.com>
Subject: [Patch v4 12/18] KVM: x86/mmu: Allocate NUMA aware page tables on TDP
 huge page splits
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        dmatlack@google.com
Cc:     jmattson@google.com, mizhang@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
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

When splitting a huge page, try to allocate new lower level page tables
on the same NUMA node of the huge page. Only do NUMA aware page splits
if KVM has enabled NUMA aware page table for the VM else fall back to
the default method of using current thread mempolicy.

When huge pages are split for dirty log, new page tables are created
based on the current thread mempolicy, which by default will be the NUMA
node of the pCPU executing the thread. If thread enabling dirty log is
on a remote NUMA node than the huge page NUMA node then it will
create all page tables mapping 4KiB pages of that huge page on the
remote node. This reduces performances of the vCPUs which are NUMA
bound and are only accessing local NUMA memory as they will access
remote NUMA node page tables to access their local NUMA node memory.

Tested this feature on synthetic read-write-heavy workload in a 416 vCPU
VM on a 8 NUMA node host. This workload creates multiple threads,
partitions data in equal sizes and assigns them to each thread. Each
thread iterates over its own data in strides, reads and writes value in
its partitions. While executing, this workload continuously outputs
combined rates at which it is performing operations.

When dirty log is enabled in WRPROT mode, workload's performance:
- Without NUMA aware page table drops by ~75%
- With NUMA aware page table drops by ~20%

Raw data from one example run:
1. Without NUMA aware page table
   Before dirty log: ~2750000 accesses/sec
   After dirty log: ~700000 accesses/sec

2. With NUMA aware page table
   Before dirty log: ~2750000 accesses/sec
   After dirty log: ~2250000 accesses/sec

NUMA aware page table improved performance by more than 200%

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/kvm/mmu/mmu_internal.h | 15 +++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c      |  9 +++++----
 include/linux/kvm_host.h        |  1 +
 virt/kvm/kvm_main.c             | 16 ++++++++++++++++
 4 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index a607314348e3..b9d0e09ae974 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -340,4 +340,19 @@ void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 void *mmu_sp_memory_cache_alloc(struct kvm_mmu_memory_cache *cache);
 
+static inline int kvm_pfn_to_page_table_nid(struct kvm *kvm, kvm_pfn_t pfn)
+{
+	struct page *page;
+
+	if (!kvm->arch.numa_aware_page_table)
+		return NUMA_NO_NODE;
+
+	page = kvm_pfn_to_refcounted_page(pfn);
+
+	if (page)
+		return page_to_nid(page);
+	else
+		return numa_mem_id();
+}
+
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index d1e85012a008..61fd9c177694 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1412,7 +1412,7 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
 	return spte_set;
 }
 
-static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
+static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp, int nid)
 {
 	struct kvm_mmu_page *sp;
 
@@ -1422,7 +1422,7 @@ static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
 	if (!sp)
 		return NULL;
 
-	sp->spt = (void *)__get_free_page(gfp);
+	sp->spt = kvm_mmu_get_free_page(gfp, nid);
 	if (!sp->spt) {
 		kmem_cache_free(mmu_page_header_cache, sp);
 		return NULL;
@@ -1435,6 +1435,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 						       struct tdp_iter *iter,
 						       bool shared)
 {
+	int nid = kvm_pfn_to_page_table_nid(kvm, spte_to_pfn(iter->old_spte));
 	struct kvm_mmu_page *sp;
 
 	/*
@@ -1446,7 +1447,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 	 * If this allocation fails we drop the lock and retry with reclaim
 	 * allowed.
 	 */
-	sp = __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT);
+	sp = __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT, nid);
 	if (sp)
 		return sp;
 
@@ -1458,7 +1459,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 		write_unlock(&kvm->mmu_lock);
 
 	iter->yielded = true;
-	sp = __tdp_mmu_alloc_sp_for_split(GFP_KERNEL_ACCOUNT);
+	sp = __tdp_mmu_alloc_sp_for_split(GFP_KERNEL_ACCOUNT, nid);
 
 	if (shared)
 		read_lock(&kvm->mmu_lock);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 5cfa42c130e0..31586a65e346 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1358,6 +1358,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool yield_to_kernel_mode);
 void kvm_flush_remote_tlbs(struct kvm *kvm);
 
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
+void *kvm_mmu_get_free_page(gfp_t gfp, int nid);
 int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
 int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min);
 int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 536d8ab6e61f..47006d209309 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -377,6 +377,22 @@ static void kvm_flush_shadow_all(struct kvm *kvm)
 }
 
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
+
+void *kvm_mmu_get_free_page(gfp_t gfp, int nid)
+{
+#ifdef CONFIG_NUMA
+	struct page *page;
+
+	if (nid != NUMA_NO_NODE) {
+		page = alloc_pages_node(nid, gfp, 0);
+		if (!page)
+			return (void *)0;
+		return page_address(page);
+	}
+#endif /* CONFIG_NUMA */
+	return (void *)__get_free_page(gfp);
+}
+
 static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
 					       gfp_t gfp_flags)
 {
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

