Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0113A16A53F
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 12:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbgBXLlq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 06:41:46 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33126 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727451AbgBXLlQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Feb 2020 06:41:16 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01OBcCVN086433;
        Mon, 24 Feb 2020 06:41:15 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yb0095a0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 06:41:15 -0500
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 01OBcw0Z087953;
        Mon, 24 Feb 2020 06:41:14 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yb00959ye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 06:41:14 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 01OBZBYe031965;
        Mon, 24 Feb 2020 11:41:12 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma02dal.us.ibm.com with ESMTP id 2yaux6fuqg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 11:41:12 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01OBfAXg51970340
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Feb 2020 11:41:10 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 445212805E;
        Mon, 24 Feb 2020 11:41:10 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34CCC2805A;
        Mon, 24 Feb 2020 11:41:10 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 24 Feb 2020 11:41:10 +0000 (GMT)
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
Subject: [PATCH v4 06/36] s390/mm: add (non)secure page access exceptions handlers
Date:   Mon, 24 Feb 2020 06:40:37 -0500
Message-Id: <20200224114107.4646-7-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200224114107.4646-1-borntraeger@de.ibm.com>
References: <20200224114107.4646-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-24_02:2020-02-21,2020-02-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 impostorscore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240098
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

Add exceptions handlers performing transparent transition of non-secure
pages to secure (import) upon guest access and secure pages to
non-secure (export) upon hypervisor access.

Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
[frankja@linux.ibm.com: adding checks for failures]
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
[imbrenda@linux.ibm.com:  adding a check for gmap fault]
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
[borntraeger@de.ibm.com: patch merging, splitting, fixing]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kernel/pgm_check.S |  4 +-
 arch/s390/mm/fault.c         | 78 ++++++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/pgm_check.S b/arch/s390/kernel/pgm_check.S
index eee3a482195a..2c27907a5ffc 100644
--- a/arch/s390/kernel/pgm_check.S
+++ b/arch/s390/kernel/pgm_check.S
@@ -78,8 +78,8 @@ PGM_CHECK(do_dat_exception)		/* 39 */
 PGM_CHECK(do_dat_exception)		/* 3a */
 PGM_CHECK(do_dat_exception)		/* 3b */
 PGM_CHECK_DEFAULT			/* 3c */
-PGM_CHECK_DEFAULT			/* 3d */
-PGM_CHECK_DEFAULT			/* 3e */
+PGM_CHECK(do_secure_storage_access)	/* 3d */
+PGM_CHECK(do_non_secure_storage_access)	/* 3e */
 PGM_CHECK_DEFAULT			/* 3f */
 PGM_CHECK(monitor_event_exception)	/* 40 */
 PGM_CHECK_DEFAULT			/* 41 */
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 7b0bb475c166..7bd86ebc882f 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -38,6 +38,7 @@
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
 #include <asm/facility.h>
+#include <asm/uv.h>
 #include "../kernel/entry.h"
 
 #define __FAIL_ADDR_MASK -4096L
@@ -816,3 +817,80 @@ static int __init pfault_irq_init(void)
 early_initcall(pfault_irq_init);
 
 #endif /* CONFIG_PFAULT */
+
+#if IS_ENABLED(CONFIG_PGSTE)
+void do_secure_storage_access(struct pt_regs *regs)
+{
+	unsigned long addr = regs->int_parm_long & __FAIL_ADDR_MASK;
+	struct vm_area_struct *vma;
+	struct mm_struct *mm;
+	struct page *page;
+	int rc;
+
+	switch (get_fault_type(regs)) {
+	case USER_FAULT:
+		mm = current->mm;
+		down_read(&mm->mmap_sem);
+		vma = find_vma(mm, addr);
+		if (!vma) {
+			up_read(&mm->mmap_sem);
+			do_fault_error(regs, VM_READ | VM_WRITE, VM_FAULT_BADMAP);
+			break;
+		}
+		page = follow_page(vma, addr, FOLL_WRITE | FOLL_GET);
+		if (IS_ERR_OR_NULL(page)) {
+			up_read(&mm->mmap_sem);
+			break;
+		}
+		if (arch_make_page_accessible(page))
+			send_sig(SIGSEGV, current, 0);
+		put_page(page);
+		up_read(&mm->mmap_sem);
+		break;
+	case KERNEL_FAULT:
+		page = phys_to_page(addr);
+		if (unlikely(!try_get_page(page)))
+			break;
+		rc = arch_make_page_accessible(page);
+		put_page(page);
+		if (rc)
+			BUG();
+		break;
+	case VDSO_FAULT:
+		/* fallthrough */
+	case GMAP_FAULT:
+		/* fallthrough */
+	default:
+		do_fault_error(regs, VM_READ | VM_WRITE, VM_FAULT_BADMAP);
+		WARN_ON_ONCE(1);
+	}
+}
+NOKPROBE_SYMBOL(do_secure_storage_access);
+
+void do_non_secure_storage_access(struct pt_regs *regs)
+{
+	unsigned long gaddr = regs->int_parm_long & __FAIL_ADDR_MASK;
+	struct gmap *gmap = (struct gmap *)S390_lowcore.gmap;
+
+	if (get_fault_type(regs) != GMAP_FAULT) {
+		do_fault_error(regs, VM_READ | VM_WRITE, VM_FAULT_BADMAP);
+		WARN_ON_ONCE(1);
+		return;
+	}
+
+	if (gmap_convert_to_secure(gmap, gaddr) == -EINVAL)
+		send_sig(SIGSEGV, current, 0);
+}
+NOKPROBE_SYMBOL(do_non_secure_storage_access);
+
+#else
+void do_secure_storage_access(struct pt_regs *regs)
+{
+	default_trap_handler(regs);
+}
+
+void do_non_secure_storage_access(struct pt_regs *regs)
+{
+	default_trap_handler(regs);
+}
+#endif
-- 
2.25.0

