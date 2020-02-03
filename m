Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7301506D9
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 14:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728307AbgBCNUJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 08:20:09 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61898 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728288AbgBCNUI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Feb 2020 08:20:08 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 013DDqJs087092
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 08:20:07 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xxbmn03js-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2020 08:20:07 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 013DDwwL087607
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 08:20:06 -0500
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xxbmn03j3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 08:20:06 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 013DFVIM006131;
        Mon, 3 Feb 2020 13:20:06 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02wdc.us.ibm.com with ESMTP id 2xw0y6109a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 13:20:06 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 013DK4RT51052828
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Feb 2020 13:20:04 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4508D28073;
        Mon,  3 Feb 2020 13:20:04 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40FE52806F;
        Mon,  3 Feb 2020 13:20:04 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  3 Feb 2020 13:20:04 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [RFCv2 11/37] KVM: s390/mm: Make pages accessible before destroying the guest
Date:   Mon,  3 Feb 2020 08:19:31 -0500
Message-Id: <20200203131957.383915-12-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200203131957.383915-1-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-03_04:2020-02-02,2020-02-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 suspectscore=0 priorityscore=1501 bulkscore=0 phishscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=678 clxscore=1015
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2002030099
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Before we destroy the secure configuration, we better make all
pages accessible again. This also happens during reboot, where we reboot
into a non-secure guest that then can go again into a secure mode. As
this "new" secure guest will have a new ID we cannot reuse the old page
state.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/include/asm/pgtable.h |  1 +
 arch/s390/kvm/pv.c              |  2 ++
 arch/s390/mm/gmap.c             | 35 +++++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 65b6bb47af0a..6e167dcc35f1 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1669,6 +1669,7 @@ extern int vmem_remove_mapping(unsigned long start, unsigned long size);
 extern int s390_enable_sie(void);
 extern int s390_enable_skey(void);
 extern void s390_reset_cmma(struct mm_struct *mm);
+extern void s390_reset_acc(struct mm_struct *mm);
 
 /* s390 has a private copy of get unmapped area to deal with cache synonyms */
 #define HAVE_ARCH_UNMAPPED_AREA
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index a867b9e9c069..24d802072ac7 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -66,6 +66,8 @@ int kvm_s390_pv_destroy_vm(struct kvm *kvm)
 	int rc;
 	u32 ret;
 
+	/* make all pages accessible before destroying the guest */
+	s390_reset_acc(kvm->mm);
 	rc = uv_cmd_nodata(kvm_s390_pv_handle(kvm),
 			   UVC_CMD_DESTROY_SEC_CONF, &ret);
 	WRITE_ONCE(kvm->arch.gmap->se_handle, 0);
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index bf365a09f900..0b00e8d5fa39 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2648,3 +2648,38 @@ void s390_reset_cmma(struct mm_struct *mm)
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
+		uv_convert_from_secure(pte_val(pte) & PAGE_MASK);
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
+	 * reset:                            we walk the pages and clear
+	 * close of all kvm file descriptor: we walk the pages and clear
+	 * exit of process on fd closure:    vma already gone, do nothing
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
2.24.0

