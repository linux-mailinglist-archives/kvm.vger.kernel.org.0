Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F28E57D111
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 18:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233648AbiGUQOB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 12:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233575AbiGUQNo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 12:13:44 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F095788F03;
        Thu, 21 Jul 2022 09:13:31 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26LFFS1g020424;
        Thu, 21 Jul 2022 16:13:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=NbKCAFXOWvlfnwS5ukZVqVgToSwudnqKsdSGTwFPigI=;
 b=lRkQBYeGTWYVjkUMM2NcUC65qMEDeBHawTtbWqvwNEKIpJsk9m9FtSNxubxL9FLmamNQ
 NnTcIWlbDO408muVCPOkgI2XYE+dQZfQnBWGbuoe18DRg+JSkkgt5Zk7LyK44NX3clq/
 T2h3npdhxBXs2lyqTPEsJa2QwdWondUsL1dSk1jYiwUG6Zb2Uq6CuvDwKC6KkIPG2C86
 ONIPow/3QPKQiX+QJDzapy59F99x43BBajssHuOWQGMm/Tw7yxPmOCBZqoVRHNu8nODH
 LTqqAW+bhYVj1CieHwT6h2ZUsJAbszj4CMYujHeaFrZyvLj+t5Hb4JGswT0UXs8BNB/q Vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf8f2m3k2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:29 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26LFYcGB007163;
        Thu, 21 Jul 2022 16:13:28 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hf8f2m3ha-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:28 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26LG70vf029937;
        Thu, 21 Jul 2022 16:13:26 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3hbmkj769k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jul 2022 16:13:26 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26LGDNMw20709856
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jul 2022 16:13:23 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6FCBA405C;
        Thu, 21 Jul 2022 16:13:22 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5F23AA4054;
        Thu, 21 Jul 2022 16:13:22 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.4.232])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jul 2022 16:13:22 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, borntraeger@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        thuth@redhat.com, david@redhat.com, Nico Boehr <nrb@linux.ibm.com>
Subject: [GIT PULL 30/42] KVM: s390: pv: refactor s390_reset_acc
Date:   Thu, 21 Jul 2022 18:12:50 +0200
Message-Id: <20220721161302.156182-31-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721161302.156182-1-imbrenda@linux.ibm.com>
References: <20220721161302.156182-1-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: isgWbCUVQQ6CG2iLrl0GPgHVI67wV34G
X-Proofpoint-GUID: oxuOBHuI42iYQBqT3IfH-5fWbdJDDDAt
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-21_22,2022-07-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 clxscore=1015 suspectscore=0 adultscore=0 spamscore=0
 mlxlogscore=933 impostorscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207210064
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Link: https://lore.kernel.org/r/20220628135619.32410-5-imbrenda@linux.ibm.com
Message-Id: <20220628135619.32410-5-imbrenda@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/gmap.h | 37 +++++++++++++-
 arch/s390/kvm/pv.c           | 12 ++++-
 arch/s390/mm/gmap.c          | 99 +++++++++++++++++++++++++-----------
 3 files changed, 116 insertions(+), 32 deletions(-)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index f4073106e1f3..5cc46e0dde62 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -147,7 +147,42 @@ int gmap_mprotect_notify(struct gmap *, unsigned long start,
 void gmap_sync_dirty_log_pmd(struct gmap *gmap, unsigned long dirty_bitmap[4],
 			     unsigned long gaddr, unsigned long vmaddr);
 int gmap_mark_unmergeable(void);
-void s390_reset_acc(struct mm_struct *mm);
 void s390_unlist_old_asce(struct gmap *gmap);
 int s390_replace_asce(struct gmap *gmap);
+void s390_uv_destroy_pfns(unsigned long count, unsigned long *pfns);
+int __s390_uv_destroy_range(struct mm_struct *mm, unsigned long start,
+			    unsigned long end, bool interruptible);
+
+/**
+ * s390_uv_destroy_range - Destroy a range of pages in the given mm.
+ * @mm: the mm on which to operate on
+ * @start: the start of the range
+ * @end: the end of the range
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
+ * @mm: the mm on which to operate on
+ * @start: the start of the range
+ * @end: the end of the range
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
index f1733812a263..a556db3912a1 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -13,6 +13,8 @@
 #include <asm/gmap.h>
 #include <asm/uv.h>
 #include <asm/mman.h>
+#include <linux/pagewalk.h>
+#include <linux/sched/mm.h>
 #include "kvm-s390.h"
 
 int kvm_s390_pv_destroy_cpu(struct kvm_vcpu *vcpu, u16 *rc, u16 *rrc)
@@ -153,8 +155,14 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
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
index 85cab61d87a9..62758cb5872f 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2697,44 +2697,85 @@ void s390_reset_cmma(struct mm_struct *mm)
 }
 EXPORT_SYMBOL_GPL(s390_reset_cmma);
 
-/*
- * make inaccessible pages accessible again
- */
-static int __s390_reset_acc(pte_t *ptep, unsigned long addr,
-			    unsigned long next, struct mm_walk *walk)
+#define GATHER_GET_PAGES 32
+
+struct reset_walk_state {
+	unsigned long next;
+	unsigned long count;
+	unsigned long pfns[GATHER_GET_PAGES];
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
+	return p->count >= GATHER_GET_PAGES;
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
+ * __s390_uv_destroy_range - Call the destroy secure page UVC on each page
+ * in the given range of the given address space.
+ * @mm: the mm to operate on
+ * @start: the start of the range
+ * @end: the end of the range
+ * @interruptible: if not 0, stop when a fatal signal is received
+ *
+ * Walk the given range of the given address space and call the destroy
+ * secure page UVC on each page. Optionally exit early if a fatal signal is
+ * pending.
+ *
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
  * s390_unlist_old_asce - Remove the topmost level of page tables from the
-- 
2.36.1

