Return-Path: <kvm+bounces-15790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B0698B07E4
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 13:00:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D6E67B22AB8
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 11:00:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95CB515B0E2;
	Wed, 24 Apr 2024 10:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gyN1Exme"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CA515991D
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 10:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713956395; cv=none; b=YPwPRfDE/mwWK45wAPP4Ru2AsBnKK5I51O6X0HKNB0KydX4RQYWfqwMAoXDavnx8zLjqj5sGxN6Jb6mtcWEqqtwUyiWrskH6x4r3T9SrT7HHogwouMd69hfwCvNQod/nAPaaFRybyayzpLBNeyukEaptq+9apT2rd+szuprkezY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713956395; c=relaxed/simple;
	bh=5GHvud91R/+TjKIusLZjhPUqwypwgKyHwSu2oVq6++k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nViGVB4JfzQdgL002q1QNlAR3f5C5GLqMTGFi0XEOk9kOdba7PhfyZOAsWnwPT+nl1IgtvrbM0z/XuOBt1VVR/R0yk3jfHcpfd7Pu1S3EhXdXxvJngIITkffPZ1wxs1KarFqbyo/vTMspZa7PUtnUFZak7kkBNSv9MvGNkL7jHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gyN1Exme; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43OAgeFX004720;
	Wed, 24 Apr 2024 10:59:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=KUjVCGSp62aDhBYcY85JeQPvSrcqCTce9mepdvBb1SY=;
 b=gyN1Exmea7nYKK8SQ4yOvgV8Xh+8Jn/T0gjb0/qGTwOoxGOpKsC079B9YL2T9bkhtg0z
 mzYYpdYE90fn5IKUaK2v1Keg9e4qcacTxn2trRl7KylGUd1gPUrO2+SxLFmvs8dmG5ab
 S9Y+tu1gKaIDyIExQXlGE2HjJ7U9CvrBScAXF707NpuVwb6iiqQxZgFbHvMdiP+sw6jW
 lq/av4TcS6GhwKXOnYLDWj0g+6TRqVfwnO2ZrY/HnVs8Nxv2p18Iq6YNn6ImgF7ZjbaT
 CT1r/3A25FYozOtyTomFa6hHFksiYWQMV38wVvYL7PpYabicZe6WTKVK0cLNHbltPO9G ag== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xq0jh813e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:46 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43OAxkpw030228;
	Wed, 24 Apr 2024 10:59:46 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xq0jh813c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:46 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43O8P6Z8023068;
	Wed, 24 Apr 2024 10:59:45 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xms1p36vh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:45 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43OAxdht25035398
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Apr 2024 10:59:41 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 876642005A;
	Wed, 24 Apr 2024 10:59:39 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5996720063;
	Wed, 24 Apr 2024 10:59:39 +0000 (GMT)
Received: from t14-nrb.boeblingen.de.ibm.com (unknown [9.152.224.21])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 24 Apr 2024 10:59:39 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 05/13] s390x: mvpg: Dirty CC before mvpg execution
Date: Wed, 24 Apr 2024 12:59:24 +0200
Message-ID: <20240424105935.184138-6-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240424105935.184138-1-nrb@linux.ibm.com>
References: <20240424105935.184138-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mCjgdPYvV9cXbbbnBt9Fe2dput-jbBgK
X-Proofpoint-ORIG-GUID: pij443DTl6Ee2qlNVfu1eKHLZ5TkNGPb
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-24_08,2024-04-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 mlxscore=0
 impostorscore=0 phishscore=0 bulkscore=0 priorityscore=1501 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404240045

From: Janosch Frank <frankja@linux.ibm.com>

Dirtying the CC allows us to find missing CC changes when mvpg is
emulated.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20240131074427.70871-5-frankja@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
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
2.44.0


