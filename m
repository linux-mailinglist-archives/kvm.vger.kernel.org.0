Return-Path: <kvm+bounces-5820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 92D15826FD6
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 14:30:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 468AB1F231BC
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 13:30:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 090F145BFC;
	Mon,  8 Jan 2024 13:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Qutqw+7b"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EB945941;
	Mon,  8 Jan 2024 13:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 408DLCrY020833;
	Mon, 8 Jan 2024 13:29:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=gnwH4Al/JpPmcSuv8tPAr6O34tKZ0I9Uyzaa9KiSEIs=;
 b=Qutqw+7bm4RLoGLlgi/hL5aphSeseCS3CC1dgDor+Nh6Tt1KgcOP74zN3nFS0ua9U6RJ
 v5c2DyNIOH3EJa65cnrv5Q17OFl/48yph/+fO4q3gft7AGdzVYv1ZSmV3vKRh4SaY2qp
 DKeOZWi8eVCJ9z5u/TJ7PKNJrP42P2+5RK0V5twVG4cxPPqTNaNluaNZkrh7X6+e0Wll
 R+cuZ+iPHDgWmaLrSj2D/tDWcSNxqIZ7feGrRh2GyQgx+WhzjqwK8JsrWz7rdPsOTFJZ
 lsyxfkAqr/vGlJ2xn1AKLVtMNP9MivstpupdExiG/jyNEsj/jWykRWEgTWYXfTYaYxBW /g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vf1uypspw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Jan 2024 13:29:50 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 408DLOKv021001;
	Mon, 8 Jan 2024 13:29:50 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vf1uypsp4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Jan 2024 13:29:50 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 408D6370004407;
	Mon, 8 Jan 2024 13:29:49 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vfjpkfxxw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Jan 2024 13:29:49 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 408DTk9O19399394
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 8 Jan 2024 13:29:46 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2FD5F20043;
	Mon,  8 Jan 2024 13:29:46 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 091CF2004B;
	Mon,  8 Jan 2024 13:29:46 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  8 Jan 2024 13:29:45 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH 1/5] lib: s390x: Add spm cc shift constant
Date: Mon,  8 Jan 2024 13:29:17 +0000
Message-Id: <20240108132921.255769-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240108132921.255769-1-frankja@linux.ibm.com>
References: <20240108132921.255769-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dtlsJvH_GHHfKYIWl1TTIsALMACOFZiU
X-Proofpoint-GUID: SsOEN-vR7iCxklOCD2XjiaSYHhzc6CpZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-08_04,2024-01-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 clxscore=1015 adultscore=0 mlxlogscore=458
 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401080115

Set Program Mask expects the CC in bits 34 and 35 of a GPR.
Adding a constant makes setting the CC in inline assembly a bit easier.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/arch_def.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
index 745a3387..65ae1e93 100644
--- a/lib/s390x/asm/arch_def.h
+++ b/lib/s390x/asm/arch_def.h
@@ -84,6 +84,8 @@ struct cpu {
 	bool in_interrupt_handler;
 };
 
+#define SPM_CC_SHIFT 28
+
 enum address_space {
 	AS_PRIM = 0,
 	AS_ACCR = 1,
-- 
2.40.1


