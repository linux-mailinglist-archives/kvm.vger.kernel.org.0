Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD7B3216CD
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 13:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbhBVMfS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 07:35:18 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:24400 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230408AbhBVMd5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Feb 2021 07:33:57 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11MCQG2l028690;
        Mon, 22 Feb 2021 07:33:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=aBykKXx2dM2HXPOLq9a3B3RgomZLOP96UCOOtS7zGrY=;
 b=g0BoCE737Bs+z96e2M3SpVHo/SE8ZnI8+FmOBF6vuuZ/E18/rXLxM0B50CvtuQjCGP6T
 5iPSmjjh7deNIsDcfGL+kDA+3jw/kY9v3rDfw/tLnybPmuRwxcZxwrF2emhGMjBrfgOp
 J3xgtVqvzth7YQBSF5v0yx1m/msmf8YEUC0WajAkgEhhzrqUVxwSmEnKhCRYQznlzaGO
 +N8YTUFiHE+zscFmqDt4xre4tXRVHhIfkYklckKs5CJjzKwCaXrTuCN9/WcG++aqymyl
 t0jIjQ/rladDaf9g+6miSWHM81fLM7xZ/VvNMk6/ghhKyN574ZaV2N/hfK+eWzWxcDPN ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36vcm3rad1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 07:33:14 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11MCQGTO028704;
        Mon, 22 Feb 2021 07:31:53 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36vcm3r4xm-48
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 07:31:53 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11M8w7AK016468;
        Mon, 22 Feb 2021 08:59:15 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 36tt289f1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 08:59:14 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11M8xCLx43319562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Feb 2021 08:59:12 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F28C1AE04D;
        Mon, 22 Feb 2021 08:59:11 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4991BAE045;
        Mon, 22 Feb 2021 08:59:11 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 22 Feb 2021 08:59:11 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        pmorel@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 4/7] s390x: Provide preliminary backtrace support
Date:   Mon, 22 Feb 2021 03:57:53 -0500
Message-Id: <20210222085756.14396-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210222085756.14396-1-frankja@linux.ibm.com>
References: <20210222085756.14396-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-22_02:2021-02-22,2021-02-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 priorityscore=1501 spamscore=0 adultscore=0 clxscore=1015 bulkscore=0
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102220113
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After the stack changes we can finally use -mbackchain and have a
working backtrace.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/stack.c | 20 ++++++++++++++------
 s390x/Makefile    |  1 +
 s390x/macros.S    |  5 +++++
 3 files changed, 20 insertions(+), 6 deletions(-)

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
 
diff --git a/s390x/macros.S b/s390x/macros.S
index 11f4397a..d4f41ec4 100644
--- a/s390x/macros.S
+++ b/s390x/macros.S
@@ -22,6 +22,11 @@
 	lgr     %r2, %r15
 	/* Allocate stack space for called C function, as specified in s390 ELF ABI */
 	slgfi   %r15, 160
+	/*
+	 * Save the address of the interrupt stack into the back chain
+	 * of the called function.
+	 */
+	stg     %r2, STACK_FRAME_INT_BACKCHAIN(%r15)
 	brasl	%r14, \c_func
 	algfi   %r15, 160
 	RESTORE_REGS_STACK
-- 
2.25.1

