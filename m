Return-Path: <kvm+bounces-27288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A62F097E601
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 08:31:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F0DC1F216BE
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 06:31:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9998F17BC9;
	Mon, 23 Sep 2024 06:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EW/MwPgG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80C91862F;
	Mon, 23 Sep 2024 06:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727073069; cv=none; b=n61g429lPMf8u+6dgXPotJHq7HClyu1UaOjzn3GND1FxMrJNZKZSp2y6ohdNZIJGeFTUBHSklq9RhGoFx9+qZTw1qPY5yVm20FL76hv6/gVfF9Qfz+6+1Q/RJc3lA79P4+mxqiQEpTinul57tB7VjcLwwfhiGldirx1Jl4Wx2oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727073069; c=relaxed/simple;
	bh=rxW//vZuGAtRNEViNAKLqp7B9+PIct2Ye3bIRW3KtBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GUzc4B+YpJ5E1luwPHHX77zg3SE+wdcWMLccii+0A6W1EREGZLugiUFIIFoH4j/jBDJkR2QPtPpnehrEzGVtk7NKps58gMBg0CgxD0vsCUNW2LTaL3iUR3Cdz8S4gwsZ9Bu+H8h+EXL1HKXb3dO76SvU6MVncqbkodOaG8p2tI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=EW/MwPgG; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48N1eFHM012818;
	Mon, 23 Sep 2024 06:30:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding; s=pp1; bh=yImlsXhEsP3lG
	TJl5ARInyjsvaodNKhdiL6Cf81Ht/c=; b=EW/MwPgGdwTO0x+cn0NgbNEpeUSHg
	ii/kM6050eGdB4Ur/yGkbCk6EVjqcGkS3reavYe8pbMgjogD80TvyPR6Dq5fQCbw
	i3lezfoS8gmVfVR2tBsV4Sh8/SzkeagqXwO/+gmg0cXZHz3szVFz/1Fu+wJyK/me
	xTMGy15gFdTbBlNlogC0qORpih+VqASJ0l+bNuA+jRLqGQLoUq1ryi6+tMBJ0ivf
	QR98OP1sacv2g4wTHLHfOBPpEvVSGmYC3jtPqyDaZ6/C7sVI25eiA9uyYXRqBgC3
	fsVZ5pBoQqGVorIVEj42V9FxoCbgs0VdHrwpaxe2ZEP+tLFAp2sfbdoLw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41snna1xqe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Sep 2024 06:30:34 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 48N6UXPY002120;
	Mon, 23 Sep 2024 06:30:33 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41snna1xay-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Sep 2024 06:30:33 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48N2Ud73008728;
	Mon, 23 Sep 2024 06:28:25 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 41t8v0w1c7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Sep 2024 06:28:25 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48N6SLmw31589070
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Sep 2024 06:28:22 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D86D720043;
	Mon, 23 Sep 2024 06:28:21 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9BF062004F;
	Mon, 23 Sep 2024 06:28:21 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 23 Sep 2024 06:28:21 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v2 2/2] s390x: edat: move LC_SIZE to arch_def.h
Date: Mon, 23 Sep 2024 08:26:04 +0200
Message-ID: <20240923062820.319308-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240923062820.319308-1-nrb@linux.ibm.com>
References: <20240923062820.319308-1-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MnXRp4UTkREjj8lLkYSgLwjDvJM-x_Ww
X-Proofpoint-ORIG-GUID: -B8ridWI6Cld5rdsDJOOWPOaOccbH6Or
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-23_03,2024-09-19_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 spamscore=0 impostorscore=0 priorityscore=1501
 phishscore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2408220000
 definitions=main-2409230043

struct lowcore is defined in arch_def.h and LC_SIZE is useful to other
tests as well, therefore move it to arch_def.h.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h | 1 +
 s390x/edat.c             | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 745a33878de5..5574a45156a9 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -119,6 +119,7 @@ enum address_space {
 
 #define CTL2_GUARDED_STORAGE		(63 - 59)
 
+#define LC_SIZE	(2 * PAGE_SIZE)
 struct lowcore {
 	uint8_t		pad_0x0000[0x0080 - 0x0000];	/* 0x0000 */
 	uint32_t	ext_int_param;			/* 0x0080 */
diff --git a/s390x/edat.c b/s390x/edat.c
index 16138397017c..e664b09d9633 100644
--- a/s390x/edat.c
+++ b/s390x/edat.c
@@ -17,7 +17,6 @@
 
 #define PGD_PAGE_SHIFT (REGION1_SHIFT - PAGE_SHIFT)
 
-#define LC_SIZE	(2 * PAGE_SIZE)
 #define VIRT(x)	((void *)((unsigned long)(x) + (unsigned long)mem))
 
 static uint8_t prefix_buf[LC_SIZE] __attribute__((aligned(LC_SIZE)));
-- 
2.46.0


