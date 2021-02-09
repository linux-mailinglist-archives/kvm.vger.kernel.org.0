Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC3743150E4
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 14:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231536AbhBINw4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 08:52:56 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6070 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231838AbhBINvc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Feb 2021 08:51:32 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 119DWTa7036302;
        Tue, 9 Feb 2021 08:50:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ByvLnKrYY+rMkq0ReAiSiW4ZyteOVq1bmi+FGSYuKBc=;
 b=YSW5KNTA63rVCAX6fPcC9084/Goj8Jvt7YFNORUZsL9ygb6mCfD8fgbIDJMqNUPiPq+O
 PMHNIZ8OVuPirve0wdW0Of86aRdvSpCaxNbPOwl/4EW/nSQ6P1XzRpMLIclH7sAFLbeL
 YCEoK/J0zQigaQq4PRC1TnjIg9erc5ZpkCvvt3mt0yvyS57cYoaovu3DzXhYMRXPpn+R
 dNER3sfLXqUEo+jwr8KnGwgnmFgO65lSZLC3cTJPZYrQSg3NMNyvJsl3U5kPzpjaEueC
 tko64w0bNtS+KV2q3EFrAIAHILiuhY0vlPcHh69Y2KpWZHvGd+DkImQUSHwd9BxQ1cvE ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36ku30h6jx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 08:50:50 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 119DX6hI039462;
        Tue, 9 Feb 2021 08:50:50 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36ku30h6j2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 08:50:50 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 119DTVFn011235;
        Tue, 9 Feb 2021 13:50:47 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 36hjr81r9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 13:50:47 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 119DoiHN38469940
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Feb 2021 13:50:44 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9B5B3A404D;
        Tue,  9 Feb 2021 13:50:44 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E76B4A4051;
        Tue,  9 Feb 2021 13:50:43 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  9 Feb 2021 13:50:43 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, thuth@redhat.com,
        pmorel@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 4/8] s390x: Introduce and use CALL_INT_HANDLER macro
Date:   Tue,  9 Feb 2021 08:49:21 -0500
Message-Id: <20210209134925.22248-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210209134925.22248-1-frankja@linux.ibm.com>
References: <20210209134925.22248-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_03:2021-02-09,2021-02-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 mlxlogscore=940 mlxscore=0 bulkscore=0 suspectscore=0
 impostorscore=0 phishscore=0 malwarescore=0 priorityscore=1501
 adultscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090067
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The ELF ABI dictates that we need to allocate 160 bytes of stack space
for the C functions we're calling. Since we would need to do that for
every interruption handler which, combined with the new stack argument
being saved in GR2, makes cstart64.S look a bit messy.

So let's introduce the CALL_INT_HANDLER macro that handles all of
that, calls the C interrupt handler and handles cleanup afterwards.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/cstart64.S | 28 +++++-----------------------
 s390x/macros.S   | 17 +++++++++++++++++
 2 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index 35d20293..666a9567 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -92,37 +92,19 @@ memsetxc:
 
 .section .text
 pgm_int:
-	SAVE_REGS_STACK
-	lgr     %r2, %r15
-	brasl	%r14, handle_pgm_int
-	RESTORE_REGS_STACK
-	lpswe	GEN_LC_PGM_OLD_PSW
+	CALL_INT_HANDLER handle_pgm_int, GEN_LC_PGM_OLD_PSW
 
 ext_int:
-	SAVE_REGS_STACK
-	lgr     %r2, %r15
-	brasl	%r14, handle_ext_int
-	RESTORE_REGS_STACK
-	lpswe	GEN_LC_EXT_OLD_PSW
+	CALL_INT_HANDLER handle_ext_int, GEN_LC_EXT_OLD_PSW
 
 mcck_int:
-	SAVE_REGS_STACK
-	brasl	%r14, handle_mcck_int
-	RESTORE_REGS_STACK
-	lpswe	GEN_LC_MCCK_OLD_PSW
+	CALL_INT_HANDLER handle_mcck_int, GEN_LC_MCCK_OLD_PSW
 
 io_int:
-	SAVE_REGS_STACK
-	lgr     %r2, %r15
-	brasl	%r14, handle_io_int
-	RESTORE_REGS_STACK
-	lpswe	GEN_LC_IO_OLD_PSW
+	CALL_INT_HANDLER handle_io_int, GEN_LC_IO_OLD_PSW
 
 svc_int:
-	SAVE_REGS_STACK
-	brasl	%r14, handle_svc_int
-	RESTORE_REGS_STACK
-	lpswe	GEN_LC_SVC_OLD_PSW
+	CALL_INT_HANDLER handle_svc_int, GEN_LC_SVC_OLD_PSW
 
 	.align	8
 initial_psw:
diff --git a/s390x/macros.S b/s390x/macros.S
index 9810d2ff..1678c821 100644
--- a/s390x/macros.S
+++ b/s390x/macros.S
@@ -11,6 +11,23 @@
  *  David Hildenbrand <david@redhat.com>
  */
 #include <asm/asm-offsets.h>
+/*
+ * Exception handler macro that saves registers on the stack,
+ * allocates stack space and calls the C handler function. Afterwards
+ * we re-load the registers and load the old PSW.
+ */
+	.macro CALL_INT_HANDLER c_func, old_psw
+	SAVE_REGS_STACK
+	/* Save the stack address in GR2 which is the first function argument */
+	lgr     %r2, %r15
+	/* Allocate stack pace for called C function, as specified in s390 ELF ABI */
+	slgfi   %r15, 160
+	brasl	%r14, \c_func
+	algfi   %r15, 160
+	RESTORE_REGS_STACK
+	lpswe	\old_psw
+	.endm
+
 	.macro SAVE_REGS
 	/* save grs 0-15 */
 	stmg	%r0, %r15, GEN_LC_SW_INT_GRS
-- 
2.25.1

