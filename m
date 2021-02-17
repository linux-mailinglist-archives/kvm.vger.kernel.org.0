Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1711631DBA9
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 15:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbhBQOnY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 09:43:24 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31028 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233565AbhBQOnL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Feb 2021 09:43:11 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11HEZPbu033387;
        Wed, 17 Feb 2021 09:42:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=RH8d5g+cUx3WZJxprHE85YwGxBSFZaSzCcPGehKSVDY=;
 b=U0SGhQx1noc7XLKyrDgGtBdvFEL7kGUr7U5Cnk586sWPVgzhLMujmsG08tj6OwpCrE75
 c/u6bqJHylBXd/SmlXAwDdU9mZTQmKMqwPMBVzNKpxmDL5FKmfKx7IawCjvjoElm51gV
 cAGOGVmEJ80mqBLSO4ToZaf0+Y+B7OWJqGpj6Bh7UgWrQ5+cVl+yjmzyrwADKhWuCryy
 BOF1QJHmLhJeoLf/WPe+Ku3UhkETEDGc8Qj6hMv/fDu2AY272TCqE1hRJTHRuyBpppWK
 VaiKKXOCbdu47zCiu5jLDyuASfxF0f3rjgR6uejfiU6ugBSDa2yy5rV6TWMqeXhKrI+T Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36s3144mqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 09:42:30 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11HEZcwr035403;
        Wed, 17 Feb 2021 09:42:29 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36s3144mp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 09:42:29 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11HEgQJs014689;
        Wed, 17 Feb 2021 14:42:26 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 36rw3u8d1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Feb 2021 14:42:26 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11HEgCi431850812
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 14:42:12 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C591111C058;
        Wed, 17 Feb 2021 14:42:23 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1D1D311C04C;
        Wed, 17 Feb 2021 14:42:23 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 17 Feb 2021 14:42:22 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        pmorel@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v2 5/8] s390x: Provide preliminary backtrace support
Date:   Wed, 17 Feb 2021 09:41:13 -0500
Message-Id: <20210217144116.3368-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210217144116.3368-1-frankja@linux.ibm.com>
References: <20210217144116.3368-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-17_12:2021-02-16,2021-02-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 clxscore=1015 suspectscore=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170113
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After the stack changes we can finally use -mbackchain and have a
working backtrace.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/interrupt.c | 12 ++++++++++++
 lib/s390x/stack.c     | 20 ++++++++++++++------
 s390x/Makefile        |  1 +
 3 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
index a59df80e..23ad922c 100644
--- a/lib/s390x/interrupt.c
+++ b/lib/s390x/interrupt.c
@@ -115,6 +115,18 @@ static void fixup_pgm_int(struct stack_frame_int *stack)
 	/* suppressed/terminated/completed point already at the next address */
 }
 
+static void print_pgm_info(struct stack_frame_int *stack)
+
+{
+	printf("\n");
+	printf("Unexpected program interrupt: %d on cpu %d at %#lx, ilen %d\n",
+	       lc->pgm_int_code, stap(), lc->pgm_old_psw.addr,
+	       lc->pgm_int_id);
+	dump_stack();
+	report_summary();
+	abort();
+}
+
 void handle_pgm_int(struct stack_frame_int *stack)
 {
 	if (!pgm_int_expected) {
diff --git a/lib/s390x/stack.c b/lib/s390x/stack.c
index 0fcd1afb..4cf80dae 100644
--- a/lib/s390x/stack.c
+++ b/lib/s390x/stack.c
@@ -3,24 +3,32 @@
  * s390x stack implementation
  *
  * Copyright (c) 2017 Red Hat Inc
+ * Copyright 2021 IBM Corp
  *
  * Authors:
  *  Thomas Huth <thuth@redhat.com>
  *  David Hildenbrand <david@redhat.com>
+ *  Janosch Frank <frankja@de.ibm.com>
  */
 #include <libcflat.h>
 #include <stack.h>
+#include <asm/arch_def.h>
 
 int backtrace_frame(const void *frame, const void **return_addrs, int max_depth)
 {
-	printf("TODO: Implement backtrace_frame(%p, %p, %d) function!\n",
-	       frame, return_addrs, max_depth);
-	return 0;
+	int depth = 0;
+	struct stack_frame *stack = (struct stack_frame *)frame;
+
+	for (depth = 0; stack && depth < max_depth; depth++) {
+		return_addrs[depth] = (void *)stack->grs[8];
+		stack = stack->back_chain;
+	}
+
+	return depth;
 }
 
 int backtrace(const void **return_addrs, int max_depth)
 {
-	printf("TODO: Implement backtrace(%p, %d) function!\n",
-	       return_addrs, max_depth);
-	return 0;
+	return backtrace_frame(__builtin_frame_address(0),
+			       return_addrs, max_depth);
 }
diff --git a/s390x/Makefile b/s390x/Makefile
index f3b0fccf..20bb5683 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -39,6 +39,7 @@ CFLAGS += -ffreestanding
 CFLAGS += -I $(SRCDIR)/lib -I $(SRCDIR)/lib/s390x -I lib
 CFLAGS += -O2
 CFLAGS += -march=zEC12
+CFLAGS += -mbackchain
 CFLAGS += -fno-delete-null-pointer-checks
 LDFLAGS += -nostdlib -Wl,--build-id=none
 
-- 
2.25.1

