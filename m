Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7262133110A
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 15:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhCHOjQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 09:39:16 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23904 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231142AbhCHOir (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 09:38:47 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 128EbCMk189617;
        Mon, 8 Mar 2021 09:38:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=3RBpSnjGdYpQW4UVu35ikSG4mnH1lcSkbBYNhPb/heA=;
 b=l9M1UOtkQFlG2U1XVdhL1YpKjzZW0I8k75wdl/GbSZv1mmZVm6G0WsWEe6EJfY/iwl1G
 DnoHa8M8GsnXVApNl2FqtwBSnmDrsLiVfpYQyxiXW1DcZXouhlRHyf5GuYRZ1Sf1mXux
 ln+DXVo7mBK8JBdDcL24kZNlT8+DZafASrb+bZdiskSp2VBN10sYDQHYbN5CSRN9S8Hq
 Hh0RhZe+DB8RlmFGlneI4gJN2F9iKhA1uklpZRpwRIUDJJYSGRmJkDD3CSaEMH2+PHOx
 Gq5K8MqECqMKsvooTS4maq1L0zKpvGoMfw3apTitNj/GLGt7m/DCLT8oZAu1EgMkhc3J gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375nuk0294-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 09:38:46 -0500
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 128EbDuc189680;
        Mon, 8 Mar 2021 09:38:46 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 375nuk027q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 09:38:46 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 128EWrTW011940;
        Mon, 8 Mar 2021 14:33:44 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3741c8hw9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Mar 2021 14:33:44 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 128EXfVT43844088
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Mar 2021 14:33:41 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD6AFA404D;
        Mon,  8 Mar 2021 14:33:41 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52995A4051;
        Mon,  8 Mar 2021 14:33:41 +0000 (GMT)
Received: from fedora.fritz.box (unknown [9.145.7.187])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Mar 2021 14:33:41 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 09/16] s390x: Introduce and use CALL_INT_HANDLER macro
Date:   Mon,  8 Mar 2021 15:31:40 +0100
Message-Id: <20210308143147.64755-10-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210308143147.64755-1-frankja@linux.ibm.com>
References: <20210308143147.64755-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-08_08:2021-03-08,2021-03-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 clxscore=1015
 suspectscore=0 mlxscore=0 malwarescore=0 impostorscore=0 spamscore=0
 priorityscore=1501 adultscore=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103080080
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
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/cstart64.S | 27 +++++----------------------
 s390x/macros.S   | 17 +++++++++++++++++
 2 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index ad0e2145..666a9567 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -92,36 +92,19 @@ memsetxc:
 
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
index a7d62c6f..11f4397a 100644
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
+	/* Allocate stack space for called C function, as specified in s390 ELF ABI */
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
2.29.2

