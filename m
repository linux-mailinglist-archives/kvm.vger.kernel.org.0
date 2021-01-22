Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D935300430
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 14:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbhAVN25 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 08:28:57 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16706 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727847AbhAVN2q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Jan 2021 08:28:46 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10MDKbv9134595;
        Fri, 22 Jan 2021 08:27:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=I0eSKaTS0TvVmNPxXhQGgshl36d4eskgLwo4v+ecqR4=;
 b=fGWnixLWxkq2wpi7qmKixkZGexXOV2J9NKWZ6IZXnpizu8N4z2myOLgeOWkOrdX9lkg4
 HXo+Pu3f+GNKJmV8WJ4fjr7lfON5yX3ty+ITyGkHTPxF/iNnQrktDNGjaiQZmBais2D0
 xNiJFMQixm8EFTaPfagmAoA4+XtyDjYMkU7YoBqoI68dkdbFtYfNuYEPs1IbIJbVTHQ3
 QHfF+AXp0Q+r9LXgsLOkZTQgrm3CtLfpo1vx3Egc3o9z9/OLv06BgZHWg5bRqPuytNwS
 cSBbHLv/VS8oYhjxKxi3KJJJfNkwVtkuctuR+/6dNKIKJqDPU/Rxddj/lk8kf88PNJVG Lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 367ygpr427-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 08:27:49 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10MDLhRE141361;
        Fri, 22 Jan 2021 08:27:49 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 367ygpr416-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 08:27:48 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10MDJp7D015192;
        Fri, 22 Jan 2021 13:27:46 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 367k1c0aad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 13:27:46 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10MDRh9H16908768
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 13:27:43 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB33EA4053;
        Fri, 22 Jan 2021 13:27:43 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58CFCA4040;
        Fri, 22 Jan 2021 13:27:43 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.82.252])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Jan 2021 13:27:43 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com, drjones@redhat.com, pbonzini@redhat.com
Subject: [kvm-unit-tests PATCH v5 2/3] s390x: define UV compatible I/O allocation
Date:   Fri, 22 Jan 2021 14:27:39 +0100
Message-Id: <1611322060-1972-3-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611322060-1972-1-git-send-email-pmorel@linux.ibm.com>
References: <1611322060-1972-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-22_09:2021-01-21,2021-01-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 phishscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101220071
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To centralize the memory allocation for I/O we define
the alloc_io_mem/free_io_mem functions which share the I/O
memory with the host in case the guest runs with
protected virtualization.

These functions allocate on a page integral granularity to
ensure a dedicated sharing of the allocated objects.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/malloc_io.c | 71 +++++++++++++++++++++++++++++++++++++++++++
 lib/s390x/malloc_io.h | 45 +++++++++++++++++++++++++++
 s390x/Makefile        |  1 +
 3 files changed, 117 insertions(+)
 create mode 100644 lib/s390x/malloc_io.c
 create mode 100644 lib/s390x/malloc_io.h

diff --git a/lib/s390x/malloc_io.c b/lib/s390x/malloc_io.c
new file mode 100644
index 0000000..b01222e
--- /dev/null
+++ b/lib/s390x/malloc_io.c
@@ -0,0 +1,71 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * I/O page allocation
+ *
+ * Copyright (c) 2021 IBM Corp
+ *
+ * Authors:
+ *  Pierre Morel <pmorel@linux.ibm.com>
+ *
+ * Using this interface provide host access to the allocated pages in
+ * case the guest is a secure guest.
+ * This is needed for I/O buffers.
+ *
+ */
+#include <libcflat.h>
+#include <asm/page.h>
+#include <asm/uv.h>
+#include <malloc_io.h>
+#include <alloc_page.h>
+#include <asm/facility.h>
+#include <bitops.h>
+
+static int share_pages(void *p, int count)
+{
+	int i = 0;
+
+	for (i = 0; i < count; i++, p += PAGE_SIZE)
+		if (uv_set_shared((unsigned long)p))
+			break;
+	return i;
+}
+
+static void unshare_pages(void *p, int count)
+{
+	int i;
+
+	for (i = count; i > 0; i--, p += PAGE_SIZE)
+		uv_remove_shared((unsigned long)p);
+}
+
+void *alloc_io_mem(int size, int flags)
+{
+	int order = get_order(size >> PAGE_SHIFT);
+	void *p;
+	int n;
+
+	assert(size);
+
+	p = alloc_pages_flags(order, AREA_DMA31 | flags);
+	if (!p || !test_facility(158))
+		return p;
+
+	n = share_pages(p, 1 << order);
+	if (n == 1 << order)
+		return p;
+
+	unshare_pages(p, n);
+	free_pages(p);
+	return NULL;
+}
+
+void free_io_mem(void *p, int size)
+{
+	int order = get_order(size >> PAGE_SHIFT);
+
+	assert(IS_ALIGNED((uintptr_t)p, PAGE_SIZE));
+
+	if (test_facility(158))
+		unshare_pages(p, 1 << order);
+	free_pages(p);
+}
diff --git a/lib/s390x/malloc_io.h b/lib/s390x/malloc_io.h
new file mode 100644
index 0000000..cc5fad7
--- /dev/null
+++ b/lib/s390x/malloc_io.h
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * I/O allocations
+ *
+ * Copyright (c) 2021 IBM Corp
+ *
+ * Authors:
+ *  Pierre Morel <pmorel@linux.ibm.com>
+ *
+ */
+#ifndef _S390X_MALLOC_IO_H_
+#define _S390X_MALLOC_IO_H_
+
+/*
+ * Allocates a page aligned page bound range of contiguous real or
+ * absolute memory in the DMA31 region large enough to contain size
+ * bytes.
+ * If Protected Virtualisation facility is present, shares the pages
+ * with the host.
+ * If all the pages for the specified size cannot be reserved,
+ * the function rewinds the partial allocation and a NULL pointer
+ * is returned.
+ *
+ * @size: the minimal size allocated in byte.
+ * @flags: the flags used for the underlying page allocator.
+ *
+ * Errors:
+ *   The allocation will assert the size parameter, will fail if the
+ *   underlying page allocator fail or in the case of protected
+ *   virtualisation if the sharing of the pages fails.
+ *
+ * Returns a pointer to the first page in case of success, NULL otherwise.
+ */
+void *alloc_io_mem(int size, int flags);
+
+/*
+ * Frees a previously memory space allocated by alloc_io_mem.
+ * If Protected Virtualisation facility is present, unshares the pages
+ * with the host.
+ * The address must be aligned on a page boundary otherwise an assertion
+ * breaks the program.
+ */
+void free_io_mem(void *p, int size);
+
+#endif /* _S390X_MALLOC_IO_H_ */
diff --git a/s390x/Makefile b/s390x/Makefile
index 08d85c9..f3b0fcc 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -64,6 +64,7 @@ cflatobjs += lib/s390x/smp.o
 cflatobjs += lib/s390x/vm.o
 cflatobjs += lib/s390x/css_dump.o
 cflatobjs += lib/s390x/css_lib.o
+cflatobjs += lib/s390x/malloc_io.o
 
 OBJDIRS += lib/s390x
 
-- 
2.17.1

