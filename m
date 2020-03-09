Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D81817DBCF
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 09:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgCIIvh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 04:51:37 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38788 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725796AbgCIIvf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Mar 2020 04:51:35 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0298pSQd050608
        for <kvm@vger.kernel.org>; Mon, 9 Mar 2020 04:51:34 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2ym6n1ewuk-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 04:51:34 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <borntraeger@de.ibm.com>;
        Mon, 9 Mar 2020 08:51:32 -0000
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 9 Mar 2020 08:51:30 -0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0298oTR041484776
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 9 Mar 2020 08:50:29 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A8DB0A405C;
        Mon,  9 Mar 2020 08:51:28 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90750A4062;
        Mon,  9 Mar 2020 08:51:28 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon,  9 Mar 2020 08:51:28 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 25651)
        id 518A7E0251; Mon,  9 Mar 2020 09:51:28 +0100 (CET)
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
Subject: [GIT PULL 04/36] s390/mm: add (non)secure page access exceptions handlers
Date:   Mon,  9 Mar 2020 09:50:54 +0100
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309085126.3334302-1-borntraeger@de.ibm.com>
References: <20200309085126.3334302-1-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20030908-0008-0000-0000-0000035AA7DC
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20030908-0009-0000-0000-00004A7BE6E2
Message-Id: <20200309085126.3334302-5-borntraeger@de.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-09_02:2020-03-06,2020-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 bulkscore=0 adultscore=0 impostorscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003090066
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vasily Gorbik <gor@linux.ibm.com>

Add exceptions handlers performing transparent transition of non-secure
pages to secure (import) upon guest access and secure pages to
non-secure (export) upon hypervisor access.

Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
[frankja@linux.ibm.com: adding checks for failures]
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
[imbrenda@linux.ibm.com:  adding a check for gmap fault]
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
[borntraeger@de.ibm.com: patch merging, splitting, fixing]
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kernel/entry.h     |  2 +
 arch/s390/kernel/pgm_check.S |  4 +-
 arch/s390/mm/fault.c         | 78 ++++++++++++++++++++++++++++++++++++
 3 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/entry.h b/arch/s390/kernel/entry.h
index 1d3927e01a5f..faca269d5f27 100644
--- a/arch/s390/kernel/entry.h
+++ b/arch/s390/kernel/entry.h
@@ -24,6 +24,8 @@ asmlinkage void do_syscall_trace_exit(struct pt_regs *regs);
 
 void do_protection_exception(struct pt_regs *regs);
 void do_dat_exception(struct pt_regs *regs);
+void do_secure_storage_access(struct pt_regs *regs);
+void do_non_secure_storage_access(struct pt_regs *regs);
 
 void addressing_exception(struct pt_regs *regs);
 void data_exception(struct pt_regs *regs);
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
2.24.1

