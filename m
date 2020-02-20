Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62DB9165C08
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 11:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbgBTKlb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 05:41:31 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60638 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727894AbgBTKk3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Feb 2020 05:40:29 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01KAbBBj034121;
        Thu, 20 Feb 2020 05:40:29 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y8ucmxc5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Feb 2020 05:40:28 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01KAbTdD034677;
        Thu, 20 Feb 2020 05:40:28 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y8ucmxc58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Feb 2020 05:40:28 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01KATZ2h024825;
        Thu, 20 Feb 2020 10:40:26 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01wdc.us.ibm.com with ESMTP id 2y6896uvs5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Feb 2020 10:40:26 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01KAeO0g7209550
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 10:40:24 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C71E0112062;
        Thu, 20 Feb 2020 10:40:23 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C37A911206D;
        Thu, 20 Feb 2020 10:40:23 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 20 Feb 2020 10:40:23 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [PATCH v3 11/37] KVM: s390: protvirt: Secure memory is not mergeable
Date:   Thu, 20 Feb 2020 05:39:54 -0500
Message-Id: <20200220104020.5343-12-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200220104020.5343-1-borntraeger@de.ibm.com>
References: <20200220104020.5343-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-20_02:2020-02-19,2020-02-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 impostorscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 suspectscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200078
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
Reviewed-by: David Hildenbrand <david@redhat.com>
[borntraeger@de.ibm.com: patch merging, splitting, fixing]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/include/asm/gmap.h |  1 +
 arch/s390/kvm/kvm-s390.c     |  7 +++++++
 arch/s390/mm/gmap.c          | 30 ++++++++++++++++++++----------
 3 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index 3c4926aa78f4..6f9ff7a69fa2 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -148,4 +148,5 @@ int gmap_mprotect_notify(struct gmap *, unsigned long start,
 
 void gmap_sync_dirty_log_pmd(struct gmap *gmap, unsigned long dirty_bitmap[4],
 			     unsigned long gaddr, unsigned long vmaddr);
+int gmap_mark_unmergeable(void);
 #endif /* _ASM_S390_GMAP_H */
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 8272a821a621..f99e4eb5c27b 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2215,6 +2215,13 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 		if (r)
 			break;
 
+		down_write(&current->mm->mmap_sem);
+		r = gmap_mark_unmergeable();
+		up_write(&current->mm->mmap_sem);
+		if (r) {
+			kvm_s390_pv_dealloc_vm(kvm);
+			break;
+		}
 		/* FMT 4 SIE needs esca */
 		r = sca_switch_to_extended(kvm);
 		if (r) {
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
2.25.0

