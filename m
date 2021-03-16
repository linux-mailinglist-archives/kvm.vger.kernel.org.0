Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF2633D07A
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 10:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236000AbhCPJU3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 05:20:29 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:64926 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235957AbhCPJUJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 05:20:09 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12G93IS9151572;
        Tue, 16 Mar 2021 05:20:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=678KBbXoglLoDeDFPqBKjxG2s6voD4yWt6F6ZFdYV7I=;
 b=ClgoeYoy5NLFfd4r/SzClbRC5zQ0okf/kgkyYHyfFJR8SHPq/yzhPWvBY/TlZJgNf3fh
 xKJQQzaPMvMwtj9KrnhsxsUrLHR1PV+C2eLxD6KCtgkG38My3BmMziJRsHAkMKPBpIon
 iblH2aegtmhHOjPGD7W1g8uYVv5Dd5lgutmxWq2zBUkg4mtmPSXhfk4D2dwAN/hp8PIj
 500CEFCmeov9DqZrqq0D//xY6/x6d7LR3fYyd947+I++Y7lECEBtdRminH/nS5aN4fX9
 lhSyqpDiI/wmqhTisRHDJO4vWdbAQgpMNmKFqQ5pgCEoMv2OzDmJHVVMXohM6UsjNkqy EQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37arn9j99q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 05:20:09 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12G93Vhu154833;
        Tue, 16 Mar 2021 05:20:09 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37arn9j98c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 05:20:09 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12G9D4RM016874;
        Tue, 16 Mar 2021 09:20:07 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 378n18jp0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 09:20:06 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12G9JlQk20054340
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 09:19:47 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A6D34C063;
        Tue, 16 Mar 2021 09:20:03 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 13B0B4C046;
        Tue, 16 Mar 2021 09:20:02 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.146.129])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 16 Mar 2021 09:20:01 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 3/6] s390x: uv: Add UV lib
Date:   Tue, 16 Mar 2021 09:16:51 +0000
Message-Id: <20210316091654.1646-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210316091654.1646-1-frankja@linux.ibm.com>
References: <20210316091654.1646-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-16_03:2021-03-15,2021-03-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 malwarescore=0 priorityscore=1501 mlxlogscore=999 suspectscore=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103160063
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's add a UV library to make checking the UV feature bit easier.
In the future this library file can take care of handling UV
initialization and UV guest creation.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/uv.h |  4 ++--
 lib/s390x/io.c     |  2 ++
 lib/s390x/uv.c     | 48 ++++++++++++++++++++++++++++++++++++++++++++++
 lib/s390x/uv.h     | 10 ++++++++++
 s390x/Makefile     |  1 +
 5 files changed, 63 insertions(+), 2 deletions(-)
 create mode 100644 lib/s390x/uv.c
 create mode 100644 lib/s390x/uv.h

diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
index 11f70a9f..b22cbaa8 100644
--- a/lib/s390x/asm/uv.h
+++ b/lib/s390x/asm/uv.h
@@ -9,8 +9,8 @@
  * This code is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License version 2.
  */
-#ifndef UV_H
-#define UV_H
+#ifndef ASM_S390X_UV_H
+#define ASM_S390X_UV_H
 
 #define UVC_RC_EXECUTED		0x0001
 #define UVC_RC_INV_CMD		0x0002
diff --git a/lib/s390x/io.c b/lib/s390x/io.c
index ef9f59e3..a4f1b113 100644
--- a/lib/s390x/io.c
+++ b/lib/s390x/io.c
@@ -14,6 +14,7 @@
 #include <asm/facility.h>
 #include <asm/sigp.h>
 #include "sclp.h"
+#include "uv.h"
 #include "smp.h"
 
 extern char ipl_args[];
@@ -38,6 +39,7 @@ void setup(void)
 	sclp_facilities_setup();
 	sclp_console_setup();
 	sclp_memory_setup();
+	uv_setup();
 	smp_setup();
 }
 
diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
new file mode 100644
index 00000000..a84a85fc
--- /dev/null
+++ b/lib/s390x/uv.c
@@ -0,0 +1,48 @@
+#include <libcflat.h>
+#include <bitops.h>
+#include <alloc.h>
+#include <alloc_page.h>
+#include <asm/page.h>
+#include <asm/arch_def.h>
+
+#include <asm/facility.h>
+#include <asm/uv.h>
+#include <uv.h>
+
+static struct uv_cb_qui uvcb_qui = {
+	.header.cmd = UVC_CMD_QUI,
+	.header.len = sizeof(uvcb_qui),
+};
+
+bool uv_os_is_guest(void)
+{
+	return uv_query_test_feature(BIT_UVC_CMD_SET_SHARED_ACCESS)
+		&& uv_query_test_feature(BIT_UVC_CMD_REMOVE_SHARED_ACCESS);
+}
+
+bool uv_os_is_host(void)
+{
+	return uv_query_test_feature(BIT_UVC_CMD_INIT_UV);
+}
+
+bool uv_query_test_feature(int nr)
+{
+	/* Query needs to be called first */
+	if (!uvcb_qui.header.rc)
+		return false;
+
+	return test_bit_inv(nr, uvcb_qui.inst_calls_list);
+}
+
+int uv_setup(void)
+{
+	int cc;
+
+	if (!test_facility(158))
+		return 0;
+
+	cc = uv_call(0, (u64)&uvcb_qui);
+	assert(cc == 0);
+
+	return cc == 0;
+}
diff --git a/lib/s390x/uv.h b/lib/s390x/uv.h
new file mode 100644
index 00000000..159bf8e5
--- /dev/null
+++ b/lib/s390x/uv.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef UV_H
+#define UV_H
+
+bool uv_os_is_guest(void);
+bool uv_os_is_host(void);
+bool uv_query_test_feature(int nr);
+int uv_setup(void);
+
+#endif /* UV_H */
diff --git a/s390x/Makefile b/s390x/Makefile
index b92de9c5..bbf177fa 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -67,6 +67,7 @@ cflatobjs += lib/s390x/vm.o
 cflatobjs += lib/s390x/css_dump.o
 cflatobjs += lib/s390x/css_lib.o
 cflatobjs += lib/s390x/malloc_io.o
+cflatobjs += lib/s390x/uv.o
 
 OBJDIRS += lib/s390x
 
-- 
2.27.0

