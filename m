Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98E874EC445
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 14:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345410AbiC3Mhv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 08:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237842AbiC3Mh2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 08:37:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396A790CE2;
        Wed, 30 Mar 2022 05:26:20 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22UBhqqd032066;
        Wed, 30 Mar 2022 12:26:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=85+oB0nQq242lbGiqyCDMVmmuInx67gJ4O6IWdnIrTE=;
 b=E6DjlZvd1uCQl+2WrTyYo/RxUrw0olYNWwK/eSDX+VvIsH9XgkhpGfGGDV8TwLvZwNdN
 O3Iof61IwekFk/e20ApZfj8Fypv1KcJVYrq4li5t1pm09NJa5jYu9S3Z0XETH019Jxe+
 /VLB4qn59llIa5i/sN6EbfPNt2l6hL+Ll9KMZVnJw4W9Sr+Ww4l6Ru5EBnZXHvjmRkvx
 qYyDUPc8XXbZTjtKGBNxzvhQnLykOL9W7U0k+OwPilHSacwoTKMMxw14NV0LYdf45ius
 jl1SWieYmnbTZZ1cCro7cxCKdGQ1QnLGFjfOKUXSaCBqb4SXx87h4VBNb5Y/4DrdKqVQ vQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f40q24grj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:26:19 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22UCQJxE012076;
        Wed, 30 Mar 2022 12:26:19 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f40q24gqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:26:19 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22UCMjEl010393;
        Wed, 30 Mar 2022 12:26:16 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 3f1t3hyacd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:26:16 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22UCQDPS50463178
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 12:26:13 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7748111C050;
        Wed, 30 Mar 2022 12:26:13 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DBB1E11C04A;
        Wed, 30 Mar 2022 12:26:12 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.13.95])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 30 Mar 2022 12:26:12 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v9 04/18] KVM: s390: pv: refactor s390_reset_acc
Date:   Wed, 30 Mar 2022 14:25:51 +0200
Message-Id: <20220330122605.247613-5-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330122605.247613-1-imbrenda@linux.ibm.com>
References: <20220330122605.247613-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2AREQin2RFQQaw08e9GlOQV912D1H9-_
X-Proofpoint-ORIG-GUID: vBPS7NjBW7YTq0x2vHabWXxOlXgY6NeQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-30_04,2022-03-30_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 mlxscore=0 clxscore=1015 impostorscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203300062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor s390_reset_acc so that it can be reused in upcoming patches.

We don't want to hold all the locks used in a walk_page_range for too
long, and the destroy page UVC does take some time to complete.
Therefore we quickly gather the pages to destroy, and then destroy them
without holding all the locks.

The new refactored function optionally allows to return early without
completing if a fatal signal is pending (and return and appropriate
error code). Two wrappers are provided to call the new function.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
(dropping Janosch's Ack because of major changes to the patch)
---
 arch/s390/include/asm/gmap.h | 37 +++++++++++++-
 arch/s390/kvm/pv.c           | 12 ++++-
 arch/s390/mm/gmap.c          | 95 +++++++++++++++++++++++++-----------
 3 files changed, 112 insertions(+), 32 deletions(-)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index 746e18bf8984..0baaa127614b 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -147,7 +147,42 @@ int gmap_mprotect_notify(struct gmap *, unsigned long start,
 void gmap_sync_dirty_log_pmd(struct gmap *gmap, unsigned long dirty_bitmap[4],
 			     unsigned long gaddr, unsigned long vmaddr);
 int gmap_mark_unmergeable(void);
-void s390_reset_acc(struct mm_struct *mm);
 void s390_remove_old_asce(struct gmap *gmap);
 int s390_replace_asce(struct gmap *gmap);
+void s390_uv_destroy_pfns(unsigned long count, unsigned long *pfns);
+int __s390_uv_destroy_range(struct mm_struct *mm, unsigned long start,
+			    unsigned long end, bool interruptible);
+
+/**
+ * s390_uv_destroy_range - Destroy a range of pages in the given mm.
+ * @mm the mm on which to operate on
+ * @start the start of the range
+ * @end the end of the range
+ *
+ * This function will call cond_sched, so it should not generate stalls, but
+ * it will otherwise only return when it completed.
+ */
+static inline void s390_uv_destroy_range(struct mm_struct *mm, unsigned long start,
+					 unsigned long end)
+{
+	(void)__s390_uv_destroy_range(mm, start, end, false);
+}
+
+/**
+ * s390_uv_destroy_range_interruptible - Destroy a range of pages in the
+ * given mm, but stop when a fatal signal is received.
+ * @mm the mm on which to operate on
+ * @start the start of the range
+ * @end the end of the range
+ *
+ * This function will call cond_sched, so it should not generate stalls. If
+ * a fatal signal is received, it will return with -EINTR immediately,
+ * without finishing destroying the whole range. Upon successful
+ * completion, 0 is returned.
+ */
+static inline int s390_uv_destroy_range_interruptible(struct mm_struct *mm, unsigned long start,
+						      unsigned long end)
+{
+	return __s390_uv_destroy_range(mm, start, end, true);
+}
 #endif /* _ASM_S390_GMAP_H */
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 3c59ef763dde..2ab22500e092 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -12,6 +12,8 @@
 #include <asm/gmap.h>
 #include <asm/uv.h>
 #include <asm/mman.h>
+#include <linux/pagewalk.h>
+#include <linux/sched/mm.h>
 #include "kvm-s390.h"
 
 int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
@@ -157,8 +159,14 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 {
 	int cc;
 
-	/* make all pages accessible before destroying the guest */
-	s390_reset_acc(kvm->mm);
+	/*
+	 * if the mm still has a mapping, make all its pages accessible
+	 * before destroying the guest
+	 */
+	if (mmget_not_zero(kvm->mm)) {
+		s390_uv_destroy_range(kvm->mm, 0, TASK_SIZE);
+		mmput(kvm->mm);
+	}
 
 	cc = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
 			   UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 3b42bf7adb77..f6a80f139b84 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2676,44 +2676,81 @@ void s390_reset_cmma(struct mm_struct *mm)
 }
 EXPORT_SYMBOL_GPL(s390_reset_cmma);
 
-/*
- * make inaccessible pages accessible again
- */
-static int __s390_reset_acc(pte_t *ptep, unsigned long addr,
-			    unsigned long next, struct mm_walk *walk)
+#define DESTROY_LOOP_THRESHOLD 32
+
+struct reset_walk_state {
+	unsigned long next;
+	unsigned long count;
+	unsigned long pfns[DESTROY_LOOP_THRESHOLD];
+};
+
+static int s390_gather_pages(pte_t *ptep, unsigned long addr,
+			     unsigned long next, struct mm_walk *walk)
 {
+	struct reset_walk_state *p = walk->private;
 	pte_t pte = READ_ONCE(*ptep);
 
-	/* There is a reference through the mapping */
-	if (pte_present(pte))
-		WARN_ON_ONCE(uv_destroy_owned_page(pte_val(pte) & PAGE_MASK));
-
-	return 0;
+	if (pte_present(pte)) {
+		/* we have a reference from the mapping, take an extra one */
+		get_page(phys_to_page(pte_val(pte)));
+		p->pfns[p->count] = phys_to_pfn(pte_val(pte));
+		p->next = next;
+		p->count++;
+	}
+	return p->count >= DESTROY_LOOP_THRESHOLD;
 }
 
-static const struct mm_walk_ops reset_acc_walk_ops = {
-	.pte_entry		= __s390_reset_acc,
+static const struct mm_walk_ops gather_pages_ops = {
+	.pte_entry = s390_gather_pages,
 };
 
-#include <linux/sched/mm.h>
-void s390_reset_acc(struct mm_struct *mm)
+/*
+ * Call the Destroy secure page UVC on each page in the given array of PFNs.
+ * Each page needs to have an extra reference, which will be released here.
+ */
+void s390_uv_destroy_pfns(unsigned long count, unsigned long *pfns)
 {
-	if (!mm_is_protected(mm))
-		return;
-	/*
-	 * we might be called during
-	 * reset:                             we walk the pages and clear
-	 * close of all kvm file descriptors: we walk the pages and clear
-	 * exit of process on fd closure:     vma already gone, do nothing
-	 */
-	if (!mmget_not_zero(mm))
-		return;
-	mmap_read_lock(mm);
-	walk_page_range(mm, 0, TASK_SIZE, &reset_acc_walk_ops, NULL);
-	mmap_read_unlock(mm);
-	mmput(mm);
+	unsigned long i;
+
+	for (i = 0; i < count; i++) {
+		/* we always have an extra reference */
+		uv_destroy_owned_page(pfn_to_phys(pfns[i]));
+		/* get rid of the extra reference */
+		put_page(pfn_to_page(pfns[i]));
+		cond_resched();
+	}
+}
+EXPORT_SYMBOL_GPL(s390_uv_destroy_pfns);
+
+/**
+ * __s390_uv_destroy_range - Walk the given range of the given address
+ * space, and call the destroy secure page UVC on each page.
+ * Optionally exit early if a fatal signal is pending.
+ * @mm the mm to operate on
+ * @start the start of the range
+ * @end the end of the range
+ * @interruptible if not 0, stop when a fatal signal is received
+ * Return: 0 on success, -EINTR if the function stopped before completing
+ */
+int __s390_uv_destroy_range(struct mm_struct *mm, unsigned long start,
+			    unsigned long end, bool interruptible)
+{
+	struct reset_walk_state state = { .next = start };
+	int r = 1;
+
+	while (r > 0) {
+		state.count = 0;
+		mmap_read_lock(mm);
+		r = walk_page_range(mm, state.next, end, &gather_pages_ops, &state);
+		mmap_read_unlock(mm);
+		cond_resched();
+		s390_uv_destroy_pfns(state.count, state.pfns);
+		if (interruptible && fatal_signal_pending(current))
+			return -EINTR;
+	}
+	return 0;
 }
-EXPORT_SYMBOL_GPL(s390_reset_acc);
+EXPORT_SYMBOL_GPL(__s390_uv_destroy_range);
 
 /**
  * s390_remove_old_asce - Remove the topmost level of page tables from the
-- 
2.34.1

