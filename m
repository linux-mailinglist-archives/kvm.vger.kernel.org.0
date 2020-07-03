Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4145321399B
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 13:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgGCLvX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 07:51:23 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38604 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726108AbgGCLvT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Jul 2020 07:51:19 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 063BVNhq148913
        for <kvm@vger.kernel.org>; Fri, 3 Jul 2020 07:51:17 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 320s8d0gyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 03 Jul 2020 07:51:17 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 063BWGsd151440
        for <kvm@vger.kernel.org>; Fri, 3 Jul 2020 07:51:17 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 320s8d0gy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 07:51:17 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 063BoIZw000485;
        Fri, 3 Jul 2020 11:51:15 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 321vnvg75g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Jul 2020 11:51:15 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 063BpD0J11338190
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Jul 2020 11:51:13 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5887811C04A;
        Fri,  3 Jul 2020 11:51:13 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E99D411C050;
        Fri,  3 Jul 2020 11:51:12 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.9.164])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  3 Jul 2020 11:51:12 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v1 4/4] lib/vmalloc: allow vm_memalign with alignment > PAGE_SIZE
Date:   Fri,  3 Jul 2020 13:51:09 +0200
Message-Id: <20200703115109.39139-5-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200703115109.39139-1-imbrenda@linux.ibm.com>
References: <20200703115109.39139-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-03_03:2020-07-02,2020-07-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 suspectscore=0 priorityscore=1501 clxscore=1015 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 cotscore=-2147483648 adultscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2007030078
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow allocating aligned virtual memory with alignment larger than only
one page.

Add a check that the backing pages were actually allocated.

Export the alloc_vpages_aligned function to allow users to allocate
non-backed aligned virtual addresses.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/vmalloc.h |  3 +++
 lib/vmalloc.c | 40 ++++++++++++++++++++++++++++++++--------
 2 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/lib/vmalloc.h b/lib/vmalloc.h
index 2b563f4..fa3fa22 100644
--- a/lib/vmalloc.h
+++ b/lib/vmalloc.h
@@ -5,6 +5,9 @@
 
 /* Allocate consecutive virtual pages (without backing) */
 extern void *alloc_vpages(ulong nr);
+/* Allocate consecutive and aligned virtual pages (without backing) */
+extern void *alloc_vpages_aligned(ulong nr, unsigned int alignment_pages);
+
 /* Allocate one virtual page (without backing) */
 extern void *alloc_vpage(void);
 /* Set the top of the virtual address space */
diff --git a/lib/vmalloc.c b/lib/vmalloc.c
index 9237a0f..2c482aa 100644
--- a/lib/vmalloc.c
+++ b/lib/vmalloc.c
@@ -12,19 +12,28 @@
 #include "alloc.h"
 #include "alloc_phys.h"
 #include "alloc_page.h"
+#include <bitops.h>
 #include "vmalloc.h"
 
 static struct spinlock lock;
 static void *vfree_top = 0;
 static void *page_root;
 
-void *alloc_vpages(ulong nr)
+/*
+ * Allocate a certain number of pages from the virtual address space (without
+ * physical backing).
+ *
+ * nr is the number of pages to allocate
+ * alignment_pages is the alignment of the allocation *in pages*
+ */
+static void *alloc_vpages_intern(ulong nr, unsigned int alignment_pages)
 {
 	uintptr_t ptr;
 
 	spin_lock(&lock);
 	ptr = (uintptr_t)vfree_top;
 	ptr -= PAGE_SIZE * nr;
+	ptr &= GENMASK_ULL(63, PAGE_SHIFT + get_order(alignment_pages));
 	vfree_top = (void *)ptr;
 	spin_unlock(&lock);
 
@@ -32,6 +41,16 @@ void *alloc_vpages(ulong nr)
 	return (void *)ptr;
 }
 
+void *alloc_vpages(ulong nr)
+{
+	return alloc_vpages_intern(nr, 1);
+}
+
+void *alloc_vpages_aligned(ulong nr, unsigned int alignment_pages)
+{
+	return alloc_vpages_intern(nr, alignment_pages);
+}
+
 void *alloc_vpage(void)
 {
 	return alloc_vpages(1);
@@ -55,17 +74,22 @@ void *vmap(phys_addr_t phys, size_t size)
 	return mem;
 }
 
+/*
+ * Allocate virtual memory, with the specified minimum alignment.
+ */
 static void *vm_memalign(size_t alignment, size_t size)
 {
+	phys_addr_t pa;
 	void *mem, *p;
-	size_t pages;
 
-	assert(alignment <= PAGE_SIZE);
-	size = PAGE_ALIGN(size);
-	pages = size / PAGE_SIZE;
-	mem = p = alloc_vpages(pages);
-	while (pages--) {
-		phys_addr_t pa = virt_to_phys(alloc_page());
+	assert(is_power_of_2(alignment));
+
+	size = PAGE_ALIGN(size) / PAGE_SIZE;
+	alignment = PAGE_ALIGN(alignment) / PAGE_SIZE;
+	mem = p = alloc_vpages_intern(size, alignment);
+	while (size--) {
+		pa = virt_to_phys(alloc_page());
+		assert(pa);
 		install_page(page_root, pa, p);
 		p += PAGE_SIZE;
 	}
-- 
2.26.2

