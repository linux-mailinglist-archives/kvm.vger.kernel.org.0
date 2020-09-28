Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4775527AFEE
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 16:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgI1OXr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 10:23:47 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55954 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726327AbgI1OXq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Sep 2020 10:23:46 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08SEF1Jq180246;
        Mon, 28 Sep 2020 10:23:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=t/R7ZuIsmXi9xFx/wc8fRhRD4oRDdVZ64/oQYAyqeGc=;
 b=EREND/qSRzpuGFvpWm36c0pnU0WaxbAVwdMnkidDhD6EocMl4fgW73t1Lf6ChOvpj1j+
 kK513JXnYE/N/2wqf5WdcMgHCFtQ0iv2Kmyw/ukwaVjsGSjjk7eiTXaOKtDuMqU2eytJ
 5rXtq6RTydDz4o3C+khzCyhKfXEmYjG++xdKTNJxYiVaQeIPmlgwYhJ/88AleoDpokXM
 GE+kfwQb5Hd2+D3FlkMq8LwlhMyATC2bM08uBkbv4Mi11vEPemaQpcM5xajOFmUp9oRx
 K4TqcJa4P3bPi/+oNEd3UUEoSBK15uenZPaixlAap9xVLxRV7d5WTZq4107slx+ZM3wZ mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33uhe8g7r5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Sep 2020 10:23:45 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08SEFtJ9182553;
        Mon, 28 Sep 2020 10:23:44 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33uhe8g7qe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Sep 2020 10:23:44 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08SELnNf008125;
        Mon, 28 Sep 2020 14:23:43 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 33u5r9gmef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Sep 2020 14:23:43 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08SENelw27591118
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 14:23:40 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A35142045;
        Mon, 28 Sep 2020 14:23:40 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BAB0242047;
        Mon, 28 Sep 2020 14:23:39 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.66.164])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 28 Sep 2020 14:23:39 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 3/4] s390x: define UV compatible I/O allocation
Date:   Mon, 28 Sep 2020 16:23:36 +0200
Message-Id: <1601303017-8176-4-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601303017-8176-1-git-send-email-pmorel@linux.ibm.com>
References: <1601303017-8176-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-28_14:2020-09-28,2020-09-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 malwarescore=0 suspectscore=3 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 phishscore=0 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009280108
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To centralize the memory allocation for I/O we define
the alloc/free_io_page() functions which share the I/O
memory with the host in case the guest runs with
protected virtualization.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/malloc_io.c | 49 +++++++++++++++++++++++++++++++++++++++++++
 lib/s390x/malloc_io.h | 18 ++++++++++++++++
 s390x/Makefile        |  1 +
 3 files changed, 68 insertions(+)
 create mode 100644 lib/s390x/malloc_io.c
 create mode 100644 lib/s390x/malloc_io.h

diff --git a/lib/s390x/malloc_io.c b/lib/s390x/malloc_io.c
new file mode 100644
index 0000000..388e568
--- /dev/null
+++ b/lib/s390x/malloc_io.c
@@ -0,0 +1,49 @@
+/*
+ * I/O page allocation
+ *
+ * Copyright (c) 2020 IBM Corp
+ *
+ * Authors:
+ *  Pierre Morel <pmorel@linux.ibm.com>
+ *
+ * This code is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2.
+ *
+ * Using this interface provide host access to the allocated pages in
+ * case the guest is a secure guest.
+ * This is needed for I/O buffers.
+ *
+ */
+#include <libcflat.h>
+#include <alloc_dma_page.h>
+#include <asm/uv.h>
+#include <malloc_io.h>
+#include <asm/facility.h>
+
+void *alloc_io_page(int size)
+{
+	void *p;
+
+	assert(size <= PAGE_SIZE);
+
+	p = get_dma_page();
+	if (!p)
+		return NULL;
+	memset(p, 0, PAGE_SIZE);
+
+	if (!test_facility(158))
+		return p;
+
+	if (uv_set_shared((unsigned long)p) == 0)
+		return p;
+
+	put_dma_page(p);
+	return NULL;
+}
+
+void free_io_page(void *p)
+{
+	if (test_facility(158))
+		uv_remove_shared((unsigned long)p);
+	put_dma_page(p);
+}
diff --git a/lib/s390x/malloc_io.h b/lib/s390x/malloc_io.h
new file mode 100644
index 0000000..c6ed481
--- /dev/null
+++ b/lib/s390x/malloc_io.h
@@ -0,0 +1,18 @@
+/*
+ * I/O allocations
+ *
+ * Copyright (c) 2020 IBM Corp
+ *
+ * Authors:
+ *  Pierre Morel <pmorel@linux.ibm.com>
+ *
+ * This code is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2.
+ */
+#ifndef _S390X_MALLOC_IO_H_
+#define _S390X_MALLOC_IO_H_
+
+void *alloc_io_page(int size);
+void free_io_page(void *p);
+
+#endif /* _S390X_MALLOC_IO_H_ */
diff --git a/s390x/Makefile b/s390x/Makefile
index 109ef9f..1b1dc9f 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -63,6 +63,7 @@ cflatobjs += lib/s390x/smp.o
 cflatobjs += lib/s390x/vm.o
 cflatobjs += lib/s390x/css_dump.o
 cflatobjs += lib/s390x/css_lib.o
+cflatobjs += lib/s390x/malloc_io.o
 
 OBJDIRS += lib/s390x
 
-- 
2.25.1

