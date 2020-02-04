Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 021D7151AEA
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 14:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbgBDNEY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 08:04:24 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:30232 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727126AbgBDNEY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Feb 2020 08:04:24 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 014CnwmM078109
        for <kvm@vger.kernel.org>; Tue, 4 Feb 2020 08:04:23 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xxtbjr0r4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2020 08:04:23 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 014CoGJd080295
        for <kvm@vger.kernel.org>; Tue, 4 Feb 2020 08:04:22 -0500
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xxtbjr0qf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Feb 2020 08:04:22 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 014D46aw020599;
        Tue, 4 Feb 2020 13:04:21 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04dal.us.ibm.com with ESMTP id 2xw0y6yqgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Feb 2020 13:04:21 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 014D4KWG39190886
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Feb 2020 13:04:20 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F18EAB2065;
        Tue,  4 Feb 2020 13:04:19 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E26BCB2064;
        Tue,  4 Feb 2020 13:04:19 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  4 Feb 2020 13:04:19 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     david@redhat.com
Cc:     Ulrich.Weigand@de.ibm.com, aarcange@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        frankja@linux.vnet.ibm.com, imbrenda@linux.ibm.com,
        kvm@vger.kernel.org, thuth@redhat.com,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [PATCH v2 10/37] KVM: s390: protvirt: Secure memory is not mergeable
Date:   Tue,  4 Feb 2020 08:04:18 -0500
Message-Id: <20200204130418.226980-1-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <04c69c18-52e8-c09e-d93e-dbf2c006ac5e@redhat.com>
References: <04c69c18-52e8-c09e-d93e-dbf2c006ac5e@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-04_03:2020-02-04,2020-02-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 bulkscore=0 suspectscore=1
 spamscore=0 phishscore=0 clxscore=1015 mlxscore=0 mlxlogscore=806
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2002040091
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

KSM will not work on secure pages, because when the kernel reads a
secure page, it will be encrypted and hence no two pages will look the
same.

Let's mark the guest pages as unmergeable when we transition to secure
mode.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 arch/s390/include/asm/gmap.h |  1 +
 arch/s390/kvm/kvm-s390.c     |  6 ++++++
 arch/s390/mm/gmap.c          | 30 ++++++++++++++++++++----------
 3 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index e2d2f48c5c7c..e1f2cc0b2b00 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -146,4 +146,5 @@ int gmap_mprotect_notify(struct gmap *, unsigned long start,
 
 void gmap_sync_dirty_log_pmd(struct gmap *gmap, unsigned long dirty_bitmap[4],
 			     unsigned long gaddr, unsigned long vmaddr);
+int gmap_mark_unmergeable(void);
 #endif /* _ASM_S390_GMAP_H */
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 35f46404830f..741d81f57c3c 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2181,6 +2181,12 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 		if (r)
 			break;
 
+		down_write(&current->mm->mmap_sem);
+		r = gmap_mark_unmergeable();
+		up_write(&current->mm->mmap_sem);
+		if (r)
+			break;
+
 		mutex_lock(&kvm->lock);
 		kvm_s390_vcpu_block_all(kvm);
 		/* FMT 4 SIE needs esca */
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index edcdca97e85e..7291452fe5f0 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2548,6 +2548,22 @@ int s390_enable_sie(void)
 }
 EXPORT_SYMBOL_GPL(s390_enable_sie);
 
+int gmap_mark_unmergeable(void)
+{
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma;
+
+	for (vma = mm->mmap; vma; vma = vma->vm_next) {
+		if (ksm_madvise(vma, vma->vm_start, vma->vm_end,
+				MADV_UNMERGEABLE, &vma->vm_flags)) {
+			return -ENOMEM;
+		}
+	}
+	mm->def_flags &= ~VM_MERGEABLE;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(gmap_mark_unmergeable);
+
 /*
  * Enable storage key handling from now on and initialize the storage
  * keys with the default key.
@@ -2593,7 +2609,6 @@ static const struct mm_walk_ops enable_skey_walk_ops = {
 int s390_enable_skey(void)
 {
 	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
 	int rc = 0;
 
 	down_write(&mm->mmap_sem);
@@ -2601,16 +2616,11 @@ int s390_enable_skey(void)
 		goto out_up;
 
 	mm->context.uses_skeys = 1;
-	for (vma = mm->mmap; vma; vma = vma->vm_next) {
-		if (ksm_madvise(vma, vma->vm_start, vma->vm_end,
-				MADV_UNMERGEABLE, &vma->vm_flags)) {
-			mm->context.uses_skeys = 0;
-			rc = -ENOMEM;
-			goto out_up;
-		}
+	rc = gmap_mark_unmergeable();
+	if (rc) {
+		mm->context.uses_skeys = 0;
+		goto out_up;
 	}
-	mm->def_flags &= ~VM_MERGEABLE;
-
 	walk_page_range(mm, 0, TASK_SIZE, &enable_skey_walk_ops, NULL);
 
 out_up:
-- 
2.24.0

