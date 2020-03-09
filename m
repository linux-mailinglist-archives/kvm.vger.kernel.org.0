Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBD717DBD3
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 09:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgCIIwh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 04:52:37 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40726 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726536AbgCIIvh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Mar 2020 04:51:37 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0298oFCH095512
        for <kvm@vger.kernel.org>; Mon, 9 Mar 2020 04:51:36 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ym90ecp2j-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 04:51:36 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 9 Mar 2020 08:51:34 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 9 Mar 2020 08:51:32 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0298pVvB1376580
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Mar 2020 08:51:31 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D3D0A405C;
        Mon,  9 Mar 2020 08:51:31 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A76DA405B;
        Mon,  9 Mar 2020 08:51:31 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon,  9 Mar 2020 08:51:31 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id E191DE0251; Mon,  9 Mar 2020 09:51:30 +0100 (CET)
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
Subject: [GIT PULL 11/36] KVM: s390/mm: Make pages accessible before destroying the guest
Date:   Mon,  9 Mar 2020 09:51:01 +0100
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309085126.3334302-1-borntraeger@de.ibm.com>
References: <20200309085126.3334302-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20030908-4275-0000-0000-000003A9B367
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030908-4276-0000-0000-000038BEC925
Message-Id: <20200309085126.3334302-12-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-09_02:2020-03-06,2020-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 spamscore=0 mlxlogscore=608 lowpriorityscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003090066
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
 arch/s390/kvm/pv.c           |  3 +++
 arch/s390/mm/gmap.c          | 35 +++++++++++++++++++++++++++++++++++
 3 files changed, 39 insertions(+)

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
index e9e020475f4a..9840ee49e572 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -140,6 +140,9 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 {
 	int cc;
 
+	/* make all pages accessible before destroying the guest */
+	s390_reset_acc(kvm->mm);
+
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
2.24.1

