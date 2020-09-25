Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED0F8278ECB
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 18:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729478AbgIYQjC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 12:39:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43550 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729125AbgIYQjB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 12:39:01 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08PGXKGG182834;
        Fri, 25 Sep 2020 12:39:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=ZsaqBb9u3bxkMNLlzPiyzpHkhV5HbI2l5uX6gwUHYGU=;
 b=Tqsju7TzwChW8FXHZRTcLDLLMOY3rE3Quc4kCp5r4cSC4juIsVi/WeUu8yBmbXAs4JWT
 RLisgU285Cwe3re7xwua52O+hwGhp9mKgx++O0d74B7oP+2FtOwtWXqlNUQ5h/WsIkyy
 RdxF5+X6NPrBJ9wgsQjcH0zU3inGwNF0G5Rmr4dZUnq9h+aL0dwwst4x9TPXxbI2P/0Q
 m5pGex8tTuYdwFSuJ7NqyxcTox+EjSfLsGmyESlru+O/4NxK/izTh+uhzO/HVLCaOZLf
 azzw+ZxCo54qBZjExL9mT1vNndUKK2zvxqU3AhqIDrSfulqMXDSHgGOMRyFFhxNDSi6V +A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33skujrnkh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Sep 2020 12:39:01 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08PGXWDZ183487;
        Fri, 25 Sep 2020 12:39:01 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33skujrngp-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Sep 2020 12:39:00 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08PG2lmQ022991;
        Fri, 25 Sep 2020 16:02:50 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 33payud76n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Sep 2020 16:02:50 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08PG2l5d27328790
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Sep 2020 16:02:47 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 924E8A405B;
        Fri, 25 Sep 2020 16:02:47 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D2FFA405C;
        Fri, 25 Sep 2020 16:02:47 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.49.151])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Sep 2020 16:02:47 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com
Subject: [PATCH v1 3/4] s390: define UV compatible I/O allocation
Date:   Fri, 25 Sep 2020 18:02:43 +0200
Message-Id: <1601049764-11784-4-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601049764-11784-1-git-send-email-pmorel@linux.ibm.com>
References: <1601049764-11784-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-25_14:2020-09-24,2020-09-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 mlxscore=0 adultscore=0 spamscore=0 suspectscore=3 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009250113
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To centralize the memory allocation for I/O we define
the alloc/free_io_page() functions which share the I/O
memory with the host in case the guest runs with
protected virtualization.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/malloc_io.c | 50 +++++++++++++++++++++++++++++++++++++++++++
 lib/s390x/malloc_io.h | 18 ++++++++++++++++
 s390x/Makefile        |  1 +
 3 files changed, 69 insertions(+)
 create mode 100644 lib/s390x/malloc_io.c
 create mode 100644 lib/s390x/malloc_io.h

diff --git a/lib/s390x/malloc_io.c b/lib/s390x/malloc_io.c
new file mode 100644
index 0000000..b84a06a
--- /dev/null
+++ b/lib/s390x/malloc_io.c
@@ -0,0 +1,50 @@
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
+	p = get_dma_page();
+	if (!p) {
+		report(0, "Memory allocation");
+		return NULL;
+	}
+
+	if (!test_facility(158))
+		return p;
+
+	if (!uv_set_shared((unsigned long)p)) {
+		report(0, "Sharing memory");
+		return NULL;
+	}
+
+	return p;
+}
+
+void free_io_page(void *p)
+{
+	if (test_facility(158) && !uv_remove_shared((unsigned long)p))
+		report(0, "Unsharing memory");
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

