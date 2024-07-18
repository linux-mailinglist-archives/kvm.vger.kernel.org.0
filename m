Return-Path: <kvm+bounces-21819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E67F4934BFC
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 12:53:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DFFC284C15
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 10:53:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D3EC13665D;
	Thu, 18 Jul 2024 10:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FkJvC3rR"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34379136653;
	Thu, 18 Jul 2024 10:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721299994; cv=none; b=OcHnU4jIGOYyzcFFXzV1ffjTyA8b/MGNYCbcy+waT9ZZQ/Wxj2wV/acl9+azQN2csi10ow5wwzDnLjRRKcsr4acaPbUWdbgf4ICEWZpdCAd5QUiWEFkWrMpPCCFXvfpfQ74zdgThgvWQNeVrAS7lUGXg3KHRJjyBJBraRBocOew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721299994; c=relaxed/simple;
	bh=8ZzGqgrHF7bXwPePjcE8by1i0K8yFmkI9mgPiniGO5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lcn/uNoY01+Y2bEH94jJuqxnEb5BCQoNULs00aj8G4l2EdLZ03frVvzUBIjYzM+ZsK6PhjXfeEOcOuBAptPCSTB3jCuEe3VlzFexW9EECL98D7SFVMf96tiUghD1X0pac27IS3Jchl1xgcp0lxr8NzgbQ+bxw4K+GZKm3xVVnrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=FkJvC3rR; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46I8R1B0008251;
	Thu, 18 Jul 2024 10:53:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=lzauRYefjJFhD
	bIme1BvTSvWS9AEzRxpZNXDkpL1Hfs=; b=FkJvC3rRkRJAIvDP6iQUFRWJmTXXe
	Cdt6w9unRYIdeZCP1G67jvX2OAyK0DBJstZA1XLLas9WroQEsQwbRopO6cVb51wc
	MafjS39DSyAtpBngubr4JgE/mw/r9aBEOvu5yx6YMGrvgRJvlvz/RbakdBm1vsTa
	ZT2PmHyqbi2jlSzAtKIdXBWZElAvnQc2or/iBN601RGC4m+u6O5JctquyCfSlf3I
	qUX+IyS/A8N/u/UT3EcX9EiUK8CMfapDT2hiw90Kh9FIZLRaBoRU0XxYEMchaAlH
	Z/lc6611+WPxVe811SCBJrs4y40wa4XRRFmpWQGKzV7cNd0dE6o550vKw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40evxe0pje-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jul 2024 10:53:11 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 46IArAZi026221;
	Thu, 18 Jul 2024 10:53:10 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40evxe0pgw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jul 2024 10:53:10 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 46I92oj0029260;
	Thu, 18 Jul 2024 10:52:30 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 40dwkj977x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jul 2024 10:52:30 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 46IAqOWT33817302
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jul 2024 10:52:26 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C8D4E2004D;
	Thu, 18 Jul 2024 10:52:24 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 975BA2004E;
	Thu, 18 Jul 2024 10:52:24 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 18 Jul 2024 10:52:24 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
        npiggin@gmail.com, nsg@linux.ibm.com, mhartmay@linux.ibm.com
Subject: [kvm-unit-tests PATCH 3/4] s390x: Move SIE assembly into new file
Date: Thu, 18 Jul 2024 10:50:18 +0000
Message-ID: <20240718105104.34154-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240718105104.34154-1-frankja@linux.ibm.com>
References: <20240718105104.34154-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wCRWg9ECmki9iW5JH4aLyeN7c1Mh9-zT
X-Proofpoint-ORIG-GUID: dBObeKp3LF1wdLKYfbfG3bkBBE6xfLeB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-18_07,2024-07-17_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 malwarescore=0 suspectscore=0 adultscore=0 spamscore=0 clxscore=1015
 bulkscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0
 mlxlogscore=976 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2407180072

In contrast to the other functions in cpu.S it's quite lengthy so
let's split it off.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/Makefile             |  2 +-
 s390x/{cpu.S => cpu-sie.S} | 59 +----------------------------------
 s390x/cpu.S                | 64 --------------------------------------
 3 files changed, 2 insertions(+), 123 deletions(-)
 copy s390x/{cpu.S => cpu-sie.S} (56%)

diff --git a/s390x/Makefile b/s390x/Makefile
index 457b8455..ecf0bc7e 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -119,7 +119,7 @@ cflatobjs += lib/s390x/fault.o
 
 OBJDIRS += lib/s390x
 
-asmlib = $(TEST_DIR)/cstart64.o $(TEST_DIR)/cpu.o
+asmlib = $(TEST_DIR)/cstart64.o $(TEST_DIR)/cpu.o $(TEST_DIR)/cpu-sie.o
 
 FLATLIBS = $(libcflat)
 
diff --git a/s390x/cpu.S b/s390x/cpu-sie.S
similarity index 56%
copy from s390x/cpu.S
copy to s390x/cpu-sie.S
index 9155b044..9370b5c0 100644
--- a/s390x/cpu.S
+++ b/s390x/cpu-sie.S
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * s390x assembly library
+ * s390x SIE assembly library
  *
  * Copyright (c) 2019 IBM Corp.
  *
@@ -8,59 +8,6 @@
  *    Janosch Frank <frankja@linux.ibm.com>
  */
 #include <asm/asm-offsets.h>
-#include <asm/sigp.h>
-
-#include "macros.S"
-
-/*
- * load_reset calling convention:
- * %r2 subcode (0 or 1)
- */
-.globl diag308_load_reset
-diag308_load_reset:
-	SAVE_REGS_STACK
-	/* Backup current PSW mask, as we have to restore it on success */
-	epsw	%r0, %r1
-	st	%r0, GEN_LC_SW_INT_PSW
-	st	%r1, GEN_LC_SW_INT_PSW + 4
-	/* Load reset psw mask (short psw, 64 bit) */
-	lg	%r0, reset_psw
-	/* Load the success label address */
-	larl    %r1, 0f
-	/* Or it to the mask */
-	ogr	%r0, %r1
-	/* Store it at the reset PSW location (real 0x0) */
-	stg	%r0, 0
-	stg     %r15, GEN_LC_SW_INT_GRS + 15 * 8
-	/* Do the reset */
-	diag    %r0,%r2,0x308
-	/* Failure path */
-	xgr	%r2, %r2
-	br	%r14
-	/* Success path */
-	/* load a cr0 that has the AFP control bit which enables all FPRs */
-0:	larl	%r1, initial_cr0
-	lctlg	%c0, %c0, 0(%r1)
-	lg      %r15, GEN_LC_SW_INT_GRS + 15 * 8
-	RESTORE_REGS_STACK
-	lhi	%r2, 1
-	larl	%r0, 1f
-	stg	%r0, GEN_LC_SW_INT_PSW + 8
-	lpswe	GEN_LC_SW_INT_PSW
-1:	br	%r14
-
-/* Sets up general registers and cr0 when a new cpu is brought online. */
-.globl smp_cpu_setup_state
-smp_cpu_setup_state:
-	xgr	%r1, %r1
-	lmg     %r0, %r15, GEN_LC_SW_INT_GRS
-	lctlg   %c0, %c0, GEN_LC_SW_INT_CRS
-	/* We should only go once through cpu setup and not for every restart */
-	stg	%r14, GEN_LC_RESTART_NEW_PSW + 8
-	larl	%r14, 0f
-	lpswe	GEN_LC_SW_INT_PSW
-	/* If the function returns, just loop here */
-0:	j	0
 
 /*
  * sie64a calling convention:
@@ -125,7 +72,3 @@ sie_exit:
 .globl sie_exit_gregs
 sie_exit_gregs:
 	br	%r14
-
-	.align	8
-reset_psw:
-	.quad	0x0008000180000000
diff --git a/s390x/cpu.S b/s390x/cpu.S
index 9155b044..2ff4b8e1 100644
--- a/s390x/cpu.S
+++ b/s390x/cpu.S
@@ -62,70 +62,6 @@ smp_cpu_setup_state:
 	/* If the function returns, just loop here */
 0:	j	0
 
-/*
- * sie64a calling convention:
- * %r2 pointer to sie control block
- * %r3 guest register save area
- */
-.globl sie64a
-sie64a:
-	# Save host grs, fprs, fpc
-	stmg	%r0,%r14,SIE_SAVEAREA_HOST_GRS(%r3)	# save kernel registers
-	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
-	std	\i, \i * 8  + SIE_SAVEAREA_HOST_FPRS(%r3)
-	.endr
-	stfpc	SIE_SAVEAREA_HOST_FPC(%r3)
-
-	stctg	%c1, %c1, SIE_SAVEAREA_HOST_ASCE(%r3)
-	lctlg	%c1, %c1, SIE_SAVEAREA_GUEST_ASCE(%r3)
-
-	# Store scb and save_area pointer into stack frame
-	stg	%r2,__SF_SIE_CONTROL(%r15)	# save control block pointer
-	stg	%r3,__SF_SIE_SAVEAREA(%r15)	# save guest register save area
-.globl sie_entry_gregs
-sie_entry_gregs:
-	# Load guest's gprs, fprs and fpc
-	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
-	ld	\i, \i * 8 + SIE_SAVEAREA_GUEST_FPRS(%r3)
-	.endr
-	lfpc	SIE_SAVEAREA_GUEST_FPC(%r3)
-	lmg	%r0,%r13,SIE_SAVEAREA_GUEST_GRS(%r3)
-
-	# Move scb ptr into r14 for the sie instruction
-	lg	%r14,__SF_SIE_CONTROL(%r15)
-
-.globl sie_entry
-sie_entry:
-	sie	0(%r14)
-	nopr	7
-	nopr	7
-	nopr	7
-
-.globl sie_exit
-sie_exit:
-	# Load guest register save area
-	lg	%r14,__SF_SIE_SAVEAREA(%r15)
-
-	# Restore the host asce
-	lctlg	%c1, %c1, SIE_SAVEAREA_HOST_ASCE(%r14)
-
-	# Store guest's gprs, fprs and fpc
-	stmg	%r0,%r13,SIE_SAVEAREA_GUEST_GRS(%r14)	# save guest gprs 0-13
-	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
-	std	\i, \i * 8  + SIE_SAVEAREA_GUEST_FPRS(%r14)
-	.endr
-	stfpc	SIE_SAVEAREA_GUEST_FPC(%r14)
-
-	# Restore host's gprs, fprs and fpc
-	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
-	ld	\i, \i * 8 + SIE_SAVEAREA_HOST_FPRS(%r14)
-	.endr
-	lfpc	SIE_SAVEAREA_HOST_FPC(%r14)
-	lmg	%r0,%r14,SIE_SAVEAREA_HOST_GRS(%r14)	# restore kernel registers
-.globl sie_exit_gregs
-sie_exit_gregs:
-	br	%r14
-
 	.align	8
 reset_psw:
 	.quad	0x0008000180000000
-- 
2.43.0


