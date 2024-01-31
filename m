Return-Path: <kvm+bounces-7533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 082CE843826
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 08:45:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A60821F275F2
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 07:45:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C11855578D;
	Wed, 31 Jan 2024 07:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rH5tgl4P"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5341D5FB85;
	Wed, 31 Jan 2024 07:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706687100; cv=none; b=XzDr71nA1cDX6tlBKbRMyFRyHFu44jsxGLtpDO3151w8Dis1WDn/MwDwWjjWkz5JBTPJ31JTQbmQWj207ffd3Em+UlxSMEkJRLwx2idceUkbH3HnEeWglEuzo27yHnTTrR3C1E/f/VgYe81Q8VIo+cJiC/g6kCJ8idMQN0m/lp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706687100; c=relaxed/simple;
	bh=L+9d30nHy2TZMkQ8mSe7qCN8wQqKWmKdvapndrxf/ow=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tKOfRe68q1w/xwU9BCV+UsCuMWpkXR+iyanvo1/8g3+n6ybWfcVMorsThnvGc9Ks2fuV3UCDQc8wyTXYXBx3ku/4bzzd+Go8a+GJiqQYZPVzi1Oyo16pHO4Icsnvk1Y0Mxfhg92POGNgK5nUUpoXPUmKyLfeFBO5yHorafGYY0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rH5tgl4P; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40V5DQpt005925;
	Wed, 31 Jan 2024 07:44:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=cgRO2RGEhwuQkoULIwi6qGNOmSSDYQs0T1frUt6AcAU=;
 b=rH5tgl4PE9Yju27KRhkccS1cKu47Ob0kEIPGE7yBKpxN8X5dLbW5yum9YXxvIQRxz8fj
 QJvrinWmwRYY8+dfYPMBTVNXC9F9zYKSqNV8nEGmAWI9db4ppxIYEBCt+YGOF0DJMOCg
 WDORObRg7IiUh1Yt7nm+vPXxCS4eWyS2ZbKeNLCk4hAZtxKEgFTmNCfKd17UpX2OZ4Qk
 Fxkft27VZbScAOHsSB2U+hUS01tUhvHNcp90XbGVF/NCbeDn50AfctPKrFNrxcxMzW8Y
 e992wTws4mI9fmoONWEU7MaWSrzNY9T6KP5P8d3eW9ijVX+v/BtkZoVBnF2eo6+ySND2 kg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vyfuyu2fr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 31 Jan 2024 07:44:56 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40V7TmQP018774;
	Wed, 31 Jan 2024 07:44:56 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vyfuyu2fk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 31 Jan 2024 07:44:56 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40V74YKG007189;
	Wed, 31 Jan 2024 07:44:55 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vwev2bkjm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 31 Jan 2024 07:44:55 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40V7iqwx51839260
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 07:44:53 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C858920040;
	Wed, 31 Jan 2024 07:44:52 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8E51D2004E;
	Wed, 31 Jan 2024 07:44:52 +0000 (GMT)
Received: from a46lp67.lnxne.boe (unknown [9.152.108.100])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 31 Jan 2024 07:44:52 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 1/5] lib: s390x: sigp: Dirty CC before sigp execution
Date: Wed, 31 Jan 2024 07:44:23 +0000
Message-Id: <20240131074427.70871-2-frankja@linux.ibm.com>
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
X-Proofpoint-GUID: K6oios9Tp2ksvd1QzC7ikA-ByH2f0fE3
X-Proofpoint-ORIG-GUID: M6o6n_cQo4btqewsmxMiOIeKY8_QHeoS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-31_02,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 bulkscore=0 spamscore=0 malwarescore=0 suspectscore=0 mlxlogscore=627
 priorityscore=1501 lowpriorityscore=0 adultscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401310057

Dirtying the CC allows us to find missing CC changes when sigp is
emulated.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/sigp.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/lib/s390x/asm/sigp.h b/lib/s390x/asm/sigp.h
index 61d2c625..4eae95d0 100644
--- a/lib/s390x/asm/sigp.h
+++ b/lib/s390x/asm/sigp.h
@@ -49,13 +49,17 @@ static inline int sigp(uint16_t addr, uint8_t order, unsigned long parm,
 		       uint32_t *status)
 {
 	register unsigned long reg1 asm ("1") = parm;
+	uint64_t bogus_cc = SIGP_CC_NOT_OPERATIONAL;
 	int cc;
 
 	asm volatile(
+		"	tmll	%[bogus_cc],3\n"
 		"	sigp	%1,%2,0(%3)\n"
 		"	ipm	%0\n"
 		"	srl	%0,28\n"
-		: "=d" (cc), "+d" (reg1) : "d" (addr), "a" (order) : "cc");
+		: "=d" (cc), "+d" (reg1)
+		: "d" (addr), "a" (order), [bogus_cc] "d" (bogus_cc)
+		: "cc");
 	if (status)
 		*status = reg1;
 	return cc;
-- 
2.40.1


