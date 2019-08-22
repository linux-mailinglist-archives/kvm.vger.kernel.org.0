Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE50C991BE
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 13:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388084AbfHVLLT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 07:11:19 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23030 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388071AbfHVLLT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Aug 2019 07:11:19 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7MB8LmL125110
        for <kvm@vger.kernel.org>; Thu, 22 Aug 2019 07:11:17 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2uhqy351nn-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 22 Aug 2019 07:11:17 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 22 Aug 2019 12:11:15 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 22 Aug 2019 12:11:11 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x7MBAo9K39911880
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Aug 2019 11:10:50 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B593A11C052;
        Thu, 22 Aug 2019 11:11:10 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED95D11C05C;
        Thu, 22 Aug 2019 11:11:09 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.131])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 22 Aug 2019 11:11:09 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH] s390x: Add diag308 subcode 0 testing
Date:   Thu, 22 Aug 2019 13:11:00 +0200
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190821104736.1470-1-frankja@linux.ibm.com>
References: <20190821104736.1470-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19082211-0016-0000-0000-000002A174B7
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19082211-0017-0000-0000-00003301AD6B
Message-Id: <20190822111100.4444-1-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-22_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908220120
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

By adding a load reset routine to cstart.S we can also test the clear
reset done by subcode 0, as we now can restore our registers again.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
I managed to extract this from another bigger test, so let's add it to the bunch.
I'd be very happy about assembly review :-)
---
 s390x/cstart64.S | 27 +++++++++++++++++++++++++++
 s390x/diag308.c  | 31 ++++++++++---------------------
 2 files changed, 37 insertions(+), 21 deletions(-)

diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index dedfe80..47045e1 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -145,6 +145,33 @@ memsetxc:
 	.endm
 
 .section .text
+/*
+ * load_reset calling convention:
+ * %r2 subcode (0 or 1)
+ */
+.globl load_reset
+load_reset:
+	SAVE_REGS
+	/* Save the first PSW word to the IPL PSW */
+	epsw	%r0, %r1
+	st	%r0, 0
+	/* Store the address and the bit for 31 bit addressing */
+	larl    %r0, 0f
+	oilh    %r0, 0x8000
+	st      %r0, 0x4
+	/* Do the reset */
+	diag    %r0,%r2,0x308
+	/* Failure path */
+	xgr	%r2, %r2
+	br	%r14
+	/* Success path */
+	/* We lost cr0 due to the reset */
+0:	larl	%r1, initial_cr0
+	lctlg	%c0, %c0, 0(%r1)
+	RESTORE_REGS
+	lhi	%r2, 1
+	br	%r14
+
 pgm_int:
 	SAVE_REGS
 	brasl	%r14, handle_pgm_int
diff --git a/s390x/diag308.c b/s390x/diag308.c
index f085b1a..baf9fd3 100644
--- a/s390x/diag308.c
+++ b/s390x/diag308.c
@@ -21,32 +21,20 @@ static void test_priv(void)
 	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
 }
 
+
 /*
- * Check that diag308 with subcode 1 loads the PSW at address 0, i.e.
+ * Check that diag308 with subcode 0 and 1 loads the PSW at address 0, i.e.
  * that we can put a pointer into address 4 which then gets executed.
  */
+extern int load_reset(u64);
+static void test_subcode0(void)
+{
+	report("load modified clear done", load_reset(0));
+}
+
 static void test_subcode1(void)
 {
-	uint64_t saved_psw = *(uint64_t *)0;
-	long subcode = 1;
-	long ret, tmp;
-
-	asm volatile (
-		"	epsw	%0,%1\n"
-		"	st	%0,0\n"
-		"	larl	%0,0f\n"
-		"	oilh	%0,0x8000\n"
-		"	st	%0,4\n"
-		"	diag	0,%2,0x308\n"
-		"	lghi	%0,0\n"
-		"	j	1f\n"
-		"0:	lghi	%0,1\n"
-		"1:"
-		: "=&d"(ret), "=&d"(tmp) : "d"(subcode) : "memory");
-
-	*(uint64_t *)0 = saved_psw;
-
-	report("load normal reset done", ret == 1);
+	report("load normal reset done", load_reset(1));
 }
 
 /* Expect a specification exception when using an uneven register */
@@ -107,6 +95,7 @@ static struct {
 	void (*func)(void);
 } tests[] = {
 	{ "privileged", test_priv },
+	{ "subcode 0", test_subcode0 },
 	{ "subcode 1", test_subcode1 },
 	{ "subcode 5", test_subcode5 },
 	{ "subcode 6", test_subcode6 },
-- 
2.17.0

