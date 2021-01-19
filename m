Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 978282FC06B
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 20:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728501AbhASTyY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 14:54:24 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:27706 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392053AbhASTxX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 14:53:23 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10JJGdEU127929;
        Tue, 19 Jan 2021 14:52:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=ZQvkzbwz8iU+rMecJtZsQpH7Vo1uQvCsWMNSWZBNpr0=;
 b=VDUm3LV/p2zuw7Rejc8/A2HvIpnP6tqFjDT1HD4YgRd5KvUcAhkcljMKjavvPENvRcCd
 AiheTCeLOLuxN1Kf+YvenRfyWCcy52JbZa00A7kYKPDd/hCLRq/3A26hKRWFAax5OdZV
 +oq14w1ww7RtyZd7fpGuVpGAvQrZJUqCowTYiHA35R47gatj84vnxSvwa3eda1wC+YzP
 rquFyNe6RC/l4X5PmRcIOsgr75HZN+gqquTF2f70Iqbr0DgW5uGtp5+drNpFmeceCUnh
 Xviu6c7QhdkqaQp7aevNOT5L/YYNnxuyV/HJjJxPWvUtc+8nxWnMGPDGI68I0yOGgysN hQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3665ebgrp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 14:52:32 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10JJhqtU080748;
        Tue, 19 Jan 2021 14:52:32 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3665ebgrnk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 14:52:31 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10JJkxh2025163;
        Tue, 19 Jan 2021 19:52:29 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 363qs8bdqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 19:52:29 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10JJqQ6r21692748
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 19:52:27 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D8EDA42041;
        Tue, 19 Jan 2021 19:52:26 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 697D54203F;
        Tue, 19 Jan 2021 19:52:26 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.38.46])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Jan 2021 19:52:26 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        imbrenda@linux.ibm.com, drjones@redhat.com, pbonzini@redhat.com
Subject: [kvm-unit-tests PATCH v3 2/3] s390x: define UV compatible I/O allocation
Date:   Tue, 19 Jan 2021 20:52:23 +0100
Message-Id: <1611085944-21609-3-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611085944-21609-1-git-send-email-pmorel@linux.ibm.com>
References: <1611085944-21609-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_07:2021-01-18,2021-01-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 mlxscore=0 suspectscore=0 bulkscore=0
 impostorscore=0 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101190104
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To centralize the memory allocation for I/O we define
the alloc_io_page/free_io_page functions which share the I/O
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
index 0000000..2a946e0
--- /dev/null
+++ b/lib/s390x/malloc_io.c
@@ -0,0 +1,50 @@
+/*
+ * I/O page allocation
+ *
+ * Copyright (c) 2021 IBM Corp
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
+#include <asm/page.h>
+#include <asm/uv.h>
+#include <malloc_io.h>
+#include <alloc_page.h>
+#include <asm/facility.h>
+
+void *alloc_io_page(int size)
+{
+	void *p;
+
+	assert(size <= PAGE_SIZE);
+
+	p = alloc_pages_flags(1, AREA_DMA31);
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
+	free_pages(p);
+	return NULL;
+}
+
+void free_io_page(void *p)
+{
+	if (test_facility(158))
+		uv_remove_shared((unsigned long)p);
+	free_pages(p);
+}
diff --git a/lib/s390x/malloc_io.h b/lib/s390x/malloc_io.h
new file mode 100644
index 0000000..f780191
--- /dev/null
+++ b/lib/s390x/malloc_io.h
@@ -0,0 +1,18 @@
+/*
+ * I/O allocations
+ *
+ * Copyright (c) 2021 IBM Corp
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
index b079a26..4b6301c 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -63,6 +63,7 @@ cflatobjs += lib/s390x/smp.o
 cflatobjs += lib/s390x/vm.o
 cflatobjs += lib/s390x/css_dump.o
 cflatobjs += lib/s390x/css_lib.o
+cflatobjs += lib/s390x/malloc_io.o
 
 OBJDIRS += lib/s390x
 
-- 
2.17.1

