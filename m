Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6997922DD1C
	for <lists+kvm@lfdr.de>; Sun, 26 Jul 2020 10:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgGZIDD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jul 2020 04:03:03 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:53873 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbgGZIDD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jul 2020 04:03:03 -0400
Received: from localhost.localdomain (unknown [180.110.142.179])
        (Authenticated sender: fly@kernel.page)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 76B41100004;
        Sun, 26 Jul 2020 08:02:48 +0000 (UTC)
From:   Pengfei Li <fly@kernel.page>
To:     akpm@linux-foundation.org
Cc:     bmt@zurich.ibm.com, dledford@redhat.com, willy@infradead.org,
        vbabka@suse.cz, kirill.shutemov@linux.intel.com, jgg@ziepe.ca,
        alex.williamson@redhat.com, cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Pengfei Li <fly@kernel.page>
Subject: [PATCH 1/2] mm: make mm->locked_vm an atomic64 counter
Date:   Sun, 26 Jul 2020 16:02:23 +0800
Message-Id: <20200726080224.205470-1-fly@kernel.page>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Like commit 70f8a3ca68d3 ("mm: make mm->pinned_vm an atomic64 counter").

By making mm->locked_vm an atomic64 counter, we can safely modify it
without holding mmap_lock.

The reason for using atomic64 instead of atomic_long is to keep the same
as mm->pinned_vm, and there is no need to worry about overflow.

Signed-off-by: Pengfei Li <fly@kernel.page>
---
 drivers/infiniband/sw/siw/siw_verbs.c | 12 +++++++-----
 drivers/vfio/vfio_iommu_type1.c       |  6 ++++--
 fs/io_uring.c                         |  4 ++--
 fs/proc/task_mmu.c                    |  2 +-
 include/linux/mm_types.h              |  4 ++--
 kernel/fork.c                         |  2 +-
 mm/debug.c                            |  5 +++--
 mm/mlock.c                            |  4 ++--
 mm/mmap.c                             | 18 +++++++++---------
 mm/mremap.c                           |  6 +++---
 mm/util.c                             |  6 +++---
 11 files changed, 37 insertions(+), 32 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_verbs.c b/drivers/infiniband/sw/siw/siw_verbs.c
index adafa1b8bebe..bf78d7988442 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -1293,14 +1293,16 @@ struct ib_mr *siw_reg_user_mr(struct ib_pd *pd, u64 start, u64 len,
 		goto err_out;
 	}
 	if (mem_limit != RLIM_INFINITY) {
-		unsigned long num_pages =
-			(PAGE_ALIGN(len + (start & ~PAGE_MASK))) >> PAGE_SHIFT;
+		unsigned long num_pages, locked_pages;
+
+		num_pages = (PAGE_ALIGN(len + (start & ~PAGE_MASK)))
+				>> PAGE_SHIFT;
+		locked_pages = atomic64_read(&current->mm->locked_vm);
 		mem_limit >>= PAGE_SHIFT;
 
-		if (num_pages > mem_limit - current->mm->locked_vm) {
+		if (num_pages > mem_limit - locked_pages) {
 			siw_dbg_pd(pd, "pages req %lu, max %lu, lock %lu\n",
-				   num_pages, mem_limit,
-				   current->mm->locked_vm);
+				   num_pages, mem_limit, locked_pages);
 			rv = -ENOMEM;
 			goto err_out;
 		}
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 9d41105bfd01..78013be07fe7 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -509,7 +509,8 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 	 * pages are already counted against the user.
 	 */
 	if (!rsvd && !vfio_find_vpfn(dma, iova)) {
-		if (!dma->lock_cap && current->mm->locked_vm + 1 > limit) {
+		if (!dma->lock_cap &&
+		    atomic64_read(&current->mm->locked_vm) + 1 > limit) {
 			put_pfn(*pfn_base, dma->prot);
 			pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n", __func__,
 					limit << PAGE_SHIFT);
@@ -536,7 +537,8 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 
 		if (!rsvd && !vfio_find_vpfn(dma, iova)) {
 			if (!dma->lock_cap &&
-			    current->mm->locked_vm + lock_acct + 1 > limit) {
+			    atomic64_read(&current->mm->locked_vm) +
+			    lock_acct + 1 > limit) {
 				put_pfn(pfn, dma->prot);
 				pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
 					__func__, limit << PAGE_SHIFT);
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7cf2f295fba7..f1241c6314e6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7371,7 +7371,7 @@ static void io_unaccount_mem(struct io_ring_ctx *ctx, unsigned long nr_pages,
 
 	if (ctx->sqo_mm) {
 		if (acct == ACCT_LOCKED)
-			ctx->sqo_mm->locked_vm -= nr_pages;
+			atomic64_sub(nr_pages, &ctx->sqo_mm->locked_vm);
 		else if (acct == ACCT_PINNED)
 			atomic64_sub(nr_pages, &ctx->sqo_mm->pinned_vm);
 	}
@@ -7390,7 +7390,7 @@ static int io_account_mem(struct io_ring_ctx *ctx, unsigned long nr_pages,
 
 	if (ctx->sqo_mm) {
 		if (acct == ACCT_LOCKED)
-			ctx->sqo_mm->locked_vm += nr_pages;
+			atomic64_add(nr_pages, &ctx->sqo_mm->locked_vm);
 		else if (acct == ACCT_PINNED)
 			atomic64_add(nr_pages, &ctx->sqo_mm->pinned_vm);
 	}
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index df2f0f05f5ba..2af56e68766e 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -58,7 +58,7 @@ void task_mem(struct seq_file *m, struct mm_struct *mm)
 	swap = get_mm_counter(mm, MM_SWAPENTS);
 	SEQ_PUT_DEC("VmPeak:\t", hiwater_vm);
 	SEQ_PUT_DEC(" kB\nVmSize:\t", total_vm);
-	SEQ_PUT_DEC(" kB\nVmLck:\t", mm->locked_vm);
+	SEQ_PUT_DEC(" kB\nVmLck:\t", atomic64_read(&mm->locked_vm));
 	SEQ_PUT_DEC(" kB\nVmPin:\t", atomic64_read(&mm->pinned_vm));
 	SEQ_PUT_DEC(" kB\nVmHWM:\t", hiwater_rss);
 	SEQ_PUT_DEC(" kB\nVmRSS:\t", total_rss);
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 496c3ff97cce..3f0ad38c534d 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -457,8 +457,8 @@ struct mm_struct {
 		unsigned long hiwater_vm;  /* High-water virtual memory usage */
 
 		unsigned long total_vm;	   /* Total pages mapped */
-		unsigned long locked_vm;   /* Pages that have PG_mlocked set */
-		atomic64_t    pinned_vm;   /* Refcount permanently increased */
+		atomic64_t locked_vm;	   /* Pages that have PG_mlocked set */
+		atomic64_t pinned_vm;	   /* Refcount permanently increased */
 		unsigned long data_vm;	   /* VM_WRITE & ~VM_SHARED & ~VM_STACK */
 		unsigned long exec_vm;	   /* VM_EXEC & ~VM_WRITE & ~VM_STACK */
 		unsigned long stack_vm;	   /* VM_STACK */
diff --git a/kernel/fork.c b/kernel/fork.c
index 45cdf724a2d4..8ed0d0574621 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1009,7 +1009,7 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 	mm->core_state = NULL;
 	mm_pgtables_bytes_init(mm);
 	mm->map_count = 0;
-	mm->locked_vm = 0;
+	atomic64_set(&mm->locked_vm, 0);
 	atomic64_set(&mm->pinned_vm, 0);
 	memset(&mm->rss_stat, 0, sizeof(mm->rss_stat));
 	spin_lock_init(&mm->page_table_lock);
diff --git a/mm/debug.c b/mm/debug.c
index 8f569db9a514..c27fff1e3ca8 100644
--- a/mm/debug.c
+++ b/mm/debug.c
@@ -218,7 +218,7 @@ void dump_mm(const struct mm_struct *mm)
 #endif
 		"mmap_base %lu mmap_legacy_base %lu highest_vm_end %lu\n"
 		"pgd %px mm_users %d mm_count %d pgtables_bytes %lu map_count %d\n"
-		"hiwater_rss %lx hiwater_vm %lx total_vm %lx locked_vm %lx\n"
+		"hiwater_rss %lx hiwater_vm %lx total_vm %lx locked_vm %llx\n"
 		"pinned_vm %llx data_vm %lx exec_vm %lx stack_vm %lx\n"
 		"start_code %lx end_code %lx start_data %lx end_data %lx\n"
 		"start_brk %lx brk %lx start_stack %lx\n"
@@ -249,7 +249,8 @@ void dump_mm(const struct mm_struct *mm)
 		atomic_read(&mm->mm_count),
 		mm_pgtables_bytes(mm),
 		mm->map_count,
-		mm->hiwater_rss, mm->hiwater_vm, mm->total_vm, mm->locked_vm,
+		mm->hiwater_rss, mm->hiwater_vm, mm->total_vm,
+		(u64)atomic64_read(&mm->locked_vm),
 		(u64)atomic64_read(&mm->pinned_vm),
 		mm->data_vm, mm->exec_vm, mm->stack_vm,
 		mm->start_code, mm->end_code, mm->start_data, mm->end_data,
diff --git a/mm/mlock.c b/mm/mlock.c
index 93ca2bf30b4f..ec8c563ce233 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -561,7 +561,7 @@ static int mlock_fixup(struct vm_area_struct *vma, struct vm_area_struct **prev,
 		nr_pages = -nr_pages;
 	else if (old_flags & VM_LOCKED)
 		nr_pages = 0;
-	mm->locked_vm += nr_pages;
+	atomic64_add(nr_pages, &mm->locked_vm);
 
 	/*
 	 * vm_flags is protected by the mmap_lock held in write mode.
@@ -688,7 +688,7 @@ static __must_check int do_mlock(unsigned long start, size_t len, vm_flags_t fla
 	if (mmap_write_lock_killable(current->mm))
 		return -EINTR;
 
-	locked += current->mm->locked_vm;
+	locked += atomic64_read(&current->mm->locked_vm);
 	if ((locked > lock_limit) && (!capable(CAP_IPC_LOCK))) {
 		/*
 		 * It is possible that the regions requested intersect with
diff --git a/mm/mmap.c b/mm/mmap.c
index c65bd5a7f80b..17bd229f820b 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1319,7 +1319,7 @@ static inline int mlock_future_check(struct mm_struct *mm,
 	/*  mlock MCL_FUTURE? */
 	if (flags & VM_LOCKED) {
 		locked = len >> PAGE_SHIFT;
-		locked += mm->locked_vm;
+		locked += atomic64_read(&mm->locked_vm);
 		lock_limit = rlimit(RLIMIT_MEMLOCK);
 		lock_limit >>= PAGE_SHIFT;
 		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
@@ -1812,7 +1812,7 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 					vma == get_gate_vma(current->mm))
 			vma->vm_flags &= VM_LOCKED_CLEAR_MASK;
 		else
-			mm->locked_vm += (len >> PAGE_SHIFT);
+			atomic64_add(len >> PAGE_SHIFT, &mm->locked_vm);
 	}
 
 	if (file)
@@ -2323,7 +2323,7 @@ static int acct_stack_growth(struct vm_area_struct *vma,
 	if (vma->vm_flags & VM_LOCKED) {
 		unsigned long locked;
 		unsigned long limit;
-		locked = mm->locked_vm + grow;
+		locked = atomic64_read(&mm->locked_vm) + grow;
 		limit = rlimit(RLIMIT_MEMLOCK);
 		limit >>= PAGE_SHIFT;
 		if (locked > limit && !capable(CAP_IPC_LOCK))
@@ -2416,7 +2416,7 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 				 */
 				spin_lock(&mm->page_table_lock);
 				if (vma->vm_flags & VM_LOCKED)
-					mm->locked_vm += grow;
+					atomic64_add(grow, &mm->locked_vm);
 				vm_stat_account(mm, vma->vm_flags, grow);
 				anon_vma_interval_tree_pre_update_vma(vma);
 				vma->vm_end = address;
@@ -2496,7 +2496,7 @@ int expand_downwards(struct vm_area_struct *vma,
 				 */
 				spin_lock(&mm->page_table_lock);
 				if (vma->vm_flags & VM_LOCKED)
-					mm->locked_vm += grow;
+					atomic64_add(grow, &mm->locked_vm);
 				vm_stat_account(mm, vma->vm_flags, grow);
 				anon_vma_interval_tree_pre_update_vma(vma);
 				vma->vm_start = address;
@@ -2839,11 +2839,11 @@ int __do_munmap(struct mm_struct *mm, unsigned long start, size_t len,
 	/*
 	 * unlock any mlock()ed ranges before detaching vmas
 	 */
-	if (mm->locked_vm) {
+	if (atomic64_read(&mm->locked_vm)) {
 		struct vm_area_struct *tmp = vma;
 		while (tmp && tmp->vm_start < end) {
 			if (tmp->vm_flags & VM_LOCKED) {
-				mm->locked_vm -= vma_pages(tmp);
+				atomic64_sub(vma_pages(tmp), &mm->locked_vm);
 				munlock_vma_pages_all(tmp);
 			}
 
@@ -3083,7 +3083,7 @@ static int do_brk_flags(unsigned long addr, unsigned long len, unsigned long fla
 	mm->total_vm += len >> PAGE_SHIFT;
 	mm->data_vm += len >> PAGE_SHIFT;
 	if (flags & VM_LOCKED)
-		mm->locked_vm += (len >> PAGE_SHIFT);
+		atomic64_add(len >> PAGE_SHIFT, &mm->locked_vm);
 	vma->vm_flags |= VM_SOFTDIRTY;
 	return 0;
 }
@@ -3155,7 +3155,7 @@ void exit_mmap(struct mm_struct *mm)
 		mmap_write_unlock(mm);
 	}
 
-	if (mm->locked_vm) {
+	if (atomic64_read(&mm->locked_vm)) {
 		vma = mm->mmap;
 		while (vma) {
 			if (vma->vm_flags & VM_LOCKED)
diff --git a/mm/mremap.c b/mm/mremap.c
index 138abbae4f75..451a5a77f82a 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -455,7 +455,7 @@ static unsigned long move_vma(struct vm_area_struct *vma,
 	}
 
 	if (vm_flags & VM_LOCKED) {
-		mm->locked_vm += new_len >> PAGE_SHIFT;
+		atomic64_add(new_len >> PAGE_SHIFT, &mm->locked_vm);
 		*locked = true;
 	}
 out:
@@ -520,7 +520,7 @@ static struct vm_area_struct *vma_to_resize(unsigned long addr,
 
 	if (vma->vm_flags & VM_LOCKED) {
 		unsigned long locked, lock_limit;
-		locked = mm->locked_vm << PAGE_SHIFT;
+		locked = atomic64_read(&mm->locked_vm) << PAGE_SHIFT;
 		lock_limit = rlimit(RLIMIT_MEMLOCK);
 		locked += new_len - old_len;
 		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
@@ -765,7 +765,7 @@ SYSCALL_DEFINE5(mremap, unsigned long, addr, unsigned long, old_len,
 
 			vm_stat_account(mm, vma->vm_flags, pages);
 			if (vma->vm_flags & VM_LOCKED) {
-				mm->locked_vm += pages;
+				atomic64_add(pages, &mm->locked_vm);
 				locked = true;
 				new_addr = addr;
 			}
diff --git a/mm/util.c b/mm/util.c
index 8d6280c05238..473add0dc275 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -439,7 +439,7 @@ int __account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc,
 
 	mmap_assert_write_locked(mm);
 
-	locked_vm = mm->locked_vm;
+	locked_vm = atomic64_read(&mm->locked_vm);
 	if (inc) {
 		if (!bypass_rlim) {
 			limit = task_rlimit(task, RLIMIT_MEMLOCK) >> PAGE_SHIFT;
@@ -447,10 +447,10 @@ int __account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc,
 				ret = -ENOMEM;
 		}
 		if (!ret)
-			mm->locked_vm = locked_vm + pages;
+			atomic64_add(pages, &mm->locked_vm);
 	} else {
 		WARN_ON_ONCE(pages > locked_vm);
-		mm->locked_vm = locked_vm - pages;
+		atomic64_sub(pages, &mm->locked_vm);
 	}
 
 	pr_debug("%s: [%d] caller %ps %c%lu %lu/%lu%s\n", __func__, task->pid,
-- 
2.26.2

