Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D9C22DD1E
	for <lists+kvm@lfdr.de>; Sun, 26 Jul 2020 10:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgGZIDI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Jul 2020 04:03:08 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:35233 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbgGZIDI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Jul 2020 04:03:08 -0400
Received: from localhost.localdomain (unknown [180.110.142.179])
        (Authenticated sender: fly@kernel.page)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 107BC100007;
        Sun, 26 Jul 2020 08:02:59 +0000 (UTC)
From:   Pengfei Li <fly@kernel.page>
To:     akpm@linux-foundation.org
Cc:     bmt@zurich.ibm.com, dledford@redhat.com, willy@infradead.org,
        vbabka@suse.cz, kirill.shutemov@linux.intel.com, jgg@ziepe.ca,
        alex.williamson@redhat.com, cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Pengfei Li <fly@kernel.page>
Subject: [PATCH 2/2] mm, util: account_locked_vm() does not hold mmap_lock
Date:   Sun, 26 Jul 2020 16:02:24 +0800
Message-Id: <20200726080224.205470-2-fly@kernel.page>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200726080224.205470-1-fly@kernel.page>
References: <20200726080224.205470-1-fly@kernel.page>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since mm->locked_vm is already an atomic counter, account_locked_vm()
does not need to hold mmap_lock.

Signed-off-by: Pengfei Li <fly@kernel.page>
---
 drivers/vfio/vfio_iommu_type1.c |  8 ++------
 mm/util.c                       | 15 +++------------
 2 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 78013be07fe7..53818fce78a6 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -376,12 +376,8 @@ static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
 	if (!mm)
 		return -ESRCH; /* process exited */
 
-	ret = mmap_write_lock_killable(mm);
-	if (!ret) {
-		ret = __account_locked_vm(mm, abs(npage), npage > 0, dma->task,
-					  dma->lock_cap);
-		mmap_write_unlock(mm);
-	}
+	ret = __account_locked_vm(mm, abs(npage), npage > 0,
+					dma->task, dma->lock_cap);
 
 	if (async)
 		mmput(mm);
diff --git a/mm/util.c b/mm/util.c
index 473add0dc275..320fdd537aea 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -424,8 +424,7 @@ void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
  * @task:        task used to check RLIMIT_MEMLOCK
  * @bypass_rlim: %true if checking RLIMIT_MEMLOCK should be skipped
  *
- * Assumes @task and @mm are valid (i.e. at least one reference on each), and
- * that mmap_lock is held as writer.
+ * Assumes @task and @mm are valid (i.e. at least one reference on each).
  *
  * Return:
  * * 0       on success
@@ -437,8 +436,6 @@ int __account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc,
 	unsigned long locked_vm, limit;
 	int ret = 0;
 
-	mmap_assert_write_locked(mm);
-
 	locked_vm = atomic64_read(&mm->locked_vm);
 	if (inc) {
 		if (!bypass_rlim) {
@@ -476,17 +473,11 @@ EXPORT_SYMBOL_GPL(__account_locked_vm);
  */
 int account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc)
 {
-	int ret;
-
 	if (pages == 0 || !mm)
 		return 0;
 
-	mmap_write_lock(mm);
-	ret = __account_locked_vm(mm, pages, inc, current,
-				  capable(CAP_IPC_LOCK));
-	mmap_write_unlock(mm);
-
-	return ret;
+	return __account_locked_vm(mm, pages, inc,
+					current, capable(CAP_IPC_LOCK));
 }
 EXPORT_SYMBOL_GPL(account_locked_vm);
 
-- 
2.26.2

