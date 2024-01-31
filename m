Return-Path: <kvm+bounces-7537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E19B084382E
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 08:45:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D1E628804D
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 07:45:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E186F58203;
	Wed, 31 Jan 2024 07:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GlPyjkb8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BDC5FDA2;
	Wed, 31 Jan 2024 07:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706687101; cv=none; b=ksj0nJaFXZCv0thSjcmoaWr78WVidai1qqxMo+GtZWRkHphhmEwSSdpMA9y8ukxzRg4f+FsbeYRcbL360LlreGkRILKwFS8D8tu6AzDxGuxg7JyIeVxXoH/7UfpDV8IVSJOnhtykzwqq++PYaBlEFxETMWlSYNZm/FR2eKjLzeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706687101; c=relaxed/simple;
	bh=KxZHE8JQMdtEjdS1jmTqZCnQpnK+EykLHvfW8W9b15w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mopCgspdMLZ/XLYce0XulQdWwAt2X2rgtdYKx+Nkj/ISm8VDuw7z60ARvq0x/rAmnMDpf9AFA1XbTgDrCXjDqIL2NK/8JtkYcgimY2aR5811HJ8zJ/ZDWMRVW6UT40/hTXGpmB5+6RE6lTHOjwyDiM/6hrU7CtTpymzYwG0Dx5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GlPyjkb8; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40V6GJZC032373;
	Wed, 31 Jan 2024 07:44:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=DF+g4WTBFPl5e0hJ0I2XP/6XwCufH3kwP5948awlN1k=;
 b=GlPyjkb8AsA8pU22AdSQmmO4YClCw89GPgVDDxgnqHgoKAE/uxmObxc4hNj9KVApdX+q
 ALdEm9UbsEkLU9nFokB24c3DSo48Etqks4X4QOgK6hk6kVZ6MZY/fsOxrMGjV0Y7u+fc
 2sVFu2UE9dVaFpJsU7bCnt1BeOvjXJqVJE8Wqq90vvRkR8BUDprDYN61i7choUS99+xE
 j5lnjR2Nwguz3NhNWgakUr9khQtgEAQjYPgvrFYwKV1j9DHZOcntcc8Okfds2LOUtq/g
 KgDAaPRG3BJbyEaVuRHL9GpF81cNUphItsPq6TaXC3vdilBSp2p+v33/rKCxwrqTeRNl 0A== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vyac9a3e1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 31 Jan 2024 07:44:57 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40V7B7Ha011641;
	Wed, 31 Jan 2024 07:44:57 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vyac9a3du-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 31 Jan 2024 07:44:57 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40V4AUve002319;
	Wed, 31 Jan 2024 07:44:56 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vwc5tca4s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 31 Jan 2024 07:44:56 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40V7irHZ47579612
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 07:44:53 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8F2FB20040;
	Wed, 31 Jan 2024 07:44:53 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5626820043;
	Wed, 31 Jan 2024 07:44:53 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 31 Jan 2024 07:44:53 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 4/5] s390x: mvpg: Dirty CC before mvpg execution
Date: Wed, 31 Jan 2024 07:44:26 +0000
Message-Id: <20240131074427.70871-5-frankja@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: 8BleQ0_4E0e7SoR75m1eWpJ0cOtbLZZ7
X-Proofpoint-GUID: jEj8MI9trhCk9zWhEd1xct51rg57cyYK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-31_02,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=705 bulkscore=0
 phishscore=0 lowpriorityscore=0 clxscore=1011 adultscore=0 spamscore=0
 impostorscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401310057

Dirtying the CC allows us to find missing CC changes when mvpg is
emulated.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/mvpg.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/s390x/mvpg.c b/s390x/mvpg.c
index 296338d4..62d42e36 100644
--- a/s390x/mvpg.c
+++ b/s390x/mvpg.c
@@ -40,12 +40,14 @@ static uint8_t *fresh;
 static inline int mvpg(unsigned long r0, void *dest, void *src)
 {
 	register unsigned long reg0 asm ("0") = r0;
+	uint64_t bogus_cc = 3;
 	int cc;
 
-	asm volatile("	mvpg    %1,%2\n"
+	asm volatile("	tmll	%[bogus_cc],3\n"
+		     "	mvpg    %1,%2\n"
 		     "	ipm     %0\n"
 		     "	srl     %0,28"
-		: "=&d" (cc) : "a" (dest), "a" (src), "d" (reg0)
+		: "=&d" (cc) : "a" (dest), "a" (src), "d" (reg0), [bogus_cc] "d" (bogus_cc)
 		: "memory", "cc");
 	return cc;
 }
-- 
2.40.1


