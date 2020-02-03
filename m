Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71EDE1506D8
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 14:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbgBCNUH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 08:20:07 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37598 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727916AbgBCNUF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Feb 2020 08:20:05 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 013DI5PV127766
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 08:20:03 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xxhf6nydk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2020 08:20:03 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 013DI6mj127921
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 08:20:03 -0500
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xxhf6nyd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 08:20:03 -0500
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 013DFTfl008693;
        Mon, 3 Feb 2020 13:20:02 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03dal.us.ibm.com with ESMTP id 2xw0y758yj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 13:20:02 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 013DK0Bh36766066
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Feb 2020 13:20:00 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B675628060;
        Mon,  3 Feb 2020 13:19:58 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E7D628068;
        Mon,  3 Feb 2020 13:19:58 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  3 Feb 2020 13:19:58 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [RFCv2 05/37] s390/mm: provide memory management functions for protected KVM guests
Date:   Mon,  3 Feb 2020 08:19:25 -0500
Message-Id: <20200203131957.383915-6-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200203131957.383915-1-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-03_04:2020-02-02,2020-02-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 mlxlogscore=878 spamscore=0
 malwarescore=0 phishscore=0 bulkscore=0 impostorscore=0 suspectscore=2
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2002030099
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

This provides the basic ultravisor calls and page table handling to cope
with secure guests.

Co-authored-by: Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/gmap.h        |   2 +
 arch/s390/include/asm/mmu.h         |   2 +
 arch/s390/include/asm/mmu_context.h |   1 +
 arch/s390/include/asm/page.h        |   5 +
 arch/s390/include/asm/pgtable.h     |  34 +++++-
 arch/s390/include/asm/uv.h          |  59 ++++++++++
 arch/s390/kernel/uv.c               | 170 ++++++++++++++++++++++++++++
 7 files changed, 268 insertions(+), 5 deletions(-)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index 37f96b6f0e61..f2ab8b6d4b57 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -9,6 +9,7 @@
 #ifndef _ASM_S390_GMAP_H
 #define _ASM_S390_GMAP_H
 
+#include <linux/radix-tree.h>
 #include <linux/refcount.h>
 
 /* Generic bits for GMAP notification on DAT table entry changes. */
@@ -61,6 +62,7 @@ struct gmap {
 	spinlock_t shadow_lock;
 	struct gmap *parent;
 	unsigned long orig_asce;
+	unsigned long se_handle;
 	int edat_level;
 	bool removed;
 	bool initialized;
diff --git a/arch/s390/include/asm/mmu.h b/arch/s390/include/asm/mmu.h
index bcfb6371086f..984026cb3608 100644
--- a/arch/s390/include/asm/mmu.h
+++ b/arch/s390/include/asm/mmu.h
@@ -16,6 +16,8 @@ typedef struct {
 	unsigned long asce;
 	unsigned long asce_limit;
 	unsigned long vdso_base;
+	/* The mmu context belongs to a secure guest. */
+	atomic_t is_se;
 	/*
 	 * The following bitfields need a down_write on the mm
 	 * semaphore when they are written to. As they are only
diff --git a/arch/s390/include/asm/mmu_context.h b/arch/s390/include/asm/mmu_context.h
index 8d04e6f3f796..0e5e67ecdaf8 100644
--- a/arch/s390/include/asm/mmu_context.h
+++ b/arch/s390/include/asm/mmu_context.h
@@ -23,6 +23,7 @@ static inline int init_new_context(struct task_struct *tsk,
 	INIT_LIST_HEAD(&mm->context.gmap_list);
 	cpumask_clear(&mm->context.cpu_attach_mask);
 	atomic_set(&mm->context.flush_count, 0);
+	atomic_set(&mm->context.is_se, 0);
 	mm->context.gmap_asce = 0;
 	mm->context.flush_mm = 0;
 	mm->context.compat_mm = test_thread_flag(TIF_31BIT);
diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
index a4d38092530a..eb209416c45b 100644
--- a/arch/s390/include/asm/page.h
+++ b/arch/s390/include/asm/page.h
@@ -151,6 +151,11 @@ static inline int devmem_is_allowed(unsigned long pfn)
 #define HAVE_ARCH_FREE_PAGE
 #define HAVE_ARCH_ALLOC_PAGE
 
+#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
+int arch_make_page_accessible(struct page *page);
+#define HAVE_ARCH_MAKE_PAGE_ACCESSIBLE
+#endif
+
 #endif /* !__ASSEMBLY__ */
 
 #define __PAGE_OFFSET		0x0UL
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 7b03037a8475..65b6bb47af0a 100644
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
 
+static inline int mm_is_se(struct mm_struct *mm)
+{
+#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
+	if (unlikely(atomic_read(&mm->context.is_se)))
+		return 1;
+#endif
+	return 0;
+}
+
 static inline int mm_alloc_pgste(struct mm_struct *mm)
 {
 #ifdef CONFIG_PGSTE
@@ -1059,7 +1069,12 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 				       unsigned long addr, pte_t *ptep)
 {
-	return ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
+	pte_t res;
+
+	res = ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
+	if (mm_is_se(mm) && pte_present(res))
+		uv_convert_from_secure(pte_val(res) & PAGE_MASK);
+	return res;
 }
 
 #define __HAVE_ARCH_PTEP_MODIFY_PROT_TRANSACTION
@@ -1071,7 +1086,12 @@ void ptep_modify_prot_commit(struct vm_area_struct *, unsigned long,
 static inline pte_t ptep_clear_flush(struct vm_area_struct *vma,
 				     unsigned long addr, pte_t *ptep)
 {
-	return ptep_xchg_direct(vma->vm_mm, addr, ptep, __pte(_PAGE_INVALID));
+	pte_t res;
+
+	res = ptep_xchg_direct(vma->vm_mm, addr, ptep, __pte(_PAGE_INVALID));
+	if (mm_is_se(vma->vm_mm) && pte_present(res))
+		uv_convert_from_secure(pte_val(res) & PAGE_MASK);
+	return res;
 }
 
 /*
@@ -1086,12 +1106,16 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
 					    unsigned long addr,
 					    pte_t *ptep, int full)
 {
+	pte_t res;
 	if (full) {
-		pte_t pte = *ptep;
+		res = *ptep;
 		*ptep = __pte(_PAGE_INVALID);
-		return pte;
+	} else {
+		res = ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
 	}
-	return ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
+	if (mm_is_se(mm) && pte_present(res))
+		uv_convert_from_secure(pte_val(res) & PAGE_MASK);
+	return res;
 }
 
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index cdf2fd71d7ab..4eaea95f5c64 100644
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
@@ -70,6 +79,19 @@ struct uv_cb_init {
 
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
@@ -170,12 +192,49 @@ static inline int is_prot_virt_host(void)
 	return prot_virt_host;
 }
 
+int uv_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb, int pins);
+int uv_convert_from_secure(unsigned long paddr);
+
+static inline int uv_convert_to_secure_pinned(struct gmap *gmap,
+					      unsigned long gaddr,
+					      int pins)
+{
+	struct uv_cb_cts uvcb = {
+		.header.cmd = UVC_CMD_CONV_TO_SEC_STOR,
+		.header.len = sizeof(uvcb),
+		.guest_handle = gmap->se_handle,
+		.gaddr = gaddr,
+	};
+
+	return uv_make_secure(gmap, gaddr, &uvcb, pins);
+}
+
+static inline int uv_convert_to_secure(struct gmap *gmap, unsigned long gaddr)
+{
+	return uv_convert_to_secure_pinned(gmap, gaddr, 0);
+}
+
 void setup_uv(void);
 void adjust_to_uv_max(unsigned long *vmax);
 #else
 #define is_prot_virt_host() 0
 static inline void setup_uv(void) {}
 static inline void adjust_to_uv_max(unsigned long *vmax) {}
+
+static inline int uv_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb, int pins)
+{
+	return 0;
+}
+
+static inline int uv_convert_from_secure(unsigned long paddr)
+{
+	return 0;
+}
+
+static inline int uv_convert_to_secure(struct gmap *gmap, unsigned long gaddr)
+{
+	return 0;
+}
 #endif
 
 #if defined(CONFIG_PROTECTED_VIRTUALIZATION_GUEST) ||                          \
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index f7778493e829..136c60a8e3ca 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -9,6 +9,8 @@
 #include <linux/sizes.h>
 #include <linux/bitmap.h>
 #include <linux/memblock.h>
+#include <linux/pagemap.h>
+#include <linux/swap.h>
 #include <asm/facility.h>
 #include <asm/sections.h>
 #include <asm/uv.h>
@@ -98,4 +100,172 @@ void adjust_to_uv_max(unsigned long *vmax)
 	if (prot_virt_host && *vmax > uv_info.max_sec_stor_addr)
 		*vmax = uv_info.max_sec_stor_addr;
 }
+
+static int __uv_pin_shared(unsigned long paddr)
+{
+	struct uv_cb_cfs uvcb = {
+		.header.cmd	= UVC_CMD_PIN_PAGE_SHARED,
+		.header.len	= sizeof(uvcb),
+		.paddr		= paddr,
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
+	uv_call(0, (u64)&uvcb);
+
+	if (uvcb.header.rc == 1 || uvcb.header.rc == 0x107)
+		return 0;
+	return -EINVAL;
+}
+
+static int expected_page_refs(struct page *page)
+{
+	int res;
+
+	res = page_mapcount(page);
+	if (PageSwapCache(page))
+		res++;
+	else if (page_mapping(page)) {
+		res++;
+		if (page_has_private(page))
+			res++;
+	}
+	return res;
+}
+
+struct conv_params {
+	struct uv_cb_header *uvcb;
+	struct page *page;
+	int extra_pins;
+};
+
+static int make_secure_pte(pte_t *ptep, unsigned long addr, void *data)
+{
+	struct conv_params *params = data;
+	pte_t entry = READ_ONCE(*ptep);
+	struct page *page;
+	int expected, rc = 0;
+
+	if (!pte_present(entry))
+		return -ENXIO;
+	if (pte_val(entry) & (_PAGE_INVALID | _PAGE_PROTECT))
+		return -ENXIO;
+
+	page = pte_page(entry);
+	if (page != params->page)
+		return -ENXIO;
+
+	if (PageWriteback(page))
+		return -EAGAIN;
+	expected = expected_page_refs(page) + params->extra_pins;
+	if (!page_ref_freeze(page, expected))
+		return -EBUSY;
+	set_bit(PG_arch_1, &page->flags);
+	rc = uv_call(0, (u64)params->uvcb);
+	page_ref_unfreeze(page, expected);
+	if (rc)
+		rc = (params->uvcb->rc == 0x10a) ? -ENXIO : -EINVAL;
+	return rc;
+}
+
+/*
+ * Requests the Ultravisor to make a page accessible to a guest.
+ * If it's brought in the first time, it will be cleared. If
+ * it has been exported before, it will be decrypted and integrity
+ * checked.
+ *
+ * @gmap: Guest mapping
+ * @gaddr: Guest 2 absolute address to be imported
+ */
+int uv_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb, int pins)
+{
+	struct conv_params params = { .uvcb = uvcb, .extra_pins = pins };
+	struct vm_area_struct *vma;
+	unsigned long uaddr;
+	int rc, local_drain = 0;
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
+	if (is_vm_hugetlb_page(vma))
+		goto out;
+
+	rc = -ENXIO;
+	params.page = follow_page(vma, uaddr, FOLL_WRITE | FOLL_NOWAIT);
+	if (IS_ERR_OR_NULL(params.page))
+		goto out;
+
+	lock_page(params.page);
+	rc = apply_to_page_range(gmap->mm, uaddr, PAGE_SIZE, make_secure_pte, &params);
+	unlock_page(params.page);
+out:
+	up_read(&gmap->mm->mmap_sem);
+
+	if (rc == -EBUSY) {
+		if (local_drain) {
+			lru_add_drain_all();
+			return -EAGAIN;
+		}
+		lru_add_drain();
+		local_drain = 1;
+		goto again;
+	} else if (rc == -ENXIO) {
+		if (gmap_fault(gmap, gaddr, FAULT_FLAG_WRITE))
+			return -EFAULT;
+		return -EAGAIN;
+	}
+	return rc;
+}
+EXPORT_SYMBOL_GPL(uv_make_secure);
+
+/**
+ * To be called with the page locked or with an extra reference!
+ */
+int arch_make_page_accessible(struct page *page)
+{
+	int rc = 0;
+
+	if (!test_bit(PG_arch_1, &page->flags))
+		return 0;
+
+	rc = __uv_pin_shared(page_to_phys(page));
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
2.24.0

