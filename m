Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4ED9E45AA
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 10:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437963AbfJYIZC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Oct 2019 04:25:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16740 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437952AbfJYIZC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Oct 2019 04:25:02 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9P87IDU094301
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2019 04:25:01 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vuw339056-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 25 Oct 2019 04:25:00 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Fri, 25 Oct 2019 09:24:58 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 25 Oct 2019 09:24:56 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9P8Osq147579140
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 08:24:54 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65FDA11C04A;
        Fri, 25 Oct 2019 08:24:54 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B81A11C050;
        Fri, 25 Oct 2019 08:24:52 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.50.181])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Oct 2019 08:24:51 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com, frankja@linux.ibm.com
Subject: [RFC v2] KVM: s390: protvirt: Secure memory is not mergeable
Date:   Fri, 25 Oct 2019 04:24:46 -0400
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024114059.102802-8-frankja@linux.ibm.com>
References: <20191024114059.102802-8-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19102508-0020-0000-0000-0000037E5677
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102508-0021-0000-0000-000021D4A185
Message-Id: <20191025082446.754-1-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-25_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=612 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910250078
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KSM will not work on secure pages, because when the kernel reads a
secure page, it will be encrypted and hence no two pages will look the
same.

Let's mark the guest pages as unmergeable when we transition to secure
mode.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/gmap.h |  1 +
 arch/s390/kvm/kvm-s390.c     |  6 ++++++
 arch/s390/mm/gmap.c          | 32 +++++++++++++++++++++-----------
 3 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index 6efc0b501227..eab6a2ec3599 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -145,4 +145,5 @@ int gmap_mprotect_notify(struct gmap *, unsigned long start,
 
 void gmap_sync_dirty_log_pmd(struct gmap *gmap, unsigned long dirty_bitmap[4],
 			     unsigned long gaddr, unsigned long vmaddr);
+int gmap_mark_unmergeable(void);
 #endif /* _ASM_S390_GMAP_H */
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 924132d92782..d1ba12f857e7 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2176,6 +2176,12 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
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
index edcdca97e85e..faecdf81abdb 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2548,6 +2548,23 @@ int s390_enable_sie(void)
 }
 EXPORT_SYMBOL_GPL(s390_enable_sie);
 
+int gmap_mark_unmergeable(void)
+{
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma;
+
+
+	for (vma = mm->mmap; vma; vma = vma->vm_next) {
+		if (ksm_madvise(vma, vma->vm_start, vma->vm_end,
+				MADV_UNMERGEABLE, &vma->vm_flags))
+			return -ENOMEM;
+	}
+	mm->def_flags &= ~VM_MERGEABLE;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(gmap_mark_unmergeable);
+
 /*
  * Enable storage key handling from now on and initialize the storage
  * keys with the default key.
@@ -2593,24 +2610,17 @@ static const struct mm_walk_ops enable_skey_walk_ops = {
 int s390_enable_skey(void)
 {
 	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
 	int rc = 0;
 
 	down_write(&mm->mmap_sem);
 	if (mm_uses_skeys(mm))
 		goto out_up;
 
-	mm->context.uses_skeys = 1;
-	for (vma = mm->mmap; vma; vma = vma->vm_next) {
-		if (ksm_madvise(vma, vma->vm_start, vma->vm_end,
-				MADV_UNMERGEABLE, &vma->vm_flags)) {
-			mm->context.uses_skeys = 0;
-			rc = -ENOMEM;
-			goto out_up;
-		}
-	}
-	mm->def_flags &= ~VM_MERGEABLE;
+	rc = gmap_mark_unmergeable();
+	if (rc)
+		goto out_up;
 
+	mm->context.uses_skeys = 1;
 	walk_page_range(mm, 0, TASK_SIZE, &enable_skey_walk_ops, NULL);
 
 out_up:
-- 
2.20.1

