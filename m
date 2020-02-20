Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59368165C01
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 11:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbgBTKlU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 05:41:20 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4298 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727686AbgBTKka (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Feb 2020 05:40:30 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01KAZKAa008544;
        Thu, 20 Feb 2020 05:40:28 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y8ubyc0e4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Feb 2020 05:40:28 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01KAZO3G008998;
        Thu, 20 Feb 2020 05:40:28 -0500
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y8ubyc0du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Feb 2020 05:40:28 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01KAY6um009293;
        Thu, 20 Feb 2020 10:40:27 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01dal.us.ibm.com with ESMTP id 2y68976x18-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Feb 2020 10:40:27 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01KAeOkR18809114
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Feb 2020 10:40:25 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D615011206F;
        Thu, 20 Feb 2020 10:40:23 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D29DD11206E;
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
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH v3 12/37] KVM: s390/mm: Make pages accessible before destroying the guest
Date:   Thu, 20 Feb 2020 05:39:55 -0500
Message-Id: <20200220104020.5343-13-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200220104020.5343-1-borntraeger@de.ibm.com>
References: <20200220104020.5343-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-20_02:2020-02-19,2020-02-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 malwarescore=0 adultscore=0 mlxlogscore=812
 spamscore=0 suspectscore=0 mlxscore=0 bulkscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002200078
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Before we destroy the secure configuration, we better make all
pages accessible again. This also happens during reboot, where we reboot
into a non-secure guest that then can go again into secure mode. As
this "new" secure guest will have a new ID we cannot reuse the old page
state.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/include/asm/gmap.h |  1 +
 arch/s390/kvm/pv.c           |  2 ++
 arch/s390/mm/gmap.c          | 35 +++++++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index 6f9ff7a69fa2..a816fb4734b8 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -149,4 +149,5 @@ int gmap_mprotect_notify(struct gmap *, unsigned long start,
 void gmap_sync_dirty_log_pmd(struct gmap *gmap, unsigned long dirty_bitmap[4],
 			     unsigned long gaddr, unsigned long vmaddr);
 int gmap_mark_unmergeable(void);
+void s390_reset_acc(struct mm_struct *mm);
 #endif /* _ASM_S390_GMAP_H */
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 67ea9a18ed8f..7d95d7437140 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -66,6 +66,8 @@ int kvm_s390_pv_destroy_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 {
 	int cc;
 
+	/* make all pages accessible before destroying the guest */
+	s390_reset_acc(kvm->mm);
 	cc = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
 			   UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
 	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 7291452fe5f0..27926a06df32 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2650,3 +2650,38 @@ void s390_reset_cmma(struct mm_struct *mm)
 	up_write(&mm->mmap_sem);
 }
 EXPORT_SYMBOL_GPL(s390_reset_cmma);
+
+/*
+ * make inaccessible pages accessible again
+ */
+static int __s390_reset_acc(pte_t *ptep, unsigned long addr,
+			    unsigned long next, struct mm_walk *walk)
+{
+	pte_t pte = READ_ONCE(*ptep);
+
+	if (pte_present(pte))
+		WARN_ON_ONCE(uv_convert_from_secure(pte_val(pte) & PAGE_MASK));
+	return 0;
+}
+
+static const struct mm_walk_ops reset_acc_walk_ops = {
+	.pte_entry		= __s390_reset_acc,
+};
+
+#include <linux/sched/mm.h>
+void s390_reset_acc(struct mm_struct *mm)
+{
+	/*
+	 * we might be called during
+	 * reset:                             we walk the pages and clear
+	 * close of all kvm file descriptors: we walk the pages and clear
+	 * exit of process on fd closure:     vma already gone, do nothing
+	 */
+	if (!mmget_not_zero(mm))
+		return;
+	down_read(&mm->mmap_sem);
+	walk_page_range(mm, 0, TASK_SIZE, &reset_acc_walk_ops, NULL);
+	up_read(&mm->mmap_sem);
+	mmput(mm);
+}
+EXPORT_SYMBOL_GPL(s390_reset_acc);
-- 
2.25.0

