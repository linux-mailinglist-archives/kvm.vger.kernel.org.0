Return-Path: <kvm+bounces-37107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5585CA25488
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 09:37:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E5D2C1883530
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 08:37:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D30FE1FC7D6;
	Mon,  3 Feb 2025 08:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WSoxhcid"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDB61FBC86
	for <kvm@vger.kernel.org>; Mon,  3 Feb 2025 08:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738571806; cv=none; b=CGW+8dm8aAOKqyK++oAE/MLYFpyHjdBUn/IzUpcjSKjlKen4Ve+nP1+2+AG1mCiafdTAGm3EBa0mOCfP9Ge5y7El9iICHn1qJ3o4+eH0eAGCCIaNQxmgKfiC0HcqbYhkc0cYzyrgSHBz1lpRMmcmrzs1MQGYmp/F0rQxpgX4yX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738571806; c=relaxed/simple;
	bh=AaPBhkgaZX7ILQj/JrLmZqmr5IDtasGLRTnKRk1JJb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o4slL4tg9bmfepiccg5r5KK5RIS7ns4ditn5vZ1wi2uwd7DfD/pIPyMg1935YBHZcBY324BJJxWvvGNiP5p4MPfPxTo2kkQ8rhh7WXmSJrO50rLaKk+IS1yV+D2PQJyg6ItTF2W6OQAkwQibz+0UMSEYZb5n4t3mmL73/bVQqVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WSoxhcid; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5137MOUS014586;
	Mon, 3 Feb 2025 08:36:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Pr7HN/ZedBZbzihlH
	Fz4VOiMJjWk5u6rYTRp8SByVk0=; b=WSoxhcid4tJ6hOwi5bVixx5jFvZG1cdN1
	JI06qMOq7CO97l0UyYAJI7FcNf1u501956OIJZKeFRBzZd76CrJohD1LnFgSkV05
	jtCI0I57HpT4M1MfCEefTw6zDJztDNOXeTtlSL+QD7uLIsz2JWR/dT1AtTPuEizt
	EEndgBUiPXVqeC1GXNpz5PcQRYnHS2NiGGv9MVL+ZG4NO0u2xHBqNLhVIoG6xMOR
	jo1k4X5uyhSI1FLZfYvpZAGXI5QPP/Z45Z/jVt8lg7rj4YP5HOnvo/7TxVs8hcYJ
	7B6EcynEadizL6+PTGtzPUkIChwCQK+H4EaGj/9x914lpA5erln1w==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44jbht2xck-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:36 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5137feRJ024635;
	Mon, 3 Feb 2025 08:36:35 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44hxxmwe5h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Feb 2025 08:36:35 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5138aVMI47382876
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Feb 2025 08:36:32 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CABA220040;
	Mon,  3 Feb 2025 08:36:31 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5CFAA20043;
	Mon,  3 Feb 2025 08:36:31 +0000 (GMT)
Received: from t14-nrb.lan (unknown [9.171.84.16])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  3 Feb 2025 08:36:31 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 14/18] s390x: Move SIE assembly into new file
Date: Mon,  3 Feb 2025 09:35:22 +0100
Message-ID: <20250203083606.22864-15-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250203083606.22864-1-nrb@linux.ibm.com>
References: <20250203083606.22864-1-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: UVMXOXQMdOHvMPIJJKqi_QYSuB9Y4QkH
X-Proofpoint-GUID: UVMXOXQMdOHvMPIJJKqi_QYSuB9Y4QkH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-03_03,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 impostorscore=0 phishscore=0 spamscore=0 mlxscore=0
 mlxlogscore=915 bulkscore=0 suspectscore=0 lowpriorityscore=0
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2501170000 definitions=main-2502030068

From: Janosch Frank <frankja@linux.ibm.com>

In contrast to the other functions in cpu.S it's quite lengthy so
let's split it off.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
Link: https://lore.kernel.org/r/20240806084409.169039-4-frankja@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/Makefile  |  2 +-
 s390x/cpu-sie.S | 74 +++++++++++++++++++++++++++++++++++++++++++++++++
 s390x/cpu.S     | 64 ------------------------------------------
 3 files changed, 75 insertions(+), 65 deletions(-)
 create mode 100644 s390x/cpu-sie.S

diff --git a/s390x/Makefile b/s390x/Makefile
index 63e96d86..e5572cb6 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -122,7 +122,7 @@ cflatobjs += lib/s390x/fault.o
 
 OBJDIRS += lib/s390x
 
-asmlib = $(TEST_DIR)/cstart64.o $(TEST_DIR)/cpu.o
+asmlib = $(TEST_DIR)/cstart64.o $(TEST_DIR)/cpu.o $(TEST_DIR)/cpu-sie.o
 
 FLATLIBS = $(libcflat)
 
diff --git a/s390x/cpu-sie.S b/s390x/cpu-sie.S
new file mode 100644
index 00000000..9370b5c0
--- /dev/null
+++ b/s390x/cpu-sie.S
@@ -0,0 +1,74 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * s390x SIE assembly library
+ *
+ * Copyright (c) 2019 IBM Corp.
+ *
+ * Authors:
+ *    Janosch Frank <frankja@linux.ibm.com>
+ */
+#include <asm/asm-offsets.h>
+
+/*
+ * sie64a calling convention:
+ * %r2 pointer to sie control block
+ * %r3 guest register save area
+ */
+.globl sie64a
+sie64a:
+	# Save host grs, fprs, fpc
+	stmg	%r0,%r14,SIE_SAVEAREA_HOST_GRS(%r3)	# save kernel registers
+	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
+	std	\i, \i * 8  + SIE_SAVEAREA_HOST_FPRS(%r3)
+	.endr
+	stfpc	SIE_SAVEAREA_HOST_FPC(%r3)
+
+	stctg	%c1, %c1, SIE_SAVEAREA_HOST_ASCE(%r3)
+	lctlg	%c1, %c1, SIE_SAVEAREA_GUEST_ASCE(%r3)
+
+	# Store scb and save_area pointer into stack frame
+	stg	%r2,__SF_SIE_CONTROL(%r15)	# save control block pointer
+	stg	%r3,__SF_SIE_SAVEAREA(%r15)	# save guest register save area
+.globl sie_entry_gregs
+sie_entry_gregs:
+	# Load guest's gprs, fprs and fpc
+	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
+	ld	\i, \i * 8 + SIE_SAVEAREA_GUEST_FPRS(%r3)
+	.endr
+	lfpc	SIE_SAVEAREA_GUEST_FPC(%r3)
+	lmg	%r0,%r13,SIE_SAVEAREA_GUEST_GRS(%r3)
+
+	# Move scb ptr into r14 for the sie instruction
+	lg	%r14,__SF_SIE_CONTROL(%r15)
+
+.globl sie_entry
+sie_entry:
+	sie	0(%r14)
+	nopr	7
+	nopr	7
+	nopr	7
+
+.globl sie_exit
+sie_exit:
+	# Load guest register save area
+	lg	%r14,__SF_SIE_SAVEAREA(%r15)
+
+	# Restore the host asce
+	lctlg	%c1, %c1, SIE_SAVEAREA_HOST_ASCE(%r14)
+
+	# Store guest's gprs, fprs and fpc
+	stmg	%r0,%r13,SIE_SAVEAREA_GUEST_GRS(%r14)	# save guest gprs 0-13
+	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
+	std	\i, \i * 8  + SIE_SAVEAREA_GUEST_FPRS(%r14)
+	.endr
+	stfpc	SIE_SAVEAREA_GUEST_FPC(%r14)
+
+	# Restore host's gprs, fprs and fpc
+	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
+	ld	\i, \i * 8 + SIE_SAVEAREA_HOST_FPRS(%r14)
+	.endr
+	lfpc	SIE_SAVEAREA_HOST_FPC(%r14)
+	lmg	%r0,%r14,SIE_SAVEAREA_HOST_GRS(%r14)	# restore kernel registers
+.globl sie_exit_gregs
+sie_exit_gregs:
+	br	%r14
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
2.47.1


