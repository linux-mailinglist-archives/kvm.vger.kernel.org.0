Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B16B53213A0
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 11:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbhBVKBb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 05:01:31 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:13614 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230209AbhBVKAs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Feb 2021 05:00:48 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11M9vjtG063171;
        Mon, 22 Feb 2021 05:00:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=b+leU8p/djmFqf5rzqEMmh41Y4UnIZj9PPKk1WmeHQM=;
 b=lk9bJ3qy/JmFtSaywZLNmXoq2KJSF6Ihm25ADXQuP2Rr1eGjVwxznULt/MCxBLSMazKY
 WsN9PEyskHlSQ9qWIOffNIhqYRQsj3VDcHCiZO0LOpMZOwPSW8RiYCKVeYKDRtTdfbBF
 kFATTKnzPKCWPAxKuCRAvqogMQSjkXS6gPf6mu9dVR1X822M2OdJSr8nySh5N3/EWlCU
 ddhoU7tfnIS1G9Phj9l1nXqzc4Hy5myazNiEU9w6czcA0Z1AqfQBLJ4dgCwHSDemLfs5
 +jSUs1CgZntlD+Px7dVpDzsu3nHVki5U25bJYs0Euvfwkl2s6ogIiG+T/j7vDqgJMJ5v OA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36vacb09cd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 04:59:58 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11M9rpG7020713;
        Mon, 22 Feb 2021 04:59:19 -0500
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36vacb0707-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 04:59:19 -0500
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11M8vPp1024219;
        Mon, 22 Feb 2021 08:59:17 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 36tt288rby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Feb 2021 08:59:17 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11M8xE6o61735380
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Feb 2021 08:59:14 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90A51AE051;
        Mon, 22 Feb 2021 08:59:14 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC68AAE053;
        Mon, 22 Feb 2021 08:59:13 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 22 Feb 2021 08:59:13 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        pmorel@linux.ibm.com, david@redhat.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 7/7] s390x: Remove SAVE/RESTORE_STACK and lowcore fpc and fprs save areas
Date:   Mon, 22 Feb 2021 03:57:56 -0500
Message-Id: <20210222085756.14396-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210222085756.14396-1-frankja@linux.ibm.com>
References: <20210222085756.14396-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-22_02:2021-02-18,2021-02-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 malwarescore=0 priorityscore=1501 suspectscore=0 impostorscore=0
 mlxscore=0 adultscore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0
 mlxlogscore=947 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102220086
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are no more users. At the same time remove sw_int_fpc and
sw_int_frps plus their asm offsets macros since they are also unused
now.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
---
 lib/s390x/asm-offsets.c  |  2 --
 lib/s390x/asm/arch_def.h |  4 +---
 s390x/macros.S           | 29 -----------------------------
 3 files changed, 1 insertion(+), 34 deletions(-)

diff --git a/lib/s390x/asm-offsets.c b/lib/s390x/asm-offsets.c
index 2658b59a..fbea3278 100644
--- a/lib/s390x/asm-offsets.c
+++ b/lib/s390x/asm-offsets.c
@@ -54,8 +54,6 @@ int main(void)
 	OFFSET(GEN_LC_MCCK_NEW_PSW, lowcore, mcck_new_psw);
 	OFFSET(GEN_LC_IO_NEW_PSW, lowcore, io_new_psw);
 	OFFSET(GEN_LC_SW_INT_GRS, lowcore, sw_int_grs);
-	OFFSET(GEN_LC_SW_INT_FPRS, lowcore, sw_int_fprs);
-	OFFSET(GEN_LC_SW_INT_FPC, lowcore, sw_int_fpc);
 	OFFSET(GEN_LC_SW_INT_CRS, lowcore, sw_int_crs);
 	OFFSET(GEN_LC_SW_INT_PSW, lowcore, sw_int_psw);
 	OFFSET(GEN_LC_MCCK_EXT_SA_ADDR, lowcore, mcck_ext_sa_addr);
diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index b8e9fe40..13e19b8a 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -103,9 +103,7 @@ struct lowcore {
 	struct psw	io_new_psw;			/* 0x01f0 */
 	/* sw definition: save area for registers in interrupt handlers */
 	uint64_t	sw_int_grs[16];			/* 0x0200 */
-	uint64_t	sw_int_fprs[16];		/* 0x0280 */
-	uint32_t	sw_int_fpc;			/* 0x0300 */
-	uint8_t		pad_0x0304[0x0308 - 0x0304];	/* 0x0304 */
+	uint8_t		pad_0x0304[0x0308 - 0x0280];	/* 0x0280 */
 	uint64_t	sw_int_crs[16];			/* 0x0308 */
 	struct psw	sw_int_psw;			/* 0x0388 */
 	uint8_t		pad_0x0310[0x11b0 - 0x0398];	/* 0x0398 */
diff --git a/s390x/macros.S b/s390x/macros.S
index d4f41ec4..13cff299 100644
--- a/s390x/macros.S
+++ b/s390x/macros.S
@@ -33,35 +33,6 @@
 	lpswe	\old_psw
 	.endm
 
-	.macro SAVE_REGS
-	/* save grs 0-15 */
-	stmg	%r0, %r15, GEN_LC_SW_INT_GRS
-	/* save crs 0-15 */
-	stctg	%c0, %c15, GEN_LC_SW_INT_CRS
-	/* load a cr0 that has the AFP control bit which enables all FPRs */
-	larl	%r1, initial_cr0
-	lctlg	%c0, %c0, 0(%r1)
-	/* save fprs 0-15 + fpc */
-	la	%r1, GEN_LC_SW_INT_FPRS
-	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
-	std	\i, \i * 8(%r1)
-	.endr
-	stfpc	GEN_LC_SW_INT_FPC
-	.endm
-
-	.macro RESTORE_REGS
-	/* restore fprs 0-15 + fpc */
-	la	%r1, GEN_LC_SW_INT_FPRS
-	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
-	ld	\i, \i * 8(%r1)
-	.endr
-	lfpc	GEN_LC_SW_INT_FPC
-	/* restore crs 0-15 */
-	lctlg	%c0, %c15, GEN_LC_SW_INT_CRS
-	/* restore grs 0-15 */
-	lmg	%r0, %r15, GEN_LC_SW_INT_GRS
-	.endm
-
 /* Save registers on the stack (r15), so we can have stacked interrupts. */
 	.macro SAVE_REGS_STACK
 	/* Allocate a full stack frame */
-- 
2.25.1

