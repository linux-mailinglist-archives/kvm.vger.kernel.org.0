Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA9C1F1438
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 10:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729149AbgFHINR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 04:13:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23184 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729101AbgFHINM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Jun 2020 04:13:12 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0588230I195934;
        Mon, 8 Jun 2020 04:13:11 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31g42s10je-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 04:13:10 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05882ZmR002496;
        Mon, 8 Jun 2020 04:13:10 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31g42s10gh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 04:13:10 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05885DYw016005;
        Mon, 8 Jun 2020 08:13:08 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 31g2s7se9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 08:13:08 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0588BoPP49349058
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Jun 2020 08:11:50 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 88CE74C052;
        Mon,  8 Jun 2020 08:13:06 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C9454C044;
        Mon,  8 Jun 2020 08:13:06 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.43.245])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Jun 2020 08:13:06 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v8 08/12] s390x: retrieve decimal and hexadecimal kernel parameters
Date:   Mon,  8 Jun 2020 10:12:57 +0200
Message-Id: <1591603981-16879-9-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1591603981-16879-1-git-send-email-pmorel@linux.ibm.com>
References: <1591603981-16879-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-08_03:2020-06-08,2020-06-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 clxscore=1015 malwarescore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=999 suspectscore=1 cotscore=-2147483648 lowpriorityscore=0
 adultscore=0 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006080057
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We often need to retrieve hexadecimal kernel parameters.
Let's implement a shared utility to do it.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/kernel-args.c | 60 +++++++++++++++++++++++++++++++++++++++++
 lib/s390x/kernel-args.h | 18 +++++++++++++
 s390x/Makefile          |  1 +
 3 files changed, 79 insertions(+)
 create mode 100644 lib/s390x/kernel-args.c
 create mode 100644 lib/s390x/kernel-args.h

diff --git a/lib/s390x/kernel-args.c b/lib/s390x/kernel-args.c
new file mode 100644
index 0000000..3335fbf
--- /dev/null
+++ b/lib/s390x/kernel-args.c
@@ -0,0 +1,60 @@
+/*
+ * Retrieving kernel arguments
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
+#include <libcflat.h>
+#include <string.h>
+#include <asm/arch_def.h>
+#include <kernel-args.h>
+
+static const char *hex_digit = "0123456789abcdef";
+
+static unsigned long htol(char *s)
+{
+	unsigned long v = 0, shift = 0, value = 0;
+	int i, digit, len = strlen(s);
+
+	for (shift = 0, i = len - 1; i >= 0; i--, shift += 4) {
+		digit = s[i] | 0x20;	/* Set lowercase */
+		if (!strchr(hex_digit, digit))
+			return 0;	/* this is not a digit ! */
+
+		if (digit <= '9')
+			v = digit - '0';
+		else
+			v = digit - 'a' + 10;
+		value += (v << shift);
+	}
+
+	return value;
+}
+
+int kernel_arg(int argc, char *argv[], const char *str, unsigned long *val)
+{
+	int i, ret;
+	char *p;
+
+	for (i = 0; i < argc; i++) {
+		ret = strncmp(argv[i], str, strlen(str));
+		if (ret)
+			continue;
+		p = strchr(argv[i], '=');
+		if (!p)
+			return -1;
+		p = strchr(p, 'x');
+		if (!p)
+			*val = atol(p + 1);
+		else
+			*val = htol(p + 1);
+		return 0;
+	}
+	return -2;
+}
diff --git a/lib/s390x/kernel-args.h b/lib/s390x/kernel-args.h
new file mode 100644
index 0000000..a88e34e
--- /dev/null
+++ b/lib/s390x/kernel-args.h
@@ -0,0 +1,18 @@
+/*
+ * Kernel argument
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
+#ifndef KERNEL_ARGS_H
+#define KERNEL_ARGS_H
+
+int kernel_arg(int argc, char *argv[], const char *str, unsigned long *val);
+
+#endif
diff --git a/s390x/Makefile b/s390x/Makefile
index ddb4b48..47a94cc 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -51,6 +51,7 @@ cflatobjs += lib/s390x/sclp-console.o
 cflatobjs += lib/s390x/interrupt.o
 cflatobjs += lib/s390x/mmu.o
 cflatobjs += lib/s390x/smp.o
+cflatobjs += lib/s390x/kernel-args.o
 
 OBJDIRS += lib/s390x
 
-- 
2.25.1

