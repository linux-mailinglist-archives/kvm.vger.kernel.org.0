Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D46386555
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 22:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238388AbhEQUJk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 16:09:40 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56860 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236497AbhEQUJ0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 May 2021 16:09:26 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14HK4EV1180608;
        Mon, 17 May 2021 16:08:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=FUR8Oes6PY1PVgJPAMcDRnxKKHcgmGTXArQluA/8gnM=;
 b=bPISlNuryc45uFS4ZaxV8DxQHe/GonqTWcOUpRvtKdOkSH9URja7DdZh0tzn7N98rIGS
 MdlOCBbEeg9wEauR1+Kb/I5cr36FbqOcEuUDEKfD9dbckMQ+6Hf94cm9yTlszzJ9STZJ
 ajJT1lPvlB2nRPWzvT2uO2cuwhd04cdZ7Ct1XMrgrJDrSEjgWdzcqVMTq6nlHClAcqRC
 WxVj3j0KGgPK+H3ff+5OUdYG2NKcOFsY/FcVBXEbeuqYNoKGjqtUQKauuCaaAErTSzRD
 K1wdNg7TlgCk2gXT0MiJ6b9rqGS0HfLGiEAWGXl0xrU8LLgChDE/w3GxN8zz0oHbNAty CA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38kxwr8ga4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 16:08:09 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14HK5Bwi186487;
        Mon, 17 May 2021 16:08:08 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38kxwr8g94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 16:08:08 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14HK86mu015793;
        Mon, 17 May 2021 20:08:06 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 38j5jh0kh2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 20:08:06 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14HK837S31326498
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 May 2021 20:08:03 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6BC775204F;
        Mon, 17 May 2021 20:08:03 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.14.34])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id F3FD252052;
        Mon, 17 May 2021 20:08:02 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 09/11] KVM: s390: pv: extend lazy destroy to handle shutdown
Date:   Mon, 17 May 2021 22:07:56 +0200
Message-Id: <20210517200758.22593-10-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517200758.22593-1-imbrenda@linux.ibm.com>
References: <20210517200758.22593-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kUwSrHbNy5c-87KNAYdviByUsgm3BOe0
X-Proofpoint-ORIG-GUID: pJoSYApJYvTNB7qmiEkJ3CL5p9tOAUWs
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-17_08:2021-05-17,2021-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 adultscore=0 malwarescore=0 impostorscore=0 phishscore=0 mlxscore=0
 clxscore=1015 bulkscore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105170140
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extend the lazy destroy infrastructure to handle almost all kinds of
exit of the userspace process. The only case not handled is if the
process is killed by the OOM, in which case the old behaviour will
still be in effect.

Add the uv_destroy_page_lazy function to set aside pages when unmapping
them during mm teardown; the pages will be processed and freed when the
protected VM is torn down.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/mmu.h         |  3 ++
 arch/s390/include/asm/mmu_context.h |  2 ++
 arch/s390/include/asm/pgtable.h     |  9 ++++--
 arch/s390/include/asm/uv.h          | 15 +++++++++
 arch/s390/kernel/uv.c               | 47 +++++++++++++++++++++++++++++
 arch/s390/kvm/pv.c                  | 34 +++++++++++++++++----
 6 files changed, 102 insertions(+), 8 deletions(-)

diff --git a/arch/s390/include/asm/mmu.h b/arch/s390/include/asm/mmu.h
index e12ff0f29d1a..e2250dbe3d9d 100644
--- a/arch/s390/include/asm/mmu.h
+++ b/arch/s390/include/asm/mmu.h
@@ -18,6 +18,7 @@ typedef struct {
 	unsigned long vdso_base;
 	/* The mmu context belongs to a secure guest. */
 	atomic_t is_protected;
+	struct list_head deferred_list;
 	/*
 	 * The following bitfields need a down_write on the mm
 	 * semaphore when they are written to. As they are only
@@ -34,6 +35,8 @@ typedef struct {
 	unsigned int uses_cmm:1;
 	/* The gmaps associated with this context are allowed to use huge pages. */
 	unsigned int allow_gmap_hpage_1m:1;
+	/* The mmu context should be destroyed synchronously */
+	unsigned int pv_sync_destroy:1;
 } mm_context_t;
 
 #define INIT_MM_CONTEXT(name)						   \
diff --git a/arch/s390/include/asm/mmu_context.h b/arch/s390/include/asm/mmu_context.h
index e7cffc7b5c2f..da62140404e8 100644
--- a/arch/s390/include/asm/mmu_context.h
+++ b/arch/s390/include/asm/mmu_context.h
@@ -27,8 +27,10 @@ static inline int init_new_context(struct task_struct *tsk,
 	cpumask_clear(&mm->context.cpu_attach_mask);
 	atomic_set(&mm->context.flush_count, 0);
 	atomic_set(&mm->context.is_protected, 0);
+	mm->context.pv_sync_destroy = 0;
 	mm->context.gmap_asce = 0;
 	mm->context.flush_mm = 0;
+	INIT_LIST_HEAD(&mm->context.deferred_list);
 #ifdef CONFIG_PGSTE
 	mm->context.alloc_pgste = page_table_allocate_pgste ||
 		test_thread_flag(TIF_PGSTE) ||
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 141a8aaacd6d..05c68d3c2256 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1106,9 +1106,14 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
 	} else {
 		res = ptep_xchg_lazy(mm, addr, ptep, __pte(_PAGE_INVALID));
 	}
+
 	/* At this point the reference through the mapping is still present */
-	if (mm_is_protected(mm) && pte_present(res))
-		uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
+	if (pte_present(res) && mm_is_protected(mm)) {
+		if (full && !mm->context.pv_sync_destroy)
+			uv_destroy_page_lazy(mm, pte_val(res) & PAGE_MASK);
+		else
+			uv_convert_owned_from_secure(pte_val(res) & PAGE_MASK);
+	}
 	return res;
 }
 
diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index c6fe6a42e79b..1de5ff5e192a 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -339,6 +339,15 @@ static inline int uv_remove_shared(unsigned long addr) { return 0; }
 #if IS_ENABLED(CONFIG_KVM)
 extern int prot_virt_host;
 
+struct destroy_page_lazy {
+	struct list_head list;
+	unsigned short count;
+	unsigned long pfns[];
+};
+
+/* This guarantees that up to PV_MAX_LAZY_COUNT can fit in a page */
+#define PV_MAX_LAZY_COUNT ((PAGE_SIZE - sizeof(struct destroy_page_lazy)) / sizeof(long))
+
 static inline int is_prot_virt_host(void)
 {
 	return prot_virt_host;
@@ -347,6 +356,7 @@ static inline int is_prot_virt_host(void)
 int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb);
 int gmap_destroy_page(struct gmap *gmap, unsigned long gaddr);
 int uv_destroy_owned_page(unsigned long paddr);
+int uv_destroy_page_lazy(struct mm_struct *mm, unsigned long paddr);
 int uv_convert_from_secure(unsigned long paddr);
 int uv_convert_owned_from_secure(unsigned long paddr);
 int gmap_convert_to_secure(struct gmap *gmap, unsigned long gaddr);
@@ -363,6 +373,11 @@ static inline int uv_destroy_owned_page(unsigned long paddr)
 	return 0;
 }
 
+static inline int uv_destroy_page_lazy(struct mm_struct *mm, unsigned long paddr)
+{
+	return 0;
+}
+
 static inline int uv_convert_from_secure(unsigned long paddr)
 {
 	return 0;
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index dbcf4434eb53..434d81baceed 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -192,6 +192,53 @@ int uv_convert_owned_from_secure(unsigned long paddr)
 	return rc;
 }
 
+/*
+ * Set aside the given page and put it in the list of pages to be cleared in
+ * background. The caller must already hold a reference to the page.
+ */
+int uv_destroy_page_lazy(struct mm_struct *mm, unsigned long paddr)
+{
+	struct list_head *head = &mm->context.deferred_list;
+	struct destroy_page_lazy *lazy;
+	struct page *page;
+	int rc;
+
+	/* get an extra reference here */
+	get_page(phys_to_page(paddr));
+
+	lazy = list_first_entry(head, struct destroy_page_lazy, list);
+	/*
+	 * We need a fresh page to store more pointers. The current page
+	 * might be shared, so it cannot be used directly. Instead, make it
+	 * accessible and release it, and let the normal unmap code free it
+	 * later, if needed.
+	 * Afterwards, try to allocate a new page, but not very hard. If the
+	 * allocation fails, we simply return. The next call to this
+	 * function will attempt to do the same again, until enough pages
+	 * have been freed.
+	 */
+	if (list_empty(head) || lazy->count >= PV_MAX_LAZY_COUNT) {
+		rc = uv_convert_owned_from_secure(paddr);
+		/* in case of failure, we intentionally leak the page */
+		if (rc)
+			return rc;
+		/* release the extra reference */
+		put_page(phys_to_page(paddr));
+
+		/* try to allocate a new page quickly, but allow failures */
+		page = alloc_page(GFP_ATOMIC | __GFP_NOMEMALLOC | __GFP_NOWARN);
+		if (!page)
+			return -ENOMEM;
+		lazy = page_to_virt(page);
+		lazy->count = 0;
+		list_add(&lazy->list, head);
+		return 0;
+	}
+	/* the array of pointers has space, just add this entry */
+	lazy->pfns[lazy->count++] = phys_to_pfn(paddr);
+	return 0;
+}
+
 /*
  * Calculate the expected ref_count for a page that would otherwise have no
  * further pins. This was cribbed from similar functions in other places in
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 9a3547966e18..4333d3e54ef0 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -19,6 +19,7 @@
 
 struct deferred_priv {
 	struct mm_struct *mm;
+	bool has_mm;
 	unsigned long old_table;
 	u64 handle;
 	void *virt;
@@ -241,13 +242,29 @@ static int kvm_s390_pv_deinit_vm_now(struct kvm *kvm, u16 *rc, u16 *rrc)
 
 static int kvm_s390_pv_destroy_vm_thread(void *priv)
 {
+	struct destroy_page_lazy *lazy, *next;
 	struct deferred_priv *p = priv;
 	u16 rc, rrc;
-	int r = 1;
+	int r;
 
-	/* Exit early if we end up being the only users of the mm */
-	s390_uv_destroy_range(p->mm, 1, 0, TASK_SIZE_MAX);
-	mmput(p->mm);
+	list_for_each_entry_safe(lazy, next, &p->mm->context.deferred_list, list) {
+		list_del(&lazy->list);
+		s390_uv_destroy_pfns(lazy->count, lazy->pfns);
+		free_page(__pa(lazy));
+	}
+
+	if (p->has_mm) {
+		/* Exit early if we end up being the only users of the mm */
+		s390_uv_destroy_range(p->mm, 1, 0, TASK_SIZE_MAX);
+		if (atomic_read(&p->mm->mm_users) == 1) {
+			mmap_write_lock(p->mm);
+			/* destroy synchronously if there are no other users */
+			p->mm->context.pv_sync_destroy = 1;
+			mmap_write_unlock(p->mm);
+		}
+		mmput(p->mm);
+	}
+	mmdrop(p->mm);
 
 	r = uv_cmd_nodata(p->handle, UVC_CMD_DESTROY_SEC_CONF, &rc, &rrc);
 	WARN_ONCE(r, "protvirt destroy vm failed rc %x rrc %x", rc, rrc);
@@ -276,7 +293,9 @@ static int deferred_destroy(struct kvm *kvm, struct deferred_priv *priv, u16 *rc
 	priv->old_table = (unsigned long)kvm->arch.gmap->table;
 	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
 
-	if (kvm_s390_pv_replace_asce(kvm))
+	if (!priv->has_mm)
+		kvm_s390_pv_remove_old_asce(kvm);
+	else if (kvm_s390_pv_replace_asce(kvm))
 		goto fail;
 
 	t = kthread_create(kvm_s390_pv_destroy_vm_thread, priv,
@@ -333,10 +352,13 @@ int kvm_s390_pv_deinit_vm_deferred(struct kvm *kvm, u16 *rc, u16 *rrc)
 	if (!priv)
 		return kvm_s390_pv_deinit_vm_now(kvm, rc, rrc);
 
+	mmgrab(kvm->mm);
 	if (mmget_not_zero(kvm->mm)) {
+		priv->has_mm = true;
 		kvm_s390_clear_2g(kvm);
-	} else {
+	} else if (list_empty(&kvm->mm->context.deferred_list)) {
 		/* No deferred work to do */
+		mmdrop(kvm->mm);
 		kfree(priv);
 		return kvm_s390_pv_deinit_vm_now(kvm, rc, rrc);
 	}
-- 
2.31.1

