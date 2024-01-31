Return-Path: <kvm+bounces-7538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C4BF84382F
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 08:45:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2B2FFB21E18
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 07:45:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4022E59B59;
	Wed, 31 Jan 2024 07:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="a0ArF06s"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98165FDBF;
	Wed, 31 Jan 2024 07:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706687101; cv=none; b=t4cSjC1zVvosixBbwkdjPSmXww9QO/oCfFGiZtKet9OD7C+DaPaDFdENRw9tACEKR77J3u+SUcBA2nOHmis81ypbNY7toJWyPAcfFaT9kSI1FQkvkjxOrA06M8KjPg7lFLj5hqzomkOqEWGANVLJSjEbn3p54c5I/oJVqBLMN5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706687101; c=relaxed/simple;
	bh=1aBSPP/3Q+n5qbkwJw1TY9bVFkDWlDGpqBNtofNtLnI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rAy9Fotg6k4Vka8OnlP7hrd8weeGVrfiJ4/kOzUyR8LORiVcZpCJ/dD0rJQbHwEvDxrgVWjOsBIDISbqSUPFTmwKiZDn4S/DSs30rMZb4TQO43Ir3jXQfFXOl1vNhCGEYt91FPdASSHRvjNMt6JzuGIlZqxfTXMyFnTgjvWOb/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=a0ArF06s; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40V60sa8015562;
	Wed, 31 Jan 2024 07:44:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+1ozq2vAdYG8ryAbcNI/2nlg99jD6BU2flhMq1vnBTc=;
 b=a0ArF06sETBloqPZ+KZmd2URJDhEzllV6uatO5dI4+ZH0qBv7Hl4YW6OHEmZrj7u9pU3
 YOsryVhU5y6dHGxJzWyRgC8ponxCF6GynIvnwEhYk0grBXhD3pkPZSqa0LyldRtnCyd9
 z/sQ5XURFbojABlW0rsaz/fwEEnwb/pRHK8fb3ejDn+1NxUIP0Ri6gq5vQNTE2y47p6R
 XnWv88TLEHKnZS9qJHt/vU01WYXGBfJQVKS6TubEQBjssBeyvph/DX+seIVQsSCDZl6n
 WpfMub19U0gSbozOG4VpkWCdoXPH+yA4LlUNqt0g2layoK+FugvoVZMNvA1v5FheBFJU hQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vyfx436ea-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 31 Jan 2024 07:44:58 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40V703Pf031043;
	Wed, 31 Jan 2024 07:44:58 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vyfx436dw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 31 Jan 2024 07:44:58 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40V5Odgd010569;
	Wed, 31 Jan 2024 07:44:57 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vwd5nv0es-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 31 Jan 2024 07:44:56 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40V7irnn45023810
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 07:44:54 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D09FF20040;
	Wed, 31 Jan 2024 07:44:53 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 979452004B;
	Wed, 31 Jan 2024 07:44:53 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 31 Jan 2024 07:44:53 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 5/5] s390x: sclp: Dirty CC before sclp execution
Date: Wed, 31 Jan 2024 07:44:27 +0000
Message-Id: <20240131074427.70871-6-frankja@linux.ibm.com>
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
X-Proofpoint-GUID: oi7II8zStO00HOQQQHZL76YeZoQ2DJXk
X-Proofpoint-ORIG-GUID: b8XdkYgdBjKqjpEiSjSDcCyq18287qMd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-31_03,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 malwarescore=0 mlxscore=0
 mlxlogscore=695 impostorscore=0 priorityscore=1501 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401310058

Dirtying the CC allows us to find missing CC changes when sclp is
emulated.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/sclp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/s390x/sclp.c b/s390x/sclp.c
index ccbaa913..53fce0cf 100644
--- a/s390x/sclp.c
+++ b/s390x/sclp.c
@@ -399,6 +399,7 @@ out:
 static void test_instbits(void)
 {
 	SCCBHeader *h = (SCCBHeader *)pagebuf;
+	uint64_t bogus_cc = 1;
 	int cc;
 
 	sclp_mark_busy();
@@ -406,10 +407,12 @@ static void test_instbits(void)
 	sclp_setup_int();
 
 	asm volatile(
+		"	tmll	%[bogus_cc],3\n"
 		"       .insn   rre,0xb2204200,%1,%2\n"  /* servc %1,%2 */
 		"       ipm     %0\n"
 		"       srl     %0,28"
-		: "=&d" (cc) : "d" (valid_code), "a" (__pa(pagebuf))
+		: "=&d" (cc)
+		: "d" (valid_code), "a" (__pa(pagebuf)), [bogus_cc] "d" (bogus_cc)
 		: "cc", "memory");
 	/* No exception, but also no command accepted, so no interrupt is
 	 * expected. We need to clear the flag manually otherwise we will
-- 
2.40.1


