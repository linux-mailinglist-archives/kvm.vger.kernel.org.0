Return-Path: <kvm+bounces-23329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F89A948B8D
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 10:46:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 87C3BB24D7A
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 08:46:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CAFC1BDAAC;
	Tue,  6 Aug 2024 08:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mwLm6qfx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF382165F00;
	Tue,  6 Aug 2024 08:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722933950; cv=none; b=dLPRdKcbkUcm0D5g3koYGcCh9Sr1W0ssqRCUAXbJ7z6EyrIp6CvDU1uM2UnlDezZ8m4YE8DMnJuyVhKXBYWug2OoQ1lxG87QsHJBqo3Y9HqtxSYAeJzPK3BDZbjq3qoxV7hYPhEZ4J1biUJOpZVJ2eJDbGqo9D7zg52BF3A8O4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722933950; c=relaxed/simple;
	bh=vg5jQk8ALzIT1vMNHuWTbLofNttsS1PYgGyBZ1prI0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A2MxElizjF5zcHuN7fMezitpJg9iiEqtlciDsYKbxhV9Ssa/aXtVnFRF8Ej/j/nWFt9N9SWC3bRt0r8hxkdnGJxO8uGsQki+vUeZ2j4mTkPeWcGkVucIHpW/jJkYPA0H0T+9AHXkhbLs0DWMBf/tnTLq+LbKUrWENyjZk4XM50E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mwLm6qfx; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4762e9U7015943;
	Tue, 6 Aug 2024 08:45:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=rjC2lYFt+mJQA
	b7369Rl8ct2OpLXCjLW/0Y99IE+6LA=; b=mwLm6qfxPAMubhTqM/LIJkslisgLI
	ZBJI1pp+1BG+zQqIsGY8d9XrEgj3toe4KkxSnjiNJdI9h4o7JM8i5LuTZKMPRZbY
	ySxTBgPOzCsAvZrY5SHqHkunNY7Mx8wuBjmco+DVVty82WEzpCzPbSx1BpsziJzv
	IyFBIseZzBZFPvdW1IbFwTsqFzFnVO3xoSimoqi5m/6TxSyzPETuN6ZfwX8yO0zF
	Y8y0UD5QSeV1er36pLVVUQHa38fb5HA5NXvFgaUnGf/f7MEsubbbRp6NdWqRr0JM
	1XrBnJFCRZxj203omRDJZvLISpZPOwMM3XnPNFv0pj8GOFQy4t5rvBy2w==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40ub2x0nax-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Aug 2024 08:45:40 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4768htlN004170;
	Tue, 6 Aug 2024 08:45:40 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40ub2x0nav-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Aug 2024 08:45:40 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4767s7ZW024136;
	Tue, 6 Aug 2024 08:45:39 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 40syvpasak-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Aug 2024 08:45:39 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4768jYl045613412
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 6 Aug 2024 08:45:36 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0E3ED2006A;
	Tue,  6 Aug 2024 08:45:34 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D0DF12006B;
	Tue,  6 Aug 2024 08:45:33 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  6 Aug 2024 08:45:33 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
        schlameuss@linux.ibm.com, nsg@linux.ibm.com, npiggin@gmail.com,
        mhartmay@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 3/4] s390x: Move SIE assembly into new file
Date: Tue,  6 Aug 2024 08:42:29 +0000
Message-ID: <20240806084409.169039-4-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240806084409.169039-1-frankja@linux.ibm.com>
References: <20240806084409.169039-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GX1IoXdcQer3dO9DpCmlbqI2kRzNPwOZ
X-Proofpoint-ORIG-GUID: 2UAeRiDi0g7_6I5dpUM7bI-vm3-t1u7h
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-06_06,2024-08-02_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 spamscore=0 mlxscore=0 impostorscore=0 suspectscore=0
 phishscore=0 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408060060

In contrast to the other functions in cpu.S it's quite lengthy so
let's split it off.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 s390x/Makefile             |  2 +-
 s390x/{cpu.S => cpu-sie.S} | 59 +----------------------------------
 s390x/cpu.S                | 64 --------------------------------------
 3 files changed, 2 insertions(+), 123 deletions(-)
 copy s390x/{cpu.S => cpu-sie.S} (56%)

diff --git a/s390x/Makefile b/s390x/Makefile
index f09bccfc..97a74514 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -118,7 +118,7 @@ cflatobjs += lib/s390x/fault.o
 
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


