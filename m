Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E35D5BFBD2
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 01:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728958AbfIZXTC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 19:19:02 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:43851 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728911AbfIZXTC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 19:19:02 -0400
Received: by mail-qk1-f201.google.com with SMTP id w7so831553qkf.10
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 16:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=yiHBZbfaEUL6oyk2w4l/q3M9S9S7wHBEf2BUGmUMZAk=;
        b=HJHliQkfXMwQIhVrOTEHtbvMNtpAMna2v7l+x0CWiUOxK9mRha5cnvY7jEkQYuE6U7
         1Lb4DJeenmtFy0pNgNp78fUkq1DJM4DC3EXZe1OTa2tUij/yW3HcLAxbz4LnRMMOdzzg
         pEhLFaLs5BYCw2SHYLaBr5Gl3q5uVSgYT3zGs26ZOkrZo/jPkVNWKfRzoq/tTnhBeD2W
         D31qeFjpPr2NEK4z9wYfjP0YZYzg10xh/PP0dc0FfWLufSnEyIYldsjQRJfLyMbK4VrE
         DkAyiLMvZJUbdIVQ5lfE1iUkFClTxCiotYNzPznyVTrSbcWl61VKcc7wAJH0iCXPcgnJ
         5nIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=yiHBZbfaEUL6oyk2w4l/q3M9S9S7wHBEf2BUGmUMZAk=;
        b=lZn4hZC9pSSs3aa/yq+yephlRHHuTGz8F1YbcvkaGVXKeDY0WgvSeQe7F3jSrunnD9
         d63SIOBuaNWQc9UmZYsjhooWBvTCCoO/OT+l+kc5QYT6iAetrq1IKytFh+pM9JbGXAXD
         M2tzAvF0BDBVoMQrjX57sJH3kYLLUXbS+d0XrnZy7mj/qRU4/Qx2WGmGPhSpms5S3izm
         JZUAEpvKkj3Jw82irmKpkR6gAXlat5LkrgBpt62OBttNgb1e2Ja0nB50CcvD+2HmO9Wt
         kFFbkRxchmZ3lHWjhgYcKkT36UWqIQkWfDfA05RGrhPSjMdS3VjwUzLkZOTkOw+pocuB
         36Ag==
X-Gm-Message-State: APjAAAV9vkXNqjqi2TKplnXqzLFloj4cNpEfd0bnrjcgJKBOLqnl24cH
        AL0mse5flxl6ywBdtuYW/ZgHmKum8QLqEVW53sgvmiDjQNFnMvD0968jlW5SMRVgR2SSwZUaeD7
        Euke654cXld3xl7aJQ9n7nVa73hb7+berJ9maRXdA7PSW0po6O4bCZ2V/rNjW
X-Google-Smtp-Source: APXvYqz3G+QtwY8PigT47G1XYVHqOsxOqS/gSpdiRo/iX+OLD+a+98fjwm/1rVjGOnvxLhCDiR95byKE1j6X
X-Received: by 2002:a0c:ad01:: with SMTP id u1mr5337710qvc.137.1569539939976;
 Thu, 26 Sep 2019 16:18:59 -0700 (PDT)
Date:   Thu, 26 Sep 2019 16:18:10 -0700
In-Reply-To: <20190926231824.149014-1-bgardon@google.com>
Message-Id: <20190926231824.149014-15-bgardon@google.com>
Mime-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [RFC PATCH 14/28] kvm: mmu: Batch updates to the direct mmu
 disconnected list
From:   Ben Gardon <bgardon@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When many threads are removing pages of page table memory from the
paging structures, the number of list operations on the disconnected
page table list can be quite high. Since a spin lock protects the
disconnected list, the high rate of list additions can lead to contention.
Instead, queue disconnected pages in the paging structure walk iterator
and add them to the global list when updating tlbs_dirty, right before
releasing the MMU lock.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu.c | 54 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 40 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 59d1866398c42..234db5f4246a4 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1780,23 +1780,30 @@ static void direct_mmu_process_pt_free_list_sync(struct kvm *kvm)
 }
 
 /*
- * Add a page of memory that has been disconnected from the paging structure to
+ * Add pages of memory that have been disconnected from the paging structure to
  * a queue to be freed. This is a two step process: after a page has been
  * disconnected, the TLBs must be flushed, and an RCU grace period must elapse
  * before the memory can be freed.
  */
 static void direct_mmu_disconnected_pt_list_add(struct kvm *kvm,
-						struct page *page)
+						struct list_head *list)
 {
+	/*
+	 * No need to acquire the disconnected pts lock if we're adding an
+	 * empty list.
+	 */
+	if (list_empty(list))
+		return;
+
 	spin_lock(&kvm->arch.direct_mmu_disconnected_pts_lock);
-	list_add_tail(&page->lru, &kvm->arch.direct_mmu_disconnected_pts);
+	list_splice_tail_init(list, &kvm->arch.direct_mmu_disconnected_pts);
 	spin_unlock(&kvm->arch.direct_mmu_disconnected_pts_lock);
 }
 
-
 static void handle_changed_pte(struct kvm *kvm, int as_id, gfn_t gfn,
 			       u64 old_pte, u64 new_pte, int level,
-			       bool vm_teardown);
+			       bool vm_teardown,
+			       struct list_head *disconnected_pts);
 
 /**
  * mark_pte_disconnected - Mark a PTE as part of a disconnected PT
@@ -1808,9 +1815,12 @@ static void handle_changed_pte(struct kvm *kvm, int as_id, gfn_t gfn,
  *	paging structure
  * @vm_teardown: all vCPUs are paused and the VM is being torn down. Yield and
  *	free child page table memory immediately.
+ * @disconnected_pts: a local list of page table pages that need to be freed.
+ *	Used to batch updtes to the disconnected pts list.
  */
 static void mark_pte_disconnected(struct kvm *kvm, int as_id, gfn_t gfn,
-				  u64 *ptep, int level, bool vm_teardown)
+				  u64 *ptep, int level, bool vm_teardown,
+				  struct list_head *disconnected_pts)
 {
 	u64 old_pte;
 
@@ -1818,7 +1828,7 @@ static void mark_pte_disconnected(struct kvm *kvm, int as_id, gfn_t gfn,
 	BUG_ON(old_pte == DISCONNECTED_PTE);
 
 	handle_changed_pte(kvm, as_id, gfn, old_pte, DISCONNECTED_PTE, level,
-			   vm_teardown);
+			   vm_teardown, disconnected_pts);
 }
 
 /**
@@ -1831,6 +1841,8 @@ static void mark_pte_disconnected(struct kvm *kvm, int as_id, gfn_t gfn,
  * @level: the level of the PT, when it was part of the paging structure
  * @vm_teardown: all vCPUs are paused and the VM is being torn down. Yield and
  *	free child page table memory immediately.
+ * @disconnected_pts: a local list of page table pages that need to be freed.
+ *	Used to batch updtes to the disconnected pts list.
  *
  * Given a pointer to a page table that has been removed from the paging
  * structure and its level, recursively free child page tables and mark their
@@ -1850,7 +1862,8 @@ static void mark_pte_disconnected(struct kvm *kvm, int as_id, gfn_t gfn,
  */
 static void handle_disconnected_pt(struct kvm *kvm, int as_id,
 				   gfn_t pt_base_gfn, kvm_pfn_t pfn, int level,
-				   bool vm_teardown)
+				   bool vm_teardown,
+				   struct list_head *disconnected_pts)
 {
 	int i;
 	gfn_t gfn = pt_base_gfn;
@@ -1864,7 +1877,7 @@ static void handle_disconnected_pt(struct kvm *kvm, int as_id,
 		 * table the entry might have pointed to.
 		 */
 		mark_pte_disconnected(kvm, as_id, gfn, &pt[i], level,
-				      vm_teardown);
+				      vm_teardown, disconnected_pts);
 
 		gfn += KVM_PAGES_PER_HPAGE(level);
 	}
@@ -1875,7 +1888,8 @@ static void handle_disconnected_pt(struct kvm *kvm, int as_id,
 		free_page((unsigned long)pt);
 	} else {
 		page = pfn_to_page(pfn);
-		direct_mmu_disconnected_pt_list_add(kvm, page);
+		BUG_ON(!disconnected_pts);
+		list_add_tail(&page->lru, disconnected_pts);
 	}
 }
 
@@ -1889,6 +1903,8 @@ static void handle_disconnected_pt(struct kvm *kvm, int as_id,
  * @level: the level of the PT the PTE is part of in the paging structure
  * @vm_teardown: all vCPUs are paused and the VM is being torn down. Yield and
  *	free child page table memory immediately.
+ * @disconnected_pts: a local list of page table pages that need to be freed.
+ *	Used to batch updtes to the disconnected pts list.
  *
  * Handle bookkeeping that might result from the modification of a PTE.
  * This function should be called in the same RCU read critical section as the
@@ -1898,7 +1914,8 @@ static void handle_disconnected_pt(struct kvm *kvm, int as_id,
  */
 static void handle_changed_pte(struct kvm *kvm, int as_id, gfn_t gfn,
 			       u64 old_pte, u64 new_pte, int level,
-			       bool vm_teardown)
+			       bool vm_teardown,
+			       struct list_head *disconnected_pts)
 {
 	bool was_present = is_present_direct_pte(old_pte);
 	bool is_present = is_present_direct_pte(new_pte);
@@ -1944,7 +1961,8 @@ static void handle_changed_pte(struct kvm *kvm, int as_id, gfn_t gfn,
 		 * pointed to must be freed.
 		 */
 		handle_disconnected_pt(kvm, as_id, gfn, spte_to_pfn(old_pte),
-				       child_level, vm_teardown);
+				       child_level, vm_teardown,
+				       disconnected_pts);
 	}
 }
 
@@ -1987,6 +2005,8 @@ struct direct_walk_iterator {
 	gfn_t target_gfn;
 	long tlbs_dirty;
 
+	struct list_head disconnected_pts;
+
 	/* the address space id. */
 	int as_id;
 	u64 *pt_path[PT64_ROOT_4LEVEL];
@@ -2056,6 +2076,9 @@ static bool direct_walk_iterator_flush_needed(struct direct_walk_iterator *iter)
 		tlbs_dirty = xadd(&iter->kvm->tlbs_dirty, iter->tlbs_dirty) +
 				iter->tlbs_dirty;
 		iter->tlbs_dirty = 0;
+
+		direct_mmu_disconnected_pt_list_add(iter->kvm,
+						    &iter->disconnected_pts);
 	} else {
 		tlbs_dirty = READ_ONCE(iter->kvm->tlbs_dirty);
 	}
@@ -2115,6 +2138,8 @@ static void direct_walk_iterator_setup_walk(struct direct_walk_iterator *iter,
 	iter->pt_path[PT64_ROOT_4LEVEL - 1] =
 			(u64 *)__va(kvm->arch.direct_root_hpa[as_id]);
 
+	INIT_LIST_HEAD(&iter->disconnected_pts);
+
 	iter->walk_start = start;
 	iter->walk_end = end;
 	iter->target_gfn = start;
@@ -2393,7 +2418,8 @@ static bool direct_walk_iterator_set_pte(struct direct_walk_iterator *iter,
 			iter->pte_gfn_start);
 	if (r) {
 		handle_changed_pte(iter->kvm, iter->as_id, iter->pte_gfn_start,
-				   iter->old_pte, new_pte, iter->level, false);
+				   iter->old_pte, new_pte, iter->level, false,
+				   &iter->disconnected_pts);
 
 		if (iter->lock_mode & (MMU_WRITE_LOCK | MMU_READ_LOCK))
 			iter->tlbs_dirty++;
@@ -6411,7 +6437,7 @@ static void kvm_mmu_uninit_direct_mmu(struct kvm *kvm)
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
 		handle_disconnected_pt(kvm, i, 0,
 			(kvm_pfn_t)(kvm->arch.direct_root_hpa[i] >> PAGE_SHIFT),
-			PT64_ROOT_4LEVEL, true);
+			PT64_ROOT_4LEVEL, true, NULL);
 }
 
 /* The return value indicates if tlb flush on all vcpus is needed. */
-- 
2.23.0.444.g18eeb5a265-goog

