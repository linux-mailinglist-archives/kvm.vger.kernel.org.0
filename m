Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 194AF1345D
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 22:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfECUUh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 16:20:37 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57966 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbfECUUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 16:20:37 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x43KEIGQ123066;
        Fri, 3 May 2019 20:19:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : content-type :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=NBf0VXWy2aRMKYEnL9KebROCy7Bu40HpC3c3T+lz8wo=;
 b=TnscqanTJfLG+rMhABQlj2zRbqxybUldb0Mxlr2pbtzuwJ96o0DA3Tdex6Ch/agNjwtw
 gKIGlcjA2wjYJy95+6yi89Rb24w9W7Sjn86CtZb0MN5t/jNAYxT7VoozlkJjMdZfS3w/
 1aCt+4qYy8MHSTNFczeYdSipaDE8ue9FQjo2OIVTS9VJFWG/eR7gnrCwQYkvnNZ/Pxdz
 wgYmCOfIENhELvg824YMA9cEXc2uLYLGvD2aYy2DDh80Rc0zuus5JzH48ZI4EYxwwrT6
 VoigNdQcpkqwpDhVZI8tWQFRGNo6bu0wMLXKAPZtn5yc68m/gauGzGCgzZ8w/8PIISFd nw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2s6xj01131-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 May 2019 20:19:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x43KGq3h044042;
        Fri, 3 May 2019 20:17:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2s7rtcfwg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 May 2019 20:17:36 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x43KHNuF021889;
        Fri, 3 May 2019 20:17:24 GMT
Received: from localhost.localdomain (/73.60.114.248) by default (Oracle
 Beehive Gateway v4.0) with ESMTP ; Fri, 03 May 2019 13:16:52 -0700
MIME-Version: 1.0
Message-ID: <20190503201629.20512-1-daniel.m.jordan@oracle.com>
Date:   Fri, 3 May 2019 13:16:30 -0700 (PDT)
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     akpm@linux-foundation.org
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Alan Tull <atull@kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christoph Lameter <cl@linux.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Moritz Fischer <mdf@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Steve Sistare <steven.sistare@oracle.com>,
        Wu Hao <hao.wu@intel.com>, linux-mm@kvack.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-fpga@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm: add account_locked_vm utility function
X-Mailer: git-send-email 2.21.0
Content-Type: text/plain; charset=ascii
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9245 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=8 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905030132
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9245 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905030133
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

locked_vm accounting is done roughly the same way in five places, so
unify them in a helper.  Standardize the debug prints, which vary
slightly.  Error codes stay the same, so user-visible behavior does too.

Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Alan Tull <atull@kernel.org>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Moritz Fischer <mdf@kernel.org>
Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: Steve Sistare <steven.sistare@oracle.com>
Cc: Wu Hao <hao.wu@intel.com>
Cc: linux-mm@kvack.org
Cc: kvm@vger.kernel.org
Cc: kvm-ppc@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-fpga@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---

Based on v5.1-rc7.  Tested with the vfio type1 driver.  Any feedback
welcome.

Andrew, this one patch replaces these six from [1]:

    mm-change-locked_vms-type-from-unsigned-long-to-atomic64_t.patch
    vfio-type1-drop-mmap_sem-now-that-locked_vm-is-atomic.patch
    vfio-spapr_tce-drop-mmap_sem-now-that-locked_vm-is-atomic.patch
    fpga-dlf-afu-drop-mmap_sem-now-that-locked_vm-is-atomic.patch
    kvm-book3s-drop-mmap_sem-now-that-locked_vm-is-atomic.patch
    powerpc-mmu-drop-mmap_sem-now-that-locked_vm-is-atomic.patch

That series converts locked_vm to an atomic, but on closer inspection causes at
least one accounting race in mremap, and fixing it just for this type
conversion came with too much ugly in the core mm to justify, especially when
the right long-term fix is making these drivers use pinned_vm instead.

Christophe's suggestion of cmpxchg[2] does prevent the races he
mentioned for pinned_vm, but others would still remain.  In perf_mmap
and the hfi1 driver, pinned_vm is checked against the rlimit racily and
then later increased when the pinned_vm originally read may have gone
stale.  Any fixes for that, that I could think of, seem about as good as
what's there now, so I left it.  I have a patch that uses cmpxchg with
pinned_vm if others feel strongly that the aforementioned races should
be fixed.

Daniel

[1] https://lore.kernel.org/linux-mm/20190402204158.27582-1-daniel.m.jordan@oracle.com/
[2] https://lore.kernel.org/linux-mm/964bd5b0-f1e5-7bf0-5c58-18e75c550841@c-s.fr/

 arch/powerpc/kvm/book3s_64_vio.c    | 44 +++---------------------
 arch/powerpc/mm/mmu_context_iommu.c | 41 +++-------------------
 drivers/fpga/dfl-afu-dma-region.c   | 53 +++--------------------------
 drivers/vfio/vfio_iommu_spapr_tce.c | 52 +++++-----------------------
 drivers/vfio/vfio_iommu_type1.c     | 23 ++++---------
 include/linux/mm.h                  | 19 +++++++++++
 mm/util.c                           | 48 ++++++++++++++++++++++++++
 7 files changed, 94 insertions(+), 186 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_64_vio.c b/arch/powerpc/kvm/book3s_64_vio.c
index f02b04973710..f7d37fa6003a 100644
--- a/arch/powerpc/kvm/book3s_64_vio.c
+++ b/arch/powerpc/kvm/book3s_64_vio.c
@@ -30,6 +30,7 @@
 #include <linux/anon_inodes.h>
 #include <linux/iommu.h>
 #include <linux/file.h>
+#include <linux/mm.h>
 
 #include <asm/kvm_ppc.h>
 #include <asm/kvm_book3s.h>
@@ -56,43 +57,6 @@ static unsigned long kvmppc_stt_pages(unsigned long tce_pages)
 	return tce_pages + ALIGN(stt_bytes, PAGE_SIZE) / PAGE_SIZE;
 }
 
-static long kvmppc_account_memlimit(unsigned long stt_pages, bool inc)
-{
-	long ret = 0;
-
-	if (!current || !current->mm)
-		return ret; /* process exited */
-
-	down_write(&current->mm->mmap_sem);
-
-	if (inc) {
-		unsigned long locked, lock_limit;
-
-		locked = current->mm->locked_vm + stt_pages;
-		lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
-			ret = -ENOMEM;
-		else
-			current->mm->locked_vm += stt_pages;
-	} else {
-		if (WARN_ON_ONCE(stt_pages > current->mm->locked_vm))
-			stt_pages = current->mm->locked_vm;
-
-		current->mm->locked_vm -= stt_pages;
-	}
-
-	pr_debug("[%d] RLIMIT_MEMLOCK KVM %c%ld %ld/%ld%s\n", current->pid,
-			inc ? '+' : '-',
-			stt_pages << PAGE_SHIFT,
-			current->mm->locked_vm << PAGE_SHIFT,
-			rlimit(RLIMIT_MEMLOCK),
-			ret ? " - exceeded" : "");
-
-	up_write(&current->mm->mmap_sem);
-
-	return ret;
-}
-
 static void kvm_spapr_tce_iommu_table_free(struct rcu_head *head)
 {
 	struct kvmppc_spapr_tce_iommu_table *stit = container_of(head,
@@ -277,7 +241,7 @@ static int kvm_spapr_tce_release(struct inode *inode, struct file *filp)
 
 	kvm_put_kvm(stt->kvm);
 
-	kvmppc_account_memlimit(
+	account_locked_vm(current->mm,
 		kvmppc_stt_pages(kvmppc_tce_pages(stt->size)), false);
 	call_rcu(&stt->rcu, release_spapr_tce_table);
 
@@ -303,7 +267,7 @@ long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
 		return -EINVAL;
 
 	npages = kvmppc_tce_pages(size);
-	ret = kvmppc_account_memlimit(kvmppc_stt_pages(npages), true);
+	ret = account_locked_vm(current->mm, kvmppc_stt_pages(npages), true);
 	if (ret)
 		return ret;
 
@@ -359,7 +323,7 @@ long kvm_vm_ioctl_create_spapr_tce(struct kvm *kvm,
 
 	kfree(stt);
  fail_acct:
-	kvmppc_account_memlimit(kvmppc_stt_pages(npages), false);
+	account_locked_vm(current->mm, kvmppc_stt_pages(npages), false);
 	return ret;
 }
 
diff --git a/arch/powerpc/mm/mmu_context_iommu.c b/arch/powerpc/mm/mmu_context_iommu.c
index 8330f135294f..9e7001a70570 100644
--- a/arch/powerpc/mm/mmu_context_iommu.c
+++ b/arch/powerpc/mm/mmu_context_iommu.c
@@ -19,6 +19,7 @@
 #include <linux/hugetlb.h>
 #include <linux/swap.h>
 #include <linux/sizes.h>
+#include <linux/mm.h>
 #include <asm/mmu_context.h>
 #include <asm/pte-walk.h>
 #include <linux/mm_inline.h>
@@ -51,40 +52,6 @@ struct mm_iommu_table_group_mem_t {
 	u64 dev_hpa;		/* Device memory base address */
 };
 
-static long mm_iommu_adjust_locked_vm(struct mm_struct *mm,
-		unsigned long npages, bool incr)
-{
-	long ret = 0, locked, lock_limit;
-
-	if (!npages)
-		return 0;
-
-	down_write(&mm->mmap_sem);
-
-	if (incr) {
-		locked = mm->locked_vm + npages;
-		lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
-			ret = -ENOMEM;
-		else
-			mm->locked_vm += npages;
-	} else {
-		if (WARN_ON_ONCE(npages > mm->locked_vm))
-			npages = mm->locked_vm;
-		mm->locked_vm -= npages;
-	}
-
-	pr_debug("[%d] RLIMIT_MEMLOCK HASH64 %c%ld %ld/%ld\n",
-			current ? current->pid : 0,
-			incr ? '+' : '-',
-			npages << PAGE_SHIFT,
-			mm->locked_vm << PAGE_SHIFT,
-			rlimit(RLIMIT_MEMLOCK));
-	up_write(&mm->mmap_sem);
-
-	return ret;
-}
-
 bool mm_iommu_preregistered(struct mm_struct *mm)
 {
 	return !list_empty(&mm->context.iommu_group_mem_list);
@@ -101,7 +68,7 @@ static long mm_iommu_do_alloc(struct mm_struct *mm, unsigned long ua,
 	unsigned long entry, chunk;
 
 	if (dev_hpa == MM_IOMMU_TABLE_INVALID_HPA) {
-		ret = mm_iommu_adjust_locked_vm(mm, entries, true);
+		ret = account_locked_vm(mm, entries, true);
 		if (ret)
 			return ret;
 
@@ -215,7 +182,7 @@ static long mm_iommu_do_alloc(struct mm_struct *mm, unsigned long ua,
 	kfree(mem);
 
 unlock_exit:
-	mm_iommu_adjust_locked_vm(mm, locked_entries, false);
+	account_locked_vm(mm, locked_entries, false);
 
 	return ret;
 }
@@ -315,7 +282,7 @@ long mm_iommu_put(struct mm_struct *mm, struct mm_iommu_table_group_mem_t *mem)
 unlock_exit:
 	mutex_unlock(&mem_list_mutex);
 
-	mm_iommu_adjust_locked_vm(mm, unlock_entries, false);
+	account_locked_vm(mm, unlock_entries, false);
 
 	return ret;
 }
diff --git a/drivers/fpga/dfl-afu-dma-region.c b/drivers/fpga/dfl-afu-dma-region.c
index e18a786fc943..059438e17193 100644
--- a/drivers/fpga/dfl-afu-dma-region.c
+++ b/drivers/fpga/dfl-afu-dma-region.c
@@ -12,6 +12,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/sched/signal.h>
 #include <linux/uaccess.h>
+#include <linux/mm.h>
 
 #include "dfl-afu.h"
 
@@ -31,52 +32,6 @@ void afu_dma_region_init(struct dfl_feature_platform_data *pdata)
 	afu->dma_regions = RB_ROOT;
 }
 
-/**
- * afu_dma_adjust_locked_vm - adjust locked memory
- * @dev: port device
- * @npages: number of pages
- * @incr: increase or decrease locked memory
- *
- * Increase or decrease the locked memory size with npages input.
- *
- * Return 0 on success.
- * Return -ENOMEM if locked memory size is over the limit and no CAP_IPC_LOCK.
- */
-static int afu_dma_adjust_locked_vm(struct device *dev, long npages, bool incr)
-{
-	unsigned long locked, lock_limit;
-	int ret = 0;
-
-	/* the task is exiting. */
-	if (!current->mm)
-		return 0;
-
-	down_write(&current->mm->mmap_sem);
-
-	if (incr) {
-		locked = current->mm->locked_vm + npages;
-		lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-
-		if (locked > lock_limit && !capable(CAP_IPC_LOCK))
-			ret = -ENOMEM;
-		else
-			current->mm->locked_vm += npages;
-	} else {
-		if (WARN_ON_ONCE(npages > current->mm->locked_vm))
-			npages = current->mm->locked_vm;
-		current->mm->locked_vm -= npages;
-	}
-
-	dev_dbg(dev, "[%d] RLIMIT_MEMLOCK %c%ld %ld/%ld%s\n", current->pid,
-		incr ? '+' : '-', npages << PAGE_SHIFT,
-		current->mm->locked_vm << PAGE_SHIFT, rlimit(RLIMIT_MEMLOCK),
-		ret ? "- exceeded" : "");
-
-	up_write(&current->mm->mmap_sem);
-
-	return ret;
-}
-
 /**
  * afu_dma_pin_pages - pin pages of given dma memory region
  * @pdata: feature device platform data
@@ -92,7 +47,7 @@ static int afu_dma_pin_pages(struct dfl_feature_platform_data *pdata,
 	struct device *dev = &pdata->dev->dev;
 	int ret, pinned;
 
-	ret = afu_dma_adjust_locked_vm(dev, npages, true);
+	ret = account_locked_vm(current->mm, npages, true);
 	if (ret)
 		return ret;
 
@@ -121,7 +76,7 @@ static int afu_dma_pin_pages(struct dfl_feature_platform_data *pdata,
 free_pages:
 	kfree(region->pages);
 unlock_vm:
-	afu_dma_adjust_locked_vm(dev, npages, false);
+	account_locked_vm(current->mm, npages, false);
 	return ret;
 }
 
@@ -141,7 +96,7 @@ static void afu_dma_unpin_pages(struct dfl_feature_platform_data *pdata,
 
 	put_all_pages(region->pages, npages);
 	kfree(region->pages);
-	afu_dma_adjust_locked_vm(dev, npages, false);
+	account_locked_vm(current->mm, npages, false);
 
 	dev_dbg(dev, "%ld pages unpinned\n", npages);
 }
diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index 6b64e45a5269..d39a1b830d82 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -22,6 +22,7 @@
 #include <linux/vmalloc.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/signal.h>
+#include <linux/mm.h>
 
 #include <asm/iommu.h>
 #include <asm/tce.h>
@@ -34,49 +35,13 @@
 static void tce_iommu_detach_group(void *iommu_data,
 		struct iommu_group *iommu_group);
 
-static long try_increment_locked_vm(struct mm_struct *mm, long npages)
+static int tce_account_locked_vm(struct mm_struct *mm, unsigned long npages,
+				 bool inc)
 {
-	long ret = 0, locked, lock_limit;
-
 	if (WARN_ON_ONCE(!mm))
 		return -EPERM;
 
-	if (!npages)
-		return 0;
-
-	down_write(&mm->mmap_sem);
-	locked = mm->locked_vm + npages;
-	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-	if (locked > lock_limit && !capable(CAP_IPC_LOCK))
-		ret = -ENOMEM;
-	else
-		mm->locked_vm += npages;
-
-	pr_debug("[%d] RLIMIT_MEMLOCK +%ld %ld/%ld%s\n", current->pid,
-			npages << PAGE_SHIFT,
-			mm->locked_vm << PAGE_SHIFT,
-			rlimit(RLIMIT_MEMLOCK),
-			ret ? " - exceeded" : "");
-
-	up_write(&mm->mmap_sem);
-
-	return ret;
-}
-
-static void decrement_locked_vm(struct mm_struct *mm, long npages)
-{
-	if (!mm || !npages)
-		return;
-
-	down_write(&mm->mmap_sem);
-	if (WARN_ON_ONCE(npages > mm->locked_vm))
-		npages = mm->locked_vm;
-	mm->locked_vm -= npages;
-	pr_debug("[%d] RLIMIT_MEMLOCK -%ld %ld/%ld\n", current->pid,
-			npages << PAGE_SHIFT,
-			mm->locked_vm << PAGE_SHIFT,
-			rlimit(RLIMIT_MEMLOCK));
-	up_write(&mm->mmap_sem);
+	return account_locked_vm(mm, npages, inc);
 }
 
 /*
@@ -336,7 +301,7 @@ static int tce_iommu_enable(struct tce_container *container)
 		return ret;
 
 	locked = table_group->tce32_size >> PAGE_SHIFT;
-	ret = try_increment_locked_vm(container->mm, locked);
+	ret = tce_account_locked_vm(container->mm, locked, true);
 	if (ret)
 		return ret;
 
@@ -355,7 +320,7 @@ static void tce_iommu_disable(struct tce_container *container)
 	container->enabled = false;
 
 	BUG_ON(!container->mm);
-	decrement_locked_vm(container->mm, container->locked_pages);
+	tce_account_locked_vm(container->mm, container->locked_pages, false);
 }
 
 static void *tce_iommu_open(unsigned long arg)
@@ -658,7 +623,8 @@ static long tce_iommu_create_table(struct tce_container *container,
 	if (!table_size)
 		return -EINVAL;
 
-	ret = try_increment_locked_vm(container->mm, table_size >> PAGE_SHIFT);
+	ret = tce_account_locked_vm(container->mm, table_size >> PAGE_SHIFT,
+				    true);
 	if (ret)
 		return ret;
 
@@ -677,7 +643,7 @@ static void tce_iommu_free_table(struct tce_container *container,
 	unsigned long pages = tbl->it_allocated_size >> PAGE_SHIFT;
 
 	iommu_tce_table_put(tbl);
-	decrement_locked_vm(container->mm, pages);
+	tce_account_locked_vm(container->mm, pages, false);
 }
 
 static long tce_iommu_create_window(struct tce_container *container,
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index d0f731c9920a..15ac76171ccd 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -273,25 +273,14 @@ static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
 		return -ESRCH; /* process exited */
 
 	ret = down_write_killable(&mm->mmap_sem);
-	if (!ret) {
-		if (npage > 0) {
-			if (!dma->lock_cap) {
-				unsigned long limit;
-
-				limit = task_rlimit(dma->task,
-						RLIMIT_MEMLOCK) >> PAGE_SHIFT;
-
-				if (mm->locked_vm + npage > limit)
-					ret = -ENOMEM;
-			}
-		}
+	if (ret)
+		goto out;
 
-		if (!ret)
-			mm->locked_vm += npage;
-
-		up_write(&mm->mmap_sem);
-	}
+	ret = __account_locked_vm(mm, abs(npage), npage > 0, dma->task,
+				  dma->lock_cap);
+	up_write(&mm->mmap_sem);
 
+out:
 	if (async)
 		mmput(mm);
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6b10c21630f5..7134e55ca23f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1521,6 +1521,25 @@ static inline long get_user_pages_longterm(unsigned long start,
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages);
 
+int __account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc,
+			struct task_struct *task, bool bypass_rlim);
+
+static inline int account_locked_vm(struct mm_struct *mm, unsigned long pages,
+				    bool inc)
+{
+	int ret;
+
+	if (pages == 0 || !mm)
+		return 0;
+
+	down_write(&mm->mmap_sem);
+	ret = __account_locked_vm(mm, pages, inc, current,
+				  capable(CAP_IPC_LOCK));
+	up_write(&mm->mmap_sem);
+
+	return ret;
+}
+
 /* Container for pinned pfns / pages */
 struct frame_vector {
 	unsigned int nr_allocated;	/* Number of frames we have space for */
diff --git a/mm/util.c b/mm/util.c
index 43a2984bccaa..552302665bc2 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -6,6 +6,7 @@
 #include <linux/err.h>
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
+#include <linux/sched/signal.h>
 #include <linux/sched/task_stack.h>
 #include <linux/security.h>
 #include <linux/swap.h>
@@ -346,6 +347,53 @@ int __weak get_user_pages_fast(unsigned long start,
 }
 EXPORT_SYMBOL_GPL(get_user_pages_fast);
 
+/**
+ * __account_locked_vm - account locked pages to an mm's locked_vm
+ * @mm:          mm to account against, may be NULL
+ * @pages:       number of pages to account
+ * @inc:         %true if @pages should be considered positive, %false if not
+ * @task:        task used to check RLIMIT_MEMLOCK
+ * @bypass_rlim: %true if checking RLIMIT_MEMLOCK should be skipped
+ *
+ * Assumes @task and @mm are valid (i.e. at least one reference on each), and
+ * that mmap_sem is held as writer.
+ *
+ * Return:
+ * * 0       on success
+ * * 0       if @mm is NULL (can happen for example if the task is exiting)
+ * * -ENOMEM if RLIMIT_MEMLOCK would be exceeded.
+ */
+int __account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc,
+			struct task_struct *task, bool bypass_rlim)
+{
+	unsigned long locked_vm, limit;
+	int ret = 0;
+
+	locked_vm = mm->locked_vm;
+	if (inc) {
+		if (!bypass_rlim) {
+			limit = task_rlimit(task, RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+			if (locked_vm + pages > limit) {
+				ret = -ENOMEM;
+				goto out;
+			}
+		}
+		mm->locked_vm = locked_vm + pages;
+	} else {
+		WARN_ON_ONCE(pages > locked_vm);
+		mm->locked_vm = locked_vm - pages;
+	}
+
+out:
+	pr_debug("%s: [%d] %c%lu %lu/%lu%s\n", __func__, task->pid,
+		 (inc) ? '+' : '-', pages << PAGE_SHIFT,
+		 locked_vm << PAGE_SHIFT, task_rlimit(task, RLIMIT_MEMLOCK),
+		 ret ? " - exceeded" : "");
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__account_locked_vm);
+
 unsigned long vm_mmap_pgoff(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long prot,
 	unsigned long flag, unsigned long pgoff)

base-commit: 37624b58542fb9f2d9a70e6ea006ef8a5f66c30b
-- 
2.21.0

