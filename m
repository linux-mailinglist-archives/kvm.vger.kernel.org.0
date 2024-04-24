Return-Path: <kvm+bounces-15789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 081B58B07E3
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 13:00:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6911DB229AE
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 11:00:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89CBA15B0E1;
	Wed, 24 Apr 2024 10:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eIUmk+Yi"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12D0315A480
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 10:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713956395; cv=none; b=FLbV65bIcsis+v8CvI3zbR8ekxBZe2wgoBj8sHqs0VyDbuGUKbqS9G2a2KdIaZiBhXW6C/8g3PpeD9hcZa8L53W0EU+Ts0MQ9aTI0AlfeHvi8li6La4ExzxBmAWcveEEYO92119OE5X4kcoXUCfixBHQA++dTb+lYp1xZy/oV0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713956395; c=relaxed/simple;
	bh=Pocx0Ac2KFd123ZtHKXIIHFrLAEo3kRCBrnyBlErJsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYZ3gwiDOqk2BGgtaJ3UjQDJDNI7HyDd+b129UWmAXOpYB0UYJjoMSmqrlyl213D7DR2HCDrEdIOBkeGYu/gT75IMED89avAU9S9kVRFv8tH4+tSu4FwWWj8SQfRHvNz4fxPG5LIghcXNn9WdTzLYFpmaON1IgdRky7sOSzY5nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eIUmk+Yi; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43O9oF7q027920;
	Wed, 24 Apr 2024 10:59:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Rh5dRRJbz3JIe63PAb5Dn6xc7dI/Yc3pMP4QPoDh3xo=;
 b=eIUmk+Yi1JX3hvnnvSUEqoYYqK3onXPDebkx9KhabqJAU1sxzUL+F/f9zozPRmu2kf/0
 IMGL9h//aKa6GcCOub9bGJVp8vf/gYiDRFV12qjgJbhwO9KVzHfcI7+xk+UwQyvuPmXb
 7u7FZk6iU9omW34Hj9mq45A6CubNcZ0dST+mGgbQ+8qqiwVoS2sdY/tvFO+ijZe0HD7g
 3QBnbCgYKoB6U5L9eB88xdhy6Fp2vBOZ34HGv/H/Z+rp9XUIKPupXCbd6+xaCmEll+sE
 KvEiCmrWTEnApYMLNEf0/QOsFauX/U0QBtUxjrOAiMmL5pGQjwB014rUYBBXFlvj2pDl XA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xpyry842x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:46 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43OAxkjv031252;
	Wed, 24 Apr 2024 10:59:46 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xpyry842t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:46 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43O7cCYZ023012;
	Wed, 24 Apr 2024 10:59:45 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xms1p36vj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Apr 2024 10:59:45 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43OAxeZX47776110
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Apr 2024 10:59:42 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 011F020065;
	Wed, 24 Apr 2024 10:59:40 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C7C0720067;
	Wed, 24 Apr 2024 10:59:39 +0000 (GMT)
Received: from t14-nrb.boeblingen.de.ibm.com (unknown [9.152.224.21])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 24 Apr 2024 10:59:39 +0000 (GMT)
From: Nico Boehr <nrb@linux.ibm.com>
To: thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests GIT PULL 07/13] lib: s390x: sigp: Name inline assembly arguments
Date: Wed, 24 Apr 2024 12:59:26 +0200
Message-ID: <20240424105935.184138-8-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240424105935.184138-1-nrb@linux.ibm.com>
References: <20240424105935.184138-1-nrb@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 75eVUYnmzNudqhGr1ewzC7CvD4DK1bBy
X-Proofpoint-ORIG-GUID: bArCH_7UJ_JZ3l5yNE-McC6aW5POjDCO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-24_08,2024-04-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0 phishscore=0
 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404240045

From: Janosch Frank <frankja@linux.ibm.com>

Less need to count the operands makes the code easier to read.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/asm/sigp.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/lib/s390x/asm/sigp.h b/lib/s390x/asm/sigp.h
index 4eae95d0..c9af2c49 100644
--- a/lib/s390x/asm/sigp.h
+++ b/lib/s390x/asm/sigp.h
@@ -54,11 +54,11 @@ static inline int sigp(uint16_t addr, uint8_t order, unsigned long parm,
 
 	asm volatile(
 		"	tmll	%[bogus_cc],3\n"
-		"	sigp	%1,%2,0(%3)\n"
-		"	ipm	%0\n"
-		"	srl	%0,28\n"
-		: "=d" (cc), "+d" (reg1)
-		: "d" (addr), "a" (order), [bogus_cc] "d" (bogus_cc)
+		"	sigp	%[reg1],%[addr],0(%[order])\n"
+		"	ipm	%[cc]\n"
+		"	srl	%[cc],28\n"
+		: [cc] "=d" (cc), [reg1] "+d" (reg1)
+		: [addr] "d" (addr), [order] "a" (order), [bogus_cc] "d" (bogus_cc)
 		: "cc");
 	if (status)
 		*status = reg1;
-- 
2.44.0


