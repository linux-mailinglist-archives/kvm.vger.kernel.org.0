Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 000DF1506D7
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 14:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbgBCNUH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 08:20:07 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8466 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728273AbgBCNUF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 Feb 2020 08:20:05 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 013DGCdS036603
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 08:20:05 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xxm8kg4v6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2020 08:20:04 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 013DGRiZ037393
        for <kvm@vger.kernel.org>; Mon, 3 Feb 2020 08:20:04 -0500
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2xxm8kg4um-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 08:20:04 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 013DFSGQ028727;
        Mon, 3 Feb 2020 13:20:03 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02dal.us.ibm.com with ESMTP id 2xw0y6da4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Feb 2020 13:20:03 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 013DK1de43974946
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Feb 2020 13:20:02 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C54BD2806D;
        Mon,  3 Feb 2020 13:19:58 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C124F2805C;
        Mon,  3 Feb 2020 13:19:58 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.114.17.106])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  3 Feb 2020 13:19:58 +0000 (GMT)
From:   Christian Borntraeger <borntraeger@de.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: [RFCv2 06/37] s390: add (non)secure page access exceptions handlers
Date:   Mon,  3 Feb 2020 08:19:26 -0500
Message-Id: <20200203131957.383915-7-borntraeger@de.ibm.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20200203131957.383915-1-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-03_04:2020-02-02,2020-02-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 suspectscore=0 spamscore=0 malwarescore=0 phishscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2002030099
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

Add exceptions handlers performing transparent transition of non-secure
pages to secure (import) upon guest access and secure pages to
non-secure (export) upon hypervisor access.

Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
[adding checks for failures]
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
[further changes like adding a check for gmap fault]
---
 arch/s390/kernel/pgm_check.S |  4 +-
 arch/s390/mm/fault.c         | 87 ++++++++++++++++++++++++++++++++++++
 2 files changed, 89 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/pgm_check.S b/arch/s390/kernel/pgm_check.S
index 59dee9d3bebf..27ac4f324c70 100644
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
 PGM_CHECK_DEFAULT			/* 40 */
 PGM_CHECK_DEFAULT			/* 41 */
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 7b0bb475c166..bd75b0765cf1 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -38,6 +38,7 @@
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
 #include <asm/facility.h>
+#include <asm/uv.h>
 #include "../kernel/entry.h"
 
 #define __FAIL_ADDR_MASK -4096L
@@ -816,3 +817,89 @@ static int __init pfault_irq_init(void)
 early_initcall(pfault_irq_init);
 
 #endif /* CONFIG_PFAULT */
+
+#ifdef CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST
+
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
+	struct uv_cb_cts uvcb = {
+		.header.cmd = UVC_CMD_CONV_TO_SEC_STOR,
+		.header.len = sizeof(uvcb),
+		.guest_handle = gmap->se_handle,
+		.gaddr = gaddr,
+	};
+	int rc;
+
+	if (get_fault_type(regs) != GMAP_FAULT) {
+		do_fault_error(regs, VM_READ | VM_WRITE, VM_FAULT_BADMAP);
+		WARN_ON_ONCE(1);
+		return;
+	}
+
+	rc = uv_make_secure(gmap, gaddr, &uvcb, 0);
+	if (rc == -EINVAL && uvcb.header.rc != 0x104)
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
2.24.0

