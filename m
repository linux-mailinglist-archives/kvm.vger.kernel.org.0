Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347BE27AFE9
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 16:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgI1OXq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 10:23:46 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:47758 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726526AbgI1OXp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Sep 2020 10:23:45 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08SEJhYP137282;
        Mon, 28 Sep 2020 10:23:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=Etdk7PsqeLaD3Vusxf283pn0UpNfftluNM0Nl0Hj960=;
 b=WF5OUr24uXnLy6qDL+wZzMreSFVbnAfdZHxOgiML8BSJDhURlV6DfAeOzCYr4JmX5oQi
 7i015PuAjo1i6rk1Yy/4mbJKeY/k2AK4wptuuGVRSUAZOvgm8sBeGx5F7eDdiadOzgQ4
 +9B9kGEMqLn4ViA7KxgzoEBYic1TObOF5grkRi08fuwJVoWvsSDHMxcD56IG1p72rvRn
 CjCPNzT+Lamy3ZJzMqysQN4DifBGWeglRodA3dGTEla38AykuAyzJVUkHecPwjfPrYJt
 jt1nfizo3N9Zvanw3PK8QLqiOC9Ai8NvmCgJv67vpkLgVmJl14eOMvM5n8kdnG8+5s+T DA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33uhgf8227-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Sep 2020 10:23:44 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08SEKVl2142340;
        Mon, 28 Sep 2020 10:23:44 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33uhgf821s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Sep 2020 10:23:44 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08SEMLNp008452;
        Mon, 28 Sep 2020 14:23:42 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 33svwgs5b8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Sep 2020 14:23:42 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08SENdHi10551706
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 14:23:39 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F73542041;
        Mon, 28 Sep 2020 14:23:39 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D7BFF4204D;
        Mon, 28 Sep 2020 14:23:38 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.66.164])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 28 Sep 2020 14:23:38 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 1/4] memory: allocation in low memory
Date:   Mon, 28 Sep 2020 16:23:34 +0200
Message-Id: <1601303017-8176-2-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601303017-8176-1-git-send-email-pmorel@linux.ibm.com>
References: <1601303017-8176-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-28_14:2020-09-28,2020-09-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=1 mlxscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 impostorscore=0 mlxlogscore=999 spamscore=0 adultscore=0 clxscore=1015
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009280108
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some architectures need allocations to be done under a
specific address limit to allow DMA from I/O.

We propose here a very simple page allocator to get
pages allocated under this specific limit.

The DMA page allocator will only use part of the available memory
under the DMA address limit to let room for the standard allocator.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/alloc_dma_page.c | 57 ++++++++++++++++++++++++++++++++++++++++++++
 lib/alloc_dma_page.h | 24 +++++++++++++++++++
 lib/s390x/sclp.c     |  2 ++
 s390x/Makefile       |  1 +
 4 files changed, 84 insertions(+)
 create mode 100644 lib/alloc_dma_page.c
 create mode 100644 lib/alloc_dma_page.h

diff --git a/lib/alloc_dma_page.c b/lib/alloc_dma_page.c
new file mode 100644
index 0000000..6a16e38
--- /dev/null
+++ b/lib/alloc_dma_page.c
@@ -0,0 +1,57 @@
+/*
+ * Page allocator for DMA
+ *
+ * Copyright (c) IBM, Corp. 2020
+ *
+ * Authors:
+ *  Pierre Morel <pmorel@linux.ibm.com>
+ *
+ * This code is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU Library General Public License version 2.
+ */
+#include <libcflat.h>
+#include <asm/spinlock.h>
+#include <alloc_dma_page.h>
+
+static struct spinlock lock;
+static void *dma_freelist = 0;
+
+void put_dma_page(void *dma_page)
+{
+	spin_lock(&lock);
+	*(void **)dma_page = dma_freelist;
+	dma_freelist = dma_page;
+	spin_unlock(&lock);
+}
+
+void *get_dma_page(void)
+{
+	void *p = NULL;
+
+	spin_lock(&lock);
+	if (!dma_freelist)
+		goto end_unlock;
+
+	p = dma_freelist;
+	dma_freelist = *(void **)dma_freelist;
+
+end_unlock:
+	spin_unlock(&lock);
+	return p;
+}
+
+phys_addr_t dma_page_alloc_init(phys_addr_t start, phys_addr_t end)
+{
+	int start_pfn = start >> PAGE_SHIFT;
+	int nb_pfn = ((end - start) >> PAGE_SHIFT) - 1;
+	int max, pfn;
+
+	max = start_pfn + nb_pfn / DMA_ALLOC_RATIO;
+	if (max > DMA_MAX_PFN)
+		max = DMA_MAX_PFN;
+
+	for (pfn = start_pfn; pfn < max; pfn++)
+		put_dma_page((void *)((unsigned long) pfn << PAGE_SHIFT));
+
+	return (phys_addr_t)pfn << PAGE_SHIFT;
+}
diff --git a/lib/alloc_dma_page.h b/lib/alloc_dma_page.h
new file mode 100644
index 0000000..85e1d2f
--- /dev/null
+++ b/lib/alloc_dma_page.h
@@ -0,0 +1,24 @@
+/*
+ * Page allocator for DMA definitions
+ *
+ * Copyright (c) IBM, Corp. 2020
+ *
+ * Authors:
+ *  Pierre Morel <pmorel@linux.ibm.com>
+ *
+ * This code is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU Library General Public License version 2.
+ */
+#ifndef _ALLOC_DMA_PAGE_H_
+#define _ALLOC_DMA_PAGE_H_
+
+#include <asm/page.h>
+
+void put_dma_page(void *dma_page);
+void *get_dma_page(void);
+phys_addr_t dma_page_alloc_init(phys_addr_t start_pfn, phys_addr_t nb_pages);
+
+#define DMA_MAX_PFN	(0x80000000 >> PAGE_SHIFT)
+#define DMA_ALLOC_RATIO	8
+
+#endif /* _ALLOC_DMA_PAGE_H_ */
diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
index 4054d0e..9c95ca5 100644
--- a/lib/s390x/sclp.c
+++ b/lib/s390x/sclp.c
@@ -19,6 +19,7 @@
 #include "sclp.h"
 #include <alloc_phys.h>
 #include <alloc_page.h>
+#include <alloc_dma_page.h>
 
 extern unsigned long stacktop;
 
@@ -35,6 +36,7 @@ static void mem_init(phys_addr_t mem_end)
 	phys_addr_t freemem_start = (phys_addr_t)&stacktop;
 	phys_addr_t base, top;
 
+	freemem_start = dma_page_alloc_init(freemem_start, mem_end);
 	phys_alloc_init(freemem_start, mem_end - freemem_start);
 	phys_alloc_get_unused(&base, &top);
 	base = (base + PAGE_SIZE - 1) & -PAGE_SIZE;
diff --git a/s390x/Makefile b/s390x/Makefile
index 9144d57..109ef9f 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -52,6 +52,7 @@ cflatobjs += lib/alloc_phys.o
 cflatobjs += lib/alloc_page.o
 cflatobjs += lib/vmalloc.o
 cflatobjs += lib/alloc_phys.o
+cflatobjs += lib/alloc_dma_page.o
 cflatobjs += lib/s390x/io.o
 cflatobjs += lib/s390x/stack.o
 cflatobjs += lib/s390x/sclp.o
-- 
2.25.1

