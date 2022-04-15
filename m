Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0E35030B9
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 01:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356230AbiDOWB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 18:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356173AbiDOWBw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 18:01:52 -0400
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B1D8E7C
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:59:22 -0700 (PDT)
Received: by mail-io1-xd49.google.com with SMTP id w28-20020a05660205dc00b00645d3cdb0f7so5423442iox.10
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 14:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Mb/OefWBn9RCKNoTmiaaE/VUMk03Unut8vex1/PGQS0=;
        b=fsNxIh3BEH+XlmSMjPVMtJeBZUk0FQpQlK3w9p+lwpUBGbcSk9U8YLOg1rOBKVY1uR
         viQStsQ0f4HjS7zw60Z7a9eHBjDc6y8KRSAjfz92x1WW108wRFezoo18fGyW9sSXBFjN
         2njPnnWl4Sr2o3BvCsi7QBaMPCEPmdo7c66TYpshJHac92EsLJ7nryQaBB4BbzWGOmGE
         IYHOMX5S+Fo9qzysE1iP/+8Q31pXvGIBFwOUa9Uu4JmQUu3iidG5OczCVUkqWrYk1BLJ
         vJIDxqvp/F8fIVIgSNja8wv/C6uygQfysG5mpeJRy6sVuameHckrI6H2LQ9ArdcD5nwl
         2BBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Mb/OefWBn9RCKNoTmiaaE/VUMk03Unut8vex1/PGQS0=;
        b=lq6nYystU9OUznPwyOTvfxPk2uqgVN7ePJHZYnPTE8RoIEUzT6QLok9HWWF82WToLt
         1Bo18B6/fJg5dJw0GtytH3dSFNtLVD7bVIbqQWIllq6hOuhGJXh0YNeKGsxmQm3l92rU
         xH5ztZp08bXkk0NrhRuA23dpAFhc5ewizP448GKiTXdYM5WZ0sAjlKx5dBloz4L++mYY
         vTBlpNtR1T3Lnst3p2LGSN/+NDpAt8r092kOpfa9HZ7VQdxoqMAF9bFnLwWZPpEj6lAQ
         +1wsn8gmBnBAPIUxDTfUdkFH7Yc42yokAL7wjKIk9264IKINXZu8ErailvVNg76pvr+0
         Vy8Q==
X-Gm-Message-State: AOAM531DqwkvmAgz5fizEDr+S+0IMfbIqtrCZhnMDaTvEKru+f6E3p8+
        i67/MdT3dZp/v0e2gAd8ATiY2B+KYns=
X-Google-Smtp-Source: ABdhPJzuFSrhWKcatk7b24EN0VEAajIWqNloCuQY+463KUJzIaWadPCnXDRKjBU8YzbqADXAgMTcRMSd1kw=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:14cb:b0:646:3b7d:6aee with SMTP id
 b11-20020a05660214cb00b006463b7d6aeemr346421iow.178.1650059961830; Fri, 15
 Apr 2022 14:59:21 -0700 (PDT)
Date:   Fri, 15 Apr 2022 21:58:58 +0000
In-Reply-To: <20220415215901.1737897-1-oupton@google.com>
Message-Id: <20220415215901.1737897-15-oupton@google.com>
Mime-Version: 1.0
References: <20220415215901.1737897-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [RFC PATCH 14/17] KVM: arm64: Punt last page reference to rcu
 callback for parallel walk
From:   Oliver Upton <oupton@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>
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

It is possible that a table page remains visible to another thread until
the next rcu synchronization event. To that end, we cannot drop the last
page reference synchronous with post-order traversal for a parallel
table walk.

Schedule an rcu callback to clean up the child table page for parallel
walks.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h |  3 ++
 arch/arm64/kvm/hyp/pgtable.c         | 24 +++++++++++++--
 arch/arm64/kvm/mmu.c                 | 44 +++++++++++++++++++++++++++-
 3 files changed, 67 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 74955aba5918..52e55e00f0ca 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -81,6 +81,8 @@ static inline bool kvm_level_supports_block_mapping(u32 level)
  * @put_page:			Decrement the refcount on a page. When the
  *				refcount reaches 0 the page is automatically
  *				freed.
+ * @free_table:			Drop the last page reference, possibly in the
+ *				next RCU sync if doing a shared walk.
  * @page_count:			Return the refcount of a page.
  * @phys_to_virt:		Convert a physical address into a virtual
  *				address	mapped in the current context.
@@ -98,6 +100,7 @@ struct kvm_pgtable_mm_ops {
 	void		(*get_page)(void *addr);
 	void		(*put_page)(void *addr);
 	int		(*page_count)(void *addr);
+	void		(*free_table)(void *addr, bool shared);
 	void*		(*phys_to_virt)(phys_addr_t phys);
 	phys_addr_t	(*virt_to_phys)(void *addr);
 	void		(*dcache_clean_inval_poc)(void *addr, size_t size);
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 121818d4c33e..a9a48edba63b 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -147,12 +147,19 @@ static inline void kvm_pgtable_walk_end(void)
 {}
 
 #define kvm_dereference_ptep	rcu_dereference_raw
+
+static inline void kvm_pgtable_destroy_barrier(void)
+{}
+
 #else
 #define kvm_pgtable_walk_begin	rcu_read_lock
 
 #define kvm_pgtable_walk_end	rcu_read_unlock
 
 #define kvm_dereference_ptep	rcu_dereference
+
+#define kvm_pgtable_destroy_barrier	rcu_barrier
+
 #endif
 
 static kvm_pte_t *kvm_pte_follow(kvm_pte_t pte, struct kvm_pgtable_mm_ops *mm_ops)
@@ -1063,7 +1070,12 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
 		childp = kvm_pte_follow(*old, mm_ops);
 	}
 
-	mm_ops->put_page(childp);
+	/*
+	 * If we do not have exclusive access to the page tables it is possible
+	 * the unlinked table remains visible to another thread until the next
+	 * rcu synchronization.
+	 */
+	mm_ops->free_table(childp, shared);
 	mm_ops->put_page(ptep);
 
 	return ret;
@@ -1203,7 +1215,7 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 					       kvm_granule_size(level));
 
 	if (childp)
-		mm_ops->put_page(childp);
+		mm_ops->free_table(childp, shared);
 
 	return 0;
 }
@@ -1433,7 +1445,7 @@ static int stage2_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	mm_ops->put_page(ptep);
 
 	if (kvm_pte_table(*old, level))
-		mm_ops->put_page(kvm_pte_follow(*old, mm_ops));
+		mm_ops->free_table(kvm_pte_follow(*old, mm_ops), shared);
 
 	return 0;
 }
@@ -1452,4 +1464,10 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
 	pgd_sz = kvm_pgd_pages(pgt->ia_bits, pgt->start_level) * PAGE_SIZE;
 	pgt->mm_ops->free_pages_exact(pgt->pgd, pgd_sz);
 	pgt->pgd = NULL;
+
+	/*
+	 * Guarantee that all unlinked subtrees associated with the stage2 page
+	 * table have also been freed before returning.
+	 */
+	kvm_pgtable_destroy_barrier();
 }
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index cc6ed6b06ec2..6ecf37009c21 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -98,9 +98,50 @@ static bool kvm_is_device_pfn(unsigned long pfn)
 static void *stage2_memcache_zalloc_page(void *arg)
 {
 	struct kvm_mmu_caches *mmu_caches = arg;
+	struct stage2_page_header *hdr;
+	void *addr;
 
 	/* Allocated with __GFP_ZERO, so no need to zero */
-	return kvm_mmu_memory_cache_alloc(&mmu_caches->page_cache);
+	addr = kvm_mmu_memory_cache_alloc(&mmu_caches->page_cache);
+	if (!addr)
+		return NULL;
+
+	hdr = kvm_mmu_memory_cache_alloc(&mmu_caches->header_cache);
+	if (!hdr) {
+		free_page((unsigned long)addr);
+		return NULL;
+	}
+
+	hdr->page = virt_to_page(addr);
+	set_page_private(hdr->page, (unsigned long)hdr);
+	return addr;
+}
+
+static void stage2_free_page_now(struct stage2_page_header *hdr)
+{
+	WARN_ON(page_ref_count(hdr->page) != 1);
+
+	__free_page(hdr->page);
+	kmem_cache_free(stage2_page_header_cache, hdr);
+}
+
+static void stage2_free_page_rcu_cb(struct rcu_head *head)
+{
+	struct stage2_page_header *hdr = container_of(head, struct stage2_page_header,
+						      rcu_head);
+
+	stage2_free_page_now(hdr);
+}
+
+static void stage2_free_table(void *addr, bool shared)
+{
+	struct page *page = virt_to_page(addr);
+	struct stage2_page_header *hdr = (struct stage2_page_header *)page_private(page);
+
+	if (shared)
+		call_rcu(&hdr->rcu_head, stage2_free_page_rcu_cb);
+	else
+		stage2_free_page_now(hdr);
 }
 
 static void *kvm_host_zalloc_pages_exact(size_t size)
@@ -613,6 +654,7 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
 	.free_pages_exact	= free_pages_exact,
 	.get_page		= kvm_host_get_page,
 	.put_page		= kvm_host_put_page,
+	.free_table		= stage2_free_table,
 	.page_count		= kvm_host_page_count,
 	.phys_to_virt		= kvm_host_va,
 	.virt_to_phys		= kvm_host_pa,
-- 
2.36.0.rc0.470.gd361397f0d-goog

