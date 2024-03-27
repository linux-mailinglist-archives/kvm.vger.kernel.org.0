Return-Path: <kvm+bounces-12890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 55F9288EC63
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 18:19:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3C5D5B25A51
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 17:19:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71A5814F128;
	Wed, 27 Mar 2024 17:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KS29rdns"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C321D14EC71
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 17:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711559890; cv=none; b=LddSOjS7bb+sjAfL6EFMVJvJqKYpYCjLcO0R5LTVQH1idVbhBH6Xk65OxcE3e4EItYFVbBzHOO59fyRhxxgpRqy3NkJOM2Btbg9jByzNbZFVhgE9+7XfVSRMoyCHWZrCE16vUMP7FA1VYYhj+owQov9/uyEe6/gzk9PV7z2XgYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711559890; c=relaxed/simple;
	bh=fCPBqdb/94XOPUlqfbJ0TMJ1y8uN4lm1XSG1ZWVDSUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q5p3GwABDUWdHd8hvTIMDqbQwmFs4mv2xq/1yAwl3VdpisKK2oRN70GJPD9m/wWsPQoG9+PZgWXbtcFAvnEKbLUkTnV4mN1WqPPzC1KUTz9314tj/C+RI0DkI8Y9Sl5w52WeM7fcv6Xtq+uYUOQIhfgnAKlQopLN3AnFxE+ALyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KS29rdns; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711559887;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BvzM0tI1442ad9elHAX827KhH0GuwUl4zhYChvz46rg=;
	b=KS29rdns/46J7S4wQHOA9+25LR231iar3kV2Jn7RmSrrC1ogNGoLXbD77uNVgo47RTKZO3
	hR4aCQkZ7P96L+KHlbVNd8Bq9XRMs+eUNbGW2Fqf2dCeXriXInDqoG6+sZnjTgYcbJunYg
	ydTsiym/9sxG6PE/6CMZus/BHhwt5nw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-507-xQyAFs2iOZCkAHoy4e8fPw-1; Wed,
 27 Mar 2024 13:17:57 -0400
X-MC-Unique: xQyAFs2iOZCkAHoy4e8fPw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF89E3802AC0;
	Wed, 27 Mar 2024 17:17:56 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.39.193.208])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3DA65111E3F3;
	Wed, 27 Mar 2024 17:17:52 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	David Hildenbrand <david@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Xu <peterx@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	kvm@vger.kernel.org,
	linux-s390@vger.kernel.org
Subject: [PATCH v2 2/2] s390/mm: re-enable the shared zeropage for !PV and !skeys KVM guests
Date: Wed, 27 Mar 2024 18:17:37 +0100
Message-ID: <20240327171737.919590-3-david@redhat.com>
In-Reply-To: <20240327171737.919590-1-david@redhat.com>
References: <20240327171737.919590-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

commit fa41ba0d08de ("s390/mm: avoid empty zero pages for KVM guests to
avoid postcopy hangs") introduced an undesired side effect when combined
with memory ballooning and VM migration: memory part of the inflated
memory balloon will consume memory.

Assuming we have a 100GiB VM and inflated the balloon to 40GiB. Our VM
will consume ~60GiB of memory. If we now trigger a VM migration,
hypervisors like QEMU will read all VM memory. As s390x does not support
the shared zeropage, we'll end up allocating for all previously-inflated
memory part of the memory balloon: 50 GiB. So we might easily
(unexpectedly) crash the VM on the migration source.

Even worse, hypervisors like QEMU optimize for zeropage migration to not
consume memory on the migration destination: when migrating a
"page full of zeroes", on the migration destination they check whether the
target memory is already zero (by reading the destination memory) and avoid
writing to the memory to not allocate memory: however, s390x will also
allocate memory here, implying that also on the migration destination, we
will end up allocating all previously-inflated memory part of the memory
balloon.

This is especially bad if actual memory overcommit was not desired, when
memory ballooning is used for dynamic VM memory resizing, setting aside
some memory during boot that can be added later on demand. Alternatives
like virtio-mem that would avoid this issue are not yet available on
s390x.

There could be ways to optimize some cases in user space: before reading
memory in an anonymous private mapping on the migration source, check via
/proc/self/pagemap if anything is already populated. Similarly check on
the migration destination before reading. While that would avoid
populating tables full of shared zeropages on all architectures, it's
harder to get right and performant, and requires user space changes.

Further, with posctopy live migration we must place a page, so there,
"avoid touching memory to avoid allocating memory" is not really
possible. (Note that a previously we would have falsely inserted
shared zeropages into processes using UFFDIO_ZEROPAGE where
mm_forbids_zeropage() would have actually forbidden it)

PV is currently incompatible with memory ballooning, and in the common
case, KVM guests don't make use of storage keys. Instead of zapping
zeropages when enabling storage keys / PV, that turned out to be
problematic in the past, let's do exactly the same we do with KSM pages:
trigger unsharing faults to replace the shared zeropages by proper
anonymous folios.

What about added latency when enabling storage kes? Having a lot of
zeropages in applicable environments (PV, legacy guests, unittests) is
unexpected. Further, KSM could today already unshare the zeropages
and unmerging KSM pages when enabling storage kets would unshare the
KSM-placed zeropages in the same way, resulting in the same latency.

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Tested-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Fixes: fa41ba0d08de ("s390/mm: avoid empty zero pages for KVM guests to avoid postcopy hangs")
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/include/asm/gmap.h        |   2 +-
 arch/s390/include/asm/mmu.h         |   5 +
 arch/s390/include/asm/mmu_context.h |   1 +
 arch/s390/include/asm/pgtable.h     |  15 ++-
 arch/s390/kvm/kvm-s390.c            |   4 +-
 arch/s390/mm/gmap.c                 | 163 +++++++++++++++++++++-------
 6 files changed, 143 insertions(+), 47 deletions(-)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index 5cc46e0dde62..9725586f4259 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -146,7 +146,7 @@ int gmap_mprotect_notify(struct gmap *, unsigned long start,
 
 void gmap_sync_dirty_log_pmd(struct gmap *gmap, unsigned long dirty_bitmap[4],
 			     unsigned long gaddr, unsigned long vmaddr);
-int gmap_mark_unmergeable(void);
+int s390_disable_cow_sharing(void);
 void s390_unlist_old_asce(struct gmap *gmap);
 int s390_replace_asce(struct gmap *gmap);
 void s390_uv_destroy_pfns(unsigned long count, unsigned long *pfns);
diff --git a/arch/s390/include/asm/mmu.h b/arch/s390/include/asm/mmu.h
index bb1b4bef1878..4c2dc7abc285 100644
--- a/arch/s390/include/asm/mmu.h
+++ b/arch/s390/include/asm/mmu.h
@@ -32,6 +32,11 @@ typedef struct {
 	unsigned int uses_skeys:1;
 	/* The mmu context uses CMM. */
 	unsigned int uses_cmm:1;
+	/*
+	 * The mmu context allows COW-sharing of memory pages (KSM, zeropage).
+	 * Note that COW-sharing during fork() is currently always allowed.
+	 */
+	unsigned int allow_cow_sharing:1;
 	/* The gmaps associated with this context are allowed to use huge pages. */
 	unsigned int allow_gmap_hpage_1m:1;
 } mm_context_t;
diff --git a/arch/s390/include/asm/mmu_context.h b/arch/s390/include/asm/mmu_context.h
index 929af18b0908..a7789a9f6218 100644
--- a/arch/s390/include/asm/mmu_context.h
+++ b/arch/s390/include/asm/mmu_context.h
@@ -35,6 +35,7 @@ static inline int init_new_context(struct task_struct *tsk,
 	mm->context.has_pgste = 0;
 	mm->context.uses_skeys = 0;
 	mm->context.uses_cmm = 0;
+	mm->context.allow_cow_sharing = 1;
 	mm->context.allow_gmap_hpage_1m = 0;
 #endif
 	switch (mm->context.asce_limit) {
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 60950e7a25f5..1a71cb19c089 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -566,10 +566,19 @@ static inline pud_t set_pud_bit(pud_t pud, pgprot_t prot)
 }
 
 /*
- * In the case that a guest uses storage keys
- * faults should no longer be backed by zero pages
+ * As soon as the guest uses storage keys or enables PV, we deduplicate all
+ * mapped shared zeropages and prevent new shared zeropages from getting
+ * mapped.
  */
-#define mm_forbids_zeropage mm_has_pgste
+static inline int mm_forbids_zeropage(struct mm_struct *mm)
+{
+#ifdef CONFIG_PGSTE
+	if (!mm->context.allow_cow_sharing)
+		return 1;
+#endif
+	return 0;
+}
+
 static inline int mm_uses_skeys(struct mm_struct *mm)
 {
 #ifdef CONFIG_PGSTE
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 5147b943a864..db3392f0be21 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2631,9 +2631,7 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 		if (r)
 			break;
 
-		mmap_write_lock(current->mm);
-		r = gmap_mark_unmergeable();
-		mmap_write_unlock(current->mm);
+		r = s390_disable_cow_sharing();
 		if (r)
 			break;
 
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 094b43b121cd..9233b0acac89 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2549,41 +2549,6 @@ static inline void thp_split_mm(struct mm_struct *mm)
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
-/*
- * Remove all empty zero pages from the mapping for lazy refaulting
- * - This must be called after mm->context.has_pgste is set, to avoid
- *   future creation of zero pages
- * - This must be called after THP was disabled.
- *
- * mm contracts with s390, that even if mm were to remove a page table,
- * racing with the loop below and so causing pte_offset_map_lock() to fail,
- * it will never insert a page table containing empty zero pages once
- * mm_forbids_zeropage(mm) i.e. mm->context.has_pgste is set.
- */
-static int __zap_zero_pages(pmd_t *pmd, unsigned long start,
-			   unsigned long end, struct mm_walk *walk)
-{
-	unsigned long addr;
-
-	for (addr = start; addr != end; addr += PAGE_SIZE) {
-		pte_t *ptep;
-		spinlock_t *ptl;
-
-		ptep = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
-		if (!ptep)
-			break;
-		if (is_zero_pfn(pte_pfn(*ptep)))
-			ptep_xchg_direct(walk->mm, addr, ptep, __pte(_PAGE_INVALID));
-		pte_unmap_unlock(ptep, ptl);
-	}
-	return 0;
-}
-
-static const struct mm_walk_ops zap_zero_walk_ops = {
-	.pmd_entry	= __zap_zero_pages,
-	.walk_lock	= PGWALK_WRLOCK,
-};
-
 /*
  * switch on pgstes for its userspace process (for kvm)
  */
@@ -2601,22 +2566,140 @@ int s390_enable_sie(void)
 	mm->context.has_pgste = 1;
 	/* split thp mappings and disable thp for future mappings */
 	thp_split_mm(mm);
-	walk_page_range(mm, 0, TASK_SIZE, &zap_zero_walk_ops, NULL);
 	mmap_write_unlock(mm);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(s390_enable_sie);
 
-int gmap_mark_unmergeable(void)
+static int find_zeropage_pte_entry(pte_t *pte, unsigned long addr,
+		unsigned long end, struct mm_walk *walk)
+{
+	unsigned long *found_addr = walk->private;
+
+	/* Return 1 of the page is a zeropage. */
+	if (is_zero_pfn(pte_pfn(*pte))) {
+
+		/*
+		 * Shared zeropage in e.g., a FS DAX mapping? We cannot do the
+		 * right thing and likely don't care: FAULT_FLAG_UNSHARE
+		 * currently only works in COW mappings, which is also where
+		 * mm_forbids_zeropage() is checked.
+		 */
+		if (!is_cow_mapping(walk->vma->vm_flags))
+			return -EFAULT;
+
+		*found_addr = addr;
+		return 1;
+	}
+	return 0;
+}
+
+static const struct mm_walk_ops find_zeropage_ops = {
+	.pte_entry	= find_zeropage_pte_entry,
+	.walk_lock	= PGWALK_WRLOCK,
+};
+
+/*
+ * Unshare all shared zeropages, replacing them by anonymous pages. Note that
+ * we cannot simply zap all shared zeropages, because this could later
+ * trigger unexpected userfaultfd missing events.
+ *
+ * This must be called after mm->context.allow_cow_sharing was
+ * set to 0, to avoid future mappings of shared zeropages.
+ *
+ * mm contracts with s390, that even if mm were to remove a page table,
+ * and racing with walk_page_range_vma() calling pte_offset_map_lock()
+ * would fail, it will never insert a page table containing empty zero
+ * pages once mm_forbids_zeropage(mm) i.e.
+ * mm->context.allow_cow_sharing is set to 0.
+ */
+static int __s390_unshare_zeropages(struct mm_struct *mm)
+{
+	struct vm_area_struct *vma;
+	VMA_ITERATOR(vmi, mm, 0);
+	unsigned long addr;
+	int rc;
+
+	for_each_vma(vmi, vma) {
+		/*
+		 * We could only look at COW mappings, but it's more future
+		 * proof to catch unexpected zeropages in other mappings and
+		 * fail.
+		 */
+		if ((vma->vm_flags & VM_PFNMAP) || is_vm_hugetlb_page(vma))
+			continue;
+		addr = vma->vm_start;
+
+retry:
+		rc = walk_page_range_vma(vma, addr, vma->vm_end,
+					 &find_zeropage_ops, &addr);
+		if (rc <= 0)
+			continue;
+
+		/* addr was updated by find_zeropage_pte_entry() */
+		rc = handle_mm_fault(vma, addr,
+				     FAULT_FLAG_UNSHARE | FAULT_FLAG_REMOTE,
+				     NULL);
+		if (rc & VM_FAULT_OOM)
+			return -ENOMEM;
+		/*
+		 * See break_ksm(): even after handle_mm_fault() returned 0, we
+		 * must start the lookup from the current address, because
+		 * handle_mm_fault() may back out if there's any difficulty.
+		 *
+		 * VM_FAULT_SIGBUS and VM_FAULT_SIGSEGV are unexpected but
+		 * maybe they could trigger in the future on concurrent
+		 * truncation. In that case, the shared zeropage would be gone
+		 * and we can simply retry and make progress.
+		 */
+		cond_resched();
+		goto retry;
+	}
+
+	return rc;
+}
+
+static int __s390_disable_cow_sharing(struct mm_struct *mm)
 {
+	int rc;
+
+	if (!mm->context.allow_cow_sharing)
+		return 0;
+
+	mm->context.allow_cow_sharing = 0;
+
+	/* Replace all shared zeropages by anonymous pages. */
+	rc = __s390_unshare_zeropages(mm);
 	/*
 	 * Make sure to disable KSM (if enabled for the whole process or
 	 * individual VMAs). Note that nothing currently hinders user space
 	 * from re-enabling it.
 	 */
-	return ksm_disable(current->mm);
+	if (!rc)
+		rc = ksm_disable(mm);
+	if (rc)
+		mm->context.allow_cow_sharing = 1;
+	return rc;
+}
+
+/*
+ * Disable most COW-sharing of memory pages for the whole process:
+ * (1) Disable KSM and unmerge/unshare any KSM pages.
+ * (2) Disallow shared zeropages and unshare any zerpages that are mapped.
+ *
+ * Not that we currently don't bother with COW-shared pages that are shared
+ * with parent/child processes due to fork().
+ */
+int s390_disable_cow_sharing(void)
+{
+	int rc;
+
+	mmap_write_lock(current->mm);
+	rc = __s390_disable_cow_sharing(current->mm);
+	mmap_write_unlock(current->mm);
+	return rc;
 }
-EXPORT_SYMBOL_GPL(gmap_mark_unmergeable);
+EXPORT_SYMBOL_GPL(s390_disable_cow_sharing);
 
 /*
  * Enable storage key handling from now on and initialize the storage
@@ -2685,7 +2768,7 @@ int s390_enable_skey(void)
 		goto out_up;
 
 	mm->context.uses_skeys = 1;
-	rc = gmap_mark_unmergeable();
+	rc = __s390_disable_cow_sharing(mm);
 	if (rc) {
 		mm->context.uses_skeys = 0;
 		goto out_up;
-- 
2.43.2


