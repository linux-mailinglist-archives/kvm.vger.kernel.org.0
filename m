Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C448EE30C0
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 13:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409230AbfJXLmK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 07:42:10 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24024 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2409221AbfJXLmJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Oct 2019 07:42:09 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9OBbAiI020771
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 07:42:08 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vuabhj5dv-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 07:42:07 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 24 Oct 2019 12:42:05 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 24 Oct 2019 12:42:03 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9OBg12p53280870
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 11:42:01 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B4E25204F;
        Thu, 24 Oct 2019 11:42:01 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.131])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id F348A5204E;
        Thu, 24 Oct 2019 11:41:59 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com, frankja@linux.ibm.com
Subject: [RFC 10/37] s390: add (non)secure page access exceptions handlers
Date:   Thu, 24 Oct 2019 07:40:32 -0400
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024114059.102802-1-frankja@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19102411-0016-0000-0000-000002BCC9AD
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102411-0017-0000-0000-0000331E0E48
Message-Id: <20191024114059.102802-11-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-24_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910240115
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

Add exceptions handlers performing transparent transition of non-secure
pages to secure (import) upon guest access and secure pages to
non-secure (export) upon hypervisor access.

Current assumption is that guest pages are pinned.

Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
---
 arch/s390/kernel/pgm_check.S |  4 +--
 arch/s390/mm/fault.c         | 64 ++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+), 2 deletions(-)

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
index 7b0bb475c166..0c4577472432 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -38,6 +38,7 @@
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
 #include <asm/facility.h>
+#include <asm/uv.h>
 #include "../kernel/entry.h"
 
 #define __FAIL_ADDR_MASK -4096L
@@ -816,3 +817,66 @@ static int __init pfault_irq_init(void)
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
+		page = follow_page(vma, addr, FOLL_GET);
+		if (IS_ERR_OR_NULL(page)) {
+			up_read(&mm->mmap_sem);
+			break;
+		}
+		uv_convert_from_secure(page_to_phys(page));
+		put_page(page);
+		up_read(&mm->mmap_sem);
+		break;
+	case KERNEL_FAULT:
+		uv_convert_from_secure(__pa(addr));
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
+	uv_convert_to_secure(gmap, gaddr);
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
2.20.1

