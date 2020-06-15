Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B631F938E
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 11:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729139AbgFOJdh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 05:33:37 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51614 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728825AbgFOJdh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 15 Jun 2020 05:33:37 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05F9XJXc150382;
        Mon, 15 Jun 2020 05:33:36 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31np7bc0v9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Jun 2020 05:33:35 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05F9XZsq151762;
        Mon, 15 Jun 2020 05:33:35 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31np7bc047-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Jun 2020 05:33:32 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05F9K0m4025068;
        Mon, 15 Jun 2020 09:32:07 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 31mpe89aw0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 15 Jun 2020 09:32:07 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05F9W4hM23658748
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jun 2020 09:32:05 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B7F152065;
        Mon, 15 Jun 2020 09:32:04 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.1.141])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id EEFB152054;
        Mon, 15 Jun 2020 09:32:03 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Subject: [kvm-unit-tests PATCH v9 03/12] s390x: saving regs for interrupts
Date:   Mon, 15 Jun 2020 11:31:52 +0200
Message-Id: <1592213521-19390-4-git-send-email-pmorel@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
References: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-15_01:2020-06-15,2020-06-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 clxscore=1015
 cotscore=-2147483648 mlxscore=0 lowpriorityscore=0 phishscore=0
 suspectscore=1 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006150078
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If we use multiple source of interrupts, for example, using SCLP
console to print information while using I/O interrupts, we need
to have a re-entrant register saving interruption handling.

Instead of saving at a static memory address, let's save the base
registers, the floating point registers and the floating point
control register on the stack in case of I/O interrupts

Note that we keep the static register saving to recover from the
RESET tests.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
Acked-by: Janosch Frank <frankja@linux.ibm.com>
Acked-by: Thomas Huth <thuth@redhat.com>
---
 s390x/cstart64.S | 41 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index e7327ea..7ca9496 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -119,6 +119,43 @@ memsetxc:
 	lmg	%r0, %r15, GEN_LC_SW_INT_GRS
 	.endm
 
+/* Save registers on the stack (r15), so we can have stacked interrupts. */
+	.macro SAVE_REGS_STACK
+	/* Allocate a stack frame for 15 general registers */
+	slgfi   %r15, 15 * 8
+	/* Store registers r0 to r14 on the stack */
+	stmg    %r0, %r14, 0(%r15)
+	/* Allocate a stack frame for 16 floating point registers */
+	/* The size of a FP register is the size of an double word */
+	slgfi   %r15, 16 * 8
+	/* Save fp register on stack: offset to SP is multiple of reg number */
+	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
+	std	\i, \i * 8(%r15)
+	.endr
+	/* Save fpc, but keep stack aligned on 64bits */
+	slgfi   %r15, 8
+	efpc	%r0
+	stg	%r0, 0(%r15)
+	.endm
+
+/* Restore the register in reverse order */
+	.macro RESTORE_REGS_STACK
+	/* Restore fpc */
+	lfpc	0(%r15)
+	algfi	%r15, 8
+	/* Restore fp register from stack: SP still where it was left */
+	/* and offset to SP is a multiple of reg number */
+	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
+	ld	\i, \i * 8(%r15)
+	.endr
+	/* Now that we're done, rewind the stack pointer by 16 double word */
+	algfi   %r15, 16 * 8
+	/* Load the registers from stack */
+	lmg     %r0, %r14, 0(%r15)
+	/* Rewind the stack by 15 double word */
+	algfi   %r15, 15 * 8
+	.endm
+
 .section .text
 /*
  * load_reset calling convention:
@@ -186,9 +223,9 @@ mcck_int:
 	lpswe	GEN_LC_MCCK_OLD_PSW
 
 io_int:
-	SAVE_REGS
+	SAVE_REGS_STACK
 	brasl	%r14, handle_io_int
-	RESTORE_REGS
+	RESTORE_REGS_STACK
 	lpswe	GEN_LC_IO_OLD_PSW
 
 svc_int:
-- 
2.25.1

