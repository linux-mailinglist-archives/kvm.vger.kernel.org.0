Return-Path: <kvm+bounces-7534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B326843829
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 08:45:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CBBEA287F7E
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 07:45:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 190C055E78;
	Wed, 31 Jan 2024 07:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fR5ffCNR"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD135FB91;
	Wed, 31 Jan 2024 07:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706687100; cv=none; b=rdQkxcPo17/hWF3jBTzvYHj9I32M3XtX6XxaC0iXBav+Z7tWvTRWYI++v0GCBh76Iakux6bnWjlSL+N3tg/FCQS4CMBWks94ptE/kHfzwTiQuHDPFAWcSYbR1VRQwRYVtsDjG2FpYJjGogxrl9yIZIoHsi/W3gH4TMpNKb+RoaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706687100; c=relaxed/simple;
	bh=3VUZIrNac6QNc6eY2T7G+9rIdXJOTUPGW5h0A6G4CpE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=G+RtaLcG4b4y+xTpsh69AlzpzPjoQtGg6+8DrtiOt1Dhs/08SIDAs05gmoSQCfuh4EyUVt3MrlBxBbcjG81Fqg8etD9Ag+97Y/EIqoavfJHX9ORdlQIBWveHoSSkkf5qtWu/eWe1aTyXLuFTYzPwfqCEHAgTevOfR4TJ1BGWghs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fR5ffCNR; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40V780c1028868;
	Wed, 31 Jan 2024 07:44:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=wNgt8oOLwbOsvwAejjYBF9U9tbvoG2aI1hlHUgcAVuk=;
 b=fR5ffCNRFESYngCOkVIpHl81z9TU4TmipIiG7wDM9Cwz9Ggl6ETWpo7st5rMvtDOdprL
 3i4C4hamRGGwKLBx+WPyIPK6GWlMOpoN53UcwrR6aURaFmOw0+EV+u909cNwx55ei29z
 89YI6ZgNTZrSRQx/NagTJt/VFO4aQz1+kRzfqOxOZ0Tw4At/iviLDc+Hb64z0uvNzJRH
 pvVnYhXVOveoRh874uPAd2WAe01prge6rD2PSpWL+WkqSN/z2XedIFtNN0JzW5Dicp3h
 Wkzl7LyzpATv0xMDXcC+YxI5Nr4P5lpu9xzM3/3RzTIv6u4NCeyWrM1PjciCZtTqXDwz PQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vyhhtgxbs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 31 Jan 2024 07:44:57 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40V7A3uo001686;
	Wed, 31 Jan 2024 07:44:56 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vyhhtgxbk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 31 Jan 2024 07:44:56 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40V4AUvd002319;
	Wed, 31 Jan 2024 07:44:56 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vwc5tca4r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 31 Jan 2024 07:44:55 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40V7irbW47579610
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 07:44:53 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1620920040;
	Wed, 31 Jan 2024 07:44:53 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D0AF220043;
	Wed, 31 Jan 2024 07:44:52 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 31 Jan 2024 07:44:52 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 2/5] lib: s390x: uv: Dirty CC before uvc execution
Date: Wed, 31 Jan 2024 07:44:24 +0000
Message-Id: <20240131074427.70871-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240131074427.70871-1-frankja@linux.ibm.com>
References: <20240131074427.70871-1-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: JxpusPsdhU6ZmahRDjJHCJ5o8gItCrW5
X-Proofpoint-ORIG-GUID: Ad7dg_pgkrkFqh1HbeGhE22ODpHSEcZr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-31_02,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 mlxlogscore=659
 priorityscore=1501 clxscore=1015 adultscore=0 bulkscore=0 phishscore=0
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401310057

Dirtying the CC allows us to find missing CC changes.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/uv.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
index e9fb19af..611dcd3f 100644
--- a/lib/s390x/asm/uv.h
+++ b/lib/s390x/asm/uv.h
@@ -216,14 +216,16 @@ struct uv_cb_ssc {
 
 static inline int uv_call_once(unsigned long r1, unsigned long r2)
 {
+	uint64_t bogus_cc = 1;
 	int cc;
 
 	asm volatile(
+		"	tmll    %[bogus_cc],3\n"
 		"0:	.insn rrf,0xB9A40000,%[r1],%[r2],0,0\n"
 		"		ipm	%[cc]\n"
 		"		srl	%[cc],28\n"
 		: [cc] "=d" (cc)
-		: [r1] "a" (r1), [r2] "a" (r2)
+		: [r1] "a" (r1), [r2] "a" (r2), [bogus_cc] "d" (bogus_cc)
 		: "memory", "cc");
 
 	if (UVC_ERR_DEBUG && cc == 1)
-- 
2.40.1


