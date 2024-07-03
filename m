Return-Path: <kvm+bounces-20904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D90D3926571
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 17:59:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C97128549E
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 15:59:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6299C1822F8;
	Wed,  3 Jul 2024 15:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ne4Gzgyx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DF9181BAE;
	Wed,  3 Jul 2024 15:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720022353; cv=none; b=oJKQSeQKMCGf0f7WDSfEtZIw+RF77beVX95694N7MOdTblLlUbYz314xndhKG9PNEZGTIujuNu305d7MXLB9wnf8u/HUqAWtnzVv+DEwFBRtynKhZOXE+yZULwxQjA9x71XoSvf6HUOvKJmvkS0ZcHuJcSJY2NUsUYUyEJ422pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720022353; c=relaxed/simple;
	bh=1gaTZoEwc8nfrThroo5Iic7JGh8gAdKysw5GCZuszbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4pNPjNAjHPpvjNxaKF6K15GWFaxIT1FonUvPZlWeyqhrmvhAmaqL1NPK7v5YvNk4WgYpKz3HNgcvAb0+XU33DZWfkCfPBYmIGJIaUW9MvCYvO551EJXatTTk6U9rEzczbYf665Ez27pStFq9ex53J+v/oD3NM4bEhU9O9yH1ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ne4Gzgyx; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 463Fw610004002;
	Wed, 3 Jul 2024 15:59:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=HXNq30fBPXeaY
	s2acHuhMbKO04/CkU04mqc/i+awCZI=; b=Ne4GzgyxcG8j1a938/4ZKczG60ABA
	JovbZR2f/DSdTvSTS00U8I8gtiUQQWem3RiBtXjnoCYdB7O5PY3LytvyMuRvVtmh
	51mse5YvQWPSg7vd0srXkjcYwN96Mmzmxg+wveY6JQrV9JzYZ1/UZ67PcYrlHaTB
	KtvFCgVjcVmpCVyyPa+PMg7bEfMqr6Zcw0Wj/P4b+25KPvejxoykEFQoJw/7IOmF
	DXNbBjEVlZaCKvLWToPbIXWva6EowPk/E/I5lcIVGwlwmVuewVDbQO+Vn80TQTIa
	xvXMgeqzQJ9Fz/vWqUAlm9KhDI2rG9PcXTZmWnmxAbxbx3leF9VK2vsZQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4056pbgm05-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Jul 2024 15:59:09 +0000 (GMT)
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 463Fx8oI005399;
	Wed, 3 Jul 2024 15:59:08 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4056pbgm03-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Jul 2024 15:59:08 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 463CwYun009502;
	Wed, 3 Jul 2024 15:59:07 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 402xtmu4b1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 03 Jul 2024 15:59:07 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 463Fx2O454854004
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 3 Jul 2024 15:59:04 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EB3192004E;
	Wed,  3 Jul 2024 15:59:01 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 938052004B;
	Wed,  3 Jul 2024 15:59:01 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  3 Jul 2024 15:59:01 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, hca@linux.ibm.com,
        svens@linux.ibm.com, agordeev@linux.ibm.com, gor@linux.ibm.com,
        nrb@linux.ibm.com, nsg@linux.ibm.com, seiden@linux.ibm.com,
        frankja@linux.ibm.com, borntraeger@de.ibm.com,
        gerald.schaefer@linux.ibm.com, david@redhat.com
Subject: [PATCH v1 2/2] s390/kvm: Move bitfields for dat tables
Date: Wed,  3 Jul 2024 17:59:00 +0200
Message-ID: <20240703155900.103783-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703155900.103783-1-imbrenda@linux.ibm.com>
References: <20240703155900.103783-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tigs0NhGoMl88ggsFQIvj_BOpb-Xth9_
X-Proofpoint-ORIG-GUID: 1boCPr46mv0kH5ZOQXbYtWtA4Kp0bW6q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-03_11,2024-07-03_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=465 bulkscore=0
 clxscore=1011 suspectscore=0 lowpriorityscore=0 mlxscore=0
 priorityscore=1501 adultscore=0 impostorscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2407030118

Move and improve the struct definitions for DAT tables from gaccess.c
to a new header.

Once in a separate header, the structs become available everywhere. One
possible usecase is to merge them in the s390 pte_t and p?d_t
definitions, which is left as an exercise for the reader.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/dat-bits.h | 170 +++++++++++++++++++++++++++++++
 arch/s390/kvm/gaccess.c          | 163 +----------------------------
 2 files changed, 173 insertions(+), 160 deletions(-)
 create mode 100644 arch/s390/include/asm/dat-bits.h

diff --git a/arch/s390/include/asm/dat-bits.h b/arch/s390/include/asm/dat-bits.h
new file mode 100644
index 000000000000..d8afd13be48c
--- /dev/null
+++ b/arch/s390/include/asm/dat-bits.h
@@ -0,0 +1,170 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * DAT table and related structures
+ *
+ * Copyright IBM Corp. 2024
+ *
+ */
+
+#ifndef _S390_DAT_BITS_H
+#define _S390_DAT_BITS_H
+
+union asce {
+	unsigned long val;
+	struct {
+		 unsigned long rsto: 52;/* Region- or Segment-Table Origin */
+		 unsigned long     : 2;
+		 unsigned long g   : 1; /* Subspace Group control */
+		 unsigned long p   : 1; /* Private Space control */
+		 unsigned long s   : 1; /* Storage-Alteration-Event control */
+		 unsigned long x   : 1; /* Space-Switch-Event control */
+		 unsigned long r   : 1; /* Real-Space control */
+		 unsigned long     : 1;
+		 unsigned long dt  : 2; /* Designation-Type control */
+		 unsigned long tl  : 2; /* Region- or Segment-Table Length */
+	};
+};
+
+enum {
+	ASCE_TYPE_SEGMENT = 0,
+	ASCE_TYPE_REGION3 = 1,
+	ASCE_TYPE_REGION2 = 2,
+	ASCE_TYPE_REGION1 = 3
+};
+
+union region1_table_entry {
+	unsigned long val;
+	struct {
+		unsigned long rto: 52;/* Region-Table Origin */
+		unsigned long    : 2;
+		unsigned long p  : 1; /* DAT-Protection Bit */
+		unsigned long    : 1;
+		unsigned long tf : 2; /* Region-Second-Table Offset */
+		unsigned long i  : 1; /* Region-Invalid Bit */
+		unsigned long    : 1;
+		unsigned long tt : 2; /* Table-Type Bits */
+		unsigned long tl : 2; /* Region-Second-Table Length */
+	};
+};
+
+union region2_table_entry {
+	unsigned long val;
+	struct {
+		unsigned long rto: 52;/* Region-Table Origin */
+		unsigned long    : 2;
+		unsigned long p  : 1; /* DAT-Protection Bit */
+		unsigned long    : 1;
+		unsigned long tf : 2; /* Region-Third-Table Offset */
+		unsigned long i  : 1; /* Region-Invalid Bit */
+		unsigned long    : 1;
+		unsigned long tt : 2; /* Table-Type Bits */
+		unsigned long tl : 2; /* Region-Third-Table Length */
+	};
+};
+
+struct region3_table_entry_fc0 {
+	unsigned long sto: 52;/* Segment-Table Origin */
+	unsigned long    : 1;
+	unsigned long fc : 1; /* Format-Control */
+	unsigned long p  : 1; /* DAT-Protection Bit */
+	unsigned long    : 1;
+	unsigned long tf : 2; /* Segment-Table Offset */
+	unsigned long i  : 1; /* Region-Invalid Bit */
+	unsigned long cr : 1; /* Common-Region Bit */
+	unsigned long tt : 2; /* Table-Type Bits */
+	unsigned long tl : 2; /* Segment-Table Length */
+};
+
+struct region3_table_entry_fc1 {
+	unsigned long rfaa: 33;/* Region-Frame Absolute Address */
+	unsigned long     : 14;
+	unsigned long av  : 1; /* ACCF-Validity Control */
+	unsigned long acc : 4; /* Access-Control Bits */
+	unsigned long f   : 1; /* Fetch-Protection Bit */
+	unsigned long fc  : 1; /* Format-Control */
+	unsigned long p   : 1; /* DAT-Protection Bit */
+	unsigned long iep : 1; /* Instruction-Execution-Protection */
+	unsigned long     : 2;
+	unsigned long i   : 1; /* Region-Invalid Bit */
+	unsigned long cr  : 1; /* Common-Region Bit */
+	unsigned long tt  : 2; /* Table-Type Bits */
+	unsigned long     : 2;
+};
+
+union region3_table_entry {
+	unsigned long val;
+	struct region3_table_entry_fc0 fc0;
+	struct region3_table_entry_fc1 fc1;
+	struct {
+		unsigned long   : 53;
+		unsigned long fc: 1; /* Format-Control */
+		unsigned long   : 4;
+		unsigned long i : 1; /* Region-Invalid Bit */
+		unsigned long cr: 1; /* Common-Region Bit */
+		unsigned long tt: 2; /* Table-Type Bits */
+		unsigned long   : 2;
+	};
+};
+
+struct segment_table_entry_fc0 {
+	unsigned long pto: 53;/* Page-Table Origin */
+	unsigned long fc : 1; /* Format-Control */
+	unsigned long p  : 1; /* DAT-Protection Bit */
+	unsigned long    : 3;
+	unsigned long i  : 1; /* Segment-Invalid Bit */
+	unsigned long cs : 1; /* Common-Segment Bit */
+	unsigned long tt : 2; /* Table-Type Bits */
+	unsigned long    : 2;
+};
+
+struct segment_table_entry_fc1 {
+	unsigned long sfaa: 44;/* Segment-Frame Absolute Address */
+	unsigned long     : 3;
+	unsigned long av  : 1; /* ACCF-Validity Control */
+	unsigned long acc : 4; /* Access-Control Bits */
+	unsigned long f   : 1; /* Fetch-Protection Bit */
+	unsigned long fc  : 1; /* Format-Control */
+	unsigned long p   : 1; /* DAT-Protection Bit */
+	unsigned long iep : 1; /* Instruction-Execution-Protection */
+	unsigned long     : 2;
+	unsigned long i   : 1; /* Segment-Invalid Bit */
+	unsigned long cs  : 1; /* Common-Segment Bit */
+	unsigned long tt  : 2; /* Table-Type Bits */
+	unsigned long     : 2;
+};
+
+union segment_table_entry {
+	unsigned long val;
+	struct segment_table_entry_fc0 fc0;
+	struct segment_table_entry_fc1 fc1;
+	struct {
+		unsigned long   : 53;
+		unsigned long fc: 1; /* Format-Control */
+		unsigned long   : 4;
+		unsigned long i : 1; /* Segment-Invalid Bit */
+		unsigned long cs: 1; /* Common-Segment Bit */
+		unsigned long tt: 2; /* Table-Type Bits */
+		unsigned long   : 2;
+	};
+};
+
+union page_table_entry {
+	unsigned long val;
+	struct {
+		unsigned long pfra: 52;/* Page-Frame Real Address */
+		unsigned long z   : 1; /* Zero Bit */
+		unsigned long i   : 1; /* Page-Invalid Bit */
+		unsigned long p   : 1; /* DAT-Protection Bit */
+		unsigned long iep : 1; /* Instruction-Execution-Protection */
+		unsigned long     : 8;
+	};
+};
+
+enum {
+	TABLE_TYPE_SEGMENT = 0,
+	TABLE_TYPE_REGION3 = 1,
+	TABLE_TYPE_REGION2 = 2,
+	TABLE_TYPE_REGION1 = 3
+};
+
+#endif /* _S390_DAT_BITS_H */
diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 5bf3d94e9dda..e65f597e3044 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -14,167 +14,10 @@
 #include <asm/access-regs.h>
 #include <asm/fault.h>
 #include <asm/gmap.h>
+#include <asm/dat-bits.h>
 #include "kvm-s390.h"
 #include "gaccess.h"
 
-union asce {
-	unsigned long val;
-	struct {
-		unsigned long origin : 52; /* Region- or Segment-Table Origin */
-		unsigned long	 : 2;
-		unsigned long g  : 1; /* Subspace Group Control */
-		unsigned long p  : 1; /* Private Space Control */
-		unsigned long s  : 1; /* Storage-Alteration-Event Control */
-		unsigned long x  : 1; /* Space-Switch-Event Control */
-		unsigned long r  : 1; /* Real-Space Control */
-		unsigned long	 : 1;
-		unsigned long dt : 2; /* Designation-Type Control */
-		unsigned long tl : 2; /* Region- or Segment-Table Length */
-	};
-};
-
-enum {
-	ASCE_TYPE_SEGMENT = 0,
-	ASCE_TYPE_REGION3 = 1,
-	ASCE_TYPE_REGION2 = 2,
-	ASCE_TYPE_REGION1 = 3
-};
-
-union region1_table_entry {
-	unsigned long val;
-	struct {
-		unsigned long rto: 52;/* Region-Table Origin */
-		unsigned long	 : 2;
-		unsigned long p  : 1; /* DAT-Protection Bit */
-		unsigned long	 : 1;
-		unsigned long tf : 2; /* Region-Second-Table Offset */
-		unsigned long i  : 1; /* Region-Invalid Bit */
-		unsigned long	 : 1;
-		unsigned long tt : 2; /* Table-Type Bits */
-		unsigned long tl : 2; /* Region-Second-Table Length */
-	};
-};
-
-union region2_table_entry {
-	unsigned long val;
-	struct {
-		unsigned long rto: 52;/* Region-Table Origin */
-		unsigned long	 : 2;
-		unsigned long p  : 1; /* DAT-Protection Bit */
-		unsigned long	 : 1;
-		unsigned long tf : 2; /* Region-Third-Table Offset */
-		unsigned long i  : 1; /* Region-Invalid Bit */
-		unsigned long	 : 1;
-		unsigned long tt : 2; /* Table-Type Bits */
-		unsigned long tl : 2; /* Region-Third-Table Length */
-	};
-};
-
-struct region3_table_entry_fc0 {
-	unsigned long sto: 52;/* Segment-Table Origin */
-	unsigned long	 : 1;
-	unsigned long fc : 1; /* Format-Control */
-	unsigned long p  : 1; /* DAT-Protection Bit */
-	unsigned long	 : 1;
-	unsigned long tf : 2; /* Segment-Table Offset */
-	unsigned long i  : 1; /* Region-Invalid Bit */
-	unsigned long cr : 1; /* Common-Region Bit */
-	unsigned long tt : 2; /* Table-Type Bits */
-	unsigned long tl : 2; /* Segment-Table Length */
-};
-
-struct region3_table_entry_fc1 {
-	unsigned long rfaa : 33; /* Region-Frame Absolute Address */
-	unsigned long	 : 14;
-	unsigned long av : 1; /* ACCF-Validity Control */
-	unsigned long acc: 4; /* Access-Control Bits */
-	unsigned long f  : 1; /* Fetch-Protection Bit */
-	unsigned long fc : 1; /* Format-Control */
-	unsigned long p  : 1; /* DAT-Protection Bit */
-	unsigned long iep: 1; /* Instruction-Execution-Protection */
-	unsigned long	 : 2;
-	unsigned long i  : 1; /* Region-Invalid Bit */
-	unsigned long cr : 1; /* Common-Region Bit */
-	unsigned long tt : 2; /* Table-Type Bits */
-	unsigned long	 : 2;
-};
-
-union region3_table_entry {
-	unsigned long val;
-	struct region3_table_entry_fc0 fc0;
-	struct region3_table_entry_fc1 fc1;
-	struct {
-		unsigned long	 : 53;
-		unsigned long fc : 1; /* Format-Control */
-		unsigned long	 : 4;
-		unsigned long i  : 1; /* Region-Invalid Bit */
-		unsigned long cr : 1; /* Common-Region Bit */
-		unsigned long tt : 2; /* Table-Type Bits */
-		unsigned long	 : 2;
-	};
-};
-
-struct segment_entry_fc0 {
-	unsigned long pto: 53;/* Page-Table Origin */
-	unsigned long fc : 1; /* Format-Control */
-	unsigned long p  : 1; /* DAT-Protection Bit */
-	unsigned long	 : 3;
-	unsigned long i  : 1; /* Segment-Invalid Bit */
-	unsigned long cs : 1; /* Common-Segment Bit */
-	unsigned long tt : 2; /* Table-Type Bits */
-	unsigned long	 : 2;
-};
-
-struct segment_entry_fc1 {
-	unsigned long sfaa : 44; /* Segment-Frame Absolute Address */
-	unsigned long	 : 3;
-	unsigned long av : 1; /* ACCF-Validity Control */
-	unsigned long acc: 4; /* Access-Control Bits */
-	unsigned long f  : 1; /* Fetch-Protection Bit */
-	unsigned long fc : 1; /* Format-Control */
-	unsigned long p  : 1; /* DAT-Protection Bit */
-	unsigned long iep: 1; /* Instruction-Execution-Protection */
-	unsigned long	 : 2;
-	unsigned long i  : 1; /* Segment-Invalid Bit */
-	unsigned long cs : 1; /* Common-Segment Bit */
-	unsigned long tt : 2; /* Table-Type Bits */
-	unsigned long	 : 2;
-};
-
-union segment_table_entry {
-	unsigned long val;
-	struct segment_entry_fc0 fc0;
-	struct segment_entry_fc1 fc1;
-	struct {
-		unsigned long	 : 53;
-		unsigned long fc : 1; /* Format-Control */
-		unsigned long	 : 4;
-		unsigned long i  : 1; /* Segment-Invalid Bit */
-		unsigned long cs : 1; /* Common-Segment Bit */
-		unsigned long tt : 2; /* Table-Type Bits */
-		unsigned long	 : 2;
-	};
-};
-
-enum {
-	TABLE_TYPE_SEGMENT = 0,
-	TABLE_TYPE_REGION3 = 1,
-	TABLE_TYPE_REGION2 = 2,
-	TABLE_TYPE_REGION1 = 3
-};
-
-union page_table_entry {
-	unsigned long val;
-	struct {
-		unsigned long pfra : 52; /* Page-Frame Real Address */
-		unsigned long z  : 1; /* Zero Bit */
-		unsigned long i  : 1; /* Page-Invalid Bit */
-		unsigned long p  : 1; /* DAT-Protection Bit */
-		unsigned long iep: 1; /* Instruction-Execution-Protection */
-		unsigned long	 : 8;
-	};
-};
-
 /*
  * vaddress union in order to easily decode a virtual address into its
  * region first index, region second index etc. parts.
@@ -632,7 +475,7 @@ static unsigned long guest_translate(struct kvm_vcpu *vcpu, unsigned long gva,
 	iep = ctlreg0.iep && test_kvm_facility(vcpu->kvm, 130);
 	if (asce.r)
 		goto real_address;
-	ptr = asce.origin * PAGE_SIZE;
+	ptr = asce.rsto * PAGE_SIZE;
 	switch (asce.dt) {
 	case ASCE_TYPE_REGION1:
 		if (vaddr.rfx01 > asce.tl)
@@ -1379,7 +1222,7 @@ static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
 	parent = sg->parent;
 	vaddr.addr = saddr;
 	asce.val = sg->orig_asce;
-	ptr = asce.origin * PAGE_SIZE;
+	ptr = asce.rsto * PAGE_SIZE;
 	if (asce.r) {
 		*fake = 1;
 		ptr = 0;
-- 
2.45.2


