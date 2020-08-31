Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1DC42578F1
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 14:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgHaMGE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 08:06:04 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33038 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726249AbgHaMFm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 31 Aug 2020 08:05:42 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07VC1pvt071169;
        Mon, 31 Aug 2020 08:05:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=9iZokfACri1pSVTV3N5LB9uwOjKV7YKhID6QIhOid8I=;
 b=OZ7gKbnTsHCYSWyCn1+b4qJDX9+2VV4Q9E2b4xTaMj1YoEuxDzEFPfP3gVSW6huOuLMG
 LN2UfADkQ6WFK9DHVQvothFKfuVvzrD1JamQ2gJF7FlqMndCCGFGA10dgem5wTUBuazy
 Ls4dlG14M48dt38z/eQa2IwTKd9lkoZ1d1rNcRAqXq/kCwU5dhbJuqCGvNrF5PUY6vKz
 8jAbepKjpZhH3kUuflo+eDvEB8hCTu3hRuQa01EVo4JoV0rSPhGAWWM6GsrT4RvK7J3B
 JcyPVKYHEjNUGJqpgUnYxZwV9jsTN7SNxmbVsvktrrUIdBJe179N5+4j9hxjqky90Ela mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 338y1bk0px-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Aug 2020 08:05:41 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07VC1xHK071858;
        Mon, 31 Aug 2020 08:05:40 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 338y1bk0nu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Aug 2020 08:05:40 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07VBxjfo028078;
        Mon, 31 Aug 2020 12:05:38 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 337e9h19r3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Aug 2020 12:05:38 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07VC5Z5a32965064
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 12:05:35 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5264A4067;
        Mon, 31 Aug 2020 12:05:35 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58913A4065;
        Mon, 31 Aug 2020 12:05:35 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.160.216])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 31 Aug 2020 12:05:35 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [PATCH v1 2/3] s390: define UV compatible I/O allocation
Date:   Mon, 31 Aug 2020 14:05:32 +0200
Message-Id: <1598875533-19947-3-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1598875533-19947-1-git-send-email-pmorel@linux.ibm.com>
References: <1598875533-19947-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-31_04:2020-08-31,2020-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 impostorscore=0 phishscore=0 lowpriorityscore=0 spamscore=0
 mlxlogscore=999 suspectscore=3 priorityscore=1501 clxscore=1015
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008310066
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To centralize the memory allocation for I/O we define
the alloc/free_io_page() functions which share the I/O
memory with the host in case the guest runs with
protected virtualization.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/malloc_io.c | 53 +++++++++++++++++++++++++++++++++++++++++++
 lib/s390x/malloc_io.h | 14 ++++++++++++
 s390x/Makefile        |  1 +
 3 files changed, 68 insertions(+)
 create mode 100644 lib/s390x/malloc_io.c
 create mode 100644 lib/s390x/malloc_io.h

diff --git a/lib/s390x/malloc_io.c b/lib/s390x/malloc_io.c
new file mode 100644
index 0000000..0e67aab
--- /dev/null
+++ b/lib/s390x/malloc_io.c
@@ -0,0 +1,53 @@
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
+
+#include <libcflat.h>
+#include <alloc_page.h>
+#include <asm/page.h>
+#include <asm/uv.h>
+#include <malloc_io.h>
+#include <asm/facility.h>
+
+
+void *alloc_io_page(int size)
+{
+	void *p;
+
+	assert(size <= PAGE_SIZE);
+	p = alloc_page();
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
+	free_page(p);
+}
diff --git a/lib/s390x/malloc_io.h b/lib/s390x/malloc_io.h
new file mode 100644
index 0000000..6916f55
--- /dev/null
+++ b/lib/s390x/malloc_io.h
@@ -0,0 +1,14 @@
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
+
+void *alloc_io_page(int size);
+void free_io_page(void *p);
diff --git a/s390x/Makefile b/s390x/Makefile
index 9144d57..f545597 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -62,6 +62,7 @@ cflatobjs += lib/s390x/smp.o
 cflatobjs += lib/s390x/vm.o
 cflatobjs += lib/s390x/css_dump.o
 cflatobjs += lib/s390x/css_lib.o
+cflatobjs += lib/s390x/malloc_io.o
 
 OBJDIRS += lib/s390x
 
-- 
2.25.1

