Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C04F3150ED
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 14:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbhBINxL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 08:53:11 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10634 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231842AbhBINvd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 08:51:33 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 119DWOwi172569;
        Tue, 9 Feb 2021 08:50:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=S8dvXIiy8agDEsyKoDBFzvGlDklevfSpUoONrKYP2gA=;
 b=tRuSOrzVFPODbGBJXvdu5UggD9jb5iG/0ulE48JP+24csmQcfrF/4uJ7z9dhZwA9zhuq
 /fdvLYxBrClG6GH3reiE5U6oigLwq9JdWG1Fl6KcRFcihilbVSIKgpQO3VBkVTjehsNr
 GDa4GPZV9SvHu3gfryXXskHdHFJWBbyerXs4h/M8rQs4wEEtXKBe2vhBQMz9+6iTOjSm
 cgibOeGr+Y28UQ2m4F0UXQiUrGwmM3EWFPToUbge7cc9SXpb+CVKhDkiubptbhoC2xVh
 SkJREWxXI+ud8YWAvTUqgoMMZu1gHjJ2B8rva0ZGafVS7Z3ilz39K+ZfamB5OHAvys/1 uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36kts6a1yn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 08:50:51 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 119DWnwb174105;
        Tue, 9 Feb 2021 08:50:51 -0500
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36kts6a1xn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 08:50:50 -0500
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 119DRBvY031291;
        Tue, 9 Feb 2021 13:50:48 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 36hjr7sr4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 13:50:48 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 119DojSK47317454
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Feb 2021 13:50:45 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77305A404D;
        Tue,  9 Feb 2021 13:50:45 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2D01A4059;
        Tue,  9 Feb 2021 13:50:44 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  9 Feb 2021 13:50:44 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        pmorel@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 5/8] s390x: Provide preliminary backtrace support
Date:   Tue,  9 Feb 2021 08:49:22 -0500
Message-Id: <20210209134925.22248-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210209134925.22248-1-frankja@linux.ibm.com>
References: <20210209134925.22248-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_03:2021-02-09,2021-02-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 suspectscore=0 spamscore=0 impostorscore=0 adultscore=0 clxscore=1015
 mlxlogscore=999 phishscore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090067
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
index 94a2cf9c..49f98759 100644
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

