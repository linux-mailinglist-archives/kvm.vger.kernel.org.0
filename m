Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807E63E047E
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 17:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239432AbhHDPlf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 11:41:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16622 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239207AbhHDPlR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Aug 2021 11:41:17 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 174FWx86179528;
        Wed, 4 Aug 2021 11:41:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=f+XLGE/DIpGs5kVWGn5peByZKvGmWrBW2Gfpzvd+Ghg=;
 b=UyOxa4fbuGx14+fd0fyAnP9S+VTqyKGuLvdeFxYVk3tHnKlRisYkPOM3Vng4kwjG4iIW
 BNxRV3mFexHv9VDGOaxfQA10gx5osE/o8h+/m15T2UhY7xJoU78DIJihXxNu6J4qelut
 3M9lzAXNERJtcaIwQS1Yfo0xsAamBEu8o0r595QGy2/gtu4jZVHREheTQSWpEx96goW1
 Nfw7mRPMNlxdAe/UqV9WduwOSNO9SAg8FbA46DBnVSPlJlu/s/JgbIsNZLz/gz7JDimj
 8JDeEgTveeZ/IlCdJ30qyXhGJDS+xTQGrDalJiO8vZs5KPssXh7Px9NpcuRyt7aws3KI Sw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a7cf8hq98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Aug 2021 11:41:03 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 174FXRre181352;
        Wed, 4 Aug 2021 11:41:03 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a7cf8hq8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Aug 2021 11:41:03 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 174FYaeK001204;
        Wed, 4 Aug 2021 15:41:01 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3a4x58rhgw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Aug 2021 15:41:01 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 174FbwAo57344470
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 Aug 2021 15:37:58 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0BF64C050;
        Wed,  4 Aug 2021 15:40:56 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 813AF4C04A;
        Wed,  4 Aug 2021 15:40:56 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.2.150])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  4 Aug 2021 15:40:56 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com
Subject: [PATCH v3 07/14] KVM: s390: pv: refactor s390_reset_acc
Date:   Wed,  4 Aug 2021 17:40:39 +0200
Message-Id: <20210804154046.88552-8-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210804154046.88552-1-imbrenda@linux.ibm.com>
References: <20210804154046.88552-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _Mi0KctIZH6ZxI7Uu8UXyDQVA-0aV_-u
X-Proofpoint-GUID: Q2Nyn4gd6bXjf7axIeIouX9XikWlV4jR
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-04_03:2021-08-04,2021-08-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 priorityscore=1501
 mlxlogscore=999 phishscore=0 spamscore=0 malwarescore=0 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108040089
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor s390_reset_acc so that its pieces can be reused in upcoming
patches. The users parameter for s390_destroy_range will be needed in
upcoming patches.

We don't want to hold all the locks used in a walk_page_range for too
long, and the destroy page UVC does take some time to complete.
Therefore we quickly gather the pages to destroy, and then destroy them
without holding all the locks.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/gmap.h |  4 +-
 arch/s390/kvm/pv.c           | 12 ++++-
 arch/s390/mm/gmap.c          | 88 ++++++++++++++++++++++++------------
 3 files changed, 72 insertions(+), 32 deletions(-)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index 746e18bf8984..559a0c18579e 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -147,7 +147,9 @@ int gmap_mprotect_notify(struct gmap *, unsigned long start,
 void gmap_sync_dirty_log_pmd(struct gmap *gmap, unsigned long dirty_bitmap[4],
 			     unsigned long gaddr, unsigned long vmaddr);
 int gmap_mark_unmergeable(void);
-void s390_reset_acc(struct mm_struct *mm);
 void s390_remove_old_asce(struct gmap *gmap);
 int s390_replace_asce(struct gmap *gmap);
+void s390_uv_destroy_range(struct mm_struct *mm, unsigned int users,
+			   unsigned long start, unsigned long end);
+void s390_uv_destroy_pfns(unsigned long count, unsigned long *pfns);
 #endif /* _ASM_S390_GMAP_H */
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index f3dd5dd00013..1e7f63c06a63 100644
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
@@ -160,8 +162,14 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 {
 	int cc;
 
-	/* make all pages accessible before destroying the guest */
-	s390_reset_acc(kvm->mm);
+	/*
+	 * if the mm still has a mapping, make all its pages accessible
+	 * before destroying the guest
+	 */
+	if (mmget_not_zero(kvm->mm)) {
+		s390_uv_destroy_range(kvm->mm, 0, 0, TASK_SIZE);
+		mmput(kvm->mm);
+	}
 
 	cc = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
 			   UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 38b792ab57f7..b87892986836 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2670,44 +2670,74 @@ void s390_reset_cmma(struct mm_struct *mm)
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
+/*
+ * Walk the given range of the given address space, and call the destroy
+ * secure page UVC on each page.
+ * Exit early if the number of users of the mm drops to (or below) the given
+ * value.
+ */
+void s390_uv_destroy_range(struct mm_struct *mm, unsigned int users,
+			   unsigned long start, unsigned long end)
+{
+	struct reset_walk_state state = { .next = start };
+	int r = 1;
+
+	while ((r > 0) && (atomic_read(&mm->mm_users) > users)) {
+		state.count = 0;
+		mmap_read_lock(mm);
+		r = walk_page_range(mm, state.next, end, &gather_pages_ops, &state);
+		mmap_read_unlock(mm);
+		cond_resched();
+		s390_uv_destroy_pfns(state.count, state.pfns);
+	}
 }
-EXPORT_SYMBOL_GPL(s390_reset_acc);
+EXPORT_SYMBOL_GPL(s390_uv_destroy_range);
 
 /*
  * Remove the topmost level of page tables from the list of page tables of
-- 
2.31.1

