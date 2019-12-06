Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8556811553F
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 17:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfLFQ0k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 11:26:40 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1636 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726377AbfLFQ0h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Dec 2019 11:26:37 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB6GESS3101897
        for <kvm@vger.kernel.org>; Fri, 6 Dec 2019 11:26:36 -0500
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wq2xddgau-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 06 Dec 2019 11:26:36 -0500
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Fri, 6 Dec 2019 16:26:34 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 6 Dec 2019 16:26:32 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xB6GQVK056098904
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 6 Dec 2019 16:26:31 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61F6752050;
        Fri,  6 Dec 2019 16:26:31 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.175.63])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 0768A52054;
        Fri,  6 Dec 2019 16:26:30 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v3 4/9] s390x: export the clock get_clock_ms() utility
Date:   Fri,  6 Dec 2019 17:26:23 +0100
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1575649588-6127-1-git-send-email-pmorel@linux.ibm.com>
References: <1575649588-6127-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19120616-4275-0000-0000-0000038C74AA
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19120616-4276-0000-0000-000038A01E2D
Message-Id: <1575649588-6127-5-git-send-email-pmorel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-06_05:2019-12-05,2019-12-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0
 clxscore=1015 spamscore=0 suspectscore=1 malwarescore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912060136
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To serve multiple times, the function get_clock_ms() is moved
from intercept.c test to the new file asm/time.h.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
---
 lib/s390x/asm/time.h | 27 +++++++++++++++++++++++++++
 s390x/intercept.c    | 11 +----------
 2 files changed, 28 insertions(+), 10 deletions(-)
 create mode 100644 lib/s390x/asm/time.h

diff --git a/lib/s390x/asm/time.h b/lib/s390x/asm/time.h
new file mode 100644
index 0000000..b07ccbd
--- /dev/null
+++ b/lib/s390x/asm/time.h
@@ -0,0 +1,27 @@
+/*
+ * Clock utilities for s390
+ *
+ * Authors:
+ *  Thomas Huth <thuth@redhat.com>
+ *
+ * Copied from the s390/intercept test by:
+ *  Pierre Morel <pmorel@linux.ibm.com>
+ *
+ * This code is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2.
+ */
+#ifndef _ASM_S390X_TIME_H_
+#define _ASM_S390X_TIME_H_
+
+static inline uint64_t get_clock_ms(void)
+{
+	uint64_t clk;
+
+	asm volatile(" stck %0 " : : "Q"(clk) : "memory");
+
+	/* Bit 51 is incrememented each microsecond */
+	return (clk >> (63 - 51)) / 1000;
+}
+
+
+#endif
diff --git a/s390x/intercept.c b/s390x/intercept.c
index 404b4c6..18aa60d 100644
--- a/s390x/intercept.c
+++ b/s390x/intercept.c
@@ -13,6 +13,7 @@
 #include <asm/asm-offsets.h>
 #include <asm/interrupt.h>
 #include <asm/page.h>
+#include <asm/time.h>
 
 static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
 
@@ -159,16 +160,6 @@ static void test_testblock(void)
 	check_pgm_int_code(PGM_INT_CODE_ADDRESSING);
 }
 
-static uint64_t get_clock_ms(void)
-{
-	uint64_t clk;
-
-	asm volatile(" stck %0 " : : "Q"(clk) : "memory");
-
-	/* Bit 51 is incrememented each microsecond */
-	return (clk >> (63 - 51)) / 1000;
-}
-
 struct {
 	const char *name;
 	void (*func)(void);
-- 
2.17.0

