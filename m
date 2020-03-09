Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A113C17DBD8
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 09:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgCIIvf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 04:51:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37908 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726027AbgCIIvf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Mar 2020 04:51:35 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0298nmGb104269
        for <kvm@vger.kernel.org>; Mon, 9 Mar 2020 04:51:34 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ym8mqvv3w-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 04:51:34 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 9 Mar 2020 08:51:32 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 9 Mar 2020 08:51:30 -0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0298oTBt46465474
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Mar 2020 08:50:29 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61E3C11C04C;
        Mon,  9 Mar 2020 08:51:28 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BAB911C058;
        Mon,  9 Mar 2020 08:51:28 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon,  9 Mar 2020 08:51:28 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id EDC7AE0269; Mon,  9 Mar 2020 09:51:27 +0100 (CET)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     KVM <kvm@vger.kernel.org>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Ulrich Weigand <uweigand@de.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL 03/36] s390/mm: provide memory management functions for protected KVM guests
Date:   Mon,  9 Mar 2020 09:50:53 +0100
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309085126.3334302-1-borntraeger@de.ibm.com>
References: <20200309085126.3334302-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20030908-4275-0000-0000-000003A9B366
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030908-4276-0000-0000-000038BEC924
Message-Id: <20200309085126.3334302-4-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-09_02:2020-03-06,2020-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 mlxlogscore=722 mlxscore=0
 suspectscore=2 malwarescore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2003090066
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

This provides the basic ultravisor calls and page table handling to cope
with secure guests:
- provide arch_make_page_accessible
- make pages accessible after unmapping of secure guests
- provide the ultravisor commands convert to/from secure
- provide the ultravisor commands pin/unpin shared
- provide callbacks to make pages secure (inacccessible)
 - we check for the expected pin count to only make pages secure if the
   host is not accessing them
 - we fence hugetlbfs for secure pages
- add missing radix-tree include into gmap.h

The basic idea is that a page can have 3 states: secure, normal or
shared. The hypervisor can call into a firmware function called
ultravisor that allows to change the state of a page: convert from/to
secure. The convert from secure will encrypt the page and make it
available to the host and host I/O. The convert to secure will remove
the host capability to access this page.
The design is that on convert to secure we will wait until writeback and
page refs are indicating no host usage. At the same time the convert
from secure (export to host) will be called in common code when the
refcount or the writeback bit is already set. This avoids races between
convert from and to secure.

Then there is also the concept of shared pages. Those are kind of secure
where the host can still access those pages. We need to be notified when
the guest "unshares" such a page, basically doing a convert to secure by
then. There is a call "pin shared page" that we use instead of convert
from secure when possible.

We do use PG_arch_1 as an optimization to minimize the convert from
secure/pin shared.

Several comments have been added in the code to explain the logic in
the relevant places.

Co-developed-by: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
Signed-off-by: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
[borntraeger@de.ibm.com: patch merging, splitting, fixing]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/include/asm/gmap.h        |   4 +
 arch/s390/include/asm/mmu.h         |   2 +
 arch/s390/include/asm/mmu_context.h |   1 +
 arch/s390/include/asm/page.h        |   5 +
 arch/s390/include/asm/pgtable.h     |  35 ++++-
 arch/s390/include/asm/uv.h          |  31 ++++
 arch/s390/kernel/uv.c               | 227 ++++++++++++++++++++++++++++
 7 files changed, 300 insertions(+), 5 deletions(-)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index 37f96b6f0e61..3c4926aa78f4 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -9,6 +9,7 @@
 #ifndef _ASM_S390_GMAP_H
 #define _ASM_S390_GMAP_H
 
+#include <linux/radix-tree.h>
 #include <linux/refcount.h>
 
 /* Generic bits for GMAP notification on DAT table entry changes. */
@@ -31,6 +32,7 @@
  * @table: pointer to the page directory
  * @asce: address space control element for gmap page table
  * @pfault_enabled: defines if pfaults are applicable for the guest
+ * @guest_handle: protected virtual machine handle for the ultravisor
  * @host_to_rmap: radix tree with gmap_rmap lists
  * @children: list of shadow gmap structures
  * @pt_list: list of all page tables used in the shadow guest address space
@@ -54,6 +56,8 @@ struct gmap {
 	unsigned long asce_end;
 	void *private;
 	bool pfault_enabled;
+	/* only set for protected virtual machines */
+	unsigned long guest_handle;
 	/* Additional data for shadow guest address spaces */
 	struct radix_tree_root host_to_rmap;
 	struct list_head children;
diff --git a/arch/s390/include/asm/mmu.h b/arch/s390/include/asm/mmu.h
index bcfb6371086f..e21b618ad432 100644
--- a/arch/s390/include/asm/mmu.h
+++ b/arch/s390/include/asm/mmu.h
@@ -16,6 +16,8 @@ typedef struct {
 	unsigned long asce;
 	unsigned long asce_limit;
 	unsigned long vdso_base;
+	/* The mmu context belongs to a secure guest. */
+	atomic_t is_protected;
 	/*
 	 * The following bitfields need a down_write on the mm
 	 * semaphore when they are written to. As they are only
diff --git a/arch/s390/include/asm/mmu_context.h b/arch/s390/include/asm/mmu_context.h
index 8d04e6f3f796..afa836014076 100644
--- a/arch/s390/include/asm/mmu_context.h
+++ b/arch/s390/include/asm/mmu_context.h
@@ -23,6 +23,7 @@ static inline int init_new_context(struct task_struct *tsk,
 	INIT_LIST_HEAD(&mm->context.gmap_list);
 	cpumask_clear(&mm->context.cpu_attach_mask);
 	atomic_set(&mm->context.flush_count, 0);
+	atomic_set(&mm->context.is_protected, 0);
 	mm->context.gmap_asce = 0;
 	mm->context.flush_mm = 0;
 	mm->context.compat_mm = test_thread_flag(TIF_31BIT);
diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
index 85e944f04c70..4ebcf891ff3c 100644
--- a/arch/s390/include/asm/page.h
+++ b/arch/s390/include/asm/page.h
@@ -153,6 +153,11 @@ static inline int devmem_is_allowed(unsigned long pfn)
 #define HAVE_ARCH_FREE_PAGE
 #define HAVE_ARCH_ALLOC_PAGE
 
+#if IS_ENABLED(CONFIG_PGSTE)
+int arch_make_page_accessible(struct page *page);
+#define HAVE_ARCH_MAKE_PAGE_ACCESSIBLE
+#endif
+
 #endif /* !__ASSEMBLY__ */
 
 #define __PAGE_OFFSET		0x0UL
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 137a3920ca36..cc7a1adacb94 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -19,6 +19,7 @@
 #include <linux/atomic.h>
 #include <asm/bug.h>
 #include <asm/page.h>
+#include <asm/uv.h>
 
 extern pgd_t swapper_pg_dir[];
 extern void paging_init(void);
@@ -520,6 +521,15 @@ static inline int mm_has_pgste(struct mm_struct *mm)
 	return 0;
 }
 
+static inline int mm_is_protected(struct mm_struct *mm)
+{
+#ifdef CONFIG_PGSTE
+	if (unlikely(atomic_read(&mm->context.is_protected)))
+		return 1;
+#endif
+	return 0;
+}
+
 static inline int mm_alloc_pgste(struct mm_struct *mm)
 {
 #ifdef CONFIG_PGSTE
@@ -1061,7 +1071,12 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 				       unsigned long addr, pte_t *ptep)
 {
-	return ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
+	pte_t res;
+
+	res = ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
+	if (mm_is_protected(mm) && pte_present(res))
+		uv_convert_from_secure(pte_val(res) & PAGE_MASK);
+	return res;
 }
 
 #define __HAVE_ARCH_PTEP_MODIFY_PROT_TRANSACTION
@@ -1073,7 +1088,12 @@ void ptep_modify_prot_commit(struct vm_area_struct *, unsigned long,
 static inline pte_t ptep_clear_flush(struct vm_area_struct *vma,
 				     unsigned long addr, pte_t *ptep)
 {
-	return ptep_xchg_direct(vma->vm_mm, addr, ptep, __pte(_PAGE_INVALID));
+	pte_t res;
+
+	res = ptep_xchg_direct(vma->vm_mm, addr, ptep, __pte(_PAGE_INVALID));
+	if (mm_is_protected(vma->vm_mm) && pte_present(res))
+		uv_convert_from_secure(pte_val(res) & PAGE_MASK);
+	return res;
 }
 
 /*
@@ -1088,12 +1108,17 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
 					    unsigned long addr,
 					    pte_t *ptep, int full)
 {
+	pte_t res;
+
 	if (full) {
-		pte_t pte = *ptep;
+		res = *ptep;
 		*ptep = __pte(_PAGE_INVALID);
-		return pte;
+	} else {
+		res = ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
 	}
-	return ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
+	if (mm_is_protected(mm) && pte_present(res))
+		uv_convert_from_secure(pte_val(res) & PAGE_MASK);
+	return res;
 }
 
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 1af6ce8023cc..d089a960b3e2 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -15,6 +15,7 @@
 #include <linux/errno.h>
 #include <linux/bug.h>
 #include <asm/page.h>
+#include <asm/gmap.h>
 
 #define UVC_RC_EXECUTED		0x0001
 #define UVC_RC_INV_CMD		0x0002
@@ -24,6 +25,10 @@
 
 #define UVC_CMD_QUI			0x0001
 #define UVC_CMD_INIT_UV			0x000f
+#define UVC_CMD_CONV_TO_SEC_STOR	0x0200
+#define UVC_CMD_CONV_FROM_SEC_STOR	0x0201
+#define UVC_CMD_PIN_PAGE_SHARED		0x0341
+#define UVC_CMD_UNPIN_PAGE_SHARED	0x0342
 #define UVC_CMD_SET_SHARED_ACCESS	0x1000
 #define UVC_CMD_REMOVE_SHARED_ACCESS	0x1001
 
@@ -31,8 +36,12 @@
 enum uv_cmds_inst {
 	BIT_UVC_CMD_QUI = 0,
 	BIT_UVC_CMD_INIT_UV = 1,
+	BIT_UVC_CMD_CONV_TO_SEC_STOR = 6,
+	BIT_UVC_CMD_CONV_FROM_SEC_STOR = 7,
 	BIT_UVC_CMD_SET_SHARED_ACCESS = 8,
 	BIT_UVC_CMD_REMOVE_SHARED_ACCESS = 9,
+	BIT_UVC_CMD_PIN_PAGE_SHARED = 21,
+	BIT_UVC_CMD_UNPIN_PAGE_SHARED = 22,
 };
 
 struct uv_cb_header {
@@ -69,6 +78,19 @@ struct uv_cb_init {
 	u64 reserved28[4];
 } __packed __aligned(8);
 
+struct uv_cb_cts {
+	struct uv_cb_header header;
+	u64 reserved08[2];
+	u64 guest_handle;
+	u64 gaddr;
+} __packed __aligned(8);
+
+struct uv_cb_cfs {
+	struct uv_cb_header header;
+	u64 reserved08[2];
+	u64 paddr;
+} __packed __aligned(8);
+
 struct uv_cb_share {
 	struct uv_cb_header header;
 	u64 reserved08[3];
@@ -171,12 +193,21 @@ static inline int is_prot_virt_host(void)
 	return prot_virt_host;
 }
 
+int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb);
+int uv_convert_from_secure(unsigned long paddr);
+int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr);
+
 void setup_uv(void);
 void adjust_to_uv_max(unsigned long *vmax);
 #else
 #define is_prot_virt_host() 0
 static inline void setup_uv(void) {}
 static inline void adjust_to_uv_max(unsigned long *vmax) {}
+
+static inline int uv_convert_from_secure(unsigned long paddr)
+{
+	return 0;
+}
 #endif
 
 #if defined(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) || IS_ENABLED(CONFIG_KVM)
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index 1ddc42154ef6..4539003dac9d 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -12,6 +12,8 @@
 #include <linux/sizes.h>
 #include <linux/bitmap.h>
 #include <linux/memblock.h>
+#include <linux/pagemap.h>
+#include <linux/swap.h>
 #include <asm/facility.h>
 #include <asm/sections.h>
 #include <asm/uv.h>
@@ -97,4 +99,229 @@ void adjust_to_uv_max(unsigned long *vmax)
 {
 	*vmax = min_t(unsigned long, *vmax, uv_info.max_sec_stor_addr);
 }
+
+/*
+ * Requests the Ultravisor to pin the page in the shared state. This will
+ * cause an intercept when the guest attempts to unshare the pinned page.
+ */
+static int uv_pin_shared(unsigned long paddr)
+{
+	struct uv_cb_cfs uvcb = {
+		.header.cmd = UVC_CMD_PIN_PAGE_SHARED,
+		.header.len = sizeof(uvcb),
+		.paddr = paddr,
+	};
+
+	if (uv_call(0, (u64)&uvcb))
+		return -EINVAL;
+	return 0;
+}
+
+/*
+ * Requests the Ultravisor to encrypt a guest page and make it
+ * accessible to the host for paging (export).
+ *
+ * @paddr: Absolute host address of page to be exported
+ */
+int uv_convert_from_secure(unsigned long paddr)
+{
+	struct uv_cb_cfs uvcb = {
+		.header.cmd = UVC_CMD_CONV_FROM_SEC_STOR,
+		.header.len = sizeof(uvcb),
+		.paddr = paddr
+	};
+
+	if (uv_call(0, (u64)&uvcb))
+		return -EINVAL;
+	return 0;
+}
+
+/*
+ * Calculate the expected ref_count for a page that would otherwise have no
+ * further pins. This was cribbed from similar functions in other places in
+ * the kernel, but with some slight modifications. We know that a secure
+ * page can not be a huge page for example.
+ */
+static int expected_page_refs(struct page *page)
+{
+	int res;
+
+	res = page_mapcount(page);
+	if (PageSwapCache(page)) {
+		res++;
+	} else if (page_mapping(page)) {
+		res++;
+		if (page_has_private(page))
+			res++;
+	}
+	return res;
+}
+
+static int make_secure_pte(pte_t *ptep, unsigned long addr,
+			   struct page *exp_page, struct uv_cb_header *uvcb)
+{
+	pte_t entry = READ_ONCE(*ptep);
+	struct page *page;
+	int expected, rc = 0;
+
+	if (!pte_present(entry))
+		return -ENXIO;
+	if (pte_val(entry) & _PAGE_INVALID)
+		return -ENXIO;
+
+	page = pte_page(entry);
+	if (page != exp_page)
+		return -ENXIO;
+	if (PageWriteback(page))
+		return -EAGAIN;
+	expected = expected_page_refs(page);
+	if (!page_ref_freeze(page, expected))
+		return -EBUSY;
+	set_bit(PG_arch_1, &page->flags);
+	rc = uv_call(0, (u64)uvcb);
+	page_ref_unfreeze(page, expected);
+	/* Return -ENXIO if the page was not mapped, -EINVAL otherwise */
+	if (rc)
+		rc = uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
+	return rc;
+}
+
+/*
+ * Requests the Ultravisor to make a page accessible to a guest.
+ * If it's brought in the first time, it will be cleared. If
+ * it has been exported before, it will be decrypted and integrity
+ * checked.
+ */
+int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
+{
+	struct vm_area_struct *vma;
+	bool local_drain = false;
+	spinlock_t *ptelock;
+	unsigned long uaddr;
+	struct page *page;
+	pte_t *ptep;
+	int rc;
+
+again:
+	rc = -EFAULT;
+	down_read(&gmap->mm->mmap_sem);
+
+	uaddr = __gmap_translate(gmap, gaddr);
+	if (IS_ERR_VALUE(uaddr))
+		goto out;
+	vma = find_vma(gmap->mm, uaddr);
+	if (!vma)
+		goto out;
+	/*
+	 * Secure pages cannot be huge and userspace should not combine both.
+	 * In case userspace does it anyway this will result in an -EFAULT for
+	 * the unpack. The guest is thus never reaching secure mode. If
+	 * userspace is playing dirty tricky with mapping huge pages later
+	 * on this will result in a segmentation fault.
+	 */
+	if (is_vm_hugetlb_page(vma))
+		goto out;
+
+	rc = -ENXIO;
+	page = follow_page(vma, uaddr, FOLL_WRITE);
+	if (IS_ERR_OR_NULL(page))
+		goto out;
+
+	lock_page(page);
+	ptep = get_locked_pte(gmap->mm, uaddr, &ptelock);
+	rc = make_secure_pte(ptep, uaddr, page, uvcb);
+	pte_unmap_unlock(ptep, ptelock);
+	unlock_page(page);
+out:
+	up_read(&gmap->mm->mmap_sem);
+
+	if (rc == -EAGAIN) {
+		wait_on_page_writeback(page);
+	} else if (rc == -EBUSY) {
+		/*
+		 * If we have tried a local drain and the page refcount
+		 * still does not match our expected safe value, try with a
+		 * system wide drain. This is needed if the pagevecs holding
+		 * the page are on a different CPU.
+		 */
+		if (local_drain) {
+			lru_add_drain_all();
+			/* We give up here, and let the caller try again */
+			return -EAGAIN;
+		}
+		/*
+		 * We are here if the page refcount does not match the
+		 * expected safe value. The main culprits are usually
+		 * pagevecs. With lru_add_drain() we drain the pagevecs
+		 * on the local CPU so that hopefully the refcount will
+		 * reach the expected safe value.
+		 */
+		lru_add_drain();
+		local_drain = true;
+		/* And now we try again immediately after draining */
+		goto again;
+	} else if (rc == -ENXIO) {
+		if (gmap_fault(gmap, gaddr, FAULT_FLAG_WRITE))
+			return -EFAULT;
+		return -EAGAIN;
+	}
+	return rc;
+}
+EXPORT_SYMBOL_GPL(gmap_make_secure);
+
+int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr)
+{
+	struct uv_cb_cts uvcb = {
+		.header.cmd = UVC_CMD_CONV_TO_SEC_STOR,
+		.header.len = sizeof(uvcb),
+		.guest_handle = gmap->guest_handle,
+		.gaddr = gaddr,
+	};
+
+	return gmap_make_secure(gmap, gaddr, &uvcb);
+}
+EXPORT_SYMBOL_GPL(gmap_convert_to_secure);
+
+/*
+ * To be called with the page locked or with an extra reference! This will
+ * prevent gmap_make_secure from touching the page concurrently. Having 2
+ * parallel make_page_accessible is fine, as the UV calls will become a
+ * no-op if the page is already exported.
+ */
+int arch_make_page_accessible(struct page *page)
+{
+	int rc = 0;
+
+	/* Hugepage cannot be protected, so nothing to do */
+	if (PageHuge(page))
+		return 0;
+
+	/*
+	 * PG_arch_1 is used in 3 places:
+	 * 1. for kernel page tables during early boot
+	 * 2. for storage keys of huge pages and KVM
+	 * 3. As an indication that this page might be secure. This can
+	 *    overindicate, e.g. we set the bit before calling
+	 *    convert_to_secure.
+	 * As secure pages are never huge, all 3 variants can co-exists.
+	 */
+	if (!test_bit(PG_arch_1, &page->flags))
+		return 0;
+
+	rc = uv_pin_shared(page_to_phys(page));
+	if (!rc) {
+		clear_bit(PG_arch_1, &page->flags);
+		return 0;
+	}
+
+	rc = uv_convert_from_secure(page_to_phys(page));
+	if (!rc) {
+		clear_bit(PG_arch_1, &page->flags);
+		return 0;
+	}
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(arch_make_page_accessible);
+
 #endif
-- 
2.24.1

