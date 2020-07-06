Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04B4215C20
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 18:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729550AbgGFQos (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 12:44:48 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31212 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729528AbgGFQor (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Jul 2020 12:44:47 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 066GYM9M152093
        for <kvm@vger.kernel.org>; Mon, 6 Jul 2020 12:44:47 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 322n2rjsbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 06 Jul 2020 12:44:47 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 066GZlXZ158720
        for <kvm@vger.kernel.org>; Mon, 6 Jul 2020 12:44:46 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 322n2rjsar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jul 2020 12:44:46 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 066GQDMU013190;
        Mon, 6 Jul 2020 16:44:44 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 322hd82hxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jul 2020 16:44:44 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 066Gg61R64749932
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Jul 2020 16:42:06 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0D81011C050;
        Mon,  6 Jul 2020 16:43:27 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B49B11C04C;
        Mon,  6 Jul 2020 16:43:26 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.9.164])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  6 Jul 2020 16:43:26 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     frankja@linux.ibm.com, thuth@redhat.com, david@redhat.com,
        drjones@redhat.com
Subject: [kvm-unit-tests PATCH v2 4/4] lib/vmalloc: allow vm_memalign with alignment > PAGE_SIZE
Date:   Mon,  6 Jul 2020 18:43:24 +0200
Message-Id: <20200706164324.81123-5-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200706164324.81123-1-imbrenda@linux.ibm.com>
References: <20200706164324.81123-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-06_15:2020-07-06,2020-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 clxscore=1015 adultscore=0 phishscore=0 priorityscore=1501
 cotscore=-2147483648 impostorscore=0 bulkscore=0 suspectscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007060120
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
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 lib/vmalloc.h |  3 +++
 lib/vmalloc.c | 35 +++++++++++++++++++++++++++--------
 2 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/lib/vmalloc.h b/lib/vmalloc.h
index 2b563f4..8b158f5 100644
--- a/lib/vmalloc.h
+++ b/lib/vmalloc.h
@@ -5,6 +5,9 @@
 
 /* Allocate consecutive virtual pages (without backing) */
 extern void *alloc_vpages(ulong nr);
+/* Allocate consecutive and aligned virtual pages (without backing) */
+extern void *alloc_vpages_aligned(ulong nr, unsigned int alignment_order);
+
 /* Allocate one virtual page (without backing) */
 extern void *alloc_vpage(void);
 /* Set the top of the virtual address space */
diff --git a/lib/vmalloc.c b/lib/vmalloc.c
index 9237a0f..e0c7b6b 100644
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
+void *alloc_vpages_aligned(ulong nr, unsigned int align_order)
 {
 	uintptr_t ptr;
 
 	spin_lock(&lock);
 	ptr = (uintptr_t)vfree_top;
 	ptr -= PAGE_SIZE * nr;
+	ptr &= GENMASK_ULL(63, PAGE_SHIFT + align_order);
 	vfree_top = (void *)ptr;
 	spin_unlock(&lock);
 
@@ -32,6 +41,11 @@ void *alloc_vpages(ulong nr)
 	return (void *)ptr;
 }
 
+void *alloc_vpages(ulong nr)
+{
+	return alloc_vpages_aligned(nr, 0);
+}
+
 void *alloc_vpage(void)
 {
 	return alloc_vpages(1);
@@ -55,17 +69,22 @@ void *vmap(phys_addr_t phys, size_t size)
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
+	alignment = get_order(PAGE_ALIGN(alignment) / PAGE_SIZE);
+	mem = p = alloc_vpages_aligned(size, alignment);
+	while (size--) {
+		pa = virt_to_phys(alloc_page());
+		assert(pa);
 		install_page(page_root, pa, p);
 		p += PAGE_SIZE;
 	}
-- 
2.26.2

